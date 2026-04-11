---
version: "1.0"
status: draft
last_updated: 2026-04-11
work_stream: 3-PLAN
sub_system: _cross
stage: validate
type: validate
---
# VALIDATE.md — DSBV Subsystem Scoping v2.1.0

> DSBV stage 4 artifact. Validates Build output against DESIGN.md contract.
> 4 independent ltc-reviewer agents (Opus) dispatched in parallel.
> Source: DESIGN.md v1.2 (inbox/2026-04-10_DESIGN-dsbv-subsystem-scoping.md)

---

## Aggregate Score

| Metric | Value |
|--------|-------|
| Total ACs evaluated | 34 |
| PASS | 34/34 (per-task Build ACs) |
| Post-Build system coherence | 8 BLOCKER, 7 COSMETIC |
| Verdict | **FAIL — 8 blockers from cross-cutting coherence review** |
| Reviewers | 4 parallel Opus agents (scripts, skills, rules, artifacts) |

---

## Build AC Results (T-01 through T-10)

All 34 DESIGN.md ACs passed during Build stage. Per-task results:

| Task | Artifact | ACs | Result |
|------|----------|-----|--------|
| T-01 | gate-state.sh | AC-11, AC-12, AC-13, AC-14, AC-14b | 5/5 PASS |
| T-02 | dsbv-skill-guard.sh | AC-07, AC-08, AC-09, AC-10 | 4/4 PASS |
| T-03 | dsbv-provenance-guard.sh | AC-24, AC-25, AC-25b | 3/3 PASS |
| T-04 | dsbv-gate.sh | AC-26, AC-26b, AC-27, AC-28 | 4/4 PASS |
| T-05 | /dsbv SKILL.md | AC-01, AC-02, AC-03, AC-04 | 4/4 PASS |
| T-06 | Template scaffolding | AC-05, AC-06 | 2/2 PASS |
| T-07 | Process map P3 | AC-15, AC-16, AC-17 | 3/3 PASS |
| T-08 | Context packaging | AC-18, AC-19, AC-20 | 3/3 PASS |
| T-09 | validate-blueprint.py | AC-21, AC-22, AC-23 | 3/3 PASS |
| T-10 | generate-registry.sh | AC-29, AC-30, AC-31 | 3/3 PASS |

---

## Cross-Cutting Coherence Review

4 reviewers audited the ENTIRE ALPEI system (not just the 10 build items) for subsystem scoping consistency. This caught issues in files NOT in the DESIGN.md scope but critical for PM usability.

### R1: Script + Hook Coherence (ltc-reviewer, Opus)

| Script | DD-1 | Exit Codes | Bash 3 | Subsystem | _cross | Syntax | Verdict |
|--------|------|------------|--------|-----------|--------|--------|---------|
| gate-state.sh | PASS | PASS | PASS | PASS | PASS | PASS | PASS (1 cosmetic) |
| dsbv-skill-guard.sh | PASS | PASS | PASS | PARTIAL | PASS | PASS | PASS (1 cosmetic) |
| dsbv-provenance-guard.sh | PARTIAL | PASS | PASS | FAIL | FAIL | PASS | **FAIL** |
| dsbv-gate.sh | PASS | PASS | PASS | PARTIAL | PASS | PASS | PASS |
| generate-registry.sh | PASS | PASS | PASS | N/A | PASS | PASS | PASS |
| validate-blueprint.py | PASS | PASS | N/A | PASS | PASS | PASS | PASS |
| gate-precheck.sh | PARTIAL | PASS | PASS | FAIL | N/A | PASS | **FAIL** |
| set-status-in-review.sh | N/A | PASS | PASS | N/A | N/A | PASS | PASS |
| gate-ceremony.sh | FAIL | PASS | PASS | N/A | N/A | PASS | **FAIL** |

### R2: Skill + Template Sync (ltc-reviewer, Opus)

