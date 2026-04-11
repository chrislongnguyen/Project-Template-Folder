---
version: "1.1"
status: archived
last_updated: 2026-04-10
type: template
work_stream: 2-LEARN
stage: spec
sub_system:
iteration: 1
superseded_by: vana-spec-template.md
aliases:
  - ESD Template
---

> **SUPERSEDED:** This template's unique content (8-Component Design, Environment Design, EOP Design) has been merged into `vana-spec-template.md` §0.6-§0.8. Use `vana-spec-template.md` for all new sub-system specs. This file is retained as design methodology reference only.

# EFFECTIVE SYSTEM DESIGN — <!-- TODO: Replace with subsystem name (e.g., "PROBLEM DIAGNOSIS", "DATA PIPELINE") -->

> Fillable template for the Effective System Design (ESD) of one subsystem.
> Produced during the LEARN workstream per-subsystem. Governs all downstream PLAN and EXECUTE work.
> Methodology reference: `_genesis/reference/ltc-effective-system-design.md`
> Cell(s) enabled: 2-LEARN (S3: Structure, S5: Spec)

---

## Document Control

| Field | Value |
|-------|-------|
| Sub-system | <!-- TODO: 1-PD / 2-DP / 3-DA / 4-IDM --> |
| Iteration | <!-- TODO: Iteration 0 / Iteration 1 / Iteration 2 / Iteration 3 / Iteration 4 --> |
| Author | <!-- TODO: PM name --> |
| Date | <!-- TODO: YYYY-MM-DD --> |
| ELF Learning Book | <!-- TODO: Path to completed Learning Book in 2-LEARN/ --> |
| Upstream ESD | <!-- TODO: Path to upstream subsystem ESD, or "N/A — this is PD (root)" --> |

---

## PHASE 1: PROBLEM DISCOVERY

> Reconstruct the User's system from ELF output — before introducing any technology.
> Source: ELF Learning Book (EO, User Roles, UBS, UDS layers).
> Rule: No solution language. Phase 1 describes the problem space only.

### 1.1 Workstream Boundary

| Field | Value |
|-------|-------|
| INPUT (from upstream) | <!-- TODO: What triggers this subsystem; what data/artifacts arrive from the upstream subsystem --> |
| EO (Effective Outcome) | <!-- TODO: Carried verbatim from ELF — the fundamental state the User is trying to achieve --> |
| OUTPUT (to downstream) | <!-- TODO: What this subsystem produces for the next subsystem in the chain --> |

### 1.2 User Definition

**User Persona (Primary)**

<!-- TODO: Who is the primary User this subsystem is designed for?
Include: role/title, operating context, current tools and methods, capability level,
primary job-to-be-done, key constraints.
Specific enough that a designer can make decisions by referencing this profile. -->

**Anti-Persona**

<!-- TODO: Who is explicitly NOT the User? What characteristics disqualify an actor?
Include: what they do differently, why this subsystem is not designed for them,
and why designing for them would harm the primary User. Be precise. -->

**System-Level RACI**

| Role | Actor | Perspective for UBS/UDS |
|------|-------|------------------------|
| R (Responsible) | <!-- TODO: Who does the work (e.g., AI Agent) --> | UBS(R): what blocks R from executing; UDS(R): what drives R |
| A (Accountable) | <!-- TODO: Who owns the outcome (e.g., Human Director) --> | UBS(A): what blocks A from ensuring quality; UDS(A): what drives A |
| C (Consulted) | <!-- TODO: Domain expert / upstream provider --> | -- |
| I (Informed) | <!-- TODO: Downstream consumer / team / logs --> | -- |

### 1.3 UBS Full Analysis (Blocking Forces)

> Root system of forces preventing the User from reaching the EO.
> Analyze from BOTH R and A perspectives. Use recursive dot-notation for depth.

| ID | Element | Description | Root Cause | Failure Mechanism | Constraint Type |
|----|---------|-------------|------------|-------------------|-----------------|
| UBS(R) | <!-- TODO: Root blocker from R perspective --> | <!-- TODO: Description --> | <!-- TODO: Why it exists --> | <!-- TODO: How it causes failure --> | <!-- TODO: Technical / Human / Economic / Temporal --> |
| UBS(R).UD | <!-- TODO: What drives UBS(R) harder --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| UBS(R).UB | <!-- TODO: What disables UBS(R) --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| UBS(A) | <!-- TODO: Root blocker from A perspective --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| UBS(A).UD | <!-- TODO: What drives UBS(A) harder --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| UBS(A).UB | <!-- TODO: What disables UBS(A) --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| <!-- TODO: Add recursive layers as needed (UBS.UD.UD, UBS.UB.UB, etc.) --> | | | | | |

