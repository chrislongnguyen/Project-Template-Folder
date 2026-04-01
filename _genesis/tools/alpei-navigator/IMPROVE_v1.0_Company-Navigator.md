---
version: "1.1"
last_updated: 2026-03-31
status: PENDING_DIRECTOR_APPROVAL
director: Manh N.
workstream: 4-IMPROVE
project: LTC Company Navigator
---

# IMPROVE: LTC Company Navigator

---

## 1. Post-Delivery Verification Procedure

### V-1: I1 Verification (Core Pipeline)
1. Open HTML in Chrome
2. Run Verb-AC1 through AC7 (navigation, toggle, display, expand, select, highlight, drill-down)
3. Run Noun-AC1 through AC11, AC13 (all views, cards, panels exist with correct counts)
4. Run SustainAdv-AC1 (spot-check 5 skill descriptions against source)
5. Run SustainAdj-AC1 through AC5 (brand colors, font, completeness, 7CS accuracy, structure)
6. **Gate: Director review** — approve or request revision

### V-2: I2 Verification (Quality Polish)
1. Run EffAdv-AC1 (performance: toggle time < 100ms)
2. Run EffAdv-AC2 (incognito test)
3. Run EffAdv-AC3 (CSS transition check)
4. Run Noun-AC12 (trace all 7 connection chains)
5. Run EffAdj-AC1 (self-contained check)
6. Run EffAdj-AC2 (file size and load time)
7. **Gate: Director review**

### V-3: I3 Verification (Maintainability)
1. Run ScalAdv-AC1 (add mock skill, verify 3 views)
2. Run ScalAdv-AC2 (add mock template, verify)
3. Run ScalAdj-AC1 (locate data section in < 30s)
4. Run ScalAdj-AC2 (verify structure/data separation)
5. **Gate: Director review — final acceptance**

---

## 2. Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Resource coverage | 100% of known resources (>= 63) | Count against PLAN §1 |
| Cell coverage | 20/20 cells populated with 7CS | Visual inspection |
| Brand compliance | 100% match | Compare colors/fonts with brand-identity.md |
| Load time | < 2 seconds | Chrome DevTools |
| File size | < 200KB | `ls -la` |
| I1 ACs passed | 100% (27/27) | Checklist in EXEC §2 |
| I2 ACs passed | 100% (6/6) | Checklist in EXEC §2 |
| I3 ACs passed | 100% (4/4) | Checklist in EXEC §2 |

---

## 3. Feedback Collection (Post v1.0)

After the product is delivered and verified:
1. Director uses the navigator for 1 week during daily operations
2. Director provides feedback on:
   - Missing resources not captured in PLAN §1
   - Incorrect cell mappings (resource appears in wrong cells)
   - UX issues (confusing navigation, hard-to-find items)
   - New needs (additional views, search functionality, etc.)
3. Feedback is captured in FEEDBACK_TEMPLATE format
4. Improvements are planned for v1.1

---

## 4. Traceability Matrix

| If Product Fails... | Trace To | Action |
|---------------------|----------|--------|
| Wrong resource data | PLAN §1 (mapping tables) | Fix mapping, rebuild |
| Missing resource | PLAN §1 (should be in tables) | Add to mapping, rebuild |
| Wrong visual design | PLAN §3 (design spec) | Fix spec, rebuild |
| Wrong interactivity | EXEC §3 Step 3 (JS requirements) | Fix implementation |
| Wrong grid structure | ALIGN §4 (anchor framework) | Review with Director |
| Misunderstood need | ALIGN §3 (interview record) | Re-interview, re-align |
| Brand violation | PLAN §3.1 (style reference) | Fix CSS to match brand |
| Performance issue | EXEC §4 (technical constraints) | Optimize JS/CSS |
| AC threshold wrong | EXEC §2 (acceptance criteria) | Revise AC, re-verify |
| Monospace font used | Intentional exception | `font-family:monospace` used for file paths, code coordinates, and markdown preview in brief panel — justified for readability. Does not apply to body text, headings, or labels which remain Inter. |

---

## 4b. Review Log: Second Review (2026-03-31)

Two specialist reviews were conducted — one Technical, one LTC Framework. Below is every finding and what was done about it, written so a low-code reviewer can verify each fix.

### How to Verify These Fixes

Open `LTC-COMPANY-NAVIGATOR.html` in your browser. Each fix below tells you exactly **where to look** and **what you should see**.

---

### TECHNICAL FIXES (4 items)

**T1. Feedback loop brief now shows specific content (was generic)**

