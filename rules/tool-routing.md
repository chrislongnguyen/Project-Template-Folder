---
version: "1.3"
status: draft
last_updated: 2026-04-01
---

# Tool Routing Rule

> When in doubt: cheapest tool that answers the question. Never use a heavy tool (Bash, WebFetch, Exa) when a light tool (Glob, Grep, Read) covers the task.

---

## Routing Table


| Task Type                           | Primary Tool             | Fallback             | Cost Tier                        | Agent(s)                                             |
| ----------------------------------- | ------------------------ | -------------------- | -------------------------------- | ---------------------------------------------------- |
| File discovery (pattern match)      | Glob                     | Bash(find)           | low                              | ltc-builder, ltc-reviewer, ltc-explorer              |
| Content search (regex / keyword)    | Grep                     | Read (scan)          | low                              | ltc-builder, ltc-reviewer, ltc-explorer              |
| Read a known file                   | Read                     | —                    | low                              | ltc-builder, ltc-reviewer, ltc-planner, ltc-explorer |
| Write a new file                    | Write                    | —                    | low                              | ltc-builder                                          |
| Edit an existing file               | Edit                     | Write (full rewrite) | low                              | ltc-builder                                          |
| Script execution / shell ops        | Bash                     | —                    | medium                           | ltc-builder, ltc-reviewer                            |
| Compliance / validation check       | Bash (script)            | Read + manual check  | medium                           | ltc-builder, ltc-reviewer                            |
| External web research               | mcp__exa__web_search_exa | WebFetch             | high — H2: −2% tokens vs WebSearch, 48% faster, 50% fewer tool calls | ltc-explorer, ltc-planner                            |
| Project knowledge search (semantic) | mcp__qmd__query          | Grep                 | medium — local semantic search, no external API | ltc-explorer, ltc-planner                            |
| Vault graph traversal (backlinks, orphans, daily notes) | obsidian-cli | Grep (fallback when app not running) | medium — requires desktop app running; degrades silently | ltc-explorer, ltc-planner                |
| External page crawl / retrieval     | WebFetch                 | Read (cached)        | medium                           | ltc-planner                                          |


---

## Cost Tiers


| Tier                     | Meaning                                                      |
| ------------------------ | ------------------------------------------------------------ |
| low                      | Local tool, zero API calls, negligible token overhead        |
| medium                   | Shell process or MCP call with bounded output                |
| high                     | External API call; token cost depends on response size       |


---

## Agent Tool Inventory


| Agent        | Model  | Allowed Tools                                                   | Phase             |
| ------------ | ------ | --------------------------------------------------------------- | ----------------- |
| ltc-builder  | Sonnet | Read, Edit, Write, Bash, Grep                                   | Build             |
| ltc-reviewer | Opus   | Read, Glob, Grep, Bash                                          | Validate          |
| ltc-planner  | Opus   | Read, Grep, WebFetch, mcp__exa__web_search_exa, mcp__qmd__query | Design + Sequence |
| ltc-explorer | Haiku  | Read, Glob, Grep, mcp__exa__web_search_exa, mcp__qmd__query     | Pre-DSBV research |


---

## 3-Tool Routing Hierarchy (Knowledge Search)

When searching project knowledge, apply this hierarchy in order. Escalate only when the lower tier cannot answer.

| Priority | Tool | When to Use |
|----------|------|-------------|
| 1 | QMD (`mcp__qmd__query`) | Semantic search across sessions, decisions, daily notes — meaning-based retrieval |
| 2 | obsidian-cli | Graph traversal: backlinks, outgoing-links, orphans — structural relationships between notes |
| 3 | Grep / `.claude/` sweep | Exact-match text search + mandatory sweep of agent rules and skills |

**Mandatory `.claude/` sweep (after every obsidian search):** After ANY obsidian-cli search, agents MUST grep `.claude/rules/` and `.claude/skills/` for content relevant to the query. This is NOT a fallback — it is a required supplement. Obsidian cannot index `.claude/`, which contains ~30% of agent-relevant references.

```bash
grep -r --include='*.md' --include='*.sh' --include='*.py' --include='*.html' "<key-term>" .claude/rules/ .claude/skills/
```

Log grep results alongside vault results before drawing conclusions. If `.claude/` content conflicts with vault content, `.claude/` takes precedence.

**Worktree constraint:** During Build phase (working in a git worktree), do NOT use obsidian-cli — it targets the main vault, not the worktree. Use Grep/Read instead. obsidian-cli is safe during Validate phase (after merge to main).

---

## Rules

1. **Stay within your tool list.** An agent MUST NOT call tools not listed in its agent file.
2. **Primary before fallback.** Use fallback only when primary is unavailable or returns no useful result.
3. **No Bash for search.** Use Glob / Grep instead of `find` / `grep` shell commands.
4. **Exa and WebSearch are peers.** Exa is faster (48% fewer tool calls); WebSearch finds higher-quality sources (academic papers, official docs). Choose based on task: Exa for speed, WebSearch for source authority.
5. **No Exa for local content.** QMD or Grep covers the project knowledge base; reserve Exa for external sources.
6. **Minimum viable scope.** Load the smallest file set that answers the question (EP-04 context discipline).
7. **obsidian-cli requires app check.** Before any obsidian-cli command, verify `obsidian --version 2>/dev/null` exits 0. If not running, fall back to Grep/Glob silently — do not error.
8. **`.claude/` sweep is mandatory.** After every obsidian-cli search, grep `.claude/rules/` and `.claude/skills/` — not optional, not a fallback. See 3-Tool Routing Hierarchy above.

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[EP-04]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[project]]
- [[task]]
