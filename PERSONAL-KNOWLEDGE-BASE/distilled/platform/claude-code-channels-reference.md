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
  - now_what_better
---

# Claude Code Channels Reference

Builder reference for the channel MCP contract: how to implement a server that pushes webhooks, alerts, or chat messages into a Claude Code session. Covers capability declaration, notification format, reply tools, sender gating, and permission relay.

Requires Claude Code v2.1.80+ (permission relay: v2.1.81+). Research preview — not for production use.

---

## L1: What, Why, and What Else

### what_is_it

A channel is an MCP server (Node/Bun/Deno) that:
1. Declares `capabilities.experimental['claude/channel']: {}` in its constructor
2. Emits `notifications/claude/channel` events when external events occur
3. Connects over stdio transport (Claude Code spawns it as a subprocess)

That is the complete minimum for a one-way channel. Two-way channels add a reply MCP tool. Channels with permission relay add `claude/channel/permission` capability and a notification handler.

### so_what_relevance

If none of the official plugins (Telegram, Discord, iMessage) cover your system, you build your own. Common targets: CI pipelines, error trackers, deploy hooks, internal alert systems, custom chat platforms.

### what_else

Two architectural patterns for the external interface:

| Pattern | External interface | Example |
|---|---|---|
| Chat bridge | Channel server polls platform API locally | Telegram, Discord — no inbound URL needed |
| Webhook receiver | Channel server listens on local HTTP port | CI alerts — external system POSTs to localhost |

Both run as local subprocesses. The channel server is always the bridge between external systems and Claude Code.

---

## L2: How It Works and Constraints

### how_does_it_work

**Channel server structure:**

```
Server constructor
  ├── capabilities.experimental['claude/channel']: {}   ← required (registers listener)
  ├── capabilities.experimental['claude/channel/permission']: {}  ← optional (permission relay)
  ├── capabilities.tools: {}                             ← two-way channels only
  └── instructions: string                               ← added to Claude's system prompt

mcp.connect(new StdioServerTransport())                  ← Claude Code spawns this

External listener (HTTP port or platform API poll)
  └── on event: mcp.notification({
        method: 'notifications/claude/channel',
        params: { content: string, meta: Record<string,string> }
      })
```

**Notification format:**

| Field | Type | Description |
|---|---|---|
| `content` | `string` | Event body — becomes the body of the `<channel>` tag |
| `meta` | `Record<string, string>` | Optional. Each key becomes a tag attribute. Keys must be identifiers (letters, digits, underscores only — hyphens silently dropped) |

Claude sees:
```xml
<channel source="your-channel" severity="high" run_id="1234">
build failed on main: https://ci.example.com/run/1234
</channel>
```

The `source` attribute is set automatically from the server's configured name in `.mcp.json`.

**MCP registration (`.mcp.json`):**
```json
{
  "mcpServers": {
    "webhook": { "command": "bun", "args": ["./webhook.ts"] }
  }
}
```

**Session start:**
```bash
# approved plugin
claude --channels plugin:yourplugin@yourmarketplace

# development/custom server (bypasses allowlist)
claude --dangerously-load-development-channels server:webhook
```

### L3: Implementation Detail — Minimal Webhook Receiver

```typescript
#!/usr/bin/env bun
import { Server } from '@modelcontextprotocol/sdk/server/index.js'
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js'

const mcp = new Server(
  { name: 'webhook', version: '0.0.1' },
  {
    capabilities: { experimental: { 'claude/channel': {} } },
    instructions: 'Events from the webhook channel arrive as <channel source="webhook" ...>. One-way: read and act, no reply expected.',
  },
)

await mcp.connect(new StdioServerTransport())

Bun.serve({
  port: 8788,
  hostname: '127.0.0.1',   // localhost only — nothing outside this machine can POST
  async fetch(req) {
    const body = await req.text()
    await mcp.notification({
      method: 'notifications/claude/channel',
      params: {
        content: body,
        meta: { path: new URL(req.url).pathname, method: req.method },
      },
    })
    return new Response('ok')
  },
})
```

Test with curl:
```bash
curl -X POST localhost:8788 -d "build failed on main: https://ci.example.com/run/1234"
```

