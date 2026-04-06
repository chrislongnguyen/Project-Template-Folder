---
version: "1.2"
last_updated: 2026-04-06
owner: "Long Nguyen"
name: learn
description: >
  Use when starting or continuing a learning pipeline for any subject. Orchestrates the full
  learn cycle: input → research → structure → review → spec. Derives pipeline state from
  the file system — no stored state file. Routes to the correct sub-skill automatically.
argument-hint: [system-slug]
allowed-tools: Read, Glob, Grep, Skill
---
# /learn — Learning Pipeline Orchestrator

State-aware orchestrator that derives pipeline state from a file system scan and routes to
the correct sub-skill. Does NOT perform learning work itself — every action is delegated
to a sub-skill via the Skill tool.

## Arguments

Optional: `{system-slug}` — identifies which learning subject to resume.

If omitted, scan `2-LEARN/_cross/input/` for files matching `learn-input-*.md`.
- If exactly one exists, use that slug automatically.
- If multiple exist, list them and ask the user to choose.
- If none exist, route directly to `/learn:input`.

## State Derivation Logic

Derive state from the file system on EVERY invocation. No state file. First matching
condition wins — scan top-down:

```
 #  File System Condition                                              State              Route
─── ────────────────────────────────────────────────────────────────── ────────────────── ──────────────────────────────────
 1  No learn-input-{slug}.md in 2-LEARN/_cross/input/          No input           → /learn:input
 2  Input exists, no 2-LEARN/_cross/research/{slug}/ directory Input ready        → /learn:research {slug}
 3  Research dir exists, any topic lacks 6 P-pages with                Research done,     → /learn:structure {slug} {topic}
    status: approved in frontmatter                                    not fully done       then /learn:review {slug} {topic}
 4  All topics status: approved, no specs/{slug}/vana-spec.md          All approved       → /learn:spec {slug}
 5  VANA-SPEC exists                                                   Pipeline complete  → completion message
```

## State Detection Procedure

```
1. Glob for 2-LEARN/_cross/input/learn-input-{slug}.md
   - If no match → STATE 1

2. Read the input file, extract system-slug from frontmatter

3. Glob for 2-LEARN/_cross/research/{slug}/*.md
   - If no research dir or no files → STATE 2

4. For each topic file in research/{slug}/:
   a. Glob for structured P-pages: research/{slug}/{topic}/P0.md .. P5.md
   b. Read each P-page, check frontmatter for status: approved
   c. If ANY topic is missing pages or has non-approved status → STATE 3
      (report which topics need work)

5. Glob for 2-LEARN/_cross/specs/{slug}/vana-spec.md
   - If not found → STATE 4

6. → STATE 5 (complete)
```

## Flow

```
/learn
  │
  ├─ scan file system
  │
  ├─ STATE 1: no input ──────────► /learn:input
  ├─ STATE 2: input, no research ─► /learn:research {slug}
  ├─ STATE 3: research, not done ──► /learn:structure + /learn:review (per topic)
  ├─ STATE 4: all approved ────────► /learn:spec {slug}
  └─ STATE 5: complete ────────────► completion message
```

## Completion Message (State 5)

When pipeline is complete, print this summary:

```
Pipeline complete for: {system_name}
├── Input:      2-LEARN/_cross/input/learn-input-{slug}.md
├── Research:   2-LEARN/_cross/research/{slug}/ ({N} topics)
├── Structured: {N} topics x 6 pages = {N*6} P-pages (all approved)
├── VANA-SPEC:  2-LEARN/_cross/specs/{slug}/vana-spec.md
└── DSBV-READY: 2-LEARN/_cross/specs/{slug}/DSBV-READY-{slug}.md

Next steps:
  /learn:visualize {slug}  — Generate interactive system map (optional, I2)
  /dsbv design             — Begin DSBV Design phase using Readiness Package
```

## Execution Instructions

1. Parse the optional `{system-slug}` argument.
2. If no slug provided, scan input dir as described in Arguments.
3. Run the State Detection Procedure above.
4. **Announce** the detected state and which sub-skill will be invoked.
5. Wait for user acknowledgment (implicit — proceed after announcement).
6. Invoke the sub-skill via the Skill tool.
7. After the sub-skill completes, re-run state detection to check for next step.
8. Repeat until State 5 or user exits.

For **State 3 (per-topic loop)**: process ONE topic at a time.
Run `/learn:structure {slug} {topic}`, then `/learn:review {slug} {topic}`,
then move to the next incomplete topic.

<HARD-GATE>
1. NEVER create or read a state file — derive state from file system EVERY invocation.
2. NEVER skip a state — if input exists but research doesn't, route to research, not structure.
3. NEVER auto-invoke a sub-skill without showing the user which state was detected and which skill will be invoked. Announce first, then invoke.
4. For State 3 (per-topic loop): process ONE topic at a time (structure → review → next topic).
</HARD-GATE>

## Gotchas

See [gotchas.md](gotchas.md) for common failure modes.

## Links

- [[DESIGN]]
- [[dsbv]]
- [[gotchas]]
