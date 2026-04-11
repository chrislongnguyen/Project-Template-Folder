---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 0-GOVERN
type: template
iteration: 2
---

# README Blueprint

> Reference for writing any README in this repo — workstream, subsystem, subfolder, or root.

Every README answers one question: **"What is this directory for, and how does it connect to everything else?"**
It does not describe implementation detail — that belongs in the artifacts inside the folder.

---

## 1. README Type Selector

Pick the type that matches the directory level, then use its template below.

| Type | Applies to | Length |
|------|-----------|--------|
| **A — Workstream** | `1-ALIGN/`, `2-LEARN/`, `3-PLAN/`, `4-EXECUTE/`, `5-IMPROVE/` (top-level only) | Long (~120 lines) |
| **B — Subsystem** | `{WS}/{SS}/` dirs: `1-PD/`, `2-DP/`, `3-DA/`, `4-IDM/`, `_cross/` | Medium (~60 lines) |
| **C — Directory** | Any other named directory (`_genesis/brand/`, `risks/`, `charter/`, etc.) | Short (~30 lines) |
| **D — Root** | Repo root `README.md` only | Special — see note |

> **Root README (Type D):** One-of-a-kind. It is the project's front door for humans and AI alike. Do not use Type A–C templates for it. The existing root `README.md` is the canonical reference.

---

## 2. Fill-In Reference

Before writing any README, resolve these values. Every placeholder below maps to one of these fields.

| Placeholder | What to fill in | Example |
|-------------|----------------|---------|
| `{WS_NUM}` | Workstream number | `1` |
| `{WS_NAME}` | Workstream name in CAPS | `ALIGN` |
| `{WS_TAGLINE}` | One-phrase mission of this workstream | `Choose the Right Outcome` |
| `{WS_QUOTE}` | Risk-first framing question | `"Are we solving the right problem?"` |
| `{SS_NUM}` | Subsystem number | `1` |
| `{SS_NAME}` | Subsystem name | `PD` |
| `{SS_FULL}` | Subsystem full name | `Problem Diagnosis` |
| `{DIR_NAME}` | Directory name as it appears in the filesystem | `risks/` |
| `{DIR_PURPOSE}` | One sentence — what this dir holds | `UBS register — all identified blocking forces` |
| `{UPSTREAM}` | Workstream or dir that feeds into this one | `1-ALIGN` |
| `{DOWNSTREAM}` | Workstream or dir that consumes this one's output | `3-PLAN` |

---

## 3. Type A — Workstream README

Use for: `1-ALIGN/README.md`, `2-LEARN/README.md`, `3-PLAN/README.md`, `4-EXECUTE/README.md`, `5-IMPROVE/README.md`

