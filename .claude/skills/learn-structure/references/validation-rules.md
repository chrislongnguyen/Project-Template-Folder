# Validation Rules — Effective Learning Page Output

These rules are checked after each page is written AND as a batch after all 6 pages complete.

---

## 1. CAG Regex Validation

Every cell in the markdown table (after the row label column) must match this regex:

```
^(Eff\.[A-Z][A-Z0-9-]*|UBS|UDS|(P_?F?[0-9]*)(\([A-Za-z]+\))?|([A-Z][A-Z0-9_]*)(\.[0-9]+)?)\([RAb][A-Za-z]*\)(\.U[BD])*\.(REL|DEF|ACT|UD|UB|FAIL|ELSE|NEXT|UD\.MECH|UD\.EP|UD\.EOT|UD\.EOE|UB\.MECH|UB\.EP|UB\.EOT|UB\.EOE): .+$
```

**P0 CAG prefix format:** `Eff.{ABBREV}(R).` — e.g., `Eff.DF(R).REL:`, `Eff.AI-Effective Learning(A).UD:`.
`{ABBREV}` = `subject_abbreviation` field from learn-input. The row label uses the full name; the CAG prefix uses the abbreviation.

**How to check:** Strip leading/trailing whitespace and pipe characters from each cell, then match.

**Common failures:**
- Old `Effective(R).REL:` format → FAIL (must use `Eff.{ABBREV}(R).REL:`)
- Missing colon after suffix: `Eff.DF(R).REL The system...` → FAIL (needs `: `)
- Wrong suffix order: `Eff.DF(R).EP.UD:` → FAIL (should be `.UD.EP:`)
- Missing role tag: `UBS.REL:` → FAIL (needs `UBS(R).REL:`)
- Empty content after tag: `Eff.DF(R).REL: ` → FAIL (must have content after `: `)

---

## 2. Column Count Validation

Every data row must have exactly **17 pipe-delimited columns**:
- Column 0: Row label (e.g., `**Effective Data Foundation(R)**`)
- Columns 1-16: Content cells, each starting with a CAG tag

**How to check:** Count `|` characters per row. A correct row has 18 pipes (17 columns + outer pipes on both sides).

**Pipe pattern:** `| Row Label | cell1 | cell2 | ... | cell16 |`

---

## 3. Row Count Validation

| Page | T0 Depth | T1+ Depth | Rule |
|------|----------|-----------|------|
| P0 | Exactly 2 | Exactly 2 (copied) | HARD — no variance |
| P1 | Exactly 2 | 2-6 | Depends on role chains |
| P2 | Exactly 2 | 2-6 | Depends on role chains |
| P3 | 4-8 | 4-8+ | Typical range (soft) |
| P4 | 4-8 | 4-8+ | Typical range (soft) |
| P5 | 4-6 | 4-6+ | Typical range (soft) |

**Hard rules:** P0 row count is strict. P1/P2 at T0 depth is strict.
**Soft rules:** P3-P5 row counts are guidance. Flag if outside range but don't fail.

---

## 4. Cross-Page Consistency

### P0 → P1 seed check
- P0 row `Effective(R)` col 10 (`.UB:`) content should match P1 row `UBS(R)` row label description
- P0 row `Effective(A)` col 10 (`.UB:`) content should match P1 row `UBS(A)` row label description

### P0 → P2 seed check
- P0 row `Effective(R)` col 4 (`.UD:`) content should match P2 row `UDS(R)` row label description
- P0 row `Effective(A)` col 4 (`.UD:`) content should match P2 row `UDS(A)` row label description

### P0/P1/P2 → P3 harvest check
- Every principle in P3 should trace back to a col 6 (`.UD.EP`) or col 12 (`.UB.EP`) cell in P0, P1, or P2
- No orphan principles (principles not sourced from earlier pages)

---

## 5. Direction Inversion Check

On **UBS rows** specifically:
- Col 6 (`.UD.EP`) must use `P_F` notation (failure principle — bad for learner)
- Col 12 (`.UB.EP`) must use `P` notation (enabling principle — good for learner)

On **UDS rows** and **Effective rows**:
- Col 6 (`.UD.EP`) must use `P` notation (enabling principle — good for learner)
- Col 12 (`.UB.EP`) must use `P_F` notation (failure principle — bad for learner)

**How to check:** In EP cells, look for `P_F` vs `P` at start of principle references.

---

## 6. Effective Learning Term Compliance

Cells must use Effective Learning column suffixes exclusively:
- `.UD`, `.UB` — not "Drivers", "Blockers"
- `.EP` — not "Principles"
- `.EOT`, `.EOE` — not "Tools", "Environment"

---

## 7. Non-Empty Cell Check

No cell should contain only its CAG tag with no content after `: `.

**Allowed:** `Effective(R).REL: Data Foundation enables analysts to transform raw data...`
**Not allowed:** `Effective(R).REL: ` or `Effective(R).REL: TBD`

Exception: If research genuinely lacks content for a cell, use `[NEEDS REVIEW]` flag:
`Effective(R).UB.EOE: [NEEDS REVIEW] Research did not cover environmental requirements for this blocker.`

---

## Validation Script Usage

```bash
# Per-page validation
bash 2-LEARN/_cross/scripts/validate-learning-page.sh <page-file> <page-type> <topic-depth>

# Arguments:
#   page-file:    path to the generated page markdown file
#   page-type:    P0 | P1 | P2 | P3 | P4 | P5
#   topic-depth:  T0 | T1 | T2 | T3 | T4 | T5

# Returns:
#   exit 0 = PASS (all checks pass)
#   exit 1 = FAIL (with error details on stderr)

# Example:
bash 2-LEARN/_cross/scripts/validate-learning-page.sh 2-LEARN/_cross/output/data-foundation/T0.P0-overview-and-summary.md P0 T0
```

## Links

- [[blocker]]
