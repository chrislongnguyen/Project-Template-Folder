---
version: "1.0"
status: draft
last_updated: 2026-03-31
owner: Long Nguyen
workstream: "EXECUTE workstream"
feature: "Obsidian Auto-Linker (Self-Discovering Wikilink System)"
---
# DESIGN workstream: Obsidian Auto-Linker

## Intent

Convert the 1,100+ markdown files in any ALPEI project into a connected Obsidian knowledge graph by injecting `[[wikilinks]]` via `## Links` sections. The linker discovers its own link targets at runtime (no hardcoded artifact names) so it works for any project cloned from this template — not just this repo.

**Why:** The Obsidian graph view currently shows ~0 edges despite 500+ cross-references existing in plain text (ADR-NNN, file paths, framework names). Without wikilinks, Obsidian CLI's graph features (backlinks, graph:walk, orphan detection) return nothing useful. This is a one-time investment with permanent compounding value — every future file inherits the linking convention via pre-commit hook.

**Design source:** Brainstorm session 2026-03-31. All decisions below are locked.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Upstream outputs sufficient? | YES — Obsidian CLI integration complete (16/16 PASS), vault scaffold exists, security rules in place |
| Q2: In scope | Self-discovering Python linker, pre-commit hook, frontmatter alias seeding, test suite, documentation |
| Q2b: Out of scope | Agent-powered semantic linking (Approach 3 — deferred to I2), Obsidian plugin development, wikilink injection inside code blocks or frontmatter, modifying file content above ## Links section |
| Q3: Go/No-Go | GO |

---

## Locked Design Decisions

| # | Decision | Rationale (S × E × Sc) |
|---|----------|------------------------|
| D1 | Alias-based links — `aliases:` in frontmatter | Rename-resilient; decouples link from filesystem; scales across teams |
| D2 | All three tiers: T1 (artifact IDs), T2 (file paths), T3 (framework names) | Half-linked graph is worse than no graph — creates false confidence |
| D3 | `## Links` section appended at file bottom | Zero disruption to existing content; inert markdown if Obsidian unused |
| D4 | One-shot script + pre-commit hook | Initial coverage + ongoing coverage for all future files |
| D5 | Self-discovering targets (no hardcoding) | Template-portable — works for ANY ALPEI project after cloning |
| D6 | Python implementation | Project stack; rich regex + frontmatter parsing (PyYAML) |

---

## Artifact Inventory

| # | Artifact | Path | Purpose (WHY) | Acceptance Criteria |
|---|----------|------|---------------|-----------------------|
| A1 | Auto-linker script | `scripts/obsidian-autolinker.py` | 3-phase engine: discover targets → scan sources → write ## Links sections. Without this, no links exist. | AC-1: `python scripts/obsidian-autolinker.py --dry-run` exits 0 and reports discovered targets + proposed links. AC-2: `python scripts/obsidian-autolinker.py` produces `## Links` sections in .md files. AC-3: Running twice produces identical output (idempotent). AC-4: No `## Links` section contains a self-reference. |
| A2 | Alias seeder script | `scripts/obsidian-alias-seeder.py` | Adds `aliases:` to frontmatter of target files (ADRs, registers, frameworks). Without this, alias-based resolution has no targets. | AC-5: `python scripts/obsidian-alias-seeder.py --dry-run` exits 0 and reports files to modify + aliases to add. AC-6: After running, `grep -r "^aliases:" --include="*.md" \| wc -l` >= 30 (target files have aliases). AC-7: Existing frontmatter fields preserved — only `aliases:` added/updated. |
| A3 | Pre-commit hook | `hooks/obsidian-autolink-hook.sh` | Runs auto-linker on staged .md files only. Without this, new files arrive unlinked — graph drifts. | AC-8: Hook runs on `git commit` when .md files are staged. AC-9: Hook only processes staged .md files, not full repo. AC-10: Hook exits 0 on repos with no .md changes (no-op). AC-11: Hook adds modified files back to staging area (links appear in the commit). |
| A4 | Test suite | `tests/test_autolinker.py` | Validates all three tiers, edge cases, idempotency. Without tests, refactoring the linker breaks silently. | AC-12: `python -m pytest tests/test_autolinker.py -v` exits 0. AC-13: Tests cover: T1 (artifact ID linking), T2 (file path linking), T3 (framework name linking), idempotency, self-reference exclusion, ## Links placement. AC-14: Test fixtures use synthetic .md files, not repo files (isolated). |
| A5 | Linker documentation | `4-EXECUTE/docs/AUTOLINKER_README.md` | Setup guide for teams cloning the template. Without this, teams don't know the linker exists or how to configure it. | AC-15: README covers: what it does, how to run one-shot, how the hook works, how to add custom aliases, how to exclude files. AC-16: `grep -i "clone\|template\|your project" 4-EXECUTE/docs/AUTOLINKER_README.md` >= 1 match (template-portable language). |

**Alignment check:**
- [ ] Orphan conditions = 0 — all 16 ACs map to a named artifact
- [ ] Orphan artifacts = 0 — all 5 artifacts have ACs
- [ ] 5 artifacts here = 5 tasks in sequence-autolinker.md (to be verified at G2)

---

## Auto-Linker Architecture

### Phase 1: DISCOVER Targets

