---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
name: Research Methodology
description: Shared research protocols — multi-angle search, source verification, anti-hallucination. Imported by any skill that performs research.
type: template
work_stream: learn
stage: design
sub_system: 
---
# Research Methodology

Three concern-based protocols for any research skill. Import the section(s) you need.

---

## 1. Multi-Angle Search Protocol

### Query Decomposition

Before searching, decompose the research question into 5-10 independent search angles:

1. **Core topic** (semantic search) — meaning-based exploration of the main concept
2. **Technical details** (keyword search) — specific terms, implementations, specifications
3. **Recent developments** (date-filtered) — what changed in the last 12-18 months
4. **Academic/formal sources** — papers, research, institutional analysis
5. **Alternative perspectives** — competing approaches, criticisms, contrarian views
6. **Quantitative evidence** — data, metrics, benchmarks, statistics
7. **Industry/commercial analysis** — market trends, adoption, real-world usage
8. **Failure modes & limitations** — known problems, edge cases, critical analysis

### Parallel Execution

Execute ALL searches in a single message with multiple concurrent tool calls. Never serialize searches that can run in parallel. Route each angle to the best available tool:

- **Semantic search** — meaning-based, conceptual exploration
- **Keyword search** — exact terms, breaking news, domain-filtered queries
- **Site crawl** — deep extraction from known high-value URLs

### Source Diversity Requirements

Every research output must demonstrate diversity across four dimensions:

| Dimension | Minimum |
|-----------|---------|
| **Source types** | 3+ (academic, industry, news, technical docs, government) |
| **Temporal** | Mix of recent + foundational older sources |
| **Perspective** | Proponents + critics + neutral analysis |
| **Geographic** | Not concentrated in a single region |

---

## 2. Source Verification Protocol

### Cross-Reference Verification

Every core claim requires **3+ independent sources** confirming it. Independent means different organizations, not the same press release rewritten.

### Single-Source Flagging

Any claim supported by only one source must be explicitly flagged:
- Mark as `[single-source]` in working notes
- Either find corroboration, move to Limitations, or caveat inline

### Credibility Assessment

Assess each source on a rough scale:

| Tier | Score Range | Examples |
|------|-------------|----------|
| High | 80-100 | Peer-reviewed papers, official documentation, institutional reports |
| Medium | 50-79 | Established news outlets, industry analysis, conference talks |
| Low | 0-49 | Blog posts, forums, social media, anonymous sources |

Low-credibility sources require additional verification before supporting any claim.

### Contradiction & Uncertainty Handling

- Document contradictions explicitly — do not silently pick one side
- Note consensus vs. active debate areas
- When sources disagree, present both positions with evidence strength

### Gate

Do not proceed to synthesis until:
- Core claims have 3+ independent sources
- Single-source claims are flagged
- Source credibility has been assessed

---

## 3. Anti-Hallucination Protocol

### Adaptive Quality Gate (FFS Pattern)

"First Finish Search" — proceed to the next phase when a quality threshold is met, not when a timer expires. Define your threshold as a combination of:

- **Source count** — enough sources to triangulate
- **Average credibility** — sources are trustworthy
- **Coverage** — search angles are adequately covered

If the threshold is met early, continue background searches for depth. If not met after exhaustive search, report the limitation and ask the user.

### Credibility Tracking

- Score every source at collection time (not retroactively)
- Flag low-credibility sources for additional verification
- Prioritize high-credibility sources for core claims
- Never cite a single low-credibility source as sole evidence

### Red Team Critique

After synthesis, challenge your own output with these questions:

1. **What's missing?** — gaps in coverage, unstated assumptions
2. **What could be wrong?** — weak evidence, logical leaps
3. **What alternative explanations exist?** — competing theories
4. **What biases might be present?** — selection bias, recency bias, source bias
5. **What counterfactuals should be considered?** — "what if the opposite were true?"

**A critique that finds zero issues is a failed critique.** LLMs optimize for plausible over correct — the critique exists to challenge this tendency.

### Evidence-Based Claims Only

- Every factual claim must cite a specific source from the current session
- Never rely on parametric (training data) memory for factual claims
- No single-source unsupported claims in final output
- When evidence is insufficient, say so — do not fill gaps with confident-sounding prose
