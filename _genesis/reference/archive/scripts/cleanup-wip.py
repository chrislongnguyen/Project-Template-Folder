#!/usr/bin/env python3
"""
cleanup-wip.py — Remove all WIP/demo/personal content from template repo.

A template repo should contain ONLY:
- Clean templates with TODOs (no project-specific content)
- Structural files (READMEs, DSBV phase files)
- _genesis/ (shared frameworks, templates, obsidian infra)
- .claude/ (agent config)
- scripts/ (infrastructure)

This script:
1. Deletes all WIP/demo/personal content
2. Replaces migrated files (that have dummy content) with clean templates
3. Adds missing VALIDATE.md files
4. Cleans personal dirs (DAILY-NOTES, inbox, MISC-TASKS, PEOPLE)
5. Removes orphan dirs
"""

import os
import sys
import subprocess
import shutil

DRY_RUN = "--dry-run" in sys.argv
stats = {"deleted": 0, "replaced": 0, "created": 0, "errors": 0}

def run(cmd):
    if DRY_RUN:
        print(f"  [DRY] {cmd}")
        return True
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"  [ERR] {cmd}: {result.stderr.strip()}")
        stats["errors"] += 1
        return False
    return True

def delete(path):
    """Delete a file via git rm."""
    if not os.path.exists(path):
        return
    print(f"  [DEL] {path}")
    run(f'git rm -f "{path}"')
    stats["deleted"] += 1

def delete_dir(path):
    """Delete an entire directory."""
    if not os.path.exists(path):
        return
    print(f"  [RMDIR] {path}")
    if not DRY_RUN:
        for root, dirs, files in os.walk(path):
            for f in files:
                subprocess.run(f'git rm -f "{os.path.join(root, f)}"', shell=True, capture_output=True)
        shutil.rmtree(path, ignore_errors=True)
    stats["deleted"] += 1

def make_fm(ws, sub, ftype, stage="build"):
    return f"""---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: {ws}
stage: {stage}
type: {ftype}
sub_system: {sub}
iteration: 2
---
"""

# ─── 1. Delete WIP/demo ADRs and migrated dummy content ─────────────────────

def phase_1():
    print("\n=== PHASE 1: Delete WIP/demo content ===\n")

    # Dummy ADRs
    delete("1-ALIGN/1-PD/pd-decision-adr-001.md")
    delete("1-ALIGN/3-DA/da-decision-adr-002.md")
    delete("1-ALIGN/_cross/cross-decision-adr-003.md")

    # Migrated files with project-specific content → delete (templates exist or will be recreated)
    for f in [
        "1-ALIGN/1-PD/pd-charter.md",       # has Long's project charter
        "1-ALIGN/1-PD/pd-adr-register.md",   # has dummy ADR list
        "1-ALIGN/1-PD/pd-okr-register.md",   # has dummy OKRs
        "3-PLAN/1-PD/pd-architecture.md",     # has dummy architecture
        "3-PLAN/1-PD/pd-risk-register.md",    # has dummy UBS risks
        "3-PLAN/1-PD/pd-driver-register.md",  # has dummy UDS drivers
        "3-PLAN/1-PD/pd-roadmap.md",          # has dummy roadmap
    ]:
        delete(f)

    # Dummy EXECUTE docs
    delete("4-EXECUTE/2-DP/docs/dp-portfolio-data-ingestion.md")
    delete("4-EXECUTE/2-DP/docs/dp-api-documentation.md")

    # WIP DSBV artifacts from our sessions
    delete("4-EXECUTE/VALIDATE.md")
    delete("1-ALIGN/VALIDATE.md")
    delete("3-PLAN/VALIDATE.md")
    delete("5-IMPROVE/VALIDATE.md")

    # WIP IMPROVE artifacts
    for f in [
        "5-IMPROVE/_cross/cross-retro-i1.md",
        "5-IMPROVE/_cross/cross-retro-plan.md",
        "5-IMPROVE/_cross/cross-review-obsidian-p1.md",
        "5-IMPROVE/_cross/cross-review-version.md",
        "5-IMPROVE/_cross/cross-changelog.md",
        "5-IMPROVE/_cross/cross-metrics-baseline.md",
        "5-IMPROVE/_cross/cross-feedback-register.md",
    ]:
        delete(f)


# ─── 2. Delete all 2-LEARN migrated research (project-specific) ─────────────