### 1.4 UDS Full Analysis (Driving Forces)

> Root system of forces helping the User reach the EO.
> Analyze from BOTH R and A perspectives. Use recursive dot-notation for depth.

| ID | Element | Description | Root Enabler | Success Mechanism | Automation Potential |
|----|---------|-------------|--------------|-------------------|---------------------|
| UDS(R) | <!-- TODO: Root driver from R perspective --> | <!-- TODO: Description --> | <!-- TODO: Why it exists --> | <!-- TODO: How it enables success --> | <!-- TODO: None / Partial / Full --> |
| UDS(R).UD | <!-- TODO: What drives UDS(R) further --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| UDS(R).UB | <!-- TODO: What blocks UDS(R) --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| UDS(A) | <!-- TODO: Root driver from A perspective --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| UDS(A).UD | <!-- TODO: What drives UDS(A) further --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| UDS(A).UB | <!-- TODO: What blocks UDS(A) --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| <!-- TODO: Add recursive layers as needed --> | | | | | |

---

## PHASE 2: SYSTEM DESIGN

> Define the conceptual solution space based ONLY on what was learned in Phase 1 and ELF.
> Rule: No design decision without a causal link to UBS or UDS.

### 2.1 Effective Principles Derivation

> Each principle derived directly from UBS/UDS findings. Bucketed by S/E/Sc pillar and role-tagged.
> Format: P[n](Pillar)(Role): Principle — Disables [UBS element] / Enables [UDS element]

**Sustainability Principles**

| ID | Principle | Disables/Enables | Enforcement Mechanism |
|----|-----------|-----------------|----------------------|
| P1(S)(R) | <!-- TODO: Principle governing correct/safe operation for R --> | <!-- TODO: UBS element --> | <!-- TODO: How enforced --> |
| P2(S)(A) | <!-- TODO: Principle governing correct/safe operation for A --> | <!-- TODO: UBS element --> | <!-- TODO: How enforced --> |
| <!-- TODO: Add rows as needed --> | | | |

**Efficiency Principles**

| ID | Principle | Enables | Enforcement Mechanism |
|----|-----------|---------|----------------------|
| P3(E)(R) | <!-- TODO: Principle governing fast/lean operation --> | <!-- TODO: UDS element --> | <!-- TODO: How enforced --> |
| <!-- TODO: Add rows as needed --> | | | |

**Scalability Principles**

| ID | Principle | Enables | Enforcement Mechanism |
|----|-----------|---------|----------------------|
| P4(Sc)(R) | <!-- TODO: Principle governing repeatable/scalable operation --> | <!-- TODO: UDS element --> | <!-- TODO: How enforced --> |
| <!-- TODO: Add rows as needed --> | | | |

### 2.2 8-Component System Design

> The 8 Effective System Components applied to this subsystem.
> Each component has current state (as-is) and target state (to-be).

| # | Component | Abbrev | Current State | Target State | Governing Principle(s) |
|---|-----------|--------|---------------|--------------|----------------------|
| 1 | Effective Input | EI | <!-- TODO: What the subsystem currently receives --> | <!-- TODO: What it should receive --> | <!-- TODO: P[n] --> |
| 2 | Effective User | EU | <!-- TODO: Current user profile and capability --> | <!-- TODO: Target user profile --> | <!-- TODO: P[n] --> |
| 3 | Effective Action | EA | <!-- TODO: Current action patterns --> | <!-- TODO: Target actions --> | <!-- TODO: P[n] --> |
| 4 | Effective Outcome | EO | <!-- TODO: Current outcome state --> | <!-- TODO: Target outcome state --> | <!-- TODO: P[n] --> |
| 5 | Effective Principles | EP | <!-- TODO: Current governing principles --> | <!-- TODO: Target principles (from 2.1) --> | <!-- TODO: P[n] --> |
| 6 | Effective Operating Environment | EOE | <!-- TODO: Current environment --> | <!-- TODO: Target environment --> | <!-- TODO: P[n] --> |
| 7 | Effective Operating Tools | EOT | <!-- TODO: Current tools --> | <!-- TODO: Target tools --> | <!-- TODO: P[n] --> |
| 8 | Effective Operating Procedure | EOP | <!-- TODO: Current procedures --> | <!-- TODO: Target procedures --> | <!-- TODO: P[n] --> |

### 2.3 Environment Design (EOE)

> Organized by environment type. DERISK column = Sustainability. OPTIMIZE column = Efficiency/Scalability.

