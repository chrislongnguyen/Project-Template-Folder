---
version: "1.0"
last_updated: 2026-03-30
---
# Spec Production — Sectional Sub-Agent Orchestration & Extended Output

Reference material for VANA-SPEC production. Read this before dispatching sub-agents.

## Sectional Sub-Agent Orchestration

When writing the VANA-SPEC, decompose spec generation across 5 sub-agent groups to prevent context overload (compensates for LT-2 context compression and LT-3 reasoning degradation).

**Read `section-allocation.md` before dispatching sub-agents.**

### Protocol

**Step 1: Lead reads all context, produces Section Allocation Map**

The lead agent (you) reads all source material and creates a Section Allocation Map that assigns VANA-SPEC sections to 5 groups:

| Group | Sections | Focus |
|---|---|---|
| 1 (Identity) | §2 Force Analysis, §1 Identity | Strategic: forces, RACI, personas |
| 2 (Behavioral) | §4.1 Verb ACs | Functional: what the system does |
| 3 (Quality) | §4.2 Adverb ACs, §4.4 Adjective ACs | Quality: how well + what properties |
| 4 (Structural) | §4.3 Noun ACs | Structural: what components exist |
| 5 (Synthesis) | §6 Boundaries, §5 AC-TEST-MAP, §7 Failure, §8 Boundaries, §9 Iteration, §6 Integration | Cross-cutting: boundaries, testing, integration |

**Step 2: Dispatch 5 sub-agent groups in parallel**

Use `ltc-builder` agent file (`.claude/agents/ltc-builder.md`) for each group. Wrap each dispatch in the context packaging template (`.claude/skills/dsbv/references/context-packaging.md`):

- **EO:** "Group {N} VANA-SPEC sections are filled with traced claims"
- **INPUT:** Context (project + spec purpose), Files (Allocation Map + source material + templates), Budget (~30K tokens)
- **EP:** EP-10 (Define Done), EP-08 (Signal Over Volume) + only fill assigned sections
- **OUTPUT:** Filled template sections + ACs: every claim traces to source page/row/col
- **VERIFY:** Section count matches allocation. Traceability check passes.

**Step 3: Each sub-agent self-reviews against source material before returning**

Checkpoint: "Does every claim trace to a source page/row/col?"

**Step 4: Lead assembles all sections into complete VANA-SPEC**

Runs cross-section consistency check:
- Every AC ID referenced in §6 exists in §4.1-§4.4
- Every persona reference in §4.1-§4.4 matches §1
- Every force in §2 maps to at least one principle in §4.2/§4.4
- Traceability chain complete for every AC

**Step 5: Run MECE validator script**

```bash
.claude/skills/ltc-brainstorming/scripts/mece-validator.sh 3-PLAN/architecture/specs/<spec-file>.md
```

- Every AC in §2-§5 appears exactly once in AC-TEST-MAP
- No duplicate AC IDs
- All source references follow format conventions
- §0 has at least 1 recursive decomposition level

### Failure Behavior

| Scenario | Action |
|---|---|
| Sub-agent failure | Retry that group (max 2 retries) |
| Assembly failure | Retry assembly with explicit error feedback |
| After 2 failed retries on any group | Escalate to Human Director with partial output + error log |
| Partial spec | Acceptable for review — missing sections flagged with `[INCOMPLETE]` tags |
| Timeout | 30 min wall-clock per group; 60 min total for assembly + validation |

## Extended VANA-SPEC Output

The OE.6.4 VANA-SPEC includes two NEW sections beyond the standard template:

### §2 Force Analysis (before §1)

**Required content:** UBS(R), UBS(A), UDS(R), UDS(A), recursive decomposition (minimum 1 level), sigmoid workstream classification, bottleneck identification, synergy check.

Use the extended template at `_genesis/templates/VANA_SPEC_TEMPLATE.md` for the full §2 structure.

### §6 System Boundaries (new position; old §6+ shift down)

**Required content:** Layer 1 (What Flows), Layer 2 (How It Flows Reliably), Layer 3 (How You Verify), Layer 4 (How It Fails Gracefully), Integration Chain, Feedback Loops.

Use the extended template at `_genesis/templates/VANA_SPEC_TEMPLATE.md` for the full §6 structure.

**Apply META-RULE 4 (VANA DECOMPOSE) and META-RULE 5 (DEFINE DONE) throughout all AC sections.**

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[EP-08]]
- [[EP-10]]
- [[architecture]]
- [[context-packaging]]
- [[iteration]]
- [[ltc-builder]]
- [[project]]
- [[section-allocation]]
- [[standard]]
- [[workstream]]
