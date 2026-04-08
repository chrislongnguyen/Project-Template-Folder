---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: design-proposal
work_stream: 0-GOVERN
iteration: 1
agent: reviewer
title: "DESIGN: Agent 4 — ltc-reviewer (Judge)"
---

# DESIGN: Agent 4 — ltc-reviewer (Judge)

> **Purpose:** Full 8-component system design for ltc-reviewer, the DSBV Phase 4 (Validate) agent. Covers current state, gaps, frontier standards, and improvement proposals with S*E*Sc evaluation and force analysis.
>
> **Governing equation:** Success = Efficient & Scalable Management of Failure Risks (UT#5)
> **Evaluation criteria:** Sustainability > Efficiency > Scalability (DT#1)
> **RACI:** R = ltc-reviewer (validates), A = Human Director (approves G4 gate)
> **Model:** Opus — highest reasoning tier for judgment quality
> **Pipeline position:** Terminal node. Builder EO is Reviewer EI. Reviewer EO is Human EI (G4 gate).

---

## 0. Dispatch Modes

Reviewer is NOT limited to the DSBV chain. It operates in multiple modes:

| Mode | Trigger | EI Source | EO Destination | Context Weight |
|------|---------|-----------|----------------|----------------|
| **DSBV Validate** | `/dsbv validate [workstream]` | Orchestrator (5-field + DESIGN.md + all artifacts) | Human Director (G4 gate) | Full: DESIGN.md + artifacts + template |
| **Generator/Critic loop** | Auto-triggered after Build phase | Orchestrator (DESIGN.md + artifacts + prior VALIDATE.md) | Orchestrator → builder re-dispatch if FAIL | Full + iteration context |
| **Ad-hoc audit** | "Review X" or "Check if Y is correct" | Orchestrator (lighter: what to check + criteria) | Main session directly | Light: files + criteria |
| **Code review** | `/code-review` or "Review this PR" | Orchestrator (diff + standards) | Main session directly | Medium: diff + rules |
| **Compliance check** | "Is this compliant?" or `/ltc-rules-compliance` | Orchestrator (files + rule set) | Main session directly | Medium: files + rules |

**Key insight:** In ad-hoc/audit mode, reviewer returns findings directly to main session — no G4 gate, no formal VALIDATE.md. The full handoff contract (VALIDATE.md + structured feedback + aggregate score) applies ONLY in DSBV chain mode. In ad-hoc mode, a simple pass/fail list suffices.

**EOE implications by mode:**
- DSBV chain: full protocol (7-step validation, criterion count check, evidence requirement)
- Ad-hoc audit: lighter protocol (check what's asked, report findings, no VALIDATE.md)
- Generator/Critic: needs iteration context (prior VALIDATE.md) — currently not provided (EP-07 amnesia gap)

---

## 1. EI — Effective Input

### Current State

| Source | Content | Delivery |
|--------|---------|----------|
| DESIGN.md | The contract — success criteria, artifact inventory, binary ACs | Context-packaged by orchestrator (EO field) |
| All produced artifacts | Files on disk at paths declared in SEQUENCE.md | File paths in INPUT field; reviewer reads with Read/Glob |
| Validation template | `_genesis/templates/dsbv-eval-template.md` | Loaded as reference for VALIDATE.md structure |
| Completion report | Builder's `DONE: <path> \| ACs: <pass>/<total> \| Blockers: <list>` | Included in context package (but NOT trusted — EP-12) |

### Frontier Standard

ADK: criteria document + output to validate + scoring rubric + historical validation data (trend tracking). OpenAI Agents SDK: typed input contract with schema validation before agent starts.

### Gap

| Gap ID | Description | Impact |
|--------|-------------|--------|
| GAP-EI-1 | No input schema validation — reviewer starts even if DESIGN.md is missing from context | Builder failure silently becomes reviewer failure |
| GAP-EI-2 | No historical validation data — each validation is stateless, can't track recurring FAIL patterns | Same issues recur across workstreams without visibility |

### S*E*Sc

| Pillar | Score | Evidence |
|--------|-------|---------|
| **Sustainability** | 7/10 | EP-12 requires independent verification (don't trust builder). But: no pre-flight check for DESIGN.md presence means reviewer may operate on incomplete input |
| **Efficiency** | 7/10 | Context packaging delivers all needed files. But: no schema check = potential wasted Opus tokens on malformed input |
| **Scalability** | 6/10 | Same input format works for any workstream. But: no historical context limits pattern detection |

### UBS (Blockers)

| ID | Description | Category | Impact |
|----|-------------|----------|--------|
| UBS-EI-1 | No pre-flight validation of input completeness | Technical | Reviewer starts with missing DESIGN.md = wasted Opus invocation |
| UBS-EI-2 | No historical FAIL data across validations | Temporal | Recurring issues go undetected; same FAILs repeat workstream after workstream |

### UDS (Drivers)

| ID | Description | Category | Leverage |
|----|-------------|----------|---------|
| UDS-EI-1 | Context packaging (5-field template) standardizes input | Technical | Reviewer always receives structured input — better than ad-hoc prompt injection |
| UDS-EI-2 | EP-12 (Verified Handoff) — reviewer independently verifies artifacts on disk | Technical | Catches builder claims that don't match reality |

---

## 2. EU — Effective User

### Current State

**Model:** Claude Opus 4.6 (1M context window)
**RACI:** R (Responsible for validation). A = Human Director. Leaf node — no dispatch authority.

**Why Opus:** Validation is high-stakes, low-volume. Judgment quality is critical — rubber-stamping defeats the purpose. Reviewer must catch what builder missed. LT-5 (plausibility != truth) demands the highest reasoning tier. LT-1 (hallucination) risk is lower at Opus tier but still present — evidence requirement compensates.

### Frontier Standard

Same model tier across all major frameworks for judge/critic agents. Google ADK uses the same model for Generator and Critic to avoid capability asymmetry.

### Gap

No gap. Opus is the correct tier for judgment tasks.

### S*E*Sc

| Pillar | Score | Evidence |
|--------|-------|---------|
| **Sustainability** | 9/10 | Highest reasoning tier minimizes false PASS (most dangerous error in validation) |
| **Efficiency** | 5/10 | Opus is 10-15x more expensive than Haiku. But: downgrading to Sonnet risks false PASS on subtle issues. Cost is justified by impact |
| **Scalability** | 5/10 | Single reviewer per dispatch. No parallel validation (unlike parallel builders). Opus latency is higher |

### UBS

| ID | Description | Category | Impact |
|----|-------------|----------|--------|
| UBS-EU-1 | Opus cost per validation (~$0.50-2.00 per dispatch) | Economic | Acceptable for I1 frequency but needs monitoring at scale |

### UDS

| ID | Description | Category | Leverage |
|----|-------------|----------|---------|
| UDS-EU-1 | Opus reasoning prevents false PASS — the highest-risk failure mode in validation | Technical | A false PASS propagates bad artifacts downstream; Opus minimizes this |
| UDS-EU-2 | 1M context window can hold entire workstream output + DESIGN.md simultaneously | Technical | No chunking needed for I1 workstreams |

---

## 3. EA — Effective Action

### Current State: 7-Step Validation Protocol

```
Step 1: Load DESIGN.md — count criteria (N)
Step 2: Check completeness — all artifacts present on disk (Glob)
Step 3: Check quality — each artifact passes its binary ACs (Read + Grep)
Step 4: Check coherence — artifacts don't contradict each other (cross-read)
Step 5: Check downstream readiness — next workstream can start with these outputs
Step 6: Run compliance checks (skill-validator.sh, template-check.sh via Bash)
Step 7: Produce VALIDATE.md — per-criterion verdicts with evidence
```

**Verdict vocabulary:** PASS / FAIL / PARTIAL (no other values allowed)

**Evidence standard per verdict:**

| Verdict | When | Evidence Required |
|---------|------|-------------------|
| PASS | Criterion fully met | File path + line number or excerpt proving compliance |
| FAIL | Criterion not met or artifact missing | What's wrong + what's expected + file path where it should be |
| PARTIAL | Partially met or ambiguous criterion | What's present + what's missing + recommended action |

**Red flags reviewer must catch:**
- Artifact in DESIGN.md but file doesn't exist on disk
- AC that isn't binary/testable (design flaw — report upstream to planner)
- File missing version frontmatter
- Visual artifact using non-LTC colors/fonts
- Skill file failing skill-validator.sh
- Cross-artifact contradictions (charter says X, architecture says Y)
- Criterion count mismatch: VALIDATE.md checks < DESIGN.md criteria = rubber-stamping

### Frontier Standard

ADK Generator/Critic pattern: critic scores per criterion with evidence, feeds FAIL items back to generator automatically. LangGraph: typed state transitions with validation functions at each node. Galileo AI metrics framework: task success rate, instruction following %, hallucination detection per output.

### Gap

| Gap ID | Description | Impact |
|--------|-------------|--------|
| GAP-EA-1 | No aggregate quality score — human must read every row | Human parsing overhead on large VALIDATE.md |
| GAP-EA-2 | No smoke test guidance — all validation is static (read-only checks) | LP-6: "Validate must test against live system, not just ACs" |
| GAP-EA-3 | No structured feedback to builder on FAIL items | Freeform FAIL descriptions require human reformatting before re-dispatch |

### S*E*Sc

| Pillar | Score | Evidence |
|--------|-------|---------|
| **Sustainability** | 9/10 | "Judge, not Advocate" prevents scope creep. Evidence requirement prevents rubber-stamping. Criterion count check catches incomplete validation |
| **Efficiency** | 6/10 | No aggregate score = human reads every row. No structured feedback = manual re-dispatch formatting. LP-6 gap = false PASS on runtime issues |
| **Scalability** | 5/10 | 7-step protocol is sequential. Large workstreams (20+ ACs) hit context limits. No auto-retry loop |

### UBS

| ID | Description | Category | Impact |
|----|-------------|----------|--------|
| UBS-EA-1 | No aggregate quality score | Human | Human must read every row to determine workstream readiness |
| UBS-EA-2 | No smoke test (LP-6) | Technical | Static validation misses runtime failures (e.g., script that has correct content but wrong permissions) |
| UBS-EA-3 | No structured feedback format for FAIL items | Human | Manual reformatting needed before builder re-dispatch |

### UDS

| ID | Description | Category | Leverage |
|----|-------------|----------|---------|
| UDS-EA-1 | Binary verdicts (PASS/FAIL/PARTIAL) — no ambiguity | Technical | Every stakeholder knows exact status per criterion |
| UDS-EA-2 | Evidence requirement prevents rubber-stamping | Technical | Audit trail — every verdict is traceable to a file path + line |
| UDS-EA-3 | Criterion count check (VALIDATE >= DESIGN count) | Technical | Structurally impossible to skip criteria |

---

## 4. EO — Effective Output

### Current State

**Primary output:** VALIDATE.md — per-criterion verdict table with evidence column.

```markdown
## Validation Results

| # | Criterion | Verdict | Evidence |
|---|-----------|---------|----------|
| 1 | Charter has version frontmatter | PASS | 1-ALIGN/charter/charter.md:1-5 — version: "1.2" |
| 2 | Architecture uses LTC colors | FAIL | 3-PLAN/architecture/system-design.html — uses #3498db (Bootstrap blue), not #004851 |
| ... | ... | ... | ... |
```

**Consumers:**
1. **Human Director** — reads VALIDATE.md to decide G4 gate (approve / re-dispatch / override / descope)
2. **Orchestrator** — reads VALIDATE.md to potentially re-dispatch builder with FAIL items

### Frontier Standard

ADK: typed validation output with aggregate metrics (pass rate, severity distribution). Galileo AI: per-criterion scoring with confidence intervals + trend comparison to previous validations. OpenAI Agents SDK: structured JSON output with metadata (execution time, model used, tool calls count).

### Gap

| Gap ID | Description | Impact |
|--------|-------------|--------|
| GAP-EO-1 | No aggregate summary line | Human must count PASS/FAIL manually to determine workstream readiness |
| GAP-EO-2 | FAIL items not formatted as builder EI | Re-dispatch requires manual reformatting by orchestrator or human |
| GAP-EO-3 | No severity ranking on FAIL items | Human treats all FAILs equally — but some are blockers, others are cosmetic |
| GAP-EO-4 | No recommended action per FAIL | Human must diagnose each FAIL to decide next step |

### Proposed EO Structure (VALIDATE.md v2)

```markdown
## Aggregate Score

14/16 PASS | 1 FAIL | 1 PARTIAL — workstream NOT ready for G4

## Validation Results

| # | Criterion | Verdict | Evidence | Action |
|---|-----------|---------|----------|--------|
| 1 | Charter has version frontmatter | PASS | 1-ALIGN/charter/charter.md:1-5 | — |
| 7 | Architecture uses LTC colors | FAIL | system-design.html uses #3498db | FIX: replace #3498db with #004851 at lines 12, 45, 89 |
| 12 | Skill passes validator | PARTIAL | 3/4 checks pass; missing description | FIX: add description field to SKILL.md frontmatter |

## FAIL Items — Builder Re-Dispatch Format

### FAIL-7: Architecture uses LTC colors
- **File:** 3-PLAN/architecture/system-design.html
- **Expected:** All colors from LTC palette (#004851, #F2C75C, #1D1F2A, #FFFFFF)
- **Actual:** Uses #3498db (Bootstrap blue) at lines 12, 45, 89
- **Fix:** Replace all instances of #3498db with #004851
- **AC (binary):** `grep -c '#3498db' system-design.html` returns 0

### PARTIAL-12: Skill passes validator
- **File:** .claude/skills/ltc-example/SKILL.md
- **Expected:** All 4 skill-validator.sh checks pass
- **Actual:** 3/4 pass; missing `description` in frontmatter
- **Fix:** Add `description: "..."` to YAML frontmatter
- **AC (binary):** `./scripts/skill-validator.sh .claude/skills/ltc-example` exits 0
```

### S*E*Sc

| Pillar | Score | Evidence |
|--------|-------|---------|
| **Sustainability** | 8/10 | Per-criterion verdicts with evidence create audit trail. But: no aggregate = human may miss overall status |
| **Efficiency** | 4/10 | No aggregate score. No builder-ready feedback format. Human does double work parsing + reformatting |
| **Scalability** | 5/10 | VALIDATE.md format works for any workstream. But: no structured feedback = manual loop overhead |

### UBS

| ID | Description | Category | Impact |
|----|-------------|----------|--------|
| UBS-EO-1 | No aggregate quality score | Human | Human must manually count verdicts |
| UBS-EO-2 | FAIL items not formatted as builder EI | Human | Re-dispatch requires manual reformatting |
| UBS-EO-3 | No severity/priority on FAIL items | Human | All FAILs treated equally |
| UBS-EO-4 | No recommended action per FAIL | Human | Human must diagnose independently |

### UDS

| ID | Description | Category | Leverage |
|----|-------------|----------|---------|
| UDS-EO-1 | Evidence column = every verdict is auditable | Technical | Trust in reviewer output |
| UDS-EO-2 | Consumed by both human AND orchestrator | Technical | Single output serves two consumers |

---

## 5. EP — Effective Principles

### Active Principles

| Principle | Application to Reviewer |
|-----------|------------------------|
| **EP-01: Brake Before Gas** | Default to FAIL before PASS. When in doubt, mark PARTIAL with evidence of ambiguity. Never rubber-stamp |
| **EP-10: Define Done** | Criterion count in VALIDATE.md MUST equal DESIGN.md count. Done = every criterion has a verdict + evidence |
| **EP-12: Verified Handoff** | Independently verify every artifact exists on disk (Glob). Do NOT trust builder's completion report. LT-1: builder may claim DONE without writing the file |
| **EP-13: Orchestrator Authority** | Reviewer is a leaf node. Cannot dispatch agents. If additional info needed, report PARTIAL — do not research |
| **EP-11: Agent Role Separation** | "Judge, not Advocate." Report neutrally. Do not fix artifacts. Do not suggest improvements beyond DESIGN.md scope |

### Principle Interactions

```
EP-01 (Brake Before Gas)
  └─ Conflicts with: nothing — FAIL-first is always safe
  └─ Reinforces: EP-10 (if not Done, say so) + EP-12 (verify, don't trust)

EP-10 (Define Done)
  └─ Enforces: criterion count check (structural anti-rubber-stamping)
  └─ Depends on: DESIGN.md having binary/testable ACs (if not, flag as design flaw)

EP-12 (Verified Handoff)
  └─ Compensates for: LT-1 (hallucination — builder may claim file exists)
  └─ Tool dependency: Glob (verify file existence on disk)

EP-13 (Leaf Node)
  └─ Prevents: scope creep into research or fixing
  └─ Consequence: PARTIAL verdict instead of "let me go find out"
```

### Gap

No EP gap. The principle set is adequate for the reviewer role. The gap is in EO and EA (applying these principles to produce structured output).

### S*E*Sc

| Pillar | Score | Evidence |
|--------|-------|---------|
| **Sustainability** | 9/10 | FAIL-first + evidence-required + criterion count check = triple protection against rubber-stamping |
| **Efficiency** | 8/10 | Principles are clear and non-conflicting — no cognitive overhead for the model |
| **Scalability** | 9/10 | Same principles work regardless of workstream content |

---

## 6. EOE — Effective Operating Environment (DEGRADED SUB-AGENT)

### 8-Layer Environment Analysis

```
┌─────────────────────────────────────────────────────────────────┐
│ LAYER 1: PLATFORM                                               │
│ Claude Code CLI | macOS | zsh | Python3                         │
│ Status: NORMAL                                                  │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 2: PERMISSIONS                                            │
│ settings.json deny/allow list: ENFORCED                         │
│ Reviewer tools (Read, Glob, Grep, Bash) — all within allow      │
│ No Write/Edit = structurally can't modify artifacts             │
│ Status: NORMAL — read-only constraint is INTENTIONAL            │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 3: HOOKS — !! DEGRADED !!                                 │
│                                                                 │
│ PreToolUse hooks:  DO NOT FIRE inside sub-agents                │
│   Impact on reviewer:                                           │
│   - Write/Edit hooks: IRRELEVANT (reviewer has no Write/Edit)   │
│   - Bash(git commit) hooks: IRRELEVANT (reviewer doesn't commit)│
│   - Bash(other) hooks: MISSING — reviewer uses Bash to run      │
│     compliance scripts (skill-validator.sh, template-check.sh)  │
│     → dsbv-gate.sh check on Bash commands doesn't fire          │
│     → Low risk: reviewer Bash usage is read-only (script output)│
│   - Agent dispatch hook: IRRELEVANT (reviewer is leaf node)     │
│                                                                 │
│ PostToolUse hooks: DO NOT FIRE inside sub-agents                │
│   Impact on reviewer:                                           │
│   - Write/Edit hooks: IRRELEVANT (no Write/Edit tools)          │
│   - Agent hooks: IRRELEVANT (no Agent tool)                     │
│   - inject-frontmatter: IRRELEVANT (no file writes)             │
│   - state-saver: NOT FIRING — reviewer state changes not saved  │
│     → Low risk: reviewer is stateless by design                 │
│                                                                 │
│ SubagentStop:  FIRES (at orchestrator level)                    │
│   → verify-deliverables.sh checks reviewer output               │
│   → This is the PRIMARY enforcement layer for reviewer EO       │
│                                                                 │
│ Net assessment: LOW RISK. Reviewer is read-only, so most        │
│ write-focused hooks are irrelevant. The one gap (Bash hooks     │
│ for compliance scripts) is low-impact because those scripts     │
│ produce output, not side effects. SubagentStop compensates.     │
│ Status: DEGRADED but ACCEPTABLE                                 │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 4: CONTEXT                                                │
│ Opus 1M context window                                          │
│ NO auto-recall (QMD memory injection doesn't fire in sub-agent) │
│ NO memory vault access                                          │
│ Must load ALL artifacts into context to validate                │
│ Large workstream risk: 20+ artifacts could approach context     │
│ limits (each artifact 500-2000 lines = 10K-40K tokens)          │
│ Status: ADEQUATE for I1 workstreams (small artifact count)      │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 5: AGENT COORDINATION                                     │
│ Leaf node — cannot dispatch agents                              │
│ If additional info needed → report PARTIAL, don't research      │
│ Status: NORMAL — intentional constraint                         │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 6: RULES                                                  │
│ Agent file (ltc-reviewer.md): LOADED at dispatch                │
│ .claude/rules/: STATUS UNCLEAR                                  │
│   → Sub-agents may or may not inherit always-on rules           │
│   → Key rules that matter for reviewer:                         │
│     - versioning.md (checking frontmatter = core reviewer task) │
│     - brand-identity.md (checking LTC colors/fonts)             │
│     - naming-rules.md (checking file/folder names)              │
│   → If rules NOT loaded: reviewer must rely on agent file text  │
│     which summarizes key rules but is less complete              │
│ Status: UNCLEAR — needs testing                                 │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 7: MCP                                                    │
│ NONE. Reviewer has no MCP server access                         │
│ Cannot search QMD, Exa, or any external source                  │
│ Status: NORMAL — intentional (no research = no scope creep)     │
├─────────────────────────────────────────────────────────────────┤
│ LAYER 8: FILESYSTEM                                             │
│ Read-only via Read/Glob/Grep                                    │
│ Bash for running compliance scripts (exit code + stdout only)   │
│ Cannot: create, modify, or delete any file                      │
│ Status: NORMAL — read-only is structural neutrality guarantee   │
└─────────────────────────────────────────────────────────────────┘
```

### Degradation Risk Matrix

| Layer | Risk | Probability | Mitigation |
|-------|------|-------------|------------|
| L3 (Hooks) | Bash compliance scripts run without PreToolUse guard | Medium | Scripts are read-only output; SubagentStop validates reviewer EO |
| L4 (Context) | Large workstream overflows context | Low (I1) | Orchestrator should summarize non-critical artifacts; load only files being validated |
| L6 (Rules) | Always-on rules not loaded in sub-agent | Medium | Agent file contains key rule summaries; orchestrator can include rules in INPUT |
| L7 (MCP) | Reviewer can't look up definitions/standards | Low | All needed context delivered via INPUT field |

### S*E*Sc

| Pillar | Score | Evidence |
|--------|-------|---------|
| **Sustainability** | 8/10 | Read-only filesystem = structurally impossible to cause damage. SubagentStop provides post-execution verification |
| **Efficiency** | 6/10 | 1M context is generous for I1. But: no auto-recall means orchestrator must pre-load everything. Rules inheritance unclear = potential re-work |
| **Scalability** | 5/10 | Context limits become real at I2+ (more artifacts, more criteria). No parallel validation support |

### UBS

| ID | Description | Category | Impact |
|----|-------------|----------|--------|
| UBS-EOE-1 | PreToolUse hooks don't fire (SDK limitation — GitHub #40580) | Technical | Bash commands run without dsbv-gate.sh check. Low risk for reviewer (read-only Bash) |
| UBS-EOE-2 | Rules inheritance unclear | Technical | Reviewer may not have versioning.md, brand-identity.md rules loaded |
| UBS-EOE-3 | No auto-recall / no memory access | Technical | Reviewer is stateless — can't learn from prior validations |

### UDS

| ID | Description | Category | Leverage |
|----|-------------|----------|---------|
| UDS-EOE-1 | Read-only filesystem = structural neutrality | Technical | Reviewer literally cannot fix artifacts, which prevents the "Judge becomes Advocate" anti-pattern |
| UDS-EOE-2 | SubagentStop hook fires at orchestrator level | Technical | Post-execution verification of reviewer output quality |
| UDS-EOE-3 | 1M context window accommodates entire I1 workstream | Technical | No chunking or multi-pass needed for current scale |

---

## 7. EOT — Effective Operating Tools

### Tool Inventory

| Tool | Purpose in Reviewer Context | Criticality |
|------|----------------------------|-------------|
| **Read** | Load specific files by known path — inspect content, gather evidence, read DESIGN.md | HIGH — primary evidence-gathering tool |
| **Glob** | Discover files by pattern — verify every artifact in DESIGN.md exists on disk | CRITICAL — EP-12 completeness check depends on Glob |
| **Grep** | Search file contents for patterns — check version frontmatter, brand colors, naming conventions | HIGH — enables bulk content verification without reading entire files |
| **Bash** | Run compliance scripts (skill-validator.sh, template-check.sh) — capture exit code + output as evidence | MEDIUM — only for scripted checks, not general computation |

### Tool Constraints (Intentional Restrictions)

| Tool NOT Available | Why |
|--------------------|-----|
| **Write** | Reviewer must not modify artifacts (Judge, not Advocate) |
| **Edit** | Same as Write — structural neutrality |
| **Agent()** | Leaf node — no dispatch (EP-13) |
| **MCP servers** | No research capability — prevents scope creep into exploration |

### Tool Interaction Pattern

```
DESIGN.md ──Read──→ Extract criteria list (N items)
                         │
                         ▼
Artifacts ──Glob──→ Verify existence    ──→ FAIL if missing
                         │
                         ▼
           ──Read──→ Inspect content    ──→ PASS/FAIL per AC
                         │
                         ▼
           ──Grep──→ Pattern checks     ──→ version frontmatter, brand colors
                         │
                         ▼
Scripts   ──Bash──→ Compliance checks   ──→ skill-validator.sh, template-check.sh
                         │
                         ▼
                    Produce VALIDATE.md  ──→ (returned as text — reviewer has no Write)
```

**Key insight:** Reviewer produces VALIDATE.md as text output (EO), NOT as a file. The orchestrator or human writes it to disk. This is consistent with the read-only constraint but creates a handoff step.

### Gap

| Gap ID | Description | Impact |
|--------|-------------|--------|
| GAP-EOT-1 | No Write tool means VALIDATE.md is text output, not a file | Orchestrator must extract and write — potential for truncation on large validations (LT-2) |

### S*E*Sc

| Pillar | Score | Evidence |
|--------|-------|---------|
| **Sustainability** | 9/10 | 4-tool set is minimal and correct. No Write = can't damage. Each tool maps to a specific validation step |
| **Efficiency** | 7/10 | Tools are sufficient for all validation tasks. Glob is especially efficient for bulk existence checks |
| **Scalability** | 7/10 | Tools scale with artifact count. Grep handles pattern checks across many files efficiently |

### UBS

| ID | Description | Category | Impact |
|----|-------------|----------|--------|
| UBS-EOT-1 | VALIDATE.md returned as text, not written to file | Technical | Large validations risk truncation during handoff (LT-2) |

### UDS

| ID | Description | Category | Leverage |
|----|-------------|----------|---------|
| UDS-EOT-1 | Read-only tool set = structural neutrality guarantee | Technical | Impossible to "fix" artifacts even accidentally |
| UDS-EOT-2 | Glob enables EP-12 completeness verification at scale | Technical | One Glob call checks all artifact paths |
| UDS-EOT-3 | Bash for compliance scripts = deterministic checks | Technical | Script exit codes are binary — no judgment needed |

---

## 8. EOP — Effective Operating Procedures

### Current Procedure: 7-Step Validation Protocol

```
┌─────────────────────────────────────────────────────────────┐
│ Step 1: LOAD CONTRACT                                       │
│   Read DESIGN.md → extract all criteria → count N           │
│   CHECKPOINT: N > 0. If N = 0, STOP — design has no ACs    │
├─────────────────────────────────────────────────────────────┤
│ Step 2: CHECK COMPLETENESS                                  │
│   Glob all artifact paths from DESIGN.md                    │
│   Any missing file → immediate FAIL verdict for that AC     │
│   CHECKPOINT: file count matches DESIGN.md artifact list    │
├─────────────────────────────────────────────────────────────┤
│ Step 3: CHECK QUALITY                                       │
│   Read each artifact → test against its binary ACs          │
│   Each AC → PASS / FAIL / PARTIAL with evidence             │
├─────────────────────────────────────────────────────────────┤
│ Step 4: CHECK COHERENCE                                     │
│   Cross-read artifacts for contradictions                   │
│   E.g., charter says scope=X but architecture covers scope=Y│
├─────────────────────────────────────────────────────────────┤
│ Step 5: CHECK DOWNSTREAM READINESS                          │
│   Can the next workstream start with these outputs?         │
│   Missing handoff artifacts → FAIL                          │
├─────────────────────────────────────────────────────────────┤
│ Step 6: RUN COMPLIANCE CHECKS                               │
│   Bash: skill-validator.sh (if skills in scope)             │
│   Bash: template-check.sh --quiet                           │
│   Exit code != 0 → FAIL with script output as evidence      │
├─────────────────────────────────────────────────────────────┤
│ Step 7: PRODUCE VALIDATE.md                                 │
│   Aggregate: X/N PASS | Y FAIL | Z PARTIAL                 │
│   Per-criterion table: # | Criterion | Verdict | Evidence   │
│   FAIL items: builder re-dispatch format (see EO section)   │
│   CHECKPOINT: verdict count = N (criterion count from Step 1)│
└─────────────────────────────────────────────────────────────┘
```

### Gate Presentation (G4)

After producing VALIDATE.md, reviewer presents to Human Director for G4 gate:

```
Human receives VALIDATE.md and chooses:
  (a) ALL PASS → approve workstream complete (G4 gate passed)
  (b) ANY FAIL → re-dispatch builder with FAIL items as EI
  (c) Override → accept despite FAIL (with documented justification)
  (d) Descope → remove failing criterion from DESIGN.md (scope change)
```

### LP-6: Smoke Test Guidance

**Learned Pattern LP-6:** "Validate must test against live system, not just ACs."

**Requirement:** At least 1 AC per artifact SHOULD exercise the live system. Examples:

| Artifact Type | Static Check | Smoke Test (LP-6) |
|--------------|-------------|-------------------|
| Shell script | File exists + has shebang + correct permissions | `bash -n script.sh` (syntax check) or `./script.sh --help` |
| Python module | File exists + has docstring | `python3 -c "import module"` |
| HTML page | File exists + has LTC colors | Open in browser or validate with `tidy` / `html5validator` |
| Skill dir | Files present + frontmatter valid | `./scripts/skill-validator.sh <skill-dir>` |
| Config file | Valid YAML/JSON syntax | `python3 -c "import json; json.load(open('file.json'))"` |

**Implementation:** Reviewer checks for smoke-testable artifacts. If found, runs the smoke test via Bash. If the artifact is not smoke-testable (pure prose, design docs), skip — static checks only.

**Boundary:** Reviewer does NOT run destructive smoke tests (anything that writes, deploys, or modifies state). Read-only smoke tests only.

### Frontier Standard

ADK LoopAgent: critic outputs structured feedback, generator receives it as new input, loop repeats until exit_condition met or max_iterations reached. This is the Generator/Critic pattern — the highest-leverage improvement for the agent system.

### Gap

| Gap ID | Description | Impact |
|--------|-------------|--------|
| GAP-EOP-1 | Single-pass validation — no auto-retry loop with builder | Human must manually trigger re-build on every FAIL |
| GAP-EOP-2 | No smoke test protocol (LP-6) | Static-only validation misses runtime failures |
| GAP-EOP-3 | No pre-flight input validation step | Reviewer may start validation with incomplete input |

### S*E*Sc

| Pillar | Score | Evidence |
|--------|-------|---------|
| **Sustainability** | 8/10 | 7-step protocol is thorough. Criterion count check prevents rubber-stamping. But: no pre-flight check |
| **Efficiency** | 5/10 | Single-pass = every FAIL requires full human intervention cycle. No auto-retry = most expensive possible loop |
| **Scalability** | 4/10 | Protocol is sequential (7 steps, no parallelism). Single-pass means O(n) human interventions where n = FAIL count |

### UBS

| ID | Description | Category | Impact |
|----|-------------|----------|--------|
| UBS-EOP-1 | No auto-retry loop (Generator/Critic) | Human | Every FAIL requires manual human re-dispatch cycle |
| UBS-EOP-2 | No smoke test protocol | Technical | Runtime failures pass static validation |
| UBS-EOP-3 | No pre-flight input validation | Technical | Wasted Opus invocation on malformed input |

### UDS

| ID | Description | Category | Leverage |
|----|-------------|----------|---------|
| UDS-EOP-1 | 7-step protocol covers completeness + quality + coherence + downstream readiness + compliance | Technical | Most thorough validation protocol in LTC system |
| UDS-EOP-2 | Criterion count checkpoint = anti-rubber-stamping | Technical | Structural guarantee against lazy validation |

---

## Handoff Contracts

### Upstream: Builder -> Reviewer (via Orchestrator)

```
Builder EO (artifacts + completion report)  ──→  Reviewer EI (artifacts to validate)
──────────────────────────────────────────────────────────────────────────────────────
MUST PROVIDE:                               │  REVIEWER EXPECTS:
 All artifacts at declared file paths       │   DESIGN.md (the contract)
 Completion report with AC pass/fail        │   All produced artifacts on disk
 Version frontmatter on every artifact      │   Completion report with blockers
 No DSBV files in 2-LEARN/                  │   Files at paths declared in SEQUENCE.md
──────────────────────────────────────────────────────────────────────────────────────
EP-12 CHECK: Reviewer must independently verify every artifact exists
on disk (Glob). Do NOT trust builder's completion report as ground
truth. LT-1: builder may claim "DONE: path" without writing the file.
```

### Downstream: Reviewer -> Human Director

```
Reviewer EO (VALIDATE.md)  ──→  Human EI (approval decision)
──────────────────────────────────────────────────────────────
MUST PROVIDE:                │  HUMAN EXPECTS:
 Per-criterion verdicts      │   Clear PASS/FAIL/PARTIAL
 File-path evidence          │   Evidence they can verify
 Criterion count = DESIGN    │   Aggregate summary line
 FAIL items with severity    │   Recommended action per FAIL
 Aggregate score (X/N PASS)  │   Builder-ready FAIL format
──────────────────────────────────────────────────────────────
HUMAN DECISION:
  ALL PASS → approve workstream complete (G4)
  ANY FAIL → (a) re-dispatch builder with FAIL items as EI
             (b) override with justification
             (c) descope the failing criterion
```

### Feedback Loop: Reviewer -> Builder (Generator/Critic)

```
Reviewer FAIL items  ──→  Builder EI (fix tasks)
────────────────────────────────────────────────────────────────────
MUST PROVIDE:                    │  BUILDER EXPECTS:
 Task ID (FAIL-N)                │   Specific file path to fix
 File path                       │   What's wrong (actual)
 Expected vs Actual              │   What's expected
 Fix instruction (1 sentence)    │   Binary AC to verify fix
 Binary AC for verification      │   Scope boundary (only this fix)
────────────────────────────────────────────────────────────────────
LOOP CONTROL (orchestrator):
  max_iterations: 3 (configurable)
  exit_condition: all ACs in VALIDATE.md = PASS
  escalation: if iterations exhausted → human decides

STRUCTURED FAIL FORMAT (ready-to-use as builder EI):

  ### FAIL-{N}: {criterion text}
  - **Task ID:** FAIL-{N}
  - **File:** {absolute path}
  - **Expected:** {what DESIGN.md requires}
  - **Actual:** {what reviewer found, with line numbers}
  - **Fix:** {1-sentence instruction}
  - **AC:** {deterministic check — grep, script exit code, file exists}
```

---

## Generator/Critic Loop Design (HIGHEST-LEVERAGE IMPROVEMENT)

### Problem Statement

Current state: Build once -> Validate once -> Human decides. Every FAIL requires a full human intervention cycle: read VALIDATE.md, understand the failure, reformulate as builder task, re-dispatch builder, re-dispatch reviewer. This is O(n) human labor where n = number of FAIL items.

### Proposed Architecture

```
                        ┌───────────────── Generator/Critic Loop ──────────────────┐
                        │                                                           │
  Orchestrator          │   Builder         Reviewer         Decision               │
  ─────────────        │   ───────         ────────         ────────               │
  Dispatch builder ────│──→ Build    ────→ VALIDATE.md                             │
                        │                       │                                   │
                        │                       ├─── ALL PASS ──→ G4 (human gate)   │
                        │                       │                                   │
                        │                       ├─── ANY FAIL + iter < max ──┐      │
                        │                       │                            │      │
                        │   ┌── FAIL items ←────┘                            │      │
                        │   │   (structured                                  │      │
                        │   │    builder EI)                                 │      │
                        │   │                                                │      │
                        │   └──→ Re-build ──→ Re-validate ──────────────────┘      │
                        │                                                           │
                        │                       ├─── ANY FAIL + iter = max ──→      │
                        │                       │   ESCALATE to Human Director      │
                        │                       │   with full failure context        │
                        └───────────────────────────────────────────────────────────┘

  Loop Parameters:
    max_iterations: 3 (default, configurable via /dsbv)
    exit_condition: all criteria in VALIDATE.md = PASS
    escalation: full VALIDATE.md + iteration history + diagnostic suggestion
```

### S*E*Sc Justification

| Pillar | Without Loop (Current) | With Loop (Proposed) | Delta |
|--------|----------------------|---------------------|-------|
| **Sustainability** | Human is the retry mechanism — fragile, depends on availability | Capped iterations (max 3) prevent infinite loops. Auto-escalation on persistent failure | +2 |
| **Efficiency** | O(n) human interventions per FAIL | Fixable issues auto-retry (0 human effort). Only unfixable issues reach human | +3 |
| **Scalability** | Each workstream's FAIL count multiplies human labor | Same loop works for any workstream. Token cost is bounded (max 3 iterations) | +2 |

### Implementation Requirements

1. **Reviewer EO format:** FAIL items must follow the structured builder EI format (see Handoff Contract above)
2. **Orchestrator logic:** `/dsbv build` skill adds loop control after reviewer returns
3. **Builder input:** FAIL items are delivered as individual task entries with file path + AC
4. **Iteration tracking:** Orchestrator maintains iteration count (proposed state file: `.claude/state/dsbv-pipeline.yaml`)
5. **Escalation format:** On max iterations, present to human: VALIDATE.md (latest) + FAIL items that persisted across all iterations + diagnostic suggestion (EP→Input→EOP→EOE→EOT→Agent order)

### Frontier Pattern Match

| Framework | Pattern Name | Our Equivalent |
|-----------|-------------|----------------|
| Google ADK | LoopAgent with exit_condition | /dsbv build loop with all-PASS exit |
| LangGraph | Conditional edges in StateGraph | Orchestrator if/else on VALIDATE.md verdicts |
| CrewAI | Agent feedback loops | Builder/Reviewer with structured handoff |
| Anthropic SDK | Tool-based retry with human_input | max_iterations + escalation to Human Director |

### Risk Analysis

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Infinite loop (builder + reviewer disagree) | Low | High (token burn) | max_iterations cap (hard limit) |
| Builder makes same mistake each iteration | Medium | Medium (wasted iterations) | Circuit breaker: if FAIL-N persists across 2 iterations with same error, escalate immediately |
| Reviewer false FAIL (Opus judgment error) | Low | Medium (unnecessary re-build) | EP-12: evidence requirement — human can audit FAIL verdicts |
| Token cost per loop iteration | Certain | Medium | Budget tracking per iteration; orchestrator logs token count |

---

## Aggregate Score Proposal for VALIDATE.md

### Problem

Current VALIDATE.md has no summary — human must read every row to determine workstream readiness. For a workstream with 16 criteria, this is significant overhead.

### Proposed Format

Add an aggregate section at the top of every VALIDATE.md:

```markdown
## Aggregate Score

14/16 PASS | 1 FAIL | 1 PARTIAL — workstream NOT ready for G4

Verdict: FAIL (any FAIL = workstream not ready)
Iteration: 1 of 3 (max)
```

### Decision Logic

```
IF all verdicts = PASS:
  "workstream READY for G4 approval"

IF any verdict = FAIL:
  "workstream NOT ready for G4 — {N} FAIL items require re-build"

IF no FAIL but any PARTIAL:
  "workstream CONDITIONALLY ready — {N} PARTIAL items for human review"
```

### S*E*Sc

| Pillar | Impact |
|--------|--------|
| **Sustainability** | Human can immediately assess readiness without reading every row |
| **Efficiency** | 5-second decision vs. 5-minute parse. Aggregate + detailed table = best of both |
| **Scalability** | Works regardless of criterion count |

---

## Consolidated Force Analysis

### All UBS (Blockers) — Ranked by S*E*Sc Impact

| Rank | ID | Component | Description | Category | Priority |
|------|-----|-----------|-------------|----------|----------|
| 1 | UBS-EOP-1 | EOP | No auto-retry loop (Generator/Critic) | Human | **P0** |
| 2 | UBS-EO-2 | EO | FAIL items not formatted as builder EI | Human | **P0** |
| 3 | UBS-EA-1 | EA | No aggregate quality score | Human | **P0** |
| 4 | UBS-EO-4 | EO | No recommended action per FAIL | Human | **P0** |
| 5 | UBS-EA-2 | EA | No smoke test protocol (LP-6) | Technical | **P1** |
| 6 | UBS-EOE-2 | EOE | Rules inheritance unclear in sub-agent | Technical | **P1** |
| 7 | UBS-EI-1 | EI | No pre-flight validation of input completeness | Technical | **P1** |
| 8 | UBS-EO-3 | EO | No severity ranking on FAIL items | Human | **P2** |
| 9 | UBS-EI-2 | EI | No historical FAIL data across validations | Temporal | **P2** |
| 10 | UBS-EOE-1 | EOE | PreToolUse hooks don't fire (SDK limitation) | Technical | **Accept** |
| 11 | UBS-EOE-3 | EOE | No auto-recall / no memory access | Technical | **Accept** |
| 12 | UBS-EU-1 | EU | Opus cost per validation | Economic | **Accept** |
| 13 | UBS-EOT-1 | EOT | VALIDATE.md returned as text, not file | Technical | **Accept** |

### All UDS (Drivers) — Ranked by Leverage

| Rank | ID | Component | Description | Category |
|------|-----|-----------|-------------|----------|
| 1 | UDS-EOE-1 | EOE | Read-only filesystem = structural neutrality | Technical |
| 2 | UDS-EA-2 | EA | Evidence requirement prevents rubber-stamping | Technical |
| 3 | UDS-EA-3 | EA | Criterion count check (VALIDATE >= DESIGN) | Technical |
| 4 | UDS-EI-2 | EI | EP-12 independent verification on disk | Technical |
| 5 | UDS-EU-1 | EU | Opus reasoning prevents false PASS | Technical |
| 6 | UDS-EOT-2 | EOT | Glob enables completeness check at scale | Technical |
| 7 | UDS-EOT-3 | EOT | Bash for deterministic script checks | Technical |
| 8 | UDS-EO-1 | EO | Evidence column = auditable verdicts | Technical |
| 9 | UDS-EI-1 | EI | Context packaging standardizes input | Technical |
| 10 | UDS-EOP-1 | EOP | 7-step protocol covers all validation dimensions | Technical |

---

## Sources

### Internal
- Agent file: `.claude/agents/ltc-reviewer.md` (v1.3, 2026-04-05)
- Agent system design: `inbox/2026-04-08_agent-system-8component-design.md`
- Settings: `.claude/settings.json` (hooks, permissions)
- Learned patterns: `learned_patterns.md` (LP-6: live system testing)
- Context packaging: `.claude/skills/dsbv/references/context-packaging.md`

### Frontier
- Google ADK LoopAgent / Generator-Critic pattern
- Anthropic Claude Agent SDK: sub-agent limitations (hooks, context)
- LangGraph conditional state transitions
- Galileo AI evaluation metrics framework
- "17x Error Trap" multi-agent error compounding (TDS, 2026-01-30)

### Philosophical Foundation
- UT#1 (Everything is a system): Reviewer IS a system with 8 components
- UT#5 (Success = managing failure risks): Reviewer's EO is failure risk reporting
- DT#1 (S > E > Sc): Sustainability-first evaluation at every component
- EP-01 (Brake Before Gas): FAIL-first default
- EP-10 (Define Done): Criterion count = DESIGN count
- EP-12 (Verified Handoff): Independent verification, don't trust upstream

---

## Review Status (2026-04-08)

**Verdict:** G1 APPROVED with P0 fixes.
**Aggregate:** S~8, E~6, Sc~6 — EOP efficiency (5/10) due to single-pass validation.
**P0 fixes required before BUILD:**
1. VALIDATE.md v2 format: aggregate score + severity + recommended action per FAIL (Proposals from EO section)
2. Structured FAIL format as builder EI (from Handoff Contracts section)
3. Generator/Critic loop integration — reviewer is the Critic half (must align with Orchestrator P0-1 and Builder Proposal 1)
4. Hook constraint mirroring in `ltc-reviewer.md` (from Orchestrator P0-3)

**Cross-agent dependency:** Generator/Critic loop spans Orchestrator (control), Builder (generator), Reviewer (critic). All 3 must be built together.

---

## Links

- [[ltc-reviewer]]
- [[ltc-builder]]
- [[ltc-planner]]
- [[ltc-explorer]]
- [[agent-dispatch]]
- [[context-packaging]]
- [[dsbv]]
- [[enforcement-layers]]
- [[DESIGN]]
- [[VALIDATE]]
- [[versioning]]
