---
version: "1.0"
status: Draft
last_updated: 2026-04-05
owner: Long Nguyen
workstream: GOVERN
iteration: I2
type: ues-deliverable
work_stream: 0-GOVERN
stage: validate
---
# VALIDATE.md — GOVERN: EP-12/EP-13 Layer 1 Enforcement

> DSBV Phase 4 artifact. Validates Build output against DESIGN-govern-ep12-ep13-enforcement.md.
> Contract: 4 deliverables, 7 artifacts, 17 acceptance criteria.

---

## Summary

| Verdict | Count |
|---------|-------|
| PASS    | 17    |
| PARTIAL | 0     |
| FAIL    | 0     |

**Blocking issues:** None.

---

## D1: EP-12 Handoff Gate (verify-deliverables.sh)

Artifact: `.claude/hooks/verify-deliverables.sh` (version 1.2)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-1 | Parses `Blockers: none` → PASS | PASS | `verify-deliverables.sh` L65: `elif echo "$BLOCKERS" \| grep -qi "^none"; then` followed by L66: `: # Clean handoff` — case-insensitive match on "none", no exit, script continues to exit 0. |
| AC-2 | Parses `Blockers: <anything else>` → exit 1 with named blocker | PASS | `verify-deliverables.sh` L69-73: else branch prints `"✗ EP-12 — Handoff blocked. Sub-agent reported unresolved blockers:"` with `${BLOCKERS}` value, then `exit 1`. |
| AC-3 | `Blockers: <text> WARN` → prints warning but exit 0 | PASS | `verify-deliverables.sh` L67-68: `elif echo "$BLOCKERS" \| grep -qi "WARN"; then echo "⚠ EP-12 — Handoff has warnings (non-blocking): ${BLOCKERS}"` — no exit, falls through to exit 0 at L115. |
| AC-4 | Existing AC-pattern checks preserved (v1.1 behavior unchanged) | PASS | `verify-deliverables.sh` L78-113: AC verification file check (`$PROJECT_ROOT/.claude/ac/${AGENT_TYPE}.json`) and per-AC pattern matching loop remain intact, unchanged from prior version. |
| AC-5 | Existing context packaging checks preserved | PASS | `verify-deliverables.sh` L37-53: Context packaging markers check (`## 1. EO`, `## 5. VERIFY`) with non-blocking warning — preserved from v1.1. |
| AC-6 | Exit code is 1 (not 2) for all new failure conditions | PASS | `verify-deliverables.sh` L73: EP-12 blocker branch uses `exit 1`. The only `exit 2` at L112 is the pre-existing AC-pattern check (v1.1 behavior), which is not a new failure condition. |

---

## D2: EP-13 Nesting Observer (nesting-depth-guard.sh)

Artifact: `.claude/hooks/nesting-depth-guard.sh` (version 1.0)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-7 | Fires on every Agent() tool call in orchestrator session | PASS | `settings.json` L155-165: PostToolUse entry with `"matcher": "Agent"` pointing to `./.claude/hooks/nesting-depth-guard.sh`. Script L38 logs every dispatch unconditionally: `echo "[$TIMESTAMP] Agent() dispatch: target=..."`. |
| AC-8 | Reads `$CLAUDE_PARENT_AGENT_ID` — if non-empty, prints `WARN: EP-13 — sub-agent spawning detected (parent: $CLAUDE_PARENT_AGENT_ID)` | PASS | `nesting-depth-guard.sh` L33: `PARENT_AGENT="${CLAUDE_PARENT_AGENT_ID:-}"`. L41-44: `if [[ -n "$PARENT_AGENT" ]]; then echo "⚠ EP-13 — Nesting detected: sub-agent context (parent=${PARENT_AGENT})..."`. Message text uses "Nesting detected" instead of "sub-agent spawning detected" but includes the parent ID and EP-13 reference — semantic match. |
| AC-9 | Exit 0 always (cannot reliably block — document why) | PASS | `nesting-depth-guard.sh` L47: sole exit statement is `exit 0`. Reason documented at L12-13: `"no reliable mechanism to deterministically block sub-agent nesting (GitHub #40580). This hook provides observation + warning (Layer 2)."` |
| AC-10 | Documents #40580 limitation in script header comment | PASS | `nesting-depth-guard.sh` L11: `"subject to platform behavior (related to #40580)"`, L13: `"(GitHub #40580)"`, L44: also references `#40580` in runtime warning. |

