# Pre-Creation Checklist and Regex

Source: `rules/naming-rules.md` §6.

## Regex (Canonical Key)

**2-part (top-level, no parent):**

```regex
^[A-Z][A-Z0-9_]*_[A-Z]{2,3}\.[0-9]+(\.[0-9]+)*\.[A-Z][A-Z0-9-]*$
```

**3-part (child with parent):**

```regex
^[A-Z][A-Z0-9_]*_[A-Z]{2,3}\.[0-9]+(\.[0-9]+)*\.[A-Z][A-Z0-9-]*_[A-Z0-9]+\.[A-Z][A-Z0-9-]*$
```

## 8 steps (before creating any named item)

1. **Determine form** — Parent present? → 3-part (default). True top-level only? → 2-part.
2. **Compose** Canonical Key from SCOPE + (PARENT +) ITEM.
3. **Validate** against the matching regex above.
4. **Verify** SCOPE exists in Table 3a (`rules/naming-rules.md` §4).
5. **Verify** FA exists in Table 3b (`rules/naming-rules.md` §5).
6. **Check** Git length **≤ 50** characters for repos (2-part); abbreviate per §3 platform rules if needed.
7. **Render** to target platform (Section 3 in rules doc).
8. **Check** collisions on the target platform — disambiguate NAME or append `-NN` as last resort; **HALT** and ask if unresolved.
