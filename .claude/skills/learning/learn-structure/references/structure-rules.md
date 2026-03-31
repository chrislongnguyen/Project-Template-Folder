# Structure Rules — Column Definitions, CAG Prefixes, Row Bounds

Reference file for `/learn:structure`. Loaded on demand from SKILL.md.

---

## 17-Column Layout

Every P-page row has exactly 17 pipe-delimited columns:

| Col | Suffix | Domain | Description |
|-----|--------|--------|-------------|
| 0 | (label) | — | Row label (bold, coded) |
| 1 | .REL | Context | Relevant context/relationship |
| 2 | .UD | Context | Ultimate Driver (what drives success) |
| 3 | .ACT | Context | Action the user takes |
| 4 | .UDS | Context | Ultimate Driving System |
| 5 | .UD.EOE | Analysis | Driver's environment/conditions |
| 6 | .UD.EP | Analysis | Driver's enabling principle |
| 7 | .UD.EOT | Analysis | Driver's enabling tool |
| 8 | .UD.EOP | Analysis | Driver's enabling operating procedure |
| 9 | .FAIL | Context | Failure mode / what goes wrong |
| 10 | .UBS | Context | Ultimate Blocking System |
| 11 | .UB.EOE | Analysis | Blocker's environment/conditions |
| 12 | .UB.EP | Analysis | Blocker's enabling principle |
| 13 | .UB.EOT | Analysis | Blocker's enabling tool |
| 14 | .UB.EOP | Analysis | Blocker's enabling operating procedure |
| 15 | .EO | Generative | Effective Outcome synthesis |
| 16 | .NEXT | Generative | Next action / handoff |

---

## CAG Prefix Rules

Every content cell (cols 1-16) MUST begin with a CAG-tagged prefix:

```
{RowCode}{ColSuffix}: {content}
```

**CAG categories:**
- **C (Context):** Cols 1-4, 9-10 — factual, grounded in research
- **A (Analysis):** Cols 5-8, 11-14 — derived from context through reasoning
- **G (Generative):** Cols 15-16 — synthesized recommendations

**Examples:**
- `Eff.DF(R).REL: Data Foundation establishes...`
- `UBS(R).UB.EP: P[1](S)(R) — Validate before transform`
- `STEP.1(R).EO: Establish baseline metrics...`

**Validation regex** (from constraints.yaml):
```
^[A-Za-z._\[\]()0-9]+:\s.+
```

---

## Row Count Bounds by Page

| Page | T0 Rows | T1+ Rows | Row Code Pattern |
|------|---------|----------|-----------------|
| P0 | 2 (R + A) | 2 (copy from parent) | `Eff.{ABBREV}(role)` |
| P1 | 2 | Up to 6 (3 per role) | `UBS(role)`, `.UB`, `.UB.UB`, `.UB.UD` |
| P2 | 2 | Up to 6 (3 per role) | `UDS(role)`, `.UD`, `.UD.UB`, `.UD.UD` |
| P3 | 4-8 | 4-8 | `P[n](pillar)(role)`, `P_F[n](pillar)(role)` |
| P4 | 4-8 | 4-8 | `INFRA.n(role)`, `WORKSPACE.n(role)`, `INTEL.n(role)` |
| P5 | 4-6 | 4-6 | `STEP.n(role)` |

---

## Direction Inversion Rules

The principle notation flips depending on whether the row is UBS or UDS:

| Row Type | `.UD.EP` column | `.UB.EP` column |
|----------|----------------|----------------|
| **UBS** (blocker) | P_F notation (failure principle) | P notation (enabling principle) |
| **UDS** (driver) | P notation (enabling principle) | P_F notation (failure principle) |

**Mnemonic:** On blocker rows, the "driver of the blocker" is a failure principle. On driver rows, the "driver of the driver" is an enabling principle.

---

## P3 Pillar Assignment

Principles are tagged with one of three pillars:
- **S (Sustainability):** Prevents failure, maintains system health
- **E (Efficiency):** Reduces waste, optimizes resource use
- **Sc (Scalability):** Enables growth, handles increasing load

Format: `P[n](pillar)(role)` for enabling, `P_F[n](pillar)(role)` for failure.

---

## P4 Component Layers

Components follow a 3-layer structure:
1. **Foundational (INFRA):** Infrastructure that must exist first
2. **Operational (WORKSPACE):** Day-to-day working environment
3. **Enabling (INTEL):** Intelligence/analytics that amplify the other layers
