---
version: "1.0"
status: draft
last_updated: 2026-04-06
work_stream: _genesis
---

# Training Decks

Two slide decks live here. They serve different purposes.

## Iteration 2 Production Deck (use this one)

```
obsidian-bases-training/
```

**Content:** Obsidian Bases, PKB, QMD, Claude Code skills, status lifecycle, DSBV process.
**Slides:** 47 | **Stack:** React + Vite + Framer Motion

### How to run

```bash
# From repo root:
cd _genesis/training/obsidian-bases-training
npm ci
npm run dev -- --port 5173
```

Then open: `http://127.0.0.1:5173/`

### How to tell your agent to run it

```
Open the Iteration 2 training deck — run the Vite dev server
in _genesis/training/obsidian-bases-training on port 5173
```

### Build for distribution

```bash
cd _genesis/training/obsidian-bases-training
npm ci && npm run build
# Ship the dist/ folder via static hosting
```

## ALPEI Foundations Deck (separate content)

```
alpei-training-slides/
```

**Content:** ALPEI workstream foundations, frontmatter anatomy, Obsidian workflow basics.
**Purpose:** Introductory training — covers the "what" before the Iteration 2 deck covers the "how."
**Note:** This is NOT a legacy/deprecated deck. It teaches different material (ALPEI structure)
that the Iteration 2 deck assumes you already know.

### How to run

```bash
cd _genesis/training/alpei-training-slides
npm ci
npm run dev -- --port 5174
```

Port 5174 (not 5173) to avoid collision if both run simultaneously.

## Common issues

| Problem | Fix |
|---------|-----|
| Stale slides in browser | Hard refresh: Cmd+Shift+R |
| Multiple Vite servers on different ports | Kill all: `lsof -ti:5173,5174,5175,5176,5177,5178,5179 \| xargs kill -9` then restart |
| Wrong deck opens | Check the port — 5173 = Iteration 2, 5174 = ALPEI foundations |
| `npm ci` fails | Delete `node_modules/` and retry |

## Links

- [[CLAUDE]]
- [[workstream]]
