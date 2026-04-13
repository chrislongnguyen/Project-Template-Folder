---
version: "1.0"
status: draft
last_updated: 2026-04-02
type: sop
stage: build
sub_system: human-adoption
---

# cmux Quickstart Guide

## What is cmux

tmux (terminal multiplexer) lets you run multiple named terminal workspaces in one window. In the LTC multi-agent setup, each agent gets its own named workspace — so instead of "which tab was the builder in?", you type `tmux attach -t builder`.

## Install

```bash
brew install tmux   # macOS
tmux -V             # verify: tmux 3.x
```

## 3-Command Quickstart

```bash
tmux new -s orchestrator    # create named workspace "orchestrator"
tmux new -s builder         # create second named workspace "builder"
tmux ls                     # list all active workspaces
tmux attach -t orchestrator # switch back to a workspace by name
```

## Orchestrator Pattern

The orchestrator workspace reads other workspaces and sends commands to them — enabling coordinated multi-agent work from a single control pane.

```bash
# Read what the builder workspace is currently showing
tmux capture-pane -t builder -p

# Send a command to the builder workspace (executes it there)
tmux send-keys -t builder "ls -la" Enter

# Send a command without executing (omit Enter)
tmux send-keys -t builder "git status"
```

## LTC Workspace Naming Convention

| Workspace | Agent | Purpose |
|-----------|-------|---------|
| orchestrator | Lead agent (Sonnet) | Planning, dispatch, coordination |
| builder | ltc-builder (Sonnet) | Artifact production, code, docs |
| reviewer | ltc-reviewer (Opus) | Validation against DESIGN.md criteria |
| explorer | ltc-explorer (Haiku) | Research, discovery, read-only exploration |

## Quick Reference

| Action | Command |
|--------|---------|
| Create workspace | `tmux new -s <name>` |
| Switch to workspace | `tmux attach -t <name>` |
| List all workspaces | `tmux ls` |
| Detach from workspace | `Ctrl-b d` |
| Kill a workspace | `tmux kill-session -t <name>` |
| Read workspace screen | `tmux capture-pane -t <name> -p` |
| Send command to workspace | `tmux send-keys -t <name> "<cmd>" Enter` |

## Links

- [[DESIGN]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-reviewer]]
