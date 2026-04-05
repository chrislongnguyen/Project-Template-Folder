# /ltc-brainstorming — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Jumping to implementation before design approval

**What happens:** Agent sees a "simple" request and invokes writing-plans or starts coding without presenting a design and getting explicit user approval. The HARD-GATE exists to prevent this but agents rationalize past it ("this is trivial, no design needed").

**How to detect:** Check whether a design was presented AND the user explicitly approved it before any implementation action. Look for the approval message in the conversation history.

**Fix:** Re-read the HARD-GATE. No exceptions. Present the design — even if it's 3 sentences for a trivial task — and wait for explicit approval before proceeding.

---

## 2. Asking multiple questions in a single message

**What happens:** Agent batches 3-5 questions to "save time." This overwhelms the user and produces shallow answers. The skill requires ONE question per message.

**How to detect:** Count the question marks in your outgoing message. If there are more than one, you are violating the rule. Also check for implicit multi-questions disguised as bullet lists.

**Fix:** Pick the highest-priority question and send only that. Queue the rest. The next question depends on the answer to this one anyway — batching creates false efficiency.

---

## 3. Skipping UBS-before-UDS analysis

**What happens:** Agent jumps to exploring what drives the system (features, capabilities) without first identifying what blocks it (risks, constraints, dependencies). Meta-Rule 2 requires forces analysis before feature exploration.

**How to detect:** Review your first 3-5 questions. If they are all about "what should the system do?" and none about "what could go wrong?" or "what are the constraints?", you skipped UBS.

**Fix:** Before asking about features, ask: "What biases, dependencies, or environmental constraints threaten this outcome?" Get blocking forces on the table first.

---

## 4. Visual companion offer bundled with other content

**What happens:** Agent offers the visual companion in the same message as a clarifying question or context summary. The skill requires the offer to be its OWN message with nothing else.

**How to detect:** Check whether the message containing the visual companion offer also contains any other content — context summaries, clarifying questions, observations, or follow-ups.

**Fix:** Send the visual companion offer as a standalone message. Wait for the user's response. Then continue with clarifying questions in a separate message.

---

## 5. Skipping spec review loop

**What happens:** After writing the VANA-SPEC, agent presents it directly to the user without dispatching the spec-document-reviewer subagent. The review loop catches cross-section inconsistencies that the writing agent misses due to context degradation.

**How to detect:** Check whether the spec-document-reviewer subagent was dispatched after spec writing and before user review. If the spec went straight to "please review this," the loop was skipped.

**Fix:** After writing the spec, dispatch the spec-document-reviewer subagent with precisely crafted review context (not your session history). Fix issues and re-dispatch until approved (max 3 iterations). Only then present to the user.

---

## 6. EP-10 Verification Gate

**GATE — Verify:** Before transitioning to writing-plans, confirm: (1) the VANA-SPEC file exists at the expected path, (2) it contains all 4 VANA elements (Verb ACs in section 2, Adverb ACs in section 3, Noun ACs in section 4, Adjective ACs in section 5), (3) the MECE validator script passed (exit code 0), (4) the user has explicitly approved the spec. If any element is missing, the spec is incomplete — do not invoke writing-plans.

---

## 7. Escape Hatch — Sub-Agent Dispatch

If a sub-agent fails or returns empty/generic output: Do NOT retry the same prompt. Report the failure to the user with: which group failed, what it was supposed to produce. Offer: (a) continue without that section and mark it `[INCOMPLETE]`, (b) user provides the input manually, (c) rephrase the prompt and retry once. Do NOT silently generate the missing section yourself without disclosing the fallback.

---

## 8. LT-1 Requirements invention

Agent adds requirements during VANA-SPEC generation that were never discussed or approved during the brainstorming dialogue. Every AC in sections 2-5 must trace to a specific point in the conversation where the user agreed to it. If you cannot point to the message where this requirement was established, remove it from the spec and flag it as a candidate for the user to confirm.

## Links

- [[DESIGN]]
- [[EP-10]]
- [[SKILL]]
- [[simple]]
- [[task]]
