---
version: "2.2"
status: draft
last_updated: 2026-04-13
type: template
iteration: 2
---

# Skills Directory

> "If the agent doesn't know a skill exists, it can't use it. If you don't know when to use it, it won't help."

All slash commands live here. Type `/` in Claude Code to see the full list. Each skill is a folder with a `SKILL.md` that tells the agent what to do.

## How to Use

Type the skill name after `/` in any Claude Code session:

```
/dsbv design align        ← run DSBV Design stage for ALIGN workstream
/git-save                 ← classify and commit your changes
/learn                    ← start or continue a learning pipeline
/deep-research:mid        ← run mid-depth research (~200K tokens)
```

Skills auto-load when invoked — you don't need to read or reference them manually.

## Skill Catalog

### Session Management

| Skill | Command | When to Use |
|-------|---------|-------------|
| **resume** | `/resume` | Start of session — load context from previous sessions |
| **compress** | `/compress` | End of session — save context to Memory Vault |
| **setup** | `/setup` | First time on a new machine or fresh clone |

### Core Workflow

| Skill | Command | When to Use |
|-------|---------|-------------|
| **dsbv** | `/dsbv [stage] [workstream]` | Produce workstream artifacts via Design → Sequence → Build → Validate |
| **git-save** | `/git-save` | Classify, stage, and commit changes with LTC conventions |
| **ltc-feedback** | `/ltc-feedback` | Report a frustration or improvement as a GitHub Issue |
| **ltc-brainstorming** | `/ltc-brainstorming` | Explore an idea or approach a non-trivial decision |

### Learning Pipeline

| Skill | Command | When to Use |
|-------|---------|-------------|
| **learn** | `/learn [slug]` | Start or continue a learning pipeline (auto-routes to correct sub-step) |
| **learn-input** | `/learn:input` | Step 1 — scope a new learning subject (9-question interview) |
| **learn-research** | `/learn:research` | Step 2 — parallel research across all topics |
| **learn-structure** | `/learn:structure` | Step 3 — generate structured P0-P5 pages from research |
| **learn-review** | `/learn:review` | Step 4 — review one topic with comprehension questions |
| **learn-spec** | `/learn:spec` | Step 5 — produce VANA-SPEC + readiness package for downstream |
| **learn-visualize** | `/learn:visualize` | Generate interactive HTML map from validated P-pages |

### Research and Analysis

| Skill | Command | When to Use |
|-------|---------|-------------|
| **deep-research** | `/deep-research:[lite\|mid\|deep\|full]` | Multi-source research with Blue-Red falsification (4 depth modes) |
| **root-cause-tracing** | `/root-cause-tracing` | Trace a problem to ultimate causes using UBS/UDS dot-notation |

### Knowledge Management

| Skill | Command | When to Use |
|-------|---------|-------------|
| **organise** | `/organise` | Organise raw files from `1-captured/` into structured PKB pages in `2-organised/` |
| **capture** | `/capture` | Quick-save text to `PERSONAL-KNOWLEDGE-BASE/1-captured/` staging area |
| **obsidian** | `/obsidian` | Graph traversal — backlinks, outgoing links, orphans |
| **recall-tune** | `/recall-tune` | Tune QMD auto-injection for better memory precision |

### Template and Compliance

| Skill | Command | When to Use |
|-------|---------|-------------|
| **template-check** | `/template-check` | Dry-run: what's new or changed in the project template |
| **template-sync** | `/template-sync` | Pull new files from the upstream project template |
| **ltc-rules-compliance** | `/ltc-rules-compliance` | Audit work against LTC rules (brand, naming, security, DSBV) |
| **ltc-naming-rules** | `/ltc-naming-rules` | Look up or validate UNG naming for repos, folders, assets |
| **ltc-brand-identity** | `/ltc-brand-identity` | Apply LTC brand to any visual artifact (HTML, CSS, slides) |
| **ltc-skill-creator** | `/ltc-skill-creator` | Create a new skill following EOP governance standards |

### Work Management

| Skill | Command | When to Use |
|-------|---------|-------------|
| **ltc-notion-planner** | `/ltc-notion-planner` | Plan and log work to the Notion Task Board (primary WMS) |
| **ltc-clickup-planner** | `/ltc-clickup-planner` | Plan and log work to ClickUp (secondary WMS) |
| **ltc-wms-adapters** | *(library — not invoked directly)* | Shared field maps and templates used by both WMS planners |

## Structure

Each skill follows this layout:

```
.claude/skills/{skill-name}/
  SKILL.md           ← Main definition (required)
  gotchas.md         ← Known pitfalls (recommended)
  references/        ← Supporting docs loaded on demand
  templates/         ← Output templates
  scripts/           ← Helper scripts (rare)
```

## Naming Prefixes

| Prefix | Domain |
|--------|--------|
| `ltc-` | Governance and cross-cutting |
| `learn-` | Learning pipeline sub-steps |
| `template-` | Template sync operations |
| `vault-` | Obsidian vault operations |
| *(none)* | General-purpose utilities |

## Quick Reference

**Most common commands:**
- `/resume` → start of day
- `/dsbv` → produce work
- `/git-save` → save work
- `/compress` → end of day

**When stuck:** `/ltc-brainstorming` to think through it, or `/deep-research:lite` to research it.

**When frustrated:** `/ltc-feedback` captures the issue as a structured GitHub Issue.

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[gotchas]]
- [[idea]]
- [[iteration]]
- [[project]]
- [[security]]
- [[task]]
- [[workstream]]
