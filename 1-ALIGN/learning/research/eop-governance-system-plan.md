---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# EOP Governance System — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a 4-artifact governance system (EOP-GOV.md codex, skill-validator.sh, ltc-skill-creator skill, improved /feedback) that deterministically enforces skill quality in all LTC projects.

**Architecture:** Reference doc (what) → validator script (gate) → skill-creator (how) → pre-commit hook (enforcement). The /feedback skill is improved first as the test case that validates the governance system before it ships.

**Tech Stack:** Markdown, Bash (validator), Git hooks

**Spec:** `docs/design/eop-governance-system-spec.md`

**Branch:** `feat/eop-governance` (create from `main`, NOT from `feat/dsbv-process`)

---

## File Structure

### Files Created

```
_shared/reference/EOP-GOV.md                          — Standalone EOP governance codex (8 principles)
scripts/skill-validator.sh                             — Deterministic validator (8 checks, pure bash)
scripts/test-fixtures/bad-skill/SKILL.md               — Deliberately malformed skill for discrimination test
.claude/skills/ltc-skill-creator/SKILL.md              — Updated skill creation procedure
.claude/skills/ltc-skill-creator/references/creation-procedure.md
.claude/skills/ltc-skill-creator/references/anti-patterns.md
.claude/skills/ltc-skill-creator/templates/simple.md
.claude/skills/ltc-skill-creator/templates/standard.md
.claude/skills/ltc-skill-creator/gotchas.md
4-IMPROVE/skills/feedback/references/classification-guide.md
4-IMPROVE/skills/feedback/templates/friction.md
4-IMPROVE/skills/feedback/templates/idea.md
4-IMPROVE/skills/feedback/gotchas.md
```

### Files Modified

```
4-IMPROVE/skills/feedback/SKILL.md                    — Restructured to routing (~70 lines)
CLAUDE.md                                              — Add EOP-GOV.md reference line
```

### Files Deleted

```
skills/skill-creator/SKILL.md                          — Replaced by .claude/skills/ltc-skill-creator/
skills/skill-creator/references/skill-template.md      — Content absorbed into new creation-procedure.md
```

---

## Deliverable 1: EOP-GOV.md — Standalone Codex

Write the governance codex with 8 principles. This is the foundation that everything else references.

**Agent Architecture:** Single Agent — 2 low-complexity tasks; sequential writing with one verification gate

**HOW NOT:**
- Do NOT reference Session 4, Thariq's article, or EP registry as required reading — EOP-GOV.md must be standalone. Cite provenance in a header for maintainers, but every principle must be self-explanatory.
- Do NOT include v2 candidate principles (EOP-09 through EOP-14) — they are explicitly deferred per spec §9. Adding them inflates the doc and violates EOP-09 (Start Simple) which is itself a v2 principle.
- Do NOT copy the EP registry format mechanically — EOP-GOV.md uses a similar structure but the "Compensated by" field becomes "Implemented by" with Design + Validator sub-fields. The component is always EOP.

#### AC Coverage

| Task | Covers ACs |
|---|---|
| T1.1 | N-01, J-01, J-02, A-01 |
| T1.2 | N-01, A-01 |

### Task 1.1: Write EOP-GOV.md

**Files:**
- Create: `_shared/reference/EOP-GOV.md`

- [ ] **Step 1: Create file with header and metadata**

```markdown
# EOP Governance Codex — Skill Quality Standards

> Canonical reference for designing, building, and validating AI agent skills (EOP).
> Standalone — does not require access to source research documents.
> Provenance: AMT Session 4 (EOP research), Anthropic Claude Code team practices,
>   LTC Effective Principles Registry. Cited for maintainer traceability, not required for use.
> Last synced: 2026-03-27

---

## How to Use This Document

- **Creating a skill:** Read the 8 principles before writing. Each principle has a "Design" sub-field telling you what to do.
- **Reviewing a skill:** Use the Diagnostic Table (Part 3) to trace symptoms to principles.
- **Running the validator:** `./scripts/skill-validator.sh <skill-directory>` checks deterministic principles automatically.
- **Retrofitting existing skills:** Run `./scripts/skill-validator.sh --all` for a full audit, then fix violations principle-by-principle.
```

- [ ] **Step 2: Write all 8 principles**

Write each principle (EOP-01 through EOP-08) following this format per principle:

