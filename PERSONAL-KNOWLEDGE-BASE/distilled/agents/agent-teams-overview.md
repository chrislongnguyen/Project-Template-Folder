---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: agents
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
  - so_what_benefit
  - now_what_next
---

# Agent Teams — Overview

Agent teams are an experimental Claude Code feature that lets multiple Claude sessions work together in parallel, with inter-agent communication and a shared task list. One session leads; others are teammates.

## L1

### So What? (Relevance)

For tasks requiring parallel exploration — code review from multiple angles, debugging with competing hypotheses, cross-layer changes (frontend + backend + tests) — agent teams can cut wall-clock time and surface blind spots that single-session work misses. They use significantly more tokens, so the tradeoff must be justified.

### What Is It?

An agent team is a coordinated group of Claude Code sessions:

- **Team lead**: the main session that creates the team, spawns teammates, assigns work, and synthesizes results
- **Teammates**: independent Claude Code instances, each with its own context window, working on assigned tasks
- **Shared task list**: the coordination surface — teammates claim and complete tasks from it
- **Mailbox**: messaging system for direct inter-agent communication

Unlike subagents (which only report back to the caller), teammates can message each other directly without going through the lead.

**Prerequisite:** Claude Code v2.1.32+. Feature is disabled by default.

### What Else?

- The lead is fixed for the team's lifetime — no leadership transfer
- One team per session; no nested teams (teammates cannot spawn their own teams)
- Teams are experimental: session resumption, task lag, and shutdown behavior have known limitations
- Reusable teammate roles can be defined using subagent definitions; teammates load skills/MCP from project and user settings, not the subagent's frontmatter

### How Does It Work?

1. Enable by setting `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in `settings.json` or shell
2. Tell Claude to create a team with a task description and desired structure in natural language
3. Claude spawns teammates, creates a shared task list, and begins coordination
4. Teammates self-claim tasks or the lead assigns them; task dependencies are resolved automatically
5. Teammates communicate via `message` (one-to-one) or `broadcast` (all teammates simultaneously)
6. When done: shut down teammates individually, then tell the lead to `clean up the team`

**Enable via settings.json:**
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

**State files (auto-generated, do not hand-edit):**
- Team config: `~/.claude/teams/{team-name}/config.json`
- Task list: `~/.claude/tasks/{team-name}/`

## L2

### Why Does It Work?

Each teammate is a full, independent context window — it does not share the lead's conversation history. This means each can explore a problem space without anchoring on what other teammates have found. The mailbox + shared task list provides coordination without a central bottleneck: teammates unblock themselves by claiming tasks and messaging peers directly. File locking on task claiming prevents race conditions.

### Why Not?

- **Token cost is high**: each teammate consumes its own context window independently; costs scale linearly with team size
- **Coordination overhead grows**: more teammates = more messaging, more potential file conflicts, more supervision required
- **Experimental stability**: session resumption (`/resume`, `/rewind`) does not restore in-process teammates; task status can lag; shutdown can be slow
- **No nested delegation**: teammates cannot spawn sub-teams, limiting depth of parallelism
- **Permissions are coarse**: all teammates start with the lead's permission mode; per-teammate modes cannot be set at spawn time

## L3

### So What? (Benefit)

The structural advantage of agent teams is **adversarial parallelism** — teammates explicitly challenge each other's findings. In debugging scenarios, this fights anchoring bias: a single-agent investigation tends to stop after the first plausible explanation, while competing investigators continue disproving each other until a consensus survives. The debate structure is the mechanism, not just the parallel execution.

### Now What? (Next Steps)

- Start with read-only tasks (PR review, library research, bug investigation) before attempting parallel implementation
- Use 3–5 teammates as the default range; scale up only when work genuinely benefits from simultaneous progress
- Define reusable teammate roles as subagent definitions to avoid re-specifying roles per session
- Set quality gates via `TeammateIdle`, `TaskCreated`, and `TaskCompleted` hooks before running complex teams

## Sources

- `captured/claude-code-docs-full.md` lines 1–427 (source: https://code.claude.com/docs/en/agent-teams)

## Links

- [[agent-teams-architecture-coordination]] — task list, mailbox, context isolation, token model
- [[agent-teams-display-modes]] — in-process vs split-pane, tmux/iTerm2 config
- [[agent-teams-best-practices]] — team size, task sizing, quality gates with hooks
- [[custom-subagents-overview]] — subagent definitions used as teammate roles
- [[subagent-hooks]] — hook types including TeammateIdle, TaskCreated, TaskCompleted
