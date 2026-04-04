---
type: ues-deliverable
version: "2.1"
status: validated
last_updated: 2026-04-04
work_stream: 2-learn
stage: validate
sub_system: 1-PD
iteration: I2
owner: "Long Nguyen"
---
# Research — Portfolio Risk Models

## Research Question

What risk models are appropriate for a mixed-asset portfolio of Vietnamese equities, USD bonds, and commodity ETFs?

## Findings Summary

Three model families evaluated: Historical Simulation VaR, Parametric (Gaussian) VaR, and CVaR (Expected Shortfall).

| Model | Pros | Cons | Fit for LTC |
|-------|------|------|-------------|
| Historical Simulation VaR | Captures fat tails, no distribution assumption | Requires 2Y+ history; slow for large portfolios | Good — we have 3Y data |
| Parametric VaR | Fast, analytically tractable | Underestimates tail risk for skewed assets | Poor — VN equities are skewed |
| CVaR (Expected Shortfall) | Regulator-preferred; coherent risk measure | More compute; harder to explain to PMs | Best — aligns with I2 efficiency goal |

## Recommendation

Implement CVaR at 95% and 99% confidence levels using Historical Simulation. Display both on the dashboard. Parametric VaR kept as secondary sanity check.

## Sources

- MSCI Risk Model Documentation v3.2
- BIS Working Paper: "Expected Shortfall in Basel III" (2016)
- Internal LTC Risk Committee memo, 2026-02-12

## Effective Principles Derived

- EP-PD-01: Use CVaR as primary risk measure; VaR as secondary disclosure
- EP-PD-02: Minimum lookback window = 500 trading days

## Links

- [[CHARTER]]
- [[ARCHITECTURE]]
- [[UBS_REGISTER]]
