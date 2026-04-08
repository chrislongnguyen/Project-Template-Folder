---
name: ltc-rules-compliance
version: "1.0"
status: draft
last_updated: 2026-04-07
description: >
  Use when auditing whether work complies with LTC rules, before shipping or merging,
  or when the user asks "is this compliant?" across brand, naming, security, DSBV, and
  skill governance. Produces a pass/warn/fail compliance report with concrete fixes.
  Do NOT replace specialist skills — route to ltc-brand-identity and ltc-naming-rules
  for deep execution checks.
---

# LTC Rules Compliance

Routes rule checks into one practical compliance pass so users get a clear decision
(PASS/WARN/FAIL), the exact violated rule source, and next actions to remediate.

## When to Use

- Before final handoff, PR creation, release packaging, or "done" declarations
- When user asks to "check & comply to LTC rules" for an artifact or workstream
- When multiple rule domains may apply (brand + naming + security + process gates)
- User runs `/ltc-rules-compliance`

## Steps

1. **Scope the target and artifact types**
   Reference: [references/scope-matrix.md](references/scope-matrix.md) to identify which rule families apply.

2. **Load canonical rule sources**
   - Always load `CLAUDE.md`
   - Then load only applicable sources:
     - `rules/brand-identity.md` (visual artifacts)
     - `rules/naming-rules.md` (UNG names)
     - `rules/security-rules.md` (secrets/risk/external boundaries)
     - `_genesis/reference/ltc-eop-gov.md` (if skill creation/review is in scope)
   - If the check involves skills, run `./scripts/skill-validator.sh <skill-dir>`

3. **Run specialist checks (do not duplicate)**
   - For visual checks, invoke `ltc-brand-identity`
   - For naming checks, invoke `ltc-naming-rules`
   - For workflow/process checks, verify required gates from relevant skill docs (e.g. DSBV, session-end)

4. **GATE:** Do not mark compliance PASS until all are true
   - Every in-scope rule family is marked PASS/WARN/FAIL with citation to source file
   - Any FAIL has at least one remediation action
   - No HIGH-risk action from security rules was executed without explicit user confirmation
   - Unknown/ambiguous checks are explicitly listed as ASSUMPTION (never silently passed)

5. **Publish actionable report**
   Use [templates/compliance-report.md](templates/compliance-report.md).
   Keep it short and operational: status, findings, fixes, and follow-up checks.

## Constraints

- This skill is an **orchestrator**; it must not re-implement brand or naming logic.
- Prefer deterministic evidence (validator output, rule table matches, explicit gate checks) over stylistic judgments.
- If an item is out of scope for LTC rules, mark `NOT APPLICABLE` with reason instead of forcing a verdict.

## Escape Hatch

If a required rule source is missing, unreadable, or contradictory: stop PASS/FAIL classification for that family, report `BLOCKED`, and ask the user whether to proceed with a partial report or restore the canonical source first.

## Gotchas

See [gotchas.md](gotchas.md) for known failure patterns.

## Links

- [[CLAUDE]]
- [[brand-identity]]
- [[compliance-report]]
- [[gotchas]]
- [[ltc-eop-gov]]
- [[naming-rules]]
- [[scope-matrix]]
- [[security]]
- [[security-rules]]
- [[workstream]]
