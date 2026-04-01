---
version: "1.1"
last_updated: 2026-03-31
status: PENDING_DIRECTOR_APPROVAL
director: Manh N.
workstream: 3-EXECUTE
project: LTC Company Navigator
---

# EXECUTE: LTC Company Navigator

---

## 1. VANA Decomposition

### Effective Outcome (EO) Statement
> "The system must **NAVIGATE** **interactively** the **company resources** that are **brand-compliant, complete, and constitutionally-anchored**."

### VANA Components

| Component | Words |
|-----------|-------|
| **V** (Verb) | navigate, display, toggle, highlight, expand, drill-down, select |
| **A** (Adverb) | interactively, accurately, responsively, maintainably, statelessly |
| **N** (Noun) | building-view, matrix-view, heatmap-overlay, sidebar, skill-cards, template-cards, framework-cards, rule-cards, cell-7CS-detail, flow-arrows, gate-indicators, connection-chains, resource-detail-panel |
| **Adj** (Adjective) | brand-compliant, complete, accurate, self-contained, extensible, constitutionally-anchored |

---

## 2. Acceptance Criteria

### 2.1 Verb Acceptance Criteria (Core Actions)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| Verb-AC1 | navigate | Opening the HTML file shows a building view with 7 clickable floors (Roof, 5F-1F, Basement). Clicking any floor expands it to reveal 4 DSBV rooms. | ALIGN:§3:Decision-8 | Deterministic | 7 floors render; all 7 expand on click; each shows 4 rooms | I1 |
| Verb-AC2 | toggle | Three pills in header ([Building] [Matrix] [Resources]) switch between view modes. Only one view is visible at a time. No page reload. | ALIGN:§3:Decision-9 | Deterministic | 3 pills render; clicking each shows correct view; others hide; URL unchanged | I1 |
| Verb-AC3 | display | Matrix view renders a 5x4 grid (ALPEI rows x DSBV columns). All 20 cells are labeled with their ID (A-D, A-S, ... I-V). | ALIGN:§4:Framework | Deterministic | 20 cells visible; each labeled correctly; grid alignment intact | I1 |
| Verb-AC4 | expand | Clicking any cell in Matrix view expands it to show full 7CS detail (EP, Input, EOP, EOE, EOT, Agent, EO). | PLAN:§1 | Deterministic | Click each of 20 cells; each shows 7 labeled sections with content | I1 |
| Verb-AC5 | select | In Resources view, dropdown allows selecting any resource. Upon selection, the 5x4 matrix highlights cells where that resource is active in gold. | ALIGN:§3:Decision-10 | Deterministic | Select "learn-input" -> L-D, L-S cells highlight gold; select "Director" -> all V cells highlight gold | I1 |
| Verb-AC6 | highlight | Clicking a gold-highlighted cell in Resources view shows the resource's specific 7CS role in that cell in a detail panel below the matrix. | PLAN:§3.2:View-3 | Deterministic | Click highlighted L-D for "learn-input" -> panel shows "Role: EOP, scopes what to learn" | I1 |
| Verb-AC7 | drill-down | Building view supports 3 layers: floor overview -> expanded floor with rooms -> room detail with individual cards. Each layer is reachable by click. | ALIGN:§3:Decision-8 | Manual | Director can navigate from overview to any individual skill/template in <=3 clicks | I1 |

### 2.2 Adverb Acceptance Criteria (Quality of Action)

#### Sustainability Adverbs (I1)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| SustainAdv-AC1 | accurately | Every skill card's description matches the `description` field in its SKILL.md source file in the OPS_OE template. | PLAN:§1.3 | Deterministic | Diff check: 29/29 skill descriptions match source files verbatim or semantically equivalent | I1 |
| SustainAdv-AC2 | accurately | Every resource's cell mapping (which cells it appears in) matches the mapping table in PLAN section 1. | PLAN:§1.1-1.5 | Manual | Director reviews 10 randomly sampled resources; 10/10 mappings match PLAN | I1 |
| SustainAdv-AC3 | constitutionally-anchored | The 5x4 grid structure is derived from ALPEI x DSBV (constitutional frameworks), not from current skill inventory. Removing a skill does NOT remove a cell. | ALIGN:§4:Framework | Manual | Delete a skill from the data -> grid still shows 20 cells with same labels; only EOP content changes | I1 |

