---
version: "1.2"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
---

# UDS REGISTER — Ultimate Driving System Identification
## OPS_OE.6.4.LTC-PROJECT-TEMPLATE

> When replicating success, trace the chain:
> UDS -> UDS.UD (what drives the driver) -> UDS.UD.Principles (why it works).
> Leverage the fundamental mechanism, not surface tactics.

**Cross-zone write:** Authorized by `1-ALIGN/DESIGN.md` artifact A6, condition C6.
**Sources:** STAKEHOLDERS.md per-stakeholder UDS, stakeholder-input-synthesis §C6, multi-agent design spec [S4].

---

## Active Drivers

### UDS-001: ALPEI framework as primary flow [Su]

| Field | Value |
|-------|-------|
| **Pillar** | Sustainability |
| **Source** | S1-Vinh, S2-Vinh |
| **Description** | The ALPEI zone model (ALIGN -> LEARN -> PLAN -> EXECUTE -> IMPROVE) gives every team member a single mental model: "which zone am I in?" This replaces ad-hoc project structures with a deterministic flow that makes the right action obvious at every stage. |
| **Why it works** | Reduces cognitive load by converting an open-ended question ("what do I do next?") into a bounded one ("which zone am I in, and what does this zone produce?"). Framework is already validated by Vinh's 5 reference PDFs. |
| **Vulnerability** | If the zone structure feels like bureaucracy rather than guidance, adoption fails (cross-ref UBS-001). |
| **Leverage strategy** | Zone READMEs answer "what do I do here?" in under 60 seconds. DSBV operates within zones as the agent-facing sub-process. ALPEI flow enforced by phase ordering (Zone N requires Zone N-1 artifact). |
| **Owner** | Long Nguyen |

---

### UDS-002: Multi-agent orchestration — 4 MECE agents with eval gates [Su]

| Field | Value |
|-------|-------|
| **Pillar** | Sustainability |
| **Source** | S4 (approved design spec) |
| **Description** | 4 specialized agents (ltc-planner/Opus, ltc-builder/Sonnet, ltc-reviewer/Opus, ltc-explorer/Haiku) with MECE scope boundaries, 3 enforcement hooks, 3 new EPs, and hypothesis-driven eval gates. Moves from ~85% probabilistic compliance to ~100% deterministic enforcement. |
| **Why it works** | Narrow agent scope produces better reasoning (LT-3). Eval gates with measured evidence prevent hallucination propagation (LT-1). Tool allowlists cap token waste (LT-7). Approach D (hypothesis-driven) was selected over 3 alternatives with evidence. |
| **Vulnerability** | Orchestration complexity could itself become a blocker if setup cost exceeds benefit (cross-ref UBS-006, UBS-007). |
| **Leverage strategy** | Deploy Foundation slice first (AGENTS.md, EP definitions, context template). Validate with H1/H2/H5 measurements before adding enforcement hooks. L3 migration guide enables member adoption in <=10 min (R24). |
| **Owner** | Long Nguyen |

---

### UDS-003: Obsidian CLI for MD search and interconnectedness [Ef]

