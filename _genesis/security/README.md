---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# security/ — PROTECTION

**Purpose:** Security standards that protect LTC data, systems, and operations.

**Cascade position:** Derived layer — applies protective constraints across all workstreams and projects.

```
philosophy → principles → frameworks → [security as derived protection layer]
```

## Contents

| File | Description |
|------|-------------|
| SECURITY_HIERARCHY.md | 3-layer defense model + 6 security rules + blast-radius model |
| DATA_CLASSIFICATION.md | 5-level data classification scheme (PUBLIC → TOP SECRET) |
| NAMING_CONVENTION.md | Universal Naming Grammar (UNG) for all platforms and tools |

## Rules

- NEVER hardcode secrets in source, prompts, or tool arguments
- HIGH risk actions require explicit human confirmation before execution
- Operate within project dir only — prefer reversible actions

---

**Classification:** INTERNAL
