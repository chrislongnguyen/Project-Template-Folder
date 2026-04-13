---
version: "1.5"
status: draft
last_updated: 2026-04-13
release_version: v2.1.0
release_date: 2026-04-12
requires: v2.0.0
---

# Release Notes — LTC Project Template v2.1.0

> Released: 2026-04-12 | Requires: v2.0.0 | 129 commits

---

## This Release In 30 Seconds

Since Iteration 0, every template update has meant another round of manual refactoring — copying files, merging by hand, hoping nothing broke. That stops with v2.1.0.

**Template updates now protect your work automatically.** The new sync system classifies every file — it knows which files are templates, which are shared (merged carefully), and which are your generated content (domain - never touched). Your charter, your decisions, your domain content — untouched. Your CLAUDE.md `## Project` section — preserved automatically. Future upgrades go from hours of manual work to minutes of guided automation.

This is the last disruptive upgrade. From here, syncing is incremental.

---

## What Changes For You

### 1. Template Updates Stop Breaking Your Work

| | v2.0.0 | v2.1.0 |
|---|---|---|
| **How you sync** | Open GitHub compare, review every file, copy one by one, manually merge CLAUDE.md, run validation, hope nothing was missed | Run `/template-sync` — the agent walks you through it |
| **Risk to your content** | High — easy to overwrite your charter, decisions, or CLAUDE.md customizations | None — your domain files are classified and never touched |
| **Time** | 2-4 hours | 15-30 minutes |
| **Verification** | Manual spot-checking | Automated 6-category sweep before you commit |
| **Tracking** | "What version am I on?" — unknown | Checkpoint file records exactly where you are |

### 2. Every Folder Now Tells You What Goes Where

In v2.0.0, opening a workstream folder like `1-ALIGN/` gave you a sparse README: "ALIGN workstream artifacts." Not helpful when you're deciding where to put a new decision record or risk register.

In v2.1.0, all 30 workstream READMEs have been rewritten with:
- **Visual diagrams** showing how the workstream fits in the ALPEI cycle
- **Artifact maps** listing exactly which documents belong here
- **Direct links** to the templates you should use
- **Subsystem notes** clarifying what goes at PD level vs cross-cutting

You no longer need to ask anyone where a file goes. The folder tells you.

### 3. Repo Validation Is One Step, Not Four

In v2.0.0, checking repo health meant running 4+ separate scripts and remembering which ones to use. Coverage was partial — roughly 40% of potential issues caught.

In v2.1.0, one command runs all 6 verification categories: structure, hooks, knowledge graph, agent config, file manifest, and sync state. It exits with pass or fail. Nothing to remember, nothing to miss.

```
bash scripts/template-verify.sh
```

### 4. Agents Can No Longer Bypass Your Approval

In v2.0.0, an agent could write a DESIGN.md directly without being properly dispatched — effectively bypassing the PM review gate. You had no way to know it happened.

In v2.1.0, a new guardrail automatically blocks agents from writing work-stage artifacts unless they were dispatched through the proper channel. Work-stage approvals are tracked in a state file (not human memory), and the `/dsbv` skill handles the full approval sequence for you. No manual tracking required.

### 5. Finding the Right Tool Is Instant

In v2.0.0, discovering which skill or script to use meant listing directories and reading headers. Duplicate scripts were sometimes created because no one knew the original existed.

In v2.1.0, a categorized index of all 60 scripts and 28 skills is loaded into every session automatically. You describe what you need, and the index is already in context. No searching required.

---

## What Else Improved

| Change | Why It Matters To You |
|--------|----------------------|
| Consistent terminology across all frameworks | "Phase" vs "Stage" confusion eliminated — one vocabulary everywhere |
| Subsystem ordering enforced (PD → DP → DA → IDM) | Downstream work can't accidentally build on stale upstream principles |
| New `.md` files get version/status/date automatically | No more "missing frontmatter" errors on commit |
| Relevant vault context surfaces automatically when you ask questions | Better answers without manually searching your knowledge base |
| Windows/WSL compatibility for template scripts | Team members on Windows can now participate fully |
| 265 files deleted — empty stubs, wrong-schema placeholders, legacy drafts | Cleaner repo, less confusion about what's real vs placeholder |
| GitHub issue templates added | Bug reports now use a structured format with triage labels |

