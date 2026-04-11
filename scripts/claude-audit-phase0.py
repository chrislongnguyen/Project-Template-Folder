#!/usr/bin/env python3
# version: 1.0 | status: draft | last_updated: 2026-04-11
"""
claude-audit-phase0.py — Deterministic local extraction for /claude-audit.

Produces a JSON manifest to stdout containing:
- Per-area file inventories with frontmatter + wikilink metadata
- Frontmatter health report (missing/invalid fields)
- Wikilink orphan report
- Validation script results (pre-flight, validate-blueprint, pkb-lint)
- Git state (ahead count, uncommitted, untracked)
- Aggregate counts

Cost: $0 (pure Python + shell, no LLM).
Usage:
    python3 scripts/claude-audit-phase0.py            # full JSON manifest → stdout
    python3 scripts/claude-audit-phase0.py --summary   # human-readable summary → stderr + JSON → stdout
"""

import argparse
import json
import os
import re
import subprocess
import sys
from collections import defaultdict
from datetime import date
from pathlib import Path

R = Path(__file__).parent.parent.resolve()
TODAY = date.today().isoformat()

# ── Area Classification ─────────────────────────────────────────────────────

CORE_SKILL_DIRS = frozenset({
    "dsbv", "learn", "learn-input", "learn-research", "learn-review",
    "learn-spec", "learn-structure", "learn-visualize", "git-save",
    "obsidian", "deep-research",
})

GENESIS_SUB_AREAS = {
    "frameworks": "genesis-frameworks",
    "templates": "genesis-templates",
    "sops": "genesis-sops",
    "guides": "genesis-sops",       # grouped with SOPs
    "reference": "genesis-reference",
    "training": "genesis-training",
}

VAULT_DIRS = frozenset({"DAILY-NOTES", "inbox", "MISC-TASKS", "PEOPLE"})

AREA_DESCRIPTIONS = {
    "ws-align":           "1-ALIGN/ — Charter, OKRs, ADRs, stakeholder map per subsystem + _cross",
    "ws-learn":           "2-LEARN/ — 6-state learning pipeline (input→research→specs→output→archive). NO DSBV files.",
    "ws-plan":            "3-PLAN/ — Architecture docs, UBS/UDS registers, roadmaps per subsystem",
    "ws-execute":         "4-EXECUTE/ — Source, tests, config, docs per subsystem",
    "ws-improve":         "5-IMPROVE/ — Changelog, metrics baselines, retros, reviews",
    "genesis-frameworks": "_genesis/frameworks/ — 9 canonical frameworks + ALPEI-DSBV process map",
    "genesis-templates":  "_genesis/templates/ — DSBV stage templates + learning book pages",
    "genesis-sops":       "_genesis/sops/ + guides/ — Standard Operating Procedures, migration/setup guides",
    "genesis-reference":  "_genesis/reference/ — archived frameworks (PDF/DOCX), agent designs, EP registry, effectiveness guide",
    "genesis-training":   "_genesis/training/ — training decks, slide apps. WARNING: may contain committed node_modules",
    "genesis-other":      "_genesis/ remaining — brand, compliance, culture, governance, obsidian, philosophy, principles, scripts, security, tools",
    "claude-rules":       ".claude/rules/ — 12 always-on rule files (auto-loaded every session)",
    "claude-agents":      ".claude/agents/ — 4 agent definitions (explorer, planner, builder, reviewer)",
    "claude-skills-core": ".claude/skills/ critical — dsbv, learn*, git-save, obsidian, deep-research",
    "claude-skills-other":".claude/skills/ remaining — governance, utility, WMS, brand, brainstorming skills",
    "claude-hooks":       ".claude/hooks/ + settings.json + .claude/ root config — 29 hook registrations",
    "scripts":            "scripts/ — 53 scripts (enforcement, validation, DSBV, setup, Obsidian, learning)",
    "rules-fullspec":     "rules/ — 8 full-spec rule files (on-demand, not auto-loaded)",
    "root-config":        "Root-level files — README.md, CLAUDE.md, AGENTS.md, GEMINI.md, codex.md, CHANGELOG.md",
    "cursor-config":      ".cursor/ + .agents/ — multi-IDE config (Cursor rules, Codex/Copilot agent config). Should mirror .claude/rules/ key sections.",
    "pkb":                "PERSONAL-KNOWLEDGE-BASE/ — Capture→Distill→Express pipeline, dashboard, auto-recall",
    "vault-other":        "DAILY-NOTES/, inbox/, MISC-TASKS/, PEOPLE/ — vault scaffolding dirs",
}


