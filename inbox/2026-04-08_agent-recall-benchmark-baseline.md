---
date: "2026-04-08"
type: capture
source: conversation
tags: [memory-vault, qmd, benchmark, recall-quality]
---

# Agent Recall Benchmark — Baseline Design

> 2-layer measurement system: Layer 1 (script) generates deterministic metrics, Layer 2 (LLM-as-judge) scores relevance. Run before/after any vault change to measure impact.

## Purpose

Measure QMD recall quality with a repeatable, automated benchmark. Produces a numeric score that can be compared across vault states (before cleanup, after cleanup, after policy change).

## Architecture

```
Layer 1: SCRIPT (deterministic, cheap, fast)
──────────────────────────────────────────
  Input:  10 canonical test queries (fixed, never change)
  Action: Run each query against QMD (lex + vec)
  Output: Raw results — {query, results[], scores[], doc_count, avg_score}
  Cost:   ~0 (QMD is local, no LLM needed)
  Time:   <5 seconds

Layer 2: LLM-AS-JUDGE (qualitative, Haiku, cheap)
──────────────────────────────────────────────────
  Input:  Layer 1 output (query + top-5 results per query)
  Action: For each result, LLM rates: relevant (1) / partially relevant (0.5) / noise (0)
  Output: Per-query precision score + overall recall quality score
  Cost:   ~10K tokens (Haiku, 10 queries × 5 results × ~200 tokens/judgment)
  Time:   ~30 seconds

          ┌──────────────┐
          │ 10 Test      │
          │ Queries      │
          └──────┬───────┘
                 │
                 ▼
          ┌──────────────┐
          │ Layer 1:     │
          │ QMD Search   │──→ Raw scores, doc counts, avg similarity
          │ (script)     │
          └──────┬───────┘
                 │ top-5 results per query
                 ▼
          ┌──────────────┐
          │ Layer 2:     │
          │ LLM Judge    │──→ Precision@5, noise ratio, overall quality
          │ (Haiku)      │
          └──────┬───────┘
                 │
                 ▼
          ┌──────────────┐
          │ Benchmark    │
          │ Report       │──→ Stored in vault, compared over time
          │ (.md file)   │
          └──────────────┘
```

## 10 Canonical Test Queries

Fixed set — never change these. They represent the recall scenarios that matter most.

| # | Query | Intent | Expected good result |
|---|-------|--------|---------------------|
| 1 | "DSBV Design phase approval gate" | Process recall | Session where G1 gate was discussed/approved |
| 2 | "session ETL decision filter" | Technical decision | Session where ETL v1.1 fixes were designed |
| 3 | "Vinh ALPEI framework philosophy" | Organizational knowledge | Framework overview or session discussing Vinh's direction |
| 4 | "memory pruning derivable info" | Operational decision | Session where 14 files were deleted with rationale |
| 5 | "skill sync user scope project scope" | Architecture decision | Session where copy-on-release strategy was chosen |
| 6 | "Obsidian Bases dashboard filter" | Feature design | Session where Bases C1 master dashboard was designed |
| 7 | "naming convention UNG separator grammar" | Reference | Naming convention doc or session discussing R1-R7 rules |
| 8 | "multi-agent orchestration 4 MECE agents" | Architecture | Session where agent system was designed (planner/builder/reviewer/explorer) |
| 9 | "hook enforcement PreToolUse sub-agent gap" | Bug/limitation | Session discussing GitHub #40580 platform limitation |
| 10 | "three pillars sustainability efficiency scalability" | Philosophy | Framework doc or session applying S>E>Sc analysis |

## Layer 1: Script

```python
#!/usr/bin/env python3
# scripts/recall-benchmark.py
# Layer 1: deterministic QMD query + Layer 2: LLM judge scoring

import json
import subprocess
import sys
from datetime import datetime

QUERIES = [
    {"query": "DSBV Design phase approval gate", "intent": "Process recall"},
    {"query": "session ETL decision filter", "intent": "Technical decision"},
    {"query": "Vinh ALPEI framework philosophy", "intent": "Organizational knowledge"},
    {"query": "memory pruning derivable info", "intent": "Operational decision"},
    {"query": "skill sync user scope project scope", "intent": "Architecture decision"},
    {"query": "Obsidian Bases dashboard filter", "intent": "Feature design"},
    {"query": "naming convention UNG separator grammar", "intent": "Reference"},
    {"query": "multi-agent orchestration 4 MECE agents", "intent": "Architecture"},
    {"query": "hook enforcement PreToolUse sub-agent gap", "intent": "Bug/limitation"},
    {"query": "three pillars sustainability efficiency scalability", "intent": "Philosophy"},
]

def run_qmd_query(query: str, intent: str) -> dict:
    """Run a QMD query via MCP and return top-5 results."""
    # This would call qmd CLI or MCP tool
    # For now, structured as the expected interface
    searches = json.dumps([
        {"type": "lex", "query": query},
        {"type": "vec", "query": query},
    ])
    # subprocess.run(["qmd", "query", "--searches", searches, ...])
    # Returns: {results: [{file, score, snippet}], total_docs, avg_score}
    pass

def score_result(query: str, intent: str, result: dict) -> float:
    """Layer 2: LLM-as-judge scores a single result.
    Returns: 1.0 (relevant), 0.5 (partial), 0.0 (noise)
    """
    # Call Haiku with structured prompt:
    # "Given query '{query}' with intent '{intent}',
    #  rate this result: {result['snippet'][:200]}
    #  Answer ONLY: relevant | partial | noise"
    pass

def run_benchmark(label: str = "baseline"):
    """Full benchmark run."""
    timestamp = datetime.now().strftime("%Y-%m-%d-%H%M")
    results = []

    for q in QUERIES:
        qmd_results = run_qmd_query(q["query"], q["intent"])
        top5 = qmd_results["results"][:5]

        scores = []
        for r in top5:
            s = score_result(q["query"], q["intent"], r)
            scores.append(s)

        precision = sum(scores) / len(scores) if scores else 0
        results.append({
            "query": q["query"],
            "intent": q["intent"],
            "doc_count": qmd_results["total_docs"],
            "avg_qmd_score": qmd_results["avg_score"],
            "precision_at_5": precision,
            "noise_count": scores.count(0.0),
            "top5_files": [r["file"] for r in top5],
        })

    # Aggregate
    overall_precision = sum(r["precision_at_5"] for r in results) / len(results)
    total_noise = sum(r["noise_count"] for r in results)
    avg_doc_count = sum(r["doc_count"] for r in results) / len(results)

    report = {
        "label": label,
        "timestamp": timestamp,
        "overall_precision_at_5": round(overall_precision, 3),
        "total_noise_results": total_noise,
        "avg_docs_per_query": round(avg_doc_count, 1),
        "per_query": results,
    }

    return report
```

