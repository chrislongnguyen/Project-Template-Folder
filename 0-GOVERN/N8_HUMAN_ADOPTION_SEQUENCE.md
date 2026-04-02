---
version: "1.0"
status: Draft
last_updated: 2026-04-02
type: govern
work_stream: GOVERN
stage: sequence
sub_system: human-adoption
---

# SEQUENCE — N8 Human Adoption Training Package (Cycle 2)

Source: `0-GOVERN/N8_HUMAN_ADOPTION_DESIGN.md` v1.0

---

## Dependency Graph

```
A1 (cmux quickstart)          ← no deps
A2 (session lifecycle)        ← no deps
A3 (tool routing cheatsheet)  ← no deps
A4 (navigator HTML)           ← A1 + A2 + A3 must exist (navigator references them)
```

A1, A2, A3 are independent — build in order but no blocking dependency between them.
A4 is last — verify A1/A2/A3 exist before updating navigator.

---

## Task Sequence

### T1 — A1: cmux Quickstart Guide
**Size:** Small (~2 hours human equivalent)
**Path:** `_genesis/sops/cmux-quickstart.md`

Sub-tasks:
1. Create file with frontmatter (version 1.0, status Draft, last_updated 2026-04-02, + 4 Vinh fields)
2. Write: What is cmux (1 paragraph), why it matters for multi-agent (named workspaces)
3. Write: Install section (brew install, verify)
4. Write: 3-command quickstart (create workspace, switch, list)
5. Write: Orchestrator pattern — read-screen + send-keys example
6. Write: LTC workspace naming table (workspace → agent type)

ACs: AC-01 through AC-05
Verify: `bash -c 'grep -c "type:\|work_stream:\|stage:\|sub_system:" _genesis/sops/cmux-quickstart.md'` ≥ 4

---

### T2 — A2: Session Lifecycle Cheatsheet
**Size:** Small (~1 hour human equivalent)
**Path:** `_genesis/sops/session-lifecycle-cheatsheet.md`

Sub-tasks:
1. Create file with frontmatter
2. Write: Canonical workflow (3-step: /compress → /clear → /resume) as numbered sequence
3. Write: Per-command section — compress (what, when, token cost), clear (what, when), resume (what, when, 2-pass)
4. Write: Deprecated commands table (session-start, session-end → replacement)
5. Write: Token cost comparison table (old vs new)

ACs: AC-06 through AC-10
Verify: `grep -i "compress\|clear\|resume" _genesis/sops/session-lifecycle-cheatsheet.md | wc -l` ≥ 3

---

### T3 — A3: Tool Routing Cheatsheet
**Size:** Small (~1 hour human equivalent)
**Path:** `_genesis/sops/tool-routing-cheatsheet.md`

Sub-tasks:
1. Create file with frontmatter
2. Write: 3-tool hierarchy table (QMD → Obsidian → Grep, with when-to-use for each)
3. Write: Decision tree — 5+ scenario rows mapping task type → tool
4. Write: Mandatory .claude/ sweep callout (bold/highlighted)
5. Write: Obsidian fallback rule (not running → grep silently)

ACs: AC-11 through AC-15
Verify: `grep -c "|" _genesis/sops/tool-routing-cheatsheet.md` ≥ 5

---

### T4 — A4: Navigator HTML Update
**Size:** Small (~1 hour human equivalent)
**Path:** `_genesis/tools/alpei-navigator.html`
**Constraint:** Only update `name`/`desc` fields. Do NOT change `id` or `connects`.

Sub-tasks:
1. Read current navigator HTML to locate session-start, session-end, compress, resume skill nodes (lines ~343-346)
2. Update session-start desc: prepend `[DEPRECATED] ` to name or desc
3. Update session-end desc: prepend `[DEPRECATED] ` to name or desc
4. Update compress desc: "Saves session context — writes rich frontmatter (goal, state, open_items) + auto-updates MEMORY.md Briefing Card"
5. Update resume desc: "2-pass recall from Memory Vault (frontmatter scan ~500 tokens + body ~2K). Total ≤5K tokens."
6. Add obsidian skill node (if absent): `{id:"obsidian",name:"obsidian",desc:"Knowledge graph traversal — backlinks, orphans, search:context. Fallback to Grep when Obsidian not running.",role:"EOP",cells:["E-B","I-B"],cat:"Knowledge",connects:["qmd","grep"]}`

ACs: AC-16 through AC-20
Verify: `grep -i "deprecated" _genesis/tools/alpei-navigator.html | grep "session-start"` exits 0

---

## Build Order Summary

| Step | Task | Artifact | ACs | Size |
|------|------|----------|-----|------|
| 1 | T1 | A1 cmux quickstart | AC-01..05 | Small |
| 2 | T2 | A2 session cheatsheet | AC-06..10 | Small |
| 3 | T3 | A3 tool routing cheatsheet | AC-11..15 | Small |
| 4 | T4 | A4 navigator HTML update | AC-16..20 | Small |

Total estimated build time: ~5 hours human equivalent (single-agent: ~20 min)

---

## Checkpoint Protocol

After each task:
1. Self-verify ACs for that task (binary checks)
2. Commit with message: `feat(govern): N8 cycle2 — [artifact name]`
3. Proceed to next task only if ACs pass

If any AC fails after 1 retry: stop, report to user.

## Links

- [[N8_HUMAN_ADOPTION_DESIGN]]
- [[SESSION_LIFECYCLE_DESIGN]]
- [[alpei-navigator]]
- [[tool-routing]]
