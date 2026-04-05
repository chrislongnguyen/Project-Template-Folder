---
version: "1.1"
last_updated: 2026-04-04
purpose: "Template for LTC members to create their personal ~/.claude/CLAUDE.md"
type: template
work_stream: 0-govern
stage: design
sub_system: 
---
# CLAUDE.md — Global ({YOUR_NAME}, LTC Partners)

> Machine-wide baseline. Loaded EVERY session. Project CLAUDE.md overrides where it conflicts.
> Keep under 50 lines. Project-specific rules belong in project CLAUDE.md.

## IDENTITY

**User:** {YOUR_NAME} | LTC Partners, {YOUR_DEPT} | {YOUR_ROLE}
**Profile:** {YOUR_LEARNING_STYLE} learner. {YOUR_COMMUNICATION_STYLE} communication style.
**WMS:** ClickUp is authoritative for task tracking, planning, and status.
**Agent level:** {L1-L5}. See _genesis/reference/ltc-ai-agent-system-project-template-guide.md for level definitions.

## COMMUNICATION

- {YOUR_PREFERENCES — examples below, pick what fits}
- Terse responses — no trailing summaries
- When challenged, revise the artifact directly — don't argue
- Use ASCII diagrams and structured tables over prose explanations
- Respond in Vietnamese when I write in Vietnamese

## NAMING (LTC Universal Naming Grammar)

All LTC items follow UNG: `{SCOPE}_{FA}.{ID}.{NAME}`
**Separators:** `_` = scope boundary, `.` = numeric level, `-` = word join within NAME
**CRITICAL:** SCOPE codes are IRREGULAR — NEVER derive algorithmically. Always look up.
**Memorized codes:** `OPS`, `INVTECH` (not INV_TECH), `INV`, `COE_EFF`, `LTC` (= [LTC ALL])

## MODEL ROUTING

| Task type | Model | Examples |
|-----------|-------|---------|
| Explore / search / lookup | Haiku | Glob, Grep, file discovery, quick checks |
| Build / test / iterate | Sonnet | Code writing, skill execution, sub-agent work |
| Architecture / design / synthesis | Opus | DSBV Design, force analysis, review, orchestration |

Default sub-agent model: Sonnet. Escalate to Opus only for design/synthesis tasks.

## SECURITY

- NEVER hardcode secrets in source, prompts, or tool arguments — use `.env` / `secrets/` via env vars
- Before completing any task, scan output for secret patterns. If found: stop, redact, alert
- HIGH risk actions (delete, push, force ops): ALWAYS require explicit user confirmation

## MEMORY SYSTEM

Project memory lives in `~/.claude/projects/{project-dir}/memory/`. Uses tiered design:
- **MEMORY.md** = concise index only (under 60 lines). Never write content directly here.
- **Topic files** = detail files with frontmatter (name, description, type). Types: user, project, reference, feedback.
- **Derivable info** (repo paths, file structure, git history, tool versions) must NEVER be stored in memory.
- **ClickUp** is the authoritative WMS — memory supplements, never replaces.

## META-RULE

If a project CLAUDE.md contradicts this file, the **project file wins**. Flag the contradiction to the User only if the intent is ambiguous.

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[SKILL]]
- [[dsbv]]
- [[ltc-ai-agent-system-project-template-guide]]
- [[project]]
- [[security]]
- [[task]]
