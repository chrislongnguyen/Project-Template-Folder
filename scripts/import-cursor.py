#!/usr/bin/env python3
# version: 1.0 | last_updated: 2026-03-29
"""
Cursor Chat Importer — SQLite (state.vscdb) → Vault Markdown

Reads Cursor's internal SQLite database (cursorDiskKV table) to extract
composer/chat sessions and writes vault-compatible markdown files
(one per conversation).

Usage:
    python3 import-cursor.py <output-dir>
    python3 import-cursor.py --db <path-to-state.vscdb> <output-dir>
    python3 import-cursor.py <output-dir> --dry-run
    python3 import-cursor.py <output-dir> --force

Arguments:
    output-dir    Vault conversations directory

Options:
    --db PATH     Path to Cursor state.vscdb
                  (default: ~/Library/Application Support/Cursor/User/globalStorage/state.vscdb)
    --dry-run     Print what would be imported without writing files
    --force       Overwrite existing files
"""

import argparse
import json
import re
import sqlite3
import sys
from datetime import datetime, timedelta
from pathlib import Path


# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

DEFAULT_DB = (
    Path.home()
    / "Library"
    / "Application Support"
    / "Cursor"
    / "User"
    / "globalStorage"
    / "state.vscdb"
)


# ---------------------------------------------------------------------------
# Filename sanitization
# ---------------------------------------------------------------------------

def sanitize_filename(text, max_len=60):
    """Sanitize text for use as a filename component.

    Replaces spaces/special chars with hyphens, lowercases, caps at max_len.
    """
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = text.strip("-")
    if len(text) > max_len:
        text = text[:max_len].rstrip("-")
    return text or "untitled"


# ---------------------------------------------------------------------------
# Timestamp helpers
# ---------------------------------------------------------------------------

def epoch_ms_to_date(epoch_ms):
    """Convert epoch milliseconds to YYYY-MM-DD string.

    Returns (date_str, success).
    """
    if not epoch_ms:
        return None, False

    try:
        dt = datetime.utcfromtimestamp(epoch_ms / 1000.0)
        return dt.strftime("%Y-%m-%d"), True
    except (ValueError, OSError, OverflowError):
        return None, False


def epoch_ms_to_datetime(epoch_ms):
    """Convert epoch milliseconds to datetime object.

    Returns (datetime, success).
    """
    if not epoch_ms:
        return None, False

    try:
        dt = datetime.utcfromtimestamp(epoch_ms / 1000.0)
        return dt, True
    except (ValueError, OSError, OverflowError):
        return None, False


# ---------------------------------------------------------------------------
# SQLite extraction
# ---------------------------------------------------------------------------

def extract_composers(db_path):
    """Extract all composer sessions from Cursor's state.vscdb.

    Returns list of dicts with: composer_id, name, created_at, headers.
    """
    try:
        conn = sqlite3.connect(str(db_path))
    except sqlite3.Error as e:
        print("ERROR: Could not open database: {}".format(e))
        sys.exit(1)

    cur = conn.cursor()

    # Check table exists
    cur.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='cursorDiskKV'")
    if not cur.fetchone():
        print("ERROR: Table 'cursorDiskKV' not found in database.")
        conn.close()
        sys.exit(1)

    # Get all composerData entries
    try:
        cur.execute("SELECT key, value FROM cursorDiskKV WHERE key LIKE 'composerData:%'")
        rows = cur.fetchall()
    except sqlite3.Error as e:
        print("ERROR: Query failed: {}".format(e))
        conn.close()
        sys.exit(1)

    composers = []
    skipped_no_turns = 0

    for key, val in rows:
        try:
            if isinstance(val, bytes):
                val = val.decode("utf-8", errors="replace")
            data = json.loads(val)

            composer_id = data.get("composerId", key.split(":")[1])
            name = data.get("name", "")
            created_at = data.get("createdAt", 0)  # epoch ms
            headers = data.get("fullConversationHeadersOnly", [])

            if not headers:
                skipped_no_turns += 1
                continue

            # Check for at least 1 user turn (type 1 = user)
            user_count = sum(1 for h in headers if h.get("type") == 1)
            if user_count == 0:
                skipped_no_turns += 1
                continue

            composers.append({
                "composer_id": composer_id,
                "name": name,
                "created_at": created_at,
                "headers": headers,
            })
        except (json.JSONDecodeError, KeyError, TypeError, IndexError):
            continue

    conn.close()
    return composers, skipped_no_turns


def extract_messages_from_composer(db_path, composer):
    """Extract ordered messages from a single composer session.

    Returns list of {role, text} dicts in conversation order.
    """
    headers = composer["headers"]
    composer_id = composer["composer_id"]

    # Pre-fetch all bubble texts for this composer
    try:
        conn = sqlite3.connect(str(db_path))
    except sqlite3.Error:
        return []

    cur = conn.cursor()
    prefix = "bubbleId:{}:".format(composer_id)

    try:
        cur.execute(
            "SELECT key, value FROM cursorDiskKV WHERE key LIKE ?",
            ("{}%".format(prefix),)
        )
    except sqlite3.Error:
        conn.close()
        return []

    bubble_cache = {}
    for key, val in cur.fetchall():
        bid = key[len(prefix):]
        try:
            if isinstance(val, bytes):
                val = val.decode("utf-8", errors="replace")
            data = json.loads(val)
            text = data.get("text", "") or data.get("rawText", "") or ""
            bubble_cache[bid] = text
        except (json.JSONDecodeError, TypeError):
            bubble_cache[bid] = ""

    conn.close()

    # Build ordered message list from headers
    messages = []
    for h in headers:
        bubble_id = h.get("bubbleId", "")
        bubble_type = h.get("type")
        text = bubble_cache.get(bubble_id, "").strip()

        if not text:
            continue

        if bubble_type == 1:
            role = "user"
        elif bubble_type == 2:
            role = "assistant"
        else:
            continue

        # Merge consecutive same-role messages
        if messages and messages[-1]["role"] == role:
            messages[-1]["text"] += "\n\n" + text
        else:
            messages.append({"role": role, "text": text})

    return messages


