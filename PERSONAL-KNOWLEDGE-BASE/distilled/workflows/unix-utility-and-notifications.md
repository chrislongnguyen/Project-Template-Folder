---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: workflows
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

# Claude Code as Unix Utility and Desktop Notifications

Claude Code can operate headlessly as a composable Unix tool — accepting stdin, writing stdout, integrating into CI pipelines and shell scripts — and can fire desktop notifications when a long-running task needs your attention.

## L1 — What / What else / How / Relevance

### What it is

Three related capabilities for non-interactive and background use:

1. **Desktop notifications** — a `Notification` hook fires when Claude is idle, needs permission, or completes auth. Maps to a native OS command (`osascript`, `notify-send`, PowerShell).
2. **Unix-style piping** — `claude -p 'prompt'` accepts stdin and writes to stdout. Combines with standard Unix tools: `cat`, `grep`, `tee`, `jq`.
3. **Scheduled tasks** — Claude can run on a cron-like schedule via four mechanisms (cloud, desktop app, GitHub Actions, `/loop`).

### What else it covers

- Output format control: `--output-format text | json | stream-json`
- CI/CD integration: Claude as a linter step in `package.json` scripts
- Self-documentation: Claude answers capability questions via `/powerup` or free text

### How it works

**Notification hook** — add a `Notification` entry to `~/.claude/settings.json`. The `matcher` field filters event types:

| Matcher | Fires when |
| :--- | :--- |
| `permission_prompt` | Claude needs tool approval |
| `idle_prompt` | Done, waiting for next prompt |
| `auth_success` | Authentication completes |
| `elicitation_dialog` | Claude is asking a question |

macOS example:
```json
{
  "hooks": {
    "Notification": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "osascript -e 'display notification \"Claude Code needs your attention\" with title \"Claude Code\"'"
      }]
    }]
  }
}
```

**Piping** — the `-p` flag enables non-interactive (print) mode:
```bash
cat build-error.txt | claude -p 'explain the root cause' > output.txt
```

**Output format** — controls what hits stdout:

| Flag | Output |
| :--- | :--- |
| `--output-format text` | Plain response string (default) |
| `--output-format json` | Full message array with cost and duration metadata |
| `--output-format stream-json` | Newline-delimited JSON objects in real time |

**Scheduling options:**

| Option | Where it runs | Best for |
| :--- | :--- | :--- |
| Cloud scheduled tasks | Anthropic-managed infra | Runs even when machine is off |
| Desktop scheduled tasks | Local machine via desktop app | Needs local files or uncommitted changes |
| GitHub Actions | CI pipeline | Repo events + cron in `.github/workflows/` |
| `/loop` | Current CLI session | Quick polling; cancelled on exit |

### So what — relevance to LTC

LTC agents run long DSBV build cycles. Notifications eliminate manual polling between tasks. Unix piping lets `ltc-builder` output feed directly into validation scripts or log parsers without intermediate files. Scheduled PR review or dependency audits reduce recurring manual overhead.

## L2 — Why it works / Why not

### Why it works

- Claude's `-p` flag exits after one turn, producing a clean stdout stream — no REPL state, no interactive prompts. This matches the Unix process model exactly.
- The `Notification` hook sits outside the model inference path; it's a shell command triggered by lifecycle events, so it adds near-zero latency.
- `stream-json` outputs one JSON object per turn, enabling real-time log tailing with `jq` without waiting for the full response.

### Why not (limits)

- `-p` (non-interactive) mode cannot use computer use — computer use requires an interactive session.
- `/loop` tasks are cancelled when the session exits — not suitable for overnight jobs.
- Cloud scheduled tasks require a Pro or Max plan and run on Anthropic infra, so they cannot access local uncommitted files.
- `--output-format json` produces a JSON array that includes the full conversation history plus cost metadata — not minimal if you only need the text.
- Scheduled prompts must be self-contained: Claude cannot ask clarifying questions mid-run. Prompts must specify what "done" looks like and where results go.

## Sources

- Source lines 7837–8076: `captured/claude-code-docs-full.md`
- Docs: https://code.claude.com/docs/en/hooks-guide#get-notified-when-claude-needs-input
- Docs: https://code.claude.com/docs/en/scheduled-tasks

## Links

- [[hooks-and-automation]]
- [[automation-and-scaling]]
- [[skills-and-subagents]]
