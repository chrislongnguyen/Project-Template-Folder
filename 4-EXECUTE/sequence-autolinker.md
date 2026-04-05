---
version: "1.0"
status: draft
last_updated: 2026-03-31
owner: Long Nguyen
workstream: "EXECUTE workstream"
feature: "Obsidian Auto-Linker (Self-Discovering Wikilink System)"
---
# SEQUENCE workstream: Obsidian Auto-Linker

> Build order for design-autolinker.md artifacts A1-A5. Each task must pass its ACs before the next begins.
> Agent: ltc-builder (Sonnet). Validator: ltc-reviewer (Opus).

---

## Dependency Graph

```
A2 (Alias seeder)
  └── A1 (Auto-linker script)   ← needs alias targets to exist
        └── A4 (Test suite)      ← tests A1+A2 behavior
              └── A3 (Pre-commit hook)   ← wraps A1; tests must pass first
                    └── A5 (Documentation)   ← documents all of the above
```

---

## Task List

| # | Task | Artifact | Path | Size | Token Est. | Input | ACs from DESIGN |
|---|------|----------|------|------|------------|-------|--------------------|
| T1 | Write alias seeder script | A2 | `scripts/obsidian-alias-seeder.py` | S (20 min) | ~2K | DESIGN §Phase 1 step 1, existing .md frontmatter patterns | AC-5, AC-6, AC-7 |
| T2 | Write auto-linker script | A1 | `scripts/obsidian-autolinker.py` | L (60 min) | ~5K | DESIGN §Phase 1-3 architecture, A2 output (aliases exist) | AC-1, AC-2, AC-3, AC-4 |
| T3 | Write test suite | A4 | `tests/test_autolinker.py` | M (40 min) | ~3K | A1 + A2 scripts, DESIGN §risk register (edge cases) | AC-12, AC-13, AC-14 |
| T4 | Write pre-commit hook | A3 | `hooks/obsidian-autolink-hook.sh` | S (20 min) | ~2K | A1 script, DESIGN §Pre-Commit Hook Flow | AC-8, AC-9, AC-10, AC-11 |
| T5 | Write linker documentation | A5 | `4-EXECUTE/docs/AUTOLINKER_README.md` | S (20 min) | ~2K | A1, A2, A3 completed artifacts | AC-15, AC-16 |

**Total estimate:** ~14K tokens, ~2.5 hours human-equivalent

---

## Task Detail

### T1 — Write Alias Seeder Script

**Input:** design-autolinker.md §Phase 1 step 1, existing repo .md files with frontmatter
**What to produce:**
- `scripts/obsidian-alias-seeder.py` — scans repo for target files (ADRs, registers, frameworks), adds `aliases:` to their YAML frontmatter
- `--dry-run` mode that reports without modifying
- Preserves all existing frontmatter fields — only adds/updates `aliases:`
- Alias derivation: ADR filename → `ADR-NNN`, register files → short name, framework docs → acronym

**Binary test:**
```bash
python3 scripts/obsidian-alias-seeder.py --dry-run && echo PASS || echo FAIL
python3 scripts/obsidian-alias-seeder.py && test $(grep -r "^aliases:" --include="*.md" | wc -l) -ge 30 && echo PASS || echo FAIL
```

---

### T2 — Write Auto-Linker Script

**Input:** design-autolinker.md §Phase 1-3 (DISCOVER → SCAN → WRITE), A2 alias seeder output
**What to produce:**
- `scripts/obsidian-autolinker.py` — 3-phase engine:
  - Phase 1 DISCOVER: build target_map from aliases + filenames + content IDs + framework names
  - Phase 2 SCAN: match sources against target_map with word-boundary regex, dedup, exclude self-refs
  - Phase 3 WRITE: append/replace `## Links` sections
- `--dry-run` mode reporting targets discovered + links proposed
- Idempotent: running twice = identical output
- No self-references in any `## Links` section

