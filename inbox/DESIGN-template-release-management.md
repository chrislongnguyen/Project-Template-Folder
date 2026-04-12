---
version: "1.1"
status: validated
last_updated: 2026-04-12
owner: "ltc-planner"
stage: design
---

# DESIGN.md — Template Release Management System

> DSBV stage 1 artifact. This document is the contract. If it is not here, it is not in scope.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Are upstream workstream outputs sufficient? | YES — template-check.sh v2.2, template-sync.sh v2.1, migration-guide.md v2.1 exist and are tested. 4 real user migrations provide empirical data. Explorer research (26 sources) complete. |
| Q2: What is in scope? | Complete 6-layer release management system: release process, file ownership, distribution engine, migration tooling, verification, adoption. All scripts, manifests, algorithms, specs. |
| Q2b: What is explicitly OUT of scope? | (a) GitHub Actions CI/CD pipeline (deferred to when GitHub Actions is adopted). (b) GUI/TUI interactive merge tool. (c) Auto-push to downstream repos (always pull-based). (d) Monorepo consolidation. (e) Template branching strategy (template is single-branch main). |
| Q3: Go/No-Go | GO |

---

## Iteration/Version Context

| Field | Value |
|-------|-------|
| Current iteration | Iteration 1 (concept) |
| UES version ceiling | v1.x — correct + safe only |
| Scope boundary | This iteration produces the complete architecture, all scripts, manifest schema, and migration paths. No deferral. |
| Version convention | New file in Iteration 1 = `version: "1.0"`. Bump minor on each committed edit. |

---

## 1. System Overview

### 1.1 Effective Outcome (EO)

Enable any LTC PM (or their AI agent) to safely, correctly, and deterministically sync their project repo with the canonical template at any divergence level — from zero (fresh clone) to severe (pre-ALPEI, 1500+ files, custom hooks) — without losing domain content, breaking agent infrastructure, or requiring heroic manual intervention.

### 1.2 Seven-Component System (7-CS) Map

