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
| 1 (Identity) | §0 Force Analysis, §1 Identity | Strategic: forces, RACI, personas |
| 2 (Behavioral) | §2 Verb ACs | Functional: what the system does |
| 3 (Quality) | §3 Adverb ACs, §5 Adjective ACs | Quality: how well + what properties |
| 4 (Structural) | §4 Noun ACs | Structural: what components exist |
| 5 (Synthesis) | §6 Boundaries, AC-TEST-MAP, §7 Failure, §8 Boundaries, §9 Iteration, §10 Integration | Cross-cutting: boundaries, testing, integration |

**Step 2: Dispatch 5 sub-agent groups in parallel**

Each sub-agent receives:
- The Section Allocation Map (for cross-reference awareness)
- Only the source material relevant to their group
- The VANA-SPEC template sections they must fill
- Budget hint: "This task should require approximately 30K tokens of context."

**Step 3: Each sub-agent self-reviews against source material before returning**

Checkpoint: "Does every claim trace to a source page/row/col?"

**Step 4: Lead assembles all sections into complete VANA-SPEC**

Runs cross-section consistency check:
- Every AC ID referenced in §6 exists in §2-§5
- Every persona reference in §2-§5 matches §1
- Every force in §0 maps to at least one principle in §3/§5
- Traceability chain complete for every AC

**Step 5: Run MECE validator script**

```bash
./1-ALIGN/skills/ltc-brainstorming/scripts/mece-validator.sh 2-PLAN/architecture/specs/<spec-file>.md
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

### §0 Force Analysis (before §1)

**Required content:** UBS(R), UBS(A), UDS(R), UDS(A), recursive decomposition (minimum 1 level), sigmoid zone classification, bottleneck identification, synergy check.

Use the extended template at `_genesis/templates/VANA_SPEC_TEMPLATE.md` for the full §0 structure.

### §6 System Boundaries (new position; old §6+ shift down)

**Required content:** Layer 1 (What Flows), Layer 2 (How It Flows Reliably), Layer 3 (How You Verify), Layer 4 (How It Fails Gracefully), Integration Chain, Feedback Loops.

Use the extended template at `_genesis/templates/VANA_SPEC_TEMPLATE.md` for the full §6 structure.

**Apply META-RULE 4 (VANA DECOMPOSE) and META-RULE 5 (DEFINE DONE) throughout all AC sections.**
