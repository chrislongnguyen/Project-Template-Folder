---
description: "DSBV sub-process awareness — ensures every zone uses Design → Sequence → Build → Validate."
---

# DSBV — Always-On Rule

Every APEI zone produces artifacts through DSBV: **Design → Sequence → Build → Validate**.

- **No ad-hoc artifacts.** No zone artifact is produced outside DSBV. If work is not in a DESIGN.md, it is not in scope.
- **Phase ordering enforced.** Design MUST complete before Build. Validate MUST happen before a zone is marked complete.
- **APEI flow constraint.** Zone N cannot reach Review until Zone (N-1) has at least 1 Approved artifact.
- **Human gates.** Each phase transition requires explicit human approval.

**Skill:** `/dsbv` — full guided flow, single-phase commands, status view.
**Process doc:** `_shared/templates/DSBV_PROCESS.md` — phase details, multi-agent config, readiness conditions (C1-C6).
