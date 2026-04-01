# LTC System Design

> For AntiGravity and other AAIF-compatible agents. Full spec: `rules/general-system.md`

## 6-Component Model (UT#1)
`Outcome = f(Input, User, Action, Principles, Tools, Environment)`
- **Input** — task-specific data; sets output ceiling
- **User/Doer** — executes the work (human or agent)
- **Action** — observable execution (emergent — diagnose only)
- **Principles** — rules governing correct operation
- **Tools** — extend doer capabilities
- **Environment** — workspace config, permissions, limits

## RACI — Establish Before Analysis
- **R** (Responsible): who does the work — **A** (Accountable): who owns the outcome
- When R = AI Agent: define Always/Ask/Never behavioral boundaries
- UBS/UDS must be analyzed from both R and A perspectives

## Force Analysis — UBS Then UDS
- **UBS first** (derisk): blocking forces. Sub-forces: UBS.UB (weakens blocker), UBS.UD (strengthens it)
- **UDS second** (drive): enabling forces. Sub-forces: UDS.UD (strengthens driver), UDS.UB (weakens it)

## System Boundaries (4 layers)
1. **What Flows:** AC, data, physical/human/financial resources
2. **Contract:** Source, Schema, Validation, Error, SLA, Version
3. **Eval Spec:** Type + Dataset + Grader + Threshold per AC
4. **Failure Modes:** Recovery, Escalation, Degradation, Timeout

## Design Methodology (ESD)
Phase 1: Problem Discovery → Phase 2: System Design → Phase 3: VANA Requirements (binary ACs)

## Links

- [[DESIGN]]
- [[blocker]]
- [[general-system]]
- [[methodology]]
