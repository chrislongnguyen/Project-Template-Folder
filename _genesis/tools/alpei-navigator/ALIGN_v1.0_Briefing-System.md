---
version: "1.0"
last_updated: 2026-03-31
status: APPROVED
director: Manh N.
workstream: 1-ALIGN
project: Company Navigator Briefing System
parent: Company Navigator v1.0
---

# ALIGN: Company Navigator Briefing System

## 1. Problem Statement

### Who
Director Manh N. — sole human Director operating an AI-agent company through the LTC template.

### Situation
- The Company Navigator (v1.0) gives the Director a visual map of the entire company using the 5x4x7CS hierarchy
- The Director understands the company structure through the map
- **BUT** when the Director wants to **change** something (add a skill, move a resource, restructure a workstream), there is no structured way to brief AI agents
- The navigator has **hardcoded data** — changes to the actual template don't automatically reflect in the map
- Briefs must work across **multiple AI tools** (Claude Code, Cursor, AntiGravity)

### Pain Points
1. **No change language** — No structured vocabulary for describing changes at any level of the hierarchy
2. **No file mapping** — Director doesn't know which template files correspond to which map coordinates
3. **Manual map updates** — After changing the template, the navigator must be manually updated separately
4. **Agent knowledge gap** — An agent with no prior LTC knowledge can't execute changes without extensive context

### Root Cause
The navigator is a **read-only reference**. It needs to become a **read-write interface** — not by editing directly, but by generating structured briefs that any AI agent can execute.

---

## 2. Desired Outcome

A **briefing system** with two integrated parts:

### Part A: Change Brief Generator
- Click any element in the navigator -> generates a pre-filled change brief
- Brief includes: coordinate, current state, desired state, affected file paths, step-by-step instructions, acceptance criteria
- "Copy to Clipboard" -> paste into any AI session (Claude Code, Cursor, AntiGravity)
- Works for all levels: resource, subsystem, workstream, framework

### Part B: Map Auto-Regeneration
- After executing a brief, the AI agent regenerates the navigator HTML as the final step
- Agent reads all source files from the template and rebuilds the navigator data
- Both the template AND the map stay in sync automatically
- No separate build script needed (agent does it as part of the brief execution)

### The Product Must:
1. Use the 5x4x7CS hierarchy as a **coordinate system** for all changes
2. Generate briefs with **enough context** that any AI agent (even without prior LTC knowledge) can execute
3. Include **affected file paths** mapping coordinates to actual template files
4. Work across **all AI tools** (tool-agnostic markdown format)
5. Include **acceptance criteria** in every brief for verification
6. Instruct agents to **regenerate the navigator** as the final execution step

---

## 3. Interview Record — Key Decisions

| # | Question | Director's Decision | Rationale |
|---|----------|-------------------|-----------|
| 1 | Usage workflow | Mix of reactive (spot issue in map) and proactive (planned improvements) | Both patterns needed |
| 2 | Executor tools | Multiple: Claude Code, Cursor, AntiGravity | Must be tool-agnostic |
| 3 | Change frequency by size | All sizes equally (resource, workstream, framework) | Full spectrum needed |
| 4 | Brief contents | Full context + file paths + step-by-step instructions | Agent should need zero prior LTC knowledge |
| 5 | Map sync | Auto-generate from template (agent regenerates after change) | No manual map updates |
| 6 | Auto-gen approach | AI agent regenerates (not a build script) | Fully integrated workflow |

---

## 4. The Coordinate System

The 5x4x7CS hierarchy provides a universal address for any element in the company:

### Coordinate Format
```
{level}:{workstream}-{phase}:{7CS}:{resource}
```

### Levels and Their Coordinates

| Level | Coordinate Format | Example | What It Addresses |
|-------|-------------------|---------|-------------------|
| **Framework** | `EP:{name}` | `EP:brand-identity` | A constitutional rule or framework |
| **Workstream** | `{workstream}:*` | `ALIGN:*` | Workstream-level I/O, purpose, or structure |
| **Workstream 7CS** | `{workstream}:{7CS}` | `PLAN:EOP` | A 7CS component at workstream level |
| **Subsystem** | `{workstream}-{phase}` | `P-B` | A specific DSBV room |
| **Component** | `{workstream}-{phase}:{7CS}` | `P-B:EOP` | A 7CS slot in a specific room |
| **Resource** | `{workstream}-{phase}:{7CS}:{name}` | `P-B:EOP:ltc-writing-plans` | A specific resource in a specific slot |

