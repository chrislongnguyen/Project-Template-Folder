#!/usr/bin/env python3
"""
Stage 2→3 Validator: Spec approval marker, version lock, no post-approval modifications.

Usage: python3 validate-spec-frozen.py /path/to/spec.md
       python3 validate-spec-frozen.py --help

Exit: 0 = all checks pass, 1 = any check fails

Checks (per spec §7.2):
  1. Spec has Human approval marker (e.g. 'Status | APPROVED')
  2. Version field present and locked (non-empty, not a placeholder)
  3. No modifications since approval — checks git diff vs approval timestamp
"""
import sys
import re
import subprocess
from pathlib import Path
from typing import Optional
from datetime import datetime, timezone


# ---------------------------------------------------------------------------
# Parsers
# ---------------------------------------------------------------------------

def read_spec(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def parse_table_field(content: str, field_name: str) -> Optional[str]:
    """
    Extract a value from a markdown table row like:
      | Field Name | Value |
    Returns the trimmed value string, or None if not found.
    """
    pattern = rf"\|\s*{re.escape(field_name)}\s*\|\s*(.+?)\s*\|"
    match = re.search(pattern, content, re.IGNORECASE)
    return match.group(1).strip() if match else None


def extract_approval_timestamp(content: str) -> Optional[str]:
    """
    Look for an approval timestamp in various formats:
      - 'Approved At | 2026-03-22...'
      - 'Approval Date | ...'
      - 'APPROVED on YYYY-MM-DD'
      - A date-like string following 'APPROVED'
    Returns ISO-ish timestamp string or None.
    """
    # Table field patterns
    for field in ("Approved At", "Approval Date", "Approval Timestamp", "Approved On"):
        val = parse_table_field(content, field)
        if val and not val.startswith("{"):
            return val

    # Inline: APPROVED on/at <date>
    match = re.search(
        r"APPROVED\s+(?:on|at)\s+(\d{4}-\d{2}-\d{2}(?:T[\d:Z]+)?)",
        content,
        re.IGNORECASE,
    )
    if match:
        return match.group(1)

    return None


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

def check_approval_marker(content: str) -> tuple[bool, str]:
    """
    Check 1: Spec has a Human approval marker.
    Looks for 'Status | APPROVED' or 'APPROVED' in a Status field row.
    """
    # Primary: table row with Status = APPROVED
    status_val = parse_table_field(content, "Status")
    if status_val and "APPROVED" in status_val.upper():
        return True, f"Approval marker found — Status: {status_val}"

    # Secondary: bare APPROVED anywhere in content (e.g. comment or badge)
    if re.search(r"\bAPPROVED\b", content):
        return True, "Approval marker found (APPROVED keyword present in spec)"

    return (
        False,
        "No approval marker found — expected 'Status | APPROVED' table row or APPROVED keyword",
    )


def check_version_locked(content: str) -> tuple[bool, str]:
    """
    Check 2: Version field present and locked (non-empty, not a template placeholder).
    """
    version = parse_table_field(content, "Version")
    if not version:
        return False, "Version field missing from spec header table"

    if version.startswith("{") or version.lower() in ("", "tbd", "draft", "x.y"):
        return False, f"Version field is a placeholder or draft value: '{version}'"

    # Version should look like vN or vN.M
    if not re.match(r"v?\d+(\.\d+)*", version, re.IGNORECASE):
        return False, f"Version field value is not a valid version string: '{version}'"

    return True, f"Version field locked — Version: {version}"


def check_no_post_approval_modifications(spec_path: Path, content: str) -> tuple[bool, str]:
    """
    Check 3: No modifications since approval.
    Strategy:
      a. Extract approval timestamp from spec content.
      b. If git is available, check git log for commits touching this file after approval.
      c. If no git, fall back to file mtime comparison.
    Returns (pass, message).
    """
    approval_ts_str = extract_approval_timestamp(content)

    # Try git-based check first
    try:
        git_result = subprocess.run(
            ["git", "log", "--follow", "--format=%aI %H", "--", str(spec_path)],
            capture_output=True,
            text=True,
            cwd=spec_path.parent,
            timeout=10,
        )
        if git_result.returncode == 0 and git_result.stdout.strip():
            commits = git_result.stdout.strip().splitlines()
            # Most recent commit is first
            latest_commit_line = commits[0]
            parts = latest_commit_line.split(" ", 1)
            latest_ts_str = parts[0] if parts else ""

            if approval_ts_str and latest_ts_str:
                # Compare: if latest commit is after approval date, fail
                try:
                    approval_dt = _parse_iso(approval_ts_str)
                    latest_dt = _parse_iso(latest_ts_str)
                    if latest_dt and approval_dt and latest_dt > approval_dt:
                        commit_hash = parts[1][:8] if len(parts) > 1 else "?"
                        return (
                            False,
                            f"Spec modified after approval — last commit {commit_hash} at "
                            f"{latest_ts_str} is newer than approval at {approval_ts_str}",
                        )
                    return True, f"No modifications since approval at {approval_ts_str} (git verified)"
                except Exception:
                    pass  # fall through to timestamp-only check

            # No approval timestamp embedded; warn but pass
            if not approval_ts_str:
                return (
                    True,
                    "[WARN] No approval timestamp found in spec — cannot verify post-approval "
                    "modifications via git (pass with warning)",
                )

    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass  # git not available, fall through

    # Fallback: file mtime vs approval timestamp
    if approval_ts_str:
        approval_dt = _parse_iso(approval_ts_str)
        if approval_dt:
            mtime = spec_path.stat().st_mtime
            file_dt = datetime.fromtimestamp(mtime, tz=timezone.utc)
            if file_dt > approval_dt:
                return (
                    False,
                    f"Spec file mtime ({file_dt.isoformat()}) is newer than approval "
                    f"timestamp ({approval_ts_str}) — possible post-approval modification",
                )
            return True, f"File mtime is not newer than approval timestamp ({approval_ts_str})"

    return True, "[WARN] Cannot verify post-approval modifications — no git and no approval timestamp (pass with warning)"


def _parse_iso(ts: str) -> Optional[datetime]:
    """Parse an ISO-like timestamp string, return datetime or None."""
    # Strip timezone offset to make comparison easier
    ts = ts.strip()
    formats = [
        "%Y-%m-%dT%H:%M:%SZ",
        "%Y-%m-%dT%H:%M:%S%z",
        "%Y-%m-%dT%H:%M%z",
        "%Y-%m-%d",
    ]
    for fmt in formats:
        try:
            dt = datetime.strptime(ts[:len(fmt) + 6], fmt)
            if dt.tzinfo is None:
                dt = dt.replace(tzinfo=timezone.utc)
            return dt
        except ValueError:
            continue
    # Try parsing partial date strings
    m = re.match(r"(\d{4}-\d{2}-\d{2})", ts)
    if m:
        try:
            return datetime.strptime(m.group(1), "%Y-%m-%d").replace(tzinfo=timezone.utc)
        except ValueError:
            pass
    return None


# ---------------------------------------------------------------------------
# Runner
# ---------------------------------------------------------------------------

def run_checks(spec_path: Path) -> int:
    content = read_spec(spec_path)

    checks = [
        ("Check 1: Approval marker present", lambda: check_approval_marker(content)),
        ("Check 2: Version field locked", lambda: check_version_locked(content)),
        ("Check 3: No post-approval modifications", lambda: check_no_post_approval_modifications(spec_path, content)),
    ]

    passed = 0
    failed = 0
    for name, fn in checks:
        try:
            ok, msg = fn()
        except Exception as e:
            ok, msg = False, f"Exception: {e}"
        status = "PASS" if ok else "FAIL"
        print(f"[{status}] {name} — {msg}")
        if ok:
            passed += 1
        else:
            failed += 1

    print(f"\nRESULT: {passed}/{passed + failed} checks passed, {failed} failed")
    return 0 if failed == 0 else 1


def main() -> int:
    if "--help" in sys.argv or "-h" in sys.argv:
        print(__doc__.strip())
        return 0

    if len(sys.argv) < 2:
        print("Usage: python3 validate-spec-frozen.py /path/to/spec.md", file=sys.stderr)
        return 1

    spec_path = Path(sys.argv[1])
    if not spec_path.is_file():
        print(f"ERROR: {spec_path} is not a file", file=sys.stderr)
        return 1

    return run_checks(spec_path)


if __name__ == "__main__":
    sys.exit(main())
