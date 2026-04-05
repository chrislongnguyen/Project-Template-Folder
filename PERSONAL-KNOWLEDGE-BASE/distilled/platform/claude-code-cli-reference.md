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

# Claude Code: CLI Reference

The `claude` command-line interface exposes every session behavior through launch commands and flags. Most users only know `claude` and `claude -p`; the full flag set covers session management, output formatting, permission control, system prompt manipulation, and automation pipelines.

## L1 — Knowledge

### So What? (Relevance)

CLI flags are the fastest way to change Claude Code behavior for a single session without touching config files. They are also the automation surface for CI pipelines, scripts, and agent orchestration. Knowing what exists prevents building workarounds for capabilities that already ship.

### What Is It?

**Launch commands** — top-level verbs that start a specific operation:

| Command | Description | Example |
|---|---|---|
| `claude` | Start interactive session | `claude` |
| `claude "query"` | Start interactive session with initial prompt | `claude "explain this project"` |
| `claude -p "query"` | Query via SDK, then exit (print mode) | `claude -p "explain this function"` |
| `cat file \| claude -p "query"` | Process piped content | `cat logs.txt \| claude -p "explain"` |
| `claude -c` | Continue most recent conversation in current directory | `claude -c` |
| `claude -c -p "query"` | Continue via SDK | `claude -c -p "Check for type errors"` |
| `claude -r "<session>" "query"` | Resume session by ID or name | `claude -r "auth-refactor" "Finish this PR"` |
| `claude update` | Update to latest version | `claude update` |
| `claude auth login` | Sign in (flags: `--email`, `--sso`, `--console` for API billing) | `claude auth login --console` |
| `claude auth logout` | Log out | `claude auth logout` |
| `claude auth status` | Show auth status as JSON (`--text` for human-readable) | `claude auth status` |
| `claude agents` | List all configured subagents, grouped by source | `claude agents` |
| `claude auto-mode defaults` | Print built-in auto mode classifier rules as JSON | `claude auto-mode defaults > rules.json` |
| `claude mcp` | Configure MCP servers | — |
| `claude plugin` | Manage plugins (alias: `claude plugins`) | `claude plugin install code-review@claude-plugins-official` |
| `claude remote-control` | Start a Remote Control server (server mode, no local session) | `claude remote-control --name "My Project"` |

### What Else?

**Key flag categories** (selected high-value flags):

| Flag | Category | What it does |
|---|---|---|
| `--print`, `-p` | Mode | Non-interactive; print response and exit |
| `--continue`, `-c` | Session | Load most recent conversation in current dir |
| `--resume`, `-r` | Session | Resume session by ID or name; opens picker if no arg |
| `--name`, `-n` | Session | Set display name; resumable via `claude -r <name>` |
| `--worktree`, `-w` | Session | Start in isolated git worktree |
| `--model` | Model | Set model by alias (`sonnet`, `opus`) or full name |
| `--effort` | Model | Set effort level: `low`, `medium`, `high`, `max` |
| `--permission-mode` | Permissions | Start in named mode: `default`, `acceptEdits`, `plan`, `auto`, `bypassPermissions` |
| `--allowedTools` | Permissions | Tools that execute without prompting |
| `--disallowedTools` | Permissions | Tools removed from model context entirely |
| `--tools` | Permissions | Restrict which built-in tools are available |
| `--add-dir` | Context | Add working directories for file access |
| `--bare` | Performance | Skip auto-discovery of hooks, skills, MCP, memory (faster for scripts) |
| `--output-format` | Output | `text`, `json`, `stream-json` |
| `--max-turns` | Automation | Limit agentic turns (print mode only) |
| `--max-budget-usd` | Automation | Spend cap in dollars (print mode only) |
| `--json-schema` | Automation | Get validated JSON output matching a schema |
| `--fallback-model` | Automation | Fallback model when default is overloaded (print mode only) |
| `--mcp-config` | MCP | Load MCP servers from JSON file or string |
| `--strict-mcp-config` | MCP | Use only `--mcp-config` servers; ignore all other MCP config |
| `--debug` | Debugging | Enable debug mode with optional category filter |
| `--debug-file <path>` | Debugging | Write debug logs to file |
| `--verbose` | Debugging | Show full turn-by-turn output |
| `--from-pr` | GitHub | Resume sessions linked to a GitHub PR number or URL |

**Note:** `claude --help` does not list every flag. A flag's absence from `--help` does not mean it is unavailable.

### How Does It Work?

