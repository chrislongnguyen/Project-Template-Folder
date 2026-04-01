---
version: "1.0"
status: Draft
last_updated: 2026-03-31
zone: Company-Navigator
dsbv_phase: Sequence
---

# SEQUENCE.md — Company Navigator HTML Refit

> Ordered task list for refitting `LTC-COMPANY-NAVIGATOR.html` to match `APEI-Project-Repo` branch state.
> Estimated total: 18 tasks across 5 phases, ~2.5 hours equivalent.

## Dependency Graph (ASCII)

```
Phase A: VERIFICATION
  A1 ──→ A2 ──→ A3
                  │
Phase B: DATA ARRAYS  ←──────┘
  B1 (skills) ──┐
  B2 (templates)├──→ B5 (cross-cutting) ──→ B6 (zone/dsbv I/O)
  B3 (frameworks)│
  B4 (rules) ───┘
                                              │
Phase C: AGENT MODEL  ←──────────────────────┘
  C1 (agent roster) ──→ C2 (cell-level agent) ──→ C3 (zone-level agent)
                                                    │
Phase D: GENERICIZATION  ←────────────────────────┘
  D1 (director name) ──┐
  D2 (file paths)  ────┤──→ D3 (brief generator)
                        │
Phase E: VALIDATION  ←──┘
  E1 (visual smoke) ──→ E2 (37 ACs) ──→ E3 (new ACs)
```

---

## Phase A: Verification

Confirm the delta between Navigator claims and branch reality. Zero code changes — only produces a verified manifest.

### A1 — Audit Skills Inventory

| Field | Value |
|-------|-------|
| **Description** | Compare Navigator's 29-entry SKILLS array against the 27 SKILL.md files on branch. Produce a +/- diff list. |
| **Input** | Navigator SKILLS array (lines 319-349), branch `find .claude/skills -name SKILL.md` |
| **Output** | Verified diff: 3 phantoms to remove (`align-specialist`, `team-architect`, `team-reviewer`), 1 missing to add (`git-save`). Net target = 27 entries. |
| **AC** | Diff list exists with exact IDs of additions and removals. Every branch SKILL.md has a corresponding Navigator entry or is flagged as "add". Every Navigator entry without a branch SKILL.md is flagged as "remove". |
| **Effort** | S |
| **Blocks** | B1 |

### A2 — Audit Templates, Frameworks, Rules

| Field | Value |
|-------|-------|
| **Description** | Compare Navigator arrays against branch `_genesis/templates/`, `_genesis/frameworks/`, `.claude/rules/`. Produce +/- diff per category. |
| **Input** | Navigator arrays (lines 350-388), branch directory listings |
| **Output** | **Templates:** +10 new (CHARTER, ARCHITECTURE, FORCE_ANALYSIS, DRIVER_ENTRY, ROADMAP, METRICS_BASELINE, OKR, TEST_PLAN, GLOBAL_CLAUDE_MD_EXAMPLE, README). Target = 27. **Frameworks:** +7 new (ALPEI_DSBV_PROCESS_MAP, P1-P4 part views, UES_VERSION_BEHAVIORS, README). Target = 17. **Rules:** Navigator has 6 entries using pre-refactor names. Branch has 8 actual rule files: dsbv, alpei-chain-of-custody, alpei-pre-flight, agent-dispatch, git-conventions, versioning, memory-format, example-api-conventions. Complete replacement needed. |
| **AC** | Diff list exists for all 3 categories with exact IDs. Every branch file has a corresponding entry or is flagged "add". Every Navigator entry without a branch file is flagged "remove" or "rename". |
| **Effort** | S |
| **Blocks** | B2, B3, B4 |
| **Depends on** | A1 (sequential discipline — verify skills first since templates share cell mappings) |

### A3 — Audit Agent Model + Cross-Cutting