```
Input:  repo root path
Output: target_map = {alias: file_path, ...}

Steps:
  1. Scan all .md frontmatter for `aliases:` field
     → each alias maps to its file
  2. Scan all .md filenames
     → stem (without .md) = implicit alias
  3. Extract ID patterns from content via regex:
     ADR-\d+, UBS-\d+, UDS-\d+, EP-\d+, AP\d+
     → map each ID to the file that defines it
        (definition = file whose name or alias matches)
  4. Scan _genesis/ for framework document names
     → DSBV, ALPEI, etc. mapped to their source files
  5. Deduplicate: if multiple files claim same alias,
     prefer: explicit aliases: > filename stem > content ID
```

### Phase 2: SCAN Sources

```
Input:  target_map + list of .md files to scan
Output: link_map = {source_file: [target_aliases], ...}

Steps:
  1. For each .md file, read content (above ## Links if exists)
  2. Match content against all aliases in target_map
     - Word-boundary matching (avoid partial matches)
     - Case-sensitive for IDs (ADR-002), case-insensitive for names (dsbv/DSBV)
  3. Deduplicate matches per file
  4. Exclude self-references (file linking to itself)
  5. Sort matches alphabetically
```

### Phase 3: WRITE Links

```
Input:  link_map
Output: modified .md files with ## Links sections

Steps:
  1. For each file in link_map:
     a. If ## Links section exists → replace it
     b. If no ## Links section → append after a blank line
  2. Format:
     ## Links
     - [[alias-1]]
     - [[alias-2]]
  3. Ensure ## Links is always the LAST section
     (if content exists below where ## Links would go, error)
```

### Pre-Commit Hook Flow

```
git add *.md
     │
     ▼
hook triggers
     │
     ▼
list staged .md files (git diff --cached --name-only --diff-filter=ACM)
     │
     ▼
run Phase 1 (DISCOVER) — full repo scan for targets (fast, ~1s)
     │
     ▼
run Phase 2 (SCAN) — staged files only
     │
     ▼
run Phase 3 (WRITE) — update ## Links on staged files only
     │
     ▼
git add (re-stage modified files)
     │
     ▼
commit proceeds
```

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Single-agent sequential |
| Why this pattern | Well-defined artifacts with locked design. No open decisions remaining. |
| Agent config | ltc-builder (Sonnet) for all Build tasks; ltc-reviewer (Opus) for Validate |
| Git strategy | All work on `feat/obsidian-cli` worktree. Commits after each task. |
| Human gates | G1 (this DESIGN), G2 (SEQUENCE), G3 (Build complete), G4 (Validate passes) |
| Cost estimate | ~5 ltc-builder tasks × ~3K tokens each = ~15K build tokens. Validate = ~5K. Total: ~20K. |

---

## Dependencies

| Dependency | From Workstream/Artifact | Status |
|------------|-------------------|--------|
| Obsidian CLI skill (A2 from prior cycle) | `.claude/skills/obsidian/SKILL.md` | Ready — completed T3 |
| Obsidian security rule (A4 from prior cycle) | `.claude/rules/obsidian-security.md` | Ready — AP3 informs staging |
| Vault scaffold (A3 from prior cycle) | `4-EXECUTE/src/vault/` | Ready — inbox/ folder exists |
| Python available in project stack | CLAUDE.md | Ready |
| Existing .md files with cross-references | Repo content | Ready — 500+ refs scanned |

---

## Human Gates

| Gate | Trigger | Decision Required |
|------|---------|-------------------|
| G1 | This design-autolinker.md | Approve scope, artifacts, ACs → proceed to SEQUENCE |
| G2 | sequence-autolinker.md complete | Approve task order → proceed to Build |
| G3 | Build complete | Review all artifacts, run test suite → proceed to Validate |
| G4 | VALIDATE_AUTOLINKER.md complete | Approve → run one-shot on repo, enable hook, commit results |

---

## Readiness Conditions (C1-C6)

| ID | Condition | Status |
|----|-----------|--------|
| C1 | Clear scope — in/out/locked decisions written | GREEN |
| C2 | Input materials curated — brainstorm output, repo stats, prior DESIGN.md | GREEN |
| C3 | Success rubric defined — 16 ACs across 5 artifacts | GREEN |
| C4 | Process definition loaded — DSBV skill + DESIGN template in context | GREEN |
| C5 | Prompt engineered — all inputs in window, no dead weight | GREEN |
| C6 | Evaluation protocol — ltc-reviewer validates against 16 ACs | GREEN |

---

## Risk Register (feature-specific)

| Risk | Impact | Mitigation |
|------|--------|------------|
| Regex false positives (e.g., "EP" in "STEP") | Spurious links clutter graph | Word-boundary matching `\bEP-\d+\b`; test suite covers edge cases |
| Alias collision (two files claim same alias) | Wrong link target | Priority: explicit aliases > filename > content ID; warn on collision |
| ## Links section corrupts file rendering | Broken markdown downstream | Links section is pure markdown list; test with multiple renderers |
| Hook slows down commits | Developer friction (UBS-001) | Phase 1 cached; Phase 2-3 only on staged files; target: <2s for typical commit |
| PyYAML not installed in cloned project | Script fails on first run | Fallback: regex-based frontmatter parsing (no PyYAML dependency); or document pip install in README |

## Links

- [[ADR-002]]
- [[CLAUDE]]
- [[DESIGN]]
- [[README]]
- [[SEQUENCE]]
- [[sequence-autolinker]]
- [[SKILL]]
- [[VALIDATE]]
- [[documentation]]
- [[dsbv]]
- [[friction]]
- [[ltc-builder]]
- [[ltc-reviewer]]
- [[obsidian-security]]
- [[project]]
- [[security]]
- [[task]]
- [[workstream]]
