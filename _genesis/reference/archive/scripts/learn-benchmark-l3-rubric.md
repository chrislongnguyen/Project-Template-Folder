# L3: LEARN Skills LLM-as-Judge Rubric

# version: 1.0 | status: draft | last_updated: 2026-04-08

## Instructions for the Judge

You are evaluating a LEARN pipeline skill file (SKILL.md) for compliance across
3 dimensions: Safety/Accuracy (S), Efficiency (E), and Scalability/Autonomy (Sc).

Score each dimension 1-5. Provide a one-line justification per score.

## Rubric

### S1: Output Path Safety
Does the skill guarantee all output lands in `2-LEARN/_cross/` subdirectories?
- 1: No path control — output location is ambiguous or unspecified
- 2: Path mentioned but not enforced (suggestion only)
- 3: Path specified in instructions but no pre-check validates it
- 4: Path specified + pre-check creates/validates the directory
- 5: Path hardcoded + pre-check + explicit prohibition of other locations

### S2: DSBV Contamination Prevention
Can this skill accidentally create DSBV artifacts (DESIGN.md, SEQUENCE.md, VALIDATE.md) in LEARN directories?
- 1: Likely — skill references DSBV concepts without distinguishing LEARN context
- 2: Possible — no explicit guard against DSBV file creation
- 3: Unlikely — skill focuses on LEARN artifacts but has no explicit prohibition
- 4: Very unlikely — skill mentions LEARN-only context
- 5: Impossible — explicit guard exists (e.g., "NEVER create DSBV files in 2-LEARN/")

### S3: Human Gate Enforcement
Are human approval gates present where the skill makes irreversible decisions?
- 1: Skill auto-approves or auto-validates without human check
- 2: Human mentioned but not enforced (can be bypassed)
- 3: HARD-GATE exists but enforcement language is weak
- 4: HARD-GATE with clear enforcement language
- 5: HARD-GATE + explicit "NEVER auto-approve" + specific human actions required

### E1: Model Tier Appropriateness
Is the declared model (or implicit model via agent type) appropriate for the cognitive load?
- 1: Grossly mismatched (Opus for file listing, Haiku for synthesis)
- 2: Overprovisioned — could use a cheaper tier without quality loss
- 3: Acceptable but not optimal
- 4: Well-matched to task complexity
- 5: Optimal — model matches cognitive load with explicit justification

### E2: Tool Minimality
Does the skill declare only the tools it actually needs?
- 1: All tools allowed or no tool declaration
- 2: Excessive tools (>7) or tools clearly unnecessary for the task
- 3: Reasonable set but includes 1-2 questionable tools
- 4: Minimal set — every tool is justified by the workflow
- 5: Exact minimal set with explicit justification for each

### E3: Agent Dispatch Efficiency
Does the skill avoid unnecessary agent overhead?
- 1: Dispatches agents for tasks the orchestrator could handle
- 2: Uses agents but could achieve same result without them
- 3: Agent use is reasonable but not clearly justified
- 4: Agent dispatch is clearly needed (parallel work or specialist knowledge)
- 5: Optimal — agents only where parallel/specialist value, with explicit rationale

### Sc1: Prerequisite Self-Diagnosis
Can the skill detect and report missing prerequisites?
- 1: Crashes or produces garbage on missing input
- 2: Silently skips missing inputs
- 3: Detects missing input but gives vague error
- 4: Detects missing input + names which upstream skill to run
- 5: Detects missing input + names upstream skill + shows exact command to run

### Sc2: Filesystem-Derived State
Does state detection rely on filesystem scanning, not conversation history or memory?
- 1: Relies on user telling it the current state
- 2: Mixes filesystem and conversation-based state
- 3: Primarily filesystem but with conversation fallbacks
- 4: Filesystem-only with explicit "no state file" declaration
- 5: Filesystem-only + HARD-GATE prohibiting state files + re-scans on every invocation

### Sc3: Cross-Skill Handoff Integrity
Are handoffs to/from other skills explicit and verifiable?
- 1: Implicit assumptions about what upstream skills produced
- 2: References upstream outputs but doesn't verify they exist
- 3: Checks upstream output existence but not content
- 4: Verifies upstream output exists + checks basic structure (frontmatter)
- 5: Verifies existence + structure + specific content requirements (e.g., status: validated)

## Output Format

Return a JSON object:

```json
{
  "skill": "<skill-name>",
  "scores": {
    "S1": {"score": N, "justification": "..."},
    "S2": {"score": N, "justification": "..."},
    "S3": {"score": N, "justification": "..."},
    "E1": {"score": N, "justification": "..."},
    "E2": {"score": N, "justification": "..."},
    "E3": {"score": N, "justification": "..."},
    "Sc1": {"score": N, "justification": "..."},
    "Sc2": {"score": N, "justification": "..."},
    "Sc3": {"score": N, "justification": "..."}
  },
  "fail_dimensions": ["<any dimension ≤ 2>"],
  "warn_dimensions": ["<any dimension = 3>"]
}
```

## Links

- [[AGENTS]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[task]]
