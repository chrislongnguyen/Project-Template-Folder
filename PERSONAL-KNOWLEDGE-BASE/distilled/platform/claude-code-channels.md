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

# Claude Code Channels

Channels let external systems push events into a running Claude Code session so Claude can react while you are away from the terminal. This enables async workflows: CI failures, chat messages, and monitoring alerts arrive where Claude already has your files open and your task context loaded.

Requires Claude Code v2.1.80+, claude.ai login. Console/API-key auth not supported.

---

## L1: What, Why, and What Else

### what_is_it

A channel is an MCP server that pushes events into your already-running Claude Code session via `notifications/claude/channel`. Unlike standard MCP servers (which Claude queries on demand), channels emit unprompted notifications when external events occur.

Three official channel plugins ship with the research preview: **Telegram**, **Discord**, and **iMessage**. A localhost demo called **fakechat** lets you test the flow without any external service.

### so_what_relevance

Most AI coding workflows are synchronous: you prompt, Claude responds, you wait. Channels break that constraint. You can start a long task, walk away, and get a Telegram message when it finishes — or have Claude react to a CI failure automatically while it already has your codebase loaded.

### what_else

Channels are one of four ways Claude Code connects to the outside world:

| Feature | What it does | Good for |
|---|---|---|
| Claude Code on the web | Runs tasks in a fresh cloud sandbox cloned from GitHub | Delegating self-contained async work |
| Claude in Slack | Spawns a web session from an `@Claude` mention | Starting tasks from team conversation |
| Standard MCP server | Claude queries it during a task; nothing is pushed | On-demand access to read/query a system |
| Remote Control | You drive your local session from claude.ai or mobile | Steering an in-progress session from your phone |

Channels fill the gap: **pushing events from non-Claude sources into your already-running local session**.

---

## L2: How It Works and Constraints

### how_does_it_work

**Architecture overview:**

```
External source (Telegram, CI, Discord)
        |
        v
Channel plugin (local subprocess, Bun)
  - chat platforms: polls platform API
  - webhooks: listens on local HTTP port
        |  stdio
        v
Claude Code session
  - receives <channel source="..."> tag in context
  - Claude reads event, acts, optionally replies via reply tool
        |  reply tool call
        v
External source (reply sent back through same channel)
```

Key mechanics:
1. Claude Code spawns the channel server as a stdio subprocess (standard MCP transport)
2. The channel declares `capabilities.experimental['claude/channel']: {}` — this is what registers the notification listener
3. External events arrive as `notifications/claude/channel` with `content` (event body) and optional `meta` (key-value attributes)
4. Claude sees `<channel source="..." key="val">event body</channel>` in its context
5. For two-way channels, Claude calls a `reply` MCP tool to send back through the same channel

**Session constraint:** Events only arrive while the session is open. For always-on use, run Claude in a background process or persistent terminal (`--dangerously-skip-permissions` for unattended).

**Reply visibility:** In the terminal you see the tool call and a confirmation (e.g., "sent"). The actual reply text appears on the remote platform only.

### L3: Platform Setup Mechanics

**Telegram setup (5 steps):**
1. Create a bot via BotFather, copy the token
2. `/plugin install telegram@claude-plugins-official`
3. `/telegram:configure <token>` — saves to `~/.claude/channels/telegram/.env`
4. `claude --channels plugin:telegram@claude-plugins-official`
5. DM your bot → get pairing code → `/telegram:access pair <code>` → `/telegram:access policy allowlist`

**Discord setup (7 steps):**
1. Discord Developer Portal → New Application → Bot section → copy token
2. Enable Message Content Intent under Privileged Gateway Intents
3. OAuth2 → URL Generator: `bot` scope + 6 permissions (View, Send, Threads, History, Attach, React)
4. `/plugin install discord@claude-plugins-official`
5. `/discord:configure <token>` — saves to `~/.claude/channels/discord/.env`
6. `claude --channels plugin:discord@claude-plugins-official`
7. DM bot → pairing code → `/discord:access pair <code>` → `/discord:access policy allowlist`

**iMessage setup (3 steps + macOS only):**
1. Grant Full Disk Access to terminal (System Settings > Privacy & Security)
2. `/plugin install imessage@claude-plugins-official`
3. `claude --channels plugin:imessage@claude-plugins-official`
   - Self-chat bypasses access control automatically
   - Add others: `/imessage:access allow +15551234567`