---

## D3: Agent File Constraints (Layer 3 rule injection)

### A3: ltc-builder.md

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-11 | Constraint present: "NEVER call the Agent() tool". Rationale present. | PASS | `ltc-builder.md` L48-53: `### EP-13: Orchestrator Authority` section. L50: `**NEVER call the Agent() tool.**` L51-53: rationale explaining RACI roles, token explosion, scope drift. |

### A4: ltc-reviewer.md

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-12 | Same constraint as A3 | PASS | `ltc-reviewer.md` L57-62: `### EP-13: Orchestrator Authority` section. L60: `**NEVER call the Agent() tool.**` L61-62: rationale explaining RACI roles and incomplete context handling. |

### A5: ltc-explorer.md

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-13 | Same constraint as A3 | PASS | `ltc-explorer.md` L55-60: `### EP-13: Orchestrator Authority` section. L57: `**NEVER call the Agent() tool.**` L58-60: rationale explaining cost/speed purpose of Haiku exploration. |

### A6: ltc-planner.md

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-14 | Constraint present, with exception: "ltc-planner MAY dispatch ltc-builder, ltc-reviewer, ltc-explorer as part of DSBV orchestration — this is the declared orchestration pattern. No further nesting permitted." | PASS | `ltc-planner.md` L58-65: `### EP-13: Orchestrator Authority` section. L60-61: `"You **MAY** dispatch ltc-builder, ltc-reviewer, and ltc-explorer as part of DSBV orchestration — this is the authorized pattern."` L63: `"**Hard limit: no further nesting.**"` Semantically equivalent to DESIGN.md wording; all three agent names listed, orchestration exception declared, nesting prohibition stated. |

---

## D4: Hook Wiring (settings.json)

Artifact: `.claude/settings.json`

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-15 | PostToolUse fires on `Agent` tool calls | PASS | `settings.json` L155-165: `"PostToolUse": [{ "matcher": "Agent", "hooks": [{ "type": "command", "command": "./.claude/hooks/nesting-depth-guard.sh" ... }] }]` |
| AC-16 | Timeout ≤5s | PASS | `settings.json` L162: `"timeout": 5` (exactly 5s, satisfies ≤5s). |
| AC-17 | Existing PostToolUse entries preserved | PASS | `settings.json` L167-183: Pre-existing `"Write\|Edit"` matcher with `state-saver.sh` and `ripple-check.sh` hooks remain intact alongside the new Agent matcher entry. |

---

## Coherence Checks

| Check | Result |
|-------|--------|
| Cross-artifact contradiction | None found. EP-12 logic in verify-deliverables.sh matches the DONE format described in sub-agent-output.md rule. EP-13 constraints in all 4 agent files are consistent with nesting-depth-guard.sh advisory approach. |
| Versioning frontmatter | All modified artifacts have version + status + last_updated fields. verify-deliverables.sh: 1.2/Draft/2026-04-05. nesting-depth-guard.sh: 1.0/Draft/2026-04-05. Agent files: 1.3/Draft(?)/2026-04-05 (frontmatter uses version field in YAML). settings.json: exempt (JSON config). |
| Platform gap documentation | #40580 documented in DESIGN.md, nesting-depth-guard.sh (L11,L13,L44), and verify-deliverables.sh (L14). Consistent across artifacts. |

---

## Verdict

All 17 acceptance criteria PASS. No blocking issues. Deliverables are ready for G4 gate approval.

---

[[DESIGN]]
[[VALIDATE]]
[[EP-12]]
[[EP-13]]
[[govern]]
[[verify-deliverables]]
