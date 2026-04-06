---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: permissions
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

# Permission Rules (Allow / Ask / Deny)

The mode sets a session-level posture; permission rules set tool-level exceptions. Rules are the mechanism for pre-approving routine commands and blocking sensitive ones permanently, across any mode.

## L1 — Knowledge

### So What? (Relevance)

Without rules, every new tool call prompts — or is silently denied in `dontAsk` mode. Rules let you encode "always allow `npm test`" and "never allow `git push *`" once in settings, so the permission system enforces policy rather than depending on per-session human judgment. This is how you make CI pipelines deterministic and prevent accidental production deploys across all developers.

### What Is It?

Permission rules are entries in the `permissions.allow`, `permissions.ask`, or `permissions.deny` arrays in any Claude Code settings file. Each rule is a string of the form `Tool` or `Tool(specifier)`.

**Three rule types:**
- `allow` — Claude runs this tool without prompting.
- `ask` — Claude prompts for confirmation (the default for most tools; explicitly listing here overrides a blanket allow).
- `deny` — Claude cannot use this tool; the call is blocked before execution.

**Evaluation order: deny → ask → allow.** The first matching rule wins. Deny rules always take precedence.

### What Else?

**Tool coverage:** Rules apply to `Bash`, `Read`, `Edit`, `WebFetch`, `mcp__<server>`, and `Agent(<name>)` tools. Separate syntax exists for each.

**Settings precedence (highest to lowest):**
1. Managed settings (cannot be overridden)
2. Command-line arguments (`--allowedTools`, `--disallowedTools`)
3. Local project settings (`.claude/settings.local.json`)
4. Shared project settings (`.claude/settings.json`)
5. User settings (`~/.claude/settings.json`)

If a tool is denied at any level, no lower level can allow it. A project `deny` overrides a user-level `allow`.

**Hooks extend rules:** `PreToolUse` hooks run before the permission prompt. A hook exiting with code 2 blocks the tool call even if an `allow` rule matches. A hook returning `"allow"` skips the prompt but deny rules still apply.

### How Does It Work?

**Basic syntax:**

```json
{
  "permissions": {
    "allow": ["Bash(npm run *)", "Bash(git commit *)"],
    "deny": ["Bash(git push *)"]
  }
}
```

**Bash wildcard patterns:**
- `Bash(npm run build)` — exact match only.
- `Bash(npm run *)` — any command starting with `npm run ` (note space before `*` enforces word boundary).
- `Bash(npm*)` — without space, matches `npm` and `npmrun` alike — no word boundary.
- `Bash(* --version)` — any command ending with ` --version`.
- `Bash(git * main)` — matches `git checkout main`, `git merge main`, etc.
- Shell operators (`&&`) are understood: `Bash(safe-cmd *)` does NOT authorize `safe-cmd && other-cmd`.
- Compound command approval ("Yes, don't ask again") saves up to 5 sub-rules, one per subcommand that required approval.

**Read/Edit path patterns (gitignore spec):**

| Pattern | Scope | Example |
|---------|-------|---------|
| `//path` | Absolute from filesystem root | `Read(//Users/alice/secrets/**)` |
| `~/path` | From home directory | `Read(~/.zshrc)` |
| `/path` | Relative to project root | `Edit(/src/**/*.ts)` |
| `path` or `./path` | Relative to current directory | `Read(*.env)` |

Note: `/Users/alice/file` is NOT absolute — it is relative to project root. Use `//Users/alice/file` for absolute paths.

`*` matches within a single directory. `**` matches recursively. To allow all reads: `Read` (no parentheses).

**WebFetch:**
- `WebFetch(domain:example.com)` — matches all fetch requests to example.com.
- WebFetch rules do not block `curl` in Bash — a separate Bash deny rule or sandbox is needed for that.

**MCP tools:**
- `mcp__puppeteer` — all tools from the `puppeteer` server.
- `mcp__puppeteer__puppeteer_navigate` — one specific tool.

**Agent (subagents):**
- `Agent(Explore)` — matches the Explore subagent.
- Add to `deny` to disable specific agents:

```json
{ "permissions": { "deny": ["Agent(Explore)"] } }
```

## L2 — Understanding

### Why Does It Work?

Rules are evaluated at the tool layer, before execution, and after classifier checks in `auto` mode. The deny-first order mirrors a security principle: default-deny is safer than default-allow because a missing rule is benign (prompts or blocks) rather than dangerous (executes). By encoding policy in settings files that can be checked into version control and distributed via managed settings, the system makes permission decisions auditable and reproducible rather than dependent on per-developer judgment.

The gitignore pattern spec for Read/Edit rules is reused because developers already understand it from `.gitignore` files — it lowers the learning cost of a new security mechanism.

### Why Not?

**Bash pattern fragility:** Patterns that try to constrain arguments are unreliable. `Bash(curl http://github.com/ *)` fails to match `curl -X GET http://github.com/...` (options before URL), `curl https://...` (different protocol), or `curl $URL` (variable). For URL-level control, use `WebFetch(domain:...)` rules combined with Bash deny rules for `curl`/`wget`, or implement a `PreToolUse` hook that validates URLs.

**Read/Edit rules only cover built-in tools:** A `Read(./.env)` deny rule blocks the `Read` tool but does NOT block `cat .env` in Bash. Bash subprocesses bypass file-level deny rules entirely. OS-level enforcement requires the sandbox.

**Allow rules in auto mode are partially dropped:** On entering `auto` mode, broad allow rules (`Bash(*)`, wildcarded interpreters, package-manager run commands) are dropped and replaced by the classifier. Narrow rules like `Bash(npm test)` carry over. Dropped rules restore when you leave `auto`.

**No wildcard for WebFetch domains:** You cannot use `WebFetch(domain:*.example.com)` to match subdomains — only exact domain strings are supported.

## Sources

- Source: `captured/claude-code-docs-full.md` lines 20458–20870
- Upstream URL: https://code.claude.com/docs/en/permissions

## Links

- [[permission-modes]]
- [[auto-mode-classifier]]
- [[managed-settings]]
- [[protected-paths]]
