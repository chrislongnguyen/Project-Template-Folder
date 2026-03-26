"""
Tests for 3-EXECUTE/scripts/run-deterministic-evals.py (Stage 6 Eval Runner).

Fixture layout (3-EXECUTE/tests/fixtures/eval-exec/):
  status.json          — 4 tasks: D1-T1 (done/pass), D1-T2 (done/fail),
                         D1-T3 (done/manual+ai), D1-T4 (ready/skip)
  D1-EvalTest/
    T1-PassingAC.md    — references EVAL-AC1 (Deterministic, grader=true)
    T2-FailingAC.md    — references EVAL-AC2 (Deterministic, grader=false)
    T3-ManualAC.md     — references EVAL-AC3 (Manual) + EVAL-AC4 (AI-Graded)

3-EXECUTE/tests/fixtures/eval-spec.md — AC-TEST-MAP with all 4 ACs
"""

import json
import shutil
import tempfile
from pathlib import Path

import pytest

# Paths relative to repo root (tests run from repo root via pytest)
REPO_ROOT = Path(__file__).parent.parent.parent
SCRIPT = REPO_ROOT / "3-EXECUTE" / "scripts" / "run-deterministic-evals.py"
EVAL_EXEC = Path(__file__).parent / "fixtures" / "eval-exec"
EVAL_SPEC = Path(__file__).parent / "fixtures" / "eval-spec.md"


# ---------------------------------------------------------------------------
# Helpers — import the script's functions directly for unit tests
# ---------------------------------------------------------------------------

import importlib.util, sys

def _load_script():
    """Import run-deterministic-evals.py as a module."""
    spec = importlib.util.spec_from_file_location("run_det_evals", SCRIPT)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


@pytest.fixture(scope="module")
def mod():
    return _load_script()


@pytest.fixture()
def temp_exec(tmp_path):
    """
    Copy the eval-exec fixture into a temp directory so tests can mutate
    status.json without affecting the source fixture.
    """
    dest = tmp_path / ".exec"
    shutil.copytree(EVAL_EXEC, dest)
    return dest


# ---------------------------------------------------------------------------
# Unit tests — parse_ac_test_map
# ---------------------------------------------------------------------------

class TestParseAcTestMap:
    def test_loads_four_acs(self, mod):
        ac_map = mod.parse_ac_test_map(EVAL_SPEC)
        assert len(ac_map) == 4

    def test_deterministic_ac_has_grader(self, mod):
        ac_map = mod.parse_ac_test_map(EVAL_SPEC)
        assert ac_map["EVAL-AC1"]["eval_type"] == "Deterministic"
        assert ac_map["EVAL-AC1"]["grader"] == "true"

    def test_failing_ac_grader_is_false(self, mod):
        ac_map = mod.parse_ac_test_map(EVAL_SPEC)
        assert ac_map["EVAL-AC2"]["grader"] == "false"

    def test_manual_ac_eval_type(self, mod):
        ac_map = mod.parse_ac_test_map(EVAL_SPEC)
        assert ac_map["EVAL-AC3"]["eval_type"] == "Manual"

    def test_ai_graded_ac_eval_type(self, mod):
        ac_map = mod.parse_ac_test_map(EVAL_SPEC)
        assert ac_map["EVAL-AC4"]["eval_type"] == "AI-Graded"

    def test_missing_spec_raises_file_not_found(self, mod, tmp_path):
        import pytest
        with pytest.raises(FileNotFoundError):
            mod.parse_ac_test_map(tmp_path / "nonexistent.md")

    def test_spec_without_ac_test_map_returns_empty(self, mod, tmp_path):
        spec = tmp_path / "empty-spec.md"
        spec.write_text("# VANA-SPEC\n\n## §1 System Identity\n\nNo AC map here.\n")
        ac_map = mod.parse_ac_test_map(spec)
        assert ac_map == {}


# ---------------------------------------------------------------------------
# Unit tests — extract_ac_ids_from_task
# ---------------------------------------------------------------------------

