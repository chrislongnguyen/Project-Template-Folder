# LTC Effective System Rules — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Distill LTC's Effective System research into three canonical reference docs (`rules/agent-system.md`, `rules/general-system.md`, `rules/agent-diagnostic.md`) plus CLAUDE.md updates in the project template repo.

**Architecture:** 5-phase LT-aware execution. Phase 1 writes all 3 docs in parallel (fresh Opus subagents, each with isolated spec + sources — compensates LT-2/LT-3/LT-6). Phase 2 integrates sequentially (CLAUDE.md edit + cross-reference validation). Phase 3 audits all 3 docs in parallel (fresh subagents with no writing context — compensates LT-1/LT-5/LT-8 confirmation bias). Phase 4 fixes audit findings in parallel. Phase 5 commits.

**Spec:** `docs/superpowers/specs/2026-03-18-effective-system-rules-design.md`

---

## LT Risk Management Strategy

This plan is designed around the 8 LLM Truths to maximize output quality:

| Risk | LT | Compensation |
|---|---|---|
| Agent fills gaps with plausible but wrong content | LT-1, LT-5 | Each writing agent gets ONLY the source files it needs — no guessing. Separate audit agents verify against sources with fresh context (no confirmation bias from having written the content). |
| Long context degrades retrieval accuracy | LT-2, LT-4 | Each agent works on ONE doc with ONE spec section + relevant sources only. No accumulated conversation history. Fresh context per agent. |
| Complex multi-doc reasoning causes drift | LT-3 | Each doc is an independent task. Cross-references validated separately in Phase 2. No agent reasons about all 3 docs simultaneously. |
| No memory of design decisions between agents | LT-6 | Every agent receives the full spec section for its doc + implementation conventions from §5. Nothing assumed from prior context. |
| Wasted tokens on unnecessary context | LT-7 | Agents load only their relevant source files. No loading of all 7 sources when only 3 are needed. |
| Writing agent may drift from spec under complexity | LT-8 | Audit agents are structurally independent — they never see the writing agent's reasoning, only the output vs. sources. |

---

## File Map

| File | Action | Responsibility |
|---|---|---|
| `rules/agent-system.md` | CREATE | Task 1 (Phase 1, parallel) |
| `rules/general-system.md` | CREATE | Task 2 (Phase 1, parallel) |
| `rules/agent-diagnostic.md` | CREATE | Task 3 (Phase 1, parallel) |
| `CLAUDE.md` | MODIFY (lines 71-77, insert before Structure section) | Task 4 (Phase 2, sequential) |

---

## Phase 1: Parallel Write (3 independent Opus subagents)

Each agent receives: (a) the spec section for its doc, (b) the implementation conventions from spec §5, (c) ONLY the source files it needs. No other context.

---

### Task 1: Write `rules/agent-system.md`

**Agent type:** Opus subagent (fresh context, worktree isolation)
**Files:**
- Create: `rules/agent-system.md`

**Context to inject into subagent prompt:**

Sources (read in this priority order for conflicts):
1. Notion Session 0 Training Doc — fetch page ID `a4fb7d96879b4d90b5e3e809a22f5069` via `mcp__claude_ai_Notion__notion-fetch`
2. Notion Session 1 Wiki — fetch page ID `655cced4317d428285b7701c56d55ae4` via `mcp__claude_ai_Notion__notion-fetch`
3. `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.0.LTC-OPERATING-SYSTEM-DESIGN/research/amt/Doc-9-Agent-System-Ultimate-Truths.md`

Spec section to follow: spec §3.1 (lines 34-111)
Implementation conventions: spec §5 (lines 357-395)
Existing rule file for pattern reference: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/rules/brand-identity.md` (read first 10 lines for header format)

- [ ] **Step 1: Read all three source files in priority order**

Read Doc-9 fully. Fetch both Notion pages. Note any conflicts — Notion pages win.

- [ ] **Step 2: Read spec §3.1 and §5 for structure and conventions**

Read the spec at `docs/superpowers/specs/2026-03-18-effective-system-rules-design.md` lines 34-111 (deliverable structure) and lines 357-395 (implementation conventions).

- [ ] **Step 3: Read existing rule file header for pattern**

Read `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/rules/brand-identity.md` first 10 lines. Match the blockquote header format exactly.

- [ ] **Step 4: Write `rules/agent-system.md`**

Create the file following spec §3.1 structure exactly:
- §1 Notation (first — abbreviations before use)
- §2 Purpose & Three Principles (include Doc-9 §4.4 SFIA pointer)
- §3 The 8 LLM Fundamental Truths (per-truth: #, Name, Bottleneck, Plain language, Mechanism, Compensated by)
- §4 The Two Operators (Human UBS/UDS + Agent LTs/strengths + shared forces)
- §5 The 7-Component System (dependency graph + summary table + per-component cards with derisk/drive + Always/Ask/Never note on EPS card)

Header format:
```markdown
# LTC Agent System

> Source of truth: Doc-9 (OPS_OE.6.0 research/amt/), Session 0 & Session 1 (Notion ALIGN Wiki)
> Distilled for agent and practitioner use. Load when configuring or diagnosing an AI agent.
> Last synced: 2026-03-18

---
```

Use `(see general-system.md §N)` cross-reference format where needed.
Target: ~300 lines (+/-15%). Clarity over compression.

- [ ] **Step 5: Self-validate against spec checklist**

Verify the written file contains:
- [ ] Blockquote header with source-of-truth, trigger condition, last-synced date
- [ ] Notation section FIRST
- [ ] All 8 LLM Truths with bottleneck labels
- [ ] Mechanism column and Compensated-by mapping for each LT
- [ ] Quick-reference summary table
- [ ] Human Director System 1 UBS (6 biases) and System 2 UDS (5 strengths)
- [ ] LLM Agent architectural strengths (6 items)
- [ ] Shared forces (Compute-Efficient / Bio-Efficient, Orchestration / Support System Belief)
- [ ] ASCII dependency graph
- [ ] 7-component summary table with AI examples and priority
- [ ] Per-component cards with: Definition, System role, Compensates for, Guards against, Derisk, Drive output
- [ ] Always/Ask/Never note on EPS component card
- [ ] Doc-9 §4.4 SFIA pointer in §2
- [ ] Cross-references use `(see X.md §N)` format
- [ ] NO Kitchen Analogy, NO SFIA ladder, NO Strategy Brief examples, NO Map Anything New table, NO citations

---

### Task 2: Write `rules/general-system.md`

**Agent type:** Opus subagent (fresh context, worktree isolation)
**Files:**
- Create: `rules/general-system.md`

**Context to inject into subagent prompt:**

Sources (read in this priority order for conflicts):
1. `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.1.ILE-ENGINE/templates/effective-system-design.md` (primary — read fully)
2. `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.1.LEARN-BUILD-ENGINE/research/spec-gap-analysis.md` (for G1 eval framework, G3 failure modes)
3. `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.0.LTC-OPERATING-SYSTEM-DESIGN/research/amt/Doc-9-Agent-System-Ultimate-Truths.md` (for UT#1, UT#2 references and system formula)

Spec section to follow: spec §3.2 (lines 114-228)
Implementation conventions: spec §5 (lines 357-395)
Existing rule file for pattern reference: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/rules/naming-rules.md` (read first 10 lines for header format)

- [ ] **Step 1: Read ESD framework fully**

This is the primary source (68KB). Read it end-to-end. Focus on: §1 Core Concepts Glossary, §3 Phase 1 (UDO, RACI, UBS, UDS, Input/Output contracts), §4 Phase 2 (Principles, Environment, Tools, EOP), Phase 3 (VANA grammar).

- [ ] **Step 2: Read spec-gap-analysis for G1 and G3**

