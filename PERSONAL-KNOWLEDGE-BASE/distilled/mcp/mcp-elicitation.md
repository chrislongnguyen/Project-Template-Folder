---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: mcp
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
---

# MCP Elicitation

> Elicitation lets MCP servers request structured user input mid-task — Claude Code shows an interactive dialog; hooks can intercept and auto-respond programmatically.

## L1 — Knowledge

### So What? (Relevance)

Elicitation solves the "MCP server needs user credentials or decisions mid-operation" problem without breaking the agentic flow. For LTC workflows using MCP servers that need credentials (databases, internal APIs), elicitation is how those credentials get passed securely without hardcoding.

### What Is It?

A mechanism by which an MCP server can pause tool execution and request structured input from the user. Claude Code displays an interactive dialog (form or browser URL) and passes the response back to the server. No client configuration required — dialogs appear automatically when a server requests them.

### What Else?

**Two elicitation modes:**
- **Form mode:** Dialog with form fields defined by server (e.g., username + password)
- **URL mode:** Browser-based authentication (OAuth, approval flows)

**Two hook events:**
- `Elicitation` — fires when server requests input; hook can auto-respond, skipping dialog
- `ElicitationResult` — fires after user responds; hook can observe or override the response

**Auto-responding with Elicitation hook:**
```json
{
  "hookSpecificOutput": {
    "hookEventName": "Elicitation",
    "action": "accept",
    "content": {
      "username": "alice"
    }
  }
}
```

**Override user response with ElicitationResult hook:**
```json
{
  "hookSpecificOutput": {
    "hookEventName": "ElicitationResult",
    "action": "decline",
    "content": {}
  }
}
```

### How Does It Work?

1. MCP server tool call executes; server determines it needs user input
2. Server sends elicitation request (form schema or URL)
3. `Elicitation` hook fires — if hook auto-responds, dialog skipped entirely
4. If no hook auto-responds: Claude Code shows dialog to user
5. User responds; `ElicitationResult` hook fires with the response
6. Hook can override before response is sent back to server
7. Server receives final response and continues execution

**`action` values:** `accept`, `decline`, `cancel`
- `accept` + `content` = submit form field values
- `decline` = explicitly decline
- `cancel` = cancel the operation

**Exit code 2 on Elicitation:** Denies the elicitation, shows stderr to user
**Exit code 2 on ElicitationResult:** Blocks response, changes effective action to `decline`

**Matcher:** Both `Elicitation` and `ElicitationResult` match on MCP server name — use your configured server name as matcher to scope responses to specific servers.

## L2 — Understanding

### Why Does It Work?

Elicitation is the MCP-equivalent of Claude's `AskUserQuestion` tool — a structured way to pause and collect input that the agent cannot generate itself. The hook interception layer allows automation (CI, scripted sessions) to provide credentials without interactive prompts, while the base behavior (dialog) works for human users with no configuration.

### Why Not?

- `ElicitationResult` hooks fire after the user has already responded — they modify/override, not prevent the user from seeing the dialog
- `Elicitation` hook auto-respond replaces the dialog entirely — if your response is wrong, no fallback dialog appears
- Hook matching is on server name, not on the specific elicitation content — you can't filter by "only auto-respond to username prompts, not password prompts" without reading the `requested_schema`

## Sources

- captured/claude-code-docs-full.md (lines 14428-14542, 17919-17930)

## Links

- [[mcp-server-config]]
- [[mcp-authentication]]
- [[hook-input-output]]
