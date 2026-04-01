# Gotchas — ltc-rules-compliance

1. **Silent PASS with missing source** — Marking PASS when a canonical rules file was unavailable creates false compliance. Use `BLOCKED` for that family and request source restoration or user decision.

2. **Duplicating specialist logic** — Re-implementing brand/naming checks here causes drift from their dedicated skills. Route deep checks to `ltc-brand-identity` and `ltc-naming-rules`, then summarize outcomes.

3. **No actionable remediation** — Reporting FAIL without next steps leaves users stuck. Every FAIL needs at least one concrete action and re-check trigger.

4. **Over-scoping every check** — Forcing all families on all tasks wastes time and causes noise. Use `NOT APPLICABLE` explicitly when a family is out of scope.

5. **Security gate bypass** — Ignoring HIGH-risk confirmation requirements from `rules/security-rules.md` invalidates compliance. Always state whether explicit confirmation was present.

## Links

- [[security]]
- [[security-rules]]
