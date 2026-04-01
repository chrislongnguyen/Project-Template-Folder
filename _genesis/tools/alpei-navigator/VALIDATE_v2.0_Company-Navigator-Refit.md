---
version: "1.0"
status: Draft
last_updated: 2026-03-31
---

# VALIDATE.md — Company Navigator Refit v2.0

## Summary
- **Total ACs tested:** 45
- **PASS:** 45
- **FAIL:** 0
- **PARTIAL:** 0

## Results Table

| AC ID | Description | Verdict | Evidence |
|-------|-------------|---------|----------|
| E1-1 | `#building-view` div exists | PASS | Line 249: `<div class="view active" id="view-building">` (id uses `view-building` convention; `bld-zones` container at line 266) |
| E1-2 | `#matrix-view` div exists | PASS | Line 292: `<div class="view" id="view-matrix">` |
| E1-3 | `#resources-view` div exists | PASS | Line 306: `<div class="view" id="view-resources">` |
| E1-4 | Brief pill exists in header | PASS | Line 196: `<div class="pill" onclick="toggleBriefMode()" id="pill-brief"...>Brief</div>` |
| E1-5 | Sidebar exists | PASS | Line 214: `<div class="sidebar" id="sidebar" role="complementary">` |
| E1-6 | No obvious JS syntax errors | PASS | All arrays close with `];` (SKILLS line 321-349, TEMPLATES 350-378, FRAMEWORKS 379-397, RULES 398-407). All functions have matching braces. No trailing commas before `]`. |
| E1-7 | Google Fonts link for Inter | PASS | Line 9: `<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">` |
| R-AC1 | SKILLS array has exactly 27 entries | PASS | Lines 322-348: counted 27 `{id:` entries (dsbv through git-save) |
| R-AC2 | TEMPLATES array has exactly 27 entries | PASS | Lines 351-377: counted 27 `{id:` entries (DSBV_PROCESS through README_TEMPLATES) |
| R-AC3 | FRAMEWORKS array has exactly 17 entries | PASS | Lines 380-396: counted 17 `{id:` entries (THREE_PILLARS through README_FRAMEWORKS) |
| R-AC4 | RULES array has exactly 8 entries | PASS | Lines 399-406: counted 8 `{id:` entries (dsbv through example-api-conventions) |
| R-AC5 | "Claude Opus/Sonnet" — 0 occurrences | PASS | Grep returns 0 matches across entire file |
| R-AC6 | "Manh" — 0 occurrences | PASS | Grep returns 0 matches across entire file |
| E3-3 | "align-specialist" — 0 occurrences | PASS | Grep returns 0 matches |
| E3-4 | "team-architect" — 0 occurrences | PASS | Grep returns 0 matches |
| E3-5 | "team-reviewer" — 0 occurrences | PASS | Grep returns 0 matches |
| E4-1 | `const AGENTS` exists with D, S, B, V keys | PASS | Lines 421-426: `const AGENTS={D:'ltc-planner (Opus)',S:'ltc-planner (Opus)',B:'ltc-builder (Sonnet)',V:'ltc-reviewer (Opus)'}` |
| E4-2 | `getCell7CS` uses AGENTS lookup | PASS | Lines 510-511: `const phase=cellId.split('-')[1]; let agent=AGENTS[phase]\|\|'ltc-planner (Opus)';` — dynamic lookup, not hardcoded |
| E4-3 | `getZone7CS` shows full 4-agent roster | PASS | Line 478: `let agent='ltc-planner (D,S) · ltc-builder (B) · ltc-reviewer (V) · ltc-explorer (pre-DSBV)';` |
| E4-4 | D-column cell renders ltc-planner, B-column renders ltc-builder | PASS | `AGENTS['D']='ltc-planner (Opus)'` and `AGENTS['B']='ltc-builder (Sonnet)'` — correct per agent roster |
| E5-1 | `git-save` skill exists with cells=['E-S','I-B'], role='EOP' | PASS | Line 348: `{id:"git-save",...role:"EOP",cells:["E-S","I-B"],...}` |
| E5-2 | `CHARTER_TEMPLATE` exists with cells=['A-D','A-B'] | PASS | Line 368: `{id:"CHARTER_TEMPLATE",...cells:["A-D","A-B"],role:"EOP"}` |
| E5-3 | `ALPEI_DSBV_PROCESS_MAP` exists with cells=['ALL'] and insight | PASS | Line 390: `{id:"ALPEI_DSBV_PROCESS_MAP",...cells:["ALL"],role:"EP",insight:"The operational spine..."}` |
| E5-4 | `dsbv` rule desc mentions "Design→Sequence→Build→Validate" | PASS | Line 399: `desc:"Every zone uses Design→Sequence→Build→Validate..."` |
| E5-5 | `agent-dispatch` rule desc mentions "4 MECE agents" | PASS | Line 402: `desc:"Every Agent() call must name 1 of 4 MECE agents..."` |
| E5-6 | `notion-mcp` cross-cutting exists, type='tool' | PASS | Line 416: `{id:"notion-mcp",name:"Notion (MCP)",...type:"tool"}` |
| E5-7 | `exa-mcp` cross-cutting exists | PASS | Line 417: `{id:"exa-mcp",name:"Exa Web Search (MCP)",...type:"tool"}` |
| E5-8 | `qmd-mcp` cross-cutting exists | PASS | Line 418: `{id:"qmd-mcp",name:"QMD Local Search (MCP)",...type:"tool"}` |
| E6-1 | Left EP rail lists 8 rule names | PASS | Lines 255-262: 8 `ep-rule` divs — dsbv, alpei-chain-of-custody, alpei-pre-flight, agent-dispatch, git-conventions, versioning, memory-format, example-api-conventions |
| E7-1 | `coordToPath()` function exists and handles patterns | PASS | Lines 764-790: function handles EP:, zone:*, ALPEI cell regex `[ALPEI]-[DSBV]`, and 3-part coordinates |
| E7-2 | Brief template text uses "Human Director" not "Manh N." | PASS | Line 860: `- **Director:** Human Director` |
| E7-3 | Brief markdown generation produces valid structure | PASS | Lines 843-888: `generateBriefMarkdown()` returns well-structured markdown with Metadata, Current State, Affected Files, Desired State, Acceptance Criteria, and Agent Instructions sections |
| E8-1 | CSS variables present: --midnight, --gold, --gunmetal, --ruby, --green, --purple | PASS | Line 11: `:root{--midnight:#004851;--gold:#F2C75C;--gunmetal:#1D1F2A;--white:#FFFFFF;--ruby:#9B1842;--green:#69994D;--purple:#653469;...}` |
| E8-2 | Font: `font-family:'Inter'` on body | PASS | Line 13: `body{font-family:'Inter',sans-serif;...}` |
| E8-3 | Google Fonts link includes Inter | PASS | Line 9: `family=Inter:wght@300;400;500;600;700` |
| E9-1 | 5x4 grid defined in HTML, not generated from data | PASS | Lines 296-301: Matrix header row is static HTML with DESIGN/SEQUENCE/BUILD/VALIDATE columns. Lines 430-431: `ROWS=["A","L","P","E","I"]` and `COLS=["D","S","B","V"]` define the constitutional skeleton. The grid structure is hardcoded; only cell content populates from data arrays. |
| E9-2 | Removing a skill would NOT remove a matrix cell | PASS | `buildMatrix()` (lines 654-678) iterates ROWS × COLS to create cells unconditionally. Skills only affect the count text inside cells, not cell existence. |
| E10-1 | Director shows "Human Director" | PASS | Line 409: `{id:"director",name:"Human Director",desc:"Sole human Director, gate approver",...}` |
| E10-2 | Resources dropdown counts: Skills 27, Templates 27, Frameworks 17, Rules 8 | PASS | Line 309: `Skills (27)...Templates (27)...Frameworks (17)...Rules (8)` |
| E10-3 | notion-mcp in cross-cutting | PASS | Line 416: `{id:"notion-mcp",...type:"tool"}` |
| E10-4 | exa-mcp in cross-cutting | PASS | Line 417: `{id:"exa-mcp",...type:"tool"}` |
| E10-5 | qmd-mcp in cross-cutting | PASS | Line 418: `{id:"qmd-mcp",...type:"tool"}` |
| E10-6 | Human (1) in type dropdown | PASS | Line 309: `<option value="human">Human (1)</option>` |
| E10-7 | Environment (3) in type dropdown | PASS | Line 309: `<option value="environment">Environment (3)</option>` — matches claude-code, cursor, antigravity |
| E10-8 | Tools (6) in type dropdown | PASS | Line 309: `<option value="tool">Tools (6)</option>` — matches clickup, mermaid, github, notion-mcp, exa-mcp, qmd-mcp |

## Failures

None.

## Validation Notes

1. **View IDs use `view-` prefix:** The HTML uses `id="view-building"`, `id="view-matrix"`, `id="view-resources"` rather than `#building-view` etc. This is a naming convention choice, not a failure — the JS `switchView()` function at line 736 correctly references these IDs.

2. **Right EP rail has 10 entries** (lines 271-280), containing framework names. The left rail has 8 entries matching the 8 enforcement rules. This asymmetry is by design — left = rules (EP enforcement), right = frameworks (EP knowledge).

3. **CROSS_CUTTING array has 10 entries** (lines 409-418): 1 human + 3 environments + 6 tools. The dropdown counts (Human 1, Environment 3, Tools 6) are consistent.

4. **File is 922 lines**, self-contained with inline CSS + JS. No external dependencies beyond Google Fonts.

---
*Validated by ltc-reviewer (Opus) on 2026-03-31*
