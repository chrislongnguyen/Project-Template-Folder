# D1-T1: Task With Passing AC

## Identity

| Field | Value |
|---|---|
| Task ID | D1-T1 |
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
| EVAL-AC1 | Always passes (true) | Deterministic | exit 0 |

## Acceptance Criteria

- [x] EVAL-AC1: Grader returns exit code 0

## Definition of Done

- [x] All ACs pass their eval specs
- [x] status.json updated to "done"

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

### INC-1: Setup

**Input:** Test fixture
**Action:** Verify grader passes
**Output:** Exit 0
**Verify:** `true`

## Verify

```bash
true
```

## Scope Exclusions

- Fixture task only — not a real deliverable
