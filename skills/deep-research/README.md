# Deep Research Skill

Multi-source research engine with 4 depth modes, Blue-Red team architecture,
and the 12-question CODE framework. Outputs professional reports in Markdown,
McKinsey-style HTML, and PDF -- all in LTC brand.

## What

- **4 depth modes** -- lite, mid, deep, full -- all answer the same 12 CODE questions.
  Depth varies per question; question count does not.
- **CODE framework** spans 12 questions across 4 stages:
  Knowledge (what exists) -> Understanding (how it works) -> Wisdom (what it means) -> Expertise (what to do).
  This follows the LTC Learning Hierarchy (ELF), building insight progressively instead of flat "Finding 1, 2, 3."
- **Blue-Red team** (deep/full modes): Blue team (3 researchers) builds the case.
  Red team (1 critic) tries to disprove it. Claims that survive active falsification are more credible.
- **Automated validation**: 9-check report validator, citation verification, source credibility scoring.

## Why This Architecture

| Design choice | Compensates for | Explanation |
|---|---|---|
| Sub-agents per mode | LT-3 (reasoning degradation) | 12 questions is too much for one agent context window |
| Blue-Red team | Radical falsification | Active disproof > passive review for credibility |
| Sonnet for research, Opus for synthesis | LT-7 (token cost) | Don't spend Opus tokens on retrieval tasks |
| ELF-ordered questions | Flat output bias | Progressive K->U->W->E structure mirrors how humans learn |

## How

1. All modes answer ALL 12 CODE questions. Depth per question scales with mode.
2. Sub-agents do the retrieval work: 2 for lite, 3 for mid, full agent team for deep/full.
3. Blue team (3 researchers on Sonnet) gathers and builds the case.
4. Red team (1 critic on Opus) attacks it -- radical falsification.
5. Lead agent (Opus) synthesizes surviving claims into the final report.
6. Validator runs 9 automated checks; citation verifier confirms sources.
7. Output rendered as Markdown + McKinsey HTML + PDF.

## Quick Reference

| Mode | Depth/Q | Agents | Sources | Tokens | Time |
|---|---|---|---|---|---|
| lite | 1-2 sentences | 2 sub + Lead | 5-10 | ~70K | 2-5 min |
| mid | 1-2 paragraphs | 3 sub + Lead | 10-20 | ~200K | 5-10 min |
| deep | Full analysis | Blue x3 + Red + Lead | 20-30 | ~350K | 10-20 min |
| full | Maximum rigor | Blue x3 + Red + Lead + iterations | 30-50 | ~600K | 20-45 min |

## Usage

```
Use deep research to analyze the state of quantum computing in 2025
Use deep research in full mode to compare PostgreSQL vs Supabase
```

## File Structure

```
deep-research/
  SKILL.md                         # Main skill definition (agent reads this)
  templates/
    _TEMPLATE.md                   # 12-question CODE template
    report_template.md             # Report structure template
    mckinsey_report_template.html  # McKinsey-style HTML output
    SPIKE_TEMPLATE.md              # Spike/exploration template
  scripts/
    research_engine.py             # Core orchestration engine
    validate_report.py             # 9-check report validator
    verify_citations.py            # Citation verification
    verify_html.py                 # HTML output validation
    source_evaluator.py            # Source credibility scoring
    citation_manager.py            # Citation tracking + bibliography
    md_to_html.py                  # Markdown to McKinsey HTML converter
  reference/
    methodology.md                 # Research methodology spec
    report-generation.md           # Report generation procedure
    effective-agent-principles-registry.md
  tests/
    fixtures/                      # valid_report.md, invalid_report.md
```

## Model Selection

| Role | Model | Rationale |
|---|---|---|
| Research sub-agents | Sonnet | Fast retrieval, lower token cost |
| Synthesis lead | Opus | Complex reasoning across all 12 questions |
| Red team critic | Opus | Adversarial critique requires strongest reasoning |
