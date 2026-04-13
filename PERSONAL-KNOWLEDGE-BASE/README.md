---
version: "3.1"
status: draft
last_updated: 2026-04-13
---
# Personal Knowledge Base (PKB)

> Your AI-maintained knowledge library. Private. Gitignored. Yours alone.
> What you produce from it can go anywhere.

---

## The Problem

Every time you start a new session, the AI agent starts from zero. You've read docs, explored frameworks, made discoveries — but that knowledge lives only in past conversations. You lose it. You re-learn it. You waste time.

The more sessions you run, the worse it gets: duplicate research, contradictory conclusions, no thread of accumulated understanding.

---

## The Solution

The PKB is a **personal knowledge library that your AI agent maintains for you.** You drop raw sources in. The agent reads them and extracts structured wiki pages. Next session, the agent automatically recalls what you've learned — before you ask.

You never write the wiki yourself. The AI does all the organising, cross-referencing, and maintenance. Your job: drop sources, review what comes back, and write your own synthesis when the moment arrives.

---

## How It Works — The 4-Stage Pipeline

```
1-captured/  ──→  2-organised/  ──→  3-distilled/  ──→  4-expressed/
  Capture           Organise           Distil              Express
  Raw               AI-extracted       Your                Outputs
  Sources           Wiki Pages         Synthesis           for Others
```

| Stage | Directory | What happens | Who does it |
|---|---|---|---|
| **Capture** | `1-captured/` | Drop raw sources: articles, PDFs, session notes, web clips | You |
| **Organise** | `2-organised/` | AI reads each source, creates/updates structured wiki pages with cross-links and L1-L4 depth | AI agent via `/organise` |
| **Distil** | `3-distilled/` | You write cross-source connections, mental models, and synthesis from multiple organised pages | You (opt-in, not nagged) |
| **Express** | `4-expressed/` | You produce outputs from your knowledge: reports, summaries, deliverables | You + AI |

### Boundary rules

- `1-captured/` is **immutable** — never edited after drop. Source of truth.
- `2-organised/` ← AI can write here from a single source. Every ingest run touches only this dir.
- `3-distilled/` ← requires YOUR thinking across multiple organised pages. No `/distil` skill exists — this is populated via natural conversation and save.
- `4-expressed/` ← anything leaving the PKB for a specific audience.

---

## What's Inside

```
PERSONAL-KNOWLEDGE-BASE/
├── README.md               ← you are here
├── dashboard.md            ← live learning stats (Dataview)
├── knowledge-map.canvas    ← visual knowledge pipeline (Canvas)
├── 1-captured/             ← drop raw sources here (immutable)
├── 2-organised/            ← AI-maintained wiki pages
│   ├── _index.md           ← table of contents (AI updates this)
│   ├── _log.md             ← history of every organise run
│   └── {topics}/           ← pages grouped by domain
├── 3-distilled/            ← YOUR cross-source synthesis (optional, opt-in)
└── 4-expressed/            ← outputs you create from your knowledge
```

---

## Using the PKB — Day to Day

### 1. Capture a Source

**From the browser:** Use Obsidian Web Clipper (browser extension).
- Press `⌥⇧O` on any page → select **PKB Capture** template → clip
- The article lands in `1-captured/` as a markdown file

**From a session:** When you're reading docs or doing research, tell the agent:
> "Save this to 1-captured/" — or use `/capture` for quick-save with auto-frontmatter

**Manually:** Drag any `.md` or `.txt` file into `1-captured/`.

Sources in `1-captured/` are **immutable** — never edited after drop. They're your source of truth.

### 2. Organise — Turn Sources into Wiki Pages

Run `/organise`. The AI agent will:

```
Step 1  Read new files in 1-captured/ (skips already-organised ones)
Step 2  Check 2-organised/_index.md for related pages
Step 3  Create or update pages in 2-organised/{topic}/
Step 4  Log what happened in 2-organised/_log.md
Step 5  Update the index in 2-organised/_index.md
```

Each wiki page answers questions at increasing depth:

| Level | Questions the page answers | When required |
|---|---|---|
| **L1 Knowledge** | What is it? How does it work? What else exists? Why does it matter? | Every page |
| **L2 Understanding** | Why does it work? When and why does it fail? | **Every page (minimum)** |
| **L3 Wisdom** | How can we benefit? What should we do next? | Core skill/framework pages |
| **L4 Expertise** | What is it NOT? Anti-patterns? Alternatives? How to do better? | Architecture decisions |

These 12 questions come from the LTC Learning Hierarchy (`_genesis/frameworks/learning-hierarchy.md`). A page **earns** its level by answering all questions at that level and below.

### 3. Auto-Recall — Knowledge Surfaces Automatically

**QMD** (your local search engine) indexes everything in `2-organised/`. At the start of every session, the system queries QMD for knowledge relevant to what you're working on. If you're building a skill and you've previously organised Anthropic's skill docs, the relevant wiki page appears in your session context — automatically.

