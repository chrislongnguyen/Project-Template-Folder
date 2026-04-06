---
version: "2.0"
status: Draft
last_updated: 2026-04-05
---
# Learning Dashboard

> Dataview-powered live queries. Requires the Dataview plugin enabled with JavaScript Queries ON.

---

## Learning Level Distribution

How deep is your knowledge? Pages grouped by highest completed learning level.

```dataview
TABLE
  length(questions_answered) AS "Questions",
  choice(length(questions_answered) >= 12, "L4 Expertise",
    choice(length(questions_answered) >= 8, "L3 Wisdom",
      choice(length(questions_answered) >= 6, "L2 Understanding",
        choice(length(questions_answered) >= 4, "L1 Knowledge", "Incomplete")))) AS "Level",
  topic AS "Topic"
FROM "PERSONAL-KNOWLEDGE-BASE/distilled"
WHERE questions_answered
SORT length(questions_answered) DESC
```

---

## Uningested Files (Staleness Monitor)

Files in `captured/` that haven't been processed yet. If this list grows, run `/ingest`.

```dataviewjs
const captured = app.vault.getFiles().filter(f => f.path.startsWith("PERSONAL-KNOWLEDGE-BASE/captured/") && !f.name.startsWith("."));
const log = await app.vault.adapter.read("PERSONAL-KNOWLEDGE-BASE/distilled/_log.md").catch(() => "");
const uningested = captured.filter(f => !log.includes(f.name));
if (uningested.length === 0) {
  dv.paragraph("✓ All files ingested. Nothing pending.");
} else {
  dv.paragraph(`⚠ **${uningested.length} file(s) awaiting ingest:**`);
  dv.list(uningested.map(f => f.name));
}
```

---

## Recent Ingests

Last 10 ingest operations from `_log.md`.

```dataviewjs
const log = await app.vault.adapter.read("PERSONAL-KNOWLEDGE-BASE/distilled/_log.md").catch(() => "");
const lines = log.split("\n").filter(l => l.startsWith("|") && !l.startsWith("| Date") && !l.startsWith("|---"));
const recent = lines.slice(-10).reverse();
if (recent.length === 0) {
  dv.paragraph("No ingests yet. Drop a source into captured/ and run /ingest.");
} else {
  dv.paragraph(recent.join("\n"));
}
```

---

## Topics

Pages grouped by topic. Shows which domains are growing.

```dataview
TABLE
  length(rows) AS "Pages",
  min(rows.last_updated) AS "Oldest",
  max(rows.last_updated) AS "Newest"
FROM "PERSONAL-KNOWLEDGE-BASE/distilled"
WHERE topic
GROUP BY topic
SORT length(rows) DESC
```

---

## Review Queue (Learnie)

Pages due for spaced repetition review.

```dataview
TABLE
  review_interval AS "Interval (days)",
  last_updated AS "Last Updated",
  choice(length(questions_answered) >= 12, "L4",
    choice(length(questions_answered) >= 8, "L3",
      choice(length(questions_answered) >= 6, "L2", "L1"))) AS "Level"
FROM "PERSONAL-KNOWLEDGE-BASE/distilled"
WHERE review = true
SORT last_updated ASC
```
