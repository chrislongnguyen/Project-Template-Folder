# /dsbv — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Skipping Design because scope "seems obvious"

**What happens:** Agent jumps straight to Build or Sequence without producing a DESIGN.md, rationalizing that the task is too simple or the outcome is self-evident. This is the #1 DSBV failure mode — it bypasses scope definition, acceptance criteria, and the artifact inventory that downstream stages depend on.

**How to detect:** Before entering any stage other than Design, check: does `{N}-{WORKSTREAM}/DESIGN.md` exist and have status Approved? If not, the agent skipped the gate.

**Fix:** Hard-stop and return to Design. No DESIGN.md = no scope = no Build. Even a 10-line DESIGN.md with acceptance criteria is better than none. The readiness check C2 (scope loaded) exists precisely for this case.

---

## 2. Running Build before Sequence is approved

**What happens:** Agent produces workstream artifacts in arbitrary order because it didn't wait for the human gate on SEQUENCE.md. Dependencies get violated — an artifact that depends on another is built first, creating rework or inconsistencies.

**How to detect:** Check the DSBV stage ordering: Design (Approved) -> Sequence (Approved) -> Build -> Validate. If Build artifacts exist but SEQUENCE.md is missing or not Approved, the gate was skipped.

**Fix:** Pause Build. Produce SEQUENCE.md from the DESIGN.md artifact inventory, get human approval, then resume Build in the sequenced order. stage ordering is enforced — Design MUST complete before Build, Sequence MUST be approved before Build begins.

---

## 3. Multi-agent Build launched without cost confirmation

**What happens:** Agent spawns parallel sub-agents for a design-heavy workstream (ALIGN, PLAN) without showing the cost estimate or getting human approval. This wastes tokens and may produce artifacts that conflict with each other.

**How to detect:** If the workstream type is design-heavy and `--model` or `--teams` flags are in play, a cost confirmation prompt MUST appear before sub-agents launch. If artifacts suddenly appear without that confirmation, the gate was bypassed.

**Fix:** Before launching multi-agent Build, display: team count, model tier, estimated token cost, and the artifact-to-agent assignment. Wait for explicit human "go" before spawning. Single-agent sequential Build does not require cost confirmation.

---

## 4. Treating Validate as a rubber stamp

**What happens:** Agent marks validation as "all pass" without actually checking each criterion against DESIGN.md acceptance criteria. Errors propagate to the next workstream because the quality gate was not enforced.

**How to detect:** Compare the VALIDATE.md verdicts against the DESIGN.md acceptance criteria line by line. If VALIDATE.md has fewer checks than DESIGN.md has criteria, or all checks are "PASS" with no evidence, it was rubber-stamped.

**Fix:** Validate must produce per-criterion evidence. Each acceptance criterion in DESIGN.md maps to a check in VALIDATE.md with a verdict (PASS/FAIL/PARTIAL) and a one-line justification. If any criterion fails, the workstream cannot be marked complete.

---

## 5. Not loading C4 (dsbv-process.md) before starting

**What happens:** Agent proceeds with stale or missing process knowledge because it didn't read `_genesis/templates/dsbv-process.md` as required by readiness check C4. Stage definitions, gate rules, and multi-agent patterns are then applied from memory, which may be outdated or wrong.

**How to detect:** Readiness check C4 requires dsbv-process.md to be loaded. If the agent cannot cite specific stage rules or readiness conditions (C1-C6) from the process doc, it likely skipped the load.

**Fix:** Before entering any DSBV stage, run the full readiness check. C4 specifically requires loading `_genesis/templates/dsbv-process.md`. If the file is missing or unreadable, STOP and alert the user — do not guess at process rules.

---

## 6. LT-1 Stage completion hallucination

**What happens:** Agent claims a stage is complete without checking if the artifact file actually exists on disk. Conversation agreement is not the same as an artifact on disk — the artifact is the deliverable, not the discussion.

**How to detect:** After any stage claim, run Glob/Read on the expected artifact (e.g., `DESIGN.md`, `SEQUENCE.md`, `VALIDATE.md`). If it doesn't exist, the stage is not complete.

**Fix:** Always verify with Glob/Read. The GATE — Verify in SKILL.md enforces this: if the file does not exist, the stage is NOT complete regardless of what was discussed.

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[deliverable]]
- [[dsbv-process]]
- [[simple]]
- [[task]]
- [[workstream]]
