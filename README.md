# LTC Project Template

Standard project scaffold for LT Capital Partners. A **thinking system** — not just file storage — that captures every decision, rejected path, and "why" explicitly in the structure.

Use this template to start any new project with LTC's 4-zone APEI framework, global rules, learning pipeline, and AI agent configuration pre-loaded.

## Quick Start

### 1. Create your project from this template

**On GitHub:** Click **"Use this template"** → name using UNG convention → Create.

**From CLI:**
```bash
gh repo create Long-Term-Capital-Partners/{YOUR_PROJECT_NAME} \
  --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
```

### 2. Configure (in this order)

| Step | File | What to do |
|------|------|------------|
| 1 | `CLAUDE.md` | Replace `{placeholders}` with project details |
| 2 | `1-ALIGN/charter/PROJECT_CHARTER.md` | Define purpose, scope, success criteria |
| 3 | `1-ALIGN/charter/STAKEHOLDERS.md` | Identify users, RACI, anti-personas |
| 4 | `1-ALIGN/charter/REQUIREMENTS.md` | VANA-decompose requirements with binary ACs |
| 5 | `.claude/settings.json` | Review deny/allow rules — your safety net |
| 6 | `.mcp.json` | Add MCP server connections if needed |

### 3. Start working

```bash
claude   # Opens Claude Code with CLAUDE.md auto-loaded
```

## Structure (5×4 Matrix)

This project follows the **LTC APEI Framework**: 5 workstream activities across 4 project-specific subsystems, organized in 4 zones.

```
Zone 0 — Agent Governance       → CLAUDE.md, AGENTS.md, .claude/, rules/
Zone 1 — ALIGN (Right Outcome)  → 1-ALIGN/  (charter, decisions, okrs, learning)
Zone 2 — PLAN (Minimize Risks)  → 2-PLAN/   (architecture, risks, drivers, roadmap)
Zone 3 — EXECUTE (Deliver)      → 3-EXECUTE/ (src, tests, config, docs)
Zone 4 — IMPROVE (Learn & Grow) → 4-IMPROVE/ (changelog, metrics, retros, reviews)
Shared  — Org Knowledge Base    → _shared/   (brand, frameworks, security, sops, templates)
```

**Core Equation:** Success = Efficient & Scalable Management of Failure Risks

**5 Activities (ALIGN → LEARN → PLAN → EXECUTE → IMPROVE):**
- LEARN lives inside Zone 1 (ALIGN) — it resolves unknowns that ALIGN identifies
- IMPROVE output loops back to ALIGN for next iteration

**Iteration Cycle:** Each iteration (I0 Scaffold, I1 Concept, etc.) should complete the full APEI loop — ALIGN → LEARN → PLAN → EXECUTE → IMPROVE — before advancing to the next iteration. The output of IMPROVE feeds back into ALIGN for the next cycle:

```
I0: ALIGN → LEARN → PLAN → EXECUTE → IMPROVE ─┐
I1: ALIGN → LEARN → PLAN → EXECUTE → IMPROVE ←─┘ (feedback loop)
I2: ...
```

**4 Subsystems (project-specific — customize per domain):**
- Example for Investment (User Enablement): User's Problem → Data → Analysis → Decision Making
- Example for Software: Requirements → Architecture → Implementation → Operations

### Zone Details

| Zone | Purpose | Key Question | Key Artifacts |
|------|---------|-------------|---------------|
| **1-ALIGN** | Choose the right outcome | Are we solving the right problem? | Charter, Stakeholders, Requirements, OKRs, ADRs, Learning Output |
| **2-PLAN** | Minimize risks via design | How do we manage failure risks? | System Design, UBS/UDS Registers, Master Plan, Execution Plan |
| **3-EXECUTE** | Deliver with version control | Are we building it right? | Source code, Tests, Config, API docs, Runbooks |
| **4-IMPROVE** | Learn and grow (cycle back) | What did we learn? What changed? | Changelog, Metrics, Retrospectives, Reviews, Risk Log |
| **_shared** | Organization knowledge base | What rules apply everywhere? | Brand, Security, Naming, Frameworks, SOPs, Templates |

