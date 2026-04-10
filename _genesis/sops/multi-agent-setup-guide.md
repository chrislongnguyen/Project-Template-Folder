---
version: "1.1"
last_updated: 2026-03-30
owner: ""
audience: "L3 users (familiar with Claude Code, new to multi-agent)"
---

# Multi-Agent Orchestration — Setup Guide

> **Time to complete:** Under 10 minutes.
> **Who this is for:** You know Claude Code and `/dsbv`. You have NOT used agent files, context packaging, or the 4 specialist agents before.
> **What you will have at the end:** A working multi-agent setup verified by checkable commands.

---

## 1. What's New (30-second read)

The template now ships with 4 specialist agents that replace ad-hoc sub-agent dispatching. Three hooks enforce quality automatically. Two old commands are deprecated but aliased so nothing breaks.

| Before | After | Notes |
|---|---|---|
| `/ltc-execution-planner` | `/dsbv build` | Old command redirects automatically |
| `/ltc-writing-plans` | `/dsbv sequence` | Old command redirects automatically |
| Ad-hoc sub-agent prompts | Context packaging v2.0 (5 fields) | Template at `.claude/skills/dsbv/references/context-packaging.md` |
| Single-agent builds | 4 MECE agents | Agent files at `.claude/agents/` |
| Exa MCP preferred | Exa + WebSearch as peers | Speed vs quality trade-off — both are valid, no default |

---

## 2. The 4 Agents (1-minute read)

Each agent has a single job. The DSBV stage determines which agent you (or a skill) should use.

| Agent | Model | When to Use | CLI Flag |
|---|---|---|---|
| `ltc-explorer` | Haiku | Before designing — research, codebase scan, prior art | `claude --agent ltc-explorer` |
| `ltc-planner` | Opus | Design + Sequence stages — architecture, trade-offs | `claude --agent ltc-planner` |
| `ltc-builder` | Sonnet | Build stage — artifact production from approved sequences | `claude --agent ltc-builder` |
| `ltc-reviewer` | Opus | Validate stage — evidence-based review against ACs | `claude --agent ltc-reviewer` |

**Important:** The `--agent` CLI flag is for direct invocation from your terminal. Inside skills (e.g., `/dsbv build`), sub-agents are dispatched automatically using the Agent tool with context packaging — you do not need to pass `--agent` manually. The skill handles routing.

---

## 3. Quick Start (3 minutes)

Complete these steps in order. Each step has a verifiable outcome.

```
Step 1: Verify agent files exist
  $ ls .claude/agents/
  → Expected: ltc-builder.md  ltc-explorer.md  ltc-planner.md  ltc-reviewer.md
  → If empty or missing: pull latest from feat/multi-agent-orchestration branch

Step 2: Verify hooks are registered
  $ cat .claude/settings.json | grep -A2 '"hooks"'
  → Expected: SubagentStop, PreCompact, SessionStart entries all present
  → If missing: see Troubleshooting §6

Step 3: Check DSBV status
  /dsbv status
  → This command is now agent-aware and shows which agent handles the current stage
  → No change to the command — output just includes agent routing info

Step 4: Try a simple build task
  /dsbv build
  → The skill dispatches ltc-builder (Sonnet) for artifact production
  → Context packaging v2.0 wraps the sub-agent call automatically — you will not see it
  → Output: artifact file in .exec/D{n}/

Step 5: Confirm the hooks fired
  → SubagentStop: fires after each sub-agent returns — verifies output meets ACs
  → PreCompact: fires before context compression — saves session state to avoid amnesia
  → SessionStart: fires at session start — loads prior state if a save exists
  → You do not trigger these manually; they are automatic
```

---

## 4. Context Packaging (2 minutes)

Context packaging is the standard format for dispatching sub-agents. Skills use it internally. You need it only when dispatching sub-agents **manually** (outside of skills).

**The 5-field template:**

```
EO:     What done looks like — the desired end state, not the task description
INPUT:  Context the agent needs + files to read + token budget
EP:     Which principles constrain this task (e.g., EP-08 Lean Output, EP-10 Binary ACs)
OUTPUT: Delivery format + acceptance criteria
VERIFY: How the agent self-checks before returning results
```

