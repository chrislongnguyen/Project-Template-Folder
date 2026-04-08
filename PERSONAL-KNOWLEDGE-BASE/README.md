---
version: "2.1"
status: Draft
last_updated: 2026-04-05
---
# Personal Knowledge Base (PKB)

> Your AI-maintained knowledge library. Private. Gitignored. Yours alone.
> What you produce from it can go anywhere.

---

## The Problem

Every time you start a new session, the AI agent starts from zero. You've read docs, explored frameworks, made discoveries — but that knowledge lives only in past conversations. You lose it. You re-learn it. You waste time.

## The Solution

The PKB is a **personal knowledge library that your AI agent maintains for you.** You drop sources in. The agent reads them, organises them into structured pages, and keeps them updated. Next session, the agent automatically recalls what you've learned — before you ask.

You never write the wiki yourself. The AI does all the organising, cross-referencing, and maintenance. Your job: drop sources, ask questions, and read what comes back.

---

## How It Works — The CODE Pipeline

```
captured/  ──→  distilled/  ──→  expressed/
 Capture         Organise +       Express
 Facts &         Distil            Expertise
 Data            Wisdom
```

| Stage | What happens | Who does it |
|---|---|---|
| **Capture** | Drop raw sources: articles, docs, session notes, web clips | You |
| **Organise + Distil** | AI reads the source, creates/updates structured wiki pages with cross-links | AI agent |
| **Express** | You produce outputs from your knowledge: reports, summaries, deliverables | You + AI |

---

## What's Inside

```
PERSONAL-KNOWLEDGE-BASE/
├── README.md               ← you are here
├── dashboard.md            ← live learning stats (Dataview)
├── knowledge-map.canvas    ← visual knowledge map (Canvas)
├── captured/               ← drop raw sources here
├── distilled/              ← AI-maintained wiki pages
│   ├── _index.md           ← table of contents (AI updates this)
│   ├── _log.md             ← history of every ingest
│   └── {topics}/           ← pages organised by domain
└── expressed/              ← outputs you create from your knowledge
```

---

## Using the PKB — Day to Day

### 1. Capture a Source

**From the browser:** Use Obsidian Web Clipper (browser extension).
- Press `⌥⇧O` on any page → select **PKB Capture** template → clip
- The article lands in `captured/` as a markdown file

**From a session:** When you're reading docs or doing research, just tell the agent:
> "Save this to captured/"

**Manually:** Drag any `.md` or `.txt` file into `captured/`.

Sources in `captured/` are **immutable** — never edited after drop. They're your source of truth.

### 2. Ingest — Turn Sources into Knowledge

Run the `/ingest` command. The AI agent will:

```
Step 1  Read new files in captured/ (skips already-ingested ones)
Step 2  Check the wiki index for related pages
Step 3  Create or update pages in distilled/
Step 4  Log what happened in _log.md
Step 5  Update the index in _index.md
```

Each wiki page answers questions at increasing depth:

| Level | Questions the page answers | When required |
|---|---|---|
| **L1 Knowledge** | What is it? How does it work? What else exists? Why does it matter? | Every page |
| **L2 Understanding** | Why does it work? When and why does it fail? | **Every page (minimum)** |
| **L3 Wisdom** | How can we benefit? What should we do next? | Core skill/framework pages |
| **L4 Expertise** | What is it NOT? Anti-patterns? Alternatives? How to do better? | Architecture decisions |

These 12 questions come from the LTC Learning Hierarchy (`_genesis/frameworks/learning-hierarchy.md`). A page **earns** its level by answering all questions at that level and below — it's not a label, it's proof of depth.

### 3. Auto-Recall — Knowledge Surfaces Automatically

This is the magic. You don't have to remember what you've learned.

**QMD** (your local search engine) indexes everything in `distilled/`. At the start of every session, the system queries QMD for knowledge relevant to what you're working on. If you're building a skill and you've previously ingested Anthropic's skill docs, the relevant wiki page appears in your session context — automatically.

