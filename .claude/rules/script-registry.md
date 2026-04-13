---
version: "1.8"
status: draft
last_updated: 2026-04-13
type: always-on rule
---
# Script Registry — Always-On Rule

60 scripts in `scripts/`. 14 hooks in `.claude/hooks/`. 10 archived to `_genesis/reference/archive/scripts/`.
This index is the authoritative lookup for agent script discovery.
Before writing a new script, check here — it may already exist.

## When to Use This Registry

| Agent need | Action |
|---|---|
| "Is there a script that does X?" | Scan the domain group below |
| "What runs automatically?" | Check §Automated — these fire via hooks |
| "What should I run before committing?" | §Pre-Commit Scripts |
| "How do I validate the repo?" | §Validation & Audit |
| Deciding whether to write a new script | Search this file first — duplicates waste maintenance budget |

## Automated — Hook-Invoked (never call manually in normal flow)

These scripts fire automatically via `.claude/settings.json` hooks. The agent does NOT need to call them — they run on the configured event. Listed here so you understand what's enforcing rules behind the scenes.

| Script | Hook Event | Purpose |
|---|---|---|
| `dsbv-gate.sh` | PreToolUse (Bash) + pre-commit | Block workstream N commits if N-1 lacks validated artifact |
| `dsbv-skill-guard.sh` | PreToolUse (Write/Edit) | Block DSBV files in `2-LEARN/`; require DESIGN.md before Build writes |
| `status-guard.sh` | pre-commit | Block `status: validated` — human-only field |
| `link-validator.sh` | pre-commit | Find broken [[wikilinks]] in staged files |
| `registry-sync-check.sh` | pre-commit | Verify staged .md versions match `version-registry.md` |
| `skill-validator.sh` | pre-commit (when skills staged) | Validate skill directory structure (EOP governance) |
| `validate-blueprint.py` | pre-commit (staged, quiet) | 8 structural checks on repo layout |
| `pkb-lint.sh` | SessionStart + Stop | 8-check PKB health audit (uningested, shallow, frontmatter, orphans, links, index, stale, log) |
| `pkb-ingest-reminder.sh` | Stop | Flag uningested files in `1-captured/` not logged in `_log.md` |
| `ripple-check.sh` | PostToolUse (Write/Edit on .md) | Show depth-1 and depth-2 backlinks after file edit |
| `auto-recall-filter.sh` | UserPromptSubmit | QMD auto-recall injection — classify intent, query vault, inject context |
| `session-etl-trigger.sh` | (manual / cron) | Debounced wrapper — triggers `session-etl.py` in background |
| `session-etl.py` | (called by trigger above) | Parse Claude JSONL sessions → extract decisions/errors/changes → append to daily vault summaries |
| `memory-guard.sh` | (not hooked — manual) | Validate MEMORY.md 3-section structure before write |
| `dsbv-provenance-guard.sh` | PreToolUse (Write/Edit) | Block DSBV artifact Write without prior designated agent dispatch (P1 enforcement) |
| `builder-audit.sh` | SubagentStop | Grep builder output for AC markers; warn if self-check skipped (S-FIX-1) |
| `registry-edit-tracker.sh` | PostToolUse (Edit on version-registry.md) | Track version-registry edits to prevent double-bump |

## Pre-Commit Scripts — Run Before Staging

Use these when preparing a commit or when a pre-commit hook fails and you need to diagnose.

| Script | When to use | What it checks |
|---|---|---|
| `status-guard.sh` | Commit blocked with "validated" error | Agent set `status: validated` — fix to `in-review` |
| `link-validator.sh --staged` | Commit blocked with broken link | Broken `[[wikilink]]` in staged .md file |
| `registry-sync-check.sh` | Commit blocked with registry mismatch | Staged .md version doesn't match `version-registry.md` row |
| `skill-validator.sh <dir>` | Commit blocked on skill file | Skill directory missing required files or structure |
| `dsbv-gate.sh` | Commit blocked on chain-of-custody | Upstream workstream lacks validated artifact |

## Validation & Audit — Run to Check Repo Health

Use these proactively before PRs, after major changes, or when diagnosing structural issues.

