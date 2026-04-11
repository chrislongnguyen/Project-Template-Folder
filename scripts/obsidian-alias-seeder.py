# version: 1.2 | status: in-review | last_updated: 2026-04-09
"""
obsidian-alias-seeder.py — Scan repo for target .md files and add aliases: to YAML frontmatter.

Usage:
    python3 scripts/obsidian-alias-seeder.py [repo_root] [--dry-run]

Targets:
    1. ADR files       */decisions/ADR-*.md  (not in archive/)
    2. Register files  *REGISTER*.md
    3. Framework docs  _genesis/frameworks/*.md
    4. Template docs   _genesis/templates/*.md
    5. Zone index      {0-5}-*/DESIGN.md, SEQUENCE.md, VALIDATE.md
    6. EP registry     _genesis/reference/ltc-effective-agent-principles-registry.md

Exclusions: .git/, .worktrees/, .claude/worktrees/, .obsidian/, archive/, drafts/
"""

import os
import re
import sys
import argparse

# ---------------------------------------------------------------------------
# Exclusion helpers
# ---------------------------------------------------------------------------

EXCLUDED_DIRS = {".git", ".worktrees", ".obsidian"}
EXCLUDED_PATH_FRAGMENTS = [
    os.sep + "archive" + os.sep,
    os.sep + "drafts" + os.sep,
    os.sep + ".claude" + os.sep + "worktrees" + os.sep,
]


def _is_excluded(path, repo_root):
    """Return True if path should be skipped."""
    rel = os.path.relpath(path, repo_root)
    parts = rel.split(os.sep)

    # Top-level excluded dirs
    if parts[0] in EXCLUDED_DIRS:
        return True

    # Fragment exclusions (archive/, drafts/, .claude/worktrees/)
    norm = os.sep + rel + os.sep
    for fragment in EXCLUDED_PATH_FRAGMENTS:
        if fragment in norm:
            return True

    return False


# ---------------------------------------------------------------------------
# Alias derivation
# ---------------------------------------------------------------------------

ZONE_NAMES = {
    "1": "ALIGN",
    "2": "LEARN",
    "3": "PLAN",
    "4": "EXECUTE",
    "5": "IMPROVE",
}

ACRONYMS = ["ALPEI", "DSBV", "APEI", "LTC", "EOP", "UBS", "UDS", "ADR", "OKR"]


def _stem(filename):
    """Return filename without extension."""
    base, _ = os.path.splitext(filename)
    return base


def _stem_to_title(stem):
    """Convert UNDERSCORE_NAME to Title Case Words."""
    words = stem.replace("_", " ").split()
    result = []
    for word in words:
        # Preserve all-caps acronyms as-is
        if word.upper() in ACRONYMS or word.upper() == word and len(word) <= 6:
            result.append(word.upper())
        else:
            result.append(word.capitalize())
    return " ".join(result)


def _acronym_aliases(stem):
    """Extract known acronyms present in the stem."""
    upper = stem.upper()
    found = []
    for acr in ACRONYMS:
        if acr in upper:
            found.append(acr)
    return found