class TestExtractAcIds:
    def test_extracts_passing_ac(self, mod):
        task_path = EVAL_EXEC / "D1-EvalTest" / "T1-PassingAC.md"
        ids = mod.extract_ac_ids_from_task(task_path)
        assert ids == ["EVAL-AC1"]

    def test_extracts_failing_ac(self, mod):
        task_path = EVAL_EXEC / "D1-EvalTest" / "T2-FailingAC.md"
        ids = mod.extract_ac_ids_from_task(task_path)
        assert ids == ["EVAL-AC2"]

    def test_extracts_multiple_acs(self, mod):
        task_path = EVAL_EXEC / "D1-EvalTest" / "T3-ManualAC.md"
        ids = mod.extract_ac_ids_from_task(task_path)
        assert "EVAL-AC3" in ids
        assert "EVAL-AC4" in ids

    def test_missing_file_returns_empty(self, mod, tmp_path):
        ids = mod.extract_ac_ids_from_task(tmp_path / "missing.md")
        assert ids == []

    def test_file_without_traceability_table_returns_empty(self, mod, tmp_path):
        f = tmp_path / "no-table.md"
        f.write_text("# Task\n\nNo traceability table here.\n")
        ids = mod.extract_ac_ids_from_task(f)
        assert ids == []


# ---------------------------------------------------------------------------
# Unit tests — run_grader
# ---------------------------------------------------------------------------

class TestRunGrader:
    def test_passing_grader(self, mod):
        result, evidence = mod.run_grader("true", dry_run=False)
        assert result == "pass"

    def test_failing_grader(self, mod):
        result, evidence = mod.run_grader("false", dry_run=False)
        assert result == "fail"

    def test_dry_run_does_not_execute(self, mod):
        # Use 'false' — if dry_run works, it should NOT mark as fail
        result, evidence = mod.run_grader("false", dry_run=True)
        assert result == "[DRY_RUN]"
        assert "false" in evidence

    def test_invalid_command_marks_eval_failed(self, mod):
        result, evidence = mod.run_grader(
            "__nonexistent_command_that_does_not_exist__", dry_run=False
        )
        # Shell can't find the command — either fail (non-zero exit) or EVAL_FAILED
        assert result in ("fail", "[EVAL_FAILED]")


# ---------------------------------------------------------------------------
# Integration tests — evaluate_exec_dir
# ---------------------------------------------------------------------------

