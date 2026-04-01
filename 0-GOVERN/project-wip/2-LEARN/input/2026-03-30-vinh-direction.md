---
version: "1.0"
last_updated: 2026-03-30
source: "whiteboard + verbal discussion"
participants: ["Vinh", "Long"]
type: raw-input
---
# Vinh Direction — 2026-03-30 Whiteboard Session

## Context

ALPEI is the primary lens — the flow the Human Director follows: ALIGN → LEARN → PLAN → EXECUTE → IMPROVE. LEARN sits between ALIGN and PLAN. You ALIGN first (understand the problem), then LEARN (research what you need), then learning outputs feed BACK into ALIGN (refine charter/requirements) AND FORWARD into PLAN (tactical/strategic inputs).

## Raw Content

### Directive 1: LEARN as Separate Zone (I1 Must)

**Formal request, not a suggestion.** Currently LEARN is nested inside `1-ALIGN/learning/`. Vinh wants it extracted as its own standalone zone in the ALPEI structure. LEARN feeds both directions — back into ALIGN (refined understanding) and forward into PLAN (research inputs for strategy/tactics). Learning WIP is personal to each user (drawings, notes, slides — unstructured, no template enforcement).

**Execution:** Must be done in a separate worktree → merge to branch → PR to main. This is I1 scope, not I2.

### Directive 2: Obsidian CLI for Information Search

Vinh proposed using Obsidian CLI to enable information search and interconnectedness of MD files in the repo. As the repo grows, every file needs to be connected to others accurately and scalably. This is an exploration assignment — Long to try it out first, then implement if viable.

Part of the learning pipeline from the whiteboard (see below).

### Directive 3: Obsidian Bases as Interim Dashboard (Nice-to-Have)

Obsidian Bases could serve as an interim dashboard for human project managers to manage agent work. Lower priority than directives 1 and 2.

### Two Types of Alignment

Vinh distinguishes:
- **Human↔Human** — philosophy, frameworks. Happens on WMS (ClickUp/Notion/Obsidian Bases). OUT OF SCOPE for I1.
- **Human↔Agent** — project artifacts in repo (charter, OKRs, decisions). IN SCOPE for I1.

### The Repo as 7-CS System

The repo IS a 7-CS system, but this is a PROPERTY, not the organizing principle. The Human thinks in ALPEI zones, not 7-CS components. Every component must enable Human (Director) and Agent (Do-er) per the 8 LLM Truths.

### Human as Effective Director

The template must enable the Human to follow Agile framework & process when working with Agent. Human leverages EOE, EOT, EOP to harness Agent in all scenarios. The repo serves the Human as Director to build their "User Enablement System" (the actual project/investment).

### Whiteboard Architecture (3-Layer)

```
┌─────────────────────────────────────────────────────────┐
│  OBSIDIAN BASE (Knowledge Layer)                        │
│                                                         │
│  Zones: GOVERN | ALIGN | LEARN | PLAN | ECE | DISCOVERY │
│  Cross: RULES  | PEOPLE                                 │
├─────────────────────────────────────────────────────────┤
│  AGENT (Execution Layer)                                │
├─────────────────────────────────────────────────────────┤
│  WMS (Accountability Layer — Human-Facing)              │
└─────────────────────────────────────────────────────────┘
```

### Learning Pipeline (from whiteboard)

```
1. Info search (Obsidian CLI, MD files)
   → 2. Info connection
      → 3. LEARN
         → 4. (unclear step)
```

Obsidian CLI solves the information search & interconnectedness problem as the repo grows.

## Attachments

- Whiteboard photo: `docs/idea/IMG_6145.jpeg`
