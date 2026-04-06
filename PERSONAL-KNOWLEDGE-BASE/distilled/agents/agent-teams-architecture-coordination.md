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
---

# Agent Teams — Architecture & Coordination

The internal mechanics of agent teams: how the task list, mailbox, context isolation, permissions, and token usage work under the hood.

## L1

### So What? (Relevance)

Understanding the architecture prevents misuse: hand-editing the team config corrupts state, broadcasting too freely multiplies token cost, and misreading the permissions model leads to unexpected teammate behavior. This knowledge guides correct team design.

### What Is It?

**Four components:**

| Component  | Role |
|------------|------|
| Team lead  | Main session — creates team, spawns teammates, coordinates, synthesizes |
| Teammates  | Independent Claude Code instances — each owns a context window |
| Task list  | Shared work items with states: pending, in progress, completed |
| Mailbox    | Async messaging — `message` (one-to-one) or `broadcast` (all teammates) |

**Storage (auto-generated, do not hand-edit):**
- `~/.claude/teams/{team-name}/config.json` — runtime state (session IDs, tmux pane IDs, members array)
- `~/.claude/tasks/{team-name}/` — task list files

The `members` array in config lets any teammate discover peers by name and agent ID.

### What Else?

- **Subagent definitions as teammate roles**: reference any subagent type (project, user, plugin, CLI-defined) when spawning a teammate. The definition's `tools` allowlist and `model` are honored; the body appends to the system prompt rather than replacing it. Team coordination tools (`SendMessage`, task tools) are always available regardless of `tools` restriction. Note: `skills` and `mcpServers` frontmatter fields in a subagent definition are NOT applied when running as a teammate — teammates load these from project and user settings.
- **Plan approval mode**: spawn a teammate with "require plan approval" to keep it in read-only mode until the lead reviews and approves its approach. Rejected plans loop back for revision.

### How Does It Work?

**Task claiming:**
- Lead assigns tasks explicitly, or teammates self-claim after finishing their current task
- File locking prevents race conditions when multiple teammates attempt to claim the same task simultaneously
- Tasks with unresolved dependencies cannot be claimed; they unblock automatically when dependencies complete

**Communication flow:**
- Teammate messages are delivered automatically to recipients — the lead does not poll
- When a teammate goes idle it auto-notifies the lead
- `broadcast` reaches all teammates simultaneously; use sparingly as cost scales with team size

**Context at spawn:**
- Teammates load project context (CLAUDE.md, MCP servers, skills) the same as a regular session
- The lead's conversation history does NOT carry over
- Spawn prompt is the mechanism for passing task-specific context to a teammate

**Permissions:**
- All teammates inherit the lead's permission mode at spawn time
- Per-teammate mode can be changed after spawning, not at spawn time
- If the lead runs `--dangerously-skip-permissions`, all teammates do too

## L2

### Why Does It Work?

Context isolation is the core design choice. Each teammate's independent context window means it explores a problem space without being anchored by what the lead or other teammates have already concluded. The shared task list is the only coordination primitive — teammates are otherwise fully decoupled. File locking on task claims makes the system safe for concurrent access without a central scheduler.

### Why Not?

- **State corruption risk**: the team config is overwritten on every state update — any manual edits are silently lost. Pre-authoring config is not supported.
- **Broadcast amplifies cost**: one broadcast to N teammates = N full message deliveries into N context windows. Overuse on large teams is expensive.
- **No inherited history**: teammates don't know what the lead has already tried. Without a rich spawn prompt, they may duplicate work.
- **Permission model is coarse at spawn**: cannot assign different permission tiers to different teammates when creating the team — only adjustable post-spawn.
- **`skills`/`mcpServers` in subagent definitions ignored**: a subagent definition used as a teammate role will not apply its own skills or MCP servers — easy to miss and causes silent capability reduction.

## Sources

- `captured/claude-code-docs-full.md` lines 194–272 (Architecture + Context and communication sections)

## Links

- [[agent-teams-overview]] — when to use, enable, start, and shut down teams
- [[agent-teams-display-modes]] — in-process vs split-pane configuration
- [[agent-teams-best-practices]] — team size, task sizing, quality gates
- [[custom-subagents-overview]] — subagent definitions used as teammate roles
- [[subagent-permission-modes]] — permission modes that propagate to teammates
