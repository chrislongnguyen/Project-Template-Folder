---
version: "1.0"
last_updated: 2026-03-30
type: input-synthesis
feeds: "ALIGN workstream — SOP Step 1.1"
---
# Stakeholder Input Synthesis — 2026-03-30

## Sources

| # | Source | Date | Participants | Format |
|---|--------|------|-------------|--------|
| S1 | Vinh whiteboard session | 2026-03-30 | Vinh (CIO/Director), Long | 1:1 strategy session |
| S2 | Team feedback session | 2026-03-30 | Đạt, Khang, Long, Vinh | Group discussion |
| S4 | Multi-agent orchestration design spec | 2026-03-30 | Long (builder), Vinh (approved) | Approved design in worktree |

## Primary Framing: ALPEI Workstreams

The organizing principle is **ALPEI**: ALIGN → LEARN → PLAN → EXECUTE → IMPROVE. This is the flow the Human Director follows. The Human thinks: "which ALPEI workstream am I in?" — not "which 7-CS component am I building?"

The 7-CS (EP, Input, EOP, EOE, EOT, Agent, EA) is a **property** of the repo that ensures quality — not the primary lens. The template serves the Human Director to follow Agile (continuous delivery + continuous improvement) by leveraging AI Agent as the Do-er. The Human must leverage EOE, EOT, EOP to harness Agent in all scenarios, with full respect to the 8 LLM Truths.

**LEARN workstream ordering:** LEARN comes AFTER ALIGN, BEFORE PLAN.
- ALIGN first (understand the problem, define EO)
- LEARN second (research what you need to fulfill alignment AND inform planning)
- Learning outputs feed BACK into ALIGN (refine charter/requirements) AND FORWARD into PLAN
- PLAN third (minimize risks, design, sequence)
- EXECUTE fourth (build via DSBV)
- IMPROVE fifth (learn from execution, loop back)

**Iteration logic:** Each iteration = one pass through ALPEI, prioritized S → E → Sc:
- I1 = Sustainability (safe to use, adoptable)
- I2 = Efficiency (faster, better)
- I3+ = Scalability (works at org scale)

**Two types of alignment:**
- Human↔Human (philosophy, frameworks) — happens on WMS. OUT OF SCOPE for I1.
- Human↔Agent (project artifacts in repo) — charter, OKRs, decisions. IN SCOPE for I1.

## Draft Charter Delta

A draft charter exists at `1-ALIGN/charter/drafts/PROJECT_CHARTER.md` (dated 2026-03-26). The following items are **stale** after S1/S2 discussions:

| Charter Claim | Current Reality | Impact |
|---------------|----------------|--------|
| "5 workstreams: GOVERN workstream–4 + _shared/" | Now 6 workstreams with LEARN as separate workstream | Structural change — charter §2 needs rewrite |
| "_shared/ knowledge base" | Renamed to `_genesis/` in PR #6 | Naming update throughout charter |
| Sc2 "LEARN-inside-ALIGN" | LEARN is now separate workstream per Vinh's formal request [S1] | Removes a scalability principle |
| Out of Scope "Notion/ClickUp integration" | Obsidian Bases suggested as interim dashboard [S1] | May need scope re-evaluation |
| I1 complete by 2026-03-28 | Timeline is stale — I1 ongoing | §5 timeline needs refresh |

**Still valid:** EO statement (§1), problem statement, system boundary (§2 INPUT/EO/OUTPUT), stakeholder analysis (§3), most governing principles (§4), top 3 risks (§6).

## Multi-Agent Design Status

- **Design spec:** APPROVED (in worktree `feat/multi-agent-orchestration`)
- **Scope:** I1 Sustainability (deterministic enforcement, token efficiency, hallucination prevention)
- **Next:** /writing-plans → DSBV Build
- **31 artifacts** across 6 slices (Foundation → S1/S2 parallel → S3 → S4 → S5 → Finalize)

## Condition Mapping

