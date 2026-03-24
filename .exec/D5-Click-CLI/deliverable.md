# D5: Click CLI

## Identity

| Field | Value |
|---|---|
| Deliverable ID | D5 |
| Project | LTC Memory Engine v2.0 (I1) |
| Spec Version | v1 |
| Plan Section | plan.md L1618-L2162 |
| Agent Architecture | Single Agent |
| Status | blocked |

## VANA Sentence

Every LTC member can interact with the memory engine from the terminal via `memory write`, `memory read`, `memory stats`, `memory audit`, `memory setup` — with JSON output, help examples, and human-readable error messages.

## Acceptance Criteria

| AC ID | Criteria | Eval Type | Covered By Tasks |
|---|---|---|---|
| N-W2 | CLI with write, read, update, delete, stats, audit, config, setup — --json and --quiet | Deterministic | D5-T1 |
| Adj-W2 | Every command has --help with usage examples | Deterministic | D5-T1 |
| Adj-W3 | Exit code 0/1, human-readable errors with fix suggestions | Deterministic | D5-T1 |
| V-10 | Install in under 5 minutes | Manual | D5-T2 |
| V-11 | memory stats + memory audit show health | Deterministic | D5-T2 |
| N-W3 | 11-step idempotent setup wizard | Deterministic | D5-T2 |
| N-W4 | memory stats + memory audit in JSON | Deterministic | D5-T2 |
| A-E1 | Setup < 5 min, zero manual config | Manual | D5-T2 |
| A-E4 | Setup idempotent — running twice = identical state | Deterministic | D5-T2 |
| Adj-W4 | Setup no partial state on failure | Deterministic | D5-T2 |
| Adj-W5 | memory stats ≤ 30 lines | Deterministic | D5-T2 |

## Child Tasks

| Task ID | Name | Status | Dependencies |
|---|---|---|---|
| D5-T1 | Core CLI Commands | blocked | D2-T1, D4-T1, D4-T3 |
| D5-T2 | Setup Wizard + Integration Test | blocked | D5-T1 |

## Scope

- **In scope:** cli.py (Click group with write, read, update, delete, stats, audit, config, setup), test_cli.py
- **Out of scope:** hook registration (I3), cron setup (I3), import CLI (I3), teardown (I4)
