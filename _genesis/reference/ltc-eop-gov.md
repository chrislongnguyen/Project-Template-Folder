---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# EOP Governance Codex — Skill Quality Standards

> Canonical reference for designing, building, and validating AI agent skills (EOP).
> Standalone — does not require access to source research documents.
> Provenance: AMT Session 4 (EOP research), Anthropic Claude Code team practices,
>   LTC Effective Principles Registry. Cited for maintainer traceability, not required for use.
> Last synced: 2026-03-27

---

## How to Use

- **Creating a skill:** Read Part 2 end-to-end before writing your first SKILL.md. Each principle has a Bad/Good example — use them as a checklist.
- **Reviewing a skill:** Scan the Part 1 Quick Reference Table. For each row, ask "Does this skill satisfy this principle?" If not, check the full specification for remediation.
- **Running the validator:** Execute `skill-validator.sh <skill-directory>`. It runs automated CHECK-01 through CHECK-08. See Part 4 for the CHECK-to-EOP mapping.
- **Retrofitting existing skills:** Use Part 3 (Diagnostic Table) to trace observed symptoms to violated principles, then apply the fix from the corresponding Part 2 specification.

---

## Part 1 — Quick Reference Table

| # | Name | Tag | One-Liner | Validator Check |
|---|------|-----|-----------|-----------------|
| EOP-01 | Skills Are Folders | DERISK | A skill is a directory with SKILL.md as entry point, not a bare file. | CHECK-01 |
| EOP-02 | Progressive Disclosure | DERISK | SKILL.md routes; detail lives in subdirectories, loaded on demand. | CHECK-06 |
| EOP-03 | Gotchas Are Highest Signal | DERISK | Documented failure patterns are the most valuable content in any skill. | CHECK-05 |
| EOP-04 | Description Is Trigger | OUTPUT | The YAML description field is a trigger condition, not a summary. | CHECK-03 + CHECK-04 |
| EOP-05 | Context Budget Sizing | DERISK | SKILL.md routing body must stay within 200 lines to preserve model accuracy. | CHECK-08 |
| EOP-06 | Validation Gates | DERISK | Multi-step procedures need explicit checkpoints between steps. | CHECK-07 |
| EOP-07 | Don't State the Obvious | OUTPUT | Focus on knowledge the agent lacks, not what it already knows. | Qualitative |
| EOP-08 | Escape Hatches | DERISK | Every procedure needs an explicit fallback path when steps fail. | Qualitative (advisory) |

**Distribution:** 6 DERISK, 2 OUTPUT. DERISK principles are non-negotiable constraints; OUTPUT principles enable quality but are secondary.

---

## Part 2 — Full Principle Specifications


**Validated:** /feedback retrofit (2026-03-27) — improved from 1/8 to 8/8 validator score
---

### EOP-01: Skills Are Folders [DERISK]

**Statement:** A skill is a directory containing SKILL.md as its entry point, with supporting detail in references/, templates/, and scripts/ subdirectories.

**Why this matters:** A bare SKILL.md file cannot carry supplementary material — gotcha lists, templates, validation scripts, or reference documents. When all content is forced into a single file, the skill either stays shallow (missing critical detail) or becomes bloated (consuming excessive context tokens). A directory structure enables progressive loading: the agent reads SKILL.md first, then pulls in specific subdirectory files only when needed.

**Without this:** You write a 400-line SKILL.md that tries to contain procedures, templates, gotchas, and reference material in one file. The agent loads all 400 lines every time the skill activates, even when it only needs the 20-line procedure. Context budget is wasted, and the agent's attention on the critical steps is diluted by surrounding noise.

**Implemented by:**
- Design: Create a directory named after the skill. Place SKILL.md at the root. Add references/, templates/, or scripts/ as needed.
- Validator: CHECK-01 in `skill-validator.sh` — SKILL.md exists inside a directory

**Example:**

Bad:
> `feedback.md` — a standalone file in `.claude/skills/` containing the entire feedback procedure, templates, and gotchas in 300 lines.

Good:
> `.claude/skills/feedback/SKILL.md` (40 lines, routing only) with `feedback/templates/issue-template.md` and `feedback/references/gotchas.md` loaded on demand.


**Validated:** /feedback retrofit (2026-03-27) — improved from 1/8 to 8/8 validator score
---

### EOP-02: Progressive Disclosure [DERISK]

