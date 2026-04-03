---
version: "1.0"
status: draft
last_updated: 2026-04-03
---

# LTC Thinking Modes — User Guide

> **Who this is for:** Any LTC member using Claude Code.
> **What this is:** Your AI assistant has 8 built-in thinking modes that activate automatically during your conversations. This guide explains each one — what it does, when it fires, and what to do when you see it.

---

## WHAT — The Big Picture

When you chat with Claude, it does not just answer. It watches your words for signals that you need a different kind of thinking. When it detects one, it injects a short check into its response — a structured prompt that surfaces something you might have missed.

There are **8 thinking modes**, grouped into 3 categories:

```
DIVERGE (expand thinking)
  1. Devil's Advocate   — challenge your proposal
  2. Perspective Switch — see through other people's eyes
  3. Reframe            — escape a stuck frame

CONVERGE (narrow to a decision)
  4. Smart Closing      — summarize what's agreed and what's open
  5. Convergence Health — ask if we're ready to lock or re-explore

CROSS-CUTTING (active throughout)
  6. Bias Check         — name the cognitive bias when you pivot
  7. Blame Diagnostic   — trace the root cause when something breaks
  8. Cobra Check        — map second-order effects before system changes
```

**These are automatic.** You do not invoke them. They fire when your words match a trigger pattern. You can suppress all modes for a session by saying **"just build it."**

---

## HOW — Each Mode Explained

---

### 1. Devil's Advocate ⚡

**WHAT:** After Claude presents a recommendation, it appends 1–2 objections it would raise if it were arguing against the proposal.

**WHY:** Your brain naturally confirms what it already believes (confirmation bias). The DA gives you the counter-argument before you commit, not after you've built it.

**HOW it appears:**
```
⚡ DA: This assumes the team will adopt the new gate. If adoption fails,
       the gate becomes a bottleneck with no fallback. [Human UBS]
```

**Triggers on:** `should we`, `recommend`, `design`, `architecture`, `approach`, `what do you think`

**NOW WHAT:** Read it. If the objection is real → address it before proceeding. If it's not relevant → ignore it and move on. Say "acknowledged" if you want Claude to continue.

---

### 2. Perspective Switch 👁

**WHAT:** When a decision involves stakeholders (Vinh, team members, CIO review), Claude adds a quick lens check from 3 angles.

**WHY:** Decisions that look good from one perspective often have blind spots from another. A technically sound design can be operationally unbuilable or strategically misaligned.

**HOW it appears:**
```
👁 Operator: buildable in I2? | Risk: SPOF at the API boundary? | CIO: aligns with S>E>Sc?
```

**Triggers on:** mentions of `Vinh`, `stakeholder`, `CIO`, `team member` + `decision`, `approve`, `review`

**NOW WHAT:** Check each lens that applies. If any lens surfaces a conflict → resolve it before locking the decision.

---

### 3. Reframe 🔄

**WHAT:** When you're stuck, Claude offers one alternative way to look at the problem.

**WHY:** Sometimes you're solving the wrong problem. A single reframe — "treat this as a risk, not a feature" — can unlock 30 minutes of circular thinking.

**HOW it appears:**
```
Reframe: We're treating this as a feature request. What if it's actually a
         risk management problem — and the feature is just one way to manage it?
```

**Triggers on:** `stuck`, `dead end`, `not working`, `going in circles`, `tried everything`

**NOW WHAT:** Try the reframe for one response. If it opens up new options → pursue it. If not → tell Claude "not that direction" and it will stop.

---

### 4. Smart Closing ✓

**WHAT:** At phase gates (DSBV transitions, approvals, "ready to build" signals), Claude summarizes the decision state before proceeding.

**WHY:** It is easy to move to the next phase with unresolved questions hiding in the conversation. Smart Closing surfaces them explicitly before you're mid-build with an open design question.

**HOW it appears:**
```
✓ Agreed: polyrepo structure, UNG naming for subsystems
⚠ Open: whether Portfolio Construction is its own subsystem
? Assumed: Vinh will review D1-D4 before I2
→ Next: create I2 branch after Blueprint review
```

**Triggers on:** `/dsbv`, `phase gate`, `ready to build`, `approved`, `let's lock`, `move to sequence`

**NOW WHAT:** Read the Open and Assumed items. If anything there is actually decided → tell Claude to update the closing. If something is genuinely open → resolve it now or explicitly flag it as a known risk before moving forward.

---

### 5. Convergence Health 🔄

**WHAT:** After 4+ exchanges on the same topic without a clear decision, Claude pauses and asks: are we ready to lock, or should we re-explore?

**WHY:** Long conversations without a decision lock are a signal that either consensus is thin, or we've been circling the same ground. This mode forces the question explicitly.

**HOW it appears:**
```
4+ exchanges on this topic without a decision lock.
Are we ready to lock this, or should we re-explore?
```

**Triggers on:** 4 consecutive exchanges on same topic with no lock signal

**NOW WHAT:** Answer the question directly. "Lock it" → Claude proceeds with the current direction. "Re-explore" → Claude opens up alternatives again. This mode resets automatically after you answer.

---

### 6. Bias Check 📌

**WHAT:** When you signal doubt or change direction ("wait", "actually", "hmm"), Claude names the cognitive bias that might be at play.

**WHY:** Mid-conversation pivots are often driven by a specific bias — anchoring to the first idea, affect heuristic (gut feeling overriding analysis), or confirmation bias. Naming it helps you decide if the pivot is real or reflexive.

