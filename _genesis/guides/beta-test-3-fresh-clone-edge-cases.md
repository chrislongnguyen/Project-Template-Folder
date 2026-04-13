---
version: "1.0"
status: draft
last_updated: 2026-04-13
---

# Beta Test 3: Learning Pipeline — Cam Van

## Your Mission

We built a learning pipeline inside Claude Code. Instead of reading docs or Googling, you use a
few skills to go from "I want to understand X" to a structured set of learning pages — in about
two hours. We want you to try it with something real from your own work, and tell us how the
experience felt.

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
- Budget about 2.5 hours. The work itself is only about 2 hours; the rest is reflection.

---

## Part 1: Start the Pipeline (~30 min)

Open Claude Code and type:

```
/learn
```

This starts the learning pipeline for your repo. It will tell you what state the pipeline is in
and what to do next.

Then start the intake interview:

```
/learn:input
```

The skill will ask you 9 questions about what you want to learn — things like: what do you
already know, what outcome do you want, how much time you have. Answer honestly. There are no
wrong answers.

**What to notice:**
- Did `/learn` explain itself clearly, or were you unsure what it does?
- Were the 9 questions easy to answer, or did any of them confuse you?
- Did the skill feel like a conversation, or like filling out a form?

Write down anything that felt off. Even a sentence is enough.

---

## Part 2: Research (~45 min)

Once the intake is done, run:

```
/learn:research
```

The skill will go find information on your topic and produce a research summary. This may take a
few minutes.

When it finishes, read what it produced. You don't need to read every word — skim it and ask
yourself: does this feel relevant to what I said I wanted to learn?

**What to notice:**
- Did the research feel on-topic, or did it drift in a different direction?
- Was the output too long, too short, or about right?
- Did anything surprise you (in a good or bad way)?

---

## Part 3: Structure and Review (~60 min)

Now turn the research into structured learning pages:

```
/learn:structure
```

This creates pages labeled P0 through P5 — each one is a different level or angle on your topic.
Read through what was created. You should be able to open these in Obsidian or read them directly
in Claude Code.

Then run the review skill:

```
/learn:review
```

This helps you check what you actually absorbed. It may ask you questions or prompt you to
summarize something back in your own words.

**What to notice:**
- Were the P0-P5 pages understandable? Could you follow the progression?
- Did `/learn:review` feel useful, or did it feel like busywork?
- At any point did you feel lost about what to do next?

---

## Part 4: Reflect (~15 min)

Step back and think about the experience as a whole.

- Did you actually learn something about your topic?
- How does this compare to how you'd normally learn something new (docs, YouTube, asking a
  colleague)?
- If this were available in your normal workflow, would you use it?
- What's the one thing you'd change?

---

## Feedback Form

Answer these 10 questions and share with Long. One or two sentences per answer is fine.

1. What topic did you choose? Why that one?
2. Was `/learn:input` easy to answer? Which question (if any) was confusing?
3. Did the research output feel relevant to what you asked for? (1=off-topic, 5=exactly what I asked for) ___
4. Were the P0-P5 learning pages understandable on first read? (1=confusing, 5=clear progression) ___
5. Did you feel guided between stages (input → research → structure → review), or did you have
   to figure out what to do next on your own?
6. Did you actually learn something useful by the end?
7. How would you rate the experience compared to your usual way of learning? (1=much worse, 3=about the same, 5=much better) ___
8. Was there a moment where you got stuck or lost? What happened?
9. What's one thing the pipeline did well?
10. What's one thing you'd want fixed before this goes to other PMs?

---

## If Something Goes Wrong

If a skill errors or you're not sure how to proceed, run `/ltc-feedback` and describe what
happened. That feedback goes directly into the improvement backlog.

*Return this completed file to: Long Nguyen 
## Links

- [[learn]]
- [[filesystem-routing]]
- [[versioning]]