| Field | Value |
|-------|-------|
| **Description** | Verify the 4-agent MECE roster (ltc-planner, ltc-builder, ltc-reviewer, ltc-explorer) from `.claude/agents/` and confirm cell-to-agent mapping logic. Audit CROSS_CUTTING array for completeness. |
| **Input** | Branch `.claude/agents/*.md` (4 files), Navigator CROSS_CUTTING array (lines 389-397), agent-dispatch rule |
| **Output** | Agent-to-DSBV-phase mapping table: planner→D+S, builder→B, reviewer→V, explorer→pre-DSBV. Cross-cutting audit: Director name needs genericization, rest is accurate. |
| **AC** | 4-agent mapping table exists with model tier (Opus/Sonnet/Haiku) per agent. Each of 20 cells has exactly 1 assigned agent. Cross-cutting diff list produced. |
| **Effort** | S |
| **Blocks** | C1, D1 |
| **Depends on** | A2 |

---

## Phase B: Data Array Updates

Mechanical JS array edits. Low risk — the architecture handles rendering automatically from data.

### B1 — Update SKILLS Array

| Field | Value |
|-------|-------|
| **Description** | Remove 3 phantom skills (`align-specialist`, `team-architect`, `team-reviewer`). Add 1 missing skill (`git-save`). Verify descriptions and cell mappings for remaining 26 entries against their SKILL.md files. |
| **Input** | A1 verified diff, branch SKILL.md files |
| **Output** | Updated SKILLS array with 27 entries. Each entry has: id, name, desc, role, cells, cat, connects. |
| **AC** | `SKILLS.length === 27`. No entry has an id that lacks a corresponding SKILL.md on branch. `git-save` entry exists with correct cells. `align-specialist`, `team-architect`, `team-reviewer` entries are absent. |
| **Effort** | M |
| **Blocks** | B5 |
| **Depends on** | A1 |
| **Risk** | LOW — mechanical replacement, no structural change |

### B2 — Update TEMPLATES Array

| Field | Value |
|-------|-------|
| **Description** | Add 10 new template entries. Assign cell mappings based on which DSBV phase each template serves. |
| **Input** | A2 verified diff, branch `_genesis/templates/*.md` files |
| **Output** | Updated TEMPLATES array with 27 entries. New entries need: id, name, desc, cells, role (all EOP). |
| **AC** | `TEMPLATES.length === 27`. Every `_genesis/templates/*.md` file (excluding DSBV_PROCESS.md which is process doc not template) has a corresponding entry. Cell mappings are logically correct (e.g., CHARTER_TEMPLATE → A-B, ARCHITECTURE_TEMPLATE → P-B, TEST_PLAN_TEMPLATE → E-B). |
| **Effort** | M |
| **Blocks** | B5 |
| **Depends on** | A2 |
| **Risk** | LOW — but cell mapping requires judgment. Use template content to determine correct zone×phase. |

### B3 — Update FRAMEWORKS Array

| Field | Value |
|-------|-------|
| **Description** | Add 7 new framework entries. The ALPEI_DSBV_PROCESS_MAP is the master process map — it goes in ALL cells. P1-P4 part views map to their specific zones. |
| **Input** | A2 verified diff, branch `_genesis/frameworks/*.md` files |
| **Output** | Updated FRAMEWORKS array with 17 entries. Each entry has: id, name, desc, cells, role (all EP), insight. |
| **AC** | `FRAMEWORKS.length === 17`. Every `_genesis/frameworks/*.md` (excluding README) has a corresponding entry. ALPEI_DSBV_PROCESS_MAP has `cells:["ALL"]`. Each P1-P4 view maps to the zones it covers. |
| **Effort** | M |
| **Blocks** | B5 |
| **Depends on** | A2 |
| **Risk** | MEDIUM — insight field for new frameworks requires reading each file to extract the key teaching point. |

### B4 — Replace RULES Array

