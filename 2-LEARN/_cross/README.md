---
version: "2.4"
status: draft
last_updated: 2026-04-11
work_stream: 2-LEARN
sub_system: _cross
---

# 2-LEARN / _cross — Pipeline Staging + Shared Infrastructure

> **You are here:** `2-LEARN/_cross/` — The central pipeline staging area. Skills route through here automatically. Also holds shared templates, scripts, and references for all 4 subsystems.

## What Goes Here

Two roles in one directory:

1. **Pipeline staging** — `/learn:*` skills write pipeline content here. The 6-state pipeline (input → research → output → specs) passes through `_cross/` subdirectories.
2. **Shared infrastructure** — Templates, scripts, references, and config used by all 4 subsystems (PD, DP, DA, IDM). A standard defined here applies to everyone; do not duplicate it into subsystem dirs.

## How to Create Artifacts

Pipeline content is routed here automatically by skills — you do not manually place files here:

```
/learn:input       # Routes to _cross/input/
/learn:research    # Routes to _cross/research/
/learn:structure   # Routes to _cross/output/
/learn:spec        # Routes to _cross/specs/
```

For shared infrastructure (templates, scripts), create files directly in the appropriate subdir.

## What's Here Now

This directory may contain pipeline configuration and shared templates. Pipeline content is generated on-demand.

## Prerequisites

None — `_cross` infrastructure should be set up before subsystem pipeline work begins. Skills depend on the directory structure and config files being in place.

## Directory Map

| Directory | Role | What lives here |
|-----------|------|-----------------|
| `input/` | S1 staging | `learn-input-{slug}.md` files, raw captures |
| `research/` | S2 staging | Structured research per topic, evidence files |
| `output/` | S3+S4 staging | P0–P5 structured pages (status set by human review) |
| `specs/` | S5 staging | VANA-SPEC + Readiness Packages |
| `templates/` | Shared infra | Artifact templates used by all subsystems |
| `scripts/` | Shared infra | Pipeline validation and automation scripts |
| `references/` | Shared infra | Shared bibliography and source registry |
| `config/` | Shared infra | Pipeline configuration files |
| `visual/` | Post-S5 | HTML system maps from `/learn:visualize` |

## Links

- [[SKILL]]
- [[standard]]
- [[workstream]]
