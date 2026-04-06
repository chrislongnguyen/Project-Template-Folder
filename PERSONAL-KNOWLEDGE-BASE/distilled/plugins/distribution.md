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
  - why_not
  - now_what_next
  - now_what_better
---

# Plugin Distribution — Versioning, Sharing, and Migration

How to go from a working local plugin to something teammates or the community can install. Covers semantic versioning, marketplace submission, and migrating standalone `.claude/` config into a plugin.

## L1: Why Distribution Matters

A plugin that only works with `--plugin-dir` is a prototype. Distribution is what makes a plugin reusable: it gets a version number, lives in a marketplace, and can be installed with one command.

## L1: What Distribution Involves

Three tracks:

| Track                  | Audience            | Mechanism                                    |
| :--------------------- | :------------------ | :------------------------------------------- |
| Team sharing           | Colleagues          | Install with `--scope project` into repo     |
| Private marketplace    | Org or team         | Self-hosted marketplace.json                 |
| Official marketplace   | Public / community  | Submit to Anthropic via in-app form          |

## L2: Versioning

Use **semantic versioning** (`MAJOR.MINOR.PATCH`) in `plugin.json`:

```json
{
  "name": "my-plugin",
  "version": "2.1.0"
}
```

| Part    | When to bump                               |
| :------ | :----------------------------------------- |
| MAJOR   | Breaking changes (incompatible API change) |
| MINOR   | New features (backward-compatible)         |
| PATCH   | Bug fixes (backward-compatible)            |

Start at `1.0.0` for first stable release. Use pre-release labels for testing: `2.0.0-beta.1`.

**Critical:** Claude Code uses the version to detect whether to update cached plugins. Changing code without bumping the version means existing users will not receive the change. If the plugin is in a marketplace directory, version can also be managed through `marketplace.json` — omit it from `plugin.json` in that case.

Document changes in a `CHANGELOG.md` inside the plugin directory.

## L2: Sharing Checklist

Before sharing with others:

1. Add a `README.md` with installation and usage instructions.
2. Bump `version` in `plugin.json`.
3. Verify all paths use `${CLAUDE_PLUGIN_ROOT}` (no hardcoded absolute paths).
4. Test with team members before wider distribution.
5. For marketplace: create or use a marketplace.json entry. See plugin-marketplaces docs.

Official marketplace submission forms:
- Claude.ai: `claude.ai/settings/plugins/submit`
- Console: `platform.claude.com/plugins/submit`

## L2: Migration — Standalone to Plugin

If you already have skills or hooks in `.claude/`, converting to a plugin enables sharing.

**Step 1 — Create plugin structure:**

```bash
mkdir -p my-plugin/.claude-plugin
```

`my-plugin/.claude-plugin/plugin.json`:
```json
{
  "name": "my-plugin",
  "description": "Migrated from standalone configuration",
  "version": "1.0.0"
}
```

**Step 2 — Copy existing files:**

```bash
cp -r .claude/commands my-plugin/
cp -r .claude/agents my-plugin/     # if any
cp -r .claude/skills my-plugin/     # if any
```

**Step 3 — Migrate hooks.** If hooks were in `.claude/settings.json` or `settings.local.json`, extract the `hooks` object into `my-plugin/hooks/hooks.json`. Format is identical. Add `jq` for stdin parsing:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [{ "type": "command", "command": "jq -r '.tool_input.file_path' | xargs npm run lint:fix" }]
      }
    ]
  }
}
```

**Step 4 — Test:**

```bash
claude --plugin-dir ./my-plugin
```

Verify commands run, agents appear in `/agents`, hooks trigger. Once confirmed, remove originals from `.claude/` to avoid duplicates. Plugin takes precedence when loaded.

**What changes after migration:**

| Standalone                   | Plugin                              |
| :--------------------------- | :---------------------------------- |
| Available in one project only | Shared via marketplaces             |
| Files in `.claude/commands/` | Files in `plugin-name/commands/`    |
| Hooks in `settings.json`     | Hooks in `hooks/hooks.json`         |
| Manual copy to share         | Install with `/plugin install`      |

## L2: Why Not (Tradeoffs)

- Plugin skill names gain a namespace prefix (`/my-plugin:deploy` vs `/deploy`) — this breaks muscle memory if you're used to short standalone names.
- Path traversal to shared utilities (`../shared/`) breaks after caching — use symlinks or bundle everything inside the plugin directory.
- Marketplace distribution requires a marketplace.json infrastructure — not free/immediate for community plugins.

## Sources

- https://code.claude.com/docs/en/plugins (lines 22285–22392)
- https://code.claude.com/docs/en/plugins-reference (lines 23206–23248)

## Links

- [[overview]] — plugin vs standalone decision
- [[manifest-reference]] — version field and userConfig
- [[cli-reference]] — install, uninstall, update commands with scope flags
- [[developing-plugins]] — complete component development guide
