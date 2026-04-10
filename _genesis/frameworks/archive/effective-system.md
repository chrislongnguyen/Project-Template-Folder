<!-- ARCHIVED 2026-04-03 — Superseded by ltc-effective-system-design-blueprint.md. Do not load. -->

---
version: "1.0"
last_updated: 2026-03-29
owner: ""
---
# Effective System Design — Quick Reference
> LTC Global Framework — applies to ALL projects.

## What is it?
The universal model for designing any system. 8 components: EI, EU, EA, EO, EP, EOE, EOT, EOP.
Core equation: `EO = f(EI, EU, EA, EP, EOE, EOT, EOP)`
Core principle: Success = Efficient & Scalable Management of Failure Risks (S > E > Sc)

## When to use
- Before designing any system, writing any spec, or performing force analysis
- During ALIGN stage to identify forces (UBS/UDS)
- During PLAN stage to translate learning into architecture

## Canonical sources
| Source | What it contains | When to load |
|--------|-----------------|--------------|
| `_genesis/reference/ltc-effectiveness-guide.md` | 10 Ultimate Truths + 8-component template + full recursive ESD structure | During LEARN — foundational philosophy |
| `_genesis/reference/ltc-effective-system-design.md` | 3-stage ESD methodology (Problem→Design→Requirements), VANA grammar, A.C. specs, iteration gates | During PLAN — translating learning to requirements |
| `rules/general-system.md` | Agent-distilled version: 8-component formula, RACI, force analysis, boundary spec | Always-loaded via CLAUDE.md |

## Key concepts (summary only — see canonical sources for full spec)
- **8 Universal Components:** EI (Inputs), EU (User), EA (Action), EO (Outcome), EP (Principles), EOE (Environment), EOT (Tools), EOP (Procedure)
- **Force Analysis:** UBS (blocks success) vs UDS (drives success) — recursive dot-notation (UBS.UB, UBS.UD, etc.)
- **3 Pillars:** Sustainability > Efficiency > Scalability — priority order, never reversed
- **VANA Grammar:** Verb + Adverb + Noun + Adjective — each with binary A.C.s
- **Iteration Gates:** Iteration 1(Concept/Sustainability) → Iteration 2(Prototype/Efficiency) → Iteration 3(MVE/Scalability) → Iteration 4(Leadership)

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[architecture]]
- [[general-system]]
- [[iteration]]
- [[ltc-effective-system-design]]
- [[ltc-effective-system-design-blueprint]]
- [[ltc-effectiveness-guide]]
- [[methodology]]