Debug: if curl succeeds but nothing reaches Claude, run `/mcp` in the session. Stderr trace at `~/.claude/debug/<session-id>.txt`.

### L3: Two-Way: Expose a Reply Tool

Three components required:
1. `tools: {}` in capabilities (enables tool discovery)
2. `ListToolsRequestSchema` handler (declares the tool schema)
3. `CallToolRequestSchema` handler (implements send logic)

```typescript
import { ListToolsRequestSchema, CallToolRequestSchema } from '@modelcontextprotocol/sdk/types.js'

mcp.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [{
    name: 'reply',
    description: 'Send a message back over this channel',
    inputSchema: {
      type: 'object',
      properties: {
        chat_id: { type: 'string', description: 'The conversation to reply in' },
        text: { type: 'string', description: 'The message to send' },
      },
      required: ['chat_id', 'text'],
    },
  }],
}))

mcp.setRequestHandler(CallToolRequestSchema, async req => {
  if (req.params.name === 'reply') {
    const { chat_id, text } = req.params.arguments as { chat_id: string; text: string }
    send(`Reply to ${chat_id}: ${text}`)   // your outbound: POST to platform API or SSE
    return { content: [{ type: 'text', text: 'sent' }] }
  }
  throw new Error(`unknown tool: ${req.params.name}`)
})
```

Update `instructions` to tell Claude which tool to call and which meta attribute to pass back:
```
'Messages arrive as <channel source="webhook" chat_id="...">. Reply with the reply tool, passing the chat_id from the tag.'
```

### L3: Permission Relay

When Claude calls a tool requiring approval, the local terminal dialog opens. A two-way channel can receive the same prompt in parallel and relay it remotely. Both stay live — first answer wins.

**Relay covers:** `Bash`, `Write`, `Edit` tool approvals.
**Does not relay:** Project trust dialogs, MCP server consent dialogs.

**Three components to add:**

**1. Declare capability:**
```typescript
capabilities: {
  experimental: {
    'claude/channel': {},
    'claude/channel/permission': {},   // opt in to permission relay
  },
  tools: {},
}
```

**2. Handle incoming permission request** (`notifications/claude/channel/permission_request`):

| Field | Description |
|---|---|
| `request_id` | 5 lowercase letters (no `l`). Include verbatim in outbound prompt. |
| `tool_name` | e.g. `Bash`, `Write` |
| `description` | Human-readable summary of the specific tool call |
| `input_preview` | Tool args as JSON, truncated to 200 chars |

```typescript
import { z } from 'zod'

const PermissionRequestSchema = z.object({
  method: z.literal('notifications/claude/channel/permission_request'),
  params: z.object({
    request_id: z.string(),
    tool_name: z.string(),
    description: z.string(),
    input_preview: z.string(),
  }),
})

mcp.setNotificationHandler(PermissionRequestSchema, async ({ params }) => {
  send(
    `Claude wants to run ${params.tool_name}: ${params.description}\n\n` +
    `Reply "yes ${params.request_id}" or "no ${params.request_id}"`
  )
})
```

**3. Intercept verdict in inbound handler:**

```typescript
// [a-km-z] is the ID alphabet (lowercase, skips 'l')
const PERMISSION_REPLY_RE = /^\s*(y|yes|n|no)\s+([a-km-z]{5})\s*$/i

async function onInbound(message) {
  if (!allowed.has(message.from.id)) return  // gate on sender first

  const m = PERMISSION_REPLY_RE.exec(message.text)
  if (m) {
    await mcp.notification({
      method: 'notifications/claude/channel/permission',
      params: {
        request_id: m[2].toLowerCase(),
        behavior: m[1].toLowerCase().startsWith('y') ? 'allow' : 'deny',
      },
    })
    return  // handled as verdict — don't forward as chat
  }

  // normal chat path
  await mcp.notification({
    method: 'notifications/claude/channel',
    params: { content: message.text, meta: { chat_id: String(message.chat.id) } },
  })
}
```

### why_does_it_work

Channels reuse the standard MCP stdio subprocess model — no new transport layer. The `claude/channel` capability is the only channel-specific addition; everything else (tool registration, notification dispatch, stdio connect) follows the existing MCP SDK patterns. This means any MCP-compatible runtime (Bun, Node, Deno) works with no extra dependencies beyond `@modelcontextprotocol/sdk`.

