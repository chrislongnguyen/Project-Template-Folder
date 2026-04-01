---
version: "1.2"
last_updated: 2026-03-30
owner: "Long Nguyen"
name: learn-spec
description: >
  Use when all 6 T0 Effective Learning pages are approved and ready for
  extraction. Reads P0-P5 pages and produces two outputs: a VANA-SPEC
  (handoff to the Build pipeline) and a DSBV Readiness Package (C1-C6
  checklist confirming DSBV Design can start). Replaces /spec:extract.
argument-hint: <system-slug>
context: fork
model: opus
allowed-tools: Read, Glob, Write, Bash
---
# /learn:spec — VANA-SPEC + DSBV Readiness Generator

Reads 6 approved T0 Effective Learning pages and produces two output files
for `2-LEARN/specs/{system-slug}/`:

1. `vana-spec.md` — VANA-SPEC handoff to Build pipeline
2. `DSBV-READY-{slug}.md` — C1-C6 Readiness Package for DSBV Design gate

VANA extraction rules and template structure live in
[references/vana-extraction-rules.md](references/vana-extraction-rules.md).

## Arguments

Parse `{system-slug}` from the invocation (e.g., `/learn:spec data-foundation`).
If missing, check for a single `2-LEARN/input/learn-input-*.md`. Use it if exactly one exists.

<HARD-GATE>
1. All 6 T0 pages must have `status: approved` frontmatter — halt if any is missing.
2. Do NOT invent content — all ACs derive from page files and learn-input. No hallucination.
3. Every `{placeholder}` in the template must be replaced. Use `[NEEDS REVIEW]` only if source genuinely lacks content.
4. Do NOT modify the template structure — section numbering and hierarchy are sacred.
</HARD-GATE>

---

## Injected Context

### Learn Input Metadata
!`cat 2-LEARN/input/learn-input-*.md 2>/dev/null`

### VANA-SPEC Template
!`cat 2-LEARN/templates/vana-spec-template.md 2>/dev/null`

---

## Pre-Checks

1. Verify `2-LEARN/output/{system-slug}/T0.P0-overview-and-summary.md` exists. If not, error: "Run /learn:structure first."
2. Collect all 6 T0 page files and check `status:` frontmatter:
   - If any page is not `status: approved`, error: "Page T0.P{m} is not approved. Run /learn:review first."
3. Read `2-LEARN/templates/vana-spec-template.md`. If missing, error: "vana-spec-template.md not found."
4. Run: `mkdir -p 2-LEARN/specs/{system-slug}`

---

## Extraction Procedure

See [references/vana-extraction-rules.md](references/vana-extraction-rules.md) for full per-step rules.

| Step | Source | Output | AC ID Pattern |
|------|--------|--------|---------------|
| 1 | learn-input + T0.P0 | §1 System Identity | — |
| 2 | T0.P5 STEP.n(R) rows | §2 Verb ACs | Verb-AC{n} |
| 3 | T0.P3 enabling principles | §3 Adverb ACs | {Pillar}Adv-AC{n} |
| 4 | T0.P4 components | §4 Noun ACs | Noun-AC{n} |
| 5 | T0.P3 × T0.P4 cross-ref | §5 Adjective ACs | {Pillar}Adj-AC{n} |
| 6 | §2–§5 ACs | §6 AC-TEST-MAP | — |
| 7 | T0.P1 UBS rows | §7 Failure Modes × 4 iterations | — |
| 8 | T0.P0 + T0.P5 | §8 Agent Boundaries | — |
| 9 | All §2–§5 ACs | §9 Master Scope + Iteration Plan | — |
| 10 | learn-input §3–§4 | §10 Integration Contracts | — |

Also extracts: SPAWNED ACs (I4, from P5 NEXT cells) and Hardening ACs (I4, from P0 RACI(I)).

---

## Output 1: VANA-SPEC

Write fully populated VANA-SPEC to `2-LEARN/specs/{system-slug}/vana-spec.md`.
Preserve all HTML comment derivation hints. Replace all `{placeholder}` values.

