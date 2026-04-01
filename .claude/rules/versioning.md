---
version: "1.2"
status: Draft
last_updated: 2026-03-31
---
# Versioning — Always-On Rule

Full spec: `_genesis/frameworks/HISTORY_VERSION_CONTROL.md` | Registry: `0-GOVERN/VERSION_REGISTRY.md`

## Required Metadata by File Type

- **Markdown (`.md`):** YAML frontmatter with `version`, `status`, `last_updated`
- **Shell/Python (`.sh`, `.py`):** Comment header `# version: X.Y | status: Draft | last_updated: YYYY-MM-DD`
- **HTML:** `<meta>` tags for version, status, last-updated
- **JSON/YAML/TOML config, binaries:** Exempt — git history is sufficient

## LTC Version Number Convention

```
MAJOR = iteration number. I1 = 1.x  |  I2 = 2.x  |  NEVER use 0.x or semver.
MINOR = edit count within the iteration. Starts at 0 for every new file.

New file in I1          → version: "1.0"  ALWAYS. Never "0.1", never "2.0".
Committed file at 1.Y   → meaningful edit → bump to 1.(Y+1)
Uncommitted rewrite     → same version (was never committed at the prior number)
Whitespace / typo only  → no bump
```

Git tags use `v{ITERATION}.0.0` format (e.g., v1.0.0 = I1 merged to main). File versions and git tags are separate systems.

## The 3 Fields

| Field | What it tracks | Who sets it |
|-------|---------------|-------------|
| `version` | Committed content state (MAJOR.MINOR per convention above) | Agent |
| `status` | Lifecycle: `Draft` \| `Review` \| `Approved` | Agent sets Draft/Review. **Human ONLY sets Approved.** |
| `last_updated` | Today's absolute date (YYYY-MM-DD) | Agent — update on every edit |

## Status Lifecycle

```
Draft ──→ Review ──→ Approved
  ↑          ↑           ↑
Agent      Agent      HUMAN ONLY
creates    requests   (Agent NEVER
& edits    review      self-approves)
```

- New files start as `Draft`
- Editing an `Approved` file → new version, reset to `Draft`

## After Editing Any Zone Artifact

Update the corresponding row in `0-GOVERN/VERSION_REGISTRY.md` — version, status, and date.

## Pre-Commit Checklist

1. `version` — follows 1.x (I1) convention, bumped only if previously committed
2. `status` — not prematurely `Approved`
3. `last_updated` — today's absolute date
4. `0-GOVERN/VERSION_REGISTRY.md` — row updated if this is a zone artifact

## PR-Level Requirements

- `VERSION` (root) updated with every PR
- `5-IMPROVE/changelog/CHANGELOG.md` updated with every PR

## Common Mistakes

| Mistake | Correct behavior |
|---------|-----------------|
| Using `version: "2.0"` for I1 content | I1 = 1.x always. 2.x is for I2. |
| Using `version: "0.1"` | LTC does not use 0.x. New file in I1 = "1.0". |
| Bumping version on uncommitted rewrite | No bump — it was never committed at the prior number |
| Setting `status: Approved` without human | Only human approves. Agent sets Draft or Review. |
| Forgetting `status` field | All three fields required: version + status + last_updated |
| Relative dates ("today") | Always absolute: 2026-03-31 |
| Skipping VERSION_REGISTRY update | Every zone artifact edit must update the registry row |
