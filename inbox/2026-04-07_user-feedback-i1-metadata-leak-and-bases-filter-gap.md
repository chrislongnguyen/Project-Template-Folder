---
date: "2026-04-07"
type: capture
source: conversation
tags: []
---

# User feedback: I1 metadata leak + Bases filter gap

Captured from post-v2.0.0 user session — acting as a net-new user cloning template and starting from scratch.

---

## Q1 — Why does iteration start at 2?

**Main cause:** Blindly preserved `iteration: 2` when editing DESIGN.md.

**Root cause:** The LTC Project Template itself is at I2 (Prototype). When it was merged (commit 081ed5f), ALL scaffolded files shipped with `iteration: 2` and `version: "2.0"`. A new user then bumped to `version: "2.1"` — continuing the wrong baseline instead of resetting.

**Correct behavior for a new project at I1 (Concept):**
- `version` should be `"1.0"` (new content in I1)
- `iteration` should be `1`

**Blame trace:** Agent | Zone: Below Threshold — iteration context not verified before writing | Fix: Reset to `iteration: 1`, `version: "1.0"` on all PD artifacts. Audit ALL template-scaffolded files for leaked I2 metadata.

---

## Q2 — Why doesn't DESIGN.md appear in Obsidian Bases C1-master-dashboard?

**Main cause:** C1-master-dashboard filters on `type == "ues-deliverable"`. DESIGN.md has `type: dsbv-design`. Filter doesn't match → excluded.

**Root cause:** The Bases query system and the DSBV frontmatter type system were designed independently. DSBV artifacts use types like `dsbv-design`, `dsbv-sequence`, `dsbv-validate`. The Bases dashboards only query for `ues-deliverable`. There is no Bases query that captures DSBV phase artifacts.

**Note:** W1-alignment-overview uses `file.inFolder("1-ALIGN")` with no type filter — DESIGN.md should appear there. Check that base separately.

---

## Fixes needed

| Fix | Scope |
|-----|-------|
| Reset DESIGN.md to `iteration: 1`, `version: "1.0"` | Immediate |
| Audit all `1-ALIGN/` files for leaked I2 metadata | Before Build |
| Either add `type: ues-deliverable` to DSBV artifacts OR update C1-master-dashboard filter to include `dsbv-*` types | Template-level decision |

---

## Template-level implications

Both issues are **onboarding traps** introduced by the template shipping live metadata (`iteration: 2`, `version: "2.0"`) in scaffolded files. A cloning user has no signal that these values must be reset before starting I1 work.

Candidate fixes to the template:
- Scaffold files with placeholder metadata (`iteration: TBD`, `version: "1.0"`) OR add a reset step to `/setup` skill
- Document the Bases filter gap + recommended `dsbv-*` query strategy in `_genesis/` or the I2 training deck
