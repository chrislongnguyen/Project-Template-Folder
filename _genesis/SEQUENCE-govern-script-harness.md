---
version: "2.0"
status: Draft
last_updated: 2026-04-04
owner: Long Nguyen
workstream: GOVERN
iteration: I2
type: ues-deliverable
work_stream: 0-govern
stage: sequence
sub_system:
---
# SEQUENCE.md — GOVERN: Script-First Harness, Ripple Enforcement & Status Governance

> DSBV Phase 2 artifact. Task ordering derived from DESIGN.md artifact inventory.
> Dependency chain: D0 → D1 → D2 → D3 → D4 → D5

---

## Dependency Graph

```
D0 (hook wiring)     ──→ no deps (existing hooks, just fix+wire)
D1 (foundations)      ──→ no deps (new utility scripts)
D2 (enforcement)      ──→ D1 (uses backlink-map.sh, frontmatter-extract.sh)
D3 (hook wiring new)  ──→ D0 + D2 (wires D0 hooks + D2 scripts into settings.json)
D4 (docs/EP)          ──→ D3 (documents what was built, references hook bugs)
D5 (skills)           ──→ D2 (vault-capture uses frontmatter patterns from D1)

Parallelizable: D0 ∥ D1 (no dependency between them)
```

---

## Task Sequence

### Phase 1: D0 + D1 in parallel (no dependencies between them)

#### T1: Fix session-reconstruct.sh (A0a)
| Field | Value |
|-------|-------|
| Artifact | A0a |
| Size | S (~15 min) |
| Input | `.claude/hooks/session-reconstruct.sh`, `.claude/hooks/lib/config.sh` |
| Action | Add `source` of config.sh, add dedup guard, verify graceful exit when no vault |
| ACs | AC-0a, AC-0b, AC-0c |
| Verify | `bash -n .claude/hooks/session-reconstruct.sh` passes; grep confirms `config.sh` source + dedup guard |

#### T2: Wire all 4 memory-vault hooks (A0b)
| Field | Value |
|-------|-------|
| Artifact | A0b |
| Size | S (~15 min) |
| Input | `.claude/settings.json`, 4 hook scripts |
| Action | Add SessionStart (session-reconstruct), PostToolUse Write\|Edit (state-saver), PreToolUse (strategic-compact), Stop (session-summary) to settings.json |
| ACs | AC-0d through AC-0k |
| Verify | `python3 -c "import json; json.load(open('.claude/settings.json'))"` passes; all 4 hooks listed in output |
| Depends on | T1 (session-reconstruct must be fixed before wiring) |

#### T3: backlink-map.sh (A1)
| Field | Value |
|-------|-------|
| Artifact | A1 |
| Size | M (~30 min) |
| Input | Repo with 276 wikilinked files |
| Action | Write script: grep all `[[...]]` patterns, output TSV of source→target, handle aliases and paths |
| ACs | AC-1, AC-2, AC-3 |
| Verify | Run on repo; output is valid TSV; `wc -l` > 200 (276 linked files); completes in <2s |

#### T4: frontmatter-extract.sh (A2)
| Field | Value |
|-------|-------|
| Artifact | A2 |
| Size | S (~20 min) |
| Input | Any .md file with YAML frontmatter |
| Action | Write script: extract field value from frontmatter given file path + field name |
| ACs | AC-4, AC-5, AC-6 |
| Verify | `./scripts/frontmatter-extract.sh CLAUDE.md version` outputs a version string; exit 1 on missing field |

**Commit checkpoint:** `chore(govern): D0 hook wiring + D1 foundation scripts`

---

### Phase 2: D2 (depends on D1)

#### T5: ripple-check.sh (A3)
| Field | Value |
|-------|-------|
| Artifact | A3 |
| Size | M (~30 min) |
| Input | backlink-map.sh (T3), any .md filename |
| Action | Write script: given filename, grep depth-1 backlinks, then depth-2 for each, output structured list |
| ACs | AC-7, AC-8, AC-9, AC-10 |
| Verify | `./scripts/ripple-check.sh CHARTER.md` outputs ≥5 depth-1 files; structured output parseable by `cut -d: -f1` |

