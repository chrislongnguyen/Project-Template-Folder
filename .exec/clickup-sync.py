#!/usr/bin/env python3
"""Create LTC Memory Engine v2.0 hierarchy on ClickUp via direct API."""

import json
import os
import sys
import time
import urllib.request
import urllib.error

TOKEN = os.environ.get("CLICKUP_PERSONAL_TOKEN", "")
LIST_ID = "900801936705"
PARENT_OE6 = "86d12fqt1"
ASSIGNEE = 88928501
BASE = "https://api.clickup.com/api/v2"

# Custom field IDs
CF_DESIRED_OUTCOMES = "a382a103-456b-41a8-9b2a-8fa15a657ce4"
CF_ACCEPTANCE_CRITERIA = "b74bfd0e-f112-4849-af6d-132e65e59b46"
CF_MOSCOW = "1da92ea7-e200-4d60-84d8-e8b6148ba7dd"
CF_DELIVERY_PHASE = "4b625634-7006-4eec-8add-8c2b8c04ca3c"
CF_STRATEGIC_FOCUS = "c25d6dc4-85c0-4810-b945-42d65f72beb4"
CF_FUNCTION = "dbcd79fb-3c44-411f-9c88-c27473854592"
CF_SHORT_ID = "d640d685-262f-46bd-b166-c9c546796a61"
CF_DOD = "5bde1429-9a92-47a8-8345-0dd0b3dc9035"

# MoSCoW UUIDs
MUST_HAVE = "46d840bc-e7f4-4557-a7b1-37c92632c996"
SHOULD_HAVE = "670937b6-574c-4c8b-8aa8-2dc149694f06"

# Delivery Phase UUIDs
PHASE_CONCEPT = "76913bd0-be6e-41eb-8ef8-0e0cbc42acc8"

# Task type name → custom_item_id mapping (from ClickUp workspace)
TASK_TYPES = {
    "PJ Project": None,       # We'll look this up
    "PJ Workstream": None,
    "PJ Deliverable": None,
    "Task": 0,                 # null / default
    "PJ Increment": None,
    "PJ Documentation": None,
}

created_ids = {}  # key -> clickup_id


def api_call(method, url, data=None, retries=3):
    """Make ClickUp API call with retry logic."""
    headers = {
        "Authorization": TOKEN,
        "Content-Type": "application/json",
    }
    for attempt in range(retries):
        try:
            body = json.dumps(data).encode() if data else None
            req = urllib.request.Request(url, data=body, headers=headers, method=method)
            with urllib.request.urlopen(req, timeout=30) as resp:
                return json.loads(resp.read().decode())
        except urllib.error.HTTPError as e:
            error_body = e.read().decode() if e.fp else ""
            if e.code == 429:
                wait = min(60, 2 ** attempt * 5)
                print(f"  Rate limited (429), waiting {wait}s...")
                time.sleep(wait)
                continue
            print(f"  HTTP {e.code}: {error_body}")
            if attempt < retries - 1:
                time.sleep(2)
                continue
            raise
        except Exception as e:
            print(f"  Error: {e}")
            if attempt < retries - 1:
                time.sleep(2)
                continue
            raise


def create_task(name, parent_id, task_type_name=None, priority="high",
                status="ready/prioritized", description="",
                custom_fields=None, tags=None):
    """Create a ClickUp task and return its ID."""
    payload = {
        "name": name,
        "parent": parent_id,
        "priority": {"urgent": 1, "high": 2, "normal": 3, "low": 4}.get(priority, 3),
        "status": status,
        "assignees": [ASSIGNEE],
    }
    if description:
        payload["description"] = description
    if tags:
        payload["tags"] = tags
    if custom_fields:
        payload["custom_fields"] = custom_fields

    url = f"{BASE}/list/{LIST_ID}/task"
    result = api_call("POST", url, payload)
    task_id = result["id"]
    print(f"  Created: {name} -> {task_id}")

    # Set task type if needed (requires separate call)
    if task_type_name and task_type_name != "Task":
        set_task_type(task_id, task_type_name)

    return task_id