```
┌─────────────────────────────────────────────────────────────────────┐
│                    TEMPLATE RELEASE MANAGEMENT                      │
│                                                                     │
│  EP (Principles)          10 Migration Principles (P1-P10)          │
│                           + S > E > Sc priority                     │
│                           + Three-lineage classification            │
│                                                                     │
│  EI (Input)               Template repo state (tags, commits)       │
│                           Downstream repo state (files, versions)   │
│                           template-manifest.yml (file ownership)    │
│                           .template-checkpoint.yml (sync state)     │
│                                                                     │
│  EA (Action)              6-layer process execution:                 │
│                           L1 Release → L2 Classify → L3 Diff/Merge  │
│                           → L4 Migrate → L5 Verify → L6 Adopt       │
│                                                                     │
│  EO (Output)              Downstream repo at target template version │
│                           Zero domain content loss                   │
│                           All structural/agent checks pass           │
│                                                                     │
│  EOE (Environment)        Git (remotes, tags, branches, worktrees)   │
│                           macOS + Bash 3 compat                      │
│                           jq, python3, git dependencies              │
│                                                                     │
│  EOT (Tools)              template-check.sh (categorize)             │
│                           template-sync.sh (apply)                   │
│                           template-manifest.sh (classify ownership)  │
│                           template-release.sh (tag + notes)          │
│                           template-verify.sh (unified sweep)         │
│                           template-diff.sh (pristine diff engine)    │
│                                                                     │
│  EOP (Procedures)         migration-guide.md (3 paths)               │
│                           release-checklist.md (release SOP)         │
│                           /template-sync skill (agent entry point)   │
│                           /template-check skill (agent entry point)  │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.3 Architecture Diagram — 6-Layer Stack

```
 TEMPLATE REPO (canonical)              DOWNSTREAM REPO (project)
 ═══════════════════════════            ═══════════════════════════
 ┌───────────────────────┐              ┌───────────────────────┐
 │   Tagged Releases     │              │   Project Content     │
 │   v2.0.0 → v2.1.0    │              │   (domain + template  │
 │                       │              │    + inherited files)  │
 │   _genesis/           │              │                       │
 │   template-manifest   │              │   .template-checkpoint│
 │   .yml                │              │   .yml                │
 │                       │              │                       │
 │   CHANGELOG.md        │              │   migration branch    │
 │   release notes       │              │   backup tag          │
 └───────┬───────────────┘              └───────┬───────────────┘
         │                                      │
         │ L1: RELEASE PROCESS                  │
         │ (tag, changelog, notes)              │
         ▼                                      │
 ┌───────────────────────┐                      │
 │ L2: FILE OWNERSHIP    │                      │
 │ template-manifest.yml │◄─────────────────────┤
 │ three-lineage class.  │  consumed by L3      │
 └───────┬───────────────┘                      │
         │                                      │
         ▼                                      ▼
 ┌──────────────────────────────────────────────────────┐
 │ L3: DISTRIBUTION ENGINE                              │
 │                                                      │
 │  ┌──────────┐   ┌──────────┐   ┌──────────────────┐ │
 │  │Checkpoint│──▶│ Pristine │──▶│ 3-Way Merge      │ │
 │  │ Reader   │   │ Diff     │   │ (template-only   │ │
 │  │          │   │ Engine   │   │  changes applied  │ │
 │  └──────────┘   └──────────┘   │  to user files)  │ │
 │                                └──────────────────┘ │
 │                                                      │
 │  Path A: Fresh Clone (trivial — gh repo create)      │
 │  Path B: Reverse Clone (divergence > 30%)            │
 │  Path C: Version Upgrade (incremental, checkpoint)   │
 └──────────────────────────┬───────────────────────────┘
                            │
                            ▼
 ┌──────────────────────────────────────────────────────┐
 │ L4: MIGRATION TOOLING                                │
 │                                                      │
 │  template-check.sh  → categorize (5 buckets)         │
 │  template-sync.sh   → apply (auto-add, take/skip)    │
 │  template-diff.sh   → pristine diff computation      │
 │  template-manifest.sh → classify file ownership       │
 │  migration-guide.md → 3-path SOP                     │
 └──────────────────────────┬───────────────────────────┘
                            │
                            ▼
 ┌──────────────────────────────────────────────────────┐
 │ L5: VERIFICATION SWEEP                               │
 │                                                      │
 │  template-verify.sh (unified entry point)            │
 │  ├── V1: structural (validate-blueprint.py)          │
 │  ├── V2: hooks (smoke-test.sh)                       │
 │  ├── V3: graph (link-validator.sh, orphan-detect.sh) │
 │  ├── V4: agent (/dsbv status)                        │
 │  ├── V5: ownership (manifest compliance)             │
 │  └── V6: sync completeness (template-sync --verify)  │
 │                                                      │
 │  Exit codes: 0 = all pass, 1 = failures, 2 = error   │
 └──────────────────────────┬───────────────────────────┘
                            │
                            ▼
 ┌──────────────────────────────────────────────────────┐
 │ L6: ADOPTION & SUPPORT                               │
 │                                                      │
 │  migration-guide.md (3 paths, 10 principles)         │
 │  release-notes-template.md (per-version)             │
 │  /template-sync skill (agent entry point)            │
 │  /template-check skill (agent entry point)           │
 └──────────────────────────────────────────────────────┘
```

### 1.4 Data Flow — End-to-End Sync

```
PM says: "sync my repo with template v2.1.0"
  │
  ▼
[1] Read .template-checkpoint.yml
    → IF exists AND last_sync_sha non-empty: proceed to [2] (incremental sync)
    → IF missing OR last_sync_sha empty: BOOTSTRAP MODE
         → Prompt user: "No checkpoint found. What template version was
           this repo originally cloned from? (e.g., v2.0.0)"
         → Write initial .template-checkpoint.yml with user-provided
           version SHA + current date
         → Re-enter flow from [2] with user-specified SHA as last_sync_sha
  │
  ▼
[2] Fetch template remote, resolve target tag
    → target_sha: def456 (template/main or tag v2.1.0)
  │
  ▼
[3] Compute pristine diff: template@abc123 vs template@def456
    → list of template-only changes (added, modified, deleted)
  │
  ▼
[4] Load template-manifest.yml
    → classify each changed file: template | shared | domain-seed
  │
  ▼
