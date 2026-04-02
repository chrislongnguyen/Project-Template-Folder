---
version: "1.3"
status: Draft
last_updated: 2026-03-31
owner: "Long Nguyen"
---
# LTC History & Version Control
> LTC Global Rule — applies to ALL projects using this template.
> Source: Created for the APEI project template standard.

---

## ELI5 — Version Control in Plain Language

> If you're new to version control, start here. The detailed rules for developers are in sections 1-7 below.

### What is version control?

Like Google Docs version history, but more structured. Every change is saved with a note explaining what changed and **why**. You can always go back to any previous version.

### The 3 Rules

**Rule 1 — Every document has a stamp at the top**

```
---
version: "1.0"              ← MAJOR = iteration (I1=1.x, I2=2.x). MINOR = edit count.
status: Draft               ← only 3 options: Draft, Review, Approved
last_updated: 2026-03-31
owner: "Long"               ← who is responsible for this document
---
```

**Rule 2 — Only 3 statuses, only Human can promote**

```
Draft ───→ Review ───→ Approved
  ↑           ↑            ↑
Agent       Agent        HUMAN ONLY
creates     requests     (Agent can NEVER approve
& edits     review        its own work)
```

**Rule 3 — Write the "why", not just the "what"**

```
BAD:  "Updated requirements"
GOOD: "Added data quality requirement because raw Bloomberg data has missing fields"
```

### What you do day-to-day

**When you start work:**
1. Open your project folder
2. Tell the Agent what you want to do
3. Agent works and saves changes with a short note (like a ClickUp comment: "Added stakeholder analysis")

**When a document is ready:**
1. Agent says "I think this is ready for review"
2. You read it
3. You say "Approved" or give feedback
4. If approved — status changes to Approved, nobody edits without creating a new version

**When a milestone is done (like finishing a Sprint):**
1. All documents in this milestone = Approved
2. Agent packages everything into a "Release"
3. You review the package — approve — it goes to the stable version
4. Gets a version tag: v1.0.0, v2.0.0, etc.

```
                    ┌──────────────────────────────────┐
Your daily work     │  Working branch                   │
happens here ──────→│  (safe to experiment,             │
                    │   nothing breaks for others)      │
                    └──────────────┬───────────────────┘
                                   │  when all docs approved
                                   ▼
                    ┌──────────────────────────────────┐
The "published"     │  main branch                      │
version lives  ────→│  (stable, approved work only)     │
here                │  v1.0.0 → v2.0.0 → v3.0.0       │
                    └──────────────────────────────────┘
```

### Guardrails (what prevents mistakes automatically)

| Guardrail | What it prevents |
|-----------|-----------------|
| Version stamp in every doc | "Which version are we looking at?" — always clear at the top |
| Agent can't self-approve | No work ships without human eyes |
| One change = one save | If something breaks, easy to find what changed |
| main branch is protected | The version everyone uses is always safe |
| CHANGELOG updated every release | "What changed?" — one file with the full history |

### Compared to ClickUp (what changes for you)

| Before (ClickUp) | Now (Project Repo) |
|-------------------|-------------------|
| Docs edited freely, no stamps | Every doc has version + status stamp |
| "Which version is latest?" | Always clear — check the stamp |
| Changes lost in edit history | Every change saved with a "why" note |
| No approval gate | Draft → Review → Approved (Human gates it) |
| Hard to roll back | Any past version recoverable instantly |
| Docs scattered across spaces | One folder structure, everything connected |
| "Who changed this?" unclear | Every save tagged with who + when + why |

### When you need more detail

Sections 1-7 below cover the full technical specification — branching strategy, commit conventions, variation management, and more. Your AI Agent follows these rules automatically. You only need to know the 3 rules above.

---

# Detailed Specification (for Developers and AI Agents)

## 1. Git Branching Strategy

```
main                        ← Stable, approved work only. Protected branch.
  ├── I0-logic-scaffold   ← Iteration 0: ALIGN workstream setup (pre-build framing)
  ├── I1-concept          ← Iteration 1: Sustainability — prove correctness
  ├── I2-prototype        ← Iteration 2: Efficiency — real data, outperform
  ├── I3-mve              ← Iteration 3: Full efficiency — production-grade
  ├── I4-leadership       ← Iteration 4: Scalability — self-improving
  └── hotfix/*            ← Emergency fixes to main
```

