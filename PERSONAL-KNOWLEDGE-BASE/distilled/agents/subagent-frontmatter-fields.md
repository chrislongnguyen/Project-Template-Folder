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

# Subagent Frontmatter Fields

The YAML frontmatter block is the complete configuration surface for a subagent. Getting it right determines everything: which tasks the agent handles, what it can touch, how much it costs, and whether it accumulates knowledge.

## L1 — Knowledge

### So What? (Relevance)

Only `name` and `description` are required. Everything else is optional — but each optional field unlocks a distinct capability class. Knowing which fields exist and what they do prevents re-inventing behavior that's already built in.

### What Is It?

A subagent file has the form:

```markdown
---
<YAML frontmatter>
---

<System prompt in markdown>
```

The body becomes the agent's system prompt. The frontmatter is configuration. The agent receives only this system prompt plus basic environment info (working directory, etc.) — not the full Claude Code system prompt.

### What Else? — Full Field Reference

| Field | Required | Default | Purpose |
|---|---|---|---|
| `name` | Yes | — | Unique ID: lowercase letters and hyphens |
| `description` | Yes | — | When Claude should delegate here (routing rule) |
| `tools` | No | Inherits all | Allowlist of tools the agent can call |
| `disallowedTools` | No | None | Denylist, removed from inherited or specified set |
| `model` | No | `inherit` | `sonnet`, `opus`, `haiku`, full model ID, or `inherit` |
| `permissionMode` | No | Inherits | `default`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | No | Unlimited | Hard stop on agentic turn count |
| `skills` | No | None | Skills to inject into context at startup |
| `mcpServers` | No | Inherits parent | MCP servers: inline definitions or string references |
| `hooks` | No | None | Lifecycle hooks scoped to this agent |
| `memory` | No | None | Persistent directory: `user`, `project`, or `local` |
| `background` | No | `false` | Always run as background task |
| `effort` | No | Inherits session | `low`, `medium`, `high`, `max` (Opus 4.6 only) |
| `isolation` | No | None | `worktree` — runs in a temporary git worktree |
| `color` | No | None | UI display color: `red`, `blue`, `green`, `yellow`, `purple`, `orange`, `pink`, `cyan` |
| `initialPrompt` | No | None | Auto-submitted as first user turn when agent runs as main session agent via `--agent` |

**Tool resolution when both `tools` and `disallowedTools` are set:** `disallowedTools` is applied first (removes from the pool), then `tools` is resolved against the remaining pool. A tool in both lists is removed.

**`isolation: worktree`:** Gives the agent an isolated copy of the repo in a temporary git worktree. Worktree is auto-cleaned up if the agent makes no changes. Useful for risky or exploratory operations that shouldn't touch the working tree.

**`initialPrompt`:** Only active when the agent runs as the main session thread via `claude --agent <name>` or the `agent` setting. Commands and skills in the prompt are processed. It is prepended to any user-provided prompt.

### How Does It Work?

Claude Code reads all `.claude/agents/` and `~/.claude/agents/` files at session start (plus managed and plugin sources). When Claude invokes a subagent:

1. The subagent definition is looked up by `name`.
2. Frontmatter fields are applied: model resolved, tools filtered, permission mode set.
3. If `skills` are specified, their full content is injected into the system prompt.
4. If `memory` is set, the system prompt is augmented with memory directory instructions + first 200 lines / 25KB of `MEMORY.md`.
5. If `mcpServers` includes inline definitions, those connections are opened.
6. The agent runs until complete or `maxTurns` is hit.
7. Inline MCP connections are closed; results return to the main conversation.

**CLI-defined agents** (via `--agents` JSON flag) use the same field names but `prompt` instead of the markdown body for the system prompt. They exist for the session only.

## L2 — Understanding

### Why Does It Work?

The frontmatter-as-config model separates concerns cleanly:
- The system prompt (body) handles "what to do" — domain knowledge, workflow steps, output format
- The frontmatter handles "what it can touch and how much it costs" — tool access, model, permissions

This means you can tune cost (model field), safety (tools + permissionMode), and persistence (memory) independently from the agent's behavioral instructions.

The `description` field is the delegation routing key. Claude uses it to decide whether to delegate at all — so it functions as a classifier label, not just documentation. Vague descriptions produce unreliable delegation.

### Why Not?

- `bypassPermissions` in `permissionMode` is dangerous: the agent can execute without any approval prompts. Writes to `.git`, `.claude`, `.vscode`, `.idea`, `.husky` still prompt (except `.claude/commands`, `.claude/agents`, `.claude/skills`).
- Plugin subagents do not support `hooks`, `mcpServers`, or `permissionMode` — those fields are silently ignored when loaded from a plugin. Copy the file to `.claude/agents/` if you need them.
- `maxTurns` with no value = unlimited turns. For automated or background agents, always set a bound to prevent runaway token spend.
- `skills` content is injected at startup — it consumes context tokens immediately, even if the skill content is never used. Only preload skills the agent will definitely need.

## L3 — Application

### So What Benefit?

The `isolation: worktree` field is the safest way to let an agent experiment with risky refactors. The `color` field makes multi-agent transcript reading tractable. The `maxTurns` field is the primary cost guardrail for background agents.

### Now What? (Next Actions)

1. For every `.claude/agents/` file: verify `name` uses lowercase-hyphen format, `description` is action-oriented
2. Set `maxTurns` on any agent that runs unattended or in background mode
3. Read: [[subagent-tool-restrictions]] for `tools` vs `disallowedTools` deep-dive
4. Read: [[subagent-persistent-memory]] for `memory` scope guidance

## Sources

- `captured/claude-code-docs-full.md` lines 28189–28210
- Source URL: https://code.claude.com/docs/en/sub-agents#supported-frontmatter-fields

## Links

- [[custom-subagents-overview]]
- [[subagent-tool-restrictions]]
- [[subagent-model-selection]]
- [[subagent-permission-modes]]
- [[subagent-persistent-memory]]
- [[subagent-skills-preloading]]
- [[subagent-mcp-scoping]]
- [[subagent-hooks]]
