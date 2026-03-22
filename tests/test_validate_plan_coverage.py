"""
Tests for scripts/stage-validators/validate-plan-coverage.py (Stage 3→4)
"""
import subprocess
import sys
from pathlib import Path

SCRIPT = Path(__file__).parent.parent / "scripts" / "stage-validators" / "validate-plan-coverage.py"
FIXTURES = Path(__file__).parent / "fixtures" / "plan-fixtures"


def run_validator(plan_path: Path) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(SCRIPT), str(plan_path)],
        capture_output=True,
        text=True,
    )


# ---------------------------------------------------------------------------
# Happy path
# ---------------------------------------------------------------------------

def test_valid_plan_passes():
    """A plan with HOW NOT, agent arch, AC coverage should pass."""
    result = run_validator(FIXTURES / "valid-plan.md")
    assert result.returncode == 0, (
        f"Expected exit 0, got {result.returncode}.\nstdout: {result.stdout}\nstderr: {result.stderr}"
    )


def test_valid_plan_all_checks_pass():
    """All checks should show PASS for a valid plan."""
    result = run_validator(FIXTURES / "valid-plan.md")
    assert "[PASS]" in result.stdout
    assert "[FAIL]" not in result.stdout


# ---------------------------------------------------------------------------
# Check 3: Tasks per deliverable < 7
# ---------------------------------------------------------------------------

def test_too_many_tasks_fails():
    """A deliverable with 7 tasks should fail Check 3."""
    result = run_validator(FIXTURES / "plan-too-many-tasks.md")
    assert result.returncode == 1
    lower = result.stdout.lower()
    assert "task" in lower


def test_too_many_tasks_names_deliverable():
    """Failure should name the offending deliverable."""
    result = run_validator(FIXTURES / "plan-too-many-tasks.md")
    assert "D1" in result.stdout


# ---------------------------------------------------------------------------
# Check 4: HOW NOT sections
# ---------------------------------------------------------------------------

def test_missing_how_not_fails():
    """A plan where D1 lacks a HOW NOT section should fail Check 4."""
    result = run_validator(FIXTURES / "plan-missing-how-not.md")
    assert result.returncode == 1
    lower = result.stdout.lower()
    assert "how not" in lower


def test_missing_how_not_names_deliverable():
    """Failure message should name the deliverable missing HOW NOT."""
    result = run_validator(FIXTURES / "plan-missing-how-not.md")
    assert "D1" in result.stdout


# ---------------------------------------------------------------------------
# Check 2: Orphan tasks (inline fixture)
# ---------------------------------------------------------------------------

def test_orphan_task_fails(tmp_path):
    """A task with no AC mapping should fail Check 2."""
    plan = tmp_path / "orphan-plan.md"
    plan.write_text(
        "# Plan\n\n## D1: Test\n\n**HOW:** Do stuff.\n\n**HOW NOT:**\n- Do NOT skip\n\n"
        "**Agent Architecture:** Single Agent\n\n### Task 1\n\nNo AC reference here.\n"
    )
    result = run_validator(plan)
    assert result.returncode == 1
    lower = result.stdout.lower()
    assert "orphan" in lower or "no ac" in lower or "ac mapping" in lower


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
    result = subprocess.run(
        [sys.executable, str(SCRIPT)],
        capture_output=True, text=True,
    )
    assert result.returncode != 0


def test_nonexistent_file_exits_nonzero(tmp_path):
    result = run_validator(tmp_path / "nope.md")
    assert result.returncode != 0


def test_result_line_present():
    result = run_validator(FIXTURES / "valid-plan.md")
    assert "RESULT:" in result.stdout
