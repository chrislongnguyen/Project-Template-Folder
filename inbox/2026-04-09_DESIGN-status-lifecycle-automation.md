---
version: "1.0"
status: draft
last_updated: 2026-04-09
work_stream: 0-GOVERN
type: dsbv-design
tags: [status-lifecycle, automation, hooks, gates, iteration]
---

# DESIGN — Status Lifecycle Automation

> **EO:** Every `.md` artifact's status moves accurately, safely, reliably, consistently,
> and efficiently through its lifecycle — from creation to validation to iteration advancement —
> with zero manual bookkeeping, scaling to 1000+ files.
>
> **Scope:** GOVERN workstream. Affects all 5 ALPEI workstreams + _genesis.
> **Predecessor:** versioning.md (rule), status-guard.sh (ceiling), inject-frontmatter.sh (floor).
> **Drives:** version-registry auto-generation, iteration advancement protocol.

---

## 1. Problem Statement

### Current State (Broken)

```
inject-frontmatter.sh              (nothing)                    status-guard.sh
creates status: draft    ──────── NO AUTOMATION ──────────────  blocks status: validated
on new files                    in the middle                   at commit time

Result: 100% of files stuck at "draft" regardless of actual lifecycle state.
```

Three failure modes:

| # | Failure | Root Cause | Impact |
|---|---------|-----------|--------|
| F1 | Files edited 50x stay `draft` | inject-frontmatter.sh has "never overwrite" policy | PM sees all-draft dashboard, no signal |
| F2 | Human approves verbally, status doesn't change | No mechanism reads human intent from conversation | Validated work looks unvalidated |
| F3 | Version-registry drifts from reality | Manual sync, agent forgets | Stale progress dashboard |

### Desired State

```
inject-frontmatter.sh v2           DSBV skill               bulk-validate.sh
creates: draft              agent detects human          human runs on path
advances: draft→in-progress   approval at gate →           sets in-review→validated
resets: validated→draft+v bump  sets in-review→validated     at scale

          generate-registry.sh
          scans all frontmatter →
          rebuilds version-registry.md
          (no manual sync ever)
```

Every status transition is either **automatic** (hook-driven) or **tool-assisted** (human runs a command). Zero transitions require manual file editing.

---

## 2. Status State Machine

### 2.1 States (5)

| State | Meaning | Who sets it | Files in this state |
|---|---|---|---|
| `draft` | Created or re-edited, not yet in active work | Agent (auto) | New files, post-validation re-edits |
| `in-progress` | Agent is actively working on this file | Agent (auto) | Files being built |
| `in-review` | Work complete, presented to human for approval | Agent (auto) | Gate report presented |
| `validated` | Human has approved this artifact | Human (explicit) | Approved work |
| `archived` | End of life, no further edits expected | Human (explicit) | Deprecated artifacts |

### 2.2 Transitions (6)

```
                    ┌─────────────────────────────────────────────────────┐
                    │              ITERATION BUMP (T6)                     │
                    │  Human approves I(N)→I(N+1) for subsystem           │
                    │  version: 1.x → 2.0 | status → draft               │
                    └──────────────────────┬──────────────────────────────┘
                                           │
    ┌──────────┐  T1     ┌─────────────┐ T2    ┌───────────┐ T3     ┌───────────┐
    │  draft   │───────> │ in-progress │──────>│ in-review │───────>│ validated │
    └──────────┘         └─────────────┘       └───────────┘        └─────┬─────┘
         ^                                                                 │ T4
         │                     version MINOR +1                            │
         └─────────────────────────────────────────────────────────────────┘

    T5: validated → archived (human only, rare)
```

| ID | Transition | Trigger | Actor | Mechanism | Version Change |
|---|---|---|---|---|---|
| T1 | `draft` → `in-progress` | Agent edits a draft file | Agent | inject-frontmatter.sh v2 | None |
| T2 | `in-progress` → `in-review` | Agent presents gate report (G1-G4) | Agent | DSBV skill gate presentation | None |
| T3 | `in-review` → `validated` | Human approves at gate | Human | DSBV skill detects approval + bulk-validate.sh | None |
| T4 | `validated` → `draft` | Agent re-edits validated file | Agent | inject-frontmatter.sh v2 | **MINOR +1** |
| T5 | `validated` → `archived` | Human retires artifact | Human | bulk-validate.sh --archive | None |
| T6 | `any` → `draft` (new MAJOR) | Human approves iteration bump | Human | iteration-bump.sh | **MAJOR +1, MINOR = 0** |

