"""
Tests for scripts/stage-validators/validate-outputs-exist.py (Stage 5→6)
"""
import subprocess
import sys
import json
from pathlib import Path

SCRIPT = Path(__file__).parent.parent / "scripts" / "stage-validators" / "validate-outputs-exist.py"
DONE_EXEC = Path(__file__).parent / "fixtures" / "exec-fixtures" / "done-exec"


def run_validator(exec_dir: Path) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(SCRIPT), str(exec_dir)],
        capture_output=True,
        text=True,
    )


# ---------------------------------------------------------------------------
# Happy path
# ---------------------------------------------------------------------------

def test_all_done_exec_passes():
    """A .exec/ dir with all tasks done and no [INCOMPLETE] tags should pass."""
    result = run_validator(DONE_EXEC)
    assert result.returncode == 0, (
        f"Expected exit 0, got {result.returncode}.\nstdout: {result.stdout}\nstderr: {result.stderr}"
    )


def test_done_exec_check1_passes():
    """Check 1 should pass when all tasks are 'done'."""
    result = run_validator(DONE_EXEC)
    lines = result.stdout.splitlines()
    check1 = next((l for l in lines if "Check 1" in l), "")
    assert "[PASS]" in check1


def test_done_exec_check2_passes():
    """Check 2 should pass when no [INCOMPLETE] tags are present."""
    result = run_validator(DONE_EXEC)
    lines = result.stdout.splitlines()
    check2 = next((l for l in lines if "Check 2" in l), "")
    assert "[PASS]" in check2


# ---------------------------------------------------------------------------
# Check 1: All tasks done
# ---------------------------------------------------------------------------

def test_not_done_task_fails(tmp_path):
    """A task with status != 'done' should fail Check 1."""
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    status = {
        "project": "Test",
        "spec_version": "v1",
        "plan_version": "v1",
        "exec_version": "v1",
        "generated_at": "2026-01-01T00:00:00Z",
        "updated_at": "2026-01-01T00:00:00Z",
        "pipeline_stage": "stage_5",
        "deliverables": {
            "D1": {
                "name": "Foundation",
                "status": "in_progress",
                "tasks": {
                    "D1-T1": {"name": "Setup", "status": "in_progress", "rework_count": 0, "ac_results": {}},
                    "D1-T2": {"name": "Templates", "status": "done", "rework_count": 0, "ac_results": {}},
                },
            }
        },
        "rework_log": [],
    }
    (exec_dir / "status.json").write_text(json.dumps(status))

    result = run_validator(exec_dir)
    assert result.returncode == 1
    lines = result.stdout.splitlines()
    check1 = next((l for l in lines if "Check 1" in l), "")
    assert "[FAIL]" in check1


def test_not_done_task_names_task(tmp_path):
    """Failure message should name the not-done task."""
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    status = {
        "project": "Test",
        "spec_version": "v1", "plan_version": "v1", "exec_version": "v1",
        "generated_at": "2026-01-01T00:00:00Z", "updated_at": "2026-01-01T00:00:00Z",
        "pipeline_stage": "stage_5",
        "deliverables": {
            "D1": {
                "name": "Foundation", "status": "in_progress",
                "tasks": {
                    "D1-T1": {"name": "Setup", "status": "rework", "rework_count": 1, "ac_results": {}},
                }
            }
        },
        "rework_log": [],
    }
    (exec_dir / "status.json").write_text(json.dumps(status))
    result = run_validator(exec_dir)
    assert "D1-T1" in result.stdout


# ---------------------------------------------------------------------------
# Check 2: [INCOMPLETE] tags
# ---------------------------------------------------------------------------

def test_incomplete_tag_fails(tmp_path):
    """An [INCOMPLETE] tag in a task file should fail Check 2."""
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    # Valid status (all done)
    status = {
        "project": "Test",
        "spec_version": "v1", "plan_version": "v1", "exec_version": "v1",
        "generated_at": "2026-01-01T00:00:00Z", "updated_at": "2026-01-01T00:00:00Z",
        "pipeline_stage": "stage_5",
        "deliverables": {
            "D1": {
                "name": "Foundation", "status": "done",
                "tasks": {"D1-T1": {"name": "Setup", "status": "done", "rework_count": 0, "ac_results": {}}}
            }
        },
        "rework_log": [],
    }
    (exec_dir / "status.json").write_text(json.dumps(status))
    # Task file with [INCOMPLETE]
    d1_dir = exec_dir / "D1-Foundation"
    d1_dir.mkdir()
    (d1_dir / "D1-T1-setup.md").write_text(
        "# D1-T1: Setup\n\n[INCOMPLETE] — needs more work\n"
    )

    result = run_validator(exec_dir)
    assert result.returncode == 1
    lines = result.stdout.splitlines()
    check2 = next((l for l in lines if "Check 2" in l), "")
    assert "[FAIL]" in check2


def test_incomplete_tag_case_insensitive(tmp_path):
    """[incomplete] tag (lowercase) should also be detected."""
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    status = {
        "project": "Test",
        "spec_version": "v1", "plan_version": "v1", "exec_version": "v1",
        "generated_at": "2026-01-01T00:00:00Z", "updated_at": "2026-01-01T00:00:00Z",
        "pipeline_stage": "stage_5",
        "deliverables": {
            "D1": {
                "name": "Foundation", "status": "done",
                "tasks": {"D1-T1": {"name": "Setup", "status": "done", "rework_count": 0, "ac_results": {}}}
            }
        },
        "rework_log": [],
    }
    (exec_dir / "status.json").write_text(json.dumps(status))
    (exec_dir / "D1-T1-note.md").write_text("[incomplete] tag here")
    result = run_validator(exec_dir)
    assert result.returncode == 1


# ---------------------------------------------------------------------------
# Missing status.json
# ---------------------------------------------------------------------------

def test_missing_status_json_exits_nonzero(tmp_path):
    """Missing status.json should exit non-zero with an error."""
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    result = run_validator(exec_dir)
    assert result.returncode != 0
    assert "ERROR" in result.stderr


# ---------------------------------------------------------------------------
# CLI / error handling
# ---------------------------------------------------------------------------

def test_help_flag():
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


def test_not_a_directory_exits_nonzero(tmp_path):
    f = tmp_path / "notadir.md"
    f.write_text("hello")
    result = run_validator(f)
    assert result.returncode != 0


def test_result_line_present():
    result = run_validator(DONE_EXEC)
    assert "RESULT:" in result.stdout
