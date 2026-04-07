---
name: ltc-brand-identity
version: "1.0"
status: draft
last_updated: 2026-04-07
description: >
  Use when creating, editing, or reviewing HTML, CSS, SVG, charts, slide decks, diagrams,
  emails, PDFs, or other visual artifacts that must comply with LTC brand identity; also
  when the user asks to apply LTC brand, fix brand colors or fonts, or audit output for
  brand compliance. Does not own domain-specific generators (e.g. /learn:visualize) — use
  this skill within those flows whenever visual rules must be enforced.
---

# LTC Brand Identity

Enforces LT Capital Partners visual standards on agent-generated artifacts so outputs use
approved colors, typography, and logo treatment instead of generic defaults.

## When to Use

- Before finalizing any HTML, CSS, SVG, canvas, chart, deck, or styled export
- When the user says “LTC brand,” “company colors,” “fix the fonts,” or “brand compliance”
- When retrofitting an existing artifact that used Bootstrap/Tailwind grays, Arial, or Roboto

## Steps

1. **Load canonical rules**
   Read [rules/brand-identity.md](../../../rules/brand-identity.md) from the repo root (source of truth). Optional human-oriented detail: [_genesis/brand/brand-guide.md](../../../_genesis/brand/brand-guide.md) if present.

2. **Choose application profile**
   Reference: [references/application-profiles.md](references/application-profiles.md) — web, print-like, or MS Office theme slots.

3. **Apply mandatory elements**
   Reference: [references/palette-and-type.md](references/palette-and-type.md) — primaries, accent priority, Inter / Work Sans, base 11pt scale, logo wording.

4. **GATE:** Before delivering or saving the artifact, verify:
   - At least one Google Fonts `<link>` or `@import` appears for **Inter** (English) and **Work Sans** when Vietnamese may appear
   - No reliance on “system UI” or Roboto/Arial/Helvetica as the only font stack without the Google Fonts hook
   - Primary surfaces use **Midnight Green `#004851`** and/or **Gold `#F2C75C`** and **Dark Gunmetal `#1D1F2A`** / **White `#FFFFFF`** as appropriate to light vs dark background — not generic blue/gray palettes
   - Logo text reads **LT Capital Partners** when a logo wordmark is shown

   **Do not proceed** to hand off as “complete” until this gate passes or the escape hatch is documented.

5. **Document exceptions**
   If the user explicitly requests a non-LTC look for a throwaway mock, note the deviation in the artifact or reply — do not silently ship mixed brand.

## Constraints

- **Accent priority (when choosing highlights):** Gold > Ruby Red `#9B1842` > Green `#69994D` > Dark Purple `#653469`
- **Never** present LTC-branded work using only default IDE/chart/slide colors
- Function color assignments (org unit hues) apply when the artifact encodes LTC function; see full palette in `rules/brand-identity.md`

## Escape Hatch

If `rules/brand-identity.md` is missing or unreadable: apply the **CLAUDE.md** summary block — Midnight Green `#004851`, Gold `#F2C75C`, Dark Gunmetal `#1D1F2A`, White `#FFFFFF`; Inter + Work Sans via Google Fonts; **LT Capital Partners** wordmark text. State in the reply that validation used the fallback block and recommend restoring the full rules file.

## Gotchas

See [gotchas.md](gotchas.md) for known failure patterns.

## Links

- [[brand-guide]]
- [[CLAUDE]]
- [[application-profiles]]
- [[brand-identity]]
- [[gotchas]]
- [[palette-and-type]]