**Binary test:**
```bash
python3 scripts/obsidian-autolinker.py --dry-run && echo PASS || echo FAIL
python3 scripts/obsidian-autolinker.py && echo PASS || echo FAIL
# Idempotency
python3 scripts/obsidian-autolinker.py
find . -name "*.md" -not -path "./.git/*" -exec md5 {} \; > /tmp/run1.md5
python3 scripts/obsidian-autolinker.py
find . -name "*.md" -not -path "./.git/*" -exec md5 {} \; > /tmp/run2.md5
diff /tmp/run1.md5 /tmp/run2.md5 && echo IDEMPOTENT || echo DRIFT
```

---

### T3 — Write Test Suite

**Input:** A1 + A2 scripts (importable modules), DESIGN §risk register edge cases
**What to produce:**
- `tests/test_autolinker.py` with pytest
- Test cases covering all 6 categories from AC-13:
  1. T1 artifact ID linking (`ADR-002` → `[[ADR-002]]`)
  2. T2 file path linking (backtick path → wikilink)
  3. T3 framework name linking (`DSBV` → `[[DSBV Process]]`)
  4. Idempotency (run twice, same output)
  5. Self-reference exclusion (file never links to itself)
  6. `## Links` placement (always last section)
- All fixtures use synthetic .md files in a temp directory — no repo files

**Binary test:**
```bash
python3 -m pytest tests/test_autolinker.py -v && echo PASS || echo FAIL
```

---

### T4 — Write Pre-Commit Hook

**Input:** A1 auto-linker script, DESIGN §Pre-Commit Hook Flow diagram
**What to produce:**
- `hooks/obsidian-autolink-hook.sh` — shell script
- Lists staged .md files via `git diff --cached --name-only --diff-filter=ACM`
- Runs Phase 1 (DISCOVER) on full repo, Phase 2-3 on staged files only
- Re-stages modified files with `git add`
- Exits 0 when no .md files staged (no-op)
- Shebanged, executable

**Binary test:**
```bash
test -f hooks/obsidian-autolink-hook.sh && echo EXISTS || echo MISSING
test -x hooks/obsidian-autolink-hook.sh && echo EXECUTABLE || echo NOT-EXECUTABLE
```

---

### T5 — Write Linker Documentation

**Input:** A1, A2, A3 completed artifacts
**What to produce:**
- `4-EXECUTE/docs/AUTOLINKER_README.md` covering:
  1. What it does (3-phase engine summary)
  2. How to run one-shot (`python3 scripts/obsidian-alias-seeder.py && python3 scripts/obsidian-autolinker.py`)
  3. How the pre-commit hook works + installation
  4. How to add custom aliases (edit frontmatter `aliases:` field)
  5. How to exclude files (CLI flag or future `.autolinkerignore`)
- Template-portable language ("your project", "after cloning")

**Binary test:**
```bash
test -f 4-EXECUTE/docs/AUTOLINKER_README.md && echo EXISTS || echo MISSING
grep -qi "clone\|template\|your project" 4-EXECUTE/docs/AUTOLINKER_README.md && echo PORTABLE || echo FAIL
```

---

## Checkpoints

| After | Checkpoint | Action |
|-------|------------|--------|
| T1 | Alias seeder --dry-run exits 0, >= 30 aliases reported | Commit: `feat(execute): obsidian alias seeder script` |
| T2 | Auto-linker --dry-run exits 0, idempotent, no self-refs | Commit: `feat(execute): obsidian auto-linker 3-phase engine` |
| T3 | pytest exits 0, all 6 test categories covered | Commit: `feat(execute): auto-linker test suite` |
| T4 | Hook exists, executable, no-op on non-.md staging | Commit: `feat(execute): obsidian auto-link pre-commit hook` |
| T5 | README exists with template-portable language | Commit: `feat(execute): auto-linker documentation` |

## Links

- [[ADR-002]]
- [[DESIGN]]
- [[design-autolinker]]
- [[README]]
- [[SEQUENCE]]
- [[documentation]]
- [[dsbv]]
- [[ltc-builder]]
- [[ltc-reviewer]]
- [[project]]
- [[task]]
- [[workstream]]