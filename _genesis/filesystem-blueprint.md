---
version: "1.1"
status: draft
last_updated: 2026-04-06
work_stream: 3-PLAN
stage: design
type: ues-deliverable
sub_system: _cross
component: EOE
iteration: 2
owner: "long nguyen"
---

# Filesystem Blueprint — LTC Project Repos

> Canonical structure for all LTC project repositories cloned from this template.
> Enforced by: `rules/filesystem-routing.md` (always-on) + PreToolUse hooks.
> Evidence: `archive/I2/improve/filesystem-depth-test` branch (40 AI tasks, 16 disk verifications, 3-agent CI/CD research, 4 falsification tests).

**Feedback:** If any part of this structure causes a blocker, failure, or obstacle during your work, report it immediately via `/feedback`. The structure is evidence-backed but not infallible — first-hand failures override theoretical models.

---

## P1: Structure — 3 Layers (Documents) / 4 Layers (Code)

### The Tree

```
project-root/
│
├── 1-ALIGN/                          ← L1: Workstream
│   ├── DESIGN.md                     ← DSBV meta-artifact (workstream scope)
│   ├── README.md
│   ├── SEQUENCE.md                   ← DSBV meta-artifact (task order)
│   ├── VALIDATE.md                   ← DSBV meta-artifact (done criteria)
│   ├── charter/                      ← Legacy dir (pre-subsystem); migrate to 1-PD/
│   │   └── drafts/
│   ├── 1-PD/                         ← L2: Subsystem (sequential, PD governs all)
│   │   ├── pd-charter.md             ← L3: Artifact (subsystem-prefixed)
│   │   ├── pd-decision-adr-001.md
│   │   └── pd-okr-q2.md
│   ├── 2-DP/
│   ├── 3-DA/
│   ├── 4-IDM/
│   └── _cross/                       ← Cross-cutting artifacts (span subsystems)
│       ├── README.md
│       ├── cross-stakeholder-map.md
│       └── cross-stakeholder-raci.md
│
├── 2-LEARN/                              ← Pipeline workstream: uses 6-state learning pipeline, NOT DSBV
│   ├── README.md
│   ├── 1-PD/                             ← Full detail shown here; 2-DP, 3-DA, 4-IDM follow same structure
│   │   ├── README.md
│   │   ├── input/                        ← S1 Scope: research questions, scoping docs, raw captures
│   │   ├── research/                     ← S2 Research: structured UBS/UDS evidence, source investigations
│   │   ├── output/                       ← S3 Structure: organized P-pages (P0–P5), structured findings
│   │   ├── specs/                        ← S5 Spec: VANA-SPEC, derived Effective Principles (S/E/Sc)
│   │   ├── archive/                      ← Superseded drafts and rejected hypotheses
│   │   ├── pd-ubs-analysis.md            ← UBS analysis (sections 1.0–1.6)
│   │   ├── pd-uds-analysis.md            ← UDS analysis (sections 2.0–2.6)
│   │   ├── pd-effective-principles.md    ← Derived EP: S-Principles, E-Principles
│   │   ├── pd-research-spec.md           ← Research specification and methodology
│   │   └── pd-literature-review.md       ← Literature review and source synthesis
│   ├── 2-DP/                             ← Same pipeline structure as 1-PD (dp-* prefixed artifacts)
│   ├── 3-DA/                             ← Same pipeline structure as 1-PD (da-* prefixed artifacts)
│   ├── 4-IDM/                            ← Same pipeline structure as 1-PD (idm-* prefixed artifacts)
│   └── _cross/                           ← Cross-subsystem: shared frameworks, reusable UBS/UDS patterns
│       ├── README.md
│       ├── config/                       ← Shared config for cross-subsystem learning tools
│       ├── references/                   ← Shared reference materials
│       ├── scripts/                      ← Shared scripts for learning pipeline
│       └── templates/                    ← Shared templates for learning artifacts
│
├── 3-PLAN/
│   ├── DESIGN.md                     ← DSBV meta-artifact (workstream scope)
│   ├── README.md
│   ├── SEQUENCE.md                   ← DSBV meta-artifact (task order)
│   ├── VALIDATE.md                   ← DSBV meta-artifact (done criteria)
│   ├── architecture/                 ← Legacy dir (pre-subsystem); migrate to 1-PD/
│   │   ├── ADRs/
│   │   ├── diagrams/
│   │   └── meta-project/
│   ├── risks/                        ← Legacy dir (pre-subsystem); migrate to subsystem dirs
│   ├── 1-PD/
│   │   ├── pd-architecture.md
│   │   ├── pd-risk-register.md
│   │   ├── pd-driver-register.md
│   │   ├── pd-roadmap.md
│   │   └── pd-dependency-map.md
│   ├── 2-DP/
│   ├── 3-DA/
│   ├── 4-IDM/
│   └── _cross/
│       ├── README.md
│       └── cross-dependency-map.md
│
├── 4-EXECUTE/                        ← L1: Workstream
│   ├── DESIGN.md                     ← DSBV meta-artifact (workstream scope)
│   ├── README.md
│   ├── SEQUENCE.md                   ← DSBV meta-artifact (task order)
│   ├── VALIDATE.md                   ← DSBV meta-artifact (done criteria)
│   ├── docs/                         ← Cross-workstream technical documentation
│   │   ├── api/
│   │   ├── onboarding/
│   │   └── runbooks/
│   ├── 1-PD/                         ← L2: Subsystem
│   │   ├── src/                      ← L3: Code type (EXECUTE only)
│   │   │   └── *.py                  ← L4: Code files
│   │   ├── tests/
│   │   ├── config/
│   │   └── docs/
│   ├── 2-DP/
│   │   ├── src/                      ← Python pipelines, lakeFS integration
│   │   ├── tests/
│   │   ├── config/
│   │   └── notebooks/                ← Colab/Jupyter data science work
│   ├── 3-DA/
│   │   ├── src/                      ← Dataform SQL, Python ML models
│   │   ├── tests/
│   │   ├── config/
│   │   └── notebooks/                ← Jupyter/Colab analytics notebooks
│   └── 4-IDM/
│       ├── src/                      ← Dashboards, decision tooling
│       └── config/
│
├── 5-IMPROVE/
│   ├── DESIGN.md                     ← DSBV meta-artifact (workstream scope)
│   ├── README.md
│   ├── SEQUENCE.md                   ← DSBV meta-artifact (task order)
│   ├── VALIDATE.md                   ← DSBV meta-artifact (done criteria)
│   ├── 1-PD/
│   │   ├── pd-changelog.md
│   │   ├── pd-retro-sprint-1.md
│   │   └── pd-metrics.md
│   ├── 2-DP/
│   ├── 3-DA/
│   ├── 4-IDM/
│   └── _cross/
│       ├── README.md
│       ├── cross-changelog.md        ← Project-wide changelog
│       ├── cross-feedback-register.md
│       └── cross-metrics-baseline.md
│
├── _genesis/                          ← Shared: frameworks, templates, brand, reference
│   ├── filesystem-blueprint.md        ← THIS DOCUMENT (Mode D — OE-builder artifact)
├── .claude/                           ← Agent: rules, skills, agents, settings
│
├── DAILY-NOTES/                       ← PM personal: daily capture
├── MISC-TASKS/                        ← PM personal: ad-hoc tasks
└── inbox/                             ← PM personal: quick capture
```

