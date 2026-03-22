"""
Tests for scripts/stage-validators/validate-spec-mece.py (Stage 1→2)
"""
import subprocess
import sys
from pathlib import Path

SCRIPT = Path(__file__).parent.parent / "scripts" / "stage-validators" / "validate-spec-mece.py"
FIXTURES = Path(__file__).parent / "fixtures" / "spec-fixtures"


def run_validator(spec_path: Path) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(SCRIPT), str(spec_path)],
        capture_output=True,
        text=True,
    )


# ---------------------------------------------------------------------------
# Happy path
# ---------------------------------------------------------------------------

def test_valid_spec_passes():
    """A spec with proper MECE AC coverage, §0, §6 should pass."""
    result = run_validator(FIXTURES / "valid-spec.md")
    assert result.returncode == 0, (
        f"Expected exit 0, got {result.returncode}.\nstdout: {result.stdout}\nstderr: {result.stderr}"
    )


def test_valid_spec_all_checks_pass():
    """All 5 checks should show PASS for a valid spec."""
    result = run_validator(FIXTURES / "valid-spec.md")
    assert "[PASS]" in result.stdout
    assert "[FAIL]" not in result.stdout


def test_valid_spec_result_line():
    """Result summary should show 5/5 checks passed."""
    result = run_validator(FIXTURES / "valid-spec.md")
    assert "5/5" in result.stdout


# ---------------------------------------------------------------------------
# Check 5: Duplicate AC IDs
# ---------------------------------------------------------------------------

def test_duplicate_ac_id_fails():
    """A spec with duplicate AC IDs in §2-§5 should fail."""
    result = run_validator(FIXTURES / "spec-duplicate-ac.md")
    assert result.returncode == 1
    assert "duplicate" in result.stdout.lower()


def test_duplicate_ac_id_names_the_id():
    """Failure output should name the duplicated AC ID."""
    result = run_validator(FIXTURES / "spec-duplicate-ac.md")
    assert "Arch-AC1" in result.stdout


# ---------------------------------------------------------------------------
# Check 3: §0 Force Analysis
# ---------------------------------------------------------------------------

def test_missing_section_zero_fails():
    """A spec without §0 Force Analysis should fail."""
    result = run_validator(FIXTURES / "spec-no-section-zero.md")
    assert result.returncode == 1


def test_missing_section_zero_message():
    """Failure message should mention §0."""
    result = run_validator(FIXTURES / "spec-no-section-zero.md")
    assert "§0" in result.stdout or "0" in result.stdout or "Force Analysis" in result.stdout


# ---------------------------------------------------------------------------
# CLI / error handling
# ---------------------------------------------------------------------------

def test_help_flag():
    """--help should print usage and exit 0."""
    result = subprocess.run(
        [sys.executable, str(SCRIPT), "--help"],
        capture_output=True,
        text=True,
    )
    assert result.returncode == 0


def test_missing_arg_exits_nonzero():
    """No argument should exit non-zero."""
    result = subprocess.run(
        [sys.executable, str(SCRIPT)],
        capture_output=True,
        text=True,
    )
    assert result.returncode != 0


def test_nonexistent_file_exits_nonzero(tmp_path):
    """Non-existent file path should exit non-zero."""
    result = run_validator(tmp_path / "does-not-exist.md")
    assert result.returncode != 0


# ---------------------------------------------------------------------------
# Result line format
# ---------------------------------------------------------------------------

def test_result_line_present():
    """Output always ends with a RESULT: line."""
    result = run_validator(FIXTURES / "valid-spec.md")
    assert "RESULT:" in result.stdout


def test_fail_result_line_on_failure():
    """On failure, RESULT line should show failed > 0."""
    result = run_validator(FIXTURES / "spec-duplicate-ac.md")
    assert "RESULT:" in result.stdout
    # Check that it does NOT say "0 failed"
    assert "0 failed" not in result.stdout
