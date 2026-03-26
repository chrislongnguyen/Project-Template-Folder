# QUALITY GATE: SCALABILITY
## "Does it hold at 10× load?"
### Derived From: Derived Truth #1 — Pillar 3

---

## Checklist

### Data Scalability
- [ ] No hardcoded limits on data volume
- [ ] Pagination implemented for large data sets
- [ ] Database schema supports partitioning/sharding if needed
- [ ] File storage strategy handles growth (not filling a single disk)

### Compute Scalability
- [ ] Services are stateless (can be horizontally scaled)
- [ ] No in-memory state that would be lost on restart
- [ ] Background jobs use queues, not synchronous processing
- [ ] Rate limiting and throttling protect against overload

### Configuration Scalability
- [ ] No magic numbers — all limits are configurable
- [ ] Environment-specific settings are externalized
- [ ] Feature flags allow incremental rollout
- [ ] Monitoring scales with the system (alerts, dashboards)

### Team Scalability
- [ ] Code is modular — new contributors can work independently
- [ ] Documentation supports onboarding without tribal knowledge
- [ ] API contracts are versioned
- [ ] Test suite runs reliably without manual setup

---

**Key Principle:** Design for the next order of magnitude. If you expect 1K users, test at 10K.
