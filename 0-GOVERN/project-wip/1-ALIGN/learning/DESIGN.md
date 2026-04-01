---
version: "1.1"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-29
owner: Long Nguyen
---
# DSBV Context Package — Learn-Skill Refactor

> Input context for agents running DSBV Build phase on the learning subsystem.
> Budget: ~4000 words. Every token costs signal-to-noise ratio.
> Bookend pattern (LT-2): most critical content at start and end, least critical in middle.

---

## Section 1: Project Identity

### What

Refactor the 7 legacy learning skills in `1-ALIGN/learning/skills/` into a 6+1 architecture with:
- A state-aware orchestrator (`/learn`) that derives pipeline state from file system
- 5 pipeline skills (input, research, structure, review, spec) with clear boundaries
- 1 on-demand companion skill (visualize) decoupled from the pipeline

**In scope:** 7 new skill directories, shared research methodology extraction, Advanced EL reference import with glossary alignment, legacy skill cleanup.

**Out of scope:** Changes to deep-research skill (only extracts shared methodology FROM it). Changes to DSBV process itself. P-page template format changes. Validation script rewrites.

**Rollback:** Worktree isolation — `git reset` in worktree; main repo unaffected. No destructive changes to main branch.

### Who

| Role | Person | RACI | Function |
|------|--------|------|----------|
| Director | Long Nguyen | **A** | Approves designs, reviews P-pages, approves specs |
| Builder | Claude Agent | **R** | Writes skill files, extracts methodology, aligns glossary |
| Consumer | DSBV Process | **I** | Downstream consumer of DSBV Readiness Package output |

### Purpose

Claude Agent [orchestrates structured learning pipelines] [producing approved P-pages and DSBV-ready specs] without [state corruption, context explosion, or passive rubber-stamping].

---

## Section 2: Key Decisions Already Made

> Settled constraints — agents MUST respect these, do not re-litigate.

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | State derived from file system, not stored in JSON | Prevents state/reality desync (LT-6, UBS.R.2) |
| D2 | Research and structure are separate skills | Different cognitive tasks; merging violates EP-04 (context explosion) and EP-09 (decompose) |
| D3 | Per-topic structure→review loop (not batch all topics) | Prevents cognitive overload (UBS.A.3); "one entry point at a time" |
| D4 | Active learning in review (comprehension Q per page) | Prevents passive rubber-stamping (UBS.A.1) |
| D5 | Shared research methodology in `_shared/templates/` | Single source of truth for deep-research + learn-research (S>E>Sc best practice) |
| D6 | Extract methodology FIRST (before building learn skills) | Learn:research can reference from day one (Q7) |
| D7 | `/learn:visualize` inside learn skill directory | Learning-specific, not general-purpose viz (Q8: option A) |
| D8 | Advanced EL doc rewritten with aligned terms (EO not UDO, EP not EPS) | Single vocabulary; careful, no content drift (Q9: option B) |
| D9 | GSD-STATE.md eliminated | This repo uses DSBV; /learn:spec produces DSBV Readiness Package instead |
| D10 | Interactive HTML as React+Vite with LTC brand | Midnight Green, Gold, Inter font; nodes from P-pages, edges from causal refs |

---

## Section 3: What This Zone Must Produce

### Required Artifacts + Completion Conditions (unified)