[5] For each changed file, apply merge strategy:
    ┌─────────────────────────────────────────────────┐
    │ Lineage     │ User Modified? │ Strategy          │
    │─────────────│────────────────│───────────────────│
    │ template    │ no             │ auto-take          │
    │ template    │ yes            │ CONFLICT — manual  │
    │ shared      │ no             │ auto-take          │
    │ shared      │ yes            │ 3-way merge        │
    │ domain-seed │ any            │ skip (user owns)   │
    └─────────────────────────────────────────────────┘
  │
  ▼
[6] Apply changes (template-sync.sh)
    → all changes unstaged, logged to .template-sync-log.json
  │
  ▼
[7] Run template-verify.sh (6-check sweep)
    → PASS: proceed to commit
    → FAIL: report failures, block commit
  │
  ▼
[8] Update .template-checkpoint.yml
    → last_sync_sha: def456
  │
  ▼
[9] Commit, PR, merge
```

---

## 2. Force Analysis

### 2.1 UBS Register — User Blocking Situations

| ID | Severity | UBS | Root Cause | Mitigation (Layer) |
|----|----------|-----|------------|---------------------|
| UBS-01 | CRITICAL | Domain content overwritten during sync | No file ownership classification | L2: template-manifest.yml with three-lineage classification |
| UBS-02 | CRITICAL | No checkpoint — cannot compute template-only changes | No structured sync state metadata | L3: .template-checkpoint.yml + pristine diff engine |
| UBS-03 | HIGH | Pre-ALPEI repos cannot use incremental sync | Path C assumes ALPEI structure exists | L4: Path B reverse-clone with auto-detection |
| UBS-04 | HIGH | Sync produces broken agent infrastructure | Hook paths go stale after template renames | L5: V2 hook path validation in unified sweep |
| UBS-05 | HIGH | Ambiguous merge strategy for shared files | CLAUDE.md, settings.json have both template + domain content | L2: Per-file merge_strategy in manifest |
| UBS-06 | MEDIUM | Knowledge graph breaks during migration | Wikilinks reference renamed/moved files | L5: V3 graph integrity check |
| UBS-07 | MEDIUM | No rollback path after failed sync | Checkpoint updates before verification | L3: Checkpoint updates ONLY after verify passes |
| UBS-08 | MEDIUM | Version-to-version migration skipping | No enforcement of sequential upgrades | L1: Version chain + L3: chain validator |
| UBS-09 | LOW | Inherited files persist indefinitely | No deprecated file detection | L2: Deprecated files list in manifest |
| UBS-10 | LOW | No release cadence or communication | Ad-hoc releases, silent accumulation | L1: Monthly cadence + L6: release notes |

### 2.2 UDS Register — User Driving Situations

| ID | Leverage | UDS | Enablement (Layer) |
|----|----------|-----|---------------------|
| UDS-01 | HIGH | AI agent executes entire migration | L4: Agent-executable guide + manifest-informed decisions |
| UDS-02 | HIGH | Pristine diff eliminates false positives | L3: Template@old vs template@new = template-only changes |
| UDS-03 | HIGH | Three-lineage prevents category errors | L2: template-manifest.yml single source of truth |
| UDS-04 | MEDIUM | Checkpoint enables incremental sync | L3: .template-checkpoint.yml with SHA + history |
| UDS-05 | MEDIUM | Unified verification catches all regressions | L5: 6 orthogonal checks, single exit code |
| UDS-06 | MEDIUM | Reverse-clone handles extreme divergence | L4: Path B for >30% divergent repos |
| UDS-07 | LOW | Release cadence creates predictable windows | L1: Monthly releases with per-version notes |
| UDS-08 | LOW | Existing tooling provides solid foundation | L4: Extend template-check v2.2 + template-sync v2.1 |

---

## 3. Six-Layer Specification

### 3.1 Layer 1 — Release Process

**Purpose:** Define how template releases are versioned, tagged, documented, and communicated.

| # | Component | Description | Status |
|---|-----------|-------------|--------|
| L1-C1 | Semantic version tags | Git tags: `v{MAJOR}.{MINOR}.{PATCH}` | To build |
| L1-C2 | CHANGELOG.md entries | Per-release with tier tags | Exists (extend) |
| L1-C3 | Release notes template | `_genesis/templates/release-notes-template.md` | To build |
| L1-C4 | template-release.sh | Validates, tags, generates notes skeleton | To build |
| L1-C5 | Release cadence | Monthly minor, quarterly major, hotfix on-demand | To build (process) |
| L1-C6 | Version chain enforcement | Each release declares `requires: vX.Y.Z` minimum | To build |

**ACs:**

| AC | Description |
|----|-------------|
| AC-L1-01 | `scripts/template-release.sh` exists AND `--help` exits 0 |
| AC-L1-02 | `--dry-run v2.1.0` exits 0, outputs tag + changelog skeleton + notes path without creating git objects |
| AC-L1-03 | `_genesis/templates/release-notes-template.md` contains: Version, Date, Requires, Summary, Breaking Changes, Added, Changed, Removed, Migration Steps |
| AC-L1-04 | Every git tag `v[0-9]*` has a corresponding CHANGELOG.md entry |
| AC-L1-05 | Release notes template has `requires:` field in YAML frontmatter |
| AC-L1-06 | `--validate v2.1.0` checks CHANGELOG entry + manifest updated + tests pass — exits 0 only if all pass |

---

### 3.2 Layer 2 — File Ownership

**Purpose:** Classify every template-tracked file into exactly one lineage so the distribution engine applies the correct merge strategy.

**Three-Lineage Taxonomy:**

```
LINEAGE        DEFINITION                          MERGE STRATEGY       EXAMPLES
─────────────────────────────────────────────────────────────────────────────────
template       Owned by template. User should       auto-take (untouched) scripts/*.sh
               NOT edit. Template is authoritative.  conflict (if edited)  .claude/rules/*.md

shared         Template structure + domain content.  3-way merge or        CLAUDE.md
               Both sides legitimately edit.         section-merge         .claude/settings.json

domain-seed    Template provides scaffold.           skip (never modify)   1-ALIGN/**/README.md
               User replaces with real content.                            PERSONAL-KNOWLEDGE-BASE/
