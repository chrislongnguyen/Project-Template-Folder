# Memory Vault — A-Z Install Guide

> **Time:** ~15 minutes
> **Audience:** Any LTC member with Claude Code installed
> **Result:** Claude remembers your work across sessions — automatically

---

## What You're Getting

After this guide, your Claude Code will:

- **Auto-save** a session log every time you close Claude (no action needed)
- **Auto-recall** what you were working on when you start a new session
- **Search** your entire work history with keyword and semantic search
- **Import** old chats from Gemini, Cursor, and claude.ai

Everything is stored locally on your machine (Google Drive optional for sync).

---

## Before You Start — Check These

Open a terminal and run each command. All must pass:

```bash
claude --version     # Must print a version number
node --version       # Must be v18 or higher
git --version        # Must be installed
```

If any fails, install it first:
- Claude Code: `npm install -g @anthropic-ai/claude-code`
- Node.js: https://nodejs.org (download LTS)
- Git: `xcode-select --install` (Mac)

---

## Step 1 — Clone the Template Repo

If you don't already have it:

```bash
cd ~/LTC    # or wherever you keep LTC repos
git clone https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git
```

Note the full path — you'll need it in Step 2. For example:
```
/Users/yourname/LTC/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
```

If you already have the repo, just `git pull` to get the latest.

---

## Step 2 — Register the Plugin Marketplace

This tells Claude Code where to find our plugins.

**Option A — Use the `/plugin` UI (recommended):**

1. Open Claude Code in any project
2. Type `/plugin` and press Enter
3. Go to the **Marketplaces** tab
4. Select "Add marketplace"
5. Enter the full path to the template repo:
   ```
   /Users/yourname/LTC/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
   ```
6. Confirm

**Option B — Edit settings.json directly:**

