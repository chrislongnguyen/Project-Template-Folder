# /feedback — Report Template Feedback to Maintainers

> Creates a GitHub Issue on the **template repo** (not the current project).
> Use when something in the scaffold, rules, skills, or shared frameworks
> is broken, confusing, or could be better.

## Scope

This skill is for **template-level feedback only** — issues with the APEI scaffold,
DSBV process, rules, skills, or `_shared/` frameworks that affect ALL projects.

For project-specific issues (your own bugs, your own domain): use `gh issue create`
directly in your repo. This skill always routes to the template maintainers.

## Steps

1. **Detect type** from conversation context:
   - Frustration, confusion, breakage → `friction`
   - Suggestion, wish, "it would be nice if" → `idea`

2. **Detect zone** from recent file paths or conversation topic:

   | Pattern | Zone label |
   |---------|-----------|
   | `1-ALIGN/`, charter, stakeholders, OKRs | `zone:align` |
   | `2-PLAN/`, risks, drivers, architecture | `zone:plan` |
   | `3-EXECUTE/`, src, tests, config | `zone:execute` |
   | `4-IMPROVE/`, changelog, retro, metrics | `zone:improve` |
   | `_shared/`, frameworks, templates, SOPs | `zone:shared` |
   | `.claude/`, `rules/`, `CLAUDE.md`, skills, hooks | `zone:agent` |
   | DSBV process, `/dsbv`, DESIGN.md, SEQUENCE.md | `zone:agent` |

3. **Detect severity** (friction only):

   | Severity | Meaning |
   |----------|---------|
   | `blocked` | Could not proceed at all |
   | `confused` | Unclear what to do or where to look |
   | `annoying` | Works but frustrating |

4. **Draft and confirm** with user (minimal input):

   ```
   Template feedback detected:
     Type:     friction
     Zone:     agent
     Severity: confused
     What:     [pre-filled from conversation context]
     Suggest:  [pre-filled or ask user]

   Create this issue on the template repo? [y/n/edit]
   ```

   Wait for user confirmation. Never create without it.

5. **Create GitHub Issue** on the template repo:

   For **friction**:
   ```bash
   gh issue create \
     --repo Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE \
     --label "friction" --label "triage" --label "zone:ZONE" --label "severity:SEVERITY" \
     --title "[friction][ZONE] Short description" \
     --body "$(cat <<'EOF'
   **Reporter:** [user name or "anonymous"]
   **Project:** [current repo name, so maintainers know which consumer hit this]
   **Zone:** ZONE
   **Severity:** SEVERITY

   ## What happened
   [1-3 sentences. Name the specific file, skill, step, or rule.]

   ## Expected behavior
   [What should have happened instead.]

   ## Suggestion
   [How to fix or improve. "I don't know" is acceptable.]

   ## Context
   [Any relevant file paths, error messages, or conversation excerpts.]
   EOF
   )"
   ```

   For **idea**:
   ```bash
   gh issue create \
     --repo Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE \
     --label "idea" --label "triage" --label "zone:ZONE" \
     --title "[idea][ZONE] Short description" \
     --body "$(cat <<'EOF'
   **Reporter:** [user name or "anonymous"]
   **Project:** [current repo name]
   **Zone:** ZONE

   ## What would improve
   [1-3 sentences. Be specific.]

   ## Proposed change
   [What the improvement looks like. Include file paths if relevant.]
   EOF
   )"
   ```

6. **Report** the issue URL back to the user.

## Constraints

- **Always route to template repo** — `--repo Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE`
- Never create an issue without user confirmation
- Keep titles under 80 characters
- One issue per friction point — do not batch
- Include the reporter's current repo name so maintainers know which consumer project hit the issue
- If `gh` is not authenticated or lacks permission to the template repo, tell the user and provide the issue body as copyable text instead

## Format Reference

See `_shared/templates/FEEDBACK_TEMPLATE.md` for the canonical field schema.
