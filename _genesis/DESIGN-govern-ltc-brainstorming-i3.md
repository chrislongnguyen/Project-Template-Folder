---
version: "2.0"
status: Draft
last_updated: 2026-04-05
owner: Long Nguyen
workstream: GOVERN
iteration: I2
skill: ltc-brainstorming
---

# DESIGN — ltc-brainstorming I3 Upgrade

## Intent

The current skill is a **gate** (must invoke before creative work). The I3 upgrade makes it a
**companion** — inviting, invoked often, valuable even when it doesn't lead to a VANA-SPEC.

The core problem: the skill jumps from vague input to clarifying questions without doing
pre-discovery work. PMs with half-formed ideas get interrogated instead of guided. The upgrade
adds a Progressive Discovery Protocol — 4 invisible gates the agent runs internally before
any clarifying question is asked. The PM's experience is a brilliant colleague who already
has a point of view.

---

## Artifact Inventory

| # | Artifact | Path | Purpose |
|---|----------|------|---------|
| A1 | Updated SKILL.md | `.claude/skills/process/ltc-brainstorming/SKILL.md` | Companion framing, broader trigger, discovery protocol entry point, light exit path |
| A2 | Discovery Modes reference | `.claude/skills/process/ltc-brainstorming/references/discovery-modes.md` | Full playbook for each protocol element: trigger criteria, action, exit condition |

---

## Completion Conditions → Artifact Mapping

| Condition | Artifact |
|-----------|----------|
| Agent triggers on vague PM input without explicit invocation | A1 (frontmatter description, trigger phrases) |
| Discovery protocol guarantees all 5 VANA-SPEC inputs at handoff | A2 (gate exit criteria) |
| PM experience = 1 question per message, agent leads with inference | A1 (process flow section) |
| "Discovery Complete" light exit available (clarity without design doc) | A1 (terminal states) |
| No SKILL.md length regression (stays under 220 lines) | A1 (details in A2, not inline) |
| UDS Analysis present alongside UBS (both sides of force analysis) | A2 (Gate 3) |
| Each mode re-states its LTC framework at point of use (LT-2 defense) | A2 (per-mode header) |

No orphan conditions. No orphan artifacts.

---

## The Progressive Discovery Protocol (4 Gates)

Gates are the agent's internal operating system — invisible to the PM.
The PM experiences a natural conversation; the agent runs this protocol silently.

```
INPUT
  │
  ▼
Gate 1: EO Gate (ALWAYS-ON)
  Agent infers a candidate EO from the input.
  States it. PM confirms or corrects.
  → EO Clarifier fires if no testable outcome can be inferred.
  Exit: PM confirms VANA EO in one sentence.
  │
  ▼
Gate 2: Scope Gate (ALWAYS-ON check, mode fires if triggered)
  Agent checks: is this one system or many?
  Also: did PM lead with a solution (not a problem)?
  → ESD Decomposer fires if >1 independent system detected.
  → Premises Check fires if solution-first framing detected.
  Exit: Scope boundary stated. One system selected if multiple found.
  │
  ▼
Gate 3: Force Analysis (ALWAYS-ON — both sides, always)
  Agent identifies top UBs (blockers) then top UDs (drivers).
  Delivers as insight, not as a question: "Here's what blocks this... and what accelerates it."
  PM validates / corrects.
  Exit: ≥2 UBs and ≥1 UD registered.
  │
  ▼
Gate 4: Approach Gate (ALWAYS-ON check, mode fires if triggered)
  Agent checks: are there ≥2 viable technical paths?
  → S/E/Sc Comparator fires if yes, or if PM is uncertain about approach.
  Even with 1 path: agent validates it against S/E/Sc before accepting.
  Exit: Approach chosen with S/E/Sc rationale.
  │
  ▼
Discovery Complete
  Agent produces 5-line pre-spec summary:
    EO:       [VANA outcome]
    Scope:    [boundary]
    Blockers: [UB-1], [UB-2]
    Drivers:  [UD-1]
    Approach: [choice + 1-line rationale]

  Then: offer two exits
    → /dsbv (if PM is ready to produce a design doc)
    → Discovery Complete — light exit (if clarity was the goal)
```

---

## The 6 Protocol Elements

