#!/usr/bin/env python3
"""Generate README shells from readme-blueprint.md for all directories.

Writes ONLY shell structure (frontmatter + section headers + placeholders).
Agents fill in actual content afterward.

Usage: python3 scripts/generate-readmes.py [--dry-run]
"""

import os
import sys
from datetime import date

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TODAY = date.today().isoformat()
ITERATION = 2
VERSION = f"{ITERATION}.0"

# ── Workstream metadata ──────────────────────────────────────────────

WORKSTREAMS = {
    "1-ALIGN": {
        "tagline": "Choose the Right Outcome",
        "quote": "Are we solving the right problem? Is everyone aligned?",
        "has_cross": True,
    },
    "2-LEARN": {
        "tagline": "Understand Before You Act",
        "quote": "What are the blockers? What are the drivers? What principles govern this system?",
        "has_cross": True,
    },
    "3-PLAN": {
        "tagline": "Minimize Failure Risks",
        "quote": "What could go wrong? How do we sequence to derisk first?",
        "has_cross": True,
    },
    "4-EXECUTE": {
        "tagline": "Deliver with Effective Process",
        "quote": "Build it right, with the right tools, in the right environment.",
        "has_cross": False,
    },
    "5-IMPROVE": {
        "tagline": "Learn, Reflect, Institutionalize",
        "quote": "What worked? What didn't? How do we make it stick?",
        "has_cross": True,
    },
}

SUBSYSTEMS = {
    "1-PD": "Problem Diagnosis",
    "2-DP": "Data Pipeline",
    "3-DA": "Data Analysis",
    "4-IDM": "Insights & Decision Making",
    "_cross": "Cross-Cutting",
}

# Upstream/downstream for workstream flow
WS_FLOW = {
    "1-ALIGN": ("(project mandate)", "2-LEARN"),
    "2-LEARN": ("1-ALIGN", "3-PLAN"),
    "3-PLAN": ("2-LEARN", "4-EXECUTE"),
    "4-EXECUTE": ("3-PLAN", "5-IMPROVE"),
    "5-IMPROVE": ("4-EXECUTE", "1-ALIGN (loop closes)"),
}

# Subsystem cascade
SS_FLOW = {
    "1-PD": (None, "2-DP"),
    "2-DP": ("1-PD", "3-DA"),
    "3-DA": ("2-DP", "4-IDM"),
    "4-IDM": ("3-DA", None),
    "_cross": (None, None),
}

# ── _genesis directory metadata ──────────────────────────────────────

GENESIS_DIRS = {
    "_genesis": {
        "purpose": "Organizational knowledge base — philosophy, principles, frameworks, and derived artifacts that ship with every project clone",
        "quote": "What foundational knowledge does every LTC project inherit?",
    },
    "_genesis/brand": {
        "purpose": "Visual identity — colors, typography, logo usage, and brand guide",
        "quote": "Would a stakeholder recognize this as an LTC deliverable?",
    },
    "_genesis/compliance": {
        "purpose": "Compliance requirements and audit artifacts",
        "quote": "Are we meeting our regulatory and policy obligations?",
    },
    "_genesis/culture": {
        "purpose": "Cultural values, team norms, and working agreements",
        "quote": "How do we work together, and what behaviors do we reward?",
    },
    "_genesis/frameworks": {
        "purpose": "System models and analytical frameworks — UBS/UDS, ALPEI, 8-component model, UES versioning, and more",
        "quote": "Which thinking model applies to this problem?",
    },
    "_genesis/governance": {
        "purpose": "Organizational governance structures and decision-making authority",
        "quote": "Who has authority to decide, and through what process?",
    },
    "_genesis/philosophy": {
        "purpose": "Core beliefs and first principles — the WHY behind everything LTC does",
        "quote": "Why do we do things this way?",
    },
    "_genesis/principles": {
        "purpose": "Non-negotiable standards derived from philosophy — the WHAT we commit to",
        "quote": "What standards are we unwilling to compromise on?",
    },
    "_genesis/reference": {
        "purpose": "Reference documents — user guide, company handbook, ALPEI PDFs, EOP governance spec",
        "quote": "Where is the authoritative source for this topic?",
    },
    "_genesis/reference/archive": {
        "purpose": "Superseded reference documents preserved for historical context",
        "quote": "What was the previous version of this reference?",
    },
    "_genesis/security": {
        "purpose": "Data classification, naming convention, security hierarchy, and access control",
        "quote": "Is this data classified correctly and handled according to policy?",
    },
    "_genesis/sops": {
        "purpose": "Standard operating procedures — repeatable processes for code review, deployment, discussions, and more",
        "quote": "What is the approved process for this activity?",
    },
    "_genesis/templates": {
        "purpose": "DSBV phase templates, VANA-SPEC, ADR, research, review, and 15+ artifact templates",
        "quote": "Is there a template for this, or are we inventing from scratch?",
    },
    "_genesis/obsidian/vault/agents": {
        "purpose": "Agent-generated notes and artifacts surfaced in the Obsidian vault",
        "quote": "What has the AI agent produced that needs human review?",
    },
    "_genesis/obsidian/vault/daily": {
        "purpose": "Daily notes — learning log, reflections, and captured observations",
        "quote": "What did we learn or decide today?",
    },
    "_genesis/obsidian/vault/inbox": {
        "purpose": "Unsorted captures — quick notes, links, and ideas awaiting triage",
        "quote": "Has everything in the inbox been triaged to its proper location?",
    },
    "_genesis/obsidian/vault/projects": {
        "purpose": "Project-level notes and dashboards within the Obsidian vault",
        "quote": "What is the current state of each active project?",
    },
    "_genesis/obsidian/vault/research": {
        "purpose": "Research captures from external sources — books, articles, courses, conversations",
        "quote": "What external knowledge has been captured and is ready for synthesis?",
    },
}