| Script | When to use | Output |
|---|---|---|
| `pre-flight.sh` | Before starting any workstream task | 9 CLAUDE.md checks: workstream status, alignment, risks, drivers, templates, learning, version, S>E>Sc, decisions |
| `template-check.sh` | Before PRs or after template-sync | v3.0: Categorized JSON diff: local vs template remote (auto-add, review-required, local-only); now includes `lineage` field per file in JSON output |
| `validate-blueprint.py` | After structural edits or template-sync | 8 checks: dir existence, file presence, frontmatter, naming |
| `validate-memory-structure.sh` | After memory edits | Verify all `MEMORY.md` files have required 3-section structure |
| `alignment-check.sh` | When reviewing DESIGN.md quality | Verify condition-to-artifact mapping completeness |
| `agent-benchmark.sh` | When auditing agent config | Safety, output quality, efficiency checks across 5 agent files |
| `smoke-test.sh` | After `/setup` or harness changes | 5 checks: memory-vault hook system correctly configured |
| `gemini-audit.py` | Before push/release — independent audit | Calls Gemini API (1 request). Packages workspace context → writes `inbox/YYYY-MM-DD_gemini-audit.md`. Set `GEMINI_API_KEY` before running. |
| `claude-audit-phase0.py` | Before claude-audit runs | Produce JSON manifest of repo ground truth (files, frontmatter, orphans, hooks) |

## Governance & Lifecycle — Run for Version/Status Operations

Use these when managing iterations, versions, or bulk metadata operations.

| Script | When to use | What it does |
|---|---|---|
| `generate-registry.sh` | After editing workstream artifacts | Rebuild `_genesis/version-registry.md` table from frontmatter source truth |
| `iteration-bump.sh` | Advancing subsystem to next iteration | Bump all .md files in a subsystem: version MAJOR, reset status, update dates |
| `readiness-report.sh` | Before iteration advancement | Check Criterion 1-3 (C1-C3) readiness criteria per subsystem. Called by `/dsbv status` |
| `bulk-validate.sh` | Bulk status promotion | Set `status: validated` on all matching .md files under a path (human-invoked only) |
| `frontmatter-extract.sh` | Debugging frontmatter issues | Parse and display YAML frontmatter fields from .md files |
| `gate-ceremony.sh` | At DSBV gate transitions | Convenience wrapper: runs gate-precheck → set-status-in-review → gate-state advance in sequence (E-FIX-2) |

## DSBV Enforcement — Gate & State Scripts

Use these for DSBV gate enforcement, state tracking, and approval verification. Most are called by hooks or `/dsbv`.

| Script | When to use | What it does |
|---|---|---|
| `gate-precheck.sh` | Before DSBV gate approval | Verify all ACs pass before allowing gate transition |
| `gate-state.sh` | DSBV stage tracking | Read/write DSBV stage state (which stage, which gate) |
| `set-status-in-review.sh` | Before requesting gate approval | Set artifact `status: in-review` with frontmatter update |
| `verify-approval-record.sh` | After gate approval | Grep markdown for approval record row in table |
| `classify-fail.sh` | After builder AC failure | Convert failure output to lowercase-classified error type |

## Bulk Rename — One-Off Migration Scripts

Used once for vocabulary standardization. Kept for reference if similar renames needed.

| Script | When it was used | What it does |
|---|---|---|
| `rename-criterion-vocab.sh` | I0-I4→Iteration 0-4 rename | Find/replace Check/Checklist → Criterion across repo |
| `rename-iteration-shorthand.sh` | I0-I4→Iteration 0-4 rename | Find/replace I0-I4 shorthand → Iteration 0-4 across 135 files |
| `bash3-compat-test.sh` | DSBV SOTA upgrade | Verify all scripts work on Bash 3 (macOS default) |

## Obsidian & Knowledge Graph — Run for Vault Maintenance

Use these when managing wikilinks, aliases, or vault structure.

| Script | When to use | What it does |
|---|---|---|
| `obsidian-autolinker.py` | After creating many new files | 3-stage engine: DISCOVER → SCAN → WRITE. Converts plain-text cross-references into [[wikilinks]] |
| `obsidian-alias-seeder.py` | After bulk file creation | Add `aliases:` to YAML frontmatter for Obsidian resolution |
| `backlink-map.sh` | Analyzing graph structure | Build adjacency list of all [[wikilinks]] in repo |
| `orphan-detect.sh` | Finding disconnected files | Find .md files with zero inbound [[backlinks]] |
| `rename-ripple.sh` | After renaming a file | Find/replace stale [[wikilinks]] across repo |
| `ripple-check.sh` | Before renaming or deleting a file | Show depth-1 and depth-2 backlinks — what depends on this file? |
| `learn-path-lint.sh` | After LEARN restructure | Detect stale flat paths in skill files from old `2-LEARN/` layout |

## Setup & Scaffolding — Run Once or On New Clone

Use these during initial setup, onboarding, or template population. Typically run once per repo or per member.

