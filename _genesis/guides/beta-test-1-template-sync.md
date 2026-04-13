---
version: "1.0"
status: draft
last_updated: 2026-04-13
---

# Beta Test 1 — Template Sync (v2.1.0)

> Tester: Dong Tran | Estimated time: 30-45 minutes | Session date: TBD

We built a new way to upgrade your project repo when the LTC template ships improvements.
Paste one prompt into Claude Code and the agent walks you through everything, protecting
your content the whole way. **Try it. Tell us honestly how it went.**

---

## 1. Your Mission

Sync your repo to template v2.1.0. Your charter, decisions, research, and CLAUDE.md project
section should be untouched when done. Tell us whether that held — and whether it felt safe.

---

## 2. Before You Start

- You are in YOUR project repo in Claude Code (not the template repo itself)
- Your repo has domain content you care about: charter, decisions, research
- Your working tree is clean — commit or set aside any unsaved work first

The agent handles everything else.

---

## 3. The Test

Paste the block below into your Claude Code session and press Enter. Read what the agent
says and approve each step when asked. Do not run commands yourself.

```
I want to sync my repo with LTC template v2.1.0.

GUIDE ME through this process — explain what you're doing and why before
each action. I want to understand the migration, not just have it done.

Follow these steps:

1. SAFETY FIRST
   - Confirm I'm in MY project repo (not the template repo itself)
   - Check my working tree is clean (if not, help me stash or commit)
   - Create a test branch: test/template-v2.1.0
   - Create a backup tag: backup/pre-v2.1.0
   - Explain: why branch + tag protects my work

2. CONNECT TO TEMPLATE
   - Add the template remote if not present:
     git remote add template https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git
   - Fetch the target version: git fetch template v2.1.0
   - Explain: what a git remote is and why we need it

3. DETECT MY PATH
   - Check my repo structure to determine Path A, B, or C:
     • PATH A: Fresh repo, no existing work
     • PATH B: Pre-ALPEI structure or severely diverged (>30%)
     • PATH C: Has 1-ALIGN/, .claude/rules/, _genesis/ — normal upgrade
   - Explain: why these 3 paths exist and which one applies to me

4. FETCH AND READ THE MIGRATION GUIDE
   - Run: git show template/v2.1.0:_genesis/guides/migration-guide.md
   - Follow the detailed steps for my detected path
   - Before each major action, explain what will happen and ask for my OK

5. VERIFY AND EXPLAIN RESULTS
   - Run verification after sync completes
   - Show me what changed (files added, merged, skipped)
   - Explain: the three lineages (template, shared, domain) and how my files were classified
   - Confirm: my domain content (charter, research, code) was NOT touched

6. FINAL CHECK
   - Summarize what was done
   - Show me how to verify the sync worked
   - Explain: how to roll back if anything is wrong
   - Tell me: what to do next (test, commit, merge to main, or discard)
```

The agent takes it from there. Read, observe, and answer if it asks you something.

---

## 4. What to Watch For

1. Did the agent explain the branch and backup tag — did you feel your main branch was safe?
2. Did your charter, decisions, or research appear in the "changed" list? They should not.
3. Was your `CLAUDE.md ## Project` section word-for-word the same after sync?
4. Did the verification step report something like "6/6 checks pass"?
5. Were there any moments where you were unsure whether something went wrong?
6. Did the agent mention the rollback option before finishing?

---

## 5. After the Sync

1. Open your charter file — does it look exactly as you left it?
2. Open `CLAUDE.md` — is your `## Project` section still your words?
3. Ask the agent: "What changed during the sync?" — the answer should be system files
   (scripts, rules), not your project content.

If all three look right, the sync worked.

---

## 6. Feedback Form

Short answers are fine — one or two sentences each.

1. Did you feel safe at the start, knowing a backup was created before anything changed? (Yes / No / Somewhat — why?)
2. Did the agent explain each step clearly? Which step, if any, was confusing?
3. Were any of your domain files (charter, decisions, research) listed as changed? (Yes / No — if yes, which ones?)
4. Was your `CLAUDE.md ## Project` section identical before and after? (Yes / No — if no, what changed?)
5. Did the verification step pass cleanly? (Yes / No — if no, what did it say?)
6. How long did it take from pasting the prompt to the agent finishing? (minutes)
7. Was there a moment where you felt unsure whether to continue? (Yes / No — describe it if yes)
8. Would you do this sync again on your own without anyone guiding you? (Yes / No / Maybe — why?)
9. What one thing would make this feel safer or clearer?
10. Would you recommend this to another LTC PM? (Yes / No / Not yet — why?)

---

## 7. If Something Goes Wrong

The agent created a backup tag (`backup/pre-v2.1.0`) at the very start. If anything looks
wrong, tell it: "Something doesn't look right — walk me through the rollback." It will
restore your repo to exactly where you started.

If the agent gets confused or something breaks, type `/ltc-feedback` in Claude Code and
describe what happened — the skill files a GitHub issue for you directly.

---
*Return this completed file to: Long Nguyen 

## Links

- [[migration-guide]]
- [[template-sync]]
- [[CHANGELOG]]
- [[CLAUDE]]
