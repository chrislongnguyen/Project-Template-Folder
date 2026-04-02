# {Deliverable-ID}-{Task-ID}: {Task Name}

## Identity

| Field | Value |
|---|---|
| Task ID | D{n}-T{m} |
| Deliverable | D{n}: {Deliverable Name} |
| Spec Version | v{x} |
| Plan Section | plan.md L{start}-L{end} |
| Agent Pattern | {Single Agent | Sub-Agents | Agent Team} |
| Agent Model | {Opus | Sonnet | Haiku} |
| Status | {ready | blocked | in_progress | done | rework | failed} |
| Rework Count | {0} |

## VANA Traceability

| A.C. ID | Criteria (short) | Eval Type | Threshold |
|---|---|---|---|
| {AC-ID} | {criteria} | {type} | {threshold} |

## Acceptance Criteria

- [ ] AC-1: {binary, deterministic criterion}
- [ ] AC-2: {binary, deterministic criterion}

## Definition of Done

- [ ] All ACs pass their eval specs
- [ ] Code reviewed (self-review or peer)
- [ ] No regressions in dependent tasks
- [ ] status.json updated to "done"
- [ ] WMS synced

## References

| Reference | Location |
|---|---|
| Plan Section | plan.md L{start}-L{end} |
| Spec ACs | vana-spec.md §{section} |
| Related Tasks | D{n}-T{x}, D{n}-T{y} |

## I/O Contract

### Inputs

| Source | Path / Interface | Schema | Validation |
|---|---|---|---|
| {upstream task or external} | {concrete file path or API} | {shape} | {rule} |

### Outputs

| Consumer | Path / Interface | Schema | Validation |
|---|---|---|---|
| {downstream task or external} | {concrete file path or API} | {shape} | {rule} |

## Dependencies

| Direction | Task ID | Condition |
|---|---|---|
| blocked_by | D{n}-T{x} | {what must be true} |
| blocks | D{n}-T{y} | {what this provides} |

## Environment

| Prerequisite | Verify Command |
|---|---|
| {e.g., Node.js >= 18} | `node --version` |
| {e.g., database running} | `pg_isready` |

## Increments

### INC-1: {Increment Name}

**Input:** {what this increment reads}
**Action:** {what the agent does}
**Output:** {what this increment produces}
**Verify:** {how to check it worked}

### INC-2: {Increment Name}

**Input:** {from INC-1 output}
**Action:** {what the agent does}
**Output:** {what this increment produces}
**Verify:** {how to check it worked}

## Verify

```bash
{test command that proves this task is complete}
```

## Scope Exclusions

- {explicitly what this task does NOT do}
- {boundary with adjacent tasks}

## Links

- [[deliverable]]
- [[increment]]
