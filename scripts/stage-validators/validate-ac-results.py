#!/usr/bin/env python3
"""
Stage 6→7 Validator: All ACs have eval results, results are pass/fail, no [EVAL_FAILED] tags.

Usage: python3 validate-ac-results.py /path/to/.exec/
       python3 validate-ac-results.py --help

Exit: 0 = all checks pass, 1 = any check fails

Checks (per spec §7.2):
  1. All ACs have eval results in status.json (ac_results populated for every AC)
  2. Every AC result is "pass" or "fail" — no empty, null, or unknown values
  3. No [EVAL_FAILED] tags in any task file (or explicitly flagged for human review)
"""
import sys
import json
import re
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


def collect_all_ac_results(status: dict) -> dict[str, tuple[str, str]]:
    """
    Flatten ac_results from all tasks in status.json.
    Returns {ac_id: (result_value, task_id)}.
    """
    all_results: dict[str, tuple[str, str]] = {}
    deliverables = status.get("deliverables", {})
    for d_key, d_data in deliverables.items():
        for t_key, t_data in d_data.get("tasks", {}).items():
            ac_results = t_data.get("ac_results", {})
            for ac_id, result in ac_results.items():
                if isinstance(result, dict):
                    result_val = result.get("result", "")
                else:
                    result_val = str(result) if result is not None else ""
                all_results[ac_id] = (result_val, t_key)
    return all_results


def count_expected_acs(status: dict) -> int:
    """
    Count how many distinct AC IDs we expect from status.json.
    Looks at the 'ac_results' keys across all tasks.
    Returns total unique AC IDs.
    """
    return len(collect_all_ac_results(status))


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

def check_all_acs_have_results(status: dict) -> tuple[bool, str]:
    """
    Check 1: All ACs have eval results in status.json.
    ac_results must be populated (non-empty) for every task that is "done".
    """
    empty_results: list[str] = []
    tasks_without_results: list[str] = []
    deliverables = status.get("deliverables", {})

    for d_key, d_data in deliverables.items():
        for t_key, t_data in d_data.get("tasks", {}).items():
            t_status = t_data.get("status", "")
            ac_results = t_data.get("ac_results", {})

            # Done tasks MUST have ac_results
            if t_status == "done" and not ac_results:
                tasks_without_results.append(t_key)

            # Each ac_result entry must have a non-null result
            for ac_id, result in ac_results.items():
                if isinstance(result, dict):
                    val = result.get("result", None)
                else:
                    val = result
                if val is None or val == "":
                    empty_results.append(f"{ac_id} (in {t_key})")

    issues: list[str] = []
    if tasks_without_results:
        issues.append(f"Done tasks missing ac_results: {tasks_without_results}")
    if empty_results:
        issues.append(f"ACs with empty/null result: {empty_results}")

    if issues:
        return False, "\n  ".join(issues)

    total = len(collect_all_ac_results(status))
    if total == 0:
        return False, "No AC results found in status.json — ac_results must be populated before Stage 7"
    return True, f"All {total} ACs have eval results"


def check_results_are_pass_or_fail(status: dict) -> tuple[bool, str]:
    """
    Check 2: Every AC result is 'pass' or 'fail' — no other values allowed.
    """
    valid_values = {"pass", "fail"}
    invalid: list[str] = []

    all_results = collect_all_ac_results(status)
    for ac_id, (result_val, task_id) in all_results.items():
        normalized = result_val.strip().lower() if result_val else ""
        if normalized not in valid_values:
            invalid.append(f"{ac_id} (in {task_id}): result is {result_val!r}")

    if invalid:
        return (
            False,
            f"AC results with invalid values (must be 'pass' or 'fail'):\n  "
            + "\n  ".join(invalid),
        )

    total = len(all_results)
    if total == 0:
        return False, "No AC results to validate"
    return True, f"All {total} AC results are 'pass' or 'fail'"


def check_no_eval_failed_tags(exec_dir: Path) -> tuple[bool, str]:
    """
    Check 3: No [EVAL_FAILED] tags in any task file.
    If [EVAL_FAILED] is present alongside an explicit human-review flag,
    treat as a warning but still fail — the tag must be resolved.
    """
    eval_failed_re = re.compile(r"\[EVAL_FAILED\]", re.IGNORECASE)
    human_review_re = re.compile(r"\[HUMAN_REVIEW\]|\[FOR_REVIEW\]", re.IGNORECASE)

    hits: list[str] = []
    warned: list[str] = []

    for md_file in exec_dir.rglob("*.md"):
        content = md_file.read_text(encoding="utf-8", errors="replace")
        eval_matches = eval_failed_re.findall(content)
        if eval_matches:
            relative = md_file.relative_to(exec_dir)
            has_human_review = bool(human_review_re.search(content))
            if has_human_review:
                warned.append(
                    f"  {relative}: {len(eval_matches)} [EVAL_FAILED] tag(s) "
                    f"(also has [HUMAN_REVIEW] — escalated but not resolved)"
                )
            else:
                hits.append(f"  {relative}: {len(eval_matches)} [EVAL_FAILED] tag(s)")

    all_issues = hits + warned
    if all_issues:
        return (
            False,
            f"Found [EVAL_FAILED] tags — must be resolved or explicitly escalated:\n"
            + "\n".join(all_issues),
        )
    return True, "No [EVAL_FAILED] tags found"


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
        ("Check 1: All ACs have eval results", lambda: check_all_acs_have_results(status)),
        ("Check 2: All AC results are 'pass' or 'fail'", lambda: check_results_are_pass_or_fail(status)),
        ("Check 3: No [EVAL_FAILED] tags in task files", lambda: check_no_eval_failed_tags(exec_dir)),
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
        print("Usage: python3 validate-ac-results.py /path/to/.exec/", file=sys.stderr)
        return 1

    exec_dir = Path(sys.argv[1])
    if not exec_dir.is_dir():
        print(f"ERROR: {exec_dir} is not a directory", file=sys.stderr)
        return 1

    return run_checks(exec_dir)


if __name__ == "__main__":
    sys.exit(main())
