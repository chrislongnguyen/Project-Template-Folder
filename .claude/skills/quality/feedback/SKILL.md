---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
name: feedback
description: "Report template-level feedback as GitHub Issues. Use when the user
  expresses frustration, confusion, or suggests an improvement about the APEI scaffold,
  DSBV process, rules, skills, or shared frameworks. Captures friction reports and
  ideas for template maintainers. Do NOT use for project-specific bugs."
---
# /feedback — Report Template Feedback to Maintainers

> Creates a GitHub Issue on the **template repo** (not the current project).
> Use when something in the scaffold, rules, skills, or shared frameworks
> is broken, confusing, or could be better.

## Scope

Template-level feedback only — issues with the APEI scaffold, DSBV process, rules,
skills, or `_genesis/` frameworks that affect ALL projects.

For project-specific issues: use `gh issue create` directly in your repo.

## Steps

1. **Classify** the feedback using [references/classification-guide.md](references/classification-guide.md):
   - Detect **type** (friction vs idea) from conversation context
   - Detect **workstream** from recent file paths or topic
   - Detect **severity** (friction only: blocked / confused / annoying)

2. **Draft and confirm** with user (minimal input):

   ```
   Template feedback detected:
     Type:     friction
     Workstream:     agent
     Severity: confused
     What:     [pre-filled from conversation context]
     Suggest:  [pre-filled or ask user]

   Create this issue on the template repo? [y/n/edit]
   ```

   **GATE:** Wait for explicit user confirmation. Never create without it.

3. **Create GitHub Issue** using the appropriate template:
   - Friction: [templates/friction.md](templates/friction.md)
   - Idea: [templates/idea.md](templates/idea.md)

   Replace all placeholders (WORKSTREAM, SEVERITY, descriptions) with actual values.

4. **Report** the issue URL back to the user.

## Constraints

- Always route to template repo — `--repo Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE`
- Never create an issue without user confirmation
- Keep titles under 80 characters
- One issue per friction point — do not batch
- Include the reporter's current repo name so maintainers know which consumer project hit the issue

## Escape Hatch

If `gh` is not authenticated or lacks permission to the template repo, tell the user
and provide the issue body as copyable text instead.

## Gotchas

- Classification tables and severity definitions live in [references/classification-guide.md](references/classification-guide.md) — consult before classifying
- Issue body format must match the templates exactly to preserve downstream automation

## Format Reference

See `_genesis/templates/FEEDBACK_TEMPLATE.md` for the canonical field schema.

## Links

- [[FEEDBACK_TEMPLATE]]
- [[classification-guide]]
- [[dsbv]]
- [[friction]]
- [[gotchas]]
- [[idea]]
- [[project]]
- [[workstream]]
