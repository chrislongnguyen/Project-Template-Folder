---
version: "1.1"
status: Draft
owner: Long Nguyen
last_updated: 2026-03-29
derived_from: [project_restructuring_design.md, 2026-03-29-i1-artifact-flow-design.md, Vinh ALPEI PDFs]
---
# VANA-SPEC: I1 Repo Restructuring

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restructure the LTC Project Template repo to match the approved I1 artifact flow design — consolidate skills, rename _shared to _genesis, dissolve docs/, enforce learning-is-ALIGN-only, add DSBV enhancements, clean stale artifacts.

**Architecture:** File moves + content updates across Zone 0 (agent governance) and zone scaffolding. No code changes. All moves are reversible via git.

**Tech Stack:** Shell (file moves), Markdown (content), git (version control)

---

## §1 System Identity

| Field | Value |
|-------|-------|
| System Name | I1 Repo Restructuring |
| Slug | restructuring-i1 |
| EO | Template repo structure matches the approved artifact flow design — safe to clone, clear for humans and agents |
| Scope | Zone 0 (agent governance) + zone scaffolding. Does NOT change zone artifact content. |

### RACI

| Role | Assignment |
|------|------------|
| Responsible (R) | Claude Agent (file moves, content updates) |
| Accountable (A) | Long Nguyen (approves PR) |
| Consulted (C) | Vinh ALPEI framework (canonical reference) |
| Informed (I) | Team members (via PR + changelog) |

---

## §2 Verb Acceptance Criteria

| A.C. ID | Verb | Criteria | Eval Type | Threshold | Test Command |
|---------|------|----------|-----------|-----------|-------------|
| V-01 | consolidate | All skills exist in `.claude/skills/{category}/{skill}/` — no duplicates in zone dirs | Deterministic | 0 skills outside `.claude/skills/` | `find 1-ALIGN/skills 2-PLAN/skills 3-EXECUTE/skills 4-IMPROVE/skills skills/ .agents/skills -name "SKILL.md" 2>/dev/null \| wc -l` = 0 |
| V-02 | rename | `_shared/` renamed to `_genesis/` with 11 MECE categories | Deterministic | 11 subdirs exist | `ls -d _genesis/{philosophy,principles,frameworks,brand,security,sops,templates,governance,compliance,culture,reference} \| wc -l` = 11 |
| V-03 | dissolve | Root `docs/` directory does not exist | Deterministic | dir absent | `test ! -d docs && echo PASS` |
| V-04 | move | Vinh's 5 PDFs + discussion notes in `_genesis/reference/` | Deterministic | 7+ files present | `find _genesis/reference -type f \| wc -l` >= 7 |
| V-05 | delete | Stale artifacts removed (.exec/, docs/idea/ltc-project-template/, empty hooks/, .claude-plugin/, plugins/) | Deterministic | dirs absent | `test ! -d .exec && test ! -d docs && test ! -d plugins && test ! -d .claude-plugin && echo PASS` |
| V-06 | remove | No `learning/` directory in zones 2-4 | Deterministic | 0 dirs | `find 2-PLAN 3-EXECUTE 4-IMPROVE -type d -name learning 2>/dev/null \| wc -l` = 0 |
| V-07 | update | DSBV_PROCESS.md includes Execution Strategy section and scope check preamble | Deterministic | sections present | `grep -c "Execution Strategy" _genesis/templates/DSBV_PROCESS.md` >= 1 |
| V-08 | update | CLAUDE.md reflects new structure (no docs/, _genesis not _shared) | Deterministic | no stale refs | `grep -c "_shared" CLAUDE.md` = 0 AND `grep -c "_genesis" CLAUDE.md` >= 1 |
| V-09 | update | README.md file tree reflects new structure | Deterministic | no stale refs | `grep -c "docs/" README.md` = 0 (except 3-EXECUTE/docs/) |
| V-10 | redirect | Skills that referenced `docs/superpowers/` now point to `2-PLAN/architecture/` | Deterministic | 0 stale refs | `grep -r "docs/superpowers" .claude/skills/ \| wc -l` = 0 |
| V-10b | redirect | All `_shared/` path refs in skills, rules, and .claude/rules/ updated to `_genesis/` | Deterministic | 0 stale refs | `grep -r "_shared" .claude/skills/ rules/ .claude/rules/ \| wc -l` = 0 |

> **V-10b added (v1.1):** V-10 alone was insufficient — `docs/superpowers/` doesn't exist so V-10 trivially passes. The real stale refs are `_shared/` paths in 6+ skill/rule files. V-10b catches these. (Risk R7)

---

## §3 Adverb Acceptance Criteria

### §3.1 Sustainability Adverbs (I1)

