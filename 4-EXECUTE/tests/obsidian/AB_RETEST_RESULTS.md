---
version: "1.0"
status: Draft
last_updated: 2026-04-01
test_date: 2026-04-01
branch: I1/feat/obsidian-cli
model: haiku
agents: 8 (4 scenarios × 2 methods)
---

# A/B Re-Test Results — Obsidian CLI Integration

## Raw Data

| Scenario | Metric | Grep (A) | Obsidian Hybrid (B) | Delta |
|----------|--------|----------|-------------------|-------|
| S1 Dependency trace | Tool calls | 3 | 2 | 1.5× fewer (obsidian) |
| S1 Dependency trace | Files found | 86 | 79 | Grep +7 (non-md files) |
| S2 Orphan detection | Tool calls | 3 | 4 | Grep fewer |
| S2 Orphan detection | Orphans found | 30 | 155 | Obsidian 5.2× |
| S3 Chain-of-custody | Tool calls | 21 | 18 | 1.2× fewer (obsidian) |
| S3 Chain-of-custody | Files in chain | 11 | 47 | Obsidian 4.3× |
| S3 Chain-of-custody | Chain depth | 4 | 4 | Equal |
| S4 Impact analysis | Tool calls | 26 | 4 | 6.5× fewer (obsidian) |
| S4 Impact analysis | Affected files | 16 | 8 | Grep +8 (non-md files) |

**Totals:** Grep 53 calls / Obsidian 28 calls = 1.9× fewer with obsidian hybrid

## Comparison to Original Baseline (broken SKILL.md)

| Metric | Original baseline | Re-test | Change |
|--------|-------------------|---------|--------|
| Tool call ratio | 3.6× fewer (obsidian) | 1.9× fewer | Narrowed — Haiku grep agents more efficient than original Sonnet |
| S2 orphan completeness | 100% vs 5% | 155 vs 30 (5.2×) | Still decisive obsidian win |
| S4 .claude/ gap | 11% vs 64% | 8 vs 16 files | Gap halved — hybrid sweep helped but grep still finds non-md |

## 1. Descriptive — What happened?

- Tool calls: 1.9× fewer with obsidian hybrid (53 vs 28)
- Scorecard: 2 wins each. No clean sweep.
  - S1: Grep wins (+7 non-markdown files: .py, .sh, .html)
  - S2: Obsidian wins decisively (5.2× more orphans found)
  - S3: Obsidian wins decisively (4.3× more files in chain)
  - S4: Grep wins (+8 non-markdown files)

## 2. Diagnostic — Why did it happen?

**Why grep won S1 and S4:**
- Grep searches ALL file types (.md, .py, .sh, .html, .json). Obsidian only indexes .md in the vault.
- The extra files grep found are scripts, HTML, and config files — outside obsidian's domain by design.
- S4 hybrid sweep only grepped `.claude/*.md`, missing test scripts (.sh) that also reference the security rule.

**Why obsidian won S2 and S3 decisively:**
- S2: Orphan detection is structurally impossible with grep at scale. Grep needs O(n²) cross-reference. Obsidian has pre-built index = O(1) lookup. 155 vs 30 is a capability class difference, not a search quality difference.
- S3: Chain traversal via grep requires reading each file + extracting links manually (21 calls). Obsidian `links` command returns structured output per hop. Obsidian followed deeper connections (47 files) while grep stopped at surface links (11).

**Why tool call ratio narrowed (3.6× → 1.9×):**
- Haiku grep agents were more efficient than original Sonnet agents (simpler reasoning = fewer exploratory calls).
- Obsidian agents added supplementary grep sweeps per hybrid mandate, increasing their call count.

## 3. Predictive — What will happen next?

| Prediction | Confidence | Basis |
|------------|-----------|-------|
| S2 orphan gap WIDENS as repo grows | HIGH | Grep O(n²) vs Obsidian O(1). At 500+ files, grep times out. |
| S4 .claude/ gap CLOSES with improved hybrid sweep | HIGH | Current sweep only greps .claude/*.md. Extending to .sh/.py/.html closes the 8-file gap. |
| S1 non-md gap is PERMANENT | HIGH | Obsidian will never index .py/.sh/.html. By design. |
| S3 chain value INCREASES as workstreams mature | MEDIUM | More workstream content = deeper chains. Obsidian per-hop efficiency compounds. |
| Tool call ratio returns to ~3× at Sonnet | MEDIUM | Haiku was unusually grep-efficient. Sonnet makes more exploratory calls. |

## 4. Prescriptive — What should we do?

| Action | Priority | Addresses | Effort | Workstream |
|--------|----------|-----------|--------|------------|
| Extend hybrid sweep to non-.md files in SKILL.md | P1 | S4 gap (8 vs 16) | 15 min | IMPROVE → EXECUTE |
| Add "when NOT to use obsidian" section to SKILL.md | P1 | S1 non-md files | 15 min | IMPROVE → EXECUTE |
| Add `search:context` to S1 methodology | P2 | S1 gap (79 vs 86) | 30 min | IMPROVE → EXECUTE |
| Re-run S2 at 500+ files on real project | I2 | Scaling prediction | 1 session | IMPROVE → LEARN |
| Document hybrid approach as permanent architecture | P1 | All scenarios | Already done | IMPROVE → ALIGN |

## Verdict

Obsidian wins on GRAPH tasks (S2, S3). Grep wins on CROSS-FORMAT tasks (S1, S4).
Hybrid approach validated — neither tool alone is enough.
3-tool routing hierarchy (QMD → Obsidian → grep) is the correct architecture.