| # | Artifact | File Path | Key Content | Condition | Binary Test |
|---|----------|-----------|-------------|-----------|-------------|
| A1 | Research Methodology | `_shared/templates/RESEARCH_METHODOLOGY.md` (target); source: `skills/deep-research/reference/methodology.md` | 3 concerns (multi-angle search, source verification, anti-hallucination) restructured from 8-phase pipeline | C1: Extracted from deep-research 8-phase methodology; restructured into 3 concern-based sections | File exists; 3 concern sections present (search, verification, anti-hallucination); no deep-research-specific references (no CODE questions, no mode-specific thresholds) |
| A2 | Advanced EL Reference | `_shared/reference/ADVANCED-EL-SYSTEM.md` | Effective Learning framework with aligned glossary | C2: All content preserved; 0 legacy terms (UDO→EO, EPS→EP, etc.) | **PRE-COMPLETED** — 1005/1005 lines, 9/9 sections, 0 legacy terms, 24 term replacements verified. Director to confirm during Build. |
| A3 | Orchestrator Skill | `1-ALIGN/learning/skills/learn/SKILL.md` + supporting files | State derivation logic, routing table (5 states), flow diagram | C3: Routes to correct sub-skill for 5 file-system states | Routing table has 5 entries matching these states; no stored state file referenced |
| | | | _5 states: (1) No learn-input file → /learn:input, (2) Input exists, no research dir → /learn:research, (3) Research exists, topics not structured → /learn:structure + /learn:review per topic, (4) All topics approved, no VANA-SPEC → /learn:spec, (5) Spec exists → "Pipeline complete" message_ | | |
| A3 | | | | C4: Passes EOP validation 23/23 | `skill-validator.sh learn/` = 23/23 |
| A4 | Input Skill | `1-ALIGN/learning/skills/learn-input/SKILL.md` + supporting files | 9-question interview, EO validation gate, escape hatch | C5: EO gate rejects vague EOs lacking [User][desired state][constraint] | Gate instruction present with structure check + 3 example EOs |
| A4 | | | | C6: Passes EOP validation 23/23 | `skill-validator.sh learn-input/` = 23/23 |
| A5 | Research Skill | `1-ALIGN/learning/skills/learn-research/SKILL.md` + supporting files | Parallel sub-agent dispatch, source verification gate, escape hatches | C7: References `_shared/templates/RESEARCH_METHODOLOGY.md` (not embeds) | Grep for "Load" or "Read" reference to shared methodology file |
| A5 | | | | C8: Source count gate ≥8 + URL spot-check documented | Gate instruction present with threshold + spot-check procedure |
| A5 | | | | C9: Escape hatches for EXA/WebSearch/QMD failure | 3 escape hatch entries in skill or gotchas |
| A5 | | | | C10: Passes EOP validation 23/23 | `skill-validator.sh learn-research/` = 23/23 |
| A6 | Structure Skill | `1-ALIGN/learning/skills/learn-structure/SKILL.md` + supporting files | Per-topic P0-P5 generation, Opus fork, mermaid companions | C11: Per-topic scope — loads only 1 topic's research | Instruction explicitly limits to 1 topic per invocation |
| A6 | | | | C12: Opus model fork instruction present | Model selection instruction in SKILL.md |
| A6 | | | | C13: Passes EOP validation 23/23 | `skill-validator.sh learn-structure/` = 23/23 |
| A7 | Review Skill | `1-ALIGN/learning/skills/learn-review/SKILL.md` + supporting files | Per-topic review, causal spine table, active learning Qs | C14: Comprehension Q required before approval accepted | Active learning instruction present; answer-required gate |
| A7 | | | | C15: Per-topic scope (not batch) | "ONE topic at a time" instruction present |
| A7 | | | | C16: Passes EOP validation 23/23 | `skill-validator.sh learn-review/` = 23/23 |
| A8 | Spec Skill | `1-ALIGN/learning/skills/learn-spec/SKILL.md` + supporting files | VANA extraction, DSBV Readiness Package, P-page→zone mapping | C17: P-page→zone mapping table with all 6 mappings (P0-P5) | Mapping table present with 6 rows |
| A8 | | | | C18: DSBV Readiness Package generates C1-C6 checklist | Readiness Package template/instruction present |
| A8 | | | | C19: Passes EOP validation 23/23 | `skill-validator.sh learn-spec/` = 23/23 |
| A9 | Visualize Skill | `1-ALIGN/learning/skills/learn-visualize/SKILL.md` + supporting files | React+Vite generation, LTC brand, interactive system map | C20: LTC brand requirements listed (colors, fonts, logo) | Brand section present with hex codes + Inter font |
| A9 | | | | C21: Interactivity spec (click-to-drill, hover, filter by S/E/Sc) | Interactive features listed |
| A9 | | | | C22: Passes EOP validation 23/23 | `skill-validator.sh learn-visualize/` = 23/23 |
| A10 | Legacy Cleanup | (removal of old directories) | Remove learn-pipeline, rename spec-extract→learn-spec | C23: 0 references to legacy skill names in new skills | Grep for `learn-pipeline`, `spec-extract` in new skill dirs = 0 hits |
| A10 | | | | C24: Old skill directories removed or replaced | `ls` shows only new directory names |

