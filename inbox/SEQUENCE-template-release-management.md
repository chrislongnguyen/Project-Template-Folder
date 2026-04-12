---
version: "1.1"
status: draft
last_updated: 2026-04-12
design_ref: inbox/DESIGN-template-release-management.md
---

# SEQUENCE.md — Template Release Management System

## Summary

| Field | Value |
|-------|-------|
| Total tasks | 18 |
| Total waves | 4 |
| Parallel opportunities | 10 tasks (T1.1/T1.3/T1.4 in W1; T2.1/T2.2/T2.3 in W2; T4.1/T4.2/T4.3/T4.4 in W4) |
| Critical path | Wave 1 → Wave 2 → Wave 3 → Wave 4 (sequential between waves) |
| Estimated sessions | ~10 |

---

## AC Coverage Map

| AC | Task | Wave |
|----|------|------|
| AC-L1-01 | T2.2 | 2 |
| AC-L1-02 | T2.2 | 2 |
| AC-L1-03 | T1.3 | 1 |
| AC-L1-04 | T2.2 | 2 |
| AC-L1-05 | T1.3 | 1 |
| AC-L1-06 | T2.2 | 2 |
| AC-L2-01 | T1.1 | 1 |
| AC-L2-02 | T1.1 | 1 |
| AC-L2-03 | T1.1 | 1 |
| AC-L2-04 | T1.2 | 1 |
| AC-L2-05 | T1.1 | 1 |
| AC-L2-06 | T1.1 | 1 |
| AC-L2-07 | T4.3 | 4 |
| AC-L3-01 | T2.1 | 2 |
| AC-L3-02 | T2.1 | 2 |
| AC-L3-03 | T1.4 | 1 |
| AC-L3-04 | T2.1 | 2 |
| AC-L3-05 | T2.3 | 2 |
| AC-L3-06 | T3.3 | 3 |
| AC-L3-07 | T4.3 | 4 |
| AC-L3-08 | T4.3 | 4 |
| AC-L3-09 | T3.2 | 3 |
| AC-L3-10 | T3.2 | 3 |
| AC-L4-01 | T3.4 | 3 |
| AC-L4-02 | T3.1 | 3 |
| AC-L4-03 | T3.2 | 3 |
| AC-L4-04 | T4.1 | 4 |
| AC-L4-05 | T4.3 | 4 |
| AC-L4-06 | T4.3 | 4 |
| AC-L4-07 | T4.3 | 4 |
| AC-L4-08 | T4.3 | 4 |
| AC-L4-09 | T3.4 | 3 |
| AC-L5-01 | T3.4 | 3 |
| AC-L5-02 | T3.4 | 3 |
| AC-L5-03 | T3.4 | 3 |
| AC-L5-04 | T3.4 | 3 |
| AC-L5-05 | T3.4 | 3 |
| AC-L5-06 | T3.4 | 3 |
| AC-L5-07 | T3.4 | 3 |
| AC-L6-01 | T4.1 | 4 |
| AC-L6-02 | T4.1 | 4 |
| AC-L6-03 | T4.1 | 4 |
| AC-L6-04 | T1.3 | 1 |
| AC-L6-05 | T4.2 | 4 |
| AC-L6-06 | T4.1 | 4 |

---

## Wave 1 — Foundation (~2 sessions)

### T1.1: Template Manifest YAML [independent]

**Artifact:** A1 — `_genesis/template-manifest.yml`
**ACs covered:** AC-L2-01, AC-L2-02, AC-L2-03, AC-L2-05, AC-L2-06
**Inputs:** DESIGN.md §3.2 manifest schema; current repo file tree (`git ls-files`); existing `template-check.sh` classification rules (lines 49-78) for baseline categories
**Acceptance:**
1. File is valid YAML (`python3 -c "import yaml; yaml.safe_load(open('_genesis/template-manifest.yml'))"` exits 0)
2. Every file in `git ls-tree -r template/main` appears in exactly one lineage section — coverage 100%, overlaps 0
3. `deprecated` section contains ≥1 entry with `removed_in_version` field
4. Every entry under `shared.entries` has a `merge_strategy` field
5. CLAUDE.md shared entry has `merge_sections` with `template_owned` (18 entries) and `user_owned` (1 entry: `## Project`) lists matching DESIGN.md §3.2