# ── Template generators ──────────────────────────────────────────────

def type_a(ws_key: str) -> str:
    """Workstream README shell."""
    ws = WORKSTREAMS[ws_key]
    num = ws_key.split("-")[0]
    name = ws_key.split("-")[1]
    upstream, downstream = WS_FLOW[ws_key]

    ss_list = ["1-PD", "2-DP", "3-DA", "4-IDM"]
    if ws.get("has_cross"):
        ss_list.append("_cross")

    structure_rows = "\n".join(
        f"| `{ss}/` | <!-- TODO: what lives here --> |" for ss in ss_list
    )

    return f'''---
version: "{VERSION}"
status: draft
last_updated: {TODAY}
work_stream: {ws_key}
type: template
iteration: {ITERATION}
---

# {ws_key} — {ws["tagline"]}

> "{ws["quote"]}"

## Purpose

<!-- TODO: 2-3 sentences. Lead with the failure risk this workstream prevents.
What breaks if this workstream is skipped? How does it feed {downstream}? -->

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | <!-- TODO --> | <!-- TODO --> |
| **Sequence** | <!-- TODO --> | <!-- TODO --> |
| **Build** | <!-- TODO --> | <!-- TODO --> |
| **Validate** | <!-- TODO --> | <!-- TODO --> |

## Subsystem Flow

```
PD-{name}  →  DP-{name}  →  DA-{name}  →  IDM-{name}
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| **DP** | <!-- TODO --> | **Principles from PD** + <!-- TODO --> | <!-- TODO --> |
| **DA** | <!-- TODO --> | **Principles from PD** + <!-- TODO --> | <!-- TODO --> |
| **IDM** | <!-- TODO --> | **Principles from all upstream** + <!-- TODO --> | <!-- TODO --> |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
{structure_rows}

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](_genesis/templates/dsbv-process.md) |
| Build | <!-- TODO: artifact-specific templates --> |
| Validate | [`review-template.md`](_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] <!-- TODO: critical gate -->
- [ ] <!-- TODO: critical gate -->

### Sequence Stage
- [ ] <!-- TODO: critical gate -->
- [ ] <!-- TODO: critical gate -->

### Build Stage
- [ ] <!-- TODO: critical gate -->
- [ ] <!-- TODO: critical gate -->

### Validate Stage
- [ ] All VANA acceptance criteria met
- [ ] Evidence basis verified
- [ ] Validated package ready for → {downstream}

## How {name} Connects

```
                  [validated output]
{upstream}  ─────────────────────>  {ws_key}
                                         │
                                    [output]
                                         │
                                         ▼
                                    {downstream}

{ws_key} ──"hit unknown"──> 2-LEARN  (loop back)
{ws_key} ──"scope changed"──> 1-ALIGN  (re-align)
```

## DASHBOARDS

![[{name} Overview.base]]
'''


