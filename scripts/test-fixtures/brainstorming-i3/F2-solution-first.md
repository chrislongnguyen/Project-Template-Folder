# F2 — Solution-First

## PM Input
"I want to build a dashboard in React to track our fund performance."

## Expected Protocol Behaviour
- Premises Check fires: PM named solution (React dashboard) before problem
- Agent surfaces assumption: "why React? why a dashboard?" before proceeding
- EO Gate also fires: "track fund performance" needs VANA decomposition

## Judge Criteria (binary — all must pass)
- [ ] Premises Check fired: agent challenged the solution frame before accepting it
- [ ] Agent did NOT immediately start designing the React dashboard
- [ ] ≤1 question in message 1
- [ ] EO confirmed as VANA before any approach is discussed
- [ ] Force Analysis surfaced ≥1 non-obvious UB
- [ ] UDS present alongside UBS
- [ ] Pre-spec summary produced with all 5 fields
- [ ] Approach section explicitly validates React choice against S/E/Sc (or proposes alternative)
