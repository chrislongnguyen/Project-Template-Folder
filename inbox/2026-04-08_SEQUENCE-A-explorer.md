---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: sequence
work_stream: 0-GOVERN
agent: explorer
parent: inbox/2026-04-08_DESIGN-agent-1-explorer.md
scope: all-proposals
---

# SEQUENCE A: Agent 1 — ltc-explorer (All Proposals)

> **DESIGN:** `inbox/2026-04-08_DESIGN-agent-1-explorer.md`
> **Scope:** 6 proposals (E1-E6) — ALL fixes and improvements.
> **Path:** INDEPENDENT — zero cross-agent dependency. Can execute in parallel with SEQ-B and SEQ-C.
> **Execution mode:** Main session Opus direct.
> **Effort:** ~1.5 hrs total.

---

## Dependency DAG

```
T-E1 (WebSearch removal)  ─── independent
T-E2 (Glob verify)        ─── independent
T-E3 (Typed output)       ─── independent (but downstream: Planner EI benefits)
T-E4 (Input completeness) ─── independent
T-E5 (Self-check)         ─── depends on T-E3 (checks against output contract)
T-E6 (Rule loading test)  ─── independent (cross-ref: Planner has same question)
T-ES (Sub-Agent Safety)   ─── depends on T-E1 (references honest fallback)
```

---

## Tasks

### T-E1: Fix WebSearch False Claims [P0, 10 min]

**Files (Write):**
- `.claude/agents/ltc-explorer.md` — lines 42, 53
- `.claude/skills/deep-research/SKILL.md` — lines 9, 14, 20, 166
- `.claude/skills/learn-research/SKILL.md` — lines 13, 19, 60, 68-69

**Change:** Remove all WebSearch references. Replace with honest fallback: Exa → QMD → STOP.

**ACs:**
1. `grep -rc 'WebSearch' .claude/agents/ltc-explorer.md .claude/skills/deep-research/SKILL.md .claude/skills/learn-research/SKILL.md` returns 0 for all 3
2. `grep -c 'local-sources-only' .claude/agents/ltc-explorer.md` ≥1

---

### T-E2: Verify Glob in Tool Guide [P0, 2 min]

**File (Read):** `.claude/agents/ltc-explorer.md`

**Check:** v1.4 already has Glob at line 67. Verify — no edit needed if present.

**AC:** `grep -c 'Glob' .claude/agents/ltc-explorer.md` ≥2

---

### T-E3: Typed Output Contract [P1, 30 min]

**File (Write):** `.claude/agents/ltc-explorer.md`
**DESIGN source:** Agent 1 § EO proposed typed output contract (yaml schema)

**Change:** Add `## Output Contract` section defining:
- Required sections: findings, sources (min 3), confidence (high/med/low), unknowns
- Optional sections: contradictions, recommendations
- Size bounds per tier: lite 1-3K, mid 3-8K, deep 8-15K, full 15-30K
- Source citation rule: every [N] in findings must appear in sources

**ACs:**
1. `grep -c 'Output Contract' .claude/agents/ltc-explorer.md` ≥1
2. `grep -c 'required_sections\|Required sections' .claude/agents/ltc-explorer.md` ≥1
3. `grep -c 'size_bounds\|Size bounds\|lite.*mid.*deep' .claude/agents/ltc-explorer.md` ≥1

---

### T-E4: Input Completeness Check [P1, 15 min]

**File (Write):** `.claude/agents/ltc-explorer.md`
**DESIGN source:** Agent 1 § Proposal E4

**Change:** Add `## Pre-Flight` section before Research Protocol:
```
1. Research question present? If NO → flag, attempt to infer
2. Budget tier specified? If NO → default to lite, flag
3. File paths provided? If NO → search-only mode
4. Search terms provided? If NO → generate from question (acceptable)
```

**ACs:**
1. `grep -c 'Pre-Flight' .claude/agents/ltc-explorer.md` ≥1
2. `grep -c 'Budget tier' .claude/agents/ltc-explorer.md` ≥1

---

### T-E5: Self-Check Before Reporting [P2, 15 min]

**Depends on:** T-E3 (references output contract sections)
**File (Write):** `.claude/agents/ltc-explorer.md`
**DESIGN source:** Agent 1 § Proposal E5

**Change:** Add `## Post-Flight` section after Research Protocol:
```
Before returning output, verify:
1. Findings section present? (required)
2. Sources section present with ≥N citations? (N from budget tier)
3. Every [N] in findings appears in sources?
4. Confidence section present?
5. Unknowns section present?
IF any check fails → fix before returning.
```

**ACs:**
1. `grep -c 'Post-Flight' .claude/agents/ltc-explorer.md` ≥1
2. `grep -c 'fix before returning' .claude/agents/ltc-explorer.md` ≥1

---

### T-E6: Clarify Rule Loading for Sub-Agents [P2, 20 min]

**File (Write):** Empirical test + document result
**DESIGN source:** Agent 1 § Proposal E6, also Planner P1 (same question)
**Cross-ref:** Planner SEQUENCE has same dependency — result applies to both.

**Method:**
1. Dispatch a test explorer with a task that would violate an always-on rule (e.g., naming)
2. Check if explorer follows the rule without it being in the context package
3. Document finding in `memory/learned_patterns.md` (new LP entry)

**ACs:**
1. Test conducted (documented in learned_patterns.md)
2. Finding is binary: "rules DO load" or "rules DO NOT load"
3. All 4 sub-agent DESIGN docs updated with finding (EOE Layer 6)

---

### T-ES: Sub-Agent Safety Section [P0, 5 min]

**Depends on:** T-E1 (references honest fallback)
**File (Write):** `.claude/agents/ltc-explorer.md`

**Change:** Add `## Sub-Agent Safety` before Links:
```
- Read-only agent: most hook constraints are irrelevant (no Write/Edit/Bash)
- If Exa MCP unavailable, fall back to QMD only — do not attempt WebSearch
- No context compaction warning fires — monitor output length on deep/full tasks
```

**AC:** `grep -c 'Sub-Agent Safety' .claude/agents/ltc-explorer.md` = 1

---

## Execution Order

```
Round 1 (parallel):
  T-E1  WebSearch removal        [10m]   P0
  T-E2  Glob verify              [2m]    P0
  T-E4  Input completeness       [15m]   P1

Round 2 (depends on T-E1):
  T-ES  Sub-Agent Safety         [5m]    P0
  T-E3  Typed output contract    [30m]   P1

Round 3 (depends on T-E3):
  T-E5  Self-check               [15m]   P2

Round 4 (independent):
  T-E6  Rule loading test        [20m]   P2

Total: ~1.5 hrs
```

## Version Bumps

| File | Current | New |
|------|---------|-----|
| `.claude/agents/ltc-explorer.md` | 1.4 | 1.5 |
| `.claude/skills/deep-research/SKILL.md` | current | bump minor |
| `.claude/skills/learn-research/SKILL.md` | current | bump minor |
