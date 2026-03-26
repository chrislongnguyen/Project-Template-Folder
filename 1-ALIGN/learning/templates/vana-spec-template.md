> ⚠️ CANONICAL SOURCE: This file is part of the LTC Effective Execution Engine. DO NOT modify, overwrite, or 'optimize' this file without explicit User approval.

# VANA-SPEC: {system_name}

<!-- This template is populated by /spec:extract (OPS-105). Every {placeholder} is
     replaced with data extracted from approved Effective Learning pages (P0-P5).
     Derivation rules in HTML comments explain WHERE each value comes from. -->

---

## §1 System Identity

<!-- Derivation: learn-input + T0.P0 Workstream Contract -->

| Field | Value |
|-------|-------|
| System Name | {system_name} |
| Slug | {system_slug} |
| Abbreviation | {system_abbrev} |
| EO | {eo} |
| Learning Book | BOOK-{nn} |
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

## §2 Verb Acceptance Criteria

<!-- Derivation: T0.P5 — each STEP.n(R) row becomes one Verb-AC (I1).
     STEP.n(A) Col16 (NEXT) cells become SPAWNED Verb-ACs (I4).
     All use sequential Verb-ACn IDs — VANA Element column distinguishes I1 vs SPAWNED. -->

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Verb-AC1 | {verb_word_1} | {verb_criteria_1} | T0.P5:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
| Verb-AC2 | {verb_word_2} | {verb_criteria_2} | T0.P5:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
| Verb-AC{n} | {spawned_word_1} | {spawned_criteria_1} | T0.P5:{row}:Col16 | {Deterministic\|Manual\|AI-Graded} | {threshold} | I4 |
<!-- One row per STEP.n(R) at I1; one row per STEP.n(A) Col16 NEXT cell at I4. Continuous Verb-ACn sequence. -->

---

## §3 Adverb Acceptance Criteria

<!-- Derivation: T0.P3 Principles — bucketed by S/E/Sc pillar tag.
     P(S) → SustainAdv (I1), P(E) → EffAdv (I2), P(Sc) → ScalAdv (I3). -->

### §3.1 Sustainability Adverbs (I1)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| SustainAdv-AC1 | {sustain_adv_word_1} | {sustain_adv_1} | T0.P3:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
<!-- One row per P(S) principle → adverb -->

### §3.2 Efficiency Adverbs (I2)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| EffAdv-AC1 | {eff_adv_word_1} | {eff_adv_1} | T0.P3:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I2 |
<!-- One row per P(E) principle → adverb -->

### §3.3 Scalability Adverbs (I3)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| ScalAdv-AC1 | {scal_adv_word_1} | {scal_adv_1} | T0.P3:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I3 |
<!-- One row per P(Sc) principle → adverb -->

---

## §4 Noun Acceptance Criteria

<!-- Derivation: T0.P4 Components — organized by EOE/EOT layer (I1).
     Hardening ACs derived from T0.P0 RACI(I) role — production readiness gates (I4).
     All use continuous Noun-ACn IDs — VANA Element column distinguishes I1 vs Hardening. -->

### §4.1 INFRA Layer

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Noun-AC1 | {noun_word_1} | {noun_infra_1} | T0.P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
<!-- One row per INFRA component -->

### §4.2 WORKSPACE Layer

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Noun-AC{n} | {noun_word_n} | {noun_workspace_1} | T0.P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
<!-- One row per WORKSPACE component -->

### §4.3 INTEL Layer

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| Noun-AC{n} | {noun_word_n} | {noun_intel_1} | T0.P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
| Noun-AC{n} | {hardening_word_1} | {hardening_criteria_1} | T0.P0:RACI(I) | Deterministic | 100% pass rate | I4 |
<!-- One row per INTEL component (I1), then one row per Hardening AC (I4). Continuous Noun-ACn sequence. -->

---

## §5 Adjective Acceptance Criteria

<!-- Derivation: Cross-reference T0.P3 (principles) x T0.P4 (components).
     Quality attributes for Nouns, bucketed by S/E/Sc pillar. -->

### §5.1 Sustainability Adjectives (I1)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| SustainAdj-AC1 | {sustain_adj_word_1} | {sustain_adj_1} | T0.P3+P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I1 |
<!-- Quality attributes that ensure Noun sustainability -->

### §5.2 Efficiency Adjectives (I2)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| EffAdj-AC1 | {eff_adj_word_1} | {eff_adj_1} | T0.P3+P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I2 |
<!-- Quality attributes that ensure Noun efficiency -->

### §5.3 Scalability Adjectives (I3)

| A.C. ID | VANA Word | Criteria | Source (Page:Row:Col) | Eval Type | Threshold | Iteration |
|---------|-----------|----------|----------------------|-----------|-----------|-----------|
| ScalAdj-AC1 | {scal_adj_word_1} | {scal_adj_1} | T0.P3+P4:{row}:{col} | {Deterministic\|Manual\|AI-Graded} | {threshold} | I3 |
<!-- Quality attributes that ensure Noun scalability -->

---

