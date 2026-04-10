#!/usr/bin/env python3
# version: 1.0 | status: draft | last_updated: 2026-04-09
"""DSBV Agent Benchmark — Layer 1: Deterministic Contract Checks

Runs 44 governance contract checks against the 4 DSBV agents and their
supporting infrastructure. Checks are grouped by dimension:
  S  — Sustainability / Safety (26 checks, S-01 through S-26)
  E  — Efficiency              ( 8 checks, E-01 through E-08)
  Sc — Scalability / Autonomy  (10 checks, Sc-01 through Sc-10)

Usage:
  python3 scripts/dsbv-benchmark-l1.py [--target-dir DIR] [--json]

Options:
  --target-dir DIR   Repo root to check (default: repo root of this script)
  --json             Output machine-readable JSON instead of human-readable text

Exit codes:
  0 — script ran successfully (checks may PASS or FAIL)
  1 — fatal error (bad args, target-dir not found)

Design ref: inbox/2026-04-09_DESIGN-dsbv-agent-benchmark.md § 3
"""

import os
import re
import sys
import json
import glob
import subprocess
import argparse
from pathlib import Path

# ── Helpers ──────────────────────────────────────────────────────────────────

def read_file(path: str) -> str:
    """Read file contents; return empty string if file does not exist."""
    try:
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            return f.read()
    except (OSError, IOError):
        return ""

def file_exists(path: str) -> bool:
    return os.path.isfile(path)

def dir_exists(path: str) -> bool:
    return os.path.isdir(path)

def parse_frontmatter(content: str) -> dict:
    """Parse YAML frontmatter between --- delimiters. No PyYAML dependency."""
    meta = {}
    lines = content.splitlines()
    if not lines or lines[0].strip() != "---":
        return meta
    for line in lines[1:]:
        if line.strip() == "---":
            break
        if ":" in line:
            key, _, val = line.partition(":")
            meta[key.strip()] = val.strip().strip('"').strip("'")
    return meta

def parse_frontmatter_tools(content: str) -> list:
    """Extract tools list from frontmatter (handles inline list format)."""
    meta = {}
    lines = content.splitlines()
    if not lines or lines[0].strip() != "---":
        return []
    for line in lines[1:]:
        if line.strip() == "---":
            break
        if line.strip().startswith("tools:"):
            val = line.split(":", 1)[1].strip().strip('"').strip("'")
            # Handle "Read, Edit, Write, Bash, Grep, Glob" format
            return [t.strip() for t in val.split(",") if t.strip()]
    return []

def bash_syntax_check(path: str) -> tuple:
    """Run bash -n on a shell script. Returns (passed: bool, stderr: str)."""
    try:
        result = subprocess.run(
            ["bash", "-n", path],
            capture_output=True,
            text=True,
            timeout=10,
        )
        return result.returncode == 0, result.stderr.strip()
    except (subprocess.TimeoutExpired, FileNotFoundError, OSError) as e:
        return False, str(e)

def find_shell_scripts(root: str) -> list:
    """Find all .sh files in scripts/ and .claude/hooks/ directories."""
    results = []
    for base in ["scripts", ".claude/hooks"]:
        base_path = os.path.join(root, base)
        if os.path.isdir(base_path):
            for dirpath, _, filenames in os.walk(base_path):
                for fn in filenames:
                    if fn.endswith(".sh"):
                        results.append(os.path.join(dirpath, fn))
    return results

def grep_in_file(pattern: str, path: str, flags: int = 0) -> bool:
    """Return True if regex pattern matches anywhere in file content."""
    content = read_file(path)
    if not content:
        return False
    return bool(re.search(pattern, content, flags))

def grep_in_files(pattern: str, paths: list, flags: int = 0) -> bool:
    """Return True if regex pattern matches in ANY of the given files."""
    for p in paths:
        if grep_in_file(pattern, p, flags):
            return True
    return False

def count_pattern_matches(pattern: str, content: str, flags: int = 0) -> int:
    """Count distinct non-overlapping matches of pattern in content."""
    return len(re.findall(pattern, content, flags))

# ── Check result container ────────────────────────────────────────────────────

def result(check_id: str, passed: bool, detail: str) -> dict:
    return {"id": check_id, "passed": passed, "detail": detail}

# ── Check implementations ─────────────────────────────────────────────────────
# Each function returns a list of result dicts (1 per logical check).

VALID_MODELS = {"opus", "sonnet", "haiku"}
AGENT_FILES = {
    "planner":  "ltc-planner.md",
    "builder":  "ltc-builder.md",
    "reviewer": "ltc-reviewer.md",
    "explorer": "ltc-explorer.md",
}
EXPECTED_MODELS = {
    "planner":  "opus",
    "builder":  "sonnet",
    "reviewer": "opus",
    "explorer": "haiku",
}

