#!/usr/bin/env python3
# version: 1.1 | status: in-review | last_updated: 2026-04-09
"""
L1: LEARN Skills Static Contract Validation

Parses each learn*/SKILL.md for S x E x Sc contract compliance.
Deterministic, zero-cost, 100% reproducible.

Usage: python3 scripts/learn-benchmark-l1.py [--json]
"""

import os
import re
import sys
import json

SKILLS_DIR = os.path.join(os.path.dirname(__file__), '..', '.claude', 'skills')


def parse_frontmatter(filepath):
    """Parse simple YAML frontmatter between --- delimiters."""
    with open(filepath) as f:
        lines = f.readlines()
    if not lines or lines[0].strip() != '---':
        return {}
    meta = {}
    for line in lines[1:]:
        if line.strip() == '---':
            break
        if ':' in line:
            key, _, val = line.partition(':')
            meta[key.strip()] = val.strip().strip('"').strip("'")
    return meta

# ── Skill registry ──────────────────────────────────────────────────────────

SKILLS = {
    'learn':           {'path': 'learn/SKILL.md',           'dispatches_agents': False, 'interactive': False},
    'learn-input':     {'path': 'learn-input/SKILL.md',     'dispatches_agents': False, 'interactive': True},
    'learn-research':  {'path': 'learn-research/SKILL.md',  'dispatches_agents': True,  'interactive': False},
    'learn-structure': {'path': 'learn-structure/SKILL.md', 'dispatches_agents': False, 'interactive': False},
    'learn-review':    {'path': 'learn-review/SKILL.md',    'dispatches_agents': False, 'interactive': True},
    'learn-spec':      {'path': 'learn-spec/SKILL.md',      'dispatches_agents': False, 'interactive': False},
    'learn-visualize': {'path': 'learn-visualize/SKILL.md', 'dispatches_agents': False, 'interactive': False},
}

# Expected model tiers (only for skills that declare model)
EXPECTED_MODELS = {
    'learn-structure': 'opus',
    'learn-spec':      'opus',
}

# Skills that should NOT have Agent in allowed-tools
NO_AGENT_SKILLS = ['learn', 'learn-input', 'learn-structure', 'learn-review', 'learn-spec', 'learn-visualize']

# Skills that produce output files (should reference 2-LEARN/_cross/)
OUTPUT_SKILLS = ['learn-input', 'learn-research', 'learn-structure', 'learn-review', 'learn-spec']

# Skills that need HARD-GATE
GATE_SKILLS = ['learn-input', 'learn-structure', 'learn-review', 'learn-spec', 'learn-visualize']

# Skills that should have Pre-Checks
PRECHECK_SKILLS = ['learn', 'learn-input', 'learn-research', 'learn-structure', 'learn-review', 'learn-spec', 'learn-visualize']

# Skills that should reference upstream skill in errors
ERROR_SKILLS = ['learn-research', 'learn-structure', 'learn-review', 'learn-spec', 'learn-visualize']


# ── Parsing ─────────────────────────────────────────────────────────────────

def parse_skill(skill_name):
    """Read and parse a SKILL.md into frontmatter dict + body string."""
    path = os.path.join(SKILLS_DIR, SKILLS[skill_name]['path'])
    if not os.path.exists(path):
        return None, None, path

    with open(path, 'r') as f:
        content = f.read()

    # Extract YAML frontmatter
    fm_match = re.match(r'^---\n(.*?)\n---\n(.*)$', content, re.DOTALL)
    if not fm_match:
        return {}, content, path

    frontmatter = parse_frontmatter(path)

    body = fm_match.group(2)
    return frontmatter, body, path


# ── Check functions ─────────────────────────────────────────────────────────

def check_s_path(skill_name, fm, body):
    """S-PATH: Output paths reference 2-LEARN/_cross/"""
    if skill_name not in OUTPUT_SKILLS:
        return None, 'N/A'
    found = bool(re.search(r'2-LEARN/_cross/', body))
    return found, '2-LEARN/_cross/ path referenced' if found else 'MISSING: no 2-LEARN/_cross/ path reference'


