#!/usr/bin/env python3
# version: 1.1 | status: draft | last_updated: 2026-04-06
"""
populate-blueprint.py — Manifest-driven repo population for LTC Project Template.

Reads the filesystem blueprint (3-PLAN/_cross/filesystem-blueprint.md) rules and:
1. Migrates existing files from old category dirs → new subsystem dirs (git mv)
2. Creates templated artifacts for all subsystems (PD, DP, DA, IDM) + _cross
3. Creates DSBV phase files (DESIGN.md, SEQUENCE.md) per workstream×subsystem
4. Cleans up empty old dirs and orphan .gitkeep files
5. Moves Obsidian code from 4-EXECUTE/src/obsidian → _genesis/obsidian/src

Usage:
    python scripts/populate-blueprint.py --dry-run   # preview changes
    python scripts/populate-blueprint.py              # execute changes
"""

import os
import sys
import subprocess
import shutil
import re
from datetime import date
from pathlib import Path

# ─── Configuration ───────────────────────────────────────────────────────────

DRY_RUN = "--dry-run" in sys.argv
TODAY = date.today().isoformat()  # 2026-04-05
TEMPLATE_DIR = "_genesis/templates"

WORKSTREAMS = {
    "1-ALIGN": {"short": "align", "upper": "ALIGN"},
    "2-LEARN": {"short": "learn", "upper": "LEARN"},
    "3-PLAN":  {"short": "plan",  "upper": "PLAN"},
    "4-EXECUTE": {"short": "execute", "upper": "EXECUTE"},
    "5-IMPROVE": {"short": "improve", "upper": "IMPROVE"},
}

SUBSYSTEMS = {
    "1-PD":  {"short": "pd",  "full": "Problem Diagnosis"},
    "2-DP":  {"short": "dp",  "full": "Data Pipeline"},
    "3-DA":  {"short": "da",  "full": "Data Analysis"},
    "4-IDM": {"short": "idm", "full": "Insights & Decision Making"},
}

# ─── Artifact definitions per workstream ─────────────────────────────────────
# Each entry: (artifact_type, template_file_or_None, description)

SUBSYSTEM_ARTIFACTS = {
    "1-ALIGN": [
        ("charter",              "charter-template.md",        "Project charter"),
        ("okr",                  "okr-template.md",            "OKR register"),
        ("decision-adr-template","adr-template.md",            "ADR template for new decisions"),
    ],
    "2-LEARN": [
        ("ubs-analysis",         None,                         "UBS (risk) analysis"),
        ("uds-analysis",         None,                         "UDS (driver) analysis"),
        ("research-spec",        "research-template.md",       "Research specification"),
        ("effective-principles", None,                         "Effective Principles register"),
        ("literature-review",    None,                         "Literature review"),
    ],
    "3-PLAN": [
        ("architecture",         "architecture-template.md",   "Architecture document"),
        ("risk-register",        "risk-entry-template.md",     "Risk register (UBS)"),
        ("driver-register",      "driver-entry-template.md",   "Driver register (UDS)"),
        ("roadmap",              "roadmap-template.md",        "Roadmap"),
    ],
    # 4-EXECUTE: no document artifacts (code only)
    "5-IMPROVE": [
        ("changelog",            None,                         "Changelog"),
        ("metrics",              "metrics-baseline-template.md","Metrics baseline"),
        ("retro-template",       "retro-template.md",          "Retrospective template"),
    ],
}

CROSS_ARTIFACTS = {
    "1-ALIGN": [
        ("stakeholder-map",  None, "Cross-cutting stakeholder map"),
        ("stakeholder-raci", None, "Cross-cutting RACI matrix"),
    ],
    "2-LEARN": [],
    "3-PLAN": [
        ("dependency-map", None, "Cross-subsystem dependency map"),
        # filesystem-blueprint.md already exists — do not create
    ],
    "5-IMPROVE": [
        ("feedback-register", "feedback-template.md", "Cross-cutting feedback register"),
        ("changelog",         None,                   "Project-wide changelog"),
    ],
}

