# /learn:input — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Batching questions

**What happens:** Agent asks 3-5 questions at once to "save time." User gives thin answers to all instead of rich answers to each. The one-at-a-time rule is non-negotiable.

**How to detect:** Count the question marks in the agent's message. If more than one question is posed, the agent is batching.

**Fix:** Enforce the HARD-GATE rule: one question per message, always. Even if the user says "just ask them all," refuse — rich single answers are worth the extra round trips.

---

## 2. Accepting vague EO

**What happens:** Agent accepts "make X better" as an EO. A valid EO must have all three structural elements: [User], [Desired state], [Constraint].

**How to detect:** Check the EO answer for: (1) a specific actor/who, (2) a measurable end-state, (3) what must NOT happen or be compromised. If any are missing, the EO is incomplete.

**Fix:** Apply the HARD-GATE — re-prompt with the missing element named explicitly: "Your EO needs [missing element]. Here's the pattern: [User] can [desired state] without [constraint]."

---

## 3. EO infinite loop — user can't articulate EO

**What happens:** After 2 re-prompts, the user is still stuck. Agent keeps re-prompting, loop never terminates.

**How to detect:** Agent has re-prompted for EO more than twice without progress.

**Fix:** Trigger the escape hatch — offer 3 EO pattern examples specific to the system name, and ask the user to pick one and customize. Never re-prompt more than twice before offering examples.

---

## 4. Skipping update mode announcement

**What happens:** Agent starts a fresh interview when a learn-input file already exists, overwriting the user's prior answers. Must announce update mode and show current values.

**How to detect:** In Pre-Checks, the agent should check for an existing file. If it exists but the agent proceeds with "Let's start fresh," update mode was skipped.

**Fix:** Always run the Pre-Check file existence test. If the file exists, announce update mode, show current values as defaults, and let the user press Enter to keep or type to replace.

## Links

- [[SKILL]]
