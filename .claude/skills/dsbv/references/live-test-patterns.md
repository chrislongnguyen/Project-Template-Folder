---
version: "1.0"
status: draft
last_updated: 2026-04-09
---

# Live Test Patterns (LP-6)

Pattern library for AC live invocation tests. Each entry shows Wrong (structural only)
vs. Right (structural + live test).

## Shell Script
- Wrong: "`scripts/tool.sh` exists"
- Right: "`scripts/tool.sh` exists AND `bash -n scripts/tool.sh` exits 0 AND `bash scripts/tool.sh --help 2>&1 | grep -q usage`"

## Python Script
- Wrong: "`scripts/analysis.py` exists"
- Right: "`scripts/analysis.py` exists AND `python3 -c \"import ast; ast.parse(open('scripts/analysis.py').read())\"` exits 0"

## JSON Config
- Wrong: "`.claude/settings.json` updated"
- Right: "`.claude/settings.json` updated AND `python3 -c \"import json; json.load(open('.claude/settings.json'))\"` exits 0"

## CLI Tool (external dependency)
- Wrong: "jq installed"
- Right: "`which jq` exits 0 AND `echo '{}' | jq .` exits 0"

## Obsidian REST API (LP-6 source case)
- Wrong: "Obsidian plugin configured"
- Right: "Obsidian plugin configured AND `curl -s http://localhost:27123/ | grep -q obsidian` exits 0"

## State File
- Wrong: "`.claude/state/dsbv-1-ALIGN.json` exists"
- Right: "`.claude/state/dsbv-1-ALIGN.json` exists AND `python3 -c \"import json; json.load(open('.claude/state/dsbv-1-ALIGN.json'))\"` exits 0 (valid JSON)"

## Gate State Machine
- Wrong: "`scripts/gate-state.sh` exists"
- Right: "`scripts/gate-state.sh` exists AND `bash scripts/gate-state.sh init 1-ALIGN` exits 0 AND `bash scripts/gate-state.sh read 1-ALIGN` outputs valid JSON"
