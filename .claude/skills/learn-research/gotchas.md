# /learn:research — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Invoking /deep-research skill

**What happens:** Sub-agents invoke /deep-research instead of following the shared methodology. This causes format collision — /deep-research outputs a different structure than the 6-section Effective Learning format.

**How to detect:** Check sub-agent output for /deep-research headers or citation styles that don't match the 6-section template.

**Fix:** The sub-agent prompt explicitly says "Do NOT invoke the /deep-research skill." If it still happens, ensure the sub-agent description does not mention "research" in a way that triggers skill matching.

---

## 2. Running topics sequentially

**What happens:** Agent spawns sub-agents one at a time instead of all simultaneously. Wastes time and defeats the parallel model.

**How to detect:** Check whether all Agent tool calls appear in a single message or are spread across multiple turns.

**Fix:** All topics must launch in a single message with multiple Agent tool calls.

---

## 3. Silently dropping partial topics

**What happens:** A sub-agent fails or produces partial output, and the orchestrator doesn't flag it. User proceeds to /learn:structure with gaps.

**How to detect:** In Step 4, check every topic for status "partial", file size <2000 chars, or [NEEDS REVIEW] markers.

**Fix:** Any partial topic must be reported with retry options. Never silently proceed.

---

## 4. Tool unavailability not handled

**What happens:** EXA is unavailable and sub-agent produces empty or hallucinated research instead of falling back to QMD.

**How to detect:** Output files with 0 citations or fabricated URLs.

**Fix:** Follow the escape hatch table in SKILL.md Step 3. If ALL tools unavailable, stop and report — never generate empty research.

---

## 5. Source count gate bypassed

**What happens:** Topics proceed with <8 sources without user acknowledgment.

**How to detect:** Check frontmatter `source_count` in each output file.

**Fix:** The HARD-GATE in Step 4 blocks progression. User must explicitly choose option (a) re-research or (b) proceed with `limited-sources` flag.

## Links

- [[SKILL]]
- [[methodology]]