class TestEvaluateExecDir:
    def test_passing_eval_writes_pass(self, mod, temp_exec):
        """D1-T1 has EVAL-AC1 (grader=true) — should be marked 'pass'."""
        rc = mod.evaluate_exec_dir(temp_exec, EVAL_SPEC, dry_run=False, verbose=False)
        assert rc == 0

        status = json.loads((temp_exec / "status.json").read_text())
        t1_results = status["deliverables"]["D1"]["tasks"]["D1-T1"]["ac_results"]
        assert "EVAL-AC1" in t1_results
        assert t1_results["EVAL-AC1"]["result"] == "pass"

    def test_failing_eval_marks_rework(self, mod, temp_exec):
        """D1-T2 has EVAL-AC2 (grader=false) — task should be demoted to rework."""
        mod.evaluate_exec_dir(temp_exec, EVAL_SPEC, dry_run=False, verbose=False)

        status = json.loads((temp_exec / "status.json").read_text())
        t2 = status["deliverables"]["D1"]["tasks"]["D1-T2"]
        assert t2["status"] == "rework", "Task with failing AC should be set to rework"
        t2_results = t2["ac_results"]
        assert t2_results["EVAL-AC2"]["result"] == "fail"

    def test_failing_eval_adds_rework_log_entry(self, mod, temp_exec):
        """A rework_log entry should be added for the demoted task."""
        mod.evaluate_exec_dir(temp_exec, EVAL_SPEC, dry_run=False, verbose=False)

        status = json.loads((temp_exec / "status.json").read_text())
        rework_log = status.get("rework_log", [])
        task_ids_in_log = [e["task_id"] for e in rework_log]
        assert "D1-T2" in task_ids_in_log

    def test_manual_eval_skipped(self, mod, temp_exec):
        """D1-T3 has EVAL-AC3 (Manual) — should be marked [MANUAL], not evaluated."""
        mod.evaluate_exec_dir(temp_exec, EVAL_SPEC, dry_run=False, verbose=False)

        status = json.loads((temp_exec / "status.json").read_text())
        t3_results = status["deliverables"]["D1"]["tasks"]["D1-T3"]["ac_results"]
        assert t3_results["EVAL-AC3"]["result"] == "[MANUAL]"

    def test_ai_graded_eval_deferred(self, mod, temp_exec):
        """D1-T3 also has EVAL-AC4 (AI-Graded) — should be marked [DEFERRED_ITER2]."""
        mod.evaluate_exec_dir(temp_exec, EVAL_SPEC, dry_run=False, verbose=False)

        status = json.loads((temp_exec / "status.json").read_text())
        t3_results = status["deliverables"]["D1"]["tasks"]["D1-T3"]["ac_results"]
        assert t3_results["EVAL-AC4"]["result"] == "[DEFERRED_ITER2]"

    def test_not_done_task_skipped(self, mod, temp_exec):
        """D1-T4 is 'ready' — should not be evaluated."""
        mod.evaluate_exec_dir(temp_exec, EVAL_SPEC, dry_run=False, verbose=False)

        status = json.loads((temp_exec / "status.json").read_text())
        t4 = status["deliverables"]["D1"]["tasks"]["D1-T4"]
        assert t4["status"] == "ready"
        assert t4["ac_results"] == {}

    def test_manual_task_not_demoted_to_rework(self, mod, temp_exec):
        """D1-T3's manual/ai ACs should NOT trigger rework (not a deterministic failure)."""
        mod.evaluate_exec_dir(temp_exec, EVAL_SPEC, dry_run=False, verbose=False)

        status = json.loads((temp_exec / "status.json").read_text())
        t3 = status["deliverables"]["D1"]["tasks"]["D1-T3"]
        assert t3["status"] == "done", "Manual ACs should not demote task to rework"

    def test_dry_run_does_not_modify_status(self, mod, temp_exec):
        """--dry-run should not write any changes to status.json."""
        original = (temp_exec / "status.json").read_text()
        mod.evaluate_exec_dir(temp_exec, EVAL_SPEC, dry_run=True, verbose=False)
        after = (temp_exec / "status.json").read_text()
        assert original == after, "dry-run should not modify status.json"

    def test_eval_script_failure_marks_eval_failed(self, mod, temp_exec, tmp_path):
        """
        If the grader command cannot be found / crashes, the AC should be
        marked [EVAL_FAILED] rather than silently passing or raising.
        """
        # Create a spec with an impossible grader
        bad_spec = tmp_path / "bad-spec.md"
        bad_spec.write_text(
            "# VANA-SPEC: Bad Grader Test\n\n"
            "## §7 AC-TEST-MAP (G1: Eval Specification)\n\n"
            "| A.C. ID | VANA Word | VANA Source | Eval Type | Dataset Description | Grader Description | Threshold |\n"
            "|---------|-----------|-------------|-----------|--------------------|--------------------|----------|\n"
            "| EVAL-AC1 | Exists | §2 | Deterministic | n/a | __this_grader_does_not_exist_at_all__ | exit 0 |\n\n"
        )
        mod.evaluate_exec_dir(temp_exec, bad_spec, dry_run=False, verbose=False)

        status = json.loads((temp_exec / "status.json").read_text())
        t1_results = status["deliverables"]["D1"]["tasks"]["D1-T1"]["ac_results"]
        # Should be fail (shell's "command not found" exits 127) or [EVAL_FAILED]
        assert t1_results["EVAL-AC1"]["result"] in ("fail", "[EVAL_FAILED]")

    def test_missing_status_json_returns_error_code(self, mod, tmp_path):
        """Missing status.json should return exit code 1."""
        rc = mod.evaluate_exec_dir(tmp_path, EVAL_SPEC, dry_run=False, verbose=False)
        assert rc == 1

    def test_returns_zero_on_success(self, mod, temp_exec):
        """Script should return 0 even when some ACs fail (failures are recorded, not raised)."""
        rc = mod.evaluate_exec_dir(temp_exec, EVAL_SPEC, dry_run=False, verbose=False)
        assert rc == 0
