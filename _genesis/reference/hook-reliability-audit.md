---
version: "2.0"
status: draft
last_updated: 2026-04-05
owner: Long Nguyen
---

# Hook Reliability Audit — Claude Code Hooks

**Scope:** Known platform-level bugs in Claude Code hooks that affect LTC script-first harness reliability.
**Audience:** LTC members designing or debugging hook-based governance.
**Rule:** When adding new hooks, consult this document first to avoid designing around unreliable platform behavior.

---

## CAN / CANNOT Matrix

| Hook Event | CAN Reliably Do | CANNOT Reliably Do |
|---|---|---|
| `PreToolUse` | Block tool execution via exit code 2 for most tool calls | Block subagent (Agent()) dispatch — exit code silently ignored (#40580) |
| `PreToolUse` | Inject feedback into Claude via stdout | Guarantee block in all edge-case tool scenarios (#13756) |
| `PostToolUse` | Observe tool output and log it | Modify or inject into built-in tool output (#32105) |
| `PostToolUse` | Trigger side-effects (write files, alert) | Inject context into Claude reliably in all cases (#37559) |
| `SubagentStop` | Block or flag after subagent completes | Prevent subagent from running in the first place |
| Any hook | Fire before context compaction threshold | Fire after compaction occurs — all hooks go silent (#25655) |

---

## Known Bugs — Full Registry

### BUG-01 — Exit Code 2 Unreliable in Edge Cases
**GitHub Issue:** #13756
**Affected hook:** `PreToolUse`
**Behavior:** Exit code 2 is the documented mechanism to block tool execution. In most scenarios it works. In certain edge cases (tool call batching, Claude-internal retries) the block does not fire reliably.
**LTC Mitigation:** Pre-commit chain uses `PreToolUse` on `Bash(git commit *)` — this specific use case is reliable. For high-stakes blocks, add a PostToolUse observer as a secondary signal. Do not rely solely on exit code 2 for safety-critical enforcement without a redundant layer.

---

### BUG-02 — PreToolUse Exit Codes Ignored for Agent() Calls
**GitHub Issue:** #40580
**Affected hook:** `PreToolUse`
**Behavior:** When Claude dispatches a subagent via `Agent()`, `PreToolUse` hooks fire but exit code 2 is silently ignored. The subagent launches regardless. This means `verify-agent-dispatch.sh` has a silent enforcement hole for subagent dispatch scenarios.
**LTC Mitigation:** `SubagentStop` hook runs `verify-deliverables.sh` after every subagent completes. This provides post-execution enforcement rather than pre-execution blocking. The design accepts the hole (subagent runs) but catches bad output before it propagates. Document this trade-off in any future agent governance design.

---

### BUG-03 — All Hooks Stop Firing After Context Compaction
**GitHub Issue:** #25655
**Affected hooks:** All (`PreToolUse`, `PostToolUse`, `SubagentStop`, `Stop`, etc.)
**Behavior:** After Claude Code performs context compaction (auto-summarization of the context window), all hooks cease firing for the remainder of the session. There is no in-session recovery. The only workaround is restarting the session.
**LTC Mitigation:** `strategic-compact.sh` monitors context usage and warns the user before hitting the compaction threshold. The warning prompts the user to save state and restart proactively — preserving hook continuity. Governance gaps post-compaction must be accepted as a known platform risk until a platform fix ships.

---

### BUG-04 — PostToolUse Cannot Modify Built-in Tool Output
**GitHub Issue:** #32105
**Affected hook:** `PostToolUse`
**Behavior:** `PostToolUse` hooks receive tool output as read-only context. Hooks cannot modify, suppress, or inject into the output Claude receives from built-in tools (Read, Bash, Grep, etc.). Any attempt to alter tool output via PostToolUse has no effect.
**LTC Mitigation:** All LTC `PostToolUse` hooks are designed as observe-only by default. Hooks use this event for logging, telemetry, and side-effect triggers — never for output mutation. This is an intentional design constraint, not a workaround gap.

---

### BUG-05 — PostToolUse Context Injection Unreliable
**GitHub Issue:** #37559
**Affected hook:** `PostToolUse`
**Behavior:** `PostToolUse` hooks can write to stdout to inject context into Claude's next turn. However, this injection is not reliable across all tool call types and sequences. In some scenarios the stdout is ignored.
**LTC Mitigation:** LTC hooks that need to surface information to Claude use `PreToolUse` injection (before the next tool call) rather than `PostToolUse` injection. For critical signals, write to a sidecar file and instruct Claude to read it via CLAUDE.md rules, bypassing hook injection entirely.

---

## Design Principles Derived From This Audit

| Principle | Rationale |
|---|---|
| Never single-point-of-failure a hook | Every critical enforcement needs a redundant layer (pre + post, or hook + rule) |
| Prefer PreToolUse over PostToolUse for blocking | PostToolUse cannot block; PreToolUse can (within known edge cases) |
| SubagentStop is the only reliable Agent() enforcement point | #40580 makes PreToolUse useless for subagent governance |
| Warn before compaction, never after | #25655 makes post-compaction hooks silent — proactive warning is the only option |
| Design PostToolUse as observe-only | #32105 and #37559 make injection unreliable; accept the constraint by design |

---

## Maintenance

When a new Claude Code bug affecting hooks is discovered:
1. Add a row to the CAN/CANNOT matrix
2. Add a BUG-XX entry with: GitHub issue #, affected hook, behavior, LTC mitigation
3. Update `last_updated` and bump `version`
4. Notify via project retro if the bug creates a governance gap

When a bug is resolved by the platform:
1. Mark the BUG-XX entry with `**RESOLVED — Claude Code vX.Y**`
2. Document whether the LTC mitigation remains (belt-and-suspenders) or is retired

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[project]]
