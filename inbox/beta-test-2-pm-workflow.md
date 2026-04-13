---
version: "1.0"
status: draft
last_updated: 2026-04-13
---

# Beta Test 2: Fresh Clone — First-Day Experience

> Tester: Dung Vuong | Role: Project Manager | Time: ~2 hours
> We built this for you. Set up your project. Tell us honestly how it went.

---

## Your Mission

Clone the LTC Project Template as if it is your real project. Try to get oriented and create your first artifacts using only what you find in the repo. If something is confusing or missing, that is the finding — not your fault.

---

## Before You Start

- You need Claude Code installed and a GitHub account with access to Long-Term-Capital-Partners org.
- You do not need to know how to code. Everything here is plain English + Claude Code prompts.
- If something blocks you completely, skip it, note it in the feedback form, and move on.

---

## Part 1: Clone & Customize (~30 min)

**Goal:** Get your own copy of the template and make it yours.

**Step 1 — Create your repo.** Ask Claude Code to run this (replace PROJECT-NAME with your project):

```
gh repo create Long-Term-Capital-Partners/{PROJECT-NAME} \
  --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE \
  --private --clone
```

Then open the new folder in Claude Code.

**Step 2 — Read CLAUDE.md.** Open the file `CLAUDE.md` at the root of your repo. Find the `## Project` section. Read it — does it explain what this repo is for and how it is structured?

**Step 3 — Customize the Project section.** Edit `CLAUDE.md` and update the `## Project` section with your project name, purpose, and team. Ask Claude Code to help if needed.

**Record:** Could you do all 3 steps without asking anyone? Yes / No / Stuck on: ___

---

## Part 2: Explore Your Repo (~30 min)

**Goal:** Understand where things go without asking anyone.

Open each README below. For each one, answer the question using only what the README says.

**1-ALIGN/README.md** — Where does your project charter go? ___

**3-PLAN/README.md** — Where does your risk register go? ___

**2-LEARN/README.md** — Where do raw research notes go? ___

**Stress test (no peeking):**
- You wrote a sprint retrospective. Which folder? ___
- You have a new stakeholder interview transcript. Which folder? ___

**Record:** How many did you answer correctly without leaving the README? ___/5

Did the READMEs feel self-explanatory, or did you need to ask Claude Code for help? ___

---

## Part 3: Create Your First Artifacts (~60 min)

**Goal:** Use templates to create a charter and start a DSBV design cycle.

**Step 1 — Find the charter template.** In Claude Code, ask:
> "I need to create a project charter. What template should I use?"

Did Claude point you to a template file? Yes / No

**Step 2 — Create your charter.** Ask Claude Code to create a charter for your project using the template. Open the file — does it have a version, status, and date at the top (called frontmatter)?

Frontmatter present? Yes / No

**Step 3 — Start a DSBV design.** In Claude Code, type:
> `/dsbv design 1-ALIGN 1-PD`

DSBV is the four-stage process (Design → Sequence → Build → Validate) that keeps your project structured. You are starting the Design stage for your ALIGN workstream.

Did Claude guide you through this, or did it feel confusing? ___

Did it ask you questions before writing anything? Yes / No

---

## Part 4: Try to Find Help (~15 min)

**Goal:** Find the right tool for common PM needs — without searching manually.

Ask Claude Code each question below. Note whether it gave you a direct answer or left you to search.

| Your question | Did Claude answer directly? |
|---|---|
| "I want to check if my repo is healthy." | Yes / No |
| "I want to find broken links in my files." | Yes / No |
| "I want to pull the latest template updates safely." | Yes / No |

---

## Feedback Form

**Tester name:** Dung Vuong
**Date tested:**
**Time spent (actual):** ___ min

1. After cloning, did CLAUDE.md explain what to do next? (1=not at all, 5=completely clear) ___
2. Could you find where to put a charter without asking Claude? (1=had to ask, 5=obvious from README) ___
3. Could you find where to put a risk register without asking Claude? (same scale) ___
4. Did the charter template have everything you needed to get started? (1=missing a lot, 5=ready to fill in) ___
5. Did `/dsbv design` feel like it was guiding you, or did you feel lost? (1=lost, 5=guided) ___
6. Did Claude find the right health-check tool when you asked? (1=no/wrong tool, 5=instant correct answer) ___
7. How oriented did you feel after Part 1 + Part 2? (1=completely lost, 5=I know where everything goes) ___
8. Was there anything that made you want to stop and ask a human for help? If yes, what? ___
9. What one change would make your first day noticeably easier? ___
10. Would you recommend this setup to another PM without a training session? Yes / No / With caveats: ___

---

## If Something Goes Wrong

If you hit a bug or get a confusing error, use the `/ltc-feedback` skill in Claude Code:

> `/ltc-feedback` — then describe what happened and paste the error message.

This sends your finding directly into the improvement backlog. You do not need to file a ticket separately.

---

*Return this completed file to: Long Nguyen 

## Links

- [[CHANGELOG]]
- [[charter]]
- [[dsbv-process]]
- [[filesystem-routing]]
- [[migration-guide]]
- [[versioning]]
- [[workstream]]
