---
date: "2026-04-07"
type: session-summary
source: dsbv
tags: [github-issues, 7-CS, feedback-skill, auto-triage, DSBV-complete]
---

# GitHub Issue System — DSBV Complete

Full DSBV cycle: Design → Sequence → Build → Validate. 20/20 ACs pass.

## What was built

| Artifact | Purpose |
|----------|---------|
| `.github/ISSUE_TEMPLATE/ltc-issue.yml` | 8-field issue form: EA→EO, UBS, Risk P×I, UBS.UD component dropdown, detail, resolution |
| `.github/ISSUE_TEMPLATE/config.yml` | Disable blank issues in GitHub UI |
| `.github/workflows/issue-triage.yml` | Auto-parse form → auto-label component:* + priority:* from Risk Factor, auto-close blank issues |
| `.claude/skills/ltc-feedback/SKILL.md` | Agent EOP for creating issues. 7-step procedure with inline label seeding, dedup check, human gate, escape hatch |
| `.claude/skills/ltc-feedback/gotchas.md` | 5 gotchas including project board setup instructions |

## Key design decisions

1. **7-CS force analysis as issue structure:** EA→EO (desired vs actual), UBS (symptom), UBS.UD (root cause = one of 6 components), Resolution (fix component → UBS gone → EO reached)
2. **No EU in dropdown:** Human Director is outside the 7-CS formula. Human error routes through Input (bad direction = bad input to agent system)
3. **Risk Factor = P(1-3) × I(1-3):** Auto-triaged to priority:critical (6-9), medium (3-5), low (1-2)
4. **Form ships to all repos via template-sync:** Each project runs its own triage workflow
5. **Renamed /feedback → /ltc-feedback:** Avoids Claude Code built-in name collision (same pattern as /resume)

## Issues resolved

- Closes #19 (dead symlink + buried subdirectory)
- Closes #20 (name collision with built-in)
- Addresses #17 (template-sync v2 — issue form ships with template)

## Commits

- `b7ef85c` feat(govern): GitHub Issue System — form + workflow + config
- `d5e72c8` feat(skills): /ltc-feedback — rename + rewrite
- `322fcd9` docs(learn): PKB captures + distilled updates

## Also in this session (prior to DSBV)

- I2 hotfix batch (commit `28f3d23`): 12 fixes across setup, smoke-test, rules, skills, BLUEPRINT
- Issue #13 responded (folder confusion)
- Issue #14 responded (resume cache bug explanation + Option A/B)
- Issue #17 created (template-sync v2 guided SOP)
- deep-research:lite on GitHub issue best practices → PKB captured
- 5 LTC repos audited for template-sync gap analysis
- CC native /resume cache bug investigation (still broken as of v2.1.92)

## Links

- [[BLUEPRINT]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[gotchas]]
- [[project]]
- [[session-summary]]
