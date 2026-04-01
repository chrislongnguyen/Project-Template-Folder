---
version: "1.0"
status: Draft
last_updated: 2026-04-01
owner: Long Nguyen
workstream: "EXECUTE workstream"
feature: "Obsidian CLI Integration — Build Sequence"
aliases: ["EXECUTE Sequence", "Obsidian Build Order"]
---

# SEQUENCE: Obsidian CLI Integration (I1)

Source: `4-EXECUTE/DESIGN.md` v1.8 (8 artifacts, 44 ACs)

---

## Dependency Graph

```
T1 [A7 Test Suite]
 │
 ├── T2 [A1 ADR-002]  (standalone after T1)
 │
 └── T3 [A4 Security Rule]
      │
      T4 [A2 SKILL.md]
      ├────────┬────────┐
      │        │        │
 T5 [A3]  T6 [A5]  T7a [A6a Autolinker]
 Vault    Routing      │
                   T7b [A6b Frontmatter Injection]
                        │
                   T8 [A8 Template Routing Rule]
```

**Critical path:** T1 → T3 → T4 → T7a → T7b → T8

---

## Task Summary

| # | Task | Artifact | Path | Size | ACs | Input | Checkpoint Commit |
|---|------|----------|------|------|-----|-------|-------------------|
| T1 | Test suite (red) | A7 | `4-EXECUTE/tests/obsidian/` | L | AC-01..AC-11 | DESIGN.md v1.8 | `feat(execute): add obsidian test suite (red)` |
| T2 | ADR-002 update | A1 | `1-ALIGN/decisions/ADR-002-obsidian-cli.md` | S | AC-12..AC-15 | A/B data, RICE HTML, Vinh analysis | `docs(align): update ADR-002 with RICE evidence and Vinh strategy` |
| T3 | Security rule | A4 | `.claude/rules/obsidian-security.md` | M | AC-16..AC-20 | Existing rule (rescued) | `feat(rules): amend obsidian security rule AP1-AP5 + write-path` |
| T4 | SKILL.md rewrite | A2 | `.claude/skills/obsidian/SKILL.md` | L | AC-21..AC-31 | A4 (security refs), existing SKILL.md | `feat(skills): rewrite obsidian SKILL.md — 10 RICE features` |
| T5 | Vault scaffold | A3 | `4-EXECUTE/src/vault/` | M | AC-32..AC-34 | A2 (SKILL.md commands) | `feat(execute): add obsidian vault scaffold Option C` |
| T6 | Tool routing update | A5 | `rules/tool-routing.md` | S | AC-35..AC-37 | A2 (SKILL.md commands) | `feat(rules): add obsidian-cli to tool routing hierarchy` |
| T7a | Autolinker wikilinks | A6 | `scripts/obsidian-autolinker.py` | M | AC-38..AC-40 | A2 (command list for link targets) | `feat(execute): autolinker wikilink injection` |
| T7b | Frontmatter injection | A6 | `scripts/inject-frontmatter.py` | M | AC-41 | Vinh schema, 27 templates list | `feat(execute): inject Vinh frontmatter schema into templates` |
| T8 | Template routing rule | A8 | `.claude/rules/alpei-template-usage.md` | S | AC-42..AC-44 | A6 (frontmatter fields), Vinh rule reference | `feat(rules): add ALPEI template routing rule` |

**Total: 9 tasks** (A6 split into T7a + T7b). All sizes ≤ L.

---

## Task Details

### T1 — Test Suite (A7) — RED TESTS

**Input:** DESIGN.md v1.8 ACs, binary test commands for each artifact
**What to produce:**
- 10 test scripts in `4-EXECUTE/tests/obsidian/`:
  - `ab-retest.sh` (AC-01, AC-02)
  - `test-skill-syntax.sh` (AC-03)
  - `test-security-rule.sh` (AC-04)
  - `test-fallback.sh` (AC-05)
  - `test-adr.sh` (AC-06)
  - `test-vault-scaffold.sh` (AC-07)
  - `test-tool-routing.sh` (AC-08)
  - `test-frontmatter-schema.sh` (AC-09)
  - `test-template-routing.sh` (AC-10)
  - `run-all.sh` (AC-11) — runs all 10, produces pass/fail summary table
- All scripts executable (`chmod +x`)
- Tests WILL FAIL (red) — artifacts don't exist yet

