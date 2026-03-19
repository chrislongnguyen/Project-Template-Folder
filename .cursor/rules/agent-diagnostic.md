---
description: Agent diagnostic framework for troubleshooting agent output failures
globs: **/*
---

# Agent Diagnostic

Full spec: `rules/agent-diagnostic.md`

## Blame Diagnostic — trace in this order, always
1. **EPS** — rules cover this case? Too verbose (LT-7)?
2. **Input** — context complete and unambiguous? Scope explicit?
3. **EOP** — procedure appropriate? Steps well-scoped? Right skill triggered?
4. **Environment** — context window sufficient? Permissions correct?
5. **Tools** — right tools available? Returning good data? Too many loaded?
6. **Agent** — only after 1-5: is the model genuinely underpowered?

## Derisk Checklist (30 seconds before ANY delegation)
1. List what can go wrong with this specific task
2. Map each risk: `Risk → Which LT → Which component compensates → Is it configured?`
3. If any component unconfigured for a known risk → fix before delegating

## Common Symptom Lookup
| Symptom | Check First |
|---|---|
| Incorrect facts stated confidently | EPS (citations required?), Tools (verification?), Input (source material?) |
| Loses track mid-task | EPS token footprint, Environment context budget |
| Completes wrong task | Input (ambiguous?), EOP (wrong skill triggered?) |
| Shallow/circular reasoning | EOP (steps too large?), Environment (extended thinking?) |
| Wrong tool selection | Tools (too many?), EOP (tool guidance?) |
| Director rejects correct output | Human UBS — System 1 biases overriding evaluation |
