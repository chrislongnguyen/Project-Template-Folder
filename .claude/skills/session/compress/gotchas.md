# /compress — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Vault path not resolved

**What happens:** Agent writes to a hardcoded or guessed path instead of resolving via config.sh. Session file ends up in wrong location or fails to write.

**How to detect:** Check whether `$MEMORY_VAULT_PATH` was sourced from `~/.config/memory-vault/config.sh` before the Write tool was called. If the path doesn't start with the vault root, it's wrong.

**Fix:** Always run `source ~/.config/memory-vault/config.sh` and verify `$MEMORY_VAULT_PATH` is set before writing. If the variable is empty, tell the user to run `/setup`.

---

## 2. Topic slug too vague or too long

**What happens:** Agent uses "session" or "work" as the topic slug, making files impossible to find later. Or uses a 10-word slug that breaks file naming conventions.

**How to detect:** Check the `{topic}` portion of the filename. If it's a single generic word or more than 4 hyphenated words, it's wrong.

**Fix:** Use 2-4 word kebab-case describing the actual focus of the session. Examples: `eop-governance-retrofit`, `memory-vault-setup`, `dsbv-align-review`. Never use generic words like "session", "work", "stuff", "updates".

---

## 3. Missing or wrong frontmatter fields

**What happens:** Agent skips `outcome` or `importance`, or uses invalid values. Downstream tools (qmd, obsidian) fail to index the file correctly.

**How to detect:** After writing the file, verify all 6 frontmatter fields are present: `type`, `date`, `project`, `topics`, `outcome`, `importance`. Check that `outcome` is one of: shipped | progressed | blocked | explored. Check that `importance` is 1-5.

**Fix:** Never skip fields. Use the template at `templates/session-summary.md` as the starting point — it has all required fields pre-populated with placeholder values.

## Links

- [[SKILL]]
- [[project]]
- [[session-summary]]
