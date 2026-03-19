---
description: Agent system rules for AI agent structural limits and compensation
globs: **/*
---

# Agent System

Full spec: `rules/agent-system.md`

## 8 LLM Truths (structural — not patched by new models)
1. Hallucination is structural (factual accuracy)
2. Context compression is lossy (volume of info)
3. Reasoning degrades on complex tasks (step count)
4. Retrieval is fragile under token limits (precision in noise)
5. Prediction optimises plausibility, not truth
6. No persistent memory across sessions
7. Cost scales with token count
8. Alignment is approximate (rule compliance)

## 7-Component System
EPS (rules) → Input (task context) → EOP (procedures) → Environment (workspace) → Tools (instruments) → Agent (model) → Action (emergent output → diagnose only)

Each component compensates for specific LTs. Action is never configured — trace failures to the other 6.

## 3 Principles
1. **Brake Before Gas** — derisk first, then drive output
2. **Know the Physics** — the 8 LTs are constraints, not bugs; stop trying to change them
3. **Two Operators, One System** — Human (judgment, biases) + Agent (execution, 8 LTs) compensate for each other
