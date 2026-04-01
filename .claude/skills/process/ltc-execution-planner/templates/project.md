# Project: {Project Name}

## Execution Topology

| Deliverable | Tasks | Critical Path | Agent Architecture |
|---|---|---|---|
| D1: {name} | T1, T2, T3 | T1 → T2 → T3 | Sub-Agents |
| D2: {name} | T1, T2 | T1 → T2 (parallel with D1) | Single Agent |

## Agent Architecture Decision

| Deliverable | Task Count | Max Complexity | Decision | Rationale |
|---|---|---|---|---|
| D1 | 3 | Medium (7 steps) | Sub-Agents | Medium on both dimensions |
| D2 | 2 | Low (3 steps) | Single Agent | Low on both dimensions |

## Dependency Graph

{ASCII or Mermaid diagram showing task execution order}

## Version History

| Version | Date | Trigger | Changes |
|---|---|---|---|
| v1 | 2026-03-22 | Initial generation | Full .exec/ created from plan v1 |

## Links

- [[deliverable]]
- [[task]]