You don't search for it. You don't ask for it. It just shows up.

### 3a. QMD — Search and Auto-Recall

QMD indexes everything in `2-organised/` and `3-distilled/`. Two search modes:
- **vec** (semantic): meaning-based vector search — finds related concepts even without exact keywords
- **lex** (keyword): BM25 keyword search — exact term matching, fast

**Auto-recall:** On `UserPromptSubmit`, the hook `.claude/hooks/auto-recall-filter.sh` queries QMD with the user's prompt intent and injects relevant pages into the session context automatically. No manual action needed.

**Manual recall:** Use `mcp__qmd__query` directly with `type:'vec'` or `type:'lex'` sub-queries.

After each `/organise` run, re-index so QMD sees new pages:
```bash
qmd update 2-organised && qmd embed
```
The SessionStop hook runs this automatically — no manual step needed in normal flow.

### 4. Distil — Your Own Synthesis (Optional)

`3-distilled/` is for cross-source thinking that only YOU can write. When you've read multiple organised pages and see a pattern, a contradiction, or a mental model forming — write it in `3-distilled/`.

There is no `/distil` skill. This stage is populated via natural conversation: tell the agent "save this synthesis to 3-distilled/{topic}/filename.md" and it writes what you've articulated.

You are not nagged to distil. The organised pages are useful on their own. Distilled is for when you've genuinely developed a new mental model.

### 5. Review — Spaced Repetition

Knowledge you don't revisit fades. Obsidian's **Spaced Repetition** plugin surfaces your organised pages on a schedule for active recall.

Every wiki page has `review: true` in its frontmatter. The plugin picks these up and reminds you to revisit them.

**How to use it:**

1. Open Obsidian
2. Press `Ctrl/Cmd + P` → type "Spaced Repetition" → select **Review flashcards**
3. Read the page, then rate: **Easy** (14 days), **Good** (7 days), **Hard** (1 day)
4. Repeat until no pages are due

Aim for 5 minutes daily. Over time, well-known pages get spaced further apart.

### 6. Dashboard — See Your Learning Stats

Open `dashboard.md` in Obsidian to see live stats powered by **Dataview** queries:

| Dashboard panel | What it shows |
|---|---|
| **Level Distribution** | How many pages at L1, L2, L3, L4 — shows depth of your knowledge |
| **Unorganised Files** | Files in 1-captured/ not yet processed — your backlog |
| **Recent Organise Operations** | Last 10 organise runs — your activity timeline |
| **Topics** | Pages grouped by domain — shows where your knowledge concentrates |
| **Your Synthesis (3-distilled/)** | Cross-source pages you've written — your own thinking |
| **Review Queue** | Pages due for spaced repetition — what to read today |

### 7. Lint — Keep Your Wiki Healthy

Run `./scripts/pkb-lint.sh` to check wiki health. 8 automated checks, zero AI needed:

```
UNINGESTED   Files in 1-captured/ not yet organised
SHALLOW      Pages below L2 minimum (< 6 questions answered)
FRONTMATTER  Pages missing required metadata fields
ORPHANS      Pages with no inbound links (disconnected knowledge)
LINKS        Broken [[links]] pointing to pages that don't exist
INDEX        Pages missing from the table of contents
STALE        Pages not updated in 30+ days
LOG          Organise history integrity
```

Three modes:
- `./scripts/pkb-lint.sh` — advisory (see issues, nothing changes)
- `./scripts/pkb-lint.sh --strict` — fails if issues found (use in CI or hooks)
- `./scripts/pkb-lint.sh --fix` — auto-fixes what it can (adds missing index entries)

### 8. Express — Produce From Your Knowledge

When you're ready to create something from what you know, outputs go in `4-expressed/`:
- Reports, summaries, deliverables
- Team-facing documents
- Research inputs for project work (`2-LEARN/input/`)
- Anything that leaves the PKB and enters a project

The PKB is the well. `4-expressed/` is what you draw from it.

---

## Setting Up — 5 Minutes

### Step 1: Verify Scaffold

The PKB folder is already created when you clone the template. Verify:
```bash
ls PERSONAL-KNOWLEDGE-BASE/
# Should show: 1-captured/  2-organised/  3-distilled/  4-expressed/  README.md  dashboard.md  knowledge-map.canvas
```

### Step 2: Configure QMD

Ensure QMD indexes your wiki. Run `/setup` or check `qmd status`. QMD should list two collections pointing to `PERSONAL-KNOWLEDGE-BASE/2-organised/` and optionally `PERSONAL-KNOWLEDGE-BASE/3-distilled/`.

```bash
# One-time setup (or run /setup which does this for you):
cd PERSONAL-KNOWLEDGE-BASE
qmd collection add 2-organised 2-organised/
qmd update 2-organised && qmd embed

# Re-index after each /organise session:
qmd update 2-organised && qmd embed
```

### Step 3: Install Obsidian Plugins

Open Obsidian → Settings → Community Plugins → Browse. Install these 4:

| Plugin | Search for | What to configure |
|---|---|---|
| **Dataview** | `dataview` | Settings → Enable JavaScript Queries → ON. This powers `dashboard.md`. |
| **Spaced Repetition** | `obsidian-spaced-repetition` | Settings → Note folder → `PERSONAL-KNOWLEDGE-BASE/2-organised/`. Filter → `review: true`. |
| **Canvas Mindmap** | `canvas-mindmap` | No config needed. Open `knowledge-map.canvas` to start. |
| **PDF++** | `pdf-plus` | Settings → Highlight export folder → `PERSONAL-KNOWLEDGE-BASE/1-captured/`. |

> **Callout blocks** are built-in. Use `> [!tip]`, `> [!warning]`, `> [!example]`, `> [!note]` in any markdown.

### Step 4: Install Web Clipper (optional but recommended)

Obsidian Web Clipper is a browser extension for capturing web pages.

1. Install from your browser's extension store (search "Obsidian Web Clipper")
2. In Clipper settings → Templates → New template:
   - **Name:** `PKB Capture`
   - **Note location:** `PERSONAL-KNOWLEDGE-BASE/1-captured`
   - **Note name:** `{{title}}`
   - **Properties:** add `version: 2.0`, `status: draft`, `source_url: {{url}}`, `source_type: web-clip`
3. Now `⌥⇧O` on any web page clips it straight to `1-captured/`

### Step 5: First Organise Run

Drop any doc you've read recently into `1-captured/` and run `/organise`. Open `dashboard.md` to see your first page appear in `2-organised/`.

### Migration Path (Existing Clones)

If you have an existing PKB with the old unnumbered layout (captured → organised → distilled → expressed):

```bash
# 1. Rename each subdir to its numbered name
mv PERSONAL-KNOWLEDGE-BASE/captured PERSONAL-KNOWLEDGE-BASE/1-captured
mv PERSONAL-KNOWLEDGE-BASE/organised PERSONAL-KNOWLEDGE-BASE/2-organised
mv PERSONAL-KNOWLEDGE-BASE/distilled PERSONAL-KNOWLEDGE-BASE/3-distilled
mv PERSONAL-KNOWLEDGE-BASE/expressed PERSONAL-KNOWLEDGE-BASE/4-expressed

# 2. Re-index QMD with the new paths
qmd collection remove organised 2>/dev/null || true
qmd collection add 2-organised 2-organised/
qmd update 2-organised && qmd embed
```

Your existing AI-extracted pages are now in `2-organised/`. `3-distilled/` is now reserved for your own cross-source synthesis.

---

## What the PKB is NOT

| It is NOT... | Use instead |
|---|---|
| Project research | `2-LEARN/` — structured problem-domain research for DSBV |
| Session memory | `/compress` + `/resume` — conversation context continuity |
| A team knowledge base | Each PM has their own PKB; the system ships, the knowledge doesn't |
| Committed to git | This entire folder is gitignored — personal and private |
| A replacement for project docs | Project decisions go to `1-ALIGN/decisions/` |
| Something you write manually | The AI maintains 2-organised/; you curate sources and read the output |

---

## How the PKB Stays Healthy

Three automated systems work together:

```
Post-session hook             Dashboard                   Lint script
─────────────────             ─────────                   ───────────
Fires when you end            Open anytime in             Run manually or
a session. If 1-captured/     Obsidian. Live stats:       on schedule.
has unorganised files,        level distribution,         8 mechanical checks:
it reminds you.               unorganised backlog,        orphans, broken links,
                              review queue.               shallow pages, stale.

"You have 2 files             "3 pages at L1,             "2 orphan pages,
awaiting organise."           7 at L2, 1 at L4"           1 broken link"
```

Together they ensure: nothing is forgotten (hook), nothing is shallow (dashboard), nothing is broken (lint).

---

## Quick Reference

| I want to... | Do this |
|---|---|
| Save something from the browser | `⌥⇧O` → PKB Capture template |
| Save something from a session | `/capture` or tell the agent: "save this to 1-captured/" |
| Turn raw sources into wiki pages | Run `/organise` |
| Write my own cross-source synthesis | Write to `3-distilled/` directly or ask agent to save |
| See my learning stats | Open `dashboard.md` in Obsidian |
| Review what I've learned | Open Spaced Repetition panel in Obsidian |
| See knowledge connections | Open `knowledge-map.canvas` |
| Check wiki health | Run `./scripts/pkb-lint.sh` |
| Create an output from my knowledge | Write to `4-expressed/` |
| Find something I've learned | QMD auto-recalls it, or search in Obsidian |
| Re-index after new organised pages | `qmd update 2-organised && qmd embed` |

---

> **The system works best when you trust the AI to organise.
> Your job: drop sources, read what comes back, and synthesise when you're ready.**

## Links

- [[SKILL]]
- [[_index]]
- [[_log]]
- [[anti-patterns]]
- [[architecture]]
- [[dashboard]]
- [[learning-hierarchy]]
- [[project]]
