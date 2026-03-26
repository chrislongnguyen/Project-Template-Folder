#!/usr/bin/env python3
"""
Stage 6 Eval Runner — runs deterministic AC evaluations.

Reads .exec/ task files and VANA-SPEC AC-TEST-MAP (§7).
Finds all tasks with status "done", extracts AC IDs from each task's
VANA Traceability table, looks up eval specs in the spec's AC-TEST-MAP,
runs deterministic graders, and writes results to status.json.

Exit codes:
  0 — all done tasks evaluated; some may have failed (check status.json)
  1 — script error (invalid arguments, missing files, unreadable JSON)

Usage:
  python3 run-deterministic-evals.py /path/to/.exec/ /path/to/spec.md
  python3 run-deterministic-evals.py /path/to/.exec/ /path/to/spec.md --dry-run
  python3 run-deterministic-evals.py --help
"""

import argparse
import json
import os
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


# ---------------------------------------------------------------------------
# AC-TEST-MAP parsing
# ---------------------------------------------------------------------------

def parse_ac_test_map(spec_path: Path) -> dict[str, dict]:
    """
    Parse §7 AC-TEST-MAP from the VANA-SPEC markdown file.

    Returns a dict keyed by AC ID:
        {
            "Verb-AC1": {
                "vana_word": "...",
                "vana_source": "§2",
                "eval_type": "Deterministic",
                "dataset": "...",
                "grader": "pytest tests/test_x.py",
                "threshold": "exit 0",
            },
            ...
        }

    The parser looks for a markdown table header containing "A.C. ID" and
    "Eval Type" and "Grader" — tolerating minor column-order variation.
    It reads until the next level-2 heading (##) or end of file.
    """
    if not spec_path.is_file():
        raise FileNotFoundError(f"Spec not found: {spec_path}")

    text = spec_path.read_text(encoding="utf-8")

    # Find the §7 AC-TEST-MAP section (may be named §6 in older specs too)
    section_pattern = re.compile(
        r"^#{1,3}\s+§[67]\s+AC-TEST-MAP.*$", re.MULTILINE | re.IGNORECASE
    )
    section_match = section_pattern.search(text)
    if not section_match:
        return {}  # No AC-TEST-MAP section found — not an error, just empty

    section_text = text[section_match.start():]

    # Find the markdown table in this section (stop at next ## heading).
    # Skip past the section's own heading line before searching for the next one.
    section_heading_end = section_text.index("\n") + 1
    rest_of_section = section_text[section_heading_end:]
    next_heading = re.search(r"^#{1,2}\s+", rest_of_section, re.MULTILINE)
    if next_heading:
        section_text = section_text[: section_heading_end + next_heading.start()]

    # Identify table lines (start and end with |)
    table_lines = [
        line.strip()
        for line in section_text.splitlines()
        if line.strip().startswith("|") and line.strip().endswith("|")
    ]

    if len(table_lines) < 2:
        return {}

    # Parse header row to locate column indices
    header_cells = [c.strip() for c in table_lines[0].split("|") if c.strip()]
    col_map: dict[str, int] = {}
    for i, cell in enumerate(header_cells):
        key = cell.lower()
        if "a.c. id" in key or "ac id" in key:
            col_map["ac_id"] = i
        elif "vana word" in key:
            col_map["vana_word"] = i
        elif "vana source" in key or "source" in key:
            col_map["vana_source"] = i
        elif "eval type" in key:
            col_map["eval_type"] = i
        elif "dataset" in key:
            col_map["dataset"] = i
        elif "grader" in key:
            col_map["grader"] = i
        elif "threshold" in key:
            col_map["threshold"] = i

    if "ac_id" not in col_map or "eval_type" not in col_map:
        return {}

    ac_map: dict[str, dict] = {}
    # Skip header row [0] and separator row [1]
    for line in table_lines[2:]:
        if line.startswith("|---") or line.startswith("| ---"):
            continue  # extra separator lines
        cells = [c.strip() for c in line.split("|") if True]
        # split("|") on "|A|B|C|" gives ['', 'A', 'B', 'C', '']
        # strip empties from head/tail
        cells = [c.strip() for c in line.split("|")]
        cells = cells[1:-1]  # drop leading and trailing empty strings

        def get(key: str) -> str:
            idx = col_map.get(key)
            if idx is None or idx >= len(cells):
                return ""
            return cells[idx].strip()

        ac_id = get("ac_id")
        if not ac_id or ac_id.startswith("{") or ac_id == "A.C. ID":
            continue  # skip placeholders and repeated headers

        ac_map[ac_id] = {
            "vana_word": get("vana_word"),
            "vana_source": get("vana_source"),
            "eval_type": get("eval_type"),
            "dataset": get("dataset"),
            "grader": get("grader"),
            "threshold": get("threshold"),
        }

    return ac_map