# ---------------------------------------------------------------------------
# Markdown output
# ---------------------------------------------------------------------------

def render_conversation_markdown(title, date_str, messages):
    """Render a conversation as vault-compatible markdown."""
    msg_count = len(messages)
    now_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    lines = []

    # Frontmatter
    lines.append("---")
    lines.append("type: imported-conversation")
    lines.append("source: cursor")
    lines.append("date: {}".format(date_str))
    safe_title = title.replace('"', '\\"')
    lines.append('title: "{}"'.format(safe_title))
    lines.append("messages: {}".format(msg_count))
    lines.append("imported_at: {}".format(now_str))
    lines.append("---")
    lines.append("")

    # Header
    lines.append("# {}".format(title))
    lines.append("")
    lines.append("**Source:** Cursor | **Date:** {} | **Messages:** {}".format(
        date_str, msg_count
    ))
    lines.append("")
    lines.append("---")
    lines.append("")

    # Messages
    for msg in messages:
        role_label = msg["role"].upper()
        lines.append("## {}".format(role_label))
        lines.append(msg["text"])
        lines.append("")

    return "\n".join(lines)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Import Cursor chat sessions to vault markdown"
    )
    parser.add_argument("output_dir", type=Path, help="Vault conversations directory")
    parser.add_argument(
        "--db",
        type=Path,
        default=DEFAULT_DB,
        help="Path to Cursor state.vscdb (default: %(default)s)",
    )
    parser.add_argument("--dry-run", action="store_true", help="Print what would be imported without writing")
    parser.add_argument("--force", action="store_true", help="Overwrite existing files")
    args = parser.parse_args()

    output_dir = args.output_dir
    db_path = args.db

    # Validate database
    if not db_path.exists():
        print("ERROR: Cursor database not found at {}".format(db_path))
        sys.exit(1)

    # Extract composers
    print("Reading Cursor database: {}".format(db_path))
    composers, skipped_no_turns = extract_composers(db_path)

    if not composers:
        print("No composer sessions with user turns found.")
        if skipped_no_turns:
            print("  ({} skipped -- no user turns)".format(skipped_no_turns))
        sys.exit(0)

    print("Found {} composer session(s) with user turns".format(len(composers)))

    # Create output directory
    if not args.dry_run:
        output_dir.mkdir(parents=True, exist_ok=True)

    # Process each composer
    imported = 0
    skipped_existing = 0
    skipped_empty = 0
    skipped_malformed = 0

    for composer in composers:
        # Extract messages
        messages = extract_messages_from_composer(db_path, composer)

        # Check for user turns in extracted messages
        user_turns = sum(1 for m in messages if m["role"] == "user")
        if user_turns == 0:
            skipped_empty += 1
            continue

        # Determine title
        title = composer["name"]
        if not title:
            # Use first user message truncated to 60 chars
            for m in messages:
                if m["role"] == "user":
                    title = m["text"][:60]
                    break
        if not title:
            title = "Untitled Cursor Session"

        # Parse date
        date_str, date_ok = epoch_ms_to_date(composer["created_at"])
        if not date_ok:
            date_str = "unknown"

        # Build filename
        title_slug = sanitize_filename(title)
        filename = "cursor-{}-{}.md".format(date_str, title_slug)
        filepath = output_dir / filename

        # Check existing
        if filepath.exists() and not args.force:
            if not args.dry_run:
                skipped_existing += 1
            else:
                print("  [SKIP existing] {}".format(filename))
                skipped_existing += 1
            continue

        # Render markdown
        try:
            md_content = render_conversation_markdown(title, date_str, messages)
        except Exception as e:
            print("  WARNING: Failed to render '{}': {}".format(title[:40], e))
            skipped_malformed += 1
            continue

        if args.dry_run:
            print("  [DRY RUN] Would write: {} ({} messages)".format(
                filename, len(messages)
            ))
        else:
            try:
                with open(filepath, "w", encoding="utf-8") as f:
                    f.write(md_content)
                imported += 1
            except OSError as e:
                print("  WARNING: Could not write {}: {}".format(filename, e))
                skipped_malformed += 1

    # Summary
    total_skipped = skipped_no_turns + skipped_empty
    print("")
    if args.dry_run:
        would_import = len(composers) - skipped_existing - skipped_empty - skipped_malformed
        print("{} conversations would be imported from Cursor ({} skipped -- no user turns)".format(
            would_import, total_skipped
        ))
        if skipped_existing:
            print("  ({} skipped -- already exist)".format(skipped_existing))
    else:
        print("{} conversations imported from Cursor ({} skipped -- no user turns)".format(
            imported, total_skipped
        ))
        if skipped_existing:
            print("  ({} skipped -- already exist, use --force to overwrite)".format(
                skipped_existing
            ))
    if skipped_malformed:
        print("  ({} skipped -- malformed)".format(skipped_malformed))


if __name__ == "__main__":
    main()