**Builder prompt hint:** Create the manifest YAML per the exact schema in DESIGN.md §3.2. Enumerate all template-tracked files by running `git ls-tree -r HEAD --name-only` and classify each into the three lineages. Use existing `template-check.sh` category logic as reference but apply the three-lineage taxonomy.

---

### T1.2: Manifest Script [depends on T1.1]

**Artifact:** A2 — `scripts/template-manifest.sh`
**ACs covered:** AC-L2-04
**Inputs:** A1 manifest YAML; DESIGN.md classify() pseudocode (§3.2)
**Acceptance:**
1. `bash scripts/template-manifest.sh --help` exits 0
2. `bash scripts/template-manifest.sh --audit` exits 0 AND outputs `coverage: 100%, overlaps: 0`
3. `bash scripts/template-manifest.sh --classify scripts/template-check.sh` outputs `template`
4. `bash scripts/template-manifest.sh --classify CLAUDE.md` outputs `shared`
5. `bash scripts/template-manifest.sh --classify 1-ALIGN/README.md` outputs `domain-seed`
6. Script is Bash 3 compatible (no associative arrays, no `|&`, no `${var,,}`)

**Builder prompt hint:** Build a Bash 3 script with three modes: `--audit` (verify manifest coverage/overlaps), `--classify <path>` (return lineage for one file), `--generate` (regenerate manifest from repo state). Implement the classify() step ordering exactly as in DESIGN.md §3.2 — reserved_domain_namespaces → deprecated → shared → domain_seed → local-only → template patterns → fallback. The local-only check (step 5) MUST precede the template pattern match (step 6).

---

### T1.3: Release Notes Template [independent]

**Artifact:** A9 — `_genesis/templates/release-notes-template.md`
**ACs covered:** AC-L1-03, AC-L1-05, AC-L6-04
**Inputs:** DESIGN.md L1-C3 requirements
**Acceptance:**
1. File exists at `_genesis/templates/release-notes-template.md`
2. YAML frontmatter includes `requires:` field
3. Contains all required sections: Version, Date, Requires, Summary, Breaking Changes, Added, Changed, Removed, Migration Steps
4. Frontmatter follows versioning.md conventions (`version: "1.0"`, `status: draft`, `last_updated`)

**Builder prompt hint:** Create a release notes template with YAML frontmatter including `requires:` for version chain enforcement. Include all 9 sections listed in AC-L1-03. Follow existing template conventions in `_genesis/templates/`.

---

### T1.4: Checkpoint Schema [independent]

**Artifact:** A3 — `.template-checkpoint.yml` (schema example shipped with template)
**ACs covered:** AC-L3-03
**Inputs:** DESIGN.md §3.3 checkpoint schema
**Acceptance:**
1. `.template-checkpoint.yml` exists at repo root with all required fields: `schema_version`, `last_sync_sha`, `last_sync_date`, `template_version`, `template_remote_url`, `migration_path`, `sync_history`
2. File is valid YAML
3. `schema_version` is `"1.0"`
4. `sync_history` is a YAML list structure (empty list `[]` acceptable for template copy)

**Builder prompt hint:** Create the checkpoint file per DESIGN.md §3.3 schema. This is the initial example that ships with the template repo — downstream repos will populate their own versions. Include inline YAML comments explaining each field. `last_sync_sha` and `last_sync_date` should be empty strings in the template copy.

---

## Wave 2 — Engine (~3 sessions)

### T2.1: Pristine Diff Script [depends on T1.1, T1.2]

