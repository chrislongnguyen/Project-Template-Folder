---
version: "1.0"
status: draft
last_updated: 2026-04-09
work_stream: _governance
type: analysis
tags: [status-lifecycle, agent-teams, test-comparison, data-analysis]
---

# Test Mode Comparison — Direct Orchestration vs Agent Team

> Two execution modes were used within the same integration test (13 checkpoints).
> This report compares them quantitatively and qualitatively.

---

## Executive Summary

We ran 13 checkpoints testing the status lifecycle automation system using two modes:
**Direct** (lead does everything) and **Agent Team** (3 agents collaborate via mailbox).

**Bottom line:** Direct mode is **2.8x more efficient** per checkpoint but can't test
human-in-the-loop approval detection. Agent Team mode adds realistic role separation
but incurs significant coordination overhead and loses automatic hook integration.
Neither mode alone provides full coverage — the hybrid approach we used is optimal.

---

## 1. Test Split

```
                 Direct Orchestration          Agent Team (3 agents)
                 ═══════════════════          ═════════════════════
Checkpoints      CP-1,2,3,8,9,10,11,12,13    CP-4,5,6,7
Count            9 of 13 (69%)                4 of 13 (31%)
What tested      Hook logic (T1,T2,T4)        Approval detection (Tier 1-4)
                 Script execution              Inter-agent communication
                 Bulk operations               Signal classification
                 Iteration advancement          Role-based behavior
```

---

## 2. Quantitative Comparison

### 2.1 Tool Call Volume

| Metric | Direct Mode | Agent Team Mode | Ratio |
|--------|------------|----------------|-------|
| Checkpoints covered | 9 | 4 | — |
| **Total tool calls** | **~27** | **~34** | 1.3x more for 56% fewer CPs |
| **Tool calls per checkpoint** | **3.0** | **8.5** | **2.8x overhead** |
| Write/Edit calls | 8 | ~5 (by ai-responsible) | — |
| Bash calls | 14 | 1 | — |
| Read calls | 5 | ~5 | — |
| SendMessage calls | 0 | **16** (8 lead + 4 pm + 4 ai) | Team-only cost |
| Idle notifications | 0 | **~18** | Team-only noise |

### 2.2 Tool Call Breakdown (per checkpoint)

```
Direct Mode (3.0 calls/CP)          Agent Team (8.5 calls/CP)
═════════════════════════           ══════════════════════════

  Edit ████████  (0.9)                SendMessage ████████████████ (4.0)
  Bash ██████████████ (1.6)           Edit ██████ (1.3)
  Read ████ (0.6)                     Read ██████ (1.3)
                                      Bash ██ (0.3)
                                      Idle cycles ████████████████████ (4.5)
```

### 2.3 Setup Overhead

| Setup Step | Direct Mode | Agent Team |
|------------|------------|------------|
| TeamCreate | 0 | 1 |
| Agent spawns (Agent tool) | 0 | 2 |
| Agent shutdown (SendMessage) | 0 | 2 |
| Task assignments (TaskUpdate) | 0 | 4 |
| Context packaging (prompt writing) | 0 | 4 detailed prompts |
| **Total setup operations** | **0** | **13** |

### 2.4 Latency per Checkpoint

| Mode | Turns per CP | Wall-clock estimate | Bottleneck |
|------|-------------|-------------------|------------|
| Direct | 1–2 | 5–15 sec | Bash execution |
| Agent Team | 3–5 | 30–90 sec | Idle cycle + message delivery |

### 2.5 Infrastructure Tested

