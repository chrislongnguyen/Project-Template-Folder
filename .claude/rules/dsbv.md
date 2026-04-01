---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
description: "DSBV sub-process awareness — ensures every workstream uses Design → Sequence → Build → Validate."
---
# DSBV — Always-On Rule

Every APEI workstream produces artifacts through DSBV: **Design → Sequence → Build → Validate**.

- **No ad-hoc artifacts.** No workstream artifact is produced outside DSBV. If work is not in a DESIGN.md, it is not in scope.
- **Phase ordering enforced.** Design MUST complete before Build. Validate MUST happen before a workstream is marked complete.
- **APEI flow constraint.** Workstream N cannot reach Review until Workstream (N-1) has at least 1 Approved artifact.
- **Human gates.** Each phase transition requires explicit human approval.

**Skill:** `/dsbv` — full guided flow, single-phase commands, status view.
**Process doc:** `_genesis/templates/DSBV_PROCESS.md` — phase details, multi-agent config, readiness conditions (C1-C6).
