# Gotchas — ltc-brand-identity

1. **Fonts without `<link>`** — The agent lists `Inter` in CSS but skips Google Fonts; text renders as Arial/Helvetica. Always add the `fonts.googleapis.com` link (or `@import`) for Inter and Work Sans before claiming the artifact is on-brand.

2. **Dark mode contrast** — Gold `#F2C75C` on White fails WCAG for small text; use Gold for accents/large type on dark backgrounds, or pair with Midnight Green/Dark Gunmetal backgrounds per design intent.

3. **Chart library defaults** — Chart.js, Recharts, and similar default to a non-LTC palette. Explicitly set `color` / `backgroundColor` arrays from the LTC hex list in `rules/brand-identity.md`, not the library defaults.

4. **“Brand” collision with learn-visualize** — `/learn:visualize` already loads `rules/brand-identity.md` for map UIs. This skill is the general entry for *any* visual artifact; use both when building the learn map so structure comes from learn-visualize and cross-check brand with this skill.
