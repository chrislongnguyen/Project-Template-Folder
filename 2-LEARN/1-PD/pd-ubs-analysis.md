---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 2-LEARN
stage: build
type: ubs-analysis
sub_system: 1-PD
iteration: 2
---

# PD — UBS Analysis

Unintended Bad State register for the Problem Diagnosis subsystem. Identifies failure modes in problem framing, diagnosis scope, and constraint derivation.

## UBS Register

| ID | Description | Likelihood | Impact | Mitigation |
|---|---|---|---|---|
| UBS-PD-01 | Problem scope defined too broadly — diagnosis covers territory outside project mandate | Medium | High | Validate scope against charter EO before finalizing |
| UBS-PD-02 | Root cause misattributed — symptom treated as cause, correct intervention missed | Medium | High | Apply 5-Why and causal chain verification |
| UBS-PD-03 | Stakeholder mental models diverge — different teams diagnose the same problem differently | High | Medium | Surface assumptions early; align on shared problem statement |
| UBS-PD-04 | Constraints not passed downstream — DP/DA/IDM proceed without PD's limiting findings | Low | High | Maintain pd-constraints.md; review before DP kickoff |
| UBS-PD-05 | Literature review omitted — diagnosis relies on intuition rather than documented evidence | Medium | Medium | Require at least one pd-lit-*.md per domain area |

## Analysis Method

UBS entries are derived through three inputs:

1. Prior incident review — what went wrong in previous diagnosis cycles
2. Stakeholder assumption mapping — surface unstated beliefs about the problem
3. Constraint tracing — verify that all PD findings propagate to downstream subsystems

Likelihood: High / Medium / Low. Impact: High / Medium / Low.
Reassess UBS register at each DSBV cycle boundary.

## Links

- Constraint outputs: `pd-constraints.md` (when created)
- Risk Register: `3-PLAN/risks/UBS_REGISTER.md`
- Charter: `1-ALIGN/charter/`
