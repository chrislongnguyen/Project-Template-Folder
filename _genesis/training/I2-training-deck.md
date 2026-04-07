---
version: "2.1"
status: draft
last_updated: 2026-04-06
work_stream: _genesis
type: training
audience: "LTC Members (new + upgrading from I1)"
reading_time: "30 min"
---

# ITERATION 2: EFFICIENT — TRAINING DECK

> **Format:** Slide deck (each `## heading` = one slide, separated by `---`)
> **Brand:** Inter font | Midnight Green `#004851` | Gold `#F2C75C` | Ruby Red `#9B1842`
> **Quick Start:** 10 min to migrated + first dashboard

---

## ITERATION 2: EFFICIENT

### Your Project Operating System — Now With Dashboards, Knowledge Base & Agent Skills

```
I1 Sustainable          I2 Efficient              I3 Scalable
─────────────────── ──► ═══════════════════════ ──► ───────────────────
  Scaffold + Rules        Dashboards + PKB +          Multi-project
  Agent architecture      Skills + Filesystem         orchestration
  You are here ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━▶
```

**One sentence:** I2 turns your file-based project into a **live dashboard system** where AI agents write, you review, and Obsidian shows you everything — plus a personal knowledge base that grows smarter with every source you feed it.

---

## WHY I2 MATTERS — THE PM PAIN POINTS WE SOLVED

In I1, the template gave you **structure** — folders, rules, agents. But you still had to manage everything manually. Here's what I2 fixes:

| # | I1 Pain Point | I2 Solution | Result for You |
|---|---------------|-------------|----------------|
| 1 | **"What changed since yesterday?"** — required `git log` or memory | **C3 Standup Preparation dashboard** auto-surfaces files modified in last 24-72 hours | 5-min morning check replaces 15 min of digging |
| 2 | **Blockers were invisible** until standup or a missed deadline | **C4 Blocker dashboard** auto-detects risk from days-since-last-update (no manual flags) | Blockers surface to you before they become crises |
| 3 | **No approval workflow** — you had to track "what needs my sign-off" in your head | **C5 Approval Queue** collects all `in-review` items with urgency levels | You never miss a review, team never waits on you |
| 4 | **Knowledge scattered** across notes, chats, and bookmarks | **Personal Knowledge Base** — capture sources → AI distils into searchable wiki | Knowledge compounds instead of evaporating |
| 5 | **Agent output was a black box** — files appeared but dashboards didn't exist | **18 dashboards** make agent work visible — you see status, stage, version, staleness | You manage by exception, not by inspection |
| 6 | **Starting a new feature was blank-page anxiety** | **`/ltc-brainstorming`** runs 4 invisible gates to structure your thinking before you write a line | Structured exploration replaces unstructured guessing |

> **The shift:** In I1, you managed the project. In I2, **the project tells you what needs managing.**

---

## WHAT'S NEW IN I2

| # | Feature | What You Get | Evidence |
|---|---------|-------------|----------|
| 1 | **18 Obsidian Dashboards** | Live project views — standup prep, blocker detection, approval queue, version tracking | **WHERE:** `_genesis/obsidian/bases/` (18 `.base` files). **HOW:** Open any `.base` file in Obsidian — it reads your file metadata automatically. **WHY:** Replaces manual folder-checking with auto-generated live tables |
| 2 | **Personal Knowledge Base** | Capture articles/docs → AI distils into searchable wiki pages (CODE pipeline) | **WHERE:** `PERSONAL-KNOWLEDGE-BASE/` (3 dirs: captured/, distilled/, expressed/). **HOW:** Drop a source in `captured/`, run `/ingest` in Claude Code. **WHY:** Knowledge compounds — every ingested source makes your wiki smarter |
| 3 | **5 New + 1 Upgraded Skill** | `/ingest`, `/template-check`, `/template-sync`, `/setup`, `/vault-capture` (new) + upgraded `/ltc-brainstorming` | **WHERE:** `.claude/skills/` (one folder per skill with SKILL.md). **HOW:** Type the command in Claude Code terminal. **WHY:** Each skill automates a multi-step workflow you'd otherwise do manually |
| 4 | **Filesystem Blueprint** *(planned)* | Subsystem-based folders (1-PD, 2-DP, 3-DA, 4-IDM) with routing rules | **WHERE:** Each ALPEI workstream will gain 4 subsystem dirs + `_cross/`. **HOW:** Agent will auto-route files via `sub_system` frontmatter. **WHY:** Replaces flat `charter/`, `decisions/` folders with problem-domain grouping. **STATUS:** Design complete, shipping in next update |
| 5 | **Frontmatter Standard** | Locked status vocabulary, SCREAMING work_stream format (e.g. `4-EXECUTE`), sub_system codes | **WHERE:** Every `.md` deliverable file (YAML block between `---` markers). **HOW:** Agent enforces on creation; `/template-sync` migrates existing files. **WHY:** Dashboards filter by exact values — inconsistent metadata = invisible files |
| 6 | **LTC Brand Theme** | Color-coded pills, zebra-striped tables, hover effects in Obsidian | **WHERE:** `_genesis/obsidian/ltc-bases-colors.css` + `ltc-bases-theme` plugin. **HOW:** Enable CSS snippet + plugin in Obsidian settings. **WHY:** Visual distinction between statuses, workstreams, and stages at a glance |

> **If you're new:** This deck covers everything. Start at the Quick Start.
> **If you're upgrading from I1:** The Quick Start below walks you through migration end-to-end.

---

## BEFORE & AFTER

```
┌─────────────────────────────────────┬──────────────────────────────────────────┐
│         I1 (SUSTAINABLE)            │           I2 (EFFICIENT)                 │
├─────────────────────────────────────┼──────────────────────────────────────────┤
│ Files in folders                    │ Files + metadata → live dashboards       │
│ Status in your head                 │ Status in frontmatter → auto-tracked     │
│ "What changed?" = git log           │ "What changed?" = open C3 dashboard      │
│ Blockers found in standup           │ Blockers auto-detected by staleness      │
│ Knowledge in scattered notes        │ Knowledge captured → distilled → wiki    │
│ Agent writes files                  │ Agent writes + updates dashboards        │
│ You check folders manually          │ Dashboards surface what needs attention  │
│ Category-based dirs (charter/)      │ Subsystem dirs planned (1-PD/, 2-DP/)   │
│ Brainstorming = blank page          │ /ltc-brainstorming = 4 structured gates  │
│ No migration tooling                │ /template-check + /template-sync         │
└─────────────────────────────────────┴──────────────────────────────────────────┘
```

---

## AGENDA

| # | Section | Time | What You'll Learn |
|---|---------|------|-------------------|
| 1 | **Quick Start & Migration** | 10 min | Upgrade from I1 → I2 with zero struggle, see your first dashboard |
| 2 | **Foundations** | 5 min | What is Obsidian, what we built, how Bases work |
| 3 | **The Frontmatter System** | 5 min | The metadata that powers every dashboard |
| 4 | **Part 1: Obsidian Bases & PM Workflow** | 10 min | 18 dashboards + your daily cycle (morning → weekly) |
| 5 | **Part 2: Personal Knowledge Base** | 8 min | CODE pipeline, /ingest, Karpathy LLM-wiki, Obsidian plugins |
| 6 | **QMD & Memory Vault** | 3 min | How semantic search powers auto-recall across sessions |
| 7 | **Upgraded Skills** | 3 min | /ltc-brainstorming Discovery Protocol + all new commands |
| 8 | **Reference** | — | Cheat sheets, dashboard index, file locations |

---

## QUICK START — MIGRATION IN 10 MINUTES

