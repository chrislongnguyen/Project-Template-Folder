---
version: "1.0"
status: Draft
last_updated: 2026-04-02
type: govern
work_stream: GOVERN
stage: design
sub_system: human-adoption
---

# DESIGN — N8 Human Adoption Training Package (Cycle 2)

## Intent

Produce 4 training artifacts that lower the barrier for humans to direct AI agents on the LTC
Project Template. Vinh's whiteboard confirms Scalable = ✗✗ for Plan + Execute — the gap is not
tooling, it is humans not knowing how to use the system. Every other feature is blocked if this
fails first (top UBS).

**RICE score:** 5.0 (R=3, I=5, C=1.0, E=3)
**Source:** `2-LEARN/output/obsidian-feature-analysis.html` v1.4 — N8 entry
**Cycle 1 prerequisite:** Session lifecycle refactor (N1-N4, N7) — DONE. Canonical workflow is
now `compress → /clear → /resume`. session-start/session-end deprecated.

---

## Scope

| Question | Answer |
|----------|--------|
| In scope | cmux quickstart, session lifecycle cheatsheet, tool routing cheatsheet, navigator HTML update |
| Out of scope | Obsidian onboarding (separate skill exists), ClickUp training, I2 V-series features, slide deck updates |

---

## UBS (What Blocks Success)

| UBS | Risk | Mitigation |
|-----|------|------------|
| Cheatsheets too verbose — nobody reads | Training material > 1 page = ignored | Each doc fits one screen. Use tables + code blocks, no prose paragraphs. |
| cmux guide assumes prior knowledge | Long isn't fluent yet — if guide is unclear, others won't be either | Write for "never used cmux before." Include exact install command + 3-command quickstart. |
| Navigator update breaks existing links | Modifying skill nodes could break graph connections | Only update `desc` and `name` fields. Do NOT change `id` or `connects` arrays. |
| Artifacts drift from each other | Session cheatsheet says X, navigator says Y | AC cross-checks: cheatsheet and navigator must agree on deprecated commands. |

---

## Artifact Inventory

### A1 — cmux Quickstart Guide

| Field | Value |
|-------|-------|
| Path | `_genesis/sops/cmux-quickstart.md` |
| Purpose | Long needs cmux fluency before team rollout. ArtemXTech: "I had 10 tabs — which one was doing what?" Named workspaces + orchestrator reads = multi-agent at scale. |
| Audience | Long (primary), team (secondary after Long validates) |

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-01 | File exists with 4-field Vinh frontmatter: `type`, `work_stream`, `stage`, `sub_system` | `grep -c "type:\|work_stream:\|stage:\|sub_system:" _genesis/sops/cmux-quickstart.md` ≥ 4 |
| AC-02 | Install command present (brew or equivalent for macOS) | `grep -i "brew\|install" _genesis/sops/cmux-quickstart.md` exits 0 |
| AC-03 | 3 core commands documented: create/new workspace, switch, list | `grep -c "create\|switch\|list" _genesis/sops/cmux-quickstart.md` ≥ 3 |
| AC-04 | Orchestrator pattern documented: read-screen + send-keys/send commands | `grep -i "read.screen\|send" _genesis/sops/cmux-quickstart.md` exits 0 |
| AC-05 | LTC workspace naming convention table present (workspace name → agent type) | `grep -i "workspace\|agent" _genesis/sops/cmux-quickstart.md \| wc -l` ≥ 3 |

### A2 — Session Lifecycle Cheatsheet

| Field | Value |
|-------|-------|
| Path | `_genesis/sops/session-lifecycle-cheatsheet.md` |
| Purpose | Codify the canonical workflow (compress→clear→resume) that replaced session-start/session-end. Team members currently don't know which skill to use. |
| Audience | All team members |

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-06 | File exists with frontmatter (version, status, last_updated) | `grep "version:" _genesis/sops/session-lifecycle-cheatsheet.md` exits 0 |
| AC-07 | Canonical workflow documented as ordered steps: /compress → /clear → /resume | `grep -i "compress\|clear\|resume" _genesis/sops/session-lifecycle-cheatsheet.md \| wc -l` ≥ 3 |
| AC-08 | Each command has: what it does + when to call it | `grep -c "##\|###" _genesis/sops/session-lifecycle-cheatsheet.md` ≥ 3 |
| AC-09 | Deprecated commands listed with replacement pointer | `grep -i "deprecated\|session-start\|session-end" _genesis/sops/session-lifecycle-cheatsheet.md` exits 0 |
| AC-10 | Token cost quantified: old cost vs new cost | `grep -i "token\|35K\|5K\|30K" _genesis/sops/session-lifecycle-cheatsheet.md` exits 0 |

