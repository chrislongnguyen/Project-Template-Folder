# Friction Issue Template

## gh issue command

```bash
gh issue create \
  --repo Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE \
  --label "friction" --label "triage" --label "workstream:WORKSTREAM" --label "severity:SEVERITY" \
  --title "[friction][WORKSTREAM] Short description" \
  --body "$(cat <<'EOF'
**Reporter:** [user name or "anonymous"]
**Project:** [current repo name, so maintainers know which consumer hit this]
**Workstream:** WORKSTREAM
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
