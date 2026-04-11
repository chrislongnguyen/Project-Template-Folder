---
name: claude-audit
description: Hybrid pipeline+team audit — 21 area agents + 5 cross-cut (pipeline) → verification team + adversarial debate team. 32 agents, evidence-based ship-readiness report.
version: "2.0"
status: draft
last_updated: 2026-04-11
model: opus
---

# /claude-audit — Comprehensive Workspace Audit

Full audit of every file, every workstream, every subsystem, every directory. Uses Claude Code agent teams to verify the entire ALPEI framework works as intended for LTC PMs.

## When to Use

- Before pushing to origin or cutting a release
- After major structural changes (refactors, template-sync, migration)
- When onboarding a new PM (verify their experience will be seamless)
- Periodic health check (monthly or per-iteration)

## Architecture — Hybrid Pipeline + Team

```
 ┌─────────────────── PIPELINE (independent agents, die after returning) ───────────┐
 │                                                                                   │
 │  Phase 0: LOCAL (Python, $0)      → JSON manifest (ground truth)                  │
 │  Phase 1: CONTENT (21× Haiku)     → per-area deep audit                           │
 │  Phase 2: CROSS-CUT (5× Haiku)    → wikilinks, process map, hooks, versions, naming│
 │                                                                                   │
 └───────────────────────────────────────────┬───────────────────────────────────────┘
                                             │ all 26 outputs collected
 ┌─────────────────── TEAM: audit-verify (agents stay alive, can query) ────────────┐
 │                                                                                   │
 │  Phase 2.R: VERIFICATION TEAM                                                     │
 │    reconciler (Opus)    — identifies contradictions, assigns verification tasks    │
 │    verifier-1 (Haiku)   — reads specific files to verify disputed claims          │
 │    verifier-2 (Haiku)   — parallel verification                                   │
 │                                                                                   │
 │  Flow: reconciler finds contradiction → creates task → verifier reads file →      │
 │        verifier reports evidence → reconciler resolves with proof                  │
 │                                                                                   │
 └───────────────────────────────────────────┬───────────────────────────────────────┘
                                             │ reconciliation output
 ┌─────────────────── TEAM: audit-debate (multi-round adversarial) ─────────────────┐
 │                                                                                   │
 │  Phase 3: ADVERSARIAL DEBATE TEAM                                                 │
 │    pm-walker (Opus)     — Day-1 walkthrough, stays alive for follow-up queries    │
 │    advocate (Opus)      — strongest case FOR shipping                              │
 │    opponent (Opus)      — strongest case AGAINST shipping                          │
 │    judge (Opus)         — queries both sides, multi-round rebuttal, verdict       │
 │    synthesizer (Opus)   — compiles report, queries any agent for clarification    │
 │                                                                                   │
 │  Key interactions enabled by teams:                                               │
 │    judge → advocate:  "Respond to opponent's point about broken hooks"            │
 │    judge → opponent:  "Counter the advocate's rebuttal on onboarding"             │
 │    synthesizer → pm-walker: "What was the exact confusion at SOP step 3?"         │
 │                                                                                   │
 └───────────────────────────────────────────┬───────────────────────────────────────┘
                                             │
 Output: inbox/YYYY-MM-DD_claude-audit.md
```

**Why hybrid?** Phase 1+2 agents must be INDEPENDENT (no groupthink — audit integrity).
Phase 2.R+3 agents benefit from INTERACTION (evidence verification, adversarial rebuttal).

Est: ~2.8M input tokens, ~280K output tokens. Time: 25-45 min.

## Execution Sequence

### Step 1 — Phase 0: Local Extraction

Run the deterministic extraction script. This produces ground-truth data that agents reference — no LLM hallucination on counts or paths.

```bash
python3 scripts/claude-audit-phase0.py --summary 2>/tmp/audit-summary.txt > /tmp/audit-manifest.json
```

Read `/tmp/audit-summary.txt` for the human-readable summary.
Read `/tmp/audit-manifest.json` — this is the manifest agents will reference.

**Record these key numbers** (you will need them for Phase 3):
- Total tracked files
- Frontmatter issue count
- Wikilink orphan count
- Hook chain broken count
- Script registry gaps
- Git commits ahead
- Per-area file counts

