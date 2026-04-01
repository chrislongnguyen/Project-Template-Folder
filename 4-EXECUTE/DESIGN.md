---
version: "1.8"
status: Draft
last_updated: 2026-04-01
owner: Long Nguyen
workstream: "EXECUTE workstream"
feature: "Obsidian CLI Integration — RICE-Ranked Features #1-#16"
aliases: ["EXECUTE Design", "Obsidian DSBV Design"]
---

# DESIGN: Obsidian CLI Integration (I1)

## Amendment History

| Version | Date | Change |
|---------|------|--------|
| 1.4 | 2026-03-31 | Original 5 artifacts (A1-A5), 16 ACs. G1 approved. |
| 1.5 | 2026-04-01 | RICE-ranked features absorbed. Test-first mandate. A/B re-test as validation gate. v1.1 self-audit corrections. Fresh branch `I1/feat/obsidian-cli` from main. |
| 1.6 | 2026-04-01 | Vinh branch deep analysis completed. V4 Bases and V8 matrix view deferred to I2. |
| 1.7 | 2026-04-01 | V2 REDEFINED: extend our 27 templates with Vinh's frontmatter schema (4 fields) + add template routing rule. Version numbering corrected to I1 = 1.x. 8 artifacts, 41 ACs. |
| 1.8 | 2026-04-01 | Self-validation pass: renumbered ACs (41→44), added test scripts for A1/A3/A5, fixed AC-17 false-positive risk, fixed AC-41 to check 2 fields not 1, added A6 build note on frontmatter injection being new scope. |

---

## Intent

Add Obsidian CLI as an optional knowledge-graph layer to the LTC Project Template, covering 16 RICE-ranked features. When Obsidian is running, agents traverse backlinks, detect orphans, search with context, and use a 3-tool routing hierarchy (QMD → Obsidian → grep). When not running, all existing tooling continues unchanged.

**Test-first mandate:** A test suite (A7) is built BEFORE any feature artifact. All artifacts are validated against measurable, repeatable tests — not manual review alone.

**Vinh adoption strategy (v1.7):** Do NOT copy Vinh's 43 Templater templates. Instead, extend our existing 27 `_genesis/templates/` files with 4 missing frontmatter fields from Vinh's schema (`type`, `work_stream`, `stage`, `sub_system`). This enables graph queries, future Bases adoption (I2), and frontmatter-consistent agent navigation — without Obsidian Templater syntax dependency.