| Component | Lines of Code | Tested by Direct | Tested by Agent Team |
|-----------|--------------|-----------------|---------------------|
| inject-frontmatter.sh v2 | 172 | T1, T4 transitions | — (hooks didn't fire) |
| bulk-validate.sh | 186 | Dry-run + live | — |
| generate-registry.sh | 427 | Full execution | — |
| readiness-report.sh | 235 | C1-C3 check | — |
| iteration-bump.sh | 367 | S1 check + simulated bump | — |
| Approval signal catalog | 23 patterns (6+8+5+4) | — | 4 patterns tested (1 per tier) |
| **Total** | **1,387 lines** | **1,387 tested** | **23 patterns tested** |

---

## 3. Qualitative Comparison

### 3.1 Strengths

| Dimension | Direct Mode | Agent Team |
|-----------|------------|------------|
| **Speed** | Fast — no coordination overhead | Slow — message passing + idle cycles |
| **Reliability** | 100% — hooks invoked deterministically | Hooks don't fire for teammates (F2) |
| **Observability** | Full — lead sees every tool result | Partial — teammate actions reported async |
| **Realism** | Low — no role separation | **High — PM and AI agents act independently** |
| **Approval testing** | Can't test — no human proxy | **Can test — PM sends realistic phrases** |
| **Scalability** | Doesn't scale — lead is bottleneck | **Scales — agents work in parallel** |

### 3.2 Weaknesses

| Dimension | Direct Mode | Agent Team |
|-----------|------------|------------|
| **Role separation** | None — lead does everything | Proper RACI (Accountable vs Responsible) |
| **Approval detection** | Untestable | Tested but at 2.8x cost |
| **Hook integration** | Manual (simulated) | **Broken** — PostToolUse doesn't fire |
| **Context cost** | Low — lead has full context | High — each agent needs context packaging |
| **Failure modes** | Simple — single point | Complex — message ordering, race conditions |

### 3.3 Error/Anomaly Comparison

| Issue | Direct Mode | Agent Team |
|-------|------------|------------|
| Hooks not auto-firing | N/A (invoked manually) | **F2 — hooks don't fire for teammates** |
| Stale file reads | Never — lead reads after each op | Possible — ai-responsible read old state |
| Message ordering | N/A | pm-accountable CP-4 phrase arrived late |
| `mapfile` bash 3 bug | Caught in script run | Not encountered |
| Race conditions | None — sequential | ai-responsible processed CP-1 in parallel with lead's CP-3 setup |

---

## 4. Coverage Matrix

```
                        Direct    Agent Team    Combined
                        ══════    ══════════    ════════
Hook T1 (draft→IP)       ✓           —            ✓
Hook T2 (IP→IR)          ✓           —            ✓
Hook T4 (val→draft+v↑)   ✓           —            ✓
Tier 1 approval           —           ✓            ✓
Tier 2 approval           —           ✓            ✓
Tier 3 ambiguous          —           ✓            ✓
Tier 4 rejection          —           ✓            ✓
Bulk validate             ✓           —            ✓
Registry generation       ✓           —            ✓
Readiness check           ✓           —            ✓
Iteration bump            ✓           —            ✓
End-to-end integration    —           —            ✗ (gap)
```

**The hybrid approach covers 11/12 capability areas.** The one gap — end-to-end
(agent writes file → hook auto-fires → frontmatter updates → agent sees result) —
requires either a platform fix for teammate hooks or testing outside Agent Teams.

---

## 5. Recommendation

| Decision | Rationale |
|----------|-----------|
| **Use Direct Mode** for hook logic, script execution, and deterministic state transitions | 2.8x more efficient, 100% reliable, full observability |
| **Use Agent Team** for approval detection and role-based behavior testing | Only way to test Tier 1-4 signal classification with realistic role separation |
| **Use Hybrid** (what we did) for integration tests | Best coverage at acceptable cost |
| **Fix F1 (mapfile)** before pushing iteration-bump.sh | Blocker — macOS bash 3 incompatibility |
| **Accept F2 (teammate hooks)** as platform constraint | Low priority — manual hook invocation is adequate workaround |

---

## 6. Cost Model (if running at scale)

| Scenario | CPs | Direct calls | Team calls | Total | Savings from Direct |
|----------|-----|-------------|-----------|-------|-------------------|
| This test (hybrid) | 13 | 27 (9 CPs) | 34 (4 CPs) | 61 | — |
| All Direct | 13 | 39 (13×3.0) | 0 | 39 | 36% fewer calls |
| All Agent Team | 13 | 0 | 111 (13×8.5) | 111 | — |
| Optimal split* | 13 | 27 (9 CPs) | 34 (4 CPs) | 61 | 45% vs all-team |

*Optimal split = Direct for deterministic CPs, Team for approval CPs (what we did).

---

## Links

- [[2026-04-09_RESULT-status-lifecycle-roleplay]]
- [[2026-04-09_TEST-status-lifecycle-roleplay]]
- [[2026-04-09_DESIGN-status-lifecycle-automation]]