### Learning Pipeline (inside 1-ALIGN/learning/)

The Effective Learning Framework (ELF) produces structured system designs from any learning process:

```
/learn:input → /learn:research → /learn:structure → /learn:review → /spec:extract → /spec:handoff
```

ELF output maps directly to project artifacts:
- P0 (Overview) → Charter | P1 (Blockers) → UBS Register | P2 (Drivers) → UDS Register
- P3 (Principles) → Requirements | P4 (Components) → System Design | P5 (Steps) → Execution Plan

Note: The learning PROCESS varies per member (Read/Write, Structured, Visual/Audio/Kinesthetic). The ELF OUTPUT format is standard. This pipeline is a could-have, not must-have.

## Global Rules (`_shared/`)

| Area | Files | What it covers |
|------|-------|---------------|
| Brand | `_shared/brand/` | 20-color palette, Inter/Work Sans typography, logo usage |
| Security | `_shared/security/` | 3-layer defense, data classification, risk tiers |
| Naming | `_shared/security/NAMING_CONVENTION.md` | UNG grammar, 75 SCOPE codes, platform rendering (lives under security/ as naming is a security control) |
| Frameworks | `_shared/frameworks/` | Thin pointers to canonical sources: ESD (8-component model), 7-CS, Diagnostics, Version Control, 3 Pillars, UBS/UDS Guide |
| Version Control | `_shared/frameworks/HISTORY_VERSION_CONTROL.md` | Branching, commits, PR workflow, chain-of-thought preservation |
| SOPs | `_shared/sops/` | Code review, deployment, discussion |
| Templates | `_shared/templates/` | ADR, research, retro, review, risk entry, SOP, spike, standup, wiki |

**SSOT flow:** `_shared/reference/` (canonical source) → `rules/` (agent-distilled, auto-loaded) → `_shared/frameworks/` (thin pointers for human discovery). When updating frameworks, edit `rules/` — `_shared/` pointers reference them automatically.

## Naming Convention

All LTC repos follow the **Universal Naming Grammar (UNG)**:

```
{SCOPE}_{FA}.{ID}.{NAME}
```

