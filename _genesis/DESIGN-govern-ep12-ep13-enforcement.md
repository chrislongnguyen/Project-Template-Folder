---
version: "1.0"
status: Draft
last_updated: 2026-04-05
owner: Long Nguyen
workstream: GOVERN
iteration: I2
type: ues-deliverable
work_stream: 0-GOVERN
stage: design
---
# DESIGN.md — GOVERN: EP-12/EP-13 Layer 1 Enforcement

> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.
> Placement: `_genesis/` — GOVERN patches skip per-workstream folders (see `alpei-chain-of-custody.md`).

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Upstream sufficient? | YES — GOVERN exception. Input: EP-12+EP-13 full specs (EP registry), hook reliability audit, verify-deliverables.sh v1.1 (current), sub-agent-output.md rule, settings.json current state, hook bug list (#13756, #40580, #25655) |
| Q2: In scope? | (1) Extend verify-deliverables.sh for EP-12 structured AC gate, (2) EP-13 nesting-depth observer (PostToolUse), (3) explicit no-sub-agent prohibition in agent files, (4) settings.json wiring updates |
| Q2b: Out of scope? | EP-13 true PreToolUse blocking (platform bug #40580 makes it impossible), any EP other than 12+13, changes to the EP registry text |
| Q3: Go/No-Go | GO |

---

## Design Decisions

**Intent:** The previous GOVERN cycle shipped EP-14 (Script-First Delegation) and the SubagentStop hook. Two gaps remain: (1) EP-12 — the DONE format exists but nothing blocks completion if ACs fail; (2) EP-13 — sub-agents can spawn sub-agents with no enforcement. This cycle closes both gaps within platform constraints.

**Platform constraint (non-negotiable):**
- PreToolUse hooks are IGNORED for sub-agent calls (#40580) — EP-13 true Layer 1 blocking is not achievable deterministically
- Exit code 2 is unreliable for blocking (#13756) — SubagentStop extension should exit 1, not 2
- PostToolUse CANNOT modify tool output (#32105) — observation only

**EP-12 design (achievable):**

Current state: `verify-deliverables.sh` checks if the DONE pattern is present (`DONE:.*ACs:.*Blockers:`). It does NOT check if Blockers = "none". A sub-agent can report `DONE: foo | ACs: 2/4 | Blockers: AC-03 FAIL` and the hook passes.

Fix: Parse the Blockers field. If Blockers ≠ "none" (case-insensitive), the handoff is blocked.

```
DONE: foo | ACs: 4/4 | Blockers: none        → PASS (EP-12 satisfied)
DONE: foo | ACs: 3/4 | Blockers: AC-03 FAIL  → BLOCK (EP-12 violated)
DONE: foo | ACs: 4/4 | Blockers: AC-01 WARN  → WARN only (non-fatal)
```

Exit behavior: exit 1 (not 2 — unreliable) if blockers are non-none and non-warn.

**EP-13 design (partially achievable):**

True Layer 1 (PreToolUse block on Agent() calls from within sub-agents) is blocked by #40580. The PreToolUse hook DOES NOT fire when a sub-agent invokes a tool.

Best-effort enforcement in 3 layers:
- **Layer 1 (deterministic, partial):** PostToolUse on Agent tool use — fires in the orchestrator session; cannot fire inside sub-agents. Logs Agent() invocations with caller context. This prevents the orchestrator from accidentally spawning sub-agents from wrong context, but does NOT prevent sub-agents from doing so.
- **Layer 2 (advisory):** nesting-depth-guard.sh — reads `$CLAUDE_CONVERSATION_ID` and `$CLAUDE_PARENT_AGENT_ID` env vars (if available) to detect sub-agent context. Logs a warning. Not reliable enough to block.
- **Layer 3 (declarative):** Each agent .md file gets an explicit prohibition: `## Constraints: NEVER call the Agent() tool. You are a sub-agent — spawning further sub-agents causes token explosion and is not authorized.`

The design acknowledges the platform gap honestly — document it in the artifact, not in a separate note.

**Overlap audit:**
| Existing | Proposed | Verdict |
|---|---|---|
| `verify-deliverables.sh` — SubagentStop, checks DONE pattern + context packaging | EP-12 extension — parses Blockers field | **Extend in-place** — same file, same hook, additional logic |
| `verify-agent-dispatch.sh` — PreToolUse on Agent(), checks context packaging | EP-13 observer — PostToolUse on Agent(), checks nesting | **Complementary** — different event, different check |

---

## Deliverable Structure (4 deliverables)

### D1: EP-12 Handoff Gate (extend verify-deliverables.sh)

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A1 | verify-deliverables.sh v2.0 | `.claude/hooks/verify-deliverables.sh` | Extend: parse Blockers field, exit 1 if non-none/non-warn | AC-1: Parses `Blockers: none` → PASS. AC-2: Parses `Blockers: <anything else>` → exit 1 with named blocker. AC-3: `Blockers: <text> WARN` → prints warning but exit 0. AC-4: Existing AC-pattern checks preserved (v1.1 behavior unchanged). AC-5: Existing context packaging checks preserved. AC-6: Exit code is 1 (not 2) for all new failure conditions |

### D2: EP-13 Nesting Observer (new PostToolUse hook)

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A2 | nesting-depth-guard.sh | `.claude/hooks/nesting-depth-guard.sh` | PostToolUse on Agent: log Agent() invocation with caller context; warn if env suggests sub-agent context | AC-7: Fires on every Agent() tool call in orchestrator session. AC-8: Reads `$CLAUDE_PARENT_AGENT_ID` — if non-empty, prints `WARN: EP-13 — sub-agent spawning detected (parent: $CLAUDE_PARENT_AGENT_ID)`. AC-9: Exit 0 always (cannot reliably block — document why). AC-10: Documents #40580 limitation in script header comment |

### D3: Agent File Constraints (Layer 3 rule injection)

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A3 | ltc-builder.md update | `.claude/agents/ltc-builder.md` | Add EP-13 constraint block | AC-11: Constraint present: "NEVER call the Agent() tool". Rationale present. |
| A4 | ltc-reviewer.md update | `.claude/agents/ltc-reviewer.md` | Add EP-13 constraint block | AC-12: Same constraint as A3 |
| A5 | ltc-explorer.md update | `.claude/agents/ltc-explorer.md` | Add EP-13 constraint block | AC-13: Same constraint as A3 |
| A6 | ltc-planner.md update | `.claude/agents/ltc-planner.md` | Add EP-13 constraint block with exception | AC-14: Constraint present, with exception: "ltc-planner MAY dispatch ltc-builder, ltc-reviewer, ltc-explorer as part of DSBV orchestration — this is the declared orchestration pattern. No further nesting permitted." |

### D4: Hook Wiring (wire D2 into settings.json)

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A7 | settings.json update | `.claude/settings.json` | Wire nesting-depth-guard.sh into PostToolUse on Agent | AC-15: PostToolUse fires on `Agent` tool calls. AC-16: Timeout ≤5s. AC-17: Existing PostToolUse entries preserved |

---

## Alignment Check

```
Deliverables: 4 (D1-D4)
Artifacts:    7 (A1-A7)
ACs:          17 (AC-1 through AC-17)
Orphan ACs:   0
Orphan artifacts: 0

Trace:
  D1: EP-12 gap — DONE format exists but Blockers not checked
  D2: EP-13 gap — nesting possible, no detection layer exists
  D3: EP-13 gap — agent files don't prohibit Agent() calls explicitly
  D4: D2 wire-up — no hook entry for Agent PostToolUse

Platform gap (documented, not in scope to fix):
  EP-13 true L1 blocking impossible due to #40580.
  Design delivers L1 (partial) + L2 + L3. Full L1 requires platform fix.
```

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Sequential single-agent — deterministic script/config changes |
| Agent config | Main context only — D1+D2 are small script edits, D3+D4 are .md/json edits |
| Git strategy | 1 commit: `feat(govern): EP-12/EP-13 Layer 1 enforcement` |
| Human gates | G1=this DESIGN. G2=SEQUENCE ordering. G3=review script changes before commit. G4=validate 17 ACs |
| Cost estimate | ~8K tokens total |

---

## Dependencies

| Dependency | Status |
|---|---|
| verify-deliverables.sh v1.1 (D3 extension from prior cycle) | Ready |
| .claude/agents/ (4 agent files exist) | Ready |
| settings.json PostToolUse section exists | Ready |
| sub-agent-output.md DONE format rule | Ready |

---

## Known Platform Gaps (honest record)

| Bug | Impact on this design |
|---|---|
| #40580: PreToolUse ignored for sub-agents | EP-13 true L1 blocking not achievable. Design uses PostToolUse (orchestrator-side) + declarative constraints instead. |
| #13756: Exit code 2 unreliable | All new failure exits use code 1. |
| #25655: Hooks stop after compaction | EP-12+EP-13 enforcement silent after compaction — same as all other hooks. Documented in hook-reliability-audit.md (prior cycle). |

---

[[DESIGN]]
[[EP-12]]
[[EP-13]]
[[EP-14]]
[[govern]]
[[verify-deliverables]]