# ─── Migration map: old_path → (new_workstream, new_subsystem_dir, new_filename) ──

MIGRATIONS = [
    # 1-ALIGN
    ("1-ALIGN/charter/CHARTER.md",                   "1-ALIGN/1-PD/pd-charter.md"),
    ("1-ALIGN/charter/BLUEPRINT.md",                 None),  # DELETE — redirect stub
    ("1-ALIGN/decisions/ADR_REGISTER.md",            "1-ALIGN/1-PD/pd-adr-register.md"),
    ("1-ALIGN/decisions/ADR-001_data-source-selection.md", "1-ALIGN/1-PD/pd-decision-adr-001.md"),
    ("1-ALIGN/decisions/ADR-002_dashboard-framework.md",   "1-ALIGN/3-DA/da-decision-adr-002.md"),
    ("1-ALIGN/decisions/ADR-002-obsidian-cli.md",          "1-ALIGN/_cross/cross-decision-adr-003.md"),
    ("1-ALIGN/okrs/OKR_REGISTER.md",                "1-ALIGN/1-PD/pd-okr-register.md"),

    # 2-LEARN
    ("2-LEARN/input/2026-03-30-vinh-direction.md",   "2-LEARN/_cross/cross-vinh-direction.md"),
    ("2-LEARN/input/raw/2026-01-04-Vinh-ALPEI Framework.md", "2-LEARN/_cross/cross-vinh-alpei-framework.md"),
    ("2-LEARN/output/AI_First_Investment_Systems_Research.md", "2-LEARN/1-PD/pd-ai-first-investment-research.md"),
    ("2-LEARN/output/AI_First_Investment_Systems_Research.html", None),  # DELETE binary
    ("2-LEARN/output/ALPEI_AI_OS_for_PM_Research.md", "2-LEARN/_cross/cross-alpei-os-research.md"),
    ("2-LEARN/output/naming-convention-gan-synthesis.md", "2-LEARN/_cross/cross-naming-convention-synthesis.md"),
    ("2-LEARN/output/naming-convention-visual-guide.md", "2-LEARN/_cross/cross-naming-convention-guide.md"),
    ("2-LEARN/output/THINKING_MODES_GUIDE.md",       "2-LEARN/_cross/cross-thinking-modes-guide.md"),
    ("2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md", "2-LEARN/_cross/cross-stakeholder-input-synthesis.md"),
    ("2-LEARN/research/2026-03-30-vinh-branch-analysis.md", "2-LEARN/_cross/cross-vinh-branch-analysis.md"),
    ("2-LEARN/research/DP-data-pipeline-patterns.md", "2-LEARN/2-DP/dp-data-pipeline-patterns.md"),
    ("2-LEARN/research/PD-portfolio-risk-models.md",  "2-LEARN/1-PD/pd-portfolio-risk-models.md"),
    ("2-LEARN/research/Repository Structure Blue-Red Analysis.pdf", "2-LEARN/_cross/cross-repository-structure-analysis.pdf"),
    ("2-LEARN/specs/DA-visualization-spec.md",        "2-LEARN/3-DA/da-visualization-spec.md"),

    # 3-PLAN
    ("3-PLAN/architecture/ARCHITECTURE.md",           "3-PLAN/1-PD/pd-architecture.md"),
    ("3-PLAN/risks/UBS_REGISTER.md",                  "3-PLAN/1-PD/pd-risk-register.md"),
    ("3-PLAN/drivers/UDS_REGISTER.md",                "3-PLAN/1-PD/pd-driver-register.md"),
    ("3-PLAN/roadmap/ROADMAP.md",                     "3-PLAN/1-PD/pd-roadmap.md"),

    # 4-EXECUTE — Obsidian code → _genesis
    ("4-EXECUTE/src/portfolio-data-ingestion.md",     "4-EXECUTE/2-DP/docs/dp-portfolio-data-ingestion.md"),
    ("4-EXECUTE/docs/api-documentation.md",           "4-EXECUTE/2-DP/docs/dp-api-documentation.md"),
    ("4-EXECUTE/docs/frontmatter-schema.md",          "_genesis/reference/frontmatter-schema.md"),
    ("4-EXECUTE/docs/vault-structure.md",             "_genesis/obsidian/vault-structure.md"),

    # 5-IMPROVE
    ("5-IMPROVE/changelog/CHANGELOG.md",              "5-IMPROVE/_cross/cross-changelog.md"),
    ("5-IMPROVE/metrics/METRICS_BASELINE.md",         "5-IMPROVE/_cross/cross-metrics-baseline.md"),
    ("5-IMPROVE/metrics/FEEDBACK_REGISTER.md",        "5-IMPROVE/_cross/cross-feedback-register.md"),
    ("5-IMPROVE/retrospectives/RETRO-I1.md",          "5-IMPROVE/_cross/cross-retro-i1.md"),
    ("5-IMPROVE/retrospectives/RETRO-PLAN.md",        "5-IMPROVE/_cross/cross-retro-plan.md"),
    ("5-IMPROVE/reviews/OBSIDIAN_P1_DESIGN.md",       "5-IMPROVE/_cross/cross-review-obsidian-p1.md"),
    ("5-IMPROVE/reviews/VERSION-REVIEW.md",           "5-IMPROVE/_cross/cross-review-version.md"),
]