# ---------------------------------------------------------------------------
# Task file AC-ID extraction
# ---------------------------------------------------------------------------

def extract_ac_ids_from_task(task_path: Path) -> list[str]:
    """
    Parse the VANA Traceability table in a task .md file.

    Looks for a table under "## VANA Traceability" with an "A.C. ID" column
    and returns all non-placeholder AC IDs found.
    """
    if not task_path.is_file():
        return []

    text = task_path.read_text(encoding="utf-8")

    section_match = re.search(
        r"^#{1,3}\s+VANA Traceability.*$", text, re.MULTILINE | re.IGNORECASE
    )
    if not section_match:
        return []

    section_text = text[section_match.start():]
    # Skip past the section's own heading line before searching for the next one.
    section_heading_end = section_text.index("\n") + 1
    rest_of_section = section_text[section_heading_end:]
    next_heading = re.search(r"^#{1,3}\s+", rest_of_section, re.MULTILINE)
    if next_heading:
        section_text = section_text[: section_heading_end + next_heading.start()]

    table_lines = [
        line.strip()
        for line in section_text.splitlines()
        if line.strip().startswith("|") and line.strip().endswith("|")
    ]

    if len(table_lines) < 2:
        return []

    header_cells = [c.strip() for c in table_lines[0].split("|") if c.strip()]
    ac_col = None
    for i, cell in enumerate(header_cells):
        if "a.c. id" in cell.lower() or "ac id" in cell.lower():
            ac_col = i
            break

    if ac_col is None:
        return []

    ac_ids = []
    for line in table_lines[2:]:
        cells = [c.strip() for c in line.split("|")]
        cells = cells[1:-1]
        if ac_col >= len(cells):
            continue
        ac_id = cells[ac_col].strip()
        if ac_id and not ac_id.startswith("{") and ac_id != "A.C. ID":
            ac_ids.append(ac_id)

    return ac_ids


# ---------------------------------------------------------------------------
# Grader execution
# ---------------------------------------------------------------------------

def run_grader(grader_cmd: str, dry_run: bool) -> tuple[str, str]:
    """
    Execute a grader command string.

    Returns (result, evidence) where result is one of:
        "pass"         — grader exited 0
        "fail"         — grader exited non-zero
        "[EVAL_FAILED]" — grader could not be launched or timed out
        "[DRY_RUN]"    — dry-run mode, not executed
    """
    if dry_run:
        return "[DRY_RUN]", f"Would run: {grader_cmd}"

    try:
        proc = subprocess.run(
            grader_cmd,
            shell=True,
            capture_output=True,
            text=True,
            timeout=120,
        )
        if proc.returncode == 0:
            evidence = (proc.stdout.strip() or proc.stderr.strip() or "exit 0")[:200]
            return "pass", evidence
        else:
            evidence = (proc.stderr.strip() or proc.stdout.strip() or f"exit {proc.returncode}")[:200]
            return "fail", evidence
    except subprocess.TimeoutExpired:
        return "[EVAL_FAILED]", "Grader timed out after 120 seconds"
    except Exception as exc:
        return "[EVAL_FAILED]", f"Grader launch error: {exc}"


# ---------------------------------------------------------------------------
# status.json helpers (atomic write)
# ---------------------------------------------------------------------------

