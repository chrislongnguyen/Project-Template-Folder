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
  - what_is_it_not
  - how_does_it_not_work
  - what_if
  - now_what_next
---

# Claude Code — Sandboxing

Sandboxing enforces OS-level filesystem and network boundaries around every bash command Claude Code runs, cutting approval fatigue while preventing a compromised agent from reaching your SSH keys, system configs, or external attacker-controlled servers.

## L1

### So What? (so_what_relevance)

Without sandboxing, each bash command Claude Code runs either needs your approval or operates with your full user permissions. Sandboxing trades that per-command gate for an upfront boundary definition: Claude works freely within the box, and anything outside requires a deliberate exception. The net effect is fewer interruptions AND a harder limit on blast radius if Claude is manipulated via prompt injection.

### What Is It? (what_is_it)

Sandboxing is a native Claude Code feature that wraps the bash tool in OS-level security primitives:

| Platform | Primitive |
|---|---|
| macOS | Seatbelt (built-in, no install needed) |
| Linux / WSL2 | bubblewrap + socat (must install: `apt-get install bubblewrap socat`) |
| WSL1 | Not supported (bubblewrap requires WSL2 kernel features) |

The sandbox enforces two dimensions simultaneously:
- **Filesystem isolation**: reads/writes outside the current working directory are blocked by default.
- **Network isolation**: outbound connections are routed through a proxy; only approved domains pass through.

Enable with the `/sandbox` command inside Claude Code, or pass `--sandbox` to `claude remote-control`.

### What Else? (what_else)

Two sandbox modes:

| Mode | Bash behavior |
|---|---|
| Auto-allow | Sandboxed commands run without prompts. Commands that cannot be sandboxed fall back to normal permission flow. |
| Regular permissions | All commands go through standard approval flow, even when sandboxed. More control, more prompts. |

Auto-allow mode is independent of the global permission mode. Even if you're not in "accept edits" mode, sandboxed bash commands auto-execute. File edits via Read/Edit tools still follow their own permission rules.

Escape hatch: when a command fails due to sandbox restrictions, Claude may retry with `dangerouslyDisableSandbox` — which routes through the normal permission flow. Disable this by setting `"allowUnsandboxedCommands": false` in sandbox settings.

Sandboxing complements (does not replace) the [[permission-rules]] system:
- **Permissions** govern which tools Claude can invoke (Bash, Read, Edit, WebFetch, MCP) — evaluated before the tool runs.
- **Sandboxing** restricts what bash commands can touch at the OS level after they run — enforced by the kernel.

### How Does It Work? (how_does_it_work)

```
User request
    │
    ▼
Permissions layer (tool-level gate)
    │  allow?
    ▼
Bash tool invoked
    │
    ├─ Filesystem access ──→ Seatbelt / bubblewrap enforces allowWrite/denyRead rules
    │
    └─ Network access ────→ Proxy server (outside sandbox) checks domain allowlist
                                │
                                ├─ Approved domain → pass through
                                └─ Unknown domain  → prompt user (or block if allowManagedDomainsOnly)
```

Child processes inherit the sandbox. `kubectl`, `terraform`, `npm`, and any subprocess spawned by a command all run under the same boundaries.

**Filesystem path resolution** (for `sandbox.filesystem.*` settings):

| Prefix | Resolves to |
|---|---|
| `/path` | Absolute filesystem path |
| `~/path` | `$HOME/path` |
| `./path` or bare name | Project root (project settings) or `~/.claude` (user settings) |

**Settings merge behavior**: `allowWrite`, `denyWrite`, `denyRead`, `allowRead` arrays are **merged** across all settings scopes — not replaced. A managed setting adding `/opt/company-tools` and a user adding `~/.kube` both survive in the final config.

Precedence within a `denyRead` region: `allowRead` takes precedence over `denyRead`, but `allowManagedReadPathsOnly` (managed settings) ignores user/project `allowRead` entries.

Example — block home dir reads, allow project:
```json
{
  "sandbox": {
    "enabled": true,
    "filesystem": {
      "denyRead": ["~/"],
      "allowRead": ["."]
    }
  }
}
```

## L2

### Why Does It Work? (why_does_it_work)

The security guarantee comes from the enforcement layer being the OS kernel, not Claude Code itself. Even if a prompt injection attack changes Claude's behavior, it cannot override Seatbelt or bubblewrap — those boundaries are enforced below the application layer. The sandbox does not trust Claude's judgment; it enforces physical limits on what the process can touch.