| Element | LTC Framework | Trigger | Always-on? |
|---------|--------------|---------|-----------|
| EO Gate | VANA decomposition | PM input received | Yes |
| EO Clarifier (mode) | VANA + Effective Thinking | No testable EO inferable | Conditional |
| Scope Gate + ESD Decomposer | EP-09 + 8-Component Model | >1 independent system | Gate always; mode conditional |
| Premises Check (mode) | Effective Thinking — Hypothesis+Premises | Solution stated before problem | Conditional |
| Force Analysis (UBS → UDS) | UBS/UDS Framework | — | Yes — both sides, always |
| Approach Gate + S/E/Sc Comparator | S/E/Sc Framework | ≥2 paths or uncertainty | Gate always; mode conditional |

---

## UX Principles (baked into A1 + A2)

**Insight-First, Not Question-First**
Agent reads → infers → surfaces one insight → asks one question.
PM corrects, not constructs. Never more than 1 question per message.

**Agent Leads with a Point of View**
Every message leads with the agent's best inference. PM validates or corrects.
Example framing per gate:
- EO Gate: "Sounds like you want to [EO]. Is that right?"
- Scope Gate: "This touches [A] and [B] — start with [A] only?"
- Force: "Main blocker: [UB]. Strongest accelerator: [UD]. Match your read?"
- Approach: "Two paths: [A] (sustainable) vs [B] (fast, fragile). Given [UB], I'd go [A]."

**Visible Crystallization**
After each gate closes, agent appends a growing "Discovery so far:" block.
PM watches their vague idea become a real design in real-time.

**The "You Didn't Think of This" Moment**
Gate 3 (Force Analysis) must surface ≥1 non-obvious UB.
This is the trust-building moment that drives repeat use.

---

## HOW — Implementation Constraints

| # | Principle | Applied |
|---|-----------|---------|
| H1 | Trigger = concrete PM phrases | Frontmatter: "I'm thinking...", "what if we...", "how should I..." |
| H2 | Each gate = binary entry/exit | "PM confirms VANA EO in one sentence" not "EO is clear" |
| H3 | Re-inject framework at point of use | Each mode names framework + plain-language explanation (LT-2 defense) |
| H4 | Minimal context at discovery start | No full project dump; discovery briefing = EO candidate + constraints only |
| H5 | Prescribe process; freedom within | Agent knows which question per gate; phrases it naturally |
| H6 | Validate pre-spec summary before handoff | Binary check: all 5 fields present before offering /dsbv exit |
| H7 | Sequential mode execution | If ESD + Premises both fire → ESD first, complete, then Premises |

---

## HOW NOT — Anti-Patterns

| # | Anti-Pattern | Risk |
|---|-------------|------|
| N1 | Growing SKILL.md past 220 lines | Discovery modes content → A2 only |
| N2 | Assuming PM knows LTC frameworks | Plain-language label before the LTC term, always |
| N3 | Soft gate exits ("feels clear") | Every gate exit is a binary PM confirmation |
| N4 | Monolithic discovery turn | One gate per agent turn; compound tasks degrade at step 4 (LT-3) |
| N5 | Cross-session continuity assumption | Protocol completes in one session; no "resume last brainstorm" dependency |
| N6 | High-freedom instructions | Prescribe which angles (8-component, UBS/UDS, S/E/Sc) — not "explore angles" |
| N7 | Skipping pre-spec validation | Agent optimizes for plausibility not truth (LT-5) — binary completeness check required |

---

## Out of Scope (I3)

- User-invocable mode selection (adds friction — deferred)
- Visual companion integration with discovery modes
- Cross-session brainstorm log (BRAINSTORM_LOG.md) — future consideration
- Hook-based auto-trigger (skill description + Claude judgment is sufficient)

---

## Success Rubric

| Criterion | Pass condition |
|-----------|---------------|
| Protocol completeness | All 5 VANA-SPEC inputs guaranteed at handoff (binary check) |
| SKILL.md length | ≤220 lines after edits |
| Light exit present | "Discovery Complete" terminal state defined and reachable |
| UDS present | Force Analysis covers both UBs AND UDs — not UBS-only |
| LT-2 defense | Each mode re-states its framework inline |
| Trigger breadth | Description covers casual exploration, not just "before creative work" |
