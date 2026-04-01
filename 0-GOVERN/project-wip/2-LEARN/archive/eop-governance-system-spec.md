---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# VANA-SPEC: EOP Governance System

> **Status:** Draft — pending Human Director approval
> **Date:** 2026-03-27
> **Branch:** `feat/dsbv-process` (spec only; execution on dedicated branch `feat/eop-governance`)
> **Author:** Long Nguyen + Claude (Governance Agent)
> **Zone:** Zone 0 (Agent Governance) + Zone 4 (IMPROVE)

---

## §0 Force Analysis

### System Identity

**EO (Effective Outcome):** Produce a standalone, deterministic governance system that ensures every skill (EOP) created or retrofitted in any LTC project meets frontier-quality standards — without requiring access to external research docs.

**EU (Effective User):** Claude agent (Responsible) creating/reviewing skills. Long Nguyen (Accountable) approving governance design and validating results.

**Formula:** `Skill Quality = f(EOP-GOV principles, skill-validator enforcement, ltc-skill-creator procedure, feedback loop)`

### UBS — Blocking Forces

**UBS.UB (Root blocking force): Skills degrade silently.**
No quality gate exists today. A skill can be committed with no gotchas, no progressive disclosure, a vague description, and no validation gates — and nobody notices until the skill fails to trigger or produces wrong output 3 sessions later.

- UBS.UB.UB: LT-6 (no persistent memory) — each session starts blank, so the agent can't learn from prior skill failures.
- UBS.UB.UD: The stale `skill-creator` exists — it gives the appearance of governance without actually checking quality. False sense of safety.

**UBS.UD (Force that blocks but also drives): Process overhead.**
A governance system adds friction to skill creation. If the friction exceeds the value, people bypass it.

- UBS.UD.UB: Over-engineering — 14 principles and 12 checks would block casual skill creation.
- UBS.UD.UD: Proportional governance — tiered requirements (v1: 8 principles, waived for tiny skills) keeps friction proportional to risk.

**Bottleneck:** The validator script. If it's too strict, it blocks legitimate skills. If it's too lenient, it's theatre. Calibration against real skills (/feedback before/after, /deep-research, known-bad mock) is the only way to find the right threshold.

### UDS — Driving Forces

**UDS.UD (Root driving force): Institutional knowledge compounds.**
Every gotcha, every gate, every principle encoded in EOP-GOV.md makes the next skill cheaper and better. L3 operators with a well-governed skill library perform at L5 level on procedural tasks.

- UDS.UD.UD: Template repo amplification — governance ships with every project cloned from this template.
- UDS.UD.UB: Governance only works if people use it — deterministic enforcement (hooks) removes the choice.

**UDS.UB (Force that drives but also blocks): Existing research depth.**
Session 4 (20+ sources), Thariq's practices, EP registry pattern — rich source material. But richness creates the temptation to over-engineer v1.

**Synergy:** UBS.UD (process overhead) and UDS.UB (research depth) share a root mechanism — "more knowledge available than should be loaded." Both are managed by the same principle: load what you need, defer the rest to v2.

### Sigmoid Zone Classification

This system is in the **early acceleration zone** — no governance exists today, so even a minimal system produces outsized improvement. Diminishing returns begin after ~8-10 principles. v1 targets the steep part of the curve.

---

## §1 Identity

### RACI

| Role | Who | Responsibility |
|---|---|---|
| **Accountable** | Long Nguyen (Human Director) | Approves governance principles, validates test results, decides v2 scope |
| **Responsible** | Claude (Governance Agent) | Drafts EOP-GOV.md, writes validator, improves /feedback, measures results |
| **Consulted** | Thariq's article (async), Session 4 research (async) | Source material — already consumed, no further consultation needed |
| **Informed** | LTC team members | Will use the governance system after deployment |

### Personas

| Persona | Context | Interaction with this system |
|---|---|---|
| **Skill Creator** (L2-L4 agent or human) | Creating a new skill from scratch | Invokes `/skill-creator`, which loads EOP-GOV.md and runs validator |
| **Skill Reviewer** (L3-L5 agent or human) | Reviewing a PR that modifies a skill | Reads EOP-GOV.md diagnostic table, runs validator manually |
| **Skill Retrofitter** (L4+ agent) | Upgrading an existing skill to governance standards | Runs `skill-validator.sh --all`, uses EOP-GOV.md as the target spec |
| **Template Consumer** (any level) | Clones this template for a new project | Inherits governance system automatically — validator + hook + skill-creator |

---

## §2 Verb ACs — What the System Does

| AC-ID | Verb | Adverb | Noun | Adjective | Acceptance Criterion |
|---|---|---|---|---|---|
| V-01 | Validate | deterministically | skill structure | against 8 EOP principles | `skill-validator.sh` exits 0 on a conforming skill and exits 1 on a non-conforming skill, with zero false results on the 3-skill discrimination test |
| V-02 | Block | automatically | malformed skill commits | before they reach the repo | Pre-commit hook fires when staged files match `*/SKILL.md` or `*/skills/*/` AND validator exit code 1 prevents the commit |
| V-03 | Guide | step-by-step | skill creation | through tier-appropriate templates | `/ltc-skill-creator` presents the correct template (simple or standard) based on user's stated complexity, and runs validator before human gate |
| V-04 | Diagnose | precisely | skill quality issues | with principle-traced recommendations | Validator output maps each failure to a specific EOP-{NN} principle and includes a one-line fix suggestion |
| V-05 | Retrofit | systematically | existing skills | to governance standards | `skill-validator.sh --all` scans every skill in the repo and produces a per-skill scorecard |
| V-06 | Improve | measurably | /feedback skill | from baseline to governance-compliant | Post-improvement measurement shows improvement on ≥4 of 5 B-metrics vs baseline |

---

## §3 Adverb ACs — How Well It Does It

| AC-ID | Quality Attribute | Acceptance Criterion |
|---|---|---|
| A-01 | **Standalone** | EOP-GOV.md is comprehensible without access to Session 4, Thariq's article, EP registry, or any external document. A new team member can read it and understand every principle from the doc alone. |
| A-02 | **Deterministic** | For any given skill directory, `skill-validator.sh` produces the same output every time. No randomness, no model calls, no network dependencies. Pure bash + grep. |
| A-03 | **Proportional** | Checks that are inappropriate for small skills (≤40 lines) are automatically waived. The system does not impose COMPLEX-tier requirements on SIMPLE-tier skills. |
| A-04 | **Discriminating** | Validator correctly discriminates between known-bad (0-2/8 pass), known-partial (/dsbv-like, 4-6/8), and known-good (/feedback improved, 7+/8) skills. |
| A-05 | **Fast** | Validator completes in <2 seconds for a single skill, <10 seconds for `--all` across the full repo. |
| A-06 | **Extensible** | Adding a new principle to EOP-GOV.md and a corresponding CHECK to the validator requires editing exactly 2 files. No other files need modification. |

---

## §4 Noun ACs — What Components Exist

| AC-ID | Component | Location | Exists When |
|---|---|---|---|
| N-01 | EOP Governance Codex | `_shared/reference/EOP-GOV.md` | File exists, contains 8 principles in the specified format, includes diagnostic table |
| N-02 | Skill Validator Script | `scripts/skill-validator.sh` | File exists, is executable, implements 8 checks, supports `--all` and `--staged` flags |
| N-03 | Skill Creator Skill | `.claude/skills/ltc-skill-creator/SKILL.md` | Directory exists with SKILL.md + references/ + templates/ + gotchas.md |
| N-04 | Improved Feedback Skill | `4-IMPROVE/skills/feedback/SKILL.md` | Directory contains SKILL.md + references/ + templates/ + gotchas.md |
| N-05 | Pre-commit Hook Config | `.claude/settings.json` (or hook script) | Hook entry exists, scoped to `*/SKILL.md` and `*/skills/*/` paths |
| N-06 | CLAUDE.md Reference | `CLAUDE.md` | Contains line referencing EOP-GOV.md for skill creation/review |
| N-07 | Test Fixtures | `scripts/test-fixtures/bad-skill/SKILL.md` | Deliberately malformed skill for discrimination testing |

---

## §5 Adjective ACs — What Properties Components Have

| AC-ID | Component | Property | Acceptance Criterion |
|---|---|---|---|
| J-01 | EOP-GOV.md | Self-contained | Every principle includes: Statement, Why this matters (plain language, no jargon references), Without this, Implemented by, Example. No principle requires reading another document to understand. |
| J-02 | EOP-GOV.md | Pattern-consistent | Format matches `effective-agent-principles-registry.md` structure: numbered principles, tag (DERISK/OUTPUT), grounding, diagnostic table. |
| J-03 | skill-validator.sh | Pure bash | No Python, no Node, no external dependencies. Runs on any macOS/Linux with bash + grep + awk. |
| J-04 | skill-validator.sh | Flexible matching | Each check uses multiple trigger patterns (not single string match). CHECK-04 accepts ≥3 trigger phrases. CHECK-07 accepts ≥4 gate phrases. |
| J-05 | ltc-skill-creator | Self-validating | The skill-creator's own skill directory passes `skill-validator.sh` at 7+/8. It eats its own dogfood. |
| J-06 | /feedback (improved) | Backward-compatible | Produces the same GitHub Issue format as the current version. No breaking change to issue consumers. |
| J-07 | Pre-commit hook | Scoped | Only fires when staged files include paths matching `*/SKILL.md` or `*/skills/*/`. Does not fire on unrelated commits. |
| J-08 | Test fixtures | Deliberately bad | `bad-skill/SKILL.md` has: no YAML frontmatter, no description, >300 lines, no gotchas, no gates, no references/ directory. Must score 0-2/8. |

---

## §6 System Boundaries

### Layer 1: What Flows

```
IN                                          OUT
──────────────────────────────────────────  ──────────────────────────────────────
Session 4 research (consumed, distilled) →  EOP-GOV.md (standalone codex)
Thariq's practices (consumed, distilled) →  skill-validator.sh (deterministic tool)
EP registry format (pattern replicated)  →  ltc-skill-creator (updated EOP)
Current /feedback (baseline)             →  Improved /feedback (retrofitted)
                                            Pre-commit hook (enforcement gate)
                                            CLAUDE.md update (reference pointer)
                                            Test fixtures (discrimination test)
```

### Layer 2: How It Flows Reliably

```
EOP-GOV.md (reference)
    │
    ├──→ loaded by ltc-skill-creator when creating skills
    ├──→ loaded by /dsbv validate when reviewing zone output
    ├──→ read by humans when reviewing PRs touching skills
    │
    └──→ encodes principles into ──→ skill-validator.sh
                                        │
                                        ├──→ called by ltc-skill-creator Step N
                                        ├──→ called by pre-commit hook
                                        ├──→ called manually for retrofit audit
                                        └──→ called by CI (future)
```

### Layer 3: How You Verify

| Test ID | What it proves | Input | Expected output |
|---|---|---|---|
| T-01 | Validator rejects garbage | `scripts/test-fixtures/bad-skill/` | Exit 1, score 0-2/8 |
| T-02 | Validator recognizes existing quality | `/skills/deep-research/` (no changes) | Exit 0, score 6+/8 |
| T-03 | Validator confirms improvement | `4-IMPROVE/skills/feedback/` (after) | Exit 0, score 7+/8 |
| T-04 | Validator catches baseline gaps | `4-IMPROVE/skills/feedback/` (before) | Exit 1 or 0 with 3+ warnings |
| T-05 | Hook blocks bad commit | Stage `bad-skill/SKILL.md`, attempt commit | Commit rejected |
| T-06 | Hook allows good commit | Stage improved `/feedback`, attempt commit | Commit succeeds |
| T-07 | Skill-creator eats own dogfood | Run validator on `.claude/skills/ltc-skill-creator/` | Score 7+/8 |
| T-08 | /feedback B-metrics improve | Compare B1-B5 before vs after | ≥4 of 5 metrics improved |

### Layer 4: How It Fails Gracefully

| Failure mode | Detection | Response |
|---|---|---|
| Validator script not found | Hook checks `[ -x ./scripts/skill-validator.sh ]` | Hook exits 0 with warning "validator not found, skipping" — does not block |
| Validator crashes mid-check | Bash `set -e` + trap | Exits 1 with partial report + "validator error, please fix script" |
| New skill type not covered by v1 principles | Validator passes but skill underperforms at runtime | Feed failure into gotchas.md → propose new principle for v2 |
| Team bypasses hook (`--no-verify`) | Not detectable at hook level | CLAUDE.md rule: "Never skip hooks unless user explicitly requests" + code review catches |
| EOP-GOV.md becomes stale | No automated detection in v1 | Quarterly review scheduled (v2: staleness detection via last-synced date) |

### Integration Chain

```
This system connects to:

UPSTREAM (provides input):
├── _shared/reference/effective-agent-principles-registry.md (format pattern)
├── rules/agent-system.md (7-CS model, LT definitions)
└── _shared/templates/DSBV_PROCESS.md (DSBV applied to skill lifecycle)

DOWNSTREAM (consumes output):
├── Every skill in the repo (validated by skill-validator.sh)
├── .claude/skills/dsbv/ (future retrofit candidate)
├── Every project cloned from this template (inherits governance)
└── Future component governance docs (EOP-GOV pattern replicated for EP-GOV, EOE-GOV, etc.)

FEEDBACK LOOP:
└── 4-IMPROVE/skills/feedback/ → captures governance friction → GitHub Issues
    → informs EOP-GOV.md updates → better governance → less friction
```

---

## §7 Failure Modes

| ID | Failure | Probability | Impact | Mitigation |
|---|---|---|---|---|
| F-01 | Validator too strict — blocks legitimate skills | Medium | High (team bypasses) | Calibrate against 3 real skills + 1 mock before deploying |
| F-02 | Validator too lenient — passes bad skills | Low | Medium (silent quality degradation) | Discrimination test T-01 through T-04 catches this |
| F-03 | EOP-GOV.md too abstract — agents can't apply it | Medium | High (governance is ignored) | "Without this" + "Example" in every principle makes it concrete |
| F-04 | /feedback improvement breaks existing issue format | Low | Medium (downstream consumers affected) | J-06 backward compatibility check |
| F-05 | Design violates EOP-09 (start simple) | Addressed | — | v1 scoped to 8 principles. v2 candidates explicitly deferred. |

---

## §8 Boundaries — What This System Does NOT Do

| Out of scope | Why | When it becomes in scope |
|---|---|---|
| Govern non-EOP components (EP, Input, EOE, EOT) | EOP-GOV is the first instance; pattern replicates later | After v1 validated and stable |
| Auto-fix failing skills | Validator reports, human/agent fixes | v3 — after patterns stabilize |
| Measure runtime skill effectiveness (trigger accuracy) | Requires instrumentation not yet built | v2 — after PreToolUse logging hook |
| Cross-platform portability (Gemini CLI, Cursor) | Template is Claude Code primary | When LTC adopts multi-platform |
| Govern plugin/imported skills (memory-vault, obsidian) | Imported skills are upstream-maintained | If LTC forks those plugins |

---

## §9 Iteration Plan

| Version | Scope | Trigger |
|---|---|---|
| **v1 (this spec)** | 8 principles, 8 checks, /feedback test case, ltc-skill-creator, hook | Human Director approval of this spec |
| **v2** | +6 principles (EOP-09 through EOP-14), tier auto-detection, PreToolUse logging, quarterly review process | After 3+ skills retrofitted using v1 |
| **v3** | Auto-fix suggestions, CI integration, cross-platform portability checks | After v2 stable for 2+ months |

---

## §10 AC-TEST-MAP

| AC-ID | Test ID(s) | How verified |
|---|---|---|
| V-01 | T-01, T-02, T-03, T-04 | Discrimination test across 4 skill types |
| V-02 | T-05, T-06 | Hook blocks bad, allows good |
| V-03 | T-07 | Skill-creator passes own validator |
| V-04 | T-01, T-03 (output inspection) | Validator output includes EOP-{NN} and fix suggestion |
| V-05 | T-02, T-04 | `--all` flag produces per-skill scorecard |
| V-06 | T-08 | B-metric comparison ≥4/5 improved |
| A-01 | Manual review | Reader test: can someone unfamiliar with Session 4 understand every principle? |
| A-02 | T-01 run twice | Same input → same output |
| A-03 | T-02 (deep-research is complex, waived checks should not fire on simple skills) | Check waiver logic |
| A-04 | T-01 + T-02 + T-03 | Three-point discrimination |
| A-05 | T-01 through T-04 timed | Each <2s |
| A-06 | Manual review | Count files that need editing to add principle #9 |
| N-01 through N-07 | File existence checks | `ls` / `test -f` |
| J-01 through J-08 | Mapped to T-01 through T-08 | See individual J-AC definitions |

---

## Execution Sequence Summary

```
Phase  Deliverable                          Gate                           Est.
─────  ────────────────────────────────────  ──────────────────────────── ─────
1      DRAFT EOP-GOV.md (8 principles)      Human reviews principles
2      skill-validator.sh (8 checks)         Discrimination test passes
3      Baseline /feedback measurement        B1-B5 recorded
4      Improve /feedback                     Validator passes 7+/8
5      Post-measurement + Q1-Q4             ≥4/5 B-metrics improved
6      FINAL EOP-GOV.md                      Human reviews updates
7      ltc-skill-creator (replace stale)     Passes own validator
8      Hook wiring + CLAUDE.md              Hook blocks bad test skill
```

**Branch strategy:**
- This spec: committed on `feat/dsbv-process` (design artifact)
- Execution: new branch `feat/eop-governance` off `main`
- /feedback improvement: on `feat/eop-governance`
- Merge to `main` after Phase 8 gate passes

---

*Spec produced by: Long Nguyen + Claude (Governance Agent)*
*Governing process: DSBV (Design phase) within Zone 0 + Zone 4*
*Source material: AMT Session 4 (Doc-12), Thariq Shihipar (Anthropic), EP Registry, conversation analysis 2026-03-27*
