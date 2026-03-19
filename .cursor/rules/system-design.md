---
description: System design methodology for building and analyzing systems
globs: **/*
---

# System Design

Full spec: `rules/general-system.md`

## 6-Component Model (UT#1 — every system, no exceptions)
`Outcome = f(Input, User, Action, Principles, Tools, Environment)`

## RACI First
Establish R (Responsible) and A (Accountable) BEFORE analyzing forces. UBS/UDS differ by role perspective — analyze both: UBS(R), UBS(A), UDS(R), UDS(A).

## Force Analysis — UBS then UDS
- **UBS** (blockers) analyzed first — derisk before driving output
- **UDS** (drivers) analyzed second — amplify after risks managed
- Forces are recursive: UBS.UB (weakens blocker), UBS.UD (strengthens blocker), etc.

## Principles Trace to Forces
Every principle MUST map to a UBS or UDS element. Priority: Sustainability > Efficiency > Scalability.

## System Boundaries (4 layers)
1. **What Flows** — AC, data, physical/human/financial resources
2. **How It Flows** — schema, validation, error, SLA, version contracts
3. **How You Verify** — eval spec per AC (deterministic / manual / AI-graded)
4. **How It Fails** — recovery, escalation, degradation, timeout

## ESD Methodology
Phase 1 (Problem Discovery) → Phase 2 (System Design) → Phase 3 (VANA Requirements) → Build → Test
