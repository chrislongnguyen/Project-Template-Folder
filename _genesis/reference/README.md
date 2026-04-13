---
version: "2.0"
status: draft
last_updated: 2026-04-06
type: template
iteration: 2
---

# reference

> "Where is the authoritative source for this topic?"

## Purpose

Reference documents — user guide, company handbook, ALPEI PDFs, EOP governance spec.

Without a stable reference layer, teams search frameworks and SOPs for contextual details that belong in a single authoritative doc — producing lookup failures and inconsistent onboarding. This directory holds documents that supplement all layers of the `_genesis/` cascade but are not themselves philosophy, principles, or frameworks. Superseded versions move to `reference/archive/`.

## What This Contains

| Content Type | Description |
|-------------|-------------|
| `ltc-ai-agent-system-project-template-guide.md` | End-to-end user guide for the LTC project template and agent system |
| `ltc-company-handbook.md` | LTC Partners company handbook — culture, policies, and operating norms |
| `ltc-eop-gov.md` | EOP governance spec — skill structure, validation rules, EOP-GOV criteria |
| `ltc-effective-agent-principles-registry.md` | Registry of all effective agent principles (EP-01 through EP-N) |
| `ltc-effective-system-design.md` | Applied system design reference — the 8-component model in practice |
| `ltc-effectiveness-guide.md` | LTC effectiveness guide — current version |
| `ltc-advanced-el-system.md` | Advanced effective learning system reference |
| `ltc-system-wiki-template.md` | Wiki page template for project system documentation |
| `frontmatter-schema.md` | Canonical frontmatter schema for all artifact types |
| `hook-reliability-audit.md` | Reliability audit reference for Claude Code hooks |
| `ltc-alpei-framework-by-subsystem.pdf` + others | PDF exports of key frameworks for stakeholder distribution |
| `archive/` | Superseded reference documents preserved for historical context |

## How It Connects

```
_genesis/ (all layers)
    │
    └──> _genesis/reference/ (supplements all layers)
              │
              ├──> New team members — onboarding via user guide + handbook
              ├──> .claude/ agents — EOP-GOV spec loaded before skill work
              ├──> All workstreams — frontmatter-schema.md governs every artifact
              └──> _genesis/reference/archive/ — retired docs move here
```

## Pre-Flight Checklist

- [ ] Confirm `ltc-eop-gov.md` is the current version before running `skill-validator.sh`
- [ ] Verify `frontmatter-schema.md` matches the versioning rules in `.claude/rules/versioning.md`
- [ ] No orphaned or stale artifacts

## Naming Convention

Reference files use `ltc-{topic}.md` for LTC-authored docs and descriptive kebab-case for operational references. PDFs retain their source filename.

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-01]]
- [[SKILL]]
- [[documentation]]
- [[frontmatter-schema]]
- [[hook-reliability-audit]]
- [[iteration]]
- [[ltc-advanced-el-system]]
- [[ltc-ai-agent-system-project-template-guide]]
- [[ltc-company-handbook]]
- [[ltc-effective-agent-principles-registry]]
- [[ltc-effective-system-design]]
- [[ltc-effectiveness-guide]]
- [[ltc-eop-gov]]
- [[ltc-system-wiki-template]]
- [[project]]
- [[schema]]
- [[versioning]]
