---
version: "1.0"
status: Draft
last_updated: 2026-04-05
owner: Long Nguyen
workstream: GOVERN
iteration: I2
type: ues-deliverable
work_stream: 0-govern
stage: design
---
# DESIGN.md — GOVERN: /setup Skill (Vault + QMD + Smoke Test)

> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.
> Placement: `_genesis/` — GOVERN patches skip per-workstream folders.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Upstream sufficient? | YES — GOVERN exception. Input: `.claude/hooks/lib/config.sh` (vault resolution — Priority 1 reads `~/.config/memory-vault/config.sh`), `setup-vault.sh` (vault folder scaffold — idempotent), QMD MCP server status, existing `/init` skill (model), multi-agent-setup-guide.md (onboarding flow) |
| Q2: In scope? | (1) `/setup` skill SKILL.md — guided onboarding, (2) `scripts/smoke-test.sh` — harness health check, (3) QMD index step (graceful skip if not installed) |
| Q2b: Out of scope? | Modifying config.sh or setup-vault.sh (they work; /setup calls them), QMD installation (user's responsibility), modifying vault folder structure |
| Q3: Go/No-Go | GO |

---

## Design Decisions

**Intent:** The memory-vault hook system ships with the template, but new members have no guided path to configure it. Currently, a member must: (1) manually find and run setup-vault.sh, (2) manually write `~/.config/memory-vault/config.sh`, (3) hope QMD is indexed, (4) have no way to verify the harness works. `/setup` closes this onboarding gap with a single skill invocation.

**What /setup does (sequential steps):**

```
Step 1 — Vault path configuration
  Ask: "Where is your memory vault? (path or leave blank to auto-detect)"
  If provided: write ~/.config/memory-vault/config.sh with MEMORY_VAULT_PATH=<path>
  If blank: call resolve_vault logic (Priority 3 scan) — if found, confirm and write config.
  If not found: create ~/Long-Memory-Vault/ as default, write config.

Step 2 — Vault folder scaffold
  Call: ./scripts/setup-vault.sh <VAULT_PATH>
  This is idempotent — safe if vault already exists.
  Output: folder count + confirmation.

Step 3 — QMD index (graceful skip)
  Check: is qmd installed? (which qmd OR mcp__qmd__status)
  If YES: run qmd index <VAULT_PATH> (or instruct user to run it)
  If NO: print note — "QMD not found — skip. Install from Extension Registry for semantic search."

Step 4 — Smoke test
  Run: ./scripts/smoke-test.sh
  Verify: 5 checks (see D2 design below).
  Report: pass/fail per check with one-line fix hint for each failure.
```

**Idempotency:** Running `/setup` twice is safe. Config file write is idempotent (overwrites same value). setup-vault.sh uses `mkdir -p` + `touch`. QMD index is additive.

**Fresh clone guarantee:** No Long-specific paths hardcoded. Vault path is configured by the member. QMD is optional.

**Smoke test design (5 checks):**

| Check | What it tests | Pass criterion | Fix hint |
|---|---|---|---|
| S1 | Config file exists | `~/.config/memory-vault/config.sh` present | Run /setup step 1 |
| S2 | Vault path resolves | `resolve_vault` finds a valid directory | Check path in config file |
| S3 | Vault folders exist | inbox/, AI-AGENT-MEMORY/ present in vault | Run ./scripts/setup-vault.sh |
| S4 | Pre-commit scripts pass dry-run | `./scripts/status-guard.sh` + `./scripts/link-validator.sh` exit 0 on clean repo | Check script permissions |
| S5 | settings.json hooks present | PostToolUse + SubagentStop + SessionStart all wired | Pull latest from branch |

The smoke test is standalone — it runs without Claude Code, just bash. Members can verify the harness at any time with `./scripts/smoke-test.sh`.

**Overlap audit:**
| Existing | Proposed | Verdict |
|---|---|---|
| `setup-vault.sh` — creates vault folders | /setup Step 2 calls this | **No change** — /setup is the wrapper skill, script unchanged |
| `config.sh` — resolves vault path | /setup Step 1 writes the config file that config.sh reads | **Complementary** — /setup configures, config.sh resolves |
| `/init` skill — scaffolds new project | /setup — configures harness for existing clone | **Complementary** — /init is for new projects, /setup is post-clone onboarding |

---

## Deliverable Structure (2 deliverables)

### D1: /setup Skill

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A1 | /setup SKILL.md | `.claude/skills/setup/SKILL.md` | Guided 4-step onboarding for new LTC members | AC-1: Trigger: user says `/setup` or "set up my vault" or "configure memory vault". AC-2: Step 1 configures vault path — writes `~/.config/memory-vault/config.sh`. AC-3: Step 1 uses resolve_vault fallback if user leaves blank. AC-4: Step 2 calls `./scripts/setup-vault.sh` with configured path. AC-5: Step 3 checks for QMD — skips gracefully if not installed. AC-6: Step 4 runs `./scripts/smoke-test.sh` and reports results. AC-7: Final report shows pass/warn/fail for all 5 smoke checks. AC-8: Skill is idempotent — running twice produces no errors and no duplicate folders. AC-9: Works on fresh clone (no personal paths hardcoded in skill text). |

### D2: Smoke Test Script

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A2 | smoke-test.sh | `scripts/smoke-test.sh` | Standalone harness health check — runs 5 checks, prints pass/fail per check | AC-10: S1 check — verifies `~/.config/memory-vault/config.sh` exists. AC-11: S2 check — sources config.sh and verifies VAULT resolves to existing directory. AC-12: S3 check — verifies inbox/ and AI-AGENT-MEMORY/ present in vault. AC-13: S4 check — runs status-guard.sh and link-validator.sh in dry-run mode, exit 0 expected. AC-14: S5 check — verifies 3 hook events present in settings.json (PostToolUse, SubagentStop, SessionStart). AC-15: Exit 0 if all pass. Exit 1 if any fail. AC-16: Each failing check prints one-line fix hint. AC-17: Runs in <5s on any LTC member machine. |

---

## Alignment Check

```
Deliverables: 2 (D1-D2)
Artifacts:    2 (A1-A2)
ACs:          17 (AC-1 through AC-17)
Orphan ACs:   0
Orphan artifacts: 0

Trace:
  D1: Onboarding gap — members have no guided path from fresh clone to working harness
  D2: Verification gap — no way to check the harness is healthy without running the whole session

Shipping constraint:
  Both artifacts must work on fresh clone with no Long-specific infra.
  QMD integration is graceful-skip — not required for smoke test pass.
```

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Sequential single-agent — skill text + shell script |
| Agent config | Main context only — small artifacts, clear specs |
| Git strategy | 1 commit: `feat(skills): /setup skill + smoke-test.sh` |
| Human gates | G1=this DESIGN. G2=SEQUENCE ordering. G3=review before commit. G4=validate 17 ACs |
| Cost estimate | ~10K tokens total |

---

## Dependencies

| Dependency | Status |
|---|---|
| `.claude/hooks/lib/config.sh` — vault resolution | Ready |
| `scripts/setup-vault.sh` — vault folder scaffold (migrated from `4-EXECUTE/scripts/`) | Ready |
| `scripts/status-guard.sh` + `scripts/link-validator.sh` — smoke test S4 | Ready |
| `.claude/settings.json` — smoke test S5 | Ready |

---

[[DESIGN]]
[[setup]]
[[vault]]
[[smoke-test]]
[[govern]]
[[onboarding]]