**Binary test:** `bash 4-EXECUTE/tests/obsidian/run-all.sh` executes without crash (exits with failure count, not error)
**Commit:** `feat(execute): add obsidian test suite (red)`

---

### T2 — ADR-002 Update (A1) — STANDALONE

**Input:** Existing ADR-002, A/B data (3.6x, 18%, 32%), RICE HTML, Vinh analysis
**What to produce:**
- Update `1-ALIGN/decisions/ADR-002-obsidian-cli.md`
- Status = Approved, Decision = Option B
- RICE evidence section citing A/B metrics
- AP4 opt-out rationale (L8)
- Vinh adoption strategy (extend templates, not copy)

**Binary test:** `bash 4-EXECUTE/tests/obsidian/test-adr.sh` passes (AC-06 green). AC-12..AC-15 grep checks pass.
**Commit:** `docs(align): update ADR-002 with RICE evidence and Vinh strategy`

---

### T3 — Security Rule (A4)

**Input:** Existing `.claude/rules/obsidian-security.md` (rescued), DESIGN.md AC-16..AC-20
**What to produce:**
- AP1-AP5 anti-patterns with rule + reason + enforcement
- AP4 opt-OUT model with `cli-blocked: true`
- Write-path whitelist (V5)
- .claude/ hybrid sweep rule (L9)
- Layer discipline (V7)

**Binary test:** `bash 4-EXECUTE/tests/obsidian/test-security-rule.sh` passes (AC-04 green). AC-16..AC-20 grep checks pass.
**Commit:** `feat(rules): amend obsidian security rule AP1-AP5 + write-path`

---

### T4 — SKILL.md Rewrite (A2)

**Input:** A4 (security rule — for cross-references), existing SKILL.md (rescued), DESIGN.md AC-21..AC-31
**What to produce:**
- Complete rewrite of `.claude/skills/obsidian/SKILL.md`
- `key=value` syntax throughout (no `--flag`)
- Remove `graph:walk`
- Document: `search:context`, `orphans`, backlinks + outgoing-links chaining, AP4 opt-out, vault targeting warning, 3-tool routing, graceful degradation, .claude/ grep sweep
- Must pass `./scripts/skill-validator.sh`

**Binary test:** `bash 4-EXECUTE/tests/obsidian/test-skill-syntax.sh` + `bash 4-EXECUTE/tests/obsidian/test-fallback.sh` pass (AC-03, AC-05 green). Run `run-all.sh` — AC-21..AC-31 all pass.
**Commit:** `feat(skills): rewrite obsidian SKILL.md — 10 RICE features`

---

### T5 — Vault Scaffold (A3)

**Input:** A2 (SKILL.md — for CLI registration instructions in VAULT_GUIDE)
**What to produce:**
- `4-EXECUTE/src/vault/` with folders: `daily/`, `projects/`, `agents/`, `research/`, `inbox/`, plus root files
- Each subfolder has `README.md` with `zone:` and `subsystem:` frontmatter
- `VAULT_GUIDE.md` covering CLI registration, fallback mode, Option C flat structure

**Binary test:** `bash 4-EXECUTE/tests/obsidian/test-vault-scaffold.sh` passes (AC-07 green). AC-32..AC-34.
**Commit:** `feat(execute): add obsidian vault scaffold Option C`

---

### T6 — Tool Routing Update (A5)

**Input:** A2 (SKILL.md — for command names and hierarchy)
**What to produce:**
- Add `obsidian-cli` row to `rules/tool-routing.md`
- Document 3-tool hierarchy: QMD → Obsidian → grep
- Add .claude/ mandatory grep sweep note

**Binary test:** `bash 4-EXECUTE/tests/obsidian/test-tool-routing.sh` passes (AC-08 green). AC-35..AC-37.
**Commit:** `feat(rules): add obsidian-cli to tool routing hierarchy`

---

### T7a — Autolinker Wikilinks (A6, part 1)

**Input:** A2 (command list for link targets), existing `scripts/obsidian-autolinker.py` (rescued — wikilinks only)
**What to produce:**
- Update/validate `scripts/obsidian-autolinker.py`
- Ensure `scripts/obsidian-alias-seeder.py` exists and is valid Python
- Dry-run mode works without error
- At least 1 wikilink injected into a sample template file

