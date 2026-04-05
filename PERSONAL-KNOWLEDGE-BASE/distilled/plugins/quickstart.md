---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: plugins
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - how_does_it_work
  - why_does_it_work
  - now_what_next
  - now_what_better
---

# Plugin Quickstart

The fastest path from zero to a working plugin: create a manifest, add one skill, and test with `--plugin-dir`. Five minutes end to end.

## L1: Why This Matters

Quickstart establishes the mental model before diving into complex plugin features. The pattern — manifest + component dir + `--plugin-dir` flag — repeats for every plugin you build.

## L1: What It Is

A minimal plugin has two files:

```
my-first-plugin/
├── .claude-plugin/
│   └── plugin.json      ← identity: name, version, description
└── skills/
    └── hello/
        └── SKILL.md     ← skill instructions
```

## L2: Step-by-Step Creation

**Step 1 — Create directories:**

```bash
mkdir -p my-first-plugin/.claude-plugin
mkdir -p my-first-plugin/skills/hello
```

**Step 2 — Write the manifest** at `my-first-plugin/.claude-plugin/plugin.json`:

```json
{
  "name": "my-first-plugin",
  "description": "A greeting plugin to learn the basics",
  "version": "1.0.0",
  "author": { "name": "Your Name" }
}
```

| Field         | Purpose                                                     |
| :------------ | :---------------------------------------------------------- |
| `name`        | Unique ID + skill namespace prefix (`/my-first-plugin:…`)   |
| `description` | Shown in plugin manager                                     |
| `version`     | Semver — must bump for users to receive updates             |
| `author`      | Optional attribution                                        |

**Step 3 — Write the skill** at `my-first-plugin/skills/hello/SKILL.md`:

```markdown
---
description: Greet the user with a friendly message
disable-model-invocation: true
---

Greet the user warmly and ask how you can help them today.
```

**Step 4 — Test locally:**

```bash
claude --plugin-dir ./my-first-plugin
```

Inside Claude Code:

```
/my-first-plugin:hello
```

Run `/help` to see the skill listed under the plugin namespace.

**Step 5 — Add arguments** (optional). Update `SKILL.md` to use `$ARGUMENTS`:

```markdown
---
description: Greet the user with a personalized message
---

Greet the user named "$ARGUMENTS" warmly and ask how you can help.
```

Run `/reload-plugins` (no restart needed), then:

```
/my-first-plugin:hello Alex
```

## L2: How `--plugin-dir` Works

- Loads the plugin for the current session only — no installation required.
- When a `--plugin-dir` plugin shares a name with an installed marketplace plugin, the local copy wins for that session.
- Load multiple plugins simultaneously: `claude --plugin-dir ./plugin-one --plugin-dir ./plugin-two`
- While running, `/reload-plugins` picks up any file changes without restarting.

## L2: What to Test After Creation

```
/my-first-plugin:hello          ← skill fires
/help                           ← skill appears under namespace
/agents                         ← agents appear (if added)
/reload-plugins                 ← hot-reload after edits
```

## Sources

- https://code.claude.com/docs/en/plugins (lines 22018–22149)

## Links

- [[overview]] — plugin vs standalone decision, architecture
- [[developing-plugins]] — add agents, hooks, MCP, LSP
- [[manifest-reference]] — all plugin.json fields
- [[distribution]] — share and publish the plugin
