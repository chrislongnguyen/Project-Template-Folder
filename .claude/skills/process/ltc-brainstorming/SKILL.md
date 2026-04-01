---
version: "1.2"
last_updated: 2026-03-30
owner: "Long Nguyen"
name: ltc-brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation. OE.6.4 fork with sectional sub-agent orchestration and extended VANA-SPEC output."
agents:
  search: ltc-explorer
  synthesis: ltc-planner
---
# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

**Agent dispatch:** For search/diverge phases, use `ltc-explorer` (`.claude/agents/ltc-explorer.md`) — fast, cheap, wide-net discovery. For synthesis/convergence, use `ltc-planner` (`.claude/agents/ltc-planner.md`) — architectural judgment. **Context packaging:** Every Agent() call must use the 5-field template in `.claude/skills/dsbv/references/context-packaging.md` (EO, INPUT, EP, OUTPUT, VERIFY).

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design and get user approval.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.
</HARD-GATE>

## Meta-Rules (re-injected — do NOT rely on CLAUDE.md for these)

Before ANY brainstorming action, apply these rules:

1. **MODEL AS SYSTEM:** Identify all 7 components (EP, Input, EOP, Environment, Tools, Agent, Action) for the system being designed. Never treat a task as isolated — always identify which components are in play and which are missing or misaligned.
   (Derived from: agent-system.md §5 — 7-Component System)

2. **UBS BEFORE UDS:** What blocks this system? Answer BEFORE asking what drives it. Ask: "What biases, dependencies, or environmental constraints threaten this outcome?"
   (Derived from: general-system.md §5 — Force Analysis)

3. **SUSTAINABILITY FIRST:** Risk-mitigated > efficient > scalable. A fragile fast system is worse than a slow reliable one. A sustainable 80% solution outperforms a fragile 100% solution.
   (Derived from: general-system.md §6 — S > E > Sc priority)

4. **VANA DECOMPOSE:** Every requirement = Verb + Adverb + Noun + Adjective. If you can't decompose it, you don't understand it.
   (Derived from: general-system.md §8 — ESD Phase 3)

5. **DEFINE DONE:** Every AC must be binary, deterministic, testable. "Good quality" is not an AC. "pytest passes with 0 failures" is.
   (Derived from: general-system.md §7 — Layer 3 Eval Spec)

These rules are grounded in: general-system.md §3-6, agent-system.md §3.
They are re-stated here because CLAUDE.md context may have degraded by the time this skill activates (LT-2, LT-4).

## Anti-Pattern: "This Is Too Simple To Need A Design"

Every project goes through this process. A todo list, a single-function utility, a config change — all of them. "Simple" projects are where unexamined assumptions cause the most wasted work. The design can be short (a few sentences for truly simple projects), but you MUST present it and get approval.

## Checklist

You MUST create a task for each of these items and complete them in order:

1. **Explore project context** — check files, docs, recent commits
2. **Offer visual companion** (if topic will involve visual questions) — this is its own message, not combined with a clarifying question. See the Visual Companion section below.
3. **Ask clarifying questions** — one at a time, understand purpose/constraints/success criteria
4. **Propose 2-3 approaches** — with trade-offs (use S/E/Sc framework from `references/trade-off-framework.md`) and your recommendation
5. **Present design** — in sections scaled to their complexity, get user approval after each section
6. **Write design doc** — produce extended VANA-SPEC (with §0 Force Analysis and §6 System Boundaries) using sectional sub-agent orchestration, save to `3-PLAN/architecture/specs/YYYY-MM-DD-<topic>-design.md` and commit
7. **Spec review loop** — dispatch spec-document-reviewer subagent with precisely crafted review context (never your session history); fix issues and re-dispatch until approved (max 3 iterations, then surface to human)
8. **User reviews written spec** — ask user to review the spec file before proceeding
9. **Transition to implementation** — invoke writing-plans skill to create implementation plan

## Process Flow

```
Flow: Confirm scope → Sub-agent explores → Draft VANA-SPEC → User reviews → Iterate or approve
```
**The terminal state is invoking writing-plans.** Do NOT invoke frontend-design, mcp-builder, or any other implementation skill. The ONLY skill you invoke after brainstorming is writing-plans.

## The Process

**Understanding the idea:**

- Check out the current project state first (files, docs, recent commits)
- Before asking detailed questions, assess scope: if the request describes multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, and analytics"), flag this immediately. Don't spend questions refining details of a project that needs to be decomposed first.
- If the project is too large for a single spec, help the user decompose into sub-projects: what are the independent pieces, how do they relate, what order should they be built? Then brainstorm the first sub-project through the normal design flow. Each sub-project gets its own spec -> plan -> implementation cycle.
- For appropriately-scoped projects, ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria
- **Apply META-RULE 2 (UBS BEFORE UDS):** Ask what blocks this system BEFORE exploring what drives it. Identify biases, dependencies, and environmental constraints early.