```markdown
### EOP-{NN}: {Name} [{DERISK|OUTPUT}]

**Statement:** {One sentence}

**Why this matters:** {Plain language — what structural limitation or practitioner
pattern creates the need. No jargon references. The explanation IS the truth.}

**Without this:** {Concrete failure scenario}

**Implemented by:**
- Design: {What to do when designing a skill}
- Validator: CHECK-{NN} in skill-validator.sh / "Qualitative — no automated check"

**Example:**

Bad:
> {Before}

Good:
> {After}
```

Principles to write (content derived from spec §3 Artifact 1):

| # | Name | Tag | Key content |
|---|---|---|---|
| EOP-01 | Skills Are Folders | DERISK | A skill is a directory, not a single file. SKILL.md is the entry point; detail goes in references/, templates/, scripts/. |
| EOP-02 | Progressive Disclosure | DERISK | SKILL.md is the routing layer. Detail loaded on-demand from subdirectories. Keeps context lean. |
| EOP-03 | Gotchas Are Highest Signal | DERISK | Document real failure patterns. Updated continuously. Prevents the agent from repeating mistakes it can't remember. |
| EOP-04 | Description Is Trigger | OUTPUT | The description field determines when the skill activates. Write it as a trigger condition with specific keywords, not a summary. |
| EOP-05 | Context Budget Sizing | DERISK | Every token in SKILL.md competes for attention. Routing body ≤200 lines. Detail in references/. |
| EOP-06 | Validation Gates | DERISK | Multi-step skills need explicit GATE checkpoints between steps. Without gates, errors compound silently. |
| EOP-07 | Don't State the Obvious | OUTPUT | Focus on what pushes the agent beyond default knowledge. Remove anything it would do without the skill. |
| EOP-08 | Escape Hatches | DERISK | When the procedure fails, the agent needs an explicit fallback path. Without one, it hallucinates a recovery. |

- [ ] **Step 3: Write Part 2 — Quick Reference Table**

Summarize all 8 principles in one table (like EP registry Part 1).

- [ ] **Step 4: Write Part 3 — Diagnostic Table**

Map symptoms to violated principles (from spec §3 Artifact 1 diagnostic table).

- [ ] **Step 5: Write Part 4 — Validator Cross-Reference**

Table mapping each principle to its CHECK-ID in skill-validator.sh.

- [ ] **Step 6: Commit**

```bash
git add _shared/reference/EOP-GOV.md
git commit -m "feat(shared): add EOP governance codex — 8 principles for skill quality"
```

### Task 1.2: Self-review — standalone readability check

**Files:**
- Read: `_shared/reference/EOP-GOV.md`

- [ ] **Step 1: Read every principle and verify no external doc is required**

For each principle, ask: "Could someone who has never read Session 4, Thariq's article, or the EP registry understand this?" If any principle fails this test, rewrite the "Why this matters" section in plain language.

- [ ] **Step 2: Verify format matches EP registry pattern**

Compare structure to `_shared/reference/effective-agent-principles-registry.md`. Confirm: numbered principles, tags, diagnostic table, quick reference table.

- [ ] **Step 3: Amend commit if changes made**

```bash
git add _shared/reference/EOP-GOV.md
git commit -m "fix(shared): improve EOP-GOV standalone readability"
```

---

## Deliverable 2: skill-validator.sh + Discrimination Test

Write the validator script and prove it discriminates quality.

**Agent Architecture:** Single Agent — 3 low-complexity tasks; sequential because T2.2 (test fixture) and T2.3 (discrimination test) depend on T2.1 (script)

**HOW NOT:**
- Do NOT use Python, Node, or any external dependency — pure bash + grep + awk. The script must run on any macOS/Linux with no install step. (spec J-03)
- Do NOT hardcode skill paths — the script takes a directory argument. `--all` discovers skills dynamically via `find`.
- Do NOT make WARN checks into HARD FAIL — the 3-WARN threshold is intentional. A skill with 1-2 warnings is acceptable; 3+ warnings indicate systemic quality issues.

#### AC Coverage

| Task | Covers ACs |
|---|---|
| T2.1 | V-01, V-04, V-05, N-02, J-03, J-04, A-02, A-05 |
| T2.2 | N-07, J-08 |
| T2.3 | V-01, A-04, T-01, T-02, T-03, T-04 |

### Task 2.1: Write skill-validator.sh

**Files:**
- Create: `scripts/skill-validator.sh`

- [ ] **Step 1: Write the script skeleton**

