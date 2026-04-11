#!/usr/bin/env python3
# version: 1.3 | status: in-review | last_updated: 2026-04-09
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
ITERATION = 1
VERSION = f"{ITERATION}.0"

# ── Bases file mapping (actual filenames in _genesis/obsidian/bases/) ─
BASES_FILE = {
    "1-ALIGN": "08-alignment-overview.base",
    "2-LEARN": "09-learning-overview.base",
    "3-PLAN": "10-planning-overview.base",
    "4-EXECUTE": "11-execution-overview.base",
    "5-IMPROVE": "12-improvement-overview.base",
}

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
        "has_cross": True,
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

# Full ALPEI ring diagrams — pre-computed per workstream
WS_CONNECTION_DIAGRAMS = {
    "1-ALIGN": """\
```
                              validated alignment package
(project mandate / 5-IMPROVE)  ──────────────────────────>  2-LEARN
          ▲                                                       │
          │ iteration retrospective                    Effective Principles
          │ + next-version scope                                  │
          │                                                       ▼
          └────── 5-IMPROVE  ◄── 4-EXECUTE  ◄── 3-PLAN  ◄────────┘
```

- **1-ALIGN → 2-LEARN:** Validated alignment package — chartered scope, approved OKRs, governing constraints
- **5-IMPROVE → 1-ALIGN:** Iteration retrospective closes the loop — next version re-enters here
- **Any WS → 1-ALIGN:** Scope change or misalignment discovered → re-align before proceeding""",

    "2-LEARN": """\
```
                         validated alignment package
1-ALIGN  ────────────────────────────────────────────>  2-LEARN
                                                             │
                                              Effective Principles
                                              + DSBV Readiness Package
                                                             │
                                                             ▼
                                                         3-PLAN
```

- **1-ALIGN → 2-LEARN:** Chartered scope + constraints that bound what to research
- **2-LEARN → 3-PLAN:** Validated Effective Principles + DSBV-READY package per subsystem
- **2-LEARN → 1-ALIGN:** Research reveals scope gap → re-align before continuing""",

    "3-PLAN": """\
```
                  Effective Principles + DSBV Readiness Package
2-LEARN  ──────────────────────────────────────────────────>  3-PLAN
                                                                  │
                                               approved architecture
                                               + UBS/UDS registers + roadmap
                                                                  │
                                                                  ▼
                                                             4-EXECUTE
```

- **2-LEARN → 3-PLAN:** Effective Principles as hard architectural constraints; DSBV-READY confirms research complete
- **3-PLAN → 4-EXECUTE:** Approved architecture, risk register, ordered roadmap as the build contract
- **3-PLAN → 2-LEARN:** Unknowns surface during planning → return to research""",

    "4-EXECUTE": """\
```
                    approved architecture + roadmap
3-PLAN  ─────────────────────────────────────────────>  4-EXECUTE
                                                              │
                                                  deployed + tested artifacts
                                                  + build postmortem
                                                              │
                                                              ▼
                                                         5-IMPROVE
```

- **3-PLAN → 4-EXECUTE:** Architecture, risk register, sequenced roadmap — the build contract
- **4-EXECUTE → 5-IMPROVE:** Deployed artifacts, test results, build postmortem
- **4-EXECUTE → 3-PLAN:** Design flaw discovered mid-build → back to planning (expensive — minimize via 3-PLAN rigor)""",

    "5-IMPROVE": """\
```
                    deployed + tested artifacts
4-EXECUTE  ───────────────────────────────────────>  5-IMPROVE
                                                          │
                                              iteration retrospective
                                              + metrics + next-version scope
                                                          │
                                                          ▼
                                               1-ALIGN  (loop closes)
```

- **4-EXECUTE → 5-IMPROVE:** Deployed artifacts, test results, user feedback signals
- **5-IMPROVE → 1-ALIGN:** Retrospective closes the iteration — next version begins with re-alignment
- **5-IMPROVE → any WS:** Systemic failure → re-enter the appropriate workstream""",
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
        "purpose": "DSBV stage templates, VANA-SPEC, ADR, research, review, and 15+ artifact templates",
        "quote": "Is there a template for this, or are we inventing from scratch?",
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

{WS_CONNECTION_DIAGRAMS[ws_key]}

## DASHBOARDS

![[{BASES_FILE[ws_key]}]]
'''


def type_a_learn() -> str:
    """LEARN workstream README shell — uses learning pipeline, NOT DSBV."""
    ws = WORKSTREAMS["2-LEARN"]
    ss_list = ["1-PD", "2-DP", "3-DA", "4-IDM", "_cross"]

    structure_rows = "\n".join(
        f"| `{ss}/` | <!-- TODO: what lives here --> |" for ss in ss_list
    )

    return f'''---
version: "{VERSION}"
status: draft
last_updated: {TODAY}
work_stream: 2-LEARN
type: template
iteration: {ITERATION}
---

# 2-LEARN — {ws["tagline"]}

> "{ws["quote"]}"

## Purpose

<!-- TODO: 2-3 sentences. Lead with the failure risk this workstream prevents.
What breaks if LEARN is skipped? How does it feed 3-PLAN? -->

## The Learning Pipeline

LEARN does **NOT** use DSBV. It uses a 6-state pipeline:

```
Input  →  Research  →  Specs  →  Output  →  Archive  →  Complete
(S1)       (S2)        (S3)      (S4)       (S5)
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Input** (S1) | Capture raw material — stakeholder input, external research, observations | Timestamped capture files |
| **Research** (S2) | Analyze, synthesize, compare — produce structured knowledge | Research documents, analysis |
| **Specs** (S3) | Formalize requirements, constraints, specifications | Formal specs for downstream |
| **Output** (S4) | Publish refined learning artifacts for PLAN consumption | Validated learning outputs |
| **Archive** (S5) | Preserve completed/superseded research for reference | Archived materials |

> **HARD CONSTRAINT:** DESIGN.md, SEQUENCE.md, and VALIDATE.md must NEVER exist in 2-LEARN/.
> Enforced by: `scripts/dsbv-skill-guard.sh` (hook) + `.claude/rules/filesystem-routing.md` (Mode B).

## 3 Types of Effective Principles

LEARN produces Effective Principles that govern all downstream workstreams:

| Type | Formula | Focus |
|------|---------|-------|
| **S-Principle** | Derived from UBS analysis | Minimize failure risks |
| **E-Principle** | Derived from UDS analysis | Maximize output efficiency |
| **Sc-Principle** | Combined UBS + UDS at Iteration 4 | Scalability constraints |

## Subsystem Flow

```
PD-LEARN  →  DP-LEARN  →  DA-LEARN  →  IDM-LEARN
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| **DP** | <!-- TODO --> | **Principles from PD** + <!-- TODO --> | <!-- TODO --> |
| **DA** | <!-- TODO --> | **Principles from PD** + <!-- TODO --> | <!-- TODO --> |
| **IDM** | <!-- TODO --> | **Principles from all upstream** + <!-- TODO --> | <!-- TODO --> |

## Structure

| Folder | Contents |
|--------|---------|
{structure_rows}

## How LEARN Connects

```
                  [validated output]
1-ALIGN  ─────────────────────>  2-LEARN
                                      │
                                 [output]
                                      │
                                      ▼
                                 3-PLAN

2-LEARN ──"scope changed"──> 1-ALIGN  (re-align)
```

> **Note:** `/ingest` and `/vault-capture` write to PKB dirs (Mode C), NOT to 2-LEARN/.

## DASHBOARDS

![[{BASES_FILE["2-LEARN"]}]]
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
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| VALIDATE.md | `VALIDATE.md` (workstream root) | DSBV Validate stage — review against ACs |
| <!-- TODO: primary artifact --> | `<!-- TODO -->.md` | <!-- TODO: one-line purpose --> |
| <!-- TODO: secondary artifact --> | `<!-- TODO -->.md` | <!-- TODO: one-line purpose --> |

## Pre-Flight Checklist

- [ ] <!-- TODO: most critical gate — what must be true before this subsystem starts -->
- [ ] <!-- TODO: gate 2 — upstream artifact confirmed received -->
- [ ] <!-- TODO: gate 3 — scope boundaries agreed -->
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |
| <!-- TODO: primary artifact --> | `<!-- TODO -->-template.md` | `../../_genesis/templates/<!-- TODO -->-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
'''


def type_b_learn(ss_key: str) -> str:
    """2-LEARN subsystem README shell — uses pipeline language (S1-S5), NOT DSBV."""
    ss_full = SUBSYSTEMS[ss_key]

    if ss_key == "_cross":
        cascade = """## Scope

Cross-cutting artifacts span all 4 subsystems (PD, DP, DA, IDM) within the LEARN pipeline.
These cannot be owned by a single subsystem — they govern or support all of them.

<!-- TODO: 1-2 sentences on what cross-cutting means in this specific pipeline context. -->
<!-- Typical _cross contents: learn-input files, shared research methodology, pipeline scripts -->"""
    else:
        prev_ss, next_ss = SS_FLOW[ss_key]
        prev_label = f"{prev_ss} ({SUBSYSTEMS.get(prev_ss, '')})" if prev_ss else "1-ALIGN (chartered scope)"
        next_label = f"{next_ss} ({SUBSYSTEMS.get(next_ss, '')})" if next_ss else "(LEARN complete → 3-PLAN)"

        cascade = f"""## Cascade Position

```
[{prev_label}]  ──►  [{ss_key}]  ──►  [{next_label}]
                          ↑
     <!-- TODO: what constraint/input this subsystem anchors on from upstream -->
```

Receives from upstream: <!-- TODO: specific artifact names and source paths -->.
Produces for downstream: <!-- TODO: specific Effective Principles or research outputs --> — consumed by {next_label} as <!-- TODO: hard constraints / research seed -->."""

    return f'''---
version: "{VERSION}"
status: draft
last_updated: {TODAY}
work_stream: 2-LEARN
sub_system: {ss_key}
type: template
iteration: {ITERATION}
---

# {ss_key} — {ss_full} | LEARN Workstream

> "<!-- TODO: what breaks if this subsystem's research is missing, wrong, or shallow? -->"

<!-- TODO: 1-2 sentences. What does this subsystem research within the LEARN pipeline?
What Effective Principles does it produce, and what does it govern downstream? -->

{cascade}

## Pipeline Stages

**HARD CONSTRAINT:** No DESIGN.md, SEQUENCE.md, or VALIDATE.md in this directory.
LEARN uses the 6-state pipeline (S1–S5), not DSBV.

| Stage | Location | What happens here |
|-------|----------|------------------|
| **S1 — Scope** | `input/` | Define research questions and boundaries for this subsystem |
| **S2 — Research** | `research/` | Gather evidence with cited sources (via `/learn:research`) |
| **S3 — Structure** | `output/` | Organize into P0–P5 structured learning pages (`/learn:structure`) |
| **S4 — Review** | status on P-pages | Human review gate — approve or reject each P-page (`/learn:review`) |
| **S5 — Spec** | `specs/` | Derive Effective Principles from validated findings (`/learn:spec`) |

## Contents

| Artifact | Location | Purpose |
|----------|----------|---------|
| `learn-input-{ss_key}.md` | `_cross/input/` | Research scope definition for this subsystem |
| `T{{n}}-{{topic}}.md` | `_cross/research/{ss_key}/` | Deep research per topic (cited, structured) |
| `T0.P{{m}}-{{slug}}.md` | `output/` | P0–P5 structured learning pages |
| `vana-spec.md` | `specs/` | Extracted Effective Principles — primary output |
| `DSBV-READY-{ss_key}.md` | `specs/` | Readiness package confirming 3-PLAN can begin |

## Pre-Flight Checklist

- [ ] `learn-input-{ss_key}.md` exists and is validated (scope locked)
- [ ] <!-- TODO: specific research domain confirmed (what are the key topics?) -->
- [ ] All P0–P5 pages have `status: validated` (human-reviewed)
- [ ] `vana-spec.md` exists with Effective Principles derived from evidence
- [ ] `DSBV-READY-{ss_key}.md` confirms downstream workstream can proceed

## Templates

| Pipeline Stage | Template | Location |
|---------------|----------|----------|
| S1 — Scope | `learn-input-template.md` | `../../_genesis/templates/learn-input-template.md` |
| S2 — Research | `research-template.md` | `../../_genesis/templates/research-template.md` |
| S5 — Spec | `vana-spec-template.md` | `../../_genesis/templates/vana-spec-template.md` |

## Links

- [[SKILL]]
- [[methodology]]
- [[workstream]]
'''


def type_c(dir_key: str) -> str:
    """Directory README shell."""
    meta = GENESIS_DIRS[dir_key]
    dir_name = os.path.basename(dir_key) if "/" in dir_key else dir_key

    return f'''---
version: "{VERSION}"
status: draft
last_updated: {TODAY}
work_stream: ""
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
        if ws_key == "2-LEARN":
            targets.append(("A", path, type_a_learn))
        else:
            targets.append(("A", path, lambda wk=ws_key: type_a(wk)))

    # Type B — subsystem READMEs
    for ws_key, ws_meta in WORKSTREAMS.items():
        for ss_key in ["1-PD", "2-DP", "3-DA", "4-IDM"]:
            path = os.path.join(ROOT, ws_key, ss_key, "README.md")
            if ws_key == "2-LEARN":
                targets.append(("B", path, lambda sk=ss_key: type_b_learn(sk)))
            else:
                targets.append(("B", path, lambda wk=ws_key, sk=ss_key: type_b(wk, sk)))
        if ws_meta["has_cross"]:
            path = os.path.join(ROOT, ws_key, "_cross", "README.md")
            if ws_key == "2-LEARN":
                targets.append(("B", path, lambda: type_b_learn("_cross")))
            else:
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
