#!/usr/bin/env python3
# version: 1.2 | status: in-review | last_updated: 2026-04-09
"""
session-etl.py — Incremental Claude Code JSONL session parser.

Reads new bytes only (watermark-based) from ~/.claude/projects/*/XXXXXXXX.jsonl,
extracts decisions / errors / file changes / key responses, redacts secrets,
appends to daily vault summaries under {vault}/07-Claude/sessions/{project}/YYYY-MM-DD.md

Usage:
    python3 scripts/session-etl.py           # incremental (from watermark)
    python3 scripts/session-etl.py --full    # ignore watermark, parse everything
    python3 scripts/session-etl.py --dry-run # parse but do not write output
"""

import glob
import json
import os
import re
import sys
import traceback
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

WATERMARK_FILENAME = ".session-etl-watermark.json"
WATERMARK_PATH = Path.home() / ".claude" / WATERMARK_FILENAME
CLAUDE_PROJECTS_GLOB = str(Path.home() / ".claude" / "projects" / "*" / "*.jsonl")
VAULT_OUTPUT_DIR = "07-Claude/sessions"

# Secret redaction patterns — order matters: specific before generic
_SECRET_PATTERNS = [
    # API key prefixes (value after prefix is the secret)
    (re.compile(r"(sk-[A-Za-z0-9\-_]{20,})", re.I), "[REDACTED:api-key]"),
    (re.compile(r"(pk-[A-Za-z0-9\-_]{20,})", re.I), "[REDACTED:api-key]"),
    (re.compile(r"(AKIA[A-Z0-9]{16})", re.I), "[REDACTED:aws-key]"),
    (re.compile(r"(AIza[A-Za-z0-9\-_]{35})", re.I), "[REDACTED:gcp-key]"),
    # .env-style KEY=value or KEY: value lines
    (
        re.compile(
            r"(?:password|secret|token|credential|api[_\-]?key)\s*[=:]\s*\S+",
            re.I,
        ),
        "[REDACTED:env-secret]",
    ),
    # Long base64-heavy tokens (>40 chars, high entropy-ish)
    # Negative lookbehind/ahead: skip if adjacent to path separators, @, or dots
    # (prevents mangling emails like user@domain.com or file paths)
    (
        re.compile(r"(?<![A-Za-z0-9/+@.\-])([A-Za-z0-9/+]{40,}={0,2})(?![A-Za-z0-9/+@.\-])"),
        "[REDACTED:token]",
    ),
]


def redact(text: str) -> str:
    """Apply secret redaction patterns. Returns redacted string."""
    for pattern, replacement in _SECRET_PATTERNS:
        text = pattern.sub(replacement, text)
    return text


# ---------------------------------------------------------------------------
# Vault path resolution
# ---------------------------------------------------------------------------

def resolve_vault_path() -> Path | None:
    """
    Priority:
    1. ~/.config/memory-vault/config.sh → MEMORY_VAULT_PATH=...
    2. MEMORY_VAULT_PATH env var
    3. Scan ~/Library/CloudStorage/GoogleDrive-*/My Drive/*-Memory-Vault
    Returns None (caller exits 0) if not found.
    """
    # P1: config file
    config_path = Path.home() / ".config" / "memory-vault" / "config.sh"
    if config_path.exists():
        try:
            text = config_path.read_text(encoding="utf-8", errors="replace")
            m = re.search(r'MEMORY_VAULT_PATH\s*=\s*["\']?([^"\'\n]+)["\']?', text)
            if m:
                candidate = Path(m.group(1).strip())
                if candidate.is_dir():
                    return candidate
        except Exception:
            pass

    # P2: env var
    env_vault = os.environ.get("MEMORY_VAULT_PATH", "").strip()
    if env_vault:
        candidate = Path(env_vault)
        if candidate.is_dir():
            return candidate

    # P3: glob scan — macOS-specific Google Drive path.
    # Override via MEMORY_VAULT_PATH env var (P2) for non-macOS or custom Drive locations.
    pattern = str(
        Path.home()
        / "Library"
        / "CloudStorage"
        / "GoogleDrive-*"
        / "My Drive"
        / "*-Memory-Vault"
    )
    matches = glob.glob(pattern)
    for m in matches:
        candidate = Path(m)
        if candidate.is_dir():
            return candidate

    return None