Example: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE`
- **SCOPE:** OPS (Operations)
- **FA:** OE (Operational Excellence)
- **ID:** 6.4
- **NAME:** LTC-PROJECT-TEMPLATE

## Safety Model

The template enforces a three-layer defense-in-depth model:

- **Layer 1 — Structural** (`.gitignore`): Passive defense. Secrets, key files, and backup directories are excluded by path. Cannot be accidentally committed.
- **Layer 2 — Agent EP** (`CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`, `.agents/rules/`): Constitutional rules the agent self-enforces — security, brand identity, naming conventions. Broad coverage, probabilistic enforcement (~80% compliance).
- **Layer 3 — Hard Gate** (`.pre-commit-config.yaml` + `.gitleaks.toml`): Deterministic. gitleaks blocks any commit containing detected secrets. Cannot be bypassed without explicit allowlist entry.

Additionally, `.claude/settings.json` provides platform-level deny/allow rules the agent physically cannot bypass. Configure it first — it is your safety net.

See `rules/security-rules.md` for the full security reference, including risk tiers, gap analysis, and setup instructions.

## Memory Protection

Claude Code's **Auto Memory** writes notes about your project across sessions into `~/.claude/projects/<project>/memory/MEMORY.md`. **AutoDream** periodically consolidates these notes — pruning stale entries, merging duplicates, and normalizing dates.

LTC projects use a custom 3-section MEMORY.md template:

```
## Agent Instructions   ← Meta-rules (structural, never consolidate)
## Briefing Card        ← Quick-load context (Identity, Subject, EO, state, WMS)
## Topic Index          ← Pointer list to detail files
```

Without protection, AutoDream flattens this structure into generic sections and deletes the meta-rules. The template includes a 2-tier defense:

| Tier | File | Mechanism | Reliability |
|------|------|-----------|-------------|
| 1 (Guide) | `.claude/rules/memory-format.md` | Instructs any agent to preserve the 3-section structure | ~95% (probabilistic) |
| 2 (Gate) | `~/.claude/hooks/scripts/memory-guard.sh` | PreToolUse hook blocks writes that destroy structure | 100% (deterministic) |

**Tier 1** ships with the template. **Tier 2** must be installed per-machine (see setup below).

### Member Setup (per-machine, ~5 minutes)

**1. Install Memory Vault plugin** — add to `~/.claude/settings.json`:
```json
{
  "extraKnownMarketplaces": {
    "ltc-plugins": {
      "source": { "source": "directory", "path": "/path/to/OPS_OE.6.4.LTC-PROJECT-TEMPLATE" }
    }
  }
}
```
Then run `/setup` in any Claude Code session.

**2. Install memory-guard hook** — copy to `~/.claude/hooks/scripts/` and add to `~/.claude/settings.json`:
```bash
# Copy scripts
cp plugins/memory-vault/scripts/memory-guard.sh ~/.claude/hooks/scripts/
cp plugins/memory-vault/scripts/validate-memory-structure.sh ~/.claude/hooks/scripts/
chmod +x ~/.claude/hooks/scripts/memory-guard.sh ~/.claude/hooks/scripts/validate-memory-structure.sh
```
Add this to `hooks.PreToolUse` array in `~/.claude/settings.json`:
```json
{ "matcher": "Write", "hooks": [{ "type": "command", "command": "bash $HOME/.claude/hooks/scripts/memory-guard.sh", "timeout": 5 }] }
```

**3. Copy global rule** — ensures protection outside project repos:
```bash
mkdir -p ~/.claude/rules
cp .claude/rules/memory-format.md ~/.claude/rules/memory-format.md
```

**4. Enable AutoDream** — run `/memory` in Claude Code, toggle `Auto-dream` to `on`.

**5. Verify:**
```bash
bash ~/.claude/hooks/scripts/validate-memory-structure.sh
```

## Plugins

This template includes Claude Code plugins in `plugins/`. Each plugin is discoverable via `.claude-plugin/marketplace.json`.

| Plugin | What it does | Install |
|--------|-------------|---------|
| `memory-vault` | Cross-session memory — auto-exports sessions, indexes with QMD, recalls context at startup | See [`plugins/memory-vault/README.md`](plugins/memory-vault/README.md) |

## Personal Overrides

To add personal permissions without affecting the team:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
# Edit settings.local.json — it's gitignored
```

## Keeping Your Repo Updated

This template uses semver versioning. The `VERSION` file tracks the current template version.

### Distribution Tiers

Every file falls into one of three update tiers:

| Tier | Strategy | What it means |
|------|----------|---------------|
| T1:REPLACE | Overwrite | Org-owned. Copy the template's version directly. |
| T2:MERGE | Merge | Mixed ownership. Update org sections, keep your project sections. |
| T3:ADD-ONLY | Add new | New files only. Never overwrites your existing files. |

See CHANGELOG.md for tier tags on every change.

### Checking for Updates

**Prerequisite:** The staleness checker uses `gh` CLI (already installed with Claude Code).
If not yet authenticated, run `gh auth login` once — no separate token needed.

Run the staleness checker:

    ./scripts/template-check.sh           # full report
    ./scripts/template-check.sh --diff    # show changed files with tier tags
    ./scripts/template-check.sh --quiet   # one-line summary (used by session-start)

First time? Bootstrap your sync version:

    ./scripts/template-check.sh --init

### Applying Updates

1. Open your repo in Claude Code (or your IDE of choice)
2. Paste the template repo URL and ask:
   "Check this template and see if there is any update I need to make to my repo"
3. Claude diffs the template against your repo and recommends changes per tier
4. Review and approve each change
5. Update `.template-version` to the new version

### Releasing a Template Update (maintainers)

1. Make changes to the template repo
2. Bump `VERSION` (semver: patch/minor/major)
3. Add CHANGELOG.md entry with tier tags per file
4. Commit, push, and optionally tag: `git tag v{VERSION}`

---

_Template maintained by OPS Process. Source: [OPS_OE.6.4.LTC-PROJECT-TEMPLATE](https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE)_
