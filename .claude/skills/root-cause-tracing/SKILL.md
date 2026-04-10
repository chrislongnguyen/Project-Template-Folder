---
version: "1.1"
status: draft
last_updated: 2026-04-07
name: root-cause-tracing
description: Learn Source causal chain reasoning using UBS/UDS recursive dot-notation. This skill should be used when tracing phenomena to ultimate causes — for Phase C page content (cols 4, 5, 10, 11), debugging learning difficulties, or analyzing system failures. NOT generic 5 Whys. Output maps directly to the 17-column table format.
---
# Root-Cause Tracing — Learn Source Causal Chain Analysis

Traces any phenomenon (a blocker, a driver, a failure, an unexpected outcome) to its ultimate cause using the Learn Source's UBS/UDS recursive dot-notation system. Output is table-ready for Phase C pages.

## When to Use

- Generating Phase C page content (cols 4, 5, 10, 11 require causal tracing)
- Learner wants to understand WHY a UBS persists or a UDS fails
- Phase B document analysis (identifying root systems in the UEDS)
- Debugging a learning difficulty (what UBS blocks the Learner's progress?)
- User runs `/trace`

## Procedure

**Reference:** [references/causal-chain-procedure.md](references/causal-chain-procedure.md)

## Notation Validation

**Reference:** [references/notation-validator.md](references/notation-validator.md)

## Rules

- ALWAYS use dot-notation: UBS.UB, UBS.UD, UDS.UD, UDS.UB and their recursions
- NEVER use UBS1, UBS2, UDS1, UDS2 or any numbered notation
- Each level of the trace produces exactly ONE cause (not a list)
- Respect the Hierarchy of Science: Sociology > Psychology > Biology > Chemistry > Physics > Mathematics > Logic > Philosophy
- Output must map to 17-column table: col 4 (UDS), col 5 (mechanism), col 10 (UBS), col 11 (failure mechanism)
- Perspective Rule applies: direction of "works" and "fails" inverts depending on whether the row subject is a UBS or UDS (CLAUDE.md section 6)
- Shared forces must be identified when they appear (e.g., Bio-Efficient Forces = UBS.UD.UD = UDS.UD.UB)
- Trace ONE level at a time. Present each level to the Learner before going deeper.

## Related Skills

- **kaizen** — when a trace reveals a systemic pattern, use kaizen to diagnose and extract a permanent rule. Note: kaizen skill is not currently available in this repo.
- **brainstorming** (`.claude/skills/ltc-brainstorming/SKILL.md`) — when multiple causal candidates exist at the same level, use brainstorming to explore alternatives before committing

## Links

- [[CLAUDE]]
- [[blocker]]
- [[causal-chain-procedure]]
- [[notation-validator]]
