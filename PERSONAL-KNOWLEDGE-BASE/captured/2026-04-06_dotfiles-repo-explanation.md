---
date: "2026-04-06"
type: capture
source: conversation
tags: [dotfiles, git, developer-tooling, claude-code]
---

# Dotfiles Repo Explanation

A dotfiles repo is a git repository that stores your personal machine configuration files — the "hidden" files (prefixed with `.`) that configure your tools.

---

## The problem it solves

Your config lives in scattered locations:
```
~/.zshrc          ← shell config
~/.gitconfig      ← git identity + aliases
~/.claude/        ← Claude Code harness
~/.ssh/config     ← SSH shortcuts
~/.vimrc          ← editor
```

No backup. No history. New machine = rebuild from memory. Accidental edit = no rollback.

---

## How a dotfiles repo works

```
~/
├── .dotfiles/          ← the git repo (tracked)
│   ├── claude/
│   │   ├── CLAUDE.md
│   │   ├── hooks/
│   │   ├── rules/
│   │   └── skills/
│   ├── zshrc
│   ├── gitconfig
│   └── install.sh      ← creates symlinks
│
├── .claude/            ← symlink → .dotfiles/claude/
├── .zshrc              ← symlink → .dotfiles/zshrc
└── .gitconfig          ← symlink → .dotfiles/gitconfig
```

`~/.claude/` looks and behaves normally to every tool. But it's actually a symlink pointing into the git repo. Every edit you make is automatically tracked.

---

## The symlink mechanic

```bash
# Instead of editing ~/.claude directly:
ln -s ~/.dotfiles/claude ~/.claude

# Now:
#   Claude Code reads  ~/.claude/        ← works normally
#   You edit           ~/.dotfiles/claude ← git-tracked
#   git sees changes   ~/.dotfiles/       ← one repo, all config
```

One `git push` backs up everything. New machine: `git clone` → run `install.sh` → all symlinks created → fully configured in 2 minutes.

---

## Three common approaches

| Approach | How | Who |
|---|---|---|
| Direct git in `~/.claude/` | `git init ~/.claude`, careful `.gitignore` | Simple, no symlinks |
| Dotfiles repo + symlinks | `~/.dotfiles/claude/` → `~/.claude/` via `ln -s` | Most common in dev community |
| `chezmoi` / `dotbot` | Managed tool handles sync + templating | Teams, multi-machine |

---

## For Long's setup specifically

```
~/.dotfiles/
├── claude/
│   ├── CLAUDE.md
│   ├── keybindings.json
│   ├── hooks/scripts/   ← strategic-compact v1.2, memory-recall v1.1
│   ├── rules/
│   └── skills/
├── gitconfig
├── zshrc
└── install.sh

Remote: github.com/longnguyen/dotfiles  (private repo)
```

Every hook fix, every rule change → committed, pushed, permanent. New machine or team member: clone + run install → identical harness in minutes.

---

## Setup in 4 commands

```bash
mkdir ~/.dotfiles
cp -R ~/.claude ~/.dotfiles/claude
rm -rf ~/.claude
ln -s ~/.dotfiles/claude ~/.claude

cd ~/.dotfiles && git init && git add claude/
git commit -m "chore: init global claude harness"
```

Push to a **private** GitHub repo — hooks/rules are sensitive.

---

## Required `.gitignore` for `~/.claude/`

```gitignore
# Ephemeral — never track
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

# Potentially sensitive — review before tracking
settings.json   # may have MCP server API keys
.credentials*
```

Check settings.json for secrets before first commit:
```bash
cat ~/.claude/settings.json | grep -iE "key|token|secret|password|credential"
```

---

## Context

- `~/.claude/` confirmed NOT a git repo as of 2026-04-06
- strategic-compact.sh v1.2 and memory-recall.sh v1.1 fixes exist only on disk — unversioned
- Action: set up dotfiles repo to protect the global Claude Code harness going forward