### You're running your project repo on the I1 engine. Here's how to upgrade to I2.

> **Context:** Your project was cloned from the LTC Project Template at I1 (v1.x). The I2 migration skills (`/template-check`, `/template-sync`) live in the I2 template — you don't have them yet. Step 1 pulls them into your project. Your AI agent handles the rest.

**Step 1 — Connect to the I2 template (one-time, ~1 min)**

```bash
# In your project repo terminal:

# 1a. Add the template as a git remote (if not already added)
git remote add template https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git

# 1b. Fetch the I2 template
git fetch template main

# 1c. Pull JUST the migration tools into your project
git checkout template/main -- \
  scripts/template-check.sh \
  scripts/template-sync.sh \
  .claude/skills/template-check/ \
  .claude/skills/template-sync/
```

> **What this does:** Copies 4 items from the I2 template into your local project — two scripts and two skill definitions. Nothing else changes. Your project files are untouched.

> **Checkpoint:** Run `ls scripts/template-check.sh` — you should see the file. Run `ls .claude/skills/template-check/SKILL.md` — you should see the skill definition. If both exist, you're ready.

**Step 2 — Run the audit (read-only, safe)**

```bash
# In Claude Code terminal:
/template-check
```

> **What happens:** The agent runs `scripts/template-check.sh` which compares your project files against the I2 template remote you just added. It outputs a categorized report — no files are changed.

> **What you see:** A JSON summary with 5 buckets:

```
┌────────────────────────────┬─────────────────────────────────────────────────┐
│ Bucket                     │ What it means                                   │
├────────────────────────────┼─────────────────────────────────────────────────┤
│ auto_add (N files)         │ New I2 files safe to add automatically          │
│ flagged: security (N)      │ .env, secrets — NEVER auto-added, your call     │
│ flagged: review (N)        │ .claude/, _genesis/, scripts/ — needs your eye  │
│ merge (N files)            │ Files that exist in both I1 and I2 — diff shown │
│ unchanged (N files)        │ Already in sync — nothing to do                 │
└────────────────────────────┴─────────────────────────────────────────────────┘
```

> **Checkpoint:** You see the report. Review the numbers. No files changed yet.

**Step 3 — Run the sync (interactive, guided)**

```bash
# In Claude Code terminal:
/template-sync
```

> **What happens:** The agent walks you through each bucket interactively:

```
Phase 1: AUTO-ADD        Agent adds safe new files (dashboards, templates, PKB scaffold)
                         → All files left UNSTAGED — you review before committing
                         
Phase 2: FLAGGED FILES   Agent presents each security/review file one by one
                         → You choose: Add / Skip / Handle individually
                         
Phase 3: MERGE           Agent shows diff for each conflicting file
                         → You choose: (K)eep local | (T)ake template | (D)iff | (M)anual merge
                         
Phase 4: VERIFY          Agent runs 4 acceptance checks:
                         ✓ Sync log exists
                         ✓ Log has entries
                         ✓ No deletes in log
                         ✓ All added files unstaged (you control the commit)
```

> **Key guarantees:**
> - NEVER deletes your files
> - NEVER overwrites without asking
> - NEVER auto-merges — every conflict is your decision
> - All decisions logged to `.template-sync-log.json` (audit trail)

> **Checkpoint:** Agent reports `4/4 passed`. Your files are updated but unstaged.

**Step 4 — Commit and verify**

```bash
# Review what was added:
git status

# Stage files you want to keep:
git add <file1> <file2> ...

# Commit:
git commit -m "feat: upgrade to I2 Efficient via template-sync"
```

**Step 5 — Open Obsidian and see your dashboards**

```
Open Obsidian → File → Open Vault → select your project root
Navigate to: _genesis/obsidian/bases/C3-standup-preparation.base
```

> **Checkpoint:** You see a live table of your project files with statuses, workstreams, and staleness. Migration complete.

> **Rollback at any point:**
> - Undo a single file: `git checkout HEAD -- <file>`
> - Undo everything: `git stash push -u -m "rollback template-sync"`
> - The template remote stays — re-run `/template-sync` anytime to try again

---

## — SECTION 1: FOUNDATIONS —

> What is Obsidian, what we built, and how Bases work

---

## WHAT IS OBSIDIAN?

| | Question | Answer |
|---|----------|--------|
| **WHAT** | What is it? | A free markdown editor that opens your project folder as a "vault" — every `.md` file becomes a viewable, linkable page |
| **HOW** | How do files connect? | Type `[[filename]]` to create a wikilink. Obsidian tracks these automatically. Click any file → see every file that links TO it (backlinks) |
| **WHY** | Why not VS Code? | Obsidian adds a visual layer: dashboards, graph view, daily notes, link navigation. Your code editor is for code. Obsidian is for project management |
| **WHAT** | What plugins do we use? | **Bases** (dashboards), **Terminal** (Claude Code inside Obsidian), **Templater** (13 pre-built templates), **Dataview** (PKB dashboard), **Spaced Repetition** (knowledge review) |
| **HOW** | Do I need to configure it? | Minimal. Your repo is already a vault. Clone → Open → Enable 3 core plugins → Done |

---

## WHAT WE BUILT FOR YOU

### Visible — what you interact with

| # | Feature | What It Does | Where & How |
|---|---------|-------------|-------------|
| 1 | **18 Bases dashboards** | Live views that query your project files — standup prep, blockers, approvals, version progress | `_genesis/obsidian/bases/*.base` — click any file in Obsidian to open |
| 2 | **LTC brand CSS theme** | Color-coded pills for status (green/gold/ruby), workstream (ALPEI colors), and stage (DSBV) | `_genesis/obsidian/ltc-bases-colors.css` — enable in Settings → Appearance → CSS Snippets |
| 3 | **Wikilinks across all files** | `[[decisions]]`, `[[risks]]`, `[[specs]]` — click to navigate, backlinks show connections | Already embedded in all deliverable files — just click any `[[link]]` |
| 4 | **Personal Knowledge Base** | Capture articles → AI distils into wiki pages → searchable knowledge system | `PERSONAL-KNOWLEDGE-BASE/` — drop sources in `captured/`, run `/ingest` |
| 5 | **Daily notes + inbox + people** | Quick capture, stakeholder tracking, daily reflections — all built into the vault | `DAILY-NOTES/`, `inbox/`, `PEOPLE/` — templates via `Ctrl+T` / `Cmd+T` |

### Invisible — runs in the background

| # | System | What It Does | Where & How |
|---|--------|-------------|-------------|
| 1 | **QMD semantic search** | Searches your vault by meaning, not just keywords. Runs locally on your machine | MCP server — agent uses it automatically when you ask questions about your project |
| 2 | **3-tier search routing** | Agent tries QMD → Obsidian CLI → Grep (automatic fallback chain) | `.claude/rules/` — no config needed, always-on |
| 3 | **Security rules** | Dangerous Obsidian commands permanently blocked — agents cannot damage your vault | `.claude/rules/` — enforced at agent level, not bypassable |
| 4 | **Hook automation** | Session start/stop scripts auto-run: PKB lint, session summaries, ingest reminders | `.claude/settings.json` — hooks fire on SessionStart and SessionStop events |

> **All pre-configured.** You just open the vault.

---

## OBSIDIAN PLUGINS & THEME

### Core Plugins (install from Community Plugins)

