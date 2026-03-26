# Project: LTC Memory Engine v2.0 (I1)

## Execution Topology

| Deliverable | Tasks | Critical Path | Agent Architecture |
|---|---|---|---|
| D1: Package Scaffolding + Data Models | T1, T2 | T1 → T2 | Single Agent (Opus) |
| D2: Config + Storage Layer | T1, T2 | T1 ∥ T2 (both blocked by D1-T2) | Single Agent (Opus) |
| D3: Embedder | T1 | T1 (parallel with D2) | Single Agent (Sonnet) |
| D4: MemoryManager | T1, T2, T3 | T1 → T2 ∥ T3 | Single Agent (Opus) |
| D5: Click CLI | T1, T2 | T1 → T2 | Single Agent (Opus) |
| D6: Final Integration | T1 | T1 | Single Agent (Opus) |

## Agent Architecture Decision

| Deliverable | Task Count | Max Complexity | Decision | Rationale |
|---|---|---|---|---|
| D1 | 2 | Low (4 steps) | Single Agent | Straightforward scaffolding, no parallelism needed |
| D2 | 2 | Medium (7 tables + FTS + triggers) | Single Agent | Storage and config are tightly coupled |
| D3 | 1 | Low (3 steps) | Single Agent | Focused module, no parallelizable subtasks |
| D4 | 3 | Medium (7 type CRUD + search + validation) | Single Agent | Heart of system — needs sequential, cross-method consistency |
| D5 | 2 | Medium (8 CLI commands + setup wizard) | Single Agent | Thin wrapper over MemoryManager — needs consistent flag handling |
| D6 | 1 | Low (integration only) | Single Agent | Holistic view across all modules |

## Dependency Graph

```
D1-T1 ──→ D1-T2 ──┬──→ D2-T1 ──────────────────────────────────┐
                   │                                              │
                   ├──→ D2-T2 ──→ D4-T1 ──┬──→ D4-T2            │
                   │                       │                      │
                   ├──→ D3-T1 ──→ D4-T1    ├──→ D4-T3 ──┐       │
                   │                       │              │       │
                   │                       └──────────────┴──→ D5-T1 ──→ D5-T2 ──→ D6-T1
                   │                                              │
                   └──────────────────────────────────────────────┘

Critical Path: D1-T1 → D1-T2 → D2-T2 → D4-T1 → D4-T3 → D5-T1 → D5-T2 → D6-T1
Parallel lanes: D2-T1 ∥ D2-T2 ∥ D3-T1 (all unblocked after D1-T2)
                D4-T2 ∥ D4-T3 (both unblocked after D4-T1)
```

## Version History

| Version | Date | Trigger | Changes |
|---|---|---|---|
| v1 | 2026-03-22 | Initial generation | Full .exec/ created from plan v1 + spec v1 |