# Obsidian code migration: 4-EXECUTE/src/obsidian/ → _genesis/obsidian/src/
OBSIDIAN_MOVES = [
    ("4-EXECUTE/src/obsidian/bases/", "_genesis/obsidian/src/bases/"),
    ("4-EXECUTE/src/obsidian/templates/", "_genesis/obsidian/src/templates/"),
    ("4-EXECUTE/src/vault/", "_genesis/obsidian/vault/"),
]

# Test migration
TEST_MOVES = [
    ("4-EXECUTE/tests/obsidian/", "_genesis/obsidian/tests/"),
]

# Old dirs to delete after migration (only if empty)
OLD_DIRS_TO_CLEAN = [
    "1-ALIGN/charter", "1-ALIGN/decisions", "1-ALIGN/okrs",
    "2-LEARN/input", "2-LEARN/output", "2-LEARN/research", "2-LEARN/specs",
    "2-LEARN/archive", "2-LEARN/config", "2-LEARN/references", "2-LEARN/scripts", "2-LEARN/templates",
    "3-PLAN/architecture", "3-PLAN/risks", "3-PLAN/drivers", "3-PLAN/roadmap",
    "4-EXECUTE/config", "4-EXECUTE/docs", "4-EXECUTE/scripts",
    "4-EXECUTE/src/obsidian", "4-EXECUTE/src/vault", "4-EXECUTE/src",
    "4-EXECUTE/tests/obsidian", "4-EXECUTE/tests",
    "5-IMPROVE/changelog", "5-IMPROVE/metrics", "5-IMPROVE/retrospectives",
    "5-IMPROVE/reviews", "5-IMPROVE/risk-log",
]

# DSBV files that already exist at workstream root — keep them there
EXISTING_DSBV = {
    "1-ALIGN": ["DESIGN.md", "SEQUENCE.md", "VALIDATE.md"],
    "3-PLAN":  ["DESIGN.md", "SEQUENCE.md", "VALIDATE.md"],
    "4-EXECUTE": ["DESIGN.md", "SEQUENCE.md", "VALIDATE.md"],
    "5-IMPROVE": ["DESIGN.md", "SEQUENCE.md", "VALIDATE.md"],
}

# ─── Counters ────────────────────────────────────────────────────────────────

stats = {"migrated": 0, "created": 0, "deleted": 0, "cleaned_dirs": 0, "skipped": 0, "errors": 0}


# ─── Helpers ─────────────────────────────────────────────────────────────────

