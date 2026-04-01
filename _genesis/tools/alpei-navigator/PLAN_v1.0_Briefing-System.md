---
version: "1.0"
last_updated: 2026-03-31
status: PENDING_DIRECTOR_APPROVAL
director: Manh N.
workstream: 2-PLAN
project: Company Navigator Briefing System
parent: Company Navigator v1.0
---

# PLAN: Company Navigator Briefing System

## 1. Architecture

### Single File Modification
The entire feature is implemented in one file:
```
/Users/nvdmm/Desktop/[MANH N.]_Repo Template for LTC Project/LTC-COMPANY-NAVIGATOR.html
```
Current size: ~45KB. Estimated after change: ~57KB (well under 200KB limit).

### Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Brief UI | Right slide-in panel (like existing sidebar) | Keeps main view visible for context; consistent pattern |
| Element targeting | Toggle "Brief Mode" via header pill | Clean, discoverable; avoids DOM bloat vs per-element buttons |
| Coordinate detection | `data-brief-coord` attributes on rendered elements | Reliable; avoids complex DOM-position inference |
| File path mapping | JS lookup function using existing data arrays | Zero new data; maps coordinates to template paths |
| Clipboard | `navigator.clipboard.writeText()` + fallback | Modern API with graceful degradation |
| Brief mode interaction | Capture-phase event delegation on `document.body` | Intercepts clicks before existing handlers when in brief mode |

---

## 2. UI Design

### Brief Mode Toggle
- New "Brief" pill in header alongside Expand All / Collapse All / Sidebar
- When active: pill glows ruby, body gets `brief-mode` class
- All briefable elements show crosshair cursor + gold dashed outline on hover
- Clicking any tagged element opens the brief panel (instead of normal expand/collapse)
- Toggle off: brief mode deactivates, normal interactions resume

### Brief Panel (right slide-in, 420px wide)
```
+------------------------------------------+
| X  Brief Generator                        |
|                                           |
| COORDINATE (auto)                         |
| [ P-B:EOP:ltc-writing-plans            ] |
|                                           |
| LEVEL (auto)                              |
| [ resource                              ] |
|                                           |
| CURRENT STATE (auto)                      |
| [ Writes plans with HOW NOT sections    ] |
| [ Role: EOP                             ] |
| [ Active in: P-D, P-B                   ] |
|                                           |
| AFFECTED FILES (auto)                     |
| [ .claude/skills/ltc-writing-plans/     ] |
| [ SKILL.md                              ] |
|                                           |
| ---------------------------------------- |
|                                           |
| ACTION (director chooses)                 |
| [ Modify  v ]                             |
|                                           |
| DESIRED STATE (director writes)           |
| [ ________________________________      ] |
|                                           |
| ACCEPTANCE CRITERIA (director writes)     |
| [ ________________________________      ] |
|                                           |
| ---------------------------------------- |
|                                           |
| BRIEF PREVIEW (live markdown)             |
| [ # Brief: Modify P-B:EOP:ltc-...      ] |
| [ ## Metadata ...                        ] |
| [ ## Current State ...                   ] |
| [ ## Regeneration Instructions ...       ] |
|                                           |
| [   Copy to Clipboard   ] [  Refresh  ]  |
+------------------------------------------+
```

### Auto-filled fields (from navigator data)
- **Coordinate**: Read from `data-brief-coord` attribute on clicked element
- **Level**: Read from `data-brief-level` attribute
- **Current State**: Looked up from SKILLS/TEMPLATES/FRAMEWORKS/RULES/CROSS_CUTTING arrays
- **Affected Files**: Mapped from coordinate using `coordToPath()` function

### Director-editable fields
- **Action**: Dropdown (Add / Remove / Move / Modify)
- **Desired State**: Textarea for describing the change
- **Acceptance Criteria**: Textarea for verification conditions

### Live Preview
- Updates as the Director types
- Shows the complete markdown brief including regeneration instructions

---

## 3. Data Attribute Mapping

Every briefable element gets two HTML attributes added during rendering:

| Element Type | data-brief-coord | data-brief-level |
|-------------|-----------------|-----------------|
| EP rail rules (static HTML) | `EP:{rule-name}` | `framework` |
| Workstream header | `{WORKSTREAM}:*` | `workstream` |
| Workstream 7CS header | `{WORKSTREAM}:*` | `workstream-7cs` |
| DSBV room header | `{z}-{p}` | `subsystem` |
| Resource tag (.r.eop) in cell | `{z}-{p}:EOP:{name}` | `resource` |
| Resource tag (.r.eot) in cell | `{z}-{p}:EOT:{name}` | `resource` |
| Resource tag (.r.ep) in cell | `{z}-{p}:EP:{name}` | `component` |
| Resource tag (.r) EOE in cell | `{z}-{p}:EOE:{name}` | `resource` |
| Matrix cell | `{z}-{p}` | `subsystem` |
| Heatmap cell | `{z}-{p}` | `subsystem` |
| Workstream-level 7CS resource tags | `{WORKSTREAM}:EOP:{name}` | `workstream-resource` |

