---
version: "1.2"
status: draft
last_updated: 2026-04-12
work_stream: 4-EXECUTE
sub_system: _cross
type: template
iteration: 1
---

# _cross — Cross-Cutting | EXECUTE Workstream

> "Shared infrastructure that is inconsistent across subsystems is not shared infrastructure — it is a source of four separate defects."

Cross-cutting EXECUTE artifacts support all subsystems with shared infrastructure, configuration, and build standards. They cannot be owned by a single subsystem — they govern how all subsystems are built, tested, and deployed.

## Scope

Cross-cutting artifacts span all 4 subsystems (PD, DP, DA, IDM) within the EXECUTE workstream.
These cannot be owned by a single subsystem — they govern or support all of them.

In EXECUTE, cross-cutting means the environment, coding standards, CI/CD configuration, and shared tooling that every subsystem build depends on. A misconfigured shared environment or broken CI/CD pipeline blocks all 4 subsystems simultaneously — making _cross the highest-leverage and highest-risk dependency in the workstream.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DESIGN.md | `DESIGN.md` | DSBV Design stage — scope, ACs, agent dispatch plan |
| SEQUENCE.md | `SEQUENCE.md` | DSBV Sequence stage — ordered work plan |
| environment.md | `environment.md` | Environment setup guide — tools, versions, credentials structure, local dev setup |
| CI/CD config | `.github/workflows/` or `ci/` | Automated test and deployment pipelines |
| shared-config/ | `config/shared/` | Shared configuration — environment variables, feature flags, logging standards |
| coding-standards.md | `coding-standards.md` | Code style, review requirements, documentation standards |

> **Note:** Cross-cutting EXECUTE artifacts (environment setup, CI/CD config, shared configuration) do not have LTC templates — they are project-specific. Use the Contents table above as a checklist of what must exist before subsystems can run.

## Pre-Flight Checklist

- [ ] All subsystems can run in the same environment without conflicts
- [ ] CI/CD pipeline covers all 4 subsystems
- [ ] Shared configuration does not contain secrets — uses env var references
- [ ] Coding standards enforced consistently across all subsystems
- [ ] Artifacts do not contradict upstream subsystem's scope or Effective Principles
- [ ] Outputs ready for handoff to downstream

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| DESIGN.md | `design-template.md` | `../../_genesis/templates/design-template.md` |
| SEQUENCE.md | `sequence-template.md` | `../../_genesis/templates/sequence-template.md` |
| VALIDATE.md | `review-template.md` | `../../_genesis/templates/review-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
