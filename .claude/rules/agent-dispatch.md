---
version: "1.0"
status: draft
last_updated: 2026-03-31
owner: ""
description: "Agent dispatch enforcement — every Agent() call must name a MECE agent, use context packaging, set the correct model, and use absolute paths in worktrees."
---
# Agent Dispatch — Always-On Rule

Every `Agent()` call MUST satisfy all 4 requirements below. No ad-hoc sub-agent invocations.

## 1. Name a MECE Agent

Use exactly one of the 4 agents. Agent files: `.claude/agents/`

| Agent | Model | Scope |
|-------|-------|-------|
| `ltc-planner` | opus | DSBV Design + Sequence, synthesis, orchestration |
| `ltc-builder` | sonnet | DSBV Build — artifact production, code, docs |
| `ltc-reviewer` | opus | DSBV Validate — review against DESIGN.md criteria |
| `ltc-explorer` | haiku | Pre-DSBV research, discovery, read-only exploration |

## 2. Use Context Packaging

Structure every invocation using the 5-field template: **EO → INPUT → EP → OUTPUT → VERIFY**.

Full template + per-agent examples: `.claude/skills/dsbv/references/context-packaging.md`

## 3. Set Model to Match Agent File

The `model:` in your Agent() call must match the agent's declared model above.
Mismatched models are silent failures — wrong capability tier, wrong cost.

## 4. Absolute Paths in Worktrees

When dispatching from a git worktree, ALL file paths in INPUT must be absolute.
Relative paths resolve to the main repo, not the worktree — writes land in the wrong location silently.

**Skill:** `/dsbv` — builds context-packaged Agent() calls for each DSBV stage.

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[context-packaging]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
