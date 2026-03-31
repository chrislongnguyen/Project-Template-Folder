# /resume — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Tilde not expanding in quoted paths

**What happens:** Agent uses `"~/Library/..."` in a shell command. In zsh, tilde does NOT expand inside double quotes. File is not found.

**How to detect:** Shell returns "No such file or directory" for a path starting with `~/`.

**Fix:** Use `"$HOME/Library/..."` or an absolute path like `/Users/{username}/Library/...`.

---

## 2. Reading wrong repo's sessions

**What happens:** Agent picks the most recent session file without filtering by repo name. Returns context from a different project, causing confusion.

**How to detect:** The session summary references a project name or repo that doesn't match the current working directory.

**Fix:** Always filter session files by current repo name before selecting. Use `grep` on filenames or frontmatter `project` field.

---

## 3. Dumping raw session content instead of synthesizing

**What happens:** Agent reads a session file and pastes its full content. The skill requires a synthesized brief (Last session, What was done, Current state, Next action).

**How to detect:** Output is longer than ~15 lines or contains raw YAML frontmatter / unstructured notes.

**Fix:** Extract key fields from the session file and format into the context brief template defined in SKILL.md Mode 1 step 4.
