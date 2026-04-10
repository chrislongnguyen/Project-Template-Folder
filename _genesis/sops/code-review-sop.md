---
version: "1.1"
last_updated: 2026-03-30
owner: ""
---
# CODE REVIEW SOP
## Review Checklist Against the 3 Pillars

---

## Before Reviewing
- [ ] Read the linked requirement in `1-ALIGN/charter/REQUIREMENTS.md`
- [ ] Read any linked risks in `3-PLAN/risks/UBS_REGISTER.md`

## Sustainability Check
- [ ] Error handling is comprehensive (no silent failures)
- [ ] Edge cases are covered
- [ ] Tests exist for the critical paths and known risks
- [ ] No security vulnerabilities introduced
- [ ] No secrets in the code

## Efficiency Check
- [ ] No redundant or dead code
- [ ] Naming is clear and consistent
- [ ] Functions have single responsibility
- [ ] No premature optimization (but no obvious inefficiencies either)

## Scalability Check
- [ ] No hardcoded limits or magic numbers
- [ ] Design supports future extension without major refactoring
- [ ] API contracts are versioned

## General
- [ ] Code follows established patterns in the codebase
- [ ] Changes are appropriately scoped (not too large, not too fragmented)
- [ ] Documentation updated if public API changed

---

**Classification:** INTERNAL

## Links

- [[DESIGN]]
- [[UBS_REGISTER]]
- [[charter]]
- [[documentation]]
- [[security]]
