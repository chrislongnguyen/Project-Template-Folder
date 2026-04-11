#!/usr/bin/env python3
# version: 1.0 | status: draft | last_updated: 2026-04-08
"""
L2: LEARN Pipeline State Simulation

Creates mock filesystem states and validates that the /learn orchestrator's
state detection logic would route to the correct sub-skill.

Extracts routing rules from the /learn SKILL.md state table:
  STATE 1: No input           → /learn:input
  STATE 2: Input, no research → /learn:research
  STATE 3: Research done, not fully structured/validated → /learn:structure + /learn:review
  STATE 4: All validated      → /learn:spec
  STATE 5: Pipeline complete  → completion message

Usage: python3 scripts/learn-benchmark-l2.py [--json]
"""

import json
import os
import shutil
import sys
import tempfile

SLUG = 'test-system'

# ── State detection logic (extracted from /learn SKILL.md) ──────────────────

def detect_state(base_dir):
    """
    Reimplements the /learn orchestrator state detection from SKILL.md.
    Returns (state_number, route_target, detail).
    """
    cross = os.path.join(base_dir, '2-LEARN', '_cross')

    # STATE 1: No input file
    input_dir = os.path.join(cross, 'input')
    input_files = []
    if os.path.isdir(input_dir):
        input_files = [f for f in os.listdir(input_dir) if f.startswith('learn-input-') and f.endswith('.md')]
    if not input_files:
        return 1, '/learn:input', 'No input file found'

    # Extract slug from first input file
    slug = input_files[0].replace('learn-input-', '').replace('.md', '')

    # STATE 2: Input exists, no research directory
    research_dir = os.path.join(cross, 'research', slug)
    if not os.path.isdir(research_dir):
        return 2, f'/learn:research {slug}', 'Input exists, no research dir'

    research_files = [f for f in os.listdir(research_dir) if f.endswith('.md')]
    if not research_files:
        return 2, f'/learn:research {slug}', 'Research dir empty'

    # STATE 3: Research exists, check if all topics have 6 validated P-pages
    output_dir = os.path.join(cross, 'output', slug)
    unstructured_topics = []
    unvalidated_topics = []

    # Derive topic numbers from research files (T0-*.md, T1-*.md, etc.)
    topic_nums = set()
    for f in research_files:
        if f.startswith('T') and '-' in f:
            try:
                num = int(f.split('-')[0][1:])
                topic_nums.add(num)
            except ValueError:
                pass

    for tnum in sorted(topic_nums):
        # Check if 6 P-pages exist for this topic
        pages_found = 0
        pages_validated = 0
        for p in range(6):
            page_pattern = f'T{tnum}.P{p}'
            if os.path.isdir(output_dir):
                matching = [f for f in os.listdir(output_dir) if f.startswith(page_pattern)]
                if matching:
                    pages_found += 1
                    # Check frontmatter for status: validated
                    page_path = os.path.join(output_dir, matching[0])
                    with open(page_path, 'r') as fh:
                        content = fh.read()
                    if 'status: validated' in content:
                        pages_validated += 1

        if pages_found < 6:
            unstructured_topics.append(tnum)
        elif pages_validated < 6:
            unvalidated_topics.append(tnum)

    if unstructured_topics:
        first = unstructured_topics[0]
        return 3, f'/learn:structure {slug} {first}', f'Topic T{first} needs structuring'

    if unvalidated_topics:
        first = unvalidated_topics[0]
        return 3, f'/learn:review {slug} {first}', f'Topic T{first} needs review/validation'

    # STATE 4: All validated, check for spec
    specs_dir = os.path.join(cross, 'specs', slug)
    spec_file = os.path.join(specs_dir, 'vana-spec.md')
    if not os.path.exists(spec_file):
        return 4, f'/learn:spec {slug}', 'All pages validated, no spec'

    # STATE 5: Complete
    return 5, 'complete', 'Pipeline complete'


# ── Fixture builders ────────────────────────────────────────────────────────

def make_base(tmp):
    """Create base 2-LEARN/_cross/ structure."""
    os.makedirs(os.path.join(tmp, '2-LEARN', '_cross', 'input'), exist_ok=True)
    return tmp


def make_input(tmp, slug=SLUG):
    """Add learn-input file."""
    path = os.path.join(tmp, '2-LEARN', '_cross', 'input', f'learn-input-{slug}.md')
    with open(path, 'w') as f:
        f.write(f'---\nsystem_name: Test System\nsystem-slug: {slug}\n---\n')
    return tmp


def make_research(tmp, slug=SLUG, topics=None):
    """Add research files for topics."""
    if topics is None:
        topics = [0]
    research_dir = os.path.join(tmp, '2-LEARN', '_cross', 'research', slug)
    os.makedirs(research_dir, exist_ok=True)
    for t in topics:
        path = os.path.join(research_dir, f'T{t}-overview.md')
        with open(path, 'w') as f:
            f.write(f'---\ntopic: T{t}\n---\nResearch content for topic {t}\n')
    return tmp