**Artifact:** A4 — `scripts/template-diff.sh`
**ACs covered:** AC-L3-01, AC-L3-02, AC-L3-04
**Inputs:** DESIGN.md §3.3 pristine diff algorithm; A1 manifest; A2 manifest script
**Acceptance:**
1. `bash scripts/template-diff.sh --help` exits 0
2. Given 2 known commits with 3 changed files, outputs exactly 3 entries with correct change_type (added/modified/deleted)
3. Each output entry includes: path, change_type, lineage, strategy
4. Version chain: checkpoint at v1.2.0 + target v2.1.0 → exits 1 with skip-detection error
5. Script is Bash 3 compatible

**Builder prompt hint:** Implement the pristine_diff() algorithm from DESIGN.md §3.3. Uses `git diff-tree` or `git ls-tree` to compare two SHAs. Calls `template-manifest.sh --classify` for each changed file to determine lineage and merge strategy. Args: `--from-sha <sha>` and `--to-sha <sha>`. Include version chain validation that rejects non-sequential major version jumps.

---

### T2.2: Release Script [independent within Wave 2]

**Artifact:** A8 — `scripts/template-release.sh`
**ACs covered:** AC-L1-01, AC-L1-02, AC-L1-04, AC-L1-06
**Inputs:** DESIGN.md §3.1 Layer 1 spec; A9 release notes template
**Acceptance:**
1. `bash scripts/template-release.sh --help` exits 0
2. `--dry-run v2.1.0` exits 0, outputs planned tag + changelog skeleton + notes path, creates zero git objects
3. `--validate v2.1.0` checks: CHANGELOG entry exists, manifest updated, notes filled — exits 0 only if all pass
4. All existing git tags `v[0-9]*` have corresponding CHANGELOG.md entries (check logic runs correctly)
5. Script is Bash 3 compatible

**Builder prompt hint:** Build a release management script with three modes: `--dry-run <version>` (preview without side effects), `--tag <version>` (create git tag + generate notes from A9 template), `--validate <version>` (verify release completeness). Validate semver format. Checks CHANGELOG.md for corresponding entry.

---

### T2.3: Section-Merge and 3-Way Merge Engine [depends on T1.1]

**Artifact:** Part of A6 — merge engine (standalone module sourced by template-sync.sh)
**ACs covered:** AC-L3-05
**Inputs:** DESIGN.md §3.3 section-merge algorithm and 3-way merge spec; A1 manifest (for merge_sections config)
**Acceptance:**
1. Section-merge on CLAUDE.md preserves BOTH a new template section AND user `## Project` section verbatim
2. Section splitter does NOT split on `## Heading` lines inside fenced code blocks (fence_open guard)
3. Section classification uses `startswith()` prefix match — heading `## Architecture: Subsystems (full spec: ...)` matches manifest entry `## Architecture: Subsystems`
4. 3-way merge via `git merge-file` produces correct output for template-modified + user-unmodified shared file
5. 3-way merge on user-modified shared file produces merge markers (not silent overwrite)
6. Bash 3 compatible (Python 3 helper acceptable for section-merge parsing complexity)

**Builder prompt hint:** Implement the section_merge() algorithm from DESIGN.md §3.3. Critical correctness requirements: (1) fence_open guard for code blocks, (2) startswith() prefix matching (NOT equality) for heading classification. Build as a standalone script (`scripts/template-merge-engine.sh` or `.py`) that Wave 3 template-sync.sh will call. The 3-way merge wrapper calls `git merge-file base.tmp ours.tmp theirs.tmp`.

---

## Wave 3 — Integration (~3 sessions)

### T3.1: Template Check v3.0 [depends on T1.1, T1.2]

**Artifact:** A5 — `scripts/template-check.sh` (enhance v2.2 → v3.0)
**ACs covered:** AC-L4-02
**Inputs:** Existing `scripts/template-check.sh` v2.2; A1 manifest; A2 manifest script
**Acceptance:**
1. JSON output includes `lineage` field per file (values: `template`, `shared`, `domain-seed`, `domain`, `deprecated`)
2. Lineage values sourced from `template-manifest.sh --classify` calls
3. All existing v2.2 behavior preserved: 5-bucket classification, `--quiet` flag, bucket counts
4. `--help` exits 0
5. Script is Bash 3 compatible