### A3 — Tool Routing Cheatsheet

| Field | Value |
|-------|-------|
| Path | `_genesis/sops/tool-routing-cheatsheet.md` |
| Purpose | Humans directing agents need to know: when do I say "use QMD" vs "search obsidian" vs "grep"? The 3-tool hierarchy exists in tool-routing.md but is buried in a rule file. |
| Audience | All team members directing agents |

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-11 | File exists with frontmatter | `grep "version:" _genesis/sops/tool-routing-cheatsheet.md` exits 0 |
| AC-12 | 3-tool hierarchy table: QMD → Obsidian CLI → Grep/.claude | `grep -i "QMD\|obsidian\|grep" _genesis/sops/tool-routing-cheatsheet.md \| wc -l` ≥ 3 |
| AC-13 | Decision criteria present: when to use each tool (≥3 scenario rows) | `grep -c "|" _genesis/sops/tool-routing-cheatsheet.md` ≥ 5 |
| AC-14 | Mandatory .claude/ grep sweep called out explicitly | `grep -i "\.claude\|mandatory\|sweep" _genesis/sops/tool-routing-cheatsheet.md` exits 0 |
| AC-15 | Obsidian fallback (not running → use Grep) documented | `grep -i "fallback\|not running\|graceful" _genesis/sops/tool-routing-cheatsheet.md` exits 0 |

### A4 — Navigator HTML Update

| Field | Value |
|-------|-------|
| Path | `_genesis/tools/alpei-navigator.html` |
| Purpose | The navigator is the team's entry point to all skills. session-start and session-end currently appear as active — this creates confusion. compress and resume need updated descriptions matching Cycle 1 changes. |
| Constraint | Only update `name`, `desc` fields of existing skill nodes. Do NOT change `id` or `connects` — these are graph edges. |

| AC | Criterion | Binary Test |
|----|-----------|-------------|
| AC-16 | session-start `desc` or `name` contains "[DEPRECATED]" | `grep -i "deprecated" _genesis/tools/alpei-navigator.html \| grep "session-start"` exits 0 |
| AC-17 | session-end `desc` or `name` contains "[DEPRECATED]" | `grep -i "deprecated" _genesis/tools/alpei-navigator.html \| grep "session-end"` exits 0 |
| AC-18 | compress `desc` mentions rich frontmatter or Briefing Card | `grep "compress" _genesis/tools/alpei-navigator.html \| grep -i "frontmatter\|briefing\|rich"` exits 0 |
| AC-19 | resume `desc` mentions 2-pass or token cap | `grep "resume" _genesis/tools/alpei-navigator.html \| grep -i "2-pass\|5K\|token"` exits 0 |
| AC-20 | obsidian skill node added (if not present) or existing entry updated with current desc | `grep -i "obsidian" _genesis/tools/alpei-navigator.html` exits 0 |

---

## Alignment Check

| ACs | Artifact | Status |
|-----|----------|--------|
| AC-01 to AC-05 | A1 cmux quickstart | Covered |
| AC-06 to AC-10 | A2 session lifecycle cheatsheet | Covered |
| AC-11 to AC-15 | A3 tool routing cheatsheet | Covered |
| AC-16 to AC-20 | A4 navigator HTML update | Covered |

- Orphan conditions: 0
- Orphan artifacts: 0
- Total ACs: 20

---

## Readiness (C1-C6)

| ID | Condition | Status |
|----|-----------|--------|
| C1 | Scope: 4 artifacts, 20 ACs, in/out defined | GREEN |
| C2 | Inputs: feature analysis v1.4 N8 entry, tool-routing.md v1.3, navigator HTML at `_genesis/tools/alpei-navigator.html`, Cycle 1 session artifacts complete | GREEN |
| C3 | Success rubric: 20 binary ACs | GREEN |
| C4 | DSBV process loaded | GREEN |
| C5 | Context clean | GREEN |
| C6 | Single-agent sequential build (execution-heavy); ltc-reviewer at G4 | GREEN |

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Single-agent sequential (Execution-heavy — content production with clear specs) |
| Agent | ltc-builder (Sonnet) for Build; ltc-reviewer (Opus) for Validate |
| Build order | A1 → A2 → A3 → A4 (cheatsheets first, navigator last to reference them) |
| Human gates | G1 (this DESIGN.md), G2 (SEQUENCE.md), G3 (Build complete), G4 (Validate — user reviews) |

## Links

- [[SESSION_LIFECYCLE_DESIGN]]
- [[alpei-navigator]]
- [[compress]]
- [[obsidian-feature-analysis]]
- [[resume]]
- [[tool-routing]]