def get_agent_path(root: str, key: str) -> str:
    return os.path.join(root, ".claude", "agents", AGENT_FILES[key])


# ── S — Sustainability / Safety ───────────────────────────────────────────────

def check_s01(root: str) -> dict:
    """S-01: All agent files declare model: in frontmatter with valid value."""
    failures = []
    for key in AGENT_FILES:
        path = get_agent_path(root, key)
        content = read_file(path)
        if not content:
            failures.append(f"{key}: file missing")
            continue
        meta = parse_frontmatter(content)
        model = meta.get("model", "")
        if model not in VALID_MODELS:
            failures.append(f"{key}: model='{model}' not in {VALID_MODELS}")
    passed = len(failures) == 0
    detail = "all 4 agents have valid model declarations" if passed else "; ".join(failures)
    return result("S-01", passed, detail)


def check_s02(root: str) -> dict:
    """S-02: All agent files declare tools: allowlist in frontmatter."""
    failures = []
    for key in AGENT_FILES:
        path = get_agent_path(root, key)
        content = read_file(path)
        if not content:
            failures.append(f"{key}: file missing")
            continue
        tools = parse_frontmatter_tools(content)
        if not tools:
            failures.append(f"{key}: tools list empty or missing")
    passed = len(failures) == 0
    detail = "all 4 agents have non-empty tools lists" if passed else "; ".join(failures)
    return result("S-02", passed, detail)


def check_s03(root: str) -> dict:
    """S-03: Builder contains NEVER set status: validated."""
    path = get_agent_path(root, "builder")
    found = grep_in_file(r"NEVER.*status.*validated", path, re.IGNORECASE | re.DOTALL)
    return result("S-03", found,
                  "builder contains 'NEVER.*status.*validated'" if found
                  else "builder missing 'NEVER set status: validated' constraint")


def check_s04(root: str) -> dict:
    """S-04: Reviewer contains NEVER set status: validated."""
    path = get_agent_path(root, "reviewer")
    found = grep_in_file(r"NEVER.*status.*validated", path, re.IGNORECASE | re.DOTALL)
    return result("S-04", found,
                  "reviewer contains 'NEVER.*status.*validated'" if found
                  else "reviewer missing 'NEVER set status: validated' constraint")


def check_s05(root: str) -> dict:
    """S-05: Builder 14-item self-check present (items 1-14 in Sub-Agent Safety)."""
    path = get_agent_path(root, "builder")
    content = read_file(path)
    if not content:
        return result("S-05", False, "builder file missing")
    # Look for numbered items 1 through 14
    items_found = set()
    for m in re.finditer(r"^\s*(\d+)\.", content, re.MULTILINE):
        n = int(m.group(1))
        if 1 <= n <= 14:
            items_found.add(n)
    all_present = all(i in items_found for i in range(1, 15))
    detail = (f"items 1-14 present in builder self-check" if all_present
              else f"only {sorted(items_found)} found; missing {sorted(set(range(1,15)) - items_found)}")
    return result("S-05", all_present, detail)


def check_s06(root: str) -> dict:
    """S-06: Builder contains smoke test requirement."""
    path = get_agent_path(root, "builder")
    found = grep_in_file(r"smoke.test", path, re.IGNORECASE)
    return result("S-06", found,
                  "builder references smoke test" if found
                  else "builder missing smoke test requirement")


def check_s07(root: str) -> dict:
    """S-07: Builder contains LP-6 live test requirement."""
    path = get_agent_path(root, "builder")
    found = grep_in_file(r"LP-6", path)
    return result("S-07", found,
                  "builder references LP-6" if found
                  else "builder missing LP-6 reference")


def check_s08(root: str) -> dict:
    """S-08: Reviewer contains historical FAIL data reference (dsbv-metrics)."""
    path = get_agent_path(root, "reviewer")
    found = grep_in_file(r"dsbv-metrics", path)
    return result("S-08", found,
                  "reviewer references dsbv-metrics" if found
                  else "reviewer missing dsbv-metrics reference (historical FAIL data)")


def check_s09(root: str) -> dict:
    """S-09: Reviewer contains criterion count matching."""
    path = get_agent_path(root, "reviewer")
    found = grep_in_file(r"criterion.count", path, re.IGNORECASE)
    return result("S-09", found,
                  "reviewer contains criterion count matching" if found
                  else "reviewer missing criterion count matching")


def check_s10(root: str) -> dict:
    """S-10: Planner contains LP-6 live test AC requirement."""
    path = get_agent_path(root, "planner")
    found = grep_in_file(r"LP-6", path)
    return result("S-10", found,
                  "planner references LP-6" if found
                  else "planner missing LP-6 reference")


def check_s11(root: str) -> dict:
    """S-11: Explorer is read-only (no Write, Edit, or Bash in tools list)."""
    path = get_agent_path(root, "explorer")
    content = read_file(path)
    if not content:
        return result("S-11", False, "explorer file missing")
    tools = parse_frontmatter_tools(content)
    forbidden = [t for t in tools if t in {"Write", "Edit", "Bash"}]
    passed = len(forbidden) == 0
    detail = ("explorer has no Write/Edit/Bash in tools" if passed
              else f"explorer has forbidden tools: {forbidden}")
    return result("S-11", passed, detail)


def check_s12(root: str) -> dict:
    """S-12: DSBV skill contains LEARN hard constraint."""
    path = os.path.join(root, ".claude", "skills", "dsbv", "SKILL.md")
    found = grep_in_file(r"HARD.CONSTRAINT.*LEARN|LEARN.*HARD.CONSTRAINT", path,
                         re.IGNORECASE | re.DOTALL)
    if not found:
        # Also try <HARD-CONSTRAINT> block containing LEARN
        content = read_file(path)
        found = bool(re.search(r"<HARD-CONSTRAINT>.*LEARN.*</HARD-CONSTRAINT>",
                               content, re.DOTALL | re.IGNORECASE))
    return result("S-12", found,
                  "DSBV skill contains LEARN hard constraint" if found
                  else "DSBV skill missing LEARN hard constraint block")


def check_s13(root: str) -> dict:
    """S-13: Agent dispatch hook checks >= 3 context packaging fields."""
    path = os.path.join(root, ".claude", "hooks", "verify-agent-dispatch.sh")
    content = read_file(path)
    if not content:
        return result("S-13", False, "verify-agent-dispatch.sh missing")
    # Count distinct EO/INPUT/EP/OUTPUT/VERIFY markers
    markers = ["EO", "INPUT", "EP", "OUTPUT", "VERIFY"]
    found = [m for m in markers if re.search(r"##\s*\d*\.?\s*" + m, content) or
             re.search(re.escape(m), content)]
    passed = len(found) >= 3
    detail = (f"hook checks {len(found)}/5 fields: {found}" if passed
              else f"hook only checks {len(found)}/5 fields: {found} (need >= 3)")
    return result("S-13", passed, detail)


def check_s14(root: str) -> dict:
    """S-14: Agent dispatch hook checks all 5 context packaging fields."""
    path = os.path.join(root, ".claude", "hooks", "verify-agent-dispatch.sh")
    content = read_file(path)
    if not content:
        return result("S-14", False, "verify-agent-dispatch.sh missing")
    markers = ["EO", "INPUT", "EP", "OUTPUT", "VERIFY"]
    found = [m for m in markers if re.search(r"##\s*\d*\.?\s*" + m, content) or
             re.search(re.escape(m), content)]
    passed = len(found) == 5
    detail = (f"hook checks all 5 fields: {found}" if passed
              else f"hook only checks {len(found)}/5 fields: {found} (need all 5)")
    return result("S-14", passed, detail)


def check_s15(root: str) -> dict:
    """S-15: SubagentStop hook validates DONE: format."""
    path = os.path.join(root, ".claude", "hooks", "verify-deliverables.sh")
    found = grep_in_file(r"DONE:", path)
    return result("S-15", found,
                  "SubagentStop hook checks DONE: format" if found
                  else "SubagentStop hook missing DONE: pattern check")


def check_s16(root: str) -> dict:
    """S-16: SubagentStop hook verifies artifact existence on disk."""
    path = os.path.join(root, ".claude", "hooks", "verify-deliverables.sh")
    found = grep_in_file(r"test -f|-f \$|os\.path\.isfile|\[.*-f.*\]", path)
    if not found:
        # Also check for -f flag pattern used in bash
        found = grep_in_file(r"\[\[.*-f|test.*-f", path)
    return result("S-16", found,
                  "SubagentStop hook checks file existence" if found
                  else "SubagentStop hook missing file existence check")


def check_s17(root: str) -> dict:
    """S-17: Status guard hook exists and blocks 'validated'."""
    path = os.path.join(root, "scripts", "status-guard.sh")
    if not file_exists(path):
        return result("S-17", False, "scripts/status-guard.sh does not exist")
    found = grep_in_file(r"validated", path)
    return result("S-17", found,
                  "status-guard.sh exists and references 'validated'" if found
                  else "status-guard.sh exists but missing 'validated' pattern")


