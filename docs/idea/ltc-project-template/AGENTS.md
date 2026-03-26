# Agent Configuration — Antigravity

## Priority Order
1. AGENTS.md (this file)
2. GEMINI.md
3. .gemini/antigravity/brain/

## Core Behavioral Rules
- ALWAYS read `2-PLAN/risks/` before generating code
- ALWAYS check `1-ALIGN/charter/REQUIREMENTS.md` before implementing
- ALWAYS run `3-EXECUTE/tests/quality-gates/` after significant changes
- NEVER skip the three-pillar validation
- NEVER introduce dependencies without an ADR in `1-ALIGN/decisions/`

## LTC Frameworks (see `_shared/frameworks/` for details)
- **UBS/UDS:** Identify blockers and drivers before acting
- **3 Pillars:** Sustainability > Efficiency > Scalability
- **6 Work Streams:** Run concurrently, not sequentially
- **Critical Thinking:** Hypothesis + Premises + Reasoning → Conclusion

## Core Equation
Success = Efficient & Scalable Management of Failure Risks
Success ≠ writing more code faster.
Success = optimal value creation with minimal failure risk.
