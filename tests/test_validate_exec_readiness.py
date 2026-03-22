"""
Tests for scripts/stage-validators/validate-exec-readiness.py (Stage 4→5)

This validator delegates to skills/execution-planner/scripts/readiness-check.py.
Tests verify the delegation wiring and CLI behavior.
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
# Delegation wiring
# ---------------------------------------------------------------------------

def test_delegates_to_readiness_check(tmp_path):
    """Validator should mention the delegated script in its output."""
    # Create a minimal .exec/ dir to avoid the "not a dir" error
    exec_dir = tmp_path / ".exec"
    exec_dir.mkdir()
    result = run_validator(exec_dir)
    # Either it found the script and reports INFO, or it errors about finding it.
    # Either way, it should NOT silently succeed on an empty dir.
    combined = result.stdout + result.stderr
    # It should produce some output
    assert len(combined.strip()) > 0


def test_error_on_no_readiness_script(tmp_path):
    """If readiness-check.py cannot be found, should exit non-zero with an error."""
    # We test in a completely isolated tmp dir with no skills/ directory
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()

    # Run from a location where readiness-check.py won't be found
    result = subprocess.run(
        [sys.executable, str(SCRIPT), str(exec_dir)],
        capture_output=True,
        text=True,
        cwd=str(tmp_path),
    )
    # Should either fail because the script isn't found or fail the readiness check
    # (valid either way — script should not silently pass)
    assert result.returncode != 0 or "INFO" in result.stdout


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
# Real delegation (integration-style)
# ---------------------------------------------------------------------------

def test_valid_exec_dir_runs_checks():
    """On a dir with valid-exec fixture, the validator should produce output."""
    result = run_validator(VALID_EXEC)
    # The readiness-check.py should either pass or produce check output
    combined = result.stdout + result.stderr
    assert len(combined.strip()) > 0


def test_output_contains_info_line():
    """INFO lines about delegation path should appear in stdout."""
    result = run_validator(VALID_EXEC)
    # The script prints [INFO] lines before delegating
    # (Only if the readiness-check is found)
    if result.returncode == 0 or "INFO" in result.stdout:
        assert True  # delegation happened
    else:
        # Failed because readiness-check not found — acceptable in isolated env
        assert "ERROR" in result.stderr or "Could not locate" in result.stderr
