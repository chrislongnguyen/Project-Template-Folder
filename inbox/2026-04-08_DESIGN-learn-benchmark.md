---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: design
work_stream: 5-IMPROVE
---

# DESIGN: LEARN Skills Benchmark Suite

## Context

7 LEARN skills form a 6-state pipeline (input → research → structure → review → spec → complete).
Before deciding whether agents need LEARN-specific awareness (Item 2 from I2 gap list),
we need empirical data on whether the skills already handle S × E × Sc correctly.

## Test Architecture — 3 Layers

| Layer | What | Method | Cost | Determinism |
|-------|------|--------|------|-------------|
| L1 (static) | Contract validation on SKILL.md files | Python parses YAML frontmatter + regex on body | $0 | 100% |
| L2 (fixture) | Pipeline state routing correctness | Python creates mock fs states, tests routing logic | $0 | 100% |
| L3 (judge) | Semantic compliance + cross-skill coherence | Opus reads SKILL.md, scores structured rubric | ~$2-3 | Probabilistic (3-run majority) |

## Skills Under Test

| Skill | Role | Dispatches Agents? | Interactive? |
|-------|------|--------------------|-------------|
| /learn | Orchestrator — state detection + routing | No (Skill calls only) | No |
| /learn:input | 9-question interview → learn-input file | No | Yes (human) |
| /learn:research | Parallel research per topic | Yes (ltc-explorer) | No |
| /learn:structure | Generate P0-P5 pages with 17-col tables | No | No |
| /learn:review | Human review gate per topic | No | Yes (human) |
| /learn:spec | VANA-SPEC + readiness package extraction | No | No |
| /learn:visualize | Interactive HTML system map | No | No |

## L1: Static Contract Checks

Script: `scripts/learn-benchmark-l1.py`

### Check Registry

| ID | Dimension | Check | Method | Applicable Skills |
|----|-----------|-------|--------|-------------------|
| S-PATH | S | Output paths reference `2-LEARN/_cross/` | Regex for path patterns in body | input, research, structure, review, spec |
| S-AGENT | S | Agent dispatch uses `ltc-explorer` not generic | Grep for `subagent_type` / agent references | research |
| S-GATE | S | HARD-GATE block with human-approval language | Regex for `<HARD-GATE>` + approval terms | input, structure, review, spec |
| S-NODSBV | S | No DESIGN.md/SEQUENCE.md/VALIDATE.md creation | Grep for DSBV file creation patterns | all 7 |
| S-FRONT | S | Skill instructs frontmatter on output files | Grep for frontmatter/version/status refs | input, research, structure, review, spec |
| E-MODEL | E | Model in frontmatter matches expected tier | Parse `model:` from YAML | structure (opus), spec (opus) |
| E-TOOLS | E | allowed-tools is minimal set | Parse `allowed-tools:` from YAML, check count | all 7 |
| E-NOOVER | E | No agent dispatch in orchestrator-only skills | Check `Agent` not in allowed-tools | learn, input, structure, review, spec, visualize |
| SC-PRECK | Sc | Pre-Checks section exists | Regex for `## Pre-Checks` heading | all 7 |
| SC-ERROR | Sc | Error messages specify upstream skill to run | Grep for "Run /learn:" error patterns | research, structure, review, spec |
| SC-STATE | Sc | State derived from filesystem, not conversation | Grep for glob/read patterns in state logic | learn (orchestrator) |

~55 applicable check-cells across 7 skills.

## L2: State Simulation Fixtures

Script: `scripts/learn-benchmark-l2.py`

Tests the `/learn` orchestrator routing by creating mock filesystem states in a temp dir:

| Fixture | Filesystem State | Expected Route |
|---------|-----------------|----------------|
| F1-EMPTY | `2-LEARN/_cross/` exists, empty | → /learn:input |
| F2-INPUT | + `input/learn-input-test.md` | → /learn:research |
| F3-RSCH | + `research/test/T0-overview.md` | → /learn:structure |
| F4-STRUC | + `output/test/T0.P0..P5.md` (status: draft) | → /learn:review |
| F5-VALID | + all P-pages `status: validated` | → /learn:spec |
| F6-DONE | + `specs/test/vana-spec.md` | → "complete" |
| F7-PARTIAL | 3 topics, 2 structured, 1 not | → /learn:structure (topic 3) |
| F8-MIXED | Some pages validated, some needs-revision | → /learn:review (unvalidated) |

Method: Extract state detection rules from `/learn` SKILL.md as Python assertions.
Create fixture dirs in `/tmp/learn-benchmark-*`, run assertions, cleanup.

## L3: LLM-as-Judge Rubric

Script: `scripts/learn-benchmark-l3-rubric.md` (rubric) + embedded in `learn-benchmark.sh` (runner)

### Rubric (9 dimensions, score 1-5 per skill)

**S (Safe/Accurate):**
- S1: Output lands in correct `2-LEARN/_cross/` path? (1=no path control, 5=hardcoded + pre-check)
- S2: Can skill accidentally create DSBV artifacts in LEARN? (1=likely, 5=impossible — explicit guard)
- S3: Human gates present where needed? (1=auto-approves, 5=HARD-GATE + explicit requirement)

**E (Efficient):**
- E1: Model tier appropriate for task complexity? (1=Opus for grep, 5=matches cognitive load)
- E2: Tools minimal — no unused capabilities? (1=all tools, 5=exact minimal set)
- E3: Agent dispatch avoids unnecessary overhead? (1=agents for simple tasks, 5=agents only where parallel/specialist)

**Sc (Autonomous/Scalable):**
- Sc1: Self-diagnoses missing prerequisites? (1=crashes, 5=clear error + corrective action)
- Sc2: State detection relies on filesystem, not conversation? (1=asks user, 5=derives from glob/read)
- Sc3: Cross-skill handoffs explicit and verifiable? (1=implicit assumption, 5=pre-check validates upstream)

### Scoring Protocol

- 3 independent Opus runs per skill
- Majority vote per dimension
- FAIL threshold: any dimension ≤ 2
- WARN threshold: any dimension = 3

## Deliverables

```
scripts/learn-benchmark.sh          — orchestrator (L1 + L2 + optional L3)
scripts/learn-benchmark-l1.py       — static contract checks
scripts/learn-benchmark-l2.py       — state simulation fixtures
scripts/learn-benchmark-l3-rubric.md — Opus judge rubric
```

## Success Criteria

- L1: ≥90% pass rate across 55 check-cells
- L2: 8/8 fixtures route correctly
- L3: No dimension scores ≤2 across any skill (majority vote)

## Links

- [[AGENTS]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[architecture]]
- [[learn-benchmark-l3-rubric]]
- [[ltc-explorer]]
- [[simple]]
- [[task]]