def load_status(exec_dir: Path) -> dict:
    status_path = exec_dir / "status.json"
    if not status_path.is_file():
        raise FileNotFoundError(f"status.json not found: {status_path}")
    with status_path.open(encoding="utf-8") as f:
        return json.load(f)


def save_status(exec_dir: Path, data: dict) -> None:
    """Atomic write: write to .tmp then rename."""
    status_path = exec_dir / "status.json"
    tmp_path = exec_dir / "status.json.tmp"
    data["updated_at"] = datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")
    with tmp_path.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2)
        f.write("\n")
    tmp_path.replace(status_path)


# ---------------------------------------------------------------------------
# Task .md file discovery
# ---------------------------------------------------------------------------

def find_task_md(exec_dir: Path, deliverable_id: str, task_id: str) -> Path | None:
    """
    Locate a task .md file inside .exec/.

    Convention: .exec/<DeliverableName>/<TaskFile>.md where the task file
    contains its task ID in the Identity table.  We search for any .md file
    (excluding deliverable.md, project.md) whose first heading or Identity
    table matches the task_id.
    """
    for md_file in sorted(exec_dir.rglob("*.md")):
        name = md_file.name.lower()
        if name in ("project.md", "deliverable.md"):
            continue
        text = md_file.read_text(encoding="utf-8")
        # Quick check: does the file reference this task ID?
        if task_id in text:
            # Verify via Identity table
            id_match = re.search(
                r"\|\s*Task ID\s*\|\s*(" + re.escape(task_id) + r")\s*\|",
                text,
            )
            if id_match:
                return md_file
    return None


# ---------------------------------------------------------------------------
# Main evaluation logic
# ---------------------------------------------------------------------------