def set_task_type(task_id, type_name):
    """Set task type via the update endpoint."""
    # ClickUp API v2: task types are set via custom_item_id on update
    # We need to look up the custom_item_id for each type name
    # For now, use the task type names directly via the update endpoint
    url = f"{BASE}/task/{task_id}"
    # The v2 API doesn't directly support task_type by name in update
    # We need custom_item_id. Let's get task types first.
    pass


def set_custom_field(task_id, field_id, value):
    """Set a custom field value on a task."""
    url = f"{BASE}/task/{task_id}/field/{field_id}"
    api_call("POST", url, {"value": value})


def set_time_estimate(task_id, minutes):
    """Set time estimate in milliseconds via update."""
    url = f"{BASE}/task/{task_id}"
    ms = minutes * 60 * 1000
    api_call("PUT", url, {"time_estimate": ms})


def add_dependency(task_id, depends_on_id):
    """Add waiting_on dependency."""
    url = f"{BASE}/task/{task_id}/dependency"
    api_call("POST", url, {
        "depends_on": depends_on_id,
        "dependency_of": task_id,
    })


def get_task_types():
    """Get available task types from workspace."""
    # Get from the team/workspace
    # First, get team ID from the list
    url = f"{BASE}/list/{LIST_ID}"
    list_info = api_call("GET", url)
    space_id = list_info.get("space", {}).get("id") or list_info.get("folder", {}).get("space", {}).get("id", "")

    # Get custom task types from the workspace
    # ClickUp v2: GET /team/{team_id}/custom_item
    # We need team_id. Let's get it from authorized teams.
    url = f"{BASE}/team"
    teams = api_call("GET", url)
    team_id = teams["teams"][0]["id"]

    url = f"{BASE}/team/{team_id}/custom_item"
    types_resp = api_call("GET", url)
    type_map = {}
    for t in types_resp.get("custom_items", []):
        type_map[t["name"]] = t["id"]
    # Default task type
    type_map["Task"] = 0
    return type_map, team_id


