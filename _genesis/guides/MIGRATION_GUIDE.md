---
version: "1.1"
status: Draft
last_updated: 2026-04-03
---

# Migration Guide — Upgrading to ALPEI Template I1

> For LTC members whose projects were cloned from the **I0 scaffold** (or earlier).
> Your AI agent can execute this guide. Paste these instructions or say:
> "Read `_genesis/guides/MIGRATION_GUIDE.md` and execute it for my project."

## Before You Start

**What this does:** Brings your existing project structure in line with the I1 template — new workstreams, updated rules, agent system, DSBV workflow. Your project content is preserved.

**What this does NOT do:** Delete your work, change your code, or modify your business logic.

**Time:** ~15 minutes with AI agent assistance.

---

## Path A — New Project (Clone Fresh)

If you haven't started real work yet:

```bash
# 1. Create from template
gh repo create Long-Term-Capital-Partners/{YOUR_PROJECT} \
  --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE

# 2. Clone and verify
git clone https://github.com/Long-Term-Capital-Partners/{YOUR_PROJECT}.git
cd {YOUR_PROJECT}
./scripts/template-check.sh --quiet

# 3. Open Claude Code and start
claude
# Then: /dsbv design align
```

Done. Skip the rest of this guide.

---

## Path B — Existing Project (Migrate In-Place)

### Step 1: Back up your branch

```bash
git checkout -b backup/pre-migration
git push origin backup/pre-migration
git checkout main   # or your working branch
```

### Step 2: Add template as remote and fetch

```bash
git remote add template https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git
git fetch template main
```

### Step 3: Create migration branch

```bash
git checkout -b feat/alpei-migration
```

### Step 4: Copy template infrastructure (agent reads and executes)

Tell your AI agent:

> "Read the template's infrastructure files and apply them to this project.
> Keep all my existing project content. Only add/update infrastructure."

The agent should copy these from the template:

| Source (template) | Destination (your project) | Action |
|---|---|---|
| `CLAUDE.md` | `CLAUDE.md` | **Merge** — keep your project-specific sections, add missing rules |
| `.claude/agents/` | `.claude/agents/` | **Copy** — 4 agent files (planner, builder, reviewer, explorer) |
| `.claude/rules/` | `.claude/rules/` | **Copy** — 8 rule files (versioning, DSBV, pre-flight, etc.) |
| `.claude/skills/` | `.claude/skills/` | **Copy** — 26 skills across 9 categories |
| `.claude/hooks/` | `.claude/hooks/` | **Copy** — 3 enforcement hooks |
| `.claude/settings.json` | `.claude/settings.json` | **Merge** — keep your permissions, add hook registrations |
| `_genesis/` | `_genesis/` | **Copy** — frameworks, templates, brand, training |
| `scripts/` | `scripts/` | **Copy** — template-check.sh, skill-validator.sh |
| `tests/brand-identity/` | `tests/brand-identity/` | **Copy** — brand validation suite |

### Step 5: Create missing workstream folders

If your project uses the old structure (`docs/`, `_shared/`, numbered differently), the agent should:

```
Ensure these folders exist with a README.md in each:

1-ALIGN/
  charter/
  decisions/
  okrs/
2-LEARN/
  input/
  research/
  specs/
  output/
  archive/
3-PLAN/
  architecture/
  risks/
  drivers/
  roadmap/
4-EXECUTE/
  src/       (or your existing code directory)
  tests/
  config/
  docs/
5-IMPROVE/
  changelog/
  metrics/
  retrospectives/
  reviews/
```

### Step 6: Move existing content to correct workstreams

Tell your agent:

> "Look at my existing project files. Move each file to the correct ALPEI workstream
> based on its purpose. If unsure, ask me."

Common mappings:

| Old location | New location | Why |
|---|---|---|
| `docs/design/` | `1-ALIGN/charter/` or `3-PLAN/architecture/` | Design docs are either alignment (charter) or planning (architecture) |
| `docs/adr/` | `1-ALIGN/decisions/` | ADRs live in ALIGN |
| `research/` | `2-LEARN/research/` | Research is LEARN workstream |
| `_shared/` | `_genesis/` | Shared resources renamed |
| `src/`, `lib/` | `4-EXECUTE/src/` | Code stays in EXECUTE |
| `tests/` | `4-EXECUTE/tests/` | Tests stay in EXECUTE |
| `CHANGELOG.md` | `5-IMPROVE/changelog/CHANGELOG.md` | Changelog is IMPROVE |

### Step 7: Verify

```bash
./scripts/template-check.sh --quiet
```

