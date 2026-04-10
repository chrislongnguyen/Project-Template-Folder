---
version: "2.0"
status: draft
last_updated: 2026-04-11
owner: ""
type: template
work_stream: 2-LEARN
stage: spec
sub_system: 
---
# VANA-SPEC: {system_name}

<!-- OE.6.4 v2.0 Template — PM-first ordering: identity, forces, design, spec, test, plan, harden, verify.
     System Thinking extensions (sigmoid, bottleneck, synergy, feedback loops) parked to
     _genesis/reference/system-thinking-extensions.md — available when PMs are ready.
     Every {placeholder} is replaced with data extracted from approved sources. -->

---

## §1 System Identity

<!-- Derivation: learn-input + T0.P0 Workstream Contract -->

| Field | Value |
|-------|-------|
| System Name | {system_name} |
| Slug | {system_slug} |
| Abbreviation | {system_abbrev} |
| EO | {eo} |
| Sub-System | {1-PD / 2-DP / 3-DA / 4-IDM} |
| Topics Covered | {topic_list} |

### User Persona

<!-- Source: T0.P0 col 3 (REL) — User Persona row -->

| Attribute | Description |
|-----------|-------------|
| Who | {persona_who} |
| Goal | {persona_goal} |
| Context | {persona_context} |

### Anti-Persona

<!-- Source: T0.P0 col 4 (DEF) — Anti-Persona row -->

| Attribute | Description |
|-----------|-------------|
| Who | {anti_persona_who} |
| Why Excluded | {anti_persona_why} |

### RACI

<!-- Source: T0.P0 Workstream Contract — R=Agent, A=Human Director -->

| Role | Assignment |
|------|------------|
| Responsible (R) | {raci_r} |
| Accountable (A) | {raci_a} |
| Consulted (C) | {raci_c} |
| Informed (I) | {raci_i} |

---

## §2 Force Analysis

<!-- Derivation: ELF output + T0.P1 (UBS) + T0.P2 (UDS) + RACI from §1.
     Requires at least 1 level of recursive decomposition (Fix 7).
     All forces analyzed from BOTH R and A perspectives (general-system.md §4). -->

### §2.1 UBS — Blocking Forces (Derisk First)

#### UBS(R) — What blocks the Responsible party

| ID | Force | Mechanism | LT/Bias Root |
|---|---|---|---|
| UBS.R.1 | {blocker} | {how it blocks} | {LT-N or Bias} |
| UBS.R.2 | {blocker} | {how it blocks} | {LT-N or Bias} |

#### UBS(A) — What blocks the Accountable party

| ID | Force | Mechanism | LT/Bias Root |
|---|---|---|---|
| UBS.A.1 | {blocker} | {how it blocks} | {Bias} |

#### Recursive Decomposition (minimum 1 level)

| Parent Force | Sub-Force | Direction | Mechanism |
|---|---|---|---|
| UBS.R.1 | UBS.R.1.UB | Weakens blocker (ally) | {what naturally weakens this blocker} |
| UBS.R.1 | UBS.R.1.UD | Strengthens blocker (threat) | {what makes this blocker worse} |
| UBS.A.1 | UBS.A.1.UB | Weakens blocker (ally) | {what naturally weakens this blocker} |
| UBS.A.1 | UBS.A.1.UD | Strengthens blocker (threat) | {what makes this blocker worse} |

### §2.2 UDS — Driving Forces

#### UDS(R) — What drives the Responsible party

| ID | Force | Mechanism | Strength Source |
|---|---|---|---|
| UDS.R.1 | {driver} | {how it drives} | {Architectural / Procedural} |

#### UDS(A) — What drives the Accountable party

| ID | Force | Mechanism | Strength Source |
|---|---|---|---|
| UDS.A.1 | {driver} | {how it drives} | {System 2 strength} |

#### Recursive Decomposition (minimum 1 level)

| Parent Force | Sub-Force | Direction | Mechanism |
|---|---|---|---|
| UDS.R.1 | UDS.R.1.UD | Strengthens driver (amplify) | {what makes this driver stronger} |
| UDS.R.1 | UDS.R.1.UB | Weakens driver (silent killer) | {what could undermine this driver} |

---

## §3 System Design — 8 Components

### §3.1 8-Component Summary Table

<!-- Derivation: T0.P3 (principles) + T0.P4 (components) + T0.P0 (user profile).
     The 8 Effective System Components applied to this sub-system.
     Each component has current state (as-is) and target state (to-be). -->