```

**Manifest Schema:** `_genesis/template-manifest.yml`

```yaml
schema_version: "1.0"
template_version: "2.1.0"
generated_date: "2026-04-12"

files:
  template:
    patterns:
      - path: "scripts/*.sh"
        description: "Template scripts"
      - path: ".claude/rules/*.md"
      - path: ".claude/agents/*.md"
      - path: ".claude/hooks/**"
      - path: "_genesis/**"
      - path: "rules/*.md"
    explicit:
      - path: "AGENTS.md"
      - path: "GEMINI.md"

  shared:
    entries:
      - path: "CLAUDE.md"
        merge_strategy: "section-merge"
        merge_sections:
          template_owned:
            - "## Build and Validate"
            - "## Rules"
            - "## Knowledge Graph"
            - "## Architecture: 5x4x4 Matrix"
            - "## Architecture: Subsystems"
            - "## Architecture: PKB"
            - "## Effective Principles"
            - "## Brand Identity"
            - "## Naming"
            - "## Security"
            - "## Agent System"
            - "## Filesystem Routing"
            - "## DSBV Process"
            - "## Enforcement and Scripts"
            - "## Pre-Flight Protocol"
            - "## Rules Architecture"
            - "## Self-Update Rule"
            - "## Links"
          user_owned:
            - "## Project"
      - path: ".claude/settings.json"
        merge_strategy: "3-way-merge"
      - path: ".gitignore"
        merge_strategy: "3-way-merge"
      - path: "VERSION"
        merge_strategy: "auto-take"

  domain_seed:
    patterns:
      - path: "[1-5]-*/README.md"
      - path: "[1-5]-*/**/.gitkeep"
      - path: "PERSONAL-KNOWLEDGE-BASE/**"
      - path: "DAILY-NOTES/**"
      - path: "inbox/**"

deprecated:
  - pattern: ".claude/commands/**"
    removed_in_version: "2.0.0"
    action: "Delete directory"
  - pattern: "_genesis/scripts/**"
    removed_in_version: "2.0.0"
  - pattern: "_shared/**"
    removed_in_version: "2.0.0"
  - pattern: "0-GOVERN/**"
    removed_in_version: "2.0.0"
  - pattern: "plugins/memory-vault/**"
    removed_in_version: "2.0.0"
  - pattern: "hooks/**"
    removed_in_version: "2.0.0"

reserved_domain_namespaces:
  - "scripts/project-custom-*.sh"
  - ".claude/rules/*-custom-*.md"
  - ".claude/skills/project-*/**"