```bash
#!/usr/bin/env bash
set -euo pipefail

# EOP Governance Validator
# Reference: _shared/reference/EOP-GOV.md
# Checks a skill directory against 8 EOP principles.
# Exit 0 = pass, Exit 1 = fail (hard fail or 3+ warnings)

PASS=0; WARN=0; FAIL=0
WARNS=(); FAILS=()
```

- [ ] **Step 2: Implement argument parsing**

Support: `<skill-dir>`, `--all`, `--staged`, `--ci` (no color).

- [ ] **Step 3: Implement CHECK-01 through CHECK-08**

Each check follows this pattern:
```bash
check_NN() {
  local skill_dir="$1"
  # ... check logic ...
  if [[ condition ]]; then
    pass "CHECK-0N" "description"
  else
    warn "CHECK-0N" "EOP-0N" "message"  # or fail()
  fi
}
```

Checks (from spec §3 Artifact 2):
- CHECK-01: SKILL.md exists in directory (HARD FAIL)
- CHECK-02: YAML frontmatter has `name` field (HARD FAIL)
- CHECK-03: Description field exists and ≥50 chars (HARD FAIL)
- CHECK-04: Trigger language present (multiple patterns) (WARN)
- CHECK-05: Gotchas section or gotchas.md exists (WARN)
- CHECK-06: references/ or templates/ exists — waived if ≤40 lines (WARN)
- CHECK-07: Gate language exists — waived if ≤40 lines (WARN)
- CHECK-08: SKILL.md ≤200 lines routing body (WARN)

- [ ] **Step 4: Implement `--all` mode**

```bash
if [[ "${1:-}" == "--all" ]]; then
  find . -name "SKILL.md" -not -path "*/.claude/worktrees/*" -not -path "*/node_modules/*" | while read -r skill; do
    validate "$(dirname "$skill")"
  done
fi
```

- [ ] **Step 5: Implement output formatting and exit logic**

```
Result: PASS/WARN/FAIL
- HARD FAIL on any CHECK → exit 1
- 3+ WARNs → exit 1
- 1-2 WARNs → exit 0 with warnings
- 0 WARNs → exit 0 clean
```

- [ ] **Step 6: Make executable and commit**

```bash
chmod +x scripts/skill-validator.sh
git add scripts/skill-validator.sh
git commit -m "feat(scripts): add skill-validator.sh — 8 EOP governance checks"
```

### Task 2.2: Create test fixture (deliberately bad skill)

**Files:**
- Create: `scripts/test-fixtures/bad-skill/SKILL.md`

- [ ] **Step 1: Write a deliberately malformed SKILL.md**

Must fail on every check: no YAML frontmatter, no description, >300 lines of filler, no gotchas, no gates, no references/, no escape hatch. Just a raw markdown file with generic content.

- [ ] **Step 2: Commit**

```bash
git add scripts/test-fixtures/bad-skill/SKILL.md
git commit -m "test(scripts): add bad-skill fixture for validator discrimination test"
```

### Task 2.3: Run discrimination test

**Files:**
- Read: `scripts/skill-validator.sh` output

- [ ] **Step 1: Run validator on bad-skill**

```bash
./scripts/skill-validator.sh scripts/test-fixtures/bad-skill/
```
Expected: Exit 1, score 0-2/8 pass.

- [ ] **Step 2: Run validator on /deep-research (known-good, untouched)**

```bash
./scripts/skill-validator.sh skills/deep-research/
```
Expected: Exit 0, score 6+/8 pass.

- [ ] **Step 3: Run validator on current /feedback (known-partial, pre-improvement)**

```bash
./scripts/skill-validator.sh 4-IMPROVE/skills/feedback/
```
Expected: Exit 1 or exit 0 with 3+ warnings. Record exact score as baseline B1.

- [ ] **Step 4: Record discrimination results**

```
bad-skill:      _/8 (expected 0-2)  → PASS/FAIL discrimination
deep-research:  _/8 (expected 6+)   → PASS/FAIL discrimination
feedback:       _/8 (baseline B1)   → Record for later comparison
```

If discrimination fails (bad-skill ≥3 OR deep-research <6): fix validator checks and re-run. Do NOT proceed to Deliverable 3 until discrimination passes.

- [ ] **Step 5: Commit results as a test log**

```bash
# Record in commit message, not a separate file
git commit --allow-empty -m "test(validator): discrimination test passed — bad:X/8, deep-research:Y/8, feedback:Z/8"
```