def classify_area(rel: str) -> str:
    """Classify a relative file path into one of 20 audit areas."""
    parts = rel.split("/")
    top = parts[0] if parts else ""

    # Workstreams
    if top == "1-ALIGN":   return "ws-align"
    if top == "2-LEARN":   return "ws-learn"
    if top == "3-PLAN":    return "ws-plan"
    if top == "4-EXECUTE": return "ws-execute"
    if top == "5-IMPROVE": return "ws-improve"

    # Genesis sub-areas
    if top == "_genesis":
        sub = parts[1] if len(parts) >= 2 else ""
        if sub in GENESIS_SUB_AREAS:
            return GENESIS_SUB_AREAS[sub]
        return "genesis-other"

    # Claude config sub-areas
    if top == ".claude":
        if len(parts) >= 2:
            sub = parts[1]
            if sub == "rules":  return "claude-rules"
            if sub == "agents": return "claude-agents"
            if sub == "skills":
                skill_dir = parts[2] if len(parts) >= 3 else ""
                if skill_dir in CORE_SKILL_DIRS:
                    return "claude-skills-core"
                return "claude-skills-other"
            if sub == "hooks":  return "claude-hooks"
        # .claude/ root files (settings.json, README.md, etc.)
        return "claude-hooks"

    # Scripts
    if top == "scripts": return "scripts"

    # Rules (full-spec, not .claude/rules/)
    if top == "rules": return "rules-fullspec"

    # Cursor + .agents/ (Codex/Copilot agent config)
    if top == ".cursor": return "cursor-config"
    if top == ".agents": return "cursor-config"

    # GitHub config
    if top == ".github": return "root-config"

    # PKB
    if top == "PERSONAL-KNOWLEDGE-BASE": return "pkb"

    # Vault dirs
    if top in VAULT_DIRS: return "vault-other"

    # Root-level files (no /)
    if "/" not in rel: return "root-config"

    return "uncategorized"


# ── Utilities ───────────────────────────────────────────────────────────────

def sh(cmd: str, timeout: int = 60) -> str:
    """Run a shell command and return stdout+stderr."""
    try:
        r = subprocess.run(
            ["bash", "-c", cmd], cwd=R,
            capture_output=True, text=True, timeout=timeout,
        )
        return (r.stdout + r.stderr).strip() or "(empty)"
    except subprocess.TimeoutExpired:
        return "[TIMEOUT]"
    except Exception as e:
        return f"[ERR: {e}]"


def extract_fm(p: Path) -> dict:
    """Parse YAML frontmatter from a markdown file. Returns {} if none."""
    try:
        text = p.read_text("utf-8", errors="replace")[:3000]
        m = re.match(r"^---\n(.*?)\n---", text, re.DOTALL)
        if not m:
            return {}
        fm = {}
        for line in m.group(1).split("\n"):
            if ":" in line:
                k, v = line.split(":", 1)
                fm[k.strip()] = v.strip().strip('"').strip("'")
        return fm
    except Exception:
        return {}


def extract_links(p: Path) -> list:
    """Extract all [[wikilink]] targets from a file."""
    try:
        text = p.read_text("utf-8", errors="replace")
        return re.findall(r"\[\[([^\]|]+)", text)
    except Exception:
        return []


# ── Scanning ────────────────────────────────────────────────────────────────

def scan_files() -> dict:
    """Scan all git-tracked files. Classify into areas, extract metadata."""
    tracked = sh("git ls-files").split("\n")
    areas = defaultdict(lambda: {"files": [], "total_chars": 0, "total_lines": 0})
    all_files = {}

    for rel in tracked:
        if not rel.strip():
            continue
        p = R / rel
        area = classify_area(rel)

        # Basic file info
        info = {"path": rel, "area": area}
        try:
            chars = p.stat().st_size
            lines = sum(1 for _ in open(p, errors="replace"))
        except Exception:
            chars, lines = 0, 0
        info["chars"] = chars
        info["lines"] = lines

        # Markdown-specific: frontmatter + wikilinks
        if rel.endswith(".md"):
            info["frontmatter"] = extract_fm(p)
            info["wikilinks"] = extract_links(p)
        # Script-specific: version header
        elif rel.endswith((".sh", ".py")):
            try:
                header = ""
                with open(p, errors="replace") as f:
                    for line in f:
                        if line.startswith("#"):
                            header += line
                        elif header:
                            break
                info["header"] = header[:300]
            except Exception:
                info["header"] = ""

        all_files[rel] = info
        areas[area]["files"].append(rel)
        areas[area]["total_chars"] += chars
        areas[area]["total_lines"] += lines

    # Add file_count and description to each area
    for name, data in areas.items():
        data["file_count"] = len(data["files"])
        data["description"] = AREA_DESCRIPTIONS.get(name, "")

    return {"files": all_files, "areas": dict(areas)}