def phase_2():
    print("\n=== PHASE 2: Delete project-specific research ===\n")

    for f in [
        "2-LEARN/1-PD/pd-ai-first-investment-research.md",
        "2-LEARN/1-PD/pd-portfolio-risk-models.md",
        "2-LEARN/2-DP/dp-data-pipeline-patterns.md",
        "2-LEARN/3-DA/da-visualization-spec.md",
        "2-LEARN/_cross/cross-vinh-direction.md",
        "2-LEARN/_cross/cross-vinh-alpei-framework.md",
        "2-LEARN/_cross/cross-alpei-os-research.md",
        "2-LEARN/_cross/cross-naming-convention-synthesis.md",
        "2-LEARN/_cross/cross-naming-convention-guide.md",
        "2-LEARN/_cross/cross-thinking-modes-guide.md",
        "2-LEARN/_cross/cross-stakeholder-input-synthesis.md",
        "2-LEARN/_cross/cross-vinh-branch-analysis.md",
        "2-LEARN/_cross/cross-repository-structure-analysis.pdf",
    ]:
        delete(f)


# ─── 3. Clean personal dirs ─────────────────────────────────────────────────

def phase_3():
    print("\n=== PHASE 3: Clean personal dirs ===\n")

    # DAILY-NOTES: keep .gitkeep, delete all content
    for f in os.listdir("DAILY-NOTES"):
        if f != ".gitkeep":
            delete(f"DAILY-NOTES/{f}")

    # inbox: keep .gitkeep, delete all content
    for f in os.listdir("inbox"):
        if f != ".gitkeep":
            delete(f"inbox/{f}")

    # MISC-TASKS: keep .gitkeep, delete all content
    for f in os.listdir("MISC-TASKS"):
        if f != ".gitkeep":
            delete(f"MISC-TASKS/{f}")

    # PEOPLE: delete entire dir (not in blueprint)
    if os.path.exists("PEOPLE"):
        delete_dir("PEOPLE")

    # Orphan metrics dir
    delete_dir("5-IMPROVE/metrics/multi-agent-eval")
    if os.path.exists("5-IMPROVE/metrics"):
        shutil.rmtree("5-IMPROVE/metrics", ignore_errors=True)


# ─── 4. Recreate deleted files as clean templates ───────────────────────────

def phase_4():
    print("\n=== PHASE 4: Recreate clean templates ===\n")

    templates = [
        # ALIGN PD
        ("1-ALIGN/1-PD/pd-charter.md", "1-ALIGN", "1-PD", "charter", "Charter — Problem Diagnosis",
         ["Project Identity", "Expected Outcome (EO)", "Scope", "Stakeholders", "Success Criteria", "Constraints"]),
        ("1-ALIGN/1-PD/pd-okr-register.md", "1-ALIGN", "1-PD", "okr", "OKR Register — Problem Diagnosis",
         ["Objectives", "Key Results", "Alignment to Charter"]),

        # PLAN PD
        ("3-PLAN/1-PD/pd-architecture.md", "3-PLAN", "1-PD", "architecture", "Architecture — Problem Diagnosis",
         ["Architecture Summary", "Component Design", "Key Decisions", "Constraints from ALIGN", "Quality Attributes (S>E>Sc)"]),
        ("3-PLAN/1-PD/pd-risk-register.md", "3-PLAN", "1-PD", "risk-register", "Risk Register (UBS) — Problem Diagnosis",
         ["Risk Register", "Risk Heat Map", "Mitigation Plans"]),
        ("3-PLAN/1-PD/pd-driver-register.md", "3-PLAN", "1-PD", "driver-register", "Driver Register (UDS) — Problem Diagnosis",
         ["Driver Register", "Force Analysis", "Leverage Strategy"]),
        ("3-PLAN/1-PD/pd-roadmap.md", "3-PLAN", "1-PD", "roadmap", "Roadmap — Problem Diagnosis",
         ["Iteration Map", "Milestones", "Dependencies", "Timeline"]),

        # IMPROVE _cross
        ("5-IMPROVE/_cross/cross-changelog.md", "5-IMPROVE", "_cross", "changelog", "Project Changelog",
         ["Unreleased", "Iteration 2: Prototype", "Iteration 1: Concept"]),
        ("5-IMPROVE/_cross/cross-metrics-baseline.md", "5-IMPROVE", "_cross", "metrics", "Metrics Baseline",
         ["Sustainability Metrics", "Efficiency Metrics", "Scalability Metrics", "Collection Schedule"]),
        ("5-IMPROVE/_cross/cross-feedback-register.md", "5-IMPROVE", "_cross", "feedback-register", "Feedback Register",
         ["Feedback Log", "Triage Process", "Resolution Tracking"]),

        # VALIDATE.md per workstream (templated, not WIP)
        ("1-ALIGN/VALIDATE.md", "1-ALIGN", "_cross", "dsbv-validate", "DSBV VALIDATE — ALIGN",
         ["Validation Criteria", "Evidence Matrix", "Verdict"]),
        ("3-PLAN/VALIDATE.md", "3-PLAN", "_cross", "dsbv-validate", "DSBV VALIDATE — PLAN",
         ["Validation Criteria", "Evidence Matrix", "Verdict"]),
        ("4-EXECUTE/VALIDATE.md", "4-EXECUTE", "_cross", "dsbv-validate", "DSBV VALIDATE — EXECUTE",
         ["Validation Criteria", "Evidence Matrix", "Verdict"]),
        ("5-IMPROVE/VALIDATE.md", "5-IMPROVE", "_cross", "dsbv-validate", "DSBV VALIDATE — IMPROVE",
         ["Validation Criteria", "Evidence Matrix", "Verdict"]),
    ]

    for path, ws, sub, ftype, title, sections in templates:
        if os.path.exists(path):
            stats["replaced"] += 1
            continue

        stage = "validate" if "validate" in ftype else "build"
        fm = make_fm(ws, sub, ftype, stage=stage)
        body = f"# {title}\n\n> Template — populate during DSBV Build phase.\n"
        for s in sections:
            body += f"\n## {s}\n\n<!-- TODO: Fill during DSBV Build -->\n"
        body += "\n## Links\n\n- [[workstream]]\n- [[iteration]]\n"

        print(f"  [CREATE] {path}")
        if not DRY_RUN:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, "w") as f:
                f.write(fm + "\n" + body)
        stats["created"] += 1


