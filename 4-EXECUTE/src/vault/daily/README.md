---
version: "1.0"
status: Draft
last_updated: 2026-04-01
zone: execute
subsystem: ""
---
# daily/

Daily log notes. One file per day, named `YYYY-MM-DD.md`.

Agent writes use `obsidian daily:append` — append-only, never overwrite.
Human creates each daily note manually or via Obsidian template.

Files in this folder are accessible via CLI by default (AP4 opt-out model).
To block a note: add `cli-blocked: true` to its frontmatter.

## Links

- [[AP4]]