| # | Component | Abbrev | Current State | Target State | Governing Principle(s) |
|---|-----------|--------|---------------|--------------|----------------------|
| 1 | Effective Input | EI | {current_input} | {target_input} | {P[n]} |
| 2 | Effective User | EU | {current_user} | {target_user} | {P[n]} |
| 3 | Effective Action | EA | {current_action} | {target_action} | {P[n]} |
| 4 | Effective Outcome | EO | {current_outcome} | {target_outcome} | {P[n]} |
| 5 | Effective Principles | EP | {current_principles} | {target_principles} | {P[n]} |
| 6 | Effective Operating Environment | EOE | {current_env} | {target_env} | {P[n]} |
| 7 | Effective Operating Tools | EOT | {current_tools} | {target_tools} | {P[n]} |
| 8 | Effective Operating Procedure | EOP | {current_procedure} | {target_procedure} | {P[n]} |

### §3.2 EI/EO Detail — What Flows

<!-- Derivation: general-system.md §7 Layer 1.
     Five categories of resources that cross the system boundary. -->

| Category | Inbound | Outbound |
|---|---|---|
| Acceptance Criteria | {what "correct" means for inputs} | {what "correct" means for outputs} |
| Signal / Data / Information | {data payloads received} | {data payloads produced} |
| Physical Resources | {hardware, infra consumed} | {hardware, infra produced/modified} |
| Human Resources | {people, roles, time consumed} | {people, roles enabled} |
| Financial Resources | {budget, token spend consumed} | {value produced, cost reduced} |

### §3.3 Effective Operating Environment (EOE)

<!-- Derivation: T0.P1 (UBS — what environmental factors block) + T0.P2 (UDS — what amplifies).
     Cross-referenced with T0.P3 principles (EP) and T0.P0 context.
     The number and types of environments are sub-system-specific — discovered during LEARN,
     not prescribed. Common examples: Physical, Digital, Cultural — but a sub-system may have
     fewer or more types, or entirely different categories (e.g., Regulatory, Social).
     DERISK column = Sustainability. OPTIMIZE column = Efficiency/Scalability. -->

| Environment Type | DERISK (Sustainability) | OPTIMIZE (Efficiency/Scalability) |
|------------------|------------------------|----------------------------------|
| {environment_type_1} | {derisk_1} | {optimize_1} |
| {environment_type_2} | {derisk_2} | {optimize_2} |
<!-- Add or remove rows as needed. The number of environment types is determined by the sub-system's LEARN output. -->

### §3.4 Effective Operating Tools (EOT) — Design

<!-- Derivation: T0.P4 component analysis grouped into EOT layers.
     The number of layers is sub-system-specific — discovered during LEARN.
     This section DESCRIBES the layers; §4.3 TESTS them with Noun ACs. -->

| Layer | Name | Purpose | Components | Traces to Principle |
|-------|------|---------|------------|-------------------|
| {layer_n} | {layer_name} | {what this layer provides} | {components in this layer} | {P[n]} |
<!-- Add rows as needed. One row per discovered EOT layer. -->

### §3.5 Effective Operating Procedure (EOP)

<!-- Derivation: T0.P5 (steps) + T0.P1/P2 (UBS/UDS targeting).
     Sequential gated steps. Stage 1 (DERISK) must complete before Stage 2 (OPTIMIZE). -->

**EOP Decision Matrix**

| Category | Targeted Elements | Source | Role Assignment |
|----------|------------------|--------|-----------------|
| DERISK: UBS to disable | {ubs_elements} | §2.1 | R: {r}; A: {a} |
| OPTIMIZE: UDS to amplify | {uds_elements} | §2.2 | R: {r}; A: {a} |

**Stage 1 — DERISK (Sustainability)**

| Step # | Step Name | Required Input | Desired Output | R | A | C | I | Gate |
|--------|-----------|----------------|----------------|---|---|---|---|------|
| 1 | {step_name} | {input} | {output} | {r} | {a} | {c} | {i} | {gate_condition} |

**Stage 2 — OPTIMIZE (Efficiency + Scalability)**

| Step # | Step Name | Required Input | Desired Output | R | A | C | I | Gate |
|--------|-----------|----------------|----------------|---|---|---|---|------|
| 2 | {step_name} | {input} | {output} | {r} | {a} | {c} | {i} | {gate_condition} |

---

## §4 VANA Acceptance Criteria

### §4.1 Verb ACs

