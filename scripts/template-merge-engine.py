#!/usr/bin/env python3
# version: 1.0 | status: draft | last_updated: 2026-04-12
"""
template-merge-engine.py — Section-merge and 3-way merge engine for template sync.

Sub-commands:
  section-merge   Merge CLAUDE.md using heading-level section ownership rules.
  3-way-merge     Delegate to git merge-file for JSON/gitignore 3-way merge.

Usage:
  python3 scripts/template-merge-engine.py section-merge \\
    --user-file CLAUDE.md \\
    --template-new /tmp/template-new-CLAUDE.md \\
    --manifest _genesis/template-manifest.yml \\
    --output /tmp/merged-CLAUDE.md

  python3 scripts/template-merge-engine.py 3-way-merge \\
    --base /tmp/base.txt \\
    --ours /tmp/ours.txt \\
    --theirs /tmp/theirs.txt \\
    --output /tmp/merged.txt

Exit codes:
  0  — clean (section-merge always exits 0; 3-way-merge exits 0 for clean merge)
  1  — conflict markers present (3-way-merge only)
  2  — error (bad args, missing file, git error)
"""

import argparse
import subprocess
import sys
from pathlib import Path

try:
    import yaml
except ImportError:
    yaml = None  # handled at call site with graceful error


# ---------------------------------------------------------------------------
# Section splitting — fence-aware
# ---------------------------------------------------------------------------

def split_sections(text: str) -> list[dict]:
    """Split markdown text into sections on '## ' headings.

    Lines starting with '## ' inside a fenced code block (between ``` delimiters)
    are NOT treated as section boundaries (fence_open guard — BUG-B upstream fix).

    Returns a list of dicts: [{"heading": str, "body": str}, ...]
    The first element always has heading "__preamble__" and contains everything
    before the first '## ' heading.
    """
    sections: list[dict] = []
    current_heading: str = "__preamble__"
    current_body: list[str] = []
    fence_open: bool = False

    for line in text.splitlines(keepends=True):
        # Toggle fence state on lines that start with ```
        # (handles both ``` and ```python etc.)
        if line.startswith("```"):
            fence_open = not fence_open

        if not fence_open and line.startswith("## "):
            # Close previous section
            sections.append({"heading": current_heading, "body": "".join(current_body)})
            current_heading = line.rstrip()
            current_body = []
        else:
            current_body.append(line)

    # Close final section
    sections.append({"heading": current_heading, "body": "".join(current_body)})
    return sections


def reconstruct(sections: list[dict]) -> str:
    """Reassemble sections into a single string."""
    parts: list[str] = []
    for sec in sections:
        if sec["heading"] == "__preamble__":
            parts.append(sec["body"])
        else:
            # heading line + newline + body
            parts.append(sec["heading"] + "\n" + sec["body"])
    return "".join(parts)


# ---------------------------------------------------------------------------
# Classification — prefix match (BUG-B fix)
# ---------------------------------------------------------------------------

def classify_heading(heading: str, template_owned: list[str], user_owned: list[str]) -> str:
    """Classify a section heading using prefix matching.

    Returns "template", "user", or "unclassified".
    Prefix matching (startswith) rather than equality handles headings that carry
    "(full spec: ...)" or "(automated: ...)" suffixes in live files.
    """
    for entry in template_owned:
        if heading.startswith(entry):
            return "template"
    for entry in user_owned:
        if heading.startswith(entry):
            return "user"
    return "unclassified"


# ---------------------------------------------------------------------------
# Anchor — nearest preceding template section in user_current
# ---------------------------------------------------------------------------

def compute_anchor(
    user_section_heading: str,
    user_sections: list[dict],
    template_owned: list[str],
    user_owned: list[str],
) -> str | None:
    """Find the nearest preceding TEMPLATE section heading for a USER section.

    Scans user_sections in order; for each USER section, the anchor is the
    last TEMPLATE section seen before it.  Returns None if the USER section
    precedes all TEMPLATE sections.
    """
    last_template_heading: str | None = None
    for sec in user_sections:
        h = sec["heading"]
        if h == "__preamble__":
            continue
        cls = classify_heading(h, template_owned, user_owned)
        if cls == "template":
            last_template_heading = h
        if h == user_section_heading:
            return last_template_heading
    return None


