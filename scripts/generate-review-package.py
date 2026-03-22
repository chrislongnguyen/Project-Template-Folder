#!/usr/bin/env python3
"""
Stage 7 Review Package Generator.
Reads .exec/status.json and produces a markdown summary for Human Director review.
Usage: python3 generate-review-package.py /path/to/.exec/
Output: prints markdown review package to stdout
"""
import sys
import json
import re
from pathlib import Path
from datetime import datetime, timezone


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def load_status(exec_dir: Path) -> dict:
    status_path = exec_dir / "status.json"
    if not status_path.exists():
        raise FileNotFoundError(f"status.json not found at {status_path}")
    with status_path.open() as f:
        try:
            return json.load(f)
        except json.JSONDecodeError as e:
            raise ValueError(f"status.json is not valid JSON: {e}") from e


def scan_for_risk_tags(exec_dir: Path) -> list[str]:
    """Scan all .md files in exec_dir for [EVAL_FAILED], [INCOMPLETE], [UNVERIFIED] tags."""
    risk_tags = []
    tag_pattern = re.compile(r"\[(EVAL_FAILED|INCOMPLETE|UNVERIFIED)\]")
    for md_file in exec_dir.rglob("*.md"):
        content = md_file.read_text(errors="replace")
        for match in tag_pattern.finditer(content):
            relative = md_file.relative_to(exec_dir)
            risk_tags.append(f"  - `[{match.group(1)}]` found in `{relative}`")
    return risk_tags


# ---------------------------------------------------------------------------
# Section builders
# ---------------------------------------------------------------------------

def build_summary(status: dict, pass_rate: float, total_tasks: int, completed_tasks: int) -> str:
    lines = [
        "## Summary\n",
        "| Field | Value |",
        "|---|---|",
        f"| Project | {status.get('project', '(unknown)')} |",
        f"| Spec Version | {status.get('spec_version', '(unknown)')} |",
        f"| Plan Version | {status.get('plan_version', '(unknown)')} |",
        f"| Exec Version | {status.get('exec_version', '(unknown)')} |",
        f"| Pipeline Stage | {status.get('pipeline_stage', '(unknown)')} |",
        f"| Total Tasks | {total_tasks} |",
        f"| Completed | {completed_tasks} ({pass_rate:.0f}%) |",
        f"| Generated | {datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')} |",
    ]
    return "\n".join(lines)


def build_ac_results(status: dict) -> str:
    """Build AC Results table from task ac_results in status.json."""
    rows = []
    deliverables = status.get("deliverables", {})
    for d_id, d_data in sorted(deliverables.items()):
        tasks = d_data.get("tasks", {})
        for t_id, t_data in sorted(tasks.items()):
            ac_results = t_data.get("ac_results", {})
            for ac_id, result in sorted(ac_results.items()):
                if isinstance(result, dict):
                    eval_type = result.get("eval_type", "—")
                    outcome = result.get("result", "—")
                    evidence = result.get("evidence", "—")
                else:
                    eval_type = "—"
                    outcome = str(result)
                    evidence = "—"
                rows.append(f"| {ac_id} | {t_id} | {eval_type} | {outcome} | {evidence} |")

    if not rows:
        rows.append("| — | — | — | — | _(no AC results recorded)_ |")

    header = [
        "## AC Results\n",
        "| AC ID | Task | Eval Type | Result | Evidence |",
        "|---|---|---|---|---|",
    ]
    return "\n".join(header + rows)


def build_deliverable_status(status: dict) -> str:
    rows = []
    deliverables = status.get("deliverables", {})
    for d_id, d_data in sorted(deliverables.items()):
        name = d_data.get("name", "(unnamed)")
        d_status = d_data.get("status", "—")
        tasks = d_data.get("tasks", {})
        total = len(tasks)
        done = sum(1 for t in tasks.values() if t.get("status") == "done")
        rate = (done / total * 100) if total > 0 else 0.0
        rows.append(f"| {d_id} | {name} | {total} | {done} | {rate:.0f}% | {d_status} |")

    if not rows:
        rows.append("| — | _(no deliverables)_ | 0 | 0 | — | — |")

    header = [
        "## Deliverable Status\n",
        "| Deliverable | Name | Tasks | Done | Pass Rate | Status |",
        "|---|---|---|---|---|---|",
    ]
    return "\n".join(header + rows)


def build_rework_history(status: dict) -> str:
    rework_log = status.get("rework_log", [])
    if not rework_log:
        return "## Rework History\n\n_(no rework cycles)_"

    lines = ["## Rework History\n"]
    for entry in rework_log:
        task_id = entry.get("task_id", "?")
        from_s = entry.get("from_status", "?")
        to_s = entry.get("to_status", "?")
        reason = entry.get("reason", "(no reason given)")
        triggered_by = entry.get("triggered_by", "?")
        timestamp = entry.get("timestamp", "?")
        lines.append(
            f"- **{task_id}** `{from_s}` → `{to_s}` at {timestamp} "
            f"(triggered by: {triggered_by}): {reason}"
        )
    return "\n".join(lines)


def build_risk_flags(risk_tags: list[str], status: dict) -> str:
    flags = list(risk_tags)

    # Also flag tasks with rework_count > 0
    deliverables = status.get("deliverables", {})
    for d_id, d_data in sorted(deliverables.items()):
        for t_id, t_data in sorted(d_data.get("tasks", {}).items()):
            rc = t_data.get("rework_count", 0)
            if rc > 0:
                flags.append(f"  - `{t_id}` has {rc} rework cycle(s)")

    if not flags:
        return "## Risk Flags\n\n_(none — clean execution)_"

    lines = ["## Risk Flags\n"] + flags
    return "\n".join(lines)


def build_decision() -> str:
    return """---

**Human Director Decision:**
- [ ] Approved — trigger completion cascade
- [ ] Code changes needed — specify tasks to rework
- [ ] Plan is wrong — re-enter Stage 3
- [ ] Spec is wrong — re-enter Stage 1"""


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def generate(exec_dir: Path) -> str:
    status = load_status(exec_dir)

    # Aggregate totals
    deliverables = status.get("deliverables", {})
    total_tasks = 0
    completed_tasks = 0
    for d_data in deliverables.values():
        tasks = d_data.get("tasks", {})
        total_tasks += len(tasks)
        completed_tasks += sum(1 for t in tasks.values() if t.get("status") == "done")

    pass_rate = (completed_tasks / total_tasks * 100) if total_tasks > 0 else 0.0

    risk_tags = scan_for_risk_tags(exec_dir)

    project_name = status.get("project", "Unknown Project")
    sections = [
        f"# Review Package: {project_name}\n",
        build_summary(status, pass_rate, total_tasks, completed_tasks),
        "",
        build_ac_results(status),
        "",
        build_deliverable_status(status),
        "",
        build_rework_history(status),
        "",
        build_risk_flags(risk_tags, status),
        "",
        build_decision(),
    ]
    return "\n".join(sections)


def main():
    if len(sys.argv) < 2 or sys.argv[1] in ("--help", "-h"):
        print(__doc__)
        sys.exit(0)

    exec_dir = Path(sys.argv[1])
    if not exec_dir.is_dir():
        print(f"ERROR: {exec_dir} is not a directory", file=sys.stderr)
        sys.exit(1)

    try:
        output = generate(exec_dir)
        print(output)
    except FileNotFoundError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)
    except (json.JSONDecodeError, ValueError) as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