<!-- Derivation: T0.P5 — each STEP.n(R) row becomes one Verb-AC (Iteration 1).
     STEP.n(A) Col16 (NEXT) cells become SPAWNED Verb-ACs (Iteration 4).
     All use sequential Verb-ACn IDs — VANA Element column distinguishes Iteration 1 vs SPAWNED. -->

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Verb-AC1 | {verb_word_1} | {verb_criteria_1} | T0.P5:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 1 |
| Verb-AC2 | {verb_word_2} | {verb_criteria_2} | T0.P5:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 1 |
| Verb-AC{n} | {spawned_word_1} | {spawned_criteria_1} | T0.P5:{row}:Col16 | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 4 |
<!-- One row per STEP.n(R) at Iteration 1; one row per STEP.n(A) Col16 NEXT cell at Iteration 4. Continuous Verb-ACn sequence. -->

### §4.2 Adverb ACs

<!-- Derivation: T0.P3 Principles — bucketed by S/E/Sc pillar tag.
     P(S) → SustainAdv (Iteration 1), P(E) → EffAdv (Iteration 2), P(Sc) → ScalAdv (Iteration 3). -->

#### §4.2.1 Sustainability Adverbs (Iteration 1)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| SustainAdv-AC1 | {sustain_adv_word_1} | {sustain_adv_1} | T0.P3:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 1 |
<!-- One row per P(S) principle → adverb -->

#### §4.2.2 Efficiency Adverbs (Iteration 2)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| EffAdv-AC1 | {eff_adv_word_1} | {eff_adv_1} | T0.P3:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 2 |
<!-- One row per P(E) principle → adverb -->

#### §4.2.3 Scalability Adverbs (Iteration 3)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| ScalAdv-AC1 | {scal_adv_word_1} | {scal_adv_1} | T0.P3:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 3 |
<!-- One row per P(Sc) principle → adverb -->

### §4.3 Noun ACs — Effective Operating Tools (EOT)

<!-- Derivation: T0.P4 Components — organized by EOT layers discovered during LEARN.
     The number of layers is sub-system-specific. A sub-system may have 1 layer or several.
     Layer names and groupings are derived from T0.P4 component analysis and §3.1 (8-Component Design, EOT row).
     Do NOT assume 3 layers. Do NOT use generic labels (Foundational/Operational/Enhancement).
     Hardening ACs derived from T0.P0 RACI(I) role — production readiness gates (Iteration 4).
     All use continuous Noun-ACn IDs — VANA Element column distinguishes Iteration 1 vs Hardening. -->

#### §4.3.1 EOT: {layer_name}

<!-- Repeat this sub-section for each EOT layer discovered during LEARN.
     Number sub-sections §4.3.1, §4.3.2, §4.3.3... as needed. -->

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Noun-AC1 | {noun_word_1} | {noun_criteria_1} | T0.P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 1 |
<!-- One row per component in this layer. Add more rows as needed. -->

<!-- Repeat §4.3.N for each additional EOT layer. After all layers, add Hardening ACs: -->

#### §4.3.N Hardening (Iteration 4)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Noun-AC{n} | {hardening_word_1} | {hardening_criteria_1} | T0.P0:RACI(I) | Deterministic | 100% pass rate | Iteration 4 |
<!-- Production readiness gates. Continuous Noun-ACn sequence from prior layers. -->

### §4.4 Adjective ACs

<!-- Derivation: Cross-reference T0.P3 (principles) x T0.P4 (components).
     Quality attributes for Nouns, bucketed by S/E/Sc pillar. -->

#### §4.4.1 Sustainability Adjectives (Iteration 1)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| SustainAdj-AC1 | {sustain_adj_word_1} | {sustain_adj_1} | T0.P3+P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 1 |
<!-- Quality attributes that ensure Noun sustainability -->

#### §4.4.2 Efficiency Adjectives (Iteration 2)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| EffAdj-AC1 | {eff_adj_word_1} | {eff_adj_1} | T0.P3+P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 2 |
<!-- Quality attributes that ensure Noun efficiency -->

#### §4.4.3 Scalability Adjectives (Iteration 3)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| ScalAdj-AC1 | {scal_adj_word_1} | {scal_adj_1} | T0.P3+P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | Iteration 3 |
<!-- Quality attributes that ensure Noun scalability -->

---

## §5 AC-TEST-MAP (G1: Eval Specification)

<!-- Derivation: One row per A.C. from §4. This is the eval-driven development
     bridge — every A.C. must have a proof-of-correctness spec before building starts.

     Eval type selection:
       Deterministic — Noun A.C.s, data format checks, schema validation, any A.C.
                       verifiable by scripted pass/fail (pytest, regex, Pydantic parse).
       Manual        — Subjective quality, UX judgment, strategic approval, any A.C.
                       requiring Human Director review with a rubric.
       AI-Graded     — Natural language quality, reasoning checks at scale, citation
                       verification. Use with calibration threshold (e.g. 95% agreement
                       with human graders). -->