| Plugin | Purpose | Install |
|--------|---------|---------|
| **Bases** | Live dashboards — powers all 18 `.base` files (C1–C7, W1–W5, U1–U6) | Settings → Community Plugins → Search "bases" → Enable |
| **Templater** | 13 pre-built templates (ADR, daily note, risk entry, deliverable, retro). Press `Ctrl+T` / `Cmd+T` | Search "templater" → Enable → Set template folder to `_genesis/templates/` |
| **Terminal** | Run Claude Code inside Obsidian — no switching to a separate terminal | Search "terminal" → Enable → Opens embedded terminal panel |
| **Local REST API** | Enables `/obsidian` CLI search — agent can query your vault programmatically | Search "local-rest-api" → Enable → Runs on localhost:27124 |

### LTC Brand Theme

| Component | Purpose | Install |
|-----------|---------|---------|
| **LTC Bases Colors** (CSS Snippet) | Color-coded pills for status (green/gold/ruby), workstream (ALPEI), stage (DSBV) | Settings → Appearance → CSS Snippets → Enable "ltc-bases-colors" |
| **LTC Bases Theme** (Plugin) | Structural table styling — Midnight Green headers, zebra striping, hover effects | Auto-loaded from `.obsidian/plugins/ltc-bases-theme/` (already in repo) |

---

## WHAT IS A BASE?

A `.base` file is a **live query** over your vault. Think of it as a database view.

```yaml
# What a Base reads (frontmatter in any .md file):

---
type: ues-deliverable
status: in-progress
work_stream: 4-EXECUTE
stage: build
sub_system: 2-DP
owner: "Long Nguyen"
last_updated: 2026-04-04
---
```

```
        YOUR .md FILES                    YOUR .base DASHBOARD
   ┌─────────────────────┐          ┌────────────────────────────────┐
   │ ---                  │          │  Name    Status    Stage  Days │
   │ status: in-progress  │ ──────► │  ────    ──────    ─────  ──── │
   │ stage: build         │          │  spec    in-prog   build   2  │
   │ ---                  │          │  risk    draft     design  5  │
   │                      │          │  arch    review    build   1  │
   └─────────────────────┘          └────────────────────────────────┘
   Metadata in files                 Live table, auto-updated
```

| What a Base does | How |
|-----------------|-----|
| Reads frontmatter | Scans all `.md` files matching a filter (e.g., `type: ues-deliverable`) |
| Renders as tables | Interactive rows with sorting, grouping, filtering |
| Computes formulas | `days_stale`, `risk_level`, `ws_order` — calculated from metadata |
| Supports views | Same data, different slices (by workstream, by status, by sub-system) |

> **Key insight:** You navigate your project through **metadata**, not folder structure. Dashboards find files BY their frontmatter.

---

## — SECTION 2: THE FRONTMATTER SYSTEM —

> The metadata that powers every dashboard

---

## FRONTMATTER ANATOMY

Every project deliverable has this block at the top:

```yaml
---
type: ues-deliverable          # ← UES marking — makes it visible to dashboards
version: "2.1"                 # ← I2 iteration, 1st revision
status: in-progress            # ← Drives pill color + view membership
work_stream: 4-EXECUTE         # ← ALPEI grouping (1-ALIGN through 5-IMPROVE)
stage: build                   # ← DSBV pipeline position (design → sequence → build → validate)
sub_system: 2-DP               # ← Problem domain (1-PD / 2-DP / 3-DA / 4-IDM)
owner: "Long Nguyen"           # ← Who owns this deliverable
last_updated: 2026-04-04       # ← Agent updates this automatically
---
```

### What each field controls

| Field | Values | Dashboard Effect |
|-------|--------|-----------------|
| `type` | `ues-deliverable` | Includes file in C1 master dashboard |
| `version` | `"2.1"` | Tracks iteration progress in C6 |
| `status` | `draft` · `in-progress` · `in-review` · `validated` · `archived` | Pill color + which views show it |
| `work_stream` | `1-ALIGN` · `2-LEARN` · `3-PLAN` · `4-EXECUTE` · `5-IMPROVE` | ALPEI column grouping |
| `stage` | `design` · `sequence` · `build` · `validate` | C2 pipeline position |
| `sub_system` | `1-PD` · `2-DP` · `3-DA` · `4-IDM` | Problem domain grouping |
| `owner` | Name string | Filters by assignee |
| `last_updated` | ISO date | Staleness formulas (days since update) |

> **Rule:** `work_stream` values use **SCREAMING format** matching folder names (e.g., `4-EXECUTE`). Obsidian Bases normalizes to lowercase internally for CSS pill matching — no mismatch. All other frontmatter values remain lowercase.

---

## STATUS LIFECYCLE

Status is the **lifecycle state** of a deliverable. Agents advance it. Only you can approve.

```
    AGENT creates          AGENT works           AGENT requests        YOU approve         AGENT after
    the file               on it                 your review           or reject            lifecycle
        │                     │                      │                     │                    │
        ▼                     ▼                      ▼                     ▼                    ▼
   ┌─────────┐         ┌────────────┐         ┌────────────┐        ┌────────────┐      ┌────────────┐
   │  draft   │ ──────► │in-progress │ ──────► │ in-review  │ ─────► │ validated  │ ───► │  archived  │
   │  (gray)  │         │   (gold)   │         │  (purple)  │        │  (green)   │      │ (dark gray)│
   └─────────┘         └────────────┘         └────────────┘        └────────────┘      └────────────┘
                                                                     ▲
                                                                     │
                                                              ┌──────────────┐
                                                              │  HUMAN ONLY  │
                                                              │ Agents NEVER │
                                                              │ set this     │
                                                              └──────────────┘
```

> **Golden Rule:** Only **YOU** can set `validated`. Agents create, work, and request review. You are the gate.

### Enforced by hooks — not just a rule

This isn't documentation the agent might ignore. Three automated layers enforce it:

| Layer | When it fires | What it blocks |
|-------|--------------|----------------|
| **Real-time gate** (`dsbv-gate.sh --pretool`) | Every Write/Edit to a workstream dir | Writes to workstream N if N-1 has no `validated` artifact |
| **Commit gate** (`status-guard.sh`) | Every `git commit` | Agent setting `status: validated` (only you can, via `FORCE_APPROVE=1`) |
| **Chain-of-custody** (`dsbv-gate.sh`) | Every `git commit` touching workstream files | Commits to 3-PLAN if 2-LEARN has nothing validated yet |

```
ALPEI CHAIN:  1-ALIGN → 2-LEARN → 3-PLAN → 4-EXECUTE → 5-IMPROVE
                 │          │         │          │           │
                 ▼          ▼         ▼          ▼           ▼
              always     needs      needs      needs       needs
              open       ALIGN      LEARN      PLAN        EXECUTE
                         validated  validated  validated   validated
```

> **What this means for you:** Your agent cannot skip ahead. It cannot approve its own work. It cannot write to PLAN before LEARN is done. The system enforces the sequence you designed.

### Status applies to all file types

| File type | Where status lives | Example |
|-----------|-------------------|---------|
| `.md` | YAML frontmatter | `status: in-review` |
| `.sh`, `.py` | Comment header | `# version: 1.0 \| status: draft \| ...` |
| `.html` | Meta tag | `<meta name="status" content="validated">` |
| Config (JSON, YAML) | Exempt | Git history is sufficient |

---

## THE 4 SUB-SYSTEMS

Every deliverable belongs to one of four problem domains:

