---
version: "1.5"
status: Draft
last_updated: 2026-04-03
purpose: "Workstream×phase progress dashboard — 22-row matrix (20 cells + 2 summary rows)"
---

# VERSION REGISTRY

> Current iteration: **I1** (all file versions must be 1.x)
> ALPEI sequence: A=1 ALIGN, L=2 LEARN, P=3 PLAN, E=4 EXECUTE, I=5 IMPROVE.
> Folder names (3-PLAN, 4-EXECUTE, 5-IMPROVE) reflect pre-ALPEI numbering — renaming deferred to I2.
> **Map Cell** column uses `P1-{A-E}{1-4}` grid notation. Values show `TBD` until Consumer 1 (A1 process map) ships.

---

## Workstream×Phase Progress Matrix

| Workstream×Phase            | Deliverable                            | Version | Status      | AC Pass | Last Updated | Map Cell |
|-----------------------|----------------------------------------|---------|-------------|---------|--------------|----------|
| 1-ALIGN × Design      | DESIGN.md                              | 1.4     | Draft       | —       | 2026-03-30   | TBD      |
| 1-ALIGN × Sequence    | SEQUENCE.md                            | 1.3     | Draft       | —       | 2026-03-30   | TBD      |
| 1-ALIGN × Build       | Charter, OKRs, ADRs (7), Stakeholders | 1.x     | In Progress | 28/30   | 2026-03-30   | TBD      |
| 1-ALIGN × Validate    | VALIDATE.md                            | 1.2     | Draft       | 28/30   | 2026-03-30   | TBD      |
| 2-LEARN × Design      | DESIGN.md                              | 1.0     | Approved    | —       | 2026-03-30   | TBD      |
| 2-LEARN × Sequence    | SEQUENCE.md                            | 1.1     | Approved    | —       | 2026-03-30   | TBD      |
| 2-LEARN × Build       | input/, research/, specs/, output/     | 1.x     | In Progress | —       | 2026-03-30   | TBD      |
| 2-LEARN × Validate    | VALIDATE.md                            | —       | Not Started | —       | —            | TBD      |
| 3-PLAN × Design       | DESIGN.md                              | —       | Pending     | —       | —            | TBD      |
| 3-PLAN × Sequence     | SEQUENCE.md                            | —       | Pending     | —       | —            | TBD      |
| 3-PLAN × Build        | UBS/UDS Registers, Architecture        | —       | Pending     | —       | —            | TBD      |
| 3-PLAN × Validate     | VALIDATE.md                            | —       | Pending     | —       | —            | TBD      |
| 4-EXECUTE × Design    | DESIGN.md                              | 1.2     | Draft       | —       | 2026-03-30   | TBD      |
| 4-EXECUTE × Sequence  | SEQUENCE.md                            | —       | Not Started | —       | —            | TBD      |
| 4-EXECUTE × Build     | src/, tests/, config/, docs/           | —       | Not Started | —       | —            | TBD      |
| 4-EXECUTE × Validate  | VALIDATE.md                            | —       | Not Started | —       | —            | TBD      |
| 5-IMPROVE × Design    | DESIGN.md                              | —       | Pending     | —       | —            | TBD      |
| 5-IMPROVE × Sequence  | SEQUENCE.md                            | —       | Pending     | —       | —            | TBD      |
| 5-IMPROVE × Build     | CHANGELOG.md, metrics/, retros/        | 1.0     | Pending     | —       | 2026-03-30   | TBD      |
| 5-IMPROVE × Validate  | VALIDATE.md                            | —       | Pending     | —       | —            | TBD      |

### Summary Rows (no DSBV expansion)

| Workstream          | Description                                        | Version | Status     | Last Updated |
|---------------|----------------------------------------------------|---------|------------|--------------|
| GOVERN        | Operational infrastructure — CLAUDE.md, .claude/rules/, .claude/agents/, hooks/ | 1.x | Active | 2026-04-05 |
| _genesis      | Reference layer — BLUEPRINT.md, brand, frameworks (18 canonical), security, SOPs, templates, 5 Vinh PDFs | 2.0 | Draft | 2026-04-03 |

### Recently Modified Files (I2 Cleanup — 2026-04-03)

| File | Version | Status | Last Updated |
|------|---------|--------|--------------|
| `_genesis/BLUEPRINT.md` | 2.0 | Draft | 2026-04-03 |
| `.claude/rules/dsbv.md` | 1.1 | Draft | 2026-04-03 |
| `.claude/rules/alpei-chain-of-custody.md` | 1.2 | Draft | 2026-04-03 |
| `.claude/rules/versioning.md` | 1.4 | Draft | 2026-04-03 |
| `_genesis/DESIGN-genesis-blueprint-cleanup.md` | 1.2 | Draft | 2026-04-03 |
| `_genesis/SEQUENCE-genesis-blueprint-cleanup.md` | 2.0 | Draft | 2026-04-03 |
| `.claude/hooks/verify-deliverables.sh` | 1.2 | Draft | 2026-04-05 |
| `.claude/hooks/nesting-depth-guard.sh` | 1.0 | Draft | 2026-04-05 |
| `.claude/agents/ltc-builder.md` | 1.3 | Draft | 2026-04-05 |
| `.claude/agents/ltc-reviewer.md` | 1.3 | Draft | 2026-04-05 |
| `.claude/agents/ltc-explorer.md` | 1.3 | Draft | 2026-04-05 |
| `.claude/agents/ltc-planner.md` | 1.3 | Draft | 2026-04-05 |
| `_genesis/DESIGN-govern-ep12-ep13-enforcement.md` | 1.0 | Draft | 2026-04-05 |
| `_genesis/SEQUENCE-govern-ep12-ep13-enforcement.md` | 1.0 | Draft | 2026-04-05 |
| `_genesis/VALIDATE-govern-ep12-ep13-enforcement.md` | 1.0 | Draft | 2026-04-05 |
| `_genesis/DESIGN-govern-setup-skill.md` | 1.0 | Draft | 2026-04-05 |