#### T6: link-validator.sh (A4)
| Field | Value |
|-------|-------|
| Artifact | A4 |
| Size | S (~20 min) |
| Input | backlink-map.sh (T3), repo files |
| Action | Write script: for each `[[target]]` in specified files, check target exists. Report broken links. |
| ACs | AC-11, AC-12 |
| Verify | Create a temp broken link `[[NONEXISTENT]]` in a test file; script reports it; exit 1 |

#### T7: orphan-detect.sh (A5)
| Field | Value |
|-------|-------|
| Artifact | A5 |
| Size | S (~15 min) |
| Input | backlink-map.sh (T3) |
| Action | Write script: invert backlink-map to find files with zero inbound links, exclude README/CHANGELOG/index |
| ACs | AC-13, AC-14 |
| Verify | Output includes at least 1 known orphan file; README.md is NOT in output |

#### T8: rename-ripple.sh (A6)
| Field | Value |
|-------|-------|
| Artifact | A6 |
| Size | S (~20 min) |
| Input | Repo files |
| Action | Write script: given old-name + new-name, grep for `[[old-name]]`, report or auto-replace with --apply |
| ACs | AC-15, AC-16, AC-17 |
| Verify | Dry run: `./scripts/rename-ripple.sh Minh-Tran Long-Nguyen` finds 0 (already replaced); test with fake name |

#### T9: registry-sync-check.sh (A7)
| Field | Value |
|-------|-------|
| Artifact | A7 |
| Size | S (~20 min) |
| Input | frontmatter-extract.sh (T4), VERSION_REGISTRY.md |
| Action | Write script: for each staged .md, extract version field, compare to registry row |
| ACs | AC-18, AC-19, AC-20 |
| Verify | Stage a file with mismatched version; script reports mismatch; exit 1 |

#### T10: status-guard.sh (A8)
| Field | Value |
|-------|-------|
| Artifact | A8 |
| Size | S (~15 min) |
| Input | Staged git diffs |
| Action | Write script: scan staged diffs for `+status: Approved` or `+status: "Approved"`, block if found |
| ACs | AC-21, AC-22, AC-23 |
| Verify | Stage a diff with `status: Approved`; script exits 2; with `FORCE_APPROVE=1` exits 0 |

**Commit checkpoint:** `feat(govern): D2 enforcement scripts — ripple, links, orphans, rename, registry, status`

---

### Phase 3: D3 (depends on D0 + D2)

#### T11: PostToolUse hook wiring for ripple-check (A9)
| Field | Value |
|-------|-------|
| Artifact | A9 |
| Size | S (~10 min) |
| Input | settings.json, ripple-check.sh |
| Action | Add PostToolUse matcher for `Edit|Write` that runs ripple-check.sh on .md files |
| ACs | AC-24, AC-25, AC-26 |
| Verify | JSON valid; matcher targets Edit\|Write; timeout ≤5s |

#### T12: Pre-commit chain wiring (A10)
| Field | Value |
|-------|-------|
| Artifact | A10 |
| Size | S (~15 min) |
| Input | settings.json, D2 scripts |
| Action | Add link-validator + registry-sync-check + status-guard + changelog-check to `Bash(git commit *)` matcher, alongside existing dsbv-gate + skill-validator |
| ACs | AC-27, AC-28, AC-29 |
| Verify | JSON valid; existing hooks preserved; count hooks in `Bash(git commit *)` = 6 total |

#### T13: verify-deliverables.sh extension (A11)
| Field | Value |
|-------|-------|
| Artifact | A11 |
| Size | S (~15 min) |
| Input | verify-deliverables.sh, context packaging markers |
| Action | Extend SubagentStop hook to also check `## 1. EO` and `## 5. VERIFY` in sub-agent output. Add header comment documenting #40580 limitation |
| ACs | AC-30, AC-31, AC-32 |
| Verify | Existing AC-pattern checks still work; new markers checked in sub-agent output |

