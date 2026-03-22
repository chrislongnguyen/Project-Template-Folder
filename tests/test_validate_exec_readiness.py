"""
Tests for scripts/stage-validators/validate-exec-readiness.py (Stage 4→5)

This validator is now standalone (all 10 checks inlined; no subprocess delegation
to skills/execution-planner/scripts/readiness-check.py).
"""
import subprocess
import sys
from pathlib import Path

SCRIPT = Path(__file__).parent.parent / "scripts" / "stage-validators" / "validate-exec-readiness.py"
VALID_EXEC = Path(__file__).parent / "fixtures" / "valid-exec"


def run_validator(exec_dir: Path) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(SCRIPT), str(exec_dir)],
        capture_output=True,
        text=True,
    )


# ---------------------------------------------------------------------------
# Standalone verification — must NOT delegate via subprocess
# ---------------------------------------------------------------------------

def test_no_subprocess_delegation():
    """validate-exec-readiness.py must not import subprocess or call readiness-check.py."""
    content = SCRIPT.read_text(encoding="utf-8")
    assert "readiness-check.py" not in content, (
        "FAIL 1 regression: script must not reference readiness-check.py"
    )
    # subprocess import is allowed only for tests, but the validator itself
    # must not use it to delegate
    assert "find_readiness_script" not in content, (
        "FAIL 1 regression: find_readiness_script() must not exist"
    )


def test_all_10_checks_present():
    """All 10 check functions must be defined inline in the script."""
    content = SCRIPT.read_text(encoding="utf-8")
    for i in range(1, 11):
        assert f"check_{i}_" in content, f"check_{i} not found in standalone script"


# ---------------------------------------------------------------------------
# CLI / error handling
# ---------------------------------------------------------------------------

def test_help_flag():
    """--help should exit 0."""
    result = subprocess.run(
        [sys.executable, str(SCRIPT), "--help"],
        capture_output=True, text=True,
    )
    assert result.returncode == 0


def test_missing_arg_exits_nonzero():
    """No argument should exit non-zero."""
    result = subprocess.run(
        [sys.executable, str(SCRIPT)],
        capture_output=True, text=True,
    )
    assert result.returncode != 0


def test_not_a_directory_exits_nonzero(tmp_path):
    """Passing a file path (not dir) should exit non-zero."""
    f = tmp_path / "notadir.md"
    f.write_text("hello")
    result = run_validator(f)
    assert result.returncode != 0
    assert "ERROR" in result.stderr


def test_nonexistent_dir_exits_nonzero(tmp_path):
    """Non-existent path should exit non-zero."""
    result = run_validator(tmp_path / "does-not-exist")
    assert result.returncode != 0


# ---------------------------------------------------------------------------
# Real checks (integration-style)
# ---------------------------------------------------------------------------

def test_valid_exec_dir_runs_checks():
    """On a dir with valid-exec fixture, the validator should produce check output."""
    result = run_validator(VALID_EXEC)
    combined = result.stdout + result.stderr
    assert "[PASS]" in combined or "[FAIL]" in combined, (
        "Expected structured check output, got: " + combined[:200]
    )


def test_valid_exec_exits_zero():
    """valid-exec fixture should pass all checks (exit 0)."""
    result = run_validator(VALID_EXEC)
    assert result.returncode == 0, (
        f"Expected exit 0 for valid-exec fixture.\n"
        f"stdout: {result.stdout}\nstderr: {result.stderr}"
    )


def test_output_contains_result_line():
    """Output must contain a RESULT summary line."""
    result = run_validator(VALID_EXEC)
    assert "RESULT:" in result.stdout


def test_empty_exec_dir_exits_nonzero(tmp_path):
    """An empty .exec/ dir (no task files) should exit non-zero."""
    exec_dir = tmp_path / ".exec"
    exec_dir.mkdir()
    result = run_validator(exec_dir)
    assert result.returncode != 0


def test_missing_status_json_exits_nonzero(tmp_path):
    """A dir with task files but no status.json should exit non-zero with specific error."""
    exec_dir = tmp_path / ".exec"
    d1 = exec_dir / "D1-Test"
    d1.mkdir(parents=True)
    (d1 / "T1-Setup.md").write_text("# D1-T1: Setup\n\n## Identity\n")
    result = run_validator(exec_dir)
    assert result.returncode != 0
    assert "status.json" in result.stdout.lower() or "status.json" in result.stderr.lower()