def make_pages(tmp, slug=SLUG, topic=0, count=6, validated=False):
    """Add P-pages for a topic."""
    output_dir = os.path.join(tmp, '2-LEARN', '_cross', 'output', slug)
    os.makedirs(output_dir, exist_ok=True)
    page_names = [
        'overview-and-summary', 'ultimate-blockers', 'ultimate-drivers',
        'principles', 'components', 'steps-to-apply'
    ]
    for p in range(count):
        name = page_names[p] if p < len(page_names) else f'page-{p}'
        path = os.path.join(output_dir, f'T{topic}.P{p}-{name}.md')
        status = 'validated' if validated else 'draft'
        with open(path, 'w') as f:
            f.write(f'---\nstatus: {status}\nversion: "1.0"\n---\nPage content\n')
    return tmp


def make_spec(tmp, slug=SLUG):
    """Add vana-spec.md."""
    specs_dir = os.path.join(tmp, '2-LEARN', '_cross', 'specs', slug)
    os.makedirs(specs_dir, exist_ok=True)
    path = os.path.join(specs_dir, 'vana-spec.md')
    with open(path, 'w') as f:
        f.write('---\nversion: "1.0"\nstatus: draft\n---\nVANA spec content\n')
    return tmp


# ── Test fixtures ───────────────────────────────────────────────────────────

FIXTURES = [
    {
        'id': 'F1-EMPTY',
        'desc': 'Empty _cross/ dir',
        'setup': lambda tmp: make_base(tmp),
        'expected_state': 1,
        'expected_route': '/learn:input',
    },
    {
        'id': 'F2-INPUT',
        'desc': 'Input exists, no research',
        'setup': lambda tmp: make_input(make_base(tmp)),
        'expected_state': 2,
        'expected_route': f'/learn:research {SLUG}',
    },
    {
        'id': 'F3-RSCH',
        'desc': 'Research exists, no P-pages',
        'setup': lambda tmp: make_research(make_input(make_base(tmp))),
        'expected_state': 3,
        'expected_route': f'/learn:structure {SLUG} 0',
    },
    {
        'id': 'F4-STRUC',
        'desc': '6 P-pages exist, not validated',
        'setup': lambda tmp: make_pages(make_research(make_input(make_base(tmp))), validated=False),
        'expected_state': 3,
        'expected_route': f'/learn:review {SLUG} 0',
    },
    {
        'id': 'F5-VALID',
        'desc': 'All P-pages validated, no spec',
        'setup': lambda tmp: make_pages(make_research(make_input(make_base(tmp))), validated=True),
        'expected_state': 4,
        'expected_route': f'/learn:spec {SLUG}',
    },
    {
        'id': 'F6-DONE',
        'desc': 'Pipeline complete (spec exists)',
        'setup': lambda tmp: make_spec(make_pages(make_research(make_input(make_base(tmp))), validated=True)),
        'expected_state': 5,
        'expected_route': 'complete',
    },
    {
        'id': 'F7-PARTIAL',
        'desc': '3 topics, only T0+T1 structured, T2 not',
        'setup': lambda tmp: (
            make_pages(
                make_pages(
                    make_research(make_input(make_base(tmp)), topics=[0, 1, 2]),
                    topic=0, validated=True
                ),
                topic=1, validated=True
            )
            # T2 has no pages — should route to structure T2
        ),
        'expected_state': 3,
        'expected_route': f'/learn:structure {SLUG} 2',
    },
    {
        'id': 'F8-MIXED',
        'desc': 'T0 validated, T1 pages exist but not validated',
        'setup': lambda tmp: (
            make_pages(
                make_pages(
                    make_research(make_input(make_base(tmp)), topics=[0, 1]),
                    topic=0, validated=True
                ),
                topic=1, validated=False
            )
        ),
        'expected_state': 3,
        'expected_route': f'/learn:review {SLUG} 1',
    },
]


# ── Runner ──────────────────────────────────────────────────────────────────

def run():
    json_mode = '--json' in sys.argv
    results = []
    passed = 0
    failed = 0

    for fixture in FIXTURES:
        tmp = tempfile.mkdtemp(prefix='learn-bench-')
        try:
            fixture['setup'](tmp)
            state, route, detail = detect_state(tmp)

            state_ok = state == fixture['expected_state']
            route_ok = route == fixture['expected_route']
            ok = state_ok and route_ok

            if ok:
                passed += 1
                status = 'PASS'
            else:
                failed += 1
                status = 'FAIL'

            result = {
                'fixture': fixture['id'],
                'desc': fixture['desc'],
                'status': status,
                'expected_state': fixture['expected_state'],
                'actual_state': state,
                'expected_route': fixture['expected_route'],
                'actual_route': route,
                'detail': detail,
            }
            results.append(result)

            if not json_mode:
                icon = '\033[32m✓\033[0m' if ok else '\033[31m✗\033[0m'
                mismatch = ''
                if not state_ok:
                    mismatch += f' state: got {state} want {fixture["expected_state"]}'
                if not route_ok:
                    mismatch += f' route: got "{route}" want "{fixture["expected_route"]}"'
                print(f'  {icon} {fixture["id"]:12s} {fixture["desc"]}{mismatch}')
        finally:
            shutil.rmtree(tmp, ignore_errors=True)

    total = passed + failed
    if json_mode:
        print(json.dumps({'results': results, 'summary': {
            'total': total, 'passed': passed, 'failed': failed
        }}, indent=2))
    else:
        print(f'\n{"="*70}')
        pct = (passed / total * 100) if total > 0 else 0
        print(f'L2 Summary: {passed}/{total} PASS ({pct:.0f}%) | {failed} FAIL')
        print(f'{"="*70}')

    return 0 if failed == 0 else 1


if __name__ == '__main__':
    sys.exit(run())