# ---------------------------------------------------------------------------
# Watermark
# ---------------------------------------------------------------------------

def load_watermark() -> dict:
    if WATERMARK_PATH.exists():
        try:
            return json.loads(WATERMARK_PATH.read_text(encoding="utf-8"))
        except Exception:
            pass
    return {"version": 1, "files": {}}


def save_watermark(wm: dict) -> None:
    WATERMARK_PATH.parent.mkdir(parents=True, exist_ok=True)
    WATERMARK_PATH.write_text(json.dumps(wm, indent=2), encoding="utf-8")


# ---------------------------------------------------------------------------
# JSONL line classification
# ---------------------------------------------------------------------------

def _text_from_content(content, *, include_tool_results: bool = True) -> str:
    """Flatten content field (str or list of blocks) to plain text.

    Args:
        include_tool_results: If False, skip tool_result blocks entirely.
            Use False when extracting human-authored text for decision detection.
    """
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        parts = []
        for block in content:
            if isinstance(block, dict):
                btype = block.get("type", "")
                if btype == "text":
                    parts.append(block.get("text", ""))
                elif btype == "tool_result" and include_tool_results:
                    inner = block.get("content", "")
                    parts.append(_text_from_content(inner))
                # skip tool_use, thinking, image blocks
        return " ".join(p for p in parts if p)
    return ""


def _is_system_noise(obj: dict) -> bool:
    """Return True for lines we should drop entirely."""
    t = obj.get("type", "")
    # snapshot metadata lines
    if t == "file-history-snapshot":
        return True
    # hook injections / meta user messages
    if t == "user" and obj.get("isMeta"):
        return True
    # command lines (slash commands)
    msg = obj.get("message", {})
    if isinstance(msg, dict):
        content = msg.get("content", "")
        if isinstance(content, str) and content.startswith("<command-name>"):
            return True
        # system prompts
        role = msg.get("role", "")
        if role == "system":
            return True
    return False


def _extract_tool_calls(content_list: list) -> list[dict]:
    """Return list of {name, input} dicts for tool_use blocks."""
    results = []
    if not isinstance(content_list, list):
        return results
    for block in content_list:
        if isinstance(block, dict) and block.get("type") == "tool_use":
            results.append(
                {"name": block.get("name", ""), "input": block.get("input", {})}
            )
    return results


def _extract_tool_results(content_list: list) -> list[dict]:
    """Return list of {tool_use_id, text, is_error} for tool_result blocks."""
    results = []
    if not isinstance(content_list, list):
        return results
    for block in content_list:
        if isinstance(block, dict) and block.get("type") == "tool_result":
            text = _text_from_content(block.get("content", ""))
            results.append(
                {
                    "tool_use_id": block.get("tool_use_id", ""),
                    "text": text,
                    "is_error": block.get("is_error", False),
                }
            )
    return results


def _classify_decision(text: str) -> bool:
    """Heuristic: does this user message look like a human approval/decision?

    Tight filter — only short, clearly human approval messages.
    Rejects: JSON/XML blobs, tool results, QMD fetches, long assistant transitions.
    """
    lower = text.lower().strip()

    # Too short or too long for a human decision
    if not lower or len(lower) < 2 or len(lower) > 300:
        return False

    # Reject structured data that leaked through (JSON, XML, tool output)
    if lower.startswith(("{", "[", "<", "```")):
        return False
    if re.search(r'[{}\[\]<>].*[{}\[\]<>]', lower):
        return False

    # Reject lines that look like tool/system noise
    noise_markers = [
        "tool_result", "tool_use", "system-reminder", "function_call",
        "content_block", "jsonl", ".jsonl", "qmd", "mcp__",
        "file_path", "old_string", "new_string",
    ]
    if any(m in lower for m in noise_markers):
        return False

    # Only match clear human approval phrases
    approval_phrases = [
        "approve", "approved", "go ahead", "yes", "confirm", "confirmed",
        "merge", "ship", "ship it", "looks good", "lgtm", "proceed",
        "do it", "build it", "run it",
    ]
    return any(lower.startswith(m) or lower == m for m in approval_phrases)


# ---------------------------------------------------------------------------
# File-change detection from tool calls
# ---------------------------------------------------------------------------



def _detect_file_changes(tool_calls: list[dict]) -> list[dict]:
    """
    Return list of {filepath, action} from Write/Edit tool calls.
    """
    changes = []
    for tc in tool_calls:
        name = tc.get("name", "")
        inp = tc.get("input", {})
        if name == "Write":
            fp = inp.get("file_path", "")
            if fp:
                changes.append({"filepath": fp, "action": "created/modified"})
        elif name == "Edit":
            fp = inp.get("file_path", "")
            if fp:
                changes.append({"filepath": fp, "action": "modified"})
        elif name == "Bash":
            cmd = inp.get("command", "")
            # detect explicit deletes
            if re.search(r"\brm\b", cmd):
                # try to extract path — rough heuristic
                m = re.search(r"rm\s+(?:-[rf]+\s+)?([^\s;|&]+)", cmd)
                if m:
                    changes.append({"filepath": m.group(1), "action": "deleted"})
    return changes


# ---------------------------------------------------------------------------
# Error classification (7-CS component label)
# ---------------------------------------------------------------------------

_COMPONENT_HINTS = {
    "EP": ["rule", "principle", "forbidden", "policy", "claude.md"],
    "EOP": ["procedure", "dsbv", "sequence", "gate", "workflow"],
    "EOE": ["hook", "environment", "permission", "settings"],
    "EOT": ["tool", "bash", "write", "read", "grep", "glob", "script"],
    "Agent": ["agent", "sub-agent", "orchestrat"],
}


def _label_component(text: str) -> str:
    lower = text.lower()
    for comp, hints in _COMPONENT_HINTS.items():
        if any(h in lower for h in hints):
            return comp
    return "EOT"  # default: tool-layer error


# ---------------------------------------------------------------------------
# Per-file incremental parser
# ---------------------------------------------------------------------------