> **Status key:** Not Started | Pending | Draft | Review | In Progress | Approved
> **Not Started** = this cell's primary artifact does not exist yet. **Pending** = upstream workstream not yet Approved — cannot start.
> **Map Cell** = TBD until Consumer 1 (A1 process map `_genesis/frameworks/alpei-dsbv-process-map.md`) is built.

---

## Sub-System Version Progression

4 sub-systems × 5 UES iteration levels. PD (Problem Diagnosis) governs all downstream sub-systems.
Version labels from `_genesis/frameworks/UES_VERSION_BEHAVIORS.md`.

| Sub-System                          | Logic Scaffold (PD) | Concept (DP)  | Prototype (DA) | MVE (IDM)  | Leadership     |
|-------------------------------------|---------------------|---------------|----------------|------------|----------------|
| PD — Problem Diagnosis              | In Progress         | Pending        | Pending        | Pending    | Pending        |
| DP — Diagnosis Pipeline             | Pending             | Pending        | Pending        | Pending    | Pending        |
| DA — Diagnosis Analysis             | Pending             | Pending        | Pending        | Pending    | Pending        |
| IDM — Insight-Driven Management     | Pending             | Pending        | Pending        | Pending    | Pending        |

> PD is at Logic Scaffold (I1). DP, DA, IDM cannot exceed PD's version — downstream inherits upstream constraint.

---

## Notes

- **I1 constraint:** All file `version` fields must be `1.x`. Never `0.x` or `2.x` for I1 content.
- **2-LEARN** is an I1 Must deliverable. DSBV Build in progress — skill rerouting and cross-refs pending.
- **3-PLAN** UBS/UDS Registers are seeded from ALIGN but not yet in formal DSBV — status = Pending.
- **4-EXECUTE** DESIGN.md exists (multi-agent orchestration context) but DSBV Sequence not yet started.
- **5-IMPROVE** CHANGELOG.md initialized but DSBV has not formally started — status = Pending.
- **GOVERN workstream** does not use full DSBV for small patches — see `rules/alpei-chain-of-custody.md`.
- **Map Cell column** populates as `P1-{A-E}{1-4}` after Consumer 1 ships. Row ordering: A=ALIGN, B=LEARN, C=PLAN, D=EXECUTE, E=IMPROVE; columns 1-4 = Design, Sequence, Build, Validate.
- This file is updated manually at each milestone. Auto-derive rules for I2 are deferred to I2 planning.

---

## How Agents Update This File

This registry uses a **22-row workstream×phase matrix**: 20 cells (5 workstreams × 4 DSBV phases) plus 2 summary rows for GOVERN infrastructure and _genesis.

**Per-cell update rules:**
1. After editing any workstream artifact: find the matching `Workstream×Phase` row, update **Version + Status + AC Pass + Last Updated**.
2. After a DSBV phase transition (human approval): update the Status column for the completed phase row (Draft → Review) and the next phase row (Pending/Not Started → Draft).
3. After adding a key artifact to a Build cell: update the **Deliverable** column (comma-separated within the cell).
4. After Consumer 1 ships: replace all `TBD` values in **Map Cell** with `P1-{A-E}{1-4}` grid references.
5. Bump this file's own `version` (MINOR +1) and `last_updated` on every edit.
6. Mirror major state changes in `5-IMPROVE/changelog/CHANGELOG.md`.

**Column definitions:**
- `Workstream×Phase` — ALPEI workstream name × DSBV phase label (20 combinations)
- `Deliverable` — primary artifact name(s) for this cell
- `Version` — current version of the primary artifact (`—` if none exists)
- `Status` — one of exactly 6 values: `Not Started` | `Pending` | `Draft` | `Review` | `In Progress` | `Approved`
- `AC Pass` — fraction of ACs passing per VALIDATE.md (`—` if no validate yet)
- `Last Updated` — date of last meaningful change (YYYY-MM-DD format)
- `Map Cell` — Consumer 1 process map grid reference (`TBD` until Consumer 1 ships)

**Status lifecycle:**
- Agent sets: `Draft`, `Review`, `In Progress`, `Not Started`, `Pending`
- Human ONLY sets: `Approved`
- Editing an `Approved` file → reset that row to `Draft`

---

## Version Bump Reference (I1)

```
New file in I1        → version: "1.0"
Committed at 1.Y      → next meaningful edit → "1.(Y+1)"
Wrong MAJOR (2.x)     → correct to 1.x (this is not a normal bump — it is a fix)
```

## Links

- [[alpei-dsbv-process-map]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[UES_VERSION_BEHAVIORS]]
- [[VALIDATE]]
- [[alpei-chain-of-custody]]
- [[deliverable]]
- [[dsbv]]
- [[iteration]]
- [[security]]
- [[workstream]]