You don't search for it. You don't ask for it. It just shows up.

### 4. Review — Spaced Repetition

Knowledge you don't revisit fades. Obsidian's **Spaced Repetition** plugin surfaces your wiki pages on a schedule for active recall — like flashcards, but for entire knowledge pages.

Every wiki page has `review: true` in its frontmatter. The plugin picks these up and reminds you to revisit them.

**How to use it — step by step:**

1. Open Obsidian
2. Press `Ctrl/Cmd + P` to open the command palette
3. Type "Spaced Repetition" → select **Review flashcards in this note** or **Review all due notes**
4. The plugin shows you a wiki page that's due for review
5. Read the page, then rate: **Easy** (push to 14 days), **Good** (keep at 7 days), **Hard** (review again in 1 day)
6. Repeat until no more pages are due

**When to review:** Aim for 5 minutes daily. The plugin tracks what's due — you don't need to remember. Over time, well-known pages get spaced further apart (14→30→60 days) while difficult ones stay frequent.

**Where to find it in Obsidian:** Look for the card icon in the left sidebar, or use the command palette (`Ctrl/Cmd + P`).

### 5. Dashboard — See Your Learning Stats

Open `dashboard.md` in Obsidian to see live stats powered by **Dataview** queries:

| Dashboard panel | What it shows |
|---|---|
| **Level Distribution** | How many pages at L1, L2, L3, L4 — shows depth of your knowledge |
| **Uningested Files** | Files in captured/ you haven't processed yet — your backlog |
| **Recent Ingests** | Last 10 ingest operations — your activity timeline |
| **Topics** | Pages grouped by domain — shows where your knowledge concentrates |
| **Review Queue** | Pages due for spaced repetition — what to read today |

Dataview queries update in real-time as your wiki grows. No manual tracking.

### 6. Knowledge Map — See Connections Visually

Open `knowledge-map.canvas` in Obsidian to see your knowledge pipeline as a visual map. **Canvas** lets you:

- See the `captured/ → distilled/ → expressed/` flow
- Add topic clusters as your wiki grows
- Drag wiki pages onto the canvas to map relationships
- Create visual brainstorms connected to your actual knowledge

Canvas Mindmap plugin adds keyboard-driven mind mapping on top.

### 7. Lint — Keep Your Wiki Healthy

Run `./scripts/pkb-lint.sh` to check wiki health. 8 automated checks, zero AI needed, runs in under 1 second:

```
UNINGESTED   Files in captured/ not yet ingested
SHALLOW      Pages below L2 minimum (< 6 questions answered)
FRONTMATTER  Pages missing required metadata fields
ORPHANS      Pages with no inbound links (disconnected knowledge)
LINKS        Broken [[links]] pointing to pages that don't exist
INDEX        Pages missing from the table of contents
STALE        Pages not updated in 30+ days
LOG          Ingest history integrity
```

Three modes:
- `./scripts/pkb-lint.sh` — advisory (see issues, nothing changes)
- `./scripts/pkb-lint.sh --strict` — fails if issues found (use in CI or hooks)
- `./scripts/pkb-lint.sh --fix` — auto-fixes what it can (adds missing index entries)

### 8. Express — Produce From Your Knowledge

When you're ready to create something from what you know, outputs go in `expressed/`:
- Reports, summaries, deliverables
- Team-facing documents
- Research inputs for project work (`2-LEARN/input/`)
- Anything that leaves the PKB and enters a project

The PKB is the well. `expressed/` is what you draw from it.

---

## Setting Up — 5 Minutes

### Step 1: Verify Scaffold

The PKB folder is already created when you clone the template. Verify:
```
ls PERSONAL-KNOWLEDGE-BASE/
# Should show: captured/  distilled/  expressed/  README.md  dashboard.md  knowledge-map.canvas
```

### Step 2: Configure QMD

Ensure QMD indexes your wiki. Run `/setup` or check `qmd status`. QMD should list a collection pointing to `PERSONAL-KNOWLEDGE-BASE/distilled/`.