| A.C. ID | Adverb | Criteria | Eval Type | Threshold |
|---------|--------|----------|-----------|-----------|
| SA-01 | correctly | All 23 skills still pass EOP validator after move | Deterministic | `./scripts/skill-validator.sh` = 23/23 pass |
| SA-02 | safely | No file content lost during moves — git diff shows only path changes, not content deletions | Manual | Human reviews `git diff --stat` before merge |
| SA-03 | safely | No secrets exposed — .env, credentials, API keys absent from committed files | Deterministic | `grep -r "API_KEY\|SECRET\|PASSWORD\|TOKEN" --include="*.md" --include="*.yaml" \| grep -v "example\|template\|placeholder" \| wc -l` = 0 |
| SA-04 | reliably | `_genesis/` has `derived_from` frontmatter convention documented | Deterministic | `grep -c "derived_from" _genesis/README.md` >= 1 |
| SA-05 | correctly | Zone boundary gate hook still works with new paths | Deterministic | Pre-commit hook passes on test commit |
| SA-06 | correctly | Learning pipeline only in 1-ALIGN — no learning infrastructure in zones 2-4 | Deterministic | `find 2-PLAN 3-EXECUTE 4-IMPROVE -path "*/learning/*" -type f 2>/dev/null \| wc -l` = 0 |

### §3.2 Efficiency Adverbs (I2 — not in scope for I1)

| A.C. ID | Adverb | Criteria | Iteration |
|---------|--------|----------|-----------|
| EA-01 | easily | Consumer teams can clone and understand structure in <15 min | I2 |
| EA-02 | quickly | Agent can locate any artifact type in <3 tool calls | I2 |

### §3.3 Scalability Adverbs (I3 — not in scope for I1)

| A.C. ID | Adverb | Criteria | Iteration |
|---------|--------|----------|-----------|
| ScA-01 | automatically | Skill validator auto-discovers skills in new paths | I3 |

---

## §4 Noun Acceptance Criteria

| A.C. ID | Noun | Criteria | Eval Type | Threshold |
|---------|------|----------|-----------|-----------|
| N-01 | _genesis/ | 11 MECE categories, each with README explaining purpose and cascade position | Deterministic | `find _genesis -maxdepth 2 -name "README.md" \| wc -l` >= 11 |
| N-02 | .claude/skills/ | 9 MECE categories (process, session, learning, wms, quality, research, reference, verification, ops) | Deterministic | `ls -d .claude/skills/{process,session,learning,wms,quality,research,reference,verification,ops} \| wc -l` = 9 |
| N-03 | DSBV_PROCESS.md | Updated with: 4-stage confirmation, scope check preamble, Execution Strategy section, agent pattern catalog reference, git lifecycle | Manual | Human reviews document for completeness |
| N-04 | DESIGN.md template | Includes Execution Strategy section (pattern, rationale, git plan, human gates, EP validation, cost estimate) | Deterministic | `grep -c "Execution Strategy" _genesis/templates/DSBV*` >= 1 |
| N-05 | artifact-flow-map.html | Interactive visualization committed, accessible, all zones + artifacts + I/O links present | Manual | Human opens HTML, verifies all 4 zones expand, artifacts clickable |
| N-06 | 1-ALIGN/learning/ | Learning infrastructure intact (config, input, output, scripts, templates, references, research) | Deterministic | `ls -d 1-ALIGN/learning/{config,input,output,scripts,templates,references,research} 2>/dev/null \| wc -l` = 7 |

---

## §5 Adjective Acceptance Criteria

### §5.1 Sustainability Adjectives (I1)

| A.C. ID | Adjective | Criteria | Eval Type | Threshold |
|---------|-----------|----------|-----------|-----------|
| SAdj-01 | consistent | All .md artifacts in _genesis/ have YAML frontmatter (version, last_updated, owner) | Deterministic | `find _genesis -name "*.md" ! -name "README.md" -exec head -1 {} \; \| grep -c "^---"` = file count |
| SAdj-02 | traceable | _genesis/ cascade documented: philosophy → principles → frameworks → derived | Manual | README.md or cascade diagram explains the flow |
| SAdj-03 | MECE | No duplicate artifacts across locations (no skill in both .claude/skills/ AND zone/skills/) | Deterministic | V-01 passes |
| SAdj-04 | complete | All approved restructuring decisions implemented (7 decisions from project_restructuring_design.md) | Manual | Human checks all 7 decisions against actual repo state |
| SAdj-05 | reversible | All changes committed atomically — can `git revert` the restructuring cleanly | Deterministic | Changes in ≤5 well-scoped commits on a feature branch |

### §5.2 Efficiency Adjectives (I2)