| Environment Type | DERISK (Sustainability) | OPTIMIZE (Efficiency/Scalability) |
|------------------|------------------------|----------------------------------|
| Physical | <!-- TODO: Physical safety, access control --> | <!-- TODO: Co-location, ergonomics --> |
| Digital | <!-- TODO: Data security, access rights --> | <!-- TODO: Speed, integration, automation --> |
| Cultural | <!-- TODO: Psychological safety, reporting --> | <!-- TODO: Deep work, recognition, autonomy --> |
| Other | <!-- TODO: Regulatory, compliance --> | <!-- TODO: Innovation, external partnerships --> |

### 2.4 Tools Design (EOT)

> Organized by 3 causal layers. Name each layer for this subsystem's domain.

| Layer | Name | Components | Traces to Principle |
|-------|------|------------|-------------------|
| Layer 1 (Foundational) | <!-- TODO: Subject-specific name (e.g., Infrastructure) --> | <!-- TODO: Base runtime components --> | <!-- TODO: P[n] --> |
| Layer 2 (Operational) | <!-- TODO: Subject-specific name (e.g., Workspace) --> | <!-- TODO: Working environment components --> | <!-- TODO: P[n] --> |
| Layer 3 (Enhancement) | <!-- TODO: Subject-specific name (e.g., Intelligence) --> | <!-- TODO: Amplification components --> | <!-- TODO: P[n] --> |

**Desirable Wrapper** (Iterations 0-2)

<!-- TODO: Minimal tool configuration enabling the User to perform core Verbs sustainably.
What root-level UBS/UDS elements does this address? -->

**Effective Core** (Iterations 3-4)

<!-- TODO: Full tool configuration solving recursive UBS/UDS layers.
What depth layers does this unlock? -->

### 2.5 EOP Design (Effective Operating Procedure)

> Sequential gated steps. Stage 1 (DERISK) must complete before Stage 2 (OPTIMIZE).

**EOP Decision Matrix**

| Category | Targeted Elements | Source | Role Assignment |
|----------|------------------|--------|-----------------|
| DERISK: UBS to disable | <!-- TODO: List specific UBS elements from 1.3 --> | Phase 1 §1.3 | R: <!-- TODO -->; A: <!-- TODO --> |
| OPTIMIZE: UDS to amplify | <!-- TODO: List specific UDS elements from 1.4 --> | Phase 1 §1.4 | R: <!-- TODO -->; A: <!-- TODO --> |

**Stage 1 — DERISK (Sustainability)**

| Step # | Step Name | Required Input | Desired Output | R | A | C | I | Gate |
|--------|-----------|----------------|----------------|---|---|---|---|------|
| 1 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO: Verifiable condition --> |
| 2 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| <!-- TODO: Add rows as needed --> | | | | | | | | |

**Stage 2 — OPTIMIZE (Efficiency + Scalability)**

| Step # | Step Name | Required Input | Desired Output | R | A | C | I | Gate |
|--------|-----------|----------------|----------------|---|---|---|---|------|
| 3 | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> | <!-- TODO --> |
| <!-- TODO: Add rows as needed --> | | | | | | | | |

---

## PHASE 3: USER'S REQUIREMENTS (VANA)

> Translate Phase 2 into strict, deterministic, binary engineering requirements.
> Every A.C. must be: Atomic, Binary, Deterministic, Pre-committed, Traceable.
> A.C. ID format: `{Grammar}-AC{n}` (e.g., Verb-AC1, SustainAdv-AC2)

### 3.1 User Definition Summary

**Primary User Persona:** <!-- TODO: One paragraph from Phase 1 §1.2 -->

**Anti-Persona:** <!-- TODO: One paragraph from Phase 1 §1.2 -->

### 3.2 Verb Requirements (Desired User Actions)

> One block per EOP step where the primary User Role = Responsible.
> Repeat the full block for each Verb.

#### Verb 1: <!-- TODO: Action word from EOP Step N -->

*Traceability: EOP Step <!-- TODO: N --> — <!-- TODO: Role --> = Responsible*
*Definition: <!-- TODO: What this action is and what successful completion looks like -->*

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| Verb-AC1 | <!-- TODO: Binary test that the User can perform this action at all --> |
| Verb-AC2 | <!-- TODO: Binary test of a distinct completeness condition --> |

**Sustainability Adverb:** *<!-- TODO: Named adverb(s) — e.g., "Correctly, Verifiably" -->*
*Traceability: EP P[n](S) — Disables <!-- TODO: UBS element -->*

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| SustainAdv-AC1 | <!-- TODO: Binary test that the Verb is performed correctly/safely --> |
| SustainAdv-AC2 | <!-- TODO --> |