# ---------------------------------------------------------------------------
# Core section_merge
# ---------------------------------------------------------------------------

def section_merge(
    user_file: str,
    template_new_file: str,
    manifest_file: str,
    output_file: str,
) -> int:
    """Merge user_file with template_new_file using section ownership from manifest.

    Algorithm (from DESIGN.md §3.3):
      1. Load manifest merge_sections for the file.
      2. Split both files into sections.
      3. Classify each section.
      4. Assemble output: template sections in template_new order,
         user sections interleaved at nearest anchor point.
      5. Write output.

    Always returns 0 (section-merge never produces conflict markers).
    """
    # --- load manifest ---
    if yaml is None:
        print("ERROR: PyYAML not installed. Install with: pip3 install pyyaml", file=sys.stderr)
        return 2

    manifest_path = Path(manifest_file)
    if not manifest_path.exists():
        print(f"ERROR: manifest not found: {manifest_file}", file=sys.stderr)
        return 2

    with open(manifest_path, "r", encoding="utf-8") as fh:
        manifest_data = yaml.safe_load(fh)

    # Locate the shared entry for the user file (match by basename)
    user_basename = Path(user_file).name
    merge_sections_cfg: dict | None = None
    shared_entries = manifest_data.get("files", {}).get("shared", {}).get("entries", [])
    for entry in shared_entries:
        if Path(entry.get("path", "")).name == user_basename:
            merge_sections_cfg = entry.get("merge_sections")
            break

    if merge_sections_cfg is None:
        print(
            f"ERROR: no merge_sections config found for '{user_basename}' in manifest",
            file=sys.stderr,
        )
        return 2

    template_owned: list[str] = merge_sections_cfg.get("template_owned", [])
    user_owned: list[str] = merge_sections_cfg.get("user_owned", [])

    # --- read files ---
    for path_str in (user_file, template_new_file):
        if not Path(path_str).exists():
            print(f"ERROR: file not found: {path_str}", file=sys.stderr)
            return 2

    user_text = Path(user_file).read_text(encoding="utf-8")
    template_new_text = Path(template_new_file).read_text(encoding="utf-8")

    # --- split ---
    user_sections = split_sections(user_text)
    template_sections = split_sections(template_new_text)

    # --- classify ---
    # template_sections: classify each non-preamble heading
    # Case c: section in template_new not in either list → TEMPLATE (default)
    def classify_t(sec: dict) -> str:
        h = sec["heading"]
        if h == "__preamble__":
            return "preamble"
        cls = classify_heading(h, template_owned, user_owned)
        if cls == "unclassified":
            return "template"  # case c: new template section → template_owned
        return cls

    # user_sections: classify each non-preamble heading
    # Case d: section in user_current not in either list → USER (preserved)
    def classify_u(sec: dict) -> str:
        h = sec["heading"]
        if h == "__preamble__":
            return "preamble"
        cls = classify_heading(h, template_owned, user_owned)
        if cls == "unclassified":
            return "user"  # case d: user-added section → preserved
        return cls

    # --- build ordered lists ---
    # Preamble: take from template_new (template owns structure)
    preamble_sections = [s for s in template_sections if s["heading"] == "__preamble__"]

    template_order: list[dict] = [s for s in template_sections if classify_t(s) == "template"]
    user_order: list[dict] = [s for s in user_sections if classify_u(s) == "user"]

    # --- assemble output ---
    # Build a lookup: for each user section, what is its anchor?
    user_anchors: dict[str, str | None] = {}
    for u_sec in user_order:
        user_anchors[u_sec["heading"]] = compute_anchor(
            u_sec["heading"], user_sections, template_owned, user_owned
        )

    output_sections: list[dict] = []
    appended_user: set[str] = set()

    # 1. Preamble
    output_sections.extend(preamble_sections)

    # 2. Insert user sections whose anchor is None (placed before all template sections in
    #    user_current).  These come first, preserving their relative user order.
    for u_sec in user_order:
        if user_anchors[u_sec["heading"]] is None:
            output_sections.append(u_sec)
            appended_user.add(u_sec["heading"])

    # 3. Walk template order, inserting user sections at their anchor
    for t_sec in template_order:
        output_sections.append(t_sec)
        for u_sec in user_order:
            if u_sec["heading"] not in appended_user:
                anchor = user_anchors[u_sec["heading"]]
                # Normalize anchor comparison: compare rstripped headings
                t_heading_norm = t_sec["heading"].rstrip()
                # anchor may carry "(full spec: ...)" suffix — compare normalized
                if anchor is not None and anchor.rstrip() == t_heading_norm:
                    output_sections.append(u_sec)
                    appended_user.add(u_sec["heading"])

    # 4. Append any user sections not yet placed (anchor existed in user_current but
    #    that template section was removed from template_new).
    for u_sec in user_order:
        if u_sec["heading"] not in appended_user:
            output_sections.append(u_sec)
            appended_user.add(u_sec["heading"])

    # --- write ---
    merged_text = reconstruct(output_sections)
    Path(output_file).write_text(merged_text, encoding="utf-8")
    return 0