### Step 2 — Phase 1: Content Audit (22 Explore agents, Haiku)

Dispatch one agent per area. Each agent reads ALL files in its area and produces structured findings.

**Load references:**
- `references/area-definitions.md` — 22 area specs with expected content and audit criteria
- `references/agent-prompts.md` § PRIMER — architecture context every agent needs
- `references/agent-prompts.md` § Phase 1 Template — the prompt template

**For each area**, construct an Agent() call:
```
Agent({
  description: "Audit {area_name}",
  subagent_type: "Explore",
  model: "haiku",
  prompt: [Phase 1 template filled with area data from manifest]
})
```

**Dispatch in parallel batches of 5:**
- Batch 1: ws-align, ws-learn, ws-plan, ws-execute, ws-improve
- Batch 2: genesis-frameworks, genesis-templates, genesis-sops, genesis-reference, genesis-other
- Batch 3: claude-rules, claude-agents, claude-skills-core, claude-skills-other, claude-hooks
- Batch 4: scripts, rules-fullspec, root-config, cursor-config, pkb
- Batch 5: vault-other (1 remaining — runs solo)

**Collect all 22 outputs.** Each output contains:
- Per-file PASS/WARN/FAIL verdicts
- Summary findings table
- Area Score (0-100)
- PM-Ready: YES/NO

### Step 3 — Phase 2: Cross-Cutting Integrity (5 Explore agents, Haiku)

These agents check cross-repo integrity that no single area agent can see.

**Load:** `references/agent-prompts.md` § Phase 2 Prompts

Dispatch all 5 in parallel:
1. **Wikilinks** — orphan detection, broken link sources, graph health
2. **Process Map × Filesystem** — every path in process map exists on disk
3. **Hook Chain** — settings.json entries → hook scripts → target scripts
4. **Versions & Status** — frontmatter vs version-registry, status lifecycle compliance
5. **Naming Convention** — UNG compliance across all file/dir names

Each agent produces a score (0-100) and findings table.

### Step 4 — Phase 2.R: Verification Team

This phase uses an **agent team** so the reconciler can dispatch verifiers to check disputed claims on disk in real-time — not just guess from text.

**4a. Create the verification team:**
```
TeamCreate({ team_name: "audit-verify", description: "Evidence-based contradiction resolution" })
```

**4b. Spawn 3 teammates:**
```
Agent({
  team_name: "audit-verify",
  name: "reconciler",
  model: "opus",
  subagent_type: "ltc-reviewer",
  prompt: [Phase 2.R reconciler prompt from references/agent-prompts.md,
           with ALL Phase 1 + Phase 2 summaries pasted in]
})

Agent({
  team_name: "audit-verify",
  name: "verifier-1",
  model: "haiku",
  subagent_type: "Explore",
  prompt: [Verifier prompt from references/agent-prompts.md]
})

Agent({
  team_name: "audit-verify",
  name: "verifier-2",
  model: "haiku",
  subagent_type: "Explore",
  prompt: [Verifier prompt from references/agent-prompts.md]
})
```

**4c. Create initial task:**
```
TaskCreate({
  subject: "Identify contradictions across 26 agent outputs",
  description: "Read all Phase 1+2 summaries. For each contradiction, create a verification task."
})
```
Assign to reconciler via `TaskUpdate({ taskId: "...", owner: "reconciler" })`.

**4d. Reconciler workflow:**
1. Reads all Phase 1+2 outputs (provided in its prompt)
2. Identifies contradictions, gaps, systemic patterns
3. For each disputed claim, creates a verification task:
   ```
   TaskCreate({
     subject: "Verify: agent-A says PASS, agent-B says FAIL for path/to/file.md",
     description: "Read the file. Check frontmatter. Report: which agent is correct and why."
   })
   ```
4. Verifiers pick up tasks from the shared task list, read actual files, mark complete
5. Reconciler reads verified evidence, resolves contradictions with proof
6. Reconciler produces final reconciliation report

**4e. Collect output, shutdown team:**
Reconciler's final output = conflict list (resolved with evidence), gap list, systemic patterns.
Send shutdown to all teammates.

