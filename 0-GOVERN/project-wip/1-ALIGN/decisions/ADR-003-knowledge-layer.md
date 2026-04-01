---
version: "1.0"
status: Deferred
last_updated: 2026-03-30
owner: Long Nguyen
---

# ADR-003: Knowledge Layer Architecture

**Status:** DEFERRED
**Date:** 2026-03-30
**Decider(s):** Vinh (CIO/Director), Long Nguyen (Builder)
**MoSCoW:** Could (I1) — directional architecture, not I1 mandatory
**Deferral Target:** I2

---

## Context

Vinh's whiteboard session (S1, 2026-03-30) introduced a 3-layer architecture:

```
┌──────────────────────────────────────────┐
│  OBSIDIAN BASE (Knowledge Layer)         │
├──────────────────────────────────────────┤
│  AGENT (Execution Layer)                 │
├──────────────────────────────────────────┤
│  WMS (Accountability Layer)              │
└──────────────────────────────────────────┘
```

The current template operates on a 2-layer model: Agent reads/writes the repo directly, WMS (ClickUp/Notion) tracks accountability. There is no distinct knowledge layer — the repo IS both knowledge and execution.

The question: should a dedicated knowledge layer (Obsidian Base) sit between the repo content and the agent, providing search, interconnectedness, and a human-facing knowledge view?

**Why deferred:** This is a Could-priority architectural direction. I1 focuses on sustainability (safe to use). The knowledge layer is an I2 efficiency/scalability concern. ADR-002 (Obsidian CLI spike) must complete first — the knowledge layer depends on whether Obsidian is viable.

## Options Recorded

### Option A: Obsidian Vault as Knowledge Base

- **Description:** The repo becomes an Obsidian vault. Obsidian provides the knowledge layer — graph view, backlinks, search, Bases for dashboards. Agents read from the vault via Obsidian CLI. Humans interact via Obsidian app. WMS remains separate for accountability.
- **Sustainability:** Risk — couples the template to Obsidian ecosystem. New team members must learn Obsidian. If Obsidian changes direction, the knowledge layer breaks.
- **Efficiency:** High for humans (rich visual tools). Potentially high for agents if CLI is performant (depends on ADR-002 spike).
- **Scalability:** Strong — Obsidian is designed for large vaults. But org-wide adoption means 8+ team members must buy into Obsidian workflow.

### Option B: Flat Markdown with Agent-Managed Indexing

- **Description:** No knowledge layer. The repo remains flat markdown. Agents build their own indexing (frontmatter parsing, grep-based search, memory files). Humans navigate via IDE/file browser. This is the current model, formalized.
- **Sustainability:** Highest — zero new dependencies. Works today. No adoption friction beyond what already exists.
- **Efficiency:** Low for cross-referencing. Agents must re-discover connections each session. No persistent graph. Humans lack visual interconnectedness view.
- **Scalability:** Degrades as repo grows. At 500+ files, flat search becomes noisy. No structural interconnectedness without manual effort.

### Option C: Hybrid — Obsidian for Humans, Agent-Native Indexing for Agents

- **Description:** Humans use Obsidian app for knowledge exploration (graph, backlinks, Bases). Agents use their own indexing (frontmatter, grep, memory). The two layers coexist but don't depend on each other. Obsidian vault config (`.obsidian/`) is optional — repo works without it.
- **Sustainability:** Medium — Obsidian is opt-in, not required. Agents function without it. But maintaining two indexing strategies adds complexity.
- **Efficiency:** Medium — each audience gets their preferred tool. But no single source of truth for interconnectedness. Humans and agents may see different connection graphs.
- **Scalability:** Moderate — scales for each audience independently. But divergence between human view and agent view could create confusion at org scale.

## Decision

**DEFERRED.** No option is chosen.

## Deferral Rationale

1. **Dependency on ADR-002.** The knowledge layer architecture depends on whether Obsidian CLI is viable. Until the spike completes, Options A and C cannot be properly evaluated.
2. **I1 scope is sustainability.** The current 2-layer model works. Adding a knowledge layer is an efficiency/scalability improvement — I2 territory.
3. **Design Principle #2: Problem-first.** The team has not yet hit the pain point of missing interconnectedness at scale. The repo currently has ~130 files. The knowledge layer solves a problem that emerges at 500+ files across multiple projects.
4. **Decision inputs needed:** ADR-002 spike results, team feedback on Obsidian adoption willingness, concrete pain points from I1 execution that a knowledge layer would solve.

## Review Date

I2 kickoff — after ADR-002 is resolved and I1 is complete.

---

**Derived From:** S1 (Vinh whiteboard 2026-03-30), R03/R04 in stakeholder input synthesis, Design Principle #6 (separate knowledge, execution, accountability)