**Binary test:** AC-38..AC-40 pass. `python3 -c "import ast; ast.parse(open('scripts/obsidian-autolinker.py').read())"` exits 0. Dry-run exits 0. Diff shows `[[` added.
**Commit:** `feat(execute): autolinker wikilink injection`

---

### T7b — Frontmatter Injection (A6, part 2) — NEW FUNCTIONALITY

**Input:** Vinh's frontmatter schema (4 fields: `type`, `work_stream`, `stage`, `sub_system`), list of 27 `_genesis/templates/*.md` files
**What to produce:**
- New script: `scripts/inject-frontmatter.py`
- Reads each `_genesis/templates/*.md` file
- Injects 4 missing frontmatter fields (with sensible defaults per template)
- Idempotent — running twice does not duplicate fields
- ≥ 20 of 27 templates have all 4 fields after run

**Binary test:** `bash 4-EXECUTE/tests/obsidian/test-frontmatter-schema.sh` passes (AC-09 green). AC-41 check: ≥ 20 templates have both `work_stream` and `sub_system`.
**Commit:** `feat(execute): inject Vinh frontmatter schema into templates`

---

### T8 — Template Routing Rule (A8)

**Input:** A6 (know which templates got frontmatter), Vinh's `.claude/rules/alpei-template-usage.md` (reference)
**What to produce:**
- New file: `.claude/rules/alpei-template-usage.md`
- YAML frontmatter (version: "1.0", status: Draft, last_updated: 2026-04-01)
- Quick reference table: 5 workstreams (ALIGN, LEARN, PLAN, EXECUTE, IMPROVE) × 4 DSBV stages
- Template names reference our `_genesis/templates/` files (not Vinh's naming)

**Binary test:** `bash 4-EXECUTE/tests/obsidian/test-template-routing.sh` passes (AC-10 green). AC-42..AC-44.
**Commit:** `feat(rules): add ALPEI template routing rule`

---

## AC Coverage Matrix

| AC Range | Artifact | Task | Status |
|----------|----------|------|--------|
| AC-01..AC-11 | A7 Test Suite | T1 | Covered |
| AC-12..AC-15 | A1 ADR-002 | T2 | Covered |
| AC-16..AC-20 | A4 Security Rule | T3 | Covered |
| AC-21..AC-31 | A2 SKILL.md | T4 | Covered |
| AC-32..AC-34 | A3 Vault Scaffold | T5 | Covered |
| AC-35..AC-37 | A5 Tool Routing | T6 | Covered |
| AC-38..AC-40 | A6 Autolinker | T7a | Covered |
| AC-41 | A6 Frontmatter | T7b | Covered |
| AC-42..AC-44 | A8 Template Routing | T8 | Covered |

**All 44 ACs covered. Zero orphans.**

---

## Execution Checklist

After EVERY task checkpoint:
1. Run `bash 4-EXECUTE/tests/obsidian/run-all.sh` — record green count
2. Stage files explicitly (no `git add .`)
3. Commit with the message from the task table
4. Expected green progression: T1=0, T2=1, T3=2, T4=4, T5=5, T6=6, T7a=7, T7b=8, T8=9 (of 10; ab-retest requires live Obsidian)

---

## Session Plan

| Session | Tasks | Est. Time | Exit Condition |
|---------|-------|-----------|----------------|
| S1 | T1, T2, T3 | 3-4 hr | A7+A1+A4 committed, run-all.sh runs, 2 tests green |
| S2 | T4, T5, T6 | 3-4 hr | A2+A3+A5 committed, 6 tests green |
| S3 | T7a, T7b, T8 | 3-4 hr | A6+A8 committed, 9 tests green, ready for G3 |

**Agent config:** ltc-builder (Sonnet) for all Build tasks. ltc-reviewer (Opus) for G4 Validate.

## Links

- [[ADR-002]]
- [[ADR-002-obsidian-cli]]
- [[AP4]]
- [[CLAUDE]]
- [[DESIGN]]
- [[README]]
- [[SKILL]]
- [[VALIDATE]]
- [[VAULT_GUIDE]]
- [[alpei-template-usage]]
- [[anti-patterns]]
- [[dsbv]]
- [[ltc-builder]]
- [[ltc-reviewer]]
- [[obsidian-security]]
- [[security]]
- [[task]]
- [[tool-routing]]
- [[workstream]]
