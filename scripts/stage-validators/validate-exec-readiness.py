#!/usr/bin/env python3
"""
Stage 4→5 Validator: .exec/ readiness checks.

Delegates to skills/execution-planner/scripts/readiness-check.py for the full
10-point readiness gate. This script is the L4 inter-stage boundary enforcer.

Usage: python3 validate-exec-readiness.py /path/to/.exec/
       python3 validate-exec-readiness.py --help

Exit: 0 = all checks pass, 1 = any check fails

The delegation pattern is intentional per spec §7.2: the skill-internal
readiness-check.py is the single source of truth for the 10-point checklist.
This script provides the inter-stage boundary wrapper.
"""
import sys
import subprocess
from pathlib import Path


# ---------------------------------------------------------------------------
# Locate the readiness-check.py skill script
# ---------------------------------------------------------------------------

def find_readiness_script(exec_dir: Path) -> Path | None:
    """
    Search for skills/execution-planner/scripts/readiness-check.py relative to
    the project root. Tries several heuristics to locate it.
    """
    # Strategy 1: look upward from exec_dir until we find the project root
    candidate = exec_dir
    for _ in range(6):  # max 6 levels up
        script = candidate / "skills" / "execution-planner" / "scripts" / "readiness-check.py"
        if script.is_file():
            return script
        parent = candidate.parent
        if parent == candidate:
            break
        candidate = parent

    # Strategy 2: relative to this script's location
    this_dir = Path(__file__).resolve().parent
    for _ in range(4):
        script = this_dir / "skills" / "execution-planner" / "scripts" / "readiness-check.py"
        if script.is_file():
            return script
        this_dir = this_dir.parent

    return None


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def run_checks(exec_dir: Path) -> int:
    readiness_script = find_readiness_script(exec_dir)

    if readiness_script is None:
        print(
            "ERROR: Could not locate skills/execution-planner/scripts/readiness-check.py\n"
            "Ensure the project root has the execution-planner skill installed.",
            file=sys.stderr,
        )
        return 1

    print(f"[INFO] Delegating to: {readiness_script}")
    print(f"[INFO] Checking .exec/ directory: {exec_dir}\n")

    result = subprocess.run(
        [sys.executable, str(readiness_script), str(exec_dir)],
        capture_output=False,  # pass stdout/stderr through directly
        text=True,
    )

    return result.returncode


def main() -> int:
    if "--help" in sys.argv or "-h" in sys.argv:
        print(__doc__.strip())
        return 0

    if len(sys.argv) < 2:
        print("Usage: python3 validate-exec-readiness.py /path/to/.exec/", file=sys.stderr)
        return 1

    exec_dir = Path(sys.argv[1])
    if not exec_dir.is_dir():
        print(f"ERROR: {exec_dir} is not a directory", file=sys.stderr)
        return 1

    return run_checks(exec_dir)


if __name__ == "__main__":
    sys.exit(main())