### 2.3 Invariants (must ALWAYS hold)

| ID | Invariant | Enforced by |
|---|---|---|
| INV-1 | Agent NEVER sets `validated` or `archived` | status-guard.sh (pre-commit) |
| INV-2 | Re-editing a `validated` file ALWAYS bumps MINOR version | inject-frontmatter.sh v2 |
| INV-3 | `last_updated` is ALWAYS today's date after any edit | inject-frontmatter.sh v2 |
| INV-4 | Version-registry ALWAYS matches file frontmatter | generate-registry.sh (pre-commit) |
| INV-5 | `in-review` → `validated` requires a traceable human approval signal | DSBV skill approval record |

---

## 3. Human Approval Detection

### 3.1 Design Principle

**Gate-based, not word-parsing.** The DSBV skill recognizes phase transitions from
human messages. It does NOT parse arbitrary conversation for approval keywords.
The skill is always the mediator — approval only counts when it occurs in the
context of a gate presentation.

**When in doubt, ASK.** If the human's intent is ambiguous, the agent asks:
> "Are you approving/validating this phase so I can advance?"

The agent NEVER silently assumes approval. There is NO auto-timeout.
Human must always prompt something.

### 3.2 Approval Signal Catalog

Derived from analysis of 37 conversation logs and 180 session records.

#### Tier 1 — Explicit Approval (agent advances immediately)

| Signal                       | Example                | Confidence |
| ---------------------------- | ---------------------- | ---------- |
| "approved" / "approve"       | "Design approved."     | HIGH       |
| "validated" / "validate it"  | "This is validated."   | HIGH       |
| "looks good" / "sounds good" | "Looks good, move on." | HIGH       |
| "lgtm"                       | "lgtm"                 | HIGH       |
| "confirmed"                  | "Design confirmed."    | HIGH       |
| "ship it"                    | "Ship it."             | HIGH       |

#### Tier 2 — Implicit Approval (agent advances with confirmation)

These phrases imply approval of the CURRENT phase when they reference the NEXT phase.
Agent confirms before advancing:

| Signal | Example | Interpretation |
|---|---|---|
| "proceed to {next phase}" | "proceed to sequence" | Current phase approved, start next |
| "go ahead" / "go" | "go ahead and build" | Current gate approved |
| "build it" / "do it" | "ok build it" | Sequence approved, start build |
| "continue" / "move on" | "continue with build" | Current phase approved |
| "next" / "what's next" | "next" | Current phase approved |
| "ok" + directive | "ok, start the sequence" | Current phase approved |
| "yes" (after gate question) | "yes" | Direct response to gate question = approval |
| "ready" / "ready for" | "ready for build" | Current phase approved |

**Confirmation template for Tier 2:**

```
Understood — marking {ARTIFACT} as validated (status: validated, v{X.Y}).
Advancing to {NEXT_PHASE}.
```

This is a **statement, not a question** — the agent declares what it's doing.
The human can interrupt ("wait, no") before the agent proceeds. But the agent
does NOT ask "are you sure?" — that adds friction at scale.

#### Tier 3 — Ambiguous (agent MUST ask)

| Signal | Why ambiguous | Agent response |
|---|---|---|
| "ok" (standalone, no directive) | Could be acknowledgment, not approval | "Are you validating this phase, or just acknowledging?" |
| "good" (standalone) | Quality comment vs. approval | "Does 'good' mean you're approving, or noting quality?" |
| "check this" / "let me review" | Human may be starting review, not finishing it | Wait. Do not advance. |
| "fix it" / "change X" | Revision request, NOT approval | Treat as REVISE. Stay in current phase. |
| "just build it" | Impatience signal — may skip review | "I'll proceed to build. Confirming: you're approving the current {DESIGN/SEQUENCE}?" |

#### Tier 4 — Rejection (agent stays in current phase)

| Signal | Action |
|---|---|
| "wait" / "hold on" / "stop" | Halt. Ask what needs to change. |
| "no" / "not yet" / "not ready" | Stay in current phase. Ask for specific feedback. |
| "revise" / "redo" / "rework" / "needs work" | Stay in current phase. Apply feedback. Re-present. |
| "come back to this" | Park. Move to other work. Status stays `in-progress`. |
| Silence (no response) | Do NOT advance. Status stays `in-review`. |

### 3.3 Approval Record

Every T3 transition (in-review → validated) writes an approval record to the artifact's
`## Approval Log` section (appended, never overwritten):

