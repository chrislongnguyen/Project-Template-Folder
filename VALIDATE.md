---
version: "1.0"
status: draft
last_updated: 2026-04-03
owner: ltc-reviewer
workstream: govern
iteration: I2
type: validate
stage: validate
---

# VALIDATE.md — GOVERN Workstream, I2 (Naming Convention Upgrade)

> DSBV Phase 4 artifact. Per-criterion evidence-based verdicts against DESIGN.md.

---

## Summary

| Metric | Count |
|--------|-------|
| Total ACs | 26 |
| PASS | 21 |
| FAIL | 3 |
| PARTIAL | 2 |

**Recommendation:** FAIL — 3 must-fix issues and 2 should-fix issues before merge approval.

---

## Per-Criterion Verdicts

### A1 — Naming Boundary Table (`_genesis/security/naming-convention.md` § 7)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-1 | Section exists with a 2-column table (Surface -> Format). | PASS | `_genesis/security/naming-convention.md` lines 334-354. Section "## 7. Naming Boundary Table (R1)" contains a 3-column table (Surface / Naming Format / Notes). The Surface and Naming Format columns satisfy the 2-column requirement; Notes is additive. |
| AC-2 | Every surface in current LTC stack is listed (Git, ClickUp, Drive, skills, rules, agents, scripts, frontmatter). | PASS | Lines 340-352. Surfaces listed: Git repos, ClickUp projects, Google Drive folders, Workstream folders, `.claude/skills/`, `.claude/rules/`, `.claude/agents/`, `scripts/`, Frontmatter keys, Frontmatter values, Python identifiers, JavaScript identifiers. All 8 required surfaces present plus 4 additional. |

### A2 — Folder Naming Rule (`_genesis/security/naming-convention.md` § 8)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-3 | Rule states folder format as `{N}-{NAME}/` with regex. | PASS | Lines 357-376. Section "## 8. Workstream Folder Naming (R2)" defines format `{N}-{NAME}/` with regex `^[0-9]+-[A-Z][A-Z-]*/$`. |
| AC-4 | Explicit rejection of `{N}. {NAME}/` with 3+ failure modes cited. | PASS | Lines 385-393. Subsection "### Rejected Pattern: `{N}. {NAME}/`" lists 3 failure modes: (1) Shell quoting, (2) URL encoding, (3) GitHub API incompatibility. |

### A3 — Kebab-case Universal Rule (`_genesis/security/naming-convention.md` § 9)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-5 | Rule lists item types governed (skills, agents, rules, scripts, configs). | PASS | Lines 399-411. Section "## 9. Internal System ID Convention (R3)" has a "Governed Item Types" table listing: Skill files/directories, Agent files, Rule files, Shell scripts, Config files, Markdown reference docs. All 5 required types present plus 1 additional. |
| AC-6 | Code identifier exception documented (snake_case for Python, camelCase for JS). | PASS | Lines 415-424. Subsection "### Code Identifier Exception" contains a table with Python (snake_case), JavaScript/TypeScript (camelCase), and Shell (snake_case) conventions. |

### A4 — Lowercase Frontmatter Rule (`.claude/rules/versioning.md`)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-7 | Rule states "all frontmatter values MUST be lowercase" with before/after example. | PARTIAL | `.claude/rules/versioning.md` lines 17-29. Section "## Frontmatter Value Casing" states the rule and provides a before/after example. However, **the file's own frontmatter violates this rule**: line 3 reads `status: Draft` (uppercase D). The artifact contradicts itself. **Fix required:** Change line 3 from `status: Draft` to `status: draft`. |
| AC-8 | YAML boolean hazard noted (quote values that could parse as boolean). | PASS | Lines 31-39. Boolean hazard documented with `reviewed: yes` (wrong) vs `reviewed: "yes"` (correct) example. |

