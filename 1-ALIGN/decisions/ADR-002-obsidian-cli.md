---
version: "1.2"
status: validated
last_updated: 2026-04-01
owner: Long Nguyen
aliases: ["ADR-002", "ADR-002-obsidian-cli"]
---
# ADR-002: Obsidian CLI Integration Approach

**Status:** DECIDED
**Date:** 2026-03-30
**Decided:** 2026-04-01
**Decider(s):** Vinh (CIO/Director), Long Nguyen (Builder)
**MoSCoW:** Should (I1)

---

## Context

Vinh proposed using Obsidian CLI to enable information search and interconnectedness of MD files in the repo (S1, 2026-03-30). As the repo grows, every file needs to be connected to others accurately and scalably. This is an exploration assignment — Long explores first, then the team decides on integration approach.

The learning pipeline from Vinh's whiteboard: Info search → Info connection → LEARN → synthesis. Obsidian CLI solves the first two steps. The question is HOW to integrate it, not WHETHER to explore it.

**Spike completed 2026-04-01.** A/B test ran across 4 scenarios with 8 parallel agents. Decision deferred in v1.1 is now closed with empirical data.

## Options Recorded

### Option A: Native Obsidian CLI as Primary Search

- **Description:** Replace current search tooling (Grep/Glob) with Obsidian CLI as the primary MD search mechanism. Repo becomes an Obsidian vault. All agents use Obsidian CLI for file discovery and cross-referencing.
- **Sustainability:** Risk — introduces hard dependency on Obsidian. If CLI breaks or changes API, all search breaks. Team members must install Obsidian tooling. Friction for adoption if Obsidian setup is non-trivial.
- **Efficiency:** Potentially high — Obsidian's graph and backlink features provide interconnectedness "for free." But unknown performance in headless/CI environments.
- **Scalability:** Strong if Obsidian scales with repo size. Unknown behavior at 500+ MD files with agent-frequency queries.

### Option B: Obsidian as Optional Enhancement

- **Description:** Keep current search (Grep/Glob/agent-native) as baseline. Add Obsidian CLI as an optional layer for humans who want graph/backlink features. Agents do not depend on Obsidian.
- **Sustainability:** High — no new dependency for core workflow. Obsidian failure is non-critical. Lowest adoption friction (opt-in, not mandatory).
- **Efficiency:** Medium — humans get Obsidian benefits, agents don't. Two search mechanisms to maintain. No single source of interconnectedness.
- **Scalability:** Scales safely because core path has no new dependency. But misses the cross-referencing value Vinh envisions for agents.

### Option C: Custom MD Search Mimicking Obsidian Graph Features

- **Description:** Build a lightweight custom tool (Python/Shell) that indexes MD files, extracts wikilinks/frontmatter references, and provides graph-like search. No Obsidian dependency.
- **Sustainability:** Medium — no external dependency, but requires building and maintaining custom tooling. Build effort competes with I1 priorities.
- **Efficiency:** Low initially (must build from scratch). Could be high long-term if tailored to LTC's exact needs.
- **Scalability:** Full control over indexing strategy. Can optimize for agent consumption patterns. But maintenance burden grows with features.

## Decision

**Option B — Approved.** Obsidian as Optional Enhancement Layer.

Grep/Glob remain the baseline search tools for all agents. Obsidian CLI is an opt-in layer for humans and agents that choose to use it — it does not replace or gate any core workflow.

### Spike Evidence (A/B Test, 2026-04-01)

4 scenarios, 8 parallel agents. Obsidian CLI vs. native agent tools (Grep/Glob/Read).

| Metric | Result | Direction |
|--------|--------|-----------|
| Tool calls per task | 3.6× fewer with Obsidian CLI | Obsidian wins |
| Token consumption | 18% fewer tokens | Obsidian wins |
| Task completion time | 32% faster | Obsidian wins |

**Interpretation:** Obsidian CLI is a meaningful efficiency gain when available. It does not, however, eliminate the baseline — agents operating without Obsidian (CI, new team members, headless hooks) must still function correctly via Grep/Glob. This confirms Option B: opt-in enhancement, not mandatory dependency.

### RICE Feature Priority (Top Features, Spike Output)

16 features ranked by Reach × Impact × Confidence ÷ Effort. Top 5 carried forward to I1 Build:

| Rank | Feature | RICE Score | Notes |
|------|---------|------------|-------|
| 1 | Frontmatter search via vault index | Highest | Core to cross-referencing |
| 2 | Backlink traversal for dependency chains | High | Enables ALPEI chain-of-custody checks |
| 3 | Tag-based file discovery | High | Reduces Grep load for known categories |
| 4 | Graph export for training materials | Medium | Human-facing; low agent utility |
| 5 | Wikilink resolution in agent context | Medium | AP4 gating required before enabling |

Lower-ranked features (ranks 6–16) deferred to I2 or dropped.

### Spike Evidence (Pre-A/B)

| Finding | Data | Impact on Decision |
|---------|------|--------------------|
| Token savings (per-task) | 32–96× reduction via schema elimination vs. loading full vault | Confirms efficiency upside of Option B when used; does not change baseline |
| Token savings (vault-load scenario) | Up to 70,000× for large vault-load patterns | Eliminates Option A as mandatory — forcing vault load on all agents would waste tokens at scale |
| Headless constraint | Obsidian app must be running (no background daemon in v1.12) | Eliminates Option A as a hard dependency — CI/hooks cannot guarantee Obsidian is running |
| Oasis Security CVE (Feb 2026) | `eval` / `dev:console` in Obsidian REST API = full machine compromise | Requires AP1 safety guardrail (see T2 security rule) before any agent usage |
| UBS-001 adoption friction | Optional layer has lowest barrier to entry — S > E pillar | Confirms Option B. Mandatory Obsidian (Option A) would increase onboarding friction for all 8 members |