| # | Condition | Status | Evidence from Discussions |
|---|-----------|--------|--------------------------|
| C1 | Problem/opportunity understood (WHY) | **KNOWN** | Charter EO is solid and still valid: "LTC team members can start any new project with correct structure, embedded thinking frameworks, and AI agent configuration already in place." New inputs refine but don't contradict: LEARN needs separation [S1], agents guess context [S2-Đạt], no release flow [S2-Khang], friction kills adoption [S2-consensus]. |
| C2 | System boundary defined (INPUT/EO/OUTPUT) | **PARTIAL** | Charter defines INPUT/EO/OUTPUT contract (§2). Vinh's 3-layer architecture (Obsidian Base → Agent → WMS) adds a knowledge layer not in charter [S1]. Learning pipeline defined as Info search → Info connection → LEARN → synthesis(?) [S1]. Execution folder = WIP vs deploy = final gives partial output boundary [S2-Vinh]. |
| C3 | Primary user + anti-persona defined | **PARTIAL** | Charter defines primary users: Directors (Khang, Dong) and AI agents. S2 confirms: Đạt's feedback about agent guessing, Khang as representative non-technical user. Vinh's "human PM" reference suggests a specific user role for Obsidian Bases dashboard [S1]. Anti-persona not discussed. |
| C4 | RACI assigned (R ≠ A) | **PARTIAL** | Charter has Vinh=A (CIO), Long=R (builder) — the core constraint R≠A is satisfied. No explicit C/I assignments for Đạt, Khang, or other team members. |
| C5 | UBS identified (role-aware) | **PARTIAL** | Charter has top 3 risks (cognitive overload, agent drift, template drift). S2 adds: agents invoking skills outside intended scope [S2-Đạt], version tracking unclear [S2-Khang], introducing solutions before users hit the problem [S2-consensus], friction killing adoption [S2-consensus]. 6 LT-specific risks with mitigations designed in multi-agent spec [S4]. Key: LT-8 drift (agents exceed scope), LT-1 cascading hallucination across agent boundaries, LT-3 reasoning degradation on broad-scope agents, LT-7 token waste. Not yet formalized as UBS entries with role assignment. |
| C6 | UDS identified (role-aware) | **PARTIAL** | Drivers surfaced: Obsidian CLI for MD search + interconnectedness [S1], Obsidian Bases as interim dashboard [S1], existing ALPEI framework as the flow [S2-Vinh], three learning types as organizational model [S2-Vinh]. 4 MECE agent roster (ltc-planner/Opus, ltc-builder/Sonnet, ltc-reviewer/Opus, ltc-explorer/Haiku), tool routing discipline (≤7 tools per agent), context packaging template (5-field structured handoff), deterministic enforcement via hooks [S4]. Not yet formalized as UDS entries. |
| C7 | Requirements VANA-decomposed with binary ACs | **PARTIAL** | 31 artifacts with binary acceptance criteria defined in multi-agent design spec [S4]. These cover the Agent, EOE, EOT, EOP components of the 7-CS. Combined with the 17 extracted requirements from stakeholder input, substantial requirement coverage exists — but not yet VANA-decomposed. |
| C8 | Success metrics with formulas, pillar-tagged | **UNKNOWN** | Charter has qualitative success def ("Khang can clone, understand in 15 min"). Long mentioned I1 = sustainability [S2]. No formulas or metrics yet. |
| C9 | Domain understood well enough for C7 + C8 | **KNOWN** | Long built the template, team tested it, feedback is in. Vinh's three learning types (Genesis frameworks, tool/platform, per-project) provide domain taxonomy [S2]. 3-layer architecture provides structural understanding [S1]. Learning pipeline has a gap (synthesis step unclear) [S1]. DSBV is internal process, workstreams are the flow [S2-Vinh]. Multi-agent design spec demonstrates deep domain understanding — 7-CS component audit, GAN analysis, tool routing evaluation with measured hypotheses [S4]. |
| C10 | Non-trivial decisions recorded with options + rationale | **PARTIAL** | Several decision points identified (see ADR Candidates) but none formally recorded with options and rationale. LEARN-as-separate-workstream is a major architectural decision from Vinh [S1]. ADR-002 (multi-agent architecture) ready with measured H1/H2/H5 evidence. Approach D (hypothesis-driven with eval gates) selected over 3 alternatives [S4]. Combined with ADR candidates from stakeholder input, substantial decision coverage. |

## Extracted Requirements (pre-VANA)

