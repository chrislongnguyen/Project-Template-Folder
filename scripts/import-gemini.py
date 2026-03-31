#!/usr/bin/env python3
# version: 1.0 | last_updated: 2026-03-29
"""
Gemini Takeout Importer — JSON → Vault Markdown

Reads Google Takeout Gemini conversation JSON files and writes
vault-compatible markdown files (one per conversation).

Usage:
    python3 import-gemini.py <takeout-dir> <output-dir>
    python3 import-gemini.py <takeout-dir> <output-dir> --dry-run
    python3 import-gemini.py <takeout-dir> <output-dir> --force

Arguments:
    takeout-dir   Path to extracted Google Takeout folder
    output-dir    Vault conversations directory
                  (default: $MEMORY_VAULT_PATH/07-Claude/conversations/)

Flags:
    --dry-run     Print what would be imported without writing files
    --force       Overwrite existing files
"""

import argparse
import json
import os
import re
import sys
from datetime import datetime
from pathlib import Path


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

def parse_gemini_timestamp(ts_str):
    """Parse Gemini conversation timestamps.

    Handles ISO-8601 formats and epoch-ms values.
    Returns (date_str YYYY-MM-DD, success).
    """
    if not ts_str:
        return None, False

    # Epoch milliseconds (numeric string or int)
    if isinstance(ts_str, (int, float)):
        try:
            dt = datetime.utcfromtimestamp(ts_str / 1000.0)
            return dt.strftime("%Y-%m-%d"), True
        except (ValueError, OSError, OverflowError):
            return None, False

    ts_str = str(ts_str).strip()

    # Try numeric epoch ms as string
    if ts_str.isdigit():
        try:
            dt = datetime.utcfromtimestamp(int(ts_str) / 1000.0)
            return dt.strftime("%Y-%m-%d"), True
        except (ValueError, OSError, OverflowError):
            pass

    # ISO-8601: "2026-03-06T14:30:00Z" or "2026-03-06T14:30:00.123Z"
    clean = ts_str.rstrip("Z").replace("+00:00", "")
    if "." in clean:
        clean = clean.split(".")[0]
    # Strip trailing timezone offset like +07:00
    clean = re.sub(r"[+-]\d{2}:\d{2}$", "", clean)

    for fmt in ("%Y-%m-%dT%H:%M:%S", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d"):
        try:
            dt = datetime.strptime(clean, fmt)
            return dt.strftime("%Y-%m-%d"), True
        except ValueError:
            continue

    return None, False


# ---------------------------------------------------------------------------
# Conversation extraction
# ---------------------------------------------------------------------------

def extract_conversations_from_file(json_path):
    """Extract conversations from a single Gemini Takeout JSON file.

    Expected formats:
    - Array of conversation objects
    - Single conversation object
    - Each conversation: {messages: [{role, text|parts}], createdTime, title}
    """
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except (json.JSONDecodeError, OSError) as e:
        print("  WARNING: Could not parse {}: {}".format(json_path.name, e))
        return []

    # Normalize to list
    if isinstance(data, dict):
        # Could be a single conversation or a wrapper
        if "messages" in data:
            conversations = [data]
        elif "conversations" in data:
            conversations = data["conversations"]
        else:
            # Try treating the whole dict values as conversations
            conversations = []
            for val in data.values():
                if isinstance(val, list):
                    conversations.extend(val)
                elif isinstance(val, dict) and "messages" in val:
                    conversations.append(val)
    elif isinstance(data, list):
        conversations = data
    else:
        return []

    results = []
    for conv in conversations:
        if not isinstance(conv, dict):
            continue

        messages = conv.get("messages", [])
        if not isinstance(messages, list) or len(messages) == 0:
            continue

        # Extract message text
        parsed_msgs = []
        for msg in messages:
            if not isinstance(msg, dict):
                continue

            role_raw = msg.get("role", "").lower()
            if role_raw in ("user", "human"):
                role = "user"
            elif role_raw in ("model", "assistant"):
                role = "assistant"
            else:
                continue

            # Text can be in "text", "content", or "parts" field
            text = ""
            if "text" in msg and isinstance(msg["text"], str):
                text = msg["text"].strip()
            elif "content" in msg:
                content = msg["content"]
                if isinstance(content, str):
                    text = content.strip()
                elif isinstance(content, list):
                    parts = []
                    for part in content:
                        if isinstance(part, str):
                            parts.append(part)
                        elif isinstance(part, dict) and "text" in part:
                            parts.append(part["text"])
                    text = "\n".join(parts).strip()
            elif "parts" in msg and isinstance(msg["parts"], list):
                parts = []
                for part in msg["parts"]:
                    if isinstance(part, str):
                        parts.append(part)
                    elif isinstance(part, dict) and "text" in part:
                        parts.append(part["text"])
                text = "\n".join(parts).strip()

            if text:
                parsed_msgs.append({"role": role, "text": text})

        if not parsed_msgs:
            continue

        # Extract metadata
        title = conv.get("title", "")
        created_time = (
            conv.get("createdTime")
            or conv.get("create_time")
            or conv.get("createTime")
            or conv.get("timestamp")
            or ""
        )

        # Derive title from first user message if missing
        if not title:
            for m in parsed_msgs:
                if m["role"] == "user":
                    title = m["text"][:60]
                    break

        results.append({
            "title": title or "Untitled Gemini Conversation",
            "created_time": created_time,
            "messages": parsed_msgs,
        })

    return results


def find_gemini_json_files(takeout_dir):
    """Walk takeout directory for JSON files that may contain Gemini conversations."""
    json_files = []
    takeout_path = Path(takeout_dir)

    for root, _dirs, files in os.walk(takeout_path):
        for fname in files:
            if fname.endswith(".json"):
                json_files.append(Path(root) / fname)

    return sorted(json_files)


# ---------------------------------------------------------------------------
# Markdown output
# ---------------------------------------------------------------------------

def render_conversation_markdown(conv, date_str):
    """Render a conversation dict as vault-compatible markdown."""
    title = conv["title"]
    messages = conv["messages"]
    msg_count = len(messages)
    now_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    lines = []

    # Frontmatter
    lines.append("---")
    lines.append("type: imported-conversation")
    lines.append("source: gemini")
    lines.append("date: {}".format(date_str))
    # Escape any YAML-problematic characters in title
    safe_title = title.replace('"', '\\"')
    lines.append('title: "{}"'.format(safe_title))
    lines.append("messages: {}".format(msg_count))
    lines.append("imported_at: {}".format(now_str))
    lines.append("---")
    lines.append("")

    # Header
    lines.append("# {}".format(title))
    lines.append("")
    lines.append("**Source:** Gemini | **Date:** {} | **Messages:** {}".format(
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
        description="Import Gemini conversations from Google Takeout to vault markdown"
    )
    parser.add_argument("takeout_dir", type=Path, help="Path to extracted Google Takeout folder")
    parser.add_argument(
        "output_dir",
        type=Path,
        nargs="?",
        default=None,
        help="Vault conversations directory (default: $MEMORY_VAULT_PATH/07-Claude/conversations/)",
    )
    parser.add_argument("--dry-run", action="store_true", help="Print what would be imported without writing")
    parser.add_argument("--force", action="store_true", help="Overwrite existing files")
    args = parser.parse_args()

    # Resolve output dir
    output_dir = args.output_dir
    if output_dir is None:
        vault_path = os.environ.get("MEMORY_VAULT_PATH", "")
        if vault_path:
            output_dir = Path(vault_path) / "07-Claude" / "conversations"
        else:
            print("ERROR: No output directory specified and $MEMORY_VAULT_PATH not set.")
            sys.exit(1)

    # Validate takeout dir
    if not args.takeout_dir.is_dir():
        print("ERROR: Takeout directory not found: {}".format(args.takeout_dir))
        sys.exit(1)

    # Find JSON files
    json_files = find_gemini_json_files(args.takeout_dir)
    if not json_files:
        print("No JSON files found in {}".format(args.takeout_dir))
        sys.exit(1)

    print("Found {} JSON file(s) in takeout directory".format(len(json_files)))

    # Extract all conversations
    all_conversations = []
    for jf in json_files:
        convs = extract_conversations_from_file(jf)
        if convs:
            all_conversations.extend(convs)

    if not all_conversations:
        print("No Gemini conversations found in takeout data.")
        sys.exit(0)

    print("Found {} conversation(s) to import".format(len(all_conversations)))

    # Create output directory
    if not args.dry_run:
        output_dir.mkdir(parents=True, exist_ok=True)

    # Write markdown files
    imported = 0
    skipped_existing = 0
    skipped_malformed = 0

    for conv in all_conversations:
        # Parse date
        date_str, date_ok = parse_gemini_timestamp(conv["created_time"])
        if not date_ok:
            date_str = "unknown"

        # Build filename
        title_slug = sanitize_filename(conv["title"])
        filename = "gemini-{}-{}.md".format(date_str, title_slug)
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
            md_content = render_conversation_markdown(conv, date_str)
        except Exception as e:
            print("  WARNING: Failed to render conversation '{}': {}".format(
                conv["title"][:40], e
            ))
            skipped_malformed += 1
            continue

        if args.dry_run:
            print("  [DRY RUN] Would write: {} ({} messages)".format(
                filename, len(conv["messages"])
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
    print("")
    if args.dry_run:
        print("{} conversations would be imported from Gemini".format(
            len(all_conversations) - skipped_existing - skipped_malformed
        ))
        if skipped_existing:
            print("  ({} skipped -- already exist)".format(skipped_existing))
    else:
        print("{} conversations imported from Gemini".format(imported))
        if skipped_existing:
            print("  ({} skipped -- already exist, use --force to overwrite)".format(
                skipped_existing
            ))
    if skipped_malformed:
        print("  ({} skipped -- malformed)".format(skipped_malformed))


if __name__ == "__main__":
    main()
