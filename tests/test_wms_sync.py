"""
Integration tests for scripts/wms-sync/ shell scripts (dry-run mode).

All tests run the scripts with --dry-run, verifying output and exit codes
without making any real API calls.
"""
import json
import subprocess
import sys
from pathlib import Path

SCRIPTS_DIR = Path(__file__).parent.parent / "scripts" / "wms-sync"
SYNC_TO_CLICKUP = SCRIPTS_DIR / "sync-to-clickup.sh"
PULL_COMMENTS   = SCRIPTS_DIR / "pull-comments.sh"
SYNC_TO_NOTION  = SCRIPTS_DIR / "sync-to-notion.sh"


# ---------------------------------------------------------------------------
# Fixture helpers
# ---------------------------------------------------------------------------

def make_exec_fixture(tmp_path: Path) -> Path:
    """Create a minimal .exec/ fixture with status.json and one task .md file."""
    exec_dir = tmp_path / ".exec"
    exec_dir.mkdir()

    # status.json
    status = {
        "project": "WMS Sync Test Project",
        "spec_version": "v1",
        "plan_version": "v1",
        "exec_version": "v1",
        "generated_at": "2026-03-22T10:00:00Z",
        "updated_at": "2026-03-22T10:00:00Z",
        "pipeline_stage": "exec_plan",
        "deliverables": {
            "D1": {
                "name": "Foundation",
                "status": "ready",
                "tasks": {
                    "D1-T1": {
                        "name": "Setup Database",
                        "status": "ready",
                        "rework_count": 0,
                        "agent_pattern": "single_agent",
                        "agent_model": "sonnet",
                        "started_at": None,
                        "completed_at": None,
                        "ac_results": {}
                    },
                    "D1-T2": {
                        "name": "Create Schema",
                        "status": "done",
                        "rework_count": 0,
                        "agent_pattern": "single_agent",
                        "agent_model": "sonnet",
                        "started_at": "2026-03-22T09:00:00Z",
                        "completed_at": "2026-03-22T09:30:00Z",
                        "ac_results": {}
                    }
                }
            }
        },
        "rework_log": []
    }
    (exec_dir / "status.json").write_text(json.dumps(status, indent=2))

    # Task file
    d1_dir = exec_dir / "D1-Foundation"
    d1_dir.mkdir()
    (d1_dir / "T1-Setup.md").write_text(
        "# D1-T1: Setup Database\n\n"
        "| Task ID | D1-T1 |\n"
    )
    (d1_dir / "T2-Schema.md").write_text(
        "# D1-T2: Create Schema\n\n"
        "| Task ID | D1-T2 |\n"
    )

    return exec_dir


def make_exec_fixture_with_cache(tmp_path: Path) -> Path:
    """Create .exec/ fixture with a .wms-sync.json cache (simulating prior sync)."""
    exec_dir = make_exec_fixture(tmp_path)

    cache = {
        "items": {
            "D1-T1": {"wms_id": "cu_abc123", "synced_at": "2026-03-22T08:00:00Z"},
            "D1-T2": {"wms_id": "cu_def456", "synced_at": "2026-03-22T08:00:00Z"}
        }
    }
    (exec_dir / ".wms-sync.json").write_text(json.dumps(cache, indent=2))

    return exec_dir


def run_bash(script: Path, *args: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        ["bash", str(script)] + list(args),
        capture_output=True,
        text=True,
    )


# ---------------------------------------------------------------------------
# sync-to-clickup.sh --dry-run
# ---------------------------------------------------------------------------

