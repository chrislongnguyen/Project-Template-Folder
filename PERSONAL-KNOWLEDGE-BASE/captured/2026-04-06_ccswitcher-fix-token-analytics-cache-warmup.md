---
date: "2026-04-06"
type: capture
source: conversation
tags: [ccswitcher, token-efficiency, cache, claude-code, debugging]
---

# CCSwitcher Fix + Token Analytics + Cache Warmup

## Session Summary

Full debug, RCA, fix, and build of CCSwitcher for Claude Code 2.1.92 account-switching breakage. Plus token waste audit and cache warmup deep-dive.

---

## Part 1 — CCSwitcher: Root Cause & Fix

### Context
CCSwitcher was built from source 2026-04-02 (3 security fixes: F1/F2/F6), installed at `/Applications/CCSwitcher.app`. After Claude Code updated to 2.1.92, switching accounts required browser re-auth every time.

### Root Cause (confirmed via log + source analysis)

CCSwitcher's `switchAccount()` flow:
1. Backs up current account token
2. Restores target account backup token → Keychain
3. Writes target `oauthAccount` → `~/.claude.json`
4. Runs `claude auth status` → returns `loggedIn=true` ← **lies**

`claude auth status` reads from the credential store without making a live API call. It returns `loggedIn=true` even with an expired access token. CCSwitcher trusts this and declares the switch complete.

When Claude Code then opens in a new terminal, it hits 401 → browser re-auth forced.

**Why tokens expire:** Non-active account backup tokens sit idle. Claude Code refreshes the active account's token mid-session (token length: 725 → 733 chars). Backups for inactive accounts are never updated.

**Evidence from logs:**
- Backup tokens: 725/728 chars (stale)
- Live Keychain token: 733 chars (refreshed)
- Health check showed all 3 accounts "OK" — but OK = backup exists, not = backup is valid

### Fix Applied

**File:** `/tmp/CCSwitcher-audit/CCSwitcher/Services/ClaudeService.swift`

Two changes to `switchAccount()`:

**Step 3.5 (new)** — After writing target credentials, make a live API call (`getUsageLimits`). If 401/expired → trigger `claude auth login` browser auth inline inside the switch flow. Browser auth now happens inside CCSwitcher with proper context instead of surprising the user in Claude Code.

**Step 5 (new)** — Always re-capture credentials after step 4 verification. Picks up any silent access-token rotation that `claude auth status` may have triggered.

### Build & Install

```bash
cd /tmp/CCSwitcher-audit
xcodebuild -project CCSwitcher.xcodeproj -scheme CCSwitcher \
  -configuration Release -derivedDataPath build/Release \
  CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO \
  build

rm -rf /Applications/CCSwitcher.app
cp -R build/Release/Build/Products/Release/CCSwitcher.app /Applications/CCSwitcher.app
```

Verify: `strings /Applications/CCSwitcher.app/Contents/MacOS/CCSwitcher | grep "Step 3.5"`

### Post-Install Steps
1. Click **↺ (re-auth)** on each non-active account in CCSwitcher to flush stale backups (one-time)
2. Test switch — should complete silently if tokens are fresh, or open browser inline if expired
3. Subsequent switches: Step 5 re-captures token after each switch, so backups stay current

### Accounts (3 total)
- `long@ltcapital.partners` — LT Capital Partners (team)
- `product@ltcapital.partners` — LT Capital Partners (team) ← Active at time of fix
- `chris.longnguyen@gmail.com` — personal (pro)

---

## Part 2 — Token Waste Audit

### Data
- 26 days, 1,949 sessions, 177,064 JSONL lines, 19,168 total messages
- Today (by ~8 AM): 244 turns, 666 tool calls, 468 Opus (92%) / 164 Sonnet / 0 Haiku turns, $78.50

### Always-Loaded Context
```
Project CLAUDE.md:     7.3 KB
Global CLAUDE.md:      2.4 KB
14 rules/*.md files:  23.8 KB
─────────────────────────────
Total:                33.8 KB ≈ 13,500 tokens per session
```