| File | WS-level refs | Subsystem param | Examples | Placeholders | Verdict |
|------|---------------|-----------------|----------|--------------|---------|
| SKILL.md | PASS | PASS | PASS | PASS | PASS (1 minor) |
| context-packaging.md | **FAIL (3 refs)** | PASS | PARTIAL | N/A | **FAIL** |
| stage-execution-guide.md | PASS | N/A | N/A | N/A | PASS |
| multi-agent-build.md | PASS | N/A | N/A | N/A | PASS |
| circuit-breaker-protocol.md | PASS | N/A | PARTIAL | N/A | PASS (1 minor) |
| gotchas.md | **FAIL (1 ref)** | N/A | FAIL | N/A | **FAIL** |
| design-template.md | PASS | PARTIAL | N/A | PARTIAL | PARTIAL |
| sequence-template.md | PASS | PARTIAL | N/A | PARTIAL | PARTIAL |
| dsbv-eval-template.md | PASS | PARTIAL | N/A | PARTIAL | PARTIAL |
| dsbv-process.md | **FAIL** | **FAIL** | FAIL | N/A | **FAIL** |
| vana-spec-template.md | PASS | PASS | PASS | PASS | PASS |

### R3: Rules + Agent Config (ltc-reviewer, Opus)

| File | Verdict | Issue |
|------|---------|-------|
| filesystem-routing.md | PASS | — |
| alpei-chain-of-custody.md | PASS | — |
| agent-dispatch.md | PASS | — |
| enforcement-layers.md | PASS | — |
| alpei-template-usage.md | PASS | — |
| versioning.md | PASS | I0 (0.x) already fixed this session |
| script-registry.md | PASS | — |
| ltc-builder.md | PARTIAL | Routing boundaries lack subsystem path examples |
| ltc-planner.md | PARTIAL | Same |
| ltc-reviewer.md | PASS | — |
| ltc-explorer.md | PASS | — |
| alpei-dsbv-process-map.md | **FAIL** | Embedded P3 (lines 194-216) uses stale WS-level paths |
| alpei-dsbv-process-map-p3.md | PASS | Separate file is correct |
| alpei-dsbv-process-map-p4.md | PASS | — |
| CLAUDE.md | PASS | — |

### R4: Workstream Artifacts (ltc-reviewer, Opus)

| Workstream | Subsystem | Frontmatter | sub_system | Version | Status | Vocab | Verdict |
|------------|-----------|-------------|------------|---------|--------|-------|---------|
| 1-ALIGN | 1-PD | PASS | PASS | PASS | PASS | PASS | PASS |
| 1-ALIGN | 2-DP | PASS | PASS | PASS | PASS | PASS | PASS |
| 1-ALIGN | 3-DA | PASS | PASS | PASS | PASS | PASS | PASS |
| 1-ALIGN | 4-IDM | PASS | PASS | PASS | PASS | PASS | PASS |
| 3-PLAN | 1-PD | PASS | PASS | PASS | PASS | PASS | PASS |
| 3-PLAN | 2-DP | PASS | PASS | PASS | PASS | PASS | PASS |
| 4-EXECUTE | 1-PD | PASS | PASS | PASS | PASS | PASS | PASS (1 cosmetic) |
| 5-IMPROVE | 1-PD | PASS | PASS | PASS | PASS | PASS | PASS |
| 5-IMPROVE | 2-DP | PASS | PASS | PASS | PASS | PASS | PASS |

**version-registry.md:** FAIL — not subsystem-granular. PMs cannot track per-subsystem artifact versions.

---

## FAIL Items — Blockers

