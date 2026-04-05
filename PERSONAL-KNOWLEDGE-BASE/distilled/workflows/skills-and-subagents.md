---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: workflows
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
---

# Skills, Subagents, and Plugins

Three extension mechanisms let you build reusable Claude behavior: skills encode repeatable workflows, subagents run isolated tasks in separate contexts, and plugins bundle multiple extensions into an installable unit. Together they turn one-off prompts into a persistent, composable system.

## L1 — Knowledge

### So What? (Relevance)

The default Claude Code interaction is ephemeral — each prompt is a fresh negotiation. Skills, subagents, and plugins convert institutional knowledge about how to do things into durable, invokable artifacts. This is the difference between "I know how to fix a GitHub issue" and `/fix-issue 1234`.

### What Is It?

**Skills** — Markdown files in `.claude/skills/<name>/SKILL.md`. They store instructions, conventions, or multi-step workflows. Invoked with `/skill-name`. Two modes:
- Standard: Claude reads the skill and uses it as context
- `disable-model-invocation: true`: triggers the workflow without autonomous LLM steps — for side-effecting operations you want to trigger deliberately

**Subagents** — Markdown files in `.claude/agents/<name>.md`. Each runs in its own isolated context window with its own tool allowlist and optionally a specific model. The main session delegates tasks; the subagent explores/reviews/acts and returns results.

**Plugins** — Bundles distributed via the marketplace (`/plugin`). A plugin can include skills, hooks, subagents, and MCP servers as a single installable unit. Code intelligence plugins add symbol navigation and automatic error detection for typed languages.

### What Else?

- Skills can encode project-specific conventions (API naming, commit format, coding standards) so Claude applies them consistently without re-prompting
- Subagents are the primary tool for keeping main context clean during investigation — they read many files without the file contents entering your window
- Subagents can also be invoked post-implementation for verification: "use a subagent to review this code for edge cases"
- Plugins are the fastest way to get up to speed with community-built integrations — no configuration beyond `/plugin install`
- The `disable-model-invocation: true` flag in skills prevents Claude from freely running steps — use it for workflows with filesystem or network side effects
- Choosing between skills, subagents, hooks, and MCP: use the decision guide at `/en/features-overview#match-features-to-your-goal`

### How Does It Work?

**Creating a skill:**
```markdown
# .claude/skills/fix-issue/SKILL.md
---
name: fix-issue
description: Fix a GitHub issue
disable-model-invocation: true
---
Analyze and fix the GitHub issue: $ARGUMENTS.

1. Use `gh issue view` to get the issue details
2. Understand the problem described in the issue
3. Search the codebase for relevant files
4. Implement the necessary changes
5. Write and run tests to verify the fix
6. Ensure code passes linting and type checking
7. Create a descriptive commit message
8. Push and create a PR
```
Invoked with: `/fix-issue 1234`

**Creating a subagent:**
```markdown
# .claude/agents/security-reviewer.md
---
name: security-reviewer
description: Reviews code for security vulnerabilities
tools: Read, Grep, Glob, Bash
model: opus
---
You are a senior security engineer. Review code for:
- Injection vulnerabilities (SQL, XSS, command injection)
- Authentication and authorization flaws
- Secrets or credentials in code
- Insecure data handling

Provide specific line references and suggested fixes.
```
Invoked with: "Use a subagent to review this code for security issues."

**Installing a plugin:**
```
/plugin
```
Browse marketplace, select, install. No configuration step.

## L2 — Understanding

### Why Does It Work?

Skills work because they externalize prompt engineering into version-controlled files. The knowledge of "how we fix issues in this repo" lives in the repo, not in someone's head or chat history. New team members inherit the workflow automatically.

Subagents work because context isolation is a hard boundary, not a soft suggestion. A subagent's file reads literally cannot appear in the main session's context window — they are separate API calls with separate histories. This makes context budget management predictable: investigation cost stays in the subagent, implementation budget stays in the main session.

The `disable-model-invocation: true` flag is a safety mechanism: it forces human intent at the invocation point rather than letting Claude autonomously chain steps that have irreversible side effects (pushing code, writing to databases, sending messages).

### Why Not?

- Skills add maintenance burden — stale skill files that reflect old conventions are worse than no skill files
- Subagents add API cost and latency for every delegation; for simple lookups, `@file` mention is cheaper
- Subagent results are summaries, not raw file contents — the subagent decides what to surface; important details can be omitted
- Plugin quality varies — community plugins may not follow security or scope hygiene; review before installing in sensitive repos
- `disable-model-invocation: true` skills require the user to supply the correct argument format manually — no LLM to infer intent from a loose description

## Sources

- `captured/claude-code-docs-full.md` lines 1335–1399 (skills, subagents, plugins sections)
- `captured/claude-code-docs-full.md` lines 1479–1492 ("Use subagents for investigation")

## Links

[[session-management]]
[[communicating-with-claude-code]]
[[automation-and-scaling]]
