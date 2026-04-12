---
version: "1.1"
status: draft
last_updated: 2026-04-12
work_stream: 4-EXECUTE
---

# Test Report — Template Release Management
## Test Run: 2026-04-12

| Test | Profile | AC | Command | Result | Notes |
|------|---------|-----|---------|--------|-------|
| T1 | Khang | AC-L4-05 | template-manifest.sh --classify | PARTIAL | `_genesis/scripts/wms-sync.sh` → `deprecated` (PASS). `.claude/commands/old-cmd.md` → `domain` (FAIL — lstrip BUG-C) |
| T2 | Dong | AC-L2-07 | template-manifest.sh --classify | PASS | `.claude/rules/dong-inflation-rules.md` → `domain` (local-only step 5 fires before template pattern step 6) |
| T3 | Dung | AC-L3-07 | template-sync.sh --detect-path | FAIL | PATH C returned instead of PATH B — REPO_ROOT resolves to template repo (script uses SCRIPT_DIR), not /tmp/test-dung |
| T4 | CamVan | AC-L3-08 | template-sync.sh --detect-path | PASS | PATH C returned (template repo has 1-ALIGN/ and .claude/rules/) |
| T5 | Bootstrap | AC-L3-10 | template-sync.sh --sync | PASS | "No checkpoint found." prompt fires; resolves v2.0.0 tag, writes checkpoint |
| T6 | BUG-A | AC-L2-07 | template-manifest.sh --classify | PASS | `.claude/rules/local-only-test.md` (untracked) → `domain` — step 5 fires before step 6 |
| T7 | BUG-B | AC-L3-05 | template-merge-engine.py section-merge | PASS | `## Architecture: Subsystems (full spec: ...)` heading preserved via startswith() prefix match |
| T8 | end-to-end | AC-L3-02 | template-diff.sh --from-sha 4fec175 --to-sha d1f99ab | PASS | 4fec175..d1f99ab, 6 files (git diff --name-only), total_changes=6 (output matches) |

## Aggregate: 6/8 PASS (T1 PARTIAL, T3 FAIL)

## Failed tests

### T1 — PARTIAL (BUG-C: lstrip dot-stripping)
- **AC:** AC-L4-05 — deprecated detection for `.claude/commands/**` pattern
- **Root cause:** `classify()` uses `fp = file_path.lstrip('./')` which strips ALL leading `.` and `/` chars. `.claude/commands/old-cmd.md` becomes `claude/commands/old-cmd.md` after lstrip, breaking the match against pattern `.claude/commands/**`.
- **Affected paths:** Any deprecated (or template/reserved) pattern starting with `.` — e.g. `.claude/`, `.github/`, `.gitleaks.toml`, `.mcp.json`.
- **Unaffected:** Paths without leading dot (`_genesis/scripts/**`, `scripts/**`) work correctly.
- **Evidence:** `_genesis/scripts/wms-sync.sh` → `deprecated` (PASS); `.claude/commands/old-cmd.md` → `domain` (incorrect).
- **Fix:** Replace `fp = file_path.lstrip('./')` with `fp = file_path.lstrip('/')` (or normalize only forward slashes, never strip dots).
- **Classification:** SYNTACTIC — algorithmic step ordering / string normalization defect.

### T3 — FAIL (test design: REPO_ROOT resolves to template repo)
- **AC:** AC-L3-07 — PATH B detection for pre-ALPEI repo
- **Root cause:** `template-sync.sh` resolves `REPO_ROOT` via `git -C "$SCRIPT_DIR" rev-parse --show-toplevel`, where `SCRIPT_DIR` is always the physical location of the script (template repo `scripts/`). When called as `bash /path/to/template/scripts/template-sync.sh --detect-path` from `/tmp/test-dung`, REPO_ROOT resolves to the TEMPLATE repo (which has `1-ALIGN/` and `.claude/rules/`) → PATH C.
- **Impact:** PATH B detection only works correctly when the script is executed from within the downstream repo (i.e., after copying the script there). The test as designed (calling the script from the template repo path) cannot simulate a downstream repo context.
- **Not a script bug:** The behavior is correct for installed usage. The test setup (cross-repo invocation) does not match the intended invocation pattern.
- **Workaround for test:** Copy `scripts/` into the test repo before running, or use `--repo-root` flag (not yet implemented).
- **Classification:** SEMANTIC — test design assumption mismatch (not a script defect per se, but AC coverage gap).

## Detailed Results

### T2 — Dong profile: BUG-A classification order
- File: `.claude/rules/dong-inflation-rules.md` (untracked, not in `git ls-tree HEAD`)
- Step 1 (reserved): no match (pattern `*.claude/rules/*-custom-*.md` — no `dong` prefix)
- Step 2 (deprecated): no match
- Step 3 (shared): no exact match
- Step 4 (domain-seed): no match
- Step 5 (local-only): file NOT in template_files_set → returns `domain` ✓
- Step 6 would have matched `.claude/rules/**` pattern → `template` (incorrectly)
- BUG-A fix confirmed working.

### T5 — Bootstrap mode
- `.template-checkpoint.yml` had `last_sync_sha: ""` (empty string)
- `do_sync()` read empty SHA → entered bootstrap branch
- Output: `"No checkpoint found. What template version was this repo originally cloned from?"`
- Tag `v2.0.0` resolved to SHA `b5935db706bc00dbc71aa8ca726b82497666bd8a` (template remote present)
- Checkpoint written with migration_path: "C"
- **Checkpoint was restored to empty state after test** (sync ran to completion; checkpoint reverted manually)
- Note: the test spec says to pipe `v2.0.0` to stdin — this worked. The `--sync v2.0.0` then ran a real sync (0 files changed, from→to same SHA), passed verify, and updated the checkpoint.

### T6 — BUG-A verify (template repo context)
- Created untracked `.claude/rules/local-only-test.md`
- `git ls-tree HEAD` does NOT include the file → step 5 fires → `domain`
- Confirmed BUG-A fix: step 5 (local-only) precedes step 6 (template patterns)
- File cleaned up after test.

### T7 — BUG-B verify
- `CLAUDE.md` heading: `## Architecture: Subsystems (full spec: \`_genesis/alpei-blueprint.md\` Part 4)`
- Manifest `template_owned` entry: `## Architecture: Subsystems` (no suffix)
- `classify_heading()` uses `heading.startswith(entry)` → matches correctly
- `grep -c "Architecture: Subsystems" /tmp/bug-b-test.md` → `1` ✓
- BUG-B fix confirmed working.

## Environment
- Template repo: `/Users/longnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE`
- Python: 3.x (PyYAML available)
- git: available
- jq: available
- Template remote: `template` (fetched, tag v2.0.0 resolves)