def check_s18(root: str) -> dict:
    """S-18: settings.json wires Agent PreToolUse hook."""
    path = os.path.join(root, ".claude", "settings.json")
    content = read_file(path)
    if not content:
        return result("S-18", False, ".claude/settings.json missing")
    try:
        settings = json.loads(content)
    except json.JSONDecodeError as e:
        return result("S-18", False, f"settings.json invalid JSON: {e}")
    # Check PreToolUse has a matcher for Agent
    pre_tool_use = settings.get("hooks", {}).get("PreToolUse", [])
    for entry in pre_tool_use:
        matcher = entry.get("matcher", "")
        if "Agent" in matcher:
            hooks = entry.get("hooks", [])
            if any("verify-agent-dispatch" in h.get("command", "") for h in hooks):
                return result("S-18", True, "settings.json PreToolUse Agent matcher wired to verify-agent-dispatch.sh")
    return result("S-18", False, "settings.json missing PreToolUse Agent matcher or verify-agent-dispatch.sh not wired")


def check_s19(root: str) -> dict:
    """S-19: settings.json wires SubagentStop hook."""
    path = os.path.join(root, ".claude", "settings.json")
    content = read_file(path)
    if not content:
        return result("S-19", False, ".claude/settings.json missing")
    try:
        settings = json.loads(content)
    except json.JSONDecodeError as e:
        return result("S-19", False, f"settings.json invalid JSON: {e}")
    subagent_stop = settings.get("hooks", {}).get("SubagentStop", [])
    has_hook = False
    for entry in subagent_stop:
        hooks = entry.get("hooks", [])
        if hooks:
            has_hook = True
            break
    return result("S-19", has_hook,
                  "settings.json SubagentStop wired" if has_hook
                  else "settings.json missing SubagentStop hook entry")


def check_s20(root: str) -> dict:
    """S-20: Gate state machine script exists (post-upgrade; expected FAIL on main)."""
    path = os.path.join(root, "scripts", "gate-state.sh")
    exists = file_exists(path)
    return result("S-20", exists,
                  "scripts/gate-state.sh exists" if exists
                  else "scripts/gate-state.sh missing (expected FAIL on main branch)")


def check_s21(root: str) -> dict:
    """S-21: Gate pre-check script exists (post-upgrade; expected FAIL on main)."""
    path = os.path.join(root, "scripts", "gate-precheck.sh")
    exists = file_exists(path)
    return result("S-21", exists,
                  "scripts/gate-precheck.sh exists" if exists
                  else "scripts/gate-precheck.sh missing (expected FAIL on main branch)")


def check_s22(root: str) -> dict:
    """S-22: Approval record verify script exists (post-upgrade; expected FAIL on main)."""
    path = os.path.join(root, "scripts", "verify-approval-record.sh")
    exists = file_exists(path)
    return result("S-22", exists,
                  "scripts/verify-approval-record.sh exists" if exists
                  else "scripts/verify-approval-record.sh missing (expected FAIL on main branch)")


def check_s23(root: str) -> dict:
    """S-23: Classify-fail script exists (post-upgrade; expected FAIL on main)."""
    path = os.path.join(root, "scripts", "classify-fail.sh")
    exists = file_exists(path)
    return result("S-23", exists,
                  "scripts/classify-fail.sh exists" if exists
                  else "scripts/classify-fail.sh missing (expected FAIL on main branch)")


def check_s24(root: str) -> dict:
    """S-24: Set-status-in-review script exists (post-upgrade; expected FAIL on main)."""
    path = os.path.join(root, "scripts", "set-status-in-review.sh")
    exists = file_exists(path)
    return result("S-24", exists,
                  "scripts/set-status-in-review.sh exists" if exists
                  else "scripts/set-status-in-review.sh missing (expected FAIL on main branch)")


def check_s25(root: str) -> dict:
    """S-25: No bash 4+ features (mapfile / declare -A) in any shell scripts."""
    sh_files = find_shell_scripts(root)
    if not sh_files:
        return result("S-25", True, "no shell scripts found (vacuously true)")
    # Scripts whose job is to CHECK for bash 4+ patterns must be excluded — they
    # legitimately reference the forbidden words inside grep/string patterns.
    EXEMPT = {"bash3-compat-test.sh"}
    hits = []
    for f in sh_files:
        if os.path.basename(f) in EXEMPT:
            continue
        content = read_file(f)
        # Strip comment lines before checking — avoids false positives from scripts
        # that document their avoidance of bash 4+ patterns in comments.
        code_lines = [ln for ln in content.split("\n")
                      if not ln.strip().startswith("#")]
        code_content = "\n".join(code_lines)
        if re.search(r"\bmapfile\b|declare\s+-A\b", code_content):
            hits.append(os.path.relpath(f, root))
    passed = len(hits) == 0
    detail = ("no bash 4+ features found" if passed
              else f"bash 4+ features found in: {hits}")
    return result("S-25", passed, detail)


