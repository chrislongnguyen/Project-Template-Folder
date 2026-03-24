# ZONE 3 — EXECUTE (Deliver with Effective Process)

> "Build it right, with the right tools, in the right environment."

**Work Stream:** WS6 — Effective Execution
**Derived From:** Ultimate Truth #7 (Work Stream 6); Agile SOPs 2.4-2.5; Effective Execution Principles

---

## Purpose
Every file here must trace back to a requirement in `1-ALIGN/` and a risk consideration in `2-PLAN/`.

## Contents

| Subfolder | Component | Contains | Key Question |
|-----------|-----------|----------|--------------|
| `src/` | EA (Effective Actions) | Source code — the primary execution artifact | What are we building? |
| `tests/` | Risk Gates | Test suites — each test disables a failure mode | What failures are we preventing? |
| `config/` | EOE (Environment) | Environment configs, security, CI/CD | Where does it run? |
| `docs/` | EOP (Procedures) | API docs, runbooks, onboarding | How do we operate it? |

## Execution Sub-Checks (from Effective Execution model)
- **Effective Process:** Are the steps clear? → `docs/runbooks/`
- **Effective Capacity:** Right skills/tools for the job? → Team allocation
- **Effective Tools:** Using LTC-approved ecosystem? → `config/`
- **Effective Environment:** Supportive context? → `config/env/`

## Execution Checklist
- [ ] Every source file traces to a requirement in `1-ALIGN/charter/REQUIREMENTS.md`
- [ ] Every test traces to a risk in `2-PLAN/risks/UBS_REGISTER.md`
- [ ] Quality gates pass for all 3 pillars
- [ ] No secrets committed to version control
- [ ] Security policy followed (`config/security/`)
- [ ] API documentation is current
- [ ] Runbooks exist for operational procedures

## Pre-Flight — 3 Pillars Check
### Sustainability — Does our execution manage failure risks?
- [ ] Error handling is comprehensive (no silent failures)
- [ ] Tests cover critical paths and known risk areas
- [ ] Graceful degradation paths implemented
- [ ] No single points of failure

### Efficiency — Is our execution lean?
- [ ] No redundant code or over-engineering
- [ ] Dependencies are minimized
- [ ] Build and deploy times are acceptable

### Scalability — Does our execution handle growth?
- [ ] No hardcoded limits or magic numbers
- [ ] Load tested at 3× expected volume
- [ ] Designed for the next order of magnitude
