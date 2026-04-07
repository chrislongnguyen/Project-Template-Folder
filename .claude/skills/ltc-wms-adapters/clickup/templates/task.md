# Task — Template

## Custom Fields

### 🌐 DESIRED OUTCOMES (Objectives) — field `a382a103-456b-41a8-9b2a-8fa15a657ce4`
```
{User} {Verb} {Adverb} {Noun} that is {Adjective}.

→ Verb: {action}
→ Adverb: {how}
→ Noun: {artefact}
→ Adjective: {quality}
```

### 🌐 ACCEPTANCE CRITERIA (Key Results) — field `b74bfd0e-f112-4849-af6d-132e65e59b46`
```
- [ ] AC-V: {verb action verified}
- [ ] AC-N: {artefact exists}
```

### AC Ownership
Owns from parent Deliverable ({deliverable_name}):
- {List specific AC IDs}

### 🌐 DEFINITION OF DONE (DoD) — field `5bde1429-9a92-47a8-8345-0dd0b3dc9035`
```
All Must Have children (Increments + Blockers) are Done or Cancelled. Documentation exists.
```

### 🌐 RISK-BASED IMPORTANCE (MoSCoW) — field `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` (dropdown)
Select: `Must Have` | `Should Have` | `Could Have` | `Won't Have`

---

## Description (native field)

```markdown
## Children
| # | Type | Name | Est. | MoSCoW |
|---|---|---|---|---|
| 1 | INCREMENT | {name} | {time} | Must Have |
| 2 | INCREMENT | {name} | {time} | Must Have |
| 3 | DOC | {subsystem} Reference | — | Must Have |

## Files
- Create: {files to create}
- Modify: {files to modify}

## Input Contract
| From | Schema |
|---|---|
| {predecessor task or parent deliverable input} | {received} |

## Output Contract
| To | Schema |
|---|---|
| {successor task(s) or parent deliverable output} | {produced} |
```

Note: A Task has 3 types of children at the same level:
- **PJ Increment** (1..N) — the testable work
- **PJ Documentation** (1) — reference doc for this Task's subsystem
- **PJ Blocker** (0..N) — reactive, created when blockers are discovered

## Links

- [[blocker]]
- [[deliverable]]
- [[documentation]]
- [[increment]]
