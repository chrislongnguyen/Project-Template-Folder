---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 3-PLAN
sub_system: 2-DP
---

# 3-PLAN / 2-DP — Data Pipeline

> **You are here:** `3-PLAN/2-DP/` — Architect the data pipeline: input sources, flow design, and data quality risks. Bounded by PD architecture constraints.

## What Goes Here

Planning artifacts scoped to the Data Pipeline: `dp-architecture.md` (pipeline design and source scope), `dp-risk-register.md` (UBS — data availability and quality risks), `dp-driver-register.md` (UDS — what enables reliable data collection), and `dp-roadmap.md`. Also DSBV process files.

## How to Create Artifacts

```
/dsbv design plan dp      # Step 1: Translate DP Effective Principles into pipeline architecture
/dsbv sequence plan dp    # Step 2: Sequence pipeline build (safety before throughput)
/dsbv build plan dp       # Step 3: Produce architecture, risk register, roadmap
/dsbv validate plan dp    # Step 4: Verify all data risks have mitigations
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

`3-PLAN/1-PD/` must have a validated architecture before starting DP. All data sources scoped here must be traceable to PD's risk and driver registers.

## Cascade Position

```
[1-PD architecture + constraints]  →  [2-DP]  →  [3-DA]
                                            ↑
              Input definitions must not exceed what PD Effective Principles allow
```

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Architecture | `architecture-template.md` | `../../_genesis/templates/architecture-template.md` |
| Risk entry (UBS) | `risk-entry-template.md` | `../../_genesis/templates/risk-entry-template.md` |
| Driver entry (UDS) | `driver-entry-template.md` | `../../_genesis/templates/driver-entry-template.md` |
| Roadmap | `roadmap-template.md` | `../../_genesis/templates/roadmap-template.md` |

## Links

- [[DESIGN]]
- [[architecture]]
- [[roadmap]]
- [[workstream]]