def parse_file_incremental(
    jsonl_path: str, start_offset: int
) -> dict:
    """
    Read from start_offset to EOF. Returns:
    {
        end_offset: int,
        lines_parsed: int,
        entries: [
            {timestamp, type, data}  # type in decisions/errors/file_changes/models/tool_calls
        ],
        model_set: set[str],
        tool_call_count: int,
        first_ts: str|None,
        last_ts: str|None,
    }
    Raises on hard IO error; caller handles.
    """
    result = {
        "end_offset": start_offset,
        "lines_parsed": 0,
        "entries": [],
        "model_set": set(),
        "tool_call_count": 0,
        "first_ts": None,
        "last_ts": None,
    }

    # We track pending tool_use by uuid so we can pair with tool_result errors
    # tool_use_id -> tool_name
    pending_tool_names: dict[str, str] = {}

    try:
        # Read incremental tail from watermark to EOF.
        # NOTE: loads the delta into memory (not full file). For incremental runs
        # the delta is small (minutes of new content). For --full on very large
        # JSONL (400MB+), consider chunked line iteration — deferred to I3.
        with open(jsonl_path, "rb") as fh:
            fh.seek(start_offset)
            raw_tail = b""

            while True:
                chunk = fh.read(65536)
                if not chunk:
                    break
                raw_tail += chunk

            result["end_offset"] = start_offset + len(raw_tail)

        # Decode, handling non-UTF8 gracefully
        text = raw_tail.decode("utf-8", errors="replace")
        lines = text.split("\n")
        del raw_tail, text  # Free memory immediately after split

        # Last line may be incomplete (active session) — skip if can't parse
        for raw_line in lines:
            raw_line = raw_line.strip()
            if not raw_line:
                continue
            try:
                obj = json.loads(raw_line)
            except json.JSONDecodeError:
                # incomplete trailing line — skip silently
                continue

            result["lines_parsed"] += 1

            if _is_system_noise(obj):
                continue

            ts = obj.get("timestamp", "")
            if ts:
                if result["first_ts"] is None:
                    result["first_ts"] = ts
                result["last_ts"] = ts

            # Track model
            model = obj.get("message", {})
            if isinstance(model, dict):
                model_val = model.get("model", "")
                if model_val:
                    result["model_set"].add(model_val)

            obj_type = obj.get("type", "")

            # --- ASSISTANT messages ---
            if obj_type == "assistant":
                msg = obj.get("message", {})
                content = msg.get("content", []) if isinstance(msg, dict) else []

                tool_calls = _extract_tool_calls(content)
                result["tool_call_count"] += len(tool_calls)

                # Register tool names from content blocks for later error matching
                if isinstance(content, list):
                    for block in content:
                        if isinstance(block, dict) and block.get("type") == "tool_use":
                            tid = block.get("id", "")
                            tname = block.get("name", "")
                            if tid:
                                pending_tool_names[tid] = tname

                # File changes
                file_changes = _detect_file_changes(tool_calls)
                for fc in file_changes:
                    try:
                        safe_path = redact(fc["filepath"])
                    except Exception:
                        continue
                    result["entries"].append(
                        {
                            "timestamp": ts,
                            "type": "file_change",
                            "data": {"filepath": safe_path, "action": fc["action"]},
                        }
                    )

            # --- USER messages (tool results + human input) ---
            elif obj_type == "user":
                msg = obj.get("message", {})
                if not isinstance(msg, dict):
                    continue
                content = msg.get("content", [])

                tool_results = _extract_tool_results(content)
                for tr in tool_results:
                    if tr["is_error"]:
                        tool_name = pending_tool_names.get(tr["tool_use_id"], "unknown")
                        # Skip QMD/MCP search tool results — these are query
                        # responses, not real errors worth surfacing.
                        if tool_name.startswith("mcp__qmd") or tool_name.startswith("mcp__exa"):
                            continue
                        raw_text = tr["text"][:500]
                        try:
                            safe_text = redact(raw_text)
                        except Exception:
                            continue
                        component = _label_component(safe_text + " " + tool_name)
                        result["entries"].append(
                            {
                                "timestamp": ts,
                                "type": "error",
                                "data": {
                                    "tool_name": tool_name,
                                    "message": safe_text,
                                    "component": component,
                                },
                            }
                        )

                # Human text message — decision detection
                # Use include_tool_results=False to get only human-authored text,
                # not tool_result noise that was inlined in the same message.
                role = msg.get("role", "")
                if role == "user":
                    text_val = _text_from_content(content, include_tool_results=False)
                    if text_val and _classify_decision(text_val):
                        try:
                            safe_text = redact(text_val[:300])
                        except Exception:
                            continue
                        result["entries"].append(
                            {
                                "timestamp": ts,
                                "type": "decision",
                                "data": {"text": safe_text},
                            }
                        )

    except Exception as exc:
        # Fail-closed: propagate so caller can skip this file
        raise RuntimeError(f"Parse error in {jsonl_path}: {exc}") from exc

    return result


# ---------------------------------------------------------------------------
# Vault output writer
# ---------------------------------------------------------------------------

def _format_time(iso_ts: str) -> str:
    """Return HH:MM from ISO timestamp string."""
    if not iso_ts:
        return "??:??"
    try:
        dt = datetime.fromisoformat(iso_ts.replace("Z", "+00:00"))
        return dt.strftime("%H:%M")
    except Exception:
        return "??:??"


def _estimate_duration(first_ts: str | None, last_ts: str | None) -> str:
    if not first_ts or not last_ts:
        return "unknown"
    try:
        t0 = datetime.fromisoformat(first_ts.replace("Z", "+00:00"))
        t1 = datetime.fromisoformat(last_ts.replace("Z", "+00:00"))
        delta = t1 - t0
        total_min = int(delta.total_seconds() / 60)
        if total_min < 1:
            return "<1 min"
        if total_min < 60:
            return f"~{total_min} min"
        hours = total_min // 60
        mins = total_min % 60
        return f"~{hours}h {mins}m"
    except Exception:
        return "unknown"