class TestSyncToClickup:
    def test_dry_run_output_contains_dry_run_header(self, tmp_path):
        """Dry-run output must contain the DRY RUN header (before task enumeration)."""
        exec_dir = make_exec_fixture(tmp_path)
        result = run_bash(SYNC_TO_CLICKUP, str(exec_dir), "--dry-run")
        assert "DRY RUN" in result.stdout

    def test_dry_run_outputs_project_name(self, tmp_path):
        """Dry-run output must include the project name from status.json."""
        exec_dir = make_exec_fixture(tmp_path)
        result = run_bash(SYNC_TO_CLICKUP, str(exec_dir), "--dry-run")
        assert "WMS Sync Test Project" in result.stdout

    def test_dry_run_create_actions_in_script_source(self):
        """Script must contain CREATE output logic for tasks without a cached ID."""
        content = SYNC_TO_CLICKUP.read_text(encoding="utf-8")
        assert "CREATE" in content and "T_ID" in content

    def test_dry_run_update_actions_in_script_source(self):
        """Script must contain UPDATE output logic for tasks with a cached ID."""
        content = SYNC_TO_CLICKUP.read_text(encoding="utf-8")
        assert "UPDATE" in content and "CACHED_ID" in content

    def test_dry_run_status_translation_in_script_source(self):
        """Script must define status translation — ready → ready/prioritized."""
        content = SYNC_TO_CLICKUP.read_text(encoding="utf-8")
        assert "ready/prioritized" in content

    def test_missing_status_json_exits_nonzero(self, tmp_path):
        """Missing status.json should cause non-zero exit."""
        exec_dir = tmp_path / ".exec"
        exec_dir.mkdir()
        result = run_bash(SYNC_TO_CLICKUP, str(exec_dir), "--dry-run")
        assert result.returncode != 0
        assert "ERROR" in result.stderr

    def test_live_mode_script_contains_mcp_action_pattern(self):
        """Script source must define MCP_ACTION output lines for both create and update paths."""
        content = SYNC_TO_CLICKUP.read_text(encoding="utf-8")
        assert "MCP_ACTION: clickup_create_task" in content
        assert "MCP_ACTION: clickup_update_task" in content

    def test_live_mode_create_action_includes_model_tag(self):
        """The clickup_create_task MCP_ACTION line must include model_tag field."""
        content = SYNC_TO_CLICKUP.read_text(encoding="utf-8")
        assert "model_tag=" in content

    def test_live_mode_update_action_includes_cached_id(self):
        """The clickup_update_task MCP_ACTION line must reference the cached ClickUp ID."""
        content = SYNC_TO_CLICKUP.read_text(encoding="utf-8")
        assert "CACHED_ID" in content


# ---------------------------------------------------------------------------
# pull-comments.sh --dry-run
# ---------------------------------------------------------------------------

class TestPullComments:
    def test_dry_run_exits_zero_no_cache(self, tmp_path):
        """Without .wms-sync.json, should exit 0 (nothing to pull)."""
        exec_dir = make_exec_fixture(tmp_path)
        result = run_bash(PULL_COMMENTS, str(exec_dir), "--dry-run")
        assert result.returncode == 0, (
            f"Expected exit 0.\nstdout: {result.stdout}\nstderr: {result.stderr}"
        )

    def test_dry_run_no_cache_info_message(self, tmp_path):
        """Without .wms-sync.json, should print an INFO message."""
        exec_dir = make_exec_fixture(tmp_path)
        result = run_bash(PULL_COMMENTS, str(exec_dir), "--dry-run")
        assert "INFO" in result.stdout

    def test_pull_comments_script_contains_mcp_action_pattern(self):
        """Script source must define MCP_ACTION: clickup_get_task_comments output."""
        content = PULL_COMMENTS.read_text(encoding="utf-8")
        assert "MCP_ACTION: clickup_get_task_comments" in content

    def test_pull_comments_script_contains_dry_run_message(self):
        """Script source must contain a dry-run completion message."""
        content = PULL_COMMENTS.read_text(encoding="utf-8")
        assert "dry-run" in content.lower() or "Dry-run" in content

    def test_pull_comments_script_contains_rework_log_instructions(self):
        """Script must document how to create rework_log entries."""
        content = PULL_COMMENTS.read_text(encoding="utf-8")
        assert "rework_log" in content

    def test_missing_status_json_exits_nonzero(self, tmp_path):
        """Missing status.json should cause non-zero exit."""
        exec_dir = tmp_path / ".exec"
        exec_dir.mkdir()
        result = run_bash(PULL_COMMENTS, str(exec_dir), "--dry-run")
        assert result.returncode != 0


# ---------------------------------------------------------------------------
# sync-to-notion.sh (stub — always exits 0)
# ---------------------------------------------------------------------------

class TestSyncToNotion:
    def test_exits_zero(self):
        """sync-to-notion.sh is a stub and must exit 0."""
        result = run_bash(SYNC_TO_NOTION)
        assert result.returncode == 0, (
            f"Expected exit 0 (stub).\nstdout: {result.stdout}\nstderr: {result.stderr}"
        )

    def test_prints_info_message(self):
        """Stub should print INFO about Iteration 2 deferral."""
        result = run_bash(SYNC_TO_NOTION)
        assert "INFO" in result.stdout or "Notion" in result.stdout

    def test_exits_zero_with_any_arg(self, tmp_path):
        """Stub should exit 0 regardless of arguments (it ignores them)."""
        result = run_bash(SYNC_TO_NOTION, str(tmp_path), "--dry-run")
        assert result.returncode == 0
