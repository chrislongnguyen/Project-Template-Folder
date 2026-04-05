---
status: unprocessed
tags: [governance, status-lifecycle, hooks, enforcement, dsbv-cycle]
priority: high
related: "[[versioning]]"
---

# Status Lifecycle Enforcement — Design Discussion

## The Gap

The status lifecycle (draft → in-progress → in-review → validated → archived) is documented in versioning.md and taught in training slides, but NOT enforced programmatically.

**Current rule (versioning.md):** "Agent sets Draft/Review. Human ONLY sets Approved."
**Reality:** Nothing stops an agent from writing `status: validated` in frontmatter.

## What Needs to Be Built

### 1. PreToolUse Hook (agent-side enforcement)
- When agent edits any `.md` file containing `status:` field
- Block if the new value is `validated` or `approved`
- Allow: `draft`, `in-progress`, `in-review`, `archived`

### 2. Pre-Commit Hook (git-side enforcement)  
- Scan staged `.md` files for `status: validated` changes
- Warn if the committer context suggests agent (not human)
- Could use git author or commit message pattern

### 3. PostToolUse Hook (auto-update)
- When any agent edits a workstream `.md` file:
  - Auto-update `last_updated:` to today's date
  - If status was `draft` and file is being meaningfully edited, auto-set `in-progress`

### 4. Dashboard Truthfulness
- If status is enforced, dashboards become trustworthy
- Approval-queue only shows genuinely reviewed items
- Blocker-dashboard risk levels reflect real state

## Questions to Resolve
- Should `in-review` be set by agent (requesting review) or human (acknowledging they're reviewing)?
- What happens if human manually edits a file — should a hook auto-set `in-progress`?
- Is `archived` agent-only or human-only?
- Should status changes be logged somewhere (audit trail)?

## Scope
This is a GOVERN workstream DSBV cycle. Not blocking the training deck — but training deck teaches a lifecycle that isn't enforced yet.