#### Efficiency Adverbs (I2)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| EffAdv-AC1 | responsively | View toggles (Building/Matrix/Resources) complete in under 100ms. No visible flicker or layout shift during toggle. | EXEC:§4:Constraints | Deterministic | Chrome DevTools Performance tab: toggle time < 100ms; no CLS events | I2 |
| EffAdv-AC2 | statelessly | No external state files, local storage, or cookies are required. All state is derived from DOM. Opening the HTML fresh produces identical behavior. | EXEC:§4:Constraints | Deterministic | Open in private/incognito browser -> all features work identically | I2 |
| EffAdv-AC3 | interactively | All expand/collapse animations complete in <=200ms. Cards, cells, and floors respond to click within 50ms (no perceivable delay). | PLAN:§3.1:Style | Deterministic | CSS transition-duration <= 0.2s for all interactive elements | I2 |

#### Scalability Adverbs (I3)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| ScalAdv-AC1 | maintainably | Adding a new skill requires changing only the data section of the HTML (adding one JS object or HTML block). No structural CSS/JS changes needed. | ALIGN:§2:Must-2 | Manual | Add a mock 27th skill -> only data section modified; all 3 views correctly show it in correct cells | I3 |
| ScalAdv-AC2 | maintainably | Adding a new template or framework follows the same pattern as adding a skill — data-only change. | ALIGN:§2:Must-2 | Manual | Add a mock 18th template -> only data section modified; appears in correct views | I3 |

### 2.3 Noun Acceptance Criteria (Data/Objects)

#### Views (UI Layer)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| Noun-AC1 | building-view | HTML contains a `#building-view` div with 7 floor sections: Roof (Constitution), 5F (IMPROVE), 4F (EXECUTE), 3F (PLAN), 2F (LEARN), 1F (ALIGN), Basement (Shared Services). | PLAN:§3.2:View-1 | Deterministic | `document.querySelectorAll('#building-view .floor').length === 7` | I1 |
| Noun-AC2 | matrix-view | HTML contains a `#matrix-view` div with a 5x4 grid. Rows: ALIGN, LEARN, PLAN, EXECUTE, IMPROVE. Columns: DESIGN, SEQUENCE, BUILD, VALIDATE. | PLAN:§3.2:View-2 | Deterministic | `document.querySelectorAll('#matrix-view .cell').length === 20` | I1 |
| Noun-AC3 | heatmap-overlay | HTML contains a `#resources-view` div with a resource selector (dropdowns grouped by type) and a 5x4 matrix that supports gold highlighting. | PLAN:§3.2:View-3 | Deterministic | Resource selector exists; selecting resource applies gold class to correct cells | I1 |
| Noun-AC4 | sidebar | HTML contains a fixed sidebar panel with quick reference content: Success Equation, Three Pillars, 7CS priority, DSBV, 8 LLM Truths, Maturity levels, UNG naming. | PLAN:§3.2:Sidebar | Deterministic | Sidebar exists; contains all 7 reference sections; toggles open/close | I1 |

