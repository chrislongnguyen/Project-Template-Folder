---
name: learn-research
description: >
  Researches all topics for a learning subject using parallel sub-agents.
  One sub-agent per topic, each producing a 6-section UEDS research output file.
  Use after /learn:input completes.
argument-hint: <system-slug>
allowed-tools: Read, Glob, Write, Bash, Agent
---

# /learn:research — Parallel Research Pipeline

You are running deep research for all active topics in a learning subject.
Spawn one sub-agent per topic — all topics launch simultaneously.

## Arguments

Parse `{system-slug}` from the invocation (e.g., `data-foundation`).
If missing, check for a single `1-ALIGN/learning/input/learn-input-*.md` file and use it. If ambiguous, list and ask.

---

## Injected Context

### Learn Input
!`cat 1-ALIGN/learning/input/learn-input-*.md 2>/dev/null | head -120`

---

## Pre-Checks

1. Find `1-ALIGN/learning/input/learn-input-{system-slug}.md`. If missing: "Run /learn:input first."
2. Extract from learn-input: `system_name`, `system-slug`, `eo`, `user_persona_r`, `user_persona_a`, `research_domains`, topics table (active rows), `topic_depth`.
3. Check `1-ALIGN/learning/research/{system-slug}/` — if files already exist, report which topics are done. Ask: "Re-run all, or only missing topics?"

---

## Step 1: Determine Research Depth

| Topic Depth | Search Depth | Min Searches | Min Sources |
|---|---|---|---|
| T0 | Mid | 5 | 8 |
| T0-T2 | Deep | 8 | 12 |
| T0-T5 | Deep | 8 | 12 |

Report to user:
```
Research depth: {mid/deep} ({min_searches} search angles, {min_sources}+ sources per topic)
Topics to research: {count}
Execution: {count} parallel sub-agents
```

---

## Step 2: Build Research Queries

For each active topic, interpolate the research prompt template below with values from learn-input.

**Research Prompt Template (interpolate per topic):**

```
Research the following system/subject comprehensively for an Operational Excellence knowledge framework.
Organize your research to map directly to 6 sections.

## System: {system_name} — {topic} ({topic_id})

## Effective Outcome (EO)
{eo}

## Perspective
Research from TWO perspectives simultaneously:
- Responsible (R) — who does the work: {raci_r}
- Accountable (A) — who owns the outcome: {raci_a}

Every finding should note whether it primarily affects R, A, or both.

## Research Domains
{research_domains}

---

## OUTPUT STRUCTURE (6 Sections — follow this exactly)

### Section 1: Overview & Summary (maps to P0)
- What is {topic}? Precise definition — what it is AND what it is not.
- Why does it matter? Relevance to the EO.
- What does success look like? What does failure look like?
- For R: how does {topic} affect the Responsible actor's daily work?
- For A: how does {topic} affect the Accountable actor's outcomes?

### Section 2: Ultimate Blockers — Root Cause Analysis (maps to P1)
- What is the ROOT blocker preventing the EO? Not symptoms — deepest systemic cause.
- Causal chain: Root Blocker → what drives it harder → what drives THAT
- Counter-chain: Root Blocker → what disables it → what enables THAT
- For R: specific blockers the Responsible actor faces
- For A: specific blockers the Accountable actor faces
- Go at least 3 levels deep. Surface-level answers are insufficient.

### Section 3: Ultimate Drivers — Success Mechanism Analysis (maps to P2)
- What is the ROOT driver enabling the EO? Deepest systemic enabler.
- Causal chain: Root Driver → what amplifies it → what amplifies THAT
- Counter-chain: Root Driver → what blocks it → what enables that blocker
- For R: specific drivers the Responsible actor leverages
- For A: specific drivers the Accountable actor leverages
- Go at least 3 levels deep. Show the mechanism, not just the label.

### Section 4: Governing Principles (maps to P3)
Bucket into three categories:
**Sustainability (S):** principles ensuring correctness, safety, risk management
**Efficiency (E):** principles minimizing time, cost, cognitive load, waste
**Scalability (Sc):** principles enabling repeatability, growth, extensibility
For each: state it, explain WHY it works (mechanism), cite source framework if available.

### Section 5: Tools & Environment — 3 Causal Layers (maps to P4)
**Layer 1 — Foundational:** base infrastructure that must exist first
**Layer 2 — Operational:** working environment built on Layer 1
**Layer 3 — Enhancement:** amplifiers requiring Layers 1+2
For each layer: specific tools/platforms, why they belong there, dependencies.

### Section 6: Operating Procedure — Steps to Apply (maps to P5)
**Phase A — DERISK (do first):** steps that neutralize Ultimate Blockers from Section 2
**Phase B — OPTIMIZE (after DERISK):** steps that amplify Ultimate Drivers from Section 3
Each step: what to do, input needed, output produced, what can go wrong.

---

## Research Guidelines
- DEPTH over breadth — causal understanding, not surface overviews
- CITE specific frameworks, tools, methodologies, research where applicable
- CONCRETE examples — real tools, real patterns, real anti-patterns
- DUAL PERSPECTIVE — always cover both R and A viewpoints
- NO generic advice — specify WHICH practices and WHY they work mechanically
```