- **main** = production-quality, approved artifacts. Never commit directly.
- **Iteration branches** = one branch per APEI iteration (I0 through I4). All work happens here.
- **Feature branches** = optional sub-branches off iteration branches for parallel workstreams.
- **hotfix/** = emergency corrections to main between iterations.

---

## 2. Commit Message Conventions

Format: `type(scope): description`

| Type | Use When |
|---|---|
| `feat` | New artifact, SOP, analysis, or deliverable |
| `fix` | Correcting an error in existing content |
| `refactor` | Restructuring without changing meaning |
| `docs` | Documentation-only changes (README, changelog) |
| `chore` | Build, config, template maintenance |

**Scope** = workstream or subsystem: `ALIGN`, `PLAN`, `EXECUTE`, `IMPROVE`, or specific subsystem name.

**Examples:**
```
feat(ALIGN): ALIGN workstream stakeholder analysis complete
fix(EXECUTE): correct CF2 acceptance criteria threshold
refactor(PLAN): restructure EOP steps for LEARN workstream
docs(IMPROVE): update changelog for I2 cycle
```

**Rules:**
- Atomic commits — one logical change per commit.
- Reference the workstream and subsystem so `git log` is navigable.
- Never combine cross-workstream changes in a single commit.

---

## 3. Variation Management (CF1/CF2/CF3)

When EXECUTE produces multiple configuration variants (CF1, CF2, CF3), manage them WITHOUT source duplication:

**Preferred: Directory-based separation**
```
4-EXECUTE/
  ├── CF1-baseline/       ← Configuration variant 1
  ├── CF2-optimized/      ← Configuration variant 2
  ├── CF3-experimental/   ← Configuration variant 3
  └── _shared/            ← Common artifacts across all variants
```

**Alternative: Branch-based separation** (only when variants diverge significantly)
- Branch per variant off the iteration branch: `I2-CF1`, `I2-CF2`, `I2-CF3`
- Merge winner back to iteration branch with rationale documented.

**Rule:** Default to directories. Use branches only when file-level conflicts make directory separation impractical.

---

## 4. Chain of Thought Preservation

Every decision must be traceable in the repo, not lost in chat sessions.

- **ADRs** (Architecture Decision Records) go in `1-ALIGN/decisions/ADR-NNN-title.md`
- **Session summaries** from agent conversations are committed as artifacts, not discarded.
- **Rejected alternatives** are documented alongside chosen approaches — future operators need to know WHY, not just WHAT.
- **Force analysis** (UBS/UDS) that informed a decision is referenced in the ADR.

### ADR Format
```
# ADR-NNN: [Title]
Status: [Proposed | Accepted | Deprecated | Superseded by ADR-NNN]
Date: YYYY-MM-DD
Workstream: [ALIGN | PLAN | EXECUTE | IMPROVE]

## Context
[What forces led to this decision?]

## Decision
[What was decided and why?]

## Consequences
[What are the expected outcomes — both positive and negative?]
```

---

## 5. PR Workflow

Each iteration produces a Pull Request to main:

| Iteration | PR Title Pattern | Merge Condition |
|---|---|---|
| I0 | `I0: Logic Scaffold — ALIGN workstream setup` | ALIGN workstream artifacts reviewed and approved |
| I1 | `I1: Concept — PLAN + first EXECUTE pass` | LEARN workstream+3 first pass, EXECUTE workstream baseline eval |
| I2 | `I2: Prototype — deep EXECUTE + EVALUATE` | All workstreams populated, eval metrics pass threshold |
| I3 | `I3: MVE — IMPROVE cycle applied` | Changelog updated, regression check passed |
| I4 | `I4: Leadership — final review and handoff` | All A.C. met, stakeholder sign-off |

- PRs require at least one reviewer (Human Director or designated reviewer).
- PR description must reference which workstreams were modified and link to relevant ADRs.
- Squash merge to main to keep history clean.

---

## 6. CHANGELOG Maintenance

Maintain `5-IMPROVE/changelog/CHANGELOG.md` with reverse-chronological entries:

```
## [I2] - 2026-03-25
### Added
- CF2 optimized configuration for PLAN workstream
- ADR-003 documenting tool selection rationale
### Changed
- Revised LEARN workstream EOP step ordering based on eval feedback
### Fixed
- Corrected data schema in PLAN workstream output contract
```

Update the changelog as part of every PR — not retroactively.

---

## 7. Tag Conventions

Tags mark stable iteration endpoints on main:

| Tag Pattern | Meaning |
|---|---|
| `v1.0.0` | I1 merged — Concept complete |
| `v2.0.0` | I2 merged — Prototype complete |
| `v3.0.0` | I3 merged — MVE complete |
| `v4.0.0` | I4 merged — Leadership complete |
| `v4.0.1` | Hotfix after I4 release |

> **Note:** I0 (Logic Scaffold) is pre-build framing — no tag is produced because no artifacts merge to main during I0.

Tag format: `v{ITERATION}.0.0`
- MAJOR = iteration number (I1=1, I2=2, I3=3, I4=4)
- MINOR = 0 (reserved for future sub-iteration use)
- PATCH = hotfixes within an iteration

## Links

- [[CHANGELOG]]
- [[README]]
- [[deliverable]]
- [[iteration]]
- [[project]]
- [[standard]]
- [[workstream]]
