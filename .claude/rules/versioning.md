---
version: "1.7"
status: draft
last_updated: 2026-04-09
---
# Versioning — Always-On Rule

Full spec: `_genesis/frameworks/history-version-control.md` | Registry: `_genesis/version-registry.md`

## Required Metadata by File Type

- **Markdown (`.md`):** YAML frontmatter with `version`, `status`, `last_updated`
- **Shell/Python (`.sh`, `.py`):** Comment header `# version: X.Y | status: draft | last_updated: YYYY-MM-DD`
- **HTML:** `<meta>` tags for version, status, last-updated
- **JSON/YAML/TOML config, binaries:** Exempt — git history is sufficient

## Frontmatter Value Casing

Frontmatter values MUST be lowercase — except `work_stream`, which uses numbered SCREAMING format to match folder names (e.g. `1-ALIGN`, `3-PLAN`). Obsidian Bases filters are case-sensitive; inconsistent casing causes silent query failures.

```yaml
# WRONG
status: Draft
work_stream: 1-align

# CORRECT
status: draft
iteration: 1
work_stream: 1-ALIGN
```

`work_stream` canonical values: `1-ALIGN` | `2-LEARN` | `3-PLAN` | `4-EXECUTE` | `5-IMPROVE`

YAML boolean hazard: values like `true`, `false`, `yes`, `no` are natively boolean in YAML. If used as string metadata, quote them to prevent type coercion.

```yaml
# WRONG — parsed as boolean true
reviewed: yes

# CORRECT — preserved as string
reviewed: "yes"
```

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

## The 4 Fields

| Field | What it tracks | Who sets it | Required |
|-------|---------------|-------------|----------|
| `version` | Committed content state (MAJOR.MINOR per convention above) | Agent | Yes |
| `status` | Lifecycle: `draft` \| `in-progress` \| `in-review` \| `validated` \| `archived` | Agent sets draft/in-progress/in-review. **Human ONLY sets validated.** | Yes |
| `last_updated` | Today's absolute date (YYYY-MM-DD) | Agent — update on every edit | Yes |
| `iteration_name` | Semantic label for the iteration — supplementary only | Agent | No |

`iteration_name` enum values (lowercase):

| Value | Iteration |
|-------|-----------|
| `logic-scaffold` | I0 |
| `concept` | I1 |
| `prototype` | I2 |
| `mve` | I3 |
| `leadership` | I4 |

Numeric `version` is primary (sortable, CI/CD compatible). `iteration_name` is supplementary metadata for human readability and Obsidian filtering. Never use `iteration_name` as a substitute for `version`.

Example showing both fields together:

```yaml
---
version: "1.4"
status: draft
last_updated: 2026-04-03
iteration: 1
---
```

## Status Lifecycle

```
draft ──→ in-progress ──→ in-review ──→ validated
  ↑                            ↑            ↑
Agent                        Agent       HUMAN ONLY
creates                    requests      (Agent NEVER
& edits                     review       self-approves)
```

- New files start as `draft`
- Editing a `validated` file → new version, reset to `draft`
- `archived` = end-of-life; no further edits expected

## After Editing Any Workstream Artifact

Update the corresponding row in `_genesis/version-registry.md` — version, status, and date.

## Pre-Commit Checklist

1. `version` — follows 1.x (I1) convention, bumped only if previously committed
2. `status` — S2 vocabulary: `draft` | `in-progress` | `in-review` | `validated` | `archived`. Not prematurely `validated`.
3. `last_updated` — today's absolute date
4. All frontmatter values lowercase (R4) — except `work_stream` which uses numbered SCREAMING (`1-ALIGN`)
5. `_genesis/version-registry.md` — row updated if this is a workstream artifact

## PR-Level Requirements

- `VERSION` (root) updated with every PR
- `CHANGELOG.md` (repo root) updated with every PR

## Common Mistakes

| Mistake | Correct behavior |
|---------|-----------------|
| Using `version: "2.0"` for I1 content | I1 = 1.x always. 2.x is for I2. |
| Using `version: "0.1"` | LTC does not use 0.x. New file in I1 = "1.0". |
| Bumping version on uncommitted rewrite | No bump — it was never committed at the prior number |
| Setting `status: validated` without human | Only human validates. Agent sets draft, in-progress, or in-review. |
| Forgetting `status` field | All four fields (version + status + last_updated) required; iteration_name optional |
| Relative dates ("today") | Always absolute: 2026-03-31 |
| Skipping version-registry update | Every workstream artifact edit must update the registry row |
| Using `status: Draft` (uppercase) | All frontmatter values lowercase: `status: draft` |
| Using `iteration_name` without numeric `version` | `version` is primary and always required; `iteration_name` is supplementary only |

## Version Awareness

Before producing any deliverable, verify current iteration. I1 = Concept (correct + safe only).
I2 = Prototype (+ efficient). Do not produce artifacts beyond current iteration scope.
Reference: `_genesis/frameworks/ltc-ues-version-behaviors.md` 25-cell matrix.

## Links

- [[CHANGELOG]]
- [[deliverable]]
- [[history-version-control]]
- [[iteration]]
- [[ltc-ues-version-behaviors]]
- [[version-registry]]
- [[workstream]]
