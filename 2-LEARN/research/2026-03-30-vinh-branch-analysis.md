---
version: "1.0"
last_updated: 2026-03-30
source: "Vinh-ALPEI-AI-Operating-System-with-Obsidian branch analysis"
type: research
---
# Vinh Branch Analysis — Content for Integration

## Source

Branch: `Vinh-ALPEI-AI-Operating-System-with-Obsidian`
Repo: Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
Analyzed: 2026-03-30

## Key Finding: S > E Priority Inversion

Our template optimized for agent efficiency (hooks, rules, DSBV gates) before human sustainability (training, onboarding, navigation). Vinh did the reverse — training deck v1→v4 in one day, SOP v1→v3, human-first. Both approaches are incomplete alone; the merge is the goal.

**Principle S8 added to charter:** "Human adoption risks (UBS) must be addressed before or alongside agent-facing risks."

## Vinh's Development Principles (inferred from commits)

1. Structure before content (Day 1 = folders + templates only)
2. Training is first-class deliverable (4 iterations in one day)
3. Agent friction is a bug, not feature request (dedicated friction sweep)
4. SOP is living documentation (updated with every capability)
5. Multi-agent governance from day 1 (5 platforms)
6. Optimize in rounds (audit → fix → verify cycles)
7. Human-facing artifacts get branded (presentation-quality output)

## Content to Bring Back (requires process mapping session)

### STEAL (direct adaptation)

| Item | Source Path | Target | Notes |
|---|---|---|---|
| UES Version-Specific Behaviors | `2. LEARN/2.3. EFFECTIVE PLANNING/` | `_genesis/reference/` | 25-cell matrix, agent-readable |
| 38 deliverable templates | `0. REUSABLE RESOURCES/0.3. TEMPLATES/` | `_genesis/templates/` | Biggest gap — makes DSBV actionable |
| ALPEI SOP v3.0 | `1. ALIGN/1.3. OPERATIONAL WIKI/Wiki-6` | `_genesis/sops/` | Living process doc |
| Global AI Agent Rules | `1. ALIGN/1.3. OPERATIONAL WIKI/Wiki-8` | `_genesis/reference/` | Multi-agent governance |
| 10 Truths training version | `2. LEARN/2.0. EFFECTIVENESS/` | `_genesis/philosophy/` | Merge with archived version |
| ALPEI Framework Overview | `2. LEARN/2.4. EFFECTIVE EXECUTION/AGILE FRAMEWORK/` | `_genesis/reference/` | MD-native of our PDFs |
| Learning Hierarchy + CODE | `2. LEARN/2.1. EFFECTIVE LEARNING/` | `_genesis/training/` | Learning methodology |
| UBS/UDS Framework doc | `2. LEARN/2.5. EFFECTIVE RISK MANAGEMENT/` | `_genesis/frameworks/` | Merge with existing guide |

### ADAPT (needs rework for our structure)

| Item | Source Path | Target | Adaptation Needed |
|---|---|---|---|
| Training Deck (43 slides) | `2. LEARN/2.4. EFFECTIVE EXECUTION/AI/` | `_genesis/training/` | Remap /ues-* to our skills, strip Obsidian tooling |
| Critical Thinking & Biases | `2. LEARN/2.2. EFFECTIVE THINKING/` | `_genesis/training/` | Light adaptation |

### SKIP

- .base dashboard files (Obsidian-only)
- DAILY NOTES, PEOPLE, PLACES, THINGS folders (Obsidian vault conventions)
- Obsidian Tools Guide, IT System wiki (platform/org specific)

## Process Mapping Required (Standalone Session)

Each template must be mapped: **which DSBV phase produces it, in which ALPEI workstream, with what acceptance criteria?** This is a design task, not a copy task. Planned for Session N+1.

## Structural Insight: Human vs Agent Optimization

| Dimension | Vinh's Approach | Our Approach | Merge Opportunity |
|---|---|---|---|
| Navigation | Deep nested folders (human-intuitive) | Flat paths (agent-optimized) | Flat paths + READMEs + /dsbv status |
| Training | Embedded in vault (40+ slides) | Scoped OUT (gap) | Add to _genesis/training/ |
| Templates | 41 templates (full ALPEI matrix) | 3 templates (DSBV only) | Import + process map |
| Governance | 12 modular rule files | 8 rule files + hooks | Similar — merge best |
| Multi-agent | 5 platforms from day 1 | Claude-only | I3/I4 scope |
| Versioning | Centralized VERSION REGISTRY | Distributed frontmatter + hooks | Both (ours = engine, registry = dashboard) |

## Links

- [[DESIGN]]
- [[deliverable]]
- [[documentation]]
- [[dsbv]]
- [[friction]]
- [[methodology]]
- [[task]]
- [[versioning]]
- [[workstream]]
