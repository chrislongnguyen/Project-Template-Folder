---
version: "2.0"
status: validated
last_updated: 2026-04-05
owner: Long Nguyen
workstream: GOVERN
iteration: I2
type: ues-deliverable
work_stream: 0-GOVERN
stage: design
---
# DESIGN.md — GOVERN: Personal Knowledge Base (PKB)

> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.
> Placement: `_genesis/` — GOVERN patches skip per-workstream folders.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Upstream sufficient? | YES — GOVERN exception. Input: Karpathy LLM Wiki research (session 2026-04-05), `_genesis/frameworks/learning-hierarchy.md` (L1–L4 depth targets), existing vault-capture skill (inbox/ staging), QMD MCP (retrieval layer), existing 2-LEARN/ pipeline (non-overlapping), `/setup` skill (QMD + vault config) |
| Q2: In scope? | (1) `PERSONAL-KNOWLEDGE-BASE/` folder scaffold + gitignore, (2) `README.md` instructional guide, (3) `distilled/_index.md` + `_log.md` stubs, (4) `/ingest` skill SKILL.md stub, (5) post-session hook reminder |
| Q2b: Out of scope? | Full `/ingest` implementation (I3), NotebookLM integration (rejected — unofficial API fragility), team-wide Tier 3 knowledge base, audio overview, Obsidian plugin auto-installation, modifying 2-LEARN/ or vault-capture |
| Q3: Go/No-Go | GO |

---

## Design Decisions

**Problem:** The full knowledge pipeline (Capture → Organise → Distill → Express) is unstructured for personal PKM. Learnings from sessions (e.g., Anthropic docs, official best practices) exist only in-session and are lost. No system accumulates personal wisdom that agents can auto-recall.

**Research (session 2026-04-05):**
- Karpathy LLM Wiki: strong Organise + Distill (compile-at-ingest, LLM-owned wiki, schema-first). Medium Capture friction. Pull-only Express.
- NotebookLM: strong bounded Distill. Weak Organise (flat, manual, siloed). Unofficial API = fragile. Rejected.
- Decision: adopt Karpathy pattern extended with QMD dual-collection indexing for the Express layer.

**2-Tier model:**

| Tier | Location | Scope | Consumer | Committed? |
|---|---|---|---|---|
| Tier 1 — Personal | `PERSONAL-KNOWLEDGE-BASE/` | Cross-project personal wisdom | Future AI agent sessions | No — gitignored |
| Tier 2 — Project | `2-LEARN/` | Problem domain research | 1-ALIGN, 3-PLAN (same project) | Yes |

These tiers serve different purposes, use different pipelines, and never overlap.

**PKB is NOT 2-LEARN.** 2-LEARN answers "what is the problem we're solving?" (9-question interview → UBS-UDS → VANA-SPEC → DSBV). PKB answers "what do I know that makes me better at solving problems?" (raw drops → wiki pages → auto-recall).

**3-dir pipeline (CODE framework):**

```
captured/   → (ingest skill) → distilled/   → (when needed) → expressed/
 C: Facts                      O+D: Wisdom                    E: Expertise
```

Originally 4 dirs (`organised/` + `distilled/` separate). Merged into 3: `distilled/` handles both organisation (sub-dir structure, `_index.md` catalog) and distillation (L1–L4 depth). Rationale: in Karpathy pattern, Organise and Distill happen simultaneously at ingest. A separate `organised/` dir would stay empty.

**Ingest depth (from `learning-hierarchy.md`):**

| Level | Questions | Target pages |
|---|---|---|
| L1 Knowledge | What is it? How does it work? | Every page |
| L2 Understanding | Why does it work? Why does it fail? | Every page (minimum) |
| L3 Wisdom | So what? Now what? | Core skill/framework pages |
| L4 Expertise | Anti-patterns? Alternatives? How to do better? | Architecture decision pages |

**Obsidian's role (earning its place):**

Obsidian is the human-facing UX layer, NOT the agent pipeline. QMD is the retrieval layer. Obsidian adds:

| Plugin | Role | Justification |
|---|---|---|
| Canvas + Canvas Mindmap | Visual knowledge maps | LTC members love visualization |
| Dataview | Learning dashboard, ingest staleness monitor | Interactive, live-updating |
| Learnie (spaced repetition) | Active recall on distilled/ pages | Beats NotebookLM flashcards |
| PDF++ | Read + annotate; highlights → captured/ | Ownership over reading materials |
| Callout blocks (built-in) | `[!tip]` `[!warning]` `[!example]` `[!note]` | Structured visual notes |

**Two ingest triggers:**
1. Manual: `/ingest` — PM drops source in captured/, runs command
2. Hook: post-session reminder — if agent read external docs during session but captured/ has uningested files, remind PM

**Artifact conventions (same rules as rest of repo):**

All PKB markdown files follow existing repo rules — gitignored does not mean exempt:
- YAML frontmatter: `version`, `status`, `last_updated` (per `rules/versioning.md`)
- Obsidian `[[links]]` for cross-referencing within distilled/
- Filenames follow LTC naming conventions (per `rules/naming-rules.md`)

LLM-generated wiki pages in `distilled/` use extended frontmatter for Dataview queries and QMD metadata. The `questions_answered` field tracks which of the 12 Learning Hierarchy questions have been answered — the learning level is **derived from coverage**, not declared:

```yaml
---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: skills                              # sub-dir / category
source: captured/anthropic-skill-docs.md
questions_answered:                        # per learning-hierarchy.md
  # L1 Knowledge (4 questions)
  - so_what_relevance      # So What? — Why is this important?
  - what_is_it             # What is it? — Definition and scope
  - what_else              # What else? — Related concepts, alternatives
  - how_does_it_work       # How does it work? — Mechanisms, processes
  # L2 Understanding (2 questions)
  - why_does_it_work       # Why does it work? — Underlying principles
  - why_not                # Why not? — When and why does it fail?
  # L3 Wisdom (2 questions)
  # - so_what_benefit      # So What? — How can we benefit?
  # - now_what_next        # Now What? — What should we do next?
  # L4 Expertise (4 questions)
  # - what_is_it_not       # Common misconceptions
  # - how_does_it_not_work # Anti-patterns to avoid
  # - what_if              # Alternatives if this fails
  # - now_what_better      # How can we do better than others?
# Derived: L1 (4/4) + L2 (2/2) = L2 complete. L3 = 0/2, not reached.
---
```

Level derivation rules:
- L1 complete = all 4 L1 questions answered
- L2 complete = L1 complete + both L2 questions answered
- L3 complete = L2 complete + both L3 questions answered
- L4 complete = L3 complete + all 4 L4 questions answered
- Minimum for any distilled/ page: L2 complete (6/12 questions)

**Template shipping:** The system (scaffold + skill + schema + hook) ships via the project template. Each PM clones the template and gets the empty PKB structure. They build their own knowledge — knowledge does not ship.

**Overlap audit:**

| Existing | Proposed | Verdict |
|---|---|---|
| `2-LEARN/` — project domain research | PKB — personal cross-project wisdom | **No overlap** — different purpose, pipeline, consumer |
| `2-LEARN/input/raw/` — raw stakeholder materials | `captured/` — raw personal source drops | **Same concept, different context** — separate dirs, separate parents |
| `2-LEARN/output/` — UBS-UDS, EPs for DSBV | `expressed/` — personal artifacts leaving PKB | **Same concept, different context** — separate dirs, separate parents |
| `inbox/` (vault root) — general staging | `captured/` — PKB-specific raw drops | **Complementary** — PM routes from inbox to captured if worth ingesting |
| `~/.claude/projects/memory/` — session agent memory | PKB — personal accumulated knowledge | **Different purpose** — memory = session state; PKB = compound wisdom |
| `/vault-capture` — quick dump to inbox/ | `/ingest` — schema-driven distillation pipeline | **Complementary** — vault-capture is capture; /ingest is organise+distill |

---

## Force Analysis

### UBS — Ultimate Blockers