#### Resource Cards (Data Layer)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| Noun-AC5 | skill-cards | All 29 skills are represented as cards with: name, one-line description, 7CS role, active cells. | PLAN:§1.3 | Deterministic | Count skill entries = 29; each has name, description, role, cells fields | I1 |
| Noun-AC6 | template-cards | All 17 templates are represented with: name, primary cells, when-to-use. | PLAN:§1.4 | Deterministic | Count template entries = 17; each has name, cells, usage fields | I1 |
| Noun-AC7 | framework-cards | All 10 frameworks are represented with: name, key insight, primary cells. | PLAN:§1.2 | Deterministic | Count framework entries = 10; each has name, insight, cells fields | I1 |
| Noun-AC8 | rule-cards | All 6 rules are represented with: name, governance scope, constitutional scope (all 20 cells). | PLAN:§1.1 | Deterministic | Count rule entries = 6; each has name, scope, and "ALL" cell mapping | I1 |
| Noun-AC9 | cell-7CS-detail | Each of the 20 matrix cells has expandable content showing all 7 components (EP, Input, EOP, EOE, EOT, Agent, EO) with actual resource names. | PLAN:§1 | Deterministic | Click cell A-D -> shows EP (6 rules), Input (Director mandate), EOP (align-specialist, ltc-brainstorming), etc. | I1 |

#### Flow Elements (Navigation Layer)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| Noun-AC10 | flow-arrows | Building view shows directional arrows between floors indicating input/output flow. Matrix view shows arrows between cells indicating iterative path. | PLAN:§3.2 | Deterministic | Building: 6 floor-to-floor arrows visible. Matrix: cell-to-cell path arrows visible | I1 |
| Noun-AC11 | gate-indicators | Every V (Validate) cell/room shows a gate indicator (lock icon or "Director approval required" label). | ALIGN:§4:DSBV | Deterministic | 5 gate indicators in building (one per floor V room); 5 in matrix (one per V cell) | I1 |
| Noun-AC12 | connection-chains | All 7 skill connection chains from PLAN section 2 are visualized: Learning Pipeline, Process Pipeline, Quality Loop, Compliance, Session Lifecycle, Research, Core Workflow. | PLAN:§2 | Manual | Director can visually trace each of the 7 chains through the matrix/building views | I2 |
| Noun-AC13 | resource-detail-panel | Resources view shows a detail panel below the matrix when a resource is selected, containing: description, 7CS role, file path, active cells, connected resources. | PLAN:§3.2:View-3 | Deterministic | Select "learn-input" -> panel shows all 5 fields populated | I1 |

### 2.4 Adjective Acceptance Criteria (Quality Attributes)

#### Sustainability Adjectives (I1)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| SustainAdj-AC1 | brand-compliant | All colors used match LTC brand palette: Midnight Green (#004851), Gold (#F2C75C), Dark Gunmetal (#1D1F2A), Ruby (#9B1842), Green (#69994D), Purple (#653469). No off-brand colors. | PLAN:§3.1:CSS | Deterministic | CSS grep: only brand colors used (allow #FFFFFF, #F4F5F7, #D0D5DD, #EAECF0 for neutrals) | I1 |
| SustainAdj-AC2 | brand-compliant | Typography uses Inter font exclusively (via Google Fonts). Base size 11pt (13px). | PLAN:§3.1:Typography | Deterministic | CSS: `font-family: 'Inter'` on body; no other font-family declarations | I1 |
| SustainAdj-AC3 | complete | All known resources are included: 29 skills + 17 templates + 10 frameworks + 6 rules + 7 cross-cutting resources. Total >= 69 resources. | PLAN:§1 | Deterministic | Count all resource entries in HTML >= 69 | I1 |
| SustainAdj-AC4 | accurate | 7CS component definitions match the canonical source in `rules/agent-system.md`: EP, Input, EOP, EOE, EOT, Agent, EA -> EO. Priority order: EP first, Agent second-to-last. | PLAN:§1:7CS | Deterministic | Sidebar/cell detail shows 7 components in correct priority order with correct names | I1 |
| SustainAdj-AC5 | constitutionally-anchored | The grid structure (5 rows x 4 columns) is hardcoded to ALPEI x DSBV. It does NOT dynamically generate from skill data. | ALIGN:§4 | Deterministic | HTML inspection: grid rows/columns are static HTML, not generated from resource data | I1 |

