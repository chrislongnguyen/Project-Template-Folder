# version: 1.1 | status: Draft | last_updated: 2026-03-31
"""
obsidian-autolinker.py — 3-phase engine: DISCOVER → SCAN → WRITE
Converts plain-text cross-references into [[wikilinks]] via ## Links sections.

Usage:
    python3 scripts/obsidian-autolinker.py [repo_root] [--dry-run] [--files FILE1 FILE2 ...]

Phases:
    1. DISCOVER: Build target_map = {alias: file_path} from aliases, filenames, content IDs
    2. SCAN:     Match each .md file's content against target_map, produce link_map
    3. WRITE:    Append/replace ## Links sections (always last section in file)

Properties:
    - Idempotent: running twice produces identical output
    - No self-references in any ## Links section
    - Aliases <= 2 chars are skipped (false-positive prevention)
    - No external dependencies (stdlib only)
    - Excludes: .git/, .worktrees/, .claude/worktrees/, .obsidian/
"""

import argparse
import os
import re
import sys

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

EXCLUDED_DIRS = {".git", ".worktrees", ".obsidian"}
EXCLUDED_PATH_FRAGMENTS = [
    os.sep + ".claude" + os.sep + "worktrees" + os.sep,
]

# Minimum alias length to avoid false positives
MIN_ALIAS_LEN = 3

# ID patterns to discover from file content
ID_PATTERNS = [
    r"ADR-\d+",
    r"UBS-\d+",
    r"UDS-\d+",
    r"EP-\d+",
    r"AP\d+",
]

# Section marker
LINKS_HEADER = "## Links"


# ---------------------------------------------------------------------------
# Exclusion helpers (reuse pattern from alias-seeder)
# ---------------------------------------------------------------------------

def _is_excluded(path, repo_root):
    """Return True if path should be skipped."""
    rel = os.path.relpath(path, repo_root)
    parts = rel.split(os.sep)

    if parts[0] in EXCLUDED_DIRS:
        return True

    norm = os.sep + rel + os.sep
    for fragment in EXCLUDED_PATH_FRAGMENTS:
        if fragment in norm:
            return True

    return False


# ---------------------------------------------------------------------------
# Phase 1: DISCOVER
# ---------------------------------------------------------------------------

FM_PATTERN = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)


def _parse_frontmatter_text(content):
    """Return fm_text or None if no frontmatter."""
    m = FM_PATTERN.match(content)
    if not m:
        return None
    return m.group(1)


def _extract_manual_links_from_fm(fm_text):
    """
    Parse manual_links: field from frontmatter text.
    Supports inline ["a", "b"] form only (same format as aliases:).
    Returns list of strings, or [] if field is absent.

    Format:
        manual_links: ["UBS UDS GUIDE", "Learning Hierarchy"]
    """
    if fm_text is None:
        return []
    inline = re.search(r"^manual_links:\s*\[([^\]]*)\]", fm_text, re.MULTILINE)
    if inline:
        raw = inline.group(1)
        items = re.findall(r'"([^"]+)"|\'([^\']+)\'|([^\s,\[\]]+)', raw)
        result = []
        for groups in items:
            val = next((g for g in groups if g), None)
            if val:
                result.append(val)
        return result
    return []


def _extract_aliases_from_fm(fm_text):
    """
    Parse aliases: field from frontmatter text.
    Supports inline [a, b] and block list forms.
    Returns list of strings.
    """
    # Inline: aliases: ["a", "b"] or aliases: [a, b]
    inline = re.search(r"^aliases:\s*\[([^\]]*)\]", fm_text, re.MULTILINE)
    if inline:
        raw = inline.group(1)
        items = re.findall(r'"([^"]+)"|\'([^\']+)\'|([^\s,\[\]]+)', raw)
        result = []
        for groups in items:
            val = next((g for g in groups if g), None)
            if val:
                result.append(val)
        return result

    # Block list:
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