```markdown
---
version: "{MAJOR}.0"
status: draft
last_updated: {YYYY-MM-DD}
work_stream: {WS_NUM}-{WS_NAME}
type: template
iteration: {N}
---

# {WS_NUM}-{WS_NAME} — {WS_TAGLINE}

> {WS_QUOTE}

## Purpose

[2–3 sentences. Lead with the failure risk this workstream prevents — not what it does.
What breaks in the project if this workstream is skipped or done badly?
End with how it feeds the next workstream.]

## The 4 Stages

Every subsystem (PD, DP, DA, IDM) flows through these stages:

```
DESIGN  →  SEQUENCE  →  BUILD  →  VALIDATE
```

| Stage | Purpose | Key Output |
|-------|---------|-----------|
| **Design** | [What gets decided] | [Primary deliverable] |
| **Sequence** | [What gets ordered] | [Primary deliverable] |
| **Build** | [What gets produced] | [Primary deliverable] |
| **Validate** | [What gets verified] | [Primary deliverable] |

## Subsystem Flow

```
PD-{WS_NAME}  →  DP-{WS_NAME}  →  DA-{WS_NAME}  →  IDM-{WS_NAME}
```

| Subsystem | Focus | Key Inputs | Key Outputs |
|-----------|-------|-----------|------------|
| **PD** | [What PD does in this WS] | [Inputs] | [Outputs → downstream] |
| **DP** | [What DP does in this WS] | **Principles from PD** + [others] | [Outputs] |
| **DA** | [What DA does in this WS] | **Principles from PD** + [others] | [Outputs] |
| **IDM** | [What IDM does in this WS] | **Principles from all upstream** + [others] | [Outputs] |

> **Critical:** PD produces the effective principles that govern the entire UES — DP, DA, and IDM inherit and build on them.

## Structure

| Folder | Contents |
|--------|---------|
| `1-PD/` | [What lives here] |
| `2-DP/` | [What lives here] |
| `3-DA/` | [What lives here] |
| `4-IDM/` | [What lives here] |
| `_cross/` | [Cross-cutting artifacts that span all subsystems] |

## Templates

| Stage | Template |
|-------|---------|
| Design | [`design-template.md`](_genesis/templates/design-template.md) |
| Sequence | [`dsbv-process.md`](_genesis/templates/dsbv-process.md) |
| Build | [Artifact-specific templates in `_genesis/templates/`] |
| Validate | [`review-template.md`](_genesis/templates/review-template.md) |

## Pre-Flight Checklist

### Design Stage
- [ ] [Critical gate 1]
- [ ] [Critical gate 2]
- [ ] [Critical gate 3]

### Sequence Stage
- [ ] [Critical gate 1]
- [ ] [Critical gate 2]

### Build Stage
- [ ] [Critical gate 1]
- [ ] [Critical gate 2]
- [ ] [Critical gate 3]

### Validate Stage
- [ ] All VANA acceptance criteria met
- [ ] Evidence basis verified
- [ ] Validated package ready for → {DOWNSTREAM}

## How {WS_NAME} Connects

```
                  [output label]
{UPSTREAM}  ─────────────────────>  {WS_NUM}-{WS_NAME}
                                         │
                                    [output label]
                                         │
                                         ▼
                                    {DOWNSTREAM}

{WS_NUM}-{WS_NAME} ──"[trigger]"──> 2-LEARN  (loop back on unknowns)
{WS_NUM}-{WS_NAME} ──"[trigger]"──> 1-ALIGN  (re-align on scope change)
```

## DASHBOARDS

![[{BASES_FILENAME}]]
<!-- Actual bases filenames: _genesis/obsidian/bases/{NN}-{name}-overview.base -->
```

---

## 4. Type B — Subsystem README

Use for: `{WS}/{SS}/README.md` — e.g., `1-ALIGN/1-PD/README.md`, `3-PLAN/2-DP/README.md`, `2-LEARN/_cross/README.md`

```markdown
---
version: "{MAJOR}.0"
status: draft
last_updated: {YYYY-MM-DD}
work_stream: {WS_NUM}-{WS_NAME}
sub_system: {SS_NUM}-{SS_NAME}
type: template
iteration: {N}
---

# {SS_NUM}-{SS_NAME} — {SS_FULL} | {WS_NAME} Workstream

> "{One sentence: what breaks if this subsystem's {WS_NAME} artifacts are missing or wrong?}"

[1–2 sentences. What does this subsystem do within this workstream? What constraint does it receive from upstream, and what does it pass downstream?]

## Cascade Position

```
[{SS_PREV}-{SS_PREV_NAME}]  ──►  [{SS_NUM}-{SS_NAME}]  ──►  [{SS_NEXT}-{SS_NEXT_NAME}]
                                        ↑
       [What this subsystem anchors / what governs it from upstream]
```

Receives from upstream: [specific artifact names and source paths].
Produces for downstream: [specific artifact names] — consumed by [next SS] as [hard constraints / inputs].

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| [Artifact name] | `filename-pattern.md` | [One-line purpose] |
| [Artifact name] | `ADR-{id}_{slug}.md` | [One-line purpose] |
| [Artifact name] | `filename-pattern.md` | [One-line purpose] |

## Pre-Flight Checklist

- [ ] [Gate 1 — most important missing artifact or decision]
- [ ] [Gate 2]
- [ ] [Gate 3]
- [ ] Artifacts here do not contradict {SS_PREV}-{SS_PREV_NAME}'s scope or principles
- [ ] Outputs are ready for handoff to {SS_NEXT}-{SS_NEXT_NAME}
```