### What Each Layer Encodes

| Layer | Dimension | Example | Stable? | Why folder, not frontmatter? |
|-------|-----------|---------|---------|------------------------------|
| L1 | Workstream (ALPEI) | `1-ALIGN/` | Permanent | Primary navigation axis. Never changes. Numbered to enforce sequence. |
| L2 | Subsystem | `1-PD/` | Per-project | Domain boundary. Sequential (PD governs all). Swappable per FA. |
| L3 (docs) | Artifact | `pd-charter.md` | Permanent | Files land here. Subsystem prefix prevents name collisions. |
| L3 (code) | Code type | `src/` | Permanent | Tooling requires it: Python imports, test runners, config loaders. |
| L4 (code) | Code file | `pipeline.py` | Evolving | Actual source code, tests, configs. |

### What Frontmatter Encodes (NOT folders)

| Dimension | Frontmatter field | Why NOT a folder? |
|-----------|------------------|-------------------|
| Iteration (I0-I4) | `version`, `iteration_name` | Temporal — file evolves across iterations, folder would lie or force duplication |
| DSBV stage | `stage` | Lifecycle — file progresses through stages, stays in same location |
| Status | `status` | Changes frequently (draft → review → approved) |
| 8-CS component | `component` | Cross-cutting property, not a spatial container |
| UES version | `ues_version` | Tracked by version number, not physical location |