def _extract_ids_from_content(content):
    """Extract ID pattern strings (ADR-001, UBS-003, etc.) from file content."""
    ids = []
    for pattern in ID_PATTERNS:
        matches = re.findall(pattern, content)
        ids.extend(matches)
    return list(set(ids))


def discover_targets(repo_root):
    """
    Phase 1: Build target_map = {alias_lower_or_exact: (canonical_alias, file_path)}

    Priority for collision resolution:
      1. explicit aliases: from frontmatter (highest)
      2. filename stem (implicit alias)
      3. content ID patterns (lowest)

    Returns:
      target_map: {alias_key: (canonical_alias, abs_path)}
        - For case-insensitive aliases (names): key = alias.lower()
        - For ID aliases: key = alias (exact, case-sensitive)
      id_set: set of alias strings that are IDs (case-sensitive matching)
    """
    # Priority buckets: 1=frontmatter, 2=filename, 3=content
    # Store as {alias_key: (priority, canonical_alias, path)}
    staging = {}

    # Track which aliases are IDs (for case-sensitive scanning)
    id_aliases = set()

    all_md_files = []
    for dirpath, dirnames, filenames in os.walk(repo_root):
        dirnames[:] = [d for d in dirnames if d not in EXCLUDED_DIRS]
        for filename in filenames:
            if not filename.endswith(".md"):
                continue
            full_path = os.path.join(dirpath, filename)
            if _is_excluded(full_path, repo_root):
                continue
            all_md_files.append(full_path)

    for path in all_md_files:
        try:
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
        except (IOError, OSError):
            continue

        stem = os.path.splitext(os.path.basename(path))[0]

        # --- Priority 1: frontmatter aliases ---
        fm_text = _parse_frontmatter_text(content)
        if fm_text:
            for alias in _extract_aliases_from_fm(fm_text):
                alias = alias.strip()
                if len(alias) <= MIN_ALIAS_LEN - 1:
                    continue
                key = alias.lower()
                existing = staging.get(key)
                if existing is None or existing[0] > 1:
                    staging[key] = (1, alias, path)

        # --- Priority 2: filename stem ---
        if len(stem) >= MIN_ALIAS_LEN:
            key = stem.lower()
            existing = staging.get(key)
            if existing is None or existing[0] > 2:
                staging[key] = (2, stem, path)

        # --- Priority 3: content IDs ---
        for id_str in _extract_ids_from_content(content):
            if len(id_str) < MIN_ALIAS_LEN:
                continue
            key = id_str  # IDs are case-sensitive — use exact string as key
            existing = staging.get(key)
            if existing is None or existing[0] > 3:
                staging[key] = (3, id_str, path)
                id_aliases.add(id_str)

    # Build final target_map: {key: (canonical_alias, path)}
    target_map = {key: (v[1], v[2]) for key, v in staging.items()}

    return target_map, id_aliases


# ---------------------------------------------------------------------------
# Phase 2: SCAN
# ---------------------------------------------------------------------------

def _content_above_links(content):
    """Return content above ## Links section (or full content if no section)."""
    # Find ## Links as a section header (at line start)
    m = re.search(r"^## Links\s*$", content, re.MULTILINE)
    if m:
        return content[: m.start()]
    return content


def _build_alias_regex(alias, is_id):
    """Build compiled regex for an alias. IDs are case-sensitive, names are not."""
    escaped = re.escape(alias)
    # Word boundary: \b works for alphanumeric. For IDs with hyphens, use lookaround.
    pattern = r"(?<![A-Za-z0-9\-_])" + escaped + r"(?![A-Za-z0-9\-_])"
    flags = 0 if is_id else re.IGNORECASE
    return re.compile(pattern, flags)


