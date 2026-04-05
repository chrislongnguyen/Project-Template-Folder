---
version: "1.0"
status: draft
last_updated: 2026-04-03
type: learning-output
work_stream: 2-LEARN
stage: build
title: "Naming Convention Visual Guide — Quick Reference"
topics: [naming-convention, ung, visual-guide, cheat-sheet]
---

# Naming Convention Visual Guide — Quick Reference

**Companion to:** `Naming_Convention_GAN_Synthesis.md`
**Date:** 2026-04-03

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                  LTC NAMING CONVENTION — VISUAL GUIDE                      ║
║                  GAN-Validated Principles (2026-04-03)                      ║
╚══════════════════════════════════════════════════════════════════════════════╝


 R1  NAMING BOUNDARY TABLE — Two Tiers, One Clear Line
 ─────────────────────────────────────────────────────────

   EXTERNAL (UNG)                         INTERNAL (kebab-case)
   ┌─────────────────────────┐            ┌─────────────────────────┐
   │ Git repos               │            │ .claude/skills/         │
   │ ClickUp projects        │            │ .claude/rules/          │
   │ Google Drive folders    │            │ .claude/agents/         │
   │ Client-facing assets    │            │ scripts/                │
   │                         │            │ frontmatter keys/values │
   │ OPS_OE.6.4.LTC-PROJECT │            │ ltc-planner             │
   │ ───┬──┬──┬─────────────│            │ naming-rules.md         │
   │  SCOPE FA ID    NAME   │            │ dsbv-gate.sh            │
   │   _    .  .      -     │            │ status: draft           │
   └─────────────────────────┘            └─────────────────────────┘
        Separators:                            Separators:
        _ = scope boundary                     - = word join (always)
        . = numeric level                      _ = YAML field names
        - = word join in NAME                  lowercase everything


 R2  FOLDER FORMAT — Why `1-ALIGN/` Wins
 ─────────────────────────────────────────

   ADOPT (System A)              REJECT (System B)
   ┌──────────────────┐          ┌──────────────────────────────┐
   │ 1-ALIGN/         │          │ 1. ALIGN/                    │
   │ 2-LEARN/         │          │ 1.1. ROLES/                  │
   │ 3-PLAN/          │          │ 1.5.1. PROBLEM DIAGNOSIS/    │
   │ 4-EXECUTE/       │          │                              │
   │ 5-IMPROVE/       │          │  Spaces → shell quoting      │
   └──────────────────┘          │  Dots  → find/grep collide   │
    cd 1-ALIGN/  ✓ just works    │  URLs  → %2E%20 encoding     │
    find . -name "1-*"  ✓        │  Windows PATH limit hit      │
    GitHub API  ✓                │  GitHub API rejects dots     │
    7 chars/level                │  20 chars/level              │
                                 └──────────────────────────────┘

   Scalability test:
   ┌──────────────────────────────────────────────────────────┐
   │  10 files    Both work fine                              │
   │  100 files   System B shell errors start appearing       │
   │  1000 files  System B URL sharing breaks, CI fails       │
   │  10K files   System B unmaintainable                     │
   └──────────────────────────────────────────────────────────┘


 R3  KEBAB-CASE — Universal System ID Format
 ─────────────────────────────────────────────

   WHERE                    FORMAT              EXAMPLE
   ──────────────────────   ──────────────────  ──────────────────────
   Skill folders            kebab-case          ltc-naming-rules/
   Agent files              kebab-case          ltc-planner.md
   Rule files               kebab-case          agent-dispatch.md
   Script files             kebab-case          dsbv-gate.sh
   Config keys              kebab-case          skill-dispatch
   ──────────────────────   ──────────────────  ──────────────────────
   Python code              snake_case          parse_frontmatter()
   JavaScript code          camelCase           parseFrontmatter()
   Class names              PascalCase          FrontmatterParser

   ┌──────────────────────────────────────────────────────────┐
   │  kebab = files, URLs, CLI, configs                       │
   │  native = code (language decides)                        │
   │  NEVER mix in the same layer                             │
   └──────────────────────────────────────────────────────────┘


 R4  LOWERCASE FRONTMATTER — Machine-Readable Data Layer
 ─────────────────────────────────────────────────────────

   BEFORE (mixed)                    AFTER (lowercase)
   ┌──────────────────────┐          ┌──────────────────────┐
   │ version: "1.0"       │          │ version: "1.0"       │
   │ status: Draft     ←──┼── BUG   │ status: draft        │
   │ work_stream: ALIGN   │          │ work_stream: align   │
   │ type: Charter         │          │ type: charter        │
   └──────────────────────┘          └──────────────────────┘

   WHY:
   ┌──────────────────────────────────────────────────────────┐
   │  Obsidian Bases filter:  status = "Draft"                │
   │  File has:               status: draft                   │
   │  Result:                 SILENT MISS  ← data loss        │
   │                                                          │
   │  Lowercase = one canonical form = zero query ambiguity   │
   └──────────────────────────────────────────────────────────┘


 R5  PREFIX REGISTRY — Bounded Namespacing for Skills
 ─────────────────────────────────────────────────────

   REGISTERED (max 5)          EXAMPLE SKILLS
   ┌──────────────────────┐    ┌──────────────────────────────┐
   │  ltc-    governance  │───>│ /ltc-naming-rules            │
   │  dsbv-   process     │───>│ /dsbv-gate, /dsbv-design     │
   │  vault-  obsidian    │───>│ /vault-daily, /vault-capture  │
   │  gws-    google ws   │───>│ /gws-sheets, /gws-drive      │
   │  (none)  utility     │───>│ /compress, /resume, /git-save │
   └──────────────────────┘    └──────────────────────────────┘

   DISCOVERY via autocomplete:
   ┌──────────────────────────────────────────────────────────┐
   │  /ltc-<TAB>   → all LTC governance skills               │
   │  /dsbv-<TAB>  → all DSBV process skills                 │
   │  /vault-<TAB> → all Obsidian vault skills                │
   │                                                          │
   │  New prefix? → requires explicit approval + registry add │
   │  Prevents: prefix explosion (Red team risk at 50+ skills)│
   └──────────────────────────────────────────────────────────┘


 R6  TEMPLATES — Folder Separation, Not Filename Prefix
 ───────────────────────────────────────────────────────

   ADOPT                                REJECT
   ┌─────────────────────────────┐      ┌─────────────────────────────────┐
   │ _genesis/templates/         │      │ TEMPLATES - UBS Analysis.md     │
   │   ├── ubs-analysis.md       │      │ TEMPLATES - Risk Register.md    │
   │   ├── risk-register.md      │      │                                 │
   │   ├── design-spec.md        │      │  Spaces in filename → quoting   │
   │   └── sprint-kickoff.md     │      │  grep noise (matches docs too)  │
   │                             │      │  URL encoding breaks            │
   │  Folder IS the classifier   │      │  Prefix IS fragile              │
   └─────────────────────────────┘      └─────────────────────────────────┘


 R7  VERSION — Numeric Primary, Semantic as Label
 ──────────────────────────────────────────────────

   ┌─────────────────────────────────────────────────────────────┐
   │                                                             │
   │  version: "1.3"              ← MACHINE (sortable, CI/CD)   │
   │  iteration_name: "concept"   ← HUMAN (governance stage)    │
   │                                                             │
   │  Both coexist. Neither replaces the other.                  │
   │                                                             │
   └─────────────────────────────────────────────────────────────┘

   Iteration map:
   ┌────────┬──────────────────┬────────────────────────────────┐
   │  I0    │  logic-scaffold  │  Design complete, no code      │
   │  I1    │  concept         │  Core tested, 1.x versions     │
   │  I2    │  prototype       │  Emerging efficiency, 2.x      │
   │  I3    │  mve             │  Full efficiency, 3.x          │
   │  I4    │  leadership      │  Scalability, 4.x              │
   └────────┴──────────────────┴────────────────────────────────┘

   Sort test:
     1.0 < 1.3 < 2.1 < 4.0     ✓ instant comparison
     concept < leadership < mve  ✗ alphabetical ≠ chronological