```

**Classification Logic:**

```
classify(file_path):
  1. reserved_domain_namespaces match → DOMAIN
  2. deprecated match → DEPRECATED
  3. shared.entries match → SHARED
  4. domain_seed.patterns match → DOMAIN-SEED
  5. Local-only (not in template remote) → DOMAIN (user-created)
  6. template.patterns/explicit match → TEMPLATE
  7. In template remote but not in manifest → TEMPLATE (fallback)

  # Step 5 note: "Local-only" is evaluated by checking whether the file exists
  # in the template remote at checkpoint.last_sync_sha (or at template HEAD for
  # first sync). A file matching a template pattern but absent from the template
  # remote is user-created → DOMAIN.
```

**ACs:**

| AC | Description |
|----|-------------|
| AC-L2-01 | `_genesis/template-manifest.yml` exists AND is valid YAML |
| AC-L2-02 | Every template-tracked file appears in exactly one manifest entry (coverage 100%) |
| AC-L2-03 | No file in more than one lineage (overlaps: 0) |
| AC-L2-04 | `scripts/template-manifest.sh --audit` exits 0, outputs "coverage: 100%, overlaps: 0" |
| AC-L2-05 | Manifest has `deprecated` section with >=1 entry including `removed_in_version` |
| AC-L2-06 | Every `shared` file has a `merge_strategy` field |
| AC-L2-07 | **Dong test:** sync simulation does NOT delete Dong's 19 custom rules (untracked by manifest = domain) |

---

### 3.3 Layer 3 — Distribution Engine

**Purpose:** Compute minimal correct changeset between template versions, apply using lineage-appropriate merge strategy.

**Checkpoint Schema:** `.template-checkpoint.yml`

```yaml
schema_version: "1.0"
last_sync_sha: "abc123def456"
last_sync_date: "2026-04-12"
template_version: "2.1.0"
template_remote_url: "https://github.com/.../OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git"
migration_path: "C"
sync_history:
  - sha: "prev123"
    version: "2.0.0"
    date: "2026-03-15"
```

**Pristine Diff Algorithm (pseudocode):**

```
FUNCTION pristine_diff(from_sha, to_sha, manifest):
  old_tree = git_ls_tree(from_sha)
  new_tree = git_ls_tree(to_sha)

  added    = new_tree - old_tree
  deleted  = old_tree - new_tree
  modified = {f for f in both if sha differs}

  FOR each changed file:
    lineage = classify(file, manifest)
    IF lineage == "domain-seed" OR "domain": strategy = "skip"
    IF lineage == "template" AND user_not_modified: strategy = "auto-take"
    IF lineage == "template" AND user_modified: strategy = "conflict"
    IF lineage == "shared": strategy = manifest.merge_strategy
    IF lineage == "deprecated": strategy = "flag-deprecated"

  RETURN changeset with {path, change_type, lineage, strategy}

FUNCTION check_user_modified(file):
  template_at_last_sync = git_show(checkpoint.last_sync_sha, file)
  user_current = read_file(file)
  RETURN template_at_last_sync != user_current
