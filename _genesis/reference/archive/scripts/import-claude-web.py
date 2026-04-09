#!/usr/bin/env python3
# version: 1.0 | last_updated: 2026-03-29
"""
Claude Web/Code Importer — JSON/JSONL/DMS → Vault Markdown

Reads Claude web exports (.dms ZIP or extracted directory) and Claude Code
JSONL transcripts, then writes vault-compatible markdown files
(one per conversation).

Usage:
    python3 import-claude-web.py <export-path> <output-dir>
    python3 import-claude-web.py <export-path> <output-dir> --dry-run
    python3 import-claude-web.py <export-path> <output-dir> --force

Arguments:
    export-path   Path to Claude web export (.dms file or extracted directory)
    output-dir    Vault conversations directory

Flags:
    --dry-run     Print what would be imported without writing files
    --force       Overwrite existing files
"""

import argparse
import json
import os
import re
import sys
import tempfile
import zipfile
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

def parse_timestamp(ts_str):
    """Parse various timestamp formats to YYYY-MM-DD.

    Returns (date_str, success).
    """
    if not ts_str:
        return None, False

    # Epoch milliseconds (numeric)
    if isinstance(ts_str, (int, float)):
        try:
            dt = datetime.utcfromtimestamp(ts_str / 1000.0)
            return dt.strftime("%Y-%m-%d"), True
        except (ValueError, OSError, OverflowError):
            return None, False

    ts_str = str(ts_str).strip()

    # Numeric epoch ms as string
    if ts_str.isdigit():
        try:
            dt = datetime.utcfromtimestamp(int(ts_str) / 1000.0)
            return dt.strftime("%Y-%m-%d"), True
        except (ValueError, OSError, OverflowError):
            pass

    # ISO-8601 variants
    clean = ts_str.rstrip("Z").replace("+00:00", "")
    if "." in clean:
        clean = clean.split(".")[0]
    # Strip timezone offset
    clean = re.sub(r"[+-]\d{2}:\d{2}$", "", clean)

    for fmt in ("%Y-%m-%dT%H:%M:%S", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d"):
        try:
            dt = datetime.strptime(clean, fmt)
            return dt.strftime("%Y-%m-%d"), True
        except ValueError:
            continue

    return None, False


# ---------------------------------------------------------------------------
# System-reminder stripping
# ---------------------------------------------------------------------------

# Pattern to detect system-reminder blocks that Claude Code adds
SYSTEM_REMINDER_RE = re.compile(
    r"<system-reminder>.*?</system-reminder>",
    re.DOTALL
)


def strip_system_reminders(text):
    """Remove <system-reminder>...</system-reminder> blocks from text."""
    return SYSTEM_REMINDER_RE.sub("", text).strip()


# ---------------------------------------------------------------------------
# Claude Web JSON export parsing
# ---------------------------------------------------------------------------

def parse_claude_web_json(json_path):
    """Parse a Claude web export JSON file.

    Expected format: array of conversations or single conversation object.
    Each conversation has: {uuid, name, created_at, updated_at, chat_messages: [{sender, text}]}
    """
    try:
        with open(json_path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except (json.JSONDecodeError, OSError) as e:
        print("  WARNING: Could not parse {}: {}".format(json_path.name, e))
        return []

    # Normalize to list
    conversations = []
    if isinstance(data, list):
        conversations = data
    elif isinstance(data, dict):
        if "chat_messages" in data or "messages" in data:
            conversations = [data]
        elif "conversations" in data:
            conversations = data["conversations"]
        else:
            # Try all dict values
            for val in data.values():
                if isinstance(val, list):
                    for item in val:
                        if isinstance(item, dict) and ("chat_messages" in item or "messages" in item):
                            conversations.append(item)
                elif isinstance(val, dict) and ("chat_messages" in val or "messages" in val):
                    conversations.append(val)

    results = []
    for conv in conversations:
        if not isinstance(conv, dict):
            continue

        # Get messages array (try multiple field names)
        raw_messages = (
            conv.get("chat_messages")
            or conv.get("messages")
            or []
        )
        if not isinstance(raw_messages, list) or not raw_messages:
            continue

        # Parse messages
        parsed_msgs = []
        for msg in raw_messages:
            if not isinstance(msg, dict):
                continue

            role_raw = (
                msg.get("sender", "")
                or msg.get("role", "")
                or msg.get("author", {}).get("role", "")
            ).lower()

            if role_raw in ("human", "user"):
                role = "user"
            elif role_raw in ("assistant", "model"):
                role = "assistant"
            else:
                continue

            # Extract text from various content structures
            text = _extract_message_text(msg)
            if not text:
                continue

            parsed_msgs.append({"role": role, "text": text})

        if not parsed_msgs:
            continue

        # Metadata
        conv_id = conv.get("uuid", "") or conv.get("id", "") or conv.get("conversation_id", "")
        title = conv.get("name", "") or conv.get("title", "")
        created_at = (
            conv.get("created_at")
            or conv.get("create_time")
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
            "id": conv_id or sanitize_filename(title),
            "title": title or "Untitled Claude Conversation",
            "created_at": created_at,
            "messages": parsed_msgs,
        })

    return results


def _extract_message_text(msg):
    """Extract text content from a Claude message dict."""
    # Direct text field
    if "text" in msg and isinstance(msg["text"], str):
        text = msg["text"].strip()
        if text:
            return strip_system_reminders(text)

    # Content field (string or list of blocks)
    content = msg.get("content", "")
    if isinstance(content, str) and content.strip():
        return strip_system_reminders(content.strip())

    if isinstance(content, list):
        text_parts = []
        for block in content:
            if isinstance(block, str):
                text_parts.append(block)
            elif isinstance(block, dict):
                block_type = block.get("type", "")
                # Skip tool_use, tool_result, thinking blocks
                if block_type in ("tool_use", "tool_result", "thinking"):
                    continue
                if block_type == "text":
                    t = block.get("text", "").strip()
                    if t:
                        text_parts.append(t)
        combined = "\n\n".join(text_parts).strip()
        if combined:
            return strip_system_reminders(combined)

    return ""


# ---------------------------------------------------------------------------
# Claude Code JSONL fallback parsing
# ---------------------------------------------------------------------------

def parse_claude_code_jsonl(jsonl_path):
    """Parse a Claude Code JSONL transcript file.

    Each line is a JSON record with {type: "user"|"assistant", message: {content: ...}}.
    Pairs user messages with subsequent assistant text responses.
    Skips: isMeta messages, tool_use/tool_result/thinking blocks, system-reminders.
    """
    messages = []

    try:
        with open(jsonl_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    record = json.loads(line)
                except json.JSONDecodeError:
                    continue

                msg_type = record.get("type")

                if msg_type == "user" and not record.get("isMeta"):
                    content = record.get("message", {}).get("content", "")
                    if isinstance(content, str) and len(content.strip()) > 3:
                        text = strip_system_reminders(content.strip())
                        if text:
                            messages.append({
                                "role": "user",
                                "text": text,
                                "timestamp": record.get("timestamp"),
                                "session_id": record.get("sessionId"),
                            })

                elif msg_type == "assistant":
                    content = record.get("message", {}).get("content", [])
                    text_parts = []

                    if isinstance(content, list):
                        for block in content:
                            if isinstance(block, dict):
                                block_type = block.get("type", "")
                                if block_type in ("tool_use", "tool_result", "thinking"):
                                    continue
                                if block_type == "text":
                                    t = block.get("text", "").strip()
                                    if t:
                                        text_parts.append(t)
                    elif isinstance(content, str) and content.strip():
                        text_parts.append(content.strip())

                    if text_parts:
                        combined = "\n\n".join(text_parts)
                        combined = strip_system_reminders(combined)
                        if combined:
                            messages.append({
                                "role": "assistant",
                                "text": combined,
                                "timestamp": record.get("timestamp"),
                                "session_id": record.get("sessionId"),
                            })
    except OSError as e:
        print("  WARNING: Could not read {}: {}".format(jsonl_path.name, e))
        return []

    if not messages:
        return []

    # Merge into alternating conversation
    merged = []
    for msg in messages:
        if merged and merged[-1]["role"] == msg["role"]:
            merged[-1]["text"] += "\n\n" + msg["text"]
        else:
            merged.append(msg)

    # Determine session metadata
    session_id = ""
    timestamp = ""
    for msg in messages:
        if not session_id and "session_id" in msg and msg["session_id"]:
            session_id = msg["session_id"]
        if not timestamp and "timestamp" in msg and msg["timestamp"]:
            timestamp = msg["timestamp"]

    if not session_id:
        session_id = jsonl_path.stem

    # Build title from first user message
    title = ""
    for m in merged:
        if m["role"] == "user":
            title = m["text"][:60]
            break

    # Strip metadata keys from final messages
    clean_msgs = [{"role": m["role"], "text": m["text"]} for m in merged]

    return [{
        "id": session_id,
        "title": title or "Untitled Claude Code Session",
        "created_at": timestamp or "",
        "messages": clean_msgs,
    }]


# ---------------------------------------------------------------------------
# Source discovery
# ---------------------------------------------------------------------------

def discover_conversations(export_path):
    """Discover and parse all conversations from an export path.

    Handles: .dms ZIP files, directories with JSON/JSONL files.
    """
    export_path = Path(export_path)
    all_conversations = []
    temp_dir = None

    try:
        # Handle .dms ZIP file
        if export_path.is_file() and (
            export_path.suffix == ".dms"
            or zipfile.is_zipfile(str(export_path))
        ):
            temp_dir = tempfile.mkdtemp(prefix="claude-import-")
            print("Extracting ZIP archive to temporary directory...")
            try:
                with zipfile.ZipFile(str(export_path), "r") as zf:
                    zf.extractall(temp_dir)
                search_dir = Path(temp_dir)
            except zipfile.BadZipFile as e:
                print("ERROR: Could not extract ZIP file: {}".format(e))
                return []
        elif export_path.is_dir():
            search_dir = export_path
        elif export_path.is_file():
            # Single file — try parsing directly
            if export_path.suffix == ".jsonl":
                return parse_claude_code_jsonl(export_path)
            elif export_path.suffix == ".json":
                return parse_claude_web_json(export_path)
            else:
                print("ERROR: Unsupported file type: {}".format(export_path.suffix))
                return []
        else:
            print("ERROR: Path not found: {}".format(export_path))
            return []

        # Walk directory for JSON and JSONL files
        for root, _dirs, files in os.walk(search_dir):
            for fname in sorted(files):
                fpath = Path(root) / fname

                if fname.endswith(".jsonl"):
                    convs = parse_claude_code_jsonl(fpath)
                    if convs:
                        all_conversations.extend(convs)
                elif fname.endswith(".json"):
                    convs = parse_claude_web_json(fpath)
                    if convs:
                        all_conversations.extend(convs)

    finally:
        # Clean up temp dir
        if temp_dir:
            import shutil
            try:
                shutil.rmtree(temp_dir)
            except OSError:
                pass

    return all_conversations


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
    lines.append("source: claude-web")
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
    lines.append("**Source:** Claude | **Date:** {} | **Messages:** {}".format(
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
        description="Import Claude web/code conversations to vault markdown"
    )
    parser.add_argument("export_path", type=Path, help="Path to Claude export (.dms file or extracted directory)")
    parser.add_argument("output_dir", type=Path, help="Vault conversations directory")
    parser.add_argument("--dry-run", action="store_true", help="Print what would be imported without writing")
    parser.add_argument("--force", action="store_true", help="Overwrite existing files")
    args = parser.parse_args()

    output_dir = args.output_dir
    export_path = args.export_path

    # Validate export path
    if not export_path.exists():
        print("ERROR: Export path not found: {}".format(export_path))
        sys.exit(1)

    # Discover and parse conversations
    print("Scanning: {}".format(export_path))
    all_conversations = discover_conversations(export_path)

    if not all_conversations:
        print("No Claude conversations found in export.")
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
        date_str, date_ok = parse_timestamp(conv["created_at"])
        if not date_ok:
            date_str = "unknown"

        # Build filename
        session_id = sanitize_filename(conv.get("id", "") or conv["title"])
        filename = "claude-web-{}-{}.md".format(date_str, session_id)
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
            print("  WARNING: Failed to render '{}': {}".format(
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
        would_import = len(all_conversations) - skipped_existing - skipped_malformed
        print("{} conversations would be imported from Claude".format(would_import))
        if skipped_existing:
            print("  ({} skipped -- already exist)".format(skipped_existing))
    else:
        print("{} conversations imported from Claude".format(imported))
        if skipped_existing:
            print("  ({} skipped -- already exist, use --force to overwrite)".format(
                skipped_existing
            ))
    if skipped_malformed:
        print("  ({} skipped -- malformed)".format(skipped_malformed))


if __name__ == "__main__":
    main()
