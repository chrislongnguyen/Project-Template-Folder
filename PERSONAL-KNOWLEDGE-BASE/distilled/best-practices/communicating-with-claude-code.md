---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: best-practices
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
  - so_what_benefit
  - now_what_next
---

# Communicating with Claude Code

The way you phrase requests determines output quality more than any other single variable. Two patterns stand out: treating Claude like a senior engineer for codebase questions, and using Claude to interview you before writing a spec.

## L1 — Knowledge

### So What? (Relevance)

Most users under-use Claude Code as a thinking partner. They ask it to execute, not to elicit. Shifting to a dialogue mode — questions, interviews, spec-then-implement — consistently produces better designs with fewer corrections.

### What Is It?

Two complementary communication practices:

**Codebase questions** — Ask Claude the same questions you would ask a knowledgeable teammate. No special syntax required; plain natural language works. Useful for onboarding, debugging unfamiliar code, and understanding design intent.

**Claude interviews you** — For larger features, reverse the direction: let Claude ask YOU the questions using the `AskUserQuestion` tool. Claude surfaces edge cases, tradeoffs, and implementation details you haven't considered yet.

### What Else?

- Claude Code can explain single lines, entire subsystems, or "why X instead of Y" rationale embedded in code
- The interview pattern produces a written spec (`SPEC.md`) that survives session boundaries
- Starting a fresh session after the spec is written gives implementation clean context — no spec-drafting noise mixed into the build
- No prompt engineering tricks required for codebase questions; directness is the technique

### How Does It Work?

**Codebase questions:**
Ask directly. Examples from the docs:
- "How does logging work?"
- "What edge cases does `CustomerOnboardingFlowImpl` handle?"
- "Why does this code call `foo()` instead of `bar()` on line 333?"

Claude uses its file-reading and grep tools to locate relevant code and synthesizes an answer.

**Claude interviews you:**
Use this prompt pattern:
```
I want to build [brief description]. Interview me in detail using the AskUserQuestion tool.

Ask about technical implementation, UI/UX, edge cases, concerns, and tradeoffs.
Don't ask obvious questions, dig into the hard parts I might not have considered.

Keep interviewing until we've covered everything, then write a complete spec to SPEC.md.
```

Then start a **new session** to implement. The spec becomes the shared contract between the interview session and the build session.

## L2 — Understanding

### Why Does It Work?

Codebase questions work because Claude has full read access and can synthesize across files — it sees relationships a human skimming files would miss. The bottleneck shifts from "finding the code" to "understanding the code," which is where Claude adds value.

The interview pattern works because Claude knows common implementation pitfalls and edge cases from training on a vast corpus of code and design discussions. It can ask the questions a senior engineer would ask before building — questions the builder often skips when excited about implementation.

The session separation (spec in one session, build in another) works because context window cleanliness is a real performance factor: a session that produced a spec has noise (deliberation, alternatives considered) that biases implementation.

### Why Not?

- Claude's codebase answers are only as good as its read access — it won't surface patterns in files it hasn't been pointed to
- The interview pattern adds upfront time; it's overkill for small, well-defined tasks
- Claude may ask redundant questions if the initial description is too vague — provide enough context to let it skip obvious questions
- A SPEC.md produced by Claude still needs human review before the build session starts

## L3 — Application

### So What Benefit?

Treating Claude as a senior engineer during onboarding reduces ramp-up time and load on human teammates. The interview pattern catches design gaps before code is written — reversing a spec costs nothing; reversing 500 lines of code costs hours.

### Now What? (Next Actions)

1. Next time onboarding to a codebase, run 5 "how does X work?" questions before touching code
2. For any feature >1 day of work, use the interview prompt and produce a SPEC.md first
3. After a spec session, always open a new session (`claude`) before implementing — resist continuing in the same window

## Sources

- `captured/claude-code-docs-full.md` lines 1403–1440 ("Communicate effectively")
- `captured/claude-code-docs-full.md` lines 1644–1652 ("Develop your intuition")

## Links

[[session-management]]
[[automation-and-scaling]]
[[skills-and-subagents]]
