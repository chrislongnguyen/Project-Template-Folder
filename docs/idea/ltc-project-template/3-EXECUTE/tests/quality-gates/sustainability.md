# QUALITY GATE: SUSTAINABILITY
## "Does it handle failure gracefully?"
### Derived From: Derived Truth #1 — Pillar 1

---

## Checklist

### Error Handling
- [ ] All external calls (API, DB, file I/O) have error handling
- [ ] Errors produce meaningful messages (not generic "something went wrong")
- [ ] Failed operations do not leave the system in an inconsistent state
- [ ] Retry logic exists for transient failures

### Failure Recovery
- [ ] System can recover from crash without data loss
- [ ] Database transactions are atomic (commit or rollback, never partial)
- [ ] Circuit breakers exist for external dependencies
- [ ] Health checks are implemented

### Resilience
- [ ] No single points of failure in the architecture
- [ ] Graceful degradation: core functionality works even when non-critical services fail
- [ ] Timeout values are explicitly set (not defaulting to infinity)
- [ ] Resource cleanup happens even on failure (finally blocks, defer, etc.)

### Security Sustainability
- [ ] Authentication and authorization enforced at every entry point
- [ ] Input validation on all user-provided data
- [ ] No secrets in source code or configuration files
- [ ] Dependencies scanned for known vulnerabilities

### Documentation Sustainability
- [ ] Critical business logic has inline documentation explaining WHY, not just WHAT
- [ ] Runbooks exist for common failure scenarios
- [ ] On-call procedures are documented

---

**Key Principle:** A sustainable system survives its worst day, not just its best day.
