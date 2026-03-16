# CLAUDE.md — {PROJECT_NAME}

> Constitutional rules for the AI agent. Loaded every session.
> Keep this under 50 lines. Move file-specific details to `.claude/rules/`.

## Project

- **Name:** {PROJECT_NAME}
- **Stack:** {e.g., TypeScript, React, Node.js}
- **Purpose:** {One sentence — what this project does}

## Rules

- Follow existing patterns in the codebase before inventing new ones
- Write tests for new functionality
- Commit atomic changes with descriptive messages

## Conventions

- {Add your naming conventions, code style, etc.}

## Brand Identity

Brand identity rules (colors, typography, logo) are in `AGENTS.md` (loaded by all AI tools).
Full reference: `rules/brand-identity.md`. Also mirrored in `.cursor/rules/` and `.agents/rules/`.

## Structure

```
src/           — Application source code
docs/          — Reference documentation
scripts/       — Build and utility scripts
tests/         — Test suites
rules/         — LTC global rules (brand identity, naming, security, effectiveness)
```

## Modular Rules

File-specific conventions live in `.claude/rules/` (loaded on demand):
- See `.claude/rules/` for path-scoped rules

## Skills

On-demand procedures live in `.claude/skills/` (loaded when invoked):
- See `.claude/skills/` for available skills