---

## Step 3: Run Research (Parallel Sub-Agents)

**CRITICAL: Sub-agents must NOT invoke the `/deep-research` skill.** Use the methodology directly.

Spawn one sub-agent per topic using the Agent tool. **All topics launch simultaneously** in a single message with multiple Agent tool calls.

Each sub-agent receives this prompt (interpolate per topic):

```
You are a research agent. Research ONE topic and save a structured output file.
Do NOT invoke the /deep-research skill. Follow these instructions exactly.

## Your Task
{INTERPOLATED_RESEARCH_QUERY from Step 2}

## Research Methodology

### Phase 1: Decompose
Break the query into {min_searches} distinct search angles targeting different facets.

### Phase 2: Search
Run WebSearch for each angle. For each result:
1. Review top results
2. WebFetch the 2-3 most relevant pages in full
3. Extract key findings, data points, frameworks
4. Record source URL and credibility (academic > industry report > vendor blog)
Target: {min_sources}+ unique sources total.

### Phase 3: Synthesize
Organize findings into the 6-section structure from the research query.
Rules:
- Every factual claim MUST cite a source as [N] in the same sentence
- Distinguish FACTS (from sources) from SYNTHESIS (your analysis): use "[ANALYSIS]" prefix
- If a section has thin coverage, write what you have and flag with [NEEDS REVIEW]
- Go 3+ levels deep on causal chains (Sections 2 and 3)
- Cover BOTH R and A perspectives in every section

### Phase 4: Write Output
Save to: 1-ALIGN/learning/research/{system_slug}/T{topic_number}-{topic_slug}.md

File must contain:
1. YAML frontmatter (format below)
2. All 6 sections with exact headings:
   - "## Section 1: Overview & Summary"
   - "## Section 2: Ultimate Blockers — Root Cause Analysis"
   - "## Section 3: Ultimate Drivers — Success Mechanism Analysis"
   - "## Section 4: Governing Principles"
   - "## Section 5: Tools & Environment — 3 Causal Layers"
   - "## Section 6: Operating Procedure — Steps to Apply"
3. "## Sources" bibliography with all [N] citations and full URLs

YAML frontmatter:
---
topic: "{topic_name}"
topic_id: "{topic_id}"
system: "{system_name}"
eo: "{eo}"
raci_r: "{raci_r}"
raci_a: "{raci_a}"
timestamp: "{ISO-8601 now}"
status: "completed"
source_count: {number of unique sources}
search_depth: "{mid/deep}"
researcher: "learn-research-agent"
---

## Anti-Hallucination Rules
- Use "According to [1]..." — never "Research suggests..."
- If no source found, say "No sources found for X" — never fabricate
- Mark speculation: "[ANALYSIS]" prefix
- If fewer than {min_sources} sources found, set status to "partial"

## Failure Handling
- If a search angle returns nothing useful, try 2 alternative phrasings
- Always write the output file even if partial — never silently fail
- Sections with no coverage: "[NEEDS REVIEW] Insufficient research for this section."

## Completion Report
After writing, report: file path, source count, any [NEEDS REVIEW] sections, status.
```

**Sub-agent configuration:**
- `subagent_type`: `general-purpose`
- `description`: `"Research T{n} {topic_name}"`
- `run_in_background`: `false`

---

## Step 4: Verify Output

After all sub-agents complete:

1. File exists at correct path
2. File > 2000 chars
3. Frontmatter `status` = "completed" (flag any "partial")
4. All 6 section headings present
5. `source_count` ≥ 8 (flag if lower)
6. Count `[NEEDS REVIEW]` markers

If any topic is partial or missing:
```
⚠ Topics needing attention:
  T{n} {topic} — partial ({N} sources, Section {X} flagged)

Options:
  1. Retry at deeper search depth
  2. Proceed with partial (learn:structure will flag gaps)
  3. Manually supplement before proceeding
```

---

## Completion Report

```
/learn:research complete.

System:       {system_name}
Search depth: {mid/deep}
Topics:       {completed}/{total} completed
Output:       1-ALIGN/learning/research/{system-slug}/

Files:
  T0-{slug}.md — {size} chars, {N} sources ✓
  ...

Quality:
  All sections present:  {yes/no}
  Avg source count:      {avg} per topic
  [NEEDS REVIEW] flags:  {count}

Next: /learn:structure {system-slug} 0
```

---

## Rules

- Do NOT invoke the `/deep-research` skill — format collision with 6-section UEDS structure
- Do NOT run topics sequentially — always spawn parallel sub-agents
- Do NOT re-run completed topics without asking user first
- Do NOT proceed to /learn:structure if any topic has status "partial" without user acknowledgment
- Create `1-ALIGN/learning/research/{system-slug}/` directory if it doesn't exist before spawning agents

---

## References

- `1-ALIGN/learning/skills/learn-research/SKILL.md` — this skill (full spec)
- `1-ALIGN/learning/skills/learn-pipeline/references/research-prompt-template.md` — research query template
- `1-ALIGN/learning/input/learn-input-{system-slug}.md` — system identity, personas, topics, research domains