| Script | When to use | What it does |
|---|---|---|
| `setup-vault.sh` | New repo clone | Create 10 Obsidian vault folders + .gitkeep files (idempotent) |
| `setup-obsidian.sh` | New repo clone | Install LTC Obsidian workspace: copy Bases and Templater templates |
| `setup-member.sh` | New team member onboarding | One-time Memory Vault setup for new project member |
| `generate-readmes.py` | After adding new directories | Generate README shells from `readme-blueprint.md` for all directories |
| `template-sync.sh` | Pulling updates from template remote | v3.1: Additive sync: `--auto-add`, `--file/--action take\|skip`, `--verify`; adds `--detect-path`, `--sync`, `--reverse-clone`, `--bootstrap` modes |
| `skill-sync-user.sh` | Sharing skills across repos | Copy project-scope skills to `~/.claude/skills/` (cross-project scope) |

## Migration & Verification — Template Release Management Tools

Use these when classifying file lineage, computing pristine diffs, verifying structural soundness after sync, or releasing a new template version.

| Script | When to use | What it does |
|---|---|---|
| `template-manifest.sh` | Classify a file's lineage, audit manifest coverage, generate manifest | 3 modes: `--classify <path>` (returns template/shared/domain-seed/domain/deprecated), `--audit` (coverage 100% + overlaps 0 check), `--generate` (stub) |
| `template-diff.sh` | Compute what changed between two template versions before syncing | Pristine diff engine — compares two template SHAs, outputs changeset with lineage + merge strategy per file |
| `template-verify.sh` | After any template sync, before committing; verify repo is structurally sound | 6-check sweep (V1=structural, V2=hooks, V3=graph, V4=agent infra, V5=manifest, V6=sync completeness); exit 0=all pass, 1=failures |
| `template-release.sh` | When releasing a new template version (tag + changelog + notes) | 3 modes: `--dry-run` (preview), `--tag` (create git tag + notes), `--validate` (verify release completeness) |
| `template-merge-engine.py` | Called by template-sync.sh; also useful standalone for merge testing | Section-merge (fence-aware, prefix-match) for CLAUDE.md; 3-way merge via git merge-file for shared files |
| `template-merge-engine.sh` | Shell wrapper for template-merge-engine.py | Thin entrypoint — validates args, activates env, delegates to `template-merge-engine.py` |

## Learning Pipeline — LEARN Workstream Tools

Use these when working in `2-LEARN/` or evaluating the learning skill suite.

| Script | When to use | What it does |
|---|---|---|
| `learn-benchmark.sh` | Evaluating learn skill quality | Orchestrator: runs L1 + L2 deterministically |
| `learn-benchmark-l1.py` | Static skill contract check | L1: Parse SKILL.md for S × E × Sc compliance |
| `learn-benchmark-l2.py` | Pipeline state simulation | L2: Validate orchestrator state detection logic |

## DSBV Benchmarking — DSBV Skill Quality Tools

Use these when evaluating the quality of DSBV skill artifacts.

| Script | When to use | What it does |
|---|---|---|
| `dsbv-benchmark.sh` | Evaluating DSBV skill quality | Orchestrator: runs L1 + L2 DSBV skill benchmarks deterministically |
| `dsbv-benchmark-l1.py` | Static DSBV skill contract check | L1: Parse DSBV SKILL.md for S x E x Sc compliance |
| `dsbv-benchmark-l2-judge.py` | Evaluating DSBV skill output quality | L2: Judge evaluation of DSBV skill output quality |

## Cross-Reference: Skills That Call Scripts

| Skill | Scripts used |
|---|---|
| `/dsbv` | `generate-registry.sh`, `readiness-report.sh`, `iteration-bump.sh`, `gate-precheck.sh`, `gate-state.sh`, `gate-ceremony.sh`, `set-status-in-review.sh`, `verify-approval-record.sh`, `classify-fail.sh` |
| `/setup` | `setup-vault.sh`, `smoke-test.sh` |
| `/template-check` | `template-check.sh`, `template-manifest.sh` |
| `/template-sync` | `template-check.sh`, `template-sync.sh`, `template-manifest.sh`, `template-diff.sh`, `template-verify.sh`, `template-merge-engine.py` |
| `/organise` | `pkb-lint.sh` |
| `/ltc-rules-compliance` | `skill-validator.sh` |
| `/ltc-skill-creator` | `skill-validator.sh` |
| `/learn:review` | `2-LEARN/_cross/scripts/validate-learning-page.sh` (separate from `scripts/`) |
| `/learn:structure` | `2-LEARN/_cross/scripts/validate-learning-page.sh` (separate from `scripts/`) |
| `/obsidian` | `orphan-detect.sh` (repo-scoped alternative to Obsidian REST API) |

## Links

- [[CLAUDE]]
- [[enforcement-layers]]
- [[filesystem-routing]]
- [[git-conventions]]
- [[naming-rules]]
- [[versioning]]
