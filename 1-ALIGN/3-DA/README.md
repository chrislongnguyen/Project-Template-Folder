---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 1-ALIGN
stage: build
type: template
sub_system: 3-DA
iteration: 2
---

# 3-DA — Data Analysis | ALIGN Workstream

Alignment artifacts for the Data Analysis subsystem: charter, OKRs, and decisions that define what analytical outputs DA must produce. DA scope is doubly constrained: by PD's problem definition and by DP's data availability commitments. DA cannot analyze what DP cannot supply.

## Cascade Position

```
[1-PD] ──► [2-DP] ──► [3-DA] ──► [4-IDM]
                          ↑
                          Receives PD constraints + DP data guarantees. Produces analytical outputs for IDM.
```

Receives from upstream: PD effective principles (`1-ALIGN/1-PD/`), DP data availability commitments (`1-ALIGN/2-DP/`).
Produces for downstream: DA output specifications, model/method decisions — consumed by IDM as the analytical substrate for decision support.

## Contents

| Artifact | File Pattern | Purpose |
|----------|-------------|---------|
| DA Charter | `da-charter.md` | Purpose, scope, analytical methods, success criteria for DA |
| DA OKR Register | `da-okr.md` | Objectives and key results scoped to DA |
| DA Decisions | `ADR-{id}_{slug}.md` | Model selection, analytical framework decisions |
| DA Output Spec | `da-output-spec.md` | What DA commits to produce for IDM |