| Field | Value |
|-------|-------|
| **Description** | Complete replacement of RULES array. Navigator has 6 entries using old names (brand-identity, naming-rules, security-rules, agent-system, agent-diagnostic, general-system). Branch has 8 actual rule files. Some are renamed, some are new, some old names are now frameworks not rules. |
| **Input** | A2 verified diff, branch `.claude/rules/*.md` files |
| **Output** | Updated RULES array with 8 entries matching branch exactly: dsbv, alpei-chain-of-custody, alpei-pre-flight, agent-dispatch, git-conventions, versioning, memory-format, example-api-conventions. All with `cells:["ALL"]`, `role:"EP"`. |
| **AC** | `RULES.length === 8`. Every `.claude/rules/*.md` file has a corresponding entry. No entry references a file that doesn't exist. Old names (brand-identity, naming-rules, security-rules, agent-system, agent-diagnostic, general-system) are absent unless they still exist as rule files on branch. |
| **Effort** | M |
| **Blocks** | B5 |
| **Depends on** | A2 |
| **Risk** | MEDIUM — the old-to-new mapping must be verified carefully. Some old "rules" may have migrated to `_genesis/frameworks/` or been absorbed into CLAUDE.md sections. Must not lose pedagogical coverage. |

> **NOTE on B4:** The old Navigator "rules" (brand-identity, naming-rules, security-rules, agent-system, agent-diagnostic, general-system) reference files in a `rules/` directory. On branch, the actual `.claude/rules/` contains a different set. The old names may correspond to content that still exists under `_genesis/` (e.g., `AGENT_SYSTEM.md`, `AGENT_DIAGNOSTIC.md` are frameworks, not rules). The builder must trace each old entry to its current location.

### B5 — Update CROSS_CUTTING Array

