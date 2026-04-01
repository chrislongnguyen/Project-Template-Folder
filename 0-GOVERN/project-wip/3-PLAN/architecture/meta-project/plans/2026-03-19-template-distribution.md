---
version: "1.0"
last_updated: 2026-03-30
---
# Template Distribution System — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add versioning, changelog, staleness checker, and session-start integration to the LTC Project Template so child repos can discover and apply updates.

**Architecture:** Pull model with visibility. A `VERSION` file tracks template state, `CHANGELOG.md` with tier tags (T1/T2/T3) describes what changed, and `scripts/template-check.sh` compares child repos against the template's GitHub-hosted VERSION. EPS instructions in all three IDE configs trigger the check at session start.

**Tech Stack:** Bash (script), Markdown (docs), curl (GitHub raw fetch)

**Spec:** `docs/superpowers/specs/2026-03-19-template-distribution-design.md`

---

## LT Compensation Strategy

Each task is designed to compensate for specific LLM Truths. This table maps risks to mitigations built into the plan structure:

| LT | Risk in this plan | Mitigation |
|----|-------------------|------------|
| LT-1 (Hallucination) | Agent invents script behavior not in spec | Every step includes exact expected output to verify against. Spec section references on every task. |
| LT-2 (Context lossy) | Spec is 300+ lines; agent loses details mid-task | Each task is self-contained with only the spec sections it needs. No task requires reading the full spec. |
| LT-3 (Reasoning degrades) | Script has 7 modes/flags — complex branching logic | Script is built incrementally: core logic first (Task 3), then flags added one at a time (Tasks 4-5). Max 3 reasoning steps per step. |
| LT-4 (Retrieval fragile) | Agent grabs wrong line numbers or file paths | Exact file paths and line numbers provided. Exact content strings for edits, not "find the section about X." |
| LT-5 (Plausibility over truth) | Agent writes script that "looks right" but has subtle bugs | Every script step has a verification command with exact expected output. Agent must run and confirm before proceeding. |
| LT-6 (No memory) | Agent forgets decisions from earlier tasks | Each task repeats the critical context it needs. No "as we discussed" references. |
| LT-7 (Cost scales) | Loading full spec + all files for every task wastes tokens | Tasks list only the files they touch. Verification steps are short commands, not re-reading files. |
| LT-8 (Alignment approximate) | Agent skips verification gates under pressure | Verification is a separate checkbox step, not bundled with implementation. Cannot be skipped without visibly leaving a box unchecked. |

---

## File Map

### New files
| File | Responsibility |
|------|---------------|
| `VERSION` | Single line: `0.3.0`. Template's authoritative version. |
| `CHANGELOG.md` | Tier-tagged changelog. Keep-a-Changelog format. |
| `scripts/template-check.sh` | Staleness checker. Reads `.template-version`, fetches remote `VERSION`, compares, reports. |
| `.cursor/rules/template-version.md` | Session-start check instruction for Cursor. |

### Modified files
| File | What changes |
|------|-------------|
| `.gitignore:19` | Add `.template-version` entry (after line 18) |
| `CLAUDE.md:99` | Append `## Template Version` section (after last content line) |
| `GEMINI.md:76` | Append `## Template Version` section (after last content line) |
| `README.md:89` | Fix Tenorite→Inter in rules table |
| `README.md:143` | Insert `## Keeping Your Repo Updated` section before `---` / footer |
| `.cursor/rules/brand-identity.md:26-27` | Fix Tenorite→Inter |
| `.agents/rules/brand-identity.md:15-16` | Fix Tenorite→Inter |
| `GEMINI.md:38` | Fix Tenorite→Inter in Brand Identity section |

---

## Task 1: Create VERSION and CHANGELOG.md

**Spec ref:** §4 (Versioning Scheme), §5 (CHANGELOG Format)
**LT focus:** LT-1 (exact content from spec, no invention), LT-4 (single-purpose files, no retrieval noise)

**Files:**
- Create: `VERSION`
- Create: `CHANGELOG.md`

- [ ] **Step 1: Create VERSION file**

```
0.3.0
```

Single line, no trailing newline, no frontmatter.

- [ ] **Step 2: Verify VERSION file**

Run: `cat VERSION && wc -c VERSION`
Expected: `0.3.0` and `5` bytes (5 chars, no trailing newline) or `6` bytes (with newline — both acceptable).

- [ ] **Step 3: Create CHANGELOG.md**

