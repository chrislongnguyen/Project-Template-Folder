# Section Allocation Map

> Reference for sectional sub-agent orchestration in the brainstorming skill.
> Ground truth: spec §4.1 (Fix 1 — Sectional Sub-Agents)

## Purpose

Stage 1 brainstorming decomposes VANA-SPEC generation across 5 sub-agent groups to prevent context overload. This map defines which sections each group owns, what source material it needs, and its context budget.

## The 5 Groups

| Group | Name | Sections | Focus | Context Budget |
|---|---|---|---|---|
| 1 | Identity | §0 Force Analysis, §1 Identity | Strategic: forces, RACI, personas | ~30K tokens |
| 2 | Behavioral | §2 Verb ACs | Functional: what the system does | ~30K tokens |
| 3 | Quality | §3 Adverb ACs, §5 Adjective ACs | Quality: how well + what properties | ~30K tokens |
| 4 | Structural | §4 Noun ACs | Structural: what components exist | ~30K tokens |
| 5 | Synthesis | §6 Boundaries, AC-TEST-MAP, §7 Failure Modes, §8 Behavioral Boundaries, §9 Iteration Plan, §10 Integration Contracts | Cross-cutting: boundaries, testing, integration | ~30K tokens |

## Source Material Routing

Each sub-agent receives ONLY the source material relevant to their group, plus the Section Allocation Map itself for cross-reference awareness.

| Group | Required Source Material |
|---|---|
| 1 (Identity) | ELF output, domain context, stakeholder interviews, RACI inputs, agent-system.md §4 (UBS/UDS framework), general-system.md §5 (Force Analysis), SYSTEM-THINKING-DESIGN-NOTES-v2.md (sigmoid workstreams) |
| 2 (Behavioral) | ELF output (functional requirements sections), user stories, use cases, existing API contracts |
| 3 (Quality) | ELF output (quality/NFR sections), SLA requirements, performance targets, general-system.md §6 (S > E > Sc) |
| 4 (Structural) | ELF output (architecture/component sections), existing codebase structure, technical constraints |
| 5 (Synthesis) | Summaries from Groups 1-4 (provided by lead after assembly), general-system.md §7 (4-layer boundaries), SYSTEM-THINKING-DESIGN-NOTES-v2.md (feedback loops) |

## Dispatch Protocol

### Step 1: Lead Produces Section Allocation Map

The lead agent reads all context and creates a project-specific allocation map that:
- Assigns concrete source pages/sections to each group
- Estimates token count per group's source material
- Flags any group that exceeds ~30K tokens (split into sub-groups if needed)

### Step 2: Parallel Dispatch

Dispatch all 5 groups as parallel Agent tool calls. Each sub-agent prompt includes:

```
You are Group {N} ({Name}) in a sectional VANA-SPEC generation.

YOUR SECTIONS: {list of sections to fill}
YOUR SOURCE MATERIAL: {attached source content}
SECTION ALLOCATION MAP: {full map for cross-reference awareness}
TEMPLATE: {VANA-SPEC template sections to fill}

RULES:
- Fill ONLY your assigned sections
- Every claim must trace to source material
- Use standard AC ID format: {Type}-AC{N} (e.g., Verb-AC1, Adverb-AC3)
- Reference other groups' sections by placeholder ID when needed
- Self-review before returning: "Does every claim trace to a source?"

BUDGET HINT: This task should require approximately 30K tokens of context.
```

### Step 3: Self-Review

Each sub-agent runs this checkpoint before returning:
- Does every claim trace to a source page/row/col?
- Are all AC IDs unique within this group?
- Are cross-references to other groups' sections clearly marked?

### Step 4: Lead Assembly

The lead assembles all 5 groups into a complete VANA-SPEC and runs:

| Check | Criteria |
|---|---|
| AC ID cross-reference | Every AC ID referenced in §6 (Boundaries) exists in §2-§5 |
| Persona consistency | Every persona reference in §2-§5 matches §1 (Identity) |
| Force-to-principle mapping | Every force in §0 maps to at least one principle in §3/§5 |
| Traceability chain | Complete for every AC: AC <- VANA Element <- ESD Decision <- Source <- EO |

### Step 5: MECE Validation

Run the deterministic validator:

```bash
.claude/skills/ltc-brainstorming/scripts/mece-validator.sh <spec-path>
```

## Failure Handling

| Scenario | Action | Max Attempts |
|---|---|---|
| Sub-agent returns incomplete sections | Retry that group with explicit feedback | 2 retries |
| Sub-agent returns but fails self-review | Retry with the self-review failures highlighted | 2 retries |
| Assembly cross-check fails | Retry assembly with specific error feedback | 2 retries |
| After max retries exhausted | Escalate to Human Director with partial output + error log | N/A |
| Partial spec | Tag missing sections with `[INCOMPLETE]`, proceed to review | N/A |

## Context Budget Constraints

- **Total per sub-agent:** ~200K tokens (Opus context window)
- **EP (rules + SKILL.md):** ~5K tokens (re-injected meta-rules)
- **Input (source material):** ~30K tokens per group
- **EOP (template sections):** ~10K tokens
- **Reasoning reserve:** ~155K tokens

If source material for any group exceeds 30K tokens:
1. Split the group into sub-groups
2. Or summarize source material before dispatch (with explicit note that summarization occurred)

## Links

- [[SKILL]]
- [[agent-system]]
- [[architecture]]
- [[general-system]]
- [[iteration]]
- [[standard]]
- [[task]]
