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

# Claude Code — Scheduled Tasks

Scheduled tasks let Claude Code run prompts automatically on a recurring schedule — no manual trigger needed. Use them for daily code reviews, dependency checks, morning briefings, and any repeating workflow you currently kick off by hand.

## L1 — What, What Else, How It Works, Relevance

### What is it?

A scheduled task is a saved prompt + schedule configuration that Claude Code Desktop (or Anthropic cloud infrastructure) executes on a timer. Each run opens a fresh session, executes the prompt, and optionally notifies you via desktop notification.

### Three scheduling options

| | Cloud | Desktop (local) | `/loop` |
|---|---|---|---|
| Runs on | Anthropic cloud | Your machine | Your machine |
| Requires machine on | No | Yes | Yes |
| Requires open session | No | No | Yes (session-scoped) |
| Persistent across restarts | Yes | Yes | No |
| Access to local files | No (fresh clone) | Yes | Yes |
| MCP servers | Connectors per task | Config files + connectors | Inherits from session |
| Permission prompts | No (autonomous) | Configurable per task | Inherits from session |
| Minimum interval | 1 hour | 1 minute | 1 minute |

**Decision rule:** Cloud tasks for reliability when machine is off. Desktop tasks when local file access is needed. `/loop` for quick polling within a live session.

### How it works (Desktop local tasks)

1. Desktop checks the schedule every minute while the app is open.
2. When a task is due, it starts a fresh session with a fixed stagger delay (up to 10 minutes, deterministic per task) to spread API load.
3. A desktop notification fires and the session appears under **Scheduled** in the sidebar.
4. The session behaves identically to a manual session — Claude can edit files, run commands, commit, and open PRs.
5. If the machine is asleep at scheduled time, the run is skipped (not queued).

### Frequency options

| Option | Behavior |
|---|---|
| Manual | No schedule — run on demand only |
| Hourly | Every hour with fixed per-task offset |
| Daily | Time picker, default 9:00 AM local |
| Weekdays | Daily but skips Sat/Sun |
| Weekly | Day + time picker |
| Custom | Ask Claude in plain language ("every 6 hours", "first of month") |

### Relevance (so_what_relevance)

Any recurring Claude workflow that currently requires manually opening a session can become a scheduled task. This shifts repetitive oversight loops (dependency audits, PR summaries, daily standup prep) from human-initiated to system-initiated.

## L2 — Why It Works, Why Not

### Why it works (why_does_it_work)

- **Fresh session per run** eliminates context bleed between runs. Each execution sees the current state of the working directory, not a stale conversation context.
- **Deterministic stagger delay** prevents all tasks firing simultaneously at the top of the hour, distributing API load without user configuration.
- **Permission mode inheritance** from `~/.claude/settings.json` allows blanket allow-rules to carry into scheduled sessions, enabling unattended operation without per-task setup.
- **Catch-up logic (max 1 run)** prevents cascade: a week of missed daily runs produces exactly one catch-up run, not six.

### Why not / limitations (why_not)

- **Machine sleep kills local tasks.** Closing a laptop lid suspends Desktop. Cloud tasks are the correct answer for time-critical overnight runs.
- **Cloud tasks use a fresh git clone**, not your local checkout. Uncommitted work is invisible to cloud-scheduled tasks.
- **Timing-sensitive prompts require self-guardrails.** A task scheduled for 9am can run at 11pm on catch-up. Without prompt-level guards ("only review today's commits; if after 5pm, skip"), the output will be contextually wrong.
- **Ask mode stalls on permission gaps.** If a task needs a tool not yet approved, the session blocks waiting for user input. Mitigation: run once manually after creation and pre-approve all tools.
- **Worktree isolation is opt-in.** By default, tasks run against whatever state the working directory is in, including uncommitted changes. Enable the worktree toggle per task to get isolation.

## L3 — Benefit and Next Action

### So what benefit (so_what_benefit)

For an LTC team running multiple projects: scheduled tasks turn Claude into a passive quality gate. A daily 9am task can scan for uncommitted changes, post a dependency audit, or summarize overnight PRs before standup — all without a developer opening Claude manually. The "always one catch-up run" policy means the system stays eventually consistent even across weekends.

### Now what next (now_what_next)

- Candidate LTC tasks: (1) daily dependency audit on template repo, (2) weekly changelog summary for stakeholder digest, (3) morning standup briefing from git log + open issues.
- First-run protocol: create task → click **Run now** → pre-approve all permission prompts → verify output → enable schedule.
- For overnight reliability, use cloud task variant once confirmed working locally.
- To persist custom schedules, ask Claude in plain language during a Desktop session; the schedule is stored in `~/.claude/scheduled-tasks/<task-name>/SKILL.md`.

## Sources

- captured/claude-code-docs-full.md lines 9417–9516 (scheduling options, create task, frequency, how tasks run, missed runs, permissions, manage tasks)

## Links

- [[claude-code-desktop]]
- [[automation-and-scaling]]
- [[claude-code-channels]]
- [[skills-and-subagents]]
