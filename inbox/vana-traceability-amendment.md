---
version: "1.0"
status: draft
last_updated: 2026-04-10
type: decision
work_stream: _genesis
sub_system:
iteration: 1
---

# VANA Traceability Amendment

> 3 drop-in replacements that codify VANA AC traceability from ESD (2-LEARN) through PLAN and EXECUTE.
> Goal: zero AC attrition — every AC crafted in the ESD is structurally traceable to downstream DESIGN.md files.
> Approach: extend 3 existing artifacts (SOP Rule 5, ESD §3.5, DESIGN.md template). No new artifact types.

---

## 1. SOP Rule 5 — Revised Text

**Drop-in replacement for §7 Rule 5 in `_genesis/sops/alpei-standard-operating-procedure.md`**

### Rule 5: VANA Handoff Verification

Every deliverable has success criteria expressed in VANA grammar (Verb, Adverb, Noun, Adjective). Without VANA criteria, AI agents self-audit as "everything looks correct" (LT-5).

**Iteration Scoping:** Each ESD AC belongs to exactly one iteration based on its pillar:

| Pillar | Target Iteration | Rationale |
|--------|-----------------|-----------|
| Sustainability | Iteration 1 (Concept) | Correct + safe first |
| Efficiency | Iteration 2 (Prototype) | Optimize second |
| Scalability | Iteration 3-4 (MVE/Leadership) | Scale last |

The PM filters ESD ACs by `Target_Iteration` to determine which ACs are in scope for the current iteration's PLAN and EXECUTE DESIGN.md files.

**Handoff Verification Checkpoints:**

| Checkpoint | When | Verification | Owner |
|------------|------|-------------|-------|
| CP-1 | PLAN Design (G1) | Every ESD AC for the current iteration has a `VANA_Ref` row in `3-PLAN/{sub}/DESIGN.md` Artifact Inventory | PM |
| CP-2 | EXECUTE Design (G1) | Every ESD AC for the current iteration has a `VANA_Ref` row in `4-EXECUTE/{sub}/DESIGN.md` Artifact Inventory | PM |
| CP-3 | EXECUTE Validate (G4) | `gate-precheck.sh` verifies VANA coverage (Iteration 2+ automation) | Script / PM |

CP-1 and CP-2 are manual checklist items at the G1 gate of their respective workstreams. The PM compares the ESD §3.5 table (filtered to `Target_Iteration = current`) against the DESIGN.md `VANA_Ref` column. Any missing AC is a G1 blocker.

CP-3 is manual in Iteration 1. In Iteration 2+, `gate-precheck.sh` will automate coverage comparison (script enhancement deferred to Scalability tier).

**Enforcement:** `scripts/gate-precheck.sh` (DSBV skill) + manual checklist at G1

---

## 2. ESD §3.5 — Revised Table

**Drop-in replacement for §3.5 in `_genesis/templates/effective-system-design-template.md`**

### 3.5 A.C. Traceability Summary

> Every A.C. requires a complete 5-link chain. Verify before locking.
> Target_Iteration is determined by the AC's pillar: Sustainability → I1, Efficiency → I2, Scalability → I3-4.

| A.C. ID | Grammar Element | Phase 2 Decision | ELF Layer | EO Link | Target_Iteration |
|---------|----------------|-----------------|-----------|---------|-----------------|
| <!-- TODO: e.g., SustainAdv-AC1 --> | <!-- TODO: e.g., SustainAdv ("Verifiably") --> | <!-- TODO: e.g., EP P1(S) --> | <!-- TODO: e.g., UBS: manual hallucination risk --> | <!-- TODO: EO statement --> | <!-- TODO: I1 / I2 / I3-4 --> |
| <!-- TODO: Add one row per A.C. --> | | | | | |

> **Integration with `/learn:spec`:** The AC-TEST-MAP produced by `/learn:spec` Step 6 (§5) already maps ACs to iterations. When using `/learn:spec`, the `Target_Iteration` column should match the AC-TEST-MAP's iteration assignment.

---

## 3. DESIGN.md Template — VANA_Ref Addition

**Amended table format for the Artifact Inventory in `_genesis/templates/design-template.md`, used by PLAN and EXECUTE DESIGN.md files.**

The existing Artifact Inventory table gains one column: `VANA_Ref`. This column references the ESD AC(s) that the artifact's acceptance condition serves.

### Artifact Inventory

Unified artifact-condition table. Every artifact has at least one condition. Every condition maps to an artifact.

| # | Artifact | Path | Purpose (WHY) | Acceptance Conditions | VANA_Ref |
|---|----------|------|---------------|-----------------------|----------|
| A1 | pd-architecture.md | 3-PLAN/1-PD/ | Define PD system architecture | AC-1: `grep "## Component Map" <file>` returns 1 match | SustainAdv-AC1, Noun-AC1 |
| A2 | pd-risk-register.md | 3-PLAN/1-PD/ | Track PD blocking forces | AC-2: Every UBS element from ESD §1.3 has a row | SustainAdj-AC2 |
| A3 | pd-driver-register.md | 3-PLAN/1-PD/ | Track PD driving forces | AC-3: Every UDS element from ESD §1.4 has a row | Verb-AC1 |

> **VANA_Ref** = comma-separated list of ESD A.C. IDs (from ESD §3.5) that this artifact's condition verifies.
> At G1, the PM checks: every ESD AC with `Target_Iteration = current` appears in at least one VANA_Ref cell.
> If an AC has no VANA_Ref in any row, it is an attrition gap — G1 blocker.

**Alignment check (mandatory at G1):**
- [ ] Orphan conditions = 0 (every condition maps to a named artifact)
- [ ] Orphan artifacts = 0 or justified (every artifact has at least one condition)
- [ ] Artifact count here = row count in this table (self-consistent)
- [ ] VANA coverage = 100% (every ESD AC for current iteration appears in at least one VANA_Ref cell)

---

## Integration Notes

### `/learn:spec` AC-TEST-MAP Connection

The `/learn:spec` skill (Step 9) already produces an AC-TEST-MAP with iteration assignments. This amendment aligns with that output:
- AC-TEST-MAP's iteration column = ESD §3.5's `Target_Iteration` column
- When `/learn:spec` is used, the PM should verify consistency between AC-TEST-MAP and ESD §3.5

**Open routing gap:** AC-TEST-MAP output location is currently undefined in `/learn:spec`. A future amendment should specify that AC-TEST-MAP is written to `2-LEARN/{sub}/specs/` and referenced from ESD §3.5.

### Files to Edit When Applying

1. `_genesis/sops/alpei-standard-operating-procedure.md` — replace §7 Rule 5
2. `_genesis/templates/effective-system-design-template.md` — replace §3.5
3. `_genesis/templates/design-template.md` — add VANA_Ref column + coverage checkbox

---

## Links

- [[alpei-standard-operating-procedure]]
- [[effective-system-design-template]]
- [[design-template]]
- [[ltc-ues-versioning]]
- [[ltc-ues-version-behaviors]]
- [[vana-extraction-rules]]
- [[gate-precheck]]
- [[enforcement-layers]]