```markdown
# Changelog

All notable changes to the LTC Project Template.
Format: [semver] — YYYY-MM-DD — summary.
Tier tags: [T1:REPLACE] [T2:MERGE] [T3:ADD-ONLY]

## [0.3.0] — 2026-03-19

### Added
- [T1:REPLACE] `rules/agent-system.md` — 7-CS, 8 LLM Truths, two operators (OPS_-4216)
- [T1:REPLACE] `rules/agent-diagnostic.md` — symptom→component diagnostics (OPS_-4216)
- [T1:REPLACE] `rules/general-system.md` — system design methodology (OPS_-4216)
- [T1:REPLACE] `rules/security-rules.md` — 3-layer defense-in-depth (OPS_-4215)
- [T1:REPLACE] `rules/naming-rules.md` — UNG with 75 SCOPE codes

### Changed
- [T1:REPLACE] `rules/brand-identity.md` — Tenorite → Inter, 20-color palette, Google Fonts CDN URLs
- [T2:MERGE] `CLAUDE.md` — Brand Identity section strengthened with explicit NEVER list
- [T2:MERGE] `GEMINI.md` — Typography: Tenorite → Inter
- [T1:REPLACE] `.cursor/rules/brand-identity.md` — Tenorite → Inter
- [T1:REPLACE] `.agents/rules/brand-identity.md` — Tenorite → Inter
```

- [ ] **Step 4: Verify CHANGELOG structure**

Run: `head -5 CHANGELOG.md`
Expected: First line is `# Changelog`, line 3 starts with `All notable`.

- [ ] **Step 5: Commit**

```bash
git add VERSION CHANGELOG.md
git commit -m "feat: add VERSION (0.3.0) and CHANGELOG.md for template distribution"
```

---

## Task 2: Update .gitignore and fix Tenorite→Inter across all IDE configs

**Spec ref:** §3 (Distribution Tiers — font consistency), §4.2 (`.template-version` is gitignored), §9 (Updated Files)
**LT focus:** LT-3 (small batch of related edits, no complex logic), LT-8 (verification gate per file)

**Files:**
- Modify: `.gitignore:19` (insert new line after line 18, before Dependencies section)
- Modify: `GEMINI.md:38`
- Modify: `.cursor/rules/brand-identity.md:26-27`
- Modify: `.agents/rules/brand-identity.md:15-16`
- Modify: `README.md:89`

- [ ] **Step 1: Add `.template-version` to .gitignore**

After line 18 (`.claude/settings.local.json`), add:

```
.template-version
```

- [ ] **Step 2: Fix GEMINI.md typography**

Replace line 38:
```
Typography: Tenorite (English), Work Sans (Vietnamese). Base 11pt, headlines 6x, sub-title 3x, body-title 1.6x.
```
With:
```
Typography: **Inter** (English), **Work Sans** (Vietnamese). Both via Google Fonts. Base 11pt, headlines 6x, sub-title 3x, body-title 1.6x.
```

- [ ] **Step 3: Fix .cursor/rules/brand-identity.md typography**

Replace lines 26-27:
```
- English: Tenorite (fallback: 'Segoe UI', system-ui, sans-serif)
- Vietnamese: Work Sans (fallback: 'Segoe UI', system-ui, sans-serif)
```
With:
```
- English: Inter (fallback: system-ui, -apple-system, sans-serif) — load via Google Fonts
- Vietnamese: Work Sans (fallback: system-ui, -apple-system, sans-serif) — load via Google Fonts
```

- [ ] **Step 4: Fix .agents/rules/brand-identity.md typography**

Replace lines 15-16:
```
- English: Tenorite (fallback: 'Segoe UI', system-ui, sans-serif)
- Vietnamese: Work Sans (fallback: 'Segoe UI', system-ui, sans-serif)
```
With:
```
- English: Inter (fallback: system-ui, -apple-system, sans-serif) — load via Google Fonts
- Vietnamese: Work Sans (fallback: system-ui, -apple-system, sans-serif) — load via Google Fonts
```

- [ ] **Step 5: Fix README.md rules table**

Replace line 89:
```
| `brand-identity.md` | Colors (20-color palette), typography (Tenorite/Work Sans), logo usage, function color assignments, MS Office theme | Active |
```
With:
```
| `brand-identity.md` | Colors (20-color palette), typography (Inter/Work Sans), logo usage, function color assignments, MS Office theme | Active |
```

- [ ] **Step 6: Verify no Tenorite references remain**