| Field | Value |
|-------|-------|
| **Description** | Add Notion MCP as a new EOT entry (it's a real tool on branch alongside ClickUp). Verify all existing entries are still accurate. Add Playwright MCP if present. Review `exa` (web search) presence. |
| **Input** | A3 audit, branch `.claude/settings.json` or MCP config |
| **Output** | Updated CROSS_CUTTING array. Director entry preserved (genericized in Phase D). |
| **AC** | Every cross-cutting resource that exists in the branch environment has an entry. No phantom entries. `role` and `type` fields are correct for each. |
| **Effort** | S |
| **Blocks** | B6 |
| **Depends on** | B1, B2, B3, B4 (needs final resource counts for environment audit) |
| **Risk** | LOW |

### B6 — Review ZONE_IO and DSBV_IO Objects

| Field | Value |
|-------|-------|
| **Description** | Verify zone input/output descriptions match current ALPEI flow. Check if new templates/frameworks change what flows between zones. |
| **Input** | Updated arrays from B1-B5, `_genesis/frameworks/ALPEI_DSBV_PROCESS_MAP.md` |
| **Output** | Updated ZONE_IO and DSBV_IO objects if needed. |
| **AC** | ZONE_IO descriptions are consistent with ALPEI_DSBV_PROCESS_MAP P4 (data flow). DSBV_IO descriptions match DSBV_PROCESS.md. |
| **Effort** | S |
| **Blocks** | C1 |
| **Depends on** | B5 |
| **Risk** | LOW — likely no changes needed, but must verify |

---

## Phase C: Agent Model Integration

The highest-value teaching change. Every cell currently shows "Claude Opus/Sonnet" — must show the specific MECE agent.

### C1 — Add Agent Roster Data Structure

| Field | Value |
|-------|-------|
| **Description** | Add a new `AGENTS` JS constant mapping the 4 MECE agents to their DSBV phases and model tiers. This is the data source for cell-level agent rendering. |
| **Input** | A3 agent mapping table, `.claude/agents/*.md` files |
| **Output** | New JS constant: `const AGENTS={D:"ltc-planner (Opus)",S:"ltc-planner (Opus)",B:"ltc-builder (Sonnet)",V:"ltc-reviewer (Opus)"}` plus a teaching note about ltc-explorer (Haiku) for pre-DSBV research. |
| **AC** | `AGENTS` object exists in the JS data section. 4 entries map to D, S, B, V phases. Model tier (Opus/Sonnet/Haiku) is included in each value string. |
| **Effort** | S |
| **Blocks** | C2 |
| **Depends on** | A3, B6 |
| **Risk** | LOW — data addition only |

### C2 — Update getCell7CS Agent Row

| Field | Value |
|-------|-------|
| **Description** | Replace the hardcoded `agent='Claude Opus/Sonnet'` in `getCell7CS()` with a lookup from the new AGENTS constant. The agent shown must vary by DSBV column (D/S/B/V). |
| **Input** | C1 AGENTS constant |
| **Output** | Updated `getCell7CS()` function where `agent = AGENTS[c]` (c = D/S/B/V column). |
| **AC** | Opening any cell in Matrix view shows the correct agent name: Design→ltc-planner, Sequence→ltc-planner, Build→ltc-builder, Validate→ltc-reviewer. No cell shows "Claude Opus/Sonnet". |
| **Effort** | S |
| **Blocks** | C3 |
| **Depends on** | C1 |
| **Risk** | LOW — single line change per function |

### C3 — Update getZone7CS Agent Row

| Field | Value |
|-------|-------|
| **Description** | Replace the hardcoded `agent='Claude Opus/Sonnet'` in `getZone7CS()` with a summary showing all agents that operate in that zone: "ltc-planner (D,S) · ltc-builder (B) · ltc-reviewer (V)". |
| **Input** | C1 AGENTS constant |
| **Output** | Updated `getZone7CS()` function with agent summary string. |
| **AC** | Expanding any zone's 7CS summary in Building view shows the full agent roster with phase assignments, not "Claude Opus/Sonnet". |
| **Effort** | S |
| **Blocks** | D1 |
| **Depends on** | C2 |
| **Risk** | LOW |

---

## Phase D: Genericization

Remove project-specific references so the Navigator works as a template artifact.

### D1 — Genericize Director Name

| Field | Value |
|-------|-------|
| **Description** | Replace all instances of "Manh N." with "Human Director" (or "{Director}") in both JS data and the brief generator function. |
| **Input** | `grep -n "Manh" LTC-COMPANY-NAVIGATOR.html` — 2 occurrences: CROSS_CUTTING line 390, brief generator line 829 |
| **Output** | Updated HTML with generic director references. |
| **AC** | `grep -c "Manh" LTC-COMPANY-NAVIGATOR.html` returns 0. Director entry in CROSS_CUTTING shows "Human Director". Brief generator shows "Human Director". |
| **Effort** | S |
| **Blocks** | D3 |
| **Depends on** | C3 |
| **Risk** | LOW |

### D2 — Audit File Paths

| Field | Value |
|-------|-------|
| **Description** | Scan `coordToPath()` function for any hardcoded absolute paths or desktop references. Ensure all paths are relative to repo root. |
| **Input** | `coordToPath()` function (lines 733-759) |
| **Output** | Updated paths if any absolute refs found. |
| **AC** | No path in the HTML contains `/Users/`, `~/Desktop`, or any absolute filesystem path. All file references are relative to repo root. |
| **Effort** | S |
| **Blocks** | D3 |
| **Depends on** | C3 (sequenced after agent work to avoid merge conflicts in JS section) |
| **Risk** | LOW — quick scan shows paths already look relative, but must verify |

### D3 — Update HTML Metadata

| Field | Value |
|-------|-------|
| **Description** | Update `<meta name="version">` to reflect the refit version. Update `<meta name="last-updated">`. Ensure title and subtitle are generic. |
| **Input** | Current meta tags (lines 5-6) |
| **Output** | Version bumped to 1.2 (or appropriate), date updated. |
| **AC** | `<meta name="version">` reflects new version. `<meta name="last-updated">` is today's date. Title contains no project-specific names. |
| **Effort** | S |
| **Blocks** | E1 |
| **Depends on** | D1, D2 |
| **Risk** | LOW |

---

## Phase E: Validation

### E1 — Visual Smoke Test

| Field | Value |
|-------|-------|
| **Description** | Open the refitted HTML in a browser. Verify all 3 views render without JS errors. Check that new resources appear in correct cells. |
| **Input** | Refitted HTML file |
| **Output** | Screenshot or manual confirmation of: Building view (all 5 zones expand), Matrix view (20 cells populated), Resources view (dropdown shows all resources, heatmap lights up). |
| **AC** | Browser console shows 0 JS errors. All 3 views render. At least 1 new template, 1 new framework, and 1 new rule appear in the correct cell when selected in Resources view. |
| **Effort** | S |
| **Blocks** | E2 |
| **Depends on** | D3 |
| **Risk** | MEDIUM — first time seeing all changes together. Typos in JS arrays cause silent failures. |

### E2 — Verify Manh's 37 ACs

| Field | Value |
|-------|-------|
| **Description** | Systematically test all 37 original ACs grouped by category: Verb (7), Noun (13), SustainAdj (5), SustainAdv (3), plus any additional ACs from the original spec. |
| **Input** | Original AC list from Manh's design doc, refitted HTML |
| **Output** | Pass/fail table for all 37 ACs. |
| **AC** | All 37 ACs pass. Any failure is documented with the specific AC ID and failure description. |
| **Effort** | M |
| **Blocks** | E3 |
| **Depends on** | E1 |
| **Risk** | MEDIUM — data array changes could break cell counts, connects references, or filter logic. |

### E3 — Verify New Refit ACs

| Field | Value |
|-------|-------|
| **Description** | Test refit-specific acceptance criteria that go beyond the original 37. |
| **Input** | Refitted HTML, this SEQUENCE.md |
| **Output** | Pass/fail table for 8 new ACs (below). |
| **AC** | All 8 new ACs pass: |
| | **R-AC1:** `SKILLS.length === 27` (no phantoms, no missing) |
| | **R-AC2:** `TEMPLATES.length === 27` (all branch templates represented) |
| | **R-AC3:** `FRAMEWORKS.length === 17` (all branch frameworks represented, excl README) |
| | **R-AC4:** `RULES.length === 8` (exact match to `.claude/rules/*.md`) |
| | **R-AC5:** No cell shows "Claude Opus/Sonnet" — all show specific agent name |
| | **R-AC6:** `grep -c "Manh" file` returns 0 |
| | **R-AC7:** Brief generator produces valid markdown with "Human Director" |
| | **R-AC8:** Resources view dropdown shows all 79 resources (27+27+17+8 = 79, plus cross-cutting) |
| **Effort** | S |
| **Depends on** | E2 |
| **Risk** | LOW — binary checks |

---

## Summary

| Phase | Tasks | Effort | Risk | Description |
|-------|-------|--------|------|-------------|
| A: Verification | 3 | 3S | LOW | Audit inventory, produce verified diffs |
| B: Data Arrays | 6 | 4M + 2S | MED | Update JS arrays (skills, templates, frameworks, rules, cross-cutting, I/O) |
| C: Agent Model | 3 | 3S | LOW | Add AGENTS constant, update 2 functions |
| D: Genericization | 3 | 3S | LOW | Director name, paths, metadata |
| E: Validation | 3 | 1M + 2S | MED | Smoke test, 37 original ACs, 8 new ACs |
| **Total** | **18** | **5M + 13S** | | **~2.5 hours** |

## Risk Register (Refit-Specific)

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|-----------|--------|------------|
| RR-1 | Old rule names have no branch equivalent (content lost) | Medium | High | A2 traces each old name to its current location (rule, framework, or CLAUDE.md section). Builder verifies no pedagogical gap. |
| RR-2 | Cell mappings for new templates are wrong | Medium | Low | B2 requires reading template content to determine zone×phase. Validator checks in E1. |
| RR-3 | JS syntax error in updated arrays breaks all views | Low | High | E1 smoke test catches this immediately. Builder uses browser dev tools during B-phase edits. |
| RR-4 | Agent model change breaks brief generator's getCurrentState() | Low | Medium | C2 only touches the agent field. Brief generator reads from getCell7CS which is the same function. Verified in E2. |
| RR-5 | connects references to removed skills cause dangling pointers | Medium | Low | B1 must also clean `connects` arrays in remaining skills that referenced phantoms (team-architect, team-reviewer, align-specialist). |

## Builder Instructions

The builder (ltc-builder, Sonnet) should:
1. Work through phases A→B→C→D→E in order
2. Keep a browser tab open with the HTML during Phase B — reload after each array update to catch syntax errors early
3. For B4 (rules replacement), read each branch `.claude/rules/*.md` first line to get the description — do not guess
4. For B3 (frameworks), read each new framework file's first section to extract the `insight` teaching point
5. Commit after each phase completes (5 atomic commits), not one giant commit at the end