**Research source:** `2-LEARN/output/obsidian-feature-analysis.html` (v1.1, RICE-ranked)
**Vinh branch analysis:** `2-LEARN/research/2026-03-30-vinh-branch-analysis.md`
**A/B baseline:** 3.6× fewer calls, 18% fewer tokens, 32% faster (4 scenarios, 8 agents)
**Decision:** ADR-002 Option B — Optional Enhancement Layer
**Branch:** `I1/feat/obsidian-cli` (fresh from main, zero conflicts)

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Upstream outputs sufficient? | YES — spike, A/B test, RICE ranking, v1.1 self-audit, Vinh branch analysis all complete |
| Q2: In scope | 16 features (#1-#16): SKILL.md rewrite, security rule, vault scaffold, tool routing, autolinker + frontmatter extension, ADR, test suite, template routing rule |
| Q2b: Out of scope | V4 Bases (I2 — requires Obsidian desktop adoption first), V8 80-cell matrix Base view (I2 — depends on V4), V3 Kanban (I2), L4/V6 daily notes (I2 — fix hooks first), V9 478-file pre-instantiation (test-gate — no data), L3 graph:walk (removed — command doesn't exist), copying Vinh's 43 Templater templates (use our 27 + frontmatter extension instead), mandatory Obsidian enforcement, replacing Grep as baseline |
| Q3: Go/No-Go | GO |

---

## Vinh Branch Findings (input to this Design)

Source: `remotes/origin/Vinh-ALPEI-AI-Operating-System-with-Obsidian` (499 files, 150 .gitkeep stubs)

**What Vinh built that we adopt:**

| Vinh Asset | Files | What we take | How we adapt |
|------------|-------|-------------|--------------|
| Frontmatter schema | All 43 templates | 4 fields: `type`, `work_stream`, `stage`, `sub_system` | Inject into our 27 `_genesis/templates/` files via A6. No Templater `<% %>` syntax. |
| Template routing rule | `.claude/rules/alpei-template-usage.md` | Workstream × stage → template name mapping | Create equivalent rule for our template names (A8). |
| 3-layer architecture | CLAUDE.md design philosophy | Knowledge / Execution / WMS layer separation | Encode in security rule write-path whitelist (A4). |
| AP4 opt-out model | CLAUDE.md session startup | `cli-blocked: true` for sensitive notes | Already in A4 (security rule) and A2 (SKILL.md). |

**What Vinh built that we defer:**

| Vinh Asset | Files | Why defer |
|------------|-------|-----------|
| 43 Templater templates | `0. REUSABLE RESOURCES/0.3. TEMPLATES/` | Obsidian Templater syntax = Obsidian-only. Our 27 templates work everywhere. Extend, don't duplicate. |
| 14 Obsidian Bases (.base) | `0. REUSABLE RESOURCES/0.2. RESOURCES/Dashboards/` | Requires Obsidian desktop. Agents can't read `.base` files. Human-only value. I2 after team adoption. |
| 150 .gitkeep stubs | `_PROJECT TEMPLATE/` subfolders | Pre-instantiation value unproven. Run A/B test with 2 members first. |
| AI Memory in vault | `AI MEMORY/` | We have a working `~/.claude/projects/.../memory/` system. Migration = risk for marginal gain. |
| 46 skill files | `.claude/skills/ues-*/` | 23 slash commands. We have equivalent coverage with different organization. Consolidation is I2 scope. |

---

## Artifact Inventory

### A7 — Test Suite (BUILD FIRST)

| Field | Value |
|-------|-------|
| Path | `4-EXECUTE/tests/obsidian/` |
| Purpose | Provides objective, repeatable measurement of all 16 features across all 7 other artifacts. Without tests, we cannot distinguish "it works" from "it seems to work." User mandate: tests before build. |
| RICE features | All (#1-#16) — one test script per artifact + A/B re-test + acceptance runner |

**Acceptance Conditions:**

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-01 | A/B re-test script exists and runs 4 scenarios (dependency trace, orphan detection, chain-of-custody, impact analysis) with 2 methods each | `bash 4-EXECUTE/tests/obsidian/ab-retest.sh --dry-run` exits 0 |
| AC-02 | Each scenario measures: tool call count, token estimate, file completeness %, wall time | Script output contains all 4 metrics per scenario |
| AC-03 | SKILL.md syntax validation test (A2) | `bash 4-EXECUTE/tests/obsidian/test-skill-syntax.sh` exits 0 |
| AC-04 | Security rule validation test (A4) — AP1-AP5 + write-path + AP4 opt-out + layer discipline | `bash 4-EXECUTE/tests/obsidian/test-security-rule.sh` exits 0 |
| AC-05 | Graceful degradation test (A2 L13) — grep fallback when obsidian unavailable | `bash 4-EXECUTE/tests/obsidian/test-fallback.sh` exits 0 |
| AC-06 | ADR validation test (A1) — status, decision, evidence, Vinh strategy | `bash 4-EXECUTE/tests/obsidian/test-adr.sh` exits 0 |
| AC-07 | Vault scaffold test (A3) — folder structure, frontmatter tags, VAULT_GUIDE | `bash 4-EXECUTE/tests/obsidian/test-vault-scaffold.sh` exits 0 |
| AC-08 | Tool routing test (A5) — obsidian row, 3-tool hierarchy, .claude/ sweep | `bash 4-EXECUTE/tests/obsidian/test-tool-routing.sh` exits 0 |
| AC-09 | Frontmatter schema test (A6) — templates contain 4 required Vinh fields | `bash 4-EXECUTE/tests/obsidian/test-frontmatter-schema.sh` exits 0 |
| AC-10 | Template routing rule test (A8) — all 5 workstreams × 4 stages mapped | `bash 4-EXECUTE/tests/obsidian/test-template-routing.sh` exits 0 |
| AC-11 | Acceptance test runner runs ALL 10 test scripts above and produces pass/fail summary | `bash 4-EXECUTE/tests/obsidian/run-all.sh` exits 0 with summary table |

### A1 — ADR-002 Update

| Field | Value |
|-------|-------|
| Path | `1-ALIGN/decisions/ADR-002-obsidian-cli.md` |
| Purpose | Close deferred decision with spike evidence + RICE data + AP4 opt-out rationale (L8) + Vinh adoption strategy (extend templates, not copy). Audit trail for why optional, why opt-out, why hybrid. |
| RICE features | #3 L8 (AP4 opt-out rationale) |

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-12 | Status = Approved, Decision = Option B | `grep "status: Approved" ADR-002-obsidian-cli.md && grep "Option B" ADR-002-obsidian-cli.md` exits 0 |
| AC-13 | RICE evidence cited (A/B test metrics: 3.6×, 18%, 32%) | `grep "3.6" ADR-002-obsidian-cli.md` exits 0 |
| AC-14 | AP4 opt-out model rationale documented (L8) | `grep -i "opt-out\|cli-blocked" ADR-002-obsidian-cli.md` exits 0 |
| AC-15 | Vinh adoption strategy documented (extend templates, not copy) | `grep -i "frontmatter\|extend.*template\|schema" ADR-002-obsidian-cli.md` exits 0 |

### A4 — Security Rule (amended)

| Field | Value |
|-------|-------|
| Path | `.claude/rules/obsidian-security.md` |
| Purpose | AP1-AP5 anti-patterns + write-path whitelist (V5) + layer discipline (V7) + AP4 opt-out model (L8). Blast-radius limit for CLI access. |
| RICE features | #3 L8, #10 L9 (.claude/ hybrid), #12 V5 (3-layer rule), #15 V7 (layer discipline) |

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-16 | AP1-AP5 present with rule + reason + enforcement per entry | `grep -c "AP[1-5]" obsidian-security.md` ≥ 5 |
| AC-17 | AP4 declares opt-OUT model with `cli-blocked: true` as the active field | `grep -A2 "AP4" obsidian-security.md \| grep "cli-blocked"` exits 0 |
| AC-18 | Write-path whitelist defined (V5: agents write to designated paths only) | `grep -i "write-path\|whitelist\|designated" obsidian-security.md` exits 0 |
| AC-19 | .claude/ hybrid sweep documented (L9: mandatory grep after obsidian search) | `grep -i "\.claude.*grep\|hybrid\|grep sweep" obsidian-security.md` exits 0 |
| AC-20 | Layer discipline rule present (V7: agents don't write to Knowledge layer except via whitelist) | `grep -i "knowledge layer\|layer discipline\|read-only" obsidian-security.md` exits 0 |

### A2 — SKILL.md Rewrite (major)

| Field | Value |
|-------|-------|
| Path | `.claude/skills/obsidian/SKILL.md` |
| Purpose | The agent's interface to Obsidian CLI. Absorbs 10 RICE features. Every agent session that touches obsidian reads this file — errors here cascade to every session. |
| RICE features | #1 L6 (orphans), #2 L5 (search:context), #3 L8 (AP4), #4 L12 (vault targeting), #5 L10 (QMD composability), #6 V10 (routing table), #7 L13 (graceful degradation), #8 L2 (outgoing-links), #11 L1 (backlinks), L3 removed |

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-21 | Command examples use `key=value` syntax (P0 fix). No `--flag` in command lines. | `grep -P "^obsidian\s.*--\|^\s+obsidian\s.*--" SKILL.md` exits non-zero (no matches = pass) |
| AC-22 | `graph:walk` removed (L3) | `grep "graph:walk" SKILL.md` exits non-zero |
| AC-23 | `search:context` documented as primary search command (L5) | `grep "search:context" SKILL.md` exits 0 |
| AC-24 | `orphans` command documented with usage example (L6) | `grep "orphans" SKILL.md` exits 0 |
| AC-25 | Backlinks + outgoing-links chaining pattern documented (L1, L2) | `grep "backlinks" SKILL.md && grep "outgoing-links\|links" SKILL.md` exits 0 |
| AC-26 | AP4 opt-out model: `cli-blocked: true` (L8) | `grep "cli-blocked" SKILL.md` exits 0 |
| AC-27 | Vault targeting warning for worktrees documented (L12) | `grep -i "worktree\|vault.*targeting\|single.*vault" SKILL.md` exits 0 |
| AC-28 | 3-tool routing: QMD → Obsidian → grep/.claude documented (L10, V10) | `grep -i "QMD\|routing" SKILL.md` exits 0 |
| AC-29 | Graceful degradation: fallback to grep when CLI unavailable (L13) | `grep -i "fallback\|graceful\|grep" SKILL.md` exits 0 |
| AC-30 | .claude/ mandatory grep sweep documented (L9) | `grep -i "\.claude.*grep\|hybrid\|mandatory.*sweep" SKILL.md` exits 0 |
| AC-31 | Passes skill-validator.sh | `./scripts/skill-validator.sh .claude/skills/obsidian/` exits 0 |

### A3 — Vault Scaffold (amended: Option C)

| Field | Value |
|-------|-------|
| Path | `4-EXECUTE/src/vault/` |
| Purpose | Ready-to-use vault structure for cloners. Option C: flat folders + `zone:`/`subsystem:` frontmatter tags (L7). No ALPEI folder mirroring. |
| RICE features | #13 L7 (vault structure Option C) |

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-32 | Folders exist: `daily/`, `projects/`, `agents/`, `research/`, `inbox/` | `ls 4-EXECUTE/src/vault/ \| wc -l` ≥ 6 |
| AC-33 | Each README.md has frontmatter with `zone:` and `subsystem:` tags (L7 Option C) | `grep -l "zone:" 4-EXECUTE/src/vault/*/README.md \| wc -l` ≥ 5 |
| AC-34 | VAULT_GUIDE.md covers: CLI registration, fallback mode, Option C flat structure | `grep -i "flat\|frontmatter.*tag\|Option C" 4-EXECUTE/src/vault/VAULT_GUIDE.md` exits 0 |

### A5 — Tool Routing Update (amended)

| Field | Value |
|-------|-------|
| Path | `rules/tool-routing.md` |
| Purpose | Places Obsidian CLI in the 3-tool routing hierarchy (L10). Documents when to use each tool and the mandatory .claude/ grep sweep. |
| RICE features | #5 L10 (QMD composability), #10 L9 (.claude/ hybrid) |

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-35 | `obsidian-cli` row in tool routing table | `grep "obsidian" rules/tool-routing.md` exits 0 |
| AC-36 | 3-tool hierarchy documented: QMD → Obsidian → grep | `grep -i "QMD\|hierarchy\|routing" rules/tool-routing.md` exits 0 |
| AC-37 | .claude/ grep sweep noted as mandatory supplement | `grep -i "\.claude\|mandatory\|sweep" rules/tool-routing.md` exits 0 |

### A6 — Autolinker + Frontmatter Schema Extension (amended)

| Field | Value |
|-------|-------|
| Path | `scripts/obsidian-autolinker.py`, `scripts/obsidian-alias-seeder.py` |
| Purpose | (1) Populate wikilinks across all template markdown files — without links, L1 (backlinks) and L6 (orphans) return empty. (2) **NEW v1.7:** Inject Vinh's 4 frontmatter fields (`type`, `work_stream`, `stage`, `sub_system`) into our 27 `_genesis/templates/` files that lack them. This is the I1 replacement for copying Vinh's 43 Templater templates — we extend our existing templates with the schema that enables graph queries and future Bases (I2). |
| RICE features | #9 L11 (autolinker), #14 V1 (flywheel mechanism), #16 V2 (frontmatter schema — redefined) |
| Vinh input | Frontmatter schema from `remotes/origin/Vinh-ALPEI-AI-Operating-System-with-Obsidian:"0. REUSABLE RESOURCES/0.3. TEMPLATES/"` — 7 fields, we adopt 4 that our templates lack |
| Build note | The rescued autolinker script handles wikilink injection only. Frontmatter field injection is NEW functionality — either extend the autolinker script or write a separate `scripts/inject-frontmatter.py` helper. SEQUENCE.md must account for this as a sub-task. |

**Vinh's frontmatter schema (reference):**

```yaml
# Fields Vinh's templates have that ours lack:
type: ues-deliverable              # what Bases filters on
work_stream: align|learn|plan|execute|improve
stage: design|sequence|build|audit # = our DSBV phases
sub_system: PD|DP|DA|IDM          # which UES subsystem
# Fields we already have:
version: "1.0"                     # already present
status: Draft                      # already present
last_updated: 2026-04-01           # already present (Vinh uses `created:` instead)
```

**Acceptance Conditions:**

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-38 | Both scripts exist and are syntactically valid Python | `python3 -c "import ast; ast.parse(open('scripts/obsidian-autolinker.py').read())"` exits 0 |
| AC-39 | Autolinker runs on template files without error (dry-run mode) | `python3 scripts/obsidian-autolinker.py --dry-run` exits 0 (or equivalent) |
| AC-40 | At least 1 wikilink injected into a sample file after run | Diff shows `[[` added to at least 1 .md file |
| AC-41 | ≥ 20 of 27 `_genesis/templates/*.md` files have all 4 Vinh frontmatter fields after schema injection | `for f in _genesis/templates/*.md; do grep -q "work_stream" "$f" && grep -q "sub_system" "$f" && echo ok; done \| wc -l` ≥ 20 |

### A8 — Template Routing Rule (NEW v1.7)

| Field | Value |
|-------|-------|
| Path | `.claude/rules/alpei-template-usage.md` |
| Purpose | Maps workstream × DSBV stage → which template to use. Without this, agents pick templates ad-hoc or create blank files. Vinh has this as `.claude/rules/alpei-template-usage.md` — we adopt the pattern with our template names. |
| RICE features | #16 V2 (template routing — redefined) |
| Vinh input | `remotes/origin/Vinh-ALPEI-AI-Operating-System-with-Obsidian:".claude/rules/alpei-template-usage.md"` — quick reference table mapping workstream × stage → template |

**Acceptance Conditions:**

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-42 | Rule file exists with frontmatter (version, status, last_updated) | `test -f .claude/rules/alpei-template-usage.md && grep "version:" .claude/rules/alpei-template-usage.md` exits 0 |
| AC-43 | Quick reference table maps all 5 workstreams (ALIGN, LEARN, PLAN, EXECUTE, IMPROVE) × 4 DSBV stages (Design, Sequence, Build, Validate) | `grep -c "ALIGN\|LEARN\|PLAN\|EXECUTE\|IMPROVE" .claude/rules/alpei-template-usage.md` ≥ 5 |
| AC-44 | Template names reference our `_genesis/templates/` files (not Vinh's `TEMPLATES -` prefix) | `grep "_genesis/templates\|_TEMPLATE" .claude/rules/alpei-template-usage.md` exits 0 |

> **Deferred to I2:** V4 Obsidian Bases (requires Obsidian desktop adoption; agents can't read `.base` files; human-only value). V8 80-cell matrix Base view (depends on V4). V3 Kanban (test agent writeability first). L4/V6 daily notes (fix session hooks first). V9 478-file pre-instantiation (A/B test with 2 members required before committing).

---

## Alignment Check

| Condition | Artifacts | Status |
|-----------|-----------|--------|
| AC-01 to AC-11 (test suite — 1 script per artifact + runner) | A7 | Covered |
| AC-12 to AC-15 (ADR) | A1 | Covered |
| AC-16 to AC-20 (security) | A4 | Covered |
| AC-21 to AC-31 (SKILL.md) | A2 | Covered |
| AC-32 to AC-34 (vault) | A3 | Covered |
| AC-35 to AC-37 (routing) | A5 | Covered |
| AC-38 to AC-41 (autolinker + schema) | A6 | Covered |
| AC-42 to AC-44 (template routing rule) | A8 | Covered |

- Orphan conditions = 0 — all 44 ACs map to a named artifact
- Orphan artifacts = 0 — all 8 artifacts have ACs
- A7 has 1 dedicated test script per artifact (10 scripts) + 1 runner = complete coverage
- 8 artifacts → 8+ tasks in SEQUENCE.md (to be verified at G2)

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Single-agent sequential (Execution-heavy workstream) |
| Why this pattern | Artifacts are well-defined with binary ACs. Test-first approach provides validation at each step. No open-ended design decisions remaining. |
| Agent config | ltc-builder (Sonnet) for Build; ltc-reviewer (Opus) for Validate |
| Git strategy | All work on `I1/feat/obsidian-cli` branch. Single PR to `main` on completion. |
| Human gates | G1 (this DESIGN.md), G2 (SEQUENCE.md), G3 (Build complete), G4 (Validate — A/B re-test passes) |
| Test-first mandate | A7 test suite is built FIRST. Every subsequent artifact runs `run-all.sh` as part of its checkpoint commit. Tests fail initially (red) → pass as artifacts are built (green). |

---

## Dependencies

| Dependency | Source | Status |
|------------|--------|--------|
| A/B test baseline data | `2-LEARN/output/obsidian-feature-analysis.html` | Ready |
| RICE ranking | Same HTML file, Priority section | Ready |
| v1.1 self-audit corrections | Same HTML file, Vinh section | Ready |
| Vinh branch analysis | `2-LEARN/research/2026-03-30-vinh-branch-analysis.md` | Ready |
| Vinh frontmatter schema | `remotes/origin/Vinh-ALPEI-AI-Operating-System-with-Obsidian` templates | Ready — read-only reference |
| Vinh template routing rule | Same branch, `.claude/rules/alpei-template-usage.md` | Ready — adapt to our names |
| ADR-002 (deferred) | `1-ALIGN/decisions/ADR-002-obsidian-cli.md` | Ready — update in A1 |
| Autolinker scripts (rescued) | `scripts/obsidian-autolinker.py`, `scripts/obsidian-alias-seeder.py` | Ready — on branch (wikilinks only; frontmatter injection = new build scope) |
| Existing SKILL.md (rescued) | `.claude/skills/obsidian/SKILL.md` | Ready — rewrite in A2 |
| Existing security rule (rescued) | `.claude/rules/obsidian-security.md` | Ready — amend in A4 |
| Our 27 templates | `_genesis/templates/*.md` | Ready — extend frontmatter in A6 |
| skill-validator.sh | `./scripts/skill-validator.sh` | Ready |

---

## Validation Protocol

**Batch 1 (A1-A6, A8):** Re-run A/B test with same 4 scenarios. Compare against baseline:

| Metric | Baseline (broken SKILL.md) | Target (after build) |
|--------|---------------------------|---------------------|
| Tool calls (4 scenarios) | 23 (Obsidian) / 83 (Grep) | ≤ 25 (hybrid) |
| S4 .claude/ completeness | 11% (Obsidian only) | ≥ 80% (hybrid) |
| S2 orphan completeness | 100% | 100% (maintained) |
| Graceful degradation | Not tested | 100% fallback coverage |
| Template frontmatter coverage | 0% (4 Vinh fields missing) | ≥ 74% (20/27 templates) |

**Test runner:** `4-EXECUTE/tests/obsidian/run-all.sh` — produces summary table of all 44 ACs.

---

## Human Gates

| Gate | Trigger | Decision |
|------|---------|----------|
| G1 | This DESIGN.md v1.8 | Approve scope, 8 artifacts, 44 ACs, test-first mandate, Vinh adoption strategy |
| G2 | SEQUENCE.md | Approve build order + test-first sequence |
| G3 | Build complete | All artifacts built, `run-all.sh` passes |
| G4 | VALIDATE.md | A/B re-test meets targets, ltc-reviewer passes audit |

---

## Readiness (C1-C6)

| ID | Condition | Status |
|----|-----------|--------|
| C1 | Clear scope — 16 features, 8 artifacts, in/out defined | GREEN |
| C2 | Inputs curated — A/B data, RICE HTML, rescued artifacts, Vinh branch analysis, Vinh template schema | GREEN |
| C3 | Success rubric — 44 binary ACs | GREEN |
| C4 | Process loaded — DSBV skill in context | GREEN |
| C5 | Prompt engineered — all inputs in window | GREEN |
| C6 | Eval protocol — A/B re-test + test runner + ltc-reviewer | GREEN |

## Links

- [[2026-03-30-vinh-branch-analysis]]
- [[ADR-002]]
- [[ADR-002-obsidian-cli]]
- [[AP4]]
- [[CLAUDE]]
- [[README]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[VAULT_GUIDE]]
- [[_TEMPLATE]]
- [[alpei-template-usage]]
- [[anti-patterns]]
- [[dsbv]]
- [[ltc-builder]]
- [[ltc-reviewer]]
- [[obsidian-security]]
- [[project]]
- [[security]]
- [[tool-routing]]
- [[workstream]]
