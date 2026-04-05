---
version: "2.3"
status: Draft
last_updated: 2026-04-05
owner: Long Nguyen
workstream: GOVERN
iteration: I2
type: ues-deliverable
work_stream: 0-GOVERN
stage: design
sub_system:
---
# DESIGN.md — GOVERN: Script-First Harness, Ripple Enforcement & Status Governance

> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.
> Placement: `_genesis/` because GOVERN patches skip per-workstream folders (see `alpei-chain-of-custody.md`).

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Upstream sufficient? | YES — GOVERN exception per chain-of-custody. Input: 6 explorer agent reports (Hermes eval, reviews, Vinh analysis, hooks docs, community patterns, scripts best practices) + full audit of existing 9 hooks + 8 scripts |
| Q2: In scope? | (1) EP-14 Script-First Delegation, (2) ripple-check system, (3) status enforcement, (4) hook wiring (PostToolUse + pre-commit chain), (5) utility scripts, (6) hook reliability audit, (7) /vault-capture skill, (8) obsidian skill update, (9) agent-dispatch mitigation, (10) hook cleanup — delete Long-specific vault hooks, keep/rewrite project-generic ones |
| Q2b: Out of scope? | /vault-promote (I3), Hermes adoption (WATCH LIST), QMD repo indexing (Grep is better), auto-skill-creation (separate DSBV), cross-project .claude/ sync (I3+), Obsidian Bases dashboards (separate branch work) |
| Q3: Go/No-Go | GO |

---

## Design Decisions

**Intent:** Close the gap between our Tier 3-4 agent orchestration and our under-invested script/hook layer. Add status enforcement (closes MEMORY.md open decision c). Community research shows scripts should handle 80% of deterministic work for free, leaving agents for judgment calls only.

