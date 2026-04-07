---
version: "2.0"
status: draft
last_updated: 2026-04-06
topic: agents
source: "captured/A team just solved AI's hardest engineering problem..md"
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
  - so_what_benefit
  - now_what_next
---
# Agent Reliability: Compounding Error and Graph-Constrained Reasoning

> Multi-step agent chains fail exponentially. The fix is not smarter models — it is constrained reasoning paths.

## L1 — Knowledge

### So What? (Relevance)
The math of multi-step agent chains is unforgiving: a 95%-accurate agent across 100 steps yields a 0.6% end-to-end success rate. This is not a model quality problem — it is an architectural one. Understanding this prevents the default response of "upgrade to a bigger model" and points to structural fixes instead. Directly relevant to designing reliable ALPEI × DSBV workflows.

### What Is It?
**Compounding error** is the multiplicative degradation of reliability across sequential agent steps. Each step's error probability multiplies with the next:

```
Accuracy per step: 95%
10-step chain:     0.95^10  = 59.9%
20-step chain:     0.95^20  = 35.8%
50-step chain:     0.95^50  =  7.7%
100-step chain:    0.95^100 =  0.6%
```

**Graph-constrained reasoning** is the architectural response: instead of letting a model reason in open-ended natural language (chain-of-thought), a frontier model draws a structured decision graph once — explicit nodes, defined transitions, terminal states — and a cheaper model executes it deterministically, without improvising.

### What Else?
- **Chain-of-thought (CoT)**: default reasoning mode — model "thinks step by step" in natural language, can wander, hallucinate, build on prior errors
- **Structured prompting / XML scaffolding**: partial constraint — adds formatting but not decision-path enforcement
- **Human-in-the-loop gates**: manual checkpoints that reset error accumulation at each gate
- **Retrieval-Augmented Generation (RAG)**: addresses knowledge gaps, not reasoning drift
- **DSBV phase gates (LTC)**: the human-gate equivalent in the LTC workflow — each G1-G4 transition resets accumulated error before the next phase compounds it

### How Does It Work?
**Standard chain-of-thought:**
```
Prompt → Model reasons freely in natural language
       → Wanders into dead ends
       → Hallucinations compound across steps
       → Each error becomes foundation for next reasoning step
```

**Graph-constrained reasoning (architect + crew pattern):**
```
Step 1 (Frontier model): Draw reasoning graph
       → Explicit decision nodes
       → Defined transitions between nodes
       → Terminal states clearly marked
       → Machine-readable, not prose

Step 2 (Cheaper model): Execute the graph
       → Follows defined paths only
       → Cannot improvise new states
       → Deterministic traversal
       → Errors are bounded to the current node, not propagated
```

The key insight: **the architect draws once, the crew executes without improvising**. The expensive frontier model's job is graph construction, not execution. Execution is deterministic and cheap.

## L2 — Understanding

### Why Does It Work?
Chain-of-thought reasoning is unbounded — the model can generate any next token, including hallucinated states. This freedom is the source of compounding error: each hallucinated state becomes context for the next step.

Graph constraints eliminate that freedom. A model following a structured graph can only transition to explicitly defined next states. A wrong answer at node N cannot create a new hallucinated node N+1 — it can only select among N's defined successors. Error is contained to the current decision, not cascaded.

The architect/crew split works because graph *construction* is the hard reasoning task (requires frontier capability), while graph *execution* is pattern matching against defined paths (can be done cheaply and reliably).

### Why Not?
- **Graph construction quality is the new bottleneck**: if the frontier model draws a wrong or incomplete graph, all downstream execution is constrained to the wrong path. Garbage in, garbage out — just more deterministically.
- **Poorly defined terminal states cause loops**: if the graph lacks clear exit conditions, the executor can get stuck traversing cycles.
- **Not all tasks are graph-reducible**: open-ended creative tasks, novel situations without prior paths, and exploration tasks resist graph pre-specification. Best suited for well-defined, repeatable decision processes.
- **Maintenance overhead**: as the domain evolves, graphs must be updated. Static graphs become stale.
- **Overkill for short chains**: a 3-step agent at 95% accuracy has 85.7% end-to-end reliability — acceptable. Graph overhead only pays off at longer chain lengths.

## L3 — Wisdom

### So What? (Benefit for LTC)
The DSBV phase-gate system is the LTC equivalent of graph-constrained reasoning:
- **Design phase** = frontier model (Opus) draws the "graph" — DESIGN.md with explicit acceptance criteria, phase transitions, and terminal states
- **Build phase** = builder agents (Sonnet) execute against the graph without improvising
- **Validate phase** = reviewer agents (Opus) verify terminal state reached
- **Phase gates (G1-G4)** = human checkpoints that break compounding error at natural boundaries

The architecture already implements the pattern. The insight is to be *more explicit* about this when designing DESIGN.md artifacts — they are reasoning graphs, not just documents.

### Now What? (Next actions)
1. **Write DESIGN.md artifacts with graph explicitness**: acceptance criteria as decision nodes, phase transitions as explicit edges, "done" as a terminal state — not a judgment call
2. **Keep DSBV chains short**: each sub-agent should handle ≤10 meaningful decisions before a human gate resets the accumulation clock
3. **Use the compounding error math when sizing agent tasks**: if a task requires 50+ decisions, it needs intermediate gates, not a longer context window
4. **When a build-phase agent drifts**, the fix is not "better prompting" — it is returning to the Design graph and checking if the graph itself was underspecified

## Sources
- [[karpathy-llm-wiki-pattern]]

## Links
- [[agent-teams-overview]]
- [[agent-teams-best-practices]]
- [[custom-subagents-overview]]
- [[persistence-and-enforcement-synthesis]]
- [[session-management]]
