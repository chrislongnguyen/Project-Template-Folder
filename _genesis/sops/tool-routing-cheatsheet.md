---
version: "1.0"
status: draft
last_updated: 2026-04-02
type: sop
stage: build
sub_system: tool-routing
---

# Tool Routing Cheatsheet

Full spec: `rules/tool-routing.md` v1.3 — this doc distills it.

## 3-Tool Hierarchy (Knowledge Search)

| Priority | Tool | When |
|----------|------|------|
| 1 | QMD (`mcp__qmd__query`) | Semantic search — "what did we decide about X?" meaning-based retrieval across all vault docs |
| 2 | obsidian-cli | Graph traversal — backlinks, orphans, structural relationships between notes |
| 3 | Grep / `.claude/` sweep | Exact text match — rule files, skill files, known filenames |

Always run in priority order: QMD first, obsidian second, Grep third.

## Decision Table

| Task | Use |
|------|-----|
| Find a prior decision or research note | QMD |
| Find what files link to a concept | obsidian-cli |
| Find exact rule text or skill content | Grep |
| Agent is doing a general project knowledge search | QMD → obsidian-cli → Grep (in order) |
| Obsidian app is not running | Skip obsidian-cli, go directly to Grep |
| Search `.claude/rules/` or `.claude/skills/` | Grep (obsidian cannot index `.claude/`) |
| Confirm a term exists in a known file | Grep with explicit path |
| Find related concepts across the entire vault | QMD (vec or hyde query type) |

## MANDATORY: .claude/ Sweep

After ANY obsidian-cli search, ALSO grep `.claude/rules/` and `.claude/skills/`.

**Why:** Obsidian cannot index `.claude/` — approximately 30% of agent references live here. Skipping this sweep means incomplete results.

```bash
grep -r --include='*.md' "<key-term>" .claude/rules/ .claude/skills/
```

This sweep is NOT optional. If you tell an agent to "search for X", it must run this after obsidian-cli.

## Fallback Rule

If Obsidian is not running: skip obsidian-cli silently. Do not error. Proceed directly to Grep.

Do not ask the user to start Obsidian. Do not retry obsidian-cli. Just grep.

## Links

- [[CLAUDE]]
- [[SKILL]]
- [[project]]
- [[task]]
- [[tool-routing]]