### Rationale

Option B satisfies the S > E > Sc priority ordering:
- **Sustainability first:** No new mandatory dependency. Obsidian outage or version change does not break agent workflows.
- **Efficiency second:** Teams that opt in get 32–96× token savings and graph/backlink features on demand.
- **Scalability third:** Core path scales independently. Obsidian layer can be extended (e.g., session hook, AP4 whitelisting) in I2 without rearchitecting the baseline.

Option A was eliminated by the headless constraint (Obsidian app must be running) and the CVE risk requiring guardrails before agent usage. Option C was deprioritized — build cost competes with I1 priorities and duplicates what Grep/Glob already provide.

## AP4 Opt-Out Model

AP4 governs which agents may invoke the Obsidian CLI. The implementation uses an **opt-OUT model** with `cli-blocked: true` as the default frontmatter flag.

### Why Opt-Out (not Opt-In)

| Model | Default | Agent behavior without explicit flag |
|-------|---------|--------------------------------------|
| Opt-in (`cli-allowed: true`) | Blocked | Agents silently fall back to Grep/Glob. New agents miss the efficiency gain unless explicitly configured. |
| Opt-out (`cli-blocked: true`) | Allowed | Agents use CLI by default. Explicitly block only when environment cannot support it (CI, hooks, restricted contexts). |

**Decision:** Opt-out. The A/B test confirms CLI is strictly better (3.6×/18%/32%) when available. Defaulting to blocked creates adoption friction without safety benefit — the CVE guardrail (AP1/T2) already handles the security surface. Opt-out with explicit `cli-blocked: true` for constrained environments is the correct model.

### Blocked Contexts (apply `cli-blocked: true`)

- CI/CD pipelines (Obsidian app not running)
- Pre-commit hooks (headless constraint)
- Any agent invocation where `OBSIDIAN_RUNNING` env var is not set
- New team members before Obsidian setup is confirmed

## Vinh Adoption Strategy

### Design Principle

Extend our existing 27 templates with 4 new frontmatter fields. Do NOT replicate Vinh's 43 Templater templates — that is his team's domain-specific instantiation, not the generic scaffold.

### 4 Frontmatter Fields to Add

| Field | Values | Purpose |
|-------|--------|---------|
| `type` | `charter`, `decision`, `risk`, `driver`, `research`, `spec`, `src`, `metric`, `retro` | Enables type-based vault queries without filename parsing |
| `work_stream` | `align`, `learn`, `plan`, `execute`, `improve`, `govern`, `genesis` | Maps every artifact to its ALPEI workstream — enables cross-workstream dependency tracing |
| `stage` | `draft`, `review`, `approved` | Mirrors `status` field for Obsidian filter compatibility (Obsidian reads `stage`, not `status`) |
| `sub_system` | free text or `null` | Optional subsystem label for teams using the horizontal layer. Blank for single-subsystem repos. |

### Rollout Plan

1. **I1:** Add 4 fields to all 27 templates (update `_genesis/templates/`). Existing artifacts update on next edit (version bump triggers field addition).
2. **I1:** Document in `_genesis/reference/obsidian-adoption.md` — field definitions, query examples, Vinh alignment notes.
3. **I2:** Evaluate Templater template extraction from Vinh's 43 — pull only templates that map directly to our 27 (no domain-specific ones).

### What We Do NOT Copy from Vinh

- His 43 Templater templates (domain-specific to his team's workflow)
- His tag taxonomy (his tags reflect his subsystem structure, not ours)
- His vault structure (he uses a different folder hierarchy than ALPEI)

The 4 frontmatter fields are the bridge — they make our files readable by Obsidian queries that Vinh's team uses, without importing his entire system.

## Consequences

### Positive
- No new mandatory dependency — all existing CI/hooks continue to work unchanged
- Agents that opt in gain 3.6× fewer tool calls, 18% fewer tokens, 32% faster execution
- 4 frontmatter fields align our vault with Vinh's query patterns without structural coupling
- AP4 opt-out model maximizes CLI adoption while protecting constrained environments

### Negative
- Two search paths to maintain (Grep/Glob baseline + Obsidian layer)
- `.claude/` directory has a known blind spot: ~30% of agent config references are invisible to Obsidian graph traversal (wikilinks in `.md` files do not resolve into `.claude/` sub-paths by default). Tracked as P3 fix item.
- Team members must install Obsidian locally to access graph features — setup friction for new members

### Open Items (tracked separately)
- P3 fix: `.claude/` symlink vs. grep workaround for blind spot (ADR pending)
- Obsidian adoption rate survey needed before I2 scope decision
- AP1/T2 security rule must be in place before any agent uses the REST API endpoint

---

**Derived From:** S1 (Vinh whiteboard 2026-03-30), R02 in stakeholder input synthesis, A/B test results (2026-04-01)

## Links

- [[ADR-002]]
- [[AP1]]
- [[AP4]]
- [[CLAUDE]]
- [[DESIGN]]
- [[UBS-001]]
- [[friction]]
- [[security]]
- [[task]]
- [[workstream]]