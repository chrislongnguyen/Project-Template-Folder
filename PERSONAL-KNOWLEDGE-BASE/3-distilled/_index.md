---
version: "2.2"
status: draft
last_updated: 2026-04-09
---

# PKB Distilled Index

> Auto-maintained table of contents. Every page in `distilled/` must appear here.
> Updated by `/organise` after each run.

## Topics

### developer-tooling
- [[developer-appearance-guide]] — Canonical appearance settings for VSCode/Cursor, Claude Code CLI/tmux, Obsidian, macOS system — optimized for astigmatism (1.5+2.5D), multi-monitor (M3 Retina, Samsung M7 43", ViewFinity S8, Dell FHD), night work 8pm–midnight

### ai-security
- [[project-glasswing]] — Anthropic's cross-industry initiative using Claude Mythos Preview to find and fix zero-day vulnerabilities in critical infrastructure

### ai-models
- [[claude-mythos-preview]] — Anthropic's unreleased frontier model with breakthrough cybersecurity and coding capabilities; powers Project Glasswing

### multi-agent
- [[adk-multi-agent-patterns]] — Google ADK's 8 canonical multi-agent design patterns (Sequential, Coordinator, Parallel, Hierarchical, Generator/Critic, Iterative Refinement, HITL, Composite)

### memory-systems
- [[mempalace]] — Local AI memory system with ChromaDB vector storage, 98.4% R@5 recall, palace metaphor (Wings → Rooms → Halls → Drawers)
- [[ai-memory-systems-comparison]] — Synthesis comparing MemPalace vs LTC Vault: retrieval quality vs workflow integration depth
- [[ai-memory-data-pipeline-best-practices]] — Deep research (73 sources): 9-stage data pipeline, preprocessing as critical gap, test-driven optimization, S×E×Sc scoring

### agent-architecture
- [[claude-code-agent-loop]] — Claude Code's 4-layer agent model (Weights + Context + Harness + Infrastructure), async generator loop, tool concurrency, compaction hierarchy, 823-line retry system
- [[claude-managed-agents]] — Anthropic's hosted agent API: cloud containers, persistent sessions, tool execution managed by Anthropic (beta 2026-04-08)
- [[managed-agents-decoupled-architecture]] — Engineering architecture: brain/hands/session decomposition, harness outside container, TTFT 60% improvement at p50
- [[agent-architecture-principles]] — Synthesis: 4-component model + 6 design principles recurring across Claude Code, Managed Agents, ADK, and OMC
- [[oh-my-claudecode]] — Teams-first multi-agent orchestration layer for Claude Code: 29 agents, 32 skills, 20 hooks, keyword routing, persistent modes. 24K+ stars.
- [[hook-enforcement-patterns]] — The enforcement hierarchy: tool restriction > hook > state > instructions. "Hooks are mandatory. CLAUDE.md is advisory."
- [[harness-engineering-research-2026]] — Deep research (28 sources): harness engineering discipline, 8-component MECE sub-component map for Claude Code (66 buildable, 19 given, 16 measured), industry convergence on EP/EOE/EOT/EOP, roadmap for LTC-AGENT-HARNESS

## Pages (All)

| Page | Topic | Level | Last Updated | Source |
|------|-------|-------|-------------|--------|
| [[project-glasswing]] | ai-security | L3 | 2026-04-08 | Project Glasswing announcement |
| [[claude-mythos-preview]] | ai-models | L4 | 2026-04-08 | red.anthropic.com Mythos technical report |
| [[adk-multi-agent-patterns]] | multi-agent | L3 | 2026-04-08 | Google Developers Blog ADK guide |
| [[mempalace]] | memory-systems | L3 | 2026-04-08 | mempalace-vs-ltc-memory-vault-comparison |
| [[ai-memory-systems-comparison]] | memory-systems | L3 | 2026-04-08 | mempalace-vs-ltc-memory-vault-comparison |
| [[ai-memory-data-pipeline-best-practices]] | memory-systems | L3 | 2026-04-08 | Deep research: 73 sources, 6 angles |
| [[claude-code-agent-loop]] | agent-architecture | L4 | 2026-04-08 | How I built harness for my agent using Claude Code leaks |
| [[claude-managed-agents]] | agent-architecture | L3 | 2026-04-09 | 2026-04-09_claude-managed-agents-platform-docs-overview + launch blog |
| [[managed-agents-decoupled-architecture]] | agent-architecture | L4 | 2026-04-09 | 2026-04-09_scaling-managed-agents-decoupling-architecture |
| [[agent-architecture-principles]] | agent-architecture | L4 | 2026-04-09 | synthesis |
| [[oh-my-claudecode]] | agent-architecture | L3 | 2026-04-09 | 2026-04-09_oh-my-claudecode-agent-orchestration-patterns |
| [[hook-enforcement-patterns]] | agent-architecture | L4 | 2026-04-09 | 2026-04-09_oh-my-claudecode-agent-orchestration-patterns |
| [[harness-engineering-research-2026]] | agent-architecture | L4 | 2026-04-12 | deep-research: 28 sources, 3 angles, 8-component MECE map |
| [[developer-appearance-guide]] | developer-tooling | L4 | 2026-04-10 | Deep research: 59 sources, 4 angles, critic-reviewed |

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[How I built harness for my agent using Claude Code leaks]]
- [[adk-multi-agent-patterns]]
- [[ai-memory-data-pipeline-best-practices]]
- [[ai-memory-systems-comparison]]
- [[claude-code-agent-loop]]
- [[claude-mythos-preview]]
- [[mempalace]]
- [[project]]
- [[project-glasswing]]
- [[red.anthropic.com]]
