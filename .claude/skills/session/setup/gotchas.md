# /setup — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Overwriting existing config without asking

**What happens:** Agent runs setup and overwrites `~/.config/memory-vault/config.sh` that already points to a different vault path. User loses their vault reference.

**How to detect:** Check if `~/.config/memory-vault/config.sh` exists before writing. If it does, read the current `MEMORY_VAULT_PATH` value.

**Fix:** Always ask the user before overwriting. Show the current path and the new path side by side so they can decide.

---

## 2. Google Drive not mounted

**What happens:** Agent assumes Google Drive is available because it was last session. Drive disconnects happen (network, logout, restart). Always verify the path exists before writing config.

**How to detect:** The `ls -d` scan in Step 2 returns results, but the path is stale (symlink exists, mount does not). Check with `test -d "$path"` after resolving.

**Fix:** After finding Google Drive candidates, verify the path actually exists on disk with `test -d` before offering it to the user. If the path is a dead symlink, fall back to asking for a custom path.

---

## 3. QMD embed on slow connection

**What happens:** Agent runs `qmd embed` without warning about the ~300MB first-time model download. User's session appears hung for minutes with no feedback.

**How to detect:** Check if QMD has already downloaded its embedding model. If `~/.cache/qmd/models/` is empty or missing, this is a first-time run.

**Fix:** Before running `qmd embed`, warn the user: "First-time embedding downloads ~300MB of models. This may take a few minutes on a slow connection." Give them the option to skip and run it later.

## Links

- [[SKILL]]
