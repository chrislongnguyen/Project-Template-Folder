---

## version: "1.0"
last_updated: 2026-04-03
owner: Long Nguyen
workstream: govern
iteration: I2
status: draft
type: design
stage: design

# DESIGN.md — GOVERN Workstream, I2 (Naming Convention Upgrade)

> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.

---

## Scope Check


| Question                                            | Answer                                                                                                                                    |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| Q1: Are upstream workstream outputs sufficient?     | YES — GAN synthesis complete (3-agent, 8 external sources, 10 principles evaluated). Current naming rules and naming-convention.md read.  |
| Q2: What is in scope for this workstream-iteration? | R1-R7 naming convention upgrades derived from GAN synthesis. Update existing rule files + add new sections.                               |
| Q2b: What is explicitly OUT of scope?               | Renaming existing files/skills (migration). Obsidian vault naming (Vinh's domain). ClickUp/Drive retroactive renames. New skill creation. |
| Q3: Go/No-Go — proceed?                             | GO                                                                                                                                        |


---

## Design Decisions

**Intent:** Upgrade LTC naming conventions to be effective across all systems — stable (S), functional (E), and scalable (Sc) — by implementing 7 GAN-validated rules into the template's governance layer.

**Key constraints:**

- All changes must be backward-compatible (no existing file renames in this iteration)
- Changes land in `.claude/rules/` and `_genesis/security/` (authoritative sources)
- Frontmatter lowercase migration (R4) is documented as a rule but NOT executed on existing files (migration is out of scope)
- GOVERN exception applies: operational rule patches skip workstream chain-of-custody

**Source of truth:** `2-LEARN/output/Naming_Convention_GAN_Synthesis.md`

---

## Artifact Inventory


| #   | Artifact                     | Path                                                         | Purpose (WHY)                                                                                                                                                                            | Acceptance Conditions                                                                                                                                                                                                                                                                                                                                                     |
| --- | ---------------------------- | ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A1  | Naming boundary table        | `_genesis/security/naming-convention.md` (new § 2b)          | R1: Explicitly document which surfaces use UNG vs kebab-case. Eliminates two-tier ambiguity.                                                                                             | AC-1: Section exists with a 2-column table (Surface → Format). AC-2: Every surface in current LTC stack is listed (Git, ClickUp, Drive, skills, rules, agents, scripts, frontmatter).                                                                                                                                                                                     |
| A2  | Folder naming rule           | `_genesis/security/naming-convention.md` (new § 2c)          | R2: Codify `{N}-{NAME}/` format and explicitly reject dots+spaces in folder names with rationale.                                                                                        | AC-3: Rule states folder format as `{N}-{NAME}/` with regex. AC-4: Explicit rejection of `{N}. {NAME}/` with 3+ failure modes cited.                                                                                                                                                                                                                                      |
| A3  | Kebab-case universal rule    | `_genesis/security/naming-convention.md` (new § 7)           | R3: Codify kebab-case as the system ID format for all internal items, with code-layer exception.                                                                                         | AC-5: Rule lists item types governed (skills, agents, rules, scripts, configs). AC-6: Code identifier exception documented (snake_case for Python, camelCase for JS).                                                                                                                                                                                                     |
| A4  | Lowercase frontmatter rule   | `.claude/rules/versioning.md` (update § Required Metadata)   | R4: Mandate lowercase for all frontmatter VALUES. Rationale: Obsidian Bases case-sensitivity.                                                                                            | AC-7: Rule states "all frontmatter values MUST be lowercase" with before/after example. AC-8: YAML boolean hazard noted (quote values that could parse as boolean).                                                                                                                                                                                                       |
| A5  | Skill prefix registry        | `_genesis/security/naming-convention.md` (new § 8)           | R5: Define max 5 registered prefixes for skill naming. Prevents namespace explosion at scale.                                                                                            | AC-9: Table lists exactly 5 prefix slots with scope description. AC-10: Rule states new prefixes require explicit approval.                                                                                                                                                                                                                                               |
| A6  | Template location rule       | `_genesis/security/naming-convention.md` (new § 2c addendum) | R6: Codify that templates live in `_genesis/templates/` (folder separation), not filename prefixes.                                                                                      | AC-11: Rule states template files go in `_genesis/templates/` with kebab-case names. AC-12: Explicit rejection of `TEMPLATES - {name}` prefix pattern with rationale.                                                                                                                                                                                                     |
| A7  | Version format rule          | `.claude/rules/versioning.md` (update)                       | R7: Add `iteration_name` as optional metadata field. Numeric version stays primary.                                                                                                      | AC-13: New field `iteration_name` documented with enum values (logic-scaffold, concept, prototype, mve, leadership). AC-14: Rule states numeric `version` is primary (sortable, CI/CD), semantic label is supplementary.                                                                                                                                                  |
| A8  | Always-on naming rule        | `.claude/rules/naming-rules.md` (NEW file)                   | Compact always-on rule that references the full spec. Loaded every session.                                                                                                              | AC-15: File exists with frontmatter. AC-16: References `_genesis/security/naming-convention.md` as full spec. AC-17: Contains the cheat sheet table (item type → format → example).                                                                                                                                                                                       |
| A9  | Enforcement layer hooks      | `.claude/hooks/naming-lint.sh` + settings.json entry         | L3 enforcement: 2 hooks that catch high-frequency naming/frontmatter violations at tool-use time. Trimmed from 6→2 via S×E×Sc audit (low-frequency checks belong in scripts, not hooks). | AC-18: `PostToolUse Write` hook validates frontmatter fields (lowercase values, required fields present) and feeds result to Claude via `additionalContext`. AC-19: `PreToolUse Write` hook warns (not blocks) when filename contains spaces, dots, or violates kebab-case for internal items. AC-20: Both hooks registered in `.claude/settings.json` under `hooks` key. |
| A10 | Enforcement layers reference | `.claude/rules/enforcement-layers.md` (NEW always-on rule)   | Cross-cutting reference: 4-stage × 3-mechanism MECE matrix of all enforcement points. Ensures agents wire up ALL layers when creating rules, not just documentation.                     | AC-21: File exists as always-on rule with YAML frontmatter. AC-22: Contains 4×3 matrix (session-load/tool-use/commit/review × documentation/automated/human-gate). AC-23: Each cell maps to concrete LTC artifact (e.g., "Tool use × Automated = PreToolUse hooks in settings.json"). AC-24: References 7-CS components each layer maps to (EP, EOE, EOT, EOP).           |
| A11 | Migration backlog stub       | `5-IMPROVE/changelog/CHANGELOG.md` (entry)                   | Log retroactive migration (existing file renames, frontmatter case migration) as future I2 task. NOT executed now.                                                                       | AC-25: CHANGELOG entry exists documenting what needs migration. AC-26: Entry explicitly states "out of scope for this DSBV cycle."                                                                                                                                                                                                                                        |


**Alignment check:**

- Orphan conditions = 0 (all 26 ACs map to artifacts A1-A11)
- Orphan artifacts = 0 (every artifact has 2+ ACs)
- R1-R7 coverage: R1→A1, R2→A2, R3→A3, R4→A4, R5→A5, R6→A6, R7→A7, cross-cutting→A8
- Enforcement coverage: L3 hooks→A9, enforcement blueprint→A10, migration backlog→A11
- Hook count: 2 (high-freq/high-impact only). Low-freq checks deferred to scripts (L5) and CI (L7).

---

## Execution Strategy


| Field            | Value                                                                                                   |
| ---------------- | ------------------------------------------------------------------------------------------------------- |
| Pattern          | Pattern 1: Single agent, sequential tasks                                                               |
| Why this pattern | Rule file edits are deterministic — one correct answer per rule. No diversity benefit from multi-agent. |
| Why NOT simpler  | Could do ad-hoc edits, but 8 artifacts with 17 ACs need structured tracking to avoid drift.             |
| Agent config     | 1x ltc-builder (Sonnet), sequential task execution                                                      |
| Git strategy     | All work in existing worktree `I2/chore/governance-sweep`. One commit per artifact or logical group.    |
| Human gates      | G1 (this doc), G2 (sequence approval), G3 (build review before commit), G4 (validate)                   |
| Cost estimate    | ~25K tokens build (11 artifacts, mostly additive sections + 2 new files + 1 shell script). Low cost.    |


---

## Dependencies


| Dependency                   | From                                                                           | Status                                                              |
| ---------------------------- | ------------------------------------------------------------------------------ | ------------------------------------------------------------------- |
| GAN Synthesis                | 2-LEARN/output/Naming_Convention_GAN_Synthesis.md                              | Ready (in worktree)                                                 |
| Visual Guide                 | 2-LEARN/output/Naming_Convention_Visual_Guide.md                               | Ready (in worktree)                                                 |
| Current naming-convention.md | _genesis/security/naming-convention.md                                         | Ready (read, 341 lines)                                             |
| Current versioning.md        | .claude/rules/versioning.md                                                    | Ready (read, v1.3)                                                  |
| naming-rules.md              | .claude/rules/                                                                 | Does not exist yet — A8 creates it                                  |
| enforcement-layers.md        | .claude/rules/                                                                 | Does not exist yet — A10 creates it                                 |
| Claude Code hooks docs       | [https://code.claude.com/docs/en/hooks](https://code.claude.com/docs/en/hooks) | Ready (fetched, 4 hook types, JSON output schema, matcher patterns) |
| agent-system.md              | .claude/rules/agent-system.md                                                  | Ready (read, 390 lines, 7-CS framework)                             |


---

## Human Gates


| Gate | Trigger           | Decision Required                             |
| ---- | ----------------- | --------------------------------------------- |
| G1   | Design complete   | Approve this DESIGN.md to proceed to SEQUENCE |
| G2   | Sequence complete | Approve task ordering                         |
| G3   | Build complete    | Review all 8 artifacts against 17 ACs         |
| G4   | Validate complete | Approve for merge to main                     |


---

## Readiness Conditions (C1-C6)


| ID  | Condition                                                                | Status |
| --- | ------------------------------------------------------------------------ | ------ |
| C1  | Clear scope — R1-R7, GOVERN, in worktree                                 | GREEN  |
| C2  | Input materials — GAN synthesis + current rules read                     | GREEN  |
| C3  | Success rubric — 17 binary ACs defined above                             | GREEN  |
| C4  | Process definition — dsbv-process.md loaded via /dsbv                    | GREEN  |
| C5  | Prompt engineered — focused on naming rules only                         | GREEN  |
| C6  | Evaluation protocol — human review against ACs at G3, ltc-reviewer at G4 | GREEN  |


