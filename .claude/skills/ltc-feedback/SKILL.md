---
version: "2.0"
status: draft
last_updated: 2026-04-07
name: ltc-feedback
description: "Report issues as GitHub Issues using the 7-CS force analysis template. Use when the user expresses frustration, confusion, or suggests an improvement. Creates structured issues with EA→EO, UBS, risk scoring, and root cause classification. Works on any LTC repo."
---
# /ltc-feedback — Report Issues via 7-CS Force Analysis

> Creates a GitHub Issue on the **current repo** using the LTC issue template.
> Classifies by 7-CS root cause component, auto-scored by Risk Factor.
> Renamed from `/feedback` to avoid collision with Claude Code built-in.

## Scope

Any issue on any LTC repo — template-level OR project-level. The issue is filed on
the repo the user is currently working in. Template issues should be filed while
working in the template repo itself.

## Steps

### Step 0 — Seed Labels (idempotent, runs every time)

```bash
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
gh label create "component:ep"      --color "D93F0B" --description "EP — Rule failure"            --repo "$REPO" 2>/dev/null || true
gh label create "component:input"   --color "E99695" --description "Input — Context/direction"     --repo "$REPO" 2>/dev/null || true
gh label create "component:eop"     --color "F9D0C4" --description "EOP — Procedure gap"           --repo "$REPO" 2>/dev/null || true
gh label create "component:eoe"     --color "C5DEF5" --description "EOE — Environment"             --repo "$REPO" 2>/dev/null || true
gh label create "component:eot"     --color "BFD4F2" --description "EOT — Tool failure"            --repo "$REPO" 2>/dev/null || true
gh label create "component:agent"   --color "D4C5F9" --description "Agent — Model limitation"      --repo "$REPO" 2>/dev/null || true
gh label create "needs-diagnosis"   --color "FBCA04" --description "Root cause unknown"             --repo "$REPO" 2>/dev/null || true
gh label create "priority:critical" --color "B60205" --description "RF 6-9 — fix this week"        --repo "$REPO" 2>/dev/null || true
gh label create "priority:medium"   --color "FF9500" --description "RF 3-5 — fix this iteration"   --repo "$REPO" 2>/dev/null || true
gh label create "priority:low"      --color "0E8A16" --description "RF 1-2 — defer/document"       --repo "$REPO" 2>/dev/null || true
```

### Step 1 — Gather from conversation context

From the current conversation, extract:
- **EA:** What action the user took
- **Desired EO:** What they expected
- **Actual EO:** What actually happened
- **UBS:** The blocker (symptom)

### Step 2 — Classify using 7-CS

Determine root cause component:

| Component | Signal |
|-----------|--------|
| EP | Rule file mentioned, rule contradiction, rule not loaded |
| Input | User gave bad context, missing info, ambiguous prompt |
| EOP | Skill/procedure missing a step, no gate, name collision |
| EOE | Hooks, MCP, permissions, settings, structure, platform, context budget |
| EOT | CLI, script, Obsidian, QMD, API, skill file broken |
| Agent | Hallucination (LT-1), context loss (LT-2), reasoning failure (LT-3) |
| Unknown | Cannot determine — flag for diagnosis |

### Step 3 — Risk score

Ask user or estimate from context:
- **Probability (1-3):** 1=rare, 2=some users, 3=most users
- **Impact (1-3):** 1=cosmetic, 2=painful, 3=blocked

Risk Factor = P × I

### Step 4 — Dedup check

```bash
gh issue list --search "TITLE_KEYWORDS" --repo "$REPO" --json number,title --jq '.[].title'
```

If match found: show existing issue, ask if user still wants to create.

### Step 5 — Draft and confirm

```
Issue draft:
  Repo:        {repo}
  Title:       [{type}][{zone}] {description}
  EA:          {action}
  Desired EO:  {expected}
  Actual EO:   {actual}
  UBS:         {symptom}
  Risk:        P={p} × I={i} = RF {rf}
  UBS.UD:      {component} — {detail}
  Resolution:  {fix}

Create this issue? [y/n/edit]
```

**GATE:** Wait for explicit user confirmation. Never create without it.

### Step 6 — Create issue

```bash
cat > /tmp/ltc-issue-body.md << 'ISSUE_EOF'
## EA → EO

**EA:** {action}
**Desired EO:** {expected}
**Actual EO:** {actual}

## UBS — What blocked

{symptom}

## Risk

**Probability:** {p} | **Impact:** {i} | **Risk Factor:** {rf}

## UBS.UD — {component}

{detail}

## Resolution

{fix}
ISSUE_EOF

gh issue create \
  --title "[{type}][{zone}] {description}" \
  --body-file /tmp/ltc-issue-body.md \
  --label "triage" \
  --repo "$REPO"
```

### Step 7 — Verify and cleanup

Capture URL from stdout. If empty → error, do NOT retry silently.
```
✓ Issue created: {URL}
```

Clean up: `rm /tmp/ltc-issue-body.md`

## Escape Hatch

If `gh` is not authenticated or API fails:
1. Print the issue body as copyable markdown
2. Instruct: "Paste this into {repo_url}/issues/new manually"
3. Do NOT retry silently

## Gotchas

See [gotchas.md](gotchas.md) for classification pitfalls and severity definitions.

## References

- [classification-guide.md](references/classification-guide.md) — type/workstream/severity detection
- [friction.md](templates/friction.md) — friction issue body template
- [idea.md](templates/idea.md) — idea issue body template

## Links

- [[CLAUDE]]
- [[blocker]]
- [[classification-guide]]
- [[friction]]
- [[gotchas]]
- [[idea]]
- [[iteration]]
- [[workstream]]
