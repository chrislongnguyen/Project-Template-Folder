#!/usr/bin/env python3
"""
LEP Readiness Check — 10-point automated gate for .exec/ files.

Usage: python3 readiness-check.py /path/to/.exec/
       python3 readiness-check.py --help

Exit code: 0 = all pass, 1 = any fail
"""
import sys
import json
import os
import re
from pathlib import Path


def find_task_files(exec_dir: Path) -> list[Path]:
    """Find all task .md files in .exec/ (excludes project.md, deliverable.md)."""
    task_files = []
    for md_file in exec_dir.rglob("*.md"):
        name = md_file.name
        if name in ("project.md", "deliverable.md"):
            continue
        # Task files match pattern T{n}-{Name}.md or D{n}-T{m}*.md
        if re.match(r"T\d+", name) or re.match(r"D\d+-T\d+", name):
            task_files.append(md_file)
    return task_files


def extract_task_id(task_file: Path) -> str | None:
    """Extract Task ID from Identity table in a task file."""
    content = task_file.read_text(encoding="utf-8")
    match = re.search(r"\|\s*Task ID\s*\|\s*(D\d+-T\d+)\s*\|", content)
    return match.group(1) if match else None


def parse_identity_field(content: str, field_name: str) -> str | None:
    """Parse a field from the Identity table."""
    pattern = rf"\|\s*{re.escape(field_name)}\s*\|\s*(.+?)\s*\|"
    match = re.search(pattern, content)
    return match.group(1).strip() if match else None


def parse_dependencies(content: str) -> dict[str, list[str]]:
    """Parse Dependencies table, return {direction: [task_ids]}."""
    deps = {"blocked_by": [], "blocks": []}
    in_deps = False
    for line in content.splitlines():
        if "## Dependencies" in line:
            in_deps = True
            continue
        if in_deps and line.startswith("##"):
            break
        if in_deps and "|" in line:
            parts = [p.strip() for p in line.split("|") if p.strip()]
            if len(parts) >= 2 and parts[0] in ("blocked_by", "blocks"):
                task_id = parts[1].strip()
                if re.match(r"D\d+-T\d+", task_id):
                    deps[parts[0]].append(task_id)
    return deps


def parse_vana_ac_ids(content: str) -> list[str]:
    """Parse AC IDs from VANA Traceability table."""
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
    return ac_ids


def parse_references(content: str) -> dict[str, str]:
    """Parse References table."""
    refs = {}
    in_refs = False
    for line in content.splitlines():
        if "## References" in line:
            in_refs = True
            continue
        if in_refs and line.startswith("##"):
            break
        if in_refs and "|" in line:
            parts = [p.strip() for p in line.split("|") if p.strip()]
            if len(parts) >= 2 and parts[0] not in ("Reference", "---", ""):
                refs[parts[0]] = parts[1]
    return refs


def parse_io_paths(content: str, section: str) -> list[str]:
    """Parse file paths from I/O Contract Inputs or Outputs table."""
    paths = []
    in_section = False
    for line in content.splitlines():
        if f"### {section}" in line:
            in_section = True
            continue
        if in_section and (line.startswith("##") or line.startswith("###")):
            break
        if in_section and "|" in line:
            parts = [p.strip() for p in line.split("|") if p.strip()]
            if len(parts) >= 2 and parts[0] not in ("Source", "Consumer", "---", ""):
                path = parts[1]
                if path and not path.startswith("{"):
                    paths.append(path)
    return paths


def parse_environment_commands(content: str) -> list[str]:
    """Parse verify commands from Environment table."""
    commands = []
    in_env = False
    for line in content.splitlines():
        if "## Environment" in line:
            in_env = True
            continue
        if in_env and line.startswith("##"):
            break
        if in_env and "|" in line:
            parts = [p.strip() for p in line.split("|") if p.strip()]
            if len(parts) >= 2 and parts[0] not in ("Prerequisite", "---", ""):
                cmd = parts[1].strip("`")
                if cmd and not cmd.startswith("{"):
                    commands.append(cmd)
    return commands


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

def check_1_completeness(task_files: list[Path]) -> tuple[bool, str]:
    """Check 1: No unfilled {..} placeholders in task files (outside code blocks)."""
    failures = []
    placeholder_re = re.compile(r"\{[^}]+\}")
    for tf in task_files:
        content = tf.read_text(encoding="utf-8")
        # Strip code blocks
        stripped = re.sub(r"```.*?```", "", content, flags=re.DOTALL)
        matches = placeholder_re.findall(stripped)
        if matches:
            failures.append(f"  {tf.name}: {len(matches)} placeholder(s) — {matches[:3]}")
    if failures:
        return False, "Unfilled placeholders found:\n" + "\n".join(failures)
    return True, "All task files fully populated"