def run(cmd, check=True):
    """Run a shell command."""
    if DRY_RUN:
        print(f"  [DRY] {cmd}")
        return True
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode != 0 and check:
        print(f"  [ERR] {cmd}\n  {result.stderr.strip()}")
        stats["errors"] += 1
        return False
    return True


def make_frontmatter(work_stream, sub_system, artifact_type, stage="build"):
    """Generate standard YAML frontmatter."""
    lines = [
        "---",
        'version: "2.0"',
        "status: draft",
        f"last_updated: {TODAY}",
        f"work_stream: {work_stream}",
        f"stage: {stage}",
        f"type: {artifact_type}",
        f"sub_system: {sub_system}",
        "iteration: 2",
        "---",
    ]
    return "\n".join(lines)


def make_stub(title, description, sections=None):
    """Generate a minimal stub body."""
    body = f"# {title}\n\n> {description}\n"
    if sections:
        for s in sections:
            body += f"\n## {s}\n\n<!-- TODO: Populate during DSBV Build phase -->\n"
    body += "\n## Links\n\n- [[workstream]]\n- [[iteration]]\n"
    return body


def update_frontmatter(content, updates):
    """Update frontmatter fields in existing file content."""
    # Split frontmatter from body
    parts = content.split("---", 2)
    if len(parts) < 3:
        return content  # No frontmatter found

    fm = parts[1]
    body = parts[2]

    for key, value in updates.items():
        pattern = rf"^{key}:.*$"
        replacement = f"{key}: {value}"
        if re.search(pattern, fm, re.MULTILINE):
            fm = re.sub(pattern, replacement, fm, flags=re.MULTILINE)
        else:
            fm = fm.rstrip() + f"\n{replacement}\n"

    return f"---{fm}---{body}"


def ensure_dir(path):
    """Create directory if it doesn't exist."""
    d = os.path.dirname(path)
    if d and not os.path.exists(d):
        if DRY_RUN:
            print(f"  [DRY] mkdir -p {d}")
        else:
            os.makedirs(d, exist_ok=True)


def create_from_template(target_path, template_name, work_stream, sub_system,
                         sub_short, artifact_type, description):
    """Create a file from a template or generate a stub."""
    if os.path.exists(target_path):
        stats["skipped"] += 1
        return

    ensure_dir(target_path)
    template_path = os.path.join(TEMPLATE_DIR, template_name) if template_name else None

    if template_path and os.path.exists(template_path):
        # Read template and rewrite frontmatter
        with open(template_path, "r") as f:
            content = f.read()

        updates = {
            "work_stream": work_stream,
            "sub_system": sub_system,
            "last_updated": TODAY,
            'version': '"2.0"',
            "status": "draft",
            "stage": "build",
            "iteration": "2",
        }
        content = update_frontmatter(content, updates)

        # Replace template placeholders
        ws_info = WORKSTREAMS.get(work_stream, {})
        content = content.replace("{{WORKSTREAM}}", ws_info.get("upper", work_stream))
        content = content.replace("{{ITERATION}}", "I2: Prototype")

        if DRY_RUN:
            print(f"  [DRY] CREATE {target_path} (from {template_name})")
        else:
            with open(target_path, "w") as f:
                f.write(content)
    else:
        # Generate stub
        fm = make_frontmatter(work_stream, sub_system, artifact_type)
        title = f"{sub_short.upper()} {artifact_type.replace('-', ' ').title()}"
        if sub_short == "cross":
            title = f"Cross-Cutting {artifact_type.replace('-', ' ').title()}"
        body = make_stub(title, description, sections=[
            "Overview", "Register", "Analysis", "Links"
        ])
        content = fm + "\n" + body

        if DRY_RUN:
            print(f"  [DRY] CREATE {target_path} (stub)")
        else:
            with open(target_path, "w") as f:
                f.write(content)

    stats["created"] += 1


# ─── Phase 1: Migrate existing files ────────────────────────────────────────

