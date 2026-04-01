---
version: "1.1"
status: Draft
owner: Long Nguyen
last_updated: 2026-03-29
iteration: "I1: Concept"
derived_from: [2026-03-29-restructuring-vana-spec.md, 2026-03-29-i1-artifact-flow-design.md, project_restructuring_design.md]
---
# I1 Repo Restructuring — SEQUENCE

> **DSBV Phase 2 of 4.** Defines task ordering, agent team, file domains, gates, and git strategy for the restructuring Build.
>
> **Prerequisite:** Learn-skill refactor COMPLETE (db69c93). All 24 ACs pass.
> **Input:** VANA-SPEC (`2026-03-29-restructuring-vana-spec.md`) — 26 I1 ACs + 1 patched (V-10b). 20 deterministic, 7 manual.
> **Output:** Approved execution plan → BUILD phase.
>
> **Risk review (v1.1):** 7 risks identified during DESIGN↔SEQUENCE cross-reference audit. All mitigated below. See §9 for full risk register.

---

## 1. Git Strategy

```
main (UNTOUCHED until G5)
  └── feat/restructuring-i1 (single worktree: restructuring-build)
        ├── Phase 1: commit 1 — skills consolidation + zone cleanup
        ├── Phase 2: commit 2 — _genesis structure + content
        ├── Phase 3: commit 3 — docs dissolution + stale cleanup
        ├── Phase 4: commit 4 — cross-reference updates
        └── Phase 5: commit 5 — validation fixes (if any)
                         ↓
                      PR → main (only after G5 ALL PASS)
```

**Rules:**
- All work happens on `feat/restructuring-i1` branch in one worktree
- Parallel agents within a phase use `isolation: "worktree"` (sub-worktrees off the feature branch)
- Orchestrator merges sub-worktree changes to `feat/restructuring-i1` at each gate
- Nothing touches `main` until final validation passes
- Maximum 5 commits (SAdj-05 constraint)

---

## 2. Agent Pattern

**Composite (Pattern 9):** Parallel Fan-Out within phases + Sequential Pipeline across phases + Human-in-the-Loop at gates.

**Why not simpler:**
- Single agent: context bloat across 26 ACs, ~5 sessions → 2-3 with parallelism
- Fully parallel (1 per AC): merge conflicts, coordination overhead exceeds benefit

**Why not more complex:**
- No dynamic decomposition needed (tasks are known)
- No quality iteration loops (file moves are deterministic)
- Orchestrator-Workers overkill for mechanical operations

---

## 3. Agent Team

| Agent | ID | Model | Role | File Domain (exclusive) |
|-------|----|-------|------|------------------------|
| Orchestrator | — | Opus | Coordinate, merge, gate reviews | All (read), merge commits |
| A | skills-migration | Haiku | Move all skills to `.claude/skills/` (incl. plugin skills) | `.claude/skills/`, `1-ALIGN/skills/`, `2-PLAN/skills/`, `3-EXECUTE/skills/`, `4-IMPROVE/skills/`, `skills/`, `.agents/skills/`, `plugins/memory-vault/skills/` |
| B | plugin-and-cleanup | Haiku | Dissolve plugins/ (move hooks→scripts→ then delete), delete stale dirs, remove zones 2-4 learning/ | `plugins/memory-vault/hooks/`, `plugins/memory-vault/scripts/`, `.claude/hooks/`, `scripts/` (plugin scripts only), `.exec/`, `.claude-plugin/`, `hooks/` (root), `2-PLAN/learning/`, `3-EXECUTE/learning/`, `4-IMPROVE/learning/` |
| C | genesis-rename | Haiku | `git mv _shared → _genesis`, create 11 subdirs | `_shared/` → `_genesis/` (rename only) |
| D | genesis-content | Sonnet | Write 11 READMEs, add frontmatter, cascade doc | `_genesis/**/*.md` (content, not structure; EXCLUDES `_genesis/templates/`) |
| E | dsbv-updates | Sonnet | Rewrite DSBV_PROCESS.md + DESIGN.md template | `_genesis/templates/DSBV_PROCESS.md`, `_genesis/templates/DESIGN_TEMPLATE.md` |
| F | docs-dissolution | Haiku | Move docs/ + root .pptx to destinations, delete docs/ | `docs/`, `1-ALIGN/learning/research/`, `_genesis/reference/`, root `.pptx` |
| G | ref-updates | Haiku | Update CLAUDE.md + README.md references | `CLAUDE.md`, `README.md` |
| H | all-stale-refs | Sonnet | Update ALL stale path refs (`_shared/` → `_genesis/`, `docs/superpowers/` → `2-PLAN/architecture/`) across skills, rules, and .claude/rules/ | `.claude/skills/**/*.md`, `rules/**/*.md`, `.claude/rules/**/*.md` (refs only) |
| I | validator | Sonnet | Run all 20 deterministic ACs, report pass/fail | Read-only + `./scripts/` |

