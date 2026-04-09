---
version: "1.3"
status: in-review
last_updated: 2026-04-09
type: always-on rule
---
# Script Registry — Always-On Rule

39 scripts in `scripts/`. 9 archived to `_genesis/reference/archive/scripts/`.
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
| `pkb-ingest-reminder.sh` | Stop | Flag uningested files in `captured/` not logged in `_log.md` |
| `ripple-check.sh` | PostToolUse (Write/Edit on .md) | Show depth-1 and depth-2 backlinks after file edit |
| `session-etl-trigger.sh` | UserPromptSubmit | Debounced wrapper — triggers `session-etl.py` in background |
| `session-etl.py` | (called by trigger above) | Parse Claude JSONL sessions → extract decisions/errors/changes → append to daily vault summaries |
| `memory-guard.sh` | PreToolUse (Write on MEMORY.md) | Validate MEMORY.md 3-section structure before write |

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
| `template-check.sh` | Before PRs or after template-sync | Categorized JSON diff: local vs template remote (auto-add, review-required, local-only) |
| `validate-blueprint.py` | After structural edits or template-sync | 8 checks: dir existence, file presence, frontmatter, naming |
| `validate-memory-structure.sh` | After memory edits | Verify all `MEMORY.md` files have required 3-section structure |
| `alignment-check.sh` | When reviewing DESIGN.md quality | Verify condition-to-artifact mapping completeness |
| `agent-benchmark.sh` | When auditing agent config | Safety, output quality, efficiency checks across 5 agent files |
| `smoke-test.sh` | After `/setup` or harness changes | 5 checks: memory-vault hook system correctly configured |

## Governance & Lifecycle — Run for Version/Status Operations

Use these when managing iterations, versions, or bulk metadata operations.

| Script | When to use | What it does |
|---|---|---|
| `generate-registry.sh` | After editing workstream artifacts | Rebuild `_genesis/version-registry.md` table from frontmatter source truth |
| `iteration-bump.sh` | Advancing subsystem to next iteration | Bump all .md files in a subsystem: version MAJOR, reset status, update dates |
| `readiness-report.sh` | Before iteration advancement | Check Criterion 1-3 (C1-C3) readiness criteria per subsystem. Called by `/dsbv status` |
| `bulk-validate.sh` | Bulk status promotion | Set `status: validated` on all matching .md files under a path (human-invoked only) |
| `frontmatter-extract.sh` | Debugging frontmatter issues | Parse and display YAML frontmatter fields from .md files |

## Obsidian & Knowledge Graph — Run for Vault Maintenance

Use these when managing wikilinks, aliases, or vault structure.

| Script | When to use | What it does |
|---|---|---|
| `obsidian-autolinker.py` | After creating many new files | 3-phase engine: DISCOVER → SCAN → WRITE. Converts plain-text cross-references into [[wikilinks]] |
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
| `template-sync.sh` | Pulling updates from template remote | Additive sync: `--auto-add`, `--file/--action take\|skip`, `--verify` |
| `skill-sync-user.sh` | Sharing skills across repos | Copy project-scope skills to `~/.claude/skills/` (cross-project scope) |

## Learning Pipeline — LEARN Workstream Tools

Use these when working in `2-LEARN/` or evaluating the learning skill suite.

| Script | When to use | What it does |
|---|---|---|
| `learn-benchmark.sh` | Evaluating learn skill quality | Orchestrator: runs L1 + L2 deterministically |
| `learn-benchmark-l1.py` | Static skill contract check | L1: Parse SKILL.md for S × E × Sc compliance |
| `learn-benchmark-l2.py` | Pipeline state simulation | L2: Validate orchestrator state detection logic |

## Cross-Reference: Skills That Call Scripts

| Skill | Scripts used |
|---|---|
| `/dsbv` | `generate-registry.sh`, `readiness-report.sh`, `iteration-bump.sh` |
| `/setup` | `setup-vault.sh`, `smoke-test.sh` |
| `/template-check` | `template-check.sh` |
| `/template-sync` | `template-check.sh`, `template-sync.sh` |
| `/ingest` | `pkb-lint.sh` |
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
