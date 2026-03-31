# Idea Issue Template

## gh issue command

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
