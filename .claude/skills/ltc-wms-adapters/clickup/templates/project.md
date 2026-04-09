# PJ Project — Template

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
- [ ] AC-V: {verb action verified — the project's core capability works}
- [ ] AC-N: {artefact exists — all deliverables shipped}
```

### AC Table (full decomposition)

The Project AC table decomposes the VANA into testable criteria with IDs:

Verb ACs:
- [ ] Verb-AC1: {criteria}
Sustainability Adverb ACs (Iteration 1):
- [ ] SAdv-AC1: {criteria}
Efficiency Adverb ACs (Iteration 2):
- [ ] EAdv-AC1: {criteria}
Scalability Adverb ACs (Iteration 3):
- [ ] ScAdv-AC1: {criteria}
Noun ACs:
- [ ] Noun-AC1: {criteria}
Sustainability Adjective ACs (Iteration 1):
- [ ] SAdj-AC1: {criteria}
Efficiency Adjective ACs (Iteration 2):
- [ ] EAdj-AC1: {criteria}
Scalability Adjective ACs (Iteration 3):
- [ ] ScAdj-AC1: {criteria}

Every child item traces back to specific AC IDs from this table.

### 🌐 DEFINITION OF DONE (DoD) — field `5bde1429-9a92-47a8-8345-0dd0b3dc9035`
```
All Must Have PJ Deliverables are Done or Cancelled.
```

### 🌐 RISK-BASED IMPORTANCE (MoSCoW) — field `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` (dropdown)
Select: `Must Have` | `Should Have` | `Could Have` | `Won't Have`

### Other custom fields (set when applicable)
- `🌐 STRATEGIC FOCUS AREA(S)` — FA mapping
- `🌐 DELIVERY PHASE` — iteration phase
- `🌐 Function(s) in Charge` — function label
- `🌐 URL Link` — link to spec or plan
- `🌐 ID / Short Name` — short project code

---

## Description (native field)

```markdown
## Overview
{1-2 sentence project summary}

## Scope
- **In scope:** {what's included}
- **Out of scope:** {what's excluded}

## Workstreams
| Iteration | Name | Deliverables | Pillar | Phase |
|---|---|---|---|---|
| Iteration 1 | {name} | D1, D2, D3 | Sustainability | Concept |
| Iteration 2 | {name} | D4, D5 | Efficiency | Prototype |
| Iteration 3 | {name} | D6, D7 | Scalability | MVE |
| Iteration 4 | {name} | D8 | Hardening | Leadership |

## Execution Topology (mandatory)

Shows which Deliverables/Tasks run in parallel vs sequential.
Any agent entering a new context reads this to know how to spawn sub-agents.

```
{Dependency diagram — example below}

D1 Foundation ──→ D2 Embedding ──→ D3 Manager ──┬──→ D4 Context
                                                 ├──→ D5 CLI
                                                 └──→ D6 Import
                                   D7 Hooks (after D5+D6) ──→ D8 Acceptance

Parallel lanes: [D4, D5, D6] can run simultaneously after D3
Critical path:  D1 → D2 → D3 → D6 → D7 → D8
Wall-clock with 3 agents: D1 → D2 → D3 → [D4|D5|D6] → D7 → D8
```

**For agents:** Use this diagram to decide:
- Which Deliverables to dispatch as parallel sub-agents
- Which must wait for a predecessor to complete
- The minimum number of sequential steps (critical path)

## Key Decisions
| Decision | Answer |
|---|---|
| {decision} | {answer} |

## Input Contract
| From | Schema |
|---|---|
| Implementation Plan + Spec | {plan file path, spec file path} |

## Output Contract
| To | Schema |
|---|---|
| All Workstreams | {system components, interfaces, artefacts} |

## References
- Spec: {link}
- Plan: {link}

## Time Summary
- **Total est. time:** {sum} hrs
- **Deliverables:** {count} | **Tasks:** {count} | **Increments:** {count}
- **Critical path:** {N} sequential steps
- **Parallel lanes:** {description of what can run simultaneously}
```

## Links

- [[AGENTS]]
- [[iteration]]
- [[schema]]