### Step 3: Install Obsidian Plugins

Open Obsidian → Settings → Community Plugins → Browse. Install these 4:

| Plugin | Search for | What to configure |
|---|---|---|
| **Dataview** | `dataview` | Settings → Enable JavaScript Queries → ON. This powers `dashboard.md`. |
| **Spaced Repetition** | `obsidian-spaced-repetition` | Settings → Note folder → `PERSONAL-KNOWLEDGE-BASE/distilled/`. Filter → `review: true`. This enables spaced repetition flashcards and review scheduling. |
| **Canvas Mindmap** | `canvas-mindmap` | No config needed. Open `knowledge-map.canvas` to start. Adds keyboard mind mapping to Canvas. |
| **PDF++** | `pdf-plus` | Settings → Highlight export folder → `PERSONAL-KNOWLEDGE-BASE/captured/`. Lets you annotate PDFs and send highlights to captured/. |

> **Callout blocks** are built-in (no install). Use `> [!tip]`, `> [!warning]`, `> [!example]`, `> [!note]` in any markdown for structured visual notes.

### Step 4: Install Web Clipper (optional but recommended)

Obsidian Web Clipper is a browser extension for capturing web pages.

1. Install from your browser's extension store (search "Obsidian Web Clipper")
2. In Clipper settings → Templates → New template:
   - **Name:** `PKB Capture`
   - **Note location:** `PERSONAL-KNOWLEDGE-BASE/captured`
   - **Note name:** `{{title}}`
   - **Properties:** add `version: 2.0`, `status: Draft`, `source_url: {{url}}`, `source_type: web-clip`
3. Now `⌥⇧O` on any web page clips it straight to `captured/`

### Step 5: First Ingest

Drop any doc you've read recently into `captured/` and run `/ingest`. Open `dashboard.md` to see your first page appear.

---

## What the PKB is NOT

| It is NOT... | Use instead |
|---|---|
| Project research | `2-LEARN/` — structured problem-domain research for DSBV |
| Session memory | `/compress` + `/resume` — conversation context continuity |
| A team knowledge base | Each PM has their own PKB; the system ships, the knowledge doesn't |
| Committed to git | This entire folder is gitignored — personal and private |
| A replacement for project docs | Project decisions go to `1-ALIGN/decisions/` |
| Something you write manually | The AI maintains the wiki; you curate sources and read the output |

---

## How the PKB Stays Healthy

Three automated systems work together:

```
Post-session hook          Dashboard                   Lint script
─────────────────          ─────────                   ───────────
Fires when you end         Open anytime in             Run manually or
a session. If captured/    Obsidian. Live stats:       on schedule.
has uningested files,      level distribution,         8 mechanical checks:
it reminds you.            uningested backlog,         orphans, broken links,
                           review queue.               shallow pages, stale.

"You have 2 files          "3 pages at L1,             "2 orphan pages,
awaiting ingest."          7 at L2, 1 at L4"           1 broken link"
```

Together they ensure: nothing is forgotten (hook), nothing is shallow (dashboard), nothing is broken (lint).

---

## Quick Reference

| I want to... | Do this |
|---|---|
| Save something from the browser | `⌥⇧O` → PKB Capture template |
| Save something from a session | Tell the agent: "save this to captured/" |
| Turn raw sources into knowledge | Run `/ingest` |
| See my learning stats | Open `dashboard.md` in Obsidian |
| Review what I've learned | Open Spaced Repetition panel in Obsidian |
| See knowledge connections | Open `knowledge-map.canvas` |
| Check wiki health | Run `./scripts/pkb-lint.sh` |
| Create an output from my knowledge | Write to `expressed/` |
| Find something I've learned | QMD auto-recalls it, or search in Obsidian |

---

> **The system works best when you trust the AI to organise.
> Your job: drop sources and read what comes back.**

## Links

- [[SKILL]]
- [[_index]]
- [[_log]]
- [[anti-patterns]]
- [[architecture]]
- [[dashboard]]
- [[learning-hierarchy]]
- [[project]]
