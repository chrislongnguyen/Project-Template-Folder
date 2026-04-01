# Migration Detection

> Extracted from setup SKILL.md. Load when an existing vault is detected.

## Manual Hook Detection

If the user has manual hooks in `~/.claude/settings.json` (legacy setup):
1. Detect by checking for hook commands containing `session-summary.sh`, `state-saver.sh`, `strategic-compact.sh`, or `session-reconstruct.sh` in `~/.claude/settings.json`
2. Warn: "Detected manual hook setup. The plugin provides these hooks automatically. Remove the manual entries from ~/.claude/settings.json to avoid double-firing."
3. List the specific hook entries to remove

## Old Skill Detection

If old skills exist in `~/.claude/skills/` (session-start, compress, resume, session-end):
1. Warn: "Found old skill files in ~/.claude/skills/. Plugin skills will shadow them. Remove old copies to avoid confusion."

## Links

- [[CLAUDE]]
- [[SKILL]]
- [[session-summary]]
