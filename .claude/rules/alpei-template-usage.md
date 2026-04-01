---
version: "1.0"
status: Draft
last_updated: 2026-04-01
---

# ALPEI Template Usage — Always-On Rule

When creating any ALPEI workstream deliverable, ALWAYS check for an applicable template first.
Do not create a blank artifact when a template exists.

## Template Lookup Protocol

1. Identify the workstream and DSBV stage of the deliverable
2. Find the matching cell in the Quick Reference table below
3. If a template is listed, load it from `_genesis/templates/` before writing
4. Fill in all template fields including frontmatter (version, status, last_updated)

## Quick Reference

| Workstream | Design | Sequence | Build | Validate |
|------------|--------|----------|-------|----------|
| **ALIGN** | `CHARTER_TEMPLATE.md`, `OKR_TEMPLATE.md`, `FORCE_ANALYSIS_TEMPLATE.md` | `DSBV_CONTEXT_TEMPLATE.md` | `VANA_SPEC_TEMPLATE.md`, `ADR_TEMPLATE.md` | `REVIEW_TEMPLATE.md`, `REVIEW_PACKAGE_TEMPLATE.md` |
| **LEARN** | `RESEARCH_METHODOLOGY.md`, `SPIKE_TEMPLATE.md` | `DSBV_CONTEXT_TEMPLATE.md` | `RESEARCH_TEMPLATE.md`, `RISK_ENTRY_TEMPLATE.md`, `DRIVER_ENTRY_TEMPLATE.md` | `REVIEW_TEMPLATE.md` |
| **PLAN** | `ARCHITECTURE_TEMPLATE.md`, `ROADMAP_TEMPLATE.md` | `DSBV_CONTEXT_TEMPLATE.md` | `RISK_ENTRY_TEMPLATE.md`, `DRIVER_ENTRY_TEMPLATE.md`, `TEST_PLAN_TEMPLATE.md` | `REVIEW_TEMPLATE.md`, `DSBV_EVAL_TEMPLATE.md` |
| **EXECUTE** | `DESIGN_TEMPLATE.md`, `VANA_SPEC_TEMPLATE.md` | `DSBV_CONTEXT_TEMPLATE.md` | `SOP_TEMPLATE.md`, `WIKI_PAGE_TEMPLATE.md`, `STANDUP_TEMPLATE.md` | `REVIEW_TEMPLATE.md`, `REVIEW_PACKAGE_TEMPLATE.md` |
| **IMPROVE** | `METRICS_BASELINE_TEMPLATE.md`, `FEEDBACK_TEMPLATE.md` | `DSBV_CONTEXT_TEMPLATE.md` | `RETRO_TEMPLATE.md`, `FEEDBACK_TEMPLATE.md` | `REVIEW_TEMPLATE.md`, `DSBV_EVAL_TEMPLATE.md` |

All templates are located at: `_genesis/templates/`

## Exception

If no template exists for a specific deliverable type, create the artifact with proper YAML frontmatter (version, status, last_updated) and add a note flagging the gap so a template can be created in the next iteration.

## Links

- [[ADR_TEMPLATE]]
- [[ARCHITECTURE_TEMPLATE]]
- [[CHARTER_TEMPLATE]]
- [[DESIGN]]
- [[DESIGN_TEMPLATE]]
- [[DRIVER_ENTRY_TEMPLATE]]
- [[DSBV_CONTEXT_TEMPLATE]]
- [[DSBV_EVAL_TEMPLATE]]
- [[FEEDBACK_TEMPLATE]]
- [[FORCE_ANALYSIS_TEMPLATE]]
- [[METRICS_BASELINE_TEMPLATE]]
- [[OKR_TEMPLATE]]
- [[RESEARCH_METHODOLOGY]]
- [[RESEARCH_TEMPLATE]]
- [[RETRO_TEMPLATE]]
- [[REVIEW_PACKAGE_TEMPLATE]]
- [[REVIEW_TEMPLATE]]
- [[RISK_ENTRY_TEMPLATE]]
- [[ROADMAP_TEMPLATE]]
- [[SEQUENCE]]
- [[SOP_TEMPLATE]]
- [[SPIKE_TEMPLATE]]
- [[STANDUP_TEMPLATE]]
- [[TEST_PLAN_TEMPLATE]]
- [[VALIDATE]]
- [[VANA_SPEC_TEMPLATE]]
- [[WIKI_PAGE_TEMPLATE]]
- [[deliverable]]
- [[dsbv]]
- [[iteration]]
- [[workstream]]
