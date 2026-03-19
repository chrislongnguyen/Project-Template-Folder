# CLAUDE.md — {PROJECT_NAME}

> Claude Code agent rules. Loaded every session. Keep under 100 lines; details go to `.claude/rules/`.

## Project

- **Name:** {PROJECT_NAME}
- **Stack:** {e.g., TypeScript, React, Node.js}
- **Purpose:** {One sentence — what this project does}

## Build

- Install: `{npm install / pip install -r requirements.txt / etc.}` | Test: `{npm test / pytest / etc.}` | Lint: `{npm run lint / etc.}`

## Rules

- Follow existing patterns in the codebase before inventing new ones
- Write tests for new functionality
- Commit atomic changes with descriptive messages
- PREFER editing existing files over creating new ones
- If anything contradicts this file, flag the contradiction before proceeding

## Conventions

- {Add your naming conventions, code style, etc.}

## Brand Identity (full spec: `rules/brand-identity.md`)

**MANDATORY for ALL visual output** — HTML, CSS, SVG, charts, slide decks, diagrams, emails, PDFs.
Non-compliance = broken output. Load `rules/brand-identity.md` BEFORE generating any visual artifact.

Primary palette:
- Midnight Green #004851 (dark primary) | Gold #F2C75C (accent primary)
- Dark Gunmetal #1D1F2A (text/dark bg) | White #FFFFFF (text/light bg)

Accent priority: Gold > Ruby Red #9B1842 > Green #69994D > Dark Purple #653469

Logo: "LT Capital Partners" — Midnight Green on light bg, Gold on dark bg.
Typography: **Inter** (English), **Work Sans** (Vietnamese). Both via Google Fonts. Base 11pt.

**NEVER:**
- Use generic/default colors (Bootstrap blue, Tailwind gray, Chart.js defaults, browser defaults)
- Use fonts other than Inter or Work Sans — no Arial, Helvetica, Roboto, system defaults
- Omit Google Fonts `<link>` / `@import` — fonts are NOT locally installed
- Generate unstyled HTML — every visual artifact MUST include LTC colors and fonts

## Naming (full spec: `rules/naming-rules.md`)

All LTC items follow UNG: `{SCOPE}_{FA}.{ID}.{NAME}`. Before creating any named item (repo, folder, ClickUp project/deliverable, Drive item), load `rules/naming-rules.md`.

## Security (full spec: `rules/security-rules.md`)

### Secrets
- NEVER hardcode secrets (API keys, tokens, passwords, connection strings) in source code, prompts, or tool arguments
- All secrets MUST live in `.env` or `secrets/` (both gitignored). Reference via environment variables only
- Before completing any task, scan your output for patterns that look like secrets (API keys, tokens, passwords, PII). This check is pattern-based. If found — stop, redact, alert the user

### Execution Risk Tiers
- LOW (read files, search, lint, run tests): proceed without confirmation
- MEDIUM (edit files, git commit, install packages): proceed, user can review
- HIGH (delete files, git push, force operations, deploy, modify CI/CD, touch .env/secrets/): ALWAYS require explicit user confirmation

### Blast Radius
- Operate only within the project directory unless explicitly instructed otherwise
- For destructive or experimental operations, prefer git worktrees or branches — never on main directly
- Prefer reversible actions (git commit) over irreversible ones (file deletion of untracked files)
- When making external API calls or web requests, never include secrets, PII, or confidential data unless the endpoint is explicitly authorized

### Backup Awareness
- Before overwriting non-git-tracked files, warn the user that the original is not recoverable
- NEVER force-push without confirming the remote state and getting explicit approval
- If a file cannot be easily recreated, flag this before modifying it

## Agent System (full spec: `rules/agent-system.md`)

Your AI agent has 8 structural limits (LLM Truths) that cannot be patched away.
The 7-Component System compensates: EPS → Input → EOP → Environment → Tools → Agent → Action → Outcome.
Three principles: (1) Derisk before driving output, (2) Know the agent's physics, (3) Human Director + Agent = complementary operators.
When output is wrong: load the diagnostic framework before blaming the model.

## System Design (full spec: `rules/general-system.md`)

Every system has 6 components: Input, User, Action, Principles, Tools, Environment → Outcome.
Establish RACI (R and A) before analyzing forces. UBS/UDS analyzed from both R and A perspectives.
System boundaries have 4 progressive layers: (1) What flows, (2) Contract fields, (3) Eval spec per AC, (4) Failure modes.
Design methodology: Problem Discovery → System Design → VANA Requirements (Verb-Adverb-Noun-Adjective with binary ACs).

## Agent Diagnostics (full spec: `rules/agent-diagnostic.md`)

When agent output is wrong: trace through 6 configurable components (EPS → Input → EOP → Environment → Tools → Agent) before blaming the model.
Derisk checklist: list what can go wrong, map each risk to an LT and component, verify it is configured.
Symptom-to-component lookup table and Force Map available for quick diagnosis.

## Structure
`src/` code | `docs/` reference | `scripts/` utilities | `tests/` tests | `rules/` LTC global rules

## Modular Rules & Skills

Path-scoped rules: `.claude/rules/` | On-demand skills: `.claude/skills/`

## Template Version

If `./scripts/template-check.sh` exists, run `./scripts/template-check.sh --quiet` at session start.
If behind, warn the user before proceeding. If the script is missing, skip silently.
