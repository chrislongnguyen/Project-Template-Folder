# PJ Workstream — Template

Parent: PJ Project. Groups Deliverables by iteration/VANA pillar scope.

## Custom Fields

### 🌐 DESIRED OUTCOMES (Objectives) — field `a382a103-456b-41a8-9b2a-8fa15a657ce4`
```
{User} {Verb} {Adverb} {Noun} that is {Adjective}.

→ Verb: {action}
→ Adverb: {how}
→ Noun: {artefact}
→ Adjective: {quality}
```

Scoped to this iteration's pillar:
- Iteration 1 (Concept): Verb + Noun + Sustainability qualities
- Iteration 2 (Prototype): + Efficiency qualities
- Iteration 3 (MVE): + Scalability qualities
- Iteration 4 (Leadership): + Spawned + Hardening

### 🌐 ACCEPTANCE CRITERIA (Key Results) — field `b74bfd0e-f112-4849-af6d-132e65e59b46`
```
Owns from Project:
{List the specific AC IDs this iteration owns}

{AC checklist — only ACs assigned to this iteration}
```

### 🌐 RISK-BASED IMPORTANCE (MoSCoW) — field `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` (dropdown)
Select: `Must Have` | `Should Have` | `Could Have` | `Won't Have`

### 🌐 DELIVERY PHASE — field `4b625634-7006-4eec-8add-8c2b8c04ca3c` (dropdown)
Must match iteration: Iteration 1→1.CONCEPT | Iteration 2→2.PROTOTYPE | Iteration 3→3.MVE | Iteration 4→4.LEADERSHIP

---

## Description (native field)

```markdown
## Deliverables
| # | Deliverable | Tasks | Est. | MoSCoW |
|---|---|---|---|---|
| D{n} | {name} | {count} | {time} | Must Have |

## Iteration Scope
- **Pillar:** {Sustainability / Efficiency / Scalability}
- **Gate:** All I{n} ACs must pass before I{n+1} work begins

## Input Contract
| From | Schema |
|---|---|
| {predecessor workstream or Plan} | {what this iteration receives} |

## Output Contract
| To | Schema |
|---|---|
| {successor workstream(s)} | {what this iteration produces} |
```

## Links

- [[deliverable]]
- [[iteration]]
- [[project]]
- [[schema]]