def evaluate_exec_dir(
    exec_dir: Path,
    spec_path: Path,
    dry_run: bool,
    verbose: bool,
) -> int:
    """
    Run Stage 6 deterministic evals for all "done" tasks in exec_dir.

    Returns 0 on success (even if some ACs fail — those are recorded in
    status.json).  Returns 1 on infrastructure error.
    """
    # Load status.json
    try:
        status = load_status(exec_dir)
    except (FileNotFoundError, json.JSONDecodeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    # Parse AC-TEST-MAP from spec
    try:
        ac_test_map = parse_ac_test_map(spec_path)
    except FileNotFoundError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    if verbose:
        print(f"Loaded {len(ac_test_map)} AC entries from AC-TEST-MAP in {spec_path.name}")

    any_ac_evaluated = False
    status_dirty = False

    for d_id, deliverable in status.get("deliverables", {}).items():
        for t_id, task in deliverable.get("tasks", {}).items():
            if task.get("status") != "done":
                continue

            # Find task .md file
            task_md = find_task_md(exec_dir, d_id, t_id)
            if task_md is None:
                if verbose:
                    print(f"  WARN: No task .md file found for {t_id} — skipping")
                continue

            ac_ids = extract_ac_ids_from_task(task_md)
            if not ac_ids:
                if verbose:
                    print(f"  WARN: No AC IDs found in VANA Traceability table for {t_id}")
                continue

            if verbose:
                print(f"\nEvaluating {t_id} ({len(ac_ids)} ACs): {', '.join(ac_ids)}")

            task_failed = False
            ac_results = task.setdefault("ac_results", {})

            for ac_id in ac_ids:
                spec = ac_test_map.get(ac_id)
                if spec is None:
                    # AC referenced in task but not in AC-TEST-MAP
                    if verbose:
                        print(f"    {ac_id}: WARN — not found in AC-TEST-MAP, skipping")
                    ac_results[ac_id] = {
                        "eval_type": "Unknown",
                        "result": "[NOT_IN_MAP]",
                        "evidence": "AC ID not found in spec §7 AC-TEST-MAP",
                    }
                    continue

                eval_type = spec.get("eval_type", "").strip()
                grader = spec.get("grader", "").strip()

                if eval_type.lower() == "manual":
                    result, evidence = "[MANUAL]", "Queued for Human Director review"
                elif eval_type.lower() in ("ai-graded", "ai_graded", "ai graded"):
                    result, evidence = "[DEFERRED_ITER2]", "AI-graded evals deferred to iteration 2"
                elif eval_type.lower() == "deterministic":
                    if not grader or grader.startswith("{"):
                        result, evidence = "[EVAL_FAILED]", "No grader command specified in AC-TEST-MAP"
                    else:
                        result, evidence = run_grader(grader, dry_run)
                        any_ac_evaluated = True
                else:
                    result, evidence = "[EVAL_FAILED]", f"Unknown eval_type: {eval_type!r}"

                ac_results[ac_id] = {
                    "eval_type": eval_type,
                    "result": result,
                    "evidence": evidence,
                }

                status_indicator = "PASS" if result == "pass" else result
                if verbose:
                    print(f"    {ac_id} [{eval_type}]: {status_indicator}")
                    if result not in ("pass", "[MANUAL]", "[DEFERRED_ITER2]", "[DRY_RUN]"):
                        print(f"      Evidence: {evidence}")

                if result == "fail":
                    task_failed = True

            # If any AC failed, demote task to rework
            if task_failed and not dry_run:
                task["status"] = "rework"
                rework_entry = {
                    "task_id": t_id,
                    "from_status": "done",
                    "to_status": "rework",
                    "reason": "Stage 6 eval: one or more deterministic ACs failed",
                    "triggered_by": "run-deterministic-evals.py",
                    "timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
                }
                status.setdefault("rework_log", []).append(rework_entry)
                if verbose:
                    print(f"  => {t_id} status set to REWORK (AC failure)")
                status_dirty = True
            elif not dry_run:
                # ac_results were updated in-place; mark dirty
                status_dirty = True

    if status_dirty and not dry_run:
        save_status(exec_dir, status)
        print(f"status.json updated: {exec_dir / 'status.json'}")
    elif dry_run:
        print("[DRY-RUN] No changes written to status.json")

    if not any_ac_evaluated and not dry_run:
        print("INFO: No deterministic ACs evaluated (all done tasks have manual/ai/missing evals or no done tasks)")

    return 0


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main() -> int:
    parser = argparse.ArgumentParser(
        prog="run-deterministic-evals.py",
        description=(
            "Stage 6 Eval Runner: evaluates deterministic ACs for all 'done' tasks\n"
            "in an .exec/ directory using the VANA-SPEC's §7 AC-TEST-MAP.\n\n"
            "Eval types:\n"
            "  Deterministic — grader command executed; exit 0 = pass\n"
            "  Manual        — marked [MANUAL], queued for Human Director\n"
            "  AI-Graded     — marked [DEFERRED_ITER2], skipped in MVP\n\n"
            "On failure: task status set to 'rework', rework_log entry added.\n"
            "Results written atomically to status.json."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "exec_dir",
        nargs="?",
        help="Path to .exec/ directory containing status.json and task .md files",
    )
    parser.add_argument(
        "spec_path",
        nargs="?",
        help="Path to VANA-SPEC markdown file containing §7 AC-TEST-MAP",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would run without executing graders or modifying status.json",
    )
    parser.add_argument(
        "--verbose",
        "-v",
        action="store_true",
        help="Print per-AC result details",
    )

    args = parser.parse_args()

    if args.exec_dir is None or args.spec_path is None:
        parser.print_help()
        return 1

    exec_dir = Path(args.exec_dir).resolve()
    spec_path = Path(args.spec_path).resolve()

    if not exec_dir.is_dir():
        print(f"ERROR: exec_dir does not exist or is not a directory: {exec_dir}", file=sys.stderr)
        return 1

    if args.dry_run:
        print(f"[DRY-RUN] exec_dir={exec_dir}")
        print(f"[DRY-RUN] spec_path={spec_path}")

    return evaluate_exec_dir(exec_dir, spec_path, dry_run=args.dry_run, verbose=args.verbose)


if __name__ == "__main__":
    sys.exit(main())
