---
version: "2.0"
status: draft
last_updated: 2026-04-06
topic: developer-tooling
source: "captured/2026-04-06_dotfiles-repo-explanation.md"
review: true
review_interval: 14
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
  - so_what_benefit
  - now_what_next
---
# Dotfiles Repo

> A git repository that tracks your personal machine configuration files via symlinks — giving hidden config files version history, backup, and portability.

## L1 — Knowledge

### So What? (Relevance)
Config files like `~/.claude/`, `~/.zshrc`, and `~/.gitconfig` are typically untracked — no backup, no history, no rollback. A dotfiles repo makes them git-managed without changing how any tool reads them. For a Claude Code harness with 7 custom hooks, 14 rule files, and engineered skills, this means every change is versioned and any machine can be fully configured in under 2 minutes.

### What Is It?
A dotfiles repo is a standard git repository (typically `~/.dotfiles/`) where your config files actually live. Symlinks in your home directory point into the repo, so tools read `~/.claude/` normally while git tracks `~/.dotfiles/claude/`.

```
~/
├── .dotfiles/           ← git repo
│   ├── claude/          ← actual files live here
│   │   ├── CLAUDE.md
│   │   ├── hooks/
│   │   ├── rules/
│   │   └── skills/
│   └── install.sh       ← creates all symlinks
│
└── .claude/             ← symlink → .dotfiles/claude/
```

### What Else?
- **chezmoi** — managed tool: handles templating, secrets injection, multi-machine config variance
- **dotbot** — declarative YAML config for symlink management, popular in teams
- **GNU Stow** — classic Unix tool, directory-based symlink management
- **Direct git in `~/.claude/`** — simplest, no symlinks, but only tracks one dir
- **Shell script bootstrap** — manual `ln -s` in an `install.sh`, most transparent

### How Does It Work?
```bash
# 1. Create repo and move files into it
mkdir ~/.dotfiles
cp -R ~/.claude ~/.dotfiles/claude
rm -rf ~/.claude

# 2. Create symlink — tool reads ~/.claude/ as normal
ln -s ~/.dotfiles/claude ~/.claude

# 3. Init git
cd ~/.dotfiles && git init
git add claude/
git commit -m "chore: init global claude harness"
git remote add origin git@github.com:you/dotfiles.git
git push -u origin main
```

New machine setup: `git clone → run install.sh → done`. Every hook fix committed and pushed = permanent.

## L2 — Understanding

### Why Does It Work?
Symlinks are transparent to all applications — the OS resolves `~/.claude/` to `~/.dotfiles/claude/` before any file I/O happens. Claude Code reads its hooks, rules, and skills exactly as if they lived at `~/.claude/`. Git sees only `~/.dotfiles/` and tracks everything there with full history.

The symlink mechanic: the inode the symlink points to is the real file. Editing `~/.claude/hooks/scripts/memory-recall.sh` edits `~/.dotfiles/claude/hooks/scripts/memory-recall.sh` — which is tracked by git. No extra steps needed.

### Why Not?
- **Secrets risk**: `settings.json` may contain MCP server API keys. A `git push` to a public or misconfigured private repo = credential leak. Must audit before first commit.
- **Scope creep**: once tracking starts, the temptation is to track more — leading to a bloated repo that's hard to maintain. Strict `.gitignore` is essential.
- **Ephemeral dir pollution**: `~/.claude/projects/`, `cache/`, `sessions/` are high-churn ephemeral directories. If accidentally tracked, they create massive, noisy commits.
- **Symlink edge cases**: some tools don't follow symlinks for config resolution (rare, but possible). Test before committing.

## L3 — Wisdom

### So What? (Benefit)
For Claude Code specifically: every hook script change (strategic-compact v1.2, memory-recall v1.1), every rule file edit, every skill update becomes a versioned commit. `git log` becomes the history of your AI harness evolution. Team members can clone and instantly have an identical harness.

New machine setup goes from "rebuild from memory over 2 days" to "git clone + ./install.sh + 5 minutes".

### Now What? (Setup)

**Required `.gitignore` before first commit:**
```gitignore
projects/
cache/
debug/
telemetry/
image-cache/
paste-cache/
file-history/
session-env/
sessions/
todos/
plans/
tasks/
shell-snapshots/
research_output/
downloads/
ide/
*.log
settings.json
.credentials*
```

**Check settings.json for secrets first:**
```bash
cat ~/.claude/settings.json | grep -iE "key|token|secret|password|credential"
```

If clean: add `settings.json` to tracked files. If has secrets: keep in `.gitignore`, document config structure separately.

**Push to private repo only** — hooks/rules contain internal workflow logic.

## Sources
- [[claude-code-dot-claude-directory]]

## Links
- [[hooks-lifecycle]]
- [[claude-md-files]]
- [[session-management]]
- [[persistence-and-enforcement-synthesis]]