def type_b(ws_key: str, ss_key: str) -> str:
    """Subsystem README shell."""
    ws_num = ws_key.split("-")[0]
    ws_name = ws_key.split("-")[1]
    ss_full = SUBSYSTEMS[ss_key]

    if ss_key == "_cross":
        cascade = f"""## Scope

Cross-cutting artifacts span all 4 subsystems (PD, DP, DA, IDM) within the {ws_name} workstream.
These cannot be owned by a single subsystem — they govern or support all of them.

<!-- TODO: 1-2 sentences on what cross-cutting means in this specific workstream -->"""
    else:
        prev_ss, next_ss = SS_FLOW[ss_key]
        prev_label = f"{prev_ss} ({SUBSYSTEMS.get(prev_ss, '')})" if prev_ss else "(workstream-level inputs)"
        next_label = f"{next_ss} ({SUBSYSTEMS.get(next_ss, '')})" if next_ss else "(workstream output)"

        cascade = f"""## Cascade Position

```
[{prev_label}]  ──►  [{ss_key}]  ──►  [{next_label}]
```

Receives from upstream: <!-- TODO: specific artifact names and source paths -->.
Produces for downstream: <!-- TODO: specific artifact names --> — consumed by {next_label} as <!-- TODO: hard constraints / inputs -->."""

    return f'''---
version: "{VERSION}"
status: draft
last_updated: {TODAY}
work_stream: {ws_key}
sub_system: {ss_key}
type: template
iteration: {ITERATION}
---

# {ss_key} — {ss_full} | {ws_name} Workstream

> "<!-- TODO: what breaks if this subsystem's {ws_name} artifacts are missing or wrong? -->"

<!-- TODO: 1-2 sentences. What does this subsystem do within this workstream?
What constraint does it receive from upstream, what does it pass downstream? -->

{cascade}

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| <!-- TODO --> | `<!-- TODO -->.md` | <!-- TODO --> |
| <!-- TODO --> | `<!-- TODO -->.md` | <!-- TODO --> |

## Pre-Flight Checklist

- [ ] <!-- TODO: most critical gate -->
- [ ] <!-- TODO: gate 2 -->
- [ ] <!-- TODO: gate 3 -->
- [ ] Artifacts here do not contradict upstream subsystem's scope or principles
- [ ] Outputs are ready for handoff to downstream
'''


def type_c(dir_key: str) -> str:
    """Directory README shell."""
    meta = GENESIS_DIRS[dir_key]
    dir_name = os.path.basename(dir_key) if "/" in dir_key else dir_key

    return f'''---
version: "{VERSION}"
status: draft
last_updated: {TODAY}
work_stream: 0-GOVERN
type: template
iteration: {ITERATION}
---

# {dir_name}

> "{meta["quote"]}"

## Purpose

{meta["purpose"]}.

<!-- TODO: 1-2 sentences on why this exists as a separate directory and what boundary it enforces -->

## What This Contains

| Content Type | Description |
|-------------|-------------|
| <!-- TODO --> | <!-- TODO --> |
| <!-- TODO --> | <!-- TODO --> |

## How It Connects

<!-- TODO: ASCII diagram showing upstream/downstream connections -->

## Pre-Flight Checklist

- [ ] <!-- TODO: most critical check -->
- [ ] <!-- TODO: second check -->
- [ ] No orphaned or stale artifacts
'''


# ── Main ─────────────────────────────────────────────────────────────

def main():
    dry_run = "--dry-run" in sys.argv
    written = 0
    skipped = 0

    targets = []

    # Type A — workstream READMEs
    for ws_key in WORKSTREAMS:
        path = os.path.join(ROOT, ws_key, "README.md")
        targets.append(("A", path, lambda wk=ws_key: type_a(wk)))

    # Type B — subsystem READMEs
    for ws_key, ws_meta in WORKSTREAMS.items():
        for ss_key in ["1-PD", "2-DP", "3-DA", "4-IDM"]:
            path = os.path.join(ROOT, ws_key, ss_key, "README.md")
            targets.append(("B", path, lambda wk=ws_key, sk=ss_key: type_b(wk, sk)))
        if ws_meta["has_cross"]:
            path = os.path.join(ROOT, ws_key, "_cross", "README.md")
            targets.append(("B", path, lambda wk=ws_key: type_b(wk, "_cross")))

    # Type C — _genesis directory READMEs
    for dir_key in GENESIS_DIRS:
        path = os.path.join(ROOT, dir_key, "README.md")
        targets.append(("C", path, lambda dk=dir_key: type_c(dk)))

    for type_label, path, generator in targets:
        rel = os.path.relpath(path, ROOT)
        if dry_run:
            print(f"  [DRY] Type {type_label}: {rel}")
            written += 1
            continue

        content = generator()
        os.makedirs(os.path.dirname(path), exist_ok=True)
        with open(path, "w") as f:
            f.write(content)
        written += 1
        print(f"  [OK]  Type {type_label}: {rel}")

    print(f"\nDone: {written} READMEs {'would be ' if dry_run else ''}written, {skipped} skipped")


if __name__ == "__main__":
    main()
