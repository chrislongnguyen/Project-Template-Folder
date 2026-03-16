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
| 4 | `AGENTS.md` | Fill in build/test/lint commands for your stack. |
| 5 | `.mcp.json` | Add MCP server connections if your project uses external tools. |
| 6 | `.claude/rules/` | Delete the example rule. Add path-scoped rules for your codebase. |
| 7 | `.claude/skills/` | Add project-specific skills (on-demand procedures). |

### 4. Start working

```bash
claude   # Opens Claude Code with all rules auto-loaded
```

## What's Included

```
.
├── CLAUDE.md                          # Agent rules (loaded every session)
├── AGENTS.md                          # Universal rules for all AI tools
├── .claude/
│   ├── settings.json                  # Safety permissions (deny/allow)
│   ├── settings.local.json.example    # Personal overrides template (gitignored)
│   ├── agents/                        # Subagent definitions
│   ├── commands/                      # Slash commands
│   ├── hooks/                         # Event-driven scripts
│   ├── rules/                         # Path-scoped rules (loaded on demand)
│   └── skills/                        # On-demand procedures
├── .cursor/rules/                     # Cursor-specific rules
├── .agents/rules/                     # AntiGravity-specific rules
├── rules/
│   └── brand-identity.md             # LTC brand colors, typography, logo rules
├── src/                               # Application source code
├── docs/                              # Reference documentation
├── scripts/                           # Build and utility scripts
├── tests/                             # Test suites
├── .gitignore                         # Secrets, build output, IDE files excluded
└── .mcp.json                          # MCP server connections
```

## LTC Global Rules

The `rules/` folder contains LTC-wide standards that apply to all projects:

| Rule File | What it covers | Status |
|-----------|---------------|--------|
| `brand-identity.md` | Colors (20-color palette), typography (Tenorite/Work Sans), logo usage, function color assignments, MS Office theme | Active |
| `naming-rules.md` | LTC Universal Naming Grammar (UNG) for repos, folders, and platform items | Coming soon |
| `security-rules.md` | Data privacy policies, authentication, access controls | Coming soon |
| `effective-system.md` | Desired outcomes, UBS/UDS framework, effective principles | Coming soon |

These rules are **not auto-loaded** into every session. CLAUDE.md contains a distilled summary of brand identity (primary palette, font, logo). The full reference files are loaded on demand when the agent needs detailed specifications.

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

- **100% enforced** (`.claude/settings.json`): Deny rules the agent physically cannot bypass — no reading secrets, no `rm -rf`, no force push.
- **~80% advisory** (`CLAUDE.md`): Constitutional rules the agent follows with high compliance — coding standards, brand identity, naming conventions.

Configure the 100% tier first. It is your safety net.

## Personal Overrides

To add personal permissions without affecting the team:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
# Edit settings.local.json — it's gitignored
```

---

_Template maintained by OPS Process. Source: [OPS_OE.6.4.LTC-PROJECT-TEMPLATE](https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE)_