def derive_aliases(path, repo_root):
    """
    Return list of alias strings for a given file path.
    Returns [] if the file does not match any target category.
    """
    rel = os.path.relpath(path, repo_root)
    filename = os.path.basename(path)
    stem = _stem(filename)
    aliases = []

    # --- Category 1: ADR files ---
    if re.match(r"ADR-\d+", filename) and "decisions" in rel:
        m = re.match(r"(ADR-\d+)", filename)
        if m:
            adr_id = m.group(1)
            aliases.append(adr_id)
            aliases.append(stem)  # full stem e.g. ADR-002-obsidian-cli

    # --- Category 2: Register files ---
    elif "REGISTER" in filename.upper() and not filename.startswith("ADR-"):
        if "UBS_REGISTER" in filename.upper() or filename.upper() == "UBS_REGISTER.MD":
            aliases.append("UBS Register")
        elif "UDS_REGISTER" in filename.upper() or filename.upper() == "UDS_REGISTER.MD":
            aliases.append("UDS Register")
        else:
            # Generic register — use stem title
            aliases.append(_stem_to_title(stem))

    # --- Category 3: Framework docs ---
    elif rel.startswith(os.path.join("_genesis", "frameworks") + os.sep):
        title = _stem_to_title(stem)
        aliases.append(title)
        for acr in _acronym_aliases(stem):
            if acr not in aliases:
                aliases.append(acr)

    # --- Category 4: Template docs ---
    elif rel.startswith(os.path.join("_genesis", "templates") + os.sep):
        title = _stem_to_title(stem)
        aliases.append(title)

    # --- Category 5: Zone index files ---
    elif filename in ("DESIGN.md", "SEQUENCE.md", "VALIDATE.md"):
        # Check if parent dir matches {digit}-* pattern
        parent = os.path.basename(os.path.dirname(path))
        m = re.match(r"^(\d)-", parent)
        if m:
            zone_num = m.group(1)
            zone_name = ZONE_NAMES.get(zone_num)
            if zone_name:
                phase = _stem(filename)  # DESIGN, SEQUENCE, VALIDATE
                phase_title = phase.capitalize()
                aliases.append("{} {}".format(zone_name, phase_title))

    # --- Category 6: EP registry ---
    elif filename == "ltc-effective-agent-principles-registry.md":
        aliases.append("EP Registry")
        aliases.append("Effective Principles")

    return aliases


# ---------------------------------------------------------------------------
# Frontmatter parsing and patching
# ---------------------------------------------------------------------------

FM_PATTERN = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)


def _parse_frontmatter(content):
    """
    Return (fm_text, body_text) or (None, content) if no frontmatter.
    fm_text includes the content between the --- delimiters (not the delimiters).
    """
    m = FM_PATTERN.match(content)
    if not m:
        return None, content
    fm_text = m.group(1)
    body_start = m.end()
    return fm_text, content[body_start:]


def _extract_existing_aliases(fm_text):
    """
    Parse existing aliases from frontmatter text.
    Supports:
        aliases: ["a", "b"]
        aliases: [a, b]
        aliases:
          - a
          - b
    Returns list of strings (stripped, unquoted).
    """
    # Inline list: aliases: ["a", "b"] or aliases: [a, b]
    inline = re.search(r"^aliases:\s*\[([^\]]*)\]", fm_text, re.MULTILINE)
    if inline:
        raw = inline.group(1)
        items = re.findall(r'"([^"]+)"|\'([^\']+)\'|([^\s,\[\]]+)', raw)
        result = []
        for groups in items:
            val = next(g for g in groups if g)
            result.append(val)
        return result

    # Block list:
    # aliases:
    #   - a
    block = re.search(r"^aliases:\s*\n((?:\s+-\s+.*\n?)+)", fm_text, re.MULTILINE)
    if block:
        lines = block.group(1).splitlines()
        result = []
        for line in lines:
            m2 = re.match(r"\s+-\s+(.+)", line)
            if m2:
                val = m2.group(1).strip().strip('"').strip("'")
                result.append(val)
        return result

    return []


def _build_aliases_line(aliases):
    """Build the YAML aliases line as a single inline list."""
    quoted = ['"{}"'.format(a.replace('"', '\\"')) for a in aliases]
    return "aliases: [{}]".format(", ".join(quoted))