**Model rationale:**
- Haiku: Mechanical file moves, deletions (low reasoning, high volume)
- Sonnet: Content generation (READMEs, DSBV rewrites), comprehensive ref updates (needs grep + judgment), validation synthesis
- Opus: Orchestration decisions, gate reviews, conflict resolution

**Agent H upgrade rationale (R3, R7):** Promoted Haiku → Sonnet. Scope expanded from `docs/superpowers/` only (which doesn't exist) to ALL stale refs including `_shared/` → `_genesis/`. Needs judgment to distinguish path refs from content mentions.

---

## 4. Phase Execution

### Phase 1 — Skills Consolidation + Plugin Dissolution + Zone Cleanup

**Parallel:** Agent A ∥ Agent B (zero file overlap — A handles skill dirs, B handles plugin infra + stale dirs)

```
Agent-A (skills-migration)          Agent-B (plugin-and-cleanup)
  │                                   │
  ├─ Create 9 category dirs           ├─ MOVE (before delete!):
  │  in .claude/skills/               │  ├─ git mv plugins/memory-vault/hooks/*.sh
  ├─ git mv each skill to             │  │  → .claude/hooks/
  │  correct category                 │  ├─ git mv plugins/memory-vault/hooks/lib/
  │  (incl. plugins/memory-vault/     │  │  → .claude/hooks/lib/
  │   skills/* → session/)            │  ├─ git mv plugins/memory-vault/hooks/hooks.json
  ├─ Delete empty source dirs         │  │  → .claude/hooks/
  └─ Verify N-02 (9 dirs)            │  ├─ git mv plugins/memory-vault/scripts/*.py
                                      │  │  → scripts/
                                      │  └─ git mv plugins/memory-vault/scripts/*.sh
                                      │     → scripts/
                                      ├─ DELETE (only after moves verified):
                                      │  ├─ rm -rf plugins/ (now empty)
                                      │  ├─ rm -rf .exec/
                                      │  ├─ rm -rf .claude-plugin/
                                      │  └─ rm -rf hooks/ (root, if empty)
                                      ├─ REMOVE learning/ from zones 2-4:
                                      │  ├─ rm -rf 2-PLAN/learning/
                                      │  ├─ rm -rf 3-EXECUTE/learning/
                                      │  └─ rm -rf 4-IMPROVE/learning/
                                      └─ Verify: plugins/ gone, hooks at new paths
```

**Agent-A context package:**
- VANA-SPEC §2: V-01, N-02 only
- `project_restructuring_design.md` → Skills section (incl. plugin dissolution: skills → `.claude/skills/session/`)
- Current skill registry (paste into prompt):
  ```
  ./plugins/memory-vault/skills/compress/SKILL.md      → .claude/skills/session/compress/
  ./plugins/memory-vault/skills/session-start/SKILL.md  → .claude/skills/session/session-start/
  ./plugins/memory-vault/skills/resume/SKILL.md         → .claude/skills/session/resume/
  ./plugins/memory-vault/skills/session-end/SKILL.md    → .claude/skills/session/session-end/
  ./plugins/memory-vault/skills/setup/SKILL.md          → .claude/skills/session/setup/
  ./2-PLAN/skills/ltc-writing-plans/SKILL.md            → .claude/skills/process/ltc-writing-plans/
  ./2-PLAN/skills/ltc-execution-planner/SKILL.md        → .claude/skills/process/ltc-execution-planner/
  ./4-IMPROVE/skills/feedback/SKILL.md                  → .claude/skills/quality/feedback/
  ./1-ALIGN/learning/skills/learn/SKILL.md              → .claude/skills/learning/learn/
  ./1-ALIGN/learning/skills/learn-input/SKILL.md        → .claude/skills/learning/learn-input/
  ./1-ALIGN/learning/skills/learn-research/SKILL.md     → .claude/skills/learning/learn-research/
  ./1-ALIGN/learning/skills/learn-review/SKILL.md       → .claude/skills/learning/learn-review/
  ./1-ALIGN/learning/skills/learn-spec/SKILL.md         → .claude/skills/learning/learn-spec/
  ./1-ALIGN/learning/skills/learn-structure/SKILL.md    → .claude/skills/learning/learn-structure/
  ./1-ALIGN/learning/skills/learn-visualize/SKILL.md    → .claude/skills/learning/learn-visualize/
  ./1-ALIGN/skills/ltc-brainstorming/SKILL.md           → .claude/skills/process/ltc-brainstorming/
  ./_shared/skills/ltc-clickup-planner/SKILL.md         → .claude/skills/wms/ltc-clickup-planner/
  ./_shared/skills/ltc-notion-planner/SKILL.md          → .claude/skills/wms/ltc-notion-planner/
  ./3-EXECUTE/skills/ltc-task-executor/SKILL.md         → .claude/skills/process/ltc-task-executor/
  ./skills/deep-research/SKILL.md                       → .claude/skills/research/deep-research/
  ./skills/root-cause-tracing/SKILL.md                  → .claude/skills/research/root-cause-tracing/
  ```
- Behavioral boundaries §8
- Constraint: "Touch ONLY `.claude/skills/` and the source skill dirs listed above. Move entire skill directories (not just SKILL.md). Do NOT modify SKILL.md content. SKIP `scripts/test-fixtures/bad-skill/` — that is test data, not a real skill."
- Output: "Return file list of moves + run `./scripts/skill-validator.sh`, paste full output"

**Agent-B context package:**
- VANA-SPEC §2: V-05, V-06 only
- `project_restructuring_design.md` → Stale Artifacts + Learning Pipeline + Plugin Dissolution sections
- Plugin dissolution map (paste into prompt):
  ```
  MOVE FIRST:
    plugins/memory-vault/hooks/strategic-compact.sh    → .claude/hooks/
    plugins/memory-vault/hooks/session-summary.sh      → .claude/hooks/
    plugins/memory-vault/hooks/state-saver.sh          → .claude/hooks/
    plugins/memory-vault/hooks/session-reconstruct.sh  → .claude/hooks/
    plugins/memory-vault/hooks/hooks.json              → .claude/hooks/
    plugins/memory-vault/hooks/lib/config.sh           → .claude/hooks/lib/
    plugins/memory-vault/scripts/import-claude-web.py  → scripts/
    plugins/memory-vault/scripts/import-gemini.py      → scripts/
    plugins/memory-vault/scripts/validate-memory-structure.sh → scripts/
    plugins/memory-vault/scripts/memory-guard.sh       → scripts/
    plugins/memory-vault/scripts/import-cursor.py      → scripts/
  DELETE AFTER:
    plugins/ (entire tree — skills already moved by Agent A)
    .exec/
    .claude-plugin/
    hooks/ (root, if empty)
  ```
- Behavioral boundaries §8
- Constraint: "NEVER touch `1-ALIGN/learning/`. MOVE THEN VERIFY THEN DELETE — never delete before confirming moves landed. Use `git mv` for traceability. Verify each source exists before moving."
- Output: "Return list of moved + deleted items + `find 2-PLAN 3-EXECUTE 4-IMPROVE -type d -name learning 2>/dev/null` output + `ls .claude/hooks/` output"

**Gate G1:**
- Orchestrator merges A + B to feature branch
- Run: `./scripts/skill-validator.sh` → must be 23/23 (SA-01)
- Run: verify V-01, V-05, V-06, N-02
- Run: verify plugin dissolution complete — `test ! -d plugins && ls .claude/hooks/*.sh | wc -l` ≥ 4
- Human approval: "Confirm skills in correct categories? Plugin hooks/scripts at new paths?"
- **FAIL action:** If SA-01 < 23/23, dispatch targeted fix agent for failed skills. If plugin move incomplete, re-run Agent B with specific file list.

**Commit 1:** `refactor(zone0): skills consolidation + plugin dissolution + zone cleanup — V-01, V-05, V-06, N-02`

---

### Phase 2 — Genesis Structure + Content

**Sequential then parallel:** Agent C first → then Agent D ∥ Agent E

```
Agent-C (genesis-rename)
  │
  ├─ git mv _shared/ _genesis/
  ├─ Create any missing subdirs from the 11 MECE list
  └─ Verify V-02 (11 subdirs exist)
        │
        ↓ merge to feature branch
        │
Agent-D (genesis-content)          Agent-E (dsbv-updates)
  │                                   │
  ├─ Write README.md for each         ├─ Add Execution Strategy
  │  of 11 _genesis/ subdirs          │  section to DSBV_PROCESS.md
  ├─ Add YAML frontmatter             ├─ Add scope check preamble
  │  to all _genesis/*.md             ├─ Add agent pattern catalog
  ├─ Add derived_from to              │  reference
  │  _genesis/README.md               └─ Update DESIGN.md template
  └─ Write cascade diagram               with Execution Strategy block
```

**Agent-C context package:**
- VANA-SPEC §2: V-02 only
- `project_restructuring_design.md` → `_shared/ → _genesis/` section (11 categories list)
- Constraint: "Rename + create structure ONLY. Do NOT write content into files."
- Output: "Return `ls -d _genesis/*/` output"

**Agent-D context package:**
- VANA-SPEC §2: N-01, SA-04, SAdj-01, SAdj-02 only
- `project_restructuring_design.md` → `_genesis/` Knowledge Hierarchy section (cascade model, 11 category descriptions)
- `2026-03-29-i1-artifact-flow-design.md` → §9 Causal Chain Verification
- Constraint: "Write ONLY to `_genesis/` markdown files. Do NOT touch `_genesis/templates/`."
- Output: "Return `find _genesis -maxdepth 2 -name 'README.md' | wc -l` + sample frontmatter from 3 files"

**Agent-E context package:**
- VANA-SPEC §2: V-07, N-03, N-04 only
- Current `_genesis/templates/DSBV_PROCESS.md` (read first)
- `2026-03-29-i1-artifact-flow-design.md` → §2 Agent Pattern Catalog, §8 Git Strategy, DESIGN.md Execution Strategy Section
- Constraint: "Touch ONLY `_genesis/templates/DSBV_PROCESS.md` and `_genesis/templates/DESIGN_TEMPLATE.md`."
- Output: "Return `grep -c 'Execution Strategy' _genesis/templates/DSBV_PROCESS.md` + section headers list"

**Gate G2:**
- Orchestrator merges C, then D + E to feature branch
- Run: verify V-02, N-01, SA-04, SAdj-01, V-07, N-04
- Human approval: "Review _genesis cascade doc + DSBV_PROCESS.md changes?"
- Test: zone gate hook with new paths (SA-05)
- **FAIL action:** If hook fails, orchestrator updates hook paths in `.claude/hooks/`

**Commit 2:** `refactor(zone0): _genesis structure + DSBV enhancements — V-02, V-07, N-01, N-03, N-04, SA-04, SAdj-01, SAdj-02`

---

### Phase 3 — Docs Dissolution + Root Cleanup

**Sequential:** Agent F alone (moves must complete before delete)

```
Agent-F (docs-dissolution)
  │
  ├─ MOVE docs/design/:
  │  ├─ git mv docs/design/*.md → 1-ALIGN/learning/research/
  │  └─ git mv docs/design/*.html → 1-ALIGN/learning/research/
  ├─ MOVE docs/idea/:
  │  ├─ git mv docs/idea/*.pdf → _genesis/reference/
  │  └─ git mv docs/idea/*.md → _genesis/reference/
  ├─ MOVE docs/reference/:
  │  ├─ git mv docs/reference/*.md → _genesis/reference/
  │  └─ git mv docs/reference/archive/ → _genesis/reference/archive/
  ├─ MOVE root .pptx:
  │  └─ git mv "[LTC ALL]_OE.6. TEMPLATES - LTC Template vFinal.pptx" → _genesis/reference/
  ├─ DELETE stale:
  │  ├─ rm -rf docs/idea/ltc-project-template/ (~90 files, stale I0 scaffold)
  │  └─ rm -rf docs/ (only after ALL moves verified)
  └─ Verify V-03, V-04
```

**Agent-F context package:**
- VANA-SPEC §2: V-03, V-04 only
- `project_restructuring_design.md` → `docs/` Dissolve section (move map table)
- Complete move map (paste into prompt):
  ```
  docs/design/*.md                    → 1-ALIGN/learning/research/
  docs/design/*.html                  → 1-ALIGN/learning/research/
  docs/idea/*.pdf (5 Vinh PDFs)       → _genesis/reference/
  docs/idea/*.md (1 guide)            → _genesis/reference/
  docs/idea/ltc-project-template/     → DELETE (stale I0, ~90 files)
  docs/reference/*.md                 → _genesis/reference/
  docs/reference/archive/*.docx       → _genesis/reference/archive/
  "[LTC ALL]_OE.6. TEMPLATES..."      → _genesis/reference/
  ```
- Behavioral boundaries §8
- Constraint: "Move THEN verify THEN delete. NEVER delete before confirming move landed. Use `git mv` for traceability. After all moves, run `ls docs/` to confirm only deletable content remains before `rm -rf docs/`."
- Output: "Return `git diff --stat` for this commit + `test ! -d docs && echo PASS` + `ls _genesis/reference/ | wc -l`"

**Gate G3:**
- Orchestrator merges F to feature branch
- Run: verify V-03, V-04
- Run: verify root .pptx moved — `test ! -f "*.pptx" && echo PASS`
- **Human approval REQUIRED:** Review `git diff --stat` for unexpected deletions (SA-02)
- **FAIL action:** If content missing, `git checkout -- <file>` to restore, re-plan move

**Commit 3:** `refactor(zone0): dissolve docs/ + root .pptx — moves to _genesis/reference + 1-ALIGN/learning/research — V-03, V-04`

---

### Phase 4 — Cross-Reference Updates

**Parallel:** Agent G ∥ Agent H (zero file overlap — G touches top-level docs, H touches skills + rules)

```
Agent-G (ref-updates)               Agent-H (all-stale-refs)
  │                                   │
  ├─ CLAUDE.md: _shared → _genesis    ├─ grep -r "_shared/" in:
  ├─ CLAUDE.md: remove docs/ refs     │  ├─ .claude/skills/**/*.md
  ├─ CLAUDE.md: update skill paths    │  ├─ rules/**/*.md
  ├─ README.md: update file tree      │  └─ .claude/rules/**/*.md
  └─ README.md: remove docs/ line     ├─ Replace _shared/ → _genesis/
                                      ├─ grep -r "docs/superpowers"
                                      │  in same scope
                                      ├─ Replace → 2-PLAN/architecture/
                                      ├─ grep -r "docs/" for any other
                                      │  stale refs to dissolved docs/
                                      └─ Verify V-10, V-10b
```

**Agent-G context package:**
- VANA-SPEC §2: V-08, V-09 only
- Current `CLAUDE.md` and `README.md` (read first)
- Constraint: "Touch ONLY `CLAUDE.md` and `README.md`. Match existing formatting. Do NOT rewrite sections — update references only. Replace `_shared` → `_genesis` everywhere. Remove `docs/` from file tree (keep `3-EXECUTE/docs/` — that's zone-level, unrelated). Update `_shared/templates/` → `_genesis/templates/`, `_shared/reference/` → `_genesis/reference/`, etc."
- Output: "Return `grep -c '_shared' CLAUDE.md` (expect 0) + `grep -c '_genesis' CLAUDE.md` (expect ≥1) + `grep 'docs/' README.md` (expect only 3-EXECUTE/docs/)"

**Agent-H context package:**
- VANA-SPEC §2: V-10, V-10b only
- Known stale refs (paste into prompt — from audit):
  ```
  Files with _shared/ refs:
    .claude/skills/ltc-skill-creator/gotchas.md
    .claude/skills/ltc-skill-creator/references/creation-procedure.md
    .claude/skills/ltc-skill-creator/references/anti-patterns.md
    .claude/skills/ltc-skill-creator/SKILL.md
    .claude/skills/dsbv/gotchas.md
    .claude/skills/dsbv/SKILL.md

  Files with docs/superpowers refs:
    (none found — dir doesn't exist, but grep to confirm)
  ```
- Constraint: "Touch ONLY `.claude/skills/**/*.md`, `rules/**/*.md`, and `.claude/rules/**/*.md`. Replace PATH references only — do NOT modify skill logic, instructions, or behavioral content. When replacing `_shared/` → `_genesis/`, verify the target path exists in the new structure. Also scan for any remaining `docs/` refs that should point to new locations."
- Output: "Return `grep -r '_shared' .claude/skills/ rules/ .claude/rules/ | wc -l` (expect 0) + `grep -r 'docs/superpowers' .claude/skills/ | wc -l` (expect 0) + list of all replacements made"

**Gate G4:**
- Orchestrator merges G + H to feature branch
- Run: verify V-08, V-09, V-10, V-10b
- Run: SA-03 (secret scan)
- Run: comprehensive stale ref sweep — `grep -r "_shared\|docs/superpowers\|plugins/" .claude/ rules/ CLAUDE.md README.md | grep -v ".git" | wc -l` (expect 0)
- Human approval: "Review CLAUDE.md, README.md, and skill ref changes?"
- **FAIL action:** Targeted find-and-replace for any remaining stale refs

**Commit 4:** `refactor(zone0): cross-reference updates — V-08, V-09, V-10, V-10b`

---

### Phase 5 — Validation Sweep

**Agent I runs all 20 deterministic ACs. Orchestrator handles 7 manual ACs.**

> **R4 mitigation:** Agent I receives the AC-TEST-MAP embedded directly in its prompt — no file path dependency on docs/design/ (which was moved to 1-ALIGN/learning/research/ in Phase 3).

```
Agent-I (validator)
  │
  ├─ Run embedded AC-TEST-MAP
  │  (all 20 deterministic tests, incl. V-10b)
  ├─ Report pass/fail table
  └─ If failures: list specific AC + actual vs expected
        │
        ↓
Orchestrator
  │
  ├─ Review Agent-I report
  ├─ Manual checks:
  │    SA-02: git diff --stat (no content loss)
  │    N-03:  DSBV_PROCESS.md completeness
  │    N-05:  artifact-flow-map.html interactive check
  │    SAdj-02: cascade diagram present
  │    SAdj-04: all 7 decisions implemented (+ plugin dissolution + root .pptx)
  ├─ If failures: dispatch targeted fix agents
  └─ If all pass: commit 5 (fixes only) or skip
```

**Agent-I context package:**
- AC-TEST-MAP embedded in prompt (not file reference):
  ```
  V-01:   find 1-ALIGN/skills 2-PLAN/skills 3-EXECUTE/skills 4-IMPROVE/skills skills/ .agents/skills -name "SKILL.md" 2>/dev/null | wc -l  → expect 0
  V-02:   ls -d _genesis/{philosophy,principles,frameworks,brand,security,sops,templates,governance,compliance,culture,reference} | wc -l  → expect 11
  V-03:   test ! -d docs && echo PASS
  V-04:   find _genesis/reference -type f | wc -l  → expect >= 7
  V-05:   test ! -d .exec && test ! -d plugins && test ! -d .claude-plugin && echo PASS
  V-06:   find 2-PLAN 3-EXECUTE 4-IMPROVE -type d -name learning 2>/dev/null | wc -l  → expect 0
  V-07:   grep -c "Execution Strategy" _genesis/templates/DSBV_PROCESS.md  → expect >= 1
  V-08:   grep -c "_shared" CLAUDE.md  → expect 0
  V-09:   grep "docs/" README.md | grep -v "3-EXECUTE/docs/" | wc -l  → expect 0
  V-10:   grep -r "docs/superpowers" .claude/skills/ | wc -l  → expect 0
  V-10b:  grep -r "_shared" .claude/skills/ rules/ .claude/rules/ | wc -l  → expect 0
  SA-01:  ./scripts/skill-validator.sh  → expect 23/23
  SA-03:  grep -r "API_KEY\|SECRET\|PASSWORD\|TOKEN" --include="*.md" --include="*.yaml" | grep -v "example\|template\|placeholder" | wc -l  → expect 0
  SA-04:  grep -c "derived_from" _genesis/README.md  → expect >= 1
  SA-05:  (run pre-commit hook on test commit)  → expect pass
  SA-06:  find 2-PLAN 3-EXECUTE 4-IMPROVE -path "*/learning/*" -type f 2>/dev/null | wc -l  → expect 0
  N-01:   find _genesis -maxdepth 2 -name "README.md" | wc -l  → expect >= 11
  N-02:   ls -d .claude/skills/{process,session,learning,wms,quality,research,reference,verification,ops} | wc -l  → expect 9
  N-04:   grep -c "Execution Strategy" _genesis/templates/DSBV*  → expect >= 1
  N-06:   ls -d 1-ALIGN/learning/{config,input,output,scripts,templates,references,research} 2>/dev/null | wc -l  → expect 7
  EXTRA:  test ! -d plugins && ls .claude/hooks/*.sh | wc -l  → expect >= 4 (plugin dissolution)
  EXTRA:  test ! -f *.pptx && echo PASS  → (root .pptx moved)
  EXTRA:  test ! -f scripts/test-fixtures/bad-skill/SKILL.md || echo "OK-fixture-untouched"  → (R5: test fixture preserved)
  ```
- Constraint: "Read-only. Run tests. Do NOT modify any files. Report results only."
- Output: "Return markdown table: AC ID | Test | Expected | Actual | PASS/FAIL"

**Gate G5 (VALIDATE):**
- All 27 ACs pass (20 deterministic + 7 manual)
- `git log --oneline feat/restructuring-i1` shows ≤5 commits (SAdj-05)
- Human approval: "Create PR to main?"
- **FAIL action:** Fix commit (commit 5), re-run Agent-I

**Commit 5 (if needed):** `fix(zone0): validation fixes — [list failed ACs]`

**PR:** `feat/restructuring-i1` → `main`

---

## 5. Dependency Map

```
Phase 1:  A ═══╗
          B ═══╬══ G1 ══╗
               ║        ║
Phase 2:       ║    C ═══╬══ merge ══╗
               ║         ║          ║
               ║    D ═══╬══ G2 ════╗
               ║    E ═══╝          ║
               ║                    ║
Phase 3:       ║         F ═════ G3 ╗
               ║                    ║
Phase 4:       ║    G ═══╗          ║
               ║    H ═══╬══ G4 ════╗
               ║         ║         ║
Phase 5:       ║         I ═════ G5 → PR → main
```

**Critical path:** A → G1 → C → D → G2 → F → G3 → G → G4 → I → G5

---

## 6. Cost-Benefit Summary

| Metric | Sequential (1 agent) | This Plan (9 agents) | Full Parallel (26 agents) |
|--------|---------------------|----------------------|--------------------------|
| Sessions | 4-5 | 2-3 | 1 |
| Merge risk | None | Low (file domain isolation) | High |
| Context bloat | Severe (26 ACs in one window) | Minimal (2-4 ACs per agent) | Minimal |
| Coordination cost | None | 5 gates | 26 merge points |
| Failure recovery | Revert entire session | Revert one phase | Revert one AC |

**Selected:** 9-agent plan. Best ratio of speed to coordination cost.

---

## 7. Failure Modes & Recovery

| Failure Mode | Detection Point | Recovery |
|-------------|-----------------|----------|
| Broken cross-references | G4 (Agent-H report) | Targeted grep + fix agent |
| Skill validator regression | G1 (SA-01 check) | Revert Agent-A commit, re-plan skill paths |
| Git hook failure | G2 (SA-05 check) | Orchestrator updates hook paths |
| Content loss during moves | G3 (human `git diff --stat`) | `git checkout -- <file>` to restore |
| _genesis cascade break | G2 (Agent-D report) | Update `derived_from` in affected files |
| Sub-worktree merge conflict | Any gate | Orchestrator resolves manually (file domain isolation should prevent) |
| Plugin hooks broken after move | G1 (hooks test) | Verify .claude/hooks/ paths in hooks.json, update if needed |
| Stale `_shared/` refs missed | G4 (comprehensive sweep) | Agent H re-run with expanded grep scope |
| Test fixture accidentally moved | G5 (EXTRA check) | Restore from git: `git checkout -- scripts/test-fixtures/` |

---

## 8. Human Gate Checklist

| Gate | Required Human Actions |
|------|----------------------|
| G1 | Confirm skills in correct categories. Approve SA-01 result. Confirm plugin hooks/scripts at new paths. |
| G2 | Review _genesis READMEs quality. Review DSBV_PROCESS.md changes. Confirm SA-05. |
| G3 | Review `git diff --stat` for unexpected deletions. Confirm no content loss. Confirm root .pptx moved. |
| G4 | Review CLAUDE.md and README.md changes. Review skill/rules ref updates. Confirm SA-03 (no secrets). Confirm comprehensive stale-ref sweep = 0. |
| G5 | Review Agent-I validation report (20 det + 3 EXTRA). Perform 7 manual AC checks. Approve PR. |

---

## 9. Risk Register (DESIGN ↔ SEQUENCE Cross-Reference Audit)

> Identified during v1.0 → v1.1 review. All mitigated in the sections above.

| # | Risk | Severity | Root Cause | Mitigation | Where Applied |
|---|------|----------|------------|------------|---------------|
| R1 | Plugin dissolution destroys hooks + scripts | **CRITICAL** | Agent B v1.0 only deleted `plugins/`, no move step | Agent B rewritten: MOVE hooks/scripts THEN delete empty shell | §4 Phase 1 |
| R2 | Root .pptx orphaned after docs/ dissolution | MEDIUM | Design said "move .pptx → docs/" but docs/ is dissolved. No agent handled it. | Added to Agent F: `git mv .pptx → _genesis/reference/` | §4 Phase 3 |
| R3 | `_shared/` refs in skills/rules uncaught | **HIGH** | Agent H v1.0 only checked `docs/superpowers/` (doesn't exist). Real stale refs are `_shared/`. | Agent H scope expanded to ALL stale refs. Promoted Haiku → Sonnet. | §3, §4 Phase 4 |
| R4 | SEQUENCE/VANA-SPEC self-move breaks Agent I paths | LOW | Agent F moves docs/design/ in Phase 3. Agent I referenced those paths. | Agent I receives AC-TEST-MAP embedded in prompt, no file dependency. | §4 Phase 5 |
| R5 | Test fixture `scripts/test-fixtures/bad-skill/SKILL.md` moved as real skill | MEDIUM | Agent A v1.0 had no exclusion for test fixtures. | Agent A constraint: "SKIP scripts/test-fixtures/" | §4 Phase 1 |
| R6 | Rules audit (distill sync) missing from plan | LOW | Design mentions it but no VANA-SPEC AC. | Explicitly deferred to I2 as RA-01 (see VANA-SPEC patch). Not a v1.1 gap — intentional scope. | VANA-SPEC §9 |
| R7 | V-10 test trivially passes (checks non-existent path) | MEDIUM | `docs/superpowers/` doesn't exist, so `grep` returns 0 regardless. Real stale refs unchecked. | Added V-10b: `grep -r "_shared" .claude/skills/ rules/ .claude/rules/ | wc -l` = 0 | VANA-SPEC §2 patch, §4 Phase 5 |
