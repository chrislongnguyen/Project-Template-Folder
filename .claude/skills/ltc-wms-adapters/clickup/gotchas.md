# ClickUp Adapter — Known Gotchas & Lessons Learned

> Confirmed ClickUp MCP quirks that cause silent failures or errors if not handled.
> Based on live workspace audit (2026-03-22) from OE.6.3 clickup-planner experience.

---

## 1. Timestamp Format — Milliseconds Required

**Problem:** ClickUp `time_estimate` and date fields require timestamps in **milliseconds**,
not seconds. Passing seconds will silently set incorrect values.

**Fix:** Always convert:
```
milliseconds = minutes × 60 × 1000
Example: 45 min = 2,700,000 ms
```

**Additional timing gotcha:** `time_estimate` is NOT available on `create_task`. Create the
task first, then call `update_task` to set the time estimate in a separate call.

---

## 2. `task_type` for Standard Tasks Must Be `null`

**Problem:** The standard "Task" level does NOT exist as a named custom type called `"Task"`.
Using `task_type: "Task"` will fail or create an item with the wrong type.

**Fix:** Use `task_type: null` (or omit the parameter entirely) for Task-level items. The
built-in default type has `custom_item_id: 0`.

---

## 3. Newlines in Text Fields — Use `\n`, Not Actual Newlines

**Problem:** Some ClickUp MCP tool calls do not correctly handle actual newline characters
(`\n` ASCII 10) in text field values. Actual newlines may be stripped or cause API errors.

**Fix:** In JSON payloads for custom text fields, use literal `\n` escape sequences. Test
with the DESIRED OUTCOMES and ACCEPTANCE CRITERIA fields specifically, as they are the most
affected.

---

## 4. Field IDs Must Be Full UUIDs

**Problem:** Using a short prefix (e.g., `a382a103`) instead of the full UUID
(e.g., `a382a103-456b-41a8-9b2a-8fa15a657ce4`) causes field updates to silently fail or error.

**Exception:** The `URL Link` field (`b76eb12c`) is not a workspace-level field and uses its
short ID. All other custom fields require full UUIDs.

**Fix:** Always use full UUIDs from field-map.md. Never abbreviate.

---

## 5. `markdown_description` Does NOT Render Markdown

**Problem:** The `markdown_description` parameter does not render markdown in ClickUp.

**Fix:** Use `description` (plain text) instead. ClickUp auto-renders markdown from the
`description` field.

---

## 6. `find_member_by_name` Requires EXACT Display Name Match

**Problem:** Partial matches to `find_member_by_name` will fail silently.

**Fix:** Prefer `get_workspace_members` + filter by name client-side. Verify the exact
display name (including capitalization and spacing) before assigning.

---

## 7. 502 Bad Gateway Under Parallel Load

**Problem:** If multiple ClickUp MCP calls are made in rapid succession (parallel sub-agents
all hitting ClickUp simultaneously), 502 errors occur.

**Fix:** If a ClickUp MCP call returns 502, retry once with a brief backoff. If it fails
again, back off and alert the user. For bulk creation, add a small delay between batches.

---

## 8. Template Field Ordering Matters for Some API Calls

**Problem:** When creating tasks from templates, the order in which custom fields are set
can affect whether some fields stick. Setting VANA-related fields before status fields
is more reliable.

**Recommended order:**
1. Create task (name, task_type, parent, status, priority, assignees)
2. Set DESIRED OUTCOMES custom field
3. Set ACCEPTANCE CRITERIA custom field
4. Set DEFINITION OF DONE custom field
5. Set MoSCoW dropdown
6. Set ID / Short Name (for idempotency key)
7. Set time_estimate via separate update_task call
8. Set dependencies via clickup_add_task_dependency (second pass, after all items created)

---

## 9. LEP-Specific: .exec/ Status `done` → ClickUp `review`

**Problem (pipeline-specific):** When LEP marks a task `done` in status.json, the agent
might be tempted to set ClickUp to `done` as well. This violates the LEP critical rule.

**Fix:** When .exec/ status = `done`, always set ClickUp to `review`. Only the Human
Director can set ClickUp to `done`. Log this in the sync comment to make it explicit.

---

## 10. Duplicate Item Prevention

**Problem:** If the sync script is run multiple times (e.g., due to retry), it can create
duplicate ClickUp items.

**Fix:** Always check `.wms-sync.json` before creating. If a `wms_id` exists for the task,
call `update_task` instead of `create_task`. See adapter.md §4 for the full idempotency
protocol.

## Links

- [[adapter]]
- [[field-map]]
- [[standard]]
- [[task]]