Flags apply to the current session only and do not persist to `settings.json`. They sit at the top of the settings override hierarchy: CLI flags beat everything except `managed-settings.json`.

The `--bare` flag disables auto-discovery of hooks, skills, plugins, MCP servers, auto memory, and CLAUDE.md. It also sets `CLAUDE_CODE_SIMPLE` in the environment. Use it for scripted calls where startup speed matters and config loading is not needed.

Print mode (`-p`) is the automation interface. It accepts piped input, returns output to stdout, and can be combined with `--output-format stream-json` for structured streaming. Key print-mode-only flags: `--max-turns`, `--max-budget-usd`, `--fallback-model`, `--no-session-persistence`, `--json-schema`.

Session continuity: `-c` loads the most recent conversation in the current directory. `-r <name>` resumes by name or ID across directories. `--fork-session` with `--resume` or `--continue` creates a new session ID rather than reusing the original.

## L2 — Understanding

### Why Does It Work?

The separation of launch commands (verbs) and flags (modifiers) mirrors Unix conventions: verbs define the operation, flags tune behavior within that operation. This makes the CLI composable — `claude -c -p "query"` combines session continuity with non-interactive output without any new syntax.

Print mode (`-p`) exists specifically to decouple Claude Code from the terminal UI, making it a first-class automation primitive. The output format flags (`--output-format json`, `stream-json`) extend this to machine-readable pipelines.

The `--bare` flag exists because startup latency matters in CI and scripted loops. Skipping MCP discovery and memory loading can shave seconds off each invocation when those features add no value.

### Why Not?

- **`--dangerously-skip-permissions`** bypasses all permission checks. Appropriate in fully-automated CI where the environment is sandboxed; dangerous anywhere a human could inject unexpected input.
- **`--bare` in interactive sessions** strips the config that makes Claude useful on your project. It is designed for scripts, not daily use.
- **`--system-prompt` replaces the entire default prompt**, removing Claude Code's built-in capabilities. Use `--append-system-prompt` in almost all cases; reserve replacement for complete control scenarios.
- **`--max-turns` without a budget cap** can still exhaust your API budget if each turn is expensive. Pair with `--max-budget-usd` in cost-sensitive automation.
- **`--fallback-model` only works in print mode.** Interactive sessions do not auto-fallback.

## L3 — Mastery

### So What? (Benefit)

The full CLI flag set is what separates using Claude Code as a chat tool from using it as an automation primitive. With `--output-format stream-json`, `--max-turns`, `--json-schema`, and `--permission-mode bypassPermissions`, Claude Code becomes a programmable reasoning engine inside CI pipelines, Git hooks, and multi-agent orchestration systems.

### Now What? (Next Steps)

**Common patterns:**

```bash
# One-shot with cost cap (CI-safe)
claude -p --max-budget-usd 2.00 --max-turns 10 "review this diff"

# Structured output for downstream processing
claude -p --output-format json --json-schema '{"type":"object","properties":{...}}' "analyze"

# Fast scripted call, skip all config loading
claude --bare -p "summarize this file"

# Start in plan mode, with option to escalate to bypass
claude --permission-mode plan --allow-dangerously-skip-permissions

# Resume named session and continue work
claude -r "auth-refactor" "Finish the token refresh logic"

# Multi-dir access (file access only, not config discovery)
claude --add-dir ../shared-lib ../infra
```

**System prompt flag decision tree:**

```
Need to add rules without removing built-ins?  → --append-system-prompt
Need to load rules from a file?                → --append-system-prompt-file
Need complete control over system prompt?      → --system-prompt or --system-prompt-file
Can combine append + replace?                  → Yes: --system-prompt + --append-system-prompt
Can use two replace flags at once?             → No: --system-prompt and --system-prompt-file are mutually exclusive
```

**System prompt flags summary:**

| Flag | Behavior |
|---|---|
| `--system-prompt` | Replaces entire default prompt |
| `--system-prompt-file` | Replaces with file contents |
| `--append-system-prompt` | Appends to the default prompt |
| `--append-system-prompt-file` | Appends file contents to the default prompt |

For most use cases, use an append flag. Appending preserves Claude Code's built-in capabilities while adding your requirements.

## Sources

- https://code.claude.com/docs/en/cli-reference

## Links

- [[claude-code-dot-claude-directory]] — settings files that CLI flags override
- [[platform/claude-code-extensibility-taxonomy]] — hooks, skills, and agents configured in .claude/
- [[workflows/automation-and-scaling]] — non-interactive / headless usage patterns
- [[permissions/claude-code-permissions]] — permission modes and tool allow/deny rules