#### Efficiency Adjectives (I2)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| EffAdj-AC1 | self-contained | Single HTML file with all CSS inline in `<style>`, all JS inline in `<script>`, all data embedded. No external dependencies except Google Fonts CDN. | EXEC:§4:Constraints | Deterministic | File has 0 external `<link>` (except fonts), 0 external `<script>`, 0 fetch() calls | I2 |
| EffAdj-AC2 | lightweight | File size under 200KB. Page load under 2 seconds on modern browser. | EXEC:§4:Constraints | Deterministic | `ls -la` file size < 200KB; Chrome DevTools load time < 2s | I2 |

#### Scalability Adjectives (I3)

| A.C. ID | VANA Word | Criteria | Source | Eval Type | Threshold | Iteration |
|---------|-----------|----------|--------|-----------|-----------|-----------|
| ScalAdj-AC1 | extensible | Resource data is organized in a clearly identifiable section of the HTML (either JS data objects or well-structured HTML blocks). Adding a resource requires editing only this section. | ALIGN:§2:Must-2 | Manual | A developer can locate the data section in < 30 seconds and add a new resource following the pattern | I3 |
| ScalAdj-AC2 | constitutionally-anchored | If a new ALPEI workstream or DSBV phase were added (hypothetical), only the grid structure section needs updating — resource data format remains unchanged. | ALIGN:§4:Framework | Manual | The separation between structure (grid) and data (resources) is architecturally clear | I3 |

### 2.5 AC-TEST-MAP (Evaluation Specification)

| A.C. ID | VANA Word | Eval Type | Dataset Description | Grader Description | Threshold |
|---------|-----------|-----------|--------------------|--------------------|-----------|
| Verb-AC1 | navigate | Deterministic | Open HTML in browser | Count floors, click each, verify room expansion | 7 floors; 7 expand; 4 rooms each |
| Verb-AC2 | toggle | Deterministic | Click each pill sequentially | Verify visibility of correct view div | 3 pills; correct div visible per click |
| Verb-AC3 | display | Deterministic | Switch to Matrix view | Count cells, verify labels | 20 cells; correct A-D through I-V labels |
| Verb-AC4 | expand | Deterministic | Click each cell | Verify 7CS sections appear | 20 cells; each shows 7 sections |
| Verb-AC5 | select | Deterministic | Select "learn-input", "Director", "Three Pillars" | Verify correct cells highlight gold | learn-input: L-D,L-S; Director: all V; Three Pillars: all 20 |
| Verb-AC6 | highlight | Deterministic | Click highlighted cell after selecting resource | Verify detail panel content | Panel shows role, description, connections |
| Verb-AC7 | drill-down | Manual | Director navigates to random skill | Count clicks from overview | <= 3 clicks |
| SustainAdv-AC1 | accurately | Deterministic | Compare 29 skill descriptions | Diff against SKILL.md files | 29/29 match |
| SustainAdv-AC2 | accurately | Manual | Sample 10 resource mappings | Director verifies against PLAN | 10/10 correct |
| SustainAdv-AC3 | constitutionally-anchored | Manual | Hypothetically remove a skill | Grid unchanged | 20 cells remain |
| EffAdv-AC1 | responsively | Deterministic | Performance tab during toggle | Measure toggle time | < 100ms |
| EffAdv-AC2 | statelessly | Deterministic | Open in incognito | All features work | Pass/fail |
| EffAdv-AC3 | interactively | Deterministic | Inspect CSS | Check transitions | All <= 0.2s |
| ScalAdv-AC1 | maintainably | Manual | Add mock 27th skill | All views show it | 1 section edited; 3 views correct |
| ScalAdv-AC2 | maintainably | Manual | Add mock 18th template | Same pattern | 1 section edited; views correct |
| Noun-AC1 | building-view | Deterministic | DOM query | Count floors | 7 |
| Noun-AC2 | matrix-view | Deterministic | DOM query | Count cells | 20 |
| Noun-AC3 | heatmap-overlay | Deterministic | Select resource | Gold class applied | Pass/fail |
| Noun-AC4 | sidebar | Deterministic | Toggle sidebar | 7 sections present | 7/7 |
| Noun-AC5 | skill-cards | Deterministic | Count entries | Verify fields | 29; 4 fields |
| Noun-AC6 | template-cards | Deterministic | Count entries | Verify fields | 17; 3 fields |
| Noun-AC7 | framework-cards | Deterministic | Count entries | Verify fields | 10; 3 fields |
| Noun-AC8 | rule-cards | Deterministic | Count entries | Verify fields | 6; 3 fields |
| Noun-AC9 | cell-7CS-detail | Deterministic | Click A-D | 7 components shown | 7 sections populated |
| Noun-AC10 | flow-arrows | Deterministic | Visual inspection | Count arrows | Building: 6; Matrix: path visible |
| Noun-AC11 | gate-indicators | Deterministic | Count gates | Inspect V cells | 5 building; 5 matrix |
| Noun-AC12 | connection-chains | Manual | Trace chains | 7 chains | 7/7 traceable |
| Noun-AC13 | resource-detail-panel | Deterministic | Select resource | 5 fields populated | 5/5 |
| SustainAdj-AC1 | brand-compliant | Deterministic | CSS grep | Only brand colors | 0 off-brand |
| SustainAdj-AC2 | brand-compliant | Deterministic | CSS grep | Only Inter font | 1 font |
| SustainAdj-AC3 | complete | Deterministic | Count resources | Total count | >= 69 |
| SustainAdj-AC4 | accurate | Deterministic | Check 7CS order | Matches canonical | Correct order |
| SustainAdj-AC5 | constitutionally-anchored | Deterministic | HTML inspection | Grid is static | Static HTML |
| EffAdj-AC1 | self-contained | Deterministic | Grep externals | 0 deps (except fonts) | 0 |
| EffAdj-AC2 | lightweight | Deterministic | File size + load | Under limits | < 200KB; < 2s |
| ScalAdj-AC1 | extensible | Manual | Locate data section | Time to find | < 30s |
| ScalAdj-AC2 | constitutionally-anchored | Manual | Inspect separation | Structure vs data | Clear |