```markdown
## Approval Log

| Date | Gate | Verdict | Signal | Tier |
|------|------|---------|--------|------|
| 2026-04-09 | G1-Design | APPROVED | "proceed to sequence" | T2-implicit |
```

This provides:
- **Audit trail** — who approved what and when
- **Traceability** — INV-5 satisfied (every validated file has a logged approval signal)
- **Debugging** — if a file is incorrectly validated, the log shows which signal triggered it

### 3.4 The DSBV Skill as Approval Mediator

```
Human: "proceed to sequence"
  │
  ▼
DSBV Skill (orchestrator context):
  │
  ├── 1. DETECT: Tier 2 implicit approval for current phase
  │
  ├── 2. CONFIRM (statement): "Marking DESIGN.md as validated (v1.3).
  │                             Advancing to Sequence."
  │
  ├── 3. WRITE approval record to DESIGN.md ## Approval Log
  │
  ├── 4. SET status: validated on DESIGN.md
  │      (commits with FORCE_APPROVE=1 — authorized human-mediated action)
  │
  ├── 5. UPDATE version-registry row (or trigger generate-registry.sh)
  │
  └── 6. CREATE/ADVANCE next phase artifact (SEQUENCE.md, status: draft)
```

**Why FORCE_APPROVE is safe here:**
- The DSBV skill only runs when human invokes `/dsbv` or interacts at a gate
- The human expressed approval (Tier 1 or confirmed Tier 2)
- The approval record provides audit trail
- status-guard.sh still blocks ALL other paths to `validated`

---

## 4. inject-frontmatter.sh v2 — Upgrade Spec

### 4.1 Current Behavior (v1.0)

- Creates frontmatter on new files (sets `draft`)
- Fills missing fields (version, status, work_stream, etc.)
- Updates `last_updated` to today
- **Never overwrites existing values** (except `last_updated`)

### 4.2 New Behavior (v2.0)

Three conditional overwrites added:

| Condition | Action | Rationale |
|---|---|---|
| Existing `status: draft` AND file just edited | Set `status: in-progress` | T1: agent started work |
| Existing `status: validated` AND file just edited | Bump version MINOR +1, set `status: draft` | T4: re-edit after approval |
| Existing `status: in-progress` AND file just edited | No change (stay `in-progress`) | Repeated edits don't re-trigger |

**Pseudocode for the overwrite logic:**

```bash
# After reading current frontmatter values:
case "$CURRENT_STATUS" in
  "draft")
    # T1: draft → in-progress (agent is actively editing)
    NEW_STATUS="in-progress"
    ;;
  "validated")
    # T4: validated → draft + version bump (re-edit after approval)
    NEW_STATUS="draft"
    # Parse current version "X.Y", bump to "X.(Y+1)"
    NEW_VERSION=$(bump_minor "$CURRENT_VERSION")
    ;;
  "in-progress"|"in-review")
    # No status change — agent is still working or awaiting review
    NEW_STATUS="$CURRENT_STATUS"
    ;;
  "archived")
    # Archived files should not be edited — warn but don't block
    echo "WARNING: editing archived file $FILE_PATH" >&2
    NEW_STATUS="draft"
    NEW_VERSION=$(bump_minor "$CURRENT_VERSION")
    ;;
esac
```

### 4.3 Scope Guard

The hook ONLY fires on workstream artifacts (`[1-5]-*/`). It does NOT touch:
- `_genesis/` files (Mode D — governed separately)
- `.claude/` files (operational config)
- `scripts/` files (tools)
- Root files (CLAUDE.md, README.md, etc.)

This prevents status churn on operational files that don't follow the DSBV lifecycle.

### 4.4 Edge Cases

| Scenario | Behavior | Why |
|---|---|---|
| Agent creates new file | draft (v1.0) | Standard — no change from v1 |
| Agent edits draft file once | → in-progress | T1 |
| Agent edits in-progress file 5 more times | stays in-progress | Idempotent |
| Agent presents gate, human doesn't respond yet | stays in-review | T2 set by DSBV skill, not hook |
| Human approves, then agent re-edits | → draft (v+1) | T4 — version bump + reset |
| Agent edits file outside DSBV flow | draft → in-progress | Hook is workstream-scoped, not DSBV-scoped |
| Two agents edit same file in parallel | Both trigger T1 — last write wins | Acceptable — status is idempotent for draft→in-progress |

---

## 5. Version-Registry Auto-Generation

### 5.1 Current Problem

`_genesis/version-registry.md` is manually maintained. Agents forget to update it.
Result: registry drifts from actual file versions within days.