| A.C. ID | VANA Word | VANA Source | Eval Type | Dataset Description | Grader Description | Threshold |
|---------|-----------|-------------|-----------|--------------------|--------------------|-----------|
| Verb-AC1 | {verb_word} | §4.1 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| SustainAdv-AC1 | {adv_word} | §4.2.1 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| Noun-AC1 | {noun_word} | §4.3 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| SustainAdj-AC1 | {adj_word} | §4.4.1 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| EffAdv-AC1 | {adv_word} | §4.2.2 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| ScalAdv-AC1 | {adv_word} | §4.2.3 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| EffAdj-AC1 | {adj_word} | §4.4.2 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| ScalAdj-AC1 | {adj_word} | §4.4.3 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
<!-- One row per A.C. — MECE. Every A.C. from §4 must appear exactly once. -->

---

## §6 Contracts & Integration

### §6.1 Input Contract

<!-- Derivation: learn-input Workstream Contract (T0.P0).
     One table per upstream system that provides data to this system. -->

| Field | Value |
|-------|-------|
| Source | {upstream_system} |
| Schema | {input_schema} |
| Field Types | {field_types} |
| Validation Rules | {validation_rules} |
| Error Handling | {error_handling} |
| SLA | {sla} |
| Version | {version} |

### §6.2 Output Contract

<!-- One table per downstream system that consumes data from this system -->

| Field | Value |
|-------|-------|
| Consumer | {downstream_system} |
| Schema | {output_schema} |
| Field Types | {field_types} |
| Validation Rules | {validation_rules} |
| Error Handling | {error_handling} |
| SLA | {sla} |
| Version | {version} |

### §6.3 Integration Chain

<!-- From general-system.md §7: SYS-A OUTPUT → SYS-B INPUT → SYS-B OUTPUT → SYS-C INPUT -->

```
{upstream_system} ──[{schema}]──► THIS SYSTEM ──[{schema}]──► {downstream_system}
```

---

## §7 Failure Modes & Recovery (G3)

<!-- Derivation: Seeded from T0.P1 UBS analysis (blockers) and T0.P5 col 9/10
     (UD.MECH / UB.MECH). Per-iteration table. -->

### Iteration 1 Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation | Degradation | Timeout |
|-------------|---------|-----------|----------|------------|-------------|---------|
| {mode_1} | {trigger} | {detection} | {recovery} | {escalation} | {degradation} | {timeout} |

### Iteration 2 Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation | Degradation | Timeout |
|-------------|---------|-----------|----------|------------|-------------|---------|
| {mode_1} | {trigger} | {detection} | {recovery} | {escalation} | {degradation} | {timeout} |

### Iteration 3 Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation | Degradation | Timeout |
|-------------|---------|-----------|----------|------------|-------------|---------|
| {mode_1} | {trigger} | {detection} | {recovery} | {escalation} | {degradation} | {timeout} |

### Iteration 4 Failure Modes

| Failure Mode | Trigger | Detection | Recovery | Escalation | Degradation | Timeout |
|-------------|---------|-----------|----------|------------|-------------|---------|
| {mode_1} | {trigger} | {detection} | {recovery} | {escalation} | {degradation} | {timeout} |

---

## §8 Agent Behavioral Boundaries (G4)

<!-- Derivation: RACI from T0.P0 + EOP from T0.P5.
     Anthropic 3-tier system. Boundaries tighten as system matures. -->

### Iteration 1 Boundaries

**Always (safe actions — no approval needed):**
- {always_action_1}
- {always_action_2}

**Ask First (high-impact — needs Human Director approval):**
- {ask_first_action_1}
- {ask_first_action_2}

**Never (hard stops — violation = immediate halt):**
- {never_action_1}
- {never_action_2}

### Iteration 2 Boundaries

**Always:**
- {always_action_1}

**Ask First:**
- {ask_first_action_1}

**Never:**
- {never_action_1}

### Iteration 3 Boundaries

**Always:**
- {always_action_1}

**Ask First:**
- {ask_first_action_1}

**Never:**
- {never_action_1}

### Iteration 4 Boundaries

**Always:**
- {always_action_1}

**Ask First:**
- {ask_first_action_1}

**Never:**
- {never_action_1}

### Model Selection Guidance

| Task Type | Model Tier | Rationale |
|-----------|-----------|-----------|
| Sustainability-critical steps | Highest-capability | Zero tolerance for error |
| Routine data transforms | Fastest / cheapest | Speed over reasoning depth |
| Creative generation | Best reasoning | Quality over cost |

