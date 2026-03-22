"""
Tests for scripts/generate-review-package.py

Uses a fixture .exec/ directory at tests/fixtures/review-package-exec/
"""
import subprocess
import json
import sys
from pathlib import Path

SCRIPT = Path(__file__).parent.parent / "scripts" / "generate-review-package.py"
FIXTURE_DIR = Path(__file__).parent / "fixtures" / "review-package-exec"
MISSING_STATUS_DIR = Path(__file__).parent / "fixtures" / "review-package-missing"


def run_script(path: Path) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(SCRIPT), str(path)],
        capture_output=True,
        text=True,
    )


# ---------------------------------------------------------------------------
# Happy path
# ---------------------------------------------------------------------------

def test_valid_exec_dir_exits_zero():
    """Script should exit 0 for a valid .exec/ directory."""
    result = run_script(FIXTURE_DIR)
    assert result.returncode == 0, f"Expected exit 0, got {result.returncode}. stderr: {result.stderr}"


def test_output_contains_project_name():
    """Review package header should include the project name from status.json."""
    result = run_script(FIXTURE_DIR)
    assert "LTC Execution Pipeline" in result.stdout


def test_output_contains_summary_section():
    """Review package must have a Summary section."""
    result = run_script(FIXTURE_DIR)
    assert "## Summary" in result.stdout


def test_output_contains_ac_results_section():
    """Review package must have an AC Results section."""
    result = run_script(FIXTURE_DIR)
    assert "## AC Results" in result.stdout


def test_output_contains_deliverable_status_section():
    """Review package must have a Deliverable Status section."""
    result = run_script(FIXTURE_DIR)
    assert "## Deliverable Status" in result.stdout


def test_output_contains_rework_history_section():
    """Review package must have a Rework History section."""
    result = run_script(FIXTURE_DIR)
    assert "## Rework History" in result.stdout


def test_output_contains_risk_flags_section():
    """Review package must have a Risk Flags section."""
    result = run_script(FIXTURE_DIR)
    assert "## Risk Flags" in result.stdout


def test_output_contains_human_director_decision():
    """Review package must include Human Director decision checkboxes."""
    result = run_script(FIXTURE_DIR)
    output = result.stdout
    assert "Human Director Decision" in output
    assert "- [ ] Approved" in output
    assert "- [ ] Code changes needed" in output
    assert "- [ ] Plan is wrong" in output
    assert "- [ ] Spec is wrong" in output


def test_pass_rate_computed_correctly():
    """3 tasks total, all done → 100%."""
    result = run_script(FIXTURE_DIR)
    assert "100%" in result.stdout


def test_rework_history_contains_entry():
    """Fixture has 1 rework log entry — it should appear in the output."""
    result = run_script(FIXTURE_DIR)
    assert "D1-T2" in result.stdout
    assert "rework" in result.stdout.lower()


def test_rework_count_flagged_in_risk():
    """D1-T2 has rework_count=1 — it should appear in Risk Flags."""
    result = run_script(FIXTURE_DIR)
    assert "D1-T2" in result.stdout


def test_ac_results_rows_present():
    """AC result entries from the fixture should be in the output table."""
    result = run_script(FIXTURE_DIR)
    assert "D1-AC-1" in result.stdout
    assert "D2-AC-1" in result.stdout


# ---------------------------------------------------------------------------
# Error handling
# ---------------------------------------------------------------------------

def test_missing_status_json_exits_nonzero(tmp_path):
    """Script should exit non-zero if status.json is missing."""
    result = run_script(tmp_path)
    assert result.returncode != 0
    assert "ERROR" in result.stderr


def test_nonexistent_dir_exits_nonzero(tmp_path):
    """Script should exit non-zero for a path that doesn't exist."""
    bad_path = tmp_path / "does_not_exist"
    result = run_script(bad_path)
    assert result.returncode != 0


def test_help_flag_exits_zero():
    """--help flag should print usage and exit 0."""
    result = subprocess.run(
        [sys.executable, str(SCRIPT), "--help"],
        capture_output=True, text=True,
    )
    assert result.returncode == 0


# ---------------------------------------------------------------------------
# Risk tag detection
# ---------------------------------------------------------------------------

def test_incomplete_tag_detected(tmp_path):
    """[INCOMPLETE] tag in a .md file should appear in Risk Flags."""
    exec_dir = tmp_path / ".exec"
    exec_dir.mkdir()

    # Write a minimal status.json
    status = {
        "project": "Test",
        "spec_version": "v1",
        "plan_version": "v1",
        "exec_version": "v1",
        "generated_at": "2026-01-01T00:00:00Z",
        "updated_at": "2026-01-01T00:00:00Z",
        "pipeline_stage": "review",
        "deliverables": {},
        "rework_log": [],
    }
    (exec_dir / "status.json").write_text(json.dumps(status))
    # Write a .md file with the risk tag
    (exec_dir / "task.md").write_text("## Output\n[INCOMPLETE] — missing section\n")

    result = run_script(exec_dir)
    assert result.returncode == 0
    assert "INCOMPLETE" in result.stdout
