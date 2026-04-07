---
version: "1.2"
status: draft
last_updated: 2026-04-07
name: learn-visualize
description: >
  Use when the user invokes /learn:visualize or asks to generate a visual system map
  from validated P-pages. Reads structured learning pages (P0-P5) for a given system
  slug and generates a self-contained React+Vite interactive HTML map with LTC brand.
argument-hint: "[system-slug]"
allowed-tools: Read, Glob, Grep, Write, Bash
---
# /learn:visualize — Interactive System Map Generator

Reads validated P-pages for a system slug and generates a self-contained interactive
HTML visualization (React+Vite via CDN). Nodes from P-page table rows. Edges from
causal references. LTC brand throughout.

## Arguments

Required: `{system-slug}` — matches the slug used in `/learn:research` and `/learn:structure`.

If omitted, list available slugs by scanning `2-LEARN/_cross/research/` and ask user to choose.

## HARD-GATE — Prerequisites

Before generating, verify:

1. `2-LEARN/_cross/research/{slug}/` exists (research was run)
2. All topic directories under `_cross/research/{slug}/` contain P0.md through P5.md
3. Every P-page frontmatter has `status: validated`

If any P-page is missing `status: validated`:

```
STOP. These topics are not yet validated for visualization:
  - {topic}: {which pages missing approval}
Run /learn:review {slug} {topic} first, then retry.
```

Do NOT generate a map from unvalidated pages — causal structure may still change.

## Step 1 — Load Brand Rules

> Load `rules/brand-identity.md` before generating any HTML/CSS.

Required brand constants (also listed here for quick reference):
- Primary bg: Midnight Green `#004851`
- Accent: Gold `#F2C75C`
- Dark surface: Dark Gunmetal `#1D1F2A`
- Text on dark: White `#FFFFFF`
- Font: Inter (English) — Google Fonts CDN
- Logo text: "LT Capital Partners"

## Step 2 — Extract Graph Data

> See `references/viz-spec.md §1` for full extraction rules.

For each validated topic, read P0-P5 and extract:
- **Nodes** — one node per table row. Node ID = CAG prefix (e.g. `UBS.R.1`). Label = row subject. Page = source page (P0-P5). Pillar = S / E / Sc from col 15.
- **Edges** — causal links stated in col 12 (causes) and col 13 (effects). Parse as directed edges: source node → target node.

Build a JSON structure:
```js
{ nodes: [{id, label, page, pillar, topic, detail}], edges: [{from, to, label}] }
```

## Step 3 — Generate HTML App

> See `references/viz-spec.md §2` for the full React+Vite CDN template.

Generate a single self-contained HTML file at:
`2-LEARN/_cross/visual/learn-visual-{slug}/index.html`

Required features:
- React + ReactDOM via CDN (esm.sh or unpkg)
- Inter font via Google Fonts `<link>`
- Node graph rendered with vis-network or D3 force layout (CDN)
- **Click-to-drill:** clicking a node expands a side panel showing full P-page row detail
- **Hover tooltip:** shows node label + pillar tag
- **Filter by pillar:** S / E / Sc toggle buttons (Gold highlight = active filter)
- **Export PNG:** button that calls `html2canvas` and triggers download
- LTC colors applied to: background, node fills (by pillar), panel, buttons, header

GATE: Before writing the file, verify the JSON has ≥1 node and ≥1 edge. If the graph
is empty (pages have no table rows or no causal references), stop and report:
```
Cannot generate map — no nodes or edges extracted. Check that P-pages contain
structured table rows with CAG prefixes and causal reference columns.
```

## Step 4 — Output Confirmation

After writing the file, confirm:
```
learn-visualize complete:
  Output:  2-LEARN/_cross/visual/learn-visual-{slug}/index.html
  Nodes:   {N}
  Edges:   {N}
  Topics:  {list}

Open index.html in a browser to view. No build step required.
```

## Escape Hatches

| Failure | Response |
|---------|----------|
| vis-network CDN unavailable | Fall back to D3 force layout (also CDN). Note in output. |
| D3 CDN also unavailable | Generate a static SVG layout instead. No interactivity — note limitation. |
| P-pages exist but no CAG prefixes found | Report which pages are missing structure. Do not generate empty map. |
| html2canvas CDN unavailable | Omit export button. Note in output: "PNG export unavailable — add html2canvas manually." |

## Gotchas

- **Status check is mandatory** — do not skip even if the user says "just do it." Unvalidated pages produce misleading causal maps that contradict the review process.
- **Brand rules must load first** — NEVER use default colors (Bootstrap blue, gray). Every visual element must use LTC hex codes. Load `rules/brand-identity.md` before generating HTML.
- **Self-contained HTML only** — no local npm build, no node_modules, no separate JS files. The output must open directly in a browser without any build step.
- **CAG prefix parsing** — row IDs use dot notation (`UBS.R.1`, `EP.3`, `EOE.2`). Parse the prefix, not the full row label. Edges come from col 12/13, not from proximity in the table.
- **Pillar column** — S/E/Sc comes from col 15 of the 17-column format. Do not infer pillar from row label text.

## Links

- [[brand-identity]]
- [[gotchas]]
- [[viz-spec]]
