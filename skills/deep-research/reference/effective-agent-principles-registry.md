# Effective Principles Registry — Agent-Readable Codex

> **Purpose:** Canonical registry of all Effective Principles (EPs) extracted from the Agent Mastery Training Programme (AMT). Each EP is an actionable design principle grounded in one or more LLM Truths (LTs) or Universal Truths (UTs). Use these when designing systems, zones, skills, hooks, rules, or any artifact where the agent must compensate for structural AI limitations.
>
> **How to use this file:**
> - **Human Director:** Read the principle statement and "Without This" to understand what each EP protects against. Use the tag (DERISK/OUTPUT) to prioritise: DERISK principles are non-negotiable constraints; OUTPUT principles enable quality.
> - **Agent:** When designing or reviewing any artifact, scan the EP table for applicable principles. Check the "Compensates" column against the task's failure modes. If an EP applies and is not addressed, flag it.
>
> **Source:** AMT Sessions 0, 0.5, 3, 4, 5 (OPS_OE.6.0.LTC-OPERATING-SYSTEM-DESIGN/research/amt/)
> **Coverage:** 5 of 10 sessions written. 7 components covered (Agent, Environment, Input, EOP; EO, EPS, Tools pending). Registry will grow as Sessions 1–2 and 6–9 are authored.
> **Last Updated:** 2026-03-25

---

## Part 1 — EP Quick Reference Table

| # | Component | Principle | Tag | LT/UT Grounding | One-Liner |
|---|-----------|-----------|-----|-----------------|-----------|
| EP-01 | Agent | Brake Before Gas | DERISK | UT#5 | Derisk first, drive output second. Every action, every component, every task. |
| EP-02 | Agent | Know the Physics | DERISK | LT-1 through LT-8 | The 8 LLM Truths are structural constraints, not bugs. Design around them. |
| EP-03 | Agent | Two Operators, One System | OUTPUT | UT#2 + UT#6 | Human judgment + Agent execution, integrated through the 7-CS. Neither can do the other's job. |
| EP-04 | Environment | Load What You Need | DERISK | LT-2 + LT-7 | Every file the agent sees costs tokens and attention. Load only what this task requires. |
| EP-05 | Environment | Gates Before Guides | DERISK | LT-8 + LT-1 | Non-negotiable rules → deterministic mechanisms. Judgment rules → probabilistic mechanisms. |
| EP-06 | Environment | Derisk-First Setup | DERISK | LT-8 | Configure what prevents damage before what enables output. Permissions before CLAUDE.md. Hooks before skills. |
| EP-07 | Input | Amnesia-First Design | DERISK | LT-6 | Design every Input as if the agent has never seen your project — because it hasn't. |
| EP-08 | Input | Signal Over Volume | DERISK | LT-2 + LT-4 | Every unnecessary token actively degrades the agent's ability to use the tokens that matter. |
| EP-09 | Input | Decompose Before You Delegate | DERISK | LT-3 | Break complex tasks into agent-digestible pieces before sending them. |
| EP-10 | Input | Define Done | OUTPUT | LT-5 + LT-8 | Embed testable success criteria so the agent can verify its own work before reporting completion. |
| EP-11 | EOP | Gate Every Step | DERISK | LT-1 + LT-3 | Place binary pass/fail validation gates between procedure steps. Errors caught at origin cost nothing; errors caught after compounding cost everything. |
| EP-12 | Environment | Budget Your Context | DERISK | LT-2 + LT-4 | Explicitly allocate context budget across EPS, Input, EOP, and reasoning. Everything that enters context has a cost; what doesn't enter has zero cost. |
| EP-13 | Environment | Engineer Your Persistence | DERISK | LT-6 | Every session starts from zero. If you don't engineer persistence externally (CLAUDE.md, auto-memory, hooks, vault), you repeat work. If you don't protect against context rot, you lose work mid-session. |
| EP-14 | Environment | Layer Your Security | DERISK | LT-8 + LT-3 | No single security layer is sufficient. Use defense-in-depth: permissions (what tools), sandbox (what filesystem/network), hooks (deterministic enforcement). |

**Distribution:** 12 DERISK, 2 OUTPUT. This reflects UT#5: managing failure risk is more important than maximising output.

---

## Part 2 — Full EP Specifications

Each EP below follows this structure:

```
EP-{NN}: {Name} [{Tag}]
Component:    Which UT#1 component this principle governs
Statement:    The principle in one sentence
Grounded in:  Which LT(s) or UT(s) create the need for this principle
Without this: What happens when this principle is violated
Compensated by: Which 7-CS mechanisms implement this principle
Patterns:     Named patterns from the AMT that apply this principle
Source:       AMT session and section reference
```

---

### EP-01: Brake Before Gas [DERISK]

**Component:** Agent (governs all components — the meta-principle)

**Statement:** For every action — per component, per task, per system — identify and reduce failure risks first (release the brake), then maximise output second (hit the gas).

**Grounded in:** UT#5 — Real-World Success = efficient and scalable management of risks. Skipping the derisk step is the single most common failure mode for both humans and AI agents. The priority order is always: Sustainability → Efficiency → Scalability.

**Without this:** You optimise for speed and compound errors. The agent produces a 2,000-word report in 90 seconds — on the wrong topic, using the wrong sources. By the time you notice, the context window is polluted and the session is wasted.