---

## Deliverable 3: Improve /feedback Skill

Retrofit /feedback using EOP-GOV.md principles. This is the primary test case.

**Agent Architecture:** Single Agent — 5 low-complexity tasks; sequential because each step builds on the previous restructure

**HOW NOT:**
- Do NOT change the GitHub Issue output format — the issue body templates must produce the same fields as today (Reporter, Project, Zone, Severity, What happened, Expected, Suggestion, Context). Backward compatibility is a hard requirement (spec J-06).
- Do NOT add features to /feedback (logging, analytics, auto-categorization) — this is a RETROFIT to governance standards, not a feature enhancement. Scope is strictly: restructure, add gotchas, improve description, add gate.
- Do NOT move /feedback to a different directory — it stays in `4-IMPROVE/skills/feedback/`. Zone-scoped skills live in their zone.

#### AC Coverage

| Task | Covers ACs |
|---|---|
| T3.1 | N-04 (partial), V-06 (baseline) |
| T3.2 | N-04, J-06 |
| T3.3 | N-04 (gotchas) |
| T3.4 | V-06 (post-measurement) |
| T3.5 | V-06 (qualitative) |

### Task 3.1: Record baseline measurements (B1-B5)

**Files:**
- Read: `4-IMPROVE/skills/feedback/SKILL.md`

- [ ] **Step 1: Run validator for B1 (structural score)**

```bash
./scripts/skill-validator.sh 4-IMPROVE/skills/feedback/
```
Record: B1 = X/8 checks pass.

- [ ] **Step 2: Measure B2 (token cost)**

```bash
wc -l 4-IMPROVE/skills/feedback/SKILL.md
```
Record: B2 = X lines × ~13 tokens/line = ~Y tokens.

- [ ] **Step 3: Assess B3 (trigger reliability)**

Read the current `description` field. Score 0-10 on: does it contain trigger keywords? Is it specific enough for auto-invocation? Does it rely on CLAUDE.md for triggering?

Record: B3 = X/10.

- [ ] **Step 4: Count B4 (gotchas coverage)**

Record: B4 = 0 (no gotchas section exists).

- [ ] **Step 5: Count B5 (progressive disclosure)**

```bash
find 4-IMPROVE/skills/feedback/ -type f | wc -l
```
Record: B5 = X files.

- [ ] **Step 6: Record all baselines in commit message**

```bash
git commit --allow-empty -m "measure(feedback): baseline B1=X/8 B2=Ytokens B3=X/10 B4=0gotchas B5=Xfiles"
```

### Task 3.2: Restructure /feedback into folder with progressive disclosure

**Files:**
- Modify: `4-IMPROVE/skills/feedback/SKILL.md`
- Create: `4-IMPROVE/skills/feedback/references/classification-guide.md`
- Create: `4-IMPROVE/skills/feedback/templates/friction.md`
- Create: `4-IMPROVE/skills/feedback/templates/idea.md`