---

## Issues Fixed

| # | What Was Wrong | What's Fixed |
|---|----------------|-------------|
| #17 | New `.md` files sometimes didn't get frontmatter injected — the hook was non-deterministic, so some files slipped through | Frontmatter injection is now deterministic. The hook reliably adds `version`, `status`, and `last_updated` to every new `.md` file on creation |
| #21, #22 | Template-check and template-sync scripts failed on Windows/WSL — path separators and shell syntax were macOS-only | All template management scripts now work on both macOS and Windows/WSL |
| #24 | Generated README files contained broken `[[wikilinks]]` pointing to wrong targets — the generator was using old file names | README generator updated to use correct current file names; all existing READMEs regenerated with valid links |
| #29 | "I0", "I1", "I2" shorthand and "Check/Checklist" terminology were used inconsistently across 135+ files — some said "I0", others said "Iteration 0", some said "Check", others "Criterion" | All 135 files standardized: "I0-I4" → "Iteration 0-4" everywhere, "Check/Checklist" → "Criterion" everywhere |
| #31 | Charter template had an incorrect VANA definition — the acronym expansion was wrong | Corrected VANA definition in charter template to match the authoritative framework |
| #32 | The `/dsbv` skill could run Design and Sequence stages without dispatching a dedicated agent — it would write artifacts directly, skipping the quality gate | Design and Sequence stages now require agent dispatch as a mandatory step — the skill enforces it before any artifact write |
| #33, #34 | The `/learn:research` skill's handoff between orchestrator and sub-agents was undocumented — the orchestrator sometimes wrote files it shouldn't, and sub-agents didn't know which files to produce | Handoff protocol documented: orchestrator creates the research brief, sub-agents produce the output files, boundaries are explicit in the skill definition |
| CVE-2026-39363 | Vite dependency in the Obsidian Bases training deck had a known security vulnerability (GitHub alerts #3, #4) | Updated `package.json` to patched Vite version |

---

## How To Upgrade

The migration guide has everything you need — including a copy-paste prompt that lets your Claude agent walk you through the entire process step by step.

**Read:** [`_genesis/guides/migration-guide.md`](_genesis/guides/migration-guide.md) — start at "Step 0: Copy This Prompt."

The guide covers: safety setup (branch + backup tag), connecting to the template remote, automatic path detection, the sync itself, verification, and rollback if anything goes wrong.

---

## Annex: Complete File Inventory (v2.0.0 → v2.1.0)

113 files added, 283 modified, 265 deleted, 103 renamed. Grouped by what they do for you.

### A. Template Sync & Migration

_The tools that make upgrading safe and automated._

| Status | File | What It Does |
|--------|------|-------------|
| Added | `_genesis/template-manifest.yml` | Declares every template file's ownership (template / shared / domain) and merge strategy |
| Added | `.template-checkpoint.yml` | Records your last sync version and SHA — so future syncs are incremental |
| Added | `scripts/template-diff.sh` | Computes what changed between two template versions — shows only template-side changes |
| Added | `scripts/template-manifest.sh` | Classifies any file's lineage; audits manifest coverage |
| Added | `scripts/template-merge-engine.py` | Section-merges CLAUDE.md (preserves your `## Project` block); 3-way merge for shared files |
| Added | `scripts/template-merge-engine.sh` | Shell wrapper for the merge engine |
| Added | `scripts/template-verify.sh` | 6-check validation sweep: structure, hooks, graph, agents, manifest, sync |
| Added | `scripts/template-release.sh` | Automates tagging and release notes scaffolding (used by template maintainers) |
| Modified | `scripts/template-check.sh` | v3.0: Now outputs categorized JSON with lineage classification per file |
| Modified | `scripts/template-sync.sh` | v3.1: Added `--sync`, `--detect-path`, `--reverse-clone`, `--bootstrap` modes |
| Modified | `_genesis/guides/migration-guide.md` | v3.2: Agent-executable guide with copy-paste Step 0 prompt for PMs |

### B. Workstream Guides (READMEs)

_Every folder now explains what belongs inside it._

| Status | File |
|--------|------|
| Modified | `1-ALIGN/README.md`, `1-ALIGN/_cross/README.md`, `1-ALIGN/1-PD/README.md`, `1-ALIGN/2-DP/README.md`, `1-ALIGN/3-DA/README.md`, `1-ALIGN/4-IDM/README.md` |
| Modified | `2-LEARN/README.md`, `2-LEARN/_cross/README.md`, `2-LEARN/1-PD/README.md`, `2-LEARN/2-DP/README.md`, `2-LEARN/3-DA/README.md`, `2-LEARN/4-IDM/README.md` |
| Modified | `3-PLAN/README.md`, `3-PLAN/_cross/README.md`, `3-PLAN/1-PD/README.md`, `3-PLAN/2-DP/README.md`, `3-PLAN/3-DA/README.md`, `3-PLAN/4-IDM/README.md` |
| Modified | `4-EXECUTE/README.md`, `4-EXECUTE/1-PD/README.md`, `4-EXECUTE/2-DP/README.md`, `4-EXECUTE/3-DA/README.md`, `4-EXECUTE/4-IDM/README.md` |
| Added | `4-EXECUTE/_cross/README.md` |
| Modified | `5-IMPROVE/README.md`, `5-IMPROVE/_cross/README.md`, `5-IMPROVE/1-PD/README.md`, `5-IMPROVE/2-DP/README.md`, `5-IMPROVE/3-DA/README.md`, `5-IMPROVE/4-IDM/README.md` |
| Modified | `DAILY-NOTES/README.md`, `inbox/README.md`, `MISC-TASKS/README.md`, `PEOPLE/README.md`, `PERSONAL-KNOWLEDGE-BASE/README.md` |

### C. Work-Stage Management (DSBV)

_How the system tracks your progress through Design → Sequence → Build → Validate._

| Status | File | What It Does |
|--------|------|-------------|
| Added | `scripts/gate-ceremony.sh` | Runs the full approval sequence in one step (called by `/dsbv`, not manually) |
| Added | `scripts/gate-precheck.sh` | Checks all acceptance criteria before allowing a gate transition |
| Added | `scripts/gate-state.sh` | Reads/writes work-stage state to a JSON file |
| Added | `scripts/set-status-in-review.sh` | Marks an artifact as "ready for review" |
| Added | `scripts/verify-approval-record.sh` | Confirms an approval row exists in the artifact |
| Added | `scripts/classify-fail.sh` | Categorizes builder failures for clearer error messages |
| Added | `scripts/readiness-report.sh` | Checks readiness criteria before advancing to next iteration |
| Added | `scripts/iteration-bump.sh` | Bulk-updates version numbers when starting a new iteration |
| Added | `scripts/bulk-validate.sh` | Sets `status: validated` across matching files (human-invoked only) |
| Modified | `scripts/dsbv-gate.sh` | v2.2: Added risks/drivers as operational exceptions — no longer blocks writing to risk/driver registers |
| Modified | `scripts/dsbv-skill-guard.sh` | v1.3: Same operational exception for risks/drivers |
| Modified | `.claude/skills/dsbv/SKILL.md` | v2.4: Added Generator/Critic loop, circuit breaker, dispatch-as-step enforcement |
| Modified | `.claude/skills/dsbv/references/context-packaging.md` | Updated with dispatch examples |
| Added | `.claude/skills/dsbv/references/circuit-breaker-protocol.md` | Prevents infinite revision cycles — stops after 3 rounds |
| Added | `.claude/skills/dsbv/references/live-test-patterns.md` | Quality patterns for build-stage output |

### D. Safety & Guardrails (Hooks)

_Automated protections that run behind the scenes — you never invoke these directly._

| Status | File | What It Protects |
|--------|------|-----------------|
| Added | `.claude/hooks/dsbv-provenance-guard.sh` | Blocks agents from writing DESIGN.md / SEQUENCE.md / VALIDATE.md without proper dispatch |
| Added | `.claude/hooks/builder-audit.sh` | Warns if a builder agent skips its acceptance criteria self-check |
| Added | `.claude/hooks/inject-frontmatter.sh` | Auto-adds version/status/date to every new `.md` file |
| Added | `.claude/hooks/auto-recall-filter.sh` | Surfaces relevant vault context automatically when you ask questions |
| Modified | `.claude/hooks/nesting-depth-guard.sh` | v2.0: Now writes structured dispatch audit log |
| Modified | `.claude/hooks/lib/config.sh` | Updated hook configuration |
| Modified | `.claude/hooks/resume-check.sh` | Updated for new session format |
| Modified | `.claude/hooks/session-reconstruct.sh` | Updated for new session format |
| Modified | `.claude/hooks/session-summary.sh` | Updated for new session format |
| Modified | `.claude/hooks/state-saver.sh` | Updated for new session format |
| Modified | `.claude/hooks/verify-agent-dispatch.sh` | Updated dispatch verification |
| Modified | `.claude/hooks/verify-deliverables.sh` | Updated deliverable checks |
| Modified | `.claude/settings.json` | Hook configuration updated to register all new hooks |
| Deleted | `.claude/hooks/validate-frontmatter.sh` | Replaced by `inject-frontmatter.sh` (proactive injection instead of reactive validation) |

### E. Skills

_What you can ask the agent to do. New skills are marked; existing skills were updated._

| Status | File | What It Does |
|--------|------|-------------|
| Added | `.claude/skills/claude-audit/SKILL.md` | 21-area hybrid audit pipeline — checks repo health before pushing |
| Added | `.claude/skills/ltc-feedback/SKILL.md` | Report issues as structured GitHub Issues |
| Added | `.claude/skills/ltc-wms-adapters/SKILL.md` | Shared adapter library for ClickUp and Notion integrations |
| Added | `.claude/skills/ltc-wms-adapters/clickup/templates/` | 7 ClickUp entity templates (project, workstream, deliverable, task, increment, documentation, blocker) |
| Added | `.claude/skills/ltc-wms-adapters/notion/templates/` | 4 Notion entity templates (deliverable, iteration, task, subtask) |
| Added | `.claude/skills/README.md` | User-facing catalog of all 28 skills |
| Modified | `.claude/skills/ltc-brainstorming/SKILL.md` | Updated discovery modes and trade-off framework |
| Modified | `.claude/skills/ltc-brand-identity/SKILL.md` | Updated color palette references |
| Modified | `.claude/skills/ltc-naming-rules/SKILL.md` | Updated with UNG v2 conventions |
| Modified | `.claude/skills/ltc-rules-compliance/SKILL.md` | Updated scope matrix |
| Modified | `.claude/skills/ltc-skill-creator/SKILL.md` | Updated creation procedure |
| Modified | `.claude/skills/obsidian/SKILL.md` | Updated with security rules (AP1-AP5) |
| Modified | `.claude/skills/setup/SKILL.md` | Updated config format |
| Modified | `.claude/skills/template-check/SKILL.md` | Updated for v3.0 JSON output |
| Modified | `.claude/skills/template-sync/SKILL.md` | Updated for v3.1 sync modes |
| Modified | `.claude/skills/vault-capture/SKILL.md` | Updated capture workflow |
| Modified | `.claude/skills/git-save/SKILL.md` | Updated commit workflow |
| Modified | `.claude/skills/ingest/SKILL.md` | Updated schema references |
| Added | Various `gotchas.md` files | Known pitfalls documented for 8 skills (git-save, ltc-clickup-planner, obsidian, root-cause-tracing, template-check, template-sync, vault-capture, dsbv) |
| Added | `.claude/skills/deep-research/references/effective-agent-principles-registry.md` | Research principles reference |
| Added | `.claude/skills/template-sync/references/legacy-workflow.md` | Documents the old sync workflow for comparison |

**Skills flattened:** 49 files moved from nested directories (`.claude/skills/process/`, `.claude/skills/research/`, `.claude/skills/session/`, `.claude/skills/wms/`, `.claude/skills/quality/`) to root-level directories under `.claude/skills/`. Same skills, faster discovery.

### F. Templates

_What you use to create new artifacts. New templates fill gaps where PMs had to create from scratch._

| Status | File | What It's For |
|--------|------|--------------|
| Added | `_genesis/templates/sequence-template.md` | SEQUENCE.md — was missing entirely, PMs had to invent the format |
| Added | `_genesis/templates/release-notes-template.md` | Standardized release notes for future template versions |
| Added | `_genesis/templates/effective-system-design-template.md` | System design methodology template |
| Added | `_genesis/templates/adr-000-template.md` | Architecture Decision Record with numbered format |
| Added | `_genesis/templates/learning-book/page-6-integration-and-practice.md` | P6 learning page — was missing from the set |
| Added | `_genesis/templates/memory-seeds/user_role.md` | Starter memory file for new project onboarding |
| Modified | `_genesis/templates/design-template.md` | v1.3: Added Approval Log, iteration context, binary AC examples |
| Modified | `_genesis/templates/dsbv-eval-template.md` | v1.2: Rewritten with Completeness/Quality/Coherence/Downstream dimensions |
| Modified | `_genesis/templates/dsbv-process.md` | v1.6: Added gate scripts, Generator/Critic loop, circuit breaker |
| Modified | `_genesis/templates/dsbv-context-template.md` | v1.2: Added Budget/max_tool_calls, EP filtering |
| Modified | `_genesis/templates/charter-template.md` | Corrected VANA definition (#31) |
| Modified | `_genesis/templates/learn-input-template.md` | Updated interview questions |
| Modified | All other templates in `_genesis/templates/` | Vocabulary standardization (Phase → Stage, I0 → Iteration 0, Check → Criterion) |

### G. Validation & Quality Scripts

_How you check that your repo is healthy._

| Status | File | What It Does |
|--------|------|-------------|
| Added | `scripts/pre-flight.sh` | 9 checks before starting any task: workstream status, alignment, risks, drivers, templates, learning, version, priorities, decisions |
| Added | `scripts/alignment-check.sh` | Verifies DESIGN.md acceptance criteria map to artifacts |
| Added | `scripts/generate-registry.sh` | Rebuilds the version registry from frontmatter — catches drift |
| Added | `scripts/registry-edit-tracker.sh` | Prevents accidental double-bumps on the version registry |
| Added | `scripts/agent-benchmark.sh` | Safety, output quality, and efficiency checks across agent files |
| Added | `scripts/dsbv-benchmark.sh`, `dsbv-benchmark-l1.py`, `dsbv-benchmark-l2-judge.py` | DSBV skill quality benchmarks (static contract check + judge evaluation) |
| Added | `scripts/learn-benchmark.sh`, `learn-benchmark-l1.py`, `learn-benchmark-l2.py` | Learning skill quality benchmarks (contract check + pipeline simulation) |
| Added | `scripts/claude-audit-phase0.py` | Produces JSON manifest of repo ground truth for audit input |
| Added | `scripts/gemini-audit.py` | Independent Gemini API audit — writes results to `inbox/` |
| Added | `scripts/session-etl-trigger.sh`, `scripts/session-etl.py` | Parse Claude session logs → extract decisions/errors → append to daily vault summaries |
| Modified | `scripts/validate-blueprint.py` | Updated structural checks |
| Modified | `scripts/status-guard.sh` | Updated S2 vocabulary |
| Modified | `scripts/link-validator.sh` | Updated link resolution |
| Modified | `scripts/registry-sync-check.sh` | Updated for new registry format |
| Modified | `scripts/skill-validator.sh` | Updated skill structure checks |
| Modified | `scripts/validate-memory-structure.sh` | Updated memory format validation |

### H. Agent Configuration

_How the 4 agents (planner, builder, reviewer, explorer) behave._

| Status | File | What Changed |
|--------|------|-------------|
| Modified | `.claude/agents/ltc-builder.md` | v1.7: Structural AC scope (builder handles structural checks, reviewer handles semantic) |
| Modified | `.claude/agents/ltc-reviewer.md` | v1.6: Semantic AC scope split from builder |
| Modified | `.claude/agents/ltc-explorer.md` | v1.6: Parallel tool use protocol — faster research via concurrent calls |
| Modified | `.claude/agents/ltc-planner.md` | Updated safety rules and contracts |
| Added | `.claude/agents/README.md` | Agent roster overview |
| Added | `.claude/README.md` | Claude config directory overview |
| Added | `AGENTS.md` | Quick reference at repo root |
| Added | `codex.md` | OpenAI Codex agent configuration — cross-IDE support |

### I. Rules (Always-On Context)

_Loaded every session. These shape how the agent works in your repo._

| Status | File | What Changed |
|--------|------|-------------|
| Added | `.claude/rules/script-registry.md` | Index of all 60 scripts and 28 skills — always in agent context |
| Added | `.claude/rules/README.md` | Overview of all 12 rule files |
| Modified | `.claude/rules/versioning.md` | Iteration naming, frontmatter casing, status lifecycle diagram |
| Modified | `.claude/rules/git-conventions.md` | Canonical commit format, scope list, staging rules |
| Modified | `.claude/rules/agent-dispatch.md` | 4 MECE agents, context packaging, worktree paths |
| Modified | `.claude/rules/filesystem-routing.md` | 4-mode routing decision tree |
| Modified | `.claude/rules/enforcement-layers.md` | 4×3 matrix with hook event quick-reference |
| Modified | `.claude/rules/naming-rules.md` | Skill prefix registry, folder format rejection |
| Modified | `.claude/rules/alpei-chain-of-custody.md` | Subsystem sequence enforcement |
| Modified | `.claude/rules/alpei-template-usage.md` | Template-first artifact creation |
| Modified | `.claude/rules/sub-agent-output.md` | Completion report format |
| Modified | `.claude/rules/memory-format.md` | MEMORY.md 3-section structure |
| Modified | `.claude/rules/obsidian-security.md` | AP1 hard block, L9 hybrid sweep |

### J. Frameworks & Reference

_The underlying LTC knowledge that governs all projects._

| Status | File | What Changed |
|--------|------|-------------|
| Added | `_genesis/alpei-blueprint.md` | Renamed from `BLUEPRINT.md` — canonical ALPEI structure definition |
| Added | `_genesis/guides/README.md` | Guides directory overview |
| Added | `_genesis/tools/README.md` | Tools directory overview |
| Added | `_genesis/reference/system-thinking-extensions.md` | Systems thinking methodology |
| Added | `_genesis/sops/alpei-standard-operating-procedure.md` | ALPEI operating procedure |
| Modified | `_genesis/frameworks/alpei-dsbv-process-map.md` | v1.6: Added sequence-template routing |
| Modified | `_genesis/frameworks/alpei-dsbv-process-map-p1.md` through `p4.md` | S2 vocabulary alignment |
| Modified | `_genesis/frameworks/ltc-alpei-framework-overview.md` | Updated for Iteration 2 |
| Modified | `_genesis/frameworks/ltc-alpei-framework-by-subsystems.md` | Updated subsystem descriptions |
| Modified | `_genesis/frameworks/ltc-effective-learning.md` | Updated learning hierarchy |
| Modified | `_genesis/frameworks/ltc-effective-thinking.md` | Updated thinking framework |
| Modified | `_genesis/frameworks/ltc-ubs-uds-framework.md` | Updated force analysis |
| Modified | `_genesis/frameworks/ltc-ues-version-behaviors.md` | Updated version behavior matrix |
| Modified | `_genesis/frameworks/history-version-control.md` | Updated version conventions |
| Modified | `_genesis/frameworks/learning-hierarchy.md` | Updated hierarchy levels |
| Modified | `_genesis/reference/ltc-effective-agent-principles-registry.md` | Updated 14 EPs |
| Modified | `_genesis/reference/ltc-effective-system-design.md` | Updated system design spec |
| Modified | `_genesis/reference/ltc-effectiveness-guide.md` | Updated guide |
| Modified | `_genesis/reference/ltc-eop-gov.md` | Updated EOP governance codex |
| Modified | `_genesis/reference/ltc-ai-agent-system-project-template-guide.md` | Updated agent system guide |
| Modified | `_genesis/reference/frontmatter-schema.md` | Updated schema spec |
| Modified | `_genesis/version-registry.md` | Updated all rows for v2.1.0 artifacts |
| Modified | `_genesis/cross-dependency-map.md` | Updated dependency graph |
| Modified | `_genesis/filesystem-blueprint.md` | Updated directory tree |
| Modified | `CLAUDE.md` | Updated project instructions, hook counts, script counts |
| Modified | `_genesis/training/` (20+ files) | Both training decks updated — slide content, vocabulary standardization, Vite dependency patch |
| Modified | `_genesis/sops/` (8 files) | SOPs updated for v2.1.0 conventions |
| Modified | `_genesis/security/` (3 files) | Security docs updated |
| Modified | `rules/` (5 files) | On-demand rule specs updated (agent-system, brand-identity, filesystem-routing, naming-rules, tool-routing) |
| Modified | `GEMINI.md` | Updated for v2.1.0 |
| Modified | `README.md` | Updated project overview |

### K. Obsidian & Knowledge Graph

_Tools for maintaining the wikilink graph and vault health._

| Status | File | What Changed |
|--------|------|-------------|
| Modified | `scripts/obsidian-autolinker.py` | Updated link discovery |
| Modified | `scripts/obsidian-alias-seeder.py` | Updated alias generation |
| Modified | `scripts/backlink-map.sh` | Updated graph analysis |
| Modified | `scripts/orphan-detect.sh` | Updated orphan detection |
| Modified | `scripts/rename-ripple.sh` | Updated ripple analysis |
| Modified | `scripts/ripple-check.sh` | Updated for PostToolUse hook |
| Modified | `scripts/learn-path-lint.sh` | Updated path patterns |
| Modified | `scripts/pkb-lint.sh` | Updated 8-check audit |
| Modified | `scripts/pkb-ingest-reminder.sh` | Updated reminder logic |
| Modified | `2-LEARN/_cross/scripts/validate-learning-page.sh` | Updated 17-column validation |
| Renamed | `_genesis/obsidian/bases/` (18 files) | Bases renamed from C1-C7/W1-W5/U1-U6 prefix to numeric 01-18 for consistent sorting |
| Modified | `_genesis/obsidian/templates/` (12 files) | Obsidian Templater templates updated with vocabulary standardization |
| Modified | `_genesis/obsidian/src/templates/` (6 files) | Source templates updated |

### L. GitHub & Issue Management

| Status | File | What It Does |
|--------|------|-------------|
| Added | `.github/ISSUE_TEMPLATE/ltc-issue.yml` | Structured issue template with force analysis fields |
| Added | `.github/ISSUE_TEMPLATE/config.yml` | Issue template configuration |
| Added | `.github/workflows/issue-triage.yml` | Auto-labels issues by type |

### M. Setup & Onboarding

| Status | File | What Changed |
|--------|------|-------------|
| Added | `scripts/README.md` | Scripts directory overview |
| Added | `scripts/skill-sync-user.sh` | Copy project skills to user-scope for cross-repo use |
| Modified | `scripts/setup-vault.sh` | Updated vault scaffold |
| Modified | `scripts/setup-obsidian.sh` | Updated Obsidian installer |
| Modified | `scripts/setup-member.sh` | Updated onboarding flow |
| Modified | `scripts/smoke-test.sh` | Updated harness checks |
| Modified | `scripts/generate-readmes.py` | Updated README generation with correct wikilinks (#24) |
| Modified | `scripts/frontmatter-extract.sh` | Updated field parsing |

### N. Risk & Driver Registers

| Status | File | What It Does |
|--------|------|-------------|
| Added | `3-PLAN/_cross/UBS_REGISTER.md` | Cross-subsystem risk register — 5 seeded entries with heat map and mitigation |
| Added | `3-PLAN/_cross/UDS_REGISTER.md` | Cross-subsystem driver register — 6 forces with leverage strategy |
| Added | `5-IMPROVE/_cross/cross-version-review.md` | Cross-version review tracking |

### O. Cursor & Multi-IDE Support

| Status | File |
|--------|------|
| Added | `.cursor/rules/agent-roster.md`, `dsbv-process.md`, `enforcement-layers.md`, `filesystem-routing.md`, `naming-rules.md` |
| Modified | `.cursor/rules/system-design.md` |
| Added | `.agents/rules/template-version.md` |
| Added | `.agents/skills/README.md` |
| Modified | `.agents/rules/agent-diagnostic.md`, `agent-system.md`, `brand-identity.md`, `system-design.md` |

### P. Vocabulary Standardization Scripts (one-time use)

_Used once for the I0-I4 → Iteration 0-4 rename. Kept for reference._

| Status | File | What It Did |
|--------|------|------------|
| Added | `scripts/rename-iteration-shorthand.sh` | Replaced I0-I4 → Iteration 0-4 across 135 files |
| Added | `scripts/rename-criterion-vocab.sh` | Replaced Check/Checklist → Criterion across 50+ files |
| Added | `scripts/bash3-compat-test.sh` | Verified all scripts work on macOS default Bash 3 |

### Q. Deleted — Empty Stubs & Legacy Files

_These were removed because they added confusion without value. 265 files total._

| Category | Count | Examples |
|----------|-------|---------|
| PKB distilled wiki + scaffold | 68 | Entire `PERSONAL-KNOWLEDGE-BASE/distilled/` wiki (60+ pages), `dashboard.md`, `knowledge-map.canvas`, `captured/` content. **Ships empty — PMs populate locally after cloning.** |
| Nested skill directories (flattened) | 49 | `.claude/skills/process/`, `.claude/skills/research/`, `.claude/skills/session/`, `.claude/skills/wms/`, `.claude/skills/quality/` — same skills, now at root level |
| Empty DSBV stubs (wrong schema) | 40 | `1-ALIGN/1-PD/DESIGN.md`, `1-ALIGN/1-PD/SEQUENCE.md`, `1-ALIGN/1-PD/VALIDATE.md` and equivalents across 4 subsystems × 5 workstreams |
| Empty workstream stubs (ALIGN) | 15 | `1-ALIGN/1-PD/pd-charter.md`, `pd-okr.md`, `pd-decision-adr-template.md` — subsystem-level placeholder files with no content |
| Empty workstream stubs (PLAN) | 16 | `3-PLAN/1-PD/pd-architecture.md`, `pd-roadmap.md`, `pd-risk-register.md`, `pd-driver-register.md` — same pattern |
| LEARN pipeline stubs | 18 | `2-LEARN/2-DP/dp-literature-review.md`, `2-LEARN/3-DA/da-research-spec.md` — LEARN uses a pipeline, not these file types |
| Unreferenced reference files | 16 | Old PDFs, PowerPoints, and drafts in `_genesis/reference/archive/` |
| Empty workstream stubs (IMPROVE) | 14 | `5-IMPROVE/1-PD/pd-changelog.md`, `pd-metrics.md`, `pd-retro-template.md` — same pattern |
| `.gitkeep` placeholders | 11 | `4-EXECUTE/docs/api/.gitkeep`, `3-PLAN/architecture/diagrams/.gitkeep`, and similar empty directories |
| Deprecated scripts | 8 | `scripts/populate-blueprint.py`, `scripts/migrate-status.sh`, `scripts/validate-brainstorming-i3.sh` |
| Old vault scaffold | 6 | `_genesis/obsidian/vault/` directory — replaced by `scripts/setup-vault.sh` |
| WMS sync scripts (archived) | 3 | `_genesis/scripts/wms-sync/` — superseded by `/ltc-wms-adapters` skill |
| Miscellaneous | 3 | `_genesis/BLUEPRINT.md` (renamed to `alpei-blueprint.md`), `.claude/hooks/validate-frontmatter.sh` (replaced by `inject-frontmatter.sh`), `.claude/rules/example-api-conventions.md` |

---

## Links

- [[CHANGELOG]]
- [[migration-guide]]
- [[template-manifest]]
- [[versioning]]
