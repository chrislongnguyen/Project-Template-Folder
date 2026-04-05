# F4 — Well-Formed Input

## PM Input
"I want to build a weekly automated email digest that sends our top 5 portfolio company updates to LPs every Monday at 8am. Single system, no integrations beyond our existing CRM. Must be low-maintenance after launch."

## Expected Protocol Behaviour
- EO Gate: EO is already nearly VANA — agent confirms quickly, does not over-process
- Scope Gate: single system, no ESD Decomposer needed
- Premises Check: no solution stated — should not fire
- Fast-path: discovery completes in ≤3 exchanges (not dragged through unnecessary gates)
- Force Analysis still runs (always-on) — finds non-obvious UBs despite good input

## Judge Criteria (binary — all must pass)
- [ ] Protocol completed in ≤3 exchanges (fast-path for good input)
- [ ] ESD Decomposer did NOT fire unnecessarily
- [ ] Premises Check did NOT fire (no solution stated)
- [ ] Force Analysis still ran and surfaced ≥1 non-obvious UB
- [ ] Pre-spec summary produced with all 5 fields
- [ ] Agent did NOT invent complexity or ask unnecessary questions
- [ ] ≤1 question per message
- [ ] Correct terminal state offered (/dsbv — clear design target)