**Alignment check:**
- Conditions with no artifact: 0
- Artifacts with no condition: 0
- Total conditions: 24 (C1-C24)
- Total artifacts: 10 (A1-A10)
- Orphans: 0

---

## Section 4: Domain Context

### Prior Zone Output

**VANA-SPEC** (approved 2026-03-29): 32 binary ACs covering Verbs (10), Adverbs (11), Nouns (10), Adjectives (7). Full spec at `1-ALIGN/learning/specs/VANA-SPEC-learn-skill-refactor.md`.

**Legacy skills analyzed:** 7 skills (learn-input, learn-pipeline, learn-research, learn-review, learn-structure, spec-extract) + README. Each has SKILL.md + supporting files. Key patterns to preserve:
- learn-input: 9-question interview format, one-at-a-time gate
- learn-research: 6-section research output format, parallel dispatch
- learn-structure: CAG-prefixed cells, 17 columns, P0-P5 page set, validation checkpoint
- learn-review: Causal spine table, frontmatter approval status
- spec-extract: VANA extraction from P-pages, T0 prerequisite gate

### Team Context

- Director (Long) is visual learner — skills should produce ASCII diagrams for state/flow visualization
- L1 agent progression — skills designed for single-agent invocation with sub-agent dispatch (not multi-orchestrator)
- Notation settled: EO (not UDO), EP (not EPS), aligned across all new artifacts

### Reference Materials

Key files for Build agents to load:
- VANA-SPEC: `1-ALIGN/learning/specs/VANA-SPEC-learn-skill-refactor.md` (§2-§5 for ACs)
- EOP-GOV: `_shared/reference/EOP-GOV.md` (skill structure requirements)
- Deep-research SKILL.md: `skills/deep-research/SKILL.md` (source for methodology extraction — project root, accessible from main repo)
- Deep-research methodology: `skills/deep-research/reference/methodology.md` (methodology source for A1 extraction)
- Note: Deep-research is in main repo root (`skills/`), not in the worktree. Build agent must read from main repo path.
- Legacy skills: `1-ALIGN/learning/skills/*/SKILL.md` (patterns to preserve/improve)
- Advanced EL source: `../OPS_OE.6.1.LTC-OSD-KNOWLEDGE-LIBRARY/OPS_OE.6.1.BOOK-00-MASTER-OE-SYSTEM/docs/ai/reference/ltc-advanced-effective-learning-system.md` (external repo — import and align glossary)
- Skill validator: `./scripts/skill-validator.sh` (23-check validation)

---

## Section 5: Agent System Constraints

### The 8 LLM Truths

| # | Truth | Summary |
|---|-------|---------|
| LT-1 | Hallucination is structural | P(hallucination) > 0 for any model. Plausible is not true. |
| LT-2 | Context compression is lossy | Effective window << nominal. Middle content gets lost. |
| LT-3 | Reasoning degrades on complex tasks | 3-step works; 12-step breaks. 0.9^7 = 48%. |
| LT-4 | Retrieval is fragile under noise | Model grabs "close enough" instead of exact fact. |
| LT-5 | Prediction optimizes plausibility | Trained for "sounds right," not "is right." |
| LT-6 | No persistent memory | Every session starts blank. |
| LT-7 | Cost scales with tokens | More words = more money, worse LT-2. |
| LT-8 | Alignment is approximate | Can drift, game criteria, find loopholes. |

### 7-CS and Two Operators

`EO = f(EP, Input, EOP, EOE, EOT, Agent, EA)` — Human Director = Accountable (not a component).
**Human** fails via System 1 (anchoring, confirmation bias). **Agent** fails via 8 LTs (hallucination, context loss). Each compensates for the other's blind spots.

---

## Section 6: Agent Instructions

### Your Role

You are the sole agent producing the learning subsystem artifacts. Output will be validated against the rubric by the Human Director and `skill-validator.sh`. This is execution-heavy work — deterministic, sequential, one task at a time.

### Your Deliverables

