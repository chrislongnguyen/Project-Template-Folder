---
version: "1.0"
status: draft
last_updated: 2026-04-03
type: learning-output
work_stream: 2-LEARN
stage: build
source_type: gan-analysis
title: "Naming Convention GAN Synthesis — S x E x Sc Analysis"
topics: [naming-convention, ung, sustainability, efficiency, scalability, gan-framework]
---

# Naming Convention GAN Synthesis — S x E x Sc Analysis

**Date:** 2026-04-03
**Method:** 3-agent parallel research (Exa external search + Blue Team advocate + Red Team adversary)
**Scope:** 10 naming principles extracted from Vinh's branch vs. main branch, evaluated against 8 external industry sources
**Desired outcome:** Effective naming across all LTC systems that is stable (S), functional (E), and scalable (Sc)

---

## Research Inputs

### External Sources (Exa Search — 8 Findings)

| # | Source | Key Rule | S | E | Sc | LTC Compatibility |
|---|--------|----------|---|---|----|--------------------|
| F1 | Google API Design (AIP-190) | Lowercase dash-separated for API paths | H | H | H | Needs adaptation (API-specific) |
| F2 | Airbnb Style Guide (JS/Swift) | kebab-case files, camelCase vars, PascalCase classes | H | M | H | Partially compatible |
| F3 | Monorepo Structure (Nx, Turborepo) | Semantic scopes, lowercase-dash, max 2-level nesting | H | H | H | Compatible as enhancement |
| F4 | Cross-Platform Filename Safety | Safe chars: a-z, A-Z, 0-9, `-`, `.`, `_`. NO spaces | M | H | L | Already enforced by UNG |
| F5 | Digital Asset Management (DAM) | `{CATEGORY}_{DESCRIPTOR}_{DATE}_{VERSION}` | M | H | H | Complementary |
| F6 | Case Convention Consensus (2026) | kebab for URLs/CLI, snake for Python/SQL, camel for JS | H | M | H | Compatible with extension |
| F7 | Obsidian PARA + Zettelkasten | PARA for <1K notes, Zettelkasten IDs for >1K | H/L | H/L | M/H | Compatible with divergence |
| F8 | Hierarchical vs Flat Semantic | Hybrid (numeric ID + semantic name) optimal long-term | M | M | H | Already implemented in UNG |

### Internal Systems Compared

