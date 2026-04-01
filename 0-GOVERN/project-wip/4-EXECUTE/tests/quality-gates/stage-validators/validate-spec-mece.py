#!/usr/bin/env python3
"""
Stage 1→2 Validator: MECE AC coverage, traceability, §0/§6 completeness, ID uniqueness.

Usage: python3 validate-spec-mece.py /path/to/spec.md
       python3 validate-spec-mece.py --help

Exit: 0 = all checks pass, 1 = any check fails

Checks (per spec §7.2):
  1. Every AC in §2-§5 appears exactly once in AC-TEST-MAP (§7)
  2. Traceability chain references are present
  3. §0 Force Analysis / recursive decomposition present (≥1 level: UBS or UDS)
  4. §6 System Boundaries with all 4 boundary layers
  5. No duplicate AC IDs across §2-§5
"""
import sys
import re
from pathlib import Path


# ---------------------------------------------------------------------------
# Parsers
# ---------------------------------------------------------------------------

def read_spec(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def split_sections(content: str) -> dict[str, str]:
    """
    Split a markdown spec into section buckets keyed by heading.
    Returns {heading_text: body_text}. Sections are delimited by ## headings.
    """
    sections: dict[str, str] = {}
    current_key = "__preamble__"
    current_lines: list[str] = []

    for line in content.splitlines():
        if line.startswith("## "):
            sections[current_key] = "\n".join(current_lines)
            current_key = line.lstrip("# ").strip()
            current_lines = []
        else:
            current_lines.append(line)

    sections[current_key] = "\n".join(current_lines)
    return sections


def extract_ac_ids_from_sections(content: str, section_numbers: tuple[str, ...]) -> list[str]:
    """
    Extract AC IDs from §2-§5 in a spec.
    AC IDs match patterns like:
      - Verb-AC1, Noun-AC2, D1-AC-3, Verb-AC-4, AC-1, Adj-AC1
    Collects them from section bodies only (not headers or code blocks).
    """
    # Split by ## headings to isolate sections §2-§5
    section_pattern = re.compile(r"^## (.+)$", re.MULTILINE)
    splits = section_pattern.split(content)
    # splits = [pre, heading1, body1, heading2, body2, ...]

    target_bodies: list[str] = []
    for i in range(1, len(splits) - 1, 2):
        heading = splits[i].strip()
        body = splits[i + 1] if i + 1 < len(splits) else ""
        # Match sections whose heading starts with one of the target numbers (e.g. "2", "3", "4", "5")
        for num in section_numbers:
            if heading.startswith(num + ".") or heading.startswith(num + " "):
                target_bodies.append(body)
                break

    # AC ID pattern: word chars then -AC then optional - then digits
    ac_pattern = re.compile(r"\b([\w]+-AC-?\d+)\b")
    found: list[str] = []
    for body in target_bodies:
        # Strip code blocks so we don't pick up examples inside backtick fences
        stripped = re.sub(r"```.*?```", "", body, flags=re.DOTALL)
        found.extend(ac_pattern.findall(stripped))
    return found


def extract_ac_test_map_ids(content: str) -> list[str]:
    """
    Extract AC IDs from the AC-TEST-MAP section (§7 or anywhere labelled AC-TEST-MAP).
    Looks for a section containing 'AC-TEST-MAP' header or table.
    """
    # Find a block labelled AC-TEST-MAP
    section_pattern = re.compile(r"^## (.+)$", re.MULTILINE)
    splits = section_pattern.split(content)

    map_bodies: list[str] = []
    for i in range(1, len(splits) - 1, 2):
        heading = splits[i].strip()
        body = splits[i + 1] if i + 1 < len(splits) else ""
        if "AC-TEST-MAP" in heading or "7" in heading.split()[0:1]:
            map_bodies.append(body)

    # Also search the entire content for an AC-TEST-MAP table block
    map_block = re.search(r"AC-TEST-MAP.*?(?=^## |\Z)", content, flags=re.DOTALL | re.MULTILINE)
    if map_block:
        map_bodies.append(map_block.group(0))

    ac_pattern = re.compile(r"\b([\w]+-AC-?\d+)\b")
    found: list[str] = []
    for body in map_bodies:
        stripped = re.sub(r"```.*?```", "", body, flags=re.DOTALL)
        found.extend(ac_pattern.findall(stripped))
    return found


def check_section_zero_present(content: str) -> tuple[bool, str]:
    """
    Check 3: §0 Force Analysis present with recursive decomposition.
    Looks for '## 0' or '§0' heading AND at least one of UBS/UDS.
    """
    has_section_zero = bool(
        re.search(r"^##\s+0[\s.]", content, re.MULTILINE)
        or re.search(r"§0", content)
    )
    has_force = bool(
        re.search(r"\bUBS\b", content)
        or re.search(r"\bUDS\b", content)
        or re.search(r"Force Analysis", content, re.IGNORECASE)
    )
    has_decomposition = bool(
        re.search(r"UBS\([AR]\)|UDS\([AR]\)", content)
        or re.search(r"recursive decomposition", content, re.IGNORECASE)
        or (re.search(r"\bUBS\b", content) and re.search(r"\bUDS\b", content))
    )

    if not has_section_zero:
        return False, "§0 Force Analysis section missing (no '## 0' or '§0' heading found)"
    if not has_force:
        return False, "§0 present but no Force Analysis content (UBS/UDS/Force Analysis keywords missing)"
    if not has_decomposition:
        return False, "§0 present but recursive decomposition incomplete (need UBS(R)/UBS(A)/UDS(R)/UDS(A))"
    return True, "§0 Force Analysis present with recursive decomposition"


def check_section_six_boundaries(content: str) -> tuple[bool, str]:
    """
    Check 4: §6 System Boundaries with all 4 layers.
    The 4 layers per spec: Design Layer, Execution Layer, Display Layer + Agent Architecture.
    Looks for a §6 section and the 4 boundary concepts.
    """
    has_section_six = bool(
        re.search(r"^##\s+6[\s.]", content, re.MULTILINE)
        or re.search(r"§6", content)
        or re.search(r"System Boundary", content, re.IGNORECASE)
        or re.search(r"Agent Architecture", content, re.IGNORECASE)
    )
    if not has_section_six:
        return False, "§6 System Boundaries section missing"

    # The 4 boundary layers from spec §6:
    # 1. Design Layer  2. Execution Layer  3. Display Layer  4. Agent Architecture
    layers = {
        "Design Layer": bool(re.search(r"Design Layer", content, re.IGNORECASE)),
        "Execution Layer": bool(re.search(r"Execution Layer", content, re.IGNORECASE)),
        "Display Layer": bool(re.search(r"Display Layer", content, re.IGNORECASE)),
        "Agent Architecture": bool(
            re.search(r"Agent Arch", content, re.IGNORECASE)
            or re.search(r"RACI", content, re.IGNORECASE)
        ),
    }
    missing = [k for k, v in layers.items() if not v]
    if missing:
        return False, f"§6 missing boundary layer(s): {missing}"
    return True, "§6 System Boundaries present with all 4 layers"


# ---------------------------------------------------------------------------
# Main checks
# ---------------------------------------------------------------------------

def check_no_duplicate_ac_ids(ac_ids: list[str]) -> tuple[bool, str]:
    """Check 5: No duplicate AC IDs in §2-§5."""
    seen: dict[str, int] = {}
    duplicates: list[str] = []
    for ac_id in ac_ids:
        seen[ac_id] = seen.get(ac_id, 0) + 1
    duplicates = [ac_id for ac_id, count in seen.items() if count > 1]
    if duplicates:
        return False, f"Duplicate AC IDs found: {duplicates}"
    return True, f"No duplicate AC IDs ({len(seen)} unique IDs)"


def check_mece_coverage(
    spec_ac_ids: list[str], map_ac_ids: list[str]
) -> tuple[bool, str]:
    """
    Check 1: Every AC in §2-§5 appears exactly once in AC-TEST-MAP.
    Also checks 2: that there are no orphan ACs in the map not in §2-§5.
    """
    spec_set = set(spec_ac_ids)
    map_set = set(map_ac_ids)

    missing_from_map = spec_set - map_set
    orphans_in_map = map_set - spec_set

    issues: list[str] = []
    if missing_from_map:
        issues.append(f"ACs in §2-§5 but NOT in AC-TEST-MAP: {sorted(missing_from_map)}")
    if orphans_in_map:
        issues.append(f"ACs in AC-TEST-MAP but NOT in §2-§5: {sorted(orphans_in_map)}")

    if issues:
        return False, "\n  ".join(issues)

    if not spec_set and not map_set:
        return False, "No AC IDs found in §2-§5 or AC-TEST-MAP — spec may be empty or malformed"

    return True, f"AC-TEST-MAP covers all {len(spec_set)} ACs in §2-§5 (MECE)"


def check_traceability(content: str) -> tuple[bool, str]:
    """
    Check 2: Traceability chain references present.
    Looks for EO reference AND a VANA element reference in the spec.
    """
    has_udo = bool(re.search(r"\bEO\b", content))
    has_vana = bool(
        re.search(r"\bVANA\b", content)
        or re.search(r"Visibility|Accessibility|Navigability|Autonomy", content, re.IGNORECASE)
    )
    has_ac_trace = bool(
        re.search(r"AC-TEST-MAP", content)
        or re.search(r"traceability", content, re.IGNORECASE)
    )

    missing = []
    if not has_udo:
        missing.append("EO (Effective Outcome) reference missing")
    if not has_vana:
        missing.append("VANA element references missing")
    if not has_ac_trace:
        missing.append("AC-TEST-MAP or traceability section missing")

    if missing:
        return False, "Incomplete traceability chain: " + "; ".join(missing)
    return True, "Traceability chain references present (EO → VANA → AC-TEST-MAP)"


# ---------------------------------------------------------------------------
# Runner
# ---------------------------------------------------------------------------

def run_checks(spec_path: Path) -> int:
    content = read_spec(spec_path)

    # Parse ACs from the content
    spec_ac_ids = extract_ac_ids_from_sections(content, ("2", "3", "4", "5"))
    map_ac_ids = extract_ac_test_map_ids(content)

    checks = [
        ("Check 1: MECE AC coverage (§2-§5 ↔ AC-TEST-MAP)", lambda: check_mece_coverage(spec_ac_ids, map_ac_ids)),
        ("Check 2: Traceability chain references", lambda: check_traceability(content)),
        ("Check 3: §0 Force Analysis with recursive decomposition", lambda: check_section_zero_present(content)),
        ("Check 4: §6 System Boundaries — all 4 layers", lambda: check_section_six_boundaries(content)),
        ("Check 5: No duplicate AC IDs in §2-§5", lambda: check_no_duplicate_ac_ids(spec_ac_ids)),
    ]

    passed = 0
    failed = 0
    for name, fn in checks:
        try:
            ok, msg = fn()
        except Exception as e:
            ok, msg = False, f"Exception: {e}"
        status = "PASS" if ok else "FAIL"
        print(f"[{status}] {name} — {msg}")
        if ok:
            passed += 1
        else:
            failed += 1

    print(f"\nRESULT: {passed}/{passed + failed} checks passed, {failed} failed")
    return 0 if failed == 0 else 1


def main() -> int:
    if "--help" in sys.argv or "-h" in sys.argv:
        print(__doc__.strip())
        return 0

    if len(sys.argv) < 2:
        print("Usage: python3 validate-spec-mece.py /path/to/spec.md", file=sys.stderr)
        return 1

    spec_path = Path(sys.argv[1])
    if not spec_path.is_file():
        print(f"ERROR: {spec_path} is not a file", file=sys.stderr)
        return 1

    return run_checks(spec_path)


if __name__ == "__main__":
    sys.exit(main())