| # | Source | Raw Statement | MoSCoW Guess | S/E/Sc |
|---|--------|---------------|-------------|--------|
| R01 | S1-Vinh | LEARN becomes a separate workstream (after ALIGN, before PLAN) feeding into both ALIGN and PLAN | Must | Su |
| R02 | S1-Vinh | Try Obsidian CLI for MD search + interconnectedness | Should | E |
| R03 | S1-Vinh | Obsidian Bases as interim dashboard for human PM | Could | E |
| R04 | S1-Vinh | 3-layer architecture: Obsidian Base (knowledge) → Agent (execution) → WMS (accountability) | Should | Sc |
| R05 | S1-Vinh | Learning pipeline: Info search → Info connection → LEARN → synthesis (part of LEARN workstream extraction) | Must | Su |
| R06 | S2-Đạt | Subfolders must have descriptions so agents don't guess and users don't skip | Must | Su |
| R07 | S2-Đạt | Skills in nested folders must not be invocable outside intended scope | Must | Su |
| R08 | S2-Khang | Release announcement flow must exist | Should | Su |
| R09 | S2-Khang | Version tracking must be clear to all team members | Must | Su |
| R10 | S2-Long | I1 = sustainability — template must be safe to use before adding features | Must | Su |
| R11 | S2-Long | I0-I4 iteration model with version numbering | Must | Sc |
| R12 | S2-consensus | Don't introduce solutions before users hit the problem | Must | Su |
| R13 | S2-consensus | Simplicity first in all template features | Must | Su |
| R14 | S2-consensus | Minimize friction — friction kills adoption | Must | Su |
| R15 | S2-Vinh | Three learning types: Genesis frameworks, tool/platform, per-project (different lifecycles) | Must | Su |
| R16 | S2-Vinh | Execution folder = WIP, deploy = final (separation of draft vs published) | Should | E |
| R17 | S2-Vinh | ALPEI workstreams are the flow the Human follows; DSBV is internal process (not user-facing flow) | Must | Su |
| R18 | S4 | 4 MECE agent roster with scope boundaries and tool allowlists | Must | Su |
| R19 | S4 | 3 enforcement hooks (verify-deliverables, save-context-state, resume-check) | Must | Su |
| R20 | S4 | Context packaging template (5 fields: EO, INPUT, EP, OUTPUT, VERIFY) for sub-agent dispatch | Must | Su |
| R21 | S4 | Tool routing rule with per-agent allowlists and cost tiers | Must | Su |
| R22 | S4 | 3 new EPs: EP-11 (Agent Role Separation), EP-12 (Verified Handoff), EP-13 (Orchestrator Authority) | Must | Su |
| R23 | S4 | Hypothesis-driven eval gates — nothing ships without measured evidence (Approach D) | Must | Su |
| R24 | S4 | L3 migration guide for member adoption (≤10 min to adopt) | Should | E |

**Legend:** Su = Sustainability, E = Efficiency, Sc = Scalability

**Pillar corrections from v1.0:**
- R01: Sc → **Su** — LEARN as separate workstream is I1 Must, foundational sustainability (formal request from Vinh)
- R04: Must → **Should** — directional architecture, not I1 mandatory
- R05: Sc → **Su** — part of LEARN workstream extraction, I1 scope
- R15: Sc → **Su** — taxonomy is foundational to LEARN workstream design
- R17: Sc → **Su** — the ALPEI flow IS the sustainability foundation

## LEARN Workstream Specifics

LEARN as a separate workstream is **I1 Must** — formal request from Vinh [S1]. Key properties:

1. **Three learning types with different lifecycles:**
   - Genesis frameworks (org-level) — long-lived, shared across all projects
   - Tool/platform (operational) — medium-lived, evolves with tooling
   - Per-project (project-level) — short-lived, scoped to one project

2. **Learning WIP is personal** — drawings, notes, slides, unstructured material. No enforcement on format. This is each user's workspace.

3. **Nothing is redundant** — every learning output has a destination:
   - Feeds BACK into ALIGN (refine charter, requirements, stakeholder analysis)
   - Feeds FORWARD into PLAN (inform risk analysis, architecture decisions, driver identification)

4. **Synthesis step** — Vinh's pipeline: Info search → Info connection → LEARN → synthesis(?). Whether synthesis is a distinct step or part of LEARN needs ADR decision (see ADR-006).

## ADR Candidates

- **ADR-001: LEARN workstream placement and artifacts** — Vinh formally requested LEARN as its own workstream [S1]. "LEARN stays in ALIGN" is OFF THE TABLE. The decision is: (a) where in the workstream order LEARN sits (after ALIGN, before PLAN is the working model from S1), and (b) what artifacts does the LEARN workstream produce? Options for artifacts: (a) research notes + synthesis docs that feed ALIGN/PLAN, (b) structured learning register analogous to UBS/UDS, (c) lightweight WIP folder with synthesis outputs only.

- **ADR-002: Obsidian CLI integration approach** — Vinh wants to try Obsidian CLI for MD search and interconnectedness. Options: (a) native Obsidian CLI as primary search, (b) Obsidian as optional enhancement alongside existing tools, (c) build custom MD search that mimics Obsidian graph features.

- **ADR-003: Knowledge layer architecture** — 3-layer model (Obsidian Base → Agent → WMS) vs current 2-layer (Agent → WMS). Impacts how knowledge is stored, searched, and connected. Options: (a) Obsidian vault as knowledge base with agent reading from it, (b) flat markdown with agent-managed indexing, (c) hybrid with Obsidian for humans and agent-native indexing for agents.

- **ADR-004: Subfolder description mechanism** — Đạt's feedback requires descriptions in subfolders. Options: (a) README.md in every subfolder, (b) YAML frontmatter index file per workstream, (c) centralized manifest file, (d) directory-level CLAUDE.md files.

