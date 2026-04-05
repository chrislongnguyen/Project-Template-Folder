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

# Rules System (.claude/rules/)

> The `.claude/rules/` directory splits CLAUDE.md into modular, topic-scoped files with optional path-specific loading — reducing context noise by loading rules only when relevant files are in scope.

## L1 — Knowledge

### So What? (Relevance)

A single CLAUDE.md growing past 200 lines has two problems: it consumes context and adherence degrades. Rules files solve both by modularizing instructions and enabling lazy loading — TypeScript-specific rules only load when Claude reads `.ts` files. LTC's `.claude/rules/` structure (`enforcement-layers.md`, `versioning.md`, `agent-dispatch.md`, etc.) uses this system.

### What Is It?

A directory-based extension of CLAUDE.md. Markdown files in `.claude/rules/` are discovered recursively and loaded alongside the main CLAUDE.md. Files can optionally include YAML frontmatter with `paths:` to scope their activation.

### What Else?

**Directory structure:**
```
your-project/
├── .claude/
│   ├── CLAUDE.md           # Main project instructions
│   └── rules/
│       ├── code-style.md   # No paths: = always loaded
│       ├── testing.md      # Always loaded
│       ├── security.md     # Always loaded
│       └── api/
│           └── ts-api.md   # Can have path-specific frontmatter
```

**Path-specific rules (YAML frontmatter):**
```markdown
---
paths:
  - "src/api/**/*.ts"
  - "src/**/*.{ts,tsx}"
  - "lib/**/*.ts"
---

# API Development Rules
- All API endpoints must include input validation
```

**Glob pattern examples:**
| Pattern | Matches |
|---------|---------|
| `**/*.ts` | All TypeScript files |
| `src/**/*` | All files under `src/` |
| `*.md` | Markdown in project root |
| `src/components/*.tsx` | React components in specific dir |

**Symlink support:** `.claude/rules/` supports symlinks — maintain shared rules and link them into multiple projects. Circular symlinks detected and handled.

**User-level rules:** `~/.claude/rules/` applies to every project on your machine. Loaded before project rules (project rules take higher priority).

### How Does It Work?

**Without `paths:` frontmatter:**
- Loaded at session launch with same priority as `.claude/CLAUDE.md`
- Always present in context

**With `paths:` frontmatter:**
- Not loaded at launch
- Triggers when Claude reads a file matching the glob pattern
- `InstructionsLoaded` hook fires with `load_reason: "path_glob_match"` for observability

**vs. skills:**
Rules load into context every session (or when matching files open). For task-specific instructions that don't need constant context presence, use skills — they only load on invocation.

**Priority:** More specific locations > broader ones. Project rules > user-level rules.

## L2 — Understanding

### Why Does It Work?

Path-specific rules use the same lazy-loading trigger as subdirectory CLAUDE.md files: Claude reading a file. When Claude opens `src/api/users.ts`, Claude Code checks if any `paths:` rules match — if yes, inject those rules into context then. The rule is now available without having consumed context tokens for the whole session.

### Why Not?

- Path-specific rules trigger on file reads, not on every tool use — if Claude edits a file without reading it first, the rule may not be loaded
- Rules without `paths:` always consume context even if irrelevant to the current task
- Symlinks are transparent — if the linked directory moves, rules silently break
- No built-in conflict detection across multiple rules files — still possible to have contradictions

## L3 — Wisdom

### So What? (Benefit)

The rules system lets you maintain a large rule corpus without paying the full context cost upfront. It's the answer to "I have 50 rules but only 10 are relevant to any given task." Path-specific rules are particularly powerful for monorepos with distinct subsystems (frontend rules only load for `.tsx` files, backend rules for `.go` files).

### Now What? (Next)

- Audit existing CLAUDE.md: extract topic clusters into separate rules files
- Add `paths:` frontmatter to any rules that are file-type or directory specific
- Use `InstructionsLoaded` hook to confirm path-specific rules are triggering as expected
- Link `~/.claude/rules/` shared company standards across personal projects via symlink

## Sources

- captured/claude-code-docs-full.md (lines 18441-18525)

## Links

- [[claude-md-files]]
- [[auto-memory]]
- [[hooks-lifecycle]]
