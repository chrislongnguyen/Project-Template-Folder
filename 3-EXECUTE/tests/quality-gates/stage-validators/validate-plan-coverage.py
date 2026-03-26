#!/usr/bin/env python3
"""
Stage 3→4 Validator: Plan AC coverage, task bidirectionality, structure quality.

Usage: python3 validate-plan-coverage.py /path/to/plan.md
       python3 validate-plan-coverage.py --help

Exit: 0 = all checks pass, 1 = any check fails

Checks (per spec §7.2):
  1. Every AC maps to ≥1 task (no uncovered ACs)
  2. Every task maps to ≥1 AC (no orphan tasks)
  3. Tasks per deliverable < 7
  4. HOW NOT sections present for every deliverable
  5. Agent architecture present for every deliverable
  6. Critical path duration < 8 hours (WARN if no estimates found)
  7. All referenced file paths are plausible (parent directories exist or are in the plan)
"""
import sys
import os
import re
from pathlib import Path


# ---------------------------------------------------------------------------
# Parsers
# ---------------------------------------------------------------------------

def read_plan(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def parse_deliverables(content: str) -> dict[str, dict]:
    """
    Parse plan into deliverable sections.
    Returns {deliverable_id: {heading, body, tasks, has_how_not, has_agent_arch}}
    Deliverable sections start with '## D{n}:' headings.
    """
    deliverable_re = re.compile(r"^## (D\d+[^:\n]*):?\s*(.*)$", re.MULTILINE)
    splits = deliverable_re.split(content)
    # splits = [pre, D1_id, D1_heading_rest, D1_body, D2_id, ...]

    deliverables: dict[str, dict] = {}
    for i in range(1, len(splits) - 2, 3):
        d_id_raw = splits[i].strip()
        d_id = re.match(r"D\d+", d_id_raw)
        if not d_id:
            continue
        d_key = d_id.group(0)
        body = splits[i + 2] if i + 2 < len(splits) else ""

        deliverables[d_key] = {
            "heading": d_id_raw,
            "body": body,
            "tasks": parse_tasks_in_deliverable(body, d_key),
            "has_how_not": bool(re.search(r"\*\*HOW NOT\*\*|HOW NOT:", body, re.IGNORECASE)),
            "has_agent_arch": bool(
                re.search(r"\*\*Agent Arch|\*\*Agent Architecture|Agent Architecture\*\*", body, re.IGNORECASE)
                or re.search(r"Single Agent|Sub-Agents|Agent Team", body, re.IGNORECASE)
            ),
        }

    return deliverables


def parse_tasks_in_deliverable(body: str, d_key: str) -> dict[str, dict]:
    """
    Parse task subsections within a deliverable body.
    Tasks start with '### Task {n}' or '### {D_key}-T{n}' headings.
    Returns {task_id: {heading, body, ac_ids}}
    """
    task_re = re.compile(
        rf"^### (?:Task (\d+)|{re.escape(d_key)}-T(\d+))[^\n]*$",
        re.MULTILINE,
    )
    splits = task_re.split(body)

    tasks: dict[str, dict] = {}
    for i in range(1, len(splits) - 1, 3):
        t_num = splits[i] or splits[i + 1]
        if not t_num:
            continue
        task_id = f"{d_key}-T{t_num.strip()}"
        t_body = splits[i + 2] if i + 2 < len(splits) else ""
        ac_ids = extract_ac_ids(t_body)
        tasks[task_id] = {"body": t_body, "ac_ids": ac_ids}

    return tasks


def extract_ac_ids(text: str) -> list[str]:
    """Extract AC IDs matching patterns like Verb-AC1, D1-AC-3, etc."""
    ac_pattern = re.compile(r"\b([\w]+-AC-?\d+)\b")
    stripped = re.sub(r"```.*?```", "", text, flags=re.DOTALL)
    return ac_pattern.findall(stripped)


def extract_all_spec_ac_ids(content: str) -> set[str]:
    """
    Extract all AC IDs mentioned in the plan's AC Coverage section or preamble.
    Falls back to collecting all AC IDs mentioned anywhere in the plan.
    """
    # Look for an explicit AC Coverage or Scope Check section listing ACs
    coverage_match = re.search(
        r"(?:AC Coverage|Scope Check|AC-TEST-MAP).*?(?=^## |\Z)",
        content,
        flags=re.DOTALL | re.MULTILINE,
    )
    if coverage_match:
        return set(extract_ac_ids(coverage_match.group(0)))

    # Fall back: all ACs in the plan
    return set(extract_ac_ids(content))


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

def check_every_ac_maps_to_task(
    deliverables: dict[str, dict], spec_ac_ids: set[str]
) -> tuple[bool, str]:
    """
    Check 1: Every AC (from spec or coverage table) maps to ≥1 task in the plan.
    """
    if not spec_ac_ids:
        return True, "[WARN] No spec AC IDs found to verify coverage against (skipped)"

    # Collect all AC IDs covered across all tasks
    covered: set[str] = set()
    for d_data in deliverables.values():
        for t_data in d_data["tasks"].values():
            covered.update(t_data["ac_ids"])

    uncovered = spec_ac_ids - covered
    if uncovered:
        return False, f"ACs with no task coverage: {sorted(uncovered)}"
    return True, f"All {len(spec_ac_ids)} ACs covered by ≥1 task"


def check_every_task_maps_to_ac(deliverables: dict[str, dict]) -> tuple[bool, str]:
    """
    Check 2: Every task maps to ≥1 AC (no orphan tasks without AC references).
    """
    orphans: list[str] = []
    for d_key, d_data in deliverables.items():
        for t_id, t_data in d_data["tasks"].items():
            if not t_data["ac_ids"]:
                orphans.append(t_id)

    if orphans:
        return False, f"Tasks with no AC mapping (orphans): {orphans}"

    total_tasks = sum(len(d["tasks"]) for d in deliverables.values())
    if total_tasks == 0:
        return True, "[WARN] No tasks found in plan (skipped)"
    return True, f"All {total_tasks} tasks have ≥1 AC mapping"


def check_tasks_per_deliverable(deliverables: dict[str, dict]) -> tuple[bool, str]:
    """
    Check 3: Tasks per deliverable < 7.
    """
    violations: list[str] = []
    for d_key, d_data in deliverables.items():
        count = len(d_data["tasks"])
        if count >= 7:
            violations.append(f"{d_key}: {count} tasks (limit is 6)")

    if violations:
        return False, "Deliverables exceeding task limit (< 7): " + ", ".join(violations)
    return True, "All deliverables have < 7 tasks"


def check_how_not_present(deliverables: dict[str, dict]) -> tuple[bool, str]:
    """
    Check 4: HOW NOT section present for every deliverable.
    """
    missing: list[str] = []
    for d_key, d_data in deliverables.items():
        if not d_data["has_how_not"]:
            missing.append(d_key)

    if missing:
        return False, f"Deliverables missing HOW NOT section: {missing}"
    if not deliverables:
        return True, "[WARN] No deliverables found in plan (skipped)"
    return True, f"HOW NOT section present in all {len(deliverables)} deliverables"


def check_agent_arch_present(deliverables: dict[str, dict]) -> tuple[bool, str]:
    """
    Check 5: Agent architecture decision present for every deliverable.
    """
    missing: list[str] = []
    for d_key, d_data in deliverables.items():
        if not d_data["has_agent_arch"]:
            missing.append(d_key)

    if missing:
        return False, f"Deliverables missing agent architecture: {missing}"
    if not deliverables:
        return True, "[WARN] No deliverables found in plan (skipped)"
    return True, f"Agent architecture present in all {len(deliverables)} deliverables"


def check_critical_path_duration(content: str) -> tuple[bool, str]:
    """
    Check 6: Critical path duration < 8 hours.
    Looks for time estimates in the plan (e.g., '~2h', '3 hours', 'estimated: 4h').
    Returns WARN (not FAIL) if no estimates are found.
    """
    time_pattern = re.compile(r"(\d+(?:\.\d+)?)\s*(?:hours?|hrs?|h)\b", re.IGNORECASE)
    matches = time_pattern.findall(content)
    if not matches:
        return True, "[WARN] No time estimates found in plan — cannot verify critical path < 8h (skipped)"

    total_hours = sum(float(m) for m in matches)
    if total_hours > 8:
        return False, f"Critical path estimates total {total_hours:.1f}h (limit is 8h)"
    return True, f"Critical path estimates total {total_hours:.1f}h (within 8h limit)"


def check_file_paths_plausible(content: str, plan_path: Path) -> tuple[bool, str]:
    """
    Check 7: All referenced file paths are plausible.
    Extracts file paths from the plan and checks that their parent directories
    either exist on disk or are listed as 'Create' targets in the plan.
    """
    # Extract paths from code blocks and inline references
    # Match patterns like: `path/to/file.ext`, Create: `path/to/file`
    path_pattern = re.compile(r"`([\w./-]+/[\w.-]+(?:\.\w+)?)`")
    paths_found = set(path_pattern.findall(content))

    if not paths_found:
        return True, "[WARN] No file paths found in plan (skipped)"

    # Build set of directories that the plan itself will create
    # (paths under "Create:" lines or mkdir commands)
    plan_creates = set()
    create_pattern = re.compile(r"(?:Create|mkdir\s+-p)\s*:?\s*`?([\w./-]+)`?")
    for match in create_pattern.finditer(content):
        created_path = match.group(1)
        plan_creates.add(created_path)
        # Also add all parent directories
        parts = created_path.split("/")
        for i in range(1, len(parts)):
            plan_creates.add("/".join(parts[:i]))

    # Check each referenced path
    plan_dir = plan_path.parent
    implausible = []
    for p in sorted(paths_found):
        parent = str(Path(p).parent)
        if parent == ".":
            continue  # root-level files are always plausible
        # Plausible if: parent dir exists on disk, or parent is in plan_creates, or path itself is in plan_creates
        parent_exists = (plan_dir / parent).is_dir() or os.path.isdir(parent)
        parent_planned = parent in plan_creates or p in plan_creates
        if not parent_exists and not parent_planned:
            implausible.append(p)

    if implausible:
        if len(implausible) > 5:
            shown = implausible[:5]
            return False, f"File paths with implausible parents ({len(implausible)} total): {shown} ..."
        return False, f"File paths with implausible parents: {implausible}"

    return True, f"All {len(paths_found)} referenced file paths have plausible parent directories"


# ---------------------------------------------------------------------------
# Runner
# ---------------------------------------------------------------------------

def run_checks(plan_path: Path) -> int:
    content = read_plan(plan_path)
    deliverables = parse_deliverables(content)
    spec_ac_ids = extract_all_spec_ac_ids(content)

    checks = [
        ("Check 1: Every AC maps to ≥1 task", lambda: check_every_ac_maps_to_task(deliverables, spec_ac_ids)),
        ("Check 2: Every task maps to ≥1 AC (no orphans)", lambda: check_every_task_maps_to_ac(deliverables)),
        ("Check 3: Tasks per deliverable < 7", lambda: check_tasks_per_deliverable(deliverables)),
        ("Check 4: HOW NOT present for every deliverable", lambda: check_how_not_present(deliverables)),
        ("Check 5: Agent arch present for every deliverable", lambda: check_agent_arch_present(deliverables)),
        ("Check 6: Critical path duration < 8 hours", lambda: check_critical_path_duration(content)),
        ("Check 7: All file paths plausible", lambda: check_file_paths_plausible(content, plan_path)),
    ]

    passed = 0
    failed = 0
    for name, fn in checks:
        try:
            ok, msg = fn()
        except Exception as e:
            ok, msg = False, f"Exception: {e}"
        status = "PASS" if ok else "FAIL"
        print(f"[{status}] {name} — {msg}")
        if ok:
            passed += 1
        else:
            failed += 1

    print(f"\nRESULT: {passed}/{passed + failed} checks passed, {failed} failed")
    return 0 if failed == 0 else 1


def main() -> int:
    if "--help" in sys.argv or "-h" in sys.argv:
        print(__doc__.strip())
        return 0

    if len(sys.argv) < 2:
        print("Usage: python3 validate-plan-coverage.py /path/to/plan.md", file=sys.stderr)
        return 1

    plan_path = Path(sys.argv[1])
    if not plan_path.is_file():
        print(f"ERROR: {plan_path} is not a file", file=sys.stderr)
        return 1

    return run_checks(plan_path)


if __name__ == "__main__":
    sys.exit(main())