**Grounding — UT#5 + UBS-1:** Encoding temporal dimensions (iteration, DSBV stage) as folders forces files to either duplicate across folders (breaking single-source-of-truth) or stay in misleading locations (a validated charter sitting in a "design" folder). Frontmatter + Obsidian Bases provides the same multi-dimensional view without physical movement. This reduces failure risk (S) and cognitive load (UBS-1: junior PM paralysis from empty folders).

---

## P2: Naming Principles

### Folder Naming

| Rule | Format | Example | Grounding |
|------|--------|---------|-----------|
| N1: Workstream prefix | `{N}-{NAME}` ALL CAPS | `1-ALIGN`, `4-EXECUTE` | Enforces ALPEI sequence (UT#7: work streams are sequential) |
| N2: Subsystem prefix | `{N}-{CODE}` ALL CAPS | `1-PD`, `3-DA` | Enforces sub-system sequence (Principle 6: PD governs all) |
| N3: Code type | lowercase | `src`, `tests`, `config` | Industry standard. Python/Node tooling expects lowercase. |
| N4: Cross-cutting | `_cross` | `_cross/` | Underscore prefix sorts first. Signals "spans subsystems." |
| N5: PM personal | ALL CAPS | `DAILY-NOTES`, `MISC-TASKS` | Visually distinct from workstream folders. Not agent-managed. |

### Folder Naming — Forbidden Patterns

| Pattern | Why forbidden | Source |
|---------|--------------|--------|
| Dots in folder names (`1.1. ALIGN`) | Breaks shell globbing, confuses `version: "1.1"` parsing, fails on some CI systems | GAN synthesis (2026-04-03): Vinh's decimal system "does NOT scale to Git, CI/CD, or cross-platform" |
| Spaces in folder names | Breaks unquoted shell scripts, requires escaping in every tool, fails in GitHub Actions YAML | POSIX portability. 100% of CI/CD examples use no-space paths. |
| Mixed case folders (`Problem-Diagnosis`) | Case-insensitive filesystems (macOS HFS+, Windows NTFS) silently merge `PD/` and `pd/`. Git tracks case but OS doesn't. | Git documentation: "core.ignoreCase" default on macOS/Windows. Confirmed by naming-lint.sh enforcement. |
| Special chars (`:`, `*`, `?`, `"`, `<`, `>`, `\|`) | Windows filesystem forbidden characters. Silent failures or data corruption. | Windows NTFS specification. Affects any team member on Windows. |
| Unicode/accented chars in paths | Normalization differences between NFC (Linux) and NFD (macOS) cause invisible path mismatches. | Apple Technical Note TN1150. Git issue #400. |

**Grounding — UDS-3 (plain-text substrate):** Plain-text files are universal only if their paths are universal. A path that works on macOS but fails on Windows violates the "version-controlled, AI-readable" promise of UDS-3.

### File Naming

| Rule | Format | Example | Grounding |
|------|--------|---------|-----------|
| F1: Subsystem prefix | `{sub}-{name}.md` | `pd-charter.md` | Prevents Obsidian `[[wikilink]]` collisions across subsystems. Each of PD/DP/DA/IDM produces charters, architectures, etc. |
| F2: Cross-cutting prefix | `cross-{name}.md` | `cross-changelog.md` | Signals artifact spans all subsystems. |
| F3: kebab-case | lowercase, hyphens | `pd-risk-register.md` | Consistent with UNG word-join rules. No underscores in filenames (reserved for scope boundaries). |
| F4: Python files | snake_case | `ingest_pipeline.py` | PEP 8 standard. Python imports require underscore-separated module names. |
| F5: ADR numbering | `{sub}-decision-adr-{NNN}.md` | `pd-decision-adr-001.md` | Sequential numbering prevents collision. Industry ADR convention. |

---

## P3: Subsystem Swappability

The default subsystems (`1-PD`, `2-DP`, `3-DA`, `4-IDM`) serve the **UE (User Enablement)** functional area for investment projects. Other LTC functional areas use different subsystems:

| FA | Example subsystems | Same structure, different L2 |
|----|-------------------|------------------------------|
| UE (Investment) | 1-PD, 2-DP, 3-DA, 4-IDM | Default in this template |
| OPS (Operations) | 1-PD, 2-PROC, 3-AUTO, 4-GOV | Process, Automation, Governance |
| Custom | 1-{A}, 2-{B}, 3-{C}, 4-{D} | Any sequential pipeline |

**Rules for swapping:**
1. Always numbered (`1-`, `2-`, `3-`, `4-`) to enforce sequential dependency
2. First subsystem (`1-*`) always produces Effective Principles that govern downstream — this is structural, not a convention
3. Codes are 2-4 uppercase letters (short, greppable, no spaces)
4. Update `rules/filesystem-routing.md` after swapping to reflect new subsystem codes

**Grounding — Principle 6 (sub-systems are sequential, PD governs all):** The numbering physically encodes the dependency chain. `2-DP` cannot start DSBV Build until `1-PD` has a validated artifact. The folder name reminds every PM and every agent of this constraint.

---

## P4: EXECUTE Workstream — Code Organization

EXECUTE is the only workstream with a 4th layer. Code requires tooling-compatible organization:

```
4-EXECUTE/{N}-{SUB}/
├── src/              ← Production code
│   ├── *.py          ← Python modules (snake_case, PEP 8)
│   ├── *.sql         ← Dataform SQL models
│   └── *.js          ← Node.js if applicable
├── tests/            ← All test types
│   ├── test_*.py     ← Unit tests (pytest convention)
│   └── *.test.js     ← JS tests if applicable
├── config/           ← Environment configs, secrets references
│   ├── *.json
│   ├── *.yaml
│   └── .env.example  ← Template only, never actual secrets
├── notebooks/        ← Jupyter/Colab (DP and DA subsystems)
│   └── *.ipynb
└── docs/             ← Technical documentation for this subsystem's code
    └── *.md
```

**Grounding — UDS-2 (AI execution speed):** AI agents write production code. Python test runners expect `tests/` directories. Import resolution expects `src/` layout. Dataform compilers expect `definitions/` or `models/`. Matching industry conventions means zero configuration for the agent — it knows where to put code without consulting a routing table.

---

## P5: What Goes Where — Decision Matrix

When creating an artifact, answer two questions:

```
Q1: Which workstream?     → L1 folder (1-ALIGN through 5-IMPROVE)
Q2: Which subsystem?      → L2 folder (1-PD through 4-IDM, or _cross)
```

Then consult the file naming rule:

| Artifact type | Workstream | Name pattern | Example |
|--------------|------------|--------------|---------|
| Charter | ALIGN | `{sub}-charter.md` | `pd-charter.md` |
| Decision / ADR | ALIGN | `{sub}-decision-adr-{NNN}.md` | `dp-decision-adr-001.md` |
| OKR | ALIGN | `{sub}-okr-{period}.md` | `pd-okr-q2.md` |
| Stakeholder map | ALIGN | `cross-stakeholder-map.md` | (cross-cutting) |
| UBS analysis | LEARN | `{sub}-ubs-analysis.md` | `pd-ubs-analysis.md` |
| UDS analysis | LEARN | `{sub}-uds-analysis.md` | `pd-uds-analysis.md` |
| Research spec | LEARN | `{sub}-research-spec.md` | `da-research-spec.md` |
| Effective Principles | LEARN | `{sub}-effective-principles.md` | `pd-effective-principles.md` |
| Literature review | LEARN | `{sub}-literature-review.md` | `dp-literature-review.md` |
| Architecture | PLAN | `{sub}-architecture.md` | `pd-architecture.md` |
| Risk register | PLAN | `{sub}-risk-register.md` | `dp-risk-register.md` |
| Driver register | PLAN | `{sub}-driver-register.md` | `da-driver-register.md` |
| Roadmap | PLAN | `{sub}-roadmap.md` | `pd-roadmap.md` |
| Dependency map | PLAN | `{sub}-dependency-map.md` | `cross-dependency-map.md` |
| Source code | EXECUTE | `src/{name}.py` | `src/ingest_pipeline.py` |
| Tests | EXECUTE | `tests/test_{name}.py` | `tests/test_pipeline.py` |
| Config | EXECUTE | `config/{name}.yaml` | `config/pipeline.yaml` |
| Notebook | EXECUTE | `notebooks/{name}.ipynb` | `notebooks/factor-analysis.ipynb` |
| Changelog | IMPROVE | `{sub}-changelog.md` | `pd-changelog.md` |
| Retrospective | IMPROVE | `{sub}-retro-{id}.md` | `pd-retro-sprint-1.md` |
| Metrics | IMPROVE | `{sub}-metrics.md` | `da-metrics.md` |
| Feedback register | IMPROVE | `{sub}-feedback-register.md` | `cross-feedback-register.md` |

**Grounding — LT-1 (cascading hallucination):** Without a deterministic routing table, the agent guesses file locations. Guesses cascade — a charter placed in PLAN instead of ALIGN breaks the chain-of-custody rule, which causes downstream agents to reference the wrong file, which produces artifacts based on incorrect context. One routing mistake compounds into N downstream errors. The table eliminates the first guess.

---

## P6: Directory Count Analysis

```
Workstream dirs:    5  (1-ALIGN through 5-IMPROVE)
Subsystem dirs:     5 × 5 = 25  (4 subsystems + _cross per workstream)
EXECUTE L3 dirs:    4 × 4 = 16  (src/tests/config/docs per subsystem, avg)
PM personal dirs:   3  (DAILY-NOTES, MISC-TASKS, inbox)
Governance dirs:    2  (_genesis, .claude — existing)
─────────────────────────
Total:              ~46 directories

vs. 6-layer alternative:  5 × 4 × 5 × 4 = 400 directories
vs. current template:     ~55 directories (category-based, no subsystems)
```

**Grounding — UBS-1 + UBS-7:** 46 directories vs 400. A junior PM cloning this repo sees 46 folders with clear names, not 400 mostly-empty folders. This directly disables UBS-1 (PM paralysis) and UBS-7 (template bloat).

---

## P7: Enforcement

This blueprint is enforced at 3 layers per the enforcement matrix:

| Layer | Mechanism | What it catches |
|-------|-----------|----------------|
| Documentation | `rules/filesystem-routing.md` (always-on) | Agent reads routing table before every file creation |
| Automated | PreToolUse hook on Write/Edit | Validates path matches routing pattern before file is created |
| Human gate | `/feedback` skill | PMs report structural blockers; team reviews quarterly |

---

## Links

- Routing rule: `rules/filesystem-routing.md`
- BLUEPRINT Principle 7: `_genesis/BLUEPRINT.md` §P7
- Naming convention: `rules/naming-rules.md`
- Evidence archive: `archive/I2/improve/filesystem-depth-test` (remote branch)
- Vinh's reference: `remotes/origin/Vinh-ALPEI-AI-Operating-System-with-Obsidian`