**Statement:** SKILL.md is the routing layer — it tells the agent what to do and where to find details; detailed procedures, reference material, and templates live in subdirectories and are loaded on demand.

**Why this matters:** AI models degrade when overloaded with irrelevant content. Research shows effective context utilization is only 30-70% of the nominal window on straightforward tasks. The "lost in the middle" phenomenon causes 30%+ accuracy drops for information positioned in the centre of long contexts. By keeping SKILL.md lean and routing to detail files, the agent loads only what it needs for the current step, preserving accuracy on the content that matters.

**Without this:** Your SKILL.md contains the full procedure, all edge cases, three templates, and a troubleshooting guide. When the agent activates the skill for a simple case, it loads 8,000 tokens of detail it does not need. The critical 200 tokens for this specific case are buried in the middle, where the model is least likely to attend to them.

**Implemented by:**
- Design: Keep SKILL.md under 200 lines. Use `> Load references/X.md for detail` pointers. Place templates in templates/, procedures in references/, scripts in scripts/.
- Validator: CHECK-06 in `skill-validator.sh` — references/ or templates/ directory exists (waived for skills with 40 lines or fewer)

**Example:**

Bad:
> SKILL.md contains 180 lines: 40 lines of routing, 80 lines of detailed API reference, 60 lines of templates — all loaded every activation.

Good:
> SKILL.md contains 40 lines of routing with `> See references/api-reference.md for endpoint details` and `> Use templates/request-template.md for the payload format`. Detail files loaded only when the agent reaches that step.


**Validated:** /feedback retrofit (2026-03-27) — improved from 1/8 to 8/8 validator score
---

### EOP-03: Gotchas Are Highest Signal [DERISK]

**Statement:** The most valuable content in any skill is the documented failure patterns — the gotchas section carries institutional memory of what goes wrong.

**Why this matters:** AI agents have no memory between sessions. They cannot learn from past mistakes unless those mistakes are explicitly written down and loaded into context. A gotchas section is the mechanism that turns a painful one-time failure into a permanent guardrail. Without it, every new session risks repeating the same error because the agent starts fresh each time with zero knowledge of prior failures.

**Without this:** Session 1: the agent formats dates as MM/DD/YYYY, breaking the European reporting pipeline. You fix it manually. Session 2: new session, no memory. The agent formats dates as MM/DD/YYYY again. Session 3: same mistake. This repeats indefinitely because the failure pattern was never documented in the skill.

**Implemented by:**
- Design: Add a `## Gotchas` section in SKILL.md or create a dedicated `gotchas.md` file. Document each failure with: what went wrong, why, and the correct approach.
- Validator: CHECK-05 in `skill-validator.sh` — gotchas section in SKILL.md or gotchas.md file exists

**Example:**

Bad:
> SKILL.md has clear procedures but no gotchas section. The skill has been used for 20 sessions, and the same 3 errors keep recurring.

Good:
> SKILL.md includes: `## Gotchas` / `- Date format: ALWAYS use ISO 8601 (YYYY-MM-DD). MM/DD/YYYY breaks EU pipelines.` / `- File paths: Use absolute paths. Relative paths break when cwd changes between bash calls.`


**Validated:** /feedback retrofit (2026-03-27) — improved from 1/8 to 8/8 validator score
---

### EOP-04: Description Is Trigger [OUTPUT]

**Statement:** The description field in YAML frontmatter is a trigger condition that determines when the agent activates the skill, not a passive summary.

**Why this matters:** At session start, the agent reads all skill descriptions (roughly 30-50 tokens each) and decides which skills to activate based on matching the user's request against those descriptions. A vague description causes two failure modes: false positives (skill activates when irrelevant, wasting context) and false negatives (skill never activates when needed, defeating its purpose). Action verbs and specific scenario language make the matching accurate.

**Without this:** Your skill for generating changelog entries has the description "helps with project documentation." The agent activates it when the user asks to write a README (false positive) and ignores it when the user says "update the changelog" (false negative, because "changelog" does not appear in the description).

**Implemented by:**
- Design: Write a description with action verbs and concrete scenarios. Include the key nouns and verbs a user would say when they need this skill. Test mentally: "If the user says X, would this description match?"
- Validator: CHECK-03 (description is 50+ characters) + CHECK-04 (trigger language patterns detected) in `skill-validator.sh`

**Example:**

Bad:
> `description: "Helps with code quality"`