def check_frontmatter(all_files: dict) -> dict:
    """Check frontmatter health across all .md files."""
    required_fields = {"version", "status", "last_updated"}
    valid_statuses = {"draft", "in-progress", "in-review", "validated", "archived"}
    version_re = re.compile(r"^\d+\.\d+$")

    md_files = {k: v for k, v in all_files.items() if k.endswith(".md")}
    issues = []
    with_fm = 0
    missing_fm = 0

    # Exempt dirs: no frontmatter expected
    exempt_prefixes = ("DAILY-NOTES/", "inbox/", ".obsidian/", "MISC-TASKS/", "PEOPLE/")

    for rel, info in sorted(md_files.items()):
        fm = info.get("frontmatter", {})
        if any(rel.startswith(p) for p in exempt_prefixes):
            continue

        if not fm:
            missing_fm += 1
            # Only flag non-README files as issues
            if not rel.endswith("README.md"):
                issues.append({"file": rel, "issue": "missing frontmatter entirely"})
            continue

        with_fm += 1

        # Check required fields
        for field in required_fields:
            if field not in fm:
                issues.append({"file": rel, "issue": f"missing {field} field"})

        # Validate version format
        ver = fm.get("version", "")
        if ver and not version_re.match(ver):
            issues.append({"file": rel, "issue": f"invalid version format: '{ver}' (expected MAJOR.MINOR)"})

        # Validate status values
        status = fm.get("status", "")
        if status and status not in valid_statuses:
            issues.append({"file": rel, "issue": f"invalid status: '{status}'"})

        # Check for uppercase in status (should be lowercase)
        if status and status != status.lower():
            issues.append({"file": rel, "issue": f"status not lowercase: '{status}'"})

        # Validate date format
        dt = fm.get("last_updated", "")
        if dt and not re.match(r"^\d{4}-\d{2}-\d{2}$", dt):
            issues.append({"file": rel, "issue": f"invalid date format: '{dt}'"})

    return {
        "total_md": len(md_files),
        "with_frontmatter": with_fm,
        "missing_frontmatter": missing_fm,
        "issue_count": len(issues),
        "issues": issues,
    }


def check_wikilinks(all_files: dict) -> dict:
    """Check wikilink integrity. Find orphans and broken links."""
    # Build target sets
    all_stems = set()
    all_aliases = set()
    link_usage = defaultdict(list)  # target -> [files that reference it]

    for rel, info in all_files.items():
        if rel.endswith(".md"):
            stem = Path(rel).stem
            all_stems.add(stem)
            # Extract aliases from frontmatter
            aliases = info.get("frontmatter", {}).get("aliases", "")
            for alias in aliases.strip("[]").split(","):
                alias = alias.strip().strip("'\"")
                if alias:
                    all_aliases.add(alias)

    targets = all_stems | all_aliases

    # Collect all wikilink usages
    for rel, info in all_files.items():
        for link in info.get("wikilinks", []):
            link_usage[link].append(rel)

    # Find orphans (links to targets that don't exist)
    unique_links = set(link_usage.keys())
    orphans = sorted(unique_links - targets)

    # Build orphan detail (which files reference each orphan)
    orphan_detail = {}
    for o in orphans[:50]:  # cap detail at 50
        orphan_detail[o] = link_usage[o][:5]  # cap references per orphan

    return {
        "total_unique_links": len(unique_links),
        "total_targets": len(targets),
        "orphan_count": len(orphans),
        "orphans": orphans[:50],
        "orphan_detail": orphan_detail,
        "top_linked": sorted(
            ((t, len(refs)) for t, refs in link_usage.items()),
            key=lambda x: -x[1],
        )[:20],
    }