def check_s_agent(skill_name, fm, body):
    """S-AGENT: Agent dispatch uses ltc-explorer, not generic Explore"""
    if not SKILLS[skill_name]['dispatches_agents']:
        return None, 'N/A'
    has_ltc = bool(re.search(r'ltc-explorer', body))
    # Match generic "Explore" but NOT "ltc-explorer"
    has_generic = bool(re.search(r'subagent_type.*["\']?(?<!ltc-)Explore["\']?(?!r)', body, re.IGNORECASE))
    # Check frontmatter agents field too
    agents = fm.get('agents', {})
    if isinstance(agents, dict):
        has_ltc = has_ltc or any('ltc-explorer' in str(v) for v in agents.values())

    if has_ltc and not has_generic:
        return True, 'Uses ltc-explorer (correct)'
    elif has_generic:
        return False, 'FAIL: References generic Explore agent type'
    elif not has_ltc:
        return False, 'FAIL: No ltc-explorer reference found for agent-dispatching skill'
    return True, 'ltc-explorer referenced'


def check_s_gate(skill_name, fm, body):
    """S-GATE: HARD-GATE block exists with enforcement language"""
    if skill_name not in GATE_SKILLS:
        return None, 'N/A'
    has_gate = bool(re.search(r'(<HARD-GATE>|\*\*HARD-GATE[:\*]|##\s*HARD-GATE)', body))
    has_enforcement = bool(re.search(
        r'(never auto|human|explicit.*approv|must.*answer|halt|STOP|Do NOT|NEVER|do not)',
        body, re.IGNORECASE
    ))
    if has_gate and has_enforcement:
        return True, 'HARD-GATE with enforcement language'
    elif has_gate:
        return False, 'WARN: HARD-GATE exists but no enforcement language detected'
    else:
        return False, 'FAIL: No HARD-GATE block found'


def check_s_nodsbv(skill_name, fm, body):
    """S-NODSBV: No DSBV artifact creation in LEARN skills"""
    # Look for patterns that would CREATE DSBV files in 2-LEARN
    dsbv_create = re.search(
        r'(create|write|produce|generate).{0,40}(DESIGN\.md|SEQUENCE\.md|VALIDATE\.md).{0,40}(2-LEARN|LEARN)',
        body, re.IGNORECASE
    )
    # Also check for positive: explicit prohibition
    has_prohibition = bool(re.search(
        r'(NEVER|not|don.t|no).{0,30}(DESIGN\.md|SEQUENCE\.md|VALIDATE\.md|DSBV).{0,30}(2-LEARN|LEARN)',
        body, re.IGNORECASE
    ))
    if dsbv_create:
        return False, 'FAIL: Pattern suggests DSBV file creation in LEARN'
    elif has_prohibition:
        return True, 'Explicit DSBV prohibition found'
    else:
        return True, 'No DSBV creation patterns (implicit safe)'


def check_s_front(skill_name, fm, body):
    """S-FRONT: Skill instructs frontmatter on output files"""
    if skill_name not in OUTPUT_SKILLS:
        return None, 'N/A'
    has_fm_ref = bool(re.search(
        r'(frontmatter|version:|status:|last_updated:|YAML)',
        body, re.IGNORECASE
    ))
    return has_fm_ref, 'Frontmatter reference found' if has_fm_ref else 'WARN: No frontmatter instructions for output files'


def check_e_model(skill_name, fm, body):
    """E-MODEL: Model in frontmatter matches expected tier"""
    if skill_name not in EXPECTED_MODELS:
        return None, 'N/A'
    declared = fm.get('model', '').lower()
    expected = EXPECTED_MODELS[skill_name]
    if declared == expected:
        return True, f'model: {declared} (correct)'
    elif not declared:
        return False, f'FAIL: No model declared, expected {expected}'
    else:
        return False, f'FAIL: model: {declared}, expected {expected}'


def check_e_tools(skill_name, fm, body):
    """E-TOOLS: allowed-tools is a reasonable minimal set"""
    tools_raw = fm.get('allowed-tools', '')
    if not tools_raw:
        return False, 'WARN: No allowed-tools declared'
    if isinstance(tools_raw, str):
        tools = [t.strip() for t in tools_raw.split(',')]
    elif isinstance(tools_raw, list):
        tools = tools_raw
    else:
        return False, f'WARN: Unexpected allowed-tools type: {type(tools_raw)}'
    count = len(tools)
    if count > 7:
        return False, f'FAIL: {count} tools declared (>7 threshold)'
    return True, f'{count} tools: {", ".join(tools)}'


def check_e_noover(skill_name, fm, body):
    """E-NOOVER: No agent dispatch in orchestrator-only skills"""
    if skill_name not in NO_AGENT_SKILLS:
        return None, 'N/A'
    tools_raw = fm.get('allowed-tools', '')
    if isinstance(tools_raw, str):
        has_agent = 'Agent' in [t.strip() for t in tools_raw.split(',')]
    elif isinstance(tools_raw, list):
        has_agent = 'Agent' in tools_raw
    else:
        has_agent = False
    if has_agent:
        return False, 'FAIL: Agent in allowed-tools for non-dispatch skill'
    return True, 'No Agent in allowed-tools (correct)'


