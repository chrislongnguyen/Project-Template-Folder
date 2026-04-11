---
version: "1.1"
status: draft
last_updated: 2026-04-11
work_stream: 4-EXECUTE
sub_system: _cross
---

# 4-EXECUTE / _cross — Cross-Cutting Execution Artifacts

> **You are here:** `4-EXECUTE/_cross/` — Shared execution artifacts that span multiple subsystems: integration tests, deployment orchestration, and shared configuration.

## What Goes Here

Cross-cutting execution artifacts that no single subsystem owns: shared configuration or infrastructure documentation that applies to all subsystems, cross-subsystem integration test plans (verifying that DP outputs flow correctly into DA, DA results flow correctly into IDM), and deployment orchestration artifacts.

## How to Create Artifacts

```
/dsbv design execute _cross      # Step 1: Design cross-cutting execution scope
/dsbv sequence execute _cross    # Step 2: Sequence integration and deployment tasks
/dsbv build execute _cross       # Step 3: Produce integration tests, deployment docs
/dsbv validate execute _cross    # Step 4: Verify end-to-end integration
```

## What's Here Now

This directory is empty — artifacts are generated on-demand when you run the commands above.

## Prerequisites

Individual subsystem builds (PD, DP, DA, IDM) should be complete or nearly complete before integration testing. Cross-cutting work confirms that subsystems connect correctly end-to-end.

## Why _cross Exists

Unit tests in each subsystem verify that component works in isolation. Integration tests in `_cross/` verify that the full chain works: raw input → transformed data → analysis results → delivered output.

## Templates

| Artifact | Template | Location |
|----------|----------|----------|
| Test plan | `test-plan-template.md` | `../../_genesis/templates/test-plan-template.md` |
| Design spec | `design-template.md` | `../../_genesis/templates/design-template.md` |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[workstream]]
