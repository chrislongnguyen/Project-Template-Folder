---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: design-proposal
work_stream: 0-GOVERN
iteration: 1
title: "DESIGN: Agent 3 — ltc-builder (Maker)"
agent: builder
parent: inbox/2026-04-08_agent-system-8component-design.md
---

# DESIGN: Agent 3 — ltc-builder (Maker)

> **Purpose:** Full 8-component system design for ltc-builder, the Maker agent.
> DSBV Phase 3 (Build). Sonnet model. The ONLY agent that modifies the codebase.
>
> **Parent document:** `inbox/2026-04-08_agent-system-8component-design.md`
>
> **Governing equation:** Success = Efficient & Scalable Management of Failure Risks (UT#5)
> **Evaluation criteria:** Sustainability > Efficiency > Scalability (DT#1)
> **RACI:** Human Director = A, Main Session = C (orchestrator), ltc-builder = R (build only)

---

## 1. Agent Identity Card

```
Name:            ltc-builder
Role:            Maker — produce artifacts per approved sequence
Model:           Sonnet (balanced speed/quality/cost)
Pipeline pos:    DSBV Phase 3 (Build) — third in chain
RACI:            R only — builds, never designs or validates
Agent type:      Leaf node — cannot dispatch sub-agents (EP-13)
Agent file:      .claude/agents/ltc-builder.md (v1.4)
Tool count:      5 (Read, Edit, Write, Bash, Grep)
Dispatch skills: /dsbv build (single or N-parallel competing hypotheses)
```

---

## 1b. Dispatch Modes

Builder is NOT limited to the DSBV chain. It operates in multiple modes:

| Mode | Trigger | EI Source | EO Destination | Context Weight |
|------|---------|-----------|----------------|----------------|
| **DSBV Build** | `/dsbv build [workstream]` | Orchestrator (5-field + SEQUENCE.md tasks) | Reviewer (via orchestrator) | Full: context package + ACs |
| **Competing hypotheses** | `/dsbv build` (design-heavy) | Orchestrator (N parallel dispatches) | Orchestrator (Opus synthesis) | Full: each builder gets complete task set |
| **Ad-hoc file creation** | "Write X" or "Create Y" | Orchestrator (lighter: what + constraints) | Main session directly | Light: deliverable + constraints |
| **Ad-hoc fix/edit** | "Fix bug in X" or "Update Y" | Orchestrator (path + instruction) | Main session directly | Minimal |
| **Skill/rule creation** | `/ltc-skill-creator` or direct | Orchestrator (spec + template) | Main session (review) | Medium |

**Key insight:** In ad-hoc mode, builder returns directly to main session — no reviewer handoff. Generator/Critic loop applies ONLY in DSBV chain mode. In ad-hoc mode, main session validates directly (acts as both orchestrator AND reviewer).

**EOE risk by mode:**
- DSBV chain: HIGHEST risk (14 hooks lost, formal handoff to reviewer)
- Ad-hoc: LOWER risk (main session validates output immediately)
- Competing hypotheses: HIGHEST risk × N (parallel degraded EOE)

---

## 2. Pipeline Position

```
                        ┌── DSBV Pipeline ──┐
                        │                    │
  Explorer ──→ Planner ──→ ▶ BUILDER ◀ ──→ Reviewer ──→ Human
  (haiku)      (opus)      (sonnet)        (opus)       Director
  research     DESIGN.md   artifacts       VALIDATE.md  approval
               SEQUENCE.md                              (G4)

  BUILDER is:
  • The ONLY agent that writes to the codebase
  • The ONLY agent with Edit/Write tools
  • The MOST AFFECTED by hook degradation (writes without guardrails)
  • The "Generator" in the Generator/Critic loop with Reviewer
```

---

## 2. Eight-Component Design

### 2.1 EI — Effective Input

#### Current State

Builder receives a context-packaged prompt from the orchestrator with these fields:
- **EO:** Task contract from SEQUENCE.md (e.g., "Task T1.3 produces updated SKILL.md...")
- **INPUT:** Context (project identity, prior decisions) + Files (Read/Write labels with paths) + Budget (token/scope)
- **EP:** 2-3 applicable principles + behavioral constraints
- **OUTPUT:** Deliverable format + binary acceptance criteria
- **VERIFY:** Deterministic checks (file existence, grep, script exit code)

Source: `.claude/skills/dsbv/references/context-packaging.md` v1.5

The builder also receives implicit EI from the filesystem — it reads input files declared in the context package before producing output.

#### Frontier Standard

ADK: `input_key` + `output_key` typed discipline. Each task has a named, schema-validated input contract.
Handoff.json pattern (arXiv 2026): upstream agent provides `{artifact, reasoning, assumptions[], uncertain[], confidence_score}` so downstream agent can validate assumptions before building on them.

#### Gap

**G-EI-1:** No assumption validation. Builder receives SEQUENCE.md tasks and trusts them completely. If planner hallucinated a requirement (LT-1), builder faithfully implements it. arXiv tested 6 frameworks — all 6 propagated false premises through the entire chain without detection.

**G-EI-2:** No typed input schema. Builder parses the context package as freeform text. If a file path is wrong or missing, builder discovers this at execution time (costly), not at input validation time (cheap).

#### S × E × Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 6/10 | 5-field context packaging prevents ad-hoc prompts. But: no assumption validation = silent error propagation from upstream |
| Efficiency | 7/10 | Read/Write labels in context package reduce guessing. Budget field caps token spend |
| Scalability | 7/10 | Same context package format works for single or parallel builders. N builders receive same structure |

#### UBS / UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-EI-1 | No assumption validation — trusts upstream output as ground truth | Technical |
| UBS | UBS-EI-2 | No typed input schema — discovers bad paths at execution time | Technical |
| UBS | UBS-EI-3 | Context-packaged by orchestrator — quality depends on orchestrator diligence | Human |
| UDS | UDS-EI-1 | 5-field template eliminates "just do the thing" anti-pattern | Technical |
| UDS | UDS-EI-2 | File paths with Read/Write labels reduce ambiguity | Technical |
| UDS | UDS-EI-3 | Budget field prevents unbounded token spend | Economic |

---

### 2.2 EU — Effective User

#### Current State

Claude Sonnet 4.6 (200K context window). Middle tier — balances speed, quality, and cost.

RACI: R (Responsible for producing artifacts). Never A (human only). Leaf node — cannot dispatch further agents. If research is needed, STOP and report to orchestrator.

8 LLM Truths that most affect builder:
- **LT-1 (Hallucination):** Builder may claim to have written a file without actually writing it. Mitigated by VERIFY field (grep, file existence check)
- **LT-3 (Reasoning degradation):** Tasks must be ≤1hr human-equivalent (EP-09). Complex tasks exceed Sonnet's reliable range
- **LT-8 (Approximate alignment):** Builder may drift from scope without hooks to enforce boundaries

#### Frontier Standard

Sonnet is the industry-standard tier for build/execution agents. ADK, Claude SDK, and CrewAI all recommend mid-tier models for execution tasks with clear ACs (not judgment-heavy work).

Cost analysis (from frontier research): Sonnet generation = ~$0.005/call for artifact production. At 3 iterations in a Generator/Critic loop: ~$0.015 for builder portion.

#### Gap

No significant EU gap. Sonnet is the correct model for execution with clear ACs. Opus would be wasteful; Haiku would degrade quality on file-writing tasks.

#### S × E × Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 7/10 | Sonnet handles well-defined tasks reliably. LT-3 risk mitigated by EP-09 decomposition |
| Efficiency | 9/10 | Best cost/quality ratio for execution. ~3-4x cheaper than Opus, ~2x more capable than Haiku for file writing |
| Scalability | 8/10 | N Sonnet builders in parallel = cost-efficient competing hypotheses pattern |

---

### 2.3 EA — Effective Action

#### Current State

For each task in SEQUENCE.md (in order):
1. Read input files declared in context package
2. Produce artifact (write/edit files)
3. Update frontmatter: `version`, `status: draft`, `last_updated: {today}`
4. Apply LTC brand identity to visual output (Midnight Green #004851, Gold #F2C75C, Inter font)
5. Self-verify against acceptance criteria from SEQUENCE.md
6. Report completion: `DONE: <path> | ACs: <pass>/<total> | Blockers: <list>`

If blocked on dependency: STOP and report — do not improvise.
If Build fails (tool error, repeated failures): STOP after 1 retry. Report to orchestrator.

#### Frontier Standard

ADK Generator pattern: agent produces output → writes to `output_key` → exits with structured completion signal.
Self-healing pattern (2026): agent catches exception → attempts fix → validates fix → escalates if fix fails. Recovery types: syntactic (regenerate), semantic (re-prompt), environmental (retry with backoff), unrecoverable (escalate).

#### Gap

**G-EA-1:** No auto-validation scripts. Builder must manually run `skill-validator.sh`, `template-check.sh`. Since PreToolUse hooks don't fire in sub-agents, these checks that would normally run on commit are BYPASSED.

**G-EA-2:** No auto-rollback on AC failure. Builder continues or stops, but partial work remains on disk. No checkpoint/restore mechanism.

**G-EA-3:** No self-healing. If builder encounters a tool error, it retries once then stops. No error classification (syntactic/semantic/environmental) to determine if retry is appropriate.

#### S × E × Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 6/10 | Self-verification against ACs is good. But: no auto-validation scripts, no rollback, no error classification |
| Efficiency | 7/10 | Sequential task execution minimizes token waste. But: manual validation adds human overhead |
| Scalability | 8/10 | Competing hypotheses pattern (N parallel builders) is proven for design-heavy workstreams |

#### UBS / UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-EA-1 | No auto-validation scripts (hooks don't fire) | Technical |
| UBS | UBS-EA-2 | No auto-rollback on failure | Technical |
| UBS | UBS-EA-3 | No error classification for intelligent retry | Technical |
| UBS | UBS-EA-4 | 1-retry limit may be too aggressive (environmental errors deserve more) | Temporal |
| UDS | UDS-EA-1 | Self-verification against ACs before reporting done | Technical |
| UDS | UDS-EA-2 | Completion report format is standardized (DONE: path | ACs) | Technical |
| UDS | UDS-EA-3 | "STOP and report" on dependency blocks prevents improvisation | Human |

---

### 2.4 EO — Effective Output

#### Current State

Builder produces two outputs:
1. **Artifacts:** Files at paths declared in SEQUENCE.md (with versioning frontmatter)
2. **Completion report:** `DONE: <path> | ACs: <pass>/<total> | Blockers: <none or list>`

Consumed by: ltc-reviewer (validation) and orchestrator (status tracking).

#### Frontier Standard

ADK: typed `output_key` with JSON schema. Each agent's output is schema-validated before handoff.
Structured metadata: execution time, token cost, tool calls count, files created/modified list.

#### Gap

**G-EO-1:** Completion report is text-only. No structured metadata (cost, duration, files modified). Orchestrator can't programmatically track per-dispatch efficiency.

**G-EO-2:** No handoff.json. Builder doesn't declare assumptions or uncertainty. Reviewer receives artifacts but doesn't know WHY builder made specific choices.

#### Proposed Output Contract

```yaml
output_contract:
  completion_report:
    format: "DONE: <path> | ACs: <pass>/<total> | Blockers: <list>"
    required: true
  artifacts:
    format: "Files at paths from SEQUENCE.md"
    required_frontmatter: [version, status, last_updated]
    brand_compliance: required_if_visual
  handoff:  # NEW — proposed
    assumptions: ["assumption 1", "assumption 2"]
    uncertain_fields: [{field: "name", reason: "why uncertain"}]
    confidence_score: 0.0-1.0
  metadata:  # NEW — proposed
    tokens_used: integer
    files_created: [paths]
    files_modified: [paths]
    duration_ms: integer
```

#### S × E × Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 6/10 | Completion report is standardized. But: no assumptions manifest = reviewer validates blindly |
| Efficiency | 5/10 | Text-only report requires manual parsing. No cost tracking |
| Scalability | 7/10 | Same format for single and parallel builders. But: N builders' text reports are hard to compare programmatically |

---

### 2.5 EP — Effective Principles

#### Current State

| Principle | Application to Builder |
|-----------|----------------------|
| EP-10 (Define Done) | Self-verify against ACs before reporting. "DONE" means all ACs pass, not "I finished writing" |
| EP-05 (Gates Before Guides) | Builder follows routing boundaries deterministically: never write DSBV files to 2-LEARN/, never write project artifacts to _genesis/ |
| EP-14 (Script-First Delegation) | Deterministic checks (skill-validator.sh, template-check.sh) should be run as scripts, not left to agent judgment. **Currently violated: builder must remember to run these manually since hooks don't fire** |
| EP-13 (Orchestrator Authority) | Leaf node. NEVER call Agent(). If research needed, STOP and report |
| EP-01 (Brake Before Gas) | If blocked on dependency, STOP — don't improvise. Report to orchestrator |

Additional constraints from agent file:
- Sustainability > Efficiency > Scalability in all prioritization
- Do NOT propose changes to 7-CS framework or 8 LLM Truths
- Do NOT create files outside scope defined in SEQUENCE.md
- Maximum context: load only current task's input files + SEQUENCE.md

#### Gap

**G-EP-1:** EP-14 (Script-First) is violated in practice because hooks don't fire. The principle says "delegate deterministic checks to shell scripts" but the scripts (skill-validator.sh, naming-lint.sh, validate-blueprint.py) are triggered by hooks that don't cascade to sub-agents.

**Fix:** Builder's EOP should explicitly include running validation scripts as a step (not relying on hooks).

#### S × E × Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 7/10 | Routing boundaries prevent cross-workstream writes. EP-13 prevents nesting. But: EP-14 violated |
| Efficiency | 8/10 | Principles are minimal (5 core EPs). No redundant constraints |
| Scalability | 8/10 | Same principles apply to single or parallel builders |

---

### 2.6 EOE — Effective Operating Environment

> **CRITICAL SECTION.** The builder is the MOST AFFECTED agent by sub-agent hook degradation
> because it is the ONLY agent that writes files. Every safety check designed to protect file
> writes is BYPASSED when the builder runs as a sub-agent.

#### Layer 1 — Platform Runtime

```
Platform:         Claude Code CLI (sub-agent process)
OS:               macOS (Darwin 25.3.0)
Shell:            zsh
Model:            Sonnet (claude-sonnet-4-6)
Context window:   200K tokens
Token budget:     Controlled by context package Budget field
Session type:     Sub-agent (spawned via Agent() from main session)
Persistence:      NONE — no memory between dispatches
```

Builder runs as a Claude Code sub-agent process. No awareness of prior dispatches, no session history, no conversation memory. Every dispatch starts from zero context (EP-07: Amnesia-First Design). The ONLY information builder has is what the orchestrator provides in the 5-field context package.

#### Layer 2 — Permission Model (settings.json)

```
Status: ✅ ENFORCED at platform level (deny/allow rules apply to sub-agents)
```

Active deny rules that protect builder:
- `Read(.env*)` — builder cannot read secrets
- `Bash(rm -rf *)` — builder cannot delete recursively
- `Bash(sudo *)` — builder cannot escalate privileges
- `Bash(npm publish)` — builder cannot publish packages
- `Bash(git push --force *)` — builder cannot force push

Active allow rules that enable builder:
- `Bash(git add *)`, `Bash(git commit *)` — builder can stage and commit
- `Bash(git status)`, `Bash(git diff *)`, `Bash(git log *)` — builder can inspect git state
- `Bash(./scripts/dsbv-gate.sh)` — builder can run DSBV gate check (but won't auto-run)

**Assessment:** Permission layer provides hard safety floor. Builder cannot perform destructive operations regardless of prompt content. This is the strongest protection that survives into sub-agents.

#### Layer 3 — Hooks (THE CRITICAL GAP)

```
Status: ❌ PreToolUse/PostToolUse hooks DO NOT FIRE for sub-agents
         (LP-7, Anthropic GitHub #40580)
```

**Every hook that protects file writes is LOST when builder runs as a sub-agent:**

| Hook | Event | What It Does | Status in Sub-Agent | Impact |
|------|-------|-------------|---------------------|--------|
| `naming-lint.sh` | PreToolUse(Write) | Validates filename against UNG naming rules | ❌ LOST | Builder can create files with invalid names |
| `inject-frontmatter.sh` | PostToolUse(Write\|Edit) | Auto-injects work_stream, sub_system, stage, type from file path | ❌ LOST | Builder must manually add all frontmatter fields |
| `dsbv-skill-guard.sh` | PreToolUse(Write\|Edit) | Checks DSBV Design phase prerequisite (no Build without DESIGN.md) | ❌ LOST | Builder could write to a workstream without DESIGN.md |
| `dsbv-gate.sh --pretool` | PreToolUse(Write\|Edit) | Checks ALPEI chain-of-custody (workstream N-1 must have validated artifact) | ❌ LOST | Builder could build in workstream N without upstream approval |
| `state-saver.sh` | PostToolUse(Write\|Edit) | Saves session state after file changes | ❌ LOST | No state preservation during build |
| `ripple-check.sh` | PostToolUse(Write\|Edit) | Checks backlink impact of file changes | ❌ LOST | Builder unaware of downstream link breakage |
| `skill-validator.sh` | PreToolUse(git commit) | Validates skill quality on commit | ❌ LOST | Skill files not validated before commit |
| `validate-blueprint.py` | PreToolUse(git commit) | Validates filesystem routing | ❌ LOST | Files may land in wrong directory mode |
| `status-guard.sh` | PreToolUse(git commit) | Blocks agent self-approve (status: validated) | ❌ LOST | Builder could set status: validated |
| `registry-sync-check.sh` | PreToolUse(git commit) | Checks version-registry sync | ❌ LOST | Version registry may fall out of sync |
| `changelog check` | PreToolUse(git commit) | Warns if CHANGELOG.md not updated | ❌ LOST | Changelog not updated with build changes |
| `strategic-compact.sh` | PreToolUse(global) | Checks context saturation | ❌ LOST | Builder unaware of context pressure |
| `link-validator.sh` | PreToolUse(git commit) | Checks for broken wikilinks in staged files | ❌ LOST | Builder can commit files with dead wikilinks |
| `naming-lint.sh` (PostToolUse) | PostToolUse(Write) | Lints frontmatter casing after file creation | ❌ LOST | Frontmatter values may use wrong casing (e.g. `status: Draft` instead of `status: draft`) |

**One hook DOES fire:**
| Hook | Event | Status | Impact |
|------|-------|--------|--------|
| `verify-deliverables.sh` | SubagentStop | ✅ FIRES | Validates builder output on completion |

**Total: 14 hooks LOST, 1 hook RETAINED.**

**This is the highest-risk design issue in the entire agent system.** The builder — the only agent that writes files — operates with 93% fewer guardrails than the main session for file operations (14/15 hooks non-functional). The single retained hook (SubagentStop) is a post-hoc check, not prevention.

**Mitigation strategy (EP-14: Script-First + EP-05: Gates Before Guides):**

Since hooks can't fire, builder's EOP must include EXPLICIT script-running steps:

```
Builder EOP Step 4a (NEW): After producing artifact, run:
  - ./scripts/skill-validator.sh <skill-dir>   (if skill file)
  - ./scripts/template-check.sh --quiet         (structural check)
  - python3 ./scripts/validate-blueprint.py     (routing check)

Builder EOP Step 4b (NEW): Before commit, verify:
  - status is NOT "validated" (self-approve guard)
  - version-registry row updated
  - CHANGELOG.md entry added
```

This converts hook-based enforcement (broken in sub-agents) to EOP-based enforcement (advisory but in the agent's procedure).

#### Layer 4 — Context Management

```
Context window:    200K tokens (Sonnet)
Auto-recall:       ❌ NOT available (UserPromptSubmit hook doesn't fire for sub-agents)
Memory vault:      ❌ NOT accessible (sub-agents have no memory file access)
QMD:               ❌ NOT available (not in builder tool list)
Context source:    ONLY the 5-field context package from orchestrator
Compaction:        ❌ No PreCompact hook fires — builder has no context management
```

Builder operates in a context island. Its entire world is the context package. If the orchestrator omits a critical file or constraint, builder has no way to discover it — no QMD, no memory, no auto-recall.

**Implication:** Context package quality is the single most important determinant of builder success. EP-04 (Load What You Need) applied to builder means: the orchestrator must provide EXACTLY the right files, not too many (LT-2: lossy compression), not too few (blind spots).

#### Layer 5 — Agent Coordination

```
Role:              Leaf node (cannot dispatch agents)
Scope:             Execute SEQUENCE.md tasks — nothing more
Isolation:         Can run in main repo or git worktree
Concurrent access: N parallel builders must target NON-OVERLAPPING files
EP-13:             "NEVER call the Agent() tool" — hard constraint in agent file
```

When N builders run in competing hypotheses pattern, each must produce a COMPLETE draft independently. No coordination between parallel builders — they don't see each other's work. Orchestrator synthesizes after all complete.

**Critical coordination rule:** Parallel builders MUST target different output paths. If two builders write the same file, the last writer wins silently — no conflict detection (unlike git).

#### Layer 6 — Rules

```
Agent file:        ✅ .claude/agents/ltc-builder.md loaded as identity
.claude/rules/:    ❓ UNCLEAR — sub-agent may or may not load always-on rules
CLAUDE.md:         ❓ UNCLEAR — may be partially loaded via system prompt
```

The builder's agent file declares scope boundaries, tool guides, and constraints. These are advisory (probabilistic ~90% compliance) — the agent reads them but can drift under context pressure (LT-8).

**Key risk:** If .claude/rules/ files are NOT loaded for sub-agents, the builder has no awareness of:
- Versioning rules (version bumping, status vocabulary)
- Naming rules (UNG format)
- Git conventions (commit format, scope list)
- Filesystem routing (4-mode routing)

These rules exist in the agent file's "Scope Boundary" section in summary form, but the full specs are in rules/ files that may not load.

#### Layer 7 — MCP Servers

```
Status: ❌ NONE available
```

Builder has no MCP server access:
- No Exa (cannot research)
- No QMD (cannot search project knowledge)
- No Notion/ClickUp (cannot update WMS)
- No Playwright (cannot test in browser)

This is correct by design — builder should execute, not research. If research is needed, builder STOPs and reports to orchestrator, who dispatches ltc-explorer.

#### Layer 8 — Filesystem and Git

```
File access:       ✅ FULL read/write via Read, Edit, Write, Bash
Git access:        ✅ Can stage, commit (via Bash within allow list)
Worktree:          Can operate in isolated git worktree (if dispatched with isolation: "worktree")
ALPEI structure:   Accessible — can read/write to 1-ALIGN through 5-IMPROVE
_genesis/:         Accessible but should NOT write here (routing boundary)
PKB dirs:          Accessible but should NOT write here (routing boundary)
```

Builder has the most powerful filesystem access of any agent. Combined with the hook gap (Layer 3), this creates the highest-risk attack surface in the system.

#### EOE Summary: Main Session vs Builder Sub-Agent

| EOE Component | Main Session | Builder Sub-Agent | Risk |
|---------------|-------------|-------------------|------|
| Permissions | ✅ 12 deny, 8 allow | ✅ Same | LOW |
| Hooks (file writes) | ✅ 14 hooks fire | ❌ 0 of 14 fire | **CRITICAL** |
| Hooks (completion) | N/A | ✅ SubagentStop fires | MEDIUM |
| Context management | ✅ Auto-recall + memory + compaction | ❌ None | HIGH |
| Rules | ✅ 14 always-on rules | ❓ Unknown | MEDIUM |
| MCP servers | ✅ All | ❌ None | LOW (by design) |
| Filesystem | ✅ Full + hooks | ✅ Full WITHOUT hooks | **CRITICAL** |

**Overall EOE Risk: HIGH** — Builder has full write power with minimal guardrails.

#### S × E × Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 3/10 | **Critically low.** 14 of 15 hooks don't fire. File writes unguarded. No naming validation, no frontmatter injection, no DSBV prerequisite check, no chain-of-custody enforcement, no wikilink validation, no frontmatter casing lint. Only SubagentStop provides post-hoc validation |
| Efficiency | 6/10 | Permission layer is zero-overhead (platform-enforced). But: manual validation steps (proposed in mitigation) add overhead |
| Scalability | 5/10 | Same degraded EOE applies to all N parallel builders. No per-builder guardrail customization possible |

#### UBS / UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-EOE-1 | **14 hooks don't fire for file writes** — highest-risk gap in entire system | Technical |
| UBS | UBS-EOE-2 | Rules loading unclear — builder may not see versioning, naming, routing rules | Technical |
| UBS | UBS-EOE-3 | No context management — builder can't recover from context pressure | Technical |
| UBS | UBS-EOE-4 | No MCP — builder is blind to project knowledge beyond context package | Technical |
| UDS | UDS-EOE-1 | Permission system enforced at platform level — destructive operations blocked | Technical |
| UDS | UDS-EOE-2 | SubagentStop hook validates output on completion | Technical |
| UDS | UDS-EOE-3 | Context island forces explicit context packaging (EP-07) | Technical |

---

### 2.7 EOT — Effective Operating Tools

#### Current State

```
tools: Read, Edit, Write, Bash, Grep
```

5 tools. Minimal but powerful. The builder has the most dangerous tool combination:

| Tool | Capability | Risk | Guard |
|------|-----------|------|-------|
| Read | Load files by path | LOW — read-only | None needed |
| Edit | Modify existing files (string replacement) | MEDIUM — can corrupt files | No naming-lint hook |
| Write | Create new files (full overwrite) | HIGH — can overwrite files | No naming-lint, no inject-frontmatter |
| Bash | Run any shell command within permissions | HIGH — most flexible/dangerous | Permission deny list (settings.json) |
| Grep | Search file contents by pattern | LOW — read-only | None needed |

#### Gap

**G-EOT-1:** No Glob tool. Builder can't discover files by pattern. Must know exact paths from context package. If context package has a typo in a path, builder has no way to find the correct file.

**G-EOT-2:** No MCP tools. Builder can't search project knowledge (QMD), external sources (Exa), or update WMS (Notion/ClickUp). This is by design — builder should build, not research — but it means the orchestrator must provide COMPLETE context.

#### Proposed Addition

Consider adding **Glob** to builder's tool list:
- **Pro:** Builder can discover files by pattern (e.g., find all SKILL.md files), verify file existence before referencing, discover project structure
- **Con:** Slightly increases scope (builder becomes more autonomous). Risk of searching instead of building.
- **Recommendation:** Add Glob. The benefit (file discovery for verification) outweighs the scope risk. The builder still can't write to unexpected locations — routing boundaries are enforced by rules/hooks.

#### S × E × Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 7/10 | Minimal tool set limits blast radius. Permission deny blocks destructive ops. But: Write/Edit without hooks = unguarded |
| Efficiency | 7/10 | 5 tools cover all build needs. No bloat (8-tool max per ADK best practice) |
| Scalability | 8/10 | Same tool set for all builder dispatches. No per-task tool variation needed |

---

### 2.8 EOP — Effective Operating Procedure

#### Current State

Builder follows this procedure (from agent file):

```
For each task in SEQUENCE.md (in order):
  1. Read input files from context package
  2. Produce artifact (Write/Edit)
  3. Update frontmatter (version, status: draft, last_updated: today)
  4. Self-verify against acceptance criteria
  5. [if skill file] Run skill-validator.sh
  6. Report: DONE: <path> | ACs: <pass>/<total> | Blockers: <list>

If blocked on dependency → STOP and report
If build fails after 1 retry → STOP and report
```

Multi-agent variant (competing hypotheses):
1. N builders each produce a COMPLETE draft
2. Each builder self-verifies independently
3. Opus (main session or planner) synthesizes best elements per criterion
4. User reviews synthesis

#### Frontier Standard

ADK Generator pattern: produce → validate → loop (with critic). Max iterations + exit condition.
Self-healing: classify error → appropriate recovery strategy.
Checkpoint/resume: save state at task boundaries.

#### Gap

**G-EOP-1 (HIGHEST LEVERAGE): No Generator/Critic loop.** Currently single-pass: build → validate → human decides. Should loop: build → validate → if FAIL: re-dispatch builder with FAIL items as EI → validate again → repeat until all PASS or max_iterations reached.

Implementation details (from frontier research):
- `max_iterations: 3` (proven optimal: 6% quality improvement vs 5 iterations, 40% cost savings)
- Exit condition: `all_ACs_pass AND no_structural_violations`
- Feedback format: structured JSON, not prose (prevents ambiguity)
- Cost per cycle: Sonnet build (~$0.005) + Opus validate (~$0.015) = ~$0.02/iteration, ~$0.06/cycle at 3 iterations
- **Critical guardrail:** Without max_iterations, a loop can run forever. Real incident: $12K API bill over a weekend from missing exit condition.

**G-EOP-2: No explicit validation scripts in EOP.** Since hooks don't fire, builder should include script execution as procedure steps (not relying on hooks):

```
Proposed EOP Step 4a (after producing artifact):
  IF artifact is in .claude/skills/:
    Run: ./scripts/skill-validator.sh <skill-dir>
  IF artifact is in [1-5]-*/ workstream dirs:
    Run: python3 ./scripts/validate-blueprint.py <file>
  ALWAYS:
    Verify: status is NOT "validated"
    Verify: version frontmatter present and valid
```

**G-EOP-3: No error classification.** Builder retries once then stops. Should classify:
- **Syntactic error** (tool call fails): retry with corrected syntax (up to 2 retries)
- **Semantic error** (output doesn't meet ACs): re-read input, try different approach (1 retry)
- **Environmental error** (file system issue, permission denied): escalate immediately
- **Scope error** (task exceeds builder's capabilities): escalate immediately

**G-EOP-4: No checkpoint at task boundaries.** If builder completes task 3 of 5 then fails on task 4, the orchestrator doesn't know which tasks completed. Should produce incremental completion reports.

#### S × E × Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 5/10 | Self-verification is good. But: no Generator/Critic loop, no error classification, no explicit validation scripts |
| Efficiency | 6/10 | Sequential task execution is efficient. But: human intervention required for every FAIL (no auto-retry loop) |
| Scalability | 7/10 | Competing hypotheses scales horizontally. But: no incremental progress tracking for long sequences |

---

## 3. Handoff Contracts

### 3.1 Upstream: Planner → Builder (via Orchestrator)

```
PLANNER EO → BUILDER EI
═══════════════════════════════════════════════════════════════════
PLANNER MUST PROVIDE:              BUILDER EXPECTS:
─────────────────────              ────────────────
• DESIGN.md on disk                • DESIGN.md readable at path
  (artifact inventory + ACs)         (verified via Read before starting)
                                   
• SEQUENCE.md on disk              • Task ID, ordering, dependencies
  (task ordering + sizing)           Binary ACs per task
  (file paths with Read/Write)       File paths with Read/Write labels
  (≤1hr human-equiv per task)        Budget (token/scope boundary)
                                   
• Context package (5 fields)       • EO, INPUT, EP, OUTPUT, VERIFY
                                     populated and specific

PROPOSED ADDITION (handoff.json):
• assumptions[]                    • Builder validates assumptions
• uncertain_fields[]                 before building on them
• confidence_score                 • If confidence < 0.80 → escalate
═══════════════════════════════════════════════════════════════════
EP-12 CHECK: Builder MUST verify DESIGN.md and SEQUENCE.md exist on
disk (Read) before starting any task. If missing → STOP, report
"prerequisite missing" to orchestrator. Do NOT proceed without the
contract.
```

### 3.2 Downstream: Builder → Reviewer

```
BUILDER EO → REVIEWER EI
═══════════════════════════════════════════════════════════════════
BUILDER MUST PROVIDE:              REVIEWER EXPECTS:
─────────────────────              ────────────────
• All artifacts at declared        • Every file in DESIGN.md exists
  file paths                        on disk (verified via Glob)
                                   
• Completion report:               • Structured report parseable
  DONE: <path>                       by orchestrator
  ACs: <pass>/<total>              
  Blockers: <none or list>         • DESIGN.md (the contract)
                                     to validate against
• Version frontmatter on           
  every artifact                   • Frontmatter present and valid
                                   
PROPOSED ADDITION:                 
• handoff.json with:               • Reviewer checks assumptions
  - assumptions[]                    before validating
  - uncertain_fields[]             • Uncertain fields get extra
  - confidence_score                 scrutiny
  - files_created[]               
  - files_modified[]              
═══════════════════════════════════════════════════════════════════
EP-12 CHECK: Reviewer independently verifies EVERY artifact exists
on disk (Glob). Does NOT trust builder's completion report.
LT-1 risk: builder may claim "DONE: path" without writing the file.

GENERATOR/CRITIC LOOP (proposed):
  IF reviewer PASS all → G4 (human approval)
  IF reviewer FAIL any + iterations < 3 →
    Reviewer formats FAIL items as builder EI:
    {task_id, file_path, expected, actual, fix_instruction}
    → re-dispatch builder → reviewer validates again
  IF reviewer FAIL any + iterations = 3 →
    Escalate to human with full context
```

---

## 4. Improvement Proposals

### Proposal 1: Generator/Critic Loop (P0 — HIGHEST LEVERAGE)

**What:** Formalize Builder↔Reviewer as a loop with `max_iterations=3` and `exit_condition: all_ACs_pass`.

**Why (S×E×Sc):**
- **S:** max_iterations cap prevents infinite loops (top 3 production failure)
- **E:** Auto-retry for fixable issues saves human intervention time
- **Sc:** Same pattern works for any workstream

**Cost:** ~$0.06/cycle (3 iterations × Sonnet build + Opus validate). vs current: ~$0.02/cycle (1 iteration) + human time for manual re-dispatch.

**EP grounding:** EP-01 (cap iterations), EP-10 (binary exit condition), EP-09 (FAIL items become individual retry tasks).

**Frontier evidence:** 68% of production systems use Generator/Critic. ADK LoopAgent. Proven at scale.

---

### Proposal 2: Explicit Validation Scripts in EOP (P0)

**What:** Since hooks don't fire, add explicit script execution steps to builder's procedure.

**Why:** EP-14 (Script-First Delegation) is violated without this. Builder writes files without naming validation, frontmatter injection, routing checks.

**Implementation:** Add steps 4a/4b to builder EOP (as documented in EOE Layer 3 mitigation).

---

### Proposal 3: Handoff.json at Builder→Reviewer Boundary (P1)

**What:** Builder produces `handoff.json` alongside artifacts, declaring assumptions, uncertainty, and confidence.

**Why:** Prevents 17x error amplification. Reviewer can validate assumptions before checking artifacts.

**Frontier evidence:** arXiv 2026 — all 6 tested frameworks propagated false premises through entire chain. Handoff.json is the proven prevention.

---

### Proposal 4: Add Glob to Builder Tool List (P2)

**What:** Add Glob to builder's tools (Read, Edit, Write, Bash, Grep, **Glob**).

**Why:** Builder can verify file existence, discover project structure, find files when context package has path errors.

**Risk:** Minimal — Glob is read-only.

---

### Proposal 5: Error Classification in EOP (P2)

**What:** Builder classifies errors before deciding retry strategy.

**Why:** Not all errors deserve retry. Syntactic → retry. Semantic → different approach. Environmental → escalate. Scope → escalate.

**Implementation:** Decision tree in builder agent file's EOP section.

---

## 5. S × E × Sc Summary

| Component | S | E | Sc | Priority Issue |
|-----------|---|---|-----|---------------|
| EI | 6 | 7 | 7 | No assumption validation |
| EU | 7 | 9 | 8 | (No gap — Sonnet is correct) |
| EA | 6 | 7 | 8 | No auto-validation, no rollback |
| EO | 6 | 5 | 7 | No structured metadata, no handoff.json |
| EP | 7 | 8 | 8 | EP-14 violated (hooks don't fire) |
| **EOE** | **3** | **6** | **5** | **14 hooks lost — CRITICAL** |
| EOT | 7 | 7 | 8 | Missing Glob (minor) |
| EOP | 5 | 6 | 7 | No Generator/Critic loop, no error classification |
| **Overall** | **5.9** | **6.9** | **7.3** | **EOE is the bottleneck** |

**Diagnosis:** Builder's EOE (Sustainability: 3/10) drags down the entire system. The S > E > Sc priority order (DT#1) means this MUST be addressed first. Proposals 1 and 2 (Generator/Critic loop + explicit validation scripts) together raise EOE sustainability from 3/10 to ~6/10 by compensating for hook loss.

---

---

## Review Status (2026-04-08)

**Verdict:** G1 APPROVED with P0 fixes.
**Aggregate:** S=5.9, E=6.9, Sc=7.3 — EOE (3/6/5) is the system bottleneck.
**P0 fixes required before BUILD:**
1. Generator/Critic loop in `/dsbv` skill (Proposal 1 — highest leverage, ~1-2 hrs)
2. Explicit validation scripts in builder EOP (Proposal 2 — compensates for 14 lost hooks, ~15 min)
3. Hook constraint mirroring in `ltc-builder.md` (from Orchestrator P0-3, ~15 min)

**Cross-agent dependency:** Builder→Reviewer handoff.json (Proposal 3) must be reflected in Reviewer EI. Build together.

---

## Links

- [[2026-04-08_agent-system-8component-design]]
- [[AGENTS]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-01]]
- [[EP-04]]
- [[EP-05]]
- [[EP-07]]
- [[EP-09]]
- [[EP-10]]
- [[EP-12]]
- [[EP-13]]
- [[EP-14]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[context-packaging]]
- [[deliverable]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-reviewer]]
- [[project]]
- [[schema]]
- [[standard]]
- [[task]]
- [[version-registry]]
- [[versioning]]
- [[workstream]]
