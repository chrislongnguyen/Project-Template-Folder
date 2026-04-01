---
version: "1.0"
status: Deferred
last_updated: 2026-03-30
owner: Long Nguyen
---

# ADR-002: Obsidian CLI Integration Approach

**Status:** DEFERRED
**Date:** 2026-03-30
**Decider(s):** Vinh (CIO/Director), Long Nguyen (Builder)
**MoSCoW:** Should (I1)
**Deferral Target:** After Long completes exploration spike

---

## Context

Vinh proposed using Obsidian CLI to enable information search and interconnectedness of MD files in the repo (S1, 2026-03-30). As the repo grows, every file needs to be connected to others accurately and scalably. This is an exploration assignment — Long explores first, then the team decides on integration approach.

The learning pipeline from Vinh's whiteboard: Info search → Info connection → LEARN → synthesis. Obsidian CLI solves the first two steps. The question is HOW to integrate it, not WHETHER to explore it.

**Why deferred:** No spike data exists yet. Choosing an approach without testing Obsidian CLI in a headless/agent context risks committing to a tool that may not work (violates Design Principle #2: problem-first, not solution-first).

## Options Recorded

### Option A: Native Obsidian CLI as Primary Search

- **Description:** Replace current search tooling (Grep/Glob) with Obsidian CLI as the primary MD search mechanism. Repo becomes an Obsidian vault. All agents use Obsidian CLI for file discovery and cross-referencing.
- **Sustainability:** Risk — introduces hard dependency on Obsidian. If CLI breaks or changes API, all search breaks. Team members must install Obsidian tooling. Friction for adoption if Obsidian setup is non-trivial.
- **Efficiency:** Potentially high — Obsidian's graph and backlink features provide interconnectedness "for free." But unknown performance in headless/CI environments.
- **Scalability:** Strong if Obsidian scales with repo size. Unknown behavior at 500+ MD files with agent-frequency queries.

### Option B: Obsidian as Optional Enhancement

- **Description:** Keep current search (Grep/Glob/agent-native) as baseline. Add Obsidian CLI as an optional layer for humans who want graph/backlink features. Agents do not depend on Obsidian.
- **Sustainability:** High — no new dependency for core workflow. Obsidian failure is non-critical. Lowest adoption friction (opt-in, not mandatory).
- **Efficiency:** Medium — humans get Obsidian benefits, agents don't. Two search mechanisms to maintain. No single source of interconnectedness.
- **Scalability:** Scales safely because core path has no new dependency. But misses the cross-referencing value Vinh envisions for agents.

### Option C: Custom MD Search Mimicking Obsidian Graph Features

- **Description:** Build a lightweight custom tool (Python/Shell) that indexes MD files, extracts wikilinks/frontmatter references, and provides graph-like search. No Obsidian dependency.
- **Sustainability:** Medium — no external dependency, but requires building and maintaining custom tooling. Build effort competes with I1 priorities.
- **Efficiency:** Low initially (must build from scratch). Could be high long-term if tailored to LTC's exact needs.
- **Scalability:** Full control over indexing strategy. Can optimize for agent consumption patterns. But maintenance burden grows with features.

## Decision

**DEFERRED.** No option is chosen.

## Deferral Rationale

1. **No empirical data.** Long has not yet tested Obsidian CLI in a headless/agent context. Key unknowns: installation friction, performance with agent-frequency queries, compatibility with CI/hooks, behavior with 100+ MD files.
2. **Vinh's directive is to explore, not commit.** S1 explicitly framed this as "Long to try it out first, then implement if viable."
3. **Sustainability-first.** Choosing an integration approach before the spike violates I1's sustainability principle — the template must be safe before adding features.
4. **Decision inputs needed:** Spike results (feasibility, friction, performance), comparison with current Grep/Glob baseline, team feedback on Obsidian setup experience.

## Review Date

After spike completion — estimated I1 mid-point or I2 kickoff.

---

**Derived From:** S1 (Vinh whiteboard 2026-03-30), R02 in stakeholder input synthesis