**Exploring approaches:**

- Propose 2-3 different approaches with trade-offs
- **Apply META-RULE 3 (SUSTAINABILITY FIRST):** Evaluate approaches using the S/E/Sc framework (see `references/trade-off-framework.md`): Sustainability > Efficiency > Scalability
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Presenting the design:**

- Once you believe you understand what you're building, present the design
- **Apply META-RULE 1 (MODEL AS SYSTEM):** Identify all 7 components (EP, Input, EOP, Environment, Tools, Agent, Action) for the system being designed
- Scale each section to its complexity: a few sentences if straightforward, up to 200-300 words if nuanced
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

## Sectional Sub-Agent Orchestration

When writing the VANA-SPEC, use sectional sub-agent orchestration and extended output format.

**Read `references/spec-production.md` before dispatching sub-agents.** It covers:
- 5-group sub-agent allocation (Identity, Behavioral, Quality, Structural, Synthesis)
- Dispatch protocol and failure behavior
- Extended §0 Force Analysis and §6 System Boundaries requirements

## After the Design

**Documentation:** Write the spec to `3-PLAN/architecture/specs/YYYY-MM-DD-<topic>-design.md` (user preferences override this default). Use elements-of-style:writing-clearly-and-concisely skill if available. Commit to git.

**Spec Review Loop:** Dispatch spec-document-reviewer subagent (see spec-document-reviewer-prompt.md). If issues found: fix, re-dispatch, repeat until Approved. Max 3 iterations, then surface to human.

**User Review Gate:** After review loop passes, ask user to review:
> "Spec written and committed to `<path>`. Please review it and let me know if you want to make any changes before we start writing out the implementation plan."

Wait for response. If changes requested, make them and re-run review loop. Only proceed once approved.

**Implementation:** Invoke writing-plans skill. Do NOT invoke any other skill — writing-plans is the ONLY next step.

## Key Principles

- **One question at a time** — multiple choice preferred when possible
- **YAGNI ruthlessly** — remove unnecessary features from all designs
- **Explore alternatives** — always propose 2-3 approaches before settling
- **Incremental validation** — present design, get approval before moving on
- Meta-Rules 2-5 (UBS first, S>E>Sc, VANA decompose, Define Done) apply throughout

## Visual Companion

A browser-based companion for showing mockups, diagrams, and visual options during brainstorming. Available as a tool — not a mode. Accepting the companion means it's available for questions that benefit from visual treatment; it does NOT mean every question goes through the browser.

**Offering the companion:** When you anticipate that upcoming questions will involve visual content (mockups, layouts, diagrams), offer it once for consent:
> "Some of what we're working on might be easier to explain if I can show it to you in a web browser. I can put together mockups, diagrams, comparisons, and other visuals as we go. This feature is still new and can be token-intensive. Want to try it? (Requires opening a local URL)"

**This offer MUST be its own message.** Do not combine it with clarifying questions, context summaries, or any other content. The message should contain ONLY the offer above and nothing else. Wait for the user's response before continuing. If they decline, proceed with text-only brainstorming.

**Per-question decision:** Even after the user accepts, decide FOR EACH QUESTION whether to use the browser or the terminal. The test: **would the user understand this better by seeing it than reading it?**

- **Use the browser** for content that IS visual — mockups, wireframes, layout comparisons, architecture diagrams, side-by-side visual designs
- **Use the terminal** for content that is text — requirements questions, conceptual choices, tradeoff lists, A/B/C/D text options, scope decisions

A question about a UI topic is not automatically a visual question. "What does personality mean in this context?" is a conceptual question — use the terminal. "Which wizard layout works better?" is a visual question — use the browser.

If they agree to the companion, read the detailed guide before proceeding:
`1-ALIGN/skills/ltc-brainstorming/references/visual-companion.md`
<!-- OE.6.4 fork note: path changed from original superpowers `skills/ltc-brainstorming/visual-companion.md`
     to `1-ALIGN/skills/ltc-brainstorming/references/visual-companion.md` to match the OE.6.4 directory convention. -->

## Gotchas

- **#1 failure mode: jumping to implementation** — agent sees a "simple" request and invokes writing-plans or starts coding without presenting a design. The HARD-GATE exists for this — no exceptions, even for trivial tasks.
- **Multiple questions in one message** — agent batches 3-5 questions to "save time." This overwhelms the user. ONE question per message, always.
- **Skipping UBS-before-UDS** — agent explores features before identifying constraints/risks. Meta-Rule 2 requires forces analysis first.

Full list (5 patterns): [gotchas.md](gotchas.md)

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[agent-system]]
- [[context-packaging]]
- [[documentation]]
- [[dsbv]]
- [[general-system]]
- [[gotchas]]
- [[idea]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[project]]
- [[simple]]
- [[spec-production]]
- [[task]]
- [[trade-off-framework]]
- [[visual-companion]]