**Builder prompt hint:** Additive enhancement of template-check.sh v2.2 → v3.0. For each file in output, call `template-manifest.sh --classify` and add a `lineage` field. Preserve ALL existing behavior — do not restructure. Bump version header comment to v3.0.

---

### T3.2: Template Sync v3.0 [depends on T1.1, T1.2, T1.4, T2.1, T2.3]

**Artifact:** A6 — `scripts/template-sync.sh` (enhance v2.1 → v3.0)
**ACs covered:** AC-L3-09, AC-L3-10, AC-L4-03
**Inputs:** Existing `scripts/template-sync.sh` v2.1; A1 manifest; A3 checkpoint; A4 pristine diff; T2.3 merge engine
**Acceptance:**
1. `--detect-path` outputs `PATH A`, `PATH B`, or `PATH C` per DESIGN.md §3.3 path detection logic
2. Bootstrap mode: repo with no `.template-checkpoint.yml` → prompts for initial template version → creates checkpoint → continues with diff
3. Checkpoint `.template-checkpoint.yml` updates ONLY after `template-verify.sh` exits 0
4. All v2.1 modes preserved: `--auto-add`, `--file/--action take|skip`, `--verify`
5. New `--sync <target-version>` mode: reads checkpoint → pristine diff → applies by lineage/strategy → verify → update checkpoint
6. Script is Bash 3 compatible

**Builder prompt hint:** Major enhancement of template-sync.sh v2.1 → v3.0. Add: (1) `--detect-path`, (2) `--bootstrap` / bootstrap mode in `--sync`, (3) `--sync <version>` full orchestration. Integrate with template-diff.sh, template-manifest.sh, and merge engine from T2.3. Critical constraint: checkpoint update AFTER verify, not before. Preserve all v2.1 modes.

---

### T3.3: Reverse-Clone Engine [depends on T3.2]

**Artifact:** Part of A6 — `--reverse-clone` mode in `scripts/template-sync.sh`
**ACs covered:** AC-L3-06
**Inputs:** DESIGN.md Path B spec; A6 sync v3.0
**Acceptance:**
1. `--reverse-clone` creates fresh template clone in a temp directory
2. Produces triage manifest: lists all domain files from source repo classified as keep/skip/merge
3. Does NOT modify the source repo (read-only on original)
4. Works when source repo has no `1-ALIGN/` directory
5. Triage manifest is valid YAML or structured text consumable by an AI agent

**Builder prompt hint:** Add `--reverse-clone <source-repo-path>` mode to template-sync.sh. Clones the template fresh, analyzes source repo file tree, produces a file-by-file triage list. The human/agent then manually copies domain content into the fresh clone. Read-only on source. Designed for pre-ALPEI repos with >30% divergence.

---

### T3.4: Verification Script [depends on T1.2, T3.1, T3.2]

**Artifact:** A7 — `scripts/template-verify.sh`
**ACs covered:** AC-L4-01, AC-L4-09, AC-L5-01, AC-L5-02, AC-L5-03, AC-L5-04, AC-L5-05, AC-L5-06, AC-L5-07
**Inputs:** DESIGN.md §3.5 verification spec; existing: `validate-blueprint.py`, `smoke-test.sh`, `link-validator.sh`, `orphan-detect.sh`
**Acceptance:**
1. `bash scripts/template-verify.sh --help` exits 0
2. Running on template repo: exits 0 (all 6 checks pass, `RESULT: 6/6`)
3. Broken hook path injected: exits 1 with `V2 FAIL`
4. Deprecated `.claude/commands/` present: exits 1 with `V5 FAIL`
5. Output: each check prints `V{N} PASS` or `V{N} FAIL: reason`. Final: `RESULT: N/6`
6. Exit codes: 0 = all pass, 1 = failures, 2 = script error
7. `--check V2` runs ONLY hook validation
8. Script is Bash 3 compatible
9. All 6 scripts exist AND `--help` exits 0: `template-manifest.sh`, `template-diff.sh`, `template-release.sh`, `template-check.sh`, `template-sync.sh`, `template-verify.sh` (satisfies AC-L4-01)
10. All 6 scripts are Bash 3 compatible — no associative arrays, no `|&`, no `${var,,}` (satisfies AC-L4-09)