- **What was wrong:** Clicking the feedback loop in Brief Mode showed "(no data)" instead of useful info.
- **What was fixed:** Added specific descriptions so the brief panel shows what the feedback loop carries and which files it affects.
- **How to verify:** Open navigator → click "Brief" pill → click the feedback loop at the bottom of Building view → the panel should show "Feedback loop: I-V validated results feed back to A-D..." and file path "CLAUDE.md (IMPROVE workstream section)".

**T2. Close buttons now accessible (sidebar and brief panel)**

- **What was wrong:** The X close buttons on the sidebar and brief panel were not keyboard-accessible.
- **What was fixed:** Added `role="button"`, `aria-label`, and `tabindex="0"` to both close buttons.
- **How to verify:** Right-click the X button on the sidebar → Inspect → you should see `role="button" aria-label="Close sidebar" tabindex="0"`.

**T3. Brief panel marked as modal dialog**

- **What was wrong:** The brief panel lacked `aria-modal="true"`, so screen readers didn't know it overlays content.
- **What was fixed:** Added `aria-modal="true"` to the brief panel.
- **How to verify:** Right-click the brief panel area → Inspect → you should see `role="dialog" aria-label="Brief Generator" aria-modal="true"`.

**T4. No remaining technical issues**

- The Technical specialist confirmed all 8 criteria pass: colors correct, meta-skills visible, feedback loop briefable, aria attributes present, EA row renders in all locations, no JS errors, file size 59KB.

---

### LTC FRAMEWORK FIXES (7 items)

**F1. EA renamed from "Emergent Action" to "Effective Action"**

- **What was wrong:** The sidebar and matrix detail called EA "Emergent Action", but the canonical name in `rules/agent-system.md` is "Effective Action" (emergent describes its behavior, not its name).
- **What was fixed:** Sidebar now reads "EA = Effective Action (emergent from Agent execution — observable only, not configurable)". Matrix detail now reads "EA (Effective Action)".
- **How to verify:** Open navigator → click "Sidebar" → look at "7CS Components" section → EA should say "Effective Action". Then click "Matrix" view → click any cell → the 8th row should say "EA (Effective Action)".

**F2. PLAN doc: Data Sources table corrected (26→29 skills, 16→17 templates)**

- **What was wrong:** The Data Sources table in Section 5 said 26 skills and 16 templates.
- **What was fixed:** Updated to 29 skills and 17 templates.
- **How to verify:** Open `Company-Navigator/2-PLAN/PLAN_v1.0_Company-Navigator.md` → search for "Data Sources" → skills should say 29, templates should say 17.

**F3. PLAN doc: Missing templates added to Section 1.4 table**

- **What was wrong:** The template table listed only 15 entries but header said 17. DESIGN_TEMPLATE and RESEARCH_METHODOLOGY were missing.
- **What was fixed:** Added both entries with correct cell mappings.
- **How to verify:** Open PLAN doc → Section 1.4 → count table rows → should be 17 (including DESIGN_TEMPLATE at all D cells and RESEARCH_METHODOLOGY at L-B).

**F4. PLAN doc: Building View spec corrected (16→17 templates)**

- **What was wrong:** The Shared Services line in the Building View wireframe said "16 Templates".
- **What was fixed:** Changed to "17 Templates".
- **How to verify:** Open PLAN doc → search "SHARED SERVICES" → should say "17 Templates".

**F5. EXEC doc: All AC thresholds corrected**

- **What was wrong:** Multiple acceptance criteria still referenced 26 skills and 16 templates.
- **What was fixed:** Updated all occurrences:
  - SustainAdv-AC1: 26/26 → 29/29 (both in AC table and AC-TEST-MAP)
  - Noun-AC5: 26 → 29 (both locations)
  - Noun-AC6: 16 → 17 (both locations)
  - SustainAdj-AC3: >= 63 → >= 69 (both locations)
  - Implementation Steps: 26 SKILL.md → 29, 16 templates → 17
  - ScalAdv-AC2: "17th template" → "18th template"
- **How to verify:** Open EXEC doc → search for "26" → should find zero matches (except the date 2026). Search for "16" → should find zero matches related to templates.

**F6. PLAN doc: Mermaid mapping reconciled**

- **What was wrong:** HTML mapped Mermaid to L-B but PLAN Section 1.5 only listed P-B and A-B.
- **What was fixed:** Added L-B to PLAN with justification "diagrams for learning materials".
- **How to verify:** Open PLAN doc → Section 1.5 → Mermaid row → should show "P-B, A-B, L-B (diagrams for learning materials)".

**F7. No remaining framework issues**

- The Framework specialist confirmed: all colors from brand palette, 7CS priority order correct, Three Pillars correctly represented, constitutional anchoring intact.

---

## 5. Lessons to Capture (Post-Delivery)

