---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: mcp
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

# MCP Authentication

> Claude Code supports OAuth 2.0, static headers, and dynamic header helpers for MCP server authentication — tokens stored in system keychain and refreshed automatically.

## L1 — Knowledge

### So What? (Relevance)

Most cloud MCP servers require authentication. Knowing which auth method to configure — and when pre-configured credentials are needed vs. dynamic registration — prevents the most common MCP connection failures.

### What Is It?

Authentication configuration for HTTP MCP servers in Claude Code. Three mechanisms:
1. **OAuth 2.0** (browser flow) — for servers that support it
2. **Static headers** — for Bearer tokens or API keys
3. **Dynamic header helper** (`headersHelper`) — for Kerberos, short-lived tokens, SSO

### What Else?

**OAuth token storage:** System keychain (macOS) or credentials file — not in config files.

**Dynamic client registration:** Claude Code supports automatic OAuth setup. If a server requires pre-configured credentials instead, you'll see: "Incompatible auth server: does not support dynamic client registration."

**Fixed callback port:** Some servers require a specific redirect URI. Use `--callback-port <port>` so the OAuth callback URL matches what you registered.

**Client ID Metadata Document (CIMD):** Alternative to dynamic registration — Claude Code discovers automatically. If auto-discovery fails, register manually.

**Override OAuth metadata discovery:** For servers with non-standard OIDC endpoints:
```json
{
  "mcpServers": {
    "my-server": {
      "type": "http",
      "url": "https://mcp.example.com/mcp",
      "oauth": {
        "authServerMetadataUrl": "https://auth.example.com/.well-known/openid-configuration"
      }
    }
  }
}
```
Requires Claude Code v2.1.64+.

### How Does It Work?

**Standard OAuth flow:**
```bash
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
/mcp  # → shows "Authenticate" option → browser opens → complete login
```

**Pre-configured credentials:**
```bash
claude mcp add --transport http \
  --client-id your-client-id --client-secret --callback-port 8080 \
  my-server https://mcp.example.com/mcp
```
`--client-secret` prompts with masked input. Set `MCP_CLIENT_SECRET` env var to skip interactive prompt (for CI).

**Static headers:**
```bash
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```
Header values support `$VAR_NAME` interpolation if listed in `allowedEnvVars`.

**Dynamic header helper:**
```json
{
  "mcpServers": {
    "internal-api": {
      "type": "http",
      "url": "https://mcp.internal.example.com",
      "headersHelper": "/opt/bin/get-mcp-auth-headers.sh"
    }
  }
}
```
- Command must write `{"Header-Name": "value"}` JSON to stdout
- 10-second timeout, runs fresh on each connection (no caching)
- Claude Code sets `CLAUDE_CODE_MCP_SERVER_NAME` and `CLAUDE_CODE_MCP_SERVER_URL` env vars
- Only runs after workspace trust dialog approval (project/local scope)

## L2 — Understanding

### Why Does It Work?

Storing OAuth tokens in the system keychain (not config files) means credentials don't end up committed to VCS. Dynamic registration reduces setup friction — most users just run `/mcp` and follow the browser flow without knowing about OAuth internals. `headersHelper` covers the non-OAuth enterprise auth patterns (Kerberos, internal SSO) that static headers can't express.

### Why Not?

- OAuth only works with HTTP/SSE transports — no effect on stdio servers
- `headersHelper` runs arbitrary shell commands — project/local scope requires workspace trust
- `--client-secret` flag stores secret in keychain; if keychain is unavailable, use env var approach
- Clearing auth (`/mcp` → "Clear authentication") only clears stored tokens — doesn't revoke the OAuth app

## Sources

- captured/claude-code-docs-full.md (lines 17527-17715)

## Links

- [[mcp-server-config]]
- [[mcp-elicitation]]