| A.C. ID | Adjective | Criteria | Iteration |
|---------|-----------|----------|-----------|
| EAdj-01 | navigable | File tree depth ≤4 for any artifact | I2 |
| EAdj-02 | documented | Every category has a README with purpose + contents | I2 |

---

## §6 AC-TEST-MAP

| A.C. ID | VANA Word | Eval Type | Test | Threshold |
|---------|-----------|-----------|------|-----------|
| V-01 | consolidate | Deterministic | `find` for SKILL.md outside .claude/skills/ | 0 matches |
| V-02 | rename | Deterministic | `ls -d _genesis/{11 dirs}` | 11 |
| V-03 | dissolve | Deterministic | `test ! -d docs` | true |
| V-04 | move | Deterministic | `find _genesis/reference -type f \| wc -l` | >= 7 |
| V-05 | delete | Deterministic | `test ! -d` for each stale dir | all true |
| V-06 | remove | Deterministic | `find` for learning/ in zones 2-4 | 0 dirs |
| V-07 | update | Deterministic | `grep "Execution Strategy"` in DSBV_PROCESS.md | >= 1 |
| V-08 | update | Deterministic | `grep "_shared" CLAUDE.md` | 0 |
| V-09 | update | Deterministic | `grep "docs/" README.md` | 0 (except 3-EXECUTE) |
| V-10 | redirect | Deterministic | `grep "docs/superpowers" .claude/skills/` | 0 |
| V-10b | redirect | Deterministic | `grep -r "_shared" .claude/skills/ rules/ .claude/rules/` | 0 |
| SA-01 | correctly | Deterministic | `skill-validator.sh` | 23/23 |
| SA-02 | safely | Manual | Human reviews git diff --stat | no content loss |
| SA-03 | safely | Deterministic | grep for secret patterns | 0 |
| SA-04 | reliably | Deterministic | grep derived_from in _genesis/README | >= 1 |
| SA-05 | correctly | Deterministic | pre-commit hook test | passes |
| SA-06 | correctly | Deterministic | find learning/ in zones 2-4 | 0 files |
| N-01 | _genesis/ | Deterministic | count READMEs in _genesis subdirs | >= 11 |
| N-02 | .claude/skills/ | Deterministic | count 9 category dirs | 9 |
| N-03 | DSBV_PROCESS.md | Manual | human review | complete |
| N-04 | DESIGN.md template | Deterministic | grep Execution Strategy | >= 1 |
| N-05 | flow-map.html | Manual | human opens + verifies | all zones work |
| N-06 | 1-ALIGN/learning/ | Deterministic | count 7 subdirs | 7 |
| SAdj-01 | consistent | Deterministic | frontmatter check script | 100% |
| SAdj-02 | traceable | Manual | cascade diagram exists | present |
| SAdj-03 | MECE | Deterministic | V-01 | passes |
| SAdj-04 | complete | Manual | 7 decisions checked | all implemented |
| SAdj-05 | reversible | Deterministic | commit count | ≤5 |

**Summary:** 27 total I1 ACs. 20 Deterministic, 7 Manual. Plus EA-01, EA-02, EAdj-01, EAdj-02 (I2), ScA-01 (I3), and RA-01 (I2).

---

## §7 Failure Modes & Recovery

### Iteration 1 Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation |
|-------------|---------|-----------|----------|------------|
| Broken cross-references | File moved but references not updated | `grep -r` for old paths after move | Find-and-replace old → new paths | If >20 broken refs, pause and review move plan |
| Skill validator regression | Skill moved to wrong path or missing SKILL.md | `skill-validator.sh` returns <23 | Check which skill failed, fix path | If >3 failures, revert commit and re-plan |
| Git hook failure | Zone boundary gate references old paths | Pre-commit hook test fails | Update hook paths in `.claude/hooks/` | Human reviews hook config |
| Content loss | File deleted instead of moved | `git diff --stat` shows unexpected deletions | `git checkout -- <file>` to restore | Always commit moves and deletes separately |
| _genesis cascade break | Downstream file's `derived_from` points to moved source | grep for broken derived_from paths | Update derived_from in affected files | Run cascade audit script |

---

## §8 Agent Behavioral Boundaries

### Iteration 1 Boundaries

**Always (safe actions — no approval needed):**
- Read any file in the repo
- Run `skill-validator.sh`, `template-check.sh`
- Create git branches and worktrees
- Move files within the repo (git mv)
- Update YAML frontmatter (version, last_updated)
- Update cross-references after file moves

**Ask First (needs Human Director approval):**
- Delete any directory (even if flagged as stale)
- Modify CLAUDE.md, README.md, or any rules/ file
- Modify DSBV_PROCESS.md or any _genesis/ template
- Create PR or push to remote
- Change hook configurations

