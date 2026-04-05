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
---

# Claude Code Fullscreen Rendering

Fullscreen rendering is an opt-in rendering mode for the Claude Code CLI (v2.1.89+) that eliminates flicker, keeps memory flat in long sessions, and adds mouse support. Enabled via `CLAUDE_CODE_NO_FLICKER=1`.

## L1 — Knowledge

### So What? (Relevance)

The default Claude Code rendering path streams output to the terminal's scrollback buffer. In certain terminals (VS Code integrated terminal, tmux, iTerm2), this causes visible flicker, scroll position jumps, and memory growth proportional to conversation length. Fullscreen rendering removes these problems for users who work in long sessions or who use those specific terminal environments.

### What Is It?

Fullscreen rendering is an alternative drawing path that takes over the terminal's alternate screen buffer (like `vim` or `htop`). It renders only the currently visible messages — not the full conversation — which keeps memory constant regardless of session length.

Key behaviors:
- Input box stays fixed at the bottom of the screen while Claude is working
- Only visible messages are kept in the render tree (constant memory)
- Mouse events are captured inside Claude Code (click, scroll, select, URL open)
- Lives in the alternate screen buffer, not the terminal's native scrollback

**Enable:** `CLAUDE_CODE_NO_FLICKER=1 claude`
**Persist:** Add `export CLAUDE_CODE_NO_FLICKER=1` to `~/.zshrc` or `~/.bashrc`

### What Else?

**Mouse capabilities when enabled:**
- Click in prompt input to position cursor
- Click a collapsed tool result to expand/collapse it
- Click a URL or file path to open it
- Click-and-drag to select text (auto-copies to clipboard on release)
- Scroll with mouse wheel

**Scroll shortcuts:**

| Shortcut | Action |
|----------|--------|
| `PgUp` / `PgDn` | Scroll half a screen |
| `Ctrl+Home` | Jump to start |
| `Ctrl+End` | Jump to latest + resume auto-follow |
| Mouse wheel | Scroll a few lines |

MacBook keyboards: `Fn+↑/↓` = `PgUp/PgDn`, `Ctrl+Fn+→` = jump to bottom.

**Transcript mode (`Ctrl+o`):** Enters `less`-style navigation with `/` search, `n/N` next/previous match, vim-style scroll keys. Press `[` to write the full conversation to native terminal scrollback (making `Cmd+f` and tmux copy mode work). Press `v` to open in `$EDITOR`.

**Opt-out of mouse while keeping rendering:** `CLAUDE_CODE_DISABLE_MOUSE=1` — preserves flicker-free rendering and flat memory; disables click-to-expand, URL clicking, wheel scroll, and cursor positioning.

**Scroll speed:** `CLAUDE_CODE_SCROLL_SPEED=3` multiplies base scroll distance (range 1–20). Useful in VS Code integrated terminal, which sends exactly one scroll event per notch.

### How Does It Work?

The alternate screen buffer is a standard ANSI terminal feature. Applications like `vim` and `htop` use it to draw a full-screen UI without disturbing the terminal's scrollback history. When the application exits, the terminal restores the previous view.

Claude Code draws into this buffer and maintains a viewport of only the currently visible messages. Instead of appending new content to an ever-growing scrollback, it re-renders the visible slice on each update. This is why memory stays flat — the render tree does not grow with conversation length.

Mouse events are captured via terminal mouse-reporting protocol. The application receives coordinates and button states instead of the terminal handling them natively. This is why native terminal copy-on-select stops working — the terminal no longer sees mouse events.

**tmux compatibility:** Works in regular tmux. Requires `set -g mouse on` in `~/.tmux.conf` for wheel scrolling. Incompatible with `tmux -CC` (iTerm2 integration mode) — that mode renders panes natively and breaks alternate screen buffer + mouse tracking.

## L2 — Understanding

### Why Does It Work?

Terminal emulators that buffer and redraw large amounts of text (VS Code's xterm.js, tmux, iTerm2) show flicker because the CLI is writing a stream of characters and the terminal is rendering each update. By drawing only the visible slice into the alternate buffer, Claude Code sends significantly less data to the terminal per update — reducing both flicker and the time the terminal spends rendering.

Memory stays flat because the render tree is a fixed-size viewport, not an accumulating list. The conversation exists as data; only what is visible is rendered.

### Why Not?

**Alternate screen buffer trade-offs:**
- `Cmd+f` and tmux copy mode do not see the conversation (it is not in the native scrollback). Must use transcript mode (`Ctrl+o`) to hand content back to the terminal.
- Mouse capture breaks native terminal selection. SSH and tmux environments may not propagate OSC 52 clipboard writes reliably — copy operations can silently fail.
- Incompatible with `tmux -CC` integration mode.

**Research preview status:** Tested on common terminals but may have rendering issues on less common configurations. Report via `/feedback` or the claude-code GitHub repo.

**Not for all terminals:** Terminals that already handle streaming output well may see no benefit. The feature description is most specific to VS Code integrated terminal, tmux, and iTerm2.

## Sources

- Claude Code docs — "Fullscreen rendering": `captured/claude-code-docs-full.md` lines 10668–10810
- Direct URL: https://code.claude.com/docs/en/fullscreen

## Links

[[claude-code-extensibility-taxonomy]]
[[claude-code-context-costs]]