**Builder prompt hint:** Unified 6-check sweep per DESIGN.md §3.5. V1=validate-blueprint.py, V2=hook path resolution + smoke-test.sh, V3=link-validator.sh + orphan-detect.sh, V4=agent/skill/rule count validation, V5=manifest coverage + deprecated file detection (calls template-manifest.sh), V6=template-sync --verify. Support `--check V{N}` selective mode and `--json` machine-readable output.

---

## Wave 4 — Adoption + Validation (~2 sessions)

### T4.1: Migration Guide v3.0 [depends on T3.2, T3.3, T3.4]

**Artifact:** A10 — `_genesis/guides/migration-guide.md`
**ACs covered:** AC-L4-04, AC-L6-01, AC-L6-02, AC-L6-03, AC-L6-06
**Inputs:** Existing migration-guide.md v2.1; all Wave 1-3 artifacts; DESIGN.md §3.6
**Acceptance:**
1. Mentions `template-manifest.yml` in Path B and Path C sections
2. Mentions `.template-checkpoint.yml` in Path C section
3. Mentions `template-diff.sh` in Path C section
4. An agent reading ONLY this guide can execute Path C without other documentation
5. All 10 migration principles (P1-P10) referenced
6. Version bumped to 3.0, frontmatter updated

**Builder prompt hint:** Rewrite migration-guide.md v2.1 → v3.0. Integrate new concepts: three-lineage classification, checkpoint-based sync, pristine diff, section-merge for CLAUDE.md, bootstrap mode. Path C is the primary path — self-contained agent-executable walkthrough. v2.1's 3 known bugs are now superseded by this rewrite.

---

### T4.2: Script Registry + CLAUDE.md Updates [independent in Wave 4]

**Artifact:** A11 — `.claude/rules/script-registry.md` + `CLAUDE.md`
**ACs covered:** AC-L6-05
**Inputs:** All new/enhanced scripts from Waves 1-3; current `script-registry.md`; current `CLAUDE.md`
**Acceptance:**
1. `script-registry.md` lists all 4 new scripts: `template-manifest.sh`, `template-diff.sh`, `template-verify.sh`, `template-release.sh`
2. Each entry has: script name, when to use, what it does (matches existing registry format)
3. Cross-reference table: `/template-sync` and `/template-check` skills reference new scripts
4. Script count in registry header updated
5. CLAUDE.md "Build and Validate" section updated with new script count if changed

**Builder prompt hint:** Update script-registry.md to add the 4 new scripts in appropriate domain groups (Migration & Verification group). Update the cross-reference table for `/template-sync` and `/template-check`. Update the total script count in the registry header. Update CLAUDE.md if the script count reference there changed.

---

### T4.3: Per-Profile Validation Tests [depends on T3.2, T3.3, T3.4]

**Artifact:** Test fixtures + results (documented in VALIDATE.md at validation stage)
**ACs covered:** AC-L2-07, AC-L3-07, AC-L3-08, AC-L4-05, AC-L4-06, AC-L4-07, AC-L4-08
**Inputs:** All Wave 1-3 artifacts; DESIGN.md per-profile table (§3.4)
**Acceptance:**
1. **Khang test:** Deprecated detection flags `.claude/commands/`, nested skills, `_genesis/scripts/` in simulated Khang-profile repo
2. **Dong test:** Full sync does NOT delete any file not in manifest; 19 custom rules in `.claude/rules/` preserved (classify() step-ordering fix verified)
3. **Dung test:** Path detector outputs `PATH B` for repo with no `1-ALIGN/`; reverse-clone lists ≥250 classified files
4. **CamVan test:** Path detector outputs `PATH C`; Path C produces changeset of only template-changed files
5. **Bootstrap test:** Repo with no `.template-checkpoint.yml` → bootstrap prompt fires → checkpoint created → diff proceeds
6. **BUG-A verify:** classify() step test — user file matching `.claude/rules/*.md` but absent from template remote → classified as `domain`, NOT `template`
7. **BUG-B verify:** section-merge prefix test — heading `## Architecture: Subsystems (full spec: ...)` matches manifest entry `## Architecture: Subsystems` via startswith()

