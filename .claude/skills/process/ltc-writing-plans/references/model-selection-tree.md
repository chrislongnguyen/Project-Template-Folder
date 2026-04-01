# Model Selection Decision Tree

> Source: LTC Execution Pipeline Design Spec §6.2 (Fix 6)
> Use this reference when deciding which model to assign to a task or deliverable.

---

## Task Type → Model Mapping

| Task Type | Recommended Model | Rationale |
|---|---|---|
| Creative + analytical (spec writing, architecture) | **Opus** | Requires deep reasoning, creative synthesis, judgment |
| Structured transform with precision (.exec/ generation) | **Opus lead + Sonnet subs** | Lead needs judgment for structure; subs need precision for templating |
| Mechanical with format compliance (WMS sync) | **Sonnet + deterministic post-validation** | Speed matters; validation catches errors |
| Code implementation following spec | **Sonnet** | Clear instructions reduce need for deep reasoning; cost-efficient |
| Review requiring judgment | **Opus** | Quality assessment requires highest reasoning capability |
| Read-only exploration (codebase scan, file search) | **Haiku** | Cheapest model sufficient for read operations |

---

## Summary by Task Category

### Use Opus for:
- Spec writing and architectural design
- Brainstorming and force analysis (UBS/UDS)
- Plan writing (Stage 3 — architectural reasoning)
- Code and artifact review requiring judgment
- Decisions that require weighing trade-offs

### Use Sonnet for:
- Code implementation when spec is clear
- Template filling and structured output generation
- WMS sync operations (ClickUp, Notion API calls)
- Multi-file refactors with well-defined scope
- Sub-agent work within a structured plan

### Use Haiku for:
- Read-only file exploration and codebase scanning
- Formatting and linting passes
- Simple validation (does file exist, does field match)
- Log parsing and data extraction with no decisions required

---

## Cost-Performance Tradeoff Rule

Use the cheapest model that can reliably complete the task.

**"Reliably"** means: the model produces output that passes the task's AC eval on the first attempt at least 90% of the time.

If a cheaper model requires frequent retries, the net cost exceeds using a more capable model once.

---

## Stage-Level Model Defaults (from §6.4 Context Budget)

| Stage | Default Model | Rationale |
|---|---|---|
| 1 Brainstorm | Opus (per sub-agent group) | Creative synthesis; each group gets fresh context |
| 2 Spec Review | Opus | Judgment required for quality assessment |
| 3 Plan | Opus | Architectural reasoning; decision trees |
| 4 Exec Plan | Opus lead + Sonnet subs | Structure decisions (lead); template filling (subs) |
| 5 Execute | Sonnet | Clear .exec/ file spec reduces reasoning load |
| 6 Test | Haiku (read) + Sonnet (eval) | Read task output cheaply; evaluate with precision |
| 7 Review | Opus | Final quality gate requires highest judgment |

---

## How to Apply

When writing a plan, state the model assignment in the Agent Architecture section:

```
**Agent Architecture:** Sub-Agents — Opus lead for structure decisions; Sonnet subs for 3 template-filling tasks
```

When the model is the default for that stage and task type, you may omit the explicit model name and just state the pattern. Only call out model choices when they deviate from stage defaults.

## Links

- [[DESIGN]]
- [[deliverable]]
- [[simple]]
- [[task]]