**Key constraints:**
- Hook exit code 2 does NOT reliably block (GitHub #13756, #40580) — do NOT rely on hooks for security-critical blocking
- PreToolUse exit codes IGNORED for subagent calls (#40580) — verify-agent-dispatch.sh has a silent hole
- All hooks stop firing after context compaction (#25655)
- PostToolUse cannot modify built-in tool output (#32105) — observe only
- Hooks execute OUTSIDE Claude's tool context — shell-native only, no MCP/Read/Grep
- Hook timeout: 5s default, 10s max recommended

**Shipping principle: This repo is the template ALL LTC members clone.** Every hook, script, and rule must work on a fresh machine with no Long-specific vault paths, no global hooks assumed, no personal MCP servers. If it depends on `~/Library/CloudStorage/GoogleDrive.../Long-Memory-Vault/`, it does NOT ship in the project — it lives in Long's global `~/.claude/` only.

**Hook cleanup (from 2026-03-30 audit):**
4 project hooks exist in `.claude/hooks/` but are NOT wired in `settings.json`. Root cause: they duplicated Long's global hooks. But these hooks are part of the **memory-vault plugin** and should ship to all LTC members.

Infrastructure already exists:
- `/setup` skill writes `~/.config/memory-vault/config.sh` with `MEMORY_VAULT_PATH`
- `.claude/hooks/lib/config.sh` resolves vault path (3-priority: config file → env var → scan). Graceful exit if no vault.
- `session-summary.sh` and `state-saver.sh` already source `config.sh` — they work today for any member who ran `/setup`
- `session-reconstruct.sh` is missing the `config.sh` source — needs fix
- `strategic-compact.sh` has no vault dependency — just counter + warning

| Hook | Current state | Action |
|---|---|---|
| `session-summary.sh` | Uses config.sh, graceful fallback | **Wire into settings.json** (Stop event) |
| `state-saver.sh` | Uses config.sh, graceful fallback | **Wire into settings.json** (PostToolUse Write\|Edit) |
| `session-reconstruct.sh` | Missing config.sh source | **Fix: add config.sh source + wire** (SessionStart, after resume-check.sh) |
| `strategic-compact.sh` | No vault dependency, counter only | **Wire into settings.json** (PreToolUse) |

Dedup guard: each hook checks `$CLAUDE_PLUGIN_ROOT` — if global version is running, project-level skips. Members with Long's global config get global versions; members without get project versions.

**Overlap audit (MECE check against existing):**

| Existing | Proposed | Verdict |
|----------|----------|---------|
| `validate-frontmatter.sh` — checks version+last_updated on **staged files only** (pre-commit) | D2 frontmatter-extract.sh — **extracts** field values from any file on demand | **Complementary** — existing validates presence at commit; new extracts values at runtime. Different trigger, different purpose |
| `dsbv-gate.sh` — fires on `git commit`, checks workstream boundaries | D3 pre-commit-chain.sh — orchestrates link-validator + registry-sync + changelog-check | **Complementary** — dsbv-gate checks workstream scope; new chain checks artifact integrity. Wire both into same PreToolUse matcher |
| `verify-deliverables.sh` — SubagentStop, checks AC patterns in output | D4 agent-dispatch mitigation — also SubagentStop, checks context packaging | **Merge** — extend verify-deliverables.sh to also check context packaging markers |
| `skill-validator.sh` — fires on commit if SKILL.md staged | D3 pre-commit chain | **No overlap** — skill-validator stays separate, pre-commit chain handles non-skill checks |
| `/obsidian orphans` command | D2 orphan-detect.sh | **Replaces** — script works without app, zero dependency |

---

## Deliverable Structure (6 deliverables, sequenceable)

### D0: Hook Wiring & Fix (ship memory-vault hooks to all members)

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A0a | Fix session-reconstruct.sh | `.claude/hooks/session-reconstruct.sh` | Add dedup guard. NOTE: This script reads `.claude/projects/` (local memory), NOT the vault — no config.sh source needed. | AC-0a: ~~Sources `.claude/hooks/lib/config.sh`~~ REVISED: No vault dependency — reads project-local memory only. AC-0b: Graceful exit if vault not configured (exit 0, no error). AC-0c: Dedup guard present (skip if `$CLAUDE_PLUGIN_ROOT` global version exists) |
| A0b | Wire all 4 hooks | `.claude/settings.json` update | Connect session-summary (Stop), state-saver (PostToolUse), session-reconstruct (SessionStart), strategic-compact (PreToolUse) | AC-0d: `session-summary.sh` fires on Stop event. AC-0e: `state-saver.sh` fires on PostToolUse `Write\|Edit`. AC-0f: `session-reconstruct.sh` fires on SessionStart (after resume-check.sh). AC-0g: `strategic-compact.sh` fires on PreToolUse. AC-0h: All 4 have timeout ≤10s. AC-0i: All 4 have dedup guards. AC-0j: Works on fresh clone where member ran `/setup` — vault writes land in configured path. AC-0k: Works on fresh clone where member did NOT run `/setup` — hooks exit 0 silently, no crash |

### D1: Foundation Scripts (utilities others depend on)

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A1 | backlink-map.sh | `scripts/backlink-map.sh` | Build adjacency list of all [[wikilinks]] in repo — shared utility for A2, A3, A4 | AC-1: Outputs TSV `source\ttarget` for every wikilink. AC-2: Handles `[[alias]]` and `[[path/file]]` syntax. AC-3: Runs in <2s on 500-file repo |
| A2 | frontmatter-extract.sh | `scripts/frontmatter-extract.sh` | Parse YAML frontmatter fields from any .md — shared utility for A6, A8, D3 | AC-4: Given file + field name, outputs value. AC-5: Handles quoted strings. AC-6: Exit 1 if field not found |

### D2: Enforcement Scripts (use D1 utilities)

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A3 | ripple-check.sh | `scripts/ripple-check.sh` | After .md edit: grep depth-1+2 [[backlinks]], output structured list for agent | AC-7: Outputs all depth-1 backlinks for a given file. AC-8: Outputs depth-2 backlinks for each depth-1 result. AC-9: Structured output (path:line:link) parseable by agent. AC-10: Runs in <3s on 500-file repo |
| A4 | link-validator.sh | `scripts/link-validator.sh` | Find broken [[wikilinks]] in staged or specified files | AC-11: Reports broken links (target doesn't exist). AC-12: Exit 0 if clean, exit 1 if broken found |
| A5 | orphan-detect.sh | `scripts/orphan-detect.sh` | Find .md with zero inbound [[backlinks]] — replaces `/obsidian orphans` | AC-13: Lists files with zero backlinks. AC-14: Excludes README, CHANGELOG, index files |
| A6 | rename-ripple.sh | `scripts/rename-ripple.sh` | After file rename: find all [[old-name]] references needing update | AC-15: Given old+new name, greps for [[old-name]]. AC-16: Outputs files+lines with stale refs. AC-17: `--apply` flag auto-replaces (default: report-only) |
| A7 | registry-sync-check.sh | `scripts/registry-sync-check.sh` | Compare staged .md versions against VERSION_REGISTRY.md | AC-18: Checks version field matches registry row. AC-19: Reports mismatches. AC-20: Exit 1 if out-of-sync |
| A8 | status-guard.sh | `scripts/status-guard.sh` | Block commits that set `status: Approved` — human-only field | AC-21: Scans staged .md diffs for `+status: Approved` or `+status: "Approved"`. AC-22: Exit 2 (block) if found. AC-23: Allows human override via `--force-approve` env var |

### D3: Hook Wiring (wire D1+D2 into settings.json)

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A9 | PostToolUse hook config | `.claude/settings.json` update | Wire ripple-check into PostToolUse on Edit/Write of .md | AC-24: PostToolUse fires on `Edit\|Write` matching .md files. AC-25: ripple-check.sh runs and outputs to stdout (agent sees it). AC-26: Timeout 5s, graceful exit on non-.md files |
| A10 | Pre-commit chain update | `.claude/settings.json` update | Add link-validator + registry-sync + status-guard + changelog-check to commit gate | AC-27: All 4 checks fire on `Bash(git commit *)`. AC-28: Existing dsbv-gate.sh + skill-validator.sh preserved (not replaced). AC-29: NEW checks total timeout <15s (pre-existing dsbv-gate + skill-validator are out of scope) |
| A11 | verify-deliverables.sh extension | `.claude/hooks/verify-deliverables.sh` | Extend SubagentStop hook to also check context packaging markers (mitigates #40580) | AC-30: Checks for `## 1. EO` and `## 5. VERIFY` in sub-agent output. AC-31: Documents PreToolUse limitation in header comment. AC-32: Existing AC-pattern checks preserved |

### D4: Documentation & Principles

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A12 | EP-14 Script-First Delegation | `_genesis/reference/ltc-effective-agent-principles-registry.md` (append) | Add EP-14 to the canonical registry alongside EP-01–EP-13 | AC-33: EP-14 follows existing format (Statement, Grounded in, Without this, Compensated by, Patterns, Source). AC-34: Cross-referenced in Part 1 quick reference table. AC-35: Added to Part 4 APEI cross-reference and Part 5 diagnostic table |
| A13 | Hook reliability audit | `_genesis/reference/hook-reliability-audit.md` | Document all known Claude Code hook bugs and LTC mitigations | AC-36: Lists all known bugs with GitHub issue #. AC-37: For each bug, states LTC mitigation. AC-38: States what hooks CAN vs CANNOT reliably do |

### D5: Skill Updates

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A14 | /vault-capture skill | `.claude/skills/vault-capture/SKILL.md` | Dump research/chat to inbox/ with minimal frontmatter | AC-39: `/vault-capture "title"` writes `inbox/{date}_{slug}.md`. AC-40: Adds frontmatter (date, type, source, tags). AC-41: `--to learn` flag writes to `2-LEARN/research/` with full governance |
| A15 | Obsidian skill routing update | `.claude/skills/obsidian/SKILL.md` (edit) | Narrow to graph-only; search is not primary use case | AC-42: `search:context` demoted from primary to fallback. AC-43: Backlinks/outgoing-links/orphans positioned as unique value. AC-44: 3-tool routing table updated: QMD→Grep→Obsidian(graph only) |

---

## Alignment Check

```
Deliverables: 6 (D0-D5)
Artifacts:    17 (A0a-A0b + A1-A15)
ACs:          55 (AC-0a through AC-0k + AC-1 through AC-44)
Orphan ACs:   0 (every AC maps to an artifact)
Orphan artifacts: 0 (every artifact has ≥1 AC)

Trace:
  D0:    hook cleanup (ship-ready for LTC members — no Long-specific paths)
  D1-D2: script gap (5 behind Tier 3 baseline)
  D3:    hook gap (no PostToolUse, no pre-commit chain, no status enforcement)
  D4:    EP registry extension + reliability documentation
  D5:    vault-capture (ephemeral content loss) + obsidian routing (mismatch with reality)

Shipping constraint:
  Every artifact in D0-D5 must work on a fresh LTC member clone.
  No ~/Library/CloudStorage/, no ~/.claude/hooks/scripts/, no personal MCP.
  If it needs Long-specific infra, it belongs in Long's global config, not here.
```

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Sequential single-agent — scripts are deterministic, no competing hypotheses |
| Why this pattern | Shell scripts have clear specs (input→output). No judgment needed. |
| Agent config | Main context for D1-D3 (shell code). Main context for D4-D5 (doc/skill edits). No sub-agents needed. |
| Git strategy | Commit per deliverable on this branch (I2/feat/obsidian-bases) |
| Human gates | G1=this DESIGN. G2=SEQUENCE ordering. G3=review scripts before commit. G4=validate 44 ACs |
| Cost estimate | ~20K tokens total. D1-D2: ~8K (shell code). D3: ~3K (config edits). D4: ~5K (docs). D5: ~4K (skill edits) |

---

## Dependencies

| Dependency | From | Status |
|---|---|---|
| Wikilinks (276 files) | I1 autolinker (merged to main) | Ready |
| Frontmatter (293 files) | I1 + I2 migrate-status.sh | Ready |
| Hook system (settings.json) | Claude Code platform | Ready (bugs documented in D4) |
| VERSION_REGISTRY.md | _genesis/ | Ready |
| verify-deliverables.sh v1.0 | .claude/hooks/ | Ready (D3 extends it) |
| EP registry (EP-01–EP-13) | _genesis/reference/ | Ready (D4 appends EP-14) |
| validate-frontmatter.sh | .claude/hooks/ | Ready (not modified — complementary) |
| dsbv-gate.sh + skill-validator.sh | scripts/ | Ready (not modified — D3 adds alongside) |
| Filesystem-blueprint worktree | worktree-I2+plan+filesystem-blueprint | No conflict — purely structural |

---

## Human Gates

| Gate | Trigger | Decision Required |
|------|---------|-------------------|
| G1 | Design complete | Approve this DESIGN.md |
| G2 | Sequence complete | Approve build order |
| G3 | Build complete | Review all scripts (security, correctness) |
| G4 | Validate complete | All 55 ACs pass |

---

## Readiness (C1-C6)

| ID | Condition | Status |
|----|-----------|--------|
| C1 | Clear scope | GREEN |
| C2 | Input materials curated | GREEN — 6 explorer reports + full hook/script audit |
| C3 | Success rubric | GREEN — 55 binary ACs |
| C4 | Process loaded | GREEN |
| C5 | Prompt engineered | GREEN |
| C6 | Evaluation protocol | GREEN — scripts testable via bash; rules reviewable by human |

---

## Risk Register

| Risk | Cat | Prob | Impact | Mitigation |
|------|-----|------|--------|------------|
| PostToolUse doesn't inject context reliably (#37559) | Technical | Medium | HIGH | D4 documents; fallback: agent reads output file |
| Hooks stop after compaction (#25655) | Technical | Medium | HIGH | D4 documents; human restarts session for critical enforcement |
| status-guard.sh false positive on legitimate human approve | Human | Low | MEDIUM | `--force-approve` env var override (AC-23) |
| Pre-commit chain too slow (>15s cumulative) | Economic | Low | LOW | AC-29 enforces <15s; each script <2s |
| Wikilink coverage 61% — ripple-check has blind spots | Technical | Low | MEDIUM | A5 orphan-detect identifies gaps; re-run autolinker |
| EP-14 in registry creates maintenance burden | Temporal | Low | LOW | Same format as EP-01–13; single file, single update point |

---

## What This DESIGN Does NOT Cover

1. **/vault-promote** — I3 (inbox/ → workstream promotion with governance)
2. **Hermes Agent** — WATCH LIST, revisit at v1.0
3. **QMD repo indexing** — Grep is better (per today's analysis)
4. **Auto-skill-creation from DSBV** — separate DSBV cycle
5. **Cross-project .claude/ sync** — I3+
6. **Obsidian Bases dashboard content** — separate branch work

---

## Links

- [[alpei-chain-of-custody]]
- [[agent-dispatch]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[dsbv]]
- [[enforcement-layers]]
- [[EP-14]]
- [[git-conventions]]
- [[ltc-effective-agent-principles-registry]]
- [[obsidian-security]]
- [[SEQUENCE]]
- [[tool-routing]]
- [[VALIDATE]]
- [[VERSION_REGISTRY]]
- [[versioning]]
