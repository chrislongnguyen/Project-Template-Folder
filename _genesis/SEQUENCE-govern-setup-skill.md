---
version: "1.0"
status: draft
last_updated: 2026-04-05
owner: Long Nguyen
workstream: GOVERN
iteration: I2
type: ues-deliverable
work_stream: 0-GOVERN
stage: sequence
---
# SEQUENCE.md — GOVERN: /setup Skill (Vault + QMD + Smoke Test)

> DSBV Phase 2 artifact. Approved DESIGN.md (v1.0) is the input.

## Dependency Graph

```
T1 (smoke-test.sh) ──→ T2 (/setup SKILL.md)
```

T1 before T2: smoke-test.sh path must be confirmed on disk before SKILL.md
references it in Step 4 text. Both are small (~S), single-agent sequential.

## Task Sequence

| # | Task | Artifact | Depends On | Size | ACs |
|---|------|----------|-----------|------|-----|
| T1 | Write smoke-test.sh — 5-check harness verifier | `scripts/smoke-test.sh` | None (first) | S (~25 min) | AC-10 to AC-17 |
| T2 | Write /setup SKILL.md — guided 4-step onboarding | `.claude/skills/setup/SKILL.md` | T1 (path confirmed) | S (~20 min) | AC-1 to AC-9 |

**Sizes:** S = <30 min

---

## Task Detail

### T1 — smoke-test.sh

**Input:** DESIGN.md §Smoke test design (5-check table), `scripts/status-guard.sh` and
`scripts/link-validator.sh` (existing), `.claude/hooks/lib/config.sh` (vault resolution logic),
`.claude/settings.json` (hook structure to grep).

**What to build:**

```bash
# 5 checks, print ✓ PASS / ✗ FAIL per check, exit 1 if any fail
S1: [ -f ~/.config/memory-vault/config.sh ]
S2: source config.sh → resolve_vault() → [ -d "$VAULT" ]
S3: [ -d "$VAULT/inbox" ] && [ -d "$VAULT/AI-AGENT-MEMORY" ]
S4: ./scripts/status-guard.sh (no staged files → exit 0) &&
    ./scripts/link-validator.sh --staged (no staged files → exit 0)
S5: grep -q "PostToolUse" .claude/settings.json &&
    grep -q "SubagentStop" .claude/settings.json &&
    grep -q "SessionStart" .claude/settings.json
```

**Acceptance criteria (from DESIGN):**
- AC-10: S1 check — verifies config file exists
- AC-11: S2 check — resolve_vault finds valid directory
- AC-12: S3 check — inbox/ and AI-AGENT-MEMORY/ present in vault
- AC-13: S4 check — status-guard.sh + link-validator.sh exit 0 on clean repo
- AC-14: S5 check — 3 hook events present in settings.json
- AC-15: Exit 0 if all pass, exit 1 if any fail
- AC-16: Each failing check prints one-line fix hint
- AC-17: Runs in <5s

**Self-verify before done:**
```bash
bash -n scripts/smoke-test.sh   # syntax check
chmod +x scripts/smoke-test.sh
./scripts/smoke-test.sh          # live run — expect all 5 PASS on this machine
```

---

### T2 — /setup SKILL.md

**Input:** smoke-test.sh path confirmed (T1 done), `.claude/hooks/lib/config.sh` (Step 1
config write pattern), `scripts/setup-vault.sh` (Step 2 call), `/init` skill model
(`~/.claude/skills/init/SKILL.md`), DESIGN.md §What /setup does.

**What to build:**

SKILL.md structure:
```
---
name: setup
version: 1.0
description: ...
---
# /setup — LTC Harness Onboarding

Trigger: /setup | "set up my vault" | "configure memory vault"

## Steps
Step 1 — Vault path configuration   (ask → write config.sh)
Step 2 — Vault folder scaffold       (call setup-vault.sh)
Step 3 — QMD index                   (graceful skip if not installed)
Step 4 — Smoke test                  (run scripts/smoke-test.sh, report)

## Final Report
[pass/warn/fail table per smoke check]

## Idempotency note
## Error handling
```

**Acceptance criteria (from DESIGN):**
- AC-1: Trigger phrases present
- AC-2: Step 1 writes `~/.config/memory-vault/config.sh`
- AC-3: Step 1 resolve_vault fallback if blank input
- AC-4: Step 2 calls `./scripts/setup-vault.sh`
- AC-5: Step 3 graceful QMD skip
- AC-6: Step 4 runs `./scripts/smoke-test.sh`
- AC-7: Final report shows 5 smoke check results
- AC-8: Idempotency documented
- AC-9: No personal paths hardcoded

**Self-verify before done:**
```bash
./scripts/skill-validator.sh .claude/skills/setup/   # EOP-GOV gate
```

---

## Build Strategy

| Field | Value |
|-------|-------|
| Pattern | Sequential single-agent (main context) |
| Order | T1 → T2 (T2 references T1 path) |
| Commit | 1 commit after both tasks pass: `feat(skills): /setup skill + smoke-test.sh` |
| Human gate | G2 = this SEQUENCE. G3 = review T1+T2 before commit. G4 = ltc-reviewer validates 17 ACs |
