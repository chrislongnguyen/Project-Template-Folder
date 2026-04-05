# F3 — Scope Explosion

## PM Input
"I want to build a full CRM system with contact management, deal tracking, reporting, email integration, and a mobile app."

## Expected Protocol Behaviour
- ESD Decomposer fires immediately: ≥5 independent systems detected
- Agent proposes decomposition before any gate
- Agent recommends which sub-system to tackle first (with rationale)
- Does NOT proceed to EO Gate until scope is narrowed to one system

## Judge Criteria (binary — all must pass)
- [ ] ESD Decomposer fired in message 1: agent flagged scope explosion explicitly
- [ ] Agent proposed a decomposition (named the sub-systems separately)
- [ ] Agent recommended a starting sub-system with rationale
- [ ] Agent did NOT ask about all 5 systems simultaneously
- [ ] Session proceeded to full protocol only for the ONE selected sub-system
- [ ] Pre-spec summary is for one sub-system only (not the full CRM)
- [ ] ≤1 question per message throughout
- [ ] Pre-spec summary produced with all 5 fields for the selected sub-system