def _project_name_from_path(jsonl_path: str) -> str:
    """
    Derive human-readable project name from ~/.claude/projects/{dir-name}/{uuid}.jsonl
    The dir name encodes the original path with / replaced by -.
    Strategy: strip the HOME directory prefix segments, then take the last 2-3 components.
    """
    dir_name = Path(jsonl_path).parent.name  # e.g. -Users-alice-projects-my-repo
    # Strip leading dash, split on dash
    segments = dir_name.lstrip("-").split("-")
    # Derive HOME segments to strip (e.g. ["Users", "alice"] on macOS/Linux)
    home_segments = [p for p in str(Path.home()).split(os.sep) if p]
    home_segment_set = set(home_segments)
    # Remove segments that are part of the HOME path prefix
    meaningful = [s for s in segments if s and s not in home_segment_set]
    return "-".join(meaningful[-4:]) if meaningful else dir_name


def build_daily_summary(
    project_name: str,
    date_str: str,
    all_entries: list[dict],
    model_set: set,
    tool_call_count: int,
    first_ts: str | None,
    last_ts: str | None,
    sessions_count: int,
) -> str:
    """Render the markdown daily summary block to append."""
    decisions = [e for e in all_entries if e["type"] == "decision"]
    errors = [e for e in all_entries if e["type"] == "error"]
    file_changes = [e for e in all_entries if e["type"] == "file_change"]

    lines = []

    # Frontmatter
    lines.append("---")
    lines.append("type: session-etl")
    lines.append(f"date: {date_str}")
    lines.append(f"project: {project_name}")
    lines.append(f"sessions_parsed: {sessions_count}")
    lines.append(f"decisions: {len(decisions)}")
    lines.append(f"errors: {len(errors)}")
    lines.append(f"files_changed: {len(file_changes)}")
    lines.append("---")
    lines.append("")
    lines.append(f"# Session ETL — {project_name} — {date_str}")
    lines.append("")

    # Decisions
    lines.append("## Decisions")
    if decisions:
        for e in decisions:
            lines.append(f"- [{_format_time(e['timestamp'])}] {e['data']['text']}")
    else:
        lines.append("- (none detected)")
    lines.append("")

    # Errors
    lines.append("## Errors")
    if errors:
        for e in errors:
            d = e["data"]
            lines.append(
                f"- [{_format_time(e['timestamp'])}] {d['tool_name']}: {d['message']} [component: {d['component']}]"
            )
    else:
        lines.append("- (none detected)")
    lines.append("")

    # File changes
    lines.append("## Key File Changes")
    if file_changes:
        seen = set()
        for e in file_changes:
            d = e["data"]
            key = f"{d['filepath']}:{d['action']}"
            if key not in seen:
                seen.add(key)
                lines.append(f"- {d['filepath']}: {d['action']}")
    else:
        lines.append("- (none detected)")
    lines.append("")

    # Session meta
    lines.append("## Session Meta")
    model_list = ", ".join(sorted(model_set)) if model_set else "unknown"
    lines.append(f"- Models used: {model_list}")
    lines.append(f"- Tool calls: {tool_call_count}")
    lines.append(f"- Duration: {_estimate_duration(first_ts, last_ts)}")
    lines.append("")

    return "\n".join(lines)


def write_vault_summary(
    vault_root: Path,
    project_name: str,
    date_str: str,
    content: str,
    dry_run: bool,
) -> Path:
    """
    Write content to vault_root/07-Claude/sessions/{project_name}/YYYY-MM-DD.md
    Overwrites on rerun (same date) to prevent duplicate blocks.
    Returns the output path.
    """
    out_dir = vault_root / VAULT_OUTPUT_DIR / project_name
    out_path = out_dir / f"{date_str}.md"

    if dry_run:
        print(f"[dry-run] Would write to {out_path} ({len(content)} chars)")
        return out_path

    out_dir.mkdir(parents=True, exist_ok=True)

    # Always overwrite — watermark ensures we parse incrementally,
    # so the full aggregated summary replaces the stale one.
    out_path.write_text(content, encoding="utf-8")

    return out_path


