---
version: "1.2"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
---

# UBS REGISTER — Ultimate Blocking System Identification
## OPS_OE.6.4.LTC-PROJECT-TEMPLATE

> The UBS exerts stronger influence than the UDS on valuable outcomes.
> Always prioritize risk mitigation over output maximization.
> Trace blockers to ROOT CAUSES, not symptoms.

**Cross-zone write:** Authorized by `1-ALIGN/DESIGN.md` artifact A5, condition C5.
**Perspectives:** R = Responsible (Long, builder) | A = Accountable (Vinh, director)
**Sources:** PROJECT_CHARTER.md §6, STAKEHOLDERS.md per-stakeholder UBS, stakeholder-input-synthesis §C5, multi-agent design spec [S4].

---

## Active Blockers

### UBS-001: Adoption friction kills template before it proves value

| Field | Value |
|-------|-------|
| **Perspective** | A (Director) |
| **Source** | S2-consensus, S2-Khang |
| **Description** | Team members find the template too complex or prescriptive and revert to ad-hoc project setup. 40+ files across 6 zones with no cognitive load management creates paralysis. If friction exceeds perceived benefit in the first 15 minutes, adoption fails silently. |
| **Root cause** | Framework depth optimized for completeness, not onboarding UX. No graduated entry path. |
| **Likelihood** | H |
| **Impact** | H |
| **Mitigation** | Simplicity-first principle (S6); root README as 5-step navigation map; zone READMEs as "start here" guides; subfolder descriptions (R06); MoSCoW labeling ("Must read: 3 files"); template-check.sh first-run orientation. |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

### UBS-002: Agents guess subfolder context — produce off-zone artifacts

| Field | Value |
|-------|-------|
| **Perspective** | R (Builder) |
| **Source** | S2-Dat |
| **Description** | Zone subfolders have no description. Agents guess which subfolder to use for ADRs vs diagrams vs metadata. Dat doesn't catch the error. Downstream artifacts build on misplaced work, compounding the mistake. |
| **Root cause** | Missing explicit context for agents — subfolder purpose is implicit in folder names only. |
| **Likelihood** | H |
| **Impact** | H |
| **Mitigation** | Subfolder descriptions in every zone (R06); ADR-004 decides mechanism (README vs YAML vs manifest); per-agent tool allowlists scope operations to correct zones. |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

### UBS-003: Version confusion — stale template usage

| Field | Value |
|-------|-------|
| **Perspective** | A (Director) |
| **Source** | S2-Khang |
| **Description** | No release announcement flow. Khang cannot tell which iteration is current, when updates shipped, or what changed. Uses a stale cloned template without knowing it's outdated. Git unfamiliarity compounds the problem. |
| **Root cause** | Version tracking exists (VERSION + CHANGELOG + frontmatter) but is not visible to non-technical users. No push-based notification. |
| **Likelihood** | M |
| **Impact** | H |
| **Mitigation** | Release announcement flow (R08); VERSION file + CHANGELOG.md visible at root; version in frontmatter (R09); ADR-005 decides announcement mechanism. |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

### UBS-004: Skill scope leakage — skills invoked outside intended context

| Field | Value |
|-------|-------|
| **Perspective** | R (Builder) |
| **Source** | S2-Dat |
| **Description** | Skills placed in nested folders are invocable from any context. A skill meant for one zone or workflow bleeds into another, producing off-scope output that the builder must debug. Flat project-root placement exacerbates the problem. |
| **Root cause** | No scope enforcement mechanism — skill invocation is name-based, not context-gated. |
| **Likelihood** | M |
| **Impact** | M |
| **Mitigation** | Skill scope enforcement via naming + manifest check (R07); multi-agent tool allowlists restrict which agent can invoke which skills (ADR-007). |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

### UBS-005: Cascading hallucination in multi-agent handoffs (LT-1)

| Field | Value |
|-------|-------|
| **Perspective** | R (Builder) |
| **Source** | S4, LT-1 |
| **Description** | One agent produces a subtly wrong artifact. Downstream agents treat it as authoritative and amplify the error across zone boundaries. In a 4-agent roster with sequential handoffs, a single hallucination can propagate through 3+ artifacts before a human reviews. |
| **Root cause** | LLM Truth #1 — agents cannot reliably self-verify. Verification requires external evidence, not self-assessment. |
| **Likelihood** | M |
| **Impact** | H |
| **Mitigation** | Eval gates with measured evidence before shipping (Approach D); verify-deliverables hook checks binary ACs; hypothesis-driven approach requires H1/H2/H5 evidence (ADR-007); human gate at each DSBV phase transition. |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

### UBS-006: Reasoning degradation on broad-scope agents (LT-3)

