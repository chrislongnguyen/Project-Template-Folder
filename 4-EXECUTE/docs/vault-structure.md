---
version: "2.2"
status: draft
last_updated: 2026-04-03
type: ues-deliverable
sub_system: 1-PD
work_stream: 4-EXECUTE
stage: build
iteration: 2
ues_version: prototype
---

# Vault Folder Structure

## Overview

The LTC Project Template Obsidian vault is organized into five workstream zones, eight operational support folders, a reusable resources library, and two agent-managed staging areas. This document defines the complete folder hierarchy that PMs will set up on day 1 of onboarding.

**Total folders:** 17 (plus nested subdirectories)  
**Setup method:** `./scripts/setup-vault.sh` (idempotent)  
**Git tracking:** `.gitkeep` files in empty dirs to enable version control

---

## Folder Hierarchy

```
vault/
├── 1-ALIGN/                   ALPEI Workstream: Right Outcome
│   └── (PM-write-only)
│
├── 2-LEARN/                   ALPEI Workstream: Problem Research
│   └── (PM-write-only)
│
├── 3-PLAN/                    ALPEI Workstream: Minimize Risks
│   └── (PM-write-only)
│
├── 4-EXECUTE/                 ALPEI Workstream: Deliver
│   └── (PM-write-only; minimal — hands off to Cursor)
│
├── 5-IMPROVE/                 ALPEI Workstream: Learn & Grow
│   └── (PM-write-only)
│
├── DAILY-NOTES/               Daily standup prep (1 file per day per PM)
│   └── (PM-write-only)
│
├── MISC-TASKS/                Ad-hoc tasks, quick notes
│   └── (PM-write-only)
│
├── PEOPLE/                    Stakeholder + contact notes
│   └── (PM-write-only)
│
├── PLACES/                    Location + meeting context
│   └── (PM-write-only)
│
├── TEMP-IN/                   Inbox for incoming materials
│   └── (PM-write-only)
│
├── TEMP-OUT/                  Outbox for outgoing materials
│   └── (PM-write-only)
│
├── THINGS/                    Reference items, resources
│   └── (PM-write-only)
│
├── AI-AGENT-MEMORY/           Agent session logs (append-only)
│   ├── .gitkeep               (Git tracks this empty dir)
│   └── (Agent-write-only; PM reviews but does not edit)
│
├── inbox/                     Agent staging area
│   ├── .gitkeep               (Git tracks this empty dir)
│   └── (Agent-write-only; PM reviews and approves moves to canonical folders)
│
└── _genesis/obsidian/         Obsidian-specific resources (canonical shared folder)
    ├── templates/             Templater auto-fill templates (T1-T6)
    └── bases/                 14 Obsidian Bases dashboards
    │
    └── bases/                 All 14 Obsidian Bases dashboards
        └── .gitkeep           (Git tracks this empty dir)
```

---

## Folder Purposes

| Folder | Purpose | Write Access |
|--------|---------|--------------|
| **1-ALIGN** | Charter, decisions, OKRs, stakeholder info | PM only |
| **2-LEARN** | Research output, specs, learning pipeline | PM only |
| **3-PLAN** | Architecture, risks, drivers, roadmap | PM only |
| **4-EXECUTE** | Code, tests, config docs (most work happens in Cursor) | PM only |
| **5-IMPROVE** | Changelog, metrics, retros, reviews | PM only |
| **DAILY-NOTES** | Daily standup prep (yesterday / today / blockers) | PM only |
| **MISC-TASKS** | Ad-hoc tasks, quick reference notes | PM only |
| **PEOPLE** | Stakeholder bios, contact info, relationship notes | PM only |
| **PLACES** | Location notes, meeting venues, context | PM only |
| **TEMP-IN** | Incoming documents, external materials | PM only |
| **TEMP-OUT** | Outgoing materials, exports, shared docs | PM only |
| **THINGS** | Reference items, tools, resource pointers | PM only |
| **AI-AGENT-MEMORY** | Agent session logs, memories, context (append-only) | Agent only |
| **inbox** | Agent staging area for proposed artifacts | Agent only |
| **_genesis/obsidian/templates** | 6 Templater templates for artifact auto-fill | PM setup (agent reads) |
| **_genesis/obsidian/bases** | 14 Obsidian Bases dashboards | PM setup (agent reads) |

---

## Git Tracking Strategy

All folders are version-controlled via Git. Empty directories require a `.gitkeep` file so Git can track them (Git ignores empty dirs by default).

**Folders that MUST have `.gitkeep` files:**
- `inbox/` — Agent staging area
- `AI-AGENT-MEMORY/` — Agent session logs
- `_genesis/obsidian/templates/` — Templates library
- `_genesis/obsidian/bases/` — Bases library

**Other folders:** Created by `setup-vault.sh` with `mkdir -p` (no `.gitkeep` needed initially; they become non-empty when PMs add content)

---

## Workflow Integration

```
PM DAILY WORKFLOW
─────────────────────────────────────────────────────────────────
OBSIDIAN (PM cockpit)              CURSOR / CLAUDE CODE (build)
  1-ALIGN   → charter, decisions    4-EXECUTE → src, tests, config
  2-LEARN   → research, specs       (PM hands off task here)
  3-PLAN    → risks, drivers
  5-IMPROVE → retros, metrics
  ─────────────────────────────────
  DAILY-NOTES → standup prep
  MISC-TASKS  → ad-hoc work
  PEOPLE      → stakeholder notes
  inbox/      → agent staging area
─────────────────────────────────────────────────────────────────
Sync: Git-backed vault (not Obsidian Sync). Agent writes to inbox/ only.
```

---

## Acceptance Criteria

- **AC-4:** `setup-vault.sh` creates all 17 folders on a fresh checkout
- **AC-5:** `inbox/` and `AI-AGENT-MEMORY/` have `.gitkeep` files after script runs
- **AC-6:** Running script twice exits 0 both times (idempotent)

---

## Related Artifacts

- `4-EXECUTE/scripts/setup-vault.sh` — Idempotent folder creation script
- `4-EXECUTE/docs/frontmatter-schema.md` — YAML field definitions (A1)
- `4-EXECUTE/src/obsidian/bases/` — All 14 Bases dashboards (A3)
- `4-EXECUTE/src/obsidian/templates/` — 6 Templater templates (A4)
- `4-EXECUTE/scripts/setup-obsidian.sh` — One-command Obsidian install (A5)