# ---------------------------------------------------------------------------
# 3-way merge via git merge-file
# ---------------------------------------------------------------------------

def three_way_merge(
    base_file: str,
    ours_file: str,
    theirs_file: str,
    output_file: str,
) -> int:
    """Delegate to git merge-file for 3-way merge.

    Semantics:
      base   = old template version (common ancestor)
      ours   = user current (what user has)
      theirs = new template version (what we want to bring in)

    git merge-file -p theirs base ours > output
      Exit 0 = clean merge
      Exit 1 = conflict markers inserted
      Exit 2 = error

    Returns the git merge-file exit code.
    """
    for path_str in (base_file, ours_file, theirs_file):
        if not Path(path_str).exists():
            print(f"ERROR: file not found: {path_str}", file=sys.stderr)
            return 2

    result = subprocess.run(
        ["git", "merge-file", "-p", theirs_file, base_file, ours_file],
        capture_output=True,
        text=True,
    )

    # git merge-file exits 0 (clean), 1 (conflict), or negative/2 (error)
    rc = result.returncode
    if rc < 0 or rc > 1:
        print(f"ERROR: git merge-file failed (exit {rc}): {result.stderr}", file=sys.stderr)
        return 2

    with open(output_file, "w", encoding="utf-8") as fh:
        fh.write(result.stdout)

    if rc == 1:
        print(
            f"WARNING: conflicts detected in {output_file} — resolve manually",
            file=sys.stderr,
        )

    return rc


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="template-merge-engine",
        description="Section-merge and 3-way merge engine for LTC template sync.",
    )
    subparsers = parser.add_subparsers(dest="command", metavar="COMMAND")
    subparsers.required = True

    # section-merge
    sm = subparsers.add_parser(
        "section-merge",
        help="Merge a shared file (e.g. CLAUDE.md) using heading-level ownership rules.",
    )
    sm.add_argument("--user-file", required=True, help="User's current file.")
    sm.add_argument("--template-new", required=True, help="New template version of the file.")
    sm.add_argument("--manifest", required=True, help="Path to template-manifest.yml.")
    sm.add_argument("--output", required=True, help="Output path for merged file.")

    # 3-way-merge
    tw = subparsers.add_parser(
        "3-way-merge",
        help="3-way merge via git merge-file (for .claude/settings.json, .gitignore).",
    )
    tw.add_argument("--base", required=True, help="Base file (old template, common ancestor).")
    tw.add_argument("--ours", required=True, help="Ours file (user current).")
    tw.add_argument("--theirs", required=True, help="Theirs file (new template).")
    tw.add_argument("--output", required=True, help="Output path for merged file.")

    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    if args.command == "section-merge":
        return section_merge(
            user_file=args.user_file,
            template_new_file=args.template_new,
            manifest_file=args.manifest,
            output_file=args.output,
        )

    if args.command == "3-way-merge":
        return three_way_merge(
            base_file=args.base,
            ours_file=args.ours,
            theirs_file=args.theirs,
            output_file=args.output,
        )

    # Should never reach here — argparse guards this
    print(f"ERROR: unknown command: {args.command}", file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main())
