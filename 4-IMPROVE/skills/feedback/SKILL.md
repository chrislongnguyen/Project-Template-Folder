# /feedback — Capture User Feedback as GitHub Issue

> Invoked when a user expresses frustration, confusion, or suggests an improvement.
> Creates a GitHub Issue using the project's issue templates.

## Trigger

- User says something is broken, confusing, annoying, or could be better
- Agent detects repeated friction with a file, skill, or workflow
- User explicitly runs `/feedback`

## Steps

1. **Detect type** from conversation context:
   - Frustration, confusion, breakage → `friction`
   - Suggestion, wish, "it would be nice if" → `idea`

2. **Auto-detect zone** from recent file paths:
   - `1-ALIGN/` → align | `2-PLAN/` → plan | `3-EXECUTE/` → execute
   - `4-IMPROVE/` → improve | `_shared/` → shared
   - `.claude/`, `rules/`, `CLAUDE.md` → agent

3. **Confirm with user** (minimal input):
   - "Type: friction | Zone: execute | Severity: confused"
   - "What happened: [pre-filled from context]"
   - "Suggestion: [ask user or pre-fill]"
   - Wait for user OK or edits before creating issue.

4. **Create GitHub Issue** using `gh`:

For **friction**:
```bash
gh issue create \
  --label "friction" --label "triage" --label "zone:ZONE" --label "severity:SEVERITY" \
  --title "[friction][ZONE] Short description" \
  --body "$(cat <<'EOF'
**Zone:** ZONE
**Severity:** SEVERITY

## What happened
DESCRIPTION

## Suggestion
SUGGESTION
EOF
)"
```

For **idea**:
```bash
gh issue create \
  --label "idea" --label "triage" --label "zone:ZONE" \
  --title "[idea][ZONE] Short description" \
  --body "$(cat <<'EOF'
**Zone:** ZONE

## What would improve
DESCRIPTION

## Proposed change
SUGGESTION
EOF
)"
```

5. **Report** the issue URL back to the user.

## Format Reference

See `_shared/templates/FEEDBACK_TEMPLATE.md` for the canonical field schema.

## Constraints

- Never create an issue without user confirmation
- Keep titles under 80 characters
- One issue per friction point — do not batch
- If `gh` is not authenticated, tell the user and skip
