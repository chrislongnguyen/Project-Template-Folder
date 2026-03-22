# D1-T3: Task With Manual AC

## Identity

| Field | Value |
|---|---|
| Task ID | D1-T3 |
| Deliverable | D1: EvalTest |
| Spec Version | v1 |
| Plan Section | eval-spec.md L1-L10 |
| Agent Pattern | Single Agent |
| Agent Model | Sonnet |
| Status | done |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| EVAL-AC3 | Human review of output quality | Manual | 80% |
| EVAL-AC4 | LLM coherence check | AI-Graded | 0.9 |

## Acceptance Criteria

- [ ] EVAL-AC3: Human Director reviews and approves quality
- [ ] EVAL-AC4: AI judge scores coherence >= 0.9

## Definition of Done

- [ ] All ACs reviewed by Human Director (manual)
- [ ] AI-graded ACs deferred to iteration 2

## References

| Reference | Location |
|---|---|
| Plan Section | eval-spec.md L1-L10 |
| Spec ACs | eval-spec.md §7 |
| Related Tasks | none |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| Test fixture | tests/fixtures/ | Markdown | n/a |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| Eval runner | status.json | JSON | Schema |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | none | n/a |
| blocks | none | n/a |

## Environment

| Prerequisite | Verify Command |
|---|---|
| Python 3.11+ | `python3 --version` |

## Increments

### INC-1: Manual Review

**Input:** Task output
**Action:** Human Director evaluates against rubric
**Output:** Pass/Fail judgment
**Verify:** Human sign-off

## Verify

Human Director must approve.

## Scope Exclusions

- Fixture task only — not a real deliverable
