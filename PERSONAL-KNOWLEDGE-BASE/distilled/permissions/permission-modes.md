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

# Permission Modes

Claude Code operates on a spectrum from "ask every time" to "run everything silently." Permission modes set where on that spectrum each session sits — choosing the wrong mode either interrupts flow constantly or removes safety nets you need.

## L1 — Knowledge

### So What? (Relevance)

Every tool call Claude makes — file edits, shell commands, network requests — must be approved or auto-approved. The mode you pick determines how many interruptions you get. For autonomous agents and CI pipelines, the default "ask every time" mode breaks workflows. For sensitive work, a looser mode removes oversight you need. Matching mode to context is a first-class security decision.

### What Is It?

A permission mode is a session-level setting that controls which tool calls Claude runs without a human approval prompt. There are six modes:

| Mode | What runs without asking | Best for |
|------|--------------------------|----------|
| `default` | Reads only | Getting started, sensitive work |
| `acceptEdits` | Reads + file edits | Iterating while reviewing via git diff |
| `plan` | Reads only (no writes at all) | Exploring a codebase before changing it |
| `auto` | Everything, with background classifier checks | Long tasks, reducing prompt fatigue |
| `dontAsk` | Only pre-approved tools (deny everything else) | Locked-down CI and scripts |
| `bypassPermissions` | Everything except protected paths | Isolated containers/VMs only |

### What Else?

- `plan` and `default` both allow reads only, but `plan` additionally prevents Claude from making any edits at all — it can only research and write a proposed plan.
- Protected paths are never auto-approved in any mode. This protects `.git`, `.vscode`, `.idea`, `.husky`, and most of `.claude/` from accidental writes.
- Modes set the baseline. You layer `allow`, `ask`, and `deny` rules on top to pre-approve or block specific tools within a mode (except `bypassPermissions`, which skips the rule layer entirely).
- `dontAsk` is the only mode not accessible via the `Shift+Tab` cycle — it must be set with `--permission-mode dontAsk` at startup.

### How Does It Work?

**Switching modes:**
- CLI: `Shift+Tab` cycles `default → acceptEdits → plan`. Optional modes (`auto`, `bypassPermissions`) slot in after `plan` once enabled.
- At startup: `claude --permission-mode plan`
- As a persistent default: set `defaultMode` in `.claude/settings.json`:

```json
{
  "permissions": {
    "defaultMode": "acceptEdits"
  }
}
```

- VS Code: click the mode indicator at the bottom of the prompt box. Labels map to modes (e.g., "Edit automatically" = `acceptEdits`, "Ask before edits" = `default`).

**Mode entry requirements:**
- `auto`: requires `--enable-auto-mode` flag, Team/Enterprise/API plan, Claude Sonnet 4.6+ or Opus 4.6+, Anthropic API only (not Bedrock/Vertex).
- `bypassPermissions`: requires `--permission-mode bypassPermissions` or `--dangerously-skip-permissions` flag at startup; cannot enter mid-session.

## L2 — Understanding

### Why Does It Work?

The mode spectrum maps to the tradeoff between throughput and oversight. Claude must request approval for any action that could have side effects. In interactive development, per-action prompts catch mistakes but create friction. In CI pipelines or autonomous runs, they block progress entirely. The mode system externalizes this tradeoff: the human sets the risk tolerance once per session rather than negotiating it action-by-action.

Protected paths exist as a hard floor beneath all modes because certain directories (`.git`, `.claude`, shell RC files) can cause irreversible corruption or compromise the agent itself if accidentally overwritten. No mode override removes that floor.

### Why Not?

**Mode limitations and failure modes:**

- `acceptEdits` only auto-approves file edits — shell commands still prompt. If your workflow is mostly shell commands, this mode does not meaningfully reduce interruptions.
- `auto` is a research preview. The classifier has false positives: routine operations against unrecognized infrastructure get blocked. If the classifier blocks 3 consecutive actions or 20 total, auto mode pauses and Claude falls back to prompting.
- `bypassPermissions` has no safety net. Prompt injection attacks or misunderstood instructions execute immediately. The docs explicitly recommend containers/VMs without internet access. Using it on a developer workstation against a production codebase is high-blast-radius.
- `dontAsk` silently denies any tool not in the allow list — including `ask` rules. A misconfigured allow list means Claude cannot complete its task with no visible error to the user.
- The `Shift+Tab` cycle is not the same set on every surface. Web sessions (cloud) only have `acceptEdits` and `plan`. Remote Control sessions exclude `auto` and `bypassPermissions`.

## L3 — Application

### So What Benefit?

The practical gain is matching session risk posture to task type without changing code:

- Code review session: `default` — every file edit gets explicit approval before landing.
- Greenfield scaffolding: `acceptEdits` — edits land immediately, review via `git diff` at the end.
- Codebase exploration before a PR: `plan` — zero risk of accidental writes.
- Overnight autonomous refactor: `auto` — maximum throughput with classifier as backstop.
- CI pipeline: `dontAsk` with a tight allow list — deterministic, non-interactive, auditable.
- Ephemeral container: `bypassPermissions` — maximum speed with OS-level isolation as the safety layer.

### Now What Next?

1. Set `defaultMode` in `~/.claude/settings.json` to match your most common session type.
2. For CI, add `--permission-mode dontAsk` to your invocation and define an explicit `permissions.allow` list.
3. For `auto` mode, read [[auto-mode-classifier]] before enabling — the classifier needs your infrastructure context to avoid false positives.
4. Administrators: block `bypassPermissions` org-wide via `permissions.disableBypassPermissionsMode: "disable"` in managed settings.

## Sources

- Source: `captured/claude-code-docs-full.md` lines 20174–20456
- Upstream URL: https://code.claude.com/docs/en/permission-modes

## Links

- [[auto-mode-classifier]]
- [[permission-rules]]
- [[managed-settings]]
- [[protected-paths]]
