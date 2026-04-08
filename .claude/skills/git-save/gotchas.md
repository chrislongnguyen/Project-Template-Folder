# Gotchas — git-save

1. **Staging secrets** — `.env`, `secrets/`, credential files must never be staged. The skill warns but double-check `git status` before committing.

2. **Large changesets** — Over 30 files or 500 lines should be split into multiple commits by (type, scope). Don't batch unrelated changes into one commit.

3. **Version bump amnesia** — Modified workstream `.md` files need version/status/last_updated checks before staging. The skill reminds you but pre-commit hooks are the real safety net.

4. **Amending after hook failure** — If a pre-commit hook rejects a commit, the commit did NOT happen. Create a NEW commit after fixing — do NOT `--amend` (that modifies the previous commit).

## Links

- [[SKILL]]
- [[workstream]]
