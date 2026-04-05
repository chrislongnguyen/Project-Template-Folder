---
version: "2.1"
status: draft
last_updated: 2026-04-03
type: ues-deliverable
sub_system: 1-PD
work_stream: 4-EXECUTE
stage: build
iteration: 2
ues_version: prototype
---

# Frontmatter Schema — Canonical Spec (S2)

> Canonical YAML field definitions for all LTC workstream artifacts.
> S2 status vocabulary (approved 2026-04-03). Consumed by: A3 Bases filters, A4 Templater templates, A6 validation test.

---

## Schema Table

| Field | Type | Required | Valid Values | Default | Notes |
|-------|------|----------|-------------|---------|-------|
| `version` | string | YES | `"MAJOR.MINOR"` e.g. `"1.0"`, `"2.3"` | `"1.0"` | Quoted string. MAJOR = iteration (I1=1.x, I2=2.x). MINOR = edit count within iteration. Never `"0.x"`. |
| `status` | string | YES | `draft` \| `in-progress` \| `in-review` \| `validated` \| `archived` | `draft` | S2 vocabulary. Lowercase only. Humans set `validated`; agents set all others. |
| `last_updated` | string | YES | `YYYY-MM-DD` e.g. `2026-04-03` | today | Absolute date. Never relative ("today"). Updated on every edit. |
| `type` | string | YES | `ues-deliverable` \| `template` \| `learning-source` \| `reference` | `ues-deliverable` | Lowercase. Drives Bases grouping in B7 Templates Library. |
| `sub_system` | string | YES | `problem-diagnosis` \| `data-pipeline` \| `data-analysis` \| `insights-decision-making` | `problem-diagnosis` | Lowercase kebab. Maps to the 4-subsystem pipeline (PD→DP→DA→IDM). |
| `work_stream` | string | YES | `align` \| `learn` \| `plan` \| `execute` \| `improve` | `execute` | Lowercase ALPEI name. Drives per-workstream Bases (B8–B12). |
| `stage` | string | YES | `design` \| `sequence` \| `build` \| `validate` | `design` | Lowercase DSBV stage. `validate` is canonical (not `audit`). |
| `iteration` | integer | YES | `0` \| `1` \| `2` \| `3` \| `4` | `2` | Integer (no quotes). Matches I0-I4 iteration. |
| `ues_version` | string | YES | `logic-scaffold` \| `concept` \| `prototype` \| `mve` \| `leadership` | `prototype` | Lowercase kebab. Matches iteration: I0=logic-scaffold, I1=concept, I2=prototype, I3=mve, I4=leadership. |

---

## S2 Status Vocabulary

| Value | Meaning | Who Sets It | Migrated From |
|-------|---------|------------|--------------|
| `draft` | Created, being authored | Agent | `Draft` (old) |
| `in-progress` | Actively being built this sprint | Agent | _(new — no migration needed)_ |
| `in-review` | Awaiting human review/approval | Agent | `Review` (old) |
| `validated` | Human-approved, meets VANA criteria | **Human only** | `Approved` (old) |
| `archived` | Deprecated, no longer active | Agent | _(new — no migration needed)_ |

---

## Stage Values

| Value | DSBV Phase | Notes |
|-------|-----------|-------|
| `design` | Design | Scope, ACs, artifact inventory |
| `sequence` | Sequence | Task ordering, dependencies |
| `build` | Build | Artifact production |
| `validate` | Validate | Verification against VANA criteria |

Note: `audit` is NOT a valid value. Vinh's bases using `audit` must be corrected to `validate` (handled in A3 T3a).

---

## Example: Full Valid Frontmatter Block

```yaml
---
version: "2.0"
status: draft
last_updated: 2026-04-03
type: ues-deliverable
sub_system: PD
work_stream: 4-EXECUTE
stage: build
iteration: 2
ues_version: prototype
---
```

---

## Migration Mapping (I1 → S2)

| Old Value | New Value | Script Action |
|-----------|----------|---------------|
| `status: Draft` | `status: draft` | sed replace |
| `status: Review` | `status: in-review` | sed replace |
| `status: Approved` | `status: validated` | sed replace |
| `status: in-progress` | no change | already S2 |
| `status: archived` | no change | already S2 |

Migration script: `4-EXECUTE/scripts/migrate-status.sh`
Scope: `.md` files in `1-ALIGN/`, `2-LEARN/`, `3-PLAN/`, `4-EXECUTE/`, `5-IMPROVE/`
Excluded: `.claude/`, `_genesis/`, `node_modules/`

---

## Field Constraints (for Bases filter expressions)

- All values are **lowercase** (Obsidian Bases filters are case-sensitive — mixed case causes silent query failures)
- `version` is a **quoted string** — Obsidian treats unquoted `1.0` as a float, breaking equality filters
- `iteration` is an **integer** — do not quote; Obsidian numeric comparisons require unquoted integers
- `stage` uses `validate` not `audit` — B2 ALPEI Stage Board formula must reflect this

---

## Consuming Artifacts

| Artifact | How It Uses This Schema |
|----------|------------------------|
| A3 — 14 Obsidian Bases | Filter expressions reference exact field names and S2 values from this table |
| A4 — 6 Templater Templates | `tp.*` calls populate all 9 required fields; defaults match this spec |
| A6 — Frontmatter Validation Test | Validates each field name, type, and value range against this spec |