| # | Blocker | Category | Severity | Mitigation |
|---|---|---|---|---|
| UBS-1 | Schema maintenance debt — ingest schema must co-evolve with domain or distillation degrades silently | Human | High | README embeds schema; schema is versioned; update when domain changes |
| UBS-2 | High-velocity capture outpaces wiki maintenance — pages go stale faster than ingested | Temporal | Medium | Dataview dashboard shows uningested files in captured/ not yet in _log.md |
| UBS-3 | Out-of-sight = out-of-mind — if PKB is outside repo, PMs forget it exists | Human | High | PKB lives in repo vault root — always visible in Obsidian sidebar |
| UBS-4 | LLM misclassification during ingest — entity pages vs synthesis pages conflated | Technical | Medium | /ingest skill schema specifies clear decision criteria; schema is versioned |
| UBS-5 | QMD not indexing PKB collection — auto-recall silently misses all PKB knowledge | Technical | High | /setup skill validates QMD collections; smoke test checks PKB collection |

### UDS — Ultimate Drivers

| # | Driver | Category |
|---|---|---|
| UDS-1 | Distil-at-ingest compounds over time — knowledge builds without recomputation | Technical |
| UDS-2 | LLM owns organisation — zero manual filing burden on PM | Human |
| UDS-3 | QMD auto-recall — agents surface knowledge without PM asking | Technical |
| UDS-4 | Obsidian visibility — PKB in vault root + Learnie keeps PM engaged | Human |
| UDS-5 | Learning Hierarchy L1–L4 enforces depth not breadth | Technical |

---

## Deliverable Structure (3 deliverables)

### D1: PERSONAL-KNOWLEDGE-BASE/ Scaffold

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A1 | README.md | `PERSONAL-KNOWLEDGE-BASE/README.md` | Full instructional guide (WHAT/WHAT NOT/Components/How it works/Setup/Why/Now what) | AC-01: All 7 sections present and complete. AC-02: References `_genesis/frameworks/learning-hierarchy.md` for L1–L4 depth targets. AC-03: Documents both ingest triggers (manual + hook). AC-04: Documents Obsidian plugin list with purpose per plugin. |
| A2 | Folder scaffold | `PERSONAL-KNOWLEDGE-BASE/{captured,distilled,expressed}/` | 3-dir CODE pipeline | AC-05: All 3 sub-dirs exist at `PERSONAL-KNOWLEDGE-BASE/`. |
| A3 | _index.md | `PERSONAL-KNOWLEDGE-BASE/distilled/_index.md` | LLM-maintained catalog | AC-06: File exists with YAML frontmatter (version, status, last_updated) and empty catalog section. |
| A4 | _log.md | `PERSONAL-KNOWLEDGE-BASE/distilled/_log.md` | Append-only ingest history | AC-07: File exists with YAML frontmatter and empty log section with documented format (date, source, pages). |
| A5 | .gitignore entry | `.gitignore` | PKB is gitignored | AC-08: `.gitignore` contains `PERSONAL-KNOWLEDGE-BASE/` line. `git status` shows no PKB files. |

### D2: /ingest Skill Stub

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A6 | SKILL.md | `.claude/skills/pkb/ingest/SKILL.md` | Skill definition: schema, process, L1–L4 depth targets, two triggers | AC-09: Skill trigger matches `/ingest` or "ingest knowledge" or "process captured". AC-10: Schema section specifies entity-page vs synthesis-page criteria. AC-11: Process section documents the 5-step pipeline (read → check index → write pages → log → update index). AC-12: L1–L4 depth targets reference learning-hierarchy.md. AC-13: Both ingest triggers documented (manual + hook). AC-14: Schema section specifies extended frontmatter for wiki pages (version, status, last_updated, topic, source, questions_answered list per learning-hierarchy.md 12 questions). Level is derived from coverage, not declared. Requires Obsidian `[[links]]` for cross-references. |

### D3: Post-Session Hook Reminder

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A7 | Hook script | `scripts/pkb-ingest-reminder.sh` | Check if captured/ has uningested files; print reminder | AC-15: Script compares files in captured/ against entries in _log.md. AC-16: Prints reminder only when uningested files exist. AC-17: Exits 0 always (reminder, not blocker). |
| A8 | settings.json entry | `.claude/settings.json` | Wire hook to post-session event | AC-18: PostToolUse or session-end event wired to run pkb-ingest-reminder.sh. |

### D4: Obsidian UX Configuration

PM installs plugins manually. Agent configures dashboards, templates, and review metadata.