| Field | Value |
|-------|-------|
| **Pillar** | Efficiency |
| **Source** | S1-Vinh |
| **Description** | Obsidian CLI enables graph-based search across all markdown files in the repo. Agents and humans can discover connections between artifacts (e.g., a UBS entry linked to a requirement linked to an ADR) without manually navigating folder trees. |
| **Why it works** | Markdown files are the atomic unit of this template. Graph-based discovery surfaces relationships that folder hierarchy obscures. Reduces time-to-find from "navigate 6 zones" to "search once." |
| **Vulnerability** | Obsidian CLI feasibility in headless/agent context is untested (Open Question #3). Dependencies may conflict with "no friction" principle. |
| **Leverage strategy** | Long explores feasibility first (ADR-002). If viable: integrate as optional enhancement alongside existing tools — not a mandatory dependency. Validate with friction test before adopting. |
| **Owner** | Long Nguyen |

---

### UDS-004: Three learning types as organizational model [Su]

| Field | Value |
|-------|-------|
| **Pillar** | Sustainability |
| **Source** | S2-Vinh |
| **Description** | Three types of learning with different lifecycles: (1) Genesis frameworks — org-level, long-lived, shared across projects; (2) Tool/platform — operational, medium-lived, evolves with tooling; (3) Per-project — short-lived, scoped to one project. This taxonomy prevents knowledge from being dumped into a single undifferentiated pile. |
| **Why it works** | Different lifecycles require different storage, curation, and access patterns. Separating them prevents stale per-project notes from polluting long-lived org frameworks. Matches Vinh's mental model for how LTC learns. |
| **Vulnerability** | If the three types are not visibly distinct in the folder structure, users collapse them back into one pile (cross-ref UBS-001). |
| **Leverage strategy** | LEARN zone structure mirrors the three types with distinct subfolders. Each subfolder has a description explaining lifecycle and intended content. `_genesis/` holds type 1 (org frameworks), LEARN zone holds types 2 and 3. |
| **Owner** | Long Nguyen |

---

### UDS-005: Explicit agent context eliminates guesswork [Ef]

| Field | Value |
|-------|-------|
| **Pillar** | Efficiency |
| **Source** | S2-Dat |
| **Description** | When subfolders have descriptions, agents know what goes where, and skills have defined invocation boundaries, the entire class of "agent guessing" errors disappears. Builder time shifts from debugging misplaced artifacts to producing correct ones. |
| **Why it works** | Agents operate deterministically on explicit inputs. Ambiguity forces probabilistic inference, which degrades with context complexity. Eliminating ambiguity at the source is cheaper than catching errors downstream. |
| **Vulnerability** | Description maintenance burden — if descriptions go stale, they become misleading rather than helpful (cross-ref UBS-002). |
| **Leverage strategy** | Subfolder descriptions (R06) via ADR-004 mechanism. Context packaging template (5 fields) for sub-agent dispatch. Skill scope enforcement via naming + manifest (R07). |
| **Owner** | Long Nguyen |

---

### UDS-006: Visible progress signals drive adoption [Su]

| Field | Value |
|-------|-------|
| **Pillar** | Sustainability |
| **Source** | S2-Khang |
| **Description** | Khang and non-technical team members respond to visible progress: clear version numbers, release announcements, checklists with checked items, and zone completion signals. These signals convert "am I doing this right?" anxiety into "I'm making progress" confidence. |
| **Why it works** | Adoption is an emotional decision as much as a rational one. If the template feels opaque, users abandon it. If they see their own progress reflected back, they continue. VERSION file, CHANGELOG, and frontmatter versioning provide the signal infrastructure. |
| **Vulnerability** | If signals require git literacy to read (e.g., only visible via `git log`), non-technical users never see them (cross-ref UBS-003). |
| **Leverage strategy** | VERSION file at root (human-readable). CHANGELOG.md with dated entries. Release announcement flow (R08, ADR-005). Zone READMEs show completion status. template-check.sh reports current vs latest version on first run. |
| **Owner** | Long Nguyen |

---

### UDS-007: Deterministic enforcement via hooks and allowlists [Sc]

| Field | Value |
|-------|-------|
| **Pillar** | Scalability |
| **Source** | S4 |
| **Description** | Moving from agent self-enforcement (~85% compliance) to hook-based enforcement (~100% compliance) via 3 hooks (verify-deliverables, save-context-state, resume-check) and per-agent tool allowlists. This makes the system reliable at scale — compliance doesn't degrade as team size or agent count grows. |
| **Why it works** | Hooks execute deterministically regardless of agent reasoning quality. Allowlists are binary (tool is allowed or not). Neither depends on the agent "remembering" rules. Grounded in LT-8: agents expand scope unless mechanically constrained. |
| **Vulnerability** | Over-constrained hooks create friction for legitimate edge cases. Hook maintenance becomes its own overhead (cross-ref UBS-004). |
| **Leverage strategy** | Start with verify-deliverables hook (highest-value, prevents out-of-scope artifacts). Add save-context-state and resume-check in sequence. Each hook validated with binary AC before deployment. Hooks are the EOT layer — separate from agent reasoning (EOE). |
| **Owner** | Long Nguyen |

---

### UDS-008: AI-assisted system design as proof of concept [Ef]

| Field | Value |
|-------|-------|
| **Pillar** | Efficiency |
| **Source** | S2-Long |
| **Description** | This template is itself the proof that AI-assisted system design works at LTC. If the template is built well using the ALPEI + multi-agent approach, it validates the methodology for all future projects. Every team member who clones it inherits a working example of the process. |
| **Why it works** | "Show, don't tell" — the template IS the documentation. Team members learn the process by using it, not by reading about it. Success here de-risks adoption of the same approach for revenue-generating projects. |
| **Vulnerability** | If I1 ships late or incomplete, it becomes evidence AGAINST the methodology instead of for it (cross-ref UBS-001). |
| **Leverage strategy** | Ship I1 as sustainability-complete (safe to use, not feature-rich). Use template-check.sh passing as the binary signal. Document the build process itself in 5-IMPROVE/ so future projects can replicate. |
| **Owner** | Long Nguyen |

---

## Driver-Pillar Summary

| Pillar | IDs | Count |
|--------|-----|-------|
| **Sustainability** | UDS-001, UDS-002, UDS-004, UDS-006 | 4 |
| **Efficiency** | UDS-003, UDS-005, UDS-008 | 3 |
| **Scalability** | UDS-007 | 1 |

**Pillar coverage check:** All 3 pillars represented. Sustainability-heavy aligns with I1 = sustainability iteration.

---

**Classification:** INTERNAL