def check_sc_precheck(skill_name, fm, body):
    """SC-PRECK: Pre-Checks section exists"""
    if skill_name not in PRECHECK_SKILLS:
        return None, 'N/A'
    # Check for Pre-Checks or equivalent prerequisite section
    has_precheck = bool(re.search(
        r'##\s*(Pre-Checks|Prerequisites|HARD-GATE.*Prerequisite)',
        body, re.IGNORECASE
    ))
    # Also check state detection for orchestrator
    if skill_name == 'learn':
        has_precheck = has_precheck or bool(re.search(r'State Detect', body))
    return has_precheck, 'Pre-Checks section found' if has_precheck else 'FAIL: No Pre-Checks section'


def check_sc_error(skill_name, fm, body):
    """SC-ERROR: Error messages specify upstream skill to run"""
    if skill_name not in ERROR_SKILLS:
        return None, 'N/A'
    has_upstream = bool(re.search(
        r'Run /learn:', body
    ))
    return has_upstream, 'Upstream skill reference in errors' if has_upstream else 'FAIL: No "Run /learn:..." error guidance'


def check_sc_state(skill_name, fm, body):
    """SC-STATE: State derived from filesystem, not conversation"""
    if skill_name != 'learn':
        return None, 'N/A'
    has_fs_derive = bool(re.search(r'(Glob|glob|file.system|scan|directory)', body, re.IGNORECASE))
    has_no_state_file = bool(re.search(r'(no state file|no stored state|derive.*from.*file)', body, re.IGNORECASE))
    passed = has_fs_derive and has_no_state_file
    if passed:
        return True, 'Filesystem-derived state, no state file'
    elif has_fs_derive:
        return True, 'Filesystem detection present (no explicit no-state-file declaration)'
    else:
        return False, 'FAIL: No filesystem state detection pattern'


# ── Runner ──────────────────────────────────────────────────────────────────

ALL_CHECKS = [
    ('S-PATH',   check_s_path),
    ('S-AGENT',  check_s_agent),
    ('S-GATE',   check_s_gate),
    ('S-NODSBV', check_s_nodsbv),
    ('S-FRONT',  check_s_front),
    ('E-MODEL',  check_e_model),
    ('E-TOOLS',  check_e_tools),
    ('E-NOOVER', check_e_noover),
    ('SC-PRECK', check_sc_precheck),
    ('SC-ERROR', check_sc_error),
    ('SC-STATE', check_sc_state),
]


def run():
    json_mode = '--json' in sys.argv
    results = []
    total = 0
    passed = 0
    failed = 0
    warned = 0
    skipped = 0

    for skill_name in SKILLS:
        fm, body, path = parse_skill(skill_name)
        if fm is None:
            print(f"ERROR: {path} not found")
            continue

        for check_id, check_fn in ALL_CHECKS:
            result, detail = check_fn(skill_name, fm, body)
            if result is None:
                skipped += 1
                status = 'SKIP'
            elif result is True:
                passed += 1
                total += 1
                status = 'PASS'
            else:
                if 'WARN' in detail:
                    warned += 1
                    total += 1
                    status = 'WARN'
                else:
                    failed += 1
                    total += 1
                    status = 'FAIL'

            results.append({
                'skill': skill_name,
                'check': check_id,
                'status': status,
                'detail': detail,
            })

            if not json_mode:
                icon = {'PASS': '\033[32m✓\033[0m', 'FAIL': '\033[31m✗\033[0m',
                        'WARN': '\033[33m⚠\033[0m', 'SKIP': '\033[90m-\033[0m'}[status]
                print(f"  {icon} {skill_name:20s} {check_id:10s} {detail}")

    if json_mode:
        print(json.dumps({'results': results, 'summary': {
            'total': total, 'passed': passed, 'failed': failed, 'warned': warned, 'skipped': skipped
        }}, indent=2))
    else:
        print(f"\n{'='*70}")
        pct = (passed / total * 100) if total > 0 else 0
        print(f"L1 Summary: {passed}/{total} PASS ({pct:.0f}%) | {failed} FAIL | {warned} WARN | {skipped} SKIP")
        print(f"{'='*70}")

    return 0 if failed == 0 else 1


if __name__ == '__main__':
    sys.exit(run())
