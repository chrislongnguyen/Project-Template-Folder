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
  - what_is_it_not
  - now_what_next
---

# Claude Code — Remote Control

Remote Control lets you steer a Claude Code session running on your machine from a browser or phone — keeping local tools, filesystem, and MCP servers alive while you work from another device.

## L1

### So What? (so_what_relevance)

If you start a long-running Claude Code task at your desk, you no longer have to stay there. Pick it up from your phone, a laptop on another network, or a browser tab — without restarting the session or losing context. This is the lowest-friction way to keep local development moving while physically away.

### What Is It? (what_is_it)

Remote Control is a feature that bridges a locally-running `claude` process to the `claude.ai/code` web interface and the Claude mobile apps (iOS / Android). The local process polls the Anthropic API over outbound HTTPS; the web/mobile client connects through the same API. No inbound ports open on your machine.

Three start modes:

| Mode | Command | Use case |
|---|---|---|
| Server mode | `claude remote-control` | Dedicated process, multiple concurrent sessions via `--spawn` |
| Interactive | `claude --remote-control` (or `--rc`) | Full local terminal + remote window simultaneously |
| In-session | `/remote-control` (or `/rc`) | Promote an already-running session to remote |

### What Else? (what_else)

Remote Control is one of five "work away from terminal" options:

| Approach | Trigger | Claude runs on |
|---|---|---|
| Dispatch | Message from Claude mobile app | Your machine (Desktop) |
| **Remote Control** | Drive a session from claude.ai/code or mobile | Your machine (CLI/VS Code) |
| Channels | Push events from Telegram/Discord/custom server | Your machine (CLI) |
| Slack | Mention `@Claude` in team channel | Anthropic cloud |
| Scheduled tasks | Set a schedule | CLI, Desktop, or cloud |

Key distinctions from adjacent features:
- **Not Claude Code on the web**: that runs on Anthropic cloud infrastructure; Remote Control always runs on your machine.
- **Not Dispatch**: Dispatch spawns a new Desktop session from a phone message; Remote Control drives an existing CLI session.
- **Not Ultraplan**: starting an ultraplan session disconnects any active Remote Control session (both occupy the `claude.ai/code` interface).

### How Does It Work? (how_does_it_work)

```
Your machine                      Anthropic API             Remote device
─────────────────                 ────────────              ──────────────
claude process                    (TLS relay)               browser / app
  └─ polls outbound HTTPS    ←──→ streams messages    ←──→  claude.ai/code
  └─ local filesystem                                        or Claude app
  └─ MCP servers
  └─ project config
```

1. Start: `claude remote-control` registers a session with the Anthropic API and displays a URL + QR code.
2. Connect: open the URL in a browser, scan the QR code with the mobile app, or find the session by name in the session list (green dot = online).
3. Credentials: multiple short-lived tokens, each scoped to a single purpose, expire independently. No long-lived secrets sent to the remote device.
4. Reconnect: if network drops or laptop sleeps, the session reconnects automatically when the machine comes back online.

Session naming priority: `--name` flag → `/rename` title → last meaningful message → auto-generated `hostname-random-words`.

Spawn modes (server mode only):

| `--spawn` value | Behavior |
|---|---|
| `same-dir` (default) | All concurrent sessions share the current working directory |
| `worktree` | Each on-demand session gets its own git worktree (requires a git repo) |

## L2

### Why Does It Work? (why_does_it_work)

The design avoids exposing your machine to inbound connections entirely. The local process is the initiator — it makes outbound HTTPS calls to the Anthropic API, which acts as a relay. This means:
- No firewall rules to open.
- No public IP or domain needed on the machine.
- The remote device never has direct network access to your machine.

Short-lived, scoped credentials prevent a stolen session token from granting broad access. The `claude.ai/code` interface is just a view; all execution stays local.

### Why Not? (why_not)

Hard limits to know before relying on this:

| Limitation | Detail |
|---|---|
| Terminal must stay open | Remote Control is a local process. Close terminal → session ends. |
| Extended outage timeout | Machine awake but offline >10 minutes → session times out, process exits. |
| One remote session per interactive process | Use server mode + `--spawn` for multiple concurrent sessions. |
| Ultraplan conflict | Starting ultraplan disconnects Remote Control. |
| Plan requirements | Pro/Max/Team/Enterprise only. API keys not supported. |
| Team/Enterprise | Admin must enable the Remote Control toggle in admin settings first. |
| Full-scope login required | `setup-token` or `CLAUDE_CODE_OAUTH_TOKEN` tokens are inference-only; run `claude auth login` for full-scope. |
| Data retention incompatibility | Some org compliance configs permanently block Remote Control; cannot be changed from admin panel. |

## L3

### So What Benefit? (so_what_benefit)

For LTC use: long multi-step agent tasks (brainstorming sessions, research runs, DSBV builds) that outrun a desk session. Start at desk, monitor from phone while in transit, intervene if Claude needs input — without losing the local environment (MCP servers, skills, `.claude/` config all stay live).

### Now What — Next Steps? (now_what_next)

Activation checklist:
1. `claude --version` — confirm v2.1.51 or later.
2. `claude auth login` — must be claude.ai OAuth (not API key).
3. Run `claude` in project dir once to accept workspace trust.
4. `claude remote-control` to start, or add `--remote-control` flag to normal invocation.
5. Optional: `/config` → "Enable Remote Control for all sessions" = true for always-on.

Related pages to read next:
- [[claude-code-cli-reference]] — full `--remote-control` flags
- [[claude-code-channels]] — event-driven alternative for external triggers
- [[permission-modes]] — how sandboxing interacts with remote sessions

## Sources

- Claude Code docs — Remote Control: https://code.claude.com/docs/en/remote-control
- Source file: `captured/claude-code-docs-full.md` lines 23597–23796

## Links

- [[claude-code-cli-reference]]
- [[claude-code-channels]]
- [[claude-code-channels-reference]]
- [[permission-modes]]
- [[permission-rules]]
- [[managed-settings]]
- [[claude-code-dot-claude-directory]]
- [[claude-code-sandboxing]]