| Field | Value |
|-------|-------|
| **Perspective** | R (Builder) |
| **Source** | S4, LT-3 |
| **Description** | Agents with broad scope (e.g., a single agent handling all zones) suffer reasoning quality degradation as context grows. The agent produces verbose, framework-heavy documents that follow the letter but miss the spirit. |
| **Root cause** | LLM Truth #3 — reasoning quality degrades with task breadth. Narrow scope = better reasoning. |
| **Likelihood** | H |
| **Impact** | M |
| **Mitigation** | 4 MECE agent roster with narrow scope boundaries (ltc-planner/Opus, ltc-builder/Sonnet, ltc-reviewer/Opus, ltc-explorer/Haiku); per-agent tool allowlists (<=7 tools); context packaging template limits input to 5 fields. |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

### UBS-007: Token waste from unscoped context loading (LT-7)

| Field | Value |
|-------|-------|
| **Perspective** | R (Builder) |
| **Source** | S4, LT-7 |
| **Description** | Agents load excessive context (full CLAUDE.md + all zone files + genesis frameworks) when only a narrow slice is needed. Token budget exhausted on context, leaving insufficient capacity for reasoning. With Anthropic usage limits tightening, this becomes a cost and availability blocker. |
| **Root cause** | LLM Truth #7 — token budget is finite. Context loading must be intentional, not exhaustive. |
| **Likelihood** | H |
| **Impact** | M |
| **Mitigation** | Tool routing rule with per-agent allowlists and cost tiers (R21); context packaging template (5 fields: EO, INPUT, EP, OUTPUT, VERIFY) limits what each agent receives; model routing (Haiku for search, Sonnet for build, Opus for design). |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

### UBS-008: Agent drift — exceeding scope boundaries (LT-8)

| Field | Value |
|-------|-------|
| **Perspective** | R (Builder) |
| **Source** | S4, LT-8 |
| **Description** | Agents exceed their assigned scope, producing artifacts in zones they should not touch or making decisions reserved for the human director. Framework complexity makes the template too heavy to clone if agents operate unconstrained. |
| **Root cause** | LLM Truth #8 — agents optimize for helpfulness, which means they expand scope unless explicitly constrained. |
| **Likelihood** | M |
| **Impact** | H |
| **Mitigation** | EP-11 (Agent Role Separation) enforces MECE boundaries; EP-13 (Orchestrator Authority) — only lead agent dispatches; per-agent tool allowlists; verify-deliverables hook rejects out-of-scope artifacts; deterministic enforcement over probabilistic (S7). |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

### UBS-009: Cognitive overload on first clone

| Field | Value |
|-------|-------|
| **Perspective** | A (Director) |
| **Source** | PROJECT_CHARTER §6, S2-Khang |
| **Description** | A non-technical director (Khang) opens the repo and sees 40+ files across 6 zones with no clear entry point. Closes the repo and asks Long directly, defeating the template's purpose. |
| **Root cause** | Template optimized for completeness (all zones, all frameworks) rather than progressive disclosure. |
| **Likelihood** | H |
| **Impact** | H |
| **Mitigation** | Root README as navigation map; zone READMEs as "start here" guides; subfolder descriptions (R06); template-check.sh provides first-run orientation; MoSCoW labeling on files. |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

### UBS-010: Template drift — consumer repos diverge from canonical

| Field | Value |
|-------|-------|
| **Perspective** | A (Director) |
| **Source** | PROJECT_CHARTER §6 |
| **Description** | Teams customize their cloned repos. Over time, the template and all consumer repos drift apart. Updates to the canonical template don't propagate. No mechanism to detect or reconcile structural divergence. |
| **Root cause** | Git clone creates a full copy with no upstream link. Template evolution and consumer evolution are independent. |
| **Likelihood** | M |
| **Impact** | M |
| **Mitigation** | template-check.sh detects version drift; CHANGELOG tracks template version; major structural changes are ADR-documented; VERSION file at root. |
| **Owner** | Long Nguyen |
| **Status** | Open |

---

## Summary Risk Matrix

| Risk Level | IDs | Count |
|-----------|-----|-------|
| **Critical (H/H)** | UBS-001, UBS-002, UBS-009 | 3 |
| **High (M/H or H/M)** | UBS-003, UBS-005, UBS-006, UBS-007, UBS-008 | 5 |
| **Medium (M/M)** | UBS-004, UBS-010 | 2 |
| **Low** | — | 0 |

**Top 3 by combined severity:** UBS-001 (adoption friction), UBS-002 (agent guessing), UBS-009 (cognitive overload) — all share the same root theme: the template's depth works against its adoptability. Mitigation strategy: progressive disclosure + explicit context.

---

**Classification:** INTERNAL
