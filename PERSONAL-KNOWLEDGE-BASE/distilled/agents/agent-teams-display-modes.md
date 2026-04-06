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

# Agent Teams — Display Modes

How agent team output is rendered in the terminal: in-process (single pane, keyboard navigation) vs split-pane (tmux or iTerm2, simultaneous visual output).

## L1

### So What? (Relevance)

Display mode affects how you monitor and steer teammates in real time. In-process requires no setup but limits visibility to one teammate at a time. Split-pane lets you watch all teammates simultaneously and click into any session, but requires tmux or iTerm2 and has platform limitations.

### What Is It?

**Two modes:**

| Mode       | How it works | Requirements |
|------------|-------------|--------------|
| In-process | All teammates run inside the main terminal. Use Shift+Down to cycle; type to message. | Any terminal |
| Split-pane | Each teammate gets its own pane visible simultaneously. Click to interact. | tmux or iTerm2 with `it2` CLI |

**Default (`"auto"`):** uses split-pane if already inside a tmux session; otherwise in-process.

### What Else?

- The `"tmux"` setting enables split-pane and auto-detects whether to use tmux or iTerm2 based on terminal
- Split-pane is NOT supported in VS Code integrated terminal, Windows Terminal, or Ghostty
- tmux has known limitations on certain operating systems; macOS is the suggested platform
- iTerm2 split-pane requires: `it2` CLI installed + Python API enabled (iTerm2 → Settings → General → Magic → Enable Python API)

### How Does It Work?

**Set globally in `~/.claude.json`:**
```json
{
  "teammateMode": "in-process"
}
```

**Override for a single session:**
```bash
claude --teammate-mode in-process
```

**In-process keyboard controls:**
- `Shift+Down` — cycle through teammates (wraps back to lead after last teammate)
- Type to send a message to the currently focused teammate
- `Enter` — view a teammate's session
- `Escape` — interrupt the teammate's current turn
- `Ctrl+T` — toggle the shared task list display

**Split-pane setup:**
- tmux: install via system package manager
- iTerm2: install `it2` CLI, then enable Python API in preferences

## L2

### Why Does It Work?

In-process mode runs all Claude sessions in a single process with multiplexed I/O — no external process manager needed. Split-pane delegates window management to tmux (process-based multiplexer) or iTerm2's native split-pane API, which provides true simultaneous rendering without Claude Code managing display state itself.

### Why Not?

- **Split-pane terminal support is narrow**: VS Code, Windows Terminal, and Ghostty are unsupported — a significant constraint for developers who work primarily in those environments
- **tmux on non-macOS**: documented limitations make macOS the reliable platform; Linux/Windows tmux behavior is less predictable
- **No display-mode isolation for specific teammates**: you can't put one teammate in split-pane and another in in-process — it's a global setting
- **In-process visibility is sequential**: you can only observe one teammate at a time; detecting a stuck teammate requires manual cycling

## Sources

- `captured/claude-code-docs-full.md` lines 93–119, 143–148 (Display modes + Talk to teammates sections)

## Links

- [[agent-teams-overview]] — when to use, enable, start, and shut down teams
- [[agent-teams-architecture-coordination]] — task list, mailbox, context model
- [[agent-teams-best-practices]] — monitoring and steering teammates