**Compensated by:** EOP (risk gates at each step), EPS (rules that enforce validation before output), Input (scope the task before delegating).

**Patterns:**
- The Derisk Checklist (Session 0 §4): Before delegating any task, list what can go wrong → which LT → which component should compensate → is it configured?
- The Blame Diagnostic (Session 0 §4): When output is wrong, walk EPS → Input → EOP → Environment → Tools → Agent. Blame the model only after checking all 5 other components.

**APEI Application:** Every zone boundary is a derisk gate. Zone 2 exists because of this principle — no execution until risks are identified and mitigated.

**Source:** AMT Session 0, §3

---

### EP-02: Know the Physics [DERISK]

**Component:** Agent (foundation layer — informs all other EPs)

**Statement:** The 8 LLM Truths are structural constraints, not bugs. Every component in the 7-CS exists to compensate for at least one. Learn what cannot change so you stop trying to change it.

**Grounded in:** LT-1 through LT-8 — transformer architecture, training objectives, mathematical proofs. Hallucination is a proven mathematical inevitability (arxiv 2401.11817). Context degradation, reasoning limits, alignment drift — all structural, all compensable, none fixable by waiting for the next model.

**Without this:** You blame the model instead of fixing your configuration. You wait for GPT-6 instead of writing a CLAUDE.md. You have a world-class analyst with no research standards, no source material, and no procedure — and you wonder why the output is wrong.

**Compensated by:** All 6 non-Agent components — each exists to compensate for specific LTs.

**Patterns:**
- The LT Audit (Session 0 §4): For every configuration rule, ask "Which LT does this compensate for?" Rules that can't be mapped to an LT are noise.

**The 8 LLM Truths (quick reference):**