After completion, document:
1. **What worked:** Which parts of the ALPEI x DSBV x 7CS mapping were clear and accurate
2. **What surprised:** Resources that didn't fit cleanly into the framework
3. **What to change:** Improvements to the mapping methodology for future products
4. **Process feedback:** Was the ALIGN -> PLAN -> EXECUTE -> IMPROVE documentation workflow effective for this type of product?

---

## 6. v1.1 Improvement Backlog (To Be Populated Post-Delivery)

| # | Improvement | Source | Priority | Status |
|---|-------------|--------|----------|--------|
| 1 | **Briefing System: Change Management Interface** | Director feedback 2026-03-31 | HIGH | DESIGN READY |

### v1.1-F1: Briefing System — Full Design

**Problem:** The navigator map is for human understanding, but the Director needs to translate what they see into instructions that AI agents can execute against the actual template. Currently there is no structured way to do this.

**Design Principle:** The 5x4x7CS hierarchy is a **coordinate system**. Any change in the company can be expressed as:

```
CHANGE = {
  level:      Framework | Workstream | Subsystem | Component
  coordinate: e.g., "P-B:EOP" (Plan workstream, Build phase, EOP slot)
  action:     Add | Remove | Move | Modify
  target:     The specific resource being changed
}
```

**Deliverables (two parts):**

**Part A: Structured Markdown Brief Template**
- A `CHANGE-BRIEF_TEMPLATE.md` that the Director fills out manually
- Fields: Level, Coordinate, Action, Target, Current State, Desired State, Acceptance Criteria
- AI agent reads the coordinate and knows exactly which files to modify in the OPS_OE template
- Works across any AI tool (Claude Code, Cursor, AntiGravity)

**Part B: Interactive Export in Navigator HTML**
- Add a "Brief" button/mode to the navigator
- When active, clicking any element (skill, template, cell, workstream) generates a pre-filled change brief
- Brief includes: the coordinate, current state (copied from the map data), and a description field
- "Copy to Clipboard" button lets Director paste the brief into any AI session
- AI agent receives the brief and knows: which level, which coordinate, what's currently there, what to change

**Coordinate Reference:**

| Level | Coordinate Format | Example | What Changes |
|-------|-------------------|---------|--------------|
| Framework | `EP:{rule-name}` | `EP:brand-identity` | A constitutional rule or framework |
| Workstream | `{workstream}:*` | `A:*` or `ALIGN:*` | Workstream-level I/O, purpose, or structure |
| Subsystem | `{workstream}-{phase}` | `P-B` | A specific DSBV room's configuration |
| Component | `{workstream}-{phase}:{7CS}` | `P-B:EOP` | A specific 7CS slot in a specific room |
| Resource | `{workstream}-{phase}:{7CS}:{resource}` | `P-B:EOP:ltc-writing-plans` | A specific resource in a specific slot |

**Example Briefs:**

**Adding a new skill:**
```
Level: Component
Coordinate: E-B:EOP
Action: Add
Target: new-deploy-skill
Description: Add a deployment automation skill to Execute Build phase
Current State: ltc-task-executor is the only EOP skill in E-B
Desired State: new-deploy-skill added alongside ltc-task-executor
```

**Moving a resource:**
```
Level: Component
Coordinate: L-B:EOT -> P-B:EOT
Action: Move
Target: deep-research
Description: Move deep-research from Learn Build to Plan Build
Current State: deep-research is EOT in L-B and A-B
Desired State: deep-research is EOT in P-B and A-B (removed from L-B)
```

**Modifying a workstream's I/O:**
```
Level: Workstream
Coordinate: P:*
Action: Modify
Target: Workstream Input
Description: Add compliance check results as additional input to PLAN
Current State: Input is "LEARN knowledge + ALIGN requirements"
Desired State: Input is "LEARN knowledge + ALIGN requirements + compliance baseline"
```

**Affected files mapping (for AI agents):**

| Coordinate Level | Files to Modify in OPS_OE Template |
|------------------|-------------------------------------|
| EP:{rule} | `rules/{rule}.md` |
| EP:{framework} | `_genesis/frameworks/{framework}.md` |
| {workstream}:* | Workstream folder structure + `CLAUDE.md` |
| {workstream}-{phase}:EOP (skill) | `.claude/skills/{skill}/SKILL.md` |
| {workstream}-{phase}:EOP (template) | `_genesis/templates/{template}.md` |
| {workstream}-{phase}:EOT | `.claude/settings.json` (tool permissions) |
| {workstream}-{phase}:EOE | `.claude/settings.json` (environment config) |
| {workstream}-{phase}:EP | `rules/*.md` or `_genesis/frameworks/*.md` |
| Navigator itself | `LTC-COMPANY-NAVIGATOR.html` (update data arrays) |