### why_not

**Not suitable when:**
- You need events to arrive without an active session (no always-on daemon mode)
- You need public inbound URLs — webhook receivers only listen on localhost; external services must be able to reach the machine
- You want broad distribution — custom channels require `--dangerously-load-development-channels` until approved by Anthropic or added to org's `allowedChannelPlugins`
- Team/Enterprise without admin enabling `channelsEnabled` — `channelsEnabled` org policy still applies even with the dev flag

---

## L4: What It Is Not, Failure Modes, Edge Cases, Better Alternatives

### what_is_it_not

- Not a persistent daemon — events only arrive while Claude Code is running
- Not a publicly accessible server — webhook receivers bind to `127.0.0.1` only
- Not a replacement for MCP tools — standard MCP is still the right model when Claude needs on-demand query access rather than pushed events
- Not authentication infrastructure — sender gating is your responsibility; an ungated channel is a prompt injection vector

### how_does_it_not_work

**Failure modes:**

| Symptom | Likely cause | Fix |
|---|---|---|
| curl succeeds but nothing reaches Claude | Server import/dependency error | Run `/mcp` in session; check `~/.claude/debug/<session-id>.txt` |
| curl fails with "connection refused" | Port not bound, or stale process | `lsof -i :<port>` to see what's listening; kill stale process |
| "blocked by org policy" on startup | `channelsEnabled` not set | Admin must enable at `claude.ai → Admin settings → Claude Code → Channels` |
| Plugin not registered | Not on allowlist | Use `--dangerously-load-development-channels` for local testing |
| meta key silently dropped | Key contains hyphens | Use underscores only in meta keys |
| Remote verdict ignored | Wrong ID format or wrong ID | ID must be 5 chars from `[a-km-z]`; no `l`; normalize to lowercase |

**Sender gating critical rule:** Gate on `message.from.id` (sender identity), NOT `message.chat.id` (room identity). In group chats these differ — gating on the room lets anyone in an allowlisted group inject messages.

### what_if

**What if you need the session to be always-on?**
Run Claude Code in a background process or persistent terminal with `--dangerously-skip-permissions`. This bypasses tool approval prompts — only use in environments you control.

**What if you want to distribute your channel?**
Package it as a plugin (`/en/plugins`) and publish to a marketplace. Submit to the official `claude-plugins-official` marketplace for Anthropic review to get added to the default allowlist. On Team/Enterprise, an admin can add it to `allowedChannelPlugins` without Anthropic review.

**What if the permission relay reply arrives in wrong format?**
Two outcomes, both safe: (a) format mismatch — regex fails, text treated as normal chat message to Claude; (b) right format, wrong ID — Claude Code drops it silently. Local terminal dialog stays open in both cases.

### now_what_better

For distribution: wrap in a plugin and submit to `claude-plugins-official`. Reference implementations with full pairing flows, file attachments, and reply tools: [claude-plugins-official/external_plugins](https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins).

For unattended background use: combine channels with `--dangerously-skip-permissions` only in trusted, isolated environments.

---

## Server Options Reference

| Field | Type | Required | Description |
|---|---|---|---|
| `capabilities.experimental['claude/channel']` | `object` | Yes | Always `{}`. Registers the notification listener. |
| `capabilities.experimental['claude/channel/permission']` | `object` | No | Always `{}`. Opts in to permission relay. Only declare if channel gates on sender. |
| `capabilities.tools` | `object` | Two-way only | Always `{}`. Enables tool discovery for reply tools. |
| `instructions` | `string` | Recommended | Added to Claude's system prompt. Describe events, attributes, whether/how to reply. |

---

## Testing During Research Preview

```bash
# Plugin under development
claude --dangerously-load-development-channels plugin:yourplugin@yourmarketplace

# Bare .mcp.json server (no plugin wrapper)
claude --dangerously-load-development-channels server:webhook
```

Bypass is per-entry. Does not extend to `--channels` entries. `channelsEnabled` org policy still applies.

---

## Sources

- https://code.claude.com/docs/en/channels-reference

## Links

- [[claude-code-channels]] — user-facing overview: supported platforms, security, enterprise controls
- [[claude-code-extensibility-taxonomy]] — where channels fit in the broader extensibility model
