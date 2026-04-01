---

## version: "1.1"
last_updated: 2026-03-30



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

## Rules

1. **Stay within your tool list.** An agent MUST NOT call tools not listed in its agent file.
2. **Primary before fallback.** Use fallback only when primary is unavailable or returns no useful result.
3. **No Bash for search.** Use Glob / Grep instead of `find` / `grep` shell commands.
4. **Exa and WebSearch are peers.** Exa is faster (48% fewer tool calls); WebSearch finds higher-quality sources (academic papers, official docs). Choose based on task: Exa for speed, WebSearch for source authority.
5. **No Exa for local content.** QMD or Grep covers the project knowledge base; reserve Exa for external sources.
6. **Minimum viable scope.** Load the smallest file set that answers the question (EP-04 context discipline).

