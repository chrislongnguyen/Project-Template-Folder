---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: configuration
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
  - so_what_benefit
  - now_what_next
---

# CLAUDE.md Files

> CLAUDE.md files inject persistent instructions into every session's context window — the primary mechanism for making Claude reliably follow project conventions without repeating them in every prompt.

## L1 — Knowledge

### So What? (Relevance)

Instructions given only in conversation are lost after `/compact` or session end. CLAUDE.md survives both. It is the "always-on rule" surface for anything that must persist: naming conventions, build commands, architectural decisions, workflow rules. LTC's entire CLAUDE.md system is built on this mechanism.

### What Is It?

Markdown files read by Claude Code at session start (and on demand for subdirectory files). They are injected as context — not enforced configuration. Claude reads them and tries to follow them; compliance is probabilistic, not guaranteed.

### What Else?

**Four scopes:**
| Scope | Location | Shared with |
|-------|----------|-------------|
| Managed policy | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) | All org users |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team via VCS |
| User | `~/.claude/CLAUDE.md` | You, all projects |
| Local | `./CLAUDE.local.md` | You only, current project |

**Import syntax:** `@path/to/file` — expands file inline at session start. Relative paths resolve to the file's location. Max 5 import hops. External imports show approval dialog first time.

**AGENTS.md bridge:**
```markdown
@AGENTS.md

## Claude Code
Use plan mode for changes under `src/billing/`.
```

**`claudeMdExcludes` setting:** Skip specific files in monorepos — glob patterns against absolute paths, configured at any settings layer, arrays merge.

**HTML comments** `<!-- -->` stripped before injection — free documentation space for maintainers, zero context cost.

### How Does It Work?

**Load order:**
1. Walk up directory tree from CWD, load `CLAUDE.md` + `CLAUDE.local.md` at each level
2. Load `.claude/CLAUDE.md` and `.claude/rules/*.md` from project
3. Subdirectory `CLAUDE.md` files load on demand when Claude reads files in those directories
4. All files concatenated into context (not overriding each other)
5. At same level: `CLAUDE.local.md` appended after `CLAUDE.md` (personal notes win on conflicts)

**Size limits:** Target under 200 lines per file. Longer = more context consumed + lower adherence. 200 lines or 25KB limit applies to auto memory's MEMORY.md, not CLAUDE.md (CLAUDE.md loads in full).

**Writing effective instructions:**
- "Use 2-space indentation" not "format code properly"
- "Run `npm test` before committing" not "test your changes"
- "API handlers live in `src/api/handlers/`" not "keep files organized"

**Compact survival:** CLAUDE.md fully survives `/compact` — Claude re-reads from disk and re-injects fresh.

## L2 — Understanding

### Why Does It Work?

CLAUDE.md content is delivered as a user message after the system prompt, not as system prompt itself. This means it benefits from full context visibility but does not have the "system prompt as hard constraint" property. The model reads it as strong guidance. Specificity directly maps to compliance — verifiable instructions ("2-space indentation") are easier to follow than subjective ones ("format code properly") because the model can self-check.

### Why Not?

- Instructions are context, not enforcement — Claude can still deviate, especially on vague or conflicting instructions
- Conflicting instructions across multiple CLAUDE.md files → Claude picks one arbitrarily
- Large CLAUDE.md files consume significant context tokens and reduce adherence (ironic: more rules = less followed)
- Managed policy CLAUDE.md cannot be excluded — organizational instructions always load regardless of individual settings
- External imports `@` require approval dialog first time — can be declined, disabling imports permanently for that project

## L3 — Wisdom

### So What? (Benefit)

CLAUDE.md is the stable, persistent layer of the human-Claude contract. Conversation is ephemeral; CLAUDE.md is durable. Rules that matter go in CLAUDE.md. Rules that change per task go in conversation. Rules that must be enforced mechanically go in hooks.

### Now What? (Next)

- Run `/init` to generate a starter CLAUDE.md from codebase analysis
- Use `@path` imports to keep CLAUDE.md under 200 lines while maintaining full rule coverage
- Split large rule sets into `.claude/rules/` with path-specific frontmatter
- Use `InstructionsLoaded` hook to audit what's actually loading
- Add `claudeMdExcludes` in local settings to filter irrelevant upstream rules in monorepos

## Sources

- captured/claude-code-docs-full.md (lines 18298-18689)

## Links

- [[rules-system]]
- [[auto-memory]]
- [[hooks-lifecycle]]
- [[hooks-in-skills-agents]]