**Commit checkpoint:** `feat(govern): D3 hook wiring — PostToolUse ripple, pre-commit chain, SubagentStop extension`

---

### Phase 4: D4 (depends on D3 — documents what was built)

#### T14: EP-14 Script-First Delegation (A12)
| Field | Value |
|-------|-------|
| Artifact | A12 |
| Size | M (~25 min) |
| Input | EP registry (EP-01–EP-13), session research on script-vs-agent patterns |
| Action | Append EP-14 to registry following existing format. Update Part 1 table, Part 4 APEI cross-ref, Part 5 diagnostic |
| ACs | AC-33, AC-34, AC-35 |
| Verify | EP-14 appears in Part 1 table; Part 4 has GOVERN column entry; Part 5 has diagnostic row |

#### T15: Hook reliability audit (A13)
| Field | Value |
|-------|-------|
| Artifact | A13 |
| Size | M (~25 min) |
| Input | 3 explorer agent reports (hooks docs, community patterns, scripts best practices), GitHub issue numbers |
| Action | Create reference doc listing all known hook bugs, LTC mitigations, and CAN/CANNOT matrix |
| ACs | AC-36, AC-37, AC-38 |
| Verify | File exists; contains ≥5 GitHub issue references; has explicit CAN/CANNOT section |

**Commit checkpoint:** `docs(govern): D4 EP-14 Script-First Delegation + hook reliability audit`

---

### Phase 5: D5 (depends on D2 for patterns)

#### T16: /vault-capture skill (A14)
| Field | Value |
|-------|-------|
| Artifact | A14 |
| Size | M (~25 min) |
| Input | inbox/ directory, frontmatter patterns from D1 |
| Action | Write SKILL.md for `/vault-capture` — captures conversation content to inbox/ or workstream with frontmatter |
| ACs | AC-39, AC-40, AC-41 |
| Verify | SKILL.md exists; contains trigger pattern; documents `--to learn` flag; follows EOP governance format |

#### T17: Obsidian skill routing update (A15)
| Field | Value |
|-------|-------|
| Artifact | A15 |
| Size | S (~15 min) |
| Input | Current obsidian SKILL.md v1.3 |
| Action | Demote search:context from primary; position backlinks/outgoing-links/orphans as unique value; update 3-tool routing table |
| ACs | AC-42, AC-43, AC-44 |
| Verify | Grep SKILL.md for routing table; search is not "Priority 1"; backlinks are listed as unique |

**Commit checkpoint:** `feat(skills): D5 /vault-capture + obsidian routing update`

---

## Summary

| Phase | Tasks | Parallel? | Depends on | Est. time | Commit |
|-------|-------|-----------|------------|-----------|--------|
| 1 | T1-T4 (D0+D1) | T1→T2 serial; T3,T4 parallel with T1-T2 | None | ~45 min | `chore(govern): D0+D1` |
| 2 | T5-T10 (D2) | All parallelizable (independent scripts) | D1 (T3,T4) | ~60 min | `feat(govern): D2` |
| 3 | T11-T13 (D3) | T11,T12,T13 parallelizable | D0+D2 | ~30 min | `feat(govern): D3` |
| 4 | T14-T15 (D4) | T14,T15 parallelizable | D3 | ~40 min | `docs(govern): D4` |
| 5 | T16-T17 (D5) | T16,T17 parallelizable | D2 | ~30 min | `feat(skills): D5` |

**Total: 17 tasks, 5 commits, ~3.5 hours human-equivalent, ~20K tokens agent cost**

---

## Links

- [[DESIGN-govern-script-harness]]
- [[VALIDATE]]
- [[VERSION_REGISTRY]]
- [[agent-dispatch]]
- [[dsbv]]
- [[git-conventions]]