| ID | File | Line(s) | Issue | Root Cause | Fix |
|----|------|---------|-------|------------|-----|
| F-4 | `.claude/hooks/dsbv-provenance-guard.sh` | 47, 89 | Passes "1-PD" (display format) to gate-state.sh which expects "pd" (lowercase). Auto-init silently fails via `\|\| true`. Also: subsystem regex misses `_cross`. | T-03 builder extracted subsystem in display format, didn't map to gate-state.sh input format. | Add display→lowercase mapping. Add `_cross` to regex. |
| F-5 | `scripts/gate-precheck.sh` | 221 | check_subsystem_ordering reads deprecated WS-level state file `dsbv-${WORKSTREAM}.json`, misses subsystem-scoped files. | Not in DESIGN.md scope (A1-A10). Pre-existing script not upgraded. | Accept optional subsystem parameter. Route to `dsbv-${ws}-${sub}.json`. |
| F-6 | `scripts/gate-precheck.sh` | 8-11 | No subsystem parameter accepted — cannot scope gate checks to DD-1 paths. | Same as F-5. | Add 4th arg for subsystem. Forward to all internal checks. |
| F-7 | `scripts/gate-ceremony.sh` | 92 | Does not forward subsystem to `gate-state.sh advance`. Gate advancement always targets WS-level state. | Not in DESIGN.md scope. Pre-existing script not upgraded. | Add 5th param for subsystem. Forward to gate-state.sh and gate-precheck.sh. |
| F-8 | `.claude/skills/dsbv/references/context-packaging.md` | 132, 234, 254 | 3 example paths use `{workstream}/DESIGN.md` instead of `{workstream}/{subsystem}/DESIGN.md`. PM-facing. | T-08 builder updated INPUT section but missed examples in other agent sections. | Replace 3 WS-level paths with subsystem-scoped paths. |
| F-9 | `.claude/skills/dsbv/gotchas.md` | 12 | Detection check uses `{N}-{WORKSTREAM}/DESIGN.md` without subsystem. | Not in DESIGN.md scope. Pre-existing file not upgraded. | Replace with `{N}-{WORKSTREAM}/{S}-{SUBSYSTEM}/DESIGN.md`. |
| F-10 | `_genesis/templates/dsbv-process.md` | 42-46 | "How to Use" section shows `/dsbv design align` (old 2-param syntax). PM-facing process doc. | Not in DESIGN.md scope. Pre-existing template not upgraded. | Update commands to include `[subsystem]` parameter. |
| F-11 | `_genesis/frameworks/alpei-dsbv-process-map.md` | 194-216 | Embedded P3 walkthrough uses stale WS-level paths (`1-ALIGN/DESIGN.md`). Contradicts P1 matrix in same file. | Separate P3 file was updated (T-07) but embedded copy in main file was not. | Update embedded P3 to subsystem paths, or replace with cross-ref to separate P3 file. |
| F-12 | `_genesis/version-registry.md` | all | Registry tracks at workstream×stage level, not subsystem-granular. PMs editing `1-ALIGN/3-DA/DESIGN.md` have no corresponding row. | T-10 updated generate-registry.sh but did not regenerate the registry file itself. | Run `bash scripts/generate-registry.sh` to regenerate with subsystem-granular rows. |

---

## FAIL Items — Cosmetic / Should-Fix

| ID | File | Issue | Severity |
|----|------|-------|----------|
| C-1 | `gate-state.sh:238` | cmd_set_subsystem may be vestigial (uses WS-level path) | cosmetic |
| C-2 | `dsbv-skill-guard.sh:140` | Open regex for subsystem detection, not canonical list | cosmetic |
| C-3 | SKILL.md gate report template | Missing explicit `Subsystem:` field | cosmetic |
| C-4 | design/sequence/eval templates | Title + `sub_system:` not templated with `{{SUBSYSTEM}}` | should-fix |
| C-5 | ltc-builder.md, ltc-planner.md | Routing boundaries lack subsystem path examples | cosmetic |
| C-6 | `4-EXECUTE/1-PD/DESIGN.md:11` | Uses lowercase "x" instead of "×" in heading | cosmetic |
| C-7 | `circuit-breaker-protocol.md:81` | `/dsbv reset` command missing subsystem | cosmetic |

---

## Verdict

**BUILD: 34/34 ACs PASS** — all DESIGN.md items delivered correctly.
**SYSTEM COHERENCE: FAIL** — 8 blockers in files outside DESIGN.md scope but critical for PM usability.

**Root cause:** DESIGN.md scoped 10 specific artifacts (A1-A10). The 4 downstream scripts (gate-precheck, gate-ceremony) and 4 reference docs (context-packaging, gotchas, dsbv-process, embedded P3) were not in scope but depend on the same DD-1 pattern. The subsystem scoping upgrade exposed these pre-existing WS-level assumptions.

**Recommendation:** Fix all 8 blockers, regenerate version-registry, then re-validate. Cosmetic items can defer.

---

## Approval Log

| Date | Gate | Decision | Signal | Tier |
|------|------|----------|--------|------|
| 2026-04-11 | G1 — Design approved | APPROVED | User directed sequence stage | T2 |
| 2026-04-11 | G2 — Sequence approved | APPROVED | User invoked /dsbv build | T2 |
| 2026-04-11 | G3 — Build complete | APPROVED | User directed validation | T2 |
| | G4 — Validate complete | | | |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[alpei-dsbv-process-map]]
- [[context-packaging]]
- [[dsbv-process]]
- [[enforcement-layers]]
- [[gate-ceremony]]
- [[gate-precheck]]
- [[gate-state]]
- [[gotchas]]
- [[version-registry]]