Read `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.1.LEARN-BUILD-ENGINE/research/spec-gap-analysis.md`. Extract: G1 eval spec (three eval types, critical sequence), G3 failure modes (Recovery, Escalation, Degradation, Timeout).

- [ ] **Step 3: Read Doc-9 for UT#1, UT#2 references**

Read Doc-9 §1.3 (system formula), §1.4 (grounding in universal truths). Extract the UT#1/UT#2 mapping table.

- [ ] **Step 4: Read spec §3.2 and §5**

Read the spec at `docs/superpowers/specs/2026-03-18-effective-system-rules-design.md` lines 114-228 (deliverable structure) and lines 357-395 (implementation conventions).

- [ ] **Step 5: Write `rules/general-system.md`**

Create the file following spec §3.2 structure exactly:
- §1 Notation (first)
- §2 Purpose & Foundation (UT#1, formula, relationship to agent-system.md)
- §3 The Universal System Model (6 components)
- §4 RACI — Who Does What (R/A before forces, Always/Ask/Never when R=Agent)
- §5 Force Analysis — UBS then UDS (UBS FIRST, with rationale note about ESD ordering inversion)
- §6 Effective Principles & Standards (trace to forces, role-tagged, S/E/Sc pillars)
- §7 System Boundaries — Input & Output (4-layer progressive disclosure: Minimum Viable → Pre-Build → Production-Ready)
- §8 The ESD Methodology (3 phases)
- §9 The Value Chain (6 layers)

Header format:
```markdown
# LTC General System

> Source of truth: ESD Framework (OPS_OE.6.1 templates/), 10 Ultimate Truths (BOOK-00), Spec-Gap-Analysis (OPS_OE.6.1 research/)
> Distilled for agent and practitioner use. Load when designing or building any system.
> Last synced: 2026-03-18

---
```

UBS before UDS with rationale note. Use `(see agent-system.md §N)` cross-reference format.
Target: ~310 lines (+/-15%).

- [ ] **Step 6: Self-validate against spec checklist**

Verify the written file contains:
- [ ] Blockquote header
- [ ] Notation section FIRST
- [ ] UT#1 formula and 6-component definitions with "What happens when missing"
- [ ] RACI section BEFORE force analysis, with Always/Ask/Never when R=Agent
- [ ] UBS analyzed BEFORE UDS, with rationale note
- [ ] Recursive notation (UBS.UB, UBS.UD, UDS.UD, UDS.UB) explained
- [ ] Role-aware throughout: UBS(R), UBS(A), UDS(R), UDS(A)
- [ ] Principles traced to forces, role-tagged P[n](S/E/Sc)(R/A)
- [ ] 4-layer progressive disclosure: Layer 1 (5 categories), Layer 2 (6 contract fields), Layer 3 (eval spec per AC with 3 types + critical sequence), Layer 4 (failure modes per step)
- [ ] Progressive labels: Minimum Viable Boundary, Pre-Build Boundary, Production-Ready Boundary
- [ ] ESD 3-phase methodology with VANA grammar
- [ ] Value chain 6 layers with OE/UE distinction
- [ ] Cross-references use `(see X.md §N)` format
- [ ] NO full ELF details, NO complete ESD glossary, NO worked examples

---

### Task 3: Write `rules/agent-diagnostic.md`

**Agent type:** Opus subagent (fresh context, worktree isolation)
**Files:**
- Create: `rules/agent-diagnostic.md`

**Context to inject into subagent prompt:**

Sources (read in this priority order):
1. `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.0.LTC-OPERATING-SYSTEM-DESIGN/research/amt/Doc-9-Agent-System-Ultimate-Truths.md` (§3.7 diagnostic table, §3.0 dependency graph)
2. Notion Session 0 Training Doc — fetch page ID `a4fb7d96879b4d90b5e3e809a22f5069` (§4 Patterns, §6 Anti-Pattern table)
3. `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.1.LEARN-BUILD-ENGINE/research/spec-gap-analysis.md` (G3 failure modes, G6 observability — for §7 future architecture)

Spec section to follow: spec §3.3 (lines 231-316)
Implementation conventions: spec §5 (lines 357-395)

- [ ] **Step 1: Read Doc-9 §3.7 (Action diagnostic table) and §3.0 (dependency graph)**

Extract: symptom → root component mapping table, diagnostic use description, the principle that Action is emergent and never the root cause.

- [ ] **Step 2: Fetch Session 0 Training Doc from Notion**

Fetch page ID `a4fb7d96879b4d90b5e3e809a22f5069`. Extract: §4 Patterns (LT Audit, Blame Diagnostic, Derisk Checklist, Force Map), §6 Anti-Pattern table (symptom → root cause → principle violated → fix).

- [ ] **Step 3: Read spec-gap-analysis G3 and G6**

Extract: G3 failure mode categories (for §7 future monitoring), G6 observability spec (for §7 cross-session intelligence).

- [ ] **Step 4: Read spec §3.3 and §5**

Read spec lines 231-316 and 357-395.

- [ ] **Step 5: Write `rules/agent-diagnostic.md`**

Create the file following spec §3.3 structure exactly:
- §1 Notation (subset: 7-CS, EPS, EOP, LT-N, UBS, UDS)
- §2 Purpose (core principle, dual-use: human + automated)
- §3 The Blame Diagnostic (sequential walkthrough EPS→Input→EOP→Environment→Tools→Agent, platform-specific trace points)
- §4 Symptom → Root Component Table (machine-parseable, 8 rows, with "Check First" column, future YAML/JSON note)
- §5 The Derisk Checklist (Risk → LT → Component → Configured?)
- §6 The Force Map (System 1/2 decision framework)
- §7 Automated Diagnostic Integration Points (FUTURE label, post-action hooks, per-step monitoring, per-session aggregation, cross-session intelligence, future architecture)

Header format:
```markdown
# LTC Agent Diagnostic

> Source of truth: Doc-9 §3.7 (OPS_OE.6.0 research/amt/), Session 0 §4+§6 (Notion ALIGN Wiki)
> Distilled for agent and practitioner use. Load when debugging agent failures.
> Last synced: 2026-03-18

---
```

Cross-references to `general-system.md §7` for Layers 2-4. Cross-references to `agent-system.md §3` for LT details.
Target: ~150 lines (+/-15%).

- [ ] **Step 6: Self-validate against spec checklist**

Verify:
- [ ] Blockquote header
- [ ] Notation section FIRST
- [ ] Blame Diagnostic in correct order (EPS first, Agent last)
- [ ] Platform-specific trace points (Claude Code, Cursor, Gemini)
- [ ] 8-row symptom table with all three columns
- [ ] Future YAML/JSON note on symptom table
- [ ] Derisk Checklist format: Risk → LT → Component → Configured?
- [ ] Force Map with System 1/2 decision guidance
- [ ] §7 has "FUTURE — not yet implemented" blockquote
- [ ] §7 covers: post-action hooks, per-step monitoring, per-session aggregation, cross-session intelligence, future architecture
- [ ] Cross-references use `(see X.md §N)` format

---

## Phase 2: Sequential Integration

Depends on: Phase 1 complete (all 3 docs written).

---

### Task 4: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md` (insert 18 lines before the Structure section)

- [ ] **Step 1: Read current CLAUDE.md**

Read `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/CLAUDE.md`. Identify the insertion point — insert at line 71 (currently `## Structure`), pushing it down. New sections go between the Security section (ends line 69) and the Structure section.

- [ ] **Step 2: Insert three new sections**

Insert exactly as specified in spec §3.4 (lines 323-343). Order: Agent System → System Design → Agent Diagnostics.

```markdown
## Agent System (full spec: `rules/agent-system.md`)

Your AI agent has 8 structural limits (LLM Truths) that cannot be patched away.
The 7-Component System compensates: EPS → Input → EOP → Environment → Tools → Agent → Action → Outcome.
Three principles: (1) Derisk before driving output, (2) Know the agent's physics, (3) Human Director + Agent = complementary operators.
When output is wrong: load the diagnostic framework before blaming the model.

## System Design (full spec: `rules/general-system.md`)

Every system has 6 components: Input, User, Action, Principles, Tools, Environment → Outcome.
Establish RACI (R and A) before analyzing forces. UBS/UDS analyzed from both R and A perspectives.
System boundaries have 4 progressive layers: (1) What flows, (2) Contract fields, (3) Eval spec per AC, (4) Failure modes.
Design methodology: Problem Discovery → System Design → VANA Requirements (Verb-Adverb-Noun-Adjective with binary ACs).

## Agent Diagnostics (full spec: `rules/agent-diagnostic.md`)

When agent output is wrong: trace through 6 configurable components (EPS → Input → EOP → Environment → Tools → Agent) before blaming the model.
Derisk checklist: list what can go wrong, map each risk to an LT and component, verify it is configured.
Symptom-to-component lookup table and Force Map available for quick diagnosis.
```

- [ ] **Step 3: Verify CLAUDE.md line count and update header**

Current: 77 lines. Adding 18 lines = 95 lines. The file header says "Keep under 80 lines" — update this to "Keep under 100 lines" (previously approved by user). Final count: 95 lines, under 100 limit.

---

### Task 5: Cross-Reference Validation

**Files:**
- Read: all 3 new rule files + CLAUDE.md

- [ ] **Step 1: Verify all cross-references resolve**

Check every `(see X.md §N)` reference in all 3 docs:
- agent-system.md references to general-system.md sections
- general-system.md references to agent-system.md sections
- agent-diagnostic.md references to agent-system.md and general-system.md sections
- CLAUDE.md `full spec:` paths match actual file names

- [ ] **Step 2: Verify no content overlap between docs**

Scan for duplicated content. Acceptable: brief back-references (e.g., "the 8 LTs defined in agent-system.md §3"). Not acceptable: re-defining the same concept in detail in two docs.

- [ ] **Step 3: Verify notation consistency**

Check that abbreviations used in each doc are defined in that doc's notation section. Check that the same abbreviation means the same thing across all 3 docs.

---

## Phase 3: Parallel Audit (3 independent Opus subagents)

Each auditor gets: (a) the written doc, (b) the source files it was derived from, (c) the spec section. NO access to the writing agent's reasoning or conversation history. This structural independence compensates for LT-1 (hallucination), LT-5 (plausibility over truth), and LT-8 (alignment drift).

---

### Task 6: Audit `rules/agent-system.md`

**Agent type:** Opus subagent (fresh context — MUST NOT be the same agent that wrote the doc)

**Audit prompt for subagent:**

> You are an independent auditor. You did NOT write this document. Your job is to find errors, omissions, and distortions.
>
> **Document to audit:** Read `rules/agent-system.md` in `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/`
>
> **Sources to verify against:**
> 1. Fetch Notion page `a4fb7d96879b4d90b5e3e809a22f5069` (Session 0 Training Doc)
> 2. Fetch Notion page `655cced4317d428285b7701c56d55ae4` (Session 1 Wiki)
> 3. Read `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.0.LTC-OPERATING-SYSTEM-DESIGN/research/amt/Doc-9-Agent-System-Ultimate-Truths.md`
>
> **Spec to check against:** Read `docs/superpowers/specs/2026-03-18-effective-system-rules-design.md` lines 34-111
>
> **Audit checklist:**
> 1. Are all 8 LLM Truths factually correct vs. sources? Check: name, bottleneck, mechanism, compensated-by for each.
> 2. Does the 7-Component dependency graph match Doc-9 §3.0 exactly?
> 3. Are per-component cards (derisk/drive) accurate vs. Doc-9 §3.1-§3.7?
> 4. Are the 6 Human Director biases correct vs. Doc-9 §2.1?
> 5. Are LLM Agent architectural strengths correct vs. Doc-9 §2.2?
> 6. Is the Always/Ask/Never note present on the EPS component card?
> 7. Is anything INVENTED that is not in the sources? (Most critical check — flag any content that appears to be hallucinated.)
> 8. Is anything MISSING that the spec requires?
> 9. Does the header follow the blockquote convention?
>
> Return: PASS/FAIL per item, with specific line numbers and evidence for any failures.

- [ ] **Step 1: Dispatch audit agent with the prompt above**
- [ ] **Step 2: Review audit results**
- [ ] **Step 3: Log findings for Phase 4**

---

### Task 7: Audit `rules/general-system.md`

**Agent type:** Opus subagent (fresh context)

**Audit prompt for subagent:**

> You are an independent auditor. You did NOT write this document. Your job is to find errors, omissions, and distortions.
>
> **Document to audit:** Read `rules/general-system.md` in `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/`
>
> **Sources to verify against:**
> 1. Read `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.1.ILE-ENGINE/templates/effective-system-design.md` (ESD Framework — primary)
> 2. Read `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.1.LEARN-BUILD-ENGINE/research/spec-gap-analysis.md`
> 3. Read `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.0.LTC-OPERATING-SYSTEM-DESIGN/research/amt/Doc-9-Agent-System-Ultimate-Truths.md` (§1.3, §1.4 only)
>
> **Spec to check against:** Read `docs/superpowers/specs/2026-03-18-effective-system-rules-design.md` lines 114-228
>
> **Audit checklist:**
> 1. Does the Universal System Model (6 components) match UT#1 from Doc-9 §1.3?
> 2. Is RACI placed BEFORE force analysis?
> 3. Is UBS analyzed BEFORE UDS? Is the rationale note present?
> 4. Does the recursive notation (UBS.UB, UBS.UD, etc.) match ESD framework exactly?
> 5. Are role-aware tags (UBS(R), UBS(A), P[n](S)(R)) correct vs. ESD §3.3-§3.4, §4.1?
> 6. Layer 1: Do the 5 categories match the Whiteboard template? (AC with S/E/Sc, Signal/Data, Physical, Human, Financial Resources)
> 7. Layer 2: Do the 6 contract fields match ESD Input/Output Contract? (Source/Consumer, Schema, Validation, Error, SLA, Version)
> 8. Layer 3: Do the 3 eval types match spec-gap-analysis G1? (Deterministic, Manual, AI-Graded)
> 9. Layer 4: Do the failure mode fields match spec-gap-analysis G3? (Recovery, Escalation, Degradation, Timeout)
> 10. Is the ESD 3-phase methodology accurate? (Phase 1 Problem Discovery, Phase 2 System Design, Phase 3 VANA Requirements)
> 11. Is anything INVENTED that is not in the sources?
> 12. Is anything MISSING that the spec requires?
>
> Return: PASS/FAIL per item, with specific line numbers and evidence for any failures.

- [ ] **Step 1: Dispatch audit agent with the prompt above**
- [ ] **Step 2: Review audit results**
- [ ] **Step 3: Log findings for Phase 4**

---

### Task 8: Audit `rules/agent-diagnostic.md`

**Agent type:** Opus subagent (fresh context)

**Audit prompt for subagent:**

> You are an independent auditor. You did NOT write this document.
>
> **Document to audit:** Read `rules/agent-diagnostic.md` in `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/`
>
> **Sources to verify against:**
> 1. Read `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.0.LTC-OPERATING-SYSTEM-DESIGN/research/amt/Doc-9-Agent-System-Ultimate-Truths.md` (§3.7 diagnostic table)
> 2. Fetch Notion page `a4fb7d96879b4d90b5e3e809a22f5069` (Session 0, §4 Patterns + §6 Anti-Patterns)
> 3. Read `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.1.LEARN-BUILD-ENGINE/research/spec-gap-analysis.md` (G3, G6)
>
> **Spec to check against:** Read `docs/superpowers/specs/2026-03-18-effective-system-rules-design.md` lines 231-316
>
> **Audit checklist:**
> 1. Does the Blame Diagnostic order match Doc-9 §3.7? (EPS → Input → EOP → Environment → Tools → Agent)
> 2. Does the symptom table match Doc-9 §3.7 + Session 0 §6? Are symptoms correctly mapped to root components?
> 3. Is the Derisk Checklist format correct? (Risk → LT → Component → Configured?)
> 4. Is the Force Map accurate vs. Session 0 §4 Pattern 4?
> 5. Does §7 have the "FUTURE — not yet implemented" label?
> 6. Are cross-references to general-system.md §7 Layers 2-4 correct?
> 7. Is anything INVENTED?
> 8. Is anything MISSING?
>
> Return: PASS/FAIL per item.

- [ ] **Step 1: Dispatch audit agent with the prompt above**
- [ ] **Step 2: Review audit results**
- [ ] **Step 3: Log findings for Phase 4**

---

## Phase 4: Parallel Fix

Depends on: Phase 3 complete. Only execute if any audit found FAIL items.

---

### Task 9: Fix audit findings

**Agent type:** One Opus subagent per doc that has FAIL items (parallel if multiple docs need fixes)

Each fix agent receives: (a) the doc to fix, (b) the specific FAIL items with line numbers, (c) the source files needed for the fix. Fresh context — no knowledge of Phase 1 writing or Phase 3 auditing.

- [ ] **Step 1: For each doc with FAIL items, dispatch a fix agent**

Fix agent prompt template:
> Fix the following issues in `rules/{filename}.md`. For each issue, read the source file cited, find the correct content, and make the minimal edit to fix the error. Do NOT rewrite sections that passed audit.
>
> Issues: {list of FAIL items with line numbers and evidence}
> Sources: {only the source files needed for these specific fixes}

- [ ] **Step 2: Re-run the relevant Phase 3 audit for any fixed doc**

Only re-audit the specific items that were FAIL. If they now PASS, proceed. If still FAIL after 2 fix cycles, escalate to human.

---

## Phase 5: Commit

Depends on: All audits PASS.

---

### Task 10: Commit all changes

- [ ] **Step 1: Stage all new and modified files**

```bash
cd /Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
git add rules/agent-system.md rules/general-system.md rules/agent-diagnostic.md CLAUDE.md
```

- [ ] **Step 2: Commit**

```bash
git commit -m "$(cat <<'EOF'
Add LTC Effective System reference docs (OPS_-4216)

Three canonical reference docs for the project template:
- rules/agent-system.md: 8 LLM Truths, 7-Component System, two operators
- rules/general-system.md: Universal System Model, RACI, UBS/UDS, 4-layer boundaries, ESD
- rules/agent-diagnostic.md: Blame Diagnostic, symptom table, derisk checklist, force map

CLAUDE.md updated with summary sections pointing to all three.

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
EOF
)"
```

- [ ] **Step 3: Verify commit**

```bash
git status
git log --oneline -3
```

---

## Execution Summary

| Phase | Tasks | Execution | LT Compensated |
|---|---|---|---|
| 1. Write | Tasks 1-3 | **PARALLEL** (3 Opus subagents) | LT-2, LT-3, LT-6, LT-7 |
| 2. Integrate | Tasks 4-5 | **SEQUENTIAL** (main agent) | — |
| 3. Audit | Tasks 6-8 | **PARALLEL** (3 fresh Opus subagents) | LT-1, LT-5, LT-8 |
| 4. Fix | Task 9 | **PARALLEL** (if needed, per doc) | LT-3 (focused fixes) |
| 5. Commit | Task 10 | **SEQUENTIAL** (main agent) | — |

**Estimated total:** 3 parallel writes + 1 sequential integration + 3 parallel audits + conditional fixes + commit.