def check_s26(root: str) -> dict:
    """S-26: All shell scripts pass bash -n syntax check."""
    sh_files = find_shell_scripts(root)
    if not sh_files:
        return result("S-26", True, "no shell scripts found (vacuously true)")
    failures = []
    for f in sh_files:
        passed_syntax, stderr = bash_syntax_check(f)
        if not passed_syntax:
            rel = os.path.relpath(f, root)
            failures.append(f"{rel}: {stderr[:80]}" if stderr else rel)
    passed = len(failures) == 0
    detail = ("all shell scripts pass bash -n" if passed
              else f"syntax errors in: {failures}")
    return result("S-26", passed, detail)


# ── E — Efficiency ────────────────────────────────────────────────────────────

def check_e01(root: str) -> dict:
    """E-01: Agent models match expected tier (planner=opus, builder=sonnet, etc.)."""
    failures = []
    for key, expected in EXPECTED_MODELS.items():
        path = get_agent_path(root, key)
        content = read_file(path)
        if not content:
            failures.append(f"{key}: file missing")
            continue
        meta = parse_frontmatter(content)
        actual = meta.get("model", "")
        if actual != expected:
            failures.append(f"{key}: expected={expected}, actual='{actual}'")
    passed = len(failures) == 0
    detail = "all 4 agents declare correct model tier" if passed else "; ".join(failures)
    return result("E-01", passed, detail)


def check_e02(root: str) -> dict:
    """E-02: Agent dispatch hook checks model routing."""
    path = os.path.join(root, ".claude", "hooks", "verify-agent-dispatch.sh")
    found = grep_in_file(r"\bmodel\b", path, re.IGNORECASE)
    return result("E-02", found,
                  "dispatch hook references model routing" if found
                  else "dispatch hook missing model routing check")


def check_e03(root: str) -> dict:
    """E-03: Agent tools are minimal per expected set."""
    # Expected minimal tool sets per agent (no unnecessary extras)
    EXPECTED_TOOLS = {
        "planner":  {"Read", "Glob", "Grep"},  # WebFetch and MCP are acceptable extras
        "builder":  {"Read", "Edit", "Write", "Bash", "Grep", "Glob"},
        "reviewer": {"Read", "Glob", "Grep", "Bash"},
        "explorer": {"Read", "Glob", "Grep"},  # MCP tools are acceptable extras
    }
    # Tools that are NOT acceptable for any given role
    FORBIDDEN_TOOLS = {
        "explorer": {"Write", "Edit", "Bash"},
        "planner":  {"Write", "Edit"},
    }
    failures = []
    for key in AGENT_FILES:
        path = get_agent_path(root, key)
        content = read_file(path)
        if not content:
            failures.append(f"{key}: file missing")
            continue
        tools = set(parse_frontmatter_tools(content))
        # Check for forbidden tools
        forbidden = FORBIDDEN_TOOLS.get(key, set()) & tools
        if forbidden:
            failures.append(f"{key} has forbidden tools: {sorted(forbidden)}")
        # Check that all required tools are present
        required = EXPECTED_TOOLS.get(key, set())
        missing = required - tools
        if missing:
            failures.append(f"{key} missing expected tools: {sorted(missing)}")
    passed = len(failures) == 0
    detail = "all agents have correct minimal tool sets" if passed else "; ".join(failures)
    return result("E-03", passed, detail)


def check_e04(root: str) -> dict:
    """E-04: SubagentStop hook logs metrics."""
    path = os.path.join(root, ".claude", "hooks", "verify-deliverables.sh")
    found = grep_in_file(r"metrics|jsonl|\.log\b", path, re.IGNORECASE)
    return result("E-04", found,
                  "SubagentStop hook references metrics/log" if found
                  else "SubagentStop hook missing metrics/log reference")


def check_e05(root: str) -> dict:
    """E-05: Auto-recall hook has intent-based filtering."""
    hooks_dir = os.path.join(root, ".claude", "hooks")
    hook_files = [os.path.join(hooks_dir, f) for f in os.listdir(hooks_dir)
                  if f.endswith(".sh")] if os.path.isdir(hooks_dir) else []
    found = grep_in_files(r"\bintent\b", hook_files, re.IGNORECASE)
    return result("E-05", found,
                  "hooks contain intent-based filtering" if found
                  else "no hooks found with intent-based filtering (auto-recall)")