def phase_1_migrate():
    print("\n=== PHASE 1: Migrate existing files ===\n")

    for old_path, new_path in MIGRATIONS:
        if not os.path.exists(old_path):
            print(f"  [SKIP] {old_path} (not found)")
            stats["skipped"] += 1
            continue

        if new_path is None:
            # DELETE
            print(f"  [DEL]  {old_path}")
            run(f'git rm -f "{old_path}"', check=False)
            stats["deleted"] += 1
            continue

        # Ensure target dir exists
        ensure_dir(new_path)

        # Remove existing file at target (e.g., starter templates we created earlier)
        if os.path.exists(new_path):
            run(f'git rm -f "{new_path}"', check=False)

        print(f"  [MOVE] {old_path} → {new_path}")
        run(f'git mv "{old_path}" "{new_path}"')

        # Update frontmatter in migrated file
        if new_path.endswith(".md") and not DRY_RUN and os.path.exists(new_path):
            with open(new_path, "r") as f:
                content = f.read()

            # Determine work_stream and sub_system from new path
            parts = new_path.split("/")
            ws = parts[0] if len(parts) > 0 else ""
            sub_dir = parts[1] if len(parts) > 1 else ""

            # Map sub_dir to sub_system value
            sub_map = {"1-PD": "1-PD", "2-DP": "2-DP", "3-DA": "3-DA",
                       "4-IDM": "4-IDM", "_cross": "_cross"}
            sub_system = sub_map.get(sub_dir, sub_dir)

            updates = {
                "work_stream": ws,
                "sub_system": sub_system,
                "last_updated": TODAY,
            }
            content = update_frontmatter(content, updates)

            with open(new_path, "w") as f:
                f.write(content)

        stats["migrated"] += 1


# ─── Phase 1b: Move Obsidian code ───────────────────────────────────────────

def phase_1b_obsidian():
    print("\n=== PHASE 1b: Move Obsidian code to _genesis/obsidian/ ===\n")

    for src_dir, dst_dir in OBSIDIAN_MOVES + TEST_MOVES:
        if not os.path.exists(src_dir):
            print(f"  [SKIP] {src_dir} (not found)")
            continue

        ensure_dir(dst_dir)

        # Move each file individually with git mv
        for root, dirs, files in os.walk(src_dir):
            for fname in files:
                old = os.path.join(root, fname)
                # Compute relative path within source
                rel = os.path.relpath(old, src_dir)
                new = os.path.join(dst_dir, rel)
                ensure_dir(new)

                if os.path.exists(new):
                    print(f"  [SKIP] {new} (already exists, keeping canonical)")
                    run(f'git rm -f "{old}"', check=False)
                    stats["deleted"] += 1
                else:
                    print(f"  [MOVE] {old} → {new}")
                    run(f'git mv "{old}" "{new}"')
                    stats["migrated"] += 1


# ─── Phase 2: Create templated artifacts ─────────────────────────────────────

def phase_2_populate():
    print("\n=== PHASE 2: Create templated artifacts ===\n")

    for ws_name, ws_info in WORKSTREAMS.items():
        if ws_name == "4-EXECUTE":
            continue  # EXECUTE has code dirs, not document artifacts

        artifacts = SUBSYSTEM_ARTIFACTS.get(ws_name, [])

        # Per-subsystem artifacts
        for sub_dir, sub_info in SUBSYSTEMS.items():
            sub_short = sub_info["short"]

            for artifact_type, template, description in artifacts:
                filename = f"{sub_short}-{artifact_type}.md"
                target = os.path.join(ws_name, sub_dir, filename)
                create_from_template(
                    target, template, ws_name, sub_dir,
                    sub_short, artifact_type, description
                )

        # Cross-cutting artifacts
        for artifact_type, template, description in CROSS_ARTIFACTS.get(ws_name, []):
            filename = f"cross-{artifact_type}.md"
            target = os.path.join(ws_name, "_cross", filename)

            # Don't overwrite filesystem-blueprint.md
            if os.path.exists(target):
                stats["skipped"] += 1
                continue

            create_from_template(
                target, template, ws_name, "_cross",
                "cross", artifact_type, description
            )