### 2.6 Iteration Plan

| Iteration | Focus | ACs Included | Gate |
|-----------|-------|-------------|------|
| **I1** | Core Pipeline — All views render with correct data | Verb-AC1-7, SustainAdv-AC1-3, All Noun-ACs (1-11, 13), SustainAdj-AC1-5 | Director approval |
| **I2** | Quality Polish — Performance, animations, chains | EffAdv-AC1-3, Noun-AC12, EffAdj-AC1-2 | Director approval |
| **I3** | Maintainability — Extensible data structure | ScalAdv-AC1-2, ScalAdj-AC1-2 | Director final acceptance |

---

## 3. Implementation Steps

### Step 1: Data Extraction (Parallel Agents)

Read all source files from the OPS_OE master template (`/Users/nvdmm/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/`) to extract accurate content.

**Agent 1: Skills Data**
- Read all 29 `SKILL.md` files in `.claude/skills/*/SKILL.md`
- Read key `gotchas.md` files in `.claude/skills/*/gotchas.md`
- Extract per skill: name, description, workstream mapping, 7CS role, input/output connections
- Validate against the mapping table in PLAN section 1.3

**Agent 2: Templates, Frameworks, Rules Data**
- Read all 17 template files in `_shared/templates/*.md`
- Read all 10 framework files in `_shared/frameworks/*.md`
- Read all 6 rule files in `rules/*.md`
- Extract per resource: name, description, purpose, key content summary

**Agent 3: Style and Brand Data**
- Read `CLAUDE.md` for brand specs and system configuration
- Read `1-ALIGN/learning/research/i1-artifact-flow-map.html` for complete CSS/JS patterns
- Extract: CSS variables, component styles, JS interaction patterns, HTML structure

### Step 2: Data Mapping

Using the data from Step 1 and the mapping tables from PLAN section 1.1-1.5:
- Confirm each resource's 7CS role and active cells
- Resolve any ambiguities (skills that could map to multiple roles)
- Build the data structures for the HTML (JSON-like objects embedded in the file)
- Verify all 7 skill connection chains (PLAN section 2)