def _patch_frontmatter(fm_text, new_aliases):
    """
    Add or replace the aliases: field in fm_text.
    Preserves all other fields and their order.
    Returns updated fm_text.
    """
    aliases_line = _build_aliases_line(new_aliases)

    # Replace existing aliases: block (inline or block form)
    # Try inline replacement first
    inline_re = re.compile(r"^aliases:\s*\[.*?\]", re.MULTILINE)
    if inline_re.search(fm_text):
        return inline_re.sub(aliases_line, fm_text)

    # Try block list replacement
    block_re = re.compile(r"^aliases:\s*\n(?:\s+-\s+.*\n?)+", re.MULTILINE)
    if block_re.search(fm_text):
        return block_re.sub(aliases_line + "\n", fm_text)

    # No existing aliases field — append at end
    if fm_text.endswith("\n"):
        return fm_text + aliases_line + "\n"
    return fm_text + "\n" + aliases_line + "\n"


def patch_file(path, new_aliases, dry_run=False):
    """
    Add/merge aliases into the file's frontmatter.
    Returns (action, merged_aliases) where action is 'skip'|'already_set'|'updated'.
    """
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    fm_text, body = _parse_frontmatter(content)

    if fm_text is None:
        return "no_frontmatter", []

    existing = _extract_existing_aliases(fm_text)
    merged = list(existing)
    for a in new_aliases:
        if a not in merged:
            merged.append(a)

    if set(merged) == set(existing) and len(merged) == len(existing):
        return "already_set", existing

    if not dry_run:
        new_fm = _patch_frontmatter(fm_text, merged)
        new_content = "---\n" + new_fm + "---\n" + body
        with open(path, "w", encoding="utf-8") as f:
            f.write(new_content)

    return "updated", merged


# ---------------------------------------------------------------------------
# File discovery
# ---------------------------------------------------------------------------

def discover_targets(repo_root):
    """
    Walk repo_root and yield (path, aliases) for each target file.
    Skips excluded dirs and files that derive no aliases.
    """
    for dirpath, dirnames, filenames in os.walk(repo_root):
        # Prune excluded top-level dirs in-place
        dirnames[:] = [
            d for d in dirnames
            if d not in EXCLUDED_DIRS
        ]

        # Also prune archive/ and drafts/ subdirs
        dirnames[:] = [
            d for d in dirnames
            if d not in ("archive", "drafts")
        ]

        for filename in filenames:
            if not filename.endswith(".md"):
                continue
            full_path = os.path.join(dirpath, filename)
            if _is_excluded(full_path, repo_root):
                continue
            aliases = derive_aliases(full_path, repo_root)
            if aliases:
                yield full_path, aliases


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Add aliases: to YAML frontmatter of target .md files."
    )
    parser.add_argument(
        "repo_root",
        nargs="?",
        default=os.getcwd(),
        help="Repo root directory (default: cwd)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Report what would change without modifying files",
    )
    args = parser.parse_args()

    repo_root = os.path.abspath(args.repo_root)
    dry_run = args.dry_run

    if dry_run:
        print("[dry-run] Scanning: {}".format(repo_root))
    else:
        print("Scanning: {}".format(repo_root))

    counts = {"updated": 0, "already_set": 0, "no_frontmatter": 0, "skipped": 0}

    for path, aliases in discover_targets(repo_root):
        rel = os.path.relpath(path, repo_root)
        action, result_aliases = patch_file(path, aliases, dry_run=dry_run)

        if action == "updated":
            counts["updated"] += 1
            tag = "[dry-run] WOULD UPDATE" if dry_run else "UPDATED"
            print("  {} {}".format(tag, rel))
            print("    aliases: {}".format(result_aliases))
        elif action == "already_set":
            counts["already_set"] += 1
            print("  OK (no change) {}".format(rel))
        elif action == "no_frontmatter":
            counts["no_frontmatter"] += 1
            print("  WARNING no frontmatter, skipping: {}".format(rel))

    print("")
    print("Summary:")
    print("  {} files would be updated".format(counts["updated"]) if dry_run else "  {} files updated".format(counts["updated"]))
    print("  {} files already have correct aliases".format(counts["already_set"]))
    print("  {} files skipped (no frontmatter)".format(counts["no_frontmatter"]))

    return 0


if __name__ == "__main__":
    sys.exit(main())