Open `~/.claude/settings.json` in any text editor. Add the `extraKnownMarketplaces` key at the top level (merge with your existing settings — don't replace the file):

```json
{
  "extraKnownMarketplaces": {
    "ltc-plugins": {
      "source": "directory",
      "path": "/Users/yourname/LTC/OPS_OE.6.4.LTC-PROJECT-TEMPLATE"
    }
  }
}
```

> **Important:** Replace `/Users/yourname/LTC/` with YOUR actual path. To find it:
> ```bash
> cd ~/LTC/OPS_OE.6.4.LTC-PROJECT-TEMPLATE && pwd
> ```
> Copy-paste the output.

---

## Step 3 — Enable the Plugin

**Option A — Use the `/plugin` UI:**

1. Type `/plugin` in Claude Code
2. Go to the **Discover** tab
3. Find `memory-vault` (under ltc-plugins)
4. Enable it (toggle or press Space)

**Option B — Edit settings.json:**

Add to the `enabledPlugins` section of `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "memory-vault@ltc-plugins": true
  }
}
```

**Verify it loaded:**

Run `/reload-plugins` in Claude Code. You should see output like:
```
Reloaded: N plugins · N skills · ...
```

Then run `/plugin` and check the **Installed** tab — `memory-vault` should appear without errors.

---

## Step 4 — Run First-Time Setup

In any Claude Code session, type:

```
/setup
```

The setup wizard will:

1. **Check prerequisites** — verifies node, git, claude are installed
2. **Install QMD** — if not already installed (`npm install -g @tobilu/qmd`)
3. **Find or create your vault folder** — it looks for Google Drive first, then offers a local folder
4. **Create folder structure** — 5 subdirectories for sessions, conversations, state, daily, decisions
5. **Write config** — saves your vault path to `~/.config/memory-vault/config.sh`
6. **Configure QMD** — creates 4 search collections pointing to your vault
7. **Verify** — checks everything works

### What to expect

The setup will ask you a few questions:

```
Found Google Drive at /Users/yourname/Library/CloudStorage/GoogleDrive-.../My Drive
Create Memory Vault here? (Y/n)
```

Say **Y** if you want Google Drive sync (recommended). Say **N** to use a local folder instead.

If QMD isn't installed, it will ask:
```
QMD is not installed. Install it now? (Y/n)
```

Say **Y**. First-time QMD embedding downloads ~300MB of models — this takes 2-5 minutes. Subsequent runs are fast (<5 sec).

### Success looks like

```
Memory Vault setup complete!

  Vault: /Users/yourname/Library/CloudStorage/GoogleDrive-.../My Drive/Long-Memory-Vault
  Collections: sessions, conversations, daily, decisions
  Config: ~/.config/memory-vault/config.sh

  Next: Start a new Claude Code session. Hooks will auto-fire.
  Try: /session-start to verify recall works.
```

---

## Step 5 — Verify It Works

### Test 1: Check hooks are active

Type `/hooks` in Claude Code (or check the hooks UI). You should see 4 hooks:

| Hook | Event | Source |
|------|-------|--------|
| session-reconstruct | SessionStart | memory-vault plugin |
| strategic-compact | PreToolUse | memory-vault plugin |
| state-saver | PostToolUse | memory-vault plugin |
| session-summary | Stop | memory-vault plugin |

### Test 2: Check skills are available

These slash commands should work:
- `/session-start` — brief recall
- `/compress` — save session context
- `/resume` — load previous session
- `/session-end` — full close protocol
- `/setup` — re-run setup (idempotent)

### Test 3: End-to-end test

1. Open Claude Code in any git repo
2. Make a small change (edit a file, run a command)
3. Close Claude (Ctrl+C or type "exit")
4. Check your vault:
   ```bash
   ls -lt "$MEMORY_VAULT_PATH/07-Claude/sessions/" | head -3
   ```
   You should see a new `auto-YYYY-MM-DD-*.md` file
5. Open Claude Code again — the SessionStart hook should inject git state automatically

### Test 4: Search your vault

```bash
qmd query -c sessions "your recent work topic" -n 3
```

Should return matching session files.

---

## Step 6 (Optional) — Import Old Conversations

If you have chat history from other tools, import them into your vault so QMD can search them too.

### From Gemini

1. Go to https://takeout.google.com
2. Click "Deselect all"
3. Scroll down, find and select **"Gemini Apps Activity"** (NOT "Gemini")
4. Click "Next step" → choose .zip format → "Create export"
5. Wait for the email with download link (can take a few hours)
6. Download and extract the ZIP
7. Run:
   ```bash
   # First, find your vault path
   source ~/.config/memory-vault/config.sh

   # Dry run to preview
   python3 ~/LTC/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/plugins/memory-vault/scripts/import-gemini.py \
     ~/Downloads/takeout-folder/ \
     "$MEMORY_VAULT_PATH/07-Claude/conversations/" \
     --dry-run

   # If it looks good, run for real
   python3 ~/LTC/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/plugins/memory-vault/scripts/import-gemini.py \
     ~/Downloads/takeout-folder/ \
     "$MEMORY_VAULT_PATH/07-Claude/conversations/"
   ```

### From Cursor

Reads directly from Cursor's local database — no export needed:

```bash
source ~/.config/memory-vault/config.sh

# Dry run
python3 ~/LTC/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/plugins/memory-vault/scripts/import-cursor.py \
  "$MEMORY_VAULT_PATH/07-Claude/conversations/" \
  --dry-run

# Import
python3 ~/LTC/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/plugins/memory-vault/scripts/import-cursor.py \
  "$MEMORY_VAULT_PATH/07-Claude/conversations/"
```

> **Note:** Close Cursor first — the database may be locked while Cursor is running.

### From Claude web (claude.ai)

1. Go to https://claude.ai → Settings → Account → Export Data
2. Wait for the email with download link
3. Download the `.dms` file
4. Run:
   ```bash
   source ~/.config/memory-vault/config.sh

   python3 ~/LTC/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/plugins/memory-vault/scripts/import-claude-web.py \
     ~/Downloads/your-export.dms \
     "$MEMORY_VAULT_PATH/07-Claude/conversations/"
   ```

### After importing: rebuild the search index

```bash
qmd update && qmd embed
```

This makes all imported conversations searchable.

---

## Daily Workflow

Once installed, Memory Vault works mostly in the background. Here's what happens and what you do:

### Automatic (you do nothing)

| When | What happens |
|------|-------------|
| You open Claude Code | Git state is injected into context (branch, recent commits, working tree) |
| You edit files | Git state snapshot saved to vault (crash recovery) |
| Every ~200 tool calls | Claude nudges you to save context before it gets too long |
| You close Claude | Session summary auto-saved to vault, QMD index refreshed |

### Manual (you choose when)

| Command | When to use it |
|---------|---------------|
| `/session-start` | Beginning of a work session — get a 10-line recap of yesterday |
| `/compress` | Conversation getting long — save context before starting fresh |
| `/resume` | Pick up where you left off on a specific topic |
| `/session-end` | End of day — full close: sync Notion, commit, save to vault |

### Recommended session pattern

```
1. Open Claude Code in your project
2. Type: "Start session"          ← triggers /session-start
3. Work normally
4. When done: "Session end"       ← triggers /session-end
```

That's it. Everything else is automatic.

---

## Troubleshooting

### "Plugin failed to load"

```bash
# Clear plugin cache and reload
rm -rf ~/.claude/plugins/cache
# Then in Claude Code:
/reload-plugins
```

### "qmd: command not found"

```bash
# Find where npm installs global packages
npm config get prefix
# Add that path's /bin to your shell
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### "Vault path not found" (hooks silently skip)

```bash
# Check if config exists
cat ~/.config/memory-vault/config.sh

# If missing, re-run setup
# In Claude Code: /setup

# If config exists but path is wrong, check Google Drive folder name
ls ~/Library/CloudStorage/
# The folder name includes your email, e.g.: GoogleDrive-you@company.com
```

### "No session files appearing after I close Claude"

1. Are you in a git repo? Session-summary only fires inside git repos
2. Did you make any changes? It skips if there are no changes or recent commits
3. Check hook errors: `/hooks` in Claude Code, look for error indicators

### "QMD search returns nothing"

```bash
# Rebuild the index
qmd update && qmd embed

# Check collections exist
qmd collection list
# Should show: sessions, conversations, daily, decisions

# Check document count
qmd status
# Should show totalDocuments > 0, hasVectorIndex: true
```

### "`qmd embed` takes forever"

First run downloads ~300MB of embedding models. This is one-time. After that:
- `qmd update` takes <1 second
- `qmd embed` takes <5 seconds for incremental updates

### "Double hooks firing" (if you had manual setup before)

Check `~/.claude/settings.json` for old manual hook entries. Remove any hooks that reference:
- `session-summary.sh`
- `state-saver.sh`
- `strategic-compact.sh`
- `session-reconstruct.sh`

The plugin provides these automatically. Having both causes double-firing.

---

## How It Works (for the curious)

```
YOU WORK IN CLAUDE CODE
         │
         ├── SessionStart ─► git state injected into context
         │                    (branch, commits, working tree)
         │
         ├── You edit files ─► snapshot saved to vault
         │                     (crash recovery point)
         │
         ├── ~200 tool calls ─► "Context getting full, run /compress"
         │
         └── You close Claude ─► session log saved to vault
                                  QMD index refreshed
                                        │
                                        ▼
                              YOUR VAULT (Google Drive)
                              ├── sessions/      ← what you did
                              ├── conversations/  ← full chat exports
                              ├── state/          ← git snapshots
                              └── decisions/      ← key decisions
                                        │
                                        ▼
                              QMD (local search engine)
                              ├── keyword search (fast, exact)
                              ├── semantic search (meaning-based)
                              └── /session-start reads from here
```

Your vault lives on your machine. Nothing is sent to external servers. QMD runs locally. Google Drive sync is optional (for backup / multi-device).

---

## Quick Reference Card

```
INSTALL
  /plugin marketplace add /path/to/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
  Enable memory-vault in /plugin → Discover
  /setup

DAILY USE
  "Start session"     → brief recall
  (work normally)
  "Session end"       → full close protocol

MANUAL SAVES
  /compress           → save context now
  /resume             → load previous session

SEARCH VAULT
  qmd query -c sessions "topic" -n 5

IMPORT OLD CHATS
  python3 .../import-gemini.py  <takeout-dir>  <vault>/07-Claude/conversations/
  python3 .../import-cursor.py  <vault>/07-Claude/conversations/
  python3 .../import-claude-web.py  <export.dms>  <vault>/07-Claude/conversations/
  qmd update && qmd embed

TROUBLESHOOT
  rm -rf ~/.claude/plugins/cache && /reload-plugins
  qmd update && qmd embed
  cat ~/.config/memory-vault/config.sh
  /setup   (re-run is safe — idempotent)
```

---

_Memory Vault v1.0.0 — LTC Partners_
