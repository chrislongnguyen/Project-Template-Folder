# /learn:spec — Gotchas

Known failure patterns when executing this skill. Update when new issues are discovered.

---

## 1. Hallucinated ACs not grounded in source pages

**What happens:** Agent invents plausible-sounding criteria not traceable to any T0 page:row:col.

**How to detect:** After extraction, verify each AC's `Source` field against the actual T0 page file. If the referenced row or column does not exist, the AC is hallucinated.

**Fix:** Every AC must trace to a specific page:row:col. If the source cell is empty, use `[NEEDS REVIEW]` — never invent content.

---

## 2. Missing SPAWNED and Hardening ACs

**What happens:** Agent extracts only Iteration 1 ACs, skipping STEP.n(A) NEXT cells (SPAWNED) and P0 RACI(I) (Hardening) for Iteration 4.

**How to detect:** Check §2 for `Verb (SPAWNED)` entries and §4 for `Noun (Hardening)` entries. Check §9 has Iteration 4 rows. Missing any → incomplete extraction.

**Fix:** After extracting Iteration 1 ACs, explicitly scan T0.P5 STEP.n(A) col 16 (NEXT) for SPAWNED ACs and T0.P0 RACI(I) for Hardening ACs. Add to §2 and §4 with Iteration 4 iteration tags.

---

## 3. Vague VANA Words

**What happens:** Agent uses generic verbs ("Process", "Handle", "Manage") instead of specific ones ("Initialize", "Validate", "Acquire").

**How to detect:** Scan VANA Word column for: "Process", "Handle", "Manage", "Do", "Run", "Execute" (used generically).

**Fix:** Replace with the specific action from the source cell. "Process data" → "Validate" or "Transform" depending on what the step actually does.

---

## 4. dsbv-process.md missing (Criterion 4 RED)

**What happens:** Agent marks Criterion 4 GREEN without verifying `_genesis/templates/dsbv-process.md` exists.

**How to detect:** Criterion 4 is GREEN but the file doesn't exist on disk.

**Fix:** Run `ls _genesis/templates/dsbv-process.md` before writing the Readiness Package. If missing, set Criterion 4 to RED and halt — DSBV cannot start without the process definition.

---

## 5. DSBV Readiness Package missing or incomplete

**What happens:** Agent writes vana-spec.md but skips `DSBV-READY-{slug}.md`, or writes it without all 6 checklist conditions.

**How to detect:** Check that both files exist in `2-LEARN/_cross/specs/{slug}/`. Verify Criterion 1-6 rows are all present.

**Fix:** Both outputs are mandatory. If DSBV-READY is missing, the skill is incomplete — the Human Director cannot gate DSBV Design without it.

## Links

- [[DESIGN]]
- [[SKILL]]
- [[VALIDATE]]
- [[dsbv-process]]
- [[iteration]]