def check_e06(root: str) -> dict:
    """E-06: Auto-recall has token budget thresholds (both 2000 and 1000)."""
    hooks_dir = os.path.join(root, ".claude", "hooks")
    hook_files = [os.path.join(hooks_dir, f) for f in os.listdir(hooks_dir)
                  if f.endswith(".sh")] if os.path.isdir(hooks_dir) else []
    # Both thresholds must appear in the same file or collectively
    has_2000 = grep_in_files(r"\b2000\b", hook_files)
    has_1000 = grep_in_files(r"\b1000\b", hook_files)
    passed = has_2000 and has_1000
    detail = ("hooks contain both token budget thresholds (2000, 1000)" if passed
              else f"missing thresholds — 2000: {has_2000}, 1000: {has_1000}")
    return result("E-06", passed, detail)


def check_e07(root: str) -> dict:
    """E-07: Circuit breaker state tracked (loop_state / max_iterations / cost_tokens)."""
    skill_path = os.path.join(root, ".claude", "skills", "dsbv", "SKILL.md")
    gate_path = os.path.join(root, "scripts", "gate-state.sh")
    pattern = r"loop_state|max_iterations|cost_tokens"
    found = grep_in_file(pattern, skill_path) or grep_in_file(pattern, gate_path)
    return result("E-07", found,
                  "circuit breaker state tracked in skill or gate-state.sh" if found
                  else "no circuit breaker state tracking found (loop_state/max_iterations/cost_tokens)")


def check_e08(root: str) -> dict:
    """E-08: Budget field required in dispatch hook."""
    path = os.path.join(root, ".claude", "hooks", "verify-agent-dispatch.sh")
    found = grep_in_file(r"\bbudget\b", path, re.IGNORECASE)
    return result("E-08", found,
                  "dispatch hook references budget field" if found
                  else "dispatch hook missing budget field check")


# ── Sc — Scalability / Autonomy ───────────────────────────────────────────────

def check_sc01(root: str) -> dict:
    """Sc-01: Gate state directory exists OR state schema documented in skill."""
    state_dir = os.path.join(root, ".claude", "state")
    if dir_exists(state_dir):
        return result("Sc-01", True, ".claude/state/ directory exists")
    skill_path = os.path.join(root, ".claude", "skills", "dsbv", "SKILL.md")
    found = grep_in_file(r"dsbv.*\.json|\.json.*dsbv", skill_path, re.IGNORECASE)
    return result("Sc-01", found,
                  "state schema documented in SKILL.md (dsbv-*.json pattern)" if found
                  else ".claude/state/ missing AND no state schema in SKILL.md")


def check_sc02(root: str) -> dict:
    """Sc-02: Per-workstream state files schema in skill or gate-state.sh."""
    skill_path = os.path.join(root, ".claude", "skills", "dsbv", "SKILL.md")
    gate_path = os.path.join(root, "scripts", "gate-state.sh")
    # Look for workstream-specific patterns (1-ALIGN, 2-LEARN patterns or workstream variables)
    pattern = r"workstream|WORKSTREAM|1-ALIGN|3-PLAN|4-EXECUTE|5-IMPROVE"
    found = grep_in_file(pattern, skill_path) or grep_in_file(pattern, gate_path)
    return result("Sc-02", found,
                  "per-workstream state schema found" if found
                  else "no per-workstream state schema found")


def check_sc03(root: str) -> dict:
    """Sc-03: Gate transitions documented (pending -> approved -> locked)."""
    skill_path = os.path.join(root, ".claude", "skills", "dsbv", "SKILL.md")
    pattern = r"pending|approved|locked"
    content = read_file(skill_path)
    # Need at least two of the three states mentioned together
    states_found = [s for s in ["pending", "approved", "locked"] if re.search(s, content, re.IGNORECASE)]
    passed = len(states_found) >= 2
    detail = (f"gate transitions documented: {states_found}" if passed
              else f"only {states_found} found; need pending/approved/locked")
    return result("Sc-03", passed, detail)


def check_sc04(root: str) -> dict:
    """Sc-04: Stage sequencing enforcement (Builder requires G2 approval)."""
    dispatch_path = os.path.join(root, ".claude", "hooks", "verify-agent-dispatch.sh")
    skill_path = os.path.join(root, ".claude", "skills", "dsbv", "SKILL.md")
    pattern = r"G2|SEQUENCE.*approved|approved.*SEQUENCE|Cannot start Build"
    found = grep_in_file(pattern, dispatch_path, re.IGNORECASE) or \
            grep_in_file(pattern, skill_path, re.IGNORECASE)
    return result("Sc-04", found,
                  "stage sequencing enforced (G2/SEQUENCE requirement found)" if found
                  else "no stage sequencing enforcement found (G2 / approved SEQUENCE)")


