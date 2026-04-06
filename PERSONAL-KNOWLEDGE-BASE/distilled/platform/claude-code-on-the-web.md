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
---

# Claude Code on the Web (Research Preview)

Kick off Claude Code tasks asynchronously on Anthropic-managed cloud VMs — from a browser, mobile app, or terminal — without the task tying up your local machine.

---

## L1 — What / Relevance

### What is it?

Claude Code on the Web lets you submit coding tasks to a cloud session at claude.ai/code. Anthropic spins up an isolated VM, clones your GitHub repository, runs a setup script if configured, and executes the task autonomously. You can monitor progress, steer Claude, review diffs, and create PRs — all from the browser or the Claude mobile app.

Currently in research preview for Pro, Max, Team, and Enterprise users.

### So what — relevance

The primary unlock is parallelism and mobility. You can start three separate bug-fix sessions with `--remote`, close your laptop, and check results on your phone. It also unblocks repositories you haven't checked out locally.

### What else

Key capabilities beyond basic task execution:

| Feature | What it enables |
|---|---|
| Diff view | Review file-by-file changes before creating a PR, iterate with comments |
| Auto-fix PRs | Claude watches a PR, responds to CI failures and review comments automatically |
| Session teleport | Pull a web session into your local terminal to continue work |
| Scheduled tasks | Recurring tasks (daily PR reviews, dep audits) without manual triggering |
| `--remote` flag | Start a cloud session from terminal, keep working locally |
| ultraplan | Draft and review execution plan in cloud before executing |
| Mobile monitoring | Monitor and steer sessions from iOS/Android Claude app |

---

## L2 — Why / Constraints

### How does it work

Execution sequence for a web session:

```
1. Repo cloned to Anthropic-managed VM (default branch unless specified in prompt)
2. Setup script runs (if configured) — before Claude Code launches, new sessions only
3. SessionStart hooks fire (if committed to repo) — after Claude Code launches
4. Claude executes: reads code, writes changes, runs tests, checks work
5. Claude pushes to a branch — you create PR from web interface
```

Networking runs behind an HTTP/HTTPS security proxy. Default access is "Limited" — an allowlist of ~100+ domains covering all major package registries (npm, PyPI, RubyGems, crates.io, Maven, etc.), GitHub/GitLab/Bitbucket, cloud platforms, and container registries.

Setup scripts vs. SessionStart hooks — decision rule:

| | Setup scripts | SessionStart hooks |
|---|---|---|
| Attached to | Cloud environment (UI config) | Repository (`.claude/settings.json`) |
| Runs | Before Claude Code, new sessions only | After Claude Code, every session start |
| Scope | Cloud only | Cloud and local |

Use setup scripts for cloud-only dependencies (a CLI tool your laptop already has). Use SessionStart hooks for project-level setup that should run everywhere (e.g., `npm install`).

### Why does it work

Sessions run in fully isolated VMs — no credential leakage because git auth flows through a scoped proxy that never places your actual token inside the sandbox. The GitHub proxy restricts push operations to the current working branch only, preventing runaway writes.

The "Plan locally, execute remotely" pattern works because Claude in plan mode (`--permission-mode plan`) is read-only — you can safely refine the approach in your terminal, then fire off a `--remote` execution without risk.

### Why not — limitations

| Constraint | Detail |
|---|---|
| GitHub only | Works with GitHub only (incl. GitHub Enterprise Server for Team/Enterprise). GitLab and others not supported. |
| Research preview | Feature set may change; not production-stable. |
| Session handoff is one-way | You can pull web→local (teleport), but you cannot push an existing local session to the web. `--remote` creates a new session. |
| Rate limits shared | Web sessions consume the same rate limits as all other Claude Code usage. Parallel sessions multiply consumption. |
| Bun proxy incompatibility | Bun does not work correctly through the security proxy. Use npm/yarn/pnpm instead. |
| Hooks don't carry from local user settings | Only hooks committed to the repo run in cloud. `~/.claude/settings.json` user-level hooks are local only. |
| Auto-fix requires GitHub App | The Auto-fix PR feature needs the Claude GitHub App installed on the repo to receive webhook events. |
| Comment automation risk | Auto-fix can reply to PR comment threads under your username, potentially triggering comment-driven automation (Atlantis, Terraform Cloud). Audit before enabling. |

---

## L3 — Deeper / Action

### What it is not

This is not a replacement for local development. It does not provide a live coding environment you interact with interactively in real time the way a local session does. It is optimized for well-defined, autonomous tasks where you want to offload execution and review results asynchronously.

It is also not Computer Use — there is no screen control of native OS apps. For that, see [[computer-use]].

### So what — concrete benefit

Best-fit task types for web sessions:

1. Well-scoped bug fixes that pass tests — ship to `--remote`, get a PR while you work on something else
2. Parallel refactors — three `--remote` commands running simultaneously in separate sessions
3. Repos you haven't cloned — review and fix issues on mobile without a dev environment
4. Scheduled dependency audits — no cron job or CI overhead required

### Now what — next actions

1. Run `/web-setup` inside Claude Code to connect GitHub using local `gh` CLI credentials.
2. Test with a low-stakes task: `claude --remote "Add docstrings to src/utils.py"`.
3. Use `/tasks` to monitor. Press `t` to teleport the session to your terminal when done.
4. For any repo with comment-driven CI/CD automation (Atlantis, etc.) — review before enabling Auto-fix on PRs.
5. Add a setup script for any cloud-only dependency (e.g., `apt install gh`). Run `check-tools` in a cloud session first to see what's already there.

---

## Sources

- https://code.claude.com/docs/en/claude-code-on-the-web
- Source file: `captured/claude-code-docs-full.md` lines 5841–6560

## Links

- [[claude-code-cli-reference]] — `--remote`, `--teleport`, `--permission-mode` flags
- [[claude-code-chrome-extension]] — browser automation from local sessions
- [[computer-use]] — native macOS app control (different from web sessions)
- [[claude-code-channels]] — VS Code and other interfaces