Network isolation through a proxy outside the sandbox is equally important: a process inside the sandbox cannot establish direct outbound connections; all traffic must route through the proxy, which only passes approved domains. This closes the exfiltration path even if filesystem isolation is perfect.

The dual-dimension design matters: filesystem-only isolation still lets a compromised agent phone home. Network-only isolation still lets it backdoor system files for later. Both must be active.

### Why Not? (why_not)

Known limitations and bypasses:

| Risk | Detail |
|---|---|
| Broad domain allowlists | Allowing `github.com` or similar large domains can enable data exfiltration. Domain fronting may bypass filtering. |
| Unix socket escalation | `allowUnixSockets` for `/var/run/docker.sock` effectively grants host access. Audit carefully. |
| Filesystem permission escalation | Write access to `$PATH` directories, shell configs (`.bashrc`, `.zshrc`), or system config dirs enables code execution in other security contexts. |
| Linux weaker nested sandbox | `enableWeakerNestedSandbox` for Docker-without-privileged-namespaces considerably weakens isolation. Only use with additional external enforcement. |
| Incompatible tools | `watchman` is incompatible with the sandbox. `docker` is incompatible — add `docker *` to `excludedCommands`. |
| Network filtering scope | Proxy does not inspect traffic content — only domain destination. Malicious content from an approved domain passes through. |

Effective sandboxing requires both filesystem AND network isolation active simultaneously. A gap in either dimension undermines the other.

## L3

### What Is It Not? (what_is_it_not)

Sandboxing is **not**:
- A replacement for permissions. Permissions govern tool access; sandboxing governs bash execution scope. They are complementary layers.
- A content inspector. The network proxy filters by domain, not payload. HTTPS traffic from allowed domains is not decrypted or inspected (unless you add a custom proxy that does so).
- A container. Sandboxing uses OS primitives (Seatbelt/bubblewrap), not a VM or container. The process still shares the kernel with your host OS.
- A user auth system. It does not control which human can invoke Claude Code — that is `claude auth login` / [[permission-modes]].

### How Does It Not Work? (how_does_it_not_work)

Common configuration mistakes that create a false sense of security:
- Enabling filesystem isolation but leaving network open → exfiltration path still exists.
- Using `allowUnixSockets` for Docker socket → grants effective host escape.
- Broad `allowWrite` to `$PATH` dirs → privilege escalation via executable replacement.
- Assuming `denyRead: ["~/"]` blocks everything — if `allowRead: ["."]` is in user settings (not project settings), `.` resolves to `~/.claude`, not the project, leaving the project blocked.
- Relying on `allowManagedReadPathsOnly` while adding `allowRead` in project settings — those entries are ignored when the managed flag is set.

### What If? (what_if)

**What if a command legitimately needs to write outside the project dir?**
Use `sandbox.filesystem.allowWrite` to grant specific paths: `["~/.kube", "/tmp/build"]`. This is preferred over `excludedCommands` because it keeps the tool sandboxed while expanding only the necessary write surface.

**What if the sandbox breaks a tool entirely?**
Add the command to `excludedCommands` to force it outside the sandbox, and it falls back to the normal permission flow. For network-dependent CLI tools, grant the required domain once — Claude Code will remember it.

**What if sandboxing is unavailable on the platform?**
By default, Claude Code warns and continues without sandboxing. Set `sandbox.failIfUnavailable: true` to make this a hard failure — recommended for managed enterprise deployments where sandboxing is a security gate.

### Now What — Next Steps? (now_what_next)

Setup path:
1. macOS: no install needed. Linux/WSL2: `sudo apt-get install bubblewrap socat`.
2. Run `/sandbox` inside Claude Code to pick auto-allow or regular permissions mode.
3. Start restrictive — expand `allowWrite`/`allowedDomains` only as tools need them.
4. For enterprise: push sandbox config via [[managed-settings]]; set `allowManagedReadPathsOnly: true` and `failIfUnavailable: true`.
5. Review sandbox violation logs to understand what Claude Code is reaching for.

For custom network inspection: configure `sandbox.network.httpProxyPort` and `socksProxyPort` to route through your own proxy for traffic decryption and logging.

Open source runtime for use in your own agent projects:
```bash
npx @anthropic-ai/sandbox-runtime <command-to-sandbox>
```

## Sources

- Claude Code docs — Sandboxing: https://code.claude.com/docs/en/sandboxing
- Source file: `captured/claude-code-docs-full.md` lines 23798–24096

## Links

- [[permission-modes]]
- [[permission-rules]]
- [[managed-settings]]
- [[protected-paths]]
- [[auto-mode-classifier]]
- [[claude-code-remote-control]]
- [[claude-code-dot-claude-directory]]
