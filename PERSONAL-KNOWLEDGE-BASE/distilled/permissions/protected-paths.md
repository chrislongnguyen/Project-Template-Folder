---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: permissions
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

# Protected Paths

Protected paths are a hard floor in the Claude Code permission system. Writes to these paths are never auto-approved in any mode — they always prompt, get routed to the classifier, or are denied. No permission rule or mode setting removes this protection.

## L1 — Knowledge

### So What? (Relevance)

Permission modes and rules can be configured to auto-approve almost anything. Protected paths exist to prevent a misconfigured session or a prompt injection attack from corrupting the repository state, editor configuration, or Claude's own configuration files. Without this floor, `bypassPermissions` mode would have zero guardrails against an agent overwriting `.git/config` or `.zshrc`.

### What Is It?

A fixed set of directories and files that receive special write protection regardless of permission mode.

**Protected directories:**
- `.git`
- `.vscode`
- `.idea`
- `.husky`
- `.claude` — with exceptions: `.claude/commands`, `.claude/agents`, `.claude/skills`, and `.claude/worktrees` are NOT protected, because Claude routinely creates content there.

**Protected files:**
- `.gitconfig`, `.gitmodules`
- `.bashrc`, `.bash_profile`, `.zshrc`, `.zprofile`, `.profile`
- `.ripgreprc`
- `.mcp.json`, `.claude.json`

### What Else?

**Per-mode behavior for writes to protected paths:**

| Mode | What happens on protected path write |
|------|--------------------------------------|
| `default` | Prompts for approval |
| `acceptEdits` | Prompts for approval |
| `plan` | Prompts for approval |
| `bypassPermissions` | Prompts for approval |
| `auto` | Routes to classifier (not auto-approved) |
| `dontAsk` | Denied |

`bypassPermissions` — despite its name — still prompts on protected path writes. Protected paths are the one exception to its "skip all checks" behavior.

### How Does It Work?

Protection is hardcoded at the tool layer. When Claude attempts a write tool call, the path is checked against the protected list before any permission mode or rule evaluation. If the path matches, the write is escalated regardless of the session's mode or any `allow` rules.

The `.claude/` directory is partially protected: the root and most subdirectories are protected, but `.claude/commands`, `.claude/agents`, `.claude/skills`, and `.claude/worktrees` are exempt because agents write there as part of normal operation (creating skills, subagents, and commands).

## L2 — Understanding

### Why Does It Work?

The protected path list covers three categories of high-consequence paths:

1. **Repository state** (`.git`, `.gitconfig`, `.gitmodules`) — corruption here can make the repo unrecoverable without a remote clone.
2. **Editor and tool config** (`.vscode`, `.idea`, `.husky`, `.ripgreprc`, `.mcp.json`) — overwriting these can silently change how other tools behave for the developer.
3. **Shell initialization** (`.bashrc`, `.zshrc`, `.profile`, etc.) — a write here persists across all terminal sessions and can execute arbitrary code on next shell start.

Claude's own configuration (`.claude`, `.claude.json`) is protected to prevent an agent from modifying its own instructions, permission rules, or hooks — a form of self-modification that could escalate privileges or disable safeguards.

The `.claude/commands`, `.claude/agents`, `.claude/skills` exemptions reflect a practical reality: creating skills and subagents is a core workflow, and protecting those paths would break the agent's ability to operate.

### Why Not?

**Protected paths cover Claude's built-in tools only.** A Bash command like `echo "alias rm='rm -rf'" >> ~/.zshrc` writes to `.zshrc` via a shell subprocess — a protected path `deny` rule does not stop it. Shell RC files are protected against Claude's `Edit`/`Write` tools, not against Bash commands. For OS-level enforcement, sandboxing is required.

**The `.claude/` exception list is static.** If Anthropic adds new subdirectories to `.claude/` for future features, they start as protected until explicitly added to the exception list. This is safe-by-default but can cause unexpected prompts when new Claude Code features write to new `.claude/` locations.

**`dontAsk` mode denies protected path writes rather than prompting.** If Claude needs to legitimately edit a protected path in a `dontAsk` session (e.g., updating `.gitconfig` as part of a sanctioned workflow), the action will silently fail. Pre-approve the specific path write via an explicit `allow` rule before switching to `dontAsk`.

## Sources

- Source: `captured/claude-code-docs-full.md` lines 20429–20456, 20494–20502
- Upstream URL: https://code.claude.com/docs/en/permission-modes#protected-paths

## Links

- [[permission-modes]]
- [[permission-rules]]
- [[auto-mode-classifier]]
- [[managed-settings]]
