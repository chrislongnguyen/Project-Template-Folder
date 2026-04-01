---
version: "1.1"
status: Draft
last_updated: 2026-03-30
---
# ALPEI Chain-of-Custody — Always-On Rule

Enforces upstream dependency ordering across zones, sub-systems, and DSBV phases.

## Zone Sequence (ALPEI)

ALIGN → LEARN → PLAN → EXECUTE → IMPROVE

- Zone N cannot start DSBV Build until Zone (N-1) has at least 1 validated artifact
- Zone N's DESIGN.md must reference Zone (N-1) outputs as inputs. Named dependencies
  (source: `_genesis/frameworks/ALPEI_DSBV_PROCESS_MAP.md` § P4 — LEARN Data Flow):

  | Consuming Zone | Required Input Artifact          | Source Zone |
  |----------------|----------------------------------|-------------|
  | ALIGN          | UBS analysis                     | LEARN       |
  | ALIGN          | Effective Principles             | LEARN       |
  | PLAN           | UBS → Risk Register              | LEARN/ALIGN |
  | PLAN           | UDS → Driver Register            | LEARN/ALIGN |
  | PLAN           | Research → Architecture inputs   | LEARN       |
  | EXECUTE        | Architecture doc                 | PLAN        |
  | EXECUTE        | Risk Register                    | PLAN        |
  | IMPROVE        | Metrics baseline                 | EXECUTE     |

  Full dependency table: `_genesis/frameworks/ALPEI_DSBV_PROCESS_MAP.md` § P4

- Downstream zones inherit constraints from upstream zones — they do not override them

## DSBV Phase Ordering

Design → Sequence → Build → Validate

- No phase may be skipped
- Each phase transition requires human approval (gate)
- Validate must happen before a zone is marked complete

## Exception: Zone 0 GOVERN

Zone 0 (GOVERN) is operational infrastructure. Small patches (rule files, registry updates, agent config) do not require full DSBV cycles. GOVERN uses DSBV only for major structural changes.

## Violation Response

If you detect a chain-of-custody violation (e.g., building a PLAN artifact before ALIGN is validated):
1. STOP — do not proceed
2. Name the violation and the upstream dependency that is missing
3. Propose: complete the upstream work first, or get explicit human override