### Step 3: Build HTML

Create `LTC-COMPANY-NAVIGATOR.html` at:
```
/Users/nvdmm/Desktop/[MANH N.]_Repo Template for LTC Project/LTC-COMPANY-NAVIGATOR.html
```

**Structure:**
```html
<!DOCTYPE html>
<html>
<head>
  <!-- Meta, Google Fonts (Inter), inline CSS -->
</head>
<body>
  <!-- Sticky Header with view toggle pills -->
  <!-- Legend bar -->
  <!-- Sidebar (quick reference, toggleable) -->

  <!-- View 1: Building (default visible) -->
  <div id="building-view">
    <!-- Roof: Constitution -->
    <!-- Floor 5: IMPROVE -->
    <!-- Floor 4: EXECUTE -->
    <!-- Floor 3: PLAN -->
    <!-- Floor 2: LEARN -->
    <!-- Floor 1: ALIGN -->
    <!-- Basement: Shared Services -->
  </div>

  <!-- View 2: Matrix (hidden by default) -->
  <div id="matrix-view">
    <!-- 5x4 grid with expandable cells -->
    <!-- Flow arrows -->
  </div>

  <!-- View 3: Resources (hidden by default) -->
  <div id="resources-view">
    <!-- Resource selector (dropdowns by type) -->
    <!-- Heatmap overlay matrix -->
    <!-- Resource detail panel -->
  </div>

  <!-- Inline JavaScript -->
  <script>
    // View toggling
    // Floor/cell expand/collapse
    // Heatmap resource selection
    // Sidebar toggle
    // Expand All / Collapse All
  </script>
</body>
</html>
```

**CSS Requirements:**
- Match all variables and component styles from i1-artifact-flow-map.html
- Add styles for: matrix grid, heatmap cells, resource selector, view toggle
- Responsive: works at 1200px+ width (desktop-focused)
- Smooth transitions for expand/collapse (0.2s)

**JS Requirements:**
- `toggleView(view)` — switches between building/matrix/resources
- `toggleFloor(el)` / `toggleCell(el)` — expand/collapse
- `selectResource(id)` — highlights active cells in heatmap
- `toggleSidebar()` — show/hide sidebar
- `toggleAll(open)` — expand/collapse all sections
- No external libraries — vanilla JS only

### Step 4: Verification

Run through all acceptance criteria in section 2, following the iteration plan in section 2.6.

---

## 4. Technical Constraints

- **Single file:** All CSS, JS, and data must be inline (only external dependency: Google Fonts CDN)
- **No frameworks:** Vanilla HTML/CSS/JS only
- **Data embedded:** All resource data is hardcoded in the HTML as JS objects or HTML elements
- **Browser targets:** Modern browsers (Chrome, Safari, Firefox, Edge — latest versions)
- **File size target:** Under 200KB (text-heavy, no images)

---

## 5. Execution Sequence (Derisk-First)

| Order | Task | Risk Level | Depends On |
|-------|------|------------|------------|
| 1 | Data extraction (3 parallel agents) | LOW | None |
| 2 | Data mapping verification | MEDIUM | Step 1 |
| 3 | Build CSS (brand compliance) | LOW | Step 1 Agent 3 |
| 4 | Build HTML structure (3 views) | MEDIUM | Steps 2, 3 |
| 5 | Build JS interactivity | MEDIUM | Step 4 |
| 6 | Populate all data into HTML | HIGH | Steps 2, 4, 5 |
| 7 | I1 verification against AC | HIGH | Step 6 |
| 8 | I2 quality polish | MEDIUM | Step 7 passed |
| 9 | I3 maintainability verification | LOW | Step 8 passed |

**Derisk rationale:** CSS first (easy to verify visually), structure second (layout before data), interactivity third (JS depends on HTML structure), data last (highest risk — accuracy matters most).
