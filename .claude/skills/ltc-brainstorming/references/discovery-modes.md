---
version: "2.0"
status: draft
last_updated: 2026-04-05
---

# Discovery Protocol — Full Playbook

Progressive Discovery Protocol for ltc-brainstorming. 4 gates run internally — invisible to PM.
PM experiences: inference-led conversation, 1 question per message, crystallizing clarity.

## Hard Message Construction Rules (always-on, all gates)

1. **One question per message — no exceptions.** Never list sub-questions, alternatives, or "or is it X? or Y?" in a single turn. One inference. One question.
2. **Gate sequencing is strict.** Each gate requires a PM response before the next gate activates. No skipping, no batching gates into one message.
3. **Lead with inference, not interrogation.** State what you believe first. Ask PM to confirm or correct. Never open with an open-ended question.

---

## Gate 1 — EO Gate

**Always-on.** Runs on every input before any question is asked.

Trigger: PM input received (any message invoking ltc-brainstorming).

**Action:** Agent reads the full input. Infers the most likely desired outcome. Frames it as VANA (Verb + Adverb + Noun + Adjective). States the inference as a candidate EO and asks ONE binary confirmation question. Agent leads — PM corrects.

**If input is already well-formed** (clear verb, scope, measurable outcome): use a clean binary confirm only — "Sounds like you want to [X]. Is that right?" Do NOT offer compound alternatives or reframings. A well-formed input needs confirmation, not re-interpretation.

**If input is vague**: infer the single most likely EO and confirm it. Pick one interpretation — do not list alternatives ("or is it X? or Y? or Z?"). One inference, one question.

Example: "Sounds like you want to [reliably capture all meeting actions so nothing falls through]. Is that right?"

Exit: PM confirms or corrects the EO. Gate 1 is closed only after PM responds — do NOT proceed to Gate 2 before PM acknowledgment.

**LTC Framework:** VANA decomposition (general-system.md §8 — ESD Phase 3). Every EO = Verb + Adverb + Noun + Adjective. "Build a thing" is not an EO.

---

## Gate 1b — EO Clarifier (conditional mode)

Trigger: No testable EO can be inferred from PM input (input is purely exploratory or too abstract to form a candidate).

**Action:** Agent uses VANA decomposition to scaffold the question. Asks one anchor question targeting the Verb first: "What does success look like — what changes, for whom, and how would you know it worked?"

Exit: PM produces a statement the agent can reframe as VANA EO. Gate 1 exit condition then applies.

**LTC Framework:** VANA + Effective Thinking (hypothesis framing). Do not ask open-ended "what do you want" — always anchor to an outcome structure.

---

## Gate 2 — Scope Gate

**Always-on check.** Mode (ESD Decomposer or Premises Check) fires conditionally.

Trigger: Gate 1 exit reached (PM has acknowledged or corrected the EO). Agent now checks scope and framing before continuing.

**Gate sequencing invariant:** Gates fire in strict order. Gate 2 MUST NOT activate until Gate 1 receives a PM response. No gate fires out of sequence.

**Action:** Agent assesses two conditions independently:
1. Scope: Does the confirmed EO span ≥2 independent systems (e.g., auth + billing + analytics as separate bounded domains)?
2. Framing: Did the PM lead with a solution ("I want to use X") before the problem was established?

If condition 1 is true → ESD Decomposer mode fires.
If condition 2 is true → Premises Check mode fires.
If both true → ESD Decomposer first, complete to exit, then Premises Check.
If neither true → scope confirmed as single system, proceed to Gate 3.

Exit: Scope boundary stated. Single system selected and confirmed (or decomposition complete and one sub-system chosen). Solution-first framing resolved if applicable.

**LTC Framework:** EP-09 (scope discipline) + 8-Component Model (EP, Input, EOP, Environment, Tools, Agent, Action). Decompose at system boundary — not at feature level.

---

## Gate 2a — ESD Decomposer (conditional mode)

Trigger: ≥2 independent systems detected in the confirmed EO or PM input.

**Action:** Agent names the independent systems it detected. Asks which to address first. Does not attempt to design all of them — flags the others for separate brainstorming cycles.

Example: "This spans [A], [B], and [C] — three independent systems. Each deserves its own spec. Which do we start with?"

Exit: One system selected. Remaining systems explicitly deferred. Scope reduced to a single bounded system.

**LTC Framework:** EP-09 + 8-Component Model. A system that contains sub-systems is a program, not a spec. Decompose before designing.