Good:
> `description: "Generate changelog entries when the user commits, merges a PR, or says 'update changelog'. Formats entries per Keep a Changelog convention."`


**Validated:** /feedback retrofit (2026-03-27) — improved from 1/8 to 8/8 validator score
---

### EOP-05: Context Budget Sizing [DERISK]

**Statement:** The routing body of SKILL.md must stay at or under 200 lines to preserve model accuracy on loaded content.

**Why this matters:** Every line in SKILL.md consumes context window tokens when the skill is activated. Models lose accuracy on information positioned in the middle of long contexts — the "lost in the middle" phenomenon causes measurable degradation. A 400-line SKILL.md means the agent is less likely to follow instructions on lines 150-250 than instructions at the start or end. By keeping the routing layer under 200 lines, you ensure the agent can attend to the full skill content with minimal accuracy loss.

**Without this:** Your SKILL.md grows to 350 lines over time as new procedures are added inline. The agent reliably follows steps 1-3 (near the top) and the final validation step (near the bottom) but intermittently skips steps 5-8 (in the middle). You debug for hours before realizing the content positioning is the problem.

**Implemented by:**
- Design: Keep SKILL.md at or under 200 lines. When it grows beyond that, extract detail into references/ subdirectory files. The 200-line limit applies to SKILL.md only — referenced files have no hard limit.
- Validator: CHECK-08 in `skill-validator.sh` — SKILL.md is 200 lines or fewer

**Example:**

Bad:
> SKILL.md is 310 lines. Lines 120-220 contain critical error-handling procedures that the agent skips 30% of the time.

Good:
> SKILL.md is 90 lines of routing. Line 45: `> Load references/error-handling.md for the full error recovery procedure`. The referenced file is 120 lines but only loaded when the agent reaches the error-handling step.


**Validated:** /feedback retrofit (2026-03-27) — improved from 1/8 to 8/8 validator score
---

### EOP-06: Validation Gates [DERISK]

**Statement:** Multi-step procedures need explicit checkpoints (gates) between steps where the agent verifies the previous step succeeded before proceeding.

**Why this matters:** Without gates, an error in an early step silently propagates through all subsequent steps. The agent does not inherently pause to verify intermediate results — it executes step after step in a forward pass. By the time the procedure completes, a step-2 error has compounded through steps 3-8 into an output that is wrong in ways that are difficult to diagnose. A gate forces the agent to stop, check, and only proceed if the check passes.

**Without this:** Your deployment skill has 6 steps: build, test, package, upload, deploy, verify. Step 2 (test) produces a warning that should block deployment. Without a gate, the agent treats the warning as informational and proceeds through steps 3-6. The broken build reaches production.

**Implemented by:**
- Design: Insert gate keywords between critical steps: `GATE:`, `HARD-GATE:`, `Do NOT proceed until`, `must pass before continuing`. A HARD-GATE means stop entirely and report to user. A soft GATE means retry once, then escalate.
- Validator: CHECK-07 in `skill-validator.sh` — gate language present (waived for skills with 40 lines or fewer)

**Example:**

Bad:
> `1. Run tests` / `2. Build package` / `3. Deploy to staging` — no checkpoints, agent proceeds regardless of test results.

Good:
> `1. Run tests` / `GATE: All tests must pass. If any test fails, do NOT proceed. Report failures to user.` / `2. Build package` / `GATE: Build exit code must be 0.` / `3. Deploy to staging`


**Validated:** Partial — /feedback retrofit confirmed structure; full validation pending on STANDARD/COMPLEX tier skills
---

### EOP-07: Don't State the Obvious [OUTPUT]

**Statement:** Skill content should focus on information that pushes the agent beyond its default coding knowledge — if the agent would do the same thing without the skill, that content is wasted tokens.

**Why this matters:** AI models already have extensive general programming knowledge from training. A skill that repeats what the model already knows (how git commit works, what a function is, basic syntax) wastes context tokens without adding value. Wasted tokens are not neutral — they actively dilute the signal of the unique, project-specific content that the skill exists to provide. Every line should earn its place by containing knowledge the agent would not have otherwise.

**Without this:** Your commit message skill spends 30 lines explaining what git commit does, what a commit message is, and why version control matters. The agent already knows all of this. The 5 lines that actually matter — your specific commit format convention (`type(zone): description`) — are buried in noise, and the agent sometimes ignores them in favor of its default format.

