# /session-start — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Querying Notion/Linear during session-start

**What happens:** Agent calls Notion MCP or Linear API to "enrich" the recall. This is explicitly forbidden — session-start reads vault only, not WMS.

**How to detect:** Check tool calls during session-start execution. Any `notion-search`, `notion-fetch`, `notion-query-*`, or Linear API call is a violation.

**Fix:** Session-start reads vault sessions only. All WMS queries happen later, outside this skill.

---

## 2. Output exceeds 10 lines

**What happens:** Agent produces a full standup or detailed summary instead of the brief recall format. The 10-line limit is a hard constraint.

**How to detect:** Count the output lines. If more than 10, the skill violated its contract.

**Fix:** Synthesize vault content into the 4-field format (Last, State, Next, Issues). Cut details ruthlessly. ILE fields append but total must stay ≤10.

---

## 3. Dumping raw qmd results

**What happens:** Agent reads a session file and pastes large chunks verbatim instead of synthesizing into the 4-field format (Last, State, Next, Issues).

**How to detect:** Output contains raw frontmatter, full file contents, or unstructured paragraphs from vault files.

**Fix:** Extract the 4 key fields from the session file, discard everything else, format as the recall template.
