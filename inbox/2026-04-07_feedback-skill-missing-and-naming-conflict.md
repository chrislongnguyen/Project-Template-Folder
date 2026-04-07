---
date: "2026-04-07"
type: capture
source: conversation
tags: []
---

# Feedback skill: missing + naming conflict with Claude Code built-in

## What happened

CLAUDE.md says:
> "Want me to capture this as feedback? Takes 30 seconds with /feedback. Feedback creates a GitHub Issue for template maintainers."

Full spec reference: `.claude/skills/quality/feedback/SKILL.md`

That file **does not exist**. The skill was never built.

## Compounding problem: naming collision

Even if the skill were built, `/feedback` is a **Claude Code built-in command** ("Submit feedback about Claude Code"). Built-ins win — the custom skill is invisible in the autocomplete list.

Screenshot evidence: `/feed` autocomplete shows `/feedback → Submit feedback about Claude Code` (Claude Code native), not any LTC skill.

## Third problem: wrong subdirectory

The reference path `.claude/skills/quality/feedback/SKILL.md` puts the skill under a `quality/` subdirectory. Claude Code skill discovery requires a **flat** `.claude/skills/` layout — subdirectories are not traversed. (Same issue fixed for `wms/` in commit 237e255.)

## Fixes needed

| Fix | Scope |
|-----|-------|
| Rename the skill to avoid collision — e.g. `/ltc-feedback` or `/project-feedback` | Template design |
| Move to flat layout: `.claude/skills/ltc-feedback/SKILL.md` | Template structure |
| Build the skill (create GitHub Issue for template repo) | Pending implementation |
| Update CLAUDE.md reference from `/feedback` → `/ltc-feedback` | CLAUDE.md |

## CLAUDE.md dead reference

Line 85-86 of CLAUDE.md currently points to a non-existent file. This is a broken promise to the user — they're told to use `/feedback` but neither the skill nor the routing exists.
