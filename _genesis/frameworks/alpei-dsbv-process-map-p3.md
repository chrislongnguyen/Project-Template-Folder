---
version: "1.0"
status: Draft
last_updated: 2026-03-30
description: "P3 — ALIGN Workstream Walkthrough: how agents, skills, rules, and gates run ALIGN through DSBV. Training deck content."
---

# P3 — ALIGN Workstream Walkthrough: How It Actually Works

When you run `/dsbv design align`, a structured sequence of agents, rules, and human gates activates — not a chat. Every artifact is produced under contract (DESIGN.md), every phase transition requires your approval, and five always-on rules enforce quality at every step. The walkthrough below traces exactly what happens, from the moment you type the command to the moment ALIGN is marked complete.

---

## Step-by-Step Walkthrough

| # | Phase | Command | Agent | Produces | Rules That Fire | Gate |
|---|-------|---------|-------|----------|-----------------|------|
| 0 | Pre-flight | _(auto — fires before every task)_ | ltc-explorer (Haiku) can assist with pre-DSBV discovery | GREEN / RED status report | **alpei-pre-flight** (6 checks: workstream, alignment, risks, drivers, learning, version consistency) · **alpei-chain-of-custody** (upstream workstream dependency check) | RED on any check = STOP. Fix before proceeding. |
| 1 | Design | `/dsbv design align` | **ltc-planner** (Opus) | `1-ALIGN/DESIGN.md` — artifact inventory, per-artifact purpose, binary ACs, alignment table | **versioning** (new file → version 1.0 / status Draft) · **agent-dispatch** (5-field context package required) | **G1:** Human reviews DESIGN.md. Approves → Sequence unlocks. Requests changes → planner revises and re-presents. |
| 2 | Sequence | `/dsbv sequence align` | **ltc-planner** (Opus) | `1-ALIGN/SEQUENCE.md` — ordered task list, dependencies, sizing, session plan | **dsbv** (hard gate: approved DESIGN.md must exist) · **agent-dispatch** (5-field context package) | **G2:** Human reviews SEQUENCE.md. Approves → Build unlocks. No approved DESIGN.md = error, not warning. |
| 3 | Build | `/dsbv build align` | **ltc-builder** (Sonnet) | Workstream artifacts per SEQUENCE.md: charter, OKRs, decisions, stakeholder map | **versioning** (bump version + update last_updated on every file edit) · **alpei-chain-of-custody** (upstream check per task — GOVERN workstream must have ≥1 validated artifact) · **agent-dispatch** (5-field context package; cost estimate shown before multi-agent launch) | **G3:** Human reviews Build output. Approves → Validate unlocks. ltc-builder does NOT approve its own work. |
| 4 | Validate | `/dsbv validate align` | **ltc-reviewer** (Opus) | `1-ALIGN/VALIDATE.md` — per-criterion PASS / FAIL / PARTIAL with file-path evidence | **dsbv** (hard gate: Validate must complete before workstream is marked done) · **agent-dispatch** (5-field context package) | **G4:** Human reviews VALIDATE.md. All PASS → ALIGN marked complete. Any FAIL → ltc-builder fixes, re-validates. Human ONLY sets status: Approved. |

---

## Gate Summary

| Gate | Trigger condition | Blocks what |
|------|------------------|-------------|
| G1 | Human approves `1-ALIGN/DESIGN.md` | Sequence cannot start |
| G2 | Human approves `1-ALIGN/SEQUENCE.md` | Build cannot start |
| G3 | Human approves Build output | Validate cannot start |
| G4 | Human approves `1-ALIGN/VALIDATE.md` (all criteria PASS) | LEARN workstream cannot start; ALIGN not marked complete |

Gates are decision points, not labels. The system does not advance automatically — it stops and waits.

---

## Always-On Rules (Every Phase)

Five rules load at session start and fire continuously. They cannot be disabled per-command.