**Implemented by:**
- Design: For each line in SKILL.md, ask: "Would the agent do this differently without this line?" If no, delete the line. Focus on: project conventions, team-specific formats, domain terminology, non-obvious constraints, and hard-won lessons.
- Validator: Qualitative — no automated check

**Example:**

Bad:
> `## How to Commit` / `Git is a version control system. To commit changes, use git commit -m "message". A good commit message explains what changed and why.` / `Use format: type(zone): description`

Good:
> `## Commit Format` / `ALWAYS: type(zone): description` / `Types: feat, fix, docs, refactor, test, chore` / `Zones: align, plan, execute, improve` / `Example: feat(align): add stakeholder analysis to charter`


**Validated:** Partial — /feedback retrofit confirmed structure; full validation pending on STANDARD/COMPLEX tier skills
---

### EOP-08: Escape Hatches [DERISK]

**Statement:** When a procedure fails (tool unavailable, unexpected state, repeated errors), the agent needs an explicit fallback path — without one, it either hallucinates a recovery or silently skips the failed step.

**Why this matters:** AI agents do not handle unexpected failures gracefully by default. When a tool call fails or a step produces unexpected output, the agent's training pushes it toward producing a plausible next action — which may be completely wrong. An escape hatch provides a pre-defined, human-approved recovery path that prevents the agent from improvising in a failure state. This is especially critical for destructive operations where a wrong recovery could cause data loss.

**Without this:** Your deployment skill calls a staging API. The API is down. Without an escape hatch, the agent either retries indefinitely (wasting tokens and time), skips the staging step and deploys directly to production, or invents an alternative deployment path that does not exist. All three outcomes are worse than stopping and telling the user.

**Implemented by:**
- Design: After each step that can fail, add: "If X fails after N retries, do Y instead" or "If this step cannot succeed, stop and tell the user Z." Use keywords: `escape`, `fallback`, `if.*fails`, `abort`.
- Validator: Qualitative — checked via presence of "escape" or "fallback" or "if.*fails" patterns (advisory only)

**Example:**

Bad:
> `3. Push to remote` — no fallback. If push fails due to auth, the agent retries with escalating creativity until it force-pushes or gives up silently.

Good:
> `3. Push to remote` / `If push fails with auth error: stop and tell the user "Push failed — check SSH key or PAT token."` / `If push fails with conflict: stop and tell the user "Remote has diverged — manual merge required."`

---


**Validated:** Partial — /feedback retrofit confirmed structure; full validation pending on STANDARD/COMPLEX tier skills

## Part 3 — Diagnostic Table

When a skill misbehaves, trace the symptom to the violated principle:

| Symptom | Likely Violated EOP | Fix |
|---------|---------------------|-----|
| Skill never triggers when needed | EOP-04 (Description Is Trigger) | Rewrite description with action verbs and scenario-specific nouns the user would say |
| Agent ignores procedure steps mid-skill | EOP-06 (Validation Gates) | Add GATE checkpoints between critical steps to force verification |
| Same mistake repeats every session | EOP-03 (Gotchas Are Highest Signal) | Document the failure pattern in a gotchas section or gotchas.md file |
| Context bloated after skill loads | EOP-05 + EOP-02 (Budget + Disclosure) | Extract detail to references/ subdirectory; keep SKILL.md under 200 lines |
| Skill loads but agent seems confused | EOP-02 (Progressive Disclosure) | Restructure SKILL.md as routing layer; move procedures to referenced files |
| Agent does exactly what it would without the skill | EOP-07 (Don't State the Obvious) | Delete lines the agent already knows; focus on project-specific conventions |
| Agent cannot recover from a failed step | EOP-08 (Escape Hatches) | Add explicit fallback instructions after each step that can fail |
| Skill triggers on unrelated requests | EOP-04 (Description Is Trigger) | Make description more specific; add scenario constraints |
| Agent skips mid-document instructions | EOP-05 (Context Budget Sizing) | SKILL.md is too long; extract middle content to referenced files |

---

## Part 4 — Validator Cross-Reference

| EOP Principle | CHECK-ID | Automated? | What It Checks |
|---------------|----------|------------|----------------|
| EOP-01: Skills Are Folders | CHECK-01 | Yes | SKILL.md exists inside a directory |
| EOP-02: Progressive Disclosure | CHECK-06 | Yes | references/ or templates/ directory exists (waived if SKILL.md is 40 lines or fewer) |
| EOP-03: Gotchas Are Highest Signal | CHECK-05 | Yes | `## Gotchas` section in SKILL.md or gotchas.md file present |
| EOP-04: Description Is Trigger | CHECK-03 + CHECK-04 | Yes | Description is 50+ characters; trigger language patterns detected |
| EOP-05: Context Budget Sizing | CHECK-08 | Yes | SKILL.md is 200 lines or fewer |
| EOP-06: Validation Gates | CHECK-07 | Yes | Gate keywords present (waived if SKILL.md is 40 lines or fewer) |
| EOP-07: Don't State the Obvious | — | No | Qualitative review — no automated check |
| EOP-08: Escape Hatches | — | Advisory | Pattern scan for "escape", "fallback", "if.*fails" (advisory, not blocking) |

---

## Part 5 — Iteration Roadmap

### v1 (current) — 8 Principles

EOP-01 through EOP-08 as specified above. Covers folder structure, context management, failure documentation, trigger design, budget sizing, validation gates, signal quality, and error recovery.

### v2 Candidates

| ID | Working Name | Focus |
|----|-------------|-------|
| EOP-09 | Idempotent Procedures | Skills should produce the same result when run twice — no double-creation, no duplicate entries |
| EOP-10 | Version Pinning | Skills that reference external tools or APIs should pin versions or check compatibility |
| EOP-11 | Cross-Skill Isolation | One skill must not silently depend on another skill's state or output |
| EOP-12 | Human Gate Placement | Define where human confirmation is mandatory vs. where the agent can proceed autonomously |
| EOP-13 | Output Format Contract | Skills should declare their output format (file, console, commit, etc.) so callers know what to expect |
| EOP-14 | Skill Composition | Rules for one skill invoking another — dependency declaration, load order, context budget sharing |

### v3 Scope

Multi-agent skill orchestration: how skills behave when multiple agents share a workspace, conflict resolution between overlapping skills, and skill versioning across template consumers.

---

## Iteration Roadmap

| Version | Scope | Status |
|---|---|---|
| **v1 (current)** | 8 principles, 8 validator checks, /feedback test case | Validated — baseline 1/8 → post 8/8 |
| v2 | +EOP-09 Start Simple Iterate, +EOP-10 Append-Only Logging, +EOP-11 Pre-Built Scripts, +EOP-12 Trigger Exclusivity, +EOP-13 Don't Overspecify, +EOP-14 Tiered Complexity | Pending — after 3+ skills retrofitted |
| v3 | Auto-fix suggestions, CI integration, cross-platform portability | Pending — after v2 stable 2+ months |

---

## Appendix — Glossary

| Term | Definition |
|------|-----------|
| **EOP** | Effective Operating Procedure — a reusable, agent-readable procedure (skill) that compensates for structural AI limitations. One of the 7 components in the LTC agent system. |
| **SKILL.md** | The entry-point file of every skill directory. Contains routing instructions, YAML frontmatter (name, description, type), and pointers to detail files. The agent reads this first when a skill activates. |
| **Gotchas** | Documented failure patterns — things that went wrong in past sessions and should not be repeated. Highest-signal content because agents have no memory between sessions. |
| **Gate** | An explicit checkpoint in a multi-step procedure where the agent must verify the previous step succeeded before continuing. HARD-GATE = stop and report. Soft GATE = retry once, then escalate. |
| **Escape Hatch** | A pre-defined fallback path the agent follows when a procedure step fails. Prevents the agent from improvising recovery in a failure state. |
| **Progressive Disclosure** | A design pattern where top-level files contain routing instructions and detail is loaded on demand from subdirectories. Keeps the context window lean. |
| **Trigger Description** | The YAML description field in SKILL.md frontmatter, written as a trigger condition (action verbs + scenarios) rather than a passive summary. Determines when the agent activates the skill. |
| **Context Budget** | The practical limit on how much text a skill can load before model accuracy degrades. For SKILL.md routing files, the budget is 200 lines. Referenced detail files have no hard limit because they are loaded selectively. |

---

*Codex maintained by: Long Nguyen + Claude (Research & Governance Agent)*
*Source material: AMT Session 4 (EOP), Anthropic Claude Code team practices, LTC Effective Principles Registry*
*Update protocol: When a new EOP principle is validated, add to this codex and update skill-validator.sh.*