Fix any warnings. Then:

```bash
git add -A
git commit -m "feat(all): migrate to ALPEI I1 template structure"
git push origin feat/alpei-migration
```

Create a PR and review the changes before merging.

### Step 8: Start using DSBV

```bash
claude
# Check where you are:
/dsbv status
# Start your first DSBV cycle:
/dsbv design align
```

---

## v2.0 Changes (2026-04-03) — _genesis/ Cleanup + Blueprint Restructure

### Blueprint Relocated

`1-ALIGN/charter/BLUEPRINT.md` → `_genesis/BLUEPRINT.md`

Blueprint is bedrock philosophy (I0–I4), not iteration-scoped alignment. A redirect stub remains at the old location.

### Framework Files Renamed (ALL_CAPS → kebab-case)

| Old Name | New Name |
|----------|----------|
| `AGENT_SYSTEM.md` | `agent-system.md` |
| `AGENT_DIAGNOSTIC.md` | `agent-diagnostic.md` |
| `LEARNING_HIERARCHY.md` | `learning-hierarchy.md` |
| `HISTORY_VERSION_CONTROL.md` | `history-version-control.md` |
| `ALPEI_DSBV_PROCESS_MAP.md` | `alpei-dsbv-process-map.md` |
| `ALPEI_DSBV_PROCESS_MAP_P1.md` | `alpei-dsbv-process-map-p1.md` |
| `ALPEI_DSBV_PROCESS_MAP_P2.md` | `alpei-dsbv-process-map-p2.md` |
| `ALPEI_DSBV_PROCESS_MAP_P3.md` | `alpei-dsbv-process-map-p3.md` |
| `ALPEI_DSBV_PROCESS_MAP_P4.md` | `alpei-dsbv-process-map-p4.md` |

All references to old names have been updated across: `.claude/rules/`, `.claude/skills/`, `CLAUDE.md`, `3-PLAN/architecture/`, `_genesis/tools/`, `_genesis/templates/`, `_genesis/principles/`.

### Frameworks Archived

6 ALL_CAPS duplicates moved to `_genesis/frameworks/archive/` (git-recoverable):

| Archived File | Superseded By |
|--------------|---------------|
| `THREE_PILLARS.md` | `ltc-10-ultimate-truths.md` + BLUEPRINT Part 1 |
| `SIX_WORKSTREAMS.md` | `ltc-alpei-framework-overview.md` + CLAUDE.md Structure |
| `EFFECTIVE_SYSTEM.md` | `ltc-effective-system-design-blueprint.md` |
| `COGNITIVE_BIASES.md` | `ltc-effective-thinking.md` + `agent-system.md` §4 |
| `CRITICAL_THINKING.md` | `ltc-effective-thinking.md` |
| `UBS_UDS_GUIDE.md` | `ltc-ubs-uds-framework.md` |

`UES_VERSION_BEHAVIORS.md` deleted (exact duplicate of `ltc-ues-version-behaviors.md`).

### SOP Archived

`sops/ALPEI_OPERATING_PROCEDURE.md` → `sops/archive/ALPEI_OPERATING_PROCEDURE.md` (self-marked DEPRECATED)

---

## What Changed Between I0 and I1

| I0 (Scaffold) | I1 (Current) |
|---|---|
| 4 workstreams (0-3) + `_shared/` | 5 ALPEI workstreams (1-5) + `_genesis/` + `0-GOVERN` (builder only) |
| No LEARN workstream | LEARN is LEARN workstream — research pipeline with 6 skills |
| No agent system | 4 MECE agents with scope boundaries |
| No DSBV workflow | Design → Sequence → Build → Validate with human gates |
| No enforcement | 5 always-on rules + 3 hooks |
| Manual commits | /git-save with classification + version checks |
| No templates | 27 templates covering all workstream × phase intersections |
| No training | 47-slide interactive deck + Navigator HTML |

---

## Troubleshooting

**"template-check.sh says files are missing"**
→ Run Step 5 again. Create the missing folders with `.gitkeep` files.

**"My CLAUDE.md conflicts with the template"**
→ Your project CLAUDE.md wins. Only add the sections you're missing (Structure, DSBV Process, Agent System). Don't overwrite your project-specific rules.

**"I have files in locations the template doesn't expect"**
→ That's fine. The template defines the standard structure, not a requirement. Move files if it makes sense for your project, leave them if it doesn't. The workstreams are guidelines, not enforcement.

**"My agent doesn't know the DSBV commands"**
→ Verify `.claude/skills/dsbv/SKILL.md` exists. If not, re-copy from Step 4.
