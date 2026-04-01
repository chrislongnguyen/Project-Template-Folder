---
version: "1.0"
status: Draft
last_updated: 2026-03-31
---

# VALIDATE v3.0 — 7CS Corrections

## Summary

- Total criteria: 8 (V1–V8), 26 sub-checks
- PASS: 25
- WARN: 1

## Results

| ID | Sub | Description | Verdict | Evidence (line) |
|----|-----|-------------|---------|-----------------|
| V1 | V1.1 | Building view DSBV room headers use dot notation `WORKSTREAM.PHASE (Z-P)` | PASS | L763: `WORKSTREAM_FULL[r]+'.'+PHASE_FULL[c]+' ('+cellId+')'` produces e.g. "ALIGN.DESIGN (A-D)" |
| V1 | V1.2 | Matrix view cell headers use dot notation | PASS | L843: same pattern as building view |
| V1 | V1.3 | Matrix detail view uses dot notation | PASS | L859: `WORKSTREAM_FULL[cellId[0]]+'.'+PHASE_FULL[cellId[2]]+' ('+cellId+')'` |
| V1 | V1.4 | Verified 3+ cells: ALIGN.DESIGN (A-D), PLAN.BUILD (P-B), EXECUTE.VALIDATE (E-V) | PASS | L432-433: `WORKSTREAM_FULL` and `PHASE_FULL` constants correctly defined |
| V2 | V2.1 | `getCell7CS()` EP row renders ONLY the 8 `.claude/rules/` entries | PASS | L612: `let ep_rules=RULES.map(r=>r.name);` — RULES array has exactly 8 entries |
| V2 | V2.2 | `getWorkstream7CS()` EP row renders ONLY rules, NOT frameworks | PASS | L580: `let ep_rules=RULES.map(r=>r.name);` — no FRAMEWORKS reference |
| V2 | V2.3 | THREE_PILLARS, EFFECTIVE_SYSTEM, AGENT_SYSTEM, COGNITIVE_BIASES not in EP row JS rendering | PASS | EP rendering at L669, L776, L861 all use `ep_rules` (sourced from RULES only) |
| V2 | V2.4 | FRAMEWORKS data array still exists for Resources view | PASS | L382-399: 17 FRAMEWORKS entries intact |
| V2 | V2.W | Static right EP rail still shows frameworks (THREE_PILLARS, AGENT_SYSTEM, etc.) under "EFFECTIVE PRINCIPLES" label | **WARN** | L272-284: Right `.ep-rail` div contains framework names. Not in JS EP rows, but visually labeled as EP. This is an architectural design choice (principles encompass both rules and frameworks), but may confuse users expecting EP = rules only. Left rail = 8 rules, right rail = 10 frameworks. |
| V3 | V3.1 | CELL_7CS has entries for 16 cells (all except L-* which uses pipeline) | PASS | 16 entries: A-D, A-S, A-B, A-V, P-D, P-S, P-B, P-V, E-D, E-S, E-B, E-V, I-D, I-S, I-B, I-V |
| V3 | V3.2 | A-D Input references specific files, not "Director mandate" | PASS | L437: `'Stakeholder brief + project scope · GOVERN workstream ≥1 validated artifact · LEARN outputs if available: 2-LEARN/output/{SUB}-EFFECTIVE-PRINCIPLES.md'` |
| V3 | V3.3 | P-B Input references specific upstream files (ARCHITECTURE, UBS_REGISTER) | PASS | L479: `'PLAN.SEQUENCE.EO: ROADMAP.md (approved) · PLAN.DESIGN.EO: UBS_REGISTER.md · LEARN: EFFECTIVE-PRINCIPLES.md · ALIGN: CHARTER.md'` |
| V3 | V3.4 | E-V Input references EXECUTE artifacts + DESIGN.md ACs | PASS | L514: `'EXECUTE.BUILD.EO: artifacts per SEQUENCE.md · EXECUTE.DESIGN.EO: DESIGN.md · PLAN: UBS_REGISTER.md'` |
| V3 | V3.5 | I-V Input references FEEDBACK_REGISTER + METRICS_BASELINE | PASS | L542: `'IMPROVE.BUILD.EO: FEEDBACK_REGISTER.md · METRICS_BASELINE.md · RETRO-PLAN.md · OKR_REGISTER.md'` |
| V3 | V3.6 | EO fields name specific file paths, not "Workstream artifacts" | PASS | All 16 CELL_7CS EO fields contain specific paths (e.g. `'1-ALIGN/DESIGN.md'`, `'3-PLAN/architecture/ARCHITECTURE.md'`, `'5-IMPROVE/reviews/VERSION-REVIEW.md'`) |
| V4 | V4.1 | Templates render in EOT row (not EOP row) in `getCell7CS()` | PASS | L626: `eot_tmpl=(data.eot_templates||[])` feeds into `eot` array; L793: EOT row renders `cs.eot` |
| V4 | V4.2 | Skills appear in EOP row | PASS | L618-620: `eop_named` + `eop_extra` = skills; L783: EOP row renders `cs.eop_skills` |
| V4 | V4.3 | CELL_7CS uses `eot_templates` (not `eop_templates`) | PASS | All 16 entries use `eot_templates`; zero occurrences of `eop_templates` |
| V5 | V5.1 | LEARN workstream does NOT have 4 DSBV rooms | PASS | L695: `if(r==='L')` branch renders pipeline instead of DSBV rooms |
| V5 | V5.2 | LEARN has 5-stage pipeline: S1 through S5 | PASS | L698-736: `learnStages` array has S1, S2, S3, S4, S5 |
| V5 | V5.3 | CSS class `.learn-pipeline` exists | PASS | L179: `.learn-pipeline{display:flex;flex-direction:column;gap:4px}` |
| V5 | V5.4 | S1 (/learn:input) and S5 (/learn:spec) present | PASS | L699: S1 label `'S1: /learn:input'`; L729: S5 label `'S5: /learn:spec'` |
| V6 | V6.1 | `.workstream-7cs-body` has `display:block` (always open) | PASS | L82: `.workstream-7cs-body{display:block;padding:0}` |
| V6 | V6.2 | No `onclick="toggle7CS"` on workstream 7CS headers | PASS | L665: workstream-7cs-hdr has no onclick attribute; grep confirms zero matches |
| V6 | V6.3 | No toggle arrow in workstream 7CS headers | PASS | L665: header uses star character only, no `▶` |
| V7 | V7.1 | SKILLS=27 | PASS | Counted 27 `{id:` in SKILLS array |
| V7 | V7.2 | TEMPLATES=27 | PASS | Counted 27 `{id:` in TEMPLATES array |
| V7 | V7.3 | FRAMEWORKS=17 | PASS | Counted 17 `{id:` in FRAMEWORKS array |
| V7 | V7.4 | RULES=8 | PASS | Counted 8 `{id:` in RULES array |
| V7 | V7.5 | "Manh" = 0 occurrences | PASS | grep: 0 matches |
| V7 | V7.6 | "Claude Opus/Sonnet" = 0 occurrences | PASS | grep `Claude (Opus|Sonnet)`: 0 matches |
| V7 | V7.7 | AGENTS constant maps D/S/B/V to specific agents | PASS | L424-429: D→ltc-planner, S→ltc-planner, B→ltc-builder, V→ltc-reviewer |
| V7 | V7.8 | Brand CSS variables present | PASS | L11: `--midnight`, `--gold`, `--gunmetal`, `--ruby`, `--green`, `--purple` all defined |
| V7 | V7.9 | Google Fonts Inter link present | PASS | L9: `fonts.googleapis.com/css2?family=Inter` |
| V8 | V8.1 | All 3 views render (building, matrix, resources divs) | PASS | L252: `view-building`, L295: `view-matrix`, L309: `view-resources` |
| V8 | V8.2 | Brief panel exists | PASS | L231: `id="brief-panel"` |
| V8 | V8.3 | Sidebar exists | PASS | L217: `id="sidebar"` |
| V8 | V8.4 | No JS syntax issues (balanced brackets) | PASS | `{`=245/`}`=245, `[`=247/`]`=247, `(`=486/`)`=486; 0 trailing commas |
| V8 | V8.5 | Meta version = 3.0 | PASS | L5: `<meta name="version" content="3.0">` |

## WARN Detail

### V2.W — Right EP Rail Shows Frameworks

The static HTML building view has two EP rails:
- **Left rail** (L256-266): 8 `.claude/rules/` entries — correct
- **Right rail** (L272-284): 10 `_genesis/frameworks/` entries — labeled "EFFECTIVE PRINCIPLES"

The JS-rendered 7CS EP rows inside cells and workstreams correctly show ONLY the 8 rules. The right rail is a *visual design element* (constitutional border), not a 7CS EP row. However, the shared "EFFECTIVE PRINCIPLES" label on both rails may create ambiguity about what EP contains.

**Impact:** Low. The right rail is architecturally intentional (EP encompasses both enforcement rules and guiding frameworks). No functional bug. Flag for user decision: keep as dual-rail design, or relabel right rail to "FRAMEWORKS" to distinguish from EP rows.

## Verdict

**PASS** — All 6 user corrections are implemented correctly. All prior ACs hold. One WARN flagged for user attention (cosmetic/labeling, not functional).
