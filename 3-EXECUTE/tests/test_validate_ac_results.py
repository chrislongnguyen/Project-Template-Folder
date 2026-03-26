"""
Tests for 3-EXECUTE/tests/quality-gates/stage-validators/validate-ac-results.py (Stage 6→7)
"""
import subprocess
import sys
import json
from pathlib import Path

SCRIPT = Path(__file__).parent / "quality-gates" / "stage-validators" / "validate-ac-results.py"
VALID_EXEC = Path(__file__).parent / "fixtures" / "exec-fixtures" / "valid-exec"
AC_FIXTURES = Path(__file__).parent / "fixtures" / "ac-results-fixtures"


def run_validator(exec_dir: Path) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(SCRIPT), str(exec_dir)],
        capture_output=True,
        text=True,
    )


def make_exec_dir(tmp_path: Path, status: dict, task_files: dict[str, str] | None = None) -> Path:
    """Helper: write status.json and optional task files to a tmp exec dir."""
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    (exec_dir / "status.json").write_text(json.dumps(status))
    if task_files:
        for fname, content in task_files.items():
            (exec_dir / fname).write_text(content)
    return exec_dir


VALID_STATUS = {
    "project": "Test",
    "spec_version": "v1", "plan_version": "v1", "exec_version": "v1",
    "generated_at": "2026-01-01T00:00:00Z", "updated_at": "2026-01-01T00:00:00Z",
    "pipeline_stage": "stage_7",
    "deliverables": {
        "D1": {
            "name": "Foundation", "status": "done",
            "tasks": {
                "D1-T1": {
                    "name": "Setup", "status": "done", "rework_count": 0,
                    "ac_results": {
                        "D1-AC-1": {"eval_type": "Deterministic", "result": "pass", "evidence": "ok"},
                        "D1-AC-2": {"eval_type": "Deterministic", "result": "fail", "evidence": "test failed"},
                    }
                }
            }
        }
    },
    "rework_log": [],
}


# ---------------------------------------------------------------------------
# Happy path
# ---------------------------------------------------------------------------

def test_valid_exec_passes():
    """A .exec/ with all AC results pass/fail and no EVAL_FAILED should pass."""
    result = run_validator(VALID_EXEC)
    assert result.returncode == 0, (
        f"Expected exit 0, got {result.returncode}.\nstdout: {result.stdout}\nstderr: {result.stderr}"
    )


def test_valid_status_passes(tmp_path):
    """status.json with complete pass/fail AC results should pass all checks."""
    exec_dir = make_exec_dir(tmp_path, VALID_STATUS)
    result = run_validator(exec_dir)
    assert result.returncode == 0
    assert "[FAIL]" not in result.stdout


def test_fail_result_is_valid(tmp_path):
    """A 'fail' AC result is still a valid result — should not trigger Check 2 failure."""
    exec_dir = make_exec_dir(tmp_path, VALID_STATUS)
    result = run_validator(exec_dir)
    assert result.returncode == 0


# ---------------------------------------------------------------------------
# Check 1: All ACs have results
# ---------------------------------------------------------------------------

def test_done_task_missing_ac_results_fails(tmp_path):
    """A done task with empty ac_results should fail Check 1."""
    status = {
        **VALID_STATUS,
        "deliverables": {
            "D1": {
                "name": "Foundation", "status": "done",
                "tasks": {
                    "D1-T1": {"name": "Setup", "status": "done", "rework_count": 0, "ac_results": {}}
                }
            }
        }
    }
    exec_dir = make_exec_dir(tmp_path, status)
    result = run_validator(exec_dir)
    assert result.returncode == 1
    lines = result.stdout.splitlines()
    check1 = next((l for l in lines if "Check 1" in l), "")
    assert "[FAIL]" in check1


def test_empty_result_value_fails(tmp_path):
    """An AC result with empty string value should fail Check 1."""
    status_path = AC_FIXTURES / "status-empty-result.json"
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    import shutil
    shutil.copy(status_path, exec_dir / "status.json")
    result = run_validator(exec_dir)
    assert result.returncode == 1