**HOW it appears:**
```
📌 Anchoring — you may be locked to the first architecture you heard.
               The current proposal is different. Worth evaluating it independently.
```

**Triggers on:** `wait`, `actually`, `hmm`, `feels wrong`, `not sure`, `second thought`

**NOW WHAT:** Consider whether the named bias applies. If yes → take 30 seconds to evaluate the current option on its own merits. If no → tell Claude "not that" and continue.

---

### 7. Blame Diagnostic 🔍

**WHAT:** When Claude's output was wrong or rejected, it traces the failure through the 7-Component System to find the root cause — before producing another response.

**WHY:** When an agent fails, the instinct is to blame the model. But 80% of the time, the real cause is elsewhere: unclear input, a missing rule, the wrong procedure, an environment constraint. The blame trace finds the actual culprit so you fix the right thing.

**The 7 components traced (in order):**
```
EP (rules) → Input (context) → EOP (procedure) → EOE (environment)
→ EOT (tools) → Agent (model)
```

**HOW it appears:**
```
🔍 Culprit: Input | Zone: Below Threshold | Fix: The task needs explicit scope
            boundaries before delegating. Add "do X and only X, do not touch Y."
```

**Triggers on:** `wrong`, `that's not right`, `failed`, `broke`, `error`, `not what I`, `incorrect`

**NOW WHAT:** Apply the fix before re-running the task. If the culprit is EP → update the rules. If Input → restructure your prompt. If Agent → consider a more capable model for this task type.

---

### 8. Cobra Check 🐍

**WHAT:** When you propose a system-level change (new rule, process, gate, policy, workflow change), Claude maps the second-order effects before proceeding.

**WHY:** The Cobra Effect: British colonial India offered bounties for dead cobras to reduce the population. People started breeding cobras for the reward. When the program ended, they released the worthless cobras — making the problem worse than before. Good intentions + unanalyzed feedback loops = Cobra Effect. This mode catches it before you ship the change.

**HOW it appears:**
```
🐍 Loops: Adding a mandatory DA gate before every commit creates a
           balancing loop (catches bad decisions) but also a reinforcing
           penalty loop (every commit now costs 2-3 minutes → developers
           batch commits → less frequent, larger commits → worse diffs).
   Cobra risk: Yes — gate may incentivize batching, degrading code quality
               in the opposite direction from intent.
```

**Triggers on:** `implement/introduce/remove/change/add` + `rule/policy/gate/process/workflow/framework/structure/constraint/system`

**NOW WHAT:** Read the Cobra risk. If it's real → adjust the intervention (smaller scope, different mechanism, pilot first). If it's not applicable → proceed. This mode fires on system-level changes only, not on code-level tasks.

---

## WHY — The Philosophy Behind This

These modes exist because of two failure patterns:

**Human failure pattern (System 1):** Under time pressure, fatigue, or emotional investment, humans default to heuristics — availability bias, anchoring, confirmation bias. These shortcuts feel like thinking but skip the analysis.

**Agent failure pattern (8 LLM Truths):** Claude optimizes for plausible output, not correct output. It can confidently be wrong, lose track of instructions, or complete the wrong task without noticing.

The thinking modes address both. DA and Bias Check counter human System 1. Blame Diagnostic addresses agent failures. Perspective Switch and Smart Closing force explicit articulation of assumptions that both humans and agents carry silently.

**The underlying principle:** Systems fail not because people are bad thinkers, but because they never had a structured moment to think differently. These modes create those moments — automatically, at the right time, in the fewest possible words.

---

## NOW WHAT — How To Use This

**If a mode fires and it's useful:** Engage with it. Answer the question it's asking.

**If a mode fires and it's not relevant:** Ignore it and continue. Claude will still answer your question — the mode adds to the response, it doesn't block it.

**If modes are firing too often and slowing you down:** Say **"just build it"** — all modes suppress for the rest of the session. They reset automatically in the next session.

**If you want to trigger a mode manually:** Just use the trigger words naturally. "I'm not sure about this approach" will fire Bias Check. "Let's transition to build" will fire Smart Closing.

**If something went wrong and you want the Blame Diagnostic:** Say "that's wrong" or "you missed X" — the trace will run automatically.

---

## Quick Reference Card

| Mode | Trigger signal | Output format | When to engage |
|------|---------------|---------------|----------------|
| ⚡ Devil's Advocate | Design/recommendation proposal | `⚡ DA: [objection] [UBS category]` | When objection is real |
| 👁 Perspective Switch | Stakeholder + decision | `👁 Operator: ... \| Risk: ... \| CIO: ...` | When a lens reveals a conflict |
| 🔄 Reframe | Stuck signals | One reframe sentence | When circling the same problem |
| ✓ Smart Closing | Phase gate signals | `✓/⚠/?/→ items` | Always — review Open items |
| 🔄 Convergence Health | 4+ exchanges, no lock | Direct question | Answer: lock or re-explore |
| 📌 Bias Check | Doubt/pivot signals | `📌 [Bias] — [why]` | When bias is real |
| 🔍 Blame Diagnostic | Failure/error signals | `🔍 Culprit/Zone/Fix` | Always — apply the fix |
| 🐍 Cobra Check | System-level change | `🐍 Loops/Cobra risk` | When risk is non-trivial |

**Suppress all modes:** say `just build it` → resets next session.

---

*Built by: Long Nguyen + Claude (Research & Governance Agent)*
*Source: thinking-modes.sh + thinking-modes.md (user-scope, ~/.claude/)*
*Applies to: All LTC members using Claude Code*