# ─── 5. Add missing VALIDATE.md per subsystem ───────────────────────────────

def phase_5():
    print("\n=== PHASE 5: Add missing subsystem VALIDATE.md ===\n")

    WORKSTREAMS = ["1-ALIGN", "2-LEARN", "3-PLAN", "5-IMPROVE"]
    SUBSYSTEMS = ["1-PD", "2-DP", "3-DA", "4-IDM"]

    for ws in WORKSTREAMS:
        for sub in SUBSYSTEMS:
            path = f"{ws}/{sub}/VALIDATE.md"
            if os.path.exists(path):
                continue

            ws_upper = ws.split("-")[1]
            sub_full = {"1-PD": "Problem Diagnosis", "2-DP": "Data Pipeline",
                        "3-DA": "Data Analysis", "4-IDM": "Insights & Decision Making"}[sub]

            fm = make_fm(ws, sub, "dsbv-validate", stage="validate")
            body = f"""# DSBV VALIDATE — {ws_upper} × {sub_full}

> DSBV Validate phase artifact. Evidence-based review against DESIGN.md criteria.
> Source template: `_genesis/templates/dsbv-eval-template.md`

## Validation Criteria

| # | Criterion | Evidence | Verdict |
|---|-----------|----------|---------|
| V1 | <!-- TODO --> | <!-- TODO --> | PASS / FAIL |

## Verdict

<!-- TODO: Overall pass/fail with justification -->

## Links

- [[workstream]]
- [[iteration]]
"""
            print(f"  [CREATE] {path}")
            if not DRY_RUN:
                with open(path, "w") as f:
                    f.write(fm + "\n" + body)
            stats["created"] += 1


# ─── Main ────────────────────────────────────────────────────────────────────

def main():
    mode = "DRY RUN" if DRY_RUN else "EXECUTING"
    print(f"{'='*60}\n  {mode} — WIP Cleanup\n{'='*60}")

    phase_1()
    phase_2()
    phase_3()
    phase_4()
    phase_5()

    print(f"\n{'='*60}")
    print(f"  Deleted:   {stats['deleted']}")
    print(f"  Created:   {stats['created']}")
    print(f"  Replaced:  {stats['replaced']}")
    print(f"  Errors:    {stats['errors']}")
    print(f"{'='*60}")

    if stats["errors"] > 0:
        sys.exit(1)

if __name__ == "__main__":
    main()
