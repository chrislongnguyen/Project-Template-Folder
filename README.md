# LTC Project Template

Standard project scaffold for LT Capital Partners. Use this template to start any new project with LTC's global rules, safety guardrails, and AI agent configuration pre-loaded.

## Quick Start

### 1. Create your project from this template

**On GitHub:** Click the green **"Use this template"** button at the top of this repo. Choose the owner, name your project using LTC naming convention, and click "Create repository."

**From CLI:**
```bash
gh repo create Long-Term-Capital-Partners/{YOUR_PROJECT_NAME} \
  --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
```

### 2. Clone and configure

```bash
git clone https://github.com/Long-Term-Capital-Partners/{YOUR_PROJECT_NAME}.git
cd {YOUR_PROJECT_NAME}
```

### 3. Customize these files (in this order)

| Step | File | What to do |
|------|------|------------|
| 1 | `.claude/settings.json` | Review deny/allow rules. Add project-specific permissions. This is your safety net — configure it first. |
| 2 | `.gitignore` | Add any project-specific exclusions (credentials, data files, etc.) |
| 3 | `CLAUDE.md` | Replace all `{placeholders}` with your project details. Keep under 80 lines. |
| 4 | `GEMINI.md` | Replace all `{placeholders}` — same structure as CLAUDE.md but for AntiGravity. Keep in sync. |
| 5 | `.mcp.json` | Add MCP server connections if your project uses external tools. |
| 6 | `.claude/rules/` | Delete the example rule. Add path-scoped rules for your codebase. |
| 7 | `.claude/skills/` | Add project-specific skills (on-demand procedures). |
| — | `.cursor/rules/`, `.agents/rules/` | Already configured with brand identity. Add more rules as needed for Cursor / AntiGravity. |

### 4. Start working

```bash
claude   # Opens Claude Code with CLAUDE.md auto-loaded
```

Or open the project in AntiGravity / Cursor — each IDE loads its own rules automatically.

## What's Included

```
.                                                    7-CS Component
├── CLAUDE.md                  # Claude Code rules     ← EPS (always-active constitution)
├── GEMINI.md                  # AntiGravity rules     ← EPS (always-active constitution)
├── VERSION                    # Template version       ← Input (distribution tracking)
├── CHANGELOG.md               # Tier-tagged changelog  ← Input (distribution tracking)
├── .claude/
│   ├── settings.json          # Safety deny/allow     ← Environment (hard ceilings)
│   ├── settings.local.json.example  # Personal overrides  ← Environment (per-user)
│   ├── agents/                # Subagent definitions   ← Agent (operator config)
│   ├── commands/              # Slash commands         ← EOP (on-demand procedures)
│   ├── hooks/                 # Event-driven scripts   ← Environment (automation)
│   ├── rules/                 # Path-scoped rules      ← EPS (modular, on-demand)
│   └── skills/                # On-demand procedures   ← EOP (reusable playbooks)
├── .cursor/rules/
│   ├── brand-identity.md     # Cursor brand rules     ← EPS (tool-specific)
│   ├── template-version.md   # Version check rule     ← EPS (session-start)
│   └── security.md           # Cursor security rules   ← EPS (tool-specific)
├── .agents/rules/
│   ├── brand-identity.md     # AntiGravity rules      ← EPS (tool-specific)
│   └── security.md           # AntiGravity security    ← EPS (tool-specific)
├── .pre-commit-config.yaml    # gitleaks hook config    ← Environment (hard gate)
├── .gitleaks.toml             # Secret detection rules  ← Environment (hard gate)
├── rules/
│   ├── brand-identity.md     # Full 20-color ref      ← EPS (global reference)
│   ├── naming-rules.md       # UNG full spec          ← EPS (global reference)
│   └── security-rules.md     # 3-layer security ref   ← EPS (global reference)
├── src/                       # Application code       ← Input (task context)
├── docs/                      # Reference docs         ← Input (knowledge base)
├── scripts/
│   └── template-check.sh     # Staleness checker      ← Tools (distribution)
├── tests/                     # Test suites            ← EOP (verification gates)
├── .gitignore                 # Excluded files         ← Environment (safety boundary)
└── .mcp.json                  # MCP server connections ← Tools (external integrations)
```

> **7-CS** = The Agent's 7-Component System (Doc-9). Each file maps to a component:
> **EPS** constrains behavior | **EOP** defines procedures | **Environment** sets hard limits |
> **Tools** extend capability | **Input** provides context | **Agent** executes within all of the above.

## LTC Global Rules

The `rules/` folder contains LTC-wide standards that apply to all projects:

| Rule File | What it covers | Status |
|-----------|---------------|--------|
| `brand-identity.md` | Colors (20-color palette), typography (Inter/Work Sans), logo usage, function color assignments, MS Office theme | Active |
| `naming-rules.md` | Universal Naming Grammar (UNG) — canonical key pattern, 75 SCOPE codes, platform rendering (Git, Local, ClickUp, Drive), validation regex | Active |
| `security-rules.md` | 3-layer defense-in-depth: 6 AI agent security rules, risk tiers, secret detection (gitleaks), gap analysis, setup guide | Active |
| `effective-system.md` | Desired outcomes, UBS/UDS framework, effective principles | Coming soon |

### How rules reach each tool

Each tool reads **different files** at session start. There is no single file all tools share.

| Tool | Primary rules file | Brand + Security source | Loading |
|------|-------------------|------------------------|---------|
| **Claude Code** (CLI) | `CLAUDE.md` | Distilled in CLAUDE.md (brand, naming, security) | Auto-loaded every session |
| **AntiGravity** (IDE) | `GEMINI.md` | Distilled in GEMINI.md (brand, naming, security) | Auto-loaded every session |
| **Cursor** (IDE) | `.cursor/rules/` | `.cursor/rules/brand-identity.md`, `security.md` | Auto-loads matching globs |
| **All tools** | `rules/` | Full references: brand-identity, naming-rules, security-rules | On demand — agent reads when it needs detailed specs |
| **Pre-commit** | `.pre-commit-config.yaml` | `.gitleaks.toml` (secret detection) | Runs on every `git commit` |

**Why no AGENTS.md?** The AAIF standard promises a universal file all tools read. In practice, only Claude Code reads it. AntiGravity reads GEMINI.md. Cursor reads .cursor/rules/. Rather than maintain a file only one tool uses, each tool gets rules through its own guaranteed loading path. Less elegant, more reliable.

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
- **Layer 2 — Agent EPS** (`CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`, `.agents/rules/`): Constitutional rules the agent self-enforces — security, brand identity, naming conventions. Broad coverage, probabilistic enforcement (~80% compliance).
- **Layer 3 — Hard Gate** (`.pre-commit-config.yaml` + `.gitleaks.toml`): Deterministic. gitleaks blocks any commit containing detected secrets. Cannot be bypassed without explicit allowlist entry.

Additionally, `.claude/settings.json` provides platform-level deny/allow rules the agent physically cannot bypass. Configure it first — it is your safety net.

See `rules/security-rules.md` for the full security reference, including risk tiers, gap analysis, and setup instructions.

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