### Actions

| Action | Meaning |
|--------|---------|
| **Add** | Insert a new resource into a coordinate |
| **Remove** | Delete a resource from a coordinate |
| **Move** | Remove from one coordinate, add to another |
| **Modify** | Change a resource's properties without moving it |

### Coordinate -> File Path Mapping

| Coordinate Pattern | Template File(s) |
|-------------------|-----------------|
| `EP:{rule}` | `rules/{rule}.md` |
| `EP:{framework}` | `_genesis/frameworks/{framework}.md` |
| `{workstream}:*` | Workstream folder + `CLAUDE.md` workstream section |
| `{z}-{p}:EOP:{skill}` | `.claude/skills/{skill}/SKILL.md` + `gotchas.md` + `references/` |
| `{z}-{p}:EOP:{template}` | `_genesis/templates/{template}.md` |
| `{z}-{p}:EOT:{mcp}` | `.claude/settings.json` (permissions) |
| `{z}-{p}:EOE:{env}` | `.claude/settings.json` (environment) |
| `{z}-{p}:EP:{rule}` | `rules/{rule}.md` (add workstream-specific content) |
| Navigator data | `LTC-COMPANY-NAVIGATOR.html` (JS data arrays) |

---

## 5. Change Brief Structure

### Brief Template (what gets generated)

```markdown
# CHANGE BRIEF

## Metadata
- Date: {auto}
- Director: Manh N.
- Coordinate: {auto from click}
- Level: {Framework|Workstream|Subsystem|Component|Resource}

## Change
- Action: {Add|Remove|Move|Modify}
- Target: {resource name or description}

## Current State
{Auto-populated from navigator data}

## Desired State
{Director fills this in}

## Affected Files
{Auto-mapped from coordinate}
1. `{file path 1}` — {what to change}
2. `{file path 2}` — {what to change}

## Instructions for Agent
1. Read the current state of each affected file
2. {Step-by-step changes}
3. Verify change against acceptance criteria
4. Regenerate LTC-COMPANY-NAVIGATOR.html:
   - Read all .claude/skills/*/SKILL.md
   - Read all _genesis/templates/*.md
   - Read all _genesis/frameworks/*.md
   - Read all rules/*.md
   - Update the data arrays in the navigator HTML
   - Verify navigator renders correctly

## Acceptance Criteria
- [ ] {Specific, testable criterion}
- [ ] Navigator map reflects the change after regeneration
```

---

## 6. Workflow End-to-End

```
DIRECTOR sees something in the navigator
    |
    v
DIRECTOR clicks element -> "Brief" mode
    |
    v
NAVIGATOR generates pre-filled brief
(coordinate, current state, file paths, instructions)
    |
    v
DIRECTOR fills in: desired state + acceptance criteria
    |
    v
DIRECTOR clicks "Copy to Clipboard"
    |
    v
DIRECTOR pastes brief into AI session
(Claude Code, Cursor, or AntiGravity)
    |
    v
AI AGENT reads brief, executes changes:
1. Modify template files per instructions
2. Verify acceptance criteria
3. Regenerate navigator HTML from template
    |
    v
BOTH template AND map are updated
```

---

## 7. Stakeholders

| Role | Person/Entity | Responsibility |
|------|---------------|----------------|
| Director | Manh N. | Generates briefs, reviews changes |
| AI Agents | Claude Code, Cursor, AntiGravity | Execute briefs |
| Navigator | LTC-COMPANY-NAVIGATOR.html | Brief generation + auto-regeneration target |
| Template | OPS_OE.6.4 | Source of truth for regeneration |

---

## 8. Implementation Scope

### In Scope (v1.1)
- Interactive brief generation in navigator HTML (click -> brief)
- Full brief template with coordinates, file paths, instructions
- Copy-to-clipboard functionality
- Navigator regeneration instructions in every brief
- All 5 coordinate levels supported

### Out of Scope (future)
- Build script for standalone navigator regeneration
- Brief execution tracking / history
- Multi-brief batching (one brief per change for now)
- Automated validation (agent does manual verification)
