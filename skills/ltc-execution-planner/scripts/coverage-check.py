#!/usr/bin/env python3
"""
LEP Coverage Check — AC-to-task traceability validator.

Validates that every AC in the spec maps to exactly one task in .exec/,
and every task AC in .exec/ maps back to the spec.

Usage: python3 coverage-check.py /path/to/spec.md /path/to/.exec/
       python3 coverage-check.py --help

Exit code: 0 = pass, 1 = fail
"""
import sys
import re
from pathlib import Path


def extract_spec_ac_ids(spec_path: Path) -> list[str]:
    """Extract AC IDs from a VANA-SPEC file.

    Looks for AC IDs in patterns like:
    - | AC-ID | ... (table rows)
    - AC-{word}: ... (list items)
    - {Noun}-AC{N} patterns
    """
    content = spec_path.read_text(encoding="utf-8")
    ac_ids: list[str] = []

    # Pattern 1: Table rows with AC IDs (e.g., | Noun-AC1 | ...)
    for match in re.finditer(r"\|\s*(\w+-AC\d+)\s*\|", content):
        ac_id = match.group(1)
        if ac_id not in ac_ids:
            ac_ids.append(ac_id)

    # Pattern 2: Checklist items (e.g., - [ ] AC-1: ...)
    for match in re.finditer(r"-\s*\[[ x]\]\s*(AC-\d+):", content):
        ac_id = match.group(1)
        if ac_id not in ac_ids:
            ac_ids.append(ac_id)

    return ac_ids


def extract_task_ac_ids(exec_dir: Path) -> dict[str, list[str]]:
    """Extract AC IDs from all task files in .exec/, keyed by task ID."""
    task_acs: dict[str, list[str]] = {}

    for md_file in exec_dir.rglob("*.md"):
        if md_file.name in ("project.md", "deliverable.md"):
            continue
        if not (re.match(r"T\d+", md_file.name) or re.match(r"D\d+-T\d+", md_file.name)):
            continue

        content = md_file.read_text(encoding="utf-8")

        # Extract task ID
        id_match = re.search(r"\|\s*Task ID\s*\|\s*(D\d+-T\d+)\s*\|", content)
        task_id = id_match.group(1) if id_match else md_file.stem

        # Extract AC IDs from VANA Traceability table
        ac_ids = []
        in_vana = False
        for line in content.splitlines():
            if "## VANA Traceability" in line:
                in_vana = True
                continue
            if in_vana and line.startswith("##"):
                break
            if in_vana and "|" in line:
                parts = [p.strip() for p in line.split("|") if p.strip()]
                if len(parts) >= 1 and parts[0] not in ("A.C. ID", "---", ""):
                    ac_id = parts[0]
                    if ac_id and not ac_id.startswith("-") and not ac_id.startswith("{"):
                        ac_ids.append(ac_id)

        task_acs[task_id] = ac_ids

    return task_acs


def main() -> int:
    if "--help" in sys.argv or "-h" in sys.argv:
        print(__doc__.strip())
        return 0

    if len(sys.argv) < 3:
        print("Usage: python3 coverage-check.py /path/to/spec.md /path/to/.exec/", file=sys.stderr)
        return 1

    spec_path = Path(sys.argv[1])
    exec_dir = Path(sys.argv[2])

    if not spec_path.is_file():
        print(f"Error: spec file not found: {spec_path}", file=sys.stderr)
        return 1
    if not exec_dir.is_dir():
        print(f"Error: .exec/ directory not found: {exec_dir}", file=sys.stderr)
        return 1

    spec_acs = extract_spec_ac_ids(spec_path)
    task_acs = extract_task_ac_ids(exec_dir)

    # Flatten task ACs with their source task
    all_task_ac_ids: list[str] = []
    ac_to_task: dict[str, list[str]] = {}
    for task_id, ac_ids in task_acs.items():
        for ac_id in ac_ids:
            all_task_ac_ids.append(ac_id)
            ac_to_task.setdefault(ac_id, []).append(task_id)

    failed = False

    # Check 1: Every spec AC is covered by at least one task
    print("=== Spec AC -> Task Coverage ===")
    uncovered = []
    for ac_id in spec_acs:
        tasks = ac_to_task.get(ac_id, [])
        if not tasks:
            uncovered.append(ac_id)
            print(f"  [FAIL] {ac_id}: not covered by any task")
        elif len(tasks) > 1:
            print(f"  [WARN] {ac_id}: covered by multiple tasks: {tasks}")
        else:
            print(f"  [PASS] {ac_id}: covered by {tasks[0]}")

    if uncovered:
        print(f"\n  {len(uncovered)} spec AC(s) not covered by any task")
        failed = True
    else:
        print(f"\n  All {len(spec_acs)} spec ACs covered")

    # Check 2: Every task AC exists in the spec
    print("\n=== Task AC -> Spec Traceability ===")
    orphans = []
    spec_ac_set = set(spec_acs)
    for ac_id, tasks in ac_to_task.items():
        if ac_id not in spec_ac_set:
            orphans.append((ac_id, tasks))
            print(f"  [FAIL] {ac_id} (in {tasks}): not found in spec")
        else:
            print(f"  [PASS] {ac_id} (in {tasks}): exists in spec")

    if orphans:
        print(f"\n  {len(orphans)} task AC(s) not found in spec")
        failed = True
    else:
        print(f"\n  All task ACs traced to spec")

    # Check 3: No task has zero ACs
    print("\n=== Task AC Minimum ===")
    empty_tasks = []
    for task_id, ac_ids in task_acs.items():
        if not ac_ids:
            empty_tasks.append(task_id)
            print(f"  [FAIL] {task_id}: no ACs defined")
        else:
            print(f"  [PASS] {task_id}: {len(ac_ids)} AC(s)")

    if empty_tasks:
        print(f"\n  {len(empty_tasks)} task(s) with no ACs")
        failed = True

    # Summary
    print("\n=== Summary ===")
    print(f"Spec ACs: {len(spec_acs)}")
    print(f"Task ACs: {len(all_task_ac_ids)} across {len(task_acs)} tasks")
    print(f"Uncovered spec ACs: {len(uncovered)}")
    print(f"Orphan task ACs: {len(orphans)}")
    print(f"Tasks with no ACs: {len(empty_tasks)}")

    if failed:
        print("\nRESULT: FAIL")
        return 1
    else:
        print("\nRESULT: PASS")
        return 0


if __name__ == "__main__":
    sys.exit(main())