**Fakechat quickstart (localhost demo, no auth needed):**
1. `/plugin install fakechat@claude-plugins-official`
2. `claude --channels plugin:fakechat@claude-plugins-official`
3. Open `http://localhost:8787` → type a message

**Multiple channels:** Pass space-separated to `--channels`:
```bash
claude --channels plugin:telegram@claude-plugins-official plugin:discord@claude-plugins-official
```

### why_does_it_work

The MCP stdio transport is already the standard for Claude Code tool servers. Channels reuse the same subprocess spawn + stdio mechanism, adding only the `claude/channel` capability declaration. This means:
- No new networking layer needed between Claude Code and the channel server
- The channel server runs locally with the same filesystem access as your session
- Chat platforms are polled from inside the channel server (no inbound URL to expose); webhooks listen on localhost (not publicly routable)

### why_not

**Constraints and gotchas:**
- Events only arrive while session is open — not a persistent daemon
- Requires claude.ai login (Console/API key auth not supported)
- Research preview: `--channels` flag syntax may change; plugins must be on Anthropic-maintained allowlist or org allowlist
- Team/Enterprise: channels are off by default — admin must enable `channelsEnabled`
- Being in `.mcp.json` is not enough — server must also be named in `--channels`
- Permission prompts pause the session until answered (unless `--dangerously-skip-permissions`)
- Terminal shows only the tool call confirmation; reply text is invisible in terminal

---

## L3: Benefit, Next Actions, and Limits

### so_what_benefit

Two primary use cases:

**Chat bridge:** Ask Claude something from your phone via Telegram/Discord/iMessage. The answer comes back in the same chat while the work runs on your machine against your real files and full session context.

**Webhook receiver:** A CI failure, error tracker alert, or deploy pipeline event arrives where Claude already has your files open and remembers what you were debugging. No context reload.

### now_what_next

- Build your own channel: see [[claude-code-channels-reference]] for the MCP contract
- Remote Control: drive a local session from your phone instead of forwarding events into it
- Scheduled tasks: poll on a timer instead of reacting to pushed events
- Enterprise enablement: `channelsEnabled: true` in managed settings + optional `allowedChannelPlugins`

---

## Security

Every approved channel plugin maintains a sender allowlist. Only IDs you have explicitly added can push messages — all others are silently dropped.

**Pairing flow (Telegram/Discord):**
1. DM your bot → bot replies with a pairing code
2. In Claude Code: `/telegram:access pair <code>` (or discord)
3. Your sender ID is added to the allowlist

**iMessage:** Self-chat bypasses the gate automatically. Other senders added by handle with `/imessage:access allow`.

**Session-level opt-in:** `--channels` controls which servers are enabled per session. Being in `.mcp.json` is not sufficient.

**Permission relay note:** Anyone who can reply through the channel can approve or deny tool use in your session (if the channel declares the permission relay capability). Only allowlist senders you trust with that authority.

**Enterprise controls:**

| Setting | Purpose | Default when unset |
|---|---|---|
| `channelsEnabled` | Master switch. Must be `true` for any channel to deliver messages. | Channels blocked |
| `allowedChannelPlugins` | Which plugins can register once enabled. Replaces Anthropic default list. | Anthropic default list applies |

Admin UI: `claude.ai → Admin settings → Claude Code → Channels`

```json
{
  "channelsEnabled": true,
  "allowedChannelPlugins": [
    { "marketplace": "claude-plugins-official", "plugin": "telegram" },
    { "marketplace": "acme-corp-plugins", "plugin": "internal-alerts" }
  ]
}
```

Pro/Max users without an organization skip org checks entirely.

---

## Research Preview Notes

- Rolling availability; `--channels` flag syntax may change
- Custom channels not on allowlist: use `--dangerously-load-development-channels`
- `channelsEnabled` org policy still applies even with the dev flag
- Report issues: [Claude Code GitHub](https://github.com/anthropics/claude-code/issues)

---

## Sources

- https://code.claude.com/docs/en/channels

## Links

- [[claude-code-channels-reference]] — MCP contract, notification format, reply tool, sender gating, permission relay
- [[claude-code-extensibility-taxonomy]] — where channels fit in the broader extensibility model
- [[claude-code-context-costs]] — session context implications of long-running channel sessions