# ─── Phase 2b: Create DSBV phase files per subsystem ────────────────────────

def phase_2b_dsbv():
    print("\n=== PHASE 2b: Create DSBV phase files ===\n")

    dsbv_templates = {
        "DESIGN.md":   ("design-template.md",       "design"),
        "SEQUENCE.md": ("dsbv-context-template.md",  "sequence"),
    }

    for ws_name in WORKSTREAMS:
        if ws_name == "4-EXECUTE":
            continue  # EXECUTE DSBV stays at workstream root
        if ws_name == "2-LEARN":
            continue  # LEARN uses learning pipeline, not DSBV

        for sub_dir, sub_info in SUBSYSTEMS.items():
            for dsbv_file, (template, stage) in dsbv_templates.items():
                target = os.path.join(ws_name, sub_dir, dsbv_file)
                if os.path.exists(target):
                    stats["skipped"] += 1
                    continue

                ensure_dir(target)
                fm = make_frontmatter(ws_name, sub_dir, f"dsbv-{stage}", stage=stage)
                ws_upper = WORKSTREAMS[ws_name]["upper"]
                sub_full = sub_info["full"]

                body = f"""# DSBV {stage.upper()} — {ws_upper} × {sub_full}

> DSBV Phase artifact for {ws_upper} workstream, {sub_full} subsystem.
> Source template: `_genesis/templates/{template}`

## Scope

<!-- TODO: Define what this workstream×subsystem phase must produce -->

## Artifacts

| # | Artifact | Path | Condition |
|---|----------|------|-----------|
| A1 | <!-- TODO --> | `{ws_name}/{sub_dir}/` | <!-- TODO --> |

## Links

- [[workstream]]
- [[iteration]]
"""
                content = fm + "\n" + body

                if DRY_RUN:
                    print(f"  [DRY] CREATE {target} (DSBV {stage})")
                else:
                    with open(target, "w") as f:
                        f.write(content)

                stats["created"] += 1


# ─── Phase 3: Create subsystem READMEs where missing ────────────────────────

def phase_3_readmes():
    print("\n=== PHASE 3: Ensure subsystem READMEs ===\n")

    for ws_name, ws_info in WORKSTREAMS.items():
        subs = list(SUBSYSTEMS.items())
        if ws_name != "4-EXECUTE":
            subs.append(("_cross", {"short": "cross", "full": "Cross-Cutting"}))

        for sub_dir, sub_info in subs:
            target = os.path.join(ws_name, sub_dir, "README.md")
            if os.path.exists(target):
                stats["skipped"] += 1
                continue

            # This shouldn't happen since we already populated READMEs, but just in case
            fm = make_frontmatter(ws_name, sub_dir, "readme", stage="build")
            body = make_stub(
                f"{ws_info['upper']} — {sub_info['full']}",
                f"Subsystem artifacts for {sub_info['full']} within {ws_info['upper']} workstream.",
                sections=["Purpose", "Contents", "Cascade Position"]
            )
            content = fm + "\n" + body

            if DRY_RUN:
                print(f"  [DRY] CREATE {target} (README)")
            else:
                ensure_dir(target)
                with open(target, "w") as f:
                    f.write(content)

            stats["created"] += 1


# ─── Phase 4: Clean up old dirs ─────────────────────────────────────────────