- **ADR-005: Release announcement flow** — Khang identified missing release communication. Options: (a) CHANGELOG.md + git tags only, (b) automated announcement via CI/CD hook, (c) manual announcement template in _genesis/templates, (d) WMS-integrated release notes.

- **ADR-006: Synthesis step in learning pipeline** — Vinh's pipeline has a question mark after LEARN: "Info search → Info connection → LEARN → (synthesis?)". Whether synthesis is a distinct step or part of LEARN/ALIGN needs decision.

- **ADR-007: Multi-agent architecture** — ALREADY DESIGNED with evidence [S4]. 4 approaches evaluated, Approach D selected (hypothesis-driven with eval gates). H1/H2/H5 measured. Ready to formalize from design spec.

## Design Principles (from discussions)

1. **ALPEI workstreams are the flow.** Users navigate workstreams (ALIGN → LEARN → PLAN → EXECUTE → IMPROVE). DSBV is how agents and builders produce artifacts within each workstream — not a user-facing workflow. [S2-Vinh]

2. **Problem-first, not solution-first.** "Don't introduce solutions before users hit the problem." [S2-consensus] — Features must respond to demonstrated need, not anticipated need.

3. **Simplicity is non-negotiable.** Complexity must be justified by proportional value. Default to the simpler option. [S2-consensus]

4. **Friction kills adoption.** Every feature must pass the friction test: does this make the template harder to start using? If yes, it must earn its place. [S2-consensus]

5. **Sustainability before scalability.** I1 = safe to use. The template must be reliable and trustworthy before it is feature-rich. [S2-Long]

6. **Separate knowledge, execution, and accountability.** Three distinct layers: Obsidian Base (knowledge), Agent (execution), WMS (accountability). Don't collapse layers. [S1-Vinh]

7. **Three types of learning are not equal.** Genesis frameworks, tool/platform knowledge, and per-project learning have different lifecycles, audiences, and storage needs. [S2-Vinh]

8. **Draft vs final must be explicit.** Execution folder = WIP, deploy = final. No ambiguity about artifact maturity. [S2-Vinh]

9. **Agent context must be explicit.** Agents should not guess scope or purpose — provide descriptions, boundaries, and intended invocation context. [S2-Đạt]

10. **Deterministic over probabilistic enforcement.** Move from ~85% rule compliance (agent self-enforcement) to ~100% (hooks + allowlists). Grounded in LT-8. [S4]

11. **Hypothesis-driven delivery.** Nothing ships without measured evidence. A/B test before adopting. Approach D. [S4]

## Open Questions (for Step 1.1 brainstorm)

1. **LEARN workstream artifacts:** What artifacts does the LEARN workstream produce? How do they differ from current `2-LEARN/` outputs? What is the minimum viable artifact set for I1?

2. **Synthesis step:** Is synthesis a sub-step of LEARN, a transition step between LEARN and ALIGN/PLAN, or its own phase? What does the output of synthesis look like?

3. **Obsidian CLI feasibility:** Has anyone tested Obsidian CLI in a headless/agent context? What are the dependencies and constraints? Is it compatible with the "no friction" principle?

4. **Subfolder description format:** What format works for both agents (machine-readable) and humans (scannable)? README.md vs YAML vs manifest?

5. **Release announcement audience:** Who receives release announcements — all 8 team members, only active contributors, external stakeholders? What channel (ClickUp, email, chat)?

6. **Version tracking visibility:** What does "clear version tracking" mean to Khang specifically? Is the current `VERSION` + `CHANGELOG.md` + frontmatter system insufficient, or just not visible enough?

7. **Anti-persona:** Who should NOT use this template? What usage patterns should the template actively discourage?

8. **Success metrics for I1:** What specific, measurable criteria define "safe to use"? How do we know when sustainability is achieved?

9. **Per-project learning lifecycle:** When a project is cloned from the template, how does per-project learning flow back to inform the template (if at all)?

10. **Obsidian Bases scope:** Is the interim dashboard for this template project only, or is it a pattern all LTC projects should adopt? What happens when the "real" WMS dashboard is ready?

11. **Skill scope enforcement:** How should skill invocation scope be technically enforced? Is this a naming convention, a manifest check, or a runtime guard?

12. **RACI completion:** Charter has Vinh=A, Long=R. Who fills C and I roles for I1? Is formalization needed or is the implicit assignment sufficient?

13. **[Reserved]**

14. How do multi-agent artifacts (31) integrate with LEARN workstream extraction? Are they parallel I1 workstreams or sequential?

## Links

- [[ADR-001]]
- [[ADR-002]]
- [[ADR-003]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-11]]
- [[EP-12]]
- [[EP-13]]
- [[README]]
- [[SEQUENCE]]
- [[SKILL]]
- [[dsbv]]
- [[friction]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[project]]
- [[workstream]]