```
┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│     1-PD              │  │     2-DP              │  │     3-DA              │  │     4-IDM             │
│  Problem Diagnosis    │  │  Data Pipeline        │  │  Data Analysis        │  │  Insights & Decision  │
│  Making               │
├──────────────────────┤  ├──────────────────────┤  ├──────────────────────┤  ├──────────────────────┤
│ Define the problem    │  │ Build data flow       │  │ Analyze & visualize   │  │ Decide & report       │
│                       │  │                       │  │                       │  │                       │
│ • Charter             │  │ • Pipeline spec       │  │ • Visualization spec  │  │ • Metrics baseline    │
│ • Risk models         │  │ • API integration     │  │ • Analysis report     │  │ • Recommendations     │
│ • UBS register        │  │ • Data dictionary     │  │ • Dashboard spec      │  │ • Retrospectives      │
└──────────────────────┘  └──────────────────────┘  └──────────────────────┘  └──────────────────────┘
```

> Dashboards group by `sub_system` to show **which part of the problem** you're working on.

---

## FRONTMATTER → DASHBOARD FLOW

How one file's metadata routes to multiple dashboards:

```
YOUR FILE (charter.md)                      DASHBOARDS IT APPEARS IN
┌──────────────────────────┐
│ ---                      │    ┌─► C1-master-dashboard        (type = ues-deliverable)
│ type: ues-deliverable    │────┤
│ status: in-review        │    ├─► C2-stage-board              (stage = build → Build column)
│ work_stream: 1-ALIGN     │    │
│ stage: build             │    ├─► W1-alignment-overview        (work_stream = 1-ALIGN)
│ sub_system: 1-PD         │    │
│ last_updated: 2026-04-01 │    ├─► C5-approval-queue            (status = in-review)
│ ---                      │    │
└──────────────────────────┘    └─► C4-blocker-dashboard         (if days_stale > 7)
```

### What happens when status changes

| Status | Effect |
|--------|--------|
| `draft` | Hidden from most active views |
| `in-progress` | Appears in standup, blocker, and workstream dashboards |
| `in-review` | Appears in **C5-approval-queue** — waiting for YOUR decision |
| `validated` | Moves to completed sections, counts toward iteration progress |
| `archived` | Hidden from all active views |

---

## — PART 1: OBSIDIAN BASES & PM WORKFLOW —

> 18 dashboards + your daily cycle from morning to weekly

---

## 18 DASHBOARDS — 3 LAYERS

```
LAYER 1: CROSS-CUTTING (7)              Your command center — spans all workstreams
═══════════════════════════════════════════════════════════════════════════════════
  C1 Master Dashboard         All deliverables, all workstreams, one view
  C2 Stage Board              D → S → B → V pipeline tracker
  C3 Standup Preparation      Morning check: what changed in 24-72 hours?
  C4 Blocker Dashboard        Auto-detects risk from staleness (no manual flags)
  C5 Approval Queue           Items waiting for YOUR review
  C6 Version Progress         Are we advancing through iterations?
  C7 Dependency Tracker       Cross-workstream upstream/downstream blockers

LAYER 2: WORKSTREAM (5)                 One per ALPEI stream
═══════════════════════════════════════════════════════════════════════════════════
  W1 Alignment Overview       1-ALIGN — Charter, decisions, OKRs
  W2 Learning Overview        2-LEARN — Research pipeline, input/output
  W3 Planning Overview        3-PLAN — Risks, drivers, roadmap
  W4 Execution Overview       4-EXECUTE — Source code, tests, docs
  W5 Improvement Overview     5-IMPROVE — Changelog, retros, metrics

LAYER 3: UTILITY (6)                    Supporting tools, not workstream-specific
═══════════════════════════════════════════════════════════════════════════════════
  U1 Daily Notes Index        Daily log entries with word-count estimate
  U2 Tasks Overview           Task tracking across all files
  U3 Inbox Overview           Unprocessed captures — triage weekly
  U4 People Directory         Stakeholder registry with "days since contact"
  U5 Templates Library        13 reusable Templater templates
  U6 Agent Activity           Recent agent actions log
```

> **All `.base` files live in:** `_genesis/obsidian/bases/`

---

## YOUR DAILY + WEEKLY CYCLE

```
  MORNING (5 min)     STANDUP (15-30 min)     WORK SESSION       APPROVAL          END OF DAY (5 min)    WEEKLY (15 min)
  ──────────────      ─────────────────       ────────────       ────────          ──────────────────    ──────────────
  ● C3 Standup Prep   ● C1 Master Dashboard   ● C2 Stage Board   ● C5 Approval     ● C6 Version Progress  ● U3 Inbox triage
  ● C4 Blockers       ● C7 Dependencies       ● W1-W5 per stream   Queue           ● Daily note            ● U4 People review
  ● /dsbv status ←                                                                                         ● U1 Daily notes scan
```

> **Principle:** Start wide (what changed?), narrow to your work, then step back (reflection + triage).

---

## MORNING: STANDUP PREPARATION

**Dashboard:** `C3-standup-preparation.base` — **Open this first.**

### What it shows
- Files modified in the last **24-72 hours**, banded by recency
- Activity bands: TODAY | LAST 3 DAYS | THIS WEEK

### What you do
1. Scan for **unexpected changes** — did the agent modify something you didn't ask for?
2. Note items stuck > 3 days — they may need attention
3. Prepare your standup answer: **what moved, what didn't**
4. In Claude Code: type **`/dsbv status`** — see the ALPEI×DSBV pipeline state in one table

> **Two views, always together:** Obsidian Bases = *what files exist and their metadata*. `/dsbv status` = *where you are in the process and what's next*. Neither alone is enough.
> **View tip:** Switch to the FULL STATUS view (grouped by sub-system) for standup reporting.

---

## MORNING: BLOCKER DASHBOARD

**Dashboard:** `C4-blocker-dashboard.base` — **Risk auto-detected, no manual flagging.**

### Risk levels (computed from days since last update)

| Risk Level | Days Stale | Pill Color | Action |
|------------|-----------|------------|--------|
| **ON TRACK** | < 3 days | Green | No action needed |
| **MONITOR** | 3-7 days | Gold | Keep an eye on it |
| **AT RISK** | 7-14 days | Orange | Escalate or unblock |
| **BLOCKED** | > 14 days | Ruby | Immediate action required |

### What you do
- Look for **AT RISK** or **BLOCKED** items
- If blocked: escalate in standup or unblock immediately
- If all ON TRACK: system is healthy — move on

---

## STANDUP: MASTER DASHBOARD

**Dashboard:** `C1-master-dashboard.base` — **Single source of truth for all deliverables.**

### What it shows
All deliverables across all workstreams with color-coded pills:

| Workstream | Color |
|-----------|-------|
| 1-ALIGN | Gold |
| 2-LEARN | Purple |
| 3-PLAN | Midnight |
| 4-EXECUTE | Green |
| 5-IMPROVE | Ruby |

### What you do
1. Use the **BY WORK STREAM** view for standup reporting
2. Report per workstream: what's in-progress, what moved forward
3. Flag items with high DAYS STALE to the team

---

## STANDUP: DEPENDENCY TRACKER

**Dashboard:** `C7-dependency-tracker.base` — **Cross-workstream chain of custody.**

```
ALIGN ──► LEARN ──► PLAN ──► EXECUTE ──► IMPROVE
  │          │         │          │           │
  │  If LEARN isn't done, PLAN can't advance  │
  │          │         │                      │
  └──────────┘─────────┘──────────────────────┘
       DEP STATUS formula flags upstream issues
```

### What you do
- Look for **CHECK UPSTREAM** or **STALE** status
- If upstream blocked: raise dependency issue in standup
- Ensure workstreams flow in order — ALPEI is sequential

---

## WORK SESSION: STAGE PIPELINE

**Dashboard:** `C2-stage-board.base` — **Your DSBV pipeline at a glance.**

```
  DESIGN ──────► SEQUENCE ──────► BUILD ──────► VALIDATE
    │               │                │              │
    │  DAYS IN STAGE catches items stuck too long   │
    └───────────────┴────────────────┴──────────────┘
```