> **For `_cross/` subsystem:** Replace "Cascade Position" with "Scope" section explaining what "cross-cutting" means in this workstream. `_cross/` holds artifacts that span all 4 subsystems and cannot be owned by one.

---

## 5. Type C — Directory README

Use for: any named directory that is not a workstream root or subsystem root.
Examples: `_genesis/brand/`, `_genesis/frameworks/`, `3-PLAN/_cross/`, `1-ALIGN/_cross/`

```markdown
---
version: "{MAJOR}.0"
status: draft
last_updated: {YYYY-MM-DD}
work_stream: {WS_NUM}-{WS_NAME}
type: template
iteration: {N}
---

# {DIR_NAME}

> "{Guiding question: what breaks if this directory is empty or stale?}"

## Purpose

{DIR_PURPOSE}. [1–2 sentences: why this dir exists as a separate directory, not inline with its parent. What boundary does it enforce?]

## What This Contains

| Content Type | Description |
|-------------|-------------|
| [Type 1] | [What it is and when it's created] |
| [Type 2] | [What it is and when it's created] |

## How It Connects

```
{UPSTREAM}
    │
    ├──> {DOWNSTREAM_1} — [what it provides]
    ├──> {DOWNSTREAM_2} — [what it provides]
    └──> {DOWNSTREAM_3} — [what it provides]
```

## Pre-Flight Checklist

- [ ] [Most critical check — what must be true before this dir is "ready"]
- [ ] [Second check]
- [ ] [Third check — often: "no orphaned or stale artifacts"]

## Naming Convention

[File naming rule for artifacts in this directory. E.g.: `ADR-{id}_{slug}.md`, `{topic}-risk.md`]
Use `[[wikilinks]]` to connect artifacts to related items in other directories.
```

---

## 6. Writing Rules (apply to all types)

### Voice
- Lead every section with **failure risk**, not feature description. ("Without this, X breaks" beats "This contains Y.")
- Use imperative mood in checklists: "Define", "Verify", "Confirm" — not "Has been defined."
- Guiding questions end with "If not, something is missing."

### Diagrams
- Cascade diagrams use `──►` for forward flow, `──>` for feedback loops, `│` and `▼` for vertical flow.
- Keep diagrams under 10 lines. If longer, split into two separate diagrams.
- Every diagram must have a label or be preceded by a sentence explaining what it shows.

### Tables
- Minimum 2 columns. Never use a table for a single-column list — use a bullet list instead.
- Column headers: Title Case. Cell content: sentence case.

### Frontmatter
- All values lowercase — except `work_stream` (numbered SCREAMING: `1-ALIGN`) and `sub_system` (`1-PD`).
- `status` starts as `draft`. Only a human sets `validated`.
- `version` follows LTC convention: `{iteration}.{edit_count}`. New file in Iteration 2 = `"2.0"`.

### What a README is NOT
- Not a design document (use `DESIGN.md`)
- Not a how-to guide (use `_genesis/sops/` or a skill)
- Not an artifact inventory (use Obsidian Bases)
- Not a status tracker (use Notion / WMS)

---

## 7. Quick Decision Tree

```
Is it the repo root README?
  └─ YES → Type D (do not use this blueprint — root README is its own standard)
  └─ NO  → Is it a top-level workstream dir (1-ALIGN/, 2-LEARN/, etc.)?
              └─ YES → Type A
              └─ NO  → Is it a subsystem dir ({WS}/1-PD/, {WS}/_cross/, etc.)?
                          └─ YES → Type B
                          └─ NO  → Type C
```

## Links

- [[BLUEPRINT]]
- [[DESIGN]]
- [[README]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[charter]]
- [[deliverable]]
- [[design-template]]
- [[dsbv-process]]
- [[iteration]]
- [[project]]
- [[review-template]]
- [[standard]]
- [[workstream]]
