# D1-T1: Setup Database

## Identity

| Field | Value |
|---|---|
| Task ID | D1-T1 |
| Deliverable | D1: Foundation |
| Spec Version | v1 |
| Plan Section | plan.md L10-L30 |
| Agent Pattern | Single Agent |
| Agent Model | Sonnet |
| Status | ready |
| Rework Count | 0 |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| Found-AC1 | Database schema created | Deterministic | Exit code 0 |

## Acceptance Criteria

- [ ] AC-1: Database schema file exists at db/schema.sql
- [ ] AC-2: Schema validates with no syntax errors

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L10-L30 |
| Spec ACs | vana-spec.md §2 |
| Related Tasks | none |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| Spec requirements | docs/spec.md | Markdown | Human-reviewed |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| Application layer | db/schema.sql | SQL DDL | sqlite3 syntax check |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | none | n/a |
| blocks | none | n/a |

## Environment

| Prerequisite | Verify Command |
|---|---|
| Python 3.11+ | `python3 --version` |
| SQLite3 | `sqlite3 --version` |

## Increments

### INC-1: Create Schema File

**Input:** Spec requirements from docs/spec.md
**Action:** Create db/schema.sql with table definitions
**Output:** db/schema.sql file
**Verify:** `test -f db/schema.sql`

### INC-2: Validate Schema

**Input:** db/schema.sql from INC-1
**Action:** Run SQLite3 syntax check
**Output:** Validation result
**Verify:** `sqlite3 :memory: < db/schema.sql`

## Verify

```bash
test -f db/schema.sql && sqlite3 :memory: < db/schema.sql
```

## Scope Exclusions

- Does NOT create the database instance
- Does NOT insert seed data
- Boundary: D1-T2 handles migrations (if it existed)