---

## §9 Iteration Plan

<!-- Every A.C. from §4 assigned to exactly one iteration — MECE.
     Rule: Sustainability gates everything. No Iteration 2 work until all Iteration 1 A.C.s pass. -->

### Master Scope Mapping

| A.C. ID | VANA Word | Criteria (short) | VANA Element | Iteration | Status |
|---------|-----------|------------------|--------------|-----------|--------|
| Verb-AC1 | {verb_word} | {short_desc} | Verb | Iteration 1 | To Do |
| SustainAdv-AC1 | {adv_word} | {short_desc} | Adverb (S) | Iteration 1 | To Do |
| Noun-AC1 | {noun_word} | {short_desc} | Noun | Iteration 1 | To Do |
| SustainAdj-AC1 | {adj_word} | {short_desc} | Adjective (S) | Iteration 1 | To Do |
| EffAdv-AC1 | {adv_word} | {short_desc} | Adverb (E) | Iteration 2 | To Do |
| EffAdj-AC1 | {adj_word} | {short_desc} | Adjective (E) | Iteration 2 | To Do |
| ScalAdv-AC1 | {adv_word} | {short_desc} | Adverb (Sc) | Iteration 3 | To Do |
| ScalAdj-AC1 | {adj_word} | {short_desc} | Adjective (Sc) | Iteration 3 | To Do |
<!-- Every A.C. appears exactly once. -->

### Iteration Sequencing

| Iteration | Name | Scope | Gate Criteria |
|-----------|------|-------|---------------|
| Iteration 1 | Concept | Verb + SustainAdv + Noun + SustainAdj | All Iteration 1 A.C.s pass eval |
| Iteration 2 | Working Prototype | + EffAdv + EffAdj | All Iteration 1+Iteration 2 A.C.s pass eval |
| Iteration 3 | MVE | + ScalAdv + ScalAdj | All Iteration 1+Iteration 2+Iteration 3 A.C.s pass eval |
| Iteration 4 | Leadership | + remaining + SPAWNED A.C.s | All A.C.s pass eval |

---

## §10 Traceability Chain

<!-- Every A.C. must trace back to the EO through this 4-link chain:
     A.C. ← VANA Grammar Element ← System Design Decision ← Learn Source ← EO -->

| A.C. ID | VANA Element | System Design Decision | Learn Source | EO Link |
|---------|-------------|-------------|-----------|----------|
| Verb-AC1 | Verb | EOP Step {n} | T0.P5:R{r}:C{c} | {udo_short} |
| SustainAdv-AC1 | Adverb (S) | Principle P{n}(S) | T0.P3:R{r}:C{c} | {udo_short} |
| Noun-AC1 | Noun | Component {layer}.{n} | T0.P4:R{r}:C{c} | {udo_short} |
| SustainAdj-AC1 | Adjective (S) | Principle P{n}(S) × Component {layer}.{n} | T0.P3+P4:R{r}:C{c} | {udo_short} |
<!-- Every A.C. must have a complete chain. Broken chain = broken spec. -->

<!-- SECTION MAPPING (OE.6.4 v1.x → v2.0)
Old §0.1-§0.2  → New §2.1-§2.2 (Force Analysis)
Old §0.3-§0.5  → PARKED to system-thinking-extensions.md
Old §0.6       → New §3.1 (8-Component Table)
Old §0.7       → New §3.3 (EOE)
Old §0.8       → New §3.5 (EOP)
Old §1         → New §1 (System Identity — unchanged)
Old §2         → New §4.1 (Verb ACs)
Old §3         → New §4.2 (Adverb ACs)
Old §4         → New §4.3 (Noun ACs — EOT)
Old §5         → New §4.4 (Adjective ACs)
Old §6.1       → New §3.2 (EI/EO Detail)
Old §6.2-§6.4  → REMOVED (redundant)
Old §6.5       → New §6.3 (Integration Chain)
Old §6.6       → PARKED to system-thinking-extensions.md
Old §7         → New §5 (AC-TEST-MAP)
Old §8         → New §7 (Failure Modes)
Old §9         → New §8 (Agent Boundaries)
Old §10        → New §9 (Iteration Plan)
Old §11        → New §6.1/§6.2 (Contracts)
Traceability   → New §10
-->

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[blocker]]
- [[general-system]]
- [[iteration]]
- [[effective-system-design-template]]
- [[ltc-effective-system-design]]
- [[ltc-effective-system-design-blueprint]]
- [[schema]]
- [[system-thinking-extensions]]
- [[task]]
- [[workstream]]