### What you do
1. Identify your active item — what stage is it in?
2. In Claude Code terminal: type `/dsbv build` to advance to next stage
3. After agent completes: check this dashboard — **did the stage move?**

---

## WORK SESSION: WORKSTREAM DASHBOARDS

**One dashboard per ALPEI stream — open the one you're working in.**

| Dashboard | Workstream | What it tracks |
|-----------|-----------|---------------|
| **W1** Alignment Overview | 1-ALIGN | Charter, decisions, OKRs — your master plan |
| **W2** Learning Overview | 2-LEARN | Research pipeline: input sources → analysis → specs |
| **W3** Planning Overview | 3-PLAN | Architecture, risks, drivers, roadmap — your execution plan |
| **W4** Execution Overview | 4-EXECUTE | Source code, tests, docs — build artifacts |
| **W5** Improvement Overview | 5-IMPROVE | Changelog, retros, metrics — feedback loop |

### What you do
1. Open the overview for **your active workstream**
2. Check which files are `draft` vs `in-progress`
3. Click any file name to open it directly

> **Auto-updates:** When agents complete work via `/dsbv build`, frontmatter changes. Dashboard refreshes when you switch tabs and return.

---

## APPROVAL: YOUR REVIEW QUEUE

**Dashboard:** `C5-approval-queue.base` — **Items waiting for YOUR decision.**

### Urgency levels

| Urgency | Wait Time | Action |
|---------|----------|--------|
| **OK** | < 3 days | Review when convenient |
| **ATTENTION** | 3-7 days | Review today |
| **OVERDUE** | > 7 days | Blocking the pipeline — review now |

### How to approve

1. Open the file in Obsidian
2. Read content — does it meet acceptance criteria?
3. Switch to **Source View** (pencil icon top-right)
4. Find `status:` line → change `in-review` to `validated`
5. Save the file

> **If NO:** Leave as `in-review`, add a comment in the file, tell the agent what to fix.

### Your role (RACI)

```
┌──────────────────────────────────────────────────┐
│  YOU are ACCOUNTABLE for approvals.              │
│  Only YOU can approve. Agents write, request     │
│  review, and surface items. You are the gate.    │
└──────────────────────────────────────────────────┘
```

---

## END OF DAY: VERSION PROGRESS

**Dashboard:** `C6-version-progress.base` — **Are we advancing through iterations?**

### What it shows
- Version distribution by sub-system (1-PD, 2-DP, 3-DA, 4-IDM)
- **DAYS AT VERSION** — how long since the last version bump

### What you do
1. Check if any sub-system is stuck at the same version too long
2. End-of-day reflection: **did I advance at least 1 item today?**
3. In Claude Code terminal: type `/compress` to save your session context

---

## WEEKLY: TRIAGE & REVIEW

### Three utilities for your weekly 15-minute review

| Dashboard | What You Do |
|-----------|-------------|
| **U3 Inbox Overview** | Process unprocessed captures: file to correct workstream, or archive. Anything > 7 days old? Deal with it or delete it |
| **U4 People Directory** | Review stakeholder contacts. **DAYS SINCE CONTACT** surfaces who's going cold |
| **U1 Daily Notes Index** | Scan the week's daily notes for patterns. **~WORDS** estimate helps spot thin vs rich days |

---

## WHO DOES WHAT

| Activity | YOU (PM) | AGENT |
|----------|----------|-------|
| Create deliverable files with frontmatter | — | Writes via `/dsbv` |
| Set version, stage, sub_system, work_stream | — | Auto on creation |
| Update `last_updated` date | — | Auto on every edit |
| Move status to `in-review` | — | Requests your review |
| **Approve (set status to `validated`)** | **YOU decide** | **NEVER — only you** |
| View dashboards daily | **YOU check** | — |
| Surface blockers & stale items | — | Auto via formulas |
| Capture knowledge sources | **YOU save to `captured/`** | — |
| Distil knowledge into wiki pages | — | Writes via `/ingest` |
| Triage inbox captures | **YOU decide action** | — |
| Write daily standup notes | **YOU reflect** | — |
| Customize / add new dashboards | **YOU describe what you want** | Builds the `.base` file |

> **Agents write. You review. Only you approve. Dashboards show you everything.**

---

## — PART 2: PERSONAL KNOWLEDGE BASE —

> New in I2: Your AI-powered knowledge system — inspired by Karpathy's LLM-wiki, built on LTC's CODE Framework

---

## WHY A PERSONAL KNOWLEDGE BASE?

**The problem:** You read articles, attend meetings, research tools — but knowledge evaporates. Bookmarks pile up. Notes scatter across apps. Six months later you re-learn the same thing.

**The solution:** A system where knowledge **compounds**. Every source you capture makes the system smarter. The AI reads once, writes permanent wiki pages, and your agent recalls them in future sessions automatically.

### The Inspiration: Karpathy's LLM-Wiki Pattern

Andrej Karpathy (ex-Tesla AI, OpenAI) proposed a pattern: let an LLM **own a wiki**. Humans abandon wikis because maintenance grows faster than value. LLMs don't get bored, don't forget cross-references, and can touch 15 files in one pass.

```
KARPATHY'S INSIGHT              LTC'S IMPLEMENTATION
───────────────────             ─────────────────────
LLM owns the wiki        →     Agent writes to distilled/ via /ingest
Compile-at-ingest         →     AI reads source ONCE, writes permanent pages
Index-first retrieval     →     _index.md + QMD semantic search
Human reads wiki          →     Obsidian as your reading/review IDE
Schema co-evolution       →     schema.md + gotchas.md govern page structure
```

> **Key insight:** Compile-at-ingest, NOT RAG. The AI doesn't re-read sources every time you ask a question — it wrote the answer into a wiki page when it first ingested the source. This means knowledge accumulates instead of being recomputed.

---

## THE CODE PIPELINE

LTC's CODE Framework defines 4 stages of knowledge transformation:

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│    CAPTURE       │     │    ORGANIZE     │     │     DISTIL      │     │    EXPRESS       │
│                  │     │                 │     │                 │     │                  │
│  YOU save raw    │     │  YOU file to    │     │  AI compiles    │     │  YOU export for  │
│  sources:        │ ──► │  captured/      │ ──► │  wiki pages     │ ──► │  others:         │
│  • articles      │     │  folder         │     │  in distilled/  │     │  • summaries     │
│  • PDFs          │     │  (or use Web    │     │  with L1-L4     │     │  • reports       │
│  • transcripts   │     │   Clipper)      │     │  depth tracking │     │  • deliverables  │
│  • session notes │     │                 │     │                 │     │                  │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
      YOU                     YOU                     AI (/ingest)             YOU
```

### Directory structure

```
PERSONAL-KNOWLEDGE-BASE/
├── captured/               ← Raw sources (IMMUTABLE — never edited after saving)
│   └── karpathy-llm-wiki.md   (example: dropped article)
├── distilled/              ← AI-generated wiki pages (compiled by /ingest)
│   ├── _index.md           ← Navigation hub — AI updates after every ingest
│   ├── _log.md             ← Ingest audit trail (append-only, parseable)
│   ├── agents/             ← Topic folder: agent architecture pages
│   ├── hooks/              ← Topic folder: hook system pages
│   ├── knowledge-systems/  ← Topic folder: PKM methodology pages
│   └── ...                 ← More topics as knowledge grows
├── expressed/              ← Outputs that leave the PKB (summaries, exports)
├── dashboard.md            ← 5 Dataview live queries for PKB health
└── knowledge-map.canvas    ← Obsidian Canvas visualization of knowledge graph
```

---

## THE /INGEST WORKFLOW — STEP BY STEP

### How to add knowledge

```bash
# Step 1: Drop a source into captured/
#   • Drag a markdown file into PERSONAL-KNOWLEDGE-BASE/captured/
#   • OR use Obsidian Web Clipper (⌥⇧O) to clip any web page directly

