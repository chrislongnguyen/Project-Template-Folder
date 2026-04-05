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

# Claude Code — Chrome Extension Integration (Beta)

Connect Claude Code to a live Chrome browser to test web apps, debug console errors, automate form filling, and extract data — without leaving the terminal.

---

## L1 — What / Relevance

### What is it?

Claude Code's Chrome integration bridges the CLI and a running Chrome (or Edge) browser via the "Claude in Chrome" browser extension. Once connected, Claude can open tabs, navigate pages, click, type, read DOM state, read console logs, and record GIFs — all driven by natural-language prompts from your terminal or VS Code.

It is currently in beta and works on Chrome and Edge only (not Brave, Arc, or other Chromium forks; not WSL).

### So what — relevance

This matters most during active web development. Instead of manually refreshing a browser to verify a code change, you can ask Claude to do it, report what it sees, and immediately loop back into fixing code. It collapses the code→test→observe cycle into one terminal session.

### What else

Seven core capability areas enabled by Chrome integration:

| Capability | What it unlocks |
|---|---|
| Live debugging | Read console errors and DOM state, then fix the code that caused them |
| Design verification | Build UI from Figma mock, open in browser, verify match |
| Web app testing | Form validation, visual regressions, user flow checks |
| Authenticated web apps | Interact with Google Docs, Gmail, Notion — no API connectors needed |
| Data extraction | Pull structured data from pages, save as CSV/JSON |
| Task automation | Repetitive data entry, form filling, multi-site workflows |
| Session recording | Record browser interactions as shareable GIFs |

---

## L2 — Why / Constraints

### Why does it work

Claude opens new tabs rather than hijacking existing ones, and inherits your browser's login session — so authenticated apps are available without OAuth setup. Actions run in a visible Chrome window in real time, making behavior auditable. When Claude hits a login page or CAPTCHA it pauses and asks you to handle it manually.

The connection is mediated by a native messaging host config file Claude Code installs on first use. Chrome reads this on startup, which is why a restart is sometimes needed after first install.

### Why not — limitations and failure modes

| Constraint | Detail |
|---|---|
| Beta, narrow browser support | Chrome and Edge only. Brave, Arc, other Chromium, WSL not supported. |
| Account requirement | Requires direct Anthropic plan (Pro, Max, Team, Enterprise). Not available via Bedrock, Vertex, or Foundry. |
| Version floor | Extension ≥ 1.0.36, Claude Code ≥ 2.0.73. |
| Modal dialogs block | JavaScript `alert`/`confirm`/`prompt` dialogs suspend all browser events — Claude cannot proceed until you dismiss manually. |
| Service worker idle | Extension service worker goes idle during long inactivity, breaking the connection. Fix: run `/chrome` → Reconnect. |
| Context cost | Enabling Chrome by default loads browser tools into every session context, increasing token consumption. Use `--chrome` flag per-session if cost is a concern. |
| Named pipe conflicts (Windows) | EADDRINUSE error if multiple Claude Code sessions share Chrome on Windows. Restart to clear. |

---

## L3 — Deeper / Action

### So what — concrete benefit

The highest-value use case for solo developers: localhost testing without browser switching. Pairs well with TDD — write the test, ask Claude to run it in the browser, read failure output, patch the code, retest, all in one terminal session.

For non-technical workflows: form automation with a local CSV as data source covers repetitive CRM data entry with no API or RPA tool required.

### Now what — next actions

1. Install the Claude in Chrome extension (v1.0.36+) from Chrome Web Store.
2. Update Claude Code to v2.0.73+ (`claude --version` to check).
3. Run `claude --chrome` to test connection on a known page.
4. Run `/chrome` → "Enabled by default" only if you do most work in web app contexts — otherwise keep it per-session to control context cost.
5. For VS Code: Chrome is available automatically when the extension is installed. No flag needed.

---

## Sources

- https://code.claude.com/docs/en/chrome
- Source file: `captured/claude-code-docs-full.md` lines 5610–5839

## Links

- [[claude-code-cli-reference]] — `--chrome` flag and `/chrome` command
- [[computer-use]] — alternative for native macOS app automation
- [[claude-code-channels]] — VS Code Chrome automation