**Example — dispatching a build sub-agent manually:**

```
EO:     Task file T3.1 written with all sections filled, no placeholders
INPUT:  Context: DSBV Build stage for PLAN workstream.
        Files: SEQUENCE.md (task list), spec.md (acceptance criteria).
        Budget: ~10K tokens.
EP:     EP-08 (Lean Output — signal only, no padding), EP-10 (Binary ACs — pass/fail only)
OUTPUT: Markdown file at .exec/D1/T3.1-Name.md. All template sections filled. No [TBD].
VERIFY: File exists at path. grep -c "\[TBD\]" returns 0. AC section has ≥1 binary criterion.
```

**EP names explained** (you will see these codes in skill output):
- EP-08 Lean Output — produce signal, not volume. No filler sentences.
- EP-10 Binary ACs — every acceptance criterion must be pass/fail checkable, not subjective.
- EP-11 through EP-13 are new in this release — see the EP Registry in §7.

Full template: `.claude/skills/dsbv/references/context-packaging.md`

---

## 5. What Changed in Existing Skills

Changes you will notice when using skills you already know:

- `/dsbv build` — now dispatches `ltc-builder` (Sonnet) for artifact production. Output format unchanged.
- `/dsbv validate` — references `ltc-reviewer` evidence standards. ACs must be binary (pass/fail).
- `/deep-research` and `/learn-research` — use both Exa and WebSearch. Neither is preferred; the skill picks based on speed vs depth trade-off.
- `/ltc-brainstorming` — uses `ltc-explorer` for search, `ltc-planner` for synthesis. Two sub-agents where there was one.
- All skill sub-agent dispatches now use context packaging v2.0 internally. You will see structured EO/INPUT/OUTPUT blocks in verbose output.

---

## 6. Troubleshooting

| Problem | Cause | Fix |
|---|---|---|
| "agent file not found" | `.claude/agents/` missing or not pulled | Run `ls .claude/agents/` — if empty, pull latest from `feat/multi-agent-orchestration` |
| Hook doesn't fire | Event not registered in `settings.json` | Open `.claude/settings.json` — confirm `SubagentStop`, `PreCompact`, `SessionStart` are listed under `"hooks"` |
| Sub-agent ignores scope | Agent file not loaded (SDK limitation for in-skill dispatch) | Agent files are CLI-only. Inside skills, scope is enforced via the EP field in context packaging — not the agent file |
| Exa MCP unavailable | MCP server not configured or unreachable | Falls back to WebSearch automatically. Both are peers — no quality loss, different speed/depth trade-off |
| Old command doesn't work | Skill file missing or alias not wired | `/ltc-execution-planner` → `/dsbv build` and `/ltc-writing-plans` → `/dsbv sequence`. If redirect fails, run the new command directly |

---

## 7. Reference Paths

| What | Path |
|---|---|
| Agent files | `.claude/agents/ltc-{name}.md` |
| Context packaging template | `.claude/skills/dsbv/references/context-packaging.md` |
| Tool routing rules | `rules/tool-routing.md` |
| Multi-agent build pattern | `.claude/skills/dsbv/references/multi-agent-build.md` |
| EP Registry (includes EP-11, EP-12, EP-13) | `_genesis/reference/ltc-effective-agent-principles-registry.md` |
| ADR-002 (architecture decision record for this design) | `1-ALIGN/decisions/ADR-002_multi-agent-architecture.md` |
| H-test results (evaluation evidence) | `5-IMPROVE/metrics/multi-agent-eval/h-test-results.md` |
| Hook scripts | `.claude/hooks/verify-deliverables.sh`, `.claude/hooks/save-context-state.sh`, `.claude/hooks/resume-check.sh` |

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-10]]
- [[EP-12]]
- [[EP-13]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[architecture]]
- [[context-packaging]]
- [[ltc-builder]]
- [[ltc-effective-agent-principles-registry]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[multi-agent-build]]
- [[simple]]
- [[standard]]
- [[task]]
- [[tool-routing]]
- [[workstream]]
