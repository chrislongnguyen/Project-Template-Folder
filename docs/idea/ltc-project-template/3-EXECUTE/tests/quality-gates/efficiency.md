# QUALITY GATE: EFFICIENCY
## "Does it use resources wisely?"
### Derived From: Derived Truth #1 — Pillar 2

---

## Checklist

### Code Efficiency
- [ ] No dead code or unused imports
- [ ] No redundant computations (results cached where appropriate)
- [ ] Algorithms use appropriate data structures
- [ ] Database queries are optimized (no N+1 queries, proper indexing)

### Resource Efficiency
- [ ] Memory usage is within expected bounds
- [ ] No memory leaks (connections, file handles, event listeners properly cleaned up)
- [ ] Network calls are minimized (batching, caching, pagination)
- [ ] Build artifacts are appropriately sized

### Process Efficiency
- [ ] CI/CD pipeline completes in acceptable time
- [ ] Development loop is fast (hot reload, incremental builds)
- [ ] No unnecessary manual steps in deployment
- [ ] Tests run in parallel where possible

### Cognitive Efficiency
- [ ] Code is readable without excessive comments
- [ ] Naming is clear and consistent
- [ ] Functions have single responsibility
- [ ] Complex logic is broken into well-named helper functions

---

**Key Principle:** Efficiency is the leanest path to quality, not the cheapest path to "done."