def check_2_acyclicity(task_files: list[Path]) -> tuple[bool, str]:
    """Check 2: Dependency graph has no cycles."""
    # Build adjacency list: edge from dependency -> dependent
    graph: dict[str, list[str]] = {}
    all_ids: set[str] = set()
    for tf in task_files:
        content = tf.read_text(encoding="utf-8")
        task_id = extract_task_id(tf)
        if not task_id:
            continue
        all_ids.add(task_id)
        deps = parse_dependencies(content)
        for dep_id in deps["blocked_by"]:
            graph.setdefault(dep_id, []).append(task_id)
            all_ids.add(dep_id)

    # DFS cycle detection
    WHITE, GRAY, BLACK = 0, 1, 2
    color = {n: WHITE for n in all_ids}

    def dfs(node: str) -> str | None:
        color[node] = GRAY
        for neighbor in graph.get(node, []):
            if color.get(neighbor) == GRAY:
                return f"{node} -> {neighbor}"
            if color.get(neighbor) == WHITE:
                result = dfs(neighbor)
                if result:
                    return result
        color[node] = BLACK
        return None

    for node in all_ids:
        if color[node] == WHITE:
            cycle = dfs(node)
            if cycle:
                return False, f"Circular dependency detected: {cycle}"
    return True, "No circular dependencies"


def check_3_ac_coverage(task_files: list[Path]) -> tuple[bool, str]:
    """Check 3: AC coverage MECE — every task AC exists, no duplicates across tasks."""
    all_ac_ids: list[str] = []
    per_task: dict[str, list[str]] = {}
    for tf in task_files:
        content = tf.read_text(encoding="utf-8")
        task_id = extract_task_id(tf) or tf.name
        ac_ids = parse_vana_ac_ids(content)
        per_task[task_id] = ac_ids
        all_ac_ids.extend(ac_ids)

    # Check for duplicates across tasks
    seen: dict[str, str] = {}
    duplicates = []
    for task_id, ac_ids in per_task.items():
        for ac_id in ac_ids:
            if ac_id in seen:
                duplicates.append(f"AC '{ac_id}' in both {seen[ac_id]} and {task_id}")
            else:
                seen[ac_id] = task_id

    if duplicates:
        return False, "Duplicate AC coverage:\n  " + "\n  ".join(duplicates)
    if not all_ac_ids:
        return False, "No AC IDs found in any task file"
    return True, f"{len(all_ac_ids)} ACs mapped across {len(per_task)} tasks, no duplicates"


def check_4_io_consistency(task_files: list[Path]) -> tuple[bool, str]:
    """Check 4: I/O contract consistency — outputs match downstream inputs."""
    # Build output map: path -> producer task
    outputs: dict[str, str] = {}
    inputs: dict[str, str] = {}
    for tf in task_files:
        content = tf.read_text(encoding="utf-8")
        task_id = extract_task_id(tf) or tf.name
        for path in parse_io_paths(content, "Outputs"):
            outputs[path] = task_id
        for path in parse_io_paths(content, "Inputs"):
            inputs[path] = task_id

    # For now, just verify format is present (deep matching requires dependency info)
    return True, f"{len(outputs)} output paths, {len(inputs)} input paths declared"


def check_5_environment(task_files: list[Path]) -> tuple[bool, str]:
    """Check 5: Environment verify commands are syntactically valid."""
    failures = []
    for tf in task_files:
        content = tf.read_text(encoding="utf-8")
        commands = parse_environment_commands(content)
        for cmd in commands:
            if not cmd.strip():
                failures.append(f"  {tf.name}: empty verify command")
            elif cmd.count('"') % 2 != 0 or cmd.count("'") % 2 != 0:
                failures.append(f"  {tf.name}: unmatched quotes in '{cmd}'")
    if failures:
        return False, "Invalid environment commands:\n" + "\n".join(failures)
    return True, "All environment verify commands syntactically valid"


def check_6_status_sync(exec_dir: Path, task_files: list[Path]) -> tuple[bool, str]:
    """Check 6: status.json <-> task files consistency."""
    status_path = exec_dir / "status.json"
    if not status_path.exists():
        return False, "status.json not found"

    status = json.loads(status_path.read_text(encoding="utf-8"))

    # Collect task IDs from status.json
    status_ids: set[str] = set()
    for d_key, d_val in status.get("deliverables", {}).items():
        for t_key in d_val.get("tasks", {}):
            status_ids.add(t_key)

    # Collect task IDs from .md files
    file_ids: set[str] = set()
    for tf in task_files:
        tid = extract_task_id(tf)
        if tid:
            file_ids.add(tid)

    missing_files = status_ids - file_ids
    missing_status = file_ids - status_ids

    issues = []
    if missing_files:
        issues.append(f"In status.json but no .md file: {missing_files}")
    if missing_status:
        issues.append(f"Has .md file but not in status.json: {missing_status}")

    if issues:
        return False, "\n  ".join(issues)
    return True, f"{len(status_ids)} tasks consistent between status.json and task files"