| Rule | File | What it enforces |
|------|------|-----------------|
| **alpei-pre-flight** | `.claude/rules/alpei-pre-flight.md` | 6 checks before every task: workstream, alignment, risks, drivers, learning, version consistency. RED = stop. |
| **alpei-chain-of-custody** | `.claude/rules/alpei-chain-of-custody.md` | Workstream N cannot build until Workstream N-1 has ≥1 validated artifact. Phase ordering: Design → Sequence → Build → Validate, no skips. |
| **versioning** | `.claude/rules/versioning.md` | Every edited `.md` file must have `version`, `status`, `last_updated` frontmatter. I1 files = 1.x. Agent sets Draft/Review. Human ONLY sets Approved. |
| **dsbv** | `.claude/rules/dsbv.md` | No artifact produced outside DSBV. Phase ordering enforced with hard gates. Workstream N cannot reach Review until Workstream N-1 has ≥1 Approved artifact. |
| **agent-dispatch** | `.claude/rules/agent-dispatch.md` | Every Agent() call must: (1) name one of the 4 MECE agents, (2) use 5-field context package (EO → INPUT → EP → OUTPUT → VERIFY), (3) match model to agent file, (4) use absolute paths in worktrees. Enforced via PreToolUse hook — ad-hoc calls are blocked. |

---

## Agent Roster

| Agent | Model | DSBV Phase | Scope boundary |
|-------|-------|-----------|----------------|
| ltc-explorer | Haiku | Pre-DSBV | Read-only research and discovery. Does NOT produce workstream artifacts. |
| ltc-planner | Opus | Design + Sequence | Defines WHAT to build and in what order. Does NOT write artifacts. |
| ltc-builder | Sonnet | Build | Produces artifacts per SEQUENCE.md. Does NOT design or review. |
| ltc-reviewer | Opus | Validate | Reviews against DESIGN.md criteria. Does NOT fix — reports only. |

---

## Example: PM ↔ Agent Interaction

This is what the ALIGN Design → Sequence transition looks like in practice.

---

**PM:** `/dsbv design align`

**ltc-planner:** Pre-flight check — all 6 conditions GREEN. Loading DSBV_CONTEXT_TEMPLATE. What do you want ALIGN to accomplish for the PD sub-system? Give me 1-3 sentences.

**PM:** ALIGN should define success for the PD sub-system: stakeholders, OKRs, and the decision log for why we chose this scope.

**ltc-planner:** Drafting DESIGN.md now.

> Artifact inventory: charter (PD scope + stakeholders), OKR register (3 OKRs, binary ACs), decision log (ADR-001 scope choice). Alignment table: 3 completion conditions, 3 artifacts, 0 orphans. Versioning: version 1.0 / status Draft / last_updated 2026-03-30.
>
> **G1 — Design complete.** I produced: `1-ALIGN/DESIGN.md` (3 artifacts, 0 orphan conditions). Ready to proceed to Sequence?

**PM:** Looks good. Proceed.

**ltc-planner:** G1 approved. Running `/dsbv sequence align`.

> Reading approved DESIGN.md. Task order: (1) Draft charter — 45 min, inputs: stakeholder list; (2) Draft OKR register — 30 min, inputs: charter §Objectives; (3) Draft ADR-001 — 20 min, inputs: charter §Scope. Total: ~95 min.
>
> **G2 — Sequence complete.** Task order above, sizes confirmed. Ready to proceed to Build?

**PM:** Approved. Launch Build.

**ltc-planner:** G2 approved. Dispatching ltc-builder with 5-field context package. Cost estimate: single-agent Build ~$3-5. Proceed? [y/n]

---

The PM makes three decisions in this exchange: approve Design, approve Sequence, authorize Build cost. The agents do not advance on their own.

---

*Connects to: P1 (ALPEI workstream map), P2 (DSBV phase overview), P4 (LEARN → ALIGN + PLAN data flow)*

## Links

- [[ADR-001]]
- [[CLAUDE]]
- [[DESIGN]]
- [[DSBV_CONTEXT_TEMPLATE]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[agent-dispatch]]
- [[alpei-chain-of-custody]]
- [[alpei-pre-flight]]
- [[dsbv]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[task]]
- [[versioning]]
- [[workstream]]
