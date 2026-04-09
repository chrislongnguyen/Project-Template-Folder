# /ingest Gotchas

## G1: Surface-level summaries (most common)

**Symptom:** Distilled page only answers L1 questions ("what is it") without reaching L2 ("why does it work/fail").
**Fix:** Every page MUST reach L2 minimum (6/12 questions). If the source doesn't contain enough depth for L2, flag it as shallow and note which L2 questions remain unanswered.
**EP:** EP-10 (Define Done) — L2 is the acceptance criterion.

## G2: Entity/synthesis confusion

**Symptom:** A page titled "X patterns" is actually a single-concept entity page, or a page titled "What is X" contains cross-topic synthesis.
**Fix:** Read the decision criteria in `references/schema.md`. Entity = one concept. Synthesis = cross-topic pattern from ≥3 entities.
**EP:** EP-09 (Decompose) — one concept per page.

## G3: Forgetting to update _index.md and _log.md

**Symptom:** Page exists in distilled/ but QMD auto-recall doesn't surface it. Dashboard shows stale data.
**Fix:** Steps 4 and 5 of the pipeline are mandatory. Every ingest must append to _log.md AND update _index.md. Check both after every ingest run.
**EP:** EP-10 (Define Done) — index + log are acceptance criteria.

## G4: Duplicate pages for the same concept

**Symptom:** Two pages cover the same topic with slightly different names.
**Fix:** Step 2 of the pipeline (check _index.md) prevents this. Always read _index.md before creating a new page. If a related page exists, UPDATE it instead of creating a new one.
**EP:** EP-07 (Amnesia-First) — the agent doesn't remember what's already ingested; _index.md is the memory.

## G5: Losing source attribution

**Symptom:** Distilled page has no `source` frontmatter or Sources section.
**Fix:** Every page must have `source:` in frontmatter pointing to the captured/ file, and a Sources section with `[[links]]` to the original.
**EP:** EP-12 (Verified Handoff) — traceability from output to input.

## G6: Large source treated as small (context overflow)

**Symptom:** Agent reads entire 31K-line file into context, output degrades mid-ingest (hallucinated sections, missing later content, truncated pages).
**Root cause:** LT-2 (context compression is lossy) + LT-3 (reasoning degrades on complex tasks). A 2MB source exceeds effective context utilisation.
**Fix:** Use the Decision Tree in SKILL.md. Sources >100KB use Chunked pipeline; >500KB use Parallel pipeline with Agent dispatch. Never single-pass a large source.
**EP:** EP-04 (Load What You Need) + EP-09 (Decompose Before You Delegate).

## G7: Cross-section links missing in multi-page ingest

**Symptom:** Pages from same source don't link to each other. Graph is disconnected.
**Root cause:** Each page written independently without checking what other pages were created in the same ingest run.
**Fix:** After all pages for a source are written (Step 3), do a cross-linking pass: read all new page titles, add `[[links]]` between related pages. In parallel pipeline, this happens in Phase 3 (Synthesis).
**EP:** EP-13 (Orchestrator Authority) — synthesis is the orchestrator's job.

## G8: Modifying captured/ files

**Symptom:** Source file in captured/ has been edited, cleaned up, or reformatted.
**Root cause:** Agent treats captured/ as working space instead of immutable archive.
**Fix:** captured/ is IMMUTABLE. Never edit, rename, or delete files there. All transformation happens in distilled/. If a source needs cleanup, note it in the page's Sources section, don't change the original.
**EP:** EP-01 (Brake Before Gas) — preserve the original before transforming.

## G9: Version/status not set on new pages

**Symptom:** New distilled page has no version or status in frontmatter, or version is "0.1".
**Fix:** All new pages in Iteration 2 start at `version: "2.0"`, `status: Draft`, `last_updated: {today}`. Level is derived from questions_answered count — never declared. Follow `rules/versioning.md`.
**EP:** EP-10 (Define Done) — metadata is an acceptance criterion.

## G10: QMD not re-embedded after ingest

**Symptom:** New pages exist in distilled/ but QMD semantic search doesn't find them.
**Root cause:** QMD needs `qmd embed` after new files are added to update vector index.
**Fix:** After ingest, remind user to run `qmd embed` (or it runs automatically on next session start if configured). The post-validation `pkb-lint.sh` check will warn about unembedded files in future versions.
**EP:** EP-14 (Script-First Delegation) — embedding is a deterministic operation.
**Post-ingest command:** `qmd update distilled && qmd embed` — add to Validation Gate if QMD distilled collection is configured.
**Recovery:** If `qmd embed` fails with UNIQUE constraint errors, run `qmd embed -f` once to rebuild (takes ~5min on M3).

## Links

- [[EP-01]]
- [[EP-04]]
- [[EP-07]]
- [[EP-09]]
- [[EP-10]]
- [[EP-12]]
- [[EP-13]]
- [[EP-14]]
- [[SKILL]]
- [[_index]]
- [[_log]]
- [[dashboard]]
- [[schema]]
- [[versioning]]
