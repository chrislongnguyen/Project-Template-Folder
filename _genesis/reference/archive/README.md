---
version: "2.0"
status: draft
last_updated: 2026-04-06
work_stream: 0-GOVERN
type: template
iteration: 2
---

# archive

> "What was the previous version of this reference?"

## Purpose

Superseded reference documents preserved for historical context.

Deleting superseded docs destroys the ability to answer "what did we previously believe and why did we change?" — a gap that causes teams to rediscover old decisions and repeat resolved debates. This directory enforces a hard boundary: documents here are read-only, never updated, and never linked to as authoritative sources.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| `ltc-10-ultimate-truths.md` | Previous version of the 10 ultimate truths (superseded by current framework) |
| `ltc-ai-centric-ueds.md` | Earlier AI-centric UES design spec (superseded) |
| `ltc-apei-discussion.md` | Original APEI framework discussion doc (superseded by ALPEI) |
| `ltc-human-centric-ueds.md` | Earlier human-centric UES design spec (superseded) |
| `ltc-effectiveness-guide-current.docx` | Legacy effectiveness guide in Word format (superseded by `.md` version) |

## How It Connects

```
_genesis/reference/ (active docs)
    │
    └──> _genesis/reference/archive/ (retired docs — read-only)
              │
              └──> Historical context only — never linked as authoritative source
```

## Pre-Flight Checklist

- [ ] Verify no active artifact links to a document in this archive as its authoritative source
- [ ] Confirm archived docs have a comment or frontmatter note stating what superseded them
- [ ] No orphaned or stale artifacts — archive only when a replacement exists in `reference/`

## Naming Convention

Archive files retain their original filename unchanged. Do not rename on archival — the filename is part of the historical record.
