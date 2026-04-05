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

# Managed Settings

Managed settings are organization-level Claude Code configuration that cannot be overridden by users or projects. They are the mechanism for enforcing permission policy across a team rather than relying on per-developer discipline.

## L1 — Knowledge

### So What? (Relevance)

User and project settings are advisory — a developer can override them. Managed settings are not. If your security posture requires that no developer can enable `bypassPermissions`, or that only approved tools ever run in CI, managed settings are the only way to enforce that. Without them, every developer's local settings file is a potential policy bypass.

### What Is It?

Managed settings are a settings file (same format as `settings.json`) delivered via MDM, OS-level policy mechanisms, or server-managed settings. They occupy the top of the settings precedence stack and cannot be overridden by any other level, including command-line arguments.

**Settings precedence (highest to lowest):**
1. Managed settings — cannot be overridden
2. Command-line arguments (temporary session overrides)
3. Local project settings (`.claude/settings.local.json`)
4. Shared project settings (`.claude/settings.json`)
5. User settings (`~/.claude/settings.json`)

If a tool is denied in managed settings, `--allowedTools` cannot re-enable it. If a tool is allowed in user settings but denied in project settings, the project denial wins.

### What Else?

**Managed-only settings** (placing these in user or project settings has no effect):

| Setting | Effect |
|---------|--------|
| `allowedChannelPlugins` | Allowlist for channel plugins that may push messages |
| `allowManagedHooksOnly` | When `true`, only managed and SDK hooks load; user/project/plugin hooks are blocked |
| `allowManagedMcpServersOnly` | When `true`, only `allowedMcpServers` from managed settings are respected |
| `allowManagedPermissionRulesOnly` | When `true`, user and project settings cannot define `allow`, `ask`, or `deny` rules |
| `blockedMarketplaces` | Blocklist of plugin marketplace sources; checked before download |
| `channelsEnabled` | Enables/disables channel message delivery for Team/Enterprise users |
| `forceRemoteSettingsRefresh` | When `true`, blocks CLI startup until remote managed settings are freshly fetched |
| `sandbox.filesystem.allowManagedReadPathsOnly` | When `true`, only managed `filesystem.allowRead` paths are respected |
| `sandbox.network.allowManagedDomainsOnly` | When `true`, only managed `allowedDomains` and `WebFetch` allow rules apply |
| `strictKnownMarketplaces` | Controls which plugin marketplaces users can add |

**Mode-blocking settings** (can be placed anywhere but are most useful in managed settings):
- `permissions.disableBypassPermissionsMode: "disable"` — prevents `bypassPermissions` mode.
- `permissions.disableAutoMode: "disable"` — prevents `auto` mode.

### How Does It Work?

Managed settings are delivered via three mechanisms:
1. **MDM/OS-level policies** — pushed by an IT administrator to managed devices.
2. **Managed settings file** — a file in a location Claude Code reads before user settings.
3. **Server-managed settings** — pulled from Anthropic's server at startup; `forceRemoteSettingsRefresh: true` blocks startup until freshly fetched.

For Team and Enterprise plans, administrators configure Claude Code admin settings at `claude.ai/admin-settings/claude-code`. This is where `auto` mode is enabled or locked off for the organization.

**Example: lock out bypassPermissions and restrict rules to managed-only:**

```json
{
  "permissions": {
    "disableBypassPermissionsMode": "disable",
    "allowManagedPermissionRulesOnly": true,
    "allow": ["Bash(npm run *)", "Bash(git commit *)"],
    "deny": ["Bash(git push *)", "Bash(curl *)"]
  }
}
```

With `allowManagedPermissionRulesOnly: true`, no developer can add their own allow/deny rules — only the managed rules apply.

**Auto mode classifier and managed settings:**

The classifier reads `autoMode` from user settings, `.claude/settings.local.json`, and managed settings — but NOT from shared `.claude/settings.json`. Managed `autoMode.environment`, `allow`, and `soft_deny` entries are combined with developer entries additively. For rules developers cannot override, use `permissions.deny` in managed settings instead of classifier-level rules — deny rules block before the classifier is consulted.

## L2 — Understanding

### Why Does It Work?

The settings precedence stack mirrors a standard policy layering model: organization policy beats project convention beats personal preference. This is the same pattern as MDM-managed browser policies, OS-level firewall rules, and enterprise software licensing. Claude Code adopted this pattern because it integrates with existing IT governance workflows — administrators already know how to deliver MDM policies, so managed settings does not require a new distribution system.

`allowManagedPermissionRulesOnly` is the high-trust lockdown option: it removes the ability to grant any new tool access at the user or project level. This is appropriate for regulated environments where every permitted tool must go through a review and change control process.

### Why Not?

**Server-managed settings with `forceRemoteSettingsRefresh: true` creates a hard dependency on Anthropic's servers.** If the fetch fails and fail-closed is enforced, Claude Code will not start at all. This is intentional security posture (fail closed > fail open) but creates an availability risk in air-gapped environments or during Anthropic service disruptions.

**`allowManagedPermissionRulesOnly` is all-or-nothing.** Once enabled, developers cannot add even low-risk allow rules (e.g., allowing `npm test`). Every permitted command must go through the managed settings update cycle, which may be slow in organizations with change control processes. Plan the allow list comprehensively before enabling this setting.

**Managed settings precedence does not apply to the auto mode classifier's `allow` and `soft_deny`.** A developer's `~/.claude/settings.json` `autoMode.allow` entry can override a managed `autoMode.soft_deny` entry, because the classifier combination is additive. Only `permissions.deny` in managed settings provides a hard block that no developer can work around.

**Remote Control and web session access are NOT controlled by managed settings keys.** They are controlled exclusively via the admin settings panel at `claude.ai/admin-settings/claude-code`.

## Sources

- Source: `captured/claude-code-docs-full.md` lines 20705–20870
- Upstream URL: https://code.claude.com/docs/en/permissions#managed-settings

## Links

- [[permission-modes]]
- [[permission-rules]]
- [[auto-mode-classifier]]
- [[protected-paths]]
