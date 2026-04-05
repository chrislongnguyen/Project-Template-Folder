#!/usr/bin/env python3
"""
validate-blueprint.py — Post-population validation for LTC Project Template.

Checks:
1. Every file in subsystem dirs has required frontmatter
2. work_stream matches L1 path, sub_system matches L2 path
3. Filenames follow {sub}-{name}.md pattern
4. No files remain in old category dirs
5. No orphan .gitkeep in populated dirs
6. DSBV phase files exist per workstream
"""

import os
import re
import sys
from pathlib import Path

PASS = 0
WARN = 0
FAIL = 0

WORKSTREAMS = ["1-ALIGN", "2-LEARN", "3-PLAN", "4-EXECUTE", "5-IMPROVE"]
SUBSYSTEMS = ["1-PD", "2-DP", "3-DA", "4-IDM", "_cross"]
SUBSYSTEM_PREFIXES = {"1-PD": "pd-", "2-DP": "dp-", "3-DA": "da-", "4-IDM": "idm-", "_cross": "cross-"}

REQUIRED_FM = ["version", "status", "last_updated", "work_stream", "sub_system"]
S2_STATUS = {"draft", "in-progress", "in-review", "validated", "archived"}

OLD_DIRS = [
    "1-ALIGN/charter", "1-ALIGN/decisions", "1-ALIGN/okrs",
    "2-LEARN/input", "2-LEARN/output", "2-LEARN/research", "2-LEARN/specs",
    "3-PLAN/architecture", "3-PLAN/risks", "3-PLAN/drivers", "3-PLAN/roadmap",
    "5-IMPROVE/changelog", "5-IMPROVE/metrics", "5-IMPROVE/retrospectives",
    "5-IMPROVE/reviews", "5-IMPROVE/risk-log",
]


def check(condition, msg, severity="FAIL"):
    global PASS, WARN, FAIL
    if condition:
        PASS += 1
        return True
    else:
        if severity == "WARN":
            WARN += 1
            print(f"  ⚠ WARN: {msg}")
        else:
            FAIL += 1
            print(f"  ✗ FAIL: {msg}")
        return False


def parse_frontmatter(filepath):
    """Extract frontmatter dict from a markdown file."""
    try:
        with open(filepath, "r", errors="replace") as f:
            content = f.read()
    except Exception:
        return None

    match = re.match(r"^---\s*\n(.*?)\n---", content, re.DOTALL)
    if not match:
        return None

    fm = {}
    for line in match.group(1).split("\n"):
        if ":" in line:
            key, _, val = line.partition(":")
            fm[key.strip()] = val.strip().strip('"').strip("'")
    return fm


def validate_subsystem_files():
    """Check every .md in subsystem dirs."""
    print("\n=== CHECK 1: Subsystem file frontmatter ===\n")

    for ws in WORKSTREAMS:
        subs = SUBSYSTEMS if ws != "4-EXECUTE" else [s for s in SUBSYSTEMS if s != "_cross"]
        for sub in subs:
            dirpath = os.path.join(ws, sub)
            if not os.path.isdir(dirpath):
                check(False, f"Missing dir: {dirpath}")
                continue

            for fname in os.listdir(dirpath):
                if not fname.endswith(".md"):
                    continue

                fpath = os.path.join(dirpath, fname)
                fm = parse_frontmatter(fpath)

                # Check frontmatter exists
                if not check(fm is not None, f"{fpath}: no frontmatter"):
                    continue

                # Check required fields
                for field in REQUIRED_FM:
                    check(field in fm, f"{fpath}: missing '{field}'")

                if fm:
                    # Check work_stream matches path
                    check(
                        fm.get("work_stream") == ws,
                        f"{fpath}: work_stream={fm.get('work_stream')}, expected {ws}"
                    )
                    # Check sub_system matches path
                    check(
                        fm.get("sub_system") == sub,
                        f"{fpath}: sub_system={fm.get('sub_system')}, expected {sub}"
                    )
                    # Check status is S2
                    status = fm.get("status", "")
                    check(
                        status in S2_STATUS,
                        f"{fpath}: status='{status}' not in S2 vocabulary",
                        severity="WARN"
                    )


