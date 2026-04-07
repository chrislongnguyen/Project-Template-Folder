---
version: "2.1"
status: Draft
last_updated: 2026-04-05
---
# Knowledge Index

> LLM-maintained catalog. Updated by `/ingest` after every ingest pass.
> Navigate this file before answering any PKB query.

## Pages

### agents/ (14 pages)
- [[agent-reliability-compounding-error]] — Compounding error math in multi-step chains + graph-constrained reasoning pattern (L3)
- [[agent-teams-overview]] — Multi-session orchestration for parallel work (L3)
- [[agent-teams-architecture-coordination]] — How teams coordinate via task system (L2)
- [[agent-teams-display-modes]] — Split, tabs, and focus display modes (L2)
- [[agent-teams-best-practices]] — Quality gates, hooks, and team patterns (L2)
- [[custom-subagents-overview]] — Creating and configuring custom subagent types (L3)
- [[subagent-frontmatter-fields]] — YAML frontmatter reference for agent files (L3)
- [[subagent-model-selection]] — Choosing models for subagents (L2)
- [[subagent-tool-restrictions]] — Controlling which tools subagents can use (L2)
- [[subagent-mcp-scoping]] — Scoping MCP servers to specific subagents (L2)
- [[subagent-permission-modes]] — Permission modes for subagent execution (L2)
- [[subagent-skills-preloading]] — Preloading skills into subagent context (L2)
- [[subagent-persistent-memory]] — Enabling memory across subagent sessions (L3)
- [[subagent-hooks]] — Conditional rules and hooks in subagents (L2)

### best-practices/ (3 pages)
- [[communicating-with-claude-code]] — Effective prompting, context, and interviewing (L3)
- [[session-management]] — Context management, checkpoints, course-correction (L3)
- [[token-efficiency-patterns]] — Deliberate vs wasteful token spend patterns, P1-P6 prescriptions (L4)

### configuration/ (4 pages)
- [[claude-md-files]] — Writing and organizing CLAUDE.md instructions (L3)
- [[rules-system]] — Path-scoped rules in .claude/rules/ (L3)
- [[auto-memory]] — Persistent memory across sessions (L3)
- [[persistence-and-enforcement-synthesis]] — Cross-cutting patterns across config mechanisms (L4, synthesis)

### hooks/ (4 pages)
- [[hooks-lifecycle]] — Hook events, lifecycle, and execution model (L3)
- [[hook-matchers]] — Pattern matching for tool and event hooks (L2)
- [[hook-input-output]] — JSON I/O, exit codes, and decision control (L3)
- [[hooks-in-skills-agents]] — Scoping hooks to skills and agent files (L2)

### developer-tooling/ (1 page)
- [[dotfiles-repo]] — Git-tracking personal config files via symlinks — setup, .gitignore, secrets risk (L3)

### knowledge-systems/ (1 page)
- [[karpathy-llm-wiki-pattern]] — LLM-owned wiki pattern for personal knowledge management (L4)

### mcp/ (5 pages)
- [[mcp-server-config]] — Configuring MCP servers in Claude Code (L3)
- [[mcp-tool-search]] — Deferred tool loading and search for large MCP servers (L2)
- [[mcp-authentication]] — OAuth and credential flows for MCP servers (L2)
- [[mcp-elicitation]] — Responding to MCP elicitation requests (L2)
- [[managed-mcp]] — Enterprise-managed MCP server policies (L2)

### permissions/ (8 pages)
- [[permission-modes]] — The 6 permission modes and when to use each (L3)
- [[permission-rules]] — Allow/ask/deny rules syntax and precedence (L2)
- [[auto-mode-classifier]] — How auto mode decides tool approvals (L2)
- [[managed-settings]] — Enterprise managed settings and precedence stack (L2)
- [[protected-paths]] — Protected directories and files by mode (L2)
- [[authentication]] — Login flows, team auth, credential management (L2)
- [[claude-code-sandboxing]] — Sandbox providers, Seatbelt, Docker isolation (L3)

### platform/ (13 pages)
- [[claude-code-extensibility-taxonomy]] — Feature taxonomy: skills vs hooks vs rules vs MCP vs plugins (L3)
- [[claude-code-context-costs]] — Context cost by feature and loading behavior (L2)
- [[claude-code-prompt-caching]] — 1-hr vs 5-min TTL tiers, 1300:1 hit ratio, keepalive strategies (L3)
- [[claude-code-fullscreen-rendering]] — Terminal fullscreen mode with mouse support (L2)
- [[claude-code-dot-claude-directory]] — .claude/ directory structure and file reference (L3)
- [[claude-code-cli-reference]] — CLI commands and flags reference (L3)
- [[claude-code-channels]] — Push events into running sessions (L3)
- [[claude-code-channels-reference]] — Webhook receiver implementation reference (L4)
- [[computer-use]] — Computer use from CLI — screen control and automation (L3)
- [[claude-code-remote-control]] — Remote session access from other devices (L2)
- [[claude-code-devcontainer]] — Development containers for isolated environments (L2)
- [[claude-code-chrome-extension]] — Browser automation via Chrome integration (L2)
- [[claude-code-on-the-web]] — Claude Code web interface and capabilities (L2)

### plugins/ (6 pages)
- [[overview]] — Plugin architecture and when to use plugins (L3)
- [[quickstart]] — Creating your first plugin (L2)
- [[developing-plugins]] — Skills, LSP servers, and complex plugin patterns (L2)
- [[manifest-reference]] — Plugin manifest.json schema (L2)
- [[cli-reference]] — Plugin CLI commands and debugging (L2)
- [[distribution]] — Sharing and marketplace submission (L2)

### workflows/ (5 pages)
- [[automation-and-scaling]] — Non-interactive mode, fan-out, multiple sessions (L2)
- [[skills-and-subagents]] — Skills and subagent workflow patterns (L2)
- [[claude-code-code-review]] — Automated code review with severity levels (L2)
- [[claude-code-scheduled-tasks]] — Cron scheduling and task management (L2)
- [[unix-utility-and-notifications]] — Pipe I/O, output formats, notifications (L2)

## Topics

- **agents/** — Subagent architecture, team coordination, agent configuration, reliability patterns (14 pages)
- **best-practices/** — Communication patterns, session hygiene, token efficiency (3 pages)
- **configuration/** — CLAUDE.md, rules, auto memory, enforcement patterns (4 pages)
- **developer-tooling/** — Machine config versioning, dotfiles, symlink patterns (1 page)
- **hooks/** — Hook lifecycle, matchers, I/O, skill/agent scoping (4 pages)
- **knowledge-systems/** — PKM architectures, retrieval patterns (1 page)
- **mcp/** — MCP server config, tool search, auth, managed policies (5 pages)
- **permissions/** — Permission modes, rules, sandboxing, authentication (8 pages)
- **platform/** — CLI, extensibility, channels, computer use, Chrome, web, prompt caching (13 pages)
- **plugins/** — Plugin creation, distribution, marketplace (6 pages)
- **workflows/** — Automation, code review, scheduling, unix utility (5 pages)

**Total: 62 pages across 11 topics**