### Step 5 — Phase 3: Adversarial Debate Team

This phase uses an **agent team** so the judge can conduct multi-round rebuttals and the synthesizer can query any prior agent for clarification — producing a higher-quality verdict than single-pass pipeline.

**5a. Create the debate team:**
```
TeamCreate({ team_name: "audit-debate", description: "Multi-round adversarial synthesis" })
```

**5b. Spawn 5 teammates:**
```
Agent({ team_name: "audit-debate", name: "pm-walker", model: "opus",
        prompt: [PM walkthrough prompt with Phase 1 key findings] })

Agent({ team_name: "audit-debate", name: "advocate", model: "opus",
        prompt: [Ship advocate prompt with evidence summaries] })

Agent({ team_name: "audit-debate", name: "opponent", model: "opus",
        prompt: [Ship opponent prompt with evidence summaries] })

Agent({ team_name: "audit-debate", name: "judge", model: "opus",
        prompt: [Judge prompt — conduct multi-round debate, then verdict] })

Agent({ team_name: "audit-debate", name: "synthesizer", model: "opus",
        prompt: [Synthesizer prompt with ALL phase outputs + report format] })
```

**5c. Create tasks with dependencies:**
```
T1: "PM Day-1 Walkthrough"     → owner: pm-walker
T2: "Build ship-advocate case"  → owner: advocate,   blockedBy: [T1]
T3: "Build ship-opponent case"  → owner: opponent,    blockedBy: [T2]
T4: "Conduct adversarial round" → owner: judge,       blockedBy: [T2, T3]
T5: "Render final verdict"      → owner: judge,       blockedBy: [T4]
T6: "Compile 10-section report" → owner: synthesizer,  blockedBy: [T1, T5]
```

**5d. Multi-round debate (the key team advantage):**

The judge does NOT just read advocate + opponent and decide. The judge conducts rounds:

**Round 1:** Read both cases. Identify the strongest and weakest point from each.
**Round 2:** SendMessage to advocate:
  > "The opponent's point about [specific issue] is compelling. Present your counter-evidence."
SendMessage to opponent:
  > "The advocate claims [specific evidence]. What's your specific rebuttal?"
**Round 3:** Read rebuttals. Render verdict with full adversarial context.

This produces a verdict grounded in 2-3 rounds of real debate, not a single reading.

**5e. Synthesizer follow-up queries:**

After judge renders verdict, synthesizer compiles the report. When evidence is thin:
- SendMessage to pm-walker: "What was the exact blocker at step 3 of SOP?"
- SendMessage to judge: "Your condition #2 — what specific files need fixing?"
- SendMessage to advocate: "What's the strongest single metric supporting ship-readiness?"

These follow-ups fill gaps that single-pass synthesis would miss.

**5f. Collect output, shutdown team:**
Synthesizer's final output = the complete 10-section report.
Send shutdown to all teammates.

### Step 6 — Write Report

Write the synthesizer's output to:
```
inbox/YYYY-MM-DD_claude-audit.md
```

Append execution metadata footer (duration, agent count, model info, manifest counts).

## Gotchas

| Area | Watch For |
|------|-----------|
| genesis-reference | Binary files (PDF, DOCX, PPTX) — note existence, skip content |
| claude-skills-core/other | 152 files total — prioritize SKILL.md per skill dir |
| vault-other | May contain personal data in inbox/ — flag if found |
| ws-learn | MUST verify NO DSBV files (DESIGN.md, SEQUENCE.md, VALIDATE.md) exist |
| All areas | Frontmatter: all lowercase except work_stream (1-ALIGN format) |

## Prior Audit Comparison

If a prior audit exists in `inbox/*_gemini-audit.md` or `inbox/*_claude-audit.md`:
1. Read the most recent prior audit
2. Compare: which findings are NEW, RESOLVED, or RECURRING?
3. Recurring findings get highest priority in the gap analysis
4. Report score trends (improving, declining, stable)

## Links

- [[CLAUDE]]
- [[AGENTS]]
- [[enforcement-layers]]
- [[alpei-dsbv-process-map]]
- [[gemini-audit]]