def check_sc05(root: str) -> dict:
    """Sc-05: Registry sync hook at write-time (PostToolUse)."""
    path = os.path.join(root, ".claude", "settings.json")
    content = read_file(path)
    if not content:
        return result("Sc-05", False, ".claude/settings.json missing")
    try:
        settings = json.loads(content)
    except json.JSONDecodeError:
        return result("Sc-05", False, "settings.json invalid JSON")
    post_tool_use = settings.get("hooks", {}).get("PostToolUse", [])
    for entry in post_tool_use:
        hooks = entry.get("hooks", [])
        for h in hooks:
            cmd = h.get("command", "")
            if "registry" in cmd.lower() or "registry-sync" in cmd.lower():
                return result("Sc-05", True, f"registry sync hook in PostToolUse: {cmd[:60]}")
    # Also check PreToolUse (git commit wires registry-sync-check)
    pre_tool_use = settings.get("hooks", {}).get("PreToolUse", [])
    for entry in pre_tool_use:
        hooks = entry.get("hooks", [])
        for h in hooks:
            cmd = h.get("command", "")
            if "registry-sync" in cmd:
                return result("Sc-05", True, f"registry-sync-check wired at commit time: {cmd[:60]}")
    return result("Sc-05", False, "no registry sync hook found in PostToolUse or PreToolUse")


def check_sc06(root: str) -> dict:
    """Sc-06: Error classification exists (SYNTACTIC/SEMANTIC/ENVIRONMENTAL/SCOPE)."""
    classify_path = os.path.join(root, "scripts", "classify-fail.sh")
    skill_path = os.path.join(root, ".claude", "skills", "dsbv", "SKILL.md")
    pattern = r"SYNTACTIC|SEMANTIC|ENVIRONMENTAL|SCOPE"
    found = grep_in_file(pattern, classify_path) or grep_in_file(pattern, skill_path)
    return result("Sc-06", found,
                  "error classification present" if found
                  else "no error classification (SYNTACTIC/SEMANTIC/ENVIRONMENTAL/SCOPE) found")


def check_sc07(root: str) -> dict:
    """Sc-07: Execution mode guard (stage-agent compatibility)."""
    dispatch_path = os.path.join(root, ".claude", "hooks", "verify-agent-dispatch.sh")
    pattern = r"stage.*mismatch|current_phase|stage.*agent|agent.*stage"
    found = grep_in_file(pattern, dispatch_path, re.IGNORECASE)
    return result("Sc-07", found,
                  "execution mode guard present in dispatch hook" if found
                  else "no stage-agent compatibility guard in dispatch hook")


def check_sc08(root: str) -> dict:
    """Sc-08: All 4 agents have scope boundary sections (You DO / You DO NOT)."""
    failures = []
    for key in AGENT_FILES:
        path = get_agent_path(root, key)
        content = read_file(path)
        if not content:
            failures.append(f"{key}: file missing")
            continue
        has_do = bool(re.search(r"You DO:", content))
        has_do_not = bool(re.search(r"You DO NOT:", content))
        if not has_do or not has_do_not:
            failures.append(f"{key}: missing {'DO' if not has_do else 'DO NOT'} section")
    passed = len(failures) == 0
    detail = "all 4 agents have DO/DO NOT scope sections" if passed else "; ".join(failures)
    return result("Sc-08", passed, detail)


def check_sc09(root: str) -> dict:
    """Sc-09: Reviewer has pre-flight validation section."""
    path = get_agent_path(root, "reviewer")
    found = grep_in_file(r"Pre-Flight|pre-flight|precondition", path, re.IGNORECASE)
    return result("Sc-09", found,
                  "reviewer has pre-flight section" if found
                  else "reviewer missing pre-flight section")


def check_sc10(root: str) -> dict:
    """Sc-10: Explorer has pre-flight section."""
    path = get_agent_path(root, "explorer")
    found = grep_in_file(r"Pre-Flight|pre-flight", path, re.IGNORECASE)
    return result("Sc-10", found,
                  "explorer has pre-flight section" if found
                  else "explorer missing pre-flight section")


# ── Check registry ────────────────────────────────────────────────────────────

ALL_CHECKS = [
    # S — Sustainability / Safety (26)
    check_s01, check_s02, check_s03, check_s04, check_s05, check_s06,
    check_s07, check_s08, check_s09, check_s10, check_s11, check_s12,
    check_s13, check_s14, check_s15, check_s16, check_s17, check_s18,
    check_s19, check_s20, check_s21, check_s22, check_s23, check_s24,
    check_s25, check_s26,
    # E — Efficiency (8)
    check_e01, check_e02, check_e03, check_e04, check_e05, check_e06,
    check_e07, check_e08,
    # Sc — Scalability (10)
    check_sc01, check_sc02, check_sc03, check_sc04, check_sc05, check_sc06,
    check_sc07, check_sc08, check_sc09, check_sc10,
]