```

**3-Way Merge:** `git merge-file ours.tmp base.tmp theirs.tmp` where base=template@old, theirs=template@new, ours=user-current.

#### Section-Merge Algorithm

Used when `merge_strategy: "section-merge"` (e.g., CLAUDE.md). Operates on heading-level sections rather than line-level diff.

```
FUNCTION section_merge(file_path, manifest_entry, template_new, user_current):

  # 1. IDENTIFY SECTIONS — split on "## " headings only.
  #    Headings inside fenced code blocks (``` ... ```) are NOT treated as headings.
  #    Algorithm: track fence_open state; toggle on ``` line; only split on "## " when fence_open = false.

  FUNCTION split_sections(text):
    sections = []
    current_heading = "__preamble__"
    current_body = []
    fence_open = false
    FOR each line in text:
      IF line starts with "```": toggle fence_open
      IF NOT fence_open AND line starts with "## ":
        sections.append({heading: current_heading, body: join(current_body)})
        current_heading = line.strip()
        current_body = []
      ELSE:
        current_body.append(line)
    sections.append({heading: current_heading, body: join(current_body)})
    RETURN sections

  template_sections = split_sections(template_new)
  user_sections     = split_sections(user_current)

  # 2. SPLIT OWNERSHIP — use manifest merge_sections lists.
  template_owned_headings = manifest_entry.merge_sections.template_owned  # explicit list
  user_owned_headings     = manifest_entry.merge_sections.user_owned      # explicit list

  # 3. CLASSIFY each section heading (prefix match — heading may have "(full spec:...)" suffix):
  #    a. heading.startswith(any entry in template_owned) → TEMPLATE: take from template_new version
  #    b. heading.startswith(any entry in user_owned)     → USER: take from user_current version (preserve verbatim)
  #    c. New section in template_new, no match in either → default: TEMPLATE (template_owned)
  #    d. Section in user_current, no match in either     → default: USER (preserved)
  #
  #    Note: split_sections() stores the full heading line (e.g. "## Architecture: Subsystems (full spec: `...`)").
  #    Classification uses startswith(), not equality, because 11/18 CLAUDE.md template_owned headings
  #    carry "(full spec: ...)" or "(automated: ...)" suffixes in live files.

  # 4. ASSEMBLE OUTPUT — ordering rules:
  #    - TEMPLATE sections: appear in template_new order
  #    - USER sections: preserve the order they appear in user_current (user reordering respected)
  #    - Interleave: insert USER sections at the position nearest their original location
  #      relative to surrounding TEMPLATE sections (best-effort placement)
  #    - Nested content (paragraphs, lists, code blocks) under a heading is captured
  #      with that heading and moves with it

  output_sections = []
  template_order = [s for s in template_sections if classify(s) == TEMPLATE]
  user_order     = [s for s in user_sections     if classify(s) == USER]

  # Walk template order; after each TEMPLATE section, insert any USER sections
  # whose nearest preceding TEMPLATE anchor in user_current matches.
  FOR each t_section in template_order:
    output_sections.append(t_section from template_new)
    FOR each u_section in user_order where anchor(u_section, user_current) == t_section.heading:
      output_sections.append(u_section from user_current)

  # Append any USER sections with no matching anchor (e.g., placed before all template sections)
  FOR each u_section in user_order not yet appended:
    output_sections.append(u_section from user_current)

  RETURN join(output_sections)

# Edge cases summary:
# - Code block containing "## Heading" → NOT a section boundary (fence_open guard)
# - User reorders user_owned sections → user order preserved within user_owned group
# - New template section not in either list → treated as template_owned (safe default)
# - User-added section not in either list → treated as user_owned (preserved, not deleted)
# - Section deleted from template_owned in new template → removed from output
# - User_owned section deleted by user → absent in user_current → absent in output
```

**Path Detection:**

```
IF commit_count <= 1: PATH A (fresh clone)
IF NOT exists("1-ALIGN") OR NOT exists(".claude/rules"): PATH B (reverse clone)
ELSE: PATH C (version upgrade)
```

**ACs:**

| AC | Description |
|----|-------------|
| AC-L3-01 | `scripts/template-diff.sh` exists AND `--help` exits 0 |
| AC-L3-02 | Given 2 commits with 3 changed files, outputs exactly 3 with correct change types |
| AC-L3-03 | `.template-checkpoint.yml` has required fields (last_sync_sha, last_sync_date, template_version) |
| AC-L3-04 | Version chain: checkpoint v1.2.0 + target v2.1.0 → exits 1 with skip-detection error |
| AC-L3-05 | 3-way merge on CLAUDE.md preserves BOTH new template section AND user ## Project |
| AC-L3-06 | Reverse-clone: `--reverse-clone` creates fresh template clone + lists domain files |
| AC-L3-07 | **Dung test:** path detector outputs "PATH B" for repo with no 1-ALIGN/ |
| AC-L3-08 | **Cam Van test:** path detector outputs "PATH C" for repo with 1-ALIGN/ + .claude/rules/ |
| AC-L3-09 | Checkpoint updates ONLY after template-verify.sh exits 0 |
| AC-L3-10 | Bootstrap mode: repo with no .template-checkpoint.yml → prompts for initial version, creates checkpoint, re-enters diff from [2] |

---

### 3.4 Layer 4 — Migration Tooling

**Purpose:** Scripts, skills, guides, and manifest files PMs/agents use to execute migrations.

| # | Component | Status |
|---|-----------|--------|
| L4-C1 | template-check.sh v3.0 (lineage-aware categorization) | Enhance |
| L4-C2 | template-sync.sh v3.0 (checkpoint + pristine diff + 3-way merge + path detect) | Enhance |
| L4-C3 | template-diff.sh (pristine diff engine) | New |
| L4-C4 | template-manifest.sh (generate, audit, classify) | New |
| L4-C5 | template-verify.sh (unified 6-check sweep) | New |
| L4-C6 | template-release.sh (tag + validate + notes) | New |
| L4-C7 | migration-guide.md v3.0 (references manifest, checkpoint, pristine diff) | Rewrite |
| L4-C8 | _genesis/template-manifest.yml | New |
| L4-C9 | .template-checkpoint.yml schema | New |
| L4-C10 | /template-sync + /template-check skill enhancements | Enhance |

**Per-Profile Validation:**

| Profile | Path | Special Handling | AC |
|---------|------|-----------------|-----|
| Khang (Assets) | C — Bootstrap | Deprecated detection + no prior checkpoint | AC-L4-05, AC-L3-10 |
| Dong (Inflation) | C — Bootstrap | 19 custom rules preserved + no prior checkpoint | AC-L4-06, AC-L3-10 |
| Dung (Growth) | B | Pre-ALPEI reverse-clone, no checkpoint | AC-L4-07 |
| Cam Van (Financial System) | C — Incremental | Checkpoint exists, incremental sync | AC-L4-08 |

**ACs:**

| AC | Description |
|----|-------------|
| AC-L4-01 | All 6 scripts exist AND `--help` exits 0 |
| AC-L4-02 | template-check.sh v3.0 JSON includes `lineage` field per file |
| AC-L4-03 | `--detect-path` classifies all 4 profiles correctly |
| AC-L4-04 | migration-guide.md v3.0 references manifest, checkpoint, and diff |
| AC-L4-05 | **Khang test:** deprecated detection flags .claude/commands/, nested skills, _genesis/scripts/ |
| AC-L4-06 | **Dong test:** full sync does NOT delete any file not in manifest |
| AC-L4-07 | **Dung test:** Path B reverse-clone lists 250 files classified for triage |
| AC-L4-08 | **Cam Van test:** Path C produces changeset of ONLY template-changed files |
| AC-L4-09 | All scripts Bash 3 compatible (macOS default) |

---

### 3.5 Layer 5 — Verification

**Purpose:** Single-entry-point sweep confirming post-sync repo is functional before commit.

```
scripts/template-verify.sh [--check V{1-6}] [--json] [--verbose]

Exit: 0=all pass, 1=failures, 2=error