## Output Format (Benchmark Report)

```yaml
---
type: recall-benchmark
label: baseline  # or "post-cleanup", "post-retention-policy"
date: 2026-04-08
qmd_doc_count: 1848
---

# Recall Benchmark: baseline — 2026-04-08

## Summary
| Metric | Value |
|--------|-------|
| Overall Precision@5 | 0.72 |
| Total noise results (of 50) | 9 |
| Avg QMD docs per query | 1848 |

## Per-Query Results
| # | Query | Precision@5 | Noise | Top Result |
|---|-------|------------|-------|------------|
| 1 | DSBV Design phase approval gate | 0.80 | 1 | sessions/2026-04-05-govern-dsbv.md |
| 2 | session ETL decision filter | 1.00 | 0 | sessions/6-4.../2026-04-07.md |
| ... | | | | |

## Noise Analysis
- 5/9 noise results were auto-generated session summaries (type: auto-summary)
- 3/9 noise results were from orphaned project dirs
- 1/9 noise result was a duplicate ETL aggregate
```

## How to Use

```bash
# Run baseline (before any vault change)
python3 scripts/recall-benchmark.py --label baseline --output vault/07-Claude/benchmarks/

# Make vault changes (cleanup, retention policy, etc.)

# Run post-change measurement
python3 scripts/recall-benchmark.py --label post-cleanup --output vault/07-Claude/benchmarks/

# Compare
python3 scripts/recall-benchmark.py --compare baseline post-cleanup
```

## Comparison Output

```
RECALL BENCHMARK COMPARISON: baseline → post-cleanup

| Metric | Baseline | Post-Cleanup | Delta |
|--------|----------|-------------|-------|
| Precision@5 | 0.72 | 0.88 | +22% ↑ |
| Noise results | 9/50 | 2/50 | -78% ↓ |
| QMD doc count | 1848 | 612 | -67% ↓ |

Per-query changes:
  Q3 (Vinh ALPEI): 0.40 → 0.80 (+100%) — orphaned sessions removed
  Q9 (hook gap):   0.60 → 1.00 (+67%)  — auto-summaries deduplicated
  Q1 (DSBV gate):  0.80 → 0.80 (=)     — no change

VERDICT: Cleanup improved recall precision by 22% while reducing index size by 67%.
```

## What This Enables

| Use case | How benchmark helps |
|---|---|
| Vault cleanup | Before/after measurement proves noise reduction |
| Retention policy tuning | Adjust age/importance thresholds, re-run, measure |
| QMD config changes | Change minScore, collection weights, re-run, measure |
| `/recall-tune` validation | Tune injection params, benchmark proves improvement |
| New hook/ETL changes | Any change to capture pipeline → benchmark regression test |

## Implementation Phases

```
Phase 0: THIS FILE (design + 10 queries) ← done
Phase 1: Build scripts/recall-benchmark.py (Layer 1 QMD + Layer 2 Haiku judge)
Phase 2: Run baseline on current vault state
Phase 3: Vault cleanup (parallel explorers + builder)
Phase 4: Run post-cleanup benchmark → compare → report
Phase 5: Encode retention policy → hook or cron
```

## Decision Criteria

| Precision@5 | Verdict |
|-------------|---------|
| < 0.50 | BAD — more noise than signal, urgent cleanup needed |
| 0.50–0.70 | FAIR — noticeable noise, cleanup worthwhile |
| 0.70–0.85 | GOOD — some noise, marginal improvement expected |
| 0.85–0.95 | GREAT — low noise, cleanup is polish not necessity |
| > 0.95 | EXCELLENT — vault is clean, focus elsewhere |

## Links

- [[AGENTS]]
- [[DESIGN]]
- [[SKILL]]
- [[architecture]]
- [[dashboard]]
- [[project]]
