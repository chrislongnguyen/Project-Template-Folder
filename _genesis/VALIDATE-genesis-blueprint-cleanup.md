---
version: "2.0"
status: Draft
last_updated: 2026-04-03
type: validate
design_ref: "_genesis/DESIGN-genesis-blueprint-cleanup.md"
---

# VALIDATE: _genesis/ Cleanup + Blueprint Restructure

## Verdict: PASS

All 16 ACs pass. Ready for merge.

## AC Results

| AC | Description | Status | Evidence |
|----|-------------|--------|----------|
| AC-1 | Zero duplicate framework files in `_genesis/frameworks/` (no ALL_CAPS + ltc- pairs) | PASS | `ls _genesis/frameworks/` shows 18 kebab-case files + README.md + archive/. No ALL_CAPS files outside archive/. |
| AC-2 | VANA gate, sub-system inheritance, version awareness enforced via existing rules (zero new rule files) | PASS | Commit `d7f591a` adds +5 lines (chain-of-custody), +3 lines (dsbv.md VANA gate), +3 lines (versioning.md) = +11 content lines. Remaining diff lines are version bumps and APEI->ALPEI fixes. Zero new files. |
| AC-3 | Blueprint lives at `_genesis/BLUEPRINT.md` with no broken references | PASS | `_genesis/BLUEPRINT.md` exists (version 2.0). Redirect stub at `1-ALIGN/charter/BLUEPRINT.md`. Grep hits for old path appear only in CHANGELOG (descriptive), MIGRATION_GUIDE (rename table), SEQUENCE/DESIGN (build docs) -- no live code or rule references point to old location. |
| AC-4 | Blueprint Part 5 (Roadmap) uses VANA + user-centric ACs, not 8-component tables | PASS | Part 5 = 71 lines (under 80 limit). Each iteration has VANA statement. AC counts: I0 = 0 (retrospective paragraph), I1 = 7, I2 = 8, I3 = 5, I4 = 3. All within 8-AC limit. |
| AC-5 | Blueprint Part 3 (Operating Model) defines PM role, RACI, tool split | PASS | Part 3 (lines 169-208) contains: 4 responsibilities table (LEARN > INPUT > REVIEW > APPROVE), RACI table (Agent=R, PM=A), Tool Split table (Obsidian for ALIGN/LEARN/PLAN, Cursor for EXECUTE). |
| AC-6 | All framework files in `_genesis/frameworks/` are kebab-case | PASS | All 18 canonical files are kebab-case. No SCREAMING_SNAKE filenames outside archive/. |
| AC-7 | Auto-loaded rule token budget unchanged (zero new rule files) | PASS | `.claude/rules/` has 8 files before and after. Zero additions. Note: DESIGN says "9 files" but baseline was always 8 (alpei-template-usage.md listed in DESIGN Section 6 does not exist on disk). The intent (zero new files) is met. |
| AC-8 | Every surviving `_genesis/frameworks/` file has S x E x Sc justification | PASS | DESIGN Section 5 table covers all 18 canonical files (15 rows, process-map p1-p4 grouped). Each has S, E, Sc columns populated. |
| AC-9 | `sops/ALPEI_OPERATING_PROCEDURE.md` archived; `security/NAMING_CONVENTION.md` kept | PASS | `_genesis/sops/archive/ALPEI_OPERATING_PROCEDURE.md` exists. `_genesis/security/NAMING_CONVENTION.md` exists. |
| AC-10 | All renames are content-free commits; all content changes are rename-free commits | PASS | Rename commits (bf8a600, fe4d3ac, acb60f2, 6de0cc5) show R100 (100% similarity = zero content change). Content commits (f2013c4, d7f591a, fae77ee, 9a327f3) show zero renames via `--diff-filter=R`. |
| AC-11 | Migration guide updated with rename table | PASS | `_genesis/guides/MIGRATION_GUIDE.md` lines 171+ contain "v2.0 Changes" section with Blueprint relocation note and 9-row rename table (ALL_CAPS -> kebab-case). |
| AC-12 | 5 PDFs in `_genesis/reference/` untouched | PASS | 5 PDFs present: ltc-alpei-framework-by-subsystem.pdf, ltc-alpei-framework-by-workstreams.pdf, ltc-alpei-framework-overview.pdf, ltc-alpei-process-requirements.pdf, ltc-ues-versioning.pdf. |
| AC-13 | Placeholder dirs (governance/, compliance/, culture/, philosophy/, principles/) untouched | PASS | All 5 dirs present, each containing README.md. |
| AC-14 | Zero old SCREAMING_SNAKE references outside `archive/` after rename | PASS | Grep for `ALPEI_DSBV_PROCESS_MAP|AGENT_SYSTEM|AGENT_DIAGNOSTIC|LEARNING_HIERARCHY|HISTORY_VERSION_CONTROL` returns zero hits outside archive/, DESIGN, SEQUENCE, and MIGRATION_GUIDE (which document the rename, not reference the old files). |
| AC-15 | `_genesis/frameworks/README.md` updated to reflect new file inventory | PASS | README lists 18 canonical files with correct kebab-case names (lines 21-38), plus archive/ entry. Total line matches DESIGN expectation. |
| AC-16 | APEI->ALPEI typo fixed in touched files (dsbv.md, CLAUDE.md) | PASS | dsbv.md: FIXED (APEI->ALPEI). CLAUDE.md: no APEI hits. `.claude/rules/memory-format.md`: FIXED in commit fc6e3b1. Only remaining APEI hit is `git-conventions.md` line 27 which correctly lists "APEI" as a forbidden scope name. |

## Notes

### AC-7 — DESIGN says "9 files" but baseline is 8

**Finding:** DESIGN Section 6 lists `alpei-template-usage.md` as a rule file, but this file does not exist on disk (before or after the build). The actual count is 8 files, unchanged. The intent (zero new files) is met. The DESIGN document has a minor inaccuracy in its file listing.

**Mitigation:** No action needed for the build. DESIGN v1.2 has a cosmetic error in its file listing.

## Sign-off Readiness

All 16 ACs pass. Commit discipline is excellent (R100 on all renames, content-free separation verified). Blueprint restructure meets all content criteria. Migration guide and frameworks README are complete. Ready for merge.
