---
version: "2.0"
status: draft
last_updated: 2026-04-07
type: readme
iteration: 2
---

# AntiGravity Agent Skills

This directory is reserved for AntiGravity IDE agent skills. Skills are on-demand procedures that agents load when specific tasks are triggered.

## Current Status

AntiGravity skill support is in development. For now, agent behavior is governed by:

- **Rules:** `.agents/rules/` — 6 always-on rule files covering brand, security, agent system, diagnostics, system design, and template version
- **Cross-agent roster:** `AGENTS.md` at project root
- **Shared rules:** `rules/` at project root (agent-agnostic, read by all IDEs)

## Claude Code Skills (reference)

The most complete skill set is in `.claude/skills/` (32 skills). When AntiGravity skill authoring matures, key skills to port:

- `/dsbv` — DSBV lifecycle orchestration
- `/git-save` — Guided git commit workflow
- `/ltc-brand-identity` — Brand compliance checking
- `/ltc-naming-rules` — UNG validation
- `/ltc-rules-compliance` — Multi-domain compliance audit

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SKILL]]
- [[iteration]]
- [[project]]
- [[security]]
