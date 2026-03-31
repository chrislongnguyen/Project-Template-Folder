# Approval Handling — Response Processing & Frontmatter Writing

> Referenced from SKILL.md Phase 2. Load when processing user approval response.

---

## Handle response

**"approve all" / "approved" / "approve":**
→ Write `status: approved` frontmatter to all pending pages.

**"revise P{m}: `<note>`" (one or more pages):**
→ Write `status: needs-revision` + `revision_note` to specified pages.
→ Write `status: approved` to all OTHER pending pages.

**"revise all: `<note>`":**
→ Write `status: needs-revision` + `revision_note` to all pending pages.

## Write frontmatter

For each page, prepend YAML frontmatter if not present, or update if present:

Approved:
```markdown
---
status: approved
reviewed_by: "{git config user.name}"
reviewed_at: {YYYY-MM-DD}
topic: T{n}
page: P{m}
---
```

Needs revision:
```markdown
---
status: needs-revision
revision_note: "{user's note}"
reviewed_at: {YYYY-MM-DD}
topic: T{n}
page: P{m}
---
```

If frontmatter already exists, update the `status:`, `reviewed_at:`, and `revision_note:` fields. Use the Edit tool for updates. Use the Edit tool with the first line for prepending new frontmatter.
