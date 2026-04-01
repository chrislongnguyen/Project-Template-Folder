# Idea Issue Template

## gh issue command

```bash
gh issue create \
  --repo Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE \
  --label "idea" --label "triage" --label "workstream:WORKSTREAM" \
  --title "[idea][WORKSTREAM] Short description" \
  --body "$(cat <<'EOF'
**Reporter:** [user name or "anonymous"]
**Project:** [current repo name]
**Workstream:** WORKSTREAM

## What would improve
[1-3 sentences. Be specific.]

## Proposed change
[What the improvement looks like. Include file paths if relevant.]
EOF
)"
```

## Links

- [[project]]
- [[workstream]]
