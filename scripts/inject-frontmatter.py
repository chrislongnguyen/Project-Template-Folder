#!/usr/bin/env python3
# version: 1.0 | status: Draft | last_updated: 2026-04-01
"""
inject-frontmatter.py — Inject Vinh schema fields into _genesis/templates/*.md files.

Fields injected (if missing):
  type: template
  work_stream: <inferred from filename>
  stage: <inferred from filename>
  sub_system: (blank)

Usage:
  python3 inject-frontmatter.py <templates_dir> [--dry-run]
"""

import sys
import re
import os
from pathlib import Path

# Filename → (work_stream, stage) mapping
FILENAME_MAP = {
    "CHARTER_TEMPLATE": ("align", "design"),
    "ADR_TEMPLATE": ("align", "design"),
    "OKR_TEMPLATE": ("align", "design"),
    "VANA_SPEC_TEMPLATE": ("align", "design"),
    "FORCE_ANALYSIS_TEMPLATE": ("align", "design"),
    "RESEARCH_TEMPLATE": ("learn", "build"),
    "RESEARCH_METHODOLOGY": ("learn", "design"),
    "SPIKE_TEMPLATE": ("learn", "design"),
    "ARCHITECTURE_TEMPLATE": ("plan", "design"),
    "RISK_ENTRY_TEMPLATE": ("plan", "build"),
    "DRIVER_ENTRY_TEMPLATE": ("plan", "build"),
    "ROADMAP_TEMPLATE": ("plan", "build"),
    "TEST_PLAN_TEMPLATE": ("execute", "build"),
    "WIKI_PAGE_TEMPLATE": ("execute", "build"),
    "SOP_TEMPLATE": ("execute", "build"),
    "STANDUP_TEMPLATE": ("execute", "build"),
    "METRICS_BASELINE_TEMPLATE": ("improve", "build"),
    "RETRO_TEMPLATE": ("improve", "build"),
    "REVIEW_TEMPLATE": ("improve", "validate"),
    "REVIEW_PACKAGE_TEMPLATE": ("improve", "validate"),
    "FEEDBACK_TEMPLATE": ("improve", "build"),
    "DESIGN_TEMPLATE": ("govern", "design"),
    "DSBV_PROCESS": ("govern", "design"),
    "DSBV_CONTEXT_TEMPLATE": ("govern", "design"),
    "DSBV_EVAL_TEMPLATE": ("govern", "validate"),
    "GLOBAL_CLAUDE_MD_EXAMPLE": ("govern", "design"),
}


def infer_fields(stem: str) -> tuple[str, str]:
    """Return (work_stream, stage) for a filename stem."""
    return FILENAME_MAP.get(stem, ("genesis", "design"))


def parse_frontmatter(content: str) -> tuple[dict, str, str]:
    """
    Returns (fields_dict, frontmatter_block, body_after_frontmatter).
    fields_dict keys are field names; values are raw value strings (including quotes).
    Returns empty dict + empty string + full content if no frontmatter found.
    """
    if not content.startswith("---"):
        return {}, "", content
    end = content.find("\n---", 3)
    if end == -1:
        return {}, "", content
    fm_block = content[3:end].strip()
    body = content[end + 4:]  # skip \n---
    fields = {}
    for line in fm_block.splitlines():
        m = re.match(r'^(\w+)\s*:\s*(.*)', line)
        if m:
            fields[m.group(1)] = m.group(2)
    return fields, fm_block, body


def build_frontmatter(fields: dict) -> str:
    """Reconstruct frontmatter block from ordered fields dict."""
    lines = []
    for k, v in fields.items():
        lines.append(f"{k}: {v}")
    return "---\n" + "\n".join(lines) + "\n---"


def inject(path: Path, dry_run: bool) -> bool:
    """Inject missing fields. Returns True if file was (or would be) modified."""
    content = path.read_text(encoding="utf-8")
    fields, fm_block, body = parse_frontmatter(content)

    if not fm_block and not content.startswith("---"):
        # No frontmatter — skip
        return False

    stem = path.stem
    work_stream, stage = infer_fields(stem)

    needs_update = False
    if "type" not in fields:
        fields["type"] = "template"
        needs_update = True
    if "work_stream" not in fields:
        fields["work_stream"] = work_stream
        needs_update = True
    if "stage" not in fields:
        fields["stage"] = stage
        needs_update = True
    if "sub_system" not in fields:
        fields["sub_system"] = ""
        needs_update = True

    if not needs_update:
        return False

    new_fm = build_frontmatter(fields)
    new_content = new_fm + body

    if dry_run:
        print(f"  [DRY-RUN] Would update: {path.name}")
        added = [k for k in ("type", "work_stream", "stage", "sub_system") if k not in parse_frontmatter(content)[0]]
        print(f"    Adding fields: {added}")
    else:
        path.write_text(new_content, encoding="utf-8")
        print(f"  Updated: {path.name}")

    return True


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <templates_dir> [--dry-run]")
        sys.exit(1)

    templates_dir = Path(sys.argv[1])
    dry_run = "--dry-run" in sys.argv

    if not templates_dir.is_dir():
        print(f"ERROR: {templates_dir} is not a directory")
        sys.exit(1)

    skip = {"README.md"}
    modified = 0
    skipped = 0

    for md_file in sorted(templates_dir.glob("*.md")):
        if md_file.name in skip:
            skipped += 1
            continue
        changed = inject(md_file, dry_run)
        if changed:
            modified += 1

    action = "Would modify" if dry_run else "Modified"
    print(f"\n{action} {modified} file(s). Skipped {skipped} file(s).")


if __name__ == "__main__":
    main()