### 5.2 Solution: generate-registry.sh

A script that scans ALL `.md` files with frontmatter across all workstreams and
rebuilds the version-registry table from source truth.

**Algorithm:**

```
1. For each workstream dir (1-ALIGN through 5-IMPROVE):
   a. Find DESIGN.md, SEQUENCE.md, VALIDATE.md
   b. Find all other .md files (Build artifacts)
   c. Read frontmatter: version, status, last_updated
   d. Map to workstream × phase cell

2. For LEARN (2-LEARN/):
   a. Check pipeline dirs: input/, research/, specs/, output/
   b. Aggregate: count files, latest version, overall status

3. For _genesis (operational layer):
   a. Summary row: latest version, overall status
   b. GOVERN is not a numbered workstream — .claude/ and _genesis/ files
      are excluded from the workstream×phase matrix

4. Write the 22-row table to _genesis/version-registry.md
   - Preserve the file's own frontmatter (version, status, etc.)
   - Overwrite ONLY the table content
   - Bump the registry file's own version (MINOR +1)
```

### 5.3 When It Runs

| Trigger | Mechanism |
|---|---|
| Pre-commit | Hook in settings.json — runs before every commit containing `.md` files |
| On-demand | `./scripts/generate-registry.sh` — human or agent can run anytime |
| `/dsbv status` | DSBV skill calls the script before rendering the table |

### 5.4 What This Replaces

- Manual "update version-registry row" after every edit (rule 1 on line 128)
- `registry-sync-check.sh` warning hook (replaced by auto-generation)
- The "Recently Modified Files" section (replaced by accurate table)

---

## 6. Iteration Advancement Protocol

### 6.1 When Does a Subsystem Advance?

A subsystem (e.g., PD — Problem Diagnosis) advances from I(N) to I(N+1) when
ALL THREE conditions are met:

```
┌─ C1: ALPEI CYCLE COMPLETE ────────────────────────────────────────┐
│  All 5 workstreams have ≥1 validated artifact for this subsystem  │
│  at the current iteration.                                         │
│  Evidence: version-registry shows no Pending/Not Started cells     │
│  for this subsystem across ALIGN, LEARN, PLAN, EXECUTE, IMPROVE.  │
└───────────────────────────────────────────────────────────────────┘

┌─ C2: IMPROVE RETRO VALIDATED ─────────────────────────────────────┐
│  5-IMPROVE has a validated retro that identifies:                   │
│   - What worked in I(N)                                            │
│   - What must improve for I(N+1)                                   │
│   - Specific acceptance criteria for I(N+1) maturity               │
│  Evidence: 5-IMPROVE/{subsystem}/retro-I{N}.md has status:validated│
└───────────────────────────────────────────────────────────────────┘

┌─ C3: UPSTREAM SUBSYSTEM AT OR ABOVE ──────────────────────────────┐
│  The subsystem's upstream must be at I(N+1) or higher.             │
│  Chain: PD → DP → DA → IDM                                        │
│  PD has no upstream — it advances first.                           │
│  Evidence: upstream subsystem's MAJOR version ≥ N+1                │
└───────────────────────────────────────────────────────────────────┘
```

### 6.2 Agent Nudge System

The agent should **proactively guide** the human toward iteration bumps.
This happens at 3 natural checkpoints:

**Nudge Point 1 — After IMPROVE Validate (G4)**

When the agent completes IMPROVE validation for a subsystem:

```
IMPROVE cycle complete for PD (Problem Diagnosis).

Iteration readiness check:
  C1 ALPEI complete:     ✓  All 5 workstreams have validated artifacts
  C2 IMPROVE retro:      ✓  retro-I1.md validated (2026-04-09)
  C3 Upstream:            ✓  PD has no upstream dependency

→ PD is READY for iteration advancement (I1 → I2).
  This means all PD artifacts would bump from 1.x → 2.0 and reset to draft.
  I2 focus: Efficiency (correct + safe + efficient).

  Would you like to advance PD to I2 now, or defer?
```

**Nudge Point 2 — At Session Start (periodic)**

If a subsystem has been iteration-ready for >7 days without advancement:

```
Reminder: PD (Problem Diagnosis) has been ready for I2 since 2026-04-02.
  All 3 conditions met. Downstream subsystems (DP, DA, IDM) are waiting.
  Would you like to advance now?
```

**Nudge Point 3 — When Downstream is Blocked**

If an agent tries to advance DP to I2 but PD is still at I1:

```
Cannot advance DP to I2 — upstream PD is still at I1.
PD iteration readiness:
  C1: ✓ | C2: ✓ | C3: ✓ (no upstream)
→ PD must advance first. Advance PD to I2 now?
```

### 6.3 iteration-bump.sh

**Usage:** `./scripts/iteration-bump.sh --subsystem PD --from 1 --to 2`

**What it does (atomic, one commit):**

```
For every .md file under */1-PD/ (across all 5 workstreams):
  1. version: 1.x → 2.0    (MAJOR bump, MINOR reset)
  2. status: → draft        (new iteration = fresh lifecycle)
  3. last_updated: today
  4. iteration: 2

Additionally:
  5. Regenerate version-registry.md
  6. Write CHANGELOG entry: "iteration-bump(PD): I1 → I2"
  7. Single atomic commit with all changes
```

**Safety checks (pre-execution):**

| Check | What | Block if |
|---|---|---|
| S1 | C1-C3 conditions met | Any condition unmet → refuse with explanation |
| S2 | No uncommitted changes in target files | Dirty worktree → refuse |
| S3 | `--from` matches actual current MAJOR | Mismatch → refuse (prevents double-bump) |
| S4 | Upstream subsystem at or above `--to` | Upstream behind → refuse with nudge |
| S5 | Human confirmation | Always prompt: "This will bump N files. Proceed?" |

**Rollback:** Single commit → `git revert HEAD` undoes entire bump.

### 6.4 Iteration × Status × Version Matrix

| Event | version | status | last_updated | iteration |
|---|---|---|---|---|
| New file in I1 | 1.0 | draft | today | 1 |
| Agent edits | (unchanged) | in-progress | today | (unchanged) |
| Agent presents gate | (unchanged) | in-review | (unchanged) | (unchanged) |
| Human validates | (unchanged) | validated | today | (unchanged) |
| Agent re-edits validated | 1.(Y+1) | draft | today | (unchanged) |
| Iteration bump I1→I2 | 2.0 | draft | today | 2 |
| Agent edits in I2 | (unchanged) | in-progress | today | (unchanged) |
| Agent re-edits validated I2 | 2.(Y+1) | draft | today | (unchanged) |

---

## 7. Bulk Operations (1000+ File Scale)

### 7.1 bulk-validate.sh

**Usage:** `./scripts/bulk-validate.sh <path> [--dry-run]`

**What it does:**
- Finds all `.md` files under `<path>` with `status: in-review`
- Sets `status: validated` on each
- Updates `last_updated` to today
- Writes approval record: `| {date} | bulk | APPROVED | bulk-validate.sh | bulk |`
- Regenerates version-registry
- Single commit

**Examples:**
```bash
# Validate everything in ALIGN workstream
./scripts/bulk-validate.sh 1-ALIGN/

# Validate just PD subsystem across all workstreams
./scripts/bulk-validate.sh --subsystem 1-PD

# Validate specific files
./scripts/bulk-validate.sh 1-ALIGN/1-PD/DESIGN.md 3-PLAN/1-PD/DESIGN.md

# Dry run — show what would change
./scripts/bulk-validate.sh 1-ALIGN/ --dry-run
```