**Never (hard stops):**
- Delete 1-ALIGN/learning/ or any of its 7 subdirs
- Modify zone artifact content (charter, requirements, UBS, etc.) — this is restructuring, not editing
- Commit .env, secrets, or API keys
- Force push to any branch
- Skip the skill-validator.sh check after moving skills

---

## §9 Iteration Plan

### Master Scope Mapping

| A.C. ID | VANA Word | Short Description | Iteration | Status |
|---------|-----------|-------------------|-----------|--------|
| V-01 | consolidate | Skills to .claude/skills/ | I1 | To Do |
| V-02 | rename | _shared → _genesis (11 cats) | I1 | To Do |
| V-03 | dissolve | Remove root docs/ | I1 | To Do |
| V-04 | move | Vinh PDFs to _genesis/reference/ | I1 | To Do |
| V-05 | delete | Stale artifacts cleanup | I1 | To Do |
| V-06 | remove | Learning dirs from zones 2-4 | I1 | To Do |
| V-07 | update | DSBV process enhancements | I1 | To Do |
| V-08 | update | CLAUDE.md new structure | I1 | To Do |
| V-09 | update | README.md file tree | I1 | To Do |
| V-10 | redirect | Skill path references (docs/superpowers/) | I1 | To Do |
| V-10b | redirect | All _shared/ refs in skills + rules → _genesis/ | I1 | To Do |
| SA-01 | correctly | Skill validator 23/23 | I1 | To Do |
| SA-02 | safely | No content loss | I1 | To Do |
| SA-03 | safely | No secrets | I1 | To Do |
| SA-04 | reliably | derived_from documented | I1 | To Do |
| SA-05 | correctly | Zone gate hook works | I1 | To Do |
| SA-06 | correctly | Learning ALIGN-only | I1 | To Do |
| N-01 | _genesis/ | 11 READMEs | I1 | To Do |
| N-02 | .claude/skills/ | 9 category dirs | I1 | To Do |
| N-03 | DSBV_PROCESS.md | Updated process | I1 | To Do |
| N-04 | DESIGN.md template | Execution Strategy | I1 | To Do |
| N-05 | flow-map.html | Visualization | I1 | Done |
| N-06 | 1-ALIGN/learning/ | Intact pipeline | I1 | To Do |
| SAdj-01 | consistent | YAML frontmatter | I1 | To Do |
| SAdj-02 | traceable | Cascade documented | I1 | To Do |
| SAdj-03 | MECE | No duplicates | I1 | To Do |
| SAdj-04 | complete | All 7 decisions | I1 | To Do |
| SAdj-05 | reversible | ≤5 commits | I1 | To Do |
| EA-01 | easily | Clone + understand <15 min | I2 | To Do |
| EA-02 | quickly | Agent finds artifact <3 calls | I2 | To Do |
| EAdj-01 | navigable | File tree depth ≤4 | I2 | To Do |
| EAdj-02 | documented | Category READMEs | I2 | To Do |
| ScA-01 | automatically | Skill validator auto-discover | I3 | To Do |
| RA-01 | audit | Rules distill sync (.cursor/rules/, .agents/rules/) — verify distills match source specs, remove orphans | I2 | To Do |

> **RA-01 added (v1.1):** Design decision "Rules — NO STRUCTURAL CHANGE" includes an execution item for distill sync audit. Explicitly deferred to I2 — not a gap, intentional scope boundary. (Risk R6)

### Iteration Sequencing

| Iteration | Scope | Gate |
|-----------|-------|------|
| I1 (now) | V-01 through V-10b, SA-01 through SA-06, N-01 through N-06, SAdj-01 through SAdj-05 | All 27 I1 ACs pass |
| I2 | EA-01, EA-02, EAdj-01, EAdj-02, RA-01 | All I1 + I2 ACs pass |
| I3 | ScA-01 | All ACs pass |

---

## §10 Integration Contracts

### INPUT CONTRACT (what restructuring consumes)

| Field | Value |
|-------|-------|
| Source | project_restructuring_design.md (memory) |
| Source | 2026-03-29-i1-artifact-flow-design.md (approved spec) |
| Source | project_learn_skill_refactor.md (learn-skill design — must complete first) |
| Validation | All 7 restructuring decisions approved by Human Director |
| Error Handling | If learn-skill refactor changes skill paths, update V-01/V-10 before Build |

### OUTPUT CONTRACT (what restructuring produces for downstream)

| Field | Value |
|-------|-------|
| Consumer | All future DSBV zones (PLAN, EXECUTE, IMPROVE) |
| Consumer | Consumer teams cloning the template |
| Schema | Repo structure matching artifact flow design |
| Validation | All 26 I1 ACs pass deterministic + manual checks |
| Error Handling | If any AC fails post-merge, create fix commit (not revert entire restructuring) |