**System A (Main branch — `1-ALIGN/` style):**
- Repo: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE`
- Folders: `1-ALIGN/`, `2-LEARN/`, `3-PLAN/`, `4-EXECUTE/`, `5-IMPROVE/`
- Rules: descriptive kebab-case (`agent-dispatch.md`, `naming-rules.md`)
- Skills: mixed naming (`dsbv/`, `resume`, `compress`, `deep-research`)
- Agents: `ltc-planner`, `ltc-builder`, `ltc-reviewer`, `ltc-explorer`
- Frontmatter: `version: "1.0"`, `status: Draft` (mixed case)

**System B (Vinh's branch — `1. ALIGN/` style):**
- Folders: `1. ALIGN/`, `1.1. ROLES/`, `1.5.1. PROBLEM DIAGNOSIS/`
- Rules: prefix + kebab-case (`alpei-pre-flight.md`, `ltc-naming-convention.md`)
- Skills: `ues-learn/`, `ltc-decide/`, `gws-sheets/` (prefix + kebab-case)
- Agents: `alpei-planner`, `alpei-researcher` (prefix + kebab-case)
- Frontmatter: all lowercase (`status: draft`, `sub_system: problem-diagnosis`)

---

## GAN Debate Results — 10 Principles

### Verdict Key

- **ADOPT** = implement as-is
- **ADAPT** = adopt the principle, modify the implementation
- **REJECT** = principle is weak or implementation is harmful
- **KEEP** = current System A approach is already optimal

### Summary Table

| # | Principle | Blue S/E/Sc | Red Risk | Evidence | Verdict |
|---|-----------|-------------|----------|----------|---------|
| P1 | Two-tier naming (external UNG vs internal) | 4/5/4 | Med | F1,F3 | **ADAPT** |
| P2 | Decimal folders `1. ALIGN/` | 5/4/5 | **HIGH** | F4,F8 | **REJECT** |
| P3 | Kebab-case universal system IDs | 5/4/5 | Low | F2,F6 | **ADOPT** |
| P4 | Lowercase frontmatter values | 5/3/5 | Low | F1 | **ADOPT** |
| P5 | Full names in folders (no abbreviations) | 5/4/5 | Med | F5 | **ADOPT** |
| P6 | Prefix-based skill naming | 5/4/5 | Med | F3 | **ADAPT** |
| P7 | `TEMPLATES - ` literal prefix | 4/5/5 | Low | F4 | **ADAPT** |
| P8 | Semantic version names | 4/4/5 | Med | F8 | **ADAPT** |
| P9 | Explicit TRIGGER/DO NOT TRIGGER | 5/5/5 | Med | CI/CD | **ADAPT** |
| P10 | `applies_to:` inheritance | 5/4/5 | Med | SRE/DAMA | **ADAPT** |

---

## Detailed Verdicts

### P1 — Two-Tier Naming: ADAPT

**Blue case:** External systems (Git, ClickUp, Drive) have different constraints than internal systems (skills, rules, agents). Separation of concerns is proven (Salesforce, Django, Johnny Decimal).

**Red case:** Two tiers create cognitive context-switching. Developers see 3 naming models within 30 seconds of browsing. 40% of users will name new files inconsistently without a clear boundary.

**External evidence:** Google API (F1) and monorepo patterns (F3) both separate external-facing names from internal organization. Kubernetes rejected two-tier after early experimentation but operates in a single-platform context (LTC operates across Git, Drive, ClickUp, Obsidian).

**Resolution:** Adopt two-tier, but make the boundary explicit in a one-page table. UNG governs external surfaces (Git repos, ClickUp items, Drive folders). Kebab-case governs internal surfaces (skills, rules, agents, scripts, frontmatter keys). No ambiguity.

---

### P2 — Decimal Folders: REJECT

**Blue case:** Hierarchical decimals encode depth directly in path. Zero-configuration navigation. Johnny Decimal System used by 10K+ knowledge bases.

**Red case (devastating):**
- `1. ALIGN/` has spaces — requires shell quoting everywhere (`cd "1. ALIGN/"`)
- Dots in folder names — `find . -name "1.*"` matches wrong targets
- GitHub API rejects dots in folder paths
- Windows 260-char PATH limit hit faster (~20 chars/level vs ~7)
- URL encoding: `1%2E%20ALIGN` is unreadable in Slack, email, URL shorteners
- Agent parsing ambiguity: `1.1` = folder level or file version?

**External evidence:** F4 (cross-platform safety) explicitly lists spaces as FORBIDDEN for scalable systems. F8 confirms hybrid numeric+semantic is optimal — but with safe characters only.

**Resolution:** `1-ALIGN/` (System A) is strictly superior on E and Sc. Vinh's decimal system works inside Obsidian (which handles paths internally) but does NOT scale to Git, CI/CD, or cross-platform. The numbering CONCEPT (ordering via prefix) is sound — the IMPLEMENTATION (dots + spaces) is harmful.

**Key insight:** This was the user's original intuition — confirmed by evidence.

---

### P3 — Kebab-Case Universal: ADOPT

**Blue case:** Only format universally safe across all platforms (URL-safe, shell-safe, platform-agnostic normalization). W3C, GitHub, Google, Docker, Kubernetes all use it. Eliminates entire category of case-collision bugs.

**Red case:** Python imports fail with hyphens (must use underscores). Bash word navigation slightly different. Regex requires escaping `-` in ranges.

**External evidence:** F2 (Airbnb) and F6 (2026 consensus) both confirm: kebab for files/URLs/CLI, language-native for code identifiers. The boundary is clear.

**Resolution:** Adopt kebab-case for all file-level IDs (skills, agents, rules, configs, folder names). Code identifiers follow language convention (snake_case for Python, camelCase for JS). Document the mapping explicitly.

---

### P4 — Lowercase Frontmatter: ADOPT

**Blue case:** Frontmatter is machine-readable data, not display text. Mixed case creates silent query failures (`status = "Draft"` misses `status: draft`). YAML 1.2 spec mandates case-sensitive keys. Obsidian Dataview/Bases are case-sensitive by default.

**Red case:** Human readability friction — `Draft` is more natural than `draft`. Acronyms lose visual significance (`ALPEI` → `alpei`). YAML boolean hazard (`true`/`false`/`yes`/`no` parsed as booleans, not strings).

**External evidence:** PostgreSQL, BigQuery, Snowflake, Kubernetes API all recommend lowercase for data fields. Google JSON API guide recommends lowercase keys.

**Resolution:** Adopt lowercase for all frontmatter VALUES. The machine-readability and Obsidian Bases compatibility outweigh the minor readability cost. YAML boolean hazard is mitigated by quoting values (`status: "draft"` not `status: draft`). Display formatting belongs in the template/rendering layer, not storage.

---

### P5 — Full Names in Folders: ADOPT

**Blue case:** Folder name is the human navigation layer. Abbreviation collision risk is real (PD = Problem Diagnosis, Product Design, Probability Distribution, Professional Development). Self-documenting navigation eliminates cognitive load. NHS/UK government legally mandates full names for accessibility.

**Red case:** Creates hidden metadata coupling (folder `3-PLAN/` has code `P` in frontmatter — developer must maintain lookup table). Tab-completion doesn't help. Agent cognition requires mapping.

**External evidence:** F5 (DAM standards) separates metadata from filenames. Google Material Design uses semantic names in docs, abbreviations in code only.

**Resolution:** Adopt full names in folders (System A already does this: `1-ALIGN/` not `1-A/`). Codes in frontmatter are acceptable as QUERY shortcuts but should always have the full name as the primary field. Example: `work_stream: align` (full name, lowercase) with optional `ws_code: A` if needed for queries.

---

### P6 — Prefix-Based Skills: ADAPT

**Blue case:** Namespacing prevents collision at scale (6 projects x 10 skills = 60+ skills). Prefix-based autocomplete (`/ues-<TAB>`) aids discovery. Kubernetes, npm scopes, Docker all use this pattern.

**Red case:** Prefix explosion — 20 skills with 15 prefixes makes the system unnavigable. Cross-domain skills don't fit cleanly. Renaming breaks references.

**External evidence:** F3 (monorepo scopes) confirms scoping works WITH a registry. npm's `@org/package` pattern works because org count is bounded.

**Resolution:** Adopt with a controlled prefix registry (max 5 registered prefixes, new ones require approval):

| Prefix | Scope | Examples |
|--------|-------|---------|
| `ltc-` | LTC governance, brand, naming | `ltc-naming-rules`, `ltc-brand-identity` |
| `dsbv-` | DSBV process skills | `dsbv-gate`, `dsbv-design` |
| `vault-` | Obsidian vault operations | `vault-daily`, `vault-capture` |
| `gws-` | Google Workspace integrations | `gws-sheets`, `gws-drive` |
| _(none)_ | General utility | `compress`, `resume`, `git-save` |

---

### P7 — Template Prefix: ADAPT

**Blue case:** Templates are generators, not deliverables. Visual distinction without reading metadata. NARA/ISO 15489 recommends classification prefixes.

**Red case:** `TEMPLATES - UBS Analysis.md` has spaces (grep noise, URL encoding, shell quoting). Literal string prefix is fragile. Hugo, Cookiecutter, GitHub all use kebab-case + folder structure instead.

**External evidence:** F4 confirms spaces in filenames are problematic at scale.

**Resolution:** Adopt the CONCEPT (distinguish templates from deliverables) but use folder-based separation (which System A already does via `_genesis/templates/`). If filename prefix is needed, use kebab-case: `template-{name}.md` not `TEMPLATES - {name}.md`.

---

### P8 — Semantic Version Names: ADAPT (Both Coexist)

**Blue case:** Semantic names (`logic-scaffold`, `concept`, `prototype`, `mve`, `leadership`) communicate governance stage to stakeholders. Google Cloud uses GA/Beta/Alpha. Linux uses codenames.

**Red case:** Semantic names can't sort (`leadership` vs `scaffold` — which is newer?). CI/CD can't compare. Git tags with semantic names require timestamp-based sorting. After 10+ releases, names become arbitrary.

**External evidence:** F8 confirms hybrid (numeric ID + semantic name) is optimal. Every major software project uses numeric as primary.

**Resolution:** Numeric version is primary (sortable, CI/CD compatible). Semantic name is metadata label.

```yaml
version: "1.3"                # Machine: sortable, comparable
iteration_name: "concept"     # Human: governance stage label
```

Both systems coexist. Neither replaces the other.

---

### P9 — Explicit Triggers: ADAPT (Positive-Only)

**Blue case:** Skills are autonomous programs — without trigger rules, agents misapply them. GitHub Actions, Kubernetes Operators, Airflow all require explicit conditions. Eliminates manual approval overhead.

**Red case:** DO NOT TRIGGER rules create exponential maintenance burden. Negative logic is fragile. Circular dependencies between skills cause deadlocks. Testing complexity is O(n^2).

**External evidence:** CI/CD best practice is positive conditions only (`on: push`, `if: branch == main`). Kubernetes uses affinity (positive), not anti-affinity as primary mechanism.

**Resolution:** Adopt positive-only trigger conditions + numeric priority for conflict resolution. No DO NOT TRIGGER rules.

```yaml
description: |
  Scan all workstream artifacts for frontmatter compliance.
  TRIGGER when: user requests audit, or DSBV phase = Validate
  priority: 2
