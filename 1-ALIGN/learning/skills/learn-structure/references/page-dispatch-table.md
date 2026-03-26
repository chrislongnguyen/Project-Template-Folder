# Page Dispatch Table — Quick Reference

Use this table to determine row structure, row counts, and derivation sources for each page type.

## Page → Structure Mapping

| Page | Template File | Row Code Pattern | T0 Rows | T1+ Rows | Seeds From |
|------|--------------|-----------------|---------|----------|------------|
| P0 | `1-ALIGN/learning/templates/page-0-overview-and-summary.md` | `Eff.{ABBREV}({role})` | 2 (R+A) | 2 (copy parent) | learn-input EO + research |
| P1 | `1-ALIGN/learning/templates/page-1-ultimate-blockers.md` | `UBS({role})[.UB]*` | 2 (R+A) | 2-6 (3/chain) | P0 col 10 (UB) per role |
| P2 | `1-ALIGN/learning/templates/page-2-ultimate-drivers.md` | `UDS({role})[.UD]*` | 2 (R+A) | 2-6 (3/chain) | P0 col 4 (UD) per role |
| P3 | `1-ALIGN/learning/templates/page-3-principles.md` | `P[n]({pillar})({role})` / `P_F[n]({pillar})({role})` | 4-8 | 4-8+ | P0/P1/P2 col 6 + col 12 |
| P4 | `1-ALIGN/learning/templates/page-4-components.md` | `{LAYER}.n({role})` | 4-8 | 4-8+ | P3 principles |
| P5 | `1-ALIGN/learning/templates/page-5-steps-to-apply.md` | `STEP.n({role})` | 4-6 | 4-6+ | P1-P4 elements |

## T1+ Causal Chain Structure (P1/P2)

### P1 (Blockers) — 3 rows per role chain:
```
UBS(R).UB       — "what blocks" (from this Topic's P0, col 10)
UBS(R).UB.UB    — "what blocks the blocker" (from row above, col 10)
UBS(R).UB.UD    — "what drives the blocker" (from row above, col 4)
```

### P2 (Drivers) — 3 rows per role chain:
```
UDS(R).UD       — "what drives" (from this Topic's P0, col 4)
UDS(R).UD.UB    — "what blocks the driver" (from row above, col 10)
UDS(R).UD.UD    — "what drives the driver" (from row above, col 4)
```

## Direction Inversion Rule

| Row Type | Col 4 (.UD) | Col 6 (.UD.EP) | Col 10 (.UB) | Col 12 (.UB.EP) |
|----------|-------------|-----------------|--------------|-------------------|
| Effective rows | Drives success (good) | P notation (good) | Causes failure (bad) | P_F notation (bad) |
| UDS rows | Drives the driver (good) | P notation (good) | Blocks the driver (bad) | P_F notation (bad) |
| UBS rows | Drives the blocker (bad) | **P_F notation** (bad) | Disables the blocker (good) | **P notation** (good) |

**Key insight:** UBS rows are INVERTED — col 4 drives the blocker (bad for learner), col 10 disables it (good for learner).

## P3 Pillar Assignment

| Pillar | Code | Meaning | Primary source |
|--------|------|---------|----------------|
| S | Sustainability | Prevents failure/harm, ensures correctness | UBS-side principles (col 12 from P0/P1/P2) |
| E | Efficiency | Reduces waste/time, optimizes resources | UDS-side principles (col 6 from P0/P1/P2) |
| Sc | Scalability | Enables growth, repeatability, comparison | Recursive-depth principles |

Priority if ambiguous: S > E > Sc (Sustainability always wins).

## P4 Layer Structure

| Layer | Code | Meaning |
|-------|------|---------|
| Foundational | `INFRA.n(role)` | Core infrastructure (frameworks, data stores, protocols) |
| Operational | `WORKSPACE.n(role)` | Daily-use tools and environments |
| Enabling | `INTEL.n(role)` | Intelligence/analysis tools that amplify capability |

## P5 Step Ordering

Steps follow the DERISK-then-OPTIMIZE pattern:
1. **DERISK steps first** — address UBS elements (failure prevention)
2. **OPTIMIZE steps second** — leverage UDS elements (success acceleration)
3. Each step references specific P1-P4 elements it acts on