### A5 — Skill Prefix Registry (`_genesis/security/naming-convention.md` § 10)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-9 | Table lists exactly 5 prefix slots with scope description. | PASS | Lines 430-439. Section "## 10. Skill Prefix Registry (R5)" contains a 4-column table with 5 rows: `ltc-`, `dsbv-`, `vault-`, `gws-`, and `(none)`. Each has a Domain description. |
| AC-10 | Rule states new prefixes require explicit approval. | PASS | Lines 442-443. First bullet under "### Rules" states: "New prefix requires explicit approval. To add a sixth prefix: propose to Long Nguyen (project owner), document rationale, receive explicit approval, then update this registry before using the prefix in any skill." |

### A6 — Template Location Rule (`_genesis/security/naming-convention.md` § 11)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-11 | Rule states template files go in `_genesis/templates/` with kebab-case names. | PASS | Lines 449-462. Section "## 11. Template File Location (R6)" states location and shows kebab-case examples. |
| AC-12 | Explicit rejection of `TEMPLATES - {name}` prefix pattern with rationale. | PASS | Lines 464-472. Subsection "### Rejected Pattern" rejects the prefix with 3 reasons: spaces in filenames, grep noise, URL encoding. |

### A7 — Version Format Rule (`.claude/rules/versioning.md`)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-13 | New field `iteration_name` documented with enum values (logic-scaffold, concept, prototype, mve, leadership). | PASS | `.claude/rules/versioning.md` lines 62-74. Field documented in "The 4 Fields" table (line 62) and enum table (lines 66-73) lists all 5 values: `logic-scaffold`, `concept`, `prototype`, `mve`, `leadership`. |
| AC-14 | Rule states numeric `version` is primary (sortable, CI/CD), semantic label is supplementary. | PASS | Line 74: "Numeric `version` is primary (sortable, CI/CD compatible). `iteration_name` is supplementary metadata for human readability and Obsidian filtering." |

### A8 — Always-on Naming Rule (`.claude/rules/naming-rules.md`)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-15 | File exists with frontmatter. | PASS | `.claude/rules/naming-rules.md` lines 1-5. YAML frontmatter present with version, status, last_updated. All values lowercase. |
| AC-16 | References `_genesis/security/naming-convention.md` as full spec. | PASS | Line 8: `Full spec: _genesis/security/naming-convention.md` |
| AC-17 | Contains the cheat sheet table (item type -> format -> example). | PASS | Lines 19-36. "## Cheat Sheet" table with 3 columns: "Creating a..." / Format / Example. Covers 15 item types including all required categories. |

### A9 — Enforcement Layer Hooks (`.claude/hooks/naming-lint.sh` + `settings.json`)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-18 | `PostToolUse Write` hook validates frontmatter fields (lowercase values, required fields present) and feeds result to Claude via `additionalContext`. | PARTIAL | `.claude/hooks/naming-lint.sh` lines 39-77. PostToolUse section checks `status` casing (line 54-59) and `version` format (line 64-69), outputs via `jq` with `additionalContext` key (line 73). However, the hook only checks for uppercase `Draft`, `Review`, `Approved` status values — it does **not** validate that required fields are present (version, status, last_updated). The AC says "required fields present" but the hook only checks casing. **Should-fix:** Add presence check for the 3 required frontmatter fields. |
| AC-19 | `PreToolUse Write` hook warns (not blocks) when filename contains spaces, dots, or violates kebab-case for internal items. | PASS | Lines 18-37. PreToolUse section checks: directory spaces (line 23), dot-space numbered prefix (line 25), filename spaces (line 27). Uses `permissionDecision: "allow"` (line 34) — warns but does not block. Dot-in-filename check covers the `{N}. NAME` pattern specifically. |
| AC-20 | Both hooks registered in `.claude/settings.json` under `hooks` key. | PASS | `.claude/settings.json` lines 62-86. `PostToolUse` with matcher `"Write"` registered at line 63, pointing to `.claude/hooks/naming-lint.sh`. `PreToolUse` with matcher `"Write"` registered at line 76, pointing to same script. Both under the `hooks` key. |

