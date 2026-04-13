---
version: "1.0"
status: draft
last_updated: 2026-04-13
work_stream: 5-IMPROVE
type: user-testing
---

# Beta Test 4 — Day in the Life

## Your Mission

Work on your actual project for about 3 hours today. Don't change anything about how you work — just notice what v2.1.0 makes easier (or harder) and jot notes as you go. Fill out the form at the end. That's it.

## Before You Start

- **Run the migration guide on your actual project repo before starting.** Beta Test 1 is the guided walkthrough — paste the prompt from that guide into your project repo and let the agent upgrade it to v2.1.0 first. This test is about how the upgraded repo feels in real work, so the migration must be done before you begin.
- Have your project open in Claude Code and Obsidian
- Keep a scratch note open to jot observations in the moment (not after)

## What to Pay Attention To

**1. Navigation — finding where things go**
When you need to know where a file belongs or where something lives, what do you reach for? Does the README help, or do you end up asking Claude or Long? Does the folder structure feel obvious or does it still require guessing?

**2. Starting work — kicking off a new piece of work**
When you start something new (a design, a plan, a research thread), does `/dsbv` feel natural or like extra ceremony? Does Claude guide you to the right first step, or do you have to explain context each time?

**3. Tool discovery — scripts and skills**
When you need a specific script or skill, can you find it without digging? Does Claude already know it exists and suggest it, or do you have to hunt?

**4. Guardrails — when something gets blocked**
If a guard fires (naming check, status block, routing check), was the error message clear? Did you understand why it stopped you? Did the guard feel like it was protecting you or slowing you down for no reason?

**5. Agent behavior — does Claude feel competent here**
Without coaching it, does Claude seem to know the rules of your repo? Does it put things in the right place, use the right format, follow conventions? Or does it need hand-holding?

## Suggested Work (pick whatever's real for you)

- Continue a design or plan you already have in progress
- Start a new LEARN research thread on something you've been meaning to explore
- Review and update a piece of documentation that's been sitting stale
- Try a new skill you haven't used before (`/dsbv status`, `/ingest`, `/obsidian`, etc.)

## Feedback Form

**1. Overall: How did today's work feel compared to before v2.1.0?**
1 (much harder) — 2 — 3 (about the same) — 4 — 5 (noticeably smoother)

**2. Navigation: Did READMEs help you find where things go?**
1 (never) — 2 — 3 (sometimes) — 4 — 5 (almost always)

**3. What's one thing you still had to ask Claude or Long about that you feel the repo should have answered?**
(open)

**4. Starting work: Did `/dsbv` feel natural or bureaucratic?**
1 (bureaucratic) — 2 — 3 (neutral) — 4 — 5 (felt right)

**5. Tool discovery: When you needed a script or skill, could you find it?**
1 (never) — 2 — 3 (sometimes) — 4 — 5 (always)

**6. Did any guard fire today? If yes — was the error message clear?**
No guard fired / Yes, message was clear / Yes, message was confusing (describe below)

**7. If a guard fired and was confusing — what did it say and what were you trying to do?**
(open, skip if no guard)

**8. Agent behavior: Did Claude feel competent in your repo without coaching?**
1 (needed a lot of hand-holding) — 2 — 3 — 4 — 5 (felt like it knew the repo)

**9. What's one thing that slowed you down today that you didn't expect?**
(open)

**10. What's one thing that worked better than you expected?**
(open)

## If Something Goes Wrong

Hit a bug, a confusing error, or a frustrating moment? Run `/ltc-feedback` in Claude Code and describe what happened. Don't fix it yourself — log it so we can improve it. Your friction is the data.

*Return this completed file to: Long Nguyen 