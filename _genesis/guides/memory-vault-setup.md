---
version: "2.1"
status: draft
last_updated: 2026-04-03
---

# Memory Vault — New Member Setup Guide

> Run this once after cloning. Takes 2 minutes.

## What you're setting up

Claude Code has a built-in **Auto Memory** feature (official, ships ON by default since v2.1.59). LTC adds structure on top of it so the memory stays organized and doesn't get overwritten into a generic format.

```
Without setup:  Claude has auto memory but no structure — notes get scattered or overwritten.
With setup:     Claude writes to a structured vault with a consistent index, loaded every session.
```

**3 pieces:**

| Piece | What it does |
|-------|-------------|
| **Memory Vault** | A folder on your machine (`~/.claude/projects/.../memory/`) where Claude stores persistent facts about this project. The first 200 lines of `MEMORY.md` are loaded at every session start automatically. |
| **Auto Memory** | Official Claude Code feature (`autoMemoryEnabled: true`, on by default since v2.1.59). Claude decides in real-time during your session what's worth saving — build commands, bugs, patterns, decisions. No timer, no background agent. |
| **memory-guard hook** | A hook that prevents Claude from destroying the vault's structure when writing. Blocks writes that would flatten the required 3-section format. |

**Why the 3-section structure matters:**

Claude's default auto memory writes in an unstructured way. LTC's vault enforces 3 required sections:

```
## Agent Instructions   ← rules for how Claude maintains the vault (never touch)
## Briefing Card        ← quick project context, loaded every session
## Topic Index          ← pointers to topic files (decisions, patterns, pitfalls)
```

Without the guard and `memory-format.md` rule, Claude's auto memory can flatten this into a generic format — you lose the structured index and meta-rules.

---

## Setup (run once)

```bash
./scripts/setup-member.sh --name "Your Name" --role "Your Role at LTC"
```

Example:
```bash
./scripts/setup-member.sh --name "Anh Vinh" --role "LTC Partners, CIO"
```

What it does:
1. Confirms `autoMemoryEnabled: true` in your `~/.claude/settings.json` (removes legacy `autoDreamEnabled` if present)
2. Wires `memory-guard.sh` as a PreToolUse hook (blocks malformed MEMORY.md writes)
3. Creates `~/.claude/projects/{this-repo-hash}/memory/`
4. Seeds `MEMORY.md` with the 3-section template, personalized with your name
5. Seeds 3 starter topic files: `learned_patterns.md`, `key_decisions.md`, `common_pitfalls.md`

---

## After setup

1. Open Claude Code in this project directory
2. Run `/resume` — Claude reads the vault and loads your project context
3. Work normally — Claude writes to the vault during the session when it decides something is worth saving
4. Run `/memory` to browse what Claude has saved at any time

---

## Files involved

| File | Location | Purpose |
|------|----------|---------|
| `MEMORY.md` | `~/.claude/projects/{hash}/memory/` | Index + briefing card (machine-local, not in git) |
| Topic files | `~/.claude/projects/{hash}/memory/*.md` | Detail files for each memory type |
| `memory-format.md` | `.claude/rules/` | Rule that enforces vault structure (ships with repo) |
| `memory-guard.sh` | `scripts/` | Hook script that blocks bad writes (ships with repo) |
| `MEMORY-seed.md` | `_genesis/templates/` | Template used by setup-member.sh |
| `memory-seeds/` | `_genesis/templates/memory-seeds/` | Seed topic file templates |

---

## Troubleshooting

**"Claude doesn't remember anything from last session"**
→ Run `ls ~/.claude/projects/*/memory/MEMORY.md` — if empty, run setup-member.sh again.
→ Check Claude Code version: `claude --version` — must be v2.1.59+.

**"Auto Memory seems disabled"**
→ Check `~/.claude/settings.json` — `autoMemoryEnabled` should be `true` (or absent — default is on).
→ Run `/memory` inside a Claude Code session to toggle it.

**"MEMORY.md write was blocked"**
→ The guard caught a structural violation. Claude tried to write a malformed file. The block is correct — don't bypass it.

**"My memory is from a different project path"**
→ The vault is keyed to the absolute path of the repo. If you moved the repo, run setup-member.sh again from the new location.