def run_validations() -> dict:
    """Run existing validation scripts and capture output."""
    results = {}

    # Pre-flight per workstream
    for ws in ["1-ALIGN", "2-LEARN", "3-PLAN", "4-EXECUTE", "5-IMPROVE"]:
        results[f"preflight-{ws}"] = sh(
            f"bash scripts/pre-flight.sh {ws} 2>&1 | tail -20"
        )

    # validate-blueprint.py
    results["validate-blueprint"] = sh(
        "python3 scripts/validate-blueprint.py 2>&1 | tail -25"
    )

    # pkb-lint.sh
    results["pkb-lint"] = sh("bash scripts/pkb-lint.sh 2>&1 | tail -20")

    return results


def git_state() -> dict:
    """Gather git state information."""
    return {
        "branch": sh("git branch --show-current"),
        "ahead": sh("git rev-list --count HEAD...origin/main 2>/dev/null || echo '?'"),
        "status_short": sh("git status --short"),
        "uncommitted_count": len([
            l for l in sh("git status --short").split("\n") if l.strip()
        ]),
        "untracked": sh("git ls-files --others --exclude-standard | head -30"),
        "untracked_count": len([
            l for l in sh("git ls-files --others --exclude-standard").split("\n") if l.strip()
        ]),
        "log_recent": sh("git log --oneline -10"),
        "last_commit": sh("git log --oneline -1"),
    }


# ── Hook Chain Verification ────────────────────────────────────────────────

def check_hook_chain() -> dict:
    """Verify settings.json hook entries point to existing scripts."""
    settings_path = R / ".claude" / "settings.json"
    if not settings_path.exists():
        return {"error": "settings.json not found"}

    try:
        settings = json.loads(settings_path.read_text())
    except Exception as e:
        return {"error": f"settings.json parse error: {e}"}

    hooks = settings.get("hooks", {})
    results = {"total_entries": 0, "valid": 0, "broken": [], "entries": []}

    for event_type, entries in hooks.items():
        if not isinstance(entries, list):
            continue
        for entry in entries:
            results["total_entries"] += 1
            cmd = entry.get("command", "")
            # Extract script path from command
            # Common patterns: "bash scripts/foo.sh", "python3 scripts/bar.py",
            # or just "scripts/foo.sh"
            scripts_in_cmd = re.findall(
                r"(?:bash\s+|python3?\s+|sh\s+)?([.\w/-]+\.(?:sh|py))", cmd
            )
            entry_info = {
                "event": event_type,
                "command": cmd[:200],
                "scripts_referenced": scripts_in_cmd,
                "scripts_exist": [],
            }
            all_exist = True
            for script in scripts_in_cmd:
                exists = (R / script).exists()
                entry_info["scripts_exist"].append({"script": script, "exists": exists})
                if not exists:
                    all_exist = False
                    results["broken"].append({
                        "event": event_type,
                        "command": cmd[:100],
                        "missing_script": script,
                    })
            if all_exist and scripts_in_cmd:
                results["valid"] += 1
            results["entries"].append(entry_info)

    return results


# ── Script Registry Verification ────────────────────────────────────────────

def check_script_registry() -> dict:
    """Cross-reference scripts on disk vs script-registry.md claims."""
    # Scripts on disk
    on_disk = set()
    for ext in ("*.sh", "*.py"):
        for p in (R / "scripts").glob(ext):
            on_disk.add(p.name)

    # Scripts mentioned in registry
    registry_path = R / ".claude" / "rules" / "script-registry.md"
    in_registry = set()
    if registry_path.exists():
        text = registry_path.read_text(errors="replace")
        # Extract script names from table rows: | `script-name.sh` |
        for m in re.finditer(r"`([\w.-]+\.(?:sh|py))`", text):
            in_registry.add(m.group(1))

    return {
        "on_disk": sorted(on_disk),
        "in_registry": sorted(in_registry),
        "on_disk_count": len(on_disk),
        "in_registry_count": len(in_registry),
        "missing_from_registry": sorted(on_disk - in_registry),
        "phantom_in_registry": sorted(in_registry - on_disk),
    }


# ── Version Registry Verification ──────────────────────────────────────────

def check_version_registry(all_files: dict) -> dict:
    """Cross-reference frontmatter versions vs version-registry.md."""
    registry_path = R / "_genesis" / "version-registry.md"
    if not registry_path.exists():
        return {"error": "version-registry.md not found"}

    text = registry_path.read_text(errors="replace")
    # Parse table rows: | path | version | status | date |
    registry_entries = {}
    for line in text.split("\n"):
        cells = [c.strip() for c in line.split("|")]
        if len(cells) >= 5 and "/" in cells[1]:  # has a path-like cell
            path = cells[1].strip("`").strip()
            ver = cells[2].strip("`").strip()
            status = cells[3].strip("`").strip()
            registry_entries[path] = {"version": ver, "status": status}

    mismatches = []
    for path, reg in registry_entries.items():
        if path in all_files:
            fm = all_files[path].get("frontmatter", {})
            if fm:
                fm_ver = fm.get("version", "")
                fm_status = fm.get("status", "")
                if fm_ver and reg["version"] and fm_ver != reg["version"]:
                    mismatches.append({
                        "file": path,
                        "registry_version": reg["version"],
                        "frontmatter_version": fm_ver,
                    })
                if fm_status and reg["status"] and fm_status != reg["status"]:
                    mismatches.append({
                        "file": path,
                        "registry_status": reg["status"],
                        "frontmatter_status": fm_status,
                    })

    return {
        "registry_entries": len(registry_entries),
        "mismatch_count": len(mismatches),
        "mismatches": mismatches[:30],
    }


# ── DSBV Routing Verification ──────────────────────────────────────────────

def check_dsbv_routing() -> dict:
    """Verify DSBV files are NOT in 2-LEARN/ and DESIGN.md placement is correct."""
    issues = []

    # Check: no DSBV files in 2-LEARN/
    learn_path = R / "2-LEARN"
    if learn_path.exists():
        for dsbv_file in ("DESIGN.md", "SEQUENCE.md", "VALIDATE.md"):
            hits = list(learn_path.rglob(dsbv_file))
            for h in hits:
                issues.append({
                    "type": "dsbv-in-learn",
                    "file": str(h.relative_to(R)),
                    "severity": "CRITICAL",
                })

    # Check: DESIGN.md and SEQUENCE.md at subsystem level
    for ws_dir in ["1-ALIGN", "3-PLAN", "4-EXECUTE", "5-IMPROVE"]:
        ws_path = R / ws_dir
        if not ws_path.exists():
            continue
        for dsbv_file in ("DESIGN.md", "SEQUENCE.md"):
            # Should be at subsystem level, not WS root
            root_hit = ws_path / dsbv_file
            if root_hit.exists():
                issues.append({
                    "type": "dsbv-at-ws-root",
                    "file": str(root_hit.relative_to(R)),
                    "note": f"{dsbv_file} should be at subsystem level, not workstream root",
                    "severity": "WARN",
                })

    # Check: VALIDATE.md at workstream root (not subsystem)
    for ws_dir in ["1-ALIGN", "3-PLAN", "4-EXECUTE", "5-IMPROVE"]:
        ws_path = R / ws_dir
        if not ws_path.exists():
            continue
        for sub in ws_path.iterdir():
            if sub.is_dir() and (sub / "VALIDATE.md").exists():
                issues.append({
                    "type": "validate-at-subsystem",
                    "file": str((sub / "VALIDATE.md").relative_to(R)),
                    "note": "VALIDATE.md should be at workstream root, not subsystem level",
                    "severity": "WARN",
                })

    return {
        "issue_count": len(issues),
        "issues": issues,
    }


# ── Subsystem Chain Verification ────────────────────────────────────────────

def check_subsystem_structure() -> dict:
    """Verify PD→DP→DA→IDM subsystem structure in each workstream."""
    expected_subs = {"1-PD", "2-DP", "3-DA", "4-IDM", "_cross"}
    results = {}

    for ws_dir in ["1-ALIGN", "2-LEARN", "3-PLAN", "4-EXECUTE", "5-IMPROVE"]:
        ws_path = R / ws_dir
        if not ws_path.exists():
            results[ws_dir] = {"exists": False}
            continue

        actual_dirs = {d.name for d in ws_path.iterdir() if d.is_dir()}
        results[ws_dir] = {
            "exists": True,
            "expected_dirs": sorted(expected_subs),
            "actual_dirs": sorted(actual_dirs),
            "missing": sorted(expected_subs - actual_dirs),
            "extra": sorted(actual_dirs - expected_subs),
        }

    return results


# ── Main ────────────────────────────────────────────────────────────────────