**Builder prompt hint:** Create minimal test fixtures (temp git repos with controlled file sets) simulating each of the 4 PM profiles. Run relevant sync commands against each. Each test must be deterministic and produce pass/fail output. All 7 acceptance criteria above are discrete binary tests. Document results as a test report.

---

### T4.4: Skill Enhancements [independent in Wave 4]

**Artifact:** Enhanced SKILL.md files for `/template-sync` and `/template-check`
**ACs covered:** (supports skill discoverability — no dedicated AC but validates L6 adoption layer)
**Inputs:** Enhanced scripts from Waves 1-3; existing skill SKILL.md files
**Acceptance:**
1. `/template-sync` SKILL.md documents new modes: `--sync`, `--detect-path`, `--bootstrap`, `--reverse-clone`
2. `/template-check` SKILL.md documents lineage-aware output
3. Both skills reference `template-verify.sh` as post-sync step
4. `bash scripts/skill-validator.sh .claude/skills/template-sync/` exits 0
5. `bash scripts/skill-validator.sh .claude/skills/template-check/` exits 0

**Builder prompt hint:** Update SKILL.md files for `/template-sync` and `/template-check`. Add new mode documentation, update example invocations, reference new scripts. Run skill-validator.sh to confirm structure compliance.

---

## Dependency Graph

```
WAVE 1 — Foundation (~2 sessions)
┌──────────────────────────────────────────────────────┐
│                                                      │
│  T1.1 Manifest YAML [independent] ──────────────┐   │
│  T1.3 Release Notes Template [independent]       │   │
│  T1.4 Checkpoint Schema [independent]            │   │
│                                                  ▼   │
│                            T1.2 Manifest Script      │
│                            [depends on T1.1]         │
│                                                      │
└──────────────────────────────┬───────────────────────┘
                               │ ALL Wave 1 complete
                               ▼
WAVE 2 — Engine (~3 sessions)
┌──────────────────────────────────────────────────────┐
│                                                      │
│  T2.1 Pristine Diff [depends on T1.1, T1.2]          │
│  T2.2 Release Script [independent in Wave 2]         │
│  T2.3 Merge Engine [depends on T1.1]                 │
│                                                      │
└──────────────────────────────┬───────────────────────┘
                               │ ALL Wave 2 complete
                               ▼
WAVE 3 — Integration (~3 sessions)
┌──────────────────────────────────────────────────────┐
│                                                      │
│  T3.1 Check v3.0 [depends on T1.1, T1.2]             │
│  T3.2 Sync v3.0  [depends on T1.1, T1.2, T1.4,      │
│                              T2.1, T2.3]             │
│         │                                            │
│         ▼                                            │
│  T3.3 Reverse-Clone [depends on T3.2]                │
│  T3.4 Verify Script [depends on T1.2, T3.1, T3.2]   │
│                                                      │
└──────────────────────────────┬───────────────────────┘
                               │ ALL Wave 3 complete
                               ▼
WAVE 4 — Adoption + Validation (~2 sessions)
┌──────────────────────────────────────────────────────┐
│                                                      │
│  T4.1 Migration Guide v3.0 [parallel]                │
│  T4.2 Registry + CLAUDE.md  [parallel]               │
│  T4.3 Per-Profile Tests     [parallel]               │
│  T4.4 Skill Enhancements    [parallel]               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Approval Log

| Date | Gate | Decision | Signal | Tier |
|------|------|----------|--------|------|
| 2026-04-12 | G2-Sequence | APPROVED | "Proceed to do all Step 1 2 3 above thoroughly" | T1 |

> Only humans write to this table.

## Links

- [[DESIGN]]
- [[VALIDATE]]
- [[migration-guide]]
- [[script-registry]]
- [[template-check]]
- [[template-sync]]