### A10 — Enforcement Layers Reference (`.claude/rules/enforcement-layers.md`)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-21 | File exists as always-on rule with YAML frontmatter. | PASS | `.claude/rules/enforcement-layers.md` lines 1-6. YAML frontmatter with version: "1.0", status: draft, last_updated: 2026-04-03, type: always-on rule. |
| AC-22 | Contains 4x3 matrix (session-load/tool-use/commit/review x documentation/automated/human-gate). | PASS | Lines 14-32. ASCII table with 4 rows (Session Load, Tool Use, Commit, Review) and 3 columns (Documentation, Automated Check, Human Gate). All 12 cells populated. |
| AC-23 | Each cell maps to concrete LTC artifact (e.g., "Tool use x Automated = PreToolUse hooks in settings.json"). | PASS | Each cell references specific artifacts: `.claude/rules/ files`, `SessionStart hooks`, `PreToolUse / PostToolUse hooks`, `permission modes`, `git-conventions.md`, `template-check.sh`, `skill-validator.sh`, `GitHub Actions`, `DSBV phase gates (G1-G4)`, `Code review`, `ltc-reviewer agent`. |
| AC-24 | References 7-CS components each layer maps to (EP, EOE, EOT, EOP). | PASS | Lines 35-42. "## 7-CS Mapping" table maps EP, EOE, EOT, EOP to their enforcement layers. |

### A11 — Migration Backlog Stub (`5-IMPROVE/changelog/CHANGELOG.md`)

| AC | Criterion (from DESIGN.md) | Verdict | Evidence |
|----|---------------------------|---------|----------|
| AC-25 | CHANGELOG entry exists documenting what needs migration. | PASS | `5-IMPROVE/changelog/CHANGELOG.md` lines 21-24. Section "### Migration Backlog (out of scope -- future I2 task)" lists 3 items: retroactive lowercase migration, skill folder rename audit, template filename audit. |
| AC-26 | Entry explicitly states "out of scope for this DSBV cycle." | FAIL | Line 21 reads: "### Migration Backlog (out of scope -- future I2 task)". The phrase used is "out of scope" but says "future I2 task" rather than "out of scope for this DSBV cycle." This is a semantic near-miss but the intent is clear. However, I am marking this FAIL because the exact phrasing "out of scope for this DSBV cycle" is not present -- the entry says "future I2 task" which could be interpreted as still within I2, just deferred. The DESIGN.md intent is to make clear this work is NOT part of the current DSBV cycle. **Fix required:** Change the heading or add a sentence stating explicitly: "Out of scope for the current DSBV cycle (GOVERN I2 naming convention upgrade)." |

---

## Cross-Cutting Assessment

### Completeness

| # | Artifact | File Exists | Verdict |
|---|----------|------------|---------|
| A1 | Naming boundary table | YES — `_genesis/security/naming-convention.md` § 7 | OK |
| A2 | Folder naming rule | YES — `_genesis/security/naming-convention.md` § 8 | OK |
| A3 | Kebab-case universal rule | YES — `_genesis/security/naming-convention.md` § 9 | OK |
| A4 | Lowercase frontmatter rule | YES — `.claude/rules/versioning.md` updated | OK |
| A5 | Skill prefix registry | YES — `_genesis/security/naming-convention.md` § 10 | OK |
| A6 | Template location rule | YES — `_genesis/security/naming-convention.md` § 11 | OK |
| A7 | Version format rule | YES — `.claude/rules/versioning.md` updated | OK |
| A8 | Always-on naming rule | YES — `.claude/rules/naming-rules.md` created | OK |
| A9 | Enforcement layer hooks | YES — `.claude/hooks/naming-lint.sh` + settings.json | OK |
| A10 | Enforcement layers reference | YES — `.claude/rules/enforcement-layers.md` created | OK |
| A11 | Migration backlog stub | YES — `5-IMPROVE/changelog/CHANGELOG.md` entry | OK |

**Result: 11/11 artifacts present on disk.**

### Quality — Frontmatter Compliance

| File | version | status | last_updated | Verdict |
|------|---------|--------|--------------|---------|
| `_genesis/security/naming-convention.md` | "1.1" | draft | 2026-04-03 | OK |
| `.claude/rules/versioning.md` | "1.4" | Draft | 2026-04-03 | **FAIL** — `status: Draft` violates the lowercase rule this file introduces |
| `.claude/rules/naming-rules.md` | "1.0" | draft | 2026-04-03 | OK |
| `.claude/hooks/naming-lint.sh` | 1.0 | draft | 2026-04-03 | OK (comment header format) |
| `.claude/rules/enforcement-layers.md` | "1.0" | draft | 2026-04-03 | OK |
| `5-IMPROVE/changelog/CHANGELOG.md` | "1.0" | Draft | 2026-04-01 | **FAIL** — (1) `status: Draft` not lowercase; (2) `last_updated: 2026-04-01` is stale (should be 2026-04-03 since content was modified) |