---

## Output 2: DSBV Readiness Package

Write `2-LEARN/specs/{system-slug}/DSBV-READY-{slug}.md` with this structure:

```
# DSBV Readiness Package — {system_name}
Generated: {date} | Skill: /learn:spec

## C1-C6 Checklist

| # | Condition | Status | Evidence |
|---|-----------|--------|----------|
| C1 | Clear scope | GREEN | VANA-SPEC §1 defines system boundary |
| C2 | Input materials curated | GREEN | P0-P5 pages in 2-LEARN/output/{slug}/ |
| C3 | Success rubric defined | GREEN | VANA-SPEC §6 AC-TEST-MAP ({N} ACs) |
| C4 | Process definition loaded | GREEN | _genesis/templates/DSBV_PROCESS.md exists |
| C5 | Prompt engineered | GREEN | /learn:spec mapped P-pages to VANA workstreams |
| C6 | Evaluation protocol defined | GREEN | DSBV_PROCESS.md §Validate |

All C1-C6 GREEN → DSBV Design phase may begin.

## P-page → Workstream Mapping

| P-page | Workstream Artifact | Feeds Into |
|--------|--------------|------------|
| P0 (System Context) | System identity, scope | DESIGN.md §1 |
| P1 (Blockers/UBS) | UBS entries | 3-PLAN/risks/UBS_REGISTER.md |
| P2 (Drivers/UDS) | UDS entries | 3-PLAN/drivers/UDS_REGISTER.md |
| P3 (Principles/EP) | EP candidates | Agent rules, design principles |
| P4 (Components) | Component map | 3-PLAN/architecture/SYSTEM_DESIGN.md |
| P5 (Steps to Apply) | Sequence hints | 3-PLAN/roadmap/EXECUTION_PLAN.md |

## Summary

- VANA-SPEC: 2-LEARN/specs/{slug}/vana-spec.md
- Total ACs: {grand_total} ({N} Verb, {N} Adverb, {N} Noun, {N} Adjective)
- Next: /learn:handoff {slug} — review spec with Human Director before building
```

---

## Completion Report

After writing both files, print:

```
/learn:spec complete.

System:   {system_name}
Slug:     {system-slug}

Output 1: 2-LEARN/specs/{slug}/vana-spec.md
  §2 Verb ACs    — {N} ACs
  §3 Adverb ACs  — {N} ACs
  §4 Noun ACs    — {N} ACs
  §5 Adj ACs     — {N} ACs
  §6 AC-TEST-MAP — {total} rows (MECE)
  Total ACs: {grand_total}

Output 2: 2-LEARN/specs/{slug}/DSBV-READY-{slug}.md
  C1-C6: all GREEN

Next: /learn:handoff {slug}
```

---

## Gotchas

- **Hallucinated ACs** — every AC traces to page:row:col. Empty source → `[NEEDS REVIEW]`, never invent.
- **Missing I4 ACs** — SPAWNED (P5 NEXT cells) and Hardening (P0 RACI(I)) are mandatory.
- **Vague VANA Words** — "Process" and "Handle" are banned. Use specific verbs.
- **C4 check** — if `_genesis/templates/DSBV_PROCESS.md` is missing, flag RED and halt.

Full list: [gotchas.md](gotchas.md)

---

## Hard Rules

1. All 6 T0 pages `status: approved` — any non-approved → halt.
2. No hallucination — all content derives from page files or learn-input.
3. No placeholder left — replace every `{placeholder}`, use `[NEEDS REVIEW]` only if source is genuinely empty.
4. Template structure is sacred — no reordering sections or renaming ACs.
5. MECE AC coverage — every P3 principle → Adverb AC; every P4 component → Noun AC; every STEP.n(R) → Verb AC.
6. Traceability — every AC has a verifiable `Source (Page:Row:Col)` reference.
7. Path escaping — file paths with `{placeholder}` syntax must be wrapped in backticks.