---

## Gate 2b — Premises Check (conditional mode)

Trigger: PM stated a solution ("use X", "build Y") before the problem was established.

**Action:** Agent names the stated solution and inverts the framing. Asks one question that forces problem-first reasoning. Does not reject the PM's solution — surfaces it as a hypothesis to test.

Example: "You mentioned [solution X]. Before we design it — what problem does it solve? What happens if we don't build it?"

Exit: Problem statement exists independently of the proposed solution. PM can articulate the problem without referencing the solution.

**LTC Framework:** Effective Thinking — Hypothesis + Premises model. A solution is a hypothesis. Test the premises before accepting it.

---

## Gate 3 — Force Analysis

**Always-on. Both UBS and UDS. Always both.**

Trigger: Gate 2 exit reached (scope confirmed, single system selected).

**Action:** Agent surfaces forces as insight, not as a question. Delivers in two beats:
1. UBS (Undesirable Blockers/Suppressors): "Main blocker: [UB-1]. Also watch: [UB-2]."
2. UDS (Undesirable Drivers/Stressors): "Strongest accelerator: [UD-1]."
Then asks one validation question: "Does this match your read, or are there forces I'm missing?"

Agent must surface ≥1 non-obvious UB (not just "time" or "resources"). This is the trust-building moment.

Exit: ≥2 UBs registered AND ≥1 UD registered. PM has validated or corrected. Both sides of the force analysis are on record.

**LTC Framework:** UBS/UDS Framework (general-system.md §5 — Force Analysis). UBS before UDS — identify what blocks success before exploring what accelerates it. Never UDS-only.

---

## Gate 4 — Approach Gate

**Always-on check.** S/E/Sc Comparator fires conditionally.

Trigger: Gate 3 exit reached. Agent checks: are there ≥2 viable technical paths, or is PM uncertain about approach?

**Action:**
- If ≥2 paths exist OR PM expressed uncertainty → S/E/Sc Comparator mode fires.
- If only 1 path exists → agent validates it against S/E/Sc before accepting. States the validation result.

Even with a single path: agent must confirm it is Sustainable (reliable, adoptable) before exiting.

Exit: Approach chosen. S/E/Sc rationale stated (1 sentence). PM confirms.

**LTC Framework:** S/E/Sc Framework (general-system.md §6). Priority: Sustainability > Efficiency > Scalability. A fast fragile approach always loses to a slow reliable one.

---

## Gate 4a — S/E/Sc Comparator (conditional mode)

Trigger: ≥2 paths identified OR PM is uncertain about approach direction.

**Action:** Agent presents options as: "[Option A] — sustainable but slower. [Option B] — faster, higher fragility risk. Given [UB from Gate 3], I'd recommend [A]." One recommendation, stated with reasoning. Does not ask PM to evaluate options without an agent point of view.

Exit: One approach chosen with S/E/Sc rationale. PM confirms.

**LTC Framework:** S/E/Sc Framework + UBS-informed reasoning. The registered UBs from Gate 3 must inform the approach recommendation. A comparator that ignores blockers is not a comparator.

---

## Discovery Complete — Pre-Spec Summary

After all 4 gates exit, agent produces this 5-field summary before offering exits:

```
Discovery Complete

EO:       [VANA outcome — Verb + Adverb + Noun + Adjective]
Scope:    [single system boundary, 1 sentence]
Blockers: [UB-1], [UB-2] (+ others if registered)
Drivers:  [UD-1] (+ others if registered)
Approach: [chosen approach + 1-line S/E/Sc rationale]
```

Binary completeness check: all 5 fields must be present. If any field is empty, the relevant gate has not exited — return to it before producing the summary.

Then offer two exits — never force /dsbv:
- "Ready to turn this into a design doc? Run `/dsbv`."
- "Or if clarity was the goal, we're done here. Discovery Complete."

---

## Evasion Handling

If the PM gives an evasive or non-responsive answer to a gate question (deflects, changes subject, answers a different question):

Rule: After 1 evasive response per gate, agent makes a default assumption, states it explicitly, and moves on.

Example: "I'll assume the EO is [X] — we can revisit if that turns out to be wrong. Moving on."

Do not re-ask the same question. Do not loop. One evasive response triggers the default assumption rule. The gate exits on the stated assumption.

## Links

- [[DESIGN]]
- [[EP-09]]
- [[SEQUENCE]]
- [[blocker]]
- [[general-system]]