### Coherence — Cross-Artifact Consistency

| Check | Result |
|-------|--------|
| naming-rules.md cheat sheet matches naming-convention.md § 7 boundary table | PASS — Both list the same surfaces with consistent format assignments. Cheat sheet is a compact superset. |
| naming-rules.md skill prefix table matches naming-convention.md § 10 | PASS — Both list the same 5 prefixes with matching domains. |
| versioning.md iteration_name enum matches DESIGN.md spec | PASS — All 5 values present and lowercase. |
| enforcement-layers.md references correct hook events vs. settings.json | PASS — Matrix references PreToolUse/PostToolUse; settings.json registers both. |
| naming-lint.sh behavior matches enforcement-layers.md "Tool Use x Automated" cell | PASS — Hook implements the enforcement described in the matrix. |
| CHANGELOG.md entries match actual artifacts produced | PASS — All 6 CHANGELOG entries (3 Added, 2 Changed, 1 Migration Backlog) correspond to real artifacts. |
| versioning.md says "The 4 Fields" (line 56) but the old file in main repo says "The 3 Fields" | OK — This is intentional; iteration_name is the 4th field added by A7. |

### Downstream Readiness

**Question:** Could a new team member follow the naming convention using just these files?

**Assessment:** YES, with the following reading path:
1. `.claude/rules/naming-rules.md` (always-on, loaded every session) provides the cheat sheet
2. `_genesis/security/naming-convention.md` (full spec, linked from the cheat sheet) provides complete rules
3. `.claude/rules/enforcement-layers.md` explains where rules are enforced
4. `.claude/hooks/naming-lint.sh` + `settings.json` provide automated guardrails

The system is self-documenting and self-enforcing. A new team member would get warnings from the hooks before they could commit a naming violation.

---

## Required Fixes (Must-Fix)

| # | Severity | File | Issue | Fix |
|---|----------|------|-------|-----|
| F1 | FAIL | `.claude/rules/versioning.md` line 3 | `status: Draft` — uppercase D violates the lowercase frontmatter rule introduced in this same file (line 19). Self-contradicting artifact. | Change to `status: draft` |
| F2 | FAIL | `5-IMPROVE/changelog/CHANGELOG.md` line 3 | `status: Draft` — uppercase D violates the lowercase frontmatter rule from versioning.md. | Change to `status: draft` |
| F3 | FAIL | `5-IMPROVE/changelog/CHANGELOG.md` line 4 | `last_updated: 2026-04-01` — stale date. File was modified as part of this DSBV cycle (new I2 section added). | Change to `last_updated: 2026-04-03` |

## Recommended Fixes (Should-Fix)

| # | Severity | File | Issue | Fix |
|---|----------|------|-------|-----|
| S1 | PARTIAL (AC-18) | `.claude/hooks/naming-lint.sh` | PostToolUse checks casing but does not check presence of required fields (version, status, last_updated). DESIGN.md AC-18 says "validates frontmatter fields (lowercase values, required fields present)". | Add presence checks for the 3 required fields. |
| S2 | PARTIAL (AC-26) | `5-IMPROVE/changelog/CHANGELOG.md` line 21 | Migration backlog heading says "out of scope -- future I2 task" but does not explicitly state "out of scope for this DSBV cycle." The current phrasing could imply the work is still within I2, just deferred. | Add explicit statement: "Out of scope for the current DSBV cycle." |

---

## Verdict

**STATUS: BLOCKED — 3 must-fix issues prevent merge approval.**

The 3 FAIL items (F1-F3) are all low-effort fixes (single-line edits). The 2 PARTIAL items (S1-S2) are recommended but not blocking. Once F1-F3 are resolved, re-validate and approve at G4.