def validate_naming():
    """Check filenames follow {sub}-{name}.md pattern."""
    print("\n=== CHECK 2: File naming patterns ===\n")

    for ws in WORKSTREAMS:
        if ws == "4-EXECUTE":
            continue  # EXECUTE has code files, different rules
        subs = SUBSYSTEMS
        for sub in subs:
            dirpath = os.path.join(ws, sub)
            if not os.path.isdir(dirpath):
                continue

            prefix = SUBSYSTEM_PREFIXES.get(sub, "")
            for fname in os.listdir(dirpath):
                if fname in ("README.md", "DESIGN.md", "SEQUENCE.md", "VALIDATE.md", ".gitkeep"):
                    continue
                if not fname.endswith(".md"):
                    continue

                check(
                    fname.startswith(prefix) or fname == "filesystem-blueprint.md",
                    f"{os.path.join(dirpath, fname)}: should start with '{prefix}'",
                    severity="WARN"
                )


def validate_old_dirs():
    """Check no files remain in old category dirs."""
    print("\n=== CHECK 3: Old dirs cleaned ===\n")

    for old_dir in OLD_DIRS:
        if os.path.exists(old_dir):
            files = []
            for root, dirs, fnames in os.walk(old_dir):
                for f in fnames:
                    if f != ".gitkeep":
                        files.append(os.path.join(root, f))
            if files:
                check(False, f"{old_dir}: still has {len(files)} files: {files[:3]}")
            else:
                check(False, f"{old_dir}: empty dir still exists (should be deleted)", severity="WARN")
        else:
            check(True, "")


def validate_gitkeep():
    """Check no orphan .gitkeep in dirs with content."""
    print("\n=== CHECK 4: No orphan .gitkeep ===\n")

    for ws in WORKSTREAMS:
        subs = SUBSYSTEMS if ws != "4-EXECUTE" else [s for s in SUBSYSTEMS if s != "_cross"]
        for sub in subs:
            dirpath = os.path.join(ws, sub)
            gitkeep = os.path.join(dirpath, ".gitkeep")
            if os.path.exists(gitkeep):
                other = [f for f in os.listdir(dirpath) if f != ".gitkeep"]
                check(
                    len(other) == 0,
                    f"{gitkeep}: dir has {len(other)} other files — .gitkeep is orphan",
                    severity="WARN"
                )


def validate_dsbv():
    """Check DSBV phase files exist."""
    print("\n=== CHECK 5: DSBV phase files ===\n")

    for ws in WORKSTREAMS:
        # Workstream-root DSBV files
        for phase in ["DESIGN.md", "SEQUENCE.md"]:
            fpath = os.path.join(ws, phase)
            check(os.path.exists(fpath), f"Missing {fpath}")

        # Subsystem DSBV (not for EXECUTE)
        if ws == "4-EXECUTE":
            continue
        for sub in ["1-PD", "2-DP", "3-DA", "4-IDM"]:
            for phase in ["DESIGN.md", "SEQUENCE.md"]:
                fpath = os.path.join(ws, sub, phase)
                check(os.path.exists(fpath), f"Missing {fpath}", severity="WARN")


def validate_obsidian_location():
    """Check Obsidian code is in _genesis/obsidian, not 4-EXECUTE."""
    print("\n=== CHECK 6: Obsidian code location ===\n")

    check(
        not os.path.exists("4-EXECUTE/src/obsidian"),
        "4-EXECUTE/src/obsidian/ still exists (should be in _genesis/obsidian/)"
    )
    check(
        os.path.isdir("_genesis/obsidian"),
        "_genesis/obsidian/ should exist"
    )


def main():
    print("=" * 60)
    print("  Blueprint Validation Report")
    print("=" * 60)

    validate_subsystem_files()
    validate_naming()
    validate_old_dirs()
    validate_gitkeep()
    validate_dsbv()
    validate_obsidian_location()

    print("\n" + "=" * 60)
    print(f"  RESULTS: {PASS} PASS | {WARN} WARN | {FAIL} FAIL")
    print("=" * 60)

    if FAIL > 0:
        print("\n✗ VALIDATION FAILED — fix FAILs before committing")
        sys.exit(1)
    elif WARN > 0:
        print("\n⚠ PASSED WITH WARNINGS — review before committing")
        sys.exit(0)
    else:
        print("\n✓ ALL CHECKS PASSED")
        sys.exit(0)


if __name__ == "__main__":
    main()
