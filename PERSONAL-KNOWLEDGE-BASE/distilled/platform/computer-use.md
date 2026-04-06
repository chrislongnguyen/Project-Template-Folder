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
  - what_is_it_not
  - how_does_it_not_work
  - what_if
---

# Computer Use — Claude Controls Your Screen

Computer use lets Claude open applications, click, type, scroll, and take screenshots on your machine. From the CLI, Claude can write code, compile it, launch the resulting app, interact with its UI, and report findings — all in the same conversation.

## L1 — What / What else / How / Relevance

### What it is

A built-in MCP server called `computer-use` that gives Claude access to:
- macOS Accessibility API (click, type, scroll)
- Screen Recording (screenshot capture)

Claude uses these to interact with GUI applications that have no CLI or API surface.

### What else it covers

- Equivalent capability exists in the Desktop app (adds Windows support + configurable denied-apps list)
- Session locking: only one Claude Code session can control the machine at a time
- Per-session per-app approval: access is not blanket — each app is approved individually
- Safety guardrails: sentinel warnings, terminal excluded from screenshots, global Esc escape

### How it works

**Tool selection hierarchy** — Claude tries the most precise tool first:

```
MCP server for the service
  → Bash (shell commands)
    → Claude in Chrome (browser tasks)
      → computer-use (everything else)
```

Screen control is the fallback for native apps, simulators, and tools with no API.

**Enable flow:**

1. Run `/mcp` in an interactive session
2. Select `computer-use` → Enable (persists per project)
3. On first use, macOS prompts for Accessibility + Screen Recording permissions. Grant both. Restart Claude Code if required after Screen Recording grant.

**Per-session app approval** — each app Claude needs shows a terminal prompt listing:
- Which apps will be controlled
- Extra permissions (e.g., clipboard)
- How many other apps will be hidden

Choose Allow or Deny. Approval lasts the current session only.

**App control tiers:**

| Warning | Applies to |
| :--- | :--- |
| Equivalent to shell access | Terminal, iTerm, VS Code, Warp, other IDEs |
| Can read or write any file | Finder |
| Can change system settings | System Settings |

Browsers and trading platforms are view-only. Terminals and IDEs are click-only. All other apps get full control.

**During a session:**
- A machine-wide lock is acquired. Other Claude sessions fail if they try to use computer use.
- Visible apps (except terminal) are hidden. Claude only sees approved app windows. Terminal is excluded from screenshots so Claude never reads its own output.
- When the turn ends, hidden apps are restored.
- A macOS notification appears: "Claude is using your computer · press Esc to stop." Esc aborts immediately from anywhere.

### So what — relevance to LTC

Useful for validating native macOS tooling, testing Obsidian vault UI behavior, or operating design tools that have no API. For LTC specifically: if a validation step requires visual confirmation (e.g., an Obsidian Base renders correctly), computer use can screenshot and verify without manual review.

## L2 — Why it works / Why not

### Why it works

- macOS Accessibility + Screen Recording APIs provide programmatic control that mirrors what a human does with a mouse and keyboard.
- The terminal exclusion from screenshots prevents a feedback loop where Claude reads its own streaming output and acts on it.
- The machine-wide lock prevents concurrent sessions from creating conflicting UI state.
- The Esc key interception is at the OS level — prompt injection in on-screen content cannot trigger or block it.

### Why not (limits)

- CLI computer use is macOS only. Windows is supported via the Desktop app only.
- Requires Pro or Max plan. Not available on Team or Enterprise plans.
- Requires Claude Code v2.1.85+. Requires interactive session — `-p` flag (non-interactive) blocks it.
- Not available with third-party providers (Bedrock, Vertex, Foundry) — needs a claude.ai account.
- Slower than MCP, Bash, or browser automation. Use only when no structured alternative exists.
- No denied-apps list in the CLI (available in Desktop app only).
- Computer use runs on your actual desktop, not in a sandbox. Trust boundary is explicitly wider than the Bash sandboxed tool.

## L3 — Safety / Benefit / Next / What-if

### So what — concrete benefits

- **Build and validate native apps in one pass**: write Swift, compile, launch, click through controls, screenshot errors — without leaving the terminal conversation.
- **End-to-end UI testing without a test harness**: no Playwright config, no XCTest boilerplate. Point Claude at the app and describe the flow.
- **Reproduce visual bugs**: resize windows, trigger layout bugs, screenshot the broken state, patch CSS, verify fix — in sequence.
- **Drive GUI-only tools**: hardware panels, iOS Simulator, proprietary dashboards that have no API.

### Now what — next steps

- Enable via `/mcp` → `computer-use` → Enable (once per project)
- Grant Accessibility + Screen Recording in System Settings
- Start with a narrowly scoped task (e.g., "launch the app and screenshot the main window") before trying multi-step flows
- For complex workflows, prefer MCP or Bash when available — use computer use only for the GUI-only remainder

### What if — edge cases

- **"Computer use is in use by another Claude session"** — find and exit the other session. If it crashed, the lock releases automatically when Claude detects the dead process.
- **Screen Recording permission keeps reappearing** — quit Claude Code completely and start a new session. If persistent: System Settings > Privacy & Security > Screen Recording, confirm terminal app is listed and enabled.
- **`computer-use` not in `/mcp`** — check: macOS platform, v2.1.85+, Pro/Max plan (`/status`), authenticated via claude.ai (not Bedrock/Vertex/Foundry), interactive session (not `-p`).
- **Prompt injection risk** — on-screen content can contain text instructing Claude to take actions. The trust boundary is wider than sandboxed Bash. Review the [computer use safety guide](https://support.claude.com/en/articles/14128542) before use on untrusted content.

## Sources

- Source lines 8099–8301: `captured/claude-code-docs-full.md`
- Docs: https://code.claude.com/docs/en/computer-use
- Safety guide: https://support.claude.com/en/articles/14128542

## Links

- [[claude-code-extensibility-taxonomy]]
- [[permissions]]
- [[unix-utility-and-notifications]]
