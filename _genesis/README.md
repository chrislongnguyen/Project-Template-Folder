---
version: "1.1"
status: draft
last_updated: 2026-04-03
owner: "Long Nguyen"
derived_from:
  - "Vinh ALPEI Overview PDF"
  - "Vinh ALPEI By Work Streams PDF"
  - "Vinh ALPEI By Sub-system PDF"
  - "Vinh ALPEI Process Requirements PDF"
  - "Vinh ALPEI UES Versioning PDF"
---
# _genesis — LTC Organizational Knowledge Base

The genesis layer is the immutable foundation that all LTC projects inherit from. It captures organizational intellectual capital: beliefs, commitments, models, and standards that are project-agnostic.

## Cascade Model

```
philosophy → principles → frameworks → derived artifacts
(WHY)        (WHAT)       (HOW)        (rules, skills, workstreams)
```

Derived artifacts (CLAUDE.md rules, agent skills, workstream templates) are downstream of this layer. Changes here propagate outward through team consensus.

## Improvement Flow

```
member worktree → branch → PR → daily standup → consensus → merge to main
```

No genesis artifact changes without team consensus. This protects organizational coherence.

## Categories

| File/Dir     | Layer         | Purpose                                              |
|--------------|---------------|------------------------------------------------------|
| BLUEPRINT.md | BEDROCK       | Canonical philosophy, principles, operating model, roadmap (I0–I4) |
| philosophy/  | WHY           | Core beliefs, cognitive truths, 3 Pillars            |
| principles/  | WHAT          | EP registry EP-01–EP-10, EOP-GOV, Agent Diagnostic   |
| frameworks/  | HOW           | 18 canonical kebab-case files + archive/ (6 superseded) |
| brand/       | IDENTITY      | Brand Guide, colors, naming convention               |
| security/    | PROTECTION    | Data classification, security hierarchy              |
| sops/        | PROCESS       | Standard operating procedures + archive/             |
| templates/   | FORMATS       | DSBV process, document templates (Agent E)           |
| guides/      | ONBOARDING    | Migration guides for template upgrades               |
| governance/  | AUTHORITY     | Decision rights, RACI, escalation paths              |
| compliance/  | OBLIGATIONS   | Regulatory, audit, legal obligations                 |
| culture/     | VALUES        | Behavioral norms, collaboration standards            |
| reference/   | SUPPLEMENTARY | Handbook, external refs, archive                    |

> Note: `DESIGN-genesis-blueprint-cleanup.md` and `SEQUENCE-genesis-blueprint-cleanup.md` are present in root during the I2 cleanup branch — remove after merge to main.

---

**Classification:** INTERNAL

## Links

- [[CLAUDE]]
- [[dsbv]]
- [[security]]
- [[standard]]
- [[versioning]]
- [[workstream]]
