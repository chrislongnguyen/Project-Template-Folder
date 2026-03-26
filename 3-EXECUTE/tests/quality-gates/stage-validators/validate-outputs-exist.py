#!/usr/bin/env python3
"""
Stage 5→6 Validator: All tasks done, no [INCOMPLETE] tags, verify commands pass.

Usage: python3 validate-outputs-exist.py /path/to/.exec/
       python3 validate-outputs-exist.py --help

Exit: 0 = all checks pass, 1 = any check fails

Checks (per spec §7.2):
  1. All tasks have status "done" in status.json
  2. No [INCOMPLETE] tags in any task file
  3. Run each task's Verify command (if present) and report pass/fail
"""
import sys
import json
import re
import subprocess
from pathlib import Path


# ---------------------------------------------------------------------------
# Parsers
# ---------------------------------------------------------------------------

def load_status(exec_dir: Path) -> dict:
    status_path = exec_dir / "status.json"
    if not status_path.exists():
        raise FileNotFoundError(f"status.json not found at {status_path}")
    return json.loads(status_path.read_text(encoding="utf-8"))


def find_task_files(exec_dir: Path) -> list[Path]:
    """Find all task .md files (excludes project.md and deliverable.md)."""
    task_files = []
    for md_file in exec_dir.rglob("*.md"):
        name = md_file.name
        if name in ("project.md", "deliverable.md"):
            continue
        if re.match(r"T\d+", name) or re.match(r"D\d+-T\d+", name):
            task_files.append(md_file)
    return task_files


def extract_verify_commands(task_file: Path) -> list[str]:
    """
    Extract shell commands from the Verify section of a task file.
    Looks for ```bash blocks or inline backtick commands under '## Verify' or '### Verify'.
    """
    content = task_file.read_text(encoding="utf-8")
    commands: list[str] = []

    in_verify = False
    for line in content.splitlines():
        if re.match(r"^#+\s+Verify\b", line, re.IGNORECASE):
            in_verify = True
            continue
        if in_verify and line.startswith("#"):
            break
        if in_verify:
            # Pick up fenced code block lines
            if line.strip().startswith("`") and not line.strip().startswith("```"):
                cmd = line.strip().strip("`").strip()
                if cmd:
                    commands.append(cmd)

    # Also look for ```bash blocks in the entire file that are within Verify sections
    verify_block_re = re.compile(
        r"#+\s+Verify\b.*?```(?:bash|sh)?\s*\n(.*?)```",
        re.DOTALL | re.IGNORECASE,
    )
    for match in verify_block_re.finditer(content):
        block = match.group(1)
        for line in block.splitlines():
            cmd = line.strip()
            if cmd and not cmd.startswith("#"):
                commands.append(cmd)

    # Deduplicate preserving order
    seen: set[str] = set()
    unique_cmds: list[str] = []
    for cmd in commands:
        if cmd not in seen:
            seen.add(cmd)
            unique_cmds.append(cmd)

    return unique_cmds


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

def check_all_tasks_done(status: dict) -> tuple[bool, str]:
    """
    Check 1: All tasks in status.json have status "done".
    """
    not_done: list[str] = []
    deliverables = status.get("deliverables", {})
    total = 0
    for d_key, d_data in deliverables.items():
        for t_key, t_data in d_data.get("tasks", {}).items():
            total += 1
            t_status = t_data.get("status", "")
            if t_status != "done":
                not_done.append(f"{t_key} (status: {t_status!r})")

    if not_done:
        return False, f"Tasks not done ({len(not_done)}/{total}): {not_done}"
    if total == 0:
        return False, "No tasks found in status.json"
    return True, f"All {total} tasks are 'done'"


def check_no_incomplete_tags(exec_dir: Path) -> tuple[bool, str]:
    """
    Check 2: No [INCOMPLETE] tags in any .md file under exec_dir.
    """
    incomplete_re = re.compile(r"\[INCOMPLETE\]", re.IGNORECASE)
    hits: list[str] = []

    for md_file in exec_dir.rglob("*.md"):
        content = md_file.read_text(encoding="utf-8", errors="replace")
        matches = incomplete_re.findall(content)
        if matches:
            relative = md_file.relative_to(exec_dir)
            hits.append(f"  {relative}: {len(matches)} [INCOMPLETE] tag(s)")

    if hits:
        return False, "Found [INCOMPLETE] tags:\n" + "\n".join(hits)
    return True, "No [INCOMPLETE] tags found"


def check_verify_commands(exec_dir: Path) -> tuple[bool, str]:
    """
    Check 3: Run each task's Verify command and report pass/fail.
    If a task has no Verify commands, it is skipped (not failed).
    """
    task_files = find_task_files(exec_dir)
    if not task_files:
        return True, "[WARN] No task files found — skipping verify command checks"

    failures: list[str] = []
    ran = 0

    for tf in task_files:
        commands = extract_verify_commands(tf)
        for cmd in commands:
            ran += 1
            try:
                result = subprocess.run(
                    cmd,
                    shell=True,
                    capture_output=True,
                    text=True,
                    timeout=30,
                    cwd=exec_dir,
                )
                if result.returncode != 0:
                    failures.append(
                        f"  {tf.name}: command '{cmd}' exited {result.returncode}"
                        + (f" — {result.stderr.strip()[:120]}" if result.stderr.strip() else "")
                    )
            except subprocess.TimeoutExpired:
                failures.append(f"  {tf.name}: command '{cmd}' timed out (>30s)")

    if failures:
        return False, f"Verify commands failed ({len(failures)}/{ran}):\n" + "\n".join(failures)
    if ran == 0:
        return True, "[WARN] No verify commands found in task files (skipped)"
    return True, f"All {ran} verify command(s) passed"


# ---------------------------------------------------------------------------
# Runner
# ---------------------------------------------------------------------------

def run_checks(exec_dir: Path) -> int:
    try:
        status = load_status(exec_dir)
    except FileNotFoundError as e:
        print(f"ERROR: {e}", file=sys.stderr)
        return 1

    checks = [
        ("Check 1: All tasks 'done' in status.json", lambda: check_all_tasks_done(status)),
        ("Check 2: No [INCOMPLETE] tags in task files", lambda: check_no_incomplete_tags(exec_dir)),
        ("Check 3: Task verify commands pass", lambda: check_verify_commands(exec_dir)),
    ]

    passed = 0
    failed = 0
    for name, fn in checks:
        try:
            ok, msg = fn()
        except Exception as e:
            ok, msg = False, f"Exception: {e}"
        status_label = "PASS" if ok else "FAIL"
        print(f"[{status_label}] {name} — {msg}")
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
        print("Usage: python3 validate-outputs-exist.py /path/to/.exec/", file=sys.stderr)
        return 1

    exec_dir = Path(sys.argv[1])
    if not exec_dir.is_dir():
        print(f"ERROR: {exec_dir} is not a directory", file=sys.stderr)
        return 1

    return run_checks(exec_dir)


if __name__ == "__main__":
    sys.exit(main())