EXPECTED_TOTAL = 44


# ── Runner ────────────────────────────────────────────────────────────────────

def run_all_checks(target_dir: str) -> dict:
    """Run all 44 checks and return aggregated results."""
    results = []
    for fn in ALL_CHECKS:
        r = fn(target_dir)
        results.append(r)

    s_results  = [r for r in results if r["id"].startswith("S-")]
    e_results  = [r for r in results if r["id"].startswith("E-")]
    sc_results = [r for r in results if r["id"].startswith("Sc-")]

    def pct(subset):
        if not subset:
            return 0.0
        return round(sum(1 for r in subset if r["passed"]) / len(subset) * 100, 1)

    total_pass = sum(1 for r in results if r["passed"])
    total_fail = len(results) - total_pass

    return {
        "target_dir": target_dir,
        "total_checks": len(results),
        "total_pass": total_pass,
        "total_fail": total_fail,
        "L1_S_score":  pct(s_results),
        "L1_E_score":  pct(e_results),
        "L1_Sc_score": pct(sc_results),
        "L1_total":    pct(results),
        "checks": results,
    }


# ── Output formatters ─────────────────────────────────────────────────────────

def format_human(data: dict) -> str:
    lines = []
    lines.append("=" * 70)
    lines.append("DSBV Agent Benchmark — Layer 1: Deterministic Contract Checks")
    lines.append("=" * 70)
    lines.append(f"Target:  {data['target_dir']}")
    lines.append(f"Checks:  {data['total_checks']} total  |  {data['total_pass']} PASS  |  {data['total_fail']} FAIL")
    lines.append("")

    current_dim = None
    for r in data["checks"]:
        dim = r["id"].split("-")[0]
        if dim != current_dim:
            current_dim = dim
            dim_label = {"S": "S — Sustainability / Safety", "E": "E — Efficiency",
                         "Sc": "Sc — Scalability / Autonomy"}.get(dim, dim)
            lines.append(f"\n── {dim_label} ──")
        status = "PASS" if r["passed"] else "FAIL"
        lines.append(f"  [{status}] {r['id']:6s}  {r['detail']}")

    lines.append("")
    lines.append("── Summary ──────────────────────────────────────────────────────")
    lines.append(f"  L1_S_score:   {data['L1_S_score']:5.1f}%  ({sum(1 for r in data['checks'] if r['id'].startswith('S-') and r['passed'])}/26 pass)")
    lines.append(f"  L1_E_score:   {data['L1_E_score']:5.1f}%  ({sum(1 for r in data['checks'] if r['id'].startswith('E-') and r['passed'])}/8 pass)")
    lines.append(f"  L1_Sc_score:  {data['L1_Sc_score']:5.1f}%  ({sum(1 for r in data['checks'] if r['id'].startswith('Sc-') and r['passed'])}/10 pass)")
    lines.append(f"  L1_total:     {data['L1_total']:5.1f}%  ({data['total_pass']}/{data['total_checks']} pass)")
    lines.append("=" * 70)
    return "\n".join(lines)


# ── CLI ───────────────────────────────────────────────────────────────────────

def resolve_target_dir(arg: str | None) -> str:
    if arg:
        return os.path.abspath(arg)
    # Default: repo root (2 levels up from scripts/)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    candidate = os.path.abspath(os.path.join(script_dir, ".."))
    # Verify it looks like a repo root (has .claude/ dir)
    if os.path.isdir(os.path.join(candidate, ".claude")):
        return candidate
    return script_dir  # fallback


def main():
    parser = argparse.ArgumentParser(
        description="DSBV Agent Benchmark — Layer 1: Deterministic Contract Checks"
    )
    parser.add_argument(
        "--target-dir",
        metavar="DIR",
        default=None,
        help="Repo root to check (default: auto-detect from script location)",
    )
    parser.add_argument(
        "--json",
        action="store_true",
        help="Output machine-readable JSON",
    )
    args = parser.parse_args()

    target_dir = resolve_target_dir(args.target_dir)
    if not os.path.isdir(target_dir):
        print(f"ERROR: target-dir '{target_dir}' is not a directory", file=sys.stderr)
        sys.exit(1)

    # Validate total check count matches expected
    assert len(ALL_CHECKS) == EXPECTED_TOTAL, (
        f"Check count mismatch: {len(ALL_CHECKS)} != {EXPECTED_TOTAL}. "
        "Update ALL_CHECKS or EXPECTED_TOTAL."
    )

    data = run_all_checks(target_dir)

    if args.json:
        print(json.dumps(data, indent=2))
    else:
        print(format_human(data))

    # Always exit 0 — checks produce PASS/FAIL, not script error
    sys.exit(0)


if __name__ == "__main__":
    main()