1. **A1: Research Methodology** — Extract multi-angle search, source verification, and anti-hallucination protocols from deep-research into `_shared/templates/RESEARCH_METHODOLOGY.md`. Strip deep-research-specific references. This is a PREREQUISITE — complete before any skill files.
2. **A2: Advanced EL Reference** — **PRE-COMPLETED.** Imported from BOOK-00 repo, glossary aligned (24 replacements: UDO→EO, EPS→EP, UES→EOE/EOT). 1005/1005 lines, 9/9 sections, 0 legacy terms. Director to verify during Build — skip if confirmed.
3. **A3: Orchestrator (`/learn`)** — State-aware router that derives pipeline state from file system scan. Routes to correct sub-skill. Contains routing table for 5 states + flow diagram. 5 states: (1) no input→input, (2) input+no research→research, (3) research+unstructured→structure+review loop, (4) all approved+no spec→spec, (5) complete→done message.
4. **A4: Input Skill (`/learn:input`)** — Refactored 9-question interview. Add EO validation gate with [User][desired state][constraint] structure check. Add escape hatch (3 example EOs if user can't articulate).
5. **A5: Research Skill (`/learn:research`)** — Refactored parallel dispatch. Reference (not embed) shared methodology. Add source count gate (≥8) + URL spot-check. Add escape hatches for EXA/WebSearch/QMD failure.
6. **A6: Structure Skill (`/learn:structure`)** — Refactored per-topic P0-P5 generation. Explicit per-topic scope (load 1 topic's research only). Opus model fork. Mermaid companion blocks.
7. **A7: Review Skill (`/learn:review`)** — Refactored per-topic review. Add active learning (1 comprehension Q per page). Answer required before approval. Causal spine table presentation.
8. **A8: Spec Skill (`/learn:spec`)** — Refactored from spec-extract. Add DSBV Readiness Package generation (C1-C6 checklist). Add P-page→zone mapping table (P0→system context, P1→UBS, P2→UDS, P3→EP candidates, P4→component map, P5→sequence hints).
9. **A9: Visualize Skill (`/learn:visualize`)** — NEW. React+Vite interactive system map. LTC brand (Midnight Green, Gold, Inter). Nodes from P-page entries, edges from causal references. Click-to-drill, filter by S/E/Sc. Invocable after structure exists.
10. **A10: Legacy Cleanup** — Remove `learn-pipeline/` directory. Remove `spec-extract/` directory (replaced by `learn-spec/`). Grep all new skills for `learn-pipeline` and `spec-extract` references. Remove orphans.

### Build Order (high-level — details in SEQUENCE.md)

```
A1 (methodology) ──► A5 (research, references A1)
A2 (Advanced EL)  ──► A6 (structure, uses EL framework)
A4 (input)        ──► independent
A7 (review)       ──► independent
A8 (spec)         ──► independent
                      A3 (orchestrator) ──► AFTER A4-A8 (references all sub-skill names)
A9 (visualize)    ──► I2 (deferred)
A10 (cleanup)     ──► LAST (after all new skills confirmed working)
```

### What to Optimize For

- **Primary:** Binary AC compliance — every skill passes 23/23 EOP validation AND satisfies its VANA-SPEC ACs
- **Secondary:** Preserve proven patterns from legacy skills while adding the new design elements (gates, escape hatches, active learning)
- **Tertiary:** Conciseness — SKILL.md ≤200 lines, references/ for supporting detail

### Constraints

- Do NOT modify deep-research SKILL.md (only read from it for methodology extraction)
- Do NOT change P-page template format or validation script logic
- Do NOT create a stored state file for the orchestrator — state MUST be derived
- Do NOT auto-approve any human gate in the pipeline design
- Sustainability > Efficiency > Scalability in all prioritization
- `learn:research` must reference (not embed) `_shared/templates/RESEARCH_METHODOLOGY.md`; other skills do not load it
- Every skill directory must pass `./scripts/skill-validator.sh` before commit
- If `skill-validator.sh` flags a structural deviation that is intentional (e.g., orchestrator routing table vs standard skill layout), document the deviation in `gotchas.md` and note the specific check that was overridden

---

**Classification:** INTERNAL
