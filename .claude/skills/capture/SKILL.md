---
name: capture
description: Capture conversation content, research notes, or ephemeral text to 1-captured/ staging area. Use when you want to save something quickly without deciding where it belongs yet.
version: "2.1"
status: draft
last_updated: "2026-04-13"
---
# /capture — Quick Capture to PKB

Dump content from the current conversation into the vault's staging area. Capture first, organise later. The `/vault-promote` command (Iteration 3 scope) handles moving captured notes to their final workstream location.

---

## Trigger

```
/capture "title"
/capture "title" --to learn
```

---

## Default Mode — 1-captured/

`/capture "title"` writes a new note to `PERSONAL-KNOWLEDGE-BASE/1-captured/` in the project root.

### Output path

```
PERSONAL-KNOWLEDGE-BASE/1-captured/{YYYY-MM-DD}_{slug}.md
```

Slug rules: lowercase title, spaces → hyphens, strip non-alphanumeric (except hyphens), max 50 chars.

Example: `/capture "API rate limit research"` → `PERSONAL-KNOWLEDGE-BASE/1-captured/2026-04-13_api-rate-limit-research.md`

### Frontmatter applied to captured file

```yaml
---
date: "YYYY-MM-DD"
type: capture
source: conversation
tags: []
---
```

### Steps

1. Compute today's date (YYYY-MM-DD).
2. Generate slug from title: lowercase → spaces to hyphens → strip non-alphanumeric except hyphens → truncate at 50 chars.
3. Check whether `PERSONAL-KNOWLEDGE-BASE/1-captured/` exists at the project root. If missing, create it using Bash: `mkdir -p {project_root}/PERSONAL-KNOWLEDGE-BASE/1-captured`.
4. Build the full file path: `{project_root}/PERSONAL-KNOWLEDGE-BASE/1-captured/{date}_{slug}.md`.
5. Write the file using the Write tool with the frontmatter block above plus `# {title}` as the H1, followed by the content to capture.
6. Confirm the path to the user.

**Do NOT use obsidian CLI commands.** Use the Write tool only.

---

## --to learn Flag — Research Destination

`/capture "title" --to learn` writes to `2-LEARN/research/` with full governance frontmatter.

### Output path

```
2-LEARN/research/{YYYY-MM-DD}_{slug}.md
```

### Frontmatter applied

```yaml
---
date: "YYYY-MM-DD"
type: research
source: conversation
tags: []
version: "2.0"
status: draft
last_updated: "YYYY-MM-DD"
---
```

`version` uses the current iteration convention (Iteration 2 = 2.x). New file → `2.0`.

### Steps

1. Compute today's date.
2. Generate slug (same rules as default mode).
3. Check whether `2-LEARN/research/` exists. If missing, create it: `mkdir -p {project_root}/2-LEARN/research`.
4. Build path: `{project_root}/2-LEARN/research/{date}_{slug}.md`.
5. Write the file with governance frontmatter + `# {title}` H1 + content.
6. Confirm path and remind user to update `_genesis/VERSION_REGISTRY.md` if this becomes a workstream artifact.

---

## Slug Generation Reference

| Input title | Slug |
|-------------|------|
| `API rate limit research` | `api-rate-limit-research` |
| `Q2 OKRs — draft` | `q2-okrs-draft` |
| `LTC: 2026 planning session` | `ltc-2026-planning-session` |
| `Very long title that exceeds the fifty character maximum limit here` | `very-long-title-that-exceeds-the-fifty-chara` |

---

## Error Handling

| Condition | Behavior |
|-----------|----------|
| `PERSONAL-KNOWLEDGE-BASE/1-captured/` does not exist | Create with `mkdir -p` before writing |
| `2-LEARN/research/` does not exist | Create with `mkdir -p` before writing |
| File at target path already exists | Append `_2`, `_3`, etc. to slug until unique |
| Title is empty string | Stop and ask user for a title |
| Content to capture is empty | Write the frontmatter + H1 only; note "(no content)" below H1 |

---

## Scope Boundary

| In scope | Out of scope |
|----------|-------------|
| Write to `PERSONAL-KNOWLEDGE-BASE/1-captured/` or `2-LEARN/research/` | Move or rename existing notes |
| Create `PERSONAL-KNOWLEDGE-BASE/1-captured/` or `2-LEARN/research/` if missing | Reorganize vault structure |
| Apply minimal frontmatter | Tag disambiguation or taxonomy decisions |
| Confirm output path | Promote to final workstream location (use `/vault-promote` — Iteration 3) |

---

## References

- Obsidian write-path whitelist (V5): `.claude/skills/obsidian/SKILL.md`
- Versioning convention: `.claude/rules/versioning.md`
- Version registry: `_genesis/VERSION_REGISTRY.md`

## Links

- [[CLAUDE]]
- [[iteration]]
- [[project]]
- [[versioning]]
- [[workstream]]