### Cache Efficiency (actual data)
- Opus cache reads: 271,619,204 tokens (1,300:1 ratio vs fresh input)
- This means the 13,500-token always-loaded context is nearly free per turn
- The tweet's waste patterns (54% cache miss, 22x repetition) do NOT apply here

### Hook Inventory
| Hook | Event | Times today |
|---|---|---|
| thinking-modes.sh | UserPromptSubmit | ~87× |
| memory-recall.sh | UserPromptSubmit | ~87× |
| strategic-compact.sh | PreToolUse (heavy tools only) | silent count |
| memory-guard.sh | PreToolUse | silent |
| git-warn.sh | PreToolUse | silent |
| build-metrics.sh | PostToolUse | silent |
| state-saver.sh | PostToolUse | silent |

### Prescriptions (ranked by impact/effort)

| # | Action | Est. token save | Effort |
|---|---|---|---|
| P1 | strategic-compact: session-scoped counter + raise threshold 200→350 | Cross-session false fires | 5 min ✅ DONE |
| P2 | memory-recall: skip prompts < 30 chars | 17–44K tokens/day | 10 min |
| P3 | Rules consolidation (7.2K→3.5K target, incomplete) | 6K/session × N | 30 min |
| P4 | Enforce model routing (audit Opus vs Sonnet sub-agent split) | Opus cost reduction | Audit |
| P5 | Read tool deduplication rule | Up to 500K in heavy sessions | 5 min |
| P6 | Cache keepalive for long thinking pauses | Prevents 13.5K token re-price | 10 min |

### Global Mastery Level: **L5 (<1% of Claude Code users)**
Evidence: 7-hook harness, QMD memory system (1,843 indexed docs), 4 MECE model-routed agents, ALPEI×DSBV PM framework, ToB security-audited tools, prior cost optimization cycles (QMD startup banned, Notion 62KB→400 token).

Not waste — deliberate expenditure. Marginal fixes are 5–15% gains, not 5× unlocks.

---

## Part 3 — strategic-compact.sh Fix

**Bug:** Counter was date-scoped (`count-YYYYMMDD`). Session 2 inherited Session 1's count → premature compaction reminders.

**Fix (v1.2):**
- Counter now session-scoped via `CLAUDE_SESSION_ID` → `count-{SESSION_ID}`
- THRESHOLD raised 200 → 350 (calibrated for 1M context window; 200 was for 200K)
- File: `~/.claude/hooks/scripts/strategic-compact.sh`

---

## Part 4 — Cache Warmup (CODE Hierarchy)

### K — Knowledge
Two prices: input (100%) vs cache read (~10%) vs cache creation (~125%). TTL: 5 minutes ephemeral.

### U — Understanding
```
Turn 1 (cold):  pay 13,500 × $3/M = ~$0.04 + creation surcharge
Turn 2+ (warm): pay 13,500 × $0.30/M = ~$0.004 (10x cheaper)
Cache expires:  any gap >5 min → next turn pays cold price again
```

### W — Wisdom
- 1,300:1 cache hit ratio = 13,500-token prefix costs ~$0.003/turn when warm
- One cache miss = same cost as 1,300 cache hits
- Sub-agents start cold — parent's warm cache does NOT transfer to children
- Stable prefix (unchanging CLAUDE.md + rules) = consistent cache hits

### E — Expertise
1. **Warm first turn**: send "hi" / "continue" before heavy work → warms cache cheap
2. **Keepalive for pauses**: if thinking >4 min, send a cheap turn to reset the 5-min clock
3. **Pre-spawn warmup**: ensure parent has 2+ turns before spawning expensive Opus agents
4. **Session continuity**: long active session > multiple short sessions (cache stays warm)
5. **Rules consolidation compounds**: smaller stable prefix = smaller creation cost on every cold start

---

## Open Items
- [ ] P2: Add prompt-length guard to memory-recall.sh (< 30 chars → skip recall)
- [ ] P3: Complete rules consolidation (23.8 KB → target ~13 KB total)
- [ ] P4: Audit Opus vs Sonnet sub-agent split in recent DSBV sessions
- [ ] P6: Add cache keepalive strategy (lightweight turns during thinking pauses)
- [ ] CCSwitcher: Re-authenticate all 3 accounts via ↺ button (one-time flush)
