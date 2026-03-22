# D1-T2: Task With Failing AC

## Identity

| Field | Value |
|---|---|
| Task ID | D1-T2 |
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
| EVAL-AC2 | Always fails (false) | Deterministic | exit 0 |

## Acceptance Criteria

- [ ] EVAL-AC2: Grader returns exit code 0 (will fail — grader returns 1)

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] status.json updated to "done"

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
**Action:** Verify grader fails
**Output:** Exit 1
**Verify:** `false`

## Verify

```bash
false
```

## Scope Exclusions

- Fixture task only — not a real deliverable