def main():
    print("=== LTC Memory Engine v2.0 — ClickUp Sync ===\n")

    # Step 0: Get task types
    print("[0] Fetching task type IDs...")
    type_map, team_id = get_task_types()
    print(f"  Task types: {json.dumps(type_map, indent=2)}")
    time.sleep(1)

    # Step 1: Create PJ Project
    print("\n[1] Creating PJ Project...")
    proj_cf = [
        {"id": CF_DESIRED_OUTCOMES, "value": "Every LTC-configured AI agent can persistently store, search, and manage contextual memory across sessions through a local SQLite-backed engine with vector+FTS5 hybrid search, a Click CLI (memory write/read/stats/setup), secret scanning, and duplicate detection — installable via pip install -e . in under 5 minutes.\n\n| Dimension | Outcome |\n|---|---|\n| V (Value) | Agents retain and recall context across sessions, eliminating repeated discovery work |\n| A (Access) | pip install -e . + memory setup — under 5 minutes, zero server dependencies |\n| N (Novelty) | Hybrid vector+FTS5 search with secret scanning and dedup — no existing tool does all three locally |\n| A (Advantage) | Single-file SQLite DB, portable, no cloud dependency, works offline |"},
        {"id": CF_ACCEPTANCE_CRITERIA, "value": "- [ ] AC Adj-W1: Constructor takes only db_path + embedder\n- [ ] AC V-10: Install in under 5 minutes\n- [ ] AC N-I1: SQLite DB with WAL, FTS5, sqlite-vec, 7+ tables\n- [ ] AC N-I2: all-MiniLM-L6-v2, embed(\"test\") → 384 floats\n- [ ] AC N-I3: TOML config at ~/.config/memory-engine/config.toml\n- [ ] AC A-S1: Atomic writes — partial writes never persist\n- [ ] AC A-S4: Embedding failure degrades to FTS5-only\n- [ ] AC V-1: Store memory unit (any of 7 types)\n- [ ] AC V-2: Vector search returns correct top-1 (80%)\n- [ ] AC V-3: Lexical search returns correct top-1 (80%)\n- [ ] AC V-4: Hybrid >= max(vector, lexical)\n- [ ] AC V-5: Update existing memory unit by ID\n- [ ] AC V-6: Delete memory unit by ID\n- [ ] AC N-W1: Single MemoryManager class with CRUD for all 7 types\n- [ ] AC N-W2: CLI: write, read, update, delete, stats, audit, config, setup\n- [ ] AC N-W3: 11-step idempotent setup wizard\n- [ ] AC A-S2: Secret patterns rejected at write time\n- [ ] AC A-S3: Duplicate detection rejects >0.95 cosine similarity\n- [ ] AC A-E1: Setup < 5 min, zero manual config\n- [ ] AC A-E2: Single write < 200ms\n- [ ] AC A-E3: Single read (top-5) < 100ms\n- [ ] AC A-E4: Setup idempotent\n- [ ] AC V-11: memory stats + audit show health\n- [ ] AC N-W4: stats + audit in JSON\n- [ ] AC Adj-I1: Single-file, zero-server, portable DB\n- [ ] AC Adj-I2: WAL mode at creation automatically\n- [ ] AC Adj-I3: Embedder loads <3s cold, <200ms warm\n- [ ] AC Adj-I4: Config human-readable, every field has comment\n- [ ] AC Adj-W2: Every command has --help with examples\n- [ ] AC Adj-W3: Exit code 0/1, human-readable errors"},
        {"id": CF_MOSCOW, "value": MUST_HAVE},
        {"id": CF_DELIVERY_PHASE, "value": PHASE_CONCEPT},
        {"id": CF_SHORT_ID, "value": "OE.6.4-MEM"},
    ]

    proj_desc = """## Execution Topology

```
D1-T1 ──→ D1-T2 ──┬──→ D2-T1 ──────────────────────────────────┐
                   │                                              │
                   ├──→ D2-T2 ──→ D4-T1 ──┬──→ D4-T2            │
                   │                       │                      │
                   ├──→ D3-T1 ──→ D4-T1    ├──→ D4-T3 ──┐       │
                   │                       │              │       │
                   │                       └──────────────┴──→ D5-T1 ──→ D5-T2 ──→ D6-T1
                   │                                              │
                   └──────────────────────────────────────────────┘

Critical Path: D1-T1 → D1-T2 → D2-T2 → D4-T1 → D4-T3 → D5-T1 → D5-T2 → D6-T1
Parallel lanes: D2-T1 ∥ D2-T2 ∥ D3-T1 (after D1-T2)
                D4-T2 ∥ D4-T3 (after D4-T1)
```

## Summary

Local SQLite-backed memory engine for LTC AI agents. Vector+FTS5 hybrid search, Click CLI, secret scanning, duplicate detection. Installable via `pip install -e .` in <5 min.

## References

- Spec: OPS_OE.6.4.LTC-PROJECT-TEMPLATE repo
- Exec plan: .exec/project.md"""

    # Create the task first without custom fields (ClickUp v2 create_task doesn't support custom_fields inline for subtasks well)
    url = f"{BASE}/list/{LIST_ID}/task"
    payload = {
        "name": "[OPS PROCESS]_OE.6.4.LTC Memory Engine v2.0",
        "parent": PARENT_OE6,
        "priority": 2,
        "status": "ready/prioritized",
        "assignees": [ASSIGNEE],
        "description": proj_desc,
        "tags": ["user: all ltc all members"],
        "custom_fields": proj_cf,
    }
    result = api_call("POST", url, payload)
    proj_id = result["id"]
    created_ids["project"] = proj_id
    print(f"  PJ Project: {proj_id}")

    # Set task type
    if type_map.get("PJ Project") is not None:
        url2 = f"{BASE}/task/{proj_id}"
        api_call("PUT", url2, {"custom_item_id": type_map["PJ Project"]})
        print(f"  Set type: PJ Project ({type_map['PJ Project']})")
    time.sleep(1)

    # Step 2: Create PJ Workstream (I1 Concept)
    print("\n[2] Creating PJ Workstream...")
    ws_cf = [
        {"id": CF_DESIRED_OUTCOMES, "value": "I1 Concept iteration delivers a working local memory engine with core CRUD, hybrid search, CLI, and security controls — proving the architecture before scaling in I2-I4."},
        {"id": CF_ACCEPTANCE_CRITERIA, "value": "- [ ] All 30 I1 ACs pass\n- [ ] pip install -e . works\n- [ ] memory setup completes in <5 min\n- [ ] Full round-trip: write → search → update → search → delete → stats"},
        {"id": CF_MOSCOW, "value": MUST_HAVE},
        {"id": CF_DELIVERY_PHASE, "value": PHASE_CONCEPT},
        {"id": CF_SHORT_ID, "value": "I1-CONCEPT"},
    ]
    url = f"{BASE}/list/{LIST_ID}/task"
    payload = {
        "name": "I1 Concept",
        "parent": proj_id,
        "priority": 2,
        "status": "ready/prioritized",
        "assignees": [ASSIGNEE],
        "description": "Iteration 1 (Concept) — 6 Deliverables, 11 Tasks, 615 min total.\n\nProves the core architecture: data models, storage, embedder, memory manager, CLI, and integration.",
        "custom_fields": ws_cf,
    }
    result = api_call("POST", url, payload)
    ws_id = result["id"]
    created_ids["workstream"] = ws_id
    print(f"  PJ Workstream: {ws_id}")
    if type_map.get("PJ Workstream") is not None:
        api_call("PUT", f"{BASE}/task/{ws_id}", {"custom_item_id": type_map["PJ Workstream"]})
        print(f"  Set type: PJ Workstream")
    time.sleep(1)

    # Step 3: Create 6 PJ Deliverables
    deliverables = [
        {
            "key": "D1", "name": "Package Scaffolding + Data Models",
            "vana": "Every LTC-configured AI agent can pip install -e . the memory-engine package and import all data models (MemoryUnit, TokenUsage, ConversationRow) — with a minimal 2-parameter constructor interface.",
            "acs": "- [ ] AC Adj-W1: Constructor takes only db_path + embedder\n- [ ] AC V-10: Install in under 5 minutes",
            "dod": "pyproject.toml passes pip install -e . cleanly. All 3 data model classes importable. conftest.py fixtures working.",
            "short_id": "D1-SCAFFOLD",
        },
        {
            "key": "D2", "name": "Config + Storage Layer",
            "vana": "Every LTC-configured AI agent can load TOML configuration and store/retrieve memory units in a SQLite database with WAL mode, FTS5 full-text search, and atomic transaction guarantees.",
            "acs": "- [ ] AC N-I3: TOML config at ~/.config/memory-engine/config.toml\n- [ ] AC Adj-I4: Config human-readable, every field commented\n- [ ] AC N-I1: SQLite DB with WAL, FTS5, sqlite-vec, 7+ tables\n- [ ] AC Adj-I1: Single-file, zero-server, portable DB\n- [ ] AC Adj-I2: WAL mode at creation automatically\n- [ ] AC A-S1: Atomic writes — partial writes never persist",
            "dod": "Config loads/saves TOML. Storage creates DB with WAL+FTS5+7 tables. All CRUD ops are atomic.",
            "short_id": "D2-CONFIG-STORAGE",
        },
        {
            "key": "D3", "name": "Embedder",
            "vana": "Every LTC-configured AI agent can embed text into 384-dimensional vectors using a locally-loaded sentence-transformers model, with lazy loading and graceful fallback to FTS5 when unavailable.",
            "acs": "- [ ] AC N-I2: all-MiniLM-L6-v2, embed(\"test\") → 384 floats\n- [ ] AC Adj-I3: Embedder loads <3s cold, <200ms warm\n- [ ] AC A-S4: Embedding failure degrades to FTS5-only",
            "dod": "LocalEmbedder class loads model, embeds text, returns 384-dim vectors. Fallback tested.",
            "short_id": "D3-EMBEDDER",
        },
        {
            "key": "D4", "name": "MemoryManager",
            "vana": "Every LTC-configured AI agent can write, read, update, and delete memories across all 7 types through a single MemoryManager class, with hybrid search (vector + FTS5), secret scanning, and duplicate detection.",
            "acs": "- [ ] AC V-1: Store memory unit (any of 7 types)\n- [ ] AC V-5: Update existing memory unit by ID\n- [ ] AC V-6: Delete memory unit by ID\n- [ ] AC N-W1: Single MemoryManager class with CRUD for all 7 types\n- [ ] AC Adj-W1: Constructor takes only db_path + embedder\n- [ ] AC V-2: Vector search returns correct top-1 (80%)\n- [ ] AC V-3: Lexical search returns correct top-1 (80%)\n- [ ] AC V-4: Hybrid >= max(vector, lexical)\n- [ ] AC A-E2: Single write < 200ms\n- [ ] AC A-E3: Single read (top-5) < 100ms\n- [ ] AC A-S2: Secret patterns rejected at write time\n- [ ] AC A-S3: Duplicate detection rejects >0.95 cosine similarity",
            "dod": "MemoryManager CRUD works for all 7 types. Hybrid search outperforms individual. Secrets blocked. Dupes caught.",
            "short_id": "D4-MANAGER",
        },
        {
            "key": "D5", "name": "Click CLI",
            "vana": "Every LTC member can interact with the memory engine from the terminal via memory write, memory read, memory stats, memory audit, memory setup — with JSON output, help examples, and human-readable error messages.",
            "acs": "- [ ] AC N-W2: CLI: write, read, update, delete, stats, audit, config, setup\n- [ ] AC Adj-W2: Every command has --help with examples\n- [ ] AC Adj-W3: Exit code 0/1, human-readable errors\n- [ ] AC V-10: Install in under 5 minutes\n- [ ] AC V-11: memory stats + audit show health\n- [ ] AC N-W3: 11-step idempotent setup wizard\n- [ ] AC N-W4: stats + audit in JSON\n- [ ] AC A-E1: Setup < 5 min, zero manual config\n- [ ] AC A-E4: Setup idempotent\n- [ ] AC Adj-W4: Setup no partial state on failure\n- [ ] AC Adj-W5: memory stats ≤ 30 lines",
            "dod": "All 8 CLI commands work. Setup wizard idempotent. JSON output on all commands. Human-readable errors.",
            "short_id": "D5-CLI",
        },
        {
            "key": "D6", "name": "Final Integration + AC Verification",
            "vana": "The complete memory engine passes all I1 acceptance criteria end-to-end: write → search → update → search → delete → verify across all modules working together.",
            "acs": "- [ ] All 30 I1 ACs pass end-to-end\n- [ ] Full round-trip integration test passes",
            "dod": "Integration test passes. All 30 ACs verified with evidence.",
            "short_id": "D6-INTEGRATION",
        },
    ]

    print("\n[3] Creating 6 PJ Deliverables...")
    for d in deliverables:
        d_cf = [
            {"id": CF_DESIRED_OUTCOMES, "value": d["vana"]},
            {"id": CF_ACCEPTANCE_CRITERIA, "value": d["acs"]},
            {"id": CF_MOSCOW, "value": MUST_HAVE},
            {"id": CF_DELIVERY_PHASE, "value": PHASE_CONCEPT},
            {"id": CF_SHORT_ID, "value": d["short_id"]},
            {"id": CF_DOD, "value": d["dod"]},
        ]
        payload = {
            "name": d["name"],
            "parent": ws_id,
            "priority": 2,
            "status": "ready/prioritized",
            "assignees": [ASSIGNEE],
            "custom_fields": d_cf,
        }
        result = api_call("POST", f"{BASE}/list/{LIST_ID}/task", payload)
        d_id = result["id"]
        created_ids[d["key"]] = d_id
        print(f"  {d['key']}: {d['name']} -> {d_id}")
        if type_map.get("PJ Deliverable") is not None:
            api_call("PUT", f"{BASE}/task/{d_id}", {"custom_item_id": type_map["PJ Deliverable"]})
        time.sleep(1)

    # Step 4: Create Tasks under Deliverables
    tasks = [
        {"key": "D1-T1", "parent_key": "D1", "name": "Data Models",
         "vana": "Define MemoryUnit, TokenUsage, ConversationRow dataclasses with full type annotations and minimal constructor.",
         "acs": "- [ ] AC Adj-W1: Constructor takes only db_path + embedder",
         "desc": "Implement data models: MemoryUnit (7 types), TokenUsage, ConversationRow. All as frozen dataclasses with factory methods."},
        {"key": "D1-T2", "parent_key": "D1", "name": "Package Scaffolding",
         "vana": "Package structure passes pip install -e . and all models are importable from memory_engine.",
         "acs": "- [ ] AC V-10: Install in under 5 minutes",
         "desc": "pyproject.toml, src/memory_engine/__init__.py, conftest.py with shared fixtures. pip install -e . must work."},
        {"key": "D2-T1", "parent_key": "D2", "name": "Config Module",
         "vana": "TOML config at ~/.config/memory-engine/config.toml loads, saves, and provides defaults for all engine settings.",
         "acs": "- [ ] AC N-I3: TOML config at ~/.config/memory-engine/config.toml\n- [ ] AC Adj-I4: Config human-readable, every field commented",
         "desc": "config.py: load_config(), save_config(), DEFAULT_CONFIG. TOML format, human-readable, all fields commented."},
        {"key": "D2-T2", "parent_key": "D2", "name": "Storage Layer",
         "vana": "SQLite storage with WAL, FTS5, 7 tables, atomic transactions for all memory CRUD operations.",
         "acs": "- [ ] AC N-I1: SQLite DB with WAL, FTS5, sqlite-vec, 7+ tables\n- [ ] AC Adj-I1: Single-file, zero-server, portable\n- [ ] AC Adj-I2: WAL mode at creation\n- [ ] AC A-S1: Atomic writes",
         "desc": "storage.py: SQLite + WAL + FTS5 + sqlite-vec. 7 memory tables + 3 FTS virtual tables + triggers. All writes atomic."},
        {"key": "D3-T1", "parent_key": "D3", "name": "Local Embedder",
         "vana": "sentence-transformers wrapper that embeds text to 384-dim vectors with lazy loading and FTS5 fallback.",
         "acs": "- [ ] AC N-I2: all-MiniLM-L6-v2, embed(\"test\") → 384 floats\n- [ ] AC Adj-I3: Loads <3s cold, <200ms warm\n- [ ] AC A-S4: Failure degrades to FTS5-only",
         "desc": "embedder.py: LocalEmbedder class. Lazy model loading, embed(), embed_batch(), dimensions property. EmbedderUnavailable exception for graceful fallback."},
        {"key": "D4-T1", "parent_key": "D4", "name": "MemoryManager CRUD",
         "vana": "Single MemoryManager class with write/read/update/delete for all 7 memory types.",
         "acs": "- [ ] AC V-1: Store memory unit (any of 7 types)\n- [ ] AC V-5: Update by ID\n- [ ] AC V-6: Delete by ID\n- [ ] AC N-W1: Single class, CRUD for all 7 types\n- [ ] AC Adj-W1: Constructor takes only db_path + embedder",
         "desc": "manager.py: MemoryManager class. write(), read(), update(), delete(), get_by_id(), list_by_type(), stats()."},
        {"key": "D4-T2", "parent_key": "D4", "name": "Search Quality + Performance",
         "vana": "Hybrid search (vector + FTS5) that outperforms either method alone, within latency targets.",
         "acs": "- [ ] AC V-2: Vector search correct top-1 (80%)\n- [ ] AC V-3: Lexical search correct top-1 (80%)\n- [ ] AC V-4: Hybrid >= max(vector, lexical)\n- [ ] AC A-E2: Write < 200ms\n- [ ] AC A-E3: Read top-5 < 100ms",
         "desc": "search() method with mode=hybrid|vector|lexical. Benchmark tests for latency. Quality tests with known-answer pairs."},
        {"key": "D4-T3", "parent_key": "D4", "name": "Secret Scanning + Dedup Detection",
         "vana": "Reject secret patterns at write time and detect near-duplicate memories by cosine similarity.",
         "acs": "- [ ] AC A-S2: Secret patterns rejected at write time\n- [ ] AC A-S3: Dedup rejects >0.95 cosine similarity",
         "desc": "Pre-write validation: regex-based secret scanning (API keys, tokens, passwords). Cosine similarity check against existing memories."},
        {"key": "D5-T1", "parent_key": "D5", "name": "Core CLI Commands",
         "vana": "8 Click commands (write, read, update, delete, stats, audit, config, setup) with --json, --quiet, --help.",
         "acs": "- [ ] AC N-W2: CLI: write, read, update, delete, stats, audit, config, setup\n- [ ] AC Adj-W2: Every command has --help with examples\n- [ ] AC Adj-W3: Exit code 0/1, human-readable errors",
         "desc": "cli.py: Click group with 8 subcommands. --json flag on all. --quiet flag. --help with usage examples. Human-readable error messages."},
        {"key": "D5-T2", "parent_key": "D5", "name": "Setup Wizard + Integration Test",
         "vana": "11-step idempotent setup wizard that configures the engine from scratch in <5 minutes.",
         "acs": "- [ ] AC V-10: Install <5 min\n- [ ] AC V-11: stats + audit show health\n- [ ] AC N-W3: 11-step idempotent setup wizard\n- [ ] AC N-W4: stats + audit in JSON\n- [ ] AC A-E1: Setup <5 min, zero manual config\n- [ ] AC A-E4: Setup idempotent",
         "desc": "memory setup: 11-step wizard (create dirs, init DB, download model, create config, verify). Idempotent — running twice = same state."},
        {"key": "D6-T1", "parent_key": "D6", "name": "Full Integration Test",
         "vana": "End-to-end verification that all 30 I1 ACs pass across all modules working together.",
         "acs": "- [ ] All 30 I1 ACs pass end-to-end\n- [ ] Full round-trip: setup → write → search → update → search → delete → stats",
         "desc": "Integration test: setup → write all 7 types → hybrid search → update → verify update → delete → verify deletion → stats → audit. AC checklist verification."},
    ]

    print("\n[4] Creating 11 Tasks...")
    for t in tasks:
        t_cf = [
            {"id": CF_DESIRED_OUTCOMES, "value": t["vana"]},
            {"id": CF_ACCEPTANCE_CRITERIA, "value": t["acs"]},
            {"id": CF_MOSCOW, "value": MUST_HAVE},
            {"id": CF_SHORT_ID, "value": t["key"]},
        ]
        parent_id = created_ids[t["parent_key"]]
        payload = {
            "name": t["name"],
            "parent": parent_id,
            "priority": 2,
            "status": "ready/prioritized",
            "assignees": [ASSIGNEE],
            "description": t["desc"],
            "custom_fields": t_cf,
        }
        result = api_call("POST", f"{BASE}/list/{LIST_ID}/task", payload)
        t_id = result["id"]
        created_ids[t["key"]] = t_id
        print(f"  {t['key']}: {t['name']} -> {t_id}")
        # Tasks use default type (custom_item_id = 0), no need to update
        time.sleep(1)

    # Step 5: Create PJ Increments (1 per Task) with time estimates
    increments = [
        {"key": "D1-T1-I1", "parent_key": "D1-T1", "name": "Implement data models (MemoryUnit, TokenUsage, ConversationRow)", "minutes": 30},
        {"key": "D1-T2-I1", "parent_key": "D1-T2", "name": "Set up pyproject.toml + package structure + conftest.py", "minutes": 45},
        {"key": "D2-T1-I1", "parent_key": "D2-T1", "name": "Implement TOML config load/save/defaults", "minutes": 45},
        {"key": "D2-T2-I1", "parent_key": "D2-T2", "name": "Implement SQLite storage with WAL + FTS5 + 7 tables", "minutes": 90},
        {"key": "D3-T1-I1", "parent_key": "D3-T1", "name": "Implement sentence-transformers wrapper + fallback", "minutes": 45},
        {"key": "D4-T1-I1", "parent_key": "D4-T1", "name": "Implement MemoryManager CRUD for 7 types", "minutes": 90},
        {"key": "D4-T2-I1", "parent_key": "D4-T2", "name": "Implement hybrid search + latency benchmarks", "minutes": 60},
        {"key": "D4-T3-I1", "parent_key": "D4-T3", "name": "Implement secret scanning + cosine dedup", "minutes": 45},
        {"key": "D5-T1-I1", "parent_key": "D5-T1", "name": "Implement 8 Click CLI commands", "minutes": 60},
        {"key": "D5-T2-I1", "parent_key": "D5-T2", "name": "Implement 11-step setup wizard + integration test", "minutes": 60},
        {"key": "D6-T1-I1", "parent_key": "D6-T1", "name": "Run full AC verification across all modules", "minutes": 45},
    ]

    print("\n[5] Creating 11 PJ Increments (with time estimates)...")
    for inc in increments:
        i_cf = [
            {"id": CF_MOSCOW, "value": MUST_HAVE},
            {"id": CF_SHORT_ID, "value": inc["key"]},
        ]
        parent_id = created_ids[inc["parent_key"]]
        payload = {
            "name": inc["name"],
            "parent": parent_id,
            "priority": 2,
            "status": "ready/prioritized",
            "assignees": [ASSIGNEE],
            "custom_fields": i_cf,
        }
        result = api_call("POST", f"{BASE}/list/{LIST_ID}/task", payload)
        i_id = result["id"]
        created_ids[inc["key"]] = i_id
        print(f"  {inc['key']}: {inc['name']} -> {i_id}")

        # Set task type to PJ Increment
        if type_map.get("PJ Increment") is not None:
            api_call("PUT", f"{BASE}/task/{i_id}", {"custom_item_id": type_map["PJ Increment"]})

        # Set time estimate
        set_time_estimate(i_id, inc["minutes"])
        print(f"    Time: {inc['minutes']} min")
        time.sleep(1)

    # Step 6: Set dependencies
    dependencies = [
        # D1-T2 depends on D1-T1
        ("D1-T2", "D1-T1"),
        # D2-T1 depends on D1-T2
        ("D2-T1", "D1-T2"),
        # D2-T2 depends on D1-T2
        ("D2-T2", "D1-T2"),
        # D3-T1 depends on D1-T2
        ("D3-T1", "D1-T2"),
        # D4-T1 depends on D2-T2 and D3-T1
        ("D4-T1", "D2-T2"),
        ("D4-T1", "D3-T1"),
        # D4-T2 depends on D4-T1
        ("D4-T2", "D4-T1"),
        # D4-T3 depends on D4-T1
        ("D4-T3", "D4-T1"),
        # D5-T1 depends on D2-T1, D4-T1, D4-T3
        ("D5-T1", "D2-T1"),
        ("D5-T1", "D4-T1"),
        ("D5-T1", "D4-T3"),
        # D5-T2 depends on D5-T1
        ("D5-T2", "D5-T1"),
        # D6-T1 depends on D5-T2
        ("D6-T1", "D5-T2"),
    ]

    print("\n[6] Setting 12 dependencies...")
    for task_key, dep_key in dependencies:
        task_id = created_ids[task_key]
        dep_id = created_ids[dep_key]
        try:
            add_dependency(task_id, dep_id)
            print(f"  {task_key} waiting_on {dep_key}")
        except Exception as e:
            print(f"  WARN: {task_key} → {dep_key} failed: {e}")
        time.sleep(0.5)

    # Summary
    print("\n=== DONE ===")
    print(f"Total items created: {len(created_ids)}")
    print(f"\nCreated IDs:")
    for key, cid in created_ids.items():
        print(f"  {key}: https://app.clickup.com/t/{cid}")

    # Save created IDs for reference
    with open(os.path.join(os.path.dirname(__file__), "clickup-ids.json"), "w") as f:
        json.dump(created_ids, f, indent=2)
    print(f"\nIDs saved to .exec/clickup-ids.json")


if __name__ == "__main__":
    main()
