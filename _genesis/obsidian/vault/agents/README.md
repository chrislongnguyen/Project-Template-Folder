---
version: "1.0"
status: draft
last_updated: 2026-04-01
zone: govern
subsystem: agent-system
---
# agents/

Agent session logs and outputs.

Each session creates one note: `{agent-name}-{YYYY-MM-DD}-{session-id}.md`.
Contents: task summary, tool calls made, decisions reached, open questions.

This is a V5 whitelisted write path — agents may create notes here.
Notes are accessible via CLI by default (AP4 opt-out model).
Sensitive agent outputs should have `cli-blocked: true` added by the vault owner.

## Links

- [[AP4]]
- [[agent-system]]
- [[task]]