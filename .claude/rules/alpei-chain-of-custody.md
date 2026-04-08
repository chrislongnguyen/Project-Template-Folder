---
version: "1.3"
status: draft
last_updated: 2026-04-03
---
# ALPEI Chain-of-Custody — Always-On Rule

ALIGN → LEARN → PLAN → EXECUTE → IMPROVE. Workstream N cannot start DSBV Build until N-1 has ≥1 validated artifact.

GOVERN exception: operational patches (rule files, registry updates, agent config) skip DSBV cycles.

**Violation:** STOP → name the missing upstream dependency → propose completing upstream first, or get explicit human override.

Full dependency table: `_genesis/frameworks/alpei-dsbv-process-map.md` § P4. Run `/dsbv` for guided flow.

## Sub-System Sequence

PD → DP → DA → IDM. Downstream sub-system cannot exceed upstream version.
PD Effective Principles govern all downstream sub-systems.
Violation: same STOP protocol as workstream violations — state the violation,
name the missing upstream artifact, wait for human override.

## Links

- [[SEQUENCE]]
- [[alpei-dsbv-process-map]]
- [[workstream]]