# ---------------------------------------------------------------------------
# Main orchestration
# ---------------------------------------------------------------------------

def run(full: bool = False, dry_run: bool = False) -> int:
    """
    Returns 0 on success/graceful-skip, 1 on hard error.
    """
    vault_root = resolve_vault_path()
    if vault_root is None:
        # Exit 0 silently — vault not configured
        return 0

    wm = load_watermark()
    files_meta = wm.get("files", {})
    new_files_meta = dict(files_meta)  # will update in place

    jsonl_files = sorted(glob.glob(CLAUDE_PROJECTS_GLOB))
    if not jsonl_files:
        return 0

    # Group by project dir for summary aggregation
    # project_dir -> list of jsonl paths
    project_files: dict[str, list[str]] = defaultdict(list)
    for jf in jsonl_files:
        project_dir = str(Path(jf).parent)
        project_files[project_dir].append(jf)

    today = datetime.now(timezone.utc).strftime("%Y-%m-%d")

    for project_dir, paths in project_files.items():
        project_name = _project_name_from_path(paths[0])

        all_entries: list[dict] = []
        all_models: set[str] = set()
        total_tool_calls = 0
        first_ts_overall = None
        last_ts_overall = None
        sessions_parsed = 0

        for jf in paths:
            if full:
                start_offset = 0
            else:
                meta = files_meta.get(jf, {})
                start_offset = meta.get("byte_offset", 0)

            try:
                file_size = os.path.getsize(jf)
            except OSError:
                continue

            if start_offset >= file_size and not full:
                # Nothing new
                continue

            try:
                result = parse_file_incremental(jf, start_offset)
            except RuntimeError as exc:
                # Fail-closed: skip this file, log, continue
                print(f"[warn] Skipping {jf}: {exc}", file=sys.stderr)
                continue

            sessions_parsed += 1
            all_entries.extend(result["entries"])
            all_models |= result["model_set"]
            total_tool_calls += result["tool_call_count"]

            if result["first_ts"]:
                if first_ts_overall is None or result["first_ts"] < first_ts_overall:
                    first_ts_overall = result["first_ts"]
            if result["last_ts"]:
                if last_ts_overall is None or result["last_ts"] > last_ts_overall:
                    last_ts_overall = result["last_ts"]

            # Update watermark
            now_iso = datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")
            new_files_meta[jf] = {
                "byte_offset": result["end_offset"],
                "last_parsed": now_iso,
                "lines_parsed": files_meta.get(jf, {}).get("lines_parsed", 0)
                + result["lines_parsed"],
            }

        if sessions_parsed == 0:
            continue

        # Build and write summary
        summary = build_daily_summary(
            project_name=project_name,
            date_str=today,
            all_entries=all_entries,
            model_set=all_models,
            tool_call_count=total_tool_calls,
            first_ts=first_ts_overall,
            last_ts=last_ts_overall,
            sessions_count=sessions_parsed,
        )

        try:
            out_path = write_vault_summary(
                vault_root=vault_root,
                project_name=project_name,
                date_str=today,
                content=summary,
                dry_run=dry_run,
            )
            if not dry_run:
                print(f"[etl] Written: {out_path}")
        except Exception as exc:
            print(f"[error] Failed to write vault summary for {project_name}: {exc}", file=sys.stderr)
            return 1

    # Persist watermark
    if not dry_run:
        updated_wm = {"version": 1, "files": new_files_meta}
        try:
            save_watermark(updated_wm)
        except Exception as exc:
            print(f"[error] Failed to save watermark: {exc}", file=sys.stderr)
            return 1

    return 0


# ---------------------------------------------------------------------------
# CLI entry point
# ---------------------------------------------------------------------------

def main() -> int:
    args = sys.argv[1:]
    full = "--full" in args
    dry_run = "--dry-run" in args

    if any(a not in ("--full", "--dry-run") for a in args):
        print(
            "Usage: session-etl.py [--full] [--dry-run]",
            file=sys.stderr,
        )
        return 1

    try:
        return run(full=full, dry_run=dry_run)
    except Exception as exc:
        print(f"[fatal] Unhandled error: {exc}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