**Safety:** Only touches `in-review` files. Will NOT validate `draft` or `in-progress`
files (they haven't been reviewed yet). Shows count and file list before proceeding.

### 7.2 Status Dashboard

`/dsbv status` becomes a live view powered by `generate-registry.sh`:

```
DSBV Status — I1 (2026-04-09)                    PD readiness: I2-READY
                                                   DP readiness: blocked (PD at I1)
┌─────────────────────┬─────────┬─────────────┬──────────┐
│ Workstream × Phase  │ Version │ Status      │ AC Pass  │
├─────────────────────┼─────────┼─────────────┼──────────┤
│ 1-ALIGN × Design    │ 1.4     │ validated   │ 4/4      │
│ 1-ALIGN × Build     │ 1.x     │ in-progress │ 28/30    │
│ ...                                                     │
└─────────────────────┴─────────┴─────────────┴──────────┘

Status distribution: 12 validated | 4 in-progress | 2 in-review | 4 draft | 0 pending
```

---

## 8. Implementation Components

| # | Component | Type | What | Depends On | Effort |
|---|---|---|---|---|---|
| C1 | inject-frontmatter.sh v2 | Hook upgrade | Add T1 (draft→in-progress) and T4 (validated→draft+bump) | None | S |
| C2 | DSBV skill gate writer | Skill upgrade | On approval: write record, set validated, advance phase | C1 |M |
| C3 | generate-registry.sh | New script | Scan frontmatter, rebuild version-registry.md | None | M |
| C4 | bulk-validate.sh | New script | Bulk set in-review→validated on path | C1, C3 | S |
| C5 | iteration-bump.sh | New script | Bump subsystem to next iteration (MAJOR version) | C3, C4 | M |
| C6 | readiness-report.sh | New script | Check C1-C3 conditions, output iteration readiness | C3 | S |
| C7 | Approval signal detection | DSBV skill logic | Tier 1-4 pattern matching in gate context | C2 | M |
| C8 | Agent nudge logic | DSBV skill + session hook | Nudge at 3 checkpoints for iteration advancement | C5, C6 | S |

**Sequencing:** C1 → C3 → C4 → C2+C7 → C5+C6 → C8

**Estimated total:** ~4-6 hours of agent build time across 8 components.

---

## 9. Acceptance Criteria

| AC | Criterion | Test |
|---|---|---|
| AC-1 | Agent edits a `draft` file → status auto-advances to `in-progress` | Edit any workstream .md, verify frontmatter |
| AC-2 | Agent edits a `validated` file → version bumps MINOR, status resets to `draft` | Edit a validated file, verify version X.Y→X.(Y+1) |
| AC-3 | Human says "proceed to sequence" after DESIGN gate → DESIGN.md becomes `validated` | Run /dsbv, present design, say "proceed to sequence" |
| AC-4 | Human says ambiguous phrase → agent asks for clarification | Say "ok" standalone after gate, verify agent asks |
| AC-5 | Rejection phrase keeps status unchanged | Say "wait" or "revise" after gate, verify no status change |
| AC-6 | Every validated file has an approval record in ## Approval Log | Grep all validated files for approval log section |
| AC-7 | `generate-registry.sh` produces registry matching all file frontmatter | Run script, diff registry versions vs actual |
| AC-8 | `bulk-validate.sh` only touches `in-review` files | Run with --dry-run on mixed-status path, verify filter |
| AC-9 | `iteration-bump.sh` refuses if C1-C3 not met | Try bumping with unmet conditions, verify refusal |
| AC-10 | `iteration-bump.sh` bumps all files atomically (one commit) | Run bump, verify single commit, verify all files changed |
| AC-11 | Agent nudges human when subsystem is iteration-ready | Complete IMPROVE cycle, verify nudge appears |
| AC-12 | Non-workstream files (.claude/, scripts/, _genesis/) are NOT affected by T1/T4 | Edit a rule file, verify no status change |

---

## 10. UBS Analysis

| Risk | Category | Severity | Mitigation |
|---|---|---|---|
| Agent misreads casual "ok" as gate approval | Human | HIGH | Tier 3 requires explicit ask. Gate context required. |
| inject-frontmatter.sh v2 corrupts frontmatter on edge case | Technical | HIGH | Extensive test suite. --dry-run mode. |
| generate-registry.sh too slow on 1000+ files | Technical | LOW | Bash + grep is fast. Benchmark at 1000 files. |
| FORCE_APPROVE bypass weakens status-guard | Technical | MEDIUM | Only DSBV skill uses it. Approval record provides audit trail. |
| Iteration bump done prematurely | Human | MEDIUM | C1-C3 checks + human confirmation + single-commit rollback |
| Two agents edit same file, status races | Technical | LOW | Hook is idempotent for draft→in-progress. Last write wins safely. |
| Human never reaches `in-review` because no gate is presented | Human | MEDIUM | Agent nudge at DSBV gates. /dsbv status shows distribution. |

---

## 11. What This Design Does NOT Cover

| Out of Scope | Why | Where It Lives |
|---|---|---|
| CI/CD enforcement of status | Requires GitHub Actions setup (separate GOVERN cycle) | Deferred to CI/CD workstream |
| Push notifications to stakeholders | Convenience feature, not lifecycle correctness | Deferred (D3 audit finding) |
| Status on non-.md files (.sh, .py, .html) | Different lifecycle, different frontmatter format | Future GOVERN cycle |
| Cross-repo status aggregation | Template repo is single-repo | Future OE initiative |

---

## Links

- [[CHANGELOG]]
- [[CLAUDE]]
- [[VALIDATE]]
- [[alpei-chain-of-custody]]
- [[inject-frontmatter]]
- [[iteration]]
- [[status-guard]]
- [[version-registry]]
- [[versioning]]
- [[workstream]]
