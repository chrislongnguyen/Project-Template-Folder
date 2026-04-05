---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 2-LEARN
stage: build
type: readme
sub_system: 1-PD
iteration: 2
---

# LEARN / PD — Problem Diagnosis Learning

Research and knowledge artifacts for the Problem Diagnosis subsystem.

## Cascade Position

PD is the upstream anchor of the LEARN pipeline.

- Upstream: none (PD is the entry point)
- Downstream: DP, DA, IDM — all consume PD's UBS/UDS findings as constraints

PD learning outputs define which problem states are valid, which principles govern the domain, and which risks must be inherited by downstream subsystems.

## Contents

| Artifact Type | Naming Pattern | Purpose |
|---|---|---|
| UBS Analysis | `pd-ubs-analysis.md` | Unintended Bad State register for PD scope |
| Effective Principles | `pd-effective-principles.md` | Principles extracted from PD research |
| Problem Domain Literature | `pd-lit-{topic}.md` | Domain-specific research summaries |
| Constraint Spec | `pd-constraints.md` | Derived constraints passed to DP/DA/IDM |

## Routing

Outputs from this directory feed `1-ALIGN/` (charter constraints) and `3-PLAN/risks/` (risk register seeds).
