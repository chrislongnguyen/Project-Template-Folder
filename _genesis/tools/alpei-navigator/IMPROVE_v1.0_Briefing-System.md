---
version: "1.0"
last_updated: 2026-03-31
status: COMPLETED
director: Manh N.
zone: 4-IMPROVE
project: Company Navigator Briefing System
parent: Company Navigator v1.0
---

# IMPROVE: Company Navigator Briefing System

## 1. Verification Procedures

### V-1: Brief Mode Toggle
1. Click "Brief" pill in header — verify pill turns ruby, cursor changes to crosshair on briefable elements
2. Click "Brief" pill again — verify mode deactivates, cursor returns to normal
3. Verify normal expand/collapse still works when brief mode is OFF

### V-2: Brief Generation (per coordinate level)
1. **Framework level:** Click an EP rail rule (e.g., "brand-identity") — verify brief panel shows `EP:brand-identity`, level `framework`, current state from RULES array, file path `rules/brand-identity.md`
2. **Zone level:** Click a zone header (e.g., "ALIGN") — verify brief shows `ALIGN:*`, level `zone`, I/O from ZONE_IO
3. **Subsystem level:** Click a DSBV room header (e.g., "P-B") — verify brief shows `P-B`, level `subsystem`, lists skills/templates in that cell
4. **Resource level:** Click a skill tag (e.g., "ltc-writing-plans" in P-B) — verify brief shows `P-B:EOP:ltc-writing-plans`, level `resource`, description matches SKILLS array
5. **Zone-resource level:** Click a skill in the zone 7CS panel — verify brief shows `PLAN:EOP:ltc-writing-plans`, level `zone-resource`

### V-3: Director-Editable Fields
1. Change Action dropdown to each option (Add, Remove, Move, Modify) — verify preview updates
2. Type in Desired State textarea — verify preview updates live
3. Type in Acceptance Criteria textarea — verify preview updates live

### V-4: Copy to Clipboard
1. Click "Copy to Clipboard" — verify toast "Copied to clipboard!" appears
2. Paste into a text editor — verify full markdown brief including regeneration instructions
3. Verify brief contains: Metadata, Current State, Affected Files, Desired State, Acceptance Criteria, Regeneration Instructions

### V-5: Panel Interaction
1. Open brief panel — verify sidebar closes if it was open
2. Click a different element while panel is open — verify panel updates to new target
3. Close panel via X button — verify panel closes

---

## 2. Acceptance Criteria (VANA)

### Verb ACs
- [ ] Clicking any `[data-brief-coord]` element in brief mode opens the brief panel
- [ ] Brief panel auto-fills coordinate, level, current state, and file paths
- [ ] "Copy to Clipboard" copies complete markdown to system clipboard
- [ ] Live preview updates as Director types

### Sustainability ACs
- [ ] Every EP rail rule, zone header, DSBV room header, and resource tag has `data-brief-coord`
- [ ] `coordToPath()` correctly resolves all 5 coordinate levels to template file paths
- [ ] `getCurrentState()` returns accurate data from JS arrays for all coordinate types

### Efficiency ACs
- [ ] Brief mode toggle is instant (no page reload, no DOM rebuild)
- [ ] Panel opens within 100ms of clicking an element
- [ ] Total file size remains under 200KB

### Scalability ACs
- [ ] Adding a new resource to the data arrays automatically makes it briefable (no extra wiring)
- [ ] Brief template is tool-agnostic (works in Claude Code, Cursor, AntiGravity)

---

## 3. Traceability Matrix

| If Brief Fails... | Trace To | Action |
|-------------------|----------|--------|
| Wrong coordinate | Data attribute on element | Fix `data-brief-coord` in render function |
| Wrong current state | `getCurrentState()` function | Fix lookup logic against data arrays |
| Wrong file path | `coordToPath()` function | Fix coordinate-to-path mapping |
| Panel doesn't open | Event delegation handler | Check capture-phase listener and `briefMode` flag |
| Copy fails | `copyBrief()` / `fallbackCopy()` | Check clipboard API and fallback |
| Normal mode broken | Capture-phase handler | Verify early return when `briefMode===false` |
| Brief content wrong | `generateBriefMarkdown()` | Fix template literal assembly |

---

## 4. Feedback Collection

After the briefing system is used for 1 week:
1. Director provides feedback on:
   - Missing briefable elements (elements without `data-brief-coord`)
   - Incorrect file path mappings
   - Brief template improvements (additional fields needed?)
   - Regeneration instruction clarity
2. Feedback captured for v1.2 planning

---

## 5. Known Exceptions

| Exception | Justification |
|-----------|---------------|
| Monospace font in `.bp-value` and `.bp-preview` | File paths and markdown preview require monospace for readability |
| Feedback loop uses `IMPROVE:feedback-loop` coordinate | Not a standard ALPEI:DSBV coordinate — it's a cross-zone architectural element |