╔══════════════════════════════════════════════════════════════════════════════╗
║  CHEAT SHEET — "What format do I use?"                                     ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                            ║
║  Creating a...          Use this format         Example                    ║
║  ─────────────────────  ────────────────────    ────────────────────────── ║
║  Git repo name          UNG canonical key       OPS_OE.6.4.PROJECT-NAME   ║
║  ClickUp project        UNG canonical key       OPS_OE.6.4.PROJECT-NAME   ║
║  Drive folder           UNG canonical key       OPS_OE.6.4.PROJECT-NAME   ║
║  Workstream folder      {N}-{NAME} (CAPS)       1-ALIGN, 3-PLAN           ║
║  Skill folder           {prefix}-{name}         ltc-naming-rules          ║
║  Agent file             {prefix}-{role}.md      ltc-planner.md            ║
║  Rule file              {topic}.md              agent-dispatch.md         ║
║  Script file            {name}.sh               dsbv-gate.sh              ║
║  Template file          (in _genesis/templates)  design-spec.md           ║
║  Frontmatter values     lowercase kebab         status: draft             ║
║  Frontmatter keys       snake_case              work_stream, last_updated ║
║  Python identifier      snake_case              parse_frontmatter()       ║
║  JS identifier          camelCase               parseFrontmatter()        ║
║  Version number         MAJOR.MINOR             1.3                       ║
║  Version label          lowercase-kebab         concept, logic-scaffold   ║
║                                                                            ║
╚══════════════════════════════════════════════════════════════════════════════╝
```
