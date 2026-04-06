---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: agents
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

# Agent Teams — Best Practices & Quality Gates

Operational guidance for running effective agent teams: sizing, task design, quality enforcement via hooks, and troubleshooting failure modes.

## L1

### So What? (Relevance)

Agent teams are easy to misconfigure: wrong team size wastes tokens, poorly scoped tasks cause file conflicts or idle teammates, and an unmonitored team diverges without producing usable output. These practices are the difference between a productive parallel run and an expensive dead end.

### What Is It?

A collection of sizing rules, task design principles, quality gate mechanisms (hooks), and failure patterns with their fixes.

**Team size rule of thumb:** 3–5 teammates for most workflows. Aim for 5–6 tasks per teammate.

**Quality gate hooks (enforce before work proceeds):**

| Hook | Trigger | Exit code 2 effect |
|------|---------|-------------------|
| `TeammateIdle` | Teammate about to go idle | Send feedback; keep teammate working |
| `TaskCreated` | Task being created | Prevent creation; send feedback |
| `TaskCompleted` | Task being marked complete | Prevent completion; send feedback |

### What Else?

- For first use of agent teams, start with read-only tasks (PR review, bug investigation) to learn team dynamics without file conflict risk
- CLAUDE.md works normally for teammates — use it to broadcast project-specific guidance to all teammates automatically
- The lead breaks work into tasks automatically; if tasks are too large, explicitly ask it to split them
- Pre-approve common operations in permission settings before spawning teammates to reduce permission-prompt interruptions

### How Does It Work?

**Spawn with enough context** (teammates don't inherit lead's history):
```text
Spawn a security reviewer teammate with the prompt: "Review the authentication
module at src/auth/ for security vulnerabilities. Focus on token handling,
session management, and input validation. The app uses JWT tokens stored in
httpOnly cookies. Report any issues with severity ratings."
```

**Control lead behavior** when it starts implementing instead of delegating:
```text
Wait for your teammates to complete their tasks before proceeding
```

**Avoid file conflicts:** assign each teammate ownership of a distinct file set. Two teammates editing the same file causes overwrites.

**Shutdown sequence:**
1. Shut down individual teammates: `Ask the researcher teammate to shut down`
2. Then clean up: `Clean up the team`
   - Cleanup fails if active teammates remain — always shut down first
   - Only the lead should run cleanup; teammates running cleanup may leave resources in inconsistent state

## L2

### Why Does It Work?

The 3–5 teammate range balances two opposing forces: parallel throughput (benefit of more teammates) vs coordination overhead + token cost (cost of more teammates). At 3–5, the lead can track progress without constant context-switching, and teammates have enough tasks (5–6 each) to stay productive without excessive claiming. The hook system enforces quality gates at the task level rather than relying on the lead's judgment alone — exit code 2 creates a feedback loop that keeps teammates working until criteria are met.

### Why Not?

- **Hooks add setup cost**: defining `TeammateIdle`, `TaskCreated`, and `TaskCompleted` hooks requires upfront spec work; without them, quality enforcement is purely prompt-based
- **File conflict prevention is manual**: there is no automatic file-locking for writes — the burden is on the user to partition file ownership in the spawn prompt
- **Lead can go rogue**: the lead may start implementing tasks itself or declare the team done prematurely; requires active monitoring and correction prompts
- **Troubleshooting is opaque in in-process mode**: a stuck teammate is invisible unless you cycle to it with Shift+Down — no passive alerts

**Common failure patterns:**

| Symptom | Fix |
|---------|-----|
| Teammates not appearing | Press Shift+Down; verify task was complex enough; check tmux in PATH |
| Too many permission prompts | Pre-approve operations in permission settings before spawning |
| Teammate stops on error | Give direct instructions via Shift+Down or spawn replacement |
| Lead finishes early | Tell lead to keep going; tell it to wait for teammates |
| Orphaned tmux session | `tmux ls` then `tmux kill-session -t <name>` |
| Task status lag | Check if work is done; manually update or nudge via lead |

## Sources

- `captured/claude-code-docs-full.md` lines 307–413 (Best practices + Troubleshooting + Limitations sections)

## Links

- [[agent-teams-overview]] — when to use, enable, start, and shut down teams
- [[agent-teams-architecture-coordination]] — task list, mailbox, context model
- [[agent-teams-display-modes]] — in-process vs split-pane, keyboard controls
- [[subagent-hooks]] — hook types including TeammateIdle, TaskCreated, TaskCompleted
