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
  - so_what_benefit
  - now_what_next
---

# Authentication & Credentials in Claude Code

Claude Code supports multiple authentication methods — from individual OAuth login to team-managed API keys, cloud provider credentials, and custom key-rotation scripts. Choosing the wrong method or having conflicting credentials is the most common source of silent billing failures and access errors in team deployments.

## L1 — What, Why, and How

### so_what_relevance — Why does this matter?

Authentication is the first gate. Get it wrong and Claude Code either silently uses the wrong billing account (API key shadowing a subscription), fails with a 401 that looks like a quota issue, or requires per-user manual setup that blocks team rollout. The precedence order is non-obvious and causes real production incidents.

For LTC: we run Claude Code across individual (Long, Pro/Max) and team contexts. Understanding the precedence chain and storage locations is prerequisite for any automated or multi-user deployment.

### what_is_it — What is Claude Code authentication?

A layered system with 5 credential types, ranked by precedence, each suited to a different deployment context:

| Tier | Credential type | Use case |
|------|----------------|----------|
| 1 | Cloud provider env vars (Bedrock/Vertex/Foundry) | Enterprise infra teams |
| 2 | `ANTHROPIC_AUTH_TOKEN` | LLM gateway / proxy with bearer tokens |
| 3 | `ANTHROPIC_API_KEY` | Direct API access, Console billing |
| 4 | `apiKeyHelper` script | Dynamic/rotating credentials, vault-fetched tokens |
| 5 | Subscription OAuth (`/login`) | Default — Claude Pro, Max, Teams, Enterprise |

Individual login flow: run `claude` → browser opens → authenticate → done. Re-auth: `/logout`.

### what_else — What types of team authentication exist?

Three team paths, each with distinct tradeoffs:

**Claude for Teams / Enterprise (recommended)**
- Teams: self-service, centralized billing, admin tools, collaboration features.
- Enterprise: adds SSO, domain capture, RBAC, compliance API, managed policy. Best for orgs with security/compliance requirements.
- Setup: subscribe → admin invites members → members install + log in with Claude.ai account.

**Claude Console authentication (API-based billing)**
- For orgs that prefer API billing over subscription billing.
- Admin invites users via Console → Settings → Members → Invite (or SSO).
- Two roles: `Claude Code` (can only create CC API keys) vs `Developer` (any API key type).
- Users accept invite → install Claude Code → log in with Console credentials.

**Cloud provider authentication (Bedrock / Vertex AI / Microsoft Foundry)**
- No browser login. Set env vars before running `claude`.
- Admin distributes env var config + credential generation instructions.
- Detailed setup in provider-specific docs (see [[cloud-provider-integrations]]).

### how_does_it_work — Credential storage and management

**Storage locations by OS:**
- macOS: encrypted Keychain
- Linux: `~/.claude/.credentials.json` (mode `0600`) or `$CLAUDE_CONFIG_DIR`
- Windows: `~/.claude/.credentials.json` (inherits user profile ACLs)

**Supported stored types:** Claude.ai OAuth, Claude API keys, Azure Auth, Bedrock Auth, Vertex Auth.

**`apiKeyHelper` — custom credential script:**
- Configured via the `apiKeyHelper` setting in settings.json.
- Returns an API key via stdout (e.g., fetched from a secrets vault).
- Refresh: called after 5 min or on HTTP 401. Set `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` for custom interval.
- Warning threshold: if the script takes >10 seconds, Claude Code shows an elapsed-time notice in the prompt bar.

**Scope constraint:** `apiKeyHelper`, `ANTHROPIC_API_KEY`, and `ANTHROPIC_AUTH_TOKEN` apply to terminal CLI sessions only. Claude Desktop and remote sessions use OAuth exclusively — they do not call `apiKeyHelper` or read API key env vars.

## L2 — Why It Works and Where It Breaks

### why_does_it_work — Why is the precedence chain designed this way?

The order reflects operational trust and specificity:
1. Cloud provider vars are explicit infrastructure-level intent — highest precedence to avoid accidental fallback.
2. Bearer token (`ANTHROPIC_AUTH_TOKEN`) covers gateway/proxy routing where you don't have an Anthropic API key at all.
3. API key (`ANTHROPIC_API_KEY`) is the standard direct-API path; interactive approval on first use prevents accidental usage.
4. `apiKeyHelper` is for dynamic credentials — lower than static env vars to allow env overrides.
5. OAuth subscription is the safe fallback — always works if user is logged in, no env pollution risk.

The design separates "infrastructure config" (env vars, set at deploy time) from "user intent" (OAuth, set at login) so they don't accidentally override each other — except API keys *do* override subscriptions, which is the known footgun.

### why_not — Where does this break down?

**The API key shadow problem:** If `ANTHROPIC_API_KEY` is set in your shell environment (e.g., from a prior project), it takes precedence over your active Claude subscription. This causes silent billing to the API key's org, not your subscription — and if that org is disabled or the key expired, you get auth failures that look like a quota or network issue. Fix: `unset ANTHROPIC_API_KEY`, check `/status` to confirm active auth method.

**`apiKeyHelper` latency:** If the key script hits a slow secrets vault, the 10-second warning fires but doesn't block — Claude Code continues waiting. If the script never returns, the session hangs. Optimize vault calls or cache the token locally with a short TTL.

**Desktop/remote scope blindness:** Engineers assume API key env vars work everywhere. They don't — Desktop and remote sessions ignore them entirely. Attempting to use `apiKeyHelper` for a remote session silently falls through to OAuth.

**Console role mismatch:** Users invited with the `Claude Code` role cannot create general API keys. If they later need API access for scripting, an admin must re-invite them with the `Developer` role. There is no self-service role upgrade.

## L2 — So What and Now What

### so_what_benefit — What does getting this right unlock?

- **Zero-friction team rollout:** Teams path + admin invites = members self-serve install + login with no per-user API key management.
- **Automated pipelines:** `apiKeyHelper` with vault integration = rotating short-lived tokens, no long-lived API keys in env files.
- **Accurate billing attribution:** Knowing the precedence chain prevents silent misrouting to the wrong org.
- **Audit-clean:** Console roles (Claude Code vs Developer) enforce least-privilege API key creation at the org level.

### now_what_next — What should I do next?

1. **Verify active auth method:** Run `/status` in any Claude Code session — confirms which credential tier is active.
2. **Check for API key shadowing:** Run `echo $ANTHROPIC_API_KEY` in your shell. If non-empty and you intend to use subscription, unset it.
3. **Team deployment path:** For LTC team use, evaluate Teams vs Console auth based on billing preference (subscription vs API billing).
4. **Vault integration:** If implementing `apiKeyHelper`, set `CLAUDE_CODE_API_KEY_HELPER_TTL_MS` to match your vault token TTL and benchmark script latency against the 10-second warning threshold.
5. **Role assignment:** When inviting via Console, assign `Claude Code` role by default; grant `Developer` only when API key creation is explicitly needed.

## Sources

- Claude Code docs — Authentication: https://code.claude.com/docs/en/authentication
- Source lines: 947–1077 of `captured/claude-code-docs-full.md`

## Links

- [[permission-modes]]
- [[permission-rules]]
- [[managed-settings]]
- [[auto-mode-classifier]]
- [[cloud-provider-integrations]]
