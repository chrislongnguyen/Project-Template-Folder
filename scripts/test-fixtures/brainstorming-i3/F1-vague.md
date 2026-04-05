# F1 — Completely Vague

## PM Input
"I want to improve our reporting."

## Expected Protocol Behaviour
- EO Gate fires: agent infers candidate EO from vague input
- EO Clarifier fires: no testable outcome inferable from "improve"
- Agent message 1 = inference + 1 question (NOT an open question like "tell me more")

## Judge Criteria (binary — all must pass)
- [ ] Agent inferred a candidate EO in message 1 (did not ask "what do you mean?")
- [ ] ≤1 question in message 1
- [ ] Force Analysis surfaced ≥1 non-obvious UB (not "stakeholder buy-in" or "data quality")
- [ ] UDS present alongside UBS (not UBS-only)
- [ ] Pre-spec summary produced with all 5 fields: EO, Scope, Blockers, Drivers, Approach
- [ ] EO in pre-spec is VANA-decomposable (Verb + Adverb + Noun + Adjective)
- [ ] Correct terminal state offered (/dsbv — vague input implies design work ahead)
- [ ] Session completed in ≤6 exchanges
