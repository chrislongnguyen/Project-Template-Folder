# Report Format — Claude Audit Output

The final report is written to `inbox/YYYY-MM-DD_claude-audit.md`.
The synthesizer agent (P3-e) produces this using all prior phase outputs.

## YAML Frontmatter

```yaml
---
version: "2.0"
status: draft
last_updated: YYYY-MM-DD
auditor: claude-multi-agent-v1.0
agents: 32
models:
  area_agents: haiku
  crosscut_agents: haiku
  reconciliation: opus
  synthesis: opus
work_stream: 5-IMPROVE
tags: [audit, claude, comprehensive, release-readiness]
---
```

## Report Structure — 10 Sections

### § 1. Executive Summary
- **Verdict:** SHIP / NO-SHIP / CONDITIONAL (from Judge)
- **S × E × Sc Scores:** 0-100 each, justified with evidence
  - S (Sustainability): can this repo be maintained long-term? (rules, conventions, documentation)
  - E (Efficiency): can a PM work productively? (tooling, automation, onboarding)
  - Sc (Scalability): does this scale to 8+ repos? (templates, consistency, multi-IDE)
- **Composite Score:** weighted average (S×0.5 + E×0.3 + Sc×0.2)
- **1-sentence summary** of the repo's current state
- **Trend vs prior audit:** improving / declining / stable (if prior exists)

### § 2. Machine Verification (Phase 0)
Present Phase 0 ground-truth data as evidence. This section is 100% deterministic.
- File counts by area
- Pre-flight results per workstream
- validate-blueprint.py output
- pkb-lint output
- Frontmatter health: N issues across M files
- Wikilink orphans: N broken links
- Hook chain status: N broken / N total
- Git state: N commits ahead, N uncommitted

### § 3. Content Audit by Area (Phase 1)
One subsection per area (21 total). Each subsection:
- **Area Score: X/100**
- **PM-Ready: YES/NO**
- Key findings only (do NOT re-list all PASS verdicts — only WARN and FAIL)
- Link to the area definition for context

### § 4. Cross-Cutting Integrity (Phase 2)
One subsection per cross-cut check (5 total):
1. Wikilink Integrity: score, top orphans
2. Process Map Alignment: score, misaligned paths
3. Hook Chain: score, broken chains
4. Version Consistency: score, mismatches
5. Naming Compliance: score, violations

### § 5. PM Day-1 Experience (Phase 3a)
From the PM Walkthrough agent:
- What works well on Day 1
- Every CONFUSION, MISSING, BLOCKER point
- **Day-1 Readiness Score: X/100**
- **Time to First Productive Action:** estimate

### § 6. GAN Debate Verdict (Phase 3b-d)
- Advocate's top 3 arguments FOR shipping
- Opponent's top 3 arguments AGAINST shipping
- **Judge's Verdict:** SHIP / NO-SHIP / CONDITIONAL
- Conditions (if CONDITIONAL)

### § 7. Gap Analysis
**This is the most actionable section.** Every finding in a single table.
Sorted by: CRITICAL first, then WARN, then INFO.

| # | What (descriptive) | Why (root cause) | Risk (if unfixed) | Fix (prescriptive) | Files | Effort | Confidence |
|---|-------------------|-----------------|-------------------|-------------------|-------|--------|------------|

Confidence levels:
- **[MACHINE]** — from Phase 0 deterministic data
- **[VERIFIED]** — agent confirmed by reading the file
- **[VERIFIED-BY-TEAM]** — disputed claim resolved by verification team with file evidence
- **[INFERRED]** — synthesis-level finding (pattern across areas)

Effort levels:
- **S** — small (<30 min, 1 file)
- **M** — medium (30-120 min, 2-5 files)
- **L** — large (2+ hours, 5+ files or architectural change)

### § 8. Ship Readiness Checklist
Binary pass/fail for each criterion:

```markdown
- [x/  ] Security: no hardcoded secrets, .env gitignored, security rules enforced
- [x/  ] Documentation: README accurate, SOP current, CLAUDE.md under 120 lines
- [x/  ] Structure: all workstream dirs exist, subsystem dirs present, _cross dirs
- [x/  ] Framework: 9 canonical frameworks present, process map accurate
- [x/  ] Versioning: frontmatter consistent, version-registry in sync
- [x/  ] Hooks: all 29 entries resolve to existing scripts
- [x/  ] Multi-IDE: .cursor/ mirrors .claude/rules/, .agents/ present
- [x/  ] Onboarding: PM can reach first productive action in <2 hours
- [x/  ] Templates: /dsbv generates correct artifacts from templates
- [x/  ] Learning: 2-LEARN/ pipeline clean, no DSBV contamination
```

### § 9. Unknown Unknowns
5-10 questions the PM director should investigate that this audit can't answer:
- Risks no automated check catches
- Architectural assumptions that might be wrong
- Things that "work by convention" but have no enforcement
- Edge cases in multi-repo scenarios
- Gaps between what's documented and what's practiced

### § 10. Composite Scores
Final scoring dashboard:

| Dimension | Score | Evidence |
|-----------|-------|----------|
| ALPEI Completeness | X/100 | WS coverage across 5 workstreams |
| DSBV Enforcement | X/100 | Gates, hooks, agent restrictions |
| Agent System | X/100 | 4 agents + hooks + dispatch rules |
| Obsidian Integration | X/100 | Wikilinks, Bases, templates |
| Learning Pipeline | X/100 | 6-state pipeline, skill chain |
| Multi-IDE Support | X/100 | .claude/, .cursor/, .agents/ parity |
| Security | X/100 | No secrets, proper gitignore, hook blocks |
| Clone Readiness | X/100 | Fresh clone → productive PM |

## Execution Metadata Footer

Appended after the report body:

```markdown
---

## Audit Execution Metadata

| Field | Value |
|-------|-------|
| Date | YYYY-MM-DD |
| Duration | Xs |
| Agents | 32 (21 area + 5 cross-cut + 3 verification team + 5 debate team) |
| Models | Pipeline: haiku, Verify team: opus+haiku, Debate team: opus |
| Phases | LOCAL → CONTENT → CROSS-CUT → VERIFY-TEAM → DEBATE-TEAM |
| Teams | audit-verify (3 agents), audit-debate (5 agents) |
| Files audited | N tracked |
| Areas | 21 |
| Repo | OPS_OE.6.4.LTC-PROJECT-TEMPLATE |
| Branch | main |
| Commits ahead | N |

## Links

- [[alpei-blueprint]]
- [[CLAUDE]]
- [[AGENTS]]
- [[alpei-dsbv-process-map]]
- [[enforcement-layers]]
```

## Prior Audit Comparison Format

If a prior audit exists, add a section between §6 and §7:

### § 6.5. Regression Analysis
```markdown
**Prior audit:** YYYY-MM-DD | Verdict: X | Issues: N
**Current audit:** Verdict: X | Issues: N
**Trend:** improving / declining / stable

### Recurring Issues (highest priority — unfixed from prior)
- Issue 1...
- Issue 2...

### New Issues (not in prior audit)
- Issue 1...

### Resolved Issues (fixed since prior audit)
- Issue 1...
```