Run: `grep -ri "tenorite" . --include="*.md" | grep -v "docs/superpowers/" | grep -v "rules/brand-identity.md" | grep -v ".git/"`
Expected: Zero matches. (`rules/brand-identity.md` contains a historical migration note — that's fine. `docs/superpowers/` specs may also reference Tenorite historically.)

- [ ] **Step 7: Commit**

```bash
git add .gitignore GEMINI.md .cursor/rules/brand-identity.md .agents/rules/brand-identity.md README.md
git commit -m "fix: Tenorite → Inter across all IDE configs, add .template-version to gitignore"
```

---

## Task 3: Create template-check.sh — core logic

**Spec ref:** §6.1-6.3 (Check Script overview, behavior, how it works)
**LT focus:** LT-3 (build incrementally — core first, flags later), LT-1 (exact output format from spec), LT-5 (verify with real execution)

This task implements: read local version, fetch remote version, compare, display result. Flags (`--diff`, `--quiet`, `--init`) are added in Tasks 4-5.

**Files:**
- Create: `scripts/template-check.sh`

- [ ] **Step 1: Write the core script**

```bash
#!/usr/bin/env bash
set -euo pipefail

# LTC Project Template — Staleness Checker
# Spec: docs/superpowers/specs/2026-03-19-template-distribution-design.md §6

TEMPLATE_REPO="Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE"
RAW_BASE="https://raw.githubusercontent.com/${TEMPLATE_REPO}/main"
LOCAL_VERSION_FILE=".template-version"

# --- Helpers ---

fetch_remote() {
  local url="$1"
  local curl_opts=(-sfL --connect-timeout 5 --max-time 10)
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    curl_opts+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
  fi
  curl "${curl_opts[@]}" "$url" 2>/dev/null
}

# Compare semver: returns 0 if $1 >= $2, 1 if $1 < $2
# Splits on "." and compares each numeric segment
semver_lt() {
  local IFS='.'
  local -a a=($1) b=($2)
  for i in 0 1 2; do
    local ai="${a[$i]:-0}" bi="${b[$i]:-0}"
    if (( ai < bi )); then return 0; fi
    if (( ai > bi )); then return 1; fi
  done
  return 1  # equal — not less than
}

# --- Main ---

main() {
  # Step 1: Read local version
  if [[ ! -f "$LOCAL_VERSION_FILE" ]]; then
    echo "No .template-version found."
    echo "Run: $0 --init"
    exit 2
  fi
  local local_version
  local_version=$(cat "$LOCAL_VERSION_FILE" | tr -d '[:space:]')

  # Step 2: Fetch remote version
  local remote_version
  remote_version=$(fetch_remote "${RAW_BASE}/VERSION" | tr -d '[:space:]') || true

  if [[ -z "$remote_version" ]]; then
    echo "LTC Project Template — Update Check"
    echo "  Local version:    ${local_version}"
    echo "  Template version: (offline — could not reach GitHub)"
    echo "  Status:           Unknown. Check manually or retry with network."
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
      echo ""
      echo "  Note: GITHUB_TOKEN is set but fetch failed. Check token permissions."
    else
      echo ""
      echo "  Hint: Set GITHUB_TOKEN to access private repos."
    fi
    exit 0
  fi

  # Step 3: Compare
  if semver_lt "$local_version" "$remote_version"; then
    echo "LTC Project Template — Update Check"
    echo "  Local version:    ${local_version}"
    echo "  Template version: ${remote_version}"
    echo "  Status:           ⚠ Outdated (local ${local_version} → latest ${remote_version})"

    # Step 4: Fetch and parse CHANGELOG for versions between local and remote
    local changelog
    changelog=$(fetch_remote "${RAW_BASE}/CHANGELOG.md") || true
    if [[ -n "$changelog" ]]; then
      echo ""
      echo "  Changes since ${local_version}:"
      # POSIX-compatible awk (no 3-arg match — works on macOS BSD awk)
      echo "$changelog" | awk -v local="$local_version" '
        /^## \[/ {
          # Extract version: find "[", grab until "]"
          s = $0
          i = index(s, "[")
          if (i > 0) {
            s = substr(s, i+1)
            j = index(s, "]")
            if (j > 0) ver = substr(s, 1, j-1); else ver = ""
          } else ver = ""
          if (ver != "" && ver != local) {
            # Extract date after "— "
            d = ""
            k = index($0, "— ")
            if (k > 0) d = substr($0, k+3, 10)
            in_range = 1
            printf "    [%s] %s\n", ver, d
          } else {
            in_range = 0
          }
        }
        /^### / && in_range { next }
        /^- \[T[123]:/ && in_range {
          # Extract file path between backticks
          s = $0
          i = index(s, "`")
          if (i > 0) {
            s = substr(s, i+1)
            j = index(s, "`")
            if (j > 0) printf "      %s\n", substr(s, 1, j-1)
          }
        }
      '
    fi
    echo ""
    echo "  Run: $0 --diff"
    echo "  to see file-level changes."
    exit 1
  else
    echo "LTC Project Template — Update Check"
    echo "  Local version:    ${local_version}"
    echo "  Template version: ${remote_version}"
    echo "  Status:           ✓ Up to date"
    exit 0
  fi
}

