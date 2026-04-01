---
version: "1.2"
status: Decided
last_updated: 2026-03-30
owner: Long Nguyen
iteration: "I1: Concept"
source: "S2-Đạt, R06"
---

# ADR-004: Subfolder Description Mechanism

## Context

Đạt reported [S2] that zone subfolders have no descriptions. Consequence: agents guess which subfolder to use (or skip entirely), and human users skip subfolders they don't understand. This is a sustainability blocker — basic usability preventing adoption.

Requirement R06: "Subfolders must have descriptions so agents don't guess and users don't skip."

The mechanism must serve two audiences simultaneously:
- **Humans** — need scannable, discoverable descriptions when browsing the repo
- **Agents** — need machine-readable context when deciding where to place artifacts

## Options

### Option A: README.md in Every Subfolder

Each subfolder gets a `README.md` with a 3-5 line description: purpose, what goes here, what does NOT go here.

### Option B: YAML Frontmatter Index Per Zone

Each zone gets a single `_index.yml` file listing all subfolders with description, purpose, and artifact types.

### Option C: Centralized Manifest File

A single `MANIFEST.md` or `MANIFEST.yml` at root describing every subfolder in the entire repo.

### Option D: Directory-Level CLAUDE.md Files

Each subfolder gets a `.claude.md` or similar agent-readable file with structured metadata (purpose, allowed artifacts, scope boundary).

## 3-Pillar Evaluation

| Option | Sustainability | Efficiency | Scalability | Total |
|--------|---------------|------------|-------------|-------|
| **A: README.md per subfolder** | **Strong.** GitHub renders README.md automatically — humans see descriptions by default when browsing. Agents can read README.md with standard tools. No new convention to learn. Failure mode is obvious (missing README = missing description). | **Moderate.** One file per subfolder adds file count (~20-30 READMEs). But each is small (3-5 lines). Maintenance cost is low — descriptions rarely change. | **Strong.** Pattern scales to any number of subfolders. Consumer repos inherit READMEs on clone. No tooling dependency. | **Best overall** |
| **B: YAML index per zone** | **Moderate.** Agents can parse YAML easily. But humans must know to look for `_index.yml` — not discoverable by browsing. GitHub does not render YAML inline. | **Strong.** One file per zone (5-6 files total). Compact. Easy to maintain. | **Moderate.** YAML parsing requires convention knowledge. Consumer repos must understand the index pattern. | Good for agents, weak for humans |
| **C: Centralized manifest** | **Weak.** Single point of failure. If manifest drifts from actual folder structure, descriptions are wrong. Humans must navigate away from the subfolder to find the description. Not discoverable. | **Strong.** One file total. Minimal file count. | **Weak.** Manifest becomes a bottleneck. Every subfolder change requires manifest update. Merge conflicts on team repos. | Fragile at scale |
| **D: Directory-level CLAUDE.md** | **Moderate.** Good for agents (Claude Code reads `.claude/` files natively). But humans don't naturally look for `.claude.md` files. Creates a parallel description system invisible to non-agent users. | **Weak.** Adds agent-specific files that humans ignore. Dual maintenance if humans also need descriptions. | **Moderate.** Works for Claude Code but not for other agents (Gemini, GPT) without convention agreement. | Agent-only solution |

## Decision

**Option A: README.md in every subfolder.**

### Rationale

1. **Sustainability wins:** GitHub auto-renders README.md when browsing a folder. This is the ONLY option where descriptions are discoverable by default — no convention knowledge required. Khang browses a subfolder, sees the description. Đạt's agent reads the README, gets context. Zero new conventions.

2. **Serves both audiences simultaneously:** Humans see it in the browser. Agents read it as a standard markdown file. No dual-maintenance path.

3. **Failure mode is obvious:** A subfolder without a README.md is visibly missing a description. This can be enforced by template-check.sh (lint for missing READMEs).

4. **File count concern is acceptable:** ~20-30 small READMEs (3-5 lines each) is a manageable addition. The files rarely change after initial creation. The cognitive load of extra files is offset by the cognitive load REDUCTION of having descriptions visible.

### What each README.md contains

```
# {Subfolder Name}

**Purpose:** One sentence describing what this subfolder is for.
**What goes here:** Artifact types that belong in this subfolder.
**What does NOT go here:** Common misplacements to prevent.
```

### Enforcement

- `template-check.sh` validates every non-exempt subfolder has a README.md
- Consumer repos inherit READMEs on clone — descriptions travel with the template

## Consequences

- **Positive:** Đạt's agent guessing problem is resolved. Khang can browse and understand structure. Template-check.sh can enforce completeness.
- **Negative:** File count increases by ~20-30 files. Each must be maintained if subfolder purpose changes.
- **Neutral:** Does not replace zone-level READMEs (which cover the zone as a whole). Subfolder READMEs are strictly scoped to subfolder purpose.

## References

- S2-Đạt feedback: `2-LEARN/input/2026-03-30-user-issues.md`
- R06: `2-LEARN/research/2026-03-30-stakeholder-input-synthesis.md`
- DESIGN.md A2 row: subfolder descriptions required for C3

---

**Classification:** INTERNAL