- [ ] **Step 1: Extract classification heuristics to references/**

Move the type/zone/severity detection tables from SKILL.md into `references/classification-guide.md`. Replace in SKILL.md with: `**Reference:** [references/classification-guide.md](references/classification-guide.md)`.

- [ ] **Step 2: Extract issue templates to templates/**

Move the `gh issue create` heredoc templates into `templates/friction.md` and `templates/idea.md`. Replace in SKILL.md with references to the template files.

- [ ] **Step 3: Rewrite SKILL.md as routing layer (~70 lines)**

SKILL.md should contain:
- Frontmatter (name, description — improved, see Step 4)
- Purpose statement (2 sentences)
- Scope (what it IS and IS NOT for)
- Steps (high-level, referencing classification-guide and templates)
- Constraints (the rules list, kept inline — small enough)
- Validation gate: "GATE: Present classification to user. Wait for confirmation before creating issue."

- [ ] **Step 4: Rewrite description as trigger condition**

Current: (no standalone description — relies on CLAUDE.md)

New:
```yaml
description: "Report template-level feedback as GitHub Issues. Use when the user
  expresses frustration, confusion, or suggests an improvement about the APEI scaffold,
  DSBV process, rules, skills, or shared frameworks. Captures friction reports and
  ideas for template maintainers. Do NOT use for project-specific bugs."
```

- [ ] **Step 5: Verify backward compatibility**

Read `templates/friction.md` and `templates/idea.md`. Verify the `gh issue create` commands produce the same issue format (same labels, same body fields) as the original SKILL.md.

- [ ] **Step 6: Commit**

```bash
git add 4-IMPROVE/skills/feedback/
git commit -m "refactor(improve): restructure /feedback for EOP governance — progressive disclosure"
```

### Task 3.3: Add gotchas.md

**Files:**
- Create: `4-IMPROVE/skills/feedback/gotchas.md`

- [ ] **Step 1: Write gotchas from known failure patterns**

```markdown
# /feedback — Gotchas

Known failure patterns. Update this file when new issues are discovered.

## Misclassification: idea tagged as friction (or vice versa)
Claude tends to classify any negative sentiment as "friction" even when
the user is suggesting an improvement (which is an "idea"). Check: does
the user describe a PROBLEM (friction) or a SOLUTION (idea)?

## Zone detection defaults to "agent" too often
When the conversation context involves both zone artifacts and agent
config, Claude defaults to "zone:agent" because .claude/ files are
more salient in context. Check the actual file path or topic being
discussed, not just the most recent tool call.

## gh auth failure silently skipped
If `gh` is not authenticated to the template repo, the skill should
NOT silently skip issue creation. It must tell the user and provide
the issue body as copyable text. Check: `gh auth status` before
attempting `gh issue create`.

## Severity inflation
Claude tends to assign "blocked" severity when the user is merely
"annoyed." Reserve "blocked" for cases where the user explicitly says
they could not proceed. Default to "annoying" unless evidence suggests
otherwise.
```

- [ ] **Step 2: Commit**

```bash
git add 4-IMPROVE/skills/feedback/gotchas.md
git commit -m "feat(improve): add gotchas.md to /feedback — 4 known failure patterns"
```

### Task 3.4: Post-improvement measurement (B1-B5)

**Files:**
- Read: `4-IMPROVE/skills/feedback/` (all files)

- [ ] **Step 1: Run validator for post-B1**

```bash
./scripts/skill-validator.sh 4-IMPROVE/skills/feedback/
```
Record: post-B1 = X/8. Target: 7+/8.

- [ ] **Step 2: Measure post-B2 (token cost)**

```bash
wc -l 4-IMPROVE/skills/feedback/SKILL.md
```
Record: post-B2. Target: <80 lines (~1,040 tokens).

- [ ] **Step 3: Assess post-B3 (trigger reliability)**

Re-read the improved description. Score 0-10 on trigger quality. Target: 7+/10.

- [ ] **Step 4: Count post-B4 (gotchas)**

Count documented failure patterns in gotchas.md. Target: 3+.

- [ ] **Step 5: Count post-B5 (files)**

```bash
find 4-IMPROVE/skills/feedback/ -type f | wc -l
```
Target: 5+ files.

- [ ] **Step 6: Calculate deltas and record**

```
Metric   Baseline   Post    Delta    Target   Pass?
B1       X/8        X/8     +X       7+/8     Y/N
B2       ~Xtokens   ~Xtok   -Xtok    <1040    Y/N
B3       X/10       X/10    +X       7+/10    Y/N
B4       0          X       +X       3+       Y/N
B5       1          X       +X       5+       Y/N
```

GATE: ≥4 of 5 metrics improved. If <4 improved, investigate which metric regressed and fix before proceeding.

- [ ] **Step 7: Commit measurement results**

```bash
git commit --allow-empty -m "measure(feedback): post B1=X/8 B2=Xtok B3=X/10 B4=X B5=X — X/5 metrics improved"
```

### Task 3.5: Qualitative tests (Q1-Q4)

**Files:**
- Read: `4-IMPROVE/skills/feedback/SKILL.md` and supporting files

- [ ] **Step 1: Q1 — Trigger test (observational)**

Note: This test is observational — it describes what to verify in a future session. In a fresh session, express frustration about a template issue without mentioning /feedback. Observe whether the skill triggers. Record: triggered Y/N.

- [ ] **Step 2: Q2 — Classification accuracy**

Feed 3 test scenarios through the classification logic mentally:
1. "This DSBV gate keeps blocking me when I have an approved DESIGN.md" → Should be: friction, zone:agent, severity:confused
2. "It would be nice if the template had a built-in changelog generator" → Should be: idea, zone:improve
3. "The UBS register template is broken — missing columns" → Should be: friction, zone:plan, severity:blocked

Verify the classification-guide.md heuristics produce correct results for all 3.

- [ ] **Step 3: Q3 — Template isolation**

Read SKILL.md. Verify it references templates by path (loaded on-demand) rather than containing both templates inline. Confirm only the relevant template would be loaded during execution.

- [ ] **Step 4: Q4 — Gotchas effectiveness**

Read gotchas.md. For each gotcha, verify it describes: (a) the specific failure, (b) when it happens, (c) what to do instead. If any gotcha is vague, rewrite it.

- [ ] **Step 5: Record qualitative results and commit**

```bash
git commit --allow-empty -m "test(feedback): qualitative Q1=note Q2=X/3 Q3=PASS/FAIL Q4=PASS/FAIL"
```

---

## Deliverable 4: Finalize EOP-GOV.md from Test Results

Update the draft codex with empirical evidence from the /feedback test.

**Agent Architecture:** Single Agent — 2 low-complexity tasks; quick update based on test data

**HOW NOT:**
- Do NOT add new principles based on test results — v1 is 8 principles. If test results suggest a 9th principle, log it as a v2 candidate in the codex's iteration section, do not add it to Part 1.
- Do NOT remove principles that weren't fully tested — EOP-07 (Don't State the Obvious) and EOP-08 (Escape Hatches) are partially tested by /feedback but fully grounded in Session 4 research. They stay.

#### AC Coverage

| Task | Covers ACs |
|---|---|
| T4.1 | N-01 (final), A-01, J-01 |
| T4.2 | A-06 |

### Task 4.1: Update EOP-GOV.md with test evidence

**Files:**
- Modify: `_shared/reference/EOP-GOV.md`

- [ ] **Step 1: Add "Validated by" line to each principle**

For principles fully validated by /feedback test:
```markdown
**Validated:** /feedback retrofit (2026-03-27) — B-metric delta: +X
```

For principles partially validated:
```markdown
**Validated:** Partial — /feedback retrofit tested structure; full validation pending on STANDARD/COMPLEX tier skills
```

- [ ] **Step 2: Add iteration roadmap section at bottom**

```markdown
## Iteration Roadmap

| Version | Scope | Status |
|---|---|---|
| v1 (current) | 8 principles, 8 validator checks | Validated against /feedback |
| v2 | +EOP-09 through EOP-14, tier auto-detection | Pending — after 3+ skills retrofitted |
| v3 | Auto-fix suggestions, CI integration | Pending — after v2 stable 2+ months |
```

- [ ] **Step 3: Commit**

```bash
git add _shared/reference/EOP-GOV.md
git commit -m "docs(shared): finalize EOP-GOV.md with /feedback test evidence"
```

### Task 4.2: Verify extensibility (A-06)

**Files:**
- Read: `_shared/reference/EOP-GOV.md`, `scripts/skill-validator.sh`

- [ ] **Step 1: Dry-run adding a hypothetical EOP-09**

Without writing it, trace the steps: (1) add principle to EOP-GOV.md Part 1 + Part 2, (2) add CHECK-09 to skill-validator.sh. Count files touched: should be exactly 2.

- [ ] **Step 2: Record result**

If >2 files required, note the coupling issue for future fix.

---

## Deliverable 5: ltc-skill-creator (Replace Stale Version)

Replace `skills/skill-creator/` with `.claude/skills/ltc-skill-creator/`.

**Agent Architecture:** Single Agent — 4 low-complexity tasks; sequential because later files reference earlier ones

**HOW NOT:**
- Do NOT keep the old `skills/skill-creator/` alongside the new one — delete it. Two skill-creators causes trigger collision (Session 4 anti-pattern #3).
- Do NOT reference `engine/`, `ILE`, `.cursor/skills/` — these are stale paths from a previous repo architecture. The new skill references `.claude/skills/`, zone-scoped paths, and `_shared/skills/`.
- Do NOT add Gemini CLI or Cursor support in v1 — cross-platform is out of scope per spec §8.

#### AC Coverage

| Task | Covers ACs |
|---|---|
| T5.1 | N-03 |
| T5.2 | N-03 (references) |
| T5.3 | N-03 (templates) |
| T5.4 | J-05 |

### Task 5.1: Write ltc-skill-creator SKILL.md

**Files:**
- Create: `.claude/skills/ltc-skill-creator/SKILL.md`
- Create: `.claude/skills/ltc-skill-creator/gotchas.md`

- [ ] **Step 1: Write SKILL.md (~80 lines routing)**

Frontmatter:
```yaml
---
name: ltc-skill-creator
description: "Create a new skill following LTC EOP governance standards. Use when
  formalizing a repeated pattern into a reusable skill, adding a new capability,
  or packaging a workflow for reuse. Runs skill-validator.sh before human approval."
disable-model-invocation: true
---
```

Body: purpose, when to use, procedure (reference to creation-procedure.md), meta-rules (load EOP-GOV.md), human gate, rules.

- [ ] **Step 2: Write gotchas.md**

Known failure patterns from current skill-creator usage: stale path references, trigger collision with existing skills, forgotten gotchas section, description written as summary not trigger.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/ltc-skill-creator/SKILL.md .claude/skills/ltc-skill-creator/gotchas.md
git commit -m "feat(agent): add ltc-skill-creator skill — EOP-governed skill creation"
```

### Task 5.2: Write reference docs

**Files:**
- Create: `.claude/skills/ltc-skill-creator/references/creation-procedure.md`
- Create: `.claude/skills/ltc-skill-creator/references/anti-patterns.md`

- [ ] **Step 1: Write creation-procedure.md**

Step-by-step procedure (evolved from old `skill-template.md`):
1. Name the skill (kebab-case, capability-descriptive)
2. Define scope (what, when, what NOT, overlap check)
3. Choose tier (SIMPLE ≤40 lines / STANDARD 41-200 lines)
4. Create directory structure
5. Write SKILL.md using tier template
6. Write gotchas.md (minimum 1 entry — "what went wrong when you tested this")
7. Run `./scripts/skill-validator.sh <skill-dir>/`
8. Fix any FAIL or 3+ WARN issues
9. Present to user for approval
10. Commit

- [ ] **Step 2: Write anti-patterns.md**

Extract from Session 4 §10 + Thariq, adapted to be standalone:
- Mega-skill (>200 lines in SKILL.md body)
- Ghost skill (vague description, never triggers)
- Gate-free skill (multi-step, no validation)
- Copy-paste skill (duplicated logic across skills)
- Trigger collision (overlapping descriptions)
- God description ("Use for any coding task")

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/ltc-skill-creator/references/
git commit -m "feat(agent): add skill-creator reference docs — procedure + anti-patterns"
```

### Task 5.3: Write tier templates

**Files:**
- Create: `.claude/skills/ltc-skill-creator/templates/simple.md`
- Create: `.claude/skills/ltc-skill-creator/templates/standard.md`

- [ ] **Step 1: Write simple.md template**

Minimal SKILL.md template for skills ≤40 lines: frontmatter + purpose + when to use + procedure + rules + gotchas placeholder.

- [ ] **Step 2: Write standard.md template**

Full SKILL.md template for 41-200 line skills: frontmatter + purpose + when to use + meta-rules + steps (with GATE keywords) + constraints + escape hatch + references/ structure.

- [ ] **Step 3: Commit**

```bash
git add .claude/skills/ltc-skill-creator/templates/
git commit -m "feat(agent): add skill-creator tier templates — simple + standard"
```

### Task 5.4: Delete old skill-creator + dogfood test

**Files:**
- Delete: `skills/skill-creator/SKILL.md`
- Delete: `skills/skill-creator/references/skill-template.md`

- [ ] **Step 1: Delete old skill-creator**

```bash
rm -rf skills/skill-creator/
```

- [ ] **Step 2: Run validator on new ltc-skill-creator**

```bash
./scripts/skill-validator.sh .claude/skills/ltc-skill-creator/
```
GATE: Must score 7+/8. The skill-creator must pass its own governance checks.

- [ ] **Step 3: Commit**

```bash
git add -A skills/skill-creator/ .claude/skills/ltc-skill-creator/
git commit -m "refactor(agent): replace stale skill-creator with ltc-skill-creator — passes own validator 7+/8"
```

---

## Deliverable 6: Hook Wiring + CLAUDE.md Update

Wire the validator into the deterministic enforcement layer.

**Agent Architecture:** Single Agent — 3 low-complexity tasks; sequential because hook test depends on hook config

**HOW NOT:**
- Do NOT wire the hook to fire on all commits — scope to `*/SKILL.md` and `*/skills/*/` paths only (spec J-07).
- Do NOT use `--no-verify` workarounds in the plan — if the hook fails, fix the skill, don't bypass the hook.
- Do NOT add CI integration in v1 — that's v3 scope per spec §9.

#### AC Coverage

| Task | Covers ACs |
|---|---|
| T6.1 | N-05, V-02, J-07 |
| T6.2 | N-06 |
| T6.3 | V-02 (T-05, T-06) |

### Task 6.1: Configure pre-commit hook

**Files:**
- Modify: `.claude/settings.json` (or create hook script)

- [ ] **Step 1: Determine hook mechanism**

Check if `.claude/settings.json` already has a hooks section. If yes, add to it. If the project uses git hooks directly (`.git/hooks/pre-commit`), use that instead.

- [ ] **Step 2: Add skill-validator hook scoped to skill files**

The hook should:
1. Check if any staged files match `*/SKILL.md` or `*/skills/*/`
2. If yes, run `./scripts/skill-validator.sh --staged`
3. If validator exits 1, block the commit
4. If no skill files staged, exit 0 immediately (no friction)

- [ ] **Step 3: Commit**

```bash
git add .claude/settings.json  # or .git/hooks/pre-commit
git commit -m "feat(agent): add pre-commit hook — skill-validator on SKILL.md changes"
```

### Task 6.2: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Add EOP governance reference**

In the `## Rules` or agent system section, add:

```markdown
## EOP Governance (full spec: `_shared/reference/EOP-GOV.md`)
Before creating or reviewing any skill, load EOP-GOV.md. Run `./scripts/skill-validator.sh` before committing skill changes.
```

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs(root): add EOP governance reference to CLAUDE.md"
```

### Task 6.3: Hook discrimination test

**Files:**
- Read: hook output

- [ ] **Step 1: Test hook blocks bad skill (T-05)**

```bash
cp -r scripts/test-fixtures/bad-skill/ /tmp/test-skill-hook/
git add /tmp/test-skill-hook/  # This won't work — need to stage in-repo
# Instead: temporarily copy bad-skill into a skills path, stage, attempt commit
cp -r scripts/test-fixtures/bad-skill/ .claude/skills/test-bad-skill/
git add .claude/skills/test-bad-skill/
git commit -m "test: should be blocked by hook"
# Expected: commit rejected by hook
```

- [ ] **Step 2: Clean up test and verify hook allows good skill (T-06)**

```bash
rm -rf .claude/skills/test-bad-skill/
git add 4-IMPROVE/skills/feedback/SKILL.md
git commit -m "test: should be allowed by hook"
# Expected: commit succeeds
```

- [ ] **Step 3: Record results**

```
T-05 (hook blocks bad):  PASS/FAIL
T-06 (hook allows good): PASS/FAIL
```

- [ ] **Step 4: Clean up any test artifacts and commit**

```bash
git clean -fd .claude/skills/test-bad-skill/ 2>/dev/null || true
```

---

## Dependency Graph

```
D1 (EOP-GOV.md)
  │
  ├──→ D2 (validator) ──→ D3 (improve /feedback) ──→ D4 (finalize EOP-GOV)
  │                                                       │
  │                                                       ├──→ D5 (ltc-skill-creator)
  │                                                       │
  └───────────────────────────────────────────────────────┴──→ D6 (hook + CLAUDE.md)
```

D1 → D2 → D3 → D4 → D5 (sequential critical path)
D6 depends on D2 (validator) + D4 (final EOP-GOV), parallelizable with D5.

---

## Plan Validation Report

| Check | Result | Notes |
|---|---|---|
| 1. Critical path duration | PASS | D1(1.5h) + D2(1.5h) + D3(2h) + D4(0.5h) + D5(1.5h) + D6(0.5h) = ~7.5h |
| 2. Max tasks/deliverable | PASS | D3 has 5 tasks (max), D5 has 4 — all ≤6 |
| 3. Agent arch vs. matrix | PASS | All deliverables: low count × low complexity = Single Agent |
| 4. File path plausibility | PASS | All parent dirs exist: `_shared/reference/`, `scripts/`, `.claude/skills/`, `4-IMPROVE/skills/feedback/` |
| 5. AC → task coverage | PASS | All V, A, N, J ACs mapped — see AC Coverage tables per deliverable |
| 6. Task → AC coverage | PASS | Every task maps to ≥1 AC |
| 7. HOW NOT present | PASS | All 6 deliverables have HOW NOT sections with 2+ entries each |

**Overall: PASS**

---

*Plan produced by: Long Nguyen + Claude (Governance Agent)*
*Governing skill: ltc-writing-plans*
*Spec: docs/design/eop-governance-system-spec.md*
