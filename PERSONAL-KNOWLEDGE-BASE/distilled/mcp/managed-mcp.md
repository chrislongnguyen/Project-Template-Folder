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

# Managed MCP Configuration

> IT admins can deploy a `managed-mcp.json` to take exclusive control over all MCP servers, or use allowlists/denylists to restrict which servers users can add.

## L1 — Knowledge

### So What? (Relevance)

For LTC or enterprise deployments where security requires controlling which external tools Claude can access, managed MCP is the enforcement mechanism. Individual users cannot override managed MCP configuration.

### What Is It?

Two options for organizational MCP control:
1. **Exclusive control** via `managed-mcp.json` — replaces all user/project server configs
2. **Policy-based control** via `allowedMcpServers`/`deniedMcpServers` in managed settings — allows user servers within restrictions

### What Else?

**Managed MCP file locations (system-wide, requires admin):**
| OS | Path |
|----|------|
| macOS | `/Library/Application Support/ClaudeCode/managed-mcp.json` |
| Linux/WSL | `/etc/claude-code/managed-mcp.json` |
| Windows | `C:\Program Files\ClaudeCode\managed-mcp.json` |

These are system paths (not `~/Library/...`) requiring administrator privileges — intended for MDM/Ansible/Group Policy deployment.

**`managed-mcp.json` format:** Same as `.mcp.json`:
```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "company-internal": {
      "type": "stdio",
      "command": "/usr/local/bin/company-mcp-server",
      "args": ["--config", "/etc/company/mcp-config.json"],
      "env": {
        "COMPANY_API_URL": "https://internal.company.com"
      }
    }
  }
}
```

### How Does It Work?

**Option 1 — Exclusive control:**
Deploy `managed-mcp.json`. When present, Claude Code uses ONLY these servers. User and project configs are ignored for MCP. No additional settings needed.

**Option 2 — Policy-based:**
In managed settings (deployed via MDM), configure:
```json
{
  "allowedMcpServers": ["github", "sentry"],
  "deniedMcpServers": ["*-untrusted-*"]
}
```
Users can still add their own servers but only those matching the allowlist (and not the denylist) connect.

**Disable MCP entirely:**
```json
{
  "deniedMcpServers": ["*"]
}
```

## L2 — Understanding

### Why Does It Work?

Managed MCP sits at the highest precedence in the scope hierarchy — above user, project, and local configurations. This mirrors how managed policy CLAUDE.md files work: they cannot be excluded by individual settings. The exclusive-control model is simple to reason about ("these are the only servers, period") while the policy model gives users flexibility within org-defined boundaries.

### Why Not?

- `managed-mcp.json` takes exclusive control — users cannot add any additional servers, including personal utilities they rely on
- Policy-based control requires correctly specifying allowlist/denylist patterns — gaps in coverage can allow unintended servers
- Managed settings require admin tooling (MDM, Ansible) to distribute — not a click-to-configure option

## Sources

- captured/claude-code-docs-full.md (lines 18068-18122)

## Links

- [[mcp-server-config]]
- [[mcp-authentication]]
- [[claude-md-files]]
