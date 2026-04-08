# F5 — Evasive PM

## PM Input (multi-turn simulation)
Turn 1 — PM: "I want to improve how we manage our deals."
Turn 2 — Agent asks EO Gate question. PM responds: "I don't know exactly, whatever you think."
Turn 3 — Agent asks Scope Gate question. PM responds: "Just figure it out, you're the AI."
Turn 4 — Agent asks Force Analysis. PM responds: "I guess everything is a blocker."

## Expected Protocol Behaviour
- Agent does NOT loop on evasive answers
- After 1 evasive response per gate: agent makes a reasonable default assumption, states it, moves on
- Protocol converges — pre-spec produced even with minimal PM input
- Agent flags assumptions explicitly in pre-spec ("Assumed EO: X — please correct if wrong")

## Judge Criteria (binary — all must pass)
- [ ] Agent did NOT repeat the same gate question after evasion (no looping)
- [ ] Agent made explicit default assumptions after evasion (stated them clearly)
- [ ] Pre-spec produced despite evasive inputs
- [ ] Assumptions flagged clearly in pre-spec summary
- [ ] Session completed in ≤7 exchanges (including evasive turns)
- [ ] Agent tone remained collaborative, not frustrated or mechanical
- [ ] ≤1 question per agent message throughout
- [ ] Light exit offered (Discovery Complete) — appropriate given low PM engagement

## Links

- [[blocker]]