V1 structural   → validate-blueprint.py (8 checks)
V2 hooks        → settings.json path resolution + smoke-test.sh
V3 graph        → link-validator.sh + orphan-detect.sh
V4 agent        → agent files + skills + rules count check
V5 ownership    → manifest coverage + deprecated detection
V6 sync         → template-sync.sh --verify (4 ACs)
```

**ACs:**

| AC | Description |
|----|-------------|
| AC-L5-01 | `scripts/template-verify.sh` exists AND `--help` exits 0 |
| AC-L5-02 | Running on template repo itself exits 0 |
| AC-L5-03 | Broken hook path in settings.json → exits 1 with "V2 FAIL" |
| AC-L5-04 | Deprecated .claude/commands/ present → exits 1 with "V5 FAIL" |
| AC-L5-05 | Output: each check `V{N} PASS` or `V{N} FAIL: reason`. Final: `RESULT: N/6` |
| AC-L5-06 | Exit 0 iff all 6 pass. Exit 1 if any fail. Exit 2 on script error. |
| AC-L5-07 | `--check V2` runs ONLY hook check |

---

### 3.6 Layer 6 — Adoption & Support

**Purpose:** PMs and agents can discover, understand, and execute syncs without support.

| # | Component | Status |
|---|-----------|--------|
| L6-C1 | migration-guide.md v3.0 | Rewrite |
| L6-C2 | release-notes-template.md | New |
| L6-C3 | /template-sync skill enhancement | Enhance |
| L6-C4 | /template-check skill enhancement | Enhance |
| L6-C5 | script-registry.md updates | Update |
| L6-C6 | CLAUDE.md reference update | Update |

**ACs:**

| AC | Description |
|----|-------------|
| AC-L6-01 | migration-guide.md mentions template-manifest.yml in Path B + Path C |
| AC-L6-02 | migration-guide.md mentions .template-checkpoint.yml in Path C |
| AC-L6-03 | migration-guide.md mentions template-diff.sh in Path C |
| AC-L6-04 | release-notes-template.md contains all required sections |
| AC-L6-05 | script-registry.md lists all 4 new scripts |
| AC-L6-06 | Agent reading migration-guide.md can execute Path C without other docs |

---

## 4. Bug Resolution Matrix

| Bug | Fix Layer | Fix Component | Verifying AC |
|-----|-----------|---------------|--------------|
| BUG-1: "safe to TAKE" deletes Dong's custom rules | L2 | Manifest + three-lineage | AC-L2-07 |
| BUG-2: No lineage concept in template-sync | L2 + L4 | Manifest + check v3.0 | AC-L4-02 |
| BUG-3: No checkpoint mechanism | L3 | .template-checkpoint.yml + template-diff.sh | AC-L3-03 |
| BUG-4: Unfinished sync baseline command | L3 + L4 | Checkpoint reader + sync v3.0 | AC-L4-08 |
| BUG-5: Ambiguous content routing | L2 | merge_strategy field | AC-L2-06 |

---

## 5. Artifact Inventory

| # | Artifact | Path | ACs |
|---|----------|------|-----|
| A1 | Template Manifest | `_genesis/template-manifest.yml` | L2-01 thru L2-07 |
| A2 | Manifest Script | `scripts/template-manifest.sh` | L2-04, L4-01 |
| A3 | Checkpoint File | `.template-checkpoint.yml` | L3-03 |
| A4 | Pristine Diff Script | `scripts/template-diff.sh` | L3-01, L3-02, L3-04 |
| A5 | Template Check v3.0 | `scripts/template-check.sh` | L4-02 |
| A6 | Template Sync v3.0 | `scripts/template-sync.sh` | L3-05 thru L3-09, L4-03/06/08 |
| A7 | Verification Script | `scripts/template-verify.sh` | L5-01 thru L5-07 |
| A8 | Release Script | `scripts/template-release.sh` | L1-01, L1-02, L1-06 |
| A9 | Release Notes Template | `_genesis/templates/release-notes-template.md` | L1-03, L1-05, L6-04 |
| A10 | Migration Guide v3.0 | `_genesis/guides/migration-guide.md` | L6-01 thru L6-06 |
| A11 | Script Registry Updates | `.claude/rules/script-registry.md` | L6-05 |

**Alignment:** 45 ACs across 6 layers. 0 orphan ACs. 0 orphan artifacts. All 4 profiles covered. All 5 bugs mapped.

---

## 6. Sequence Hints — Build Order

```
WAVE 1 — Foundation                          ~2 sessions
├── A1: template-manifest.yml
├── A2: template-manifest.sh
├── A3: .template-checkpoint.yml
└── A9: release-notes-template.md

WAVE 2 — Engine                              ~3 sessions
├── A4: template-diff.sh (pristine diff)
├── A8: template-release.sh
└── 3-way merge + chain validator in sync.sh

WAVE 3 — Integration                         ~3 sessions
├── A5: template-check.sh v3.0
├── A6: template-sync.sh v3.0
├── A6: reverse-clone engine
└── A7: template-verify.sh

WAVE 4 — Adoption                            ~2 sessions
├── A10: migration-guide.md v3.0
├── A11: script-registry.md updates
├── CLAUDE.md update
└── Per-profile validation tests
```

---

## Approval Log

| Date | Gate | Decision | Signal | Tier |
|------|------|----------|--------|------|
| 2026-04-12 | G1-Design | APPROVED | "/dsbv sequence template management" | T2 |

> Only humans write to this table.

## Links

- [[AGENTS]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[agent-dispatch]]
- [[alpei-blueprint]]
- [[enforcement-layers]]
- [[filesystem-routing]]
- [[git-conventions]]
- [[ltc-builder]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[migration-guide]]
- [[naming-rules]]
- [[script-registry]]
- [[versioning]]
- [[workstream]]