def test_no_ac_results_at_all_fails(tmp_path):
    """status.json with zero AC results should fail."""
    status_path = AC_FIXTURES / "status-no-results.json"
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    import shutil
    shutil.copy(status_path, exec_dir / "status.json")
    result = run_validator(exec_dir)
    assert result.returncode == 1


# ---------------------------------------------------------------------------
# Check 2: Results are pass or fail
# ---------------------------------------------------------------------------

def test_invalid_result_value_fails(tmp_path):
    """An AC result with value 'unknown' should fail Check 2."""
    status_path = AC_FIXTURES / "status-invalid-result.json"
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    import shutil
    shutil.copy(status_path, exec_dir / "status.json")
    result = run_validator(exec_dir)
    assert result.returncode == 1
    lines = result.stdout.splitlines()
    check2 = next((l for l in lines if "Check 2" in l), "")
    assert "[FAIL]" in check2


def test_invalid_result_names_the_ac(tmp_path):
    """Failure message should name the AC with invalid result."""
    status_path = AC_FIXTURES / "status-invalid-result.json"
    exec_dir = tmp_path / "exec"
    exec_dir.mkdir()
    import shutil
    shutil.copy(status_path, exec_dir / "status.json")
    result = run_validator(exec_dir)
    assert "D1-AC-1" in result.stdout


def test_null_result_fails(tmp_path):
    """An AC result with null (None) value should fail."""
    status = {
        **VALID_STATUS,
        "deliverables": {
            "D1": {
                "name": "Foundation", "status": "done",
                "tasks": {
                    "D1-T1": {
                        "name": "Setup", "status": "done", "rework_count": 0,
                        "ac_results": {
                            "D1-AC-1": {"eval_type": "Deterministic", "result": None, "evidence": ""}
                        }
                    }
                }
            }
        }
    }
    exec_dir = make_exec_dir(tmp_path, status)
    result = run_validator(exec_dir)
    assert result.returncode == 1


# ---------------------------------------------------------------------------
# Check 3: [EVAL_FAILED] tags
# ---------------------------------------------------------------------------

def test_eval_failed_tag_fails(tmp_path):
    """An [EVAL_FAILED] tag in a task file should fail Check 3."""
    exec_dir = make_exec_dir(tmp_path, VALID_STATUS, {
        "D1-T1-setup.md": "[EVAL_FAILED] — output format wrong\n"
    })
    result = run_validator(exec_dir)
    assert result.returncode == 1
    lines = result.stdout.splitlines()
    check3 = next((l for l in lines if "Check 3" in l), "")
    assert "[FAIL]" in check3


def test_eval_failed_with_human_review_also_fails(tmp_path):
    """[EVAL_FAILED] + [HUMAN_REVIEW] should still fail — tag not resolved."""
    exec_dir = make_exec_dir(tmp_path, VALID_STATUS, {
        "D1-T1-setup.md": "[EVAL_FAILED] — bad output\n[HUMAN_REVIEW] — escalated\n"
    })
    result = run_validator(exec_dir)
    assert result.returncode == 1


def test_no_eval_failed_tags_passes(tmp_path):
    """No [EVAL_FAILED] tags means Check 3 passes."""
    exec_dir = make_exec_dir(tmp_path, VALID_STATUS, {
        "D1-T1-setup.md": "# Setup\n\nTask completed successfully.\n"
    })
    result = run_validator(exec_dir)
    assert result.returncode == 0


def test_eval_failed_in_subdirectory(tmp_path):
    """[EVAL_FAILED] in a nested subdirectory file should be detected."""
    exec_dir = make_exec_dir(tmp_path, VALID_STATUS)
    subdir = exec_dir / "D1-Foundation"
    subdir.mkdir()
    (subdir / "D1-T1-task.md").write_text("[EVAL_FAILED] nested\n")
    result = run_validator(exec_dir)
    assert result.returncode == 1


# ---------------------------------------------------------------------------
# Missing status.json
# ---------------------------------------------------------------------------

def test_missing_status_json_exits_nonzero(tmp_path):
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


def test_result_line_present(tmp_path):
    exec_dir = make_exec_dir(tmp_path, VALID_STATUS)
    result = run_validator(exec_dir)
    assert "RESULT:" in result.stdout
