---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: platform
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

# Claude Code: The .claude Directory

Claude Code reads all of its persistent configuration — instructions, permissions, hooks, skills, agents, and memory — from two directory trees: `.claude/` inside your project repo, and `~/.claude/` in your home folder. Understanding this structure is the prerequisite for any customization beyond editing `CLAUDE.md`.

## L1 — Knowledge

### So What? (Relevance)

If you do not know what lives in `.claude/`, you will either search for settings that do not exist, or add config in the wrong place and wonder why it has no effect. This directory is the single source of truth for every behavior you can control in Claude Code. Every skill, hook, agent, permission rule, and memory file flows through here.

### What Is It?

The `.claude/` directory (project-scoped) and `~/.claude/` (user-scoped) are the configuration roots for Claude Code. Together they hold:

| File / Dir | Scope | Committable | Purpose |
|---|---|---|---|
| `CLAUDE.md` | Project + global | Yes | Instructions loaded every session |
| `rules/*.md` | Project + global | Yes | Topic-scoped instructions, optionally path-gated |
| `settings.json` | Project + global | Yes | Permissions, hooks, env vars, model defaults |
| `settings.local.json` | Project only | No (auto-gitignored) | Personal overrides for the project |
| `.mcp.json` | Project only | Yes | Team-shared MCP servers |
| `.worktreeinclude` | Project only | Yes | Gitignored files to copy into new worktrees |
| `skills/<name>/SKILL.md` | Project + global | Yes | Reusable prompts invoked with `/name` or auto-invoked |
| `commands/*.md` | Project + global | Yes | Single-file prompts; same mechanism as skills |
| `output-styles/*.md` | Project + global | Yes | Custom system-prompt sections |
| `agents/*.md` | Project + global | Yes | Subagent definitions with their own prompt and tools |
| `agent-memory/<name>/` | Project + global | Yes | Persistent memory for subagents |
| `~/.claude.json` | Global only | No | App state, OAuth, UI toggles, personal MCP servers |
| `projects/<project>/memory/` | Global only | No | Auto memory: Claude's notes across sessions |
| `keybindings.json` | Global only | No | Custom keyboard shortcuts |

Two additional files live at project root, not under `.claude/`:

| File | Location | Purpose |
|---|---|---|
| `managed-settings.json` | System-level, OS-specific | Enterprise-enforced settings that cannot be overridden |
| `CLAUDE.local.md` | Project root | Private preferences for this project, loaded alongside CLAUDE.md; add to `.gitignore` |

### What Else?

- **Scope boundary:** Project `.claude/` applies only to that repo. `~/.claude/` applies across all projects. Commit project files to share config with teammates; keep personal preferences in `~/.claude/`.
- **Override hierarchy:** Managed settings (enterprise) > CLI flags > `settings.json` > environment variables (varies per variable). See `settings#settings-precedence` for the full order.
- **Most users only ever touch** `CLAUDE.md` and `settings.json`. The rest of the directory is opt-in.
- **The `rules/` subdirectory** allows path-gating: a rule file in `rules/auth.md` can declare it only applies to files under `src/auth/`. This keeps CLAUDE.md lean.

### How Does It Work?

At session start, Claude Code discovers and loads configuration in this sequence:

1. Reads `managed-settings.json` from the OS-level path (enterprise override).
2. Merges `~/.claude/settings.json` (global user settings).
3. Merges `.claude/settings.json` (project settings) on top.
4. Merges `.claude/settings.local.json` (personal project overrides) on top.
5. Applies CLI flags (`--settings`, `--permission-mode`, etc.) as the final layer.
6. Loads `CLAUDE.md` and all matching `rules/*.md` files into the system prompt context.
7. Discovers and registers `skills/`, `commands/`, `output-styles/`, `agents/` from both scopes.
8. Connects MCP servers from `.mcp.json` and user-level MCP config.
9. Loads auto memory from `~/.claude/projects/<project>/memory/`.

Config from `--add-dir` directories grants file access but does NOT trigger `.claude/` discovery from those paths — only the primary working directory is scanned for configuration.

## L2 — Understanding

### Why Does It Work?

The two-tier design (project + global) mirrors how developers naturally separate concerns: project config belongs with the codebase and should be shared, personal config belongs to the individual and should be portable. Making the project layer committable means teams get consistent behavior without out-of-band setup docs. Making the global layer separate means personal preferences (API keys, personal MCP servers, UI toggles) are never accidentally committed.

The layered merge order (managed > global > project > local > CLI) follows a principle of increasing specificity: enterprise policy always wins, but within that constraint, the most-specific setting for the current context applies.

### Why Not?

- **Risk: config drift between teammates.** If `settings.local.json` is used for permissions that should be shared, teammates won't have those rules. Use `settings.json` for anything that should be consistent across the team.
- **Risk: bloated CLAUDE.md.** Loading all project instructions into one file inflates every session's context cost. Use `rules/*.md` with path-gating to scope instructions to relevant files only.
- **Risk: `--add-dir` false sense of security.** Adding a directory grants Claude file access to it, but Claude does NOT discover `.claude/` config from that path. If you expect skills or hooks from an added dir to activate, they will not.
- **Managed settings are silent winners.** Enterprise-deployed `managed-settings.json` overrides everything with no indication in the UI. If a permission rule has no apparent effect, check for managed settings first.

## L3 — Mastery

### So What? (Benefit)

A well-structured `.claude/` directory turns Claude Code from a general-purpose assistant into a domain-specific tool for your project. Path-gated rules mean junior contributors automatically get architecture reminders when editing sensitive files. Committed `agents/*.md` means every teammate gets the same specialist subagents without any setup. Auto memory in `projects/<project>/memory/` means Claude carries context between sessions without consuming prompt tokens.

### Now What? (Next Steps)

**Immediate actions:**

1. Run `/context` to see how much of your token budget is consumed by current config.
2. Run `/memory` to confirm which CLAUDE.md and rules files actually loaded.
3. Run `/hooks` and `/agents` to verify the rest of the config tree is active.
4. Move large instruction blocks from `CLAUDE.md` into topic-scoped `rules/*.md` files to reduce baseline context cost.

**Diagnostic workflow:**

```
Session seems wrong → /memory (check what loaded)
                    → /context (check token cost)
                    → /permissions (check rule conflicts)
                    → /doctor (check install health)
```

**Check-what-loaded commands reference:**

| Command | Shows |
|---|---|
| `/context` | Token usage by category: system prompt, memory, skills, MCP, messages |
| `/memory` | Which CLAUDE.md and rules files loaded, plus auto-memory entries |
| `/agents` | Configured subagents and their settings |
| `/hooks` | Active hook configurations |
| `/mcp` | Connected MCP servers and their status |
| `/skills` | Available skills from project, user, and plugin sources |
| `/permissions` | Current allow and deny rules |
| `/doctor` | Installation and configuration diagnostics |

Start with `/context` for the overview, then drill into the specific command for the area you want to investigate.

## Sources

- https://code.claude.com/docs/en/claude-directory

## Links

- [[claude-code-extensibility-taxonomy]] — the six extension points that live inside .claude/
- [[claude-code-cli-reference]] — CLI flags that override settings.json for a session
- [[configuration/claude-code-settings]] — settings.json structure and precedence
- [[agents/claude-code-subagents]] — agents/*.md file format
- [[hooks/claude-code-hooks]] — hooks configuration in settings.json
