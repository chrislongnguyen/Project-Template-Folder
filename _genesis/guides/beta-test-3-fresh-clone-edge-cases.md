---
version: "1.0"
status: draft
last_updated: 2026-04-13
---

# Beta Test 3: Learning Pipeline — Cam Van

## Your Mission

We built a 5-stage learning pipeline inside Claude Code. Instead of reading docs or Googling, you
run five commands that take you from "I want to understand X" all the way to a structured spec
your team can act on. We want you to try it with something real from your own work, and tell us
how the experience felt.

---

## Before You Start

- **Start by cloning a fresh copy of the v2.1.0 template** — this test runs on a clean repo, not your existing project:
  ```
  gh repo create Long-Term-Capital-Partners/{YOUR-TEST-REPO-NAME} \
    --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE \
    --private --clone
  ```
  Then open the new folder in Claude Code.
- Pick a topic you actually want to learn — a methodology, a tool, a domain concept. Anything
  relevant to your project. The test is about the process, not the topic.
- Budget about 3 hours. The pipeline itself takes about 2.5 hours; the rest is reflection.

---

## The Pipeline — 5 stages, one command each

The learning pipeline has 5 stages. Run them in order. Each stage builds on the last.

```
/learn:input  →  /learn:research  →  /learn:structure  →  /learn:review  →  /learn:spec
   (you)           (agent)             (agent)              (you + agent)     (agent)
  9 questions     find sources        build P0-P5 pages     test your         produce handoff
  about your      and summarize       from research         understanding     spec + readiness
  learning goal   findings                                                    package
```

At any point, you can type `/learn` (no sub-command) to see where the pipeline is and what to
do next. Use it whenever you're unsure.

---

## Part 1: Input — Define What You Want to Learn (~20 min)

Open Claude Code and type:

```
/learn
```

This shows you the current state of the pipeline. Since this is a fresh repo, it will tell you
to start with input. Run:

```
/learn:input
```

The skill asks you 9 questions about what you want to learn — things like: what do you already
know, what outcome do you want, how much time you have. Answer honestly. There are no wrong
answers. It saves your answers to a file that the rest of the pipeline uses.

**What to notice:**
- Did `/learn` explain itself clearly, or were you unsure what it does?
- Were the 9 questions easy to answer, or did any of them confuse you?
- Did the skill feel like a conversation, or like filling out a form?

Write down anything that felt off. Even a sentence is enough.

---

## Part 2: Research — Let the Agent Find Sources (~45 min)

Once the intake is done, run:

```
/learn:research
```

The agent goes out to find information on your topic and produces research summaries — one per
topic you defined. This may take a few minutes. When it finishes, skim what it produced. You
don't need to read every word — ask yourself: does this feel relevant to what I said I wanted
to learn?

**What to notice:**
- Did the research feel on-topic, or did it drift in a different direction?
- Was the output too long, too short, or about right?
- Did anything surprise you (in a good or bad way)?

---

## Part 3: Structure — Build Your Learning Pages (~30 min)

Now turn the research into structured learning pages:

```
/learn:structure
```

This creates 6 pages labeled P0 through P5 — each covers a different angle on your topic:

| Page | What it covers |
|------|----------------|
| P0 | Overview & Summary |
| P1 | Ultimate Blockers — what prevents success |
| P2 | Ultimate Drivers — what enables success |
| P3 | Principles — the rules that govern this domain |
| P4 | Components — the parts of the system |
| P5 | Steps to Apply — how to put it into practice |

Read through what was created. You can open these in Obsidian or read them directly in Claude Code.

**What to notice:**
- Were the P0-P5 pages understandable? Could you follow the progression?
- Did any page feel redundant or confusing?
- Could you explain the topic to a colleague using just these 6 pages?

---

## Part 4: Review — Test What You Actually Absorbed (~30 min)

Now validate your understanding:

```
/learn:review
```

The agent presents the causal chain from your pages and asks you comprehension questions — one
per page (6 total). This is where you discover whether the pages actually taught you something,
or just looked good. Answer in your own words. The agent marks each page as `validated` or
`needs-revision` based on your answers.

If any page needs revision, the agent will tell you what to fix. You can re-run
`/learn:structure` for that topic and then `/learn:review` again.

**What to notice:**
- Did `/learn:review` feel useful, or did it feel like busywork?
- Were the questions fair — testing understanding, not memorization?
- Did you pass all 6, or did some pages need revision? Was that feedback helpful?

---

## Part 5: Spec — Produce the Handoff Package (~15 min)

Once all pages are validated, run the final stage:

```
/learn:spec
```

This reads your validated P0-P5 pages and produces two outputs:

1. **VANA-SPEC** — a structured handoff document that downstream work (designs, plans, builds)
   can consume. It captures what you learned in a format that other agents and team members
   can act on.
2. **Readiness Package** — a checklist confirming that this learning is complete and ready to
   feed into the next workstream.

This is the capstone. Without it, the learning stays in your head. With it, the learning becomes
an input that the rest of your project can use.

**What to notice:**
- Did the VANA-SPEC capture the essence of what you learned?
- Did it feel like the pipeline reached a clear conclusion, or did it just... stop?
- Could a colleague read the spec and understand the domain without doing the pipeline themselves?

---

## Part 6: Reflect (~15 min)

Step back and think about the full experience — all 5 stages.

- Did you actually learn something about your topic?
- How does this compare to how you'd normally learn something new (docs, YouTube, asking a
  colleague)?
- Was there a clear arc from "I want to learn X" to "here's a usable spec"?
- If this were available in your normal workflow, would you use it?
- What's the one thing you'd change?

---

## Feedback Form

Answer these 12 questions and share with Long. One or two sentences per answer is fine.

**Stage experience (one question per stage):**

1. `/learn:input` — Were the 9 questions easy to answer? Which (if any) was confusing?
2. `/learn:research` — Did the research feel relevant to what you asked for? (1=off-topic, 5=exactly right) ___
3. `/learn:structure` — Were the P0-P5 pages understandable on first read? (1=confusing, 5=clear progression) ___
4. `/learn:review` — Did the review feel useful (testing your understanding) or like busywork? (1=busywork, 5=genuinely tested me) ___
5. `/learn:spec` — Did the VANA-SPEC capture the essence of what you learned? Could a colleague use it? (1=useless, 5=actionable handoff) ___

**Overall experience:**

6. What topic did you choose? Why that one?
7. Did you feel guided between the 5 stages, or did you have to figure out what to do next on your own?
8. Did the pipeline reach a clear conclusion (spec), or did it feel like it just... stopped?
9. Did you actually learn something useful by the end?
10. How would you rate this compared to your usual way of learning? (1=much worse, 3=about the same, 5=much better) ___
11. Was there a moment where you got stuck or lost? What happened?
12. What's one thing you'd want fixed before this goes to other PMs?

---

## If Something Goes Wrong

If a skill errors or you're not sure how to proceed, run `/ltc-feedback` and describe what
happened. That feedback goes directly into the improvement backlog.

*Return this completed file to: Long Nguyen 
## Links

- [[learn]]
- [[filesystem-routing]]
- [[versioning]]
