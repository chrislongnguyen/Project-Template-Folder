---
version: "1.2"
status: draft
last_updated: 2026-04-13
requires: ""
release_version: ""
release_date: ""
---

# Release Notes — v{VERSION}

> Released: {DATE} | Requires: v{PRIOR_VERSION} | {N} commits

---

## This Release In 30 Seconds

_2-3 sentences addressing the user's current pain. Name the problem they've been living with. Then state the outcome this release delivers — not what you built, but what changes for them. End with one sentence on stability/trust._

---

## What Changes For You

_3-5 workflow deltas, ranked by impact. Each one follows this pattern:_

### {N}. {Outcome headline — no jargon, no file paths}

_Describe what was painful in v{PRIOR}, then what's different in v{VERSION}. Use a comparison table for the biggest change. Use prose for the rest. If the user runs a command directly, show it. If it's automated behind the scenes, just describe the outcome — don't show internal scripts._

---

## What Else Improved

_Table of secondary improvements. Column headers: Change | Why It Matters To You. Keep descriptions in user terms._

| Change | Why It Matters To You |
|--------|----------------------|
| {change} | {user-facing benefit} |

---

## Issues Fixed

| Issue | What Was Wrong |
|-------|---------------|
| #{N} | {description of the problem the user experienced} |

---

## How To Upgrade

_Two options: agent-guided (recommended) and manual. Agent-guided = a paste-ready prompt. Manual = numbered bash steps with safety net first, sync, verify, commit, PR._

**Option A — Agent-guided (recommended)**

```
Read _genesis/guides/migration-guide.md and execute Path C for template v{VERSION}.
Guide me through each step.
```

**Option B — Manual**

```bash
# Safety net
git checkout -b feat/template-v{VERSION}
git tag backup/pre-v{VERSION}

# Sync + verify + commit
bash scripts/template-sync.sh --sync v{VERSION}
bash scripts/template-verify.sh
git add .claude/ _genesis/ scripts/ rules/ CLAUDE.md AGENTS.md VERSION
git commit -m "chore(govern): sync with template v{VERSION}"
```

**Rollback:**
```bash
git checkout main && git branch -D feat/template-v{VERSION}
```

---

## Links

- [[CHANGELOG]]
- [[migration-guide]]
- [[versioning]]
