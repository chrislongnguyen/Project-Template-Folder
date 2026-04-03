---
version: "1.0"
status: draft
last_updated: 2026-04-01
---
# VAULT_GUIDE — LTC Obsidian Vault

## Overview

This vault uses **Option C: flat folders + frontmatter tags**.

### What is Option C?

Option C is a flat folder structure where notes are NOT organized into ALPEI zone mirrors.
Instead of nesting files under `1-ALIGN/`, `2-LEARN/`, etc., all notes live in 5 top-level
purpose-driven folders. Context and classification are encoded in **YAML frontmatter tags**
(`zone:` and `subsystem:`), not in folder paths.

```
vault/
  daily/       ← daily logs (flat files by date)
  projects/    ← project-scoped notes
  agents/      ← agent session logs
  research/    ← research notes
  inbox/       ← staging area for new/unreviewed notes
  VAULT_GUIDE.md
```

Benefits over folder mirrors:
- Notes can belong to multiple zones without duplication
- Obsidian search + filters work across all notes without path-based navigation
- Agents write only to whitelisted paths — no risk of corrupting zone structure

---

## Frontmatter Tags

Every note should include:

```yaml
---
zone: align        # one of: align | learn | plan | execute | improve | govern
subsystem: ""      # optional: the subsystem this note relates to (e.g., obsidian-cli)
---
```

This enables Obsidian Dataview queries like:
```
TABLE file.name FROM "" WHERE zone = "plan"
```

---

## CLI Registration

The Obsidian CLI integration requires the Local REST API plugin.

### Steps

1. Open Obsidian → Settings → Community Plugins → Browse
2. Search "Local REST API" → Install → Enable
3. Copy the API key from the plugin settings
4. Set the environment variable:
   ```bash
   export OBSIDIAN_API_KEY="<your-key>"
   ```
5. Verify CLI is available:
   ```bash
   obsidian --version 2>/dev/null && echo "CLI ready" || echo "Obsidian not running"
   ```
6. Point the vault path to this directory (the parent of `VAULT_GUIDE.md`)

### Fallback Mode

If Obsidian is not running, the CLI degrades silently to Grep/Glob:

| Obsidian command | Fallback |
|-----------------|---------|
| `obsidian search:context query="X"` | `Grep` with pattern |
| `obsidian backlinks path="X"` | `Grep` for `[[path]]` references |
| `obsidian daily` | `Glob` for `daily/YYYY-MM-DD.md` |
| `obsidian tasks status="todo"` | `Grep` for `- [ ]` |

Fallback is automatic — no manual configuration required.

---

## Security Rules (summary)

Full rules: `.claude/rules/obsidian-security.md`

- **AP1:** `obsidian eval` and `obsidian dev:console` are permanently blocked (Oasis CVE Feb 2026)
- **AP2:** Vault is a mirror — git is the source of truth. Agent writes are append-only
- **AP3:** Agents write max 1 note per session. Multi-note changes stage to `inbox/` first
- **AP4:** Opt-out privacy — notes are accessible by default; add `cli-blocked: true` to block
- **AP5:** Check for sync lock before any write: `test -f .obsidian/sync.lock`
- **V5:** Agent writes only to: `inbox/`, `agents/`, `projects/{id}/`, `daily/` (append only)

---

## References

- Security rules: `.claude/rules/obsidian-security.md`
- CLI skill: `.claude/skills/obsidian/SKILL.md`
- Tool routing: `.claude/rules/tool-routing.md`

## Links

- [[AP1]]
- [[AP3]]
- [[AP4]]
- [[AP5]]
- [[CLAUDE]]
- [[SKILL]]
- [[obsidian-security]]
- [[security]]
- [[tool-routing]]