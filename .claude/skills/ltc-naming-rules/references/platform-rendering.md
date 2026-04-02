# Platform Rendering (Summary)

Full rules: `rules/naming-rules.md` §2–3.

## Where UNG applies

| Context | UNG? |
|---------|------|
| Git repos, local top-level folders | Yes — canonical key; Git max **50** chars |
| ClickUp PJ Project, PJ Deliverable | Yes — bracketed group + formatted segments |
| ClickUp task / increment / doc (below deliverable) | **No** — free text |
| Learning book filenames in repo | **No** — `BOOK-NN --` convention |

## Git / GitHub

- Canonical Key as-is; **ALL CAPS**; no spaces, no brackets.
- Max **50** characters — abbreviate NAME words first, then org segment; never abbreviate SCOPE, FA, ID.

## ClickUp (short)

- **Canonical → ClickUp:** Table 3a → bracketed display name → append `_FA.ID. ` patterns per PJ Project vs PJ Deliverable formulas in `rules/naming-rules.md`.
- **ClickUp → Canonical:** strip brackets, map display to SCOPE, spaces in NAMEs → hyphens, preserve 3-part structure when present.

## Google Drive

- Similar bracket patterns; optional decorators (`[RESTRICTED]_`, owner tags, version suffixes). Title Case allowed; `AND` may appear as `&`.

## Links

- [[deliverable]]
- [[increment]]
- [[naming-rules]]
- [[project]]
- [[task]]