def main():
    ap = argparse.ArgumentParser(description="Claude audit Phase 0 — local extraction")
    ap.add_argument("--summary", action="store_true", help="Print human-readable summary to stderr")
    args = ap.parse_args()

    if args.summary:
        print("claude-audit-phase0: scanning...", file=sys.stderr)

    # Core scan
    scan = scan_files()
    all_files = scan["files"]
    areas = scan["areas"]

    # Cross-checks
    fm_health = check_frontmatter(all_files)
    wl_health = check_wikilinks(all_files)
    validations = run_validations()
    git = git_state()
    hook_chain = check_hook_chain()
    script_reg = check_script_registry()
    version_reg = check_version_registry(all_files)
    dsbv_routing = check_dsbv_routing()
    subsystem_struct = check_subsystem_structure()

    # Aggregate counts
    counts = {
        "tracked_files": len(all_files),
        "md_files": len([f for f in all_files if f.endswith(".md")]),
        "scripts": len([f for f in all_files if f.startswith("scripts/")]),
        "skills": len([
            f for f in all_files
            if f.startswith(".claude/skills/") and f.endswith("SKILL.md")
        ]),
        "rules": len([
            f for f in all_files
            if f.startswith(".claude/rules/") and f.endswith(".md")
            and not f.endswith("README.md")
        ]),
        "hooks": hook_chain.get("total_entries", 0),
        "areas": len(areas),
        "total_chars": sum(a["total_chars"] for a in areas.values()),
        "total_lines": sum(a["total_lines"] for a in areas.values()),
    }

    # Build manifest
    manifest = {
        "meta": {
            "date": TODAY,
            "repo": R.name,
            "script": "claude-audit-phase0.py",
            "version": "1.0",
        },
        "counts": counts,
        "areas": {
            name: {
                "description": data["description"],
                "file_count": data["file_count"],
                "total_chars": data["total_chars"],
                "total_lines": data["total_lines"],
                "files": data["files"],
            }
            for name, data in sorted(areas.items())
        },
        "frontmatter": fm_health,
        "wikilinks": wl_health,
        "hook_chain": hook_chain,
        "script_registry": script_reg,
        "version_registry": version_reg,
        "dsbv_routing": dsbv_routing,
        "subsystem_structure": subsystem_struct,
        "validations": validations,
        "git": git,
    }

    # Human-readable summary to stderr
    if args.summary:
        print(f"\n{'='*60}", file=sys.stderr)
        print(f"  CLAUDE AUDIT PHASE 0 — LOCAL EXTRACTION", file=sys.stderr)
        print(f"{'='*60}", file=sys.stderr)
        print(f"  Date:    {TODAY}", file=sys.stderr)
        print(f"  Repo:    {R.name}", file=sys.stderr)
        print(f"  Branch:  {git['branch']}", file=sys.stderr)
        print(f"  Ahead:   {git['ahead']} commits", file=sys.stderr)
        print(f"  Files:   {counts['tracked_files']} tracked "
              f"({counts['md_files']} md, {counts['scripts']} scripts)", file=sys.stderr)
        print(f"  Skills:  {counts['skills']} | Rules: {counts['rules']} "
              f"| Hooks: {counts['hooks']}", file=sys.stderr)
        print(f"  Areas:   {counts['areas']}", file=sys.stderr)
        print(f"{'─'*60}", file=sys.stderr)

        # Area summary
        for name, data in sorted(areas.items()):
            fc = data["file_count"]
            tc = data["total_chars"]
            print(f"  {name:25s}  {fc:4d} files  {tc:>8,} chars", file=sys.stderr)

        print(f"{'─'*60}", file=sys.stderr)

        # Issue counts
        print(f"  Frontmatter issues: {fm_health['issue_count']}", file=sys.stderr)
        print(f"  Wikilink orphans:   {wl_health['orphan_count']}", file=sys.stderr)
        print(f"  Hook chain broken:  {len(hook_chain.get('broken', []))}", file=sys.stderr)
        print(f"  Script reg gaps:    {len(script_reg.get('missing_from_registry', []))}", file=sys.stderr)
        print(f"  Version mismatches: {version_reg.get('mismatch_count', '?')}", file=sys.stderr)
        print(f"  DSBV routing issues:{dsbv_routing['issue_count']}", file=sys.stderr)
        print(f"{'='*60}\n", file=sys.stderr)

    # JSON manifest to stdout
    json.dump(manifest, sys.stdout, indent=2, default=str)
    print()  # trailing newline


if __name__ == "__main__":
    main()