main "$@"
```

- [ ] **Step 2: Make executable**

Run: `chmod +x scripts/template-check.sh`

- [ ] **Step 3: Verify script runs (missing .template-version case)**

Run: `./scripts/template-check.sh`
Expected output contains: `No .template-version found.`
Expected exit code: 2

- [ ] **Step 4: Test with a local .template-version**

Run: `echo "0.3.0" > .template-version && ./scripts/template-check.sh; echo "exit: $?"`
Expected: Either shows "Up to date" (exit 0) or "Outdated" (exit 1) or "offline" (exit 0) — any is valid, confirming the script runs end-to-end.

- [ ] **Step 5: Clean up test file**

Run: `rm .template-version`
(This file is gitignored and only exists in child repos.)

- [ ] **Step 6: Commit**

```bash
git add scripts/template-check.sh
git commit -m "feat: add template-check.sh — core version comparison logic"
```

---

## Task 4: Add --quiet, --diff, and --init flags to template-check.sh

**Spec ref:** §6.2 (quiet/diff behavior), §6.3 steps 5-7 (flag logic)
**LT focus:** LT-3 (one flag per step — never implement two features simultaneously), LT-5 (verify each flag independently)
**LT-2 note:** This task has 10 steps modifying a single file. Re-read `scripts/template-check.sh` before starting to hold the full script in context.

**Files:**
- Modify: `scripts/template-check.sh`

- [ ] **Step 0: Re-read the full script**

Run: `cat scripts/template-check.sh`
Purpose: Load the current script state into context before making modifications.

- [ ] **Step 1: Add flag parsing and --init to the script**

Insert after the `LOCAL_VERSION_FILE=` line and before `# --- Helpers ---`:

```bash
# --- Flag parsing ---
MODE="default"
for arg in "$@"; do
  case "$arg" in
    --quiet) MODE="quiet" ;;
    --diff)  MODE="diff" ;;
    --init)  MODE="init" ;;
    *)       echo "Usage: $0 [--quiet|--diff|--init]"; exit 2 ;;
  esac
done
```

- [ ] **Step 2: Add --init handler**

Insert before `main()`:

```bash
do_init() {
  local remote_version
  remote_version=$(fetch_remote "${RAW_BASE}/VERSION" | tr -d '[:space:]') || true
  if [[ -z "$remote_version" ]]; then
    echo "Error: Could not fetch template VERSION (offline or auth required)."
    echo "Hint: Set GITHUB_TOKEN to access private repos."
    exit 2
  fi
  echo "$remote_version" > "$LOCAL_VERSION_FILE"
  echo "Initialized .template-version to ${remote_version}"
  exit 0
}
```

- [ ] **Step 3: Wire --init into main**

At the top of `main()`, before the `.template-version` existence check, add:

```bash
  if [[ "$MODE" == "init" ]]; then
    do_init
  fi
```

- [ ] **Step 4: Add --quiet mode**

In the `semver_lt` branch (where status is outdated), before the changelog fetch block, add:

```bash
    if [[ "$MODE" == "quiet" ]]; then
      echo "⚠ Template v${remote_version} available (you're on v${local_version}). Run ./scripts/template-check.sh for details."
      exit 1
    fi
```

In the "up to date" else branch, wrap the existing output:

```bash
    if [[ "$MODE" != "quiet" ]]; then
      echo "LTC Project Template — Update Check"
      echo "  Local version:    ${local_version}"
      echo "  Template version: ${remote_version}"
      echo "  Status:           ✓ Up to date"
    fi
    exit 0
```

- [ ] **Step 5: Add --diff mode**

In the outdated branch, after the changelog parse block and before the "Run: $0 --diff" hint, add:

```bash
    if [[ "$MODE" == "diff" ]]; then
      echo ""
      echo "  Changed files (${local_version} → ${remote_version}):"
      # POSIX-compatible awk (no 3-arg match — works on macOS BSD awk)
      echo "$changelog" | awk -v local="$local_version" '
        /^## \[/ {
          s = $0; i = index(s, "[")
          if (i > 0) { s = substr(s, i+1); j = index(s, "]"); ver = (j>0) ? substr(s,1,j-1) : "" } else ver = ""
          in_range = (ver != "" && ver != local) ? 1 : 0
        }
        /^- \[T[123]:/ && in_range {
          # Extract tier tag: first [...] on the line
          s = $0; i = index(s, "[")
          if (i > 0) { s = substr(s, i+1); j = index(s, "]"); tier = (j>0) ? substr(s,1,j-1) : "" } else tier = ""
          # Extract file path between backticks
          s = $0; i = index(s, "`")
          if (i > 0) { s = substr(s, i+1); j = index(s, "`"); f = (j>0) ? substr(s,1,j-1) : "" } else f = ""
          if (tier != "" && f != "") printf "    [%-12s] %s\n", tier, f
        }
      '
      exit 1
    fi
```

And in the default mode block, hide the "Run --diff" hint when already in diff mode (already handled since diff exits early above).

- [ ] **Step 6: Verify --init**

Run: `./scripts/template-check.sh --init && cat .template-version`
Expected: `Initialized .template-version to X.Y.Z` and file contains the version.

- [ ] **Step 7: Verify --quiet when up to date**

Run: `./scripts/template-check.sh --quiet; echo "exit: $?"`
Expected: Silent output (nothing printed), exit code 0.

- [ ] **Step 8: Verify --quiet when behind**

Run: `echo "0.0.1" > .template-version && ./scripts/template-check.sh --quiet; echo "exit: $?"`
Expected: `⚠ Template vX.Y.Z available (you're on v0.0.1). Run ./scripts/template-check.sh for details.` and exit code 1.

- [ ] **Step 9: Verify --diff when behind**

Run: `echo "0.0.1" > .template-version && ./scripts/template-check.sh --diff`
Expected: Shows `Changed files (0.0.1 → X.Y.Z):` with tier-tagged file list.

- [ ] **Step 10: Clean up and commit**

```bash
rm .template-version
git add scripts/template-check.sh
git commit -m "feat: add --quiet, --diff, --init flags to template-check.sh"
```

---

## Task 5: Add session-start instructions to all three IDE configs

**Spec ref:** §7 (Session-Start Integration), §7.2 (EPS Additions)
**LT focus:** LT-2 (instruction is 2 lines — minimal context consumption), LT-8 (same instruction in all 3 IDEs — no alignment drift)

**Files:**
- Modify: `CLAUDE.md:99` (append after last line)
- Modify: `GEMINI.md:77` (append after last line)
- Create: `.cursor/rules/template-version.md`

- [ ] **Step 1: Add Template Version section to CLAUDE.md**

Append after line 99 (`Path-scoped rules: .claude/rules/ | On-demand skills: .claude/skills/`):

```markdown

## Template Version

If `./scripts/template-check.sh` exists, run `./scripts/template-check.sh --quiet` at session start.
If behind, warn the user before proceeding. If the script is missing, skip silently.
```

- [ ] **Step 2: Add Template Version section to GEMINI.md**

Append after line 76 (`Workspace rules: .agents/rules/ | Workspace skills: .agents/skills/`):

```markdown

## Template Version

If `./scripts/template-check.sh` exists, run `./scripts/template-check.sh --quiet` at session start.
If behind, warn the user before proceeding. If the script is missing, skip silently.
```

- [ ] **Step 3: Create .cursor/rules/template-version.md**

```markdown
---
paths:
  - "**/*"
---

# Template Version Check

If `./scripts/template-check.sh` exists, run `./scripts/template-check.sh --quiet` at session start.
If behind, warn the user before proceeding. If the script is missing, skip silently.
```

- [ ] **Step 4: Verify all three files contain the instruction**

Run: `grep -l "template-check.sh" CLAUDE.md GEMINI.md .cursor/rules/template-version.md`
Expected: All three files listed.

- [ ] **Step 5: Commit**

```bash
git add CLAUDE.md GEMINI.md .cursor/rules/template-version.md
git commit -m "feat: add session-start template version check to all IDE configs"
```

---

## Task 6: Update README with "Keeping Your Repo Updated" section

**Spec ref:** §8 (README Documentation)
**LT focus:** LT-1 (exact content from spec §8 — no paraphrasing), LT-4 (insert at precise location — before footer)

**Files:**
- Modify: `README.md:143` (insert before the `---` horizontal rule that precedes the footer)

- [ ] **Step 1: Insert the section before the footer**

Before line 143 (`---` horizontal rule before the `_Template maintained by OPS Process..._` footer), insert:

```markdown
## Keeping Your Repo Updated

This template uses semver versioning. The `VERSION` file tracks the current template version.

### Distribution Tiers

Every file falls into one of three update tiers:

| Tier | Strategy | What it means |
|------|----------|---------------|
| T1:REPLACE | Overwrite | Org-owned. Copy the template's version directly. |
| T2:MERGE | Merge | Mixed ownership. Update org sections, keep your project sections. |
| T3:ADD-ONLY | Add new | New files only. Never overwrites your existing files. |

See CHANGELOG.md for tier tags on every change.

### Checking for Updates

Run the staleness checker:

    ./scripts/template-check.sh           # full report
    ./scripts/template-check.sh --diff    # show changed files with tier tags
    ./scripts/template-check.sh --quiet   # one-line summary (used by session-start)

First time? Bootstrap your sync version:

    ./scripts/template-check.sh --init

### Applying Updates

1. Open your repo in Claude Code (or your IDE of choice)
2. Paste the template repo URL and ask:
   "Check this template and see if there is any update I need to make to my repo"
3. Claude diffs the template against your repo and recommends changes per tier
4. Review and approve each change
5. Update `.template-version` to the new version

### Releasing a Template Update (maintainers)

1. Make changes to the template repo
2. Bump `VERSION` (semver: patch/minor/major)
3. Add CHANGELOG.md entry with tier tags per file
4. Commit, push, and optionally tag: `git tag v{VERSION}`

---

```

- [ ] **Step 2: Verify the section exists and footer follows**

Run: `grep -n "Keeping Your Repo Updated" README.md && grep -n "Template maintained" README.md`
Expected: "Keeping Your Repo Updated" appears before "Template maintained" in line numbers.

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: add 'Keeping Your Repo Updated' section to README"
```

---

## Task 7: End-to-end verification

**Spec ref:** Full spec — cross-cutting verification
**LT focus:** LT-5 (verify the whole system works, not just individual pieces), LT-8 (human gate before push)

**Files:** None modified — verification only.

- [ ] **Step 1: Verify file inventory matches spec §9**

Run: `ls -la VERSION CHANGELOG.md scripts/template-check.sh .cursor/rules/template-version.md 2>&1`
Expected: All four new files exist.

- [ ] **Step 2: Verify .template-version is gitignored**

Run: `echo "0.3.0" > .template-version && git status .template-version`
Expected: File does NOT appear in `git status` output (it's ignored).

Run: `rm .template-version`

- [ ] **Step 3: Verify no Tenorite references in active config files**

Run: `grep -ri "tenorite" . --include="*.md" | grep -v "docs/superpowers/" | grep -v ".git/"`
Expected: Zero matches.

- [ ] **Step 4: Verify VERSION content**

Run: `cat VERSION`
Expected: `0.3.0`

- [ ] **Step 5: Verify script is executable**

Run: `test -x scripts/template-check.sh && echo "OK"`
Expected: `OK`

- [ ] **Step 6: Run full template-check.sh cycle**

```bash
# Bootstrap
./scripts/template-check.sh --init

# Default mode
./scripts/template-check.sh

# Quiet mode
./scripts/template-check.sh --quiet

# Simulate outdated
echo "0.0.1" > .template-version
./scripts/template-check.sh --quiet
./scripts/template-check.sh --diff
./scripts/template-check.sh

# Clean up
rm .template-version
```

Verify each mode produces output matching spec §6.2.

- [ ] **Step 7: Verify all IDE configs have template-check instruction**

Run: `grep -c "template-check.sh" CLAUDE.md GEMINI.md .cursor/rules/template-version.md`
Expected: Each file shows count ≥ 1.

- [ ] **Step 8: Review git log**

Run: `git log --oneline -6`
Expected: 5 new commits from Tasks 1-6, all with descriptive messages.

- [ ] **Step 9: Human review gate**

Present the diff to the user: `git diff HEAD~5..HEAD --stat`
**Do not push until the user explicitly approves.**
