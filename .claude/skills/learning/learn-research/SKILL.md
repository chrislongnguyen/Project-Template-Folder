---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
name: learn-research
description: >
  Use when /learn:input is complete and all active topics need parallel research.
  Spawns one sub-agent per topic against the shared research methodology.
argument-hint: <system-slug>
allowed-tools: Read, Glob, Write, Bash, Agent
---
# /learn:research — Parallel Research Pipeline

Spawn one sub-agent per topic — all topics launch simultaneously.

> Load `_genesis/templates/RESEARCH_METHODOLOGY.md` before executing research.

## Arguments

Parse `{system-slug}` from the invocation. If missing, check for a single `1-ALIGN/learning/input/learn-input-*.md` file. If ambiguous, list and ask.

---

## Pre-Checks

1. Find `1-ALIGN/learning/input/learn-input-{system-slug}.md`. If missing: "Run /learn:input first."
2. Extract: `system_name`, `system-slug`, `eo`, `user_persona_r`, `user_persona_a`, `research_domains`, topics table (active rows), `topic_depth`.
3. Check `1-ALIGN/learning/research/{system-slug}/` — if files exist, report done topics. Ask: "Re-run all, or only missing?"

---

## Step 1: Determine Research Depth

| Topic Depth | Search Depth | Min Searches | Min Sources |
|---|---|---|---|
| T0 | Mid | 5 | 8 |
| T0-T2 | Deep | 8 | 12 |
| T0-T5 | Deep | 8 | 12 |

Report: depth, topic count, parallel agent count.

---

## Step 2: Build Research Queries

For each active topic, interpolate the sub-agent prompt from **[references/research-agent-prompt.md](references/research-agent-prompt.md)** with learn-input values.

---

## Step 3: Run Research (Parallel Sub-Agents)

Launch 1 Agent tool call per topic in a SINGLE message — all topics research simultaneously.

Each sub-agent receives the interpolated prompt from `references/research-agent-prompt.md`. Sub-agent config:
- `subagent_type`: `general-purpose`
- `description`: `"Research T{n} {topic_name}"`
- `run_in_background`: `false`

### Tool Escape Hatches

| Tool | Fallback | Flag |
|---|---|---|
| EXA unavailable | WebSearch for all queries | — |
| WebSearch unavailable | QMD (local KB) only | `local-sources-only` |
| QMD unavailable | Web sources only | `no-local-kb` |
| ALL tools unavailable | **STOP** — report to user, do not generate empty research | — |

---

## Step 4: Verify Output

After all sub-agents complete, verify each topic:

1. File exists at `1-ALIGN/learning/research/{system-slug}/T{n}-{topic}.md`
2. File > 2000 chars
3. Frontmatter `status` = "completed" (flag any "partial")
4. All 6 section headings present
5. `source_count` checked against gate below
6. Count `[NEEDS REVIEW]` markers

<HARD-GATE>
Source count gate: Each topic must have >=8 unique sources.
URL spot-check: Verify >=2 URLs per topic are accessible (WebFetch or crawl).
If source count <8 -> block progression, report to user with option to:
  (a) re-research with different queries
  (b) proceed with flag "limited-sources" in research file frontmatter
</HARD-GATE>

If any topic is partial or missing, report (ID, name, source count, flagged sections) and offer: (1) retry deeper, (2) proceed with partial, (3) manually supplement.

---

## Step 5: Completion Report

Report: system name, search depth, topics completed/total, per-file stats (chars, source count, status), quality summary. End with `Next: /learn:structure {system-slug} 0`.

---

## Research Output Format (6 sections per topic)

Output path: `1-ALIGN/learning/research/{system-slug}/T{n}-{topic}.md`

1. Overview (system context)
2. Blockers (failure modes, risks)
3. Drivers (enablers, leverage points)
4. Principles (compensating strategies)
5. Tools/Environment (infrastructure, tooling)
6. Procedure (steps, sequences)

Full prompt template with frontmatter spec: [references/research-agent-prompt.md](references/research-agent-prompt.md)

---

## Gotchas

See [gotchas.md](gotchas.md) for known failure patterns.

---

## Rules

- Do NOT invoke the `/deep-research` skill — format collision with 6-section structure
- Do NOT run topics sequentially — always spawn parallel sub-agents
- Do NOT re-run completed topics without asking user first
- Do NOT proceed to /learn:structure if any topic has status "partial" without user acknowledgment
- Create output directory before spawning agents

---

## References

- `references/research-agent-prompt.md` — full sub-agent prompt template with 6-section structure
- `_genesis/templates/RESEARCH_METHODOLOGY.md` — shared methodology (multi-angle search, verification, anti-hallucination)
- `1-ALIGN/learning/input/learn-input-{system-slug}.md` — system identity, personas, topics