def scan_sources(repo_root, target_map, id_aliases, specific_files=None):
    """
    Phase 2: Scan .md files and build link_map = {source_path: [canonical_aliases]}.

    specific_files: if provided, only scan those paths (still uses full target_map).
    """
    # Pre-compile regexes for all aliases
    compiled = {}
    for key, (canonical, _) in target_map.items():
        is_id = key in id_aliases
        compiled[key] = (canonical, _build_alias_regex(canonical if not is_id else key, is_id))

    if specific_files is not None:
        source_files = [os.path.abspath(p) for p in specific_files]
    else:
        source_files = []
        for dirpath, dirnames, filenames in os.walk(repo_root):
            dirnames[:] = [d for d in dirnames if d not in EXCLUDED_DIRS]
            for filename in filenames:
                if not filename.endswith(".md"):
                    continue
                full_path = os.path.join(dirpath, filename)
                if _is_excluded(full_path, repo_root):
                    continue
                source_files.append(full_path)

    link_map = {}

    for path in source_files:
        try:
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
        except (IOError, OSError):
            continue

        scan_content = _content_above_links(content)

        # Determine this file's own aliases to exclude (self-reference prevention)
        stem = os.path.splitext(os.path.basename(path))[0]
        self_keys = set()
        fm_text = _parse_frontmatter_text(content)
        if fm_text:
            for alias in _extract_aliases_from_fm(fm_text):
                self_keys.add(alias.lower())
        self_keys.add(stem.lower())
        # Also add exact-case stem for ID matching
        self_keys.add(stem)

        found_canonicals = set()
        for key, (canonical, regex) in compiled.items():
            # Skip self-references
            canonical_key = canonical.lower() if key not in id_aliases else key
            if canonical_key in self_keys:
                continue
            # Also skip if the target file IS this file
            _, target_path = target_map[key]
            if os.path.abspath(target_path) == os.path.abspath(path):
                continue

            if regex.search(scan_content):
                found_canonicals.add(canonical)

        if found_canonicals:
            link_map[path] = sorted(found_canonicals)

    return link_map


# ---------------------------------------------------------------------------
# Phase 3: WRITE
# ---------------------------------------------------------------------------

def _build_links_section(aliases):
    """Build the ## Links section text."""
    lines = [LINKS_HEADER, ""]
    for alias in aliases:
        lines.append("- [[{}]]".format(alias))
    return "\n".join(lines)


def _strip_existing_links_section(content):
    """
    Remove existing ## Links section (from header to next ## or EOF).
    Also strips trailing blank lines left after removal.
    Returns content without ## Links section.
    """
    # Match ## Links through next ## heading or end of file
    pattern = re.compile(
        r"\n## Links\s*\n.*?(?=\n## |\Z)",
        re.DOTALL,
    )
    stripped = pattern.sub("", content)
    # Strip trailing whitespace/newlines from the file body
    stripped = stripped.rstrip()
    return stripped


def write_links(path, aliases, dry_run=False):
    """
    Write ## Links section to file. Replaces existing section if present.
    Merges manual_links: from the file's own frontmatter before writing.
    Returns (action, message) where action is 'updated'|'unchanged'|'error'.
    """
    try:
        with open(path, "r", encoding="utf-8") as f:
            original = f.read()
    except (IOError, OSError) as e:
        return "error", str(e)

    # Merge manual_links from this file's own frontmatter
    fm_text = _parse_frontmatter_text(original)
    manual = _extract_manual_links_from_fm(fm_text)
    if manual:
        merged = list(aliases)
        for m in manual:
            if m not in merged:
                merged.append(m)
        aliases = sorted(merged)

    # Nothing to write if no links at all
    if not aliases:
        return "unchanged", path

    # Build new links section
    links_block = _build_links_section(aliases)

    # Strip existing ## Links section
    base_content = _strip_existing_links_section(original)

    # Assemble new content: base + blank line + links section
    new_content = base_content + "\n\n" + links_block + "\n"

    if new_content == original:
        return "unchanged", path

    if not dry_run:
        try:
            with open(path, "w", encoding="utf-8") as f:
                f.write(new_content)
        except (IOError, OSError) as e:
            return "error", str(e)

    return "updated", path


# ---------------------------------------------------------------------------
# Reporting helpers
# ---------------------------------------------------------------------------