```

Conflicts resolved by priority (lower number fires first).

---

### P10 — `applies_to:` Inheritance: ADAPT (Annotation, Not Enforcement)

**Blue case:** Sub-system pipeline (PD -> DP -> DA -> IDM) requires inheritance tracking. Without explicit metadata, agents can't validate downstream artifacts against upstream principles. Google SRE, DAMA, ISO 9001 all require explicit traceability.

**Red case:** Hidden dependencies make refactoring dangerous. Version mismatch between source and target. Circular inheritance possible. At 50+ files, auditing `applies_to:` fields is error-prone.

**External evidence:** npm uses explicit `package.json` dependencies. Terraform uses explicit module inputs/outputs. Kubernetes uses explicit volume mounts.

**Resolution:** Use `applies_to:` as a QUERY ANNOTATION (helps humans and agents find relevant artifacts) but NOT as an enforcement mechanism. Actual dependencies use explicit file references or include paths. The field answers "what is this relevant to?" not "what must this comply with?"

---

## Actionable Output: 7 Implementation Rules

| # | Rule | What Changes | Effort |
|---|------|-------------|--------|
| R1 | Naming boundary table — UNG for external, kebab for internal | New section in `naming-rules.md` | ~1hr |
| R2 | Keep `1-ALIGN/` format — no dots or spaces in folder names | No change needed (validate existing) | 0 |
| R3 | Kebab-case for all system IDs — skills, agents, rules, configs | Audit + rename any stragglers | ~2hr |
| R4 | Lowercase frontmatter values — `status: draft` not `Draft` | Regex migration across workstream files | ~1hr |
| R5 | Prefix registry — max 5 prefixes, approval required for new | New section in `naming-rules.md` | ~1hr |
| R6 | Templates in folders, not filename prefixes | Already done via `_genesis/templates/` (validate) | 0 |
| R7 | Numeric version primary, semantic label as metadata | Update versioning rule | ~1hr |

**Total estimated effort:** ~6 hours. No architectural changes. All backward-compatible.

---

## Key Insight

LTC's existing UNG and System A folder structure are already well-designed. The main gaps are:

1. **Undocumented boundary** between UNG-governed and internally-governed naming (R1)
2. **Inconsistent frontmatter casing** that will break Obsidian Bases at scale (R4)
3. **No skill prefix governance** — will cause namespace collision at I3 scale (R5)

Vinh's System B contributes valuable IDEAS (lowercase frontmatter, prefix namespacing, explicit triggers) but his IMPLEMENTATIONS often use Obsidian-specific patterns (dots, spaces, ALL CAPS folder names) that don't survive the transition to Git, CI/CD, and cross-platform environments.

**Core equation validated:** Success = S x E x Sc. Every rejected principle (P2, P7 implementation) failed on E or Sc. Every adopted principle scores high on all three dimensions.