| # | Artifact | Path | Purpose | ACs |
|---|----------|------|---------|-----|
| A9 | Learning dashboard | `PERSONAL-KNOWLEDGE-BASE/dashboard.md` | Dataview queries: pages by learning level, staleness monitor, recent ingests, topic distribution | AC-19: File contains ≥4 Dataview query blocks (level distribution, uningested files, recent ingests, topic counts). AC-20: Queries reference `questions_answered` frontmatter and _log.md format from DESIGN spec. |
| A10 | Knowledge map canvas | `PERSONAL-KNOWLEDGE-BASE/knowledge-map.canvas` | Starter Canvas for visual knowledge mapping | AC-21: Valid .canvas JSON with placeholder nodes for captured/, distilled/, expressed/ flow and empty topic groups. |
| A11 | Spaced repetition config | Extended frontmatter in /ingest SKILL.md | `review: true` + `review_interval` fields in wiki page frontmatter template | AC-22: /ingest SKILL.md frontmatter spec includes `review: true` (default) and `review_interval: 7` (days) fields. Learnie-compatible. |
| A12 | Plugin install checklist | Section in README.md | Step-by-step install + minimum config per plugin | AC-23: README §Setup lists each plugin (Canvas Mindmap, Dataview, Learnie, PDF++) with install instructions and minimum config settings. |

---

## Alignment Check

```
Deliverables: 4 (D1–D4)
Artifacts:    12 (A1–A12)
ACs:          23 (AC-01 through AC-23)
Orphan ACs:   0
Orphan artifacts: 0

Trace:
  D1: Knowledge pipeline gap — PMs have no structured place for personal cross-project wisdom
  D2: Ingest process gap — no skill converts raw sources into distilled wiki pages
  D3: Human adoption gap — without reminder, PM forgets to ingest after sessions
  D4: Learning UX gap — Obsidian has the plugins but no configured dashboards, templates, or review metadata

Shipping constraint:
  All artifacts must work on fresh clone. QMD integration is graceful-skip (not required).
  Obsidian plugins are documented, not auto-installed.
  PERSONAL-KNOWLEDGE-BASE/ is gitignored — ships empty scaffold only.
```

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Sequential single-agent — scaffold + skill text + shell script |
| Agent config | Main context only — small artifacts, clear specs |
| Git strategy | 1 commit: `feat(govern): PERSONAL-KNOWLEDGE-BASE scaffold + /ingest skill stub` |
| Human gates | G1=this DESIGN. G2=SEQUENCE ordering. G3=review before commit. G4=validate 17 ACs |
| Cost estimate | ~15K tokens total |

---

## Dependencies

| Dependency | Status |
|---|---|
| `_genesis/frameworks/learning-hierarchy.md` — L1–L4 depth targets | Ready |
| QMD MCP server — retrieval layer for auto-recall | Ready (graceful-skip if not installed) |
| `.gitignore` — needs PKB entry added | Ready (entry already drafted) |
| `/setup` skill — QMD collection validation | Ready |
| `vault-capture` skill — complementary inbox capture | Ready |
| `2-LEARN/` pipeline — non-overlapping, verified | Ready |

---

## System Boundaries

### What crosses IN to PKB
- External docs agent reads during sessions (Anthropic docs, articles, research)
- Obsidian Web Clipper captures (inbox/ → human routes to captured/)
- Session transcripts or learnings worth preserving cross-project

### What crosses OUT of PKB
- `expressed/` artifacts → any project, `2-LEARN/input/`, team docs
- QMD auto-recall → agent context in any future session

### What NEVER crosses
- Project-specific domain research (stays in 2-LEARN/)
- PKB content → git (gitignored, always)
- Team knowledge (no Tier 3 — each PM builds their own)

### Adjacent systems
- `inbox/` (vault root): general staging — PM manually routes to captured/
- `2-LEARN/`: complementary, not overlapping. PKB can seed 2-LEARN/input/ optionally
- `~/.claude/projects/memory/`: session agent memory — different purpose, different consumer

---

[[DESIGN]]
[[pkb]]
[[knowledge]]
[[ingest]]
[[govern]]
[[obsidian]]
[[qmd]]
