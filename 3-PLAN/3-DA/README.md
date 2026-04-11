---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 3-PLAN
sub_system: 3-DA
---

# 3-PLAN / 3-DA — Data Analysis

> **You are here:** `3-PLAN/3-DA/` — Architect the analytical layer: stress-test the approach, prioritize risks, and produce an analysis build sequence that puts accuracy before scale.

## What Goes Here

Planning artifacts scoped to Data Analysis: `da-architecture.md` (analytical design with trade-off rationale), `da-risk-register.md` (UBS — bias, brittle logic, methodology risks), `da-driver-register.md` (UDS — validation approaches, robust methods), and `da-roadmap.md`. Also DSBV process files.

## How to Create Artifacts

```
/dsbv design plan da      # Step 1: Translate DA Effective Principles into analytical architecture
/dsbv sequence plan da    # Step 2: Sequence build (accuracy validation before scale)
/dsbv build plan da       # Step 3: Produce architecture, risk register, roadmap
/dsbv validate plan da    # Step 4: Verify analytical approach against PD framing
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`3-PLAN/2-DP/` must have a validated architecture. The DP architecture defines what analysis-ready inputs will be available, constraining analytical options here.

## Cascade Position

```
[2-DP architecture + input scope]  →  [3-DA]  →  [4-IDM]
                                            ↑
              Analytical options bounded by what DP can actually deliver
```

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Architecture | `architecture-template.md` | `../../_genesis/templates/architecture-template.md` |
| Risk entry (UBS) | `risk-entry-template.md` | `../../_genesis/templates/risk-entry-template.md` |
| Driver entry (UDS) | `driver-entry-template.md` | `../../_genesis/templates/driver-entry-template.md` |
| Roadmap | `roadmap-template.md` | `../../_genesis/templates/roadmap-template.md` |

## Links

- [[architecture]]
- [[roadmap]]
- [[workstream]]
