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
| 3 | `CLAUDE.md` | Replace all `{placeholders}` with your project details. Keep under 50 lines. |
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
├── .claude/
│   ├── settings.json          # Safety deny/allow     ← Environment (hard ceilings)
│   ├── settings.local.json.example  # Personal overrides  ← Environment (per-user)
│   ├── agents/                # Subagent definitions   ← Agent (operator config)
│   ├── commands/              # Slash commands         ← EOP (on-demand procedures)
│   ├── hooks/                 # Event-driven scripts   ← Environment (automation)
│   ├── rules/                 # Path-scoped rules      ← EPS (modular, on-demand)
│   └── skills/                # On-demand procedures   ← EOP (reusable playbooks)
├── .cursor/rules/
│   └── brand-identity.md     # Cursor brand rules     ← EPS (tool-specific)
├── .agents/rules/
│   └── brand-identity.md     # AntiGravity rules      ← EPS (tool-specific)
├── rules/
│   └── brand-identity.md     # Full 20-color ref      ← EPS (global reference)
├── src/                       # Application code       ← Input (task context)
├── docs/                      # Reference docs         ← Input (knowledge base)
├── scripts/                   # Build/deploy utils     ← Tools (extend agent capability)
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
| `brand-identity.md` | Colors (20-color palette), typography (Tenorite/Work Sans), logo usage, function color assignments, MS Office theme | Active |
| `naming-rules.md` | Universal Naming Grammar (UNG) — canonical key pattern, 75 SCOPE codes, platform rendering (Git, Local, ClickUp, Drive), validation regex | Active |
| `security-rules.md` | Data privacy policies, authentication, access controls | Coming soon |
| `effective-system.md` | Desired outcomes, UBS/UDS framework, effective principles | Coming soon |

### How rules reach each tool

Each tool reads **different files** at session start. There is no single file all tools share.

| Tool | Primary rules file | Brand identity source | Loading |
|------|-------------------|----------------------|---------|
| **Claude Code** (CLI) | `CLAUDE.md` | Embedded in CLAUDE.md (distilled summary) | Auto-loaded every session |
| **AntiGravity** (IDE) | `GEMINI.md` | Embedded in GEMINI.md (distilled summary) | Auto-loaded every session |
| **Cursor** (IDE) | `.cursor/rules/` | `.cursor/rules/brand-identity.md` | Auto-loads when editing *.html, *.css, *.tsx, etc. |
| **All tools** | `rules/brand-identity.md` | Full 20-color reference | On demand — agent reads when it needs detailed specs |

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

The template enforces a two-tier safety model:

- **100% enforced** (`.claude/settings.json`): Deny rules the Claude Code agent physically cannot bypass — no reading secrets, no `rm -rf`, no force push. AntiGravity and Cursor have their own permission models configured in their respective IDE settings.
- **~80% advisory** (`CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`): Constitutional rules the agent follows with high compliance — coding standards, brand identity, naming conventions.

Configure the 100% tier first. It is your safety net.

## Personal Overrides

To add personal permissions without affecting the team:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
# Edit settings.local.json — it's gitignored
```

---

_Template maintained by OPS Process. Source: [OPS_OE.6.4.LTC-PROJECT-TEMPLATE](https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE)_