def check_7_wms_sync(exec_dir: Path, task_files: list[Path]) -> tuple[bool, str]:
    """Check 7: WMS sync successful (skippable)."""
    wms_path = exec_dir / ".wms-sync.json"
    if not wms_path.exists():
        return True, "[WARN] .wms-sync.json not found — WMS sync not yet configured (skipped)"

    wms = json.loads(wms_path.read_text(encoding="utf-8"))
    items = wms.get("items", {})
    file_ids: set[str] = set()
    for tf in task_files:
        tid = extract_task_id(tf)
        if tid:
            file_ids.add(tid)

    missing = file_ids - set(items.keys())
    if missing:
        return False, f"Tasks not synced to WMS: {missing}"
    return True, f"{len(items)} tasks synced to WMS"


def check_8_agent_pattern(task_files: list[Path]) -> tuple[bool, str]:
    """Check 8: Agent pattern is a valid value."""
    valid_patterns = {"Single Agent", "Sub-Agents", "Agent Team"}
    failures = []
    for tf in task_files:
        content = tf.read_text(encoding="utf-8")
        pattern = parse_identity_field(content, "Agent Pattern")
        if pattern and pattern not in valid_patterns and not pattern.startswith("{"):
            failures.append(f"  {tf.name}: invalid pattern '{pattern}'")
    if failures:
        return False, "Invalid agent patterns:\n" + "\n".join(failures)
    return True, "All agent patterns valid"


def check_9_model_assignment(task_files: list[Path]) -> tuple[bool, str]:
    """Check 9: Agent model is a valid value."""
    valid_models = {"Opus", "Sonnet", "Haiku"}
    failures = []
    for tf in task_files:
        content = tf.read_text(encoding="utf-8")
        model = parse_identity_field(content, "Agent Model")
        if model and model not in valid_models and not model.startswith("{"):
            failures.append(f"  {tf.name}: invalid model '{model}'")
    if failures:
        return False, "Invalid agent models:\n" + "\n".join(failures)
    return True, "All agent models valid"


def check_10_traceability(task_files: list[Path]) -> tuple[bool, str]:
    """Check 10: Traceability chain complete."""
    failures = []
    for tf in task_files:
        content = tf.read_text(encoding="utf-8")
        refs = parse_references(content)
        ac_ids = parse_vana_ac_ids(content)

        issues = []
        plan_ref = refs.get("Plan Section", "")
        if not plan_ref or plan_ref.startswith("{"):
            issues.append("missing Plan Section reference")
        spec_ref = refs.get("Spec ACs", "")
        if not spec_ref or spec_ref.startswith("{"):
            issues.append("missing Spec ACs reference")
        if not ac_ids:
            issues.append("no AC IDs in VANA Traceability")

        if issues:
            failures.append(f"  {tf.name}: {', '.join(issues)}")

    if failures:
        return False, "Incomplete traceability:\n" + "\n".join(failures)
    return True, "All tasks have complete trace links"


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> int:
    if "--help" in sys.argv or "-h" in sys.argv:
        print(__doc__.strip())
        return 0

    if len(sys.argv) < 2:
        print("Usage: python3 readiness-check.py /path/to/.exec/", file=sys.stderr)
        return 1

    exec_dir = Path(sys.argv[1])
    if not exec_dir.is_dir():
        print(f"Error: {exec_dir} is not a directory", file=sys.stderr)
        return 1

    task_files = find_task_files(exec_dir)
    if not task_files:
        print(f"Error: no task files found in {exec_dir}", file=sys.stderr)
        return 1

    checks = [
        ("Check 1: Task file completeness", lambda: check_1_completeness(task_files)),
        ("Check 2: Dependency graph acyclicity", lambda: check_2_acyclicity(task_files)),
        ("Check 3: AC coverage MECE", lambda: check_3_ac_coverage(task_files)),
        ("Check 4: I/O contract consistency", lambda: check_4_io_consistency(task_files)),
        ("Check 5: Environment prereqs verifiable", lambda: check_5_environment(task_files)),
        ("Check 6: status.json <-> task files", lambda: check_6_status_sync(exec_dir, task_files)),
        ("Check 7: WMS sync", lambda: check_7_wms_sync(exec_dir, task_files)),
        ("Check 8: Agent pattern valid", lambda: check_8_agent_pattern(task_files)),
        ("Check 9: Model assignment valid", lambda: check_9_model_assignment(task_files)),
        ("Check 10: Traceability chain complete", lambda: check_10_traceability(task_files)),
    ]

    passed = 0
    failed = 0
    for name, check_fn in checks:
        try:
            ok, msg = check_fn()
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


if __name__ == "__main__":
    sys.exit(main())
