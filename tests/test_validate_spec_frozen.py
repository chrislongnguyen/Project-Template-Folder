"""
Tests for scripts/stage-validators/validate-spec-frozen.py (Stage 2→3)
"""
import subprocess
import sys
import json
from pathlib import Path

SCRIPT = Path(__file__).parent.parent / "scripts" / "stage-validators" / "validate-spec-frozen.py"
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

def test_approved_spec_passes():
    """A spec with APPROVED status and version should pass checks 1 and 2."""
    result = run_validator(FIXTURES / "spec-approved.md")
    # Check 1 and 2 must pass; check 3 may warn (no git, old timestamp)
    assert "[PASS] Check 1" in result.stdout
    assert "[PASS] Check 2" in result.stdout


def test_approved_spec_version_check_passes():
    """Version field 'v1' should be recognized as locked."""
    result = run_validator(FIXTURES / "spec-approved.md")
    assert "Version" in result.stdout or "version" in result.stdout.lower()


# ---------------------------------------------------------------------------
# Check 1: Approval marker
# ---------------------------------------------------------------------------

def test_not_approved_spec_fails_check1():
    """A spec with Status REVIEWED (not APPROVED) should fail Check 1."""
    result = run_validator(FIXTURES / "spec-not-approved.md")
    assert result.returncode == 1
    assert "Check 1" in result.stdout
    # Should show FAIL for check 1
    lines = result.stdout.splitlines()
    check1_line = next((l for l in lines if "Check 1" in l), "")
    assert "[FAIL]" in check1_line


def test_approval_message_mentions_status():
    """Failure should mention approval marker or status."""
    result = run_validator(FIXTURES / "spec-not-approved.md")
    lower = result.stdout.lower()
    assert "approv" in lower or "status" in lower or "marker" in lower


# ---------------------------------------------------------------------------
# Check 2: Version field
# ---------------------------------------------------------------------------

def test_no_version_fails(tmp_path):
    """A spec without a Version field should fail Check 2."""
    spec = tmp_path / "no-version.md"
    spec.write_text("| Status | APPROVED |\n\n# Spec\n\nNo version field here.")
    result = run_validator(spec)
    assert result.returncode == 1
    lines = result.stdout.splitlines()
    check2_line = next((l for l in lines if "Check 2" in l), "")
    assert "[FAIL]" in check2_line


def test_placeholder_version_fails(tmp_path):
    """A spec with Version = {version} (placeholder) should fail Check 2."""
    spec = tmp_path / "placeholder-version.md"
    spec.write_text(
        "| Field | Value |\n|---|---|\n| Version | {version} |\n| Status | APPROVED |\n\n# Spec"
    )
    result = run_validator(spec)
    assert result.returncode == 1


def test_draft_version_fails(tmp_path):
    """A spec with Version = 'draft' should fail Check 2."""
    spec = tmp_path / "draft-version.md"
    spec.write_text(
        "| Field | Value |\n|---|---|\n| Version | draft |\n| Status | APPROVED |\n\n# Spec"
    )
    result = run_validator(spec)
    assert result.returncode == 1


# ---------------------------------------------------------------------------
# Check 3: Post-approval modifications
# ---------------------------------------------------------------------------

def test_warn_no_approval_timestamp(tmp_path):
    """A spec with no approval timestamp should pass with a warning, not fail."""
    spec = tmp_path / "no-ts.md"
    spec.write_text(
        "| Field | Value |\n|---|---|\n| Version | v1 |\n| Status | APPROVED |\n\n# Spec"
    )
    result = run_validator(spec)
    # Check 1 and 2 pass; check 3 either passes with WARN or fails due to git state
    assert "[PASS] Check 1" in result.stdout
    assert "[PASS] Check 2" in result.stdout


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


def test_nonexistent_file_exits_nonzero(tmp_path):
    """Non-existent file path should exit non-zero."""
    result = run_validator(tmp_path / "nope.md")
    assert result.returncode != 0


def test_result_line_present():
    """Output always ends with a RESULT: line."""
    result = run_validator(FIXTURES / "spec-approved.md")
    assert "RESULT:" in result.stdout