**Efficiency Adverb:** *<!-- TODO: Named adverb(s) — e.g., "Incrementally, Frugally" -->*
*Traceability: EP P[n](E) — Enables <!-- TODO: UDS element -->*

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| EffAdv-AC1 | <!-- TODO: Binary test that the Verb is performed quickly/leanly --> |

**Scalability Adverb:** *<!-- TODO: Named adverb(s) — e.g., "Repeatedly, Comparatively" -->*
*Traceability: EP P[n](Sc) — Enables <!-- TODO: UDS element -->*

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| ScalAdv-AC1 | <!-- TODO: Binary test that the Verb scales to required load/scope --> |

<!-- TODO: Repeat the full Verb block for each additional EOP step where User = R -->

### 3.3 Noun Requirements (Feature Requirements)

#### Noun: <!-- TODO: Name of the UE system or primary component -->

*Traceability: EOE/EOT from Phase 2 §2.4*
*Definition: <!-- TODO: What this tool is built to do and for whom -->*

**<!-- TODO: Layer 1 Name --> Components** (Foundational)

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| Noun-AC1 | <!-- TODO: Binary test that foundational component exists and functions --> |
| Noun-AC2 | <!-- TODO --> |

**<!-- TODO: Layer 2 Name --> Components** (Operational)

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| Noun-AC3 | <!-- TODO: Binary test that operational component exists and functions --> |
| Noun-AC4 | <!-- TODO --> |

**<!-- TODO: Layer 3 Name --> Components** (Enhancement)

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| Noun-AC5 | <!-- TODO: Binary test that enhancement component exists and functions --> |

### 3.4 Adjective Requirements (Noun Qualities)

**Sustainability Adjective:** *<!-- TODO: Named qualities — e.g., "Auditable, Sourced, Deterministic" -->*
*Traceability: EP Sustainability Principles — qualities the Noun must possess*

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| SustainAdj-AC1 | <!-- TODO: Binary test of one correctness/safety quality --> |
| SustainAdj-AC2 | <!-- TODO --> |

**Efficiency Adjective:** *<!-- TODO: Named qualities — e.g., "Lightweight, Structured, Automated" -->*
*Traceability: EP Efficiency Principles — qualities for speed/lightness*

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| EffAdj-AC1 | <!-- TODO: Binary test of one speed/lightness quality --> |

**Scalability Adjective:** *<!-- TODO: Named qualities — e.g., "Modular, API-driven, Extensible" -->*
*Traceability: EP Scalability Principles — qualities for growth*

| A.C. ID | Acceptance Criteria |
|---------|-------------------|
| ScalAdj-AC1 | <!-- TODO: Binary test of one modularity/extensibility quality --> |

### 3.5 A.C. Traceability Summary

> Every A.C. requires a complete 4-link chain. Verify before locking.

| A.C. ID | Grammar Element | Phase 2 Decision | ELF Layer | EO Link |
|---------|----------------|-----------------|-----------|---------|
| <!-- TODO: e.g., SustainAdv-AC1 --> | <!-- TODO: e.g., SustainAdv ("Verifiably") --> | <!-- TODO: e.g., EP P1(S) --> | <!-- TODO: e.g., UBS: manual hallucination risk --> | <!-- TODO: EO statement --> |
| <!-- TODO: Add one row per A.C. --> | | | | |

---

## HANDOFF

> What this ESD produces for downstream consumers.

| Output | Consumer | Path |
|--------|----------|------|
| Validated Effective Principles | PLAN workstream (architecture, risk registers) | <!-- TODO: 3-PLAN/{subsystem}/ --> |
| VANA Requirements (Phase 3) | EXECUTE workstream (build specs) | <!-- TODO: 4-EXECUTE/{subsystem}/ --> |
| UBS/UDS Analysis | PLAN risk/driver registers | `3-PLAN/_cross/UBS_REGISTER.md`, `3-PLAN/_cross/UDS_REGISTER.md` |
| EOP Steps | EXECUTE task breakdown | <!-- TODO: 4-EXECUTE/{subsystem}/ --> |
| Subsystem boundary (INPUT/OUTPUT) | Adjacent subsystem ESDs | <!-- TODO: Path to downstream subsystem ESD --> |

---

## Links

- [[ltc-effective-system-design]]
- [[vana-spec-template]]
- [[charter]]
- [[force-analysis-template]]
- [[UBS_REGISTER]]
- [[UDS_REGISTER]]
- [[ltc-ues-versioning]]
- [[workstream]]
- [[iteration]]
- [[alpei-dsbv-process-map]]
