# Iteration Page Body Template

Use this template for the page body content when creating an Iteration in the Master Plan DB.
Replace all `{placeholders}` with actual values. Remove this instruction block before writing.

Detail level: **RICH** — Iterations define the build cycle scope. Invest in clarity here.

## Standard Iteration Names (ILE Framework)

| Iteration | Name          | Focus |
| --------- | ------------- | ----- |
| I1        | **Concept**   | Sustainability — correct, safe, risk-managed. Does the right thing work? |
| I2        | **Prototype** | Efficiency — fast, lean, minimal waste. Does it work well? |
| I3        | **MVE**       | Scalability — handles growth, load, edge cases. Does it work at scale? |
| I4        | **Leadership**| Desirability — delightful, differentiated. Does it stand out? |

Each Iteration gates the next: no I2 work begins until all I1 `Must Have` ACs pass.

---

Parent Project: {Parent Task link to parent Project}

## Context

{1-2 sentences: what this build cycle aims to accomplish, what triggered it, and how it fits in the overall project timeline}

## Desired Outcomes (VANA)

| Element       | Statement     |
| ------------- | ------------- |
| **Verb**      | {action}      |
| **Adverb**    | {how/quality} |
| **Noun**      | {artefact}    |
| **Adjective** | {qualities}   |

**Full VANA:** {User} {Verb} {Adverb} {Noun} that is {Adjective}.

## Acceptance Criteria Verification

| AC     | Description              | Status      |
| ------ | ------------------------ | ----------- |
| AC-V   | {verb criterion}         | PASS / FAIL |
| AC-Adv | {quality criterion}      | PASS / FAIL |
| AC-N   | {artefact exists}        | PASS / FAIL |
| AC-Adj | {quality properties met} | PASS / FAIL |

> Iteration ACs = sum of all child Deliverable ACs (MECE). Every Deliverable AC must trace to an Iteration AC.

## Child Deliverables

| # | Deliverable | Priority | Status | Key ACs |
|---|-------------|----------|--------|---------|
| DEL-1 | {title} | {priority} | {status} | {1-line AC summary} |
| DEL-2 | {title} | {priority} | {status} | {1-line AC summary} |

## Dependencies

- **Blocked by:** {link(s) to items that must complete first, or "None"}
- **Blocking:** {link(s) to items that depend on this, or "None"}

## Action Plan

1. {step — reference specific Deliverables if known}
2. {step}
3. {step}

## What Was Delivered

{**Mandatory at completion.** Fill when Status -> Done. Link to every artifact produced.}

- {e.g., DEL-1: [Scaffold](notion-url) -- project structure + DVC init}
- {e.g., DEL-2: [Acquisition Pipeline](notion-url) -- data ingestion working}