def _rel(path, repo_root):
    return os.path.relpath(path, repo_root)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="3-phase auto-linker: DISCOVER → SCAN → WRITE [[wikilinks]]"
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
        help="Print proposed changes without modifying files",
    )
    parser.add_argument(
        "--files",
        nargs="*",
        metavar="FILE",
        help="Only scan/write these files (still discovers from full repo)",
    )
    args = parser.parse_args()

    repo_root = os.path.abspath(args.repo_root)
    dry_run = args.dry_run
    specific_files = args.files if args.files else None

    prefix = "[dry-run] " if dry_run else ""
    print("{}obsidian-autolinker — repo: {}".format(prefix, repo_root))

    # -------------------------------------------------------------------------
    # Phase 1: DISCOVER
    # -------------------------------------------------------------------------
    print("\n-- Phase 1: DISCOVER --")
    target_map, id_aliases = discover_targets(repo_root)
    print("  {} targets discovered ({} are ID aliases)".format(
        len(target_map), len(id_aliases)
    ))

    if dry_run:
        # Print sample targets (first 20)
        sample = list(target_map.items())[:20]
        for key, (canonical, path) in sample:
            print("  alias '{}' -> {}".format(canonical, _rel(path, repo_root)))
        if len(target_map) > 20:
            print("  ... and {} more".format(len(target_map) - 20))

    # -------------------------------------------------------------------------
    # Phase 2: SCAN
    # -------------------------------------------------------------------------
    print("\n-- Phase 2: SCAN --")
    link_map = scan_sources(repo_root, target_map, id_aliases, specific_files)
    print("  {} files have references to link".format(len(link_map)))

    if dry_run:
        for path, aliases in sorted(link_map.items()):
            print("  {} -> {}".format(_rel(path, repo_root), aliases))

    # -------------------------------------------------------------------------
    # Phase 3: WRITE
    # Collect write targets: all files in link_map PLUS any file that has
    # manual_links: in its frontmatter but no body-text matches (so it
    # doesn't appear in link_map yet).
    # -------------------------------------------------------------------------
    print("\n-- Phase 3: WRITE --")
    counts = {"updated": 0, "unchanged": 0, "error": 0}

    # Build full write set: link_map entries + manual_links-only files
    write_map = dict(link_map)  # {path: [aliases from body scan]}

    # Discover files with manual_links that may not be in link_map
    scan_roots = [specific_files] if specific_files else None
    _scan_files = []
    if specific_files is not None:
        _scan_files = [os.path.abspath(p) for p in specific_files]
    else:
        for dirpath, dirnames, filenames in os.walk(repo_root):
            dirnames[:] = [d for d in dirnames if d not in EXCLUDED_DIRS]
            for filename in filenames:
                if not filename.endswith(".md"):
                    continue
                full_path = os.path.join(dirpath, filename)
                if _is_excluded(full_path, repo_root):
                    continue
                _scan_files.append(full_path)

    for path in _scan_files:
        if path in write_map:
            continue  # already handled via link_map
        try:
            with open(path, "r", encoding="utf-8") as f:
                content = f.read()
        except (IOError, OSError):
            continue
        fm_text = _parse_frontmatter_text(content)
        if fm_text and _extract_manual_links_from_fm(fm_text):
            write_map[path] = []  # no body-text aliases; manual_links will be merged in write_links

    for path, aliases in sorted(write_map.items()):
        action, msg = write_links(path, aliases, dry_run=dry_run)
        counts[action] = counts.get(action, 0) + 1
        if action == "updated":
            tag = "{}WOULD UPDATE".format(prefix) if dry_run else "UPDATED"
            print("  {} {}".format(tag, _rel(path, repo_root)))
        elif action == "error":
            print("  ERROR {} — {}".format(_rel(path, repo_root), msg))

    print("\nSummary:")
    if dry_run:
        print("  {} files would be updated".format(counts.get("updated", 0)))
    else:
        print("  {} files updated".format(counts.get("updated", 0)))
    print("  {} files unchanged (already correct)".format(counts.get("unchanged", 0)))
    print("  {} errors".format(counts.get("error", 0)))

    return 0


if __name__ == "__main__":
    sys.exit(main())