---

## 4. Coordinate-to-FilePath Mapping (JS function)

```
coordToPath(coord) resolves:

EP:{rule}               -> rules/{rule}.md
EP:{framework}          -> _genesis/frameworks/{framework}.md
{workstream}:*                -> <workstream-folder>/ + CLAUDE.md
{z}-{p}                 -> (subsystem — multiple files)
{z}-{p}:EOP:{skill}     -> .claude/skills/{skill}/SKILL.md
{z}-{p}:EOP:{template}  -> _genesis/templates/{template}.md
{z}-{p}:EOT:{tool}      -> .claude/settings.json
{z}-{p}:EOE:{env}       -> .claude/settings.json
{z}-{p}:EP:{name}       -> rules/{name}.md or _genesis/frameworks/{name}.md
```

Uses existing data arrays (RULES, FRAMEWORKS, SKILLS, TEMPLATES) to disambiguate.

---

## 5. Brief Markdown Template (generated output)

Every brief includes Part B (regeneration instructions) as a hardcoded final section:

```markdown
# Brief: {Action} {Coordinate}

## Metadata
- **Coordinate:** `{coord}`
- **Level:** {level}
- **Action:** {action}
- **Generated:** {timestamp}

## Current State
{auto from data}

## Affected File(s)
`{path from coordToPath}`

## Desired State
{director's input}

## Acceptance Criteria
{director's input}

---

## Regeneration Instructions
After completing the changes:
1. Verify affected files are correctly modified
2. Regenerate LTC-COMPANY-NAVIGATOR.html:
   - Update the relevant JS data array(s) to match new state
   - If Added: add entry with cells, role, desc, connects
   - If Removed: delete entry and clean up connects references
   - If Moved: update cells array
   - If Modified: update relevant fields
   - Verify navigator renders correctly in all 3 views
3. Commit both source changes and regenerated navigator
```

---

## 6. Implementation Steps (Execution Sequence)

| Order | Task | Risk | Depends On |
|-------|------|------|------------|
| 1 | Add CSS: brief mode + panel styles (~80 lines) | LOW | None |
| 2 | Add HTML: Brief pill + panel + toast (~50 lines) | LOW | Step 1 |
| 3 | Add data attributes to static EP rail HTML | LOW | None |
| 4 | Add data attributes to `buildBuildingView()` renders (~15 touch points) | MEDIUM | Step 3 |
| 5 | Add data attributes to `buildMatrix()` and `buildResourcesView()` | MEDIUM | Step 3 |
| 6 | Add JS: brief mode toggle, event delegation, coordToPath, getCurrentState | MEDIUM | Steps 2-5 |
| 7 | Add JS: openBrief, generateBriefMarkdown, copyBrief, updatePreview | MEDIUM | Step 6 |
| 8 | Add JS: live preview binding + sidebar conflict resolution | LOW | Step 7 |
| 9 | Test all 5 coordinate levels with click-to-brief | HIGH | Steps 1-8 |

---

## 7. Risk Register

| # | Risk | Impact | Mitigation |
|---|------|--------|------------|
| R1 | Capture-phase handler breaks normal interactions when brief mode is OFF | HIGH | Handler returns early when `briefMode===false`; only intercepts when active |
| R2 | Some elements don't have data attributes (missed during rendering) | MEDIUM | Test every element type in all 3 views |
| R3 | Brief panel and sidebar both open simultaneously | LOW | Close sidebar when brief panel opens (and vice versa) |
| R4 | Clipboard API blocked in some browsers | LOW | Fallback to `document.execCommand('copy')` with hidden textarea |
| R5 | Workstream-level resource tags share names across cells | MEDIUM | Workstream-level tags use workstream prefix (e.g., `PLAN:EOP:{name}`) not cell prefix |

---

## 8. Interaction with Existing Features

| Existing Feature | Impact | Resolution |
|-----------------|--------|------------|
| Building view expand/collapse | Brief mode suppresses via capture-phase | Exits brief mode restores normal behavior |
| Matrix cell detail expansion | Brief mode suppresses via capture-phase | Same |
| Resources heatmap selection | Brief mode suppresses via capture-phase | Same |
| Sidebar | Mutual exclusion with brief panel | Auto-close sidebar when brief opens |
| Expand All / Collapse All | Works normally in both modes | No conflict |