def phase_4_cleanup():
    print("\n=== PHASE 4: Clean up old dirs ===\n")

    # First, delete all .gitkeep in dirs that now have content
    for ws_name in WORKSTREAMS:
        subs = list(SUBSYSTEMS.keys())
        if ws_name != "4-EXECUTE":
            subs.append("_cross")

        for sub_dir in subs:
            gitkeep = os.path.join(ws_name, sub_dir, ".gitkeep")
            dirpath = os.path.join(ws_name, sub_dir)
            if os.path.exists(gitkeep):
                # Check if dir has other files
                other_files = [f for f in os.listdir(dirpath) if f != ".gitkeep"]
                if other_files:
                    print(f"  [DEL]  {gitkeep} (dir has {len(other_files)} files)")
                    run(f'git rm -f "{gitkeep}"', check=False)
                    stats["deleted"] += 1

    # Then remove old category dirs (bottom-up to handle nesting)
    for old_dir in sorted(OLD_DIRS_TO_CLEAN, key=len, reverse=True):
        if not os.path.exists(old_dir):
            continue

        # Check if empty (only .gitkeep or truly empty)
        remaining = []
        for root, dirs, files in os.walk(old_dir):
            for f in files:
                if f != ".gitkeep":
                    remaining.append(os.path.join(root, f))

        if remaining:
            print(f"  [WARN] {old_dir} still has {len(remaining)} files: {remaining[:3]}")
            continue

        print(f"  [RMDIR] {old_dir}")
        if not DRY_RUN:
            # Remove .gitkeep files first
            for root, dirs, files in os.walk(old_dir):
                for f in files:
                    fp = os.path.join(root, f)
                    subprocess.run(f'git rm -f "{fp}"', shell=True, capture_output=True)
            # Remove empty dirs
            try:
                shutil.rmtree(old_dir)
            except OSError:
                pass
        stats["cleaned_dirs"] += 1


# ─── Phase 5: Remove training deck duplicate ────────────────────────────────

def phase_5_execute_cleanup():
    """Clean up 4-EXECUTE files that moved elsewhere or are duplicates."""
    print("\n=== PHASE 5: EXECUTE cleanup ===\n")

    # design-autolinker.md and sequence-autolinker.md are orphan DSBV artifacts
    for f in ["4-EXECUTE/design-autolinker.md", "4-EXECUTE/sequence-autolinker.md"]:
        if os.path.exists(f):
            print(f"  [DEL] {f} (orphan DSBV artifact)")
            run(f'git rm -f "{f}"', check=False)
            stats["deleted"] += 1

    # Training deck — check if already in _genesis/training
    train_src = "4-EXECUTE/docs/training"
    train_dst = "_genesis/training"
    if os.path.exists(train_src):
        if os.path.exists(train_dst):
            print(f"  [DEL] {train_src} (duplicate of {train_dst})")
            if not DRY_RUN:
                for root, dirs, files in os.walk(train_src):
                    for f in files:
                        fp = os.path.join(root, f)
                        subprocess.run(f'git rm -f "{fp}"', shell=True, capture_output=True)
                try:
                    shutil.rmtree(train_src)
                except OSError:
                    pass
            stats["deleted"] += 1


# ─── Main ────────────────────────────────────────────────────────────────────

def main():
    if DRY_RUN:
        print("=" * 60)
        print("  DRY RUN — no files will be changed")
        print("=" * 60)
    else:
        print("=" * 60)
        print("  EXECUTING — files will be modified")
        print("=" * 60)

    phase_1_migrate()
    phase_1b_obsidian()
    phase_2_populate()
    phase_2b_dsbv()
    phase_3_readmes()
    phase_4_cleanup()
    phase_5_execute_cleanup()

    print("\n" + "=" * 60)
    print(f"  SUMMARY")
    print(f"  Migrated:     {stats['migrated']}")
    print(f"  Created:      {stats['created']}")
    print(f"  Deleted:      {stats['deleted']}")
    print(f"  Cleaned dirs: {stats['cleaned_dirs']}")
    print(f"  Skipped:      {stats['skipped']}")
    print(f"  Errors:       {stats['errors']}")
    print("=" * 60)

    if stats["errors"] > 0:
        print("\n⚠ ERRORS DETECTED — review output above")
        sys.exit(1)


if __name__ == "__main__":
    main()
