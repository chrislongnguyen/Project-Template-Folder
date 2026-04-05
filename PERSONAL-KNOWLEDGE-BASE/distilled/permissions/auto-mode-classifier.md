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

# Auto Mode Classifier

Auto mode eliminates permission prompts by substituting a background classifier model that evaluates each action before execution. Understanding what the classifier trusts by default — and how to configure it — determines whether auto mode is usable or noise-generating in your environment.

## L1 — Knowledge

### So What? (Relevance)

Without configuration, the classifier knows only your working directory and the current repo's remotes as "trusted." Every push to your org's GitHub, write to a shared S3 bucket, or call to an internal service looks like potential exfiltration and gets blocked. For teams, this means auto mode generates more false-positive blocks than it prevents interruptions, until the `autoMode.environment` block is filled in with your actual infrastructure.

### What Is It?

The auto mode classifier is a separate model (currently Claude Sonnet 4.6) that evaluates each tool call in `auto` mode against a set of allow and deny rules before execution. It replaces per-action human approval with a safety assessment that runs server-side and out-of-band from the main session.

**Availability requirements:**
- Claude Code v2.1.83 or later.
- Plan: Team, Enterprise, or API only (not Pro or Max).
- Admin on Team/Enterprise must enable it in Claude Code admin settings.
- Model: Claude Sonnet 4.6 or Opus 4.6 (not Haiku or claude-3).
- Provider: Anthropic API only (not Bedrock, Vertex, or Foundry).

### What Else?

**Decision order (first match wins):**
1. Explicit `allow` or `deny` rules → resolve immediately, classifier not consulted.
2. Read-only actions and file edits in the working directory (outside protected paths) → auto-approved.
3. Everything else → sent to classifier.
4. Classifier blocks → Claude receives the reason and tries an alternative.

**Broad allow rules dropped on auto mode entry:**
- `Bash(*)`, wildcarded interpreters (`Bash(python*)`), package-manager run commands, `Agent` allow rules — all dropped. Narrow rules like `Bash(npm test)` carry over.

**Subagent handling:**
1. Delegated task description evaluated before subagent starts — dangerous-looking tasks blocked at spawn time.
2. Each subagent action evaluated with same classifier rules; `permissionMode` in subagent frontmatter is ignored.
3. On subagent completion, full action history reviewed; concerns prepend a security warning to results.

**Fallback thresholds:**
- 3 consecutive blocks OR 20 total blocks → auto mode pauses, Claude resumes prompting.
- Approving a prompted action resumes auto mode.
- In non-interactive mode (`-p` flag), repeated blocks abort the session (no user to prompt).
- Any allowed action resets the consecutive counter. Total counter persists for the session.

### How Does It Work?

**Defaults (what classifier trusts out of the box):**

Allowed: local file operations in working directory, dependencies declared in lock files/manifests, reading `.env` and sending credentials to their matching API, read-only HTTP, pushing to the branch you started on or one Claude created.

Blocked: `curl | bash`, sending sensitive data to external endpoints, production deploys and migrations, mass deletion on cloud storage, IAM/repo permission grants, modifying shared infrastructure, irreversibly destroying pre-session files, force push or pushing directly to `main`.

Run `claude auto-mode defaults` to see the full built-in lists.

**Configuring trusted infrastructure (`autoMode.environment`):**

The classifier reads `autoMode` from user settings, `.claude/settings.local.json`, and managed settings only — NOT from shared `.claude/settings.json` (a checked-in repo could inject its own allow rules).

```json
{
  "autoMode": {
    "environment": [
      "Organization: Acme Corp. Primary use: software development",
      "Source control: github.com/acme-corp and all repos under it",
      "Trusted cloud buckets: s3://acme-build-artifacts, gs://acme-ml-datasets",
      "Trusted internal domains: *.corp.example.com, api.internal.example.com",
      "Key internal services: Jenkins at ci.example.com, Artifactory at artifacts.example.com"
    ]
  }
}
```

Entries are prose, not regex. The classifier reads them as natural-language rules. Write them as you would describe your infrastructure to a new engineer. `environment` alone leaves the default `allow` and `soft_deny` lists intact.

**Overriding block and allow lists:**

- `autoMode.soft_deny` — replaces the full default block list. Setting even one entry discards ALL built-in block rules.
- `autoMode.allow` — replaces the full default allow exceptions.
- Precedence inside classifier: `soft_deny` blocks first, `allow` overrides as exceptions, explicit user intent overrides both (e.g., "force-push this branch" authorizes force-push; "clean up the repo" does not).

**Safe customization workflow:**

```bash
claude auto-mode defaults   # print full built-in rules
claude auto-mode config     # show effective config (your settings + defaults)
claude auto-mode critique   # AI feedback on custom allow/soft_deny rules
```

Copy the output of `defaults` into your settings, edit to match your policy, verify with `config`.

**Scope and merging:**

| Scope | File | Use for |
|-------|------|---------|
| One developer | `~/.claude/settings.json` | Personal trusted infra |
| One project, one developer | `.claude/settings.local.json` | Per-project buckets/services, gitignored |
| Organization | Managed settings | Enforced for all developers |

Entries from each scope are combined additively. A developer `allow` entry can override an org `soft_deny` entry. For a rule developers cannot work around, use `permissions.deny` in managed settings instead — that blocks before the classifier is consulted.

## L2 — Understanding

### Why Does It Work?

The classifier operates server-side on a separate model, which means it runs without access to tool results — hostile content in a file Claude read cannot manipulate the classifier directly. A separate server-side probe scans incoming tool results and flags suspicious content before Claude reads it. This two-layer separation (classifier sees user messages + tool calls + CLAUDE.md, not tool results) reduces the attack surface for prompt injection.

Prose-based `environment` entries work because the classifier is an LLM that can interpret natural language descriptions of infrastructure. This is more maintainable than regex patterns and matches how engineers actually document their systems.

### Why Not?

**Setting `allow` or `soft_deny` replaces the entire default list.** This is the highest-severity footgun in the permission system. A single `soft_deny` entry with one custom rule discards force-push protection, exfiltration detection, and production deploy blocking simultaneously. Always start from `claude auto-mode defaults` output, never from an empty list.

**Developer `allow` entries can override org `soft_deny`.** The combination is additive, not a hard policy boundary. If you need rules developers cannot work around, `permissions.deny` in managed settings is the correct mechanism — classifier-level rules are not enforcement-grade.

**Classifier cost and latency:** Each check sends a portion of the transcript plus the pending action to a Sonnet 4.6 instance, adding a round-trip before execution. Reads and working-directory edits skip the classifier, so overhead concentrates on shell commands and network operations. Classifier calls count against your token usage.

**False positives are the primary failure mode.** If auto mode blocks 20 actions in a session, it pauses entirely. In repos with unusual infrastructure (air-gapped networks, custom registries, non-standard cloud providers), the out-of-box classifier will be noisy until `environment` is configured. The `/permissions` Recently denied tab and `r` to retry are the recovery mechanism.

## Sources

- Source: `captured/claude-code-docs-full.md` lines 20307–20401, 20739–20870
- Upstream URL: https://code.claude.com/docs/en/permission-modes#eliminate-prompts-with-auto-mode
- Upstream URL: https://code.claude.com/docs/en/permissions#configure-the-auto-mode-classifier

## Links

- [[permission-modes]]
- [[permission-rules]]
- [[managed-settings]]
- [[protected-paths]]
