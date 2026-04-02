# Gotchas — learn-visualize

Failure patterns from design and anticipated failure modes. Read before generating.

---

## G1: Skipping the approval gate

**What goes wrong:** Agent generates the map before all P-pages have `status: approved`.
Causal structure in unapproved pages may still change during review, making the visual
map stale or misleading the moment a page is revised.

**Rule:** The HARD-GATE check (Step 0) is non-negotiable. If the user says "just generate
it anyway," explain that the map is only meaningful when the causal structure is locked.
Offer to run `/learn:review` first.

---

## G2: Using default colors or fonts

**What goes wrong:** Agent generates HTML with Bootstrap blue, Tailwind gray, or system
fonts (Arial, Helvetica, Roboto). Output fails brand compliance and looks unprofessional.

**Rule:** Load `rules/brand-identity.md` FIRST. Apply LTC hex codes to every element:
`#004851` (bg/header), `#F2C75C` (Gold — accents, active state), `#1D1F2A` (panels),
`#FFFFFF` (text on dark). Inter font via Google Fonts `<link>` — never omit it.

---

## G3: Requiring a build step

**What goes wrong:** Agent generates separate `App.jsx`, `package.json`, or `vite.config.js`
files expecting the user to run `npm install && npm run build`. Users cannot open the output
without a build environment.

**Rule:** Single self-contained `index.html` with React and all libraries loaded via CDN.
No build step. No local files. Test by opening in browser directly.

---

## G4: Empty graph (no nodes or edges)

**What goes wrong:** P-pages exist but have no CAG-prefixed table rows, or causal reference
columns (col 12/13) are blank. Agent generates an empty canvas or crashes.

**Rule:** Check node count BEFORE writing the file. If 0 nodes: stop and report which pages
are missing structured rows. Do not write an empty HTML file.

---

## G5: Parsing row labels instead of CAG prefixes as node IDs

**What goes wrong:** Agent uses the full row label ("Effective Claude Agent (R)") as the
node ID, causing edge matching to fail because edge source/target references use CAG
notation (`UBS.R.1`).

**Rule:** Node ID = CAG prefix only (e.g., `UBS.R.1`, `EP.3`). Label = row subject text.
Parse edges from col 12/13 using the same CAG prefix notation.

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[brand-identity]]