| LT | Truth | Bottleneck | Compensated By |
|----|-------|-----------|---------------|
| LT-1 | Hallucination is structural | Factual accuracy | EPS (validation rules), Tools (fact-checking), Input (provide sources) |
| LT-2 | Context compression is lossy | Volume of info loaded | Environment (context budget), Input (load only what's needed), EPS (concise rules) |
| LT-3 | Reasoning degrades on complex tasks | Number of logical steps | EOP (break into sub-steps), Input (decompose tasks), Environment (extended thinking budget) |
| LT-4 | Retrieval is fragile under token limits | Precision in noisy context | Input (label and structure clearly), Tools (dedicated search), Environment (reduce noise) |
| LT-5 | Prediction optimises plausibility, not truth | Truth vs sounding right | EPS (require evidence), Tools (verification), Human judgment |
| LT-6 | No persistent memory across sessions | Memory between sessions | Input (load session state), Tools (memory vault), EPS (context loading rules) |
| LT-7 | Cost scales with token count | Budget | Input (lean context), EPS (concise rules), Environment (budget limits) |
| LT-8 | Alignment is approximate | Rule compliance under pressure | EPS (clear boundaries), EOP (verification gates), Human oversight |

**APEI Application:** Zone boundaries are context window boundaries (LT-2, LT-6). .exec/ files must be self-contained engineered Input because the Zone 3 agent cannot carry Zone 1 + Zone 2 context.

**Source:** AMT Session 0, §3 + §5

---

### EP-03: Two Operators, One System [OUTPUT]

**Component:** Agent (defines the Human-Agent collaboration model)

**Statement:** The Human Director and the LLM Agent have complementary failure modes and complementary strengths. The 7-Component System is what makes them work together.

**Grounded in:** UT#2 (every system has UBS blocking forces and UDS driving forces) + UT#6 (personal biases distort human judgment). The Human's weaknesses are cognitive shortcuts (System 1: availability heuristic, anchoring, confirmation bias, affect heuristic, self-serving attribution). The Agent's weaknesses are the 8 LTs. Neither can compensate for their own blind spots, but each can compensate for the other's.

**Without this:** You either micromanage (which neutralises the Agent's strengths: parallelism, exhaustive analysis, no ego) or over-delegate (which runs straight into the Agent's limits: hallucination, no memory, plausibility over truth) with no guardrails.

**The Two Operators:**

| Operator | Role | Strengths (UDS) | Weaknesses (UBS) |
|----------|------|-----------------|-------------------|
| **Human Director** (Accountable) | Decides scope, judges quality, owns the deliverable | Domain expertise, strategic judgment, ethical oversight, creative direction (System 2) | Cognitive shortcuts: availability, anchoring, confirmation bias, affect heuristic (System 1) |
| **LLM Agent** (Responsible) | Reads sources, synthesizes at speed, drafts with consistency | Parallelism, exhaustive analysis, no ego, consistent rule following | The 8 LTs: hallucination, lossy context, reasoning degradation, no memory, plausibility bias, approximate alignment |

**Two shared forces:**
- **Compute-Efficient Forces** (Agent) mirror **Bio-Efficient Forces** (Human). Both default to shortcuts under pressure.
- **Orchestration System Belief** (Agent) mirrors **Support System Belief** (Human). Both perform better within structured frameworks.

**Compensated by:** The 7-CS itself — the integration layer that connects the two operators. EPS constrains both. EOP guides both. Environment protects both.

**APEI Application:** Human Director owns ALIGN + PLAN (judgment-heavy). Agent Team owns EXECUTE (execution-heavy). Zone 4 IMPROVE is the feedback loop connecting them. RACI separation: R ≠ A (UT#9).

**Source:** AMT Session 0, §3 + §5

---

### EP-04: Load What You Need [DERISK]

**Component:** Environment (token budget allocator)

**Statement:** Every file Claude sees costs tokens and attention. Load only what this task requires; park everything else where Claude can find it on demand.

**Grounded in:** LT-2 (context compression is lossy — dominant failure mode, root cause in 7 of 10 anti-patterns) + LT-7 (cost scales with token count). The "Lost in the Middle" phenomenon causes 30%+ performance drop for information in the middle of long contexts. Effective context utilisation is 30-70% of nominal window on straightforward tasks, dropping to 15-30% on complex reasoning.

**Without this:** You dump your entire codebase or reference library into context. The agent drowns in noise, misses the critical file, and produces generic output. A session requiring 300 tokens of relevant context loads 2,100 tokens from an oversized CLAUDE.md — 86% waste.

**Compensated by:** Environment (context budget limits, progressive disclosure), EPS (routing index pattern — CLAUDE.md under 200 lines), Skills (loaded on demand, ~15K token recovery per session).

**Patterns:**
- The 200-Line CLAUDE.md (Session 0.5 §4): CLAUDE.md is a routing index, not a knowledge base. Route to `.claude/rules/` and `.claude/skills/` for details.
- Context Layering (Session 3 §4): Structure context in tiers — always-loaded, on-demand, and agent-discovered.
- Bookend Positioning (Session 3 §4): Place critical info at start and end of Input. Less critical in the middle (lower attention zone).

**APEI Application:** Each zone loads only its own reference docs. Zone 2 does not carry Zone 1 artifacts into every session — only the distilled PLANNING_BASELINE.md. .exec/ task files embed only the relevant slice of risk/architecture, not the full registers.

**Source:** AMT Session 0.5, §3 + AMT Session 3, §4

---

### EP-05: Gates Before Guides [DERISK]

**Component:** Environment (enforcement reliability hierarchy)

**Statement:** For rules that must be followed 100% of the time, use deterministic mechanisms (hooks, permissions). For rules that require judgment, use probabilistic mechanisms (skills, CLAUDE.md). Never rely on the agent's judgment for non-negotiable constraints.

**Grounded in:** LT-8 (alignment is approximate — the agent can drift from instructions under context pressure) + LT-1 (hallucination is structural — the agent can confidently violate rules it has "forgotten" mid-session).

**Without this:** You put "never commit .env files" in CLAUDE.md, and it works 95% of the time. The 5% failure happens when the context window is full and the agent skips past the rule. One bad session exposes your API keys.

**The Enforcement Hierarchy:**

| Level | Mechanism | Reliability | Example |
|-------|-----------|-------------|---------|
| 1 (highest) | Hooks (deterministic) | 100% — always executes, zero exceptions | gitleaks pre-commit blocks secrets |
| 2 | Permissions (deterministic) | 100% — hard deny cannot be overridden | `permissions.deny: ["Read(.env)"]` |
| 3 | Rules (probabilistic-high) | ~95% — always loaded, but can be lost in context | Path-scoped `.claude/rules/` |
| 4 | Skills (probabilistic-medium) | ~90% — loaded on demand, judgment-dependent | `.claude/skills/` procedures |
| 5 (lowest) | CLAUDE.md (probabilistic) | ~85% — always loaded but competes for attention | Inline instructions |

**Compensated by:** Environment (hooks, permissions — deterministic layer), EPS (rules — high-reliability layer), EOP (skills — on-demand layer).

**APEI Application:** Zone boundary gates (e.g., "no Zone 3 work without .exec/") must be hooks (deterministic), not CLAUDE.md instructions (probabilistic). The enforcement stack per zone: Hooks > Rules > Skills > CLAUDE.md.

**Source:** AMT Session 0.5, §3

---

### EP-06: Derisk-First Setup [DERISK]

**Component:** Environment (safety barriers before enablement)

**Statement:** Configure what prevents damage before configuring what enables output. Permissions before CLAUDE.md. Hooks before skills. Deny rules before allow rules.

**Grounded in:** Session 0's "Brake Before Gas" applied to project setup + LT-8 (alignment is approximate). The agent has full access from the moment a session starts. If guardrails are not in place first, one bad interaction can overwrite files, expose secrets, or hallucinate into production code.

**Without this:** You spend 30 minutes writing a beautiful CLAUDE.md with research standards, then the agent reads your .env file containing API keys in its first action. The order matters: lock the dangerous drawers before arranging the reference materials.

**The 7-Step Derisk-First Setup Order:**

| Step | What | LT Compensated |
|------|------|---------------|
| 1 | Permissions (`.claude/settings.json`) — deny dangerous operations | LT-8 |
| 2 | CLAUDE.md — constitutional rules, under 200 lines | LT-2 |
| 3 | Hooks — deterministic gates that cannot be skipped | LT-1 |
| 4 | Rules (`.claude/rules/`) — path-scoped progressive disclosure | LT-2 |
| 5 | Skills (`.claude/skills/`) — on-demand procedures | LT-3, LT-7 |
| 6 | Stages — workflow structure for multi-step tasks | LT-3, LT-6 |
| 7 | Cross-platform — portability (GEMINI.md, .cursor/rules/) | LT-8 |

**Compensated by:** Environment (setup order), EPS (deny-before-allow rule), the 3-Layer Defense-in-Depth model (Layer 1: .gitignore passive defense → Layer 2: Agent EPS self-enforcement → Layer 3: Pre-commit hook hard gate).

**APEI Application:** When scaffolding a new project from this template, follow the 7-step order. When designing zone enforcement, install hooks (deterministic) before writing rules (probabilistic). Zone 0 (Agent Governance) exists because of this principle.

**Source:** AMT Session 0.5, §3 + §4

---

### EP-07: Amnesia-First Design [DERISK]

**Component:** Input (context engineering for stateless sessions)

**Statement:** Design every Input as if the agent has never seen your project before — because it hasn't.

**Grounded in:** LT-6 (no persistent memory across sessions). Every session starts completely blank. The agent has zero memory of yesterday's work, last week's decisions, or the context you built up in a prior session. Everything it knows comes from what you load into this session's context window. If you don't provide it, it doesn't exist.

**Without this:** You say "continue where we left off" and the agent invents a plausible but wrong prior state. Every session without amnesia-first design risks building on fiction. Monday: you established Competitor X exited the market. Thursday: new session. The agent treats Competitor X as an active threat and recommends defending against them.

**Compensated by:** Input (load session state, prior decisions, relevant history), Tools (memory vault systems that persist between sessions), EPS (rules specifying what to load at session start).

**Patterns:**
- Session Handoff (Session 3 §4): At session end, capture what was done, what's pending, key decisions, traps, file paths. At session start, load this before anything else.
- The `/session-start` and `/session-end` skills implement this pattern in the LTC system.

**APEI Application:** Zone boundaries are session boundaries. The .exec/ task files must be self-contained because the Zone 3 agent has no memory of Zone 2 discussions. Every zone output must carry enough context for the next zone to work from scratch.

**Source:** AMT Session 3, §3

---

### EP-08: Signal Over Volume [DERISK]

**Component:** Input (context quality over quantity)

**Statement:** Every unnecessary token in the context window actively degrades the agent's ability to find and use the tokens that matter.

**Grounded in:** LT-2 (context compression is lossy) + LT-4 (retrieval is fragile under token limits). Out of 50,000 tokens, only ~10,000-15,000 may be actively utilised — approximately 70% waste. The "Lost in the Middle" phenomenon causes 30%+ accuracy degradation for information positioned in the centre of context.

**Without this:** You dump your entire codebase into context. The agent drowns in noise, misses the critical file, and produces generic code. Claude Code uses 5.5x fewer tokens than Cursor — because it loads context progressively, not all at once.

**Compensated by:** Input (lean context, progressive loading), Environment (context budget management), EPS (concise rules that don't eat the budget).

**Patterns:**
- Context Layering (Session 3 §4): Always-loaded (CLAUDE.md, ~200 lines) → On-demand (path-scoped rules, skills) → Agent-discovered (subagent exploration).
- Bookend Positioning (Session 3 §4): Critical info at start (primacy) and end (recency). Background in the middle.

**APEI Application:** Each .exec/ task file embeds only the slice of risk/architecture relevant to THAT task — not the full UBS register. Zone README files route to artifacts, they don't duplicate content. The planning baseline is a distillation, not a copy of Zone 1.

**Source:** AMT Session 3, §3

---

### EP-09: Decompose Before You Delegate [DERISK]

**Component:** Input (task sizing as a design decision)

**Statement:** Break complex tasks into agent-digestible pieces before sending them — task size is an Input decision that determines success probability.

**Grounded in:** LT-3 (reasoning degrades on complex tasks). METR benchmarks show Claude's 50% success horizon is approximately 1 hour of human-equivalent work. Adaptive decomposition (ADaPT, NAACL 2024) outperforms single-shot prompting by 28-33%. Configurations with 7+ reasoning steps per task drop to 38% success rate.

**Step-decay math:** If each step succeeds at 90%, then 0.9^7 ≈ 48% end-to-end success. Breaking 12 steps into 3 sub-tasks of 4 steps each gives the same raw probability — but each sub-task stays within the model's reliable range, context stays clean (LT-2/LT-8 don't compound), and retry is cheap (redo 4 steps, not 12).

**Without this:** You send "build auth with OAuth, JWT, rate limiting, and audit logging" as one request. The agent implements OAuth, fumbles JWT, skips rate limiting, forgets logging. Four focused requests would each succeed where one compound request fails.

**Compensated by:** Input (decompose before sending), EOP (procedures with sub-steps and checkpoints), the Agent Architecture Decision Tree (maps task count × complexity to single agent / sub-agents / agent teams).

**Patterns:**
- Spec-Driven Development (Session 3 §4): Write a structured spec before asking the agent to code. Collaborate to write the spec first (separate session), then start a fresh session to execute.
- Task-Type Templates (Session 3 §4): Different task types need different Input structures (bug fix template, feature implementation template).

**APEI Application:** The .exec/ task file format decomposes deliverables → tasks → increments. Each task targets ~1hr human-equivalent work (the 50% success horizon). The Agent Architecture Decision Tree in project.md determines whether tasks run as single agent, sub-agents, or agent teams based on count × complexity.

**Source:** AMT Session 3, §3

---

### EP-10: Define Done [OUTPUT]

**Component:** Input (self-verification criteria)

**Statement:** Embed testable success criteria in every Input so the agent can verify its own work before reporting completion.

**Grounded in:** LT-5 (prediction optimises plausibility, not truth) + LT-8 (alignment drift). The agent was trained to produce plausible output, not correct output. Without explicit success criteria, it optimises for "sounds right" rather than "is right." Anthropic calls verification criteria "the single highest-leverage thing you can do" for agentic coding.

**Without this:** "Write a login function" produces code that looks correct but handles no edge cases and has no tests. You become the only feedback loop. "Write a good brief" is a wish. "3-page brief covering Q3 revenue trends for top 4 competitors, with source citations from SEC filings" is an order the agent can self-verify against.

**Compensated by:** Input (success criteria embedded in every prompt or spec), EOP (verification gates at each step), EPS (rules requiring acceptance criteria).

**Patterns:**
- Spec-Driven Development (Session 3 §4): The spec includes acceptance criteria the agent can check.
- VANA Grammar (UT#3): Verb + Adverb + Noun + Adjective. Every requirement has a binary acceptance criterion.

**APEI Application:** Every .exec/ task file contains: VANA traceability, acceptance criteria (binary, deterministic), Definition of Done, and a Verify command (bash command proving task completion). The agent can self-check before reporting done. The readiness-check validates that every task has these fields populated.

**Source:** AMT Session 3, §3

---

### EP-11: Gate Every Step [DERISK]

**Component:** EOP (validation gates within procedures)

**Statement:** Place binary pass/fail validation gates between procedure steps. Errors caught at their origin cost nothing; errors caught after compounding cost everything.

**Grounded in:** LT-1 (hallucination is structural — the agent cannot reliably self-validate) + LT-3 (reasoning degrades on complex tasks — multi-step procedures are where errors compound). Without explicit gates between steps, an error in step 2 silently propagates through steps 3–8, compounding into an unrecoverable output.

**Without this:** You write a 6-step deployment procedure with no checkpoints. The build fails silently in step 1, but the agent continues through steps 2–6, deploying a broken artifact. A single gate after step 1 (`exit code must be 0`) would have caught it. The TDD red-green-refactor cycle illustrates the pattern: RED (verify test quality) → GATE → GREEN (minimal implementation) → GATE → REFACTOR (improve) → GATE.

**Step-decay math:** If each step succeeds at 90% and errors in earlier steps make later steps fail, then 0.9^6 ≈ 53% end-to-end success without gates. With gates after every 2 steps (3 checkpoints), failed steps are caught and retried before compounding: effective success rises to ~80%+ because retry is cheap (redo 2 steps, not 6).

**Compensated by:** EOP (GATE keyword + "Do NOT proceed until..." phrasing), EPS (rules requiring gates in all multi-step skills), Input (acceptance criteria per step).

**Patterns:**
- The GATE Keyword (Session 4 §5): Use explicit `GATE: [condition]` markers between steps. The word GATE is a strong activation signal for agent compliance.
- Before/After Pattern (Session 4 §6): Bad EOP: "1. Build 2. Test 3. Deploy." Good EOP: "1. Build — GATE: exit 0. 2. Test — GATE: 0 failures. 3. Deploy staging — GATE: 200 OK. 4. Deploy production — GATE: health check passes."
- Escape Hatch (Session 4 §6): After 3 failed gate attempts, escalate to the user rather than silently weakening the gate condition.

**APEI Application:** Every .exec/ task file must contain at least one validation gate. Zone boundary transitions are gates. The readiness-check script validates that gates exist in every task file.

**Source:** AMT Session 4, §5 (Doc-12-Session-4-Research-EOP.md)

---

### EP-12: Budget Your Context [DERISK]

**Component:** Environment (context budget as a finite resource)

**Statement:** Explicitly allocate context budget across EPS, Input, EOP, and reasoning. Everything that enters context has a cost; what doesn't enter has zero cost.

**Grounded in:** LT-2 (context compression is lossy) + LT-4 (retrieval is fragile under token limits). On a 200K context window, ~30% is consumed by system overhead before a single user token is processed: system prompt (~1.3%), built-in tools (~8.4%), custom agents (~0.7%), memory files (~3.7%), skills metadata (~0.5%), autocompact buffer (~16.5%). On a 1M window the ratios are the same — usable space is ~830K, not 1M.

**Without this:** You load a 2,000-line CLAUDE.md, 15 always-on rules, and 50 skill descriptions. Before the user types a word, 40% of context is consumed. The agent has 60% remaining for the actual task — and instruction compliance drops noticeably after ~150–200 distinct rules (the "instruction cliff"). You've optimised for comprehensiveness and achieved mediocrity.

**The Context Budget Breakdown (200K window):**

| Consumer | Tokens | % of 200K | Persistence |
|----------|--------|-----------|-------------|
| System prompt | ~2,700 | 1.3% | Every session |
| Built-in tools | ~16,800 | 8.4% | Every session |
| Custom agents/subagents | ~1,300 | 0.7% | Every session |
| Memory files (CLAUDE.md + auto-memory) | ~7,400 | 3.7% | Every session |
| Skills metadata | ~1,000 | 0.5% | Every session |
| Autocompact buffer (reserved) | ~33,000 | 16.5% | Reserved |
| **Available for work** | **~137,800** | **~69%** | Until compaction |

**Compensated by:** Environment (.claudeignore for 40–70% token reduction, path-scoped rules, on-demand skills), Input (lean context, progressive loading), EPS (concise rules — CLAUDE.md under 200 lines as routing index).

**Patterns:**
- The 5 Strategies of Context Engineering (Session 5 §3): Selection → Compression → Ordering → Isolation → Format Optimization.
- Context Rot Prevention (Session 5 §3): `/clear` between unrelated tasks, custom compaction instructions, session-start hooks that re-inject critical context, subagent delegation for noisy exploration.
- The 150–200 Instruction Cliff (Session 5 §3): CLAUDE.md compliance drops after ~150–200 distinct instructions. This is the practical ceiling for always-on EPS.

**APEI Application:** Each zone loads only its own context. Zone artifacts route to detail (don't duplicate content). CLAUDE.md is a routing index under 200 lines. Skills load on demand (~30–50 tokens at rest vs. full body on activation). Subagents isolate research noise from the main context window.

**Source:** AMT Session 5, §12.1 (Doc-13-Session-5-Research-Environment.md)

---

### EP-13: Engineer Your Persistence [DERISK]

**Component:** Environment (session lifecycle and state management)

**Statement:** Every session starts from zero. If you don't engineer persistence externally, you repeat work. If you don't protect against context rot, you lose work mid-session.

**Grounded in:** LT-6 (no persistent memory across sessions). The agent has zero memory of yesterday's work, last week's decisions, or any prior session. Everything it knows comes from what the Environment loads into the current context window. Additionally, within a session, auto-compaction is lossy — critical instructions from early messages get summarised away ("context rot").

**Without this:** Monday: you and the agent spend 45 minutes establishing architecture decisions. Tuesday: new session. The agent has zero knowledge of Monday's decisions — you either re-explain everything (wasting 45 minutes) or the agent invents plausible but wrong prior state. Mid-session: after 3 hours of work, the agent "forgets" your CLAUDE.md instructions because auto-compaction summarised them away.

**The 5 Persistence Mechanisms (Claude Code):**

| Mechanism | What persists | Loaded how | Survives compaction? |
|-----------|--------------|-----------|---------------------|
| CLAUDE.md | Team rules, conventions | Automatic, every session | Yes (system prompt) |
| Auto-memory | Corrections, preferences | Automatic, every session | Yes (system prompt) |
| Session resume | Full conversation history | `--continue` / `--resume` | N/A (restores session) |
| Session naming | Session identifiers | `/rename` | N/A |
| Memory Vault hooks | Custom state | SessionStart / Stop hooks | Yes (external files) |

**Context rot symptoms:** Agent "forgets" instructions mid-session. Earlier corrections stop being applied. Quality degrades over time. Agent makes errors it didn't make earlier.

**Context rot prevention:** `/clear` between unrelated tasks (cheapest, most effective). Custom compaction instructions: "When compacting, always preserve...". Session-start hooks that re-inject critical context. Subagent delegation for noisy exploration.

**Compensated by:** Environment (hooks for session lifecycle, auto-memory, session resume), Tools (Memory Vault persistence), EPS (rules specifying what to load at session start), Input (session handoff files).

**Patterns:**
- The Session Lifecycle Pattern (Session 5 §7): SessionStart → load vault + query tasks + present standup. Working session → tasks + /compact + /clear. SessionEnd → persist state + update tasks + git commit.
- The `/session-start` and `/session-end` skills implement this pattern in the LTC system.
- PreCompact/PostCompact hooks (Session 5 §4): Save critical state before compaction, re-inject after.

**APEI Application:** Zone boundaries are session boundaries. The .exec/ task files must be self-contained because the Zone 3 agent has no memory of Zone 2 discussions. Session-start hooks load project state. Session-end hooks persist progress. The Memory Vault pattern bridges sessions with structured state files.

**Source:** AMT Session 5, §7 + §12.1 (Doc-13-Session-5-Research-Environment.md)

---

### EP-14: Layer Your Security [DERISK]

**Component:** Environment (defense-in-depth security model)

**Statement:** No single security layer is sufficient. Use defense-in-depth: permissions (what tools the agent can use), sandbox (what filesystem and network the agent can access), hooks (deterministic enforcement of security policies). Advisory instructions degrade under context pressure.

**Grounded in:** LT-8 (alignment is approximate — the agent can drift from instructions under context pressure) + LT-3 (reasoning degrades on complex tasks — security rules are the first to be forgotten when the agent is under cognitive load). Putting "never read .env" in CLAUDE.md works ~85% of the time. The 15% failure is when context is full and the agent skips past the rule — exposing your API keys.

**Without this:** You rely on a single CLAUDE.md instruction: "Do not read .env files." The agent follows this 85% of the time. One complex session with a full context window, and the agent reads .env, loads your API keys into context, and potentially transmits them to the model provider. A permission deny rule (`Read(.env)` in settings.json) would have blocked this 100% of the time, regardless of context pressure.

**The Security Triad:**

| Layer | Mechanism | Reliability | What it protects |
|-------|-----------|-------------|-----------------|
| 1. Permissions | `settings.json` allow/deny rules | 100% — evaluated before any tool runs | Tool access (what the agent can do) |
| 2. Sandbox | OS-level isolation (Seatbelt/bubblewrap) | 100% — OS-enforced, agent cannot bypass | Filesystem + network (what the agent can reach) |
| 3. Hooks | PreToolUse event handlers | 100% — deterministic, guaranteed execution | Policy enforcement (custom security logic) |
| 4. EPS (advisory) | CLAUDE.md / rules/ instructions | ~85–95% — probabilistic, degrades under context pressure | Behavioral guidance (what the agent should do) |

**The 3-Layer Defense-in-Depth Model:**
- Layer 1 (passive): `.gitignore` prevents secrets from entering the repository
- Layer 2 (agent-level): EPS self-enforcement — CLAUDE.md instructions about secrets handling
- Layer 3 (hard gate): Pre-commit hook (gitleaks) blocks secrets from ever being committed

**Compensated by:** Environment (permissions, sandbox, hooks — all deterministic), EPS (advisory layer for judgment-dependent security decisions), Tools (credential scanning, vault integration).

**Patterns:**
- Trail of Bits Security Config (Session 5 §11): Deny reads to all credential files (.env, .ssh, .aws, .gcloud). Sandbox with minimal write permissions. Network isolation with explicit domain allowlist. PreToolUse hooks to block destructive Bash commands.
- The Anti-Rationalization Gate (Session 5 §11): A Stop hook with a fast model catches the agent declaring victory prematurely — defense-in-depth at the decision point.
- Secrets Management (Session 5 §5): Permission deny rules → Sandbox denyRead → .claudeignore → Vault pattern (move secrets to external vault, access via CLI tools).

**APEI Application:** Zone 0 (Agent Governance) exists because of this principle. Setup order: permissions first, then hooks, then rules, then skills. Every zone enforces security through deterministic mechanisms (hooks, permissions), not advisory instructions alone. Production deployments require all three layers active.

**Source:** AMT Session 5, §5 + §12.1 (Doc-13-Session-5-Research-Environment.md)

---

## Part 3 — Coverage Map

### Sessions Written vs. Components Covered

| Session | Component | # EPs | Status |
|---------|-----------|-------|--------|
| **Session 0** | Agent | 3 | Written — EPs extracted |
| **Session 0.5** | Environment | 3 | Written — EPs extracted |
| Session 1 | EO (Outcome) | ? | Not yet written |
| Session 2 | EPS (Principles) | ? | Not yet written |
| **Session 3** | Input | 4 | Written — EPs extracted |
| **Session 4** | EOP (Procedures) | 1 | Written — EPs extracted |
| **Session 5** | Environment | 3 | Written — EPs extracted |
| Session 6 | Action | ? | Not yet written |
| Session 7 | Integration | ? | Not yet written |
| Session 8 | Mastery | ? | Not yet written |

### Components Without EPs Yet

| Component | Expected Session | Key LTs to Compensate | Likely EP Focus |
|-----------|-----------------|----------------------|-----------------|
| **EO (Outcome)** | Session 1 | LT-5 (plausibility ≠ truth) | Defining what success looks like, outcome verification |
| **EPS (Principles)** | Session 2 | LT-2 (conciseness), LT-8 (compliance) | Writing effective rules, constitutional constraints |
| **Tools** | Session 6+ | LT-1 (fact-checking), LT-4 (retrieval) | MCP servers, search, external verification |
| **Action** | Session 6+ | LT-3 (execution quality) | Agent execution patterns, debugging |

---

## Part 4 — Cross-Reference: EP × APEI Zone

How each EP applies to each APEI zone:

| EP | Zone 0 (Governance) | Zone 1 (ALIGN) | Zone 2 (PLAN) | Zone 3 (EXECUTE) | Zone 4 (IMPROVE) |
|----|-------------------|----------------|---------------|-----------------|-----------------|
| EP-01 Brake Before Gas | Setup order: safety first | Validate problem before solving | Derisk before optimise (S→E→Sc) | Risk gates between tasks | Review before institutionalise |
| EP-02 Know the Physics | Map every config to an LT | Understand domain constraints | Identify which LTs affect execution | Task files compensate for LTs | Log which LTs caused failures |
| EP-03 Two Operators | Define R ≠ A (UT#9) | Human owns alignment decisions | Human owns plan approval | Agent owns task execution | Both contribute to retrospective |
| EP-04 Load What You Need | CLAUDE.md ≤ 200 lines | Load only charter + requirements | Load only relevant risk/arch per WS | Task file = minimal viable context | Load only metrics + review data |
| EP-05 Gates Before Guides | Hooks > Rules > Skills | Entry gate: charter must exist | Entry gate: Zone 1 complete | Entry gate: .exec/ must exist | Exit gate: review approved |
| EP-06 Derisk-First Setup | Permissions → hooks → rules → skills | Risk conditions before OKRs | UBS register before architecture | Verify commands before coding | Failure log before improvements |
| EP-07 Amnesia-First | Session start loads project state | Zone 1 artifacts self-contained | Planning baseline snapshots Zone 1 | .exec/ files self-contained | Review artifacts reference evidence |
| EP-08 Signal Over Volume | Route, don't duplicate | Requirements are VANA (minimal) | Task files embed relevant slice only | One task = one agent-session focus | Metrics are focused, not exhaustive |
| EP-09 Decompose | Skills decompose complex procedures | Break requirements into VANA atoms | Break roadmap into ≤1hr tasks | One .exec/ task per agent session | Break retro into per-deliverable |
| EP-10 Define Done | Every rule has a verification method | Requirements have binary ACs | Every task has AC + Verify command | Agent self-checks before reporting | Review has pass/fail criteria |
| EP-11 Gate Every Step | Setup validation gates | Alignment checklist gates | Risk gates between plan steps | GATE keyword between task steps | Review gates per deliverable |
| EP-12 Budget Your Context | CLAUDE.md ≤ 200 lines, .claudeignore | Load only charter artifacts | Load only relevant slice per task | .exec/ = minimal viable context | Load only metrics needed |
| EP-13 Engineer Persistence | Auto-memory + session hooks | Zone 1 outputs self-contained | Planning baseline snapshots state | .exec/ carries all needed context | Retrospective artifacts persist learnings |
| EP-14 Layer Your Security | Permissions + sandbox + hooks | N/A (human-owned zone) | Validate .exec/ completeness | Sandbox + permission deny + hooks | Audit security config per retrospective |

---

## Part 5 — Diagnostic: Which EP Is Violated?

When something goes wrong, trace the symptom to the violated EP:

| Symptom | Likely Violated EP | Fix |
|---------|-------------------|-----|
| Agent rewrites half the codebase | EP-10 (Define Done) — no scope boundary | Add "do X and ONLY X, do NOT touch Y" |
| Agent invents prior context | EP-07 (Amnesia-First) — no session state loaded | Use session handoff file or MEMORY.md |
| Agent produces generic output ignoring architecture | EP-08 (Signal Over Volume) — context overloaded | Load only relevant files; use context layering |
| Agent implements OAuth when asked for login form | EP-09 (Decompose) — compound task | Break into focused sub-tasks |
| Agent says "looks correct" but code fails tests | EP-10 (Define Done) — no success criteria | Add verify command and acceptance criteria |
| Agent occasionally ignores critical rules | EP-05 (Gates Before Guides) — rule is in CLAUDE.md, not hook | Move non-negotiable rules to deterministic mechanisms |
| Session costs $4.80 instead of $0.40 | EP-04 (Load What You Need) — entire knowledge base loaded | Load only what this task needs |
| Agent drifts from instructions mid-task | EP-02 (Know the Physics, LT-8) — alignment is approximate | Add verification gates; shorter tasks |
| Rushed delegation, errors compound | EP-01 (Brake Before Gas) — skipped derisk step | 30-second derisk checklist before delegating |
| Human micromanages every step | EP-03 (Two Operators) — not trusting Agent strengths | Delegate analysis/execution; reserve judgment for yourself |
| Executed plan missed a critical risk | EP-01 (Brake Before Gas) + EP-06 (Derisk-First) — skipped Zone 2 | Never skip from ALIGN to EXECUTE |
| Zone 3 agent hallucinates requirements | EP-07 (Amnesia-First) + EP-08 (Signal Over Volume) — .exec/ files incomplete | .exec/ task files must be self-contained engineered Input |
| Error in step 2 silently ruins steps 3–8 | EP-11 (Gate Every Step) — no validation gates between steps | Add explicit GATE checkpoints with binary pass/fail conditions |
| Agent quality degrades mid-session | EP-12 (Budget Your Context) + EP-13 (Engineer Persistence) — context rot | /clear between tasks; compaction instructions; session hooks |
| Repeating the same work every session | EP-13 (Engineer Your Persistence) — no session lifecycle hooks | Add SessionStart/Stop hooks; use Memory Vault pattern |
| Agent reads .env despite CLAUDE.md rule | EP-14 (Layer Your Security) — advisory instruction, not deterministic gate | Add permission deny rule: `Read(.env)` in settings.json |
| Security rule violated under cognitive load | EP-14 (Layer Your Security) — single advisory layer | Move to 3-layer defense: permissions + sandbox + hooks |

---

## Appendix A — Glossary

| Term | Definition |
|------|-----------|
| **EP** | Effective Principle — an actionable design principle grounded in LTs or UTs |
| **LT** | LLM Truth — one of 8 structural limitations of AI models (LT-1 through LT-8) |
| **UT** | Universal Truth — one of 10 foundational truths + 2 derived truths from the LTC framework |
| **7-CS** | 7-Component System — EPS, Input, EOP, Environment, Tools, Agent, Action → Outcome |
| **DERISK** | EP tag: this principle mitigates a failure risk (manages UBS). Non-negotiable. |
| **OUTPUT** | EP tag: this principle enables quality output (drives UDS). Important but secondary to DERISK. |
| **VANA** | Verb-Adverb-Noun-Adjective — the requirements grammar from UT#3 |
| **APEI** | Align-Plan-Execute-Improve — the 4-zone operating system for human-agent collaboration |
| **UBS** | Ultimate Blocking System — root forces that block effective outcomes |
| **UDS** | Ultimate Driving System — root forces that drive effective outcomes |
| **S→E→Sc** | Sustainability → Efficiency → Scalability — the 3-pillar priority order from UT#5 |
| **GATE** | A binary pass/fail validation checkpoint between procedure steps (EP-11) |
| **Context rot** | Accuracy degradation as context length increases during a session — caused by lossy auto-compaction |
| **3-Stage Loading** | Metadata scan → Description match → Full body injection — the progressive loading model for skills/EOPs |
| **Defense-in-depth** | Layered security: permissions + sandbox + hooks + EPS (EP-14) |

---

*Registry maintained by: Long Nguyen + Claude (Research & Governance Agent)*
*Source material: AMT Sessions 0, 0.5, 3, 4, 5 — OPS_OE.6.0.LTC-OPERATING-SYSTEM-DESIGN/research/amt/*
*Update protocol: When a new AMT session is authored, extract its §3 principles and add to this registry.*