# Step 2: Run ingest in Claude Code terminal
/ingest

# Step 3 (optional): Target a specific file or depth
/ingest karpathy-llm-wiki.md              # One specific file
/ingest karpathy-llm-wiki.md --depth L3   # Minimum L3 depth
/ingest --dry-run                          # Preview without writing
```

### What the agent does (5-step pipeline)

```
Step 1   Read new files in captured/ not yet in _log.md
Step 2   Read _index.md to find related existing pages (prevents duplicates)
Step 3   Write/update wiki pages in distilled/{topic}/ with depth tracking
Step 4   Append row to _log.md (audit trail: date, source, pages affected)
Step 5   Update _index.md catalog (so next ingest and next session can find them)
```

### Size routing (smart dispatch)

| Source Size | Strategy | Example |
|------------|----------|---------|
| < 100 KB | Standard pipeline (single-pass) | A blog post or article |
| 100-500 KB | Chunked pipeline (split by sections) | A long technical doc |
| > 500 KB | Parallel agent dispatch (survey → build → synthesize) | claude-code-docs-full.md (2 MB) |

### Two types of wiki pages

| Type | What It Is | When Created |
|------|-----------|-------------|
| **Entity page** | "What is X?" — one concept per page, factual | Every source produces at least 1 entity page |
| **Synthesis page** | "What patterns emerge?" — connects 3+ entity pages | Created when pattern detected across entities |

---

## THE 12-QUESTION LEARNING HIERARCHY

Every wiki page earns its depth by **answering questions** — level is never declared, always derived from how many questions are answered.

```
L1 — KNOWLEDGE (4 questions — required for ALL pages)
  ├── So What?            Why is this important? (relevance)
  ├── What Is It?         Definition and scope
  ├── What Else?          Related concepts, alternatives
  └── How Does It Work?   Mechanisms, processes

L2 — UNDERSTANDING (2 more — MANDATORY minimum for all pages = 6/12)
  ├── Why Does It Work?   Underlying principles
  └── Why Not?            When and why does it fail?

L3 — WISDOM (2 more — for core skill/framework pages = 8/12)
  ├── So What?            How can we benefit from this?
  └── Now What?           What should we do next?

L4 — EXPERTISE (4 more — for architecture decision pages = 12/12)
  ├── What Is It NOT?     Common misconceptions
  ├── How Not?            Anti-patterns to avoid
  ├── What If?            Alternatives if this fails
  └── Now What?           How can we do better than others?
```

> **Example:** A wiki page with `questions_answered: [so_what_relevance, what_is_it, what_else, how_does_it_work, why_does_it_work, why_not]` = **L2 Understanding** (6 questions). The page never says "level: L2" — the dashboard computes it from the count.

---

## PKB IN OBSIDIAN — YOUR READING & REVIEW IDE

### 5 plugins that bring PKB to life

| Plugin | Install In | What It Does For PKB |
|--------|-----------|---------------------|
| **Dataview** | Settings → Community Plugins → Search "dataview" → Enable JavaScript Queries | Powers `dashboard.md` — 5 live panels showing learning levels, uningested backlog, recent ingests, topic growth, review queue |
| **Spaced Repetition** | Search "obsidian-spaced-repetition" → Configure note folder to `PERSONAL-KNOWLEDGE-BASE/distilled/` | Flashcard-style review of wiki pages. Open Cmd+P → "Review flashcards" → rate Easy/Good/Hard → plugin auto-schedules next review. 5 min/day builds retention |
| **Canvas Mindmap** | Search "canvas-mindmap" → No config needed | Open `knowledge-map.canvas` → drag wiki pages to visualize topic clusters. Keyboard-driven mind mapping for brainstorming |
| **PDF++** | Search "pdf-plus" → Set highlight export to `captured/` | Annotate PDFs → send highlights directly to captured/ for ingest |
| **Web Clipper** | Browser extension (search "Obsidian Web Clipper") → Template: note location = `captured/`, name = `{{title}}` | Press `⌥⇧O` on any web page → clips to captured/ with frontmatter. Fastest capture path |

### The PKB Dashboard (5 live panels)

Open `PERSONAL-KNOWLEDGE-BASE/dashboard.md` in Obsidian to see:

| Panel | What It Shows | Why It Matters |
|-------|-------------|---------------|
| **Learning Level Distribution** | Pages grouped by L1/L2/L3/L4 depth | Spot shallow knowledge areas |
| **Uningested Files** | Sources in captured/ not yet processed | Your ingest backlog — aim for zero |
| **Recent Ingests** | Last 10 ingest operations with timestamps | Activity heartbeat — is knowledge growing? |
| **Topics** | Pages grouped by topic folder, with counts | Where your knowledge concentrates |
| **Review Queue** | Pages due for spaced repetition review | Oldest-first — prevents knowledge rot |

### PKB Lint (automatic health checks)

`scripts/pkb-lint.sh` runs automatically at session start and stop. 8 checks, zero AI, < 1 second:

| Check | What It Catches |
|-------|----------------|
| UNINGESTED | Sources in captured/ not in _log.md |
| SHALLOW | Pages below L2 minimum (< 6 questions) |
| FRONTMATTER | Missing required metadata fields |
| ORPHANS | Pages with no inbound [[links]] |
| LINKS | Broken [[links]] to non-existent pages |
| INDEX | Pages not listed in _index.md |
| STALE | Pages not updated in 30+ days |
| LOG | _log.md integrity (append-only) |

---

## — QMD & MEMORY VAULT —

> How semantic search powers auto-recall across sessions

---

## HOW QMD WORKS — YOUR LOCAL SEARCH ENGINE

**QMD** (Query Markdown) is a local semantic search engine that indexes your markdown files. It powers how your AI agent **remembers** across sessions.

```
YOUR MARKDOWN FILES          QMD ENGINE              YOUR AGENT
┌─────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│ distilled/              │     │  BM25 keyword    │     │ "Based on your   │
│ sessions/               │ ──► │  + vector embed  │ ──► │  wiki page on X, │
│ conversations/          │     │  + reranking     │     │  the answer is…" │
│ decisions/              │     │                  │     │                  │
│ 2-LEARN/_cross/output/  │     │                  │     │                  │
└────────────────────────┘     └──────────────────┘     └──────────────────┘
  You write/ingest/research     Indexes locally          Searches automatically
```

### Three search types

| Type | How It Works | Best For | Example |
|------|-------------|----------|---------|
| **lex** (BM25) | Exact keyword matching — fast, precise | Finding specific terms | `"connection pool" timeout -redis` |
| **vec** (semantic) | Meaning-based — understands intent | Natural language questions | `how does the rate limiter handle burst traffic?` |
| **hyde** (hypothetical) | You write what the answer looks like (50-100 words) | Nuanced, complex topics | `The rate limiter uses a token bucket algorithm...` |

### How QMD connects to Memory Vault

```
YOUR MACHINE
┌──────────────────────────────────────────────────────────┐
│                                                          │
│  Tier 1: Auto-Memory (built into Claude Code)            │
│    └── Claude remembers facts across sessions natively   │
│                                                          │
│  Tier 2: Memory Vault (Google Drive + markdown)          │
│    └── ~/[NAME]-Memory-Vault/07-Claude/                  │
│         ├── sessions/       (exported session logs)       │
│         ├── conversations/  (parsed transcripts)          │
│         └── decisions/      (decision records)            │
│                                                          │
│  Tier 3: QMD Search Layer                                │
│    └── Indexes Tier 2 + PKB distilled/ + 2-LEARN output  │
│         ├── lex search (keyword)                          │
│         ├── vec search (semantic)                         │
│         └── hyde search (hypothetical document)           │
│                                                          │
│  PKB Indexing (after each /ingest)                       │
│    └── PERSONAL-KNOWLEDGE-BASE/distilled/ → QMD          │
│         ├── qmd collection add distilled .                │
│         ├── qmd update && qmd embed                       │
│         Auto-runs on SessionStop hook — no manual step    │
│                                                          │
│  LEARN Indexing (after /learn:structure)                  │
│    └── 2-LEARN/_cross/output/ → QMD (collection: learn)  │
│         Structured P-pages (P0-P5) per topic              │
│         Auto-indexed on SessionStop — weight 1.5          │
│         "What did we learn about X?" auto-recalls         │
│                                                          │
│  Auto-Recall (MCP Integration)                           │
│    └── QMD is available as an MCP server — the agent     │
│         can search your vault at any point during a       │
│         conversation when your question relates to        │
│         previously ingested knowledge                     │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

> **The flywheel:** You ingest sources → wiki pages grow → QMD indexes them → agent recalls them → better answers → you ingest more → wiki grows. Knowledge compounds automatically.

### Setup: How to index your PKB

```bash
# One-time setup (or run /setup which does this for you):
cd PERSONAL-KNOWLEDGE-BASE
qmd collection add distilled .
qmd update distilled
qmd embed

# After each /ingest session (to index new wiki pages):
qmd update distilled && qmd embed
```

> **Tip:** The SessionStop hook auto-runs `qmd update && qmd embed` — so new wiki pages are indexed automatically when you close a session.

---

## — UPGRADED SKILLS —

> /ltc-brainstorming Discovery Protocol + all new commands

---

## /LTC-BRAINSTORMING — THE UPGRADE FROM SUPERPOWERS

**You know the brainstorming skill from the Superpowers Plugin.** In I2, it got a major upgrade called the **Discovery Protocol**.

### What changed

| Aspect | I1 (Superpowers Plugin) | I2 (Discovery Protocol) |
|--------|------------------------|------------------------|
| **Triggering** | You type `/brainstorming` explicitly | Auto-triggered — AI leads with inference, not questions |
| **Structure** | 9-step sequential checklist | **4 invisible gates** run automatically before any question |
| **First interaction** | "What do you want to build?" (blank-page anxiety) | AI infers your Effective Outcome first, then asks ONE focused question |
| **Force analysis** | Not explicit | **Mandatory UBS + UDS** — blockers AND drivers, identified in order |
| **Message discipline** | One question preferred | **1 question per message** (hard rule — never compounds) |
| **Output** | Design spec → invokes writing-plans skill | **Discovery Complete pre-spec** (5 structured fields) → feeds into `/dsbv` |

### The 4 invisible gates

When you start brainstorming, the agent runs these gates **silently** before asking you anything:

```
Gate 1: EO (Effective Outcome)       → Infers your desired outcome as VANA
                                        (Verb + Adverb + Noun + Adjective)
                                        Asks you to confirm or correct
Gate 2: SCOPE                         → Checks if EO spans multiple systems
                                        Narrows to a single system boundary
Gate 3: FORCE ANALYSIS                → Surfaces UBS (blockers) FIRST, then UDS (drivers)
                                        Rule: identify what blocks before what accelerates
                                        Exit: ≥2 blockers AND ≥1 driver registered
Gate 4: APPROACH                      → Evaluates ≥2 viable paths using S > E > Sc
                                        (Sustainability > Efficiency > Scalability)
                                        Exit: approach chosen with rationale
```

> **Why invisible?** You don't need to know the gates exist. They structure the AI's thinking so that when it speaks to you, it already understands the problem space. You get focused questions instead of generic "tell me more."

### The Discovery Complete output

After the guided conversation, the agent produces a **pre-spec with 5 fields**:

```
┌──────────────────────────────────────────────────────────┐
│  DISCOVERY COMPLETE                                      │
├──────────────────────────────────────────────────────────┤
│  1. EO         Effective Outcome (VANA format)           │
│  2. SCOPE      Single system boundary (1 sentence)       │
│  3. BLOCKERS   UBS — what prevents success? (≥2)         │
│  4. DRIVERS    UDS — what enables success? (≥1)          │
│  5. APPROACH   Chosen path + S/E/Sc rationale            │
└──────────────────────────────────────────────────────────┘
```

### How it connects to DSBV

```
/ltc-brainstorming                           /dsbv
┌──────────────────────┐                ┌──────────────────────┐
│  Discovery Protocol  │                │  Design Phase        │
│  (4 gates)           │ ─── feeds ──► │  EO becomes §1 of    │
│                      │    into        │  context-packaging    │
│  Output:             │                │  template             │
│  Discovery Complete  │                │                      │
│  (5 fields)          │                │  Then: Sequence →     │
│                      │                │  Build → Validate     │
└──────────────────────┘                └──────────────────────┘

  Option A: PM says "let's build it" → agent offers /dsbv to start Design phase
  Option B: PM just wanted clarity  → closes with Discovery Complete summary
```

> **How this helps you:** Instead of jumping from "I have an idea" to "write the code," you now have a structured problem definition that exposes hidden assumptions, surfaces blockers early, and aligns the agent to your actual intent. When you're ready to build, the Discovery Complete feeds directly into DSBV as the starting context.

---

## ALL AGENT COMMANDS — CHEAT SHEET

### Core skills

| Command | What It Does | When To Use |
|---------|-------------|-------------|
| `/dsbv status` | Show your Design-Sequence-Build-Validate pipeline | Morning check, work session |
| `/dsbv build` | Tell agent to advance current item to next DSBV stage | Active work — agent writes artifacts |
| `/ingest` | Compile captured sources into PKB wiki pages | After saving articles/PDFs to `captured/` |
| `/compress` | Save session context to memory vault | End of day, before starting fresh |
| `/resume` | Load context from previous sessions | Start of day, picking up where you left off |
| `claude -c` | **Crash recovery** — restore full conversation from terminal (run before opening Claude) | After unexpected shutdown / if you never ran `/compress` |
| `/obsidian` | Search your vault via QMD semantic search | When you need to find something by meaning |
| `/ltc-brainstorming` | Structured discovery with 4 invisible gates | Starting a new feature or investigation |

### Template & migration skills

| Command | What It Does | When To Use |
|---------|-------------|-------------|
| `/template-check` | Audit your project files against I2 template (read-only) | Before upgrading — see what's changed |
| `/template-sync` | Apply I2 template updates interactively (never deletes) | Migration from I1 → I2 |
| `/setup` | Initialize Memory Vault + QMD semantic search (idempotent) | First-time setup or re-initialization |
| `/vault-capture` | Capture content into PKB or vault from Claude Code | Quick knowledge capture during work |

### Templater shortcuts (inside Obsidian)

```
Press Ctrl+T (Cmd+T on Mac) to insert a template from the 13 pre-built options:
  ADR, daily note, driver entry, risk entry, deliverable, retrospective, and more.
```

---

## /SETUP — QMD & MEMORY VAULT

Two separate setup commands for two separate systems:

| Command | What it sets up | What it does |
|---------|----------------|-------------|
| **`/setup`** | Memory Vault + QMD | Scaffolds Google Drive vault folders (sessions/, conversations/, decisions/). Installs QMD search engine. Connects QMD to your PKB. Runs smoke test. |
| **`./scripts/setup-obsidian.sh`** | Obsidian visual layer | Copies `.base` dashboards + Templater templates + CSS snippet into `.obsidian/`. Lists plugins to install manually. |

### /setup — 5 steps (automated)

```
/setup
```

1. Scaffolds Memory Vault folders on Google Drive (sessions/, conversations/, decisions/)
2. Installs QMD search engine — indexes your vault for semantic search
3. Connects QMD to your PKB (distilled/ → qmd collection add)
4. Runs smoke test to verify everything works
5. Idempotent — safe to re-run anytime

```
Your PKB pages ──→ QMD indexes them ──→ Agent auto-recalls relevant knowledge
                                         when you ask questions
```

> **Why this matters:** Without QMD, your agent has no memory between sessions. With QMD, it recalls past decisions, research, and context automatically.

---

## — GETTING STARTED —

> Setup, first actions, and reference

---

## SETUP & INSTALL

### 7 steps to a working vault

| Step | Action | Note |
|------|--------|------|
| **1** | Download Obsidian from `obsidian.md` | Free for personal use |
| **2** | File → Open Vault → select your project root folder | The repo IS the vault |
| **3** | Settings → Community Plugins → turn off Restricted Mode | Safe — our repo includes security rules |
| **4** | Install & enable: **Bases**, **Terminal**, **Templater** | Templater: `Ctrl+T` / `Cmd+T` to insert templates |
| **5** | Settings → Appearance → CSS Snippets → enable `ltc-bases-colors` | Adds LTC brand colors to dashboard tables |
| **6** | Install for PKB: **Dataview** (enable JS queries), **Spaced Repetition**, **Canvas Mindmap** | Enables PKB dashboard, flashcard review, knowledge maps |
| **7** | Navigate to `_genesis/obsidian/bases/` → click any `.base` file | Verify your dashboards are working |

> **The `.base` files and CSS are already in your repo.** You just enable the plugins and snippet.

---

## YOUR FIRST 5 ACTIONS

| # | Action | What You'll See |
|---|--------|----------------|
| **01** | Open `C3-standup-preparation` dashboard | Files modified recently, grouped by recency |
| **02** | Open `C4-blocker-dashboard` — scan for red items | Risk levels auto-computed from staleness |
| **03** | Open `C1-master-dashboard` — full project overview | All workstreams, stages, and statuses in one view |
| **04** | Open `PERSONAL-KNOWLEDGE-BASE/dashboard.md` | 5 live panels showing your knowledge system health |
| **05** | In Claude Code: type `/dsbv status` | Your Design-Sequence-Build-Validate pipeline at a glance |

> **After these 5:** You understand both systems. Now explore at your own pace.

---

## — REFERENCE —

---

## CHEAT SHEET

### Frontmatter quick reference

```yaml
---
type: ues-deliverable
version: "2.0"
status: draft | in-progress | in-review | validated | archived
work_stream: 1-ALIGN | 2-LEARN | 3-PLAN | 4-EXECUTE | 5-IMPROVE
stage: design | sequence | build | validate
sub_system: 1-PD | 2-DP | 3-DA | 4-IDM
owner: "Your Name"
last_updated: 2026-04-06
---
```

### Dashboard index

| Code | Name | Layer | Purpose |
|------|------|-------|---------|
| C1 | Master Dashboard | Cross-cutting | All deliverables |
| C2 | Stage Board | Cross-cutting | DSBV pipeline |
| C3 | Standup Preparation | Cross-cutting | Recent changes |
| C4 | Blocker Dashboard | Cross-cutting | Staleness risk |
| C5 | Approval Queue | Cross-cutting | Your review items |
| C6 | Version Progress | Cross-cutting | Iteration tracking |
| C7 | Dependency Tracker | Cross-cutting | Upstream/downstream |
| W1 | Alignment Overview | Workstream | 1-ALIGN |
| W2 | Learning Overview | Workstream | 2-LEARN |
| W3 | Planning Overview | Workstream | 3-PLAN |
| W4 | Execution Overview | Workstream | 4-EXECUTE |
| W5 | Improvement Overview | Workstream | 5-IMPROVE |
| U1 | Daily Notes Index | Utility | Daily logs |
| U2 | Tasks Overview | Utility | Task tracking |
| U3 | Inbox Overview | Utility | Unprocessed items |
| U4 | People Directory | Utility | Stakeholders |
| U5 | Templates Library | Utility | Template browser |
| U6 | Agent Activity | Utility | Agent action log |

### File locations

```
_genesis/obsidian/bases/               ← 18 dashboard .base files
_genesis/obsidian/ltc-bases-colors.css ← LTC brand theme
_genesis/training/                     ← This training deck
PERSONAL-KNOWLEDGE-BASE/               ← Knowledge management system
.claude/skills/                        ← Agent skill definitions
.claude/rules/                         ← Governance rules (always-on)
scripts/                               ← Infrastructure scripts (lint, check, sync)
```

---

## YOUR DAY AS A PM — BEFORE AND AFTER I2

```
┌─ BEFORE (I1) ─────────────────────────────────┐
│                                                │
│  8:30  Open repo. Scan folders. What changed?  │
│  8:45  Check git log. Try to remember context  │
│  9:00  Standup. "I think we're on track..."    │
│  9:30  Start working. Which file was I on?     │
│ 11:00  Idea for new feature. Blank page.       │
│ 14:00  Agent finished. Did it do it right?     │
│        Open 5 folders to check.                │
│ 16:00  Read an article. Bookmark it. Forget it │
│ 17:00  Close laptop. Context lost.             │
│                                                │
└────────────────────────────────────────────────┘

┌─ AFTER (I2) ──────────────────────────────────┐
│                                                │
│  8:30  Open C3. See exactly what changed.      │
│  8:32  Open C4. No blockers. System healthy.   │
│  9:00  Standup. "3 items moved, 1 at risk."   │
│  9:15  Open C2. My item is in Build stage.     │
│        Type /dsbv build. Agent advances it.    │
│ 11:00  Idea for new feature.                   │
│        Type /ltc-brainstorming.                │
│        Agent structures my thinking in 4 gates │
│        → Discovery Complete → /dsbv ready      │
│ 14:00  C5 shows 2 items need my review.        │
│        Open file, read, change to validated.   │
│ 16:00  Read an article. Drop in captured/.     │
│        Type /ingest. Wiki page created.        │
│        QMD indexes it. Agent recalls it later. │
│ 17:00  Type /compress. Context saved.          │
│        Tomorrow: /resume picks up right here.  │
│                                                │
└────────────────────────────────────────────────┘
```

> **I2 doesn't add more work. It removes the work you were already doing badly — tracking status in your head, searching folders, losing knowledge, re-explaining context.**

---

## ITERATION 2: EFFICIENT

### The system works when you do two things: keep frontmatter current, and keep feeding your knowledge base.

```
  ┌────────────────────────────────────────────────────────────────────┐
  │                                                                    │
  │   Your morning:   C3 → C4 → C1 (5 minutes, full picture)         │
  │   Your work:      /dsbv build (agent writes, you review)          │
  │   Your thinking:  /ltc-brainstorming (structured, not blank-page) │
  │   Your knowledge: /ingest (compounds, never evaporates)           │
  │   Your approvals: C5 (you are the gate, dashboards remind you)    │
  │   Your context:   /compress + /resume (nothing lost between days) │
  │                                                                    │
  └────────────────────────────────────────────────────────────────────┘
```

**LT Capital Partners · 2026**
