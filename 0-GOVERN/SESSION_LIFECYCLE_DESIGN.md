---
version: "1.0"
status: Draft
last_updated: 2026-04-02
type: govern
work_stream: GOVERN
stage: Design
sub_system: session-lifecycle
---

# DESIGN — Session Lifecycle Refactor (N1, N2, N3, N4, N7)

## Problem Statement

The session lifecycle skills (/compress, /resume, /session-start, /session-end) have 3 measurable problems:

1. **Token waste:** /resume costs 30-40K tokens (reads 1-3 full session files). On Sonnet 200K, that's 15-20% of context burned before any work starts.
2. **Stale memory:** 5/6 project MEMORY.md Briefing Cards are frozen at 2026-03-17 (15+ days). No mechanism updates them.
3. **Dead code:** /session-start and /session-end are abandoned. User's actual workflow is compress → clear → resume.

## Scope

**In scope:** 4 global skill files + 1 global hook script
**Out of scope:** Project-level skills (`.claude/skills/session/` copies), Obsidian integration, WMS sync, ILE protocol

## UBS (What Blocks Success)

| UBS | Risk | Mitigation |
|-----|------|------------|
| Agent reads full session body despite frontmatter being sufficient | Token waste persists | AC-03 enforces 2-pass with token cap |
| /compress doesn't update Briefing Card → staleness continues | Same problem, different skill | AC-05 makes it mandatory |
| Deprecation breaks a workflow someone else relies on | Regression | Deprecation notice only — don't delete files |

## Artifacts

| # | Artifact | Location | Purpose |
|---|----------|----------|---------|
| A1 | /compress SKILL.md (refactored) | `~/.claude/skills/compress/SKILL.md` | Rich frontmatter, short body, auto-update Briefing Card |
| A2 | /resume SKILL.md (refactored) | `~/.claude/skills/resume/SKILL.md` | 2-pass: frontmatter scan → selective body load |
| A3 | /session-start SKILL.md (deprecated) | `~/.claude/skills/session-start/SKILL.md` | Add deprecation notice at top |
| A4 | /session-end SKILL.md (deprecated) | `~/.claude/skills/session-end/SKILL.md` | Add deprecation notice at top |
| A5 | Staleness guard | `~/.claude/hooks/scripts/memory-staleness.sh` | Shell script: warn if Briefing Card > 7 days old |

## Acceptance Criteria

### A1 — /compress refactored

| AC | Criterion | Test |
|----|-----------|------|
| AC-01 | Session file frontmatter includes fields: `goal`, `state`, `open_items`, `next_action` (in addition to existing `type`, `date`, `project`, `topics`, `outcome`, `importance`) | Read a /compress output file, verify all 10 frontmatter fields present |
| AC-02 | Session file body is ≤20 lines (excluding frontmatter) | `wc -l` on body section of output file |
| AC-03 | /compress auto-updates the active project's MEMORY.md Briefing Card `Current state` line with today's date + 1-line state | After /compress, read MEMORY.md, verify date = today |
| AC-04 | Open items from conversation are extracted into `open_items` frontmatter field as YAML list | Read frontmatter, verify `open_items` is a list |

### A2 — /resume refactored

| AC | Criterion | Test |
|----|-----------|------|
| AC-05 | Pass 1: reads only frontmatter of last 3 session files (not body). Estimated ≤1.5K tokens. | Verify skill text specifies frontmatter-only scan |
| AC-06 | Pass 2: reads body of at most 1 session file (most relevant). Estimated ≤3K tokens. | Verify skill text specifies single-body selective load |
| AC-07 | Total /resume output ≤5K tokens (vs current 30-40K) | Verify skill text includes token cap guidance |
| AC-08 | Open items from `open_items` frontmatter are surfaced in resume output as "Open from last session" | Verify skill text includes open_items display |
| AC-09 | Mode 2 (vault sweep for session-start) removed — replaced with deprecation pointer | Verify Mode 2 section removed or marked deprecated |

### A3 + A4 — Deprecation

| AC | Criterion | Test |
|----|-----------|------|
| AC-10 | /session-start SKILL.md has deprecation notice as first content after frontmatter | Read file, verify notice |
| AC-11 | /session-end SKILL.md has deprecation notice as first content after frontmatter | Read file, verify notice |
| AC-12 | Deprecation notices explain what to use instead (/compress + /resume) | Read notices, verify replacement guidance |

### A5 — Staleness guard

| AC | Criterion | Test |
|----|-----------|------|
| AC-13 | Shell script reads MEMORY.md, extracts Briefing Card date, compares to today | Read script, verify logic |
| AC-14 | If date > 7 days old, outputs warning message to stdout | Test with stale date |
| AC-15 | If MEMORY.md doesn't exist or has no date, exits silently (no crash) | Test with missing file |
| AC-16 | Script runs in <1 second, no dependencies beyond bash + grep + date | Read script, verify |

## Alignment Table

| AC | Artifact |
|----|----------|
| AC-01..AC-04 | A1 (/compress) |
| AC-05..AC-09 | A2 (/resume) |
| AC-10..AC-12 | A3 + A4 (deprecation) |
| AC-13..AC-16 | A5 (staleness guard) |

All 16 ACs map to an artifact. All 5 artifacts have ACs. 0 orphans.

## Out of Scope

- Obsidian daily notes integration (deferred V6)
- WMS sync at session-end (use /notion-planner separately)
- ILE protocol support (remains in deprecated files)
- Project-level skill copies (`.claude/skills/session/`) — leave as-is
- Stop hook (session-summary.sh) — already works, unchanged
- SessionStart hook (resume-check.sh) — unchanged except A5 integration
