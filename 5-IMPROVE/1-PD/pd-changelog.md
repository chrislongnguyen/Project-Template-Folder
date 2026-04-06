---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 5-IMPROVE
stage: build
type: changelog
sub_system: 1-PD
iteration: 2
---

# PD Subsystem Changelog

## Purpose

Tracks all meaningful changes to the Problem Diagnosis subsystem: framework updates, template revisions, scope changes, tooling shifts, and process corrections. Every entry must be logged here before the change propagates downstream.

## Change Log

| Date       | Version | Change                         | Author | Impact                              |
|------------|---------|--------------------------------|--------|-------------------------------------|
| 2026-04-05 | 2.0     | Initial changelog created      | —      | None — baseline record established  |

## Semantic Versioning Notes

PD changelog versions track subsystem-level state, not individual artifact versions.

- **MAJOR bump** (X.0): Structural change to PD frameworks, principles, or scope. Triggers cascade review across DP, DA, IDM.
- **MINOR bump** (X.Y): Template revisions, tooling updates, process corrections. Downstream notification recommended but cascade review optional.
- **No bump**: Typo fixes, metadata corrections, formatting only.

When a MAJOR change is logged, add a corresponding entry in `5-IMPROVE/_cross/cross-feedback-register.md` to track cascade resolution status across downstream subsystems.