## §6 AC-TEST-MAP (G1: Eval Specification)

<!-- Derivation: One row per A.C. from §2-§5. This is the eval-driven development
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
| Verb-AC1 | {verb_word} | §2 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| SustainAdv-AC1 | {adv_word} | §3.1 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| Noun-AC1 | {noun_word} | §4 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| SustainAdj-AC1 | {adj_word} | §5.1 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| Verb-AC{n} | {spawned_word} | §2 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
| Noun-AC{n} | {hardening_word} | §4 | {Deterministic\|Manual\|AI-Graded} | {dataset_desc} | {grader_desc} | {threshold} |
<!-- One row per A.C. — MECE. Every A.C. from §2-§5 must appear exactly once. I4 Verb (SPAWNED) and Noun (Hardening) use the same Verb-ACn / Noun-ACn sequence. -->

---

## §7 Failure Modes & Recovery (G3)

<!-- Derivation: Seeded from T0.P1 UBS analysis (blockers) and T0.P5 col 9/10
     (UD.MECH / UB.MECH). Per-iteration table — failure modes become more specific
     as the system matures through iterations.

     Categories: Hallucination, API Failure, Context Loss, Token Exhaustion,
                 Schema Violation, Permission Denied, Stale Data -->

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
     Anthropic 3-tier system. Boundaries tighten as system matures.
     Per config/constraints.yaml: behavioral_boundaries.tiers = [always, ask_first, never] -->

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

<!-- Every A.C. from §2-§5 assigned to exactly one iteration — MECE.
     Rule: Sustainability gates everything. No I2 work until all I1 A.C.s pass. -->

### Master Scope Mapping

| A.C. ID | VANA Word | Criteria (short) | VANA Element | Iteration | Status |
|---------|-----------|------------------|--------------|-----------|--------|
| Verb-AC1 | {verb_word} | {short_desc} | Verb | I1 | To Do |
| SustainAdv-AC1 | {adv_word} | {short_desc} | Adverb (S) | I1 | To Do |
| Noun-AC1 | {noun_word} | {short_desc} | Noun | I1 | To Do |
| SustainAdj-AC1 | {adj_word} | {short_desc} | Adjective (S) | I1 | To Do |
| EffAdv-AC1 | {adv_word} | {short_desc} | Adverb (E) | I2 | To Do |
| EffAdj-AC1 | {adj_word} | {short_desc} | Adjective (E) | I2 | To Do |
| ScalAdv-AC1 | {adv_word} | {short_desc} | Adverb (Sc) | I3 | To Do |
| ScalAdj-AC1 | {adj_word} | {short_desc} | Adjective (Sc) | I3 | To Do |
| Verb-AC{n} | {spawned_word} | {short_desc} | Verb (SPAWNED) | I4 | To Do |
| Noun-AC{n} | {hardening_word} | {short_desc} | Noun (Hardening) | I4 | To Do |
<!-- Every A.C. appears exactly once. One row per A.C. I4 SPAWNED = Verb-ACn. I4 Hardening = Noun-ACn. Continuous sequence. -->

### Iteration Sequencing

| Iteration | Name | Scope | Gate Criteria |
|-----------|------|-------|---------------|
| I1 | Concept | Verb + SustainAdv + Noun + SustainAdj | All I1 A.C.s pass eval |
| I2 | Working Prototype | + EffAdv + EffAdj | All I1+I2 A.C.s pass eval |
| I3 | MVE | + ScalAdv + ScalAdj | All I1+I2+I3 A.C.s pass eval |
| I4 | Leadership | + remaining + SPAWNED A.C.s | All A.C.s pass eval |

---

## §10 Integration Contracts (G2)

<!-- Derivation: learn-input Workstream Contract (T0.P0).
     Per config/constraints.yaml: interface_contract.required_fields =
       [source, schema, field_types, validation_rules, error_handling, sla, version] -->

### INPUT CONTRACT

<!-- One table per upstream system that provides data to this system -->

| Field | Value |
|-------|-------|
| Source | {upstream_system} |
| Schema | {input_schema} |
| Field Types | {field_types} |
| Validation Rules | {validation_rules} |
| Error Handling | {error_handling} |
| SLA | {sla} |
| Version | {version} |

### OUTPUT CONTRACT

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

---

## Traceability Chain

<!-- Every A.C. must trace back to the EO through this 4-link chain:
     A.C. ← VANA Grammar Element ← ESD Phase 2 Decision ← ILE Page ← EO -->

| A.C. ID | VANA Element | ESD Decision | ILE Source | EO Link |
|---------|-------------|-------------|-----------|----------|
| Verb-AC1 | Verb | EOP Step {n} | T0.P5:R{r}:C{c} | {udo_short} |
| SustainAdv-AC1 | Adverb (S) | Principle P{n}(S) | T0.P3:R{r}:C{c} | {udo_short} |
| Noun-AC1 | Noun | Component {layer}.{n} | T0.P4:R{r}:C{c} | {udo_short} |
<!-- Every A.C. must have a complete chain. Broken chain = broken spec. -->
