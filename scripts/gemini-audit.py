#!/usr/bin/env python3
# version: 3.4 | status: draft | last_updated: 2026-04-11
"""
gemini-audit.py v3.4 — Comprehensive multi-agent workspace audit.

Reads EVERY file. No stone unturned. 4-phase pipeline:
  Phase 0: LOCAL (Python) — frontmatter, wikilinks, script validation. $0.
  Phase 1: CONTENT (Flash×11) — per-area line-by-line audit of all files
  Phase 1.5: CLAIM VERIFICATION — file-path claims cross-checked against manifest
  Phase 1.R: RECONCILIATION — cross-agent contradiction detection across Phase 1 outputs
  Phase 2: CROSS-CUT (Flash×5) — links, naming, process-map, hooks, versions
  Phase 2.5: CLAIM VERIFICATION — same cross-check applied to Phase 2 output
  Phase 3: SYNTHESIS (ProMax×5) — PM walkthrough, GAN debate, final report

Reliability features (v3.1):
  - verify_claims(): extract & verify all file-path claims; tag VERIFIED/DISPUTED/HALLUCINATED
  - tag_confidence(): tag findings as [MACHINE]/[ANALYZED]/[SPECULATIVE]
  - Schema enforcement: auto-retry malformed agent responses once with stricter prompt

Pipeline features (v3.2):
  - reconcile(): cross-agent contradiction detection after Phase 1 (Gap 4)
  - load_prior_audit(): load most-recent prior audit from inbox/ for trend analysis (Gap 5)
  - regression_analysis(): new/resolved/recurring issues + score trend (Gap 5)

Models: gemini-2.5-flash (Flash), gemini-3.1-pro-preview (ProMax)
Override: GEMINI_FLASH / GEMINI_PRO_MAX env vars.
Cost: ~$2-5 | Time: ~5-15 min | API calls: ~21

Usage:
    GEMINI_API_KEY=key python3 scripts/gemini-audit.py
    GEMINI_API_KEY=key python3 scripts/gemini-audit.py --dry-run
    GEMINI_API_KEY=key python3 scripts/gemini-audit.py --phase 0
    GEMINI_API_KEY=key python3 scripts/gemini-audit.py --list-models
"""

import argparse, json, os, re, subprocess, sys, threading, time, urllib.error, urllib.request
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import date
from pathlib import Path

# ── Config ───────────────────────────────────────────────────────────────────

R       = Path(__file__).parent.parent.resolve()
TODAY   = date.today().isoformat()
OUT     = R / "inbox" / f"{TODAY}_gemini-audit.md"
KEY     = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY", "")
MODELS  = {
    "flash":   os.environ.get("GEMINI_FLASH",    "gemini-2.5-flash"),
    "promax":  os.environ.get("GEMINI_PRO_MAX",  "gemini-3.1-pro-preview"),
}
RPM     = {"flash": 800, "promax": 20}  # conservative (80% of actual limits)
MAXOUT  = {"flash": 8192, "promax": 8192}
TEMP    = {"flash": 0.15, "promax": 0.2}
FILE_CAP = 6000   # per-file char cap for API context

# ── Utilities ────────────────────────────────────────────────────────────────

def rf(p: Path, cap: int = FILE_CAP) -> str:
    try:
        t = p.read_text("utf-8", errors="replace")
        return t[:cap] + "\n[TRUNCATED]" if len(t) > cap else t
    except Exception as e: return f"[UNREADABLE: {e}]"

def sh(cmd: str) -> str:
    try:
        r = subprocess.run(["bash", "-c", cmd], cwd=R, capture_output=True, text=True, timeout=60)
        return (r.stdout + r.stderr).strip() or "(empty)"
    except Exception as e: return f"[ERR: {e}]"

def extract_fm(p: Path) -> dict:
    try:
        t = p.read_text("utf-8", errors="replace")[:2000]
        m = re.match(r'^---\n(.*?)\n---', t, re.DOTALL)
        if not m: return {}
        fm = {}
        for line in m.group(1).split('\n'):
            if ':' in line:
                k, v = line.split(':', 1)
                fm[k.strip()] = v.strip().strip('"').strip("'")
        return fm
    except: return {}

def extract_links(p: Path) -> list:
    try:
        t = p.read_text("utf-8", errors="replace")
        return re.findall(r'\[\[([^\]|]+)', t)
    except: return []

# ── Rate Limiter ─────────────────────────────────────────────────────────────

class RL:
    _ts: dict = defaultdict(list)
    _lock = threading.Lock()
    @classmethod
    def wait(cls, tier: str):
        with cls._lock:
            now = time.time()
            q = cls._ts[tier]
            q[:] = [t for t in q if now - t < 60]
            lim = RPM.get(tier, 20)
            if len(q) >= lim:
                w = 60 - (now - q[0]) + 1.5
                print(f"    ⏳ RPM limit ({tier}): {w:.0f}s", flush=True)
                time.sleep(w)
            q.append(time.time())

# ── Gemini Client ────────────────────────────────────────────────────────────

def gemini(prompt: str, tier: str, label: str, retries: int = 2,
           validate_fn=None) -> str:
    """Call Gemini API with optional schema-enforcement retry.

    validate_fn: callable(str) -> bool — if provided, the response is tested
    after the first successful call. If it fails, one format-enforcement retry
    is performed with the original prompt plus a strict reminder suffix. The
    retry attempt is logged to stdout. validate_fn does NOT count against the
    HTTP retries budget.
    """
    FORMAT_SUFFIX = (
        "\n\n---\nFORMAT ENFORCEMENT: Your previous response did not follow the "
        "required format. Respond ONLY with the table format specified. Include "
        "the required markers (e.g. 'Area Score:', table pipes '|'). Do not add "
        "preamble or explanation — start directly with the table."
    )
    _schema_retried: list = []  # track which labels needed a schema retry

    model = MODELS[tier]
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={KEY}"

    def _call(p: str) -> str:
        body = json.dumps({
            "contents": [{"parts": [{"text": p}]}],
            "generationConfig": {"temperature": TEMP[tier], "maxOutputTokens": MAXOUT[tier]},
        }).encode()
        for att in range(retries + 1):
            RL.wait(tier)
            t0 = time.time()
            try:
                req = urllib.request.Request(url, data=body, headers={"Content-Type": "application/json"})
                with urllib.request.urlopen(req, timeout=300) as resp:
                    txt = json.loads(resp.read().decode())["candidates"][0]["content"]["parts"][0]["text"]
                    dt = time.time() - t0
                    print(f"    ✓ {label} ({len(txt):,}ch, {dt:.0f}s)", flush=True)
                    return txt
            except urllib.error.HTTPError as e:
                err = e.read().decode("utf-8", errors="replace")[:300]
                if e.code == 429 and att < retries:
                    time.sleep(30 * (att + 1)); continue
                if e.code >= 500 and att < retries:
                    time.sleep(5); continue
                print(f"    ✗ {label} HTTP {e.code}", flush=True)
                return f"[API ERROR {e.code}: {err}]"
            except Exception as e:
                if att < retries: time.sleep(5); continue
                print(f"    ✗ {label} {e}", flush=True)
                return f"[FAILED: {e}]"
        return "[EXHAUSTED]"

    txt = _call(prompt)

    # Schema enforcement: if validate_fn provided and response is malformed, retry once
    if validate_fn is not None and not validate_fn(txt):
        print(f"    ! {label} schema check FAILED — retrying with format enforcement", flush=True)
        enforced = _call(prompt + FORMAT_SUFFIX)
        if validate_fn(enforced):
            print(f"    ✓ {label} schema retry PASSED", flush=True)
            return enforced
        else:
            print(f"    ! {label} schema retry still malformed — using original", flush=True)
            return txt + "\n\n> [AUDIT-META] Schema enforcement retry failed for this agent."

    return txt

def list_models():
    url = f"https://generativelanguage.googleapis.com/v1beta/models?key={KEY}&pageSize=100"
    with urllib.request.urlopen(url, timeout=15) as resp:
        for m in sorted(json.loads(resp.read().decode()).get("models", []), key=lambda x: x["name"]):
            if "generateContent" in m.get("supportedGenerationMethods", []):
                print(f"  {m['name'].replace('models/',''):<55} {m.get('displayName','')}")

# ── Phase 1.5 / 2.5 — Claim Verification ────────────────────────────────────

# Regex patterns for file-path extraction from agent markdown output.
# Matches:
#   - backtick-quoted paths:  `path/to/file.md`
#   - markdown code spans:    `scripts/foo.sh`
#   - bare path-like tokens:  scripts/foo.sh  or  .claude/rules/bar.md
#   All must contain at least one '/' and a file extension, to avoid false positives
#   on short identifiers.
_PATH_RE = re.compile(
    r'`([a-zA-Z_.][a-zA-Z0-9_.\-/]+\.[a-zA-Z]{1,6})`'   # backtick-quoted
    r'|(?<![`\w/])([a-zA-Z_.][a-zA-Z0-9_.\-/]+\.[a-zA-Z]{1,6})(?![`\w/])'  # bare token
)

def _extract_paths(text: str) -> list[str]:
    """Return deduplicated list of file-path-like strings found in text."""
    paths = []
    for m in _PATH_RE.finditer(text):
        p = m.group(1) or m.group(2)
        # Heuristic filter: must contain '/' (so plain words like "yes.no" are excluded)
        if "/" in p and not p.startswith("http"):
            paths.append(p)
    return list(dict.fromkeys(paths))  # deduplicate, preserve order

def verify_claims(text: str, manifest: dict) -> tuple[str, dict]:
    """Extract all file-path references from agent text and verify them on disk.

    For each extracted path:
      [VERIFIED]     — file exists in manifest (was tracked by Phase 0)
      [DISPUTED]     — path looks plausible but is not in manifest (may be stale)
      [HALLUCINATED] — path has no partial match in any manifest key

    Returns:
      annotated_text  — original text with inline tags appended after each matched path
      stats           — {"verified": N, "disputed": N, "hallucinated": N, "paths": [...]}
    """
    manifest_keys = set(manifest.get("files", {}).keys())
    # Build a lowercase stem set for partial / alias matching
    manifest_stems = {Path(k).name for k in manifest_keys} | {Path(k).stem for k in manifest_keys}

    raw_paths = _extract_paths(text)
    stats: dict = {"verified": 0, "disputed": 0, "hallucinated": 0, "paths": []}

    def _tag(p: str) -> str:
        # Normalise: strip leading './'
        norm = p.lstrip("./")
        if norm in manifest_keys or p in manifest_keys:
            stats["verified"] += 1
            tag = "[VERIFIED]"
        elif Path(p).name in manifest_stems or Path(p).stem in manifest_stems:
            stats["disputed"] += 1
            tag = "[DISPUTED]"
        else:
            stats["hallucinated"] += 1
            tag = "[HALLUCINATED]"
        stats["paths"].append({"path": p, "tag": tag})
        return tag

    # Annotate text: append tag after every matched path occurrence
    annotated = text
    # Track replacement offsets to avoid double-replacing
    seen: set[str] = set()
    for p in raw_paths:
        if p in seen:
            continue
        seen.add(p)
        tag = _tag(p)
        # Replace the first occurrence of the path (backtick or bare) with path+tag
        # Use a non-greedy replacement that preserves surrounding punctuation
        escaped = re.escape(p)
        annotated = re.sub(
            rf'(`{escaped}`|(?<![`\w/]){escaped}(?![`\w/]))',
            lambda m, _t=tag: m.group(0) + f" {_t}",
            annotated,
            count=0,  # annotate ALL occurrences
        )

    summary = (
        f"\n\n> **Claim Verification Summary:** "
        f"{stats['verified']} [VERIFIED], "
        f"{stats['disputed']} [DISPUTED], "
        f"{stats['hallucinated']} [HALLUCINATED] "
        f"across {len(raw_paths)} extracted file-path claims.\n"
    )
    annotated += summary
    return annotated, stats

# ── Confidence Tagging ───────────────────────────────────────────────────────

# Keywords that signal the line is derived from Phase 0 machine data
_MACHINE_KEYWORDS = re.compile(
    r'\b(md_files|scripts|hooks|skills|rules|tracked|counts?|wikilinks?|orphan|'
    r'pre-?flight|validate-?blueprint|pkb-?lint|git (status|log|ahead)|'
    r'frontmatter|lines?:\s*\d|version:\s*[\"\d]|status:\s*(draft|validated|in-review|in-progress|archived))\b',
    re.IGNORECASE
)

def tag_confidence(text: str, manifest: dict) -> str:
    """Post-process Phase 1-2 output to tag each non-empty line with a confidence level.

    Tagging rules (applied in priority order):
      [MACHINE]     — line references Phase 0 counts or machine-verified data
      [ANALYZED]    — line contains a [VERIFIED] tag (set by verify_claims)
      [SPECULATIVE] — everything else (no verifiable file evidence)

    Lines that are already tagged, blank, pure markdown structure (headers, HR, table
    separators, fenced code fences) are left unchanged.
    """
    # already_tagged matches ONLY confidence tags produced by this function itself,
    # so lines are not double-tagged on re-runs. Claim tags ([VERIFIED] etc.) from
    # verify_claims are INPUT signals — they must not suppress tagging.
    already_tagged = re.compile(r'<!--\s*\[(MACHINE|ANALYZED|SPECULATIVE)\]\s*-->')
    skip_line = re.compile(r'^\s*(#{1,6}\s|[-*]{3,}|\|[-| ]+\||\s*```|>\s*\*\*Claim)')

    lines = text.split("\n")
    tagged: list[str] = []
    for line in lines:
        if not line.strip() or skip_line.match(line) or already_tagged.search(line):
            tagged.append(line)
            continue

        if "[VERIFIED]" in line:
            # Line has at least one claim-verified path — elevate to ANALYZED.
            # Check this before MACHINE so a concrete file reference wins over
            # a keyword-pattern match (e.g. "scripts/foo.sh [VERIFIED]" should
            # be ANALYZED, not MACHINE, even though "scripts" is a machine keyword).
            tagged.append(f"{line}  <!-- [ANALYZED] -->")
        elif _MACHINE_KEYWORDS.search(line):
            tagged.append(f"{line}  <!-- [MACHINE] -->")
        else:
            tagged.append(f"{line}  <!-- [SPECULATIVE] -->")

    return "\n".join(tagged)

# ── Schema Validation Helpers (Phase 1-2) ────────────────────────────────────

def _validate_area_response(txt: str) -> bool:
    """Return True if a Phase 1 area-audit response has the expected structure."""
    if len(txt) < 500:
        return False
    has_score = bool(re.search(r'Area Score\s*:', txt, re.IGNORECASE))
    has_table = "|" in txt
    return has_score and has_table

def _validate_crosscut_response(txt: str) -> bool:
    """Return True if a Phase 2 cross-cut response has the expected structure."""
    if len(txt) < 500:
        return False
    has_score = bool(re.search(r'Score\s*:', txt, re.IGNORECASE))
    has_table = "|" in txt
    return has_score and has_table

# ── PHASE 0 — Local Extraction ($0) ─────────────────────────────────────────

def phase0() -> dict:
    """Deterministic local extraction — frontmatter, links, counts, validation scripts."""
    print("\n═══ PHASE 0: LOCAL EXTRACTION (Python, $0) ═══", flush=True)
    manifest = {"files": {}, "wikilinks_all": [], "orphans": [], "validations": {}}

    # Scan all tracked .md files
    tracked = sh("git ls-files -- '*.md'").split('\n')
    for rel in tracked:
        if not rel.strip(): continue
        p = R / rel
        fm = extract_fm(p)
        lnks = extract_links(p)
        manifest["files"][rel] = {
            "fm": fm,
            "links": lnks,
            "lines": sum(1 for _ in open(p, errors="replace")) if p.exists() else 0,
        }
        manifest["wikilinks_all"].extend(lnks)

    # Scan scripts
    for ext in ("*.sh", "*.py"):
        for s in (R / "scripts").glob(ext):
            rel = str(s.relative_to(R))
            hdr = ""
            try:
                with open(s) as f:
                    for line in f:
                        if line.startswith("#"): hdr += line
                        elif hdr: break
            except: pass
            manifest["files"][rel] = {"header": hdr[:500], "lines": sum(1 for _ in open(s, errors="replace"))}

    # Add ALL tracked files to manifest (not just .md) for verify_claims coverage.
    # Without this, every .sh / .py / .json reference in agent output is tagged
    # [HALLUCINATED] because only .md files were scanned above.
    all_tracked = sh("git ls-files").split('\n')
    for rel in all_tracked:
        if not rel.strip(): continue
        if rel not in manifest["files"]:
            manifest["files"][rel] = {"fm": {}, "links": [], "lines": 0}

    # Counts
    manifest["counts"] = {
        "md_files": len([f for f in manifest["files"] if f.endswith(".md")]),
        "scripts": int(sh("find scripts/ -name '*.sh' -o -name '*.py' | wc -l").strip()),
        "hooks": int(sh("find .claude/hooks/ -name '*.sh' | wc -l").strip()),
        "skills": int(sh("find .claude/skills/ -name 'SKILL.md' | wc -l").strip()),
        "rules": int(sh("find .claude/rules/ -name '*.md' ! -name 'README.md' | wc -l").strip()),
        "tracked": int(sh("git ls-files | wc -l").strip()),
        "all_manifest_paths": len(manifest["files"]),
    }

    # Run validation scripts (capture output)
    print("  Running validation scripts...", flush=True)
    for ws in ["1-ALIGN", "2-LEARN", "3-PLAN", "4-EXECUTE", "5-IMPROVE"]:
        manifest["validations"][f"preflight-{ws}"] = sh(f"bash scripts/pre-flight.sh {ws} 2>&1 | tail -15")
    manifest["validations"]["validate-blueprint"] = sh("python3 scripts/validate-blueprint.py 2>&1 | tail -20")
    manifest["validations"]["pkb-lint"] = sh("bash scripts/pkb-lint.sh 2>&1 | tail -15")

    # Wikilink orphan check
    all_stems = {Path(f).stem for f in manifest["files"]}
    all_aliases = set()
    for f, d in manifest["files"].items():
        for alias in d.get("fm", {}).get("aliases", "").strip("[]").split(","):
            alias = alias.strip().strip("'\"")
            if alias: all_aliases.add(alias)
    targets = all_stems | all_aliases
    used = set(manifest["wikilinks_all"])
    manifest["orphans"] = sorted(used - targets)[:50]

    # Git state
    manifest["git"] = {
        "ahead": sh("git rev-list --count HEAD...origin/main 2>/dev/null || echo '?'"),
        "status": sh("git status --short"),
        "log": sh("git log --oneline -10"),
        "untracked": sh("git ls-files --others --exclude-standard"),
    }

    n = manifest["counts"]
    print(f"  {n['md_files']} md files | {n['scripts']} scripts | {n['hooks']} hooks | "
          f"{n['skills']} skills | {n['rules']} rules | {n['tracked']} tracked", flush=True)
    print(f"  {len(manifest['orphans'])} orphan wikilinks | 5 pre-flights + 2 validators run", flush=True)
    print("  Phase 0 complete.\n", flush=True)
    return manifest

# ── Primers (shared context for all Gemini agents) ───────────────────────────

PRIMER = """## Claude Code Architecture (for non-Claude auditors)

Claude Code is an AI CLI. This template's automation relies on:

**Hooks** (29 registered in .claude/settings.json) — shell scripts that fire on events:
SessionStart(3), PreToolUse(13), PostToolUse(6), SubagentStop(2), PreCompact(1), Stop(3), UserPromptSubmit(1).
Example: `status-guard.sh` blocks `status: validated` at pre-commit — only human can validate.

**Skills** (28 in .claude/skills/) — slash commands invoked via `/command`. Loaded on demand.
Key: `/dsbv` (DSBV lifecycle), `/learn` (6-state pipeline), `/ingest` (PKB), `/git-save` (commits).

**Rules** (12 in .claude/rules/) — always-on markdown auto-loaded every session. Define naming, versioning, routing.

**Agents** (4 in .claude/agents/) — sub-agent definitions dispatched via Agent() tool:
ltc-explorer(Haiku/research), ltc-planner(Opus/design), ltc-builder(Sonnet/build), ltc-reviewer(Opus/validate).
EP-13: Only orchestrator dispatches. Sub-agents NEVER dispatch sub-agents.

**Enforcement tier:** hooks > scripts > rules > skills (strongest→weakest).

## ALPEI × DSBV × 4-Subsystem Architecture

**5 Workstreams (ALPEI):** ALIGN→LEARN→PLAN→EXECUTE→IMPROVE
Chain-of-custody: WS N needs N-1 validated before Build. 2-LEARN uses 6-state pipeline, NOT DSBV.

**4 Subsystems:** 1-PD(Problem Diagnosis)→2-DP(Data Pipeline)→3-DA(Data Analysis)→4-IDM(Insights & Decisions)
PD governs all. Downstream cannot exceed upstream version. _cross = cross-cutting.

**DSBV:** Design→Sequence→Build→Validate. Human gates G1-G4. DESIGN.md+SEQUENCE.md at subsystem level. VALIDATE.md at workstream root.

**Key rules:** S>E>Sc priority. YAML frontmatter required (version, status, last_updated). Status: draft→in-progress→in-review→validated(human only).

**Bootstrap design:** This template ships as a minimal skeleton. DSBV artifacts generated on-demand via `/dsbv`. Only READMEs + cross-cutting registers are pre-populated.

**Desired outcomes per workstream:**
1-ALIGN: Charter, OKRs, ADRs, stakeholder map — defines WHAT and WHY
2-LEARN: Effective Principles, UBS/UDS analysis — researches forces
3-PLAN: Architecture, roadmap, risk/driver registers — designs HOW
4-EXECUTE: Source, tests, config, docs — builds artifacts
5-IMPROVE: Changelog, metrics, retros, reviews — iterates
"""

# ── PHASE 1 — Per-Area Content Audit (Flash) ────────────────────────────────

AREAS = [
    ("1-ALIGN",          "1-ALIGN/",        "Charter, OKRs, ADRs, stakeholder map per subsystem. _cross has shared decisions. Each subsystem dir should have README. Populated files should have correct frontmatter and meaningful content."),
    ("2-LEARN",          "2-LEARN/",        "6-state pipeline (input→research→specs→output→archive). NO DSBV files. Effective Principles evidence-backed. UBS/UDS analysis with force categorization."),
    ("3-PLAN",           "3-PLAN/",         "Architecture docs, UBS_REGISTER.md, UDS_REGISTER.md in _cross. Per-subsystem roadmaps, risk registers. All should reference upstream ALIGN decisions."),
    ("4-EXECUTE",        "4-EXECUTE/",      "Source, tests, config, docs per subsystem. _cross for shared execution artifacts. Build outputs should be traceable to PLAN architecture."),
    ("5-IMPROVE",        "5-IMPROVE/",      "Changelogs, metrics baselines (S/E/Sc), retro templates, review stubs. _cross has cross-changelog and feedback register."),
    ("genesis-fw",       "_genesis/frameworks/", "9 canonical frameworks (Vinh's). Process map (alpei-dsbv-process-map.md + parts). All should have frontmatter. Paths in process map must match filesystem-routing."),
    ("genesis-tmpl",     "_genesis/templates/",  "Templates for every DSBV artifact type. Learning book pages (P0-P7). DSBV context template. Check completeness vs process map claims."),
    ("genesis-sops",     "_genesis/sops/",       "Standard Operating Procedures. The main SOP should match actual repo state (counts, paths, workflow). Migration guide, setup guide."),
    ("claude-skills",    ".claude/skills/",      "28 skill dirs, each with SKILL.md (required). Check: frontmatter present, script refs resolve, gotchas.md where needed. Key skills: /dsbv, /learn, /ingest, /git-save."),
    ("claude-gov",       ".claude/",             "Rules (12), agents (4), hooks (15 scripts), settings.json (29 registrations). Check: hook scripts exist for every settings.json entry. Rule files cover naming, versioning, routing, dispatch, enforcement."),
    ("scripts-root",     "scripts/",             "53 scripts. Each .sh/.py should have version header comment. Check script-registry.md lists all. No orphan scripts. Pre-flight, template-check, validate-blueprint critical."),
    ("root-config",      "",                     "Root-level files: README.md, CLAUDE.md, AGENTS.md, GEMINI.md, codex.md, CHANGELOG.md, VERSION. These are the first things a PM sees. Check: counts accurate, links valid, bootstrap note present, iteration version correct."),
    ("genesis-other",    "_genesis/",            "Remaining _genesis/ subdirs: brand, compliance, culture, governance, guides, obsidian, philosophy, principles, reference, scripts, security, tools, training. Organizational knowledge. Check: frontmatter, content quality, not orphaned."),
    ("rules-fullspec",   "rules/",               "Full-spec rule files (on-demand, not auto-loaded). 8 files covering: agent-system, brand-identity, filesystem-routing, general-system, naming-convention, security-rules, tool-routing. Check: consistent with .claude/rules/ summaries."),
    ("cursor-config",    ".cursor/",             "Cursor IDE config: 11 rule files in rules/. Should mirror CLAUDE.md key sections: DSBV, enforcement, routing, naming, agent roster. Check: parity with .claude/rules/."),
    ("pkb-vault",        "PERSONAL-KNOWLEDGE-BASE/", "Personal Knowledge Base: Capture→Distill→Express pipeline. README, dashboard, captured/, distilled/. Check: README documents auto-recall, frontmatter lowercase, no stale content."),
    ("vault-other",      "",                     "Vault dirs: DAILY-NOTES/, inbox/, MISC-TASKS/, PEOPLE/. Light scaffolding. Check: READMEs exist, .gitkeep files present, no personal data leaked."),
]

def gather_area_files(prefix: str, name: str = "") -> str:
    """Read all files in an area and return formatted content."""
    parts = []
    # Handle special areas
    if prefix == "" and name == "root-config":
        # Root-level files only (not dirs)
        files = sorted(f for f in R.iterdir() if f.is_file() and f.suffix in (".md", ".json", ".yml"))
    elif prefix == "" and name == "vault-other":
        # Vault dirs: DAILY-NOTES, inbox, MISC-TASKS, PEOPLE
        files = []
        for d in ["DAILY-NOTES", "inbox", "MISC-TASKS", "PEOPLE"]:
            dp = R / d
            if dp.exists():
                files.extend(sorted(dp.rglob("*")))
    elif name == "genesis-other":
        # _genesis/ dirs NOT already covered by genesis-fw, genesis-tmpl, genesis-sops
        covered = {"frameworks", "templates", "sops"}
        files = []
        for d in sorted((R / "_genesis").iterdir()):
            if d.is_dir() and d.name not in covered:
                files.extend(sorted(d.rglob("*")))
        # Also include root-level _genesis files
        files.extend(sorted(f for f in (R / "_genesis").iterdir() if f.is_file()))
    else:
        p = R / prefix
        if not p.exists(): return "(directory not found)"
        files = sorted(p.rglob("*"))

    for f in files:
        if f.is_dir() or ".git" in str(f): continue
        rel = str(f.relative_to(R))
        if f.suffix in (".md", ".sh", ".py", ".json", ".yml", ".yaml", ".css", ".html", ".base"):
            content = rf(f, FILE_CAP)
            parts.append(f"### FILE: {rel} ({sum(1 for _ in open(f, errors='replace'))} lines)\n```\n{content}\n```\n")
        else:
            parts.append(f"### FILE: {rel} (binary/other — skipped)\n")
        if len("\n".join(parts)) > 80000:  # safety cap per area
            parts.append(f"\n[... more files truncated for context budget ...]\n")
            break
    return "\n".join(parts) if parts else "(no files found)"

def area_prompt(name: str, expect: str, files_content: str, manifest_excerpt: str) -> str:
    return f"""{PRIMER}

## YOUR TASK: Audit area "{name}"

You are auditing EVERY file in this area. Read each file line by line. Check for:

1. **Content Quality**: Is the content meaningful or just a stub/placeholder? Does it fulfill its stated purpose?
2. **Frontmatter Correctness**: version (MAJOR.MINOR), status (draft|in-progress|in-review|validated|archived), last_updated (YYYY-MM-DD). All lowercase except work_stream (1-ALIGN format).
3. **Internal Consistency**: Do sections reference things that exist? Are there dead links or phantom paths?
4. **Completeness for LTC PM**: If a PM followed the SOP and arrived at this area, would they find what they need? What's missing?
5. **Security**: Any hardcoded secrets, PII, or sensitive data?

**Expected content for this area:** {expect}

**Manifest data for cross-reference:**
```
{manifest_excerpt}
```

**FILES IN THIS AREA (read every one):**

{files_content}

## OUTPUT FORMAT

For each file, write ONE line: `[PASS|WARN|FAIL] path — reason`

Then a summary table of findings:
| # | File | Severity | What (descriptive) | Why (root cause) | Risk (if unfixed) | Fix (prescriptive) |

End with: **Area Score: X/100** and **PM-Ready: YES/NO**
"""

def phase1(manifest: dict) -> tuple:
    """Run 11 area agents in parallel batches.

    Returns (combined_str, results_dict) where results_dict is {area_name: text}
    needed by reconcile().
    """
    print(f"═══ PHASE 1: CONTENT AUDIT (Flash×{len(AREAS)}, parallel batches) ═══", flush=True)
    results = {}

    def run_area(name, prefix, expect):
        files_content = gather_area_files(prefix, name=name)
        # Build manifest excerpt for this area
        area_files = {k: v for k, v in manifest["files"].items() if k.startswith(prefix)}
        excerpt = json.dumps({"files_in_area": len(area_files),
                              "validations": {k: v for k, v in manifest["validations"].items()
                                              if name.split("-")[0].upper() in k.upper()}},
                             indent=1)[:2000]
        prompt = area_prompt(name, expect, files_content, excerpt)
        return gemini(prompt, "flash", f"P1-{name}", validate_fn=_validate_area_response)

    # Run in parallel batches of 4 to respect TPM
    for batch_start in range(0, len(AREAS), 4):
        batch = AREAS[batch_start:batch_start + 4]
        with ThreadPoolExecutor(max_workers=4) as pool:
            futs = {pool.submit(run_area, n, p, e): n for n, p, e in batch}
            for f in as_completed(futs):
                results[futs[f]] = f.result()
        if batch_start + 4 < len(AREAS):
            time.sleep(2)  # TPM pacing between batches

    combined = "\n\n---\n\n".join(f"### {k}\n\n{v}" for k, v in sorted(results.items()))
    print("  Phase 1 complete.\n", flush=True)
    # Return both the combined string AND the raw per-area dict so reconcile() can use it.
    return combined, results

# ── PHASE 1.R — Cross-Agent Reconciliation (Gap 4) ───────────────────────────

# Matches file-path-like tokens in free-form agent markdown.
# Must contain '/' (avoids "foo.bar" identifiers) and a short extension.
_RECON_PATH_RE = re.compile(
    r'`([A-Za-z_.][A-Za-z0-9_./\-]*\.[A-Za-z]{1,10})`'             # backtick-quoted
    r'|(?<![`\w/])([A-Za-z_.][A-Za-z0-9_./\-]*\.[A-Za-z]{1,10})(?![`\w/])',  # bare token
)

# Claim pattern: a path mentioned on the same line as version/status/last_updated.
_RECON_CLAIM_RE = re.compile(
    r'([A-Za-z_.][A-Za-z0-9_./\-]*\.[A-Za-z]{1,10})'
    r'.*?'
    r'(?:version[:\s]+([0-9]+\.[0-9]+)|status[:\s]+([\w-]+)|last_updated[:\s]+([\d]{4}-[\d]{2}-[\d]{2}))',
    re.IGNORECASE,
)


def reconcile(results: dict) -> tuple:
    """Scan all Phase 1 agent outputs for cross-agent contradictions (Gap 4).

    Args:
        results: {area_name: agent_output_text}

    Returns:
        (summary_text: str, conflicts: list[str])
          summary_text — human-readable reconciliation block for Phase 3 context
          conflicts    — list of [CONFLICT] strings, one per detected contradiction
    """
    print("  Phase 1.R: reconciling cross-agent claims...", flush=True)

    agent_paths: dict = {}   # agent -> set of path strings
    agent_claims: dict = {}  # agent -> {path -> {claim_type -> value}}

    for agent, text in results.items():
        paths: set = set()
        claims: dict = {}
        for m in _RECON_PATH_RE.finditer(text):
            p = (m.group(1) or m.group(2) or "").strip()
            if len(p) > 4 and "/" in p and "://" not in p:
                paths.add(p)
        for m in _RECON_CLAIM_RE.finditer(text):
            path = m.group(1).strip()
            ver, status, dt = m.group(2), m.group(3), m.group(4)
            if "/" not in path:
                continue  # skip non-path tokens
            if path not in claims:
                claims[path] = {}
            if ver:    claims[path]["version"] = ver
            if status: claims[path]["status"]  = status.lower()
            if dt:     claims[path]["date"]     = dt
        agent_paths[agent] = paths
        agent_claims[agent] = claims

    # Build overlap map: path -> [agents that mentioned it]
    all_paths: dict = {}
    for agent, paths in agent_paths.items():
        for p in paths:
            all_paths.setdefault(p, []).append(agent)
    overlap_paths = {p: ags for p, ags in all_paths.items() if len(ags) >= 2}

    # Detect typed-claim contradictions
    conflicts: list = []
    for path, mentioning_agents in sorted(overlap_paths.items()):
        typed: dict = {}  # claim_type -> {value -> [agents]}
        for agent in mentioning_agents:
            for claim_type, value in agent_claims.get(agent, {}).get(path, {}).items():
                typed.setdefault(claim_type, {}).setdefault(value, []).append(agent)
        for claim_type, value_map in typed.items():
            if len(value_map) > 1:
                parts = [f"{', '.join(sorted(ags))} says {claim_type}={val}"
                         for val, ags in sorted(value_map.items())]
                conflicts.append(f"[CONFLICT] `{path}` — {' | '.join(parts)}")

    n_overlap = len(overlap_paths)
    n_conflicts = len(conflicts)
    summary = (
        f"**Phase 1.R Reconciliation:** "
        f"{n_overlap} file(s) mentioned by multiple agents, "
        f"{n_conflicts} contradiction(s) found.\n"
    )
    if conflicts:
        summary += "\n### Cross-Agent Conflicts\n\n" + "\n".join(f"- {c}" for c in conflicts) + "\n"
    else:
        summary += "\nNo contradictions detected between Phase 1 agents.\n"

    print(f"    Reconciliation: {n_overlap} overlapping paths, {n_conflicts} conflicts",
          flush=True)
    return summary, conflicts


# ── PHASE 2 — Cross-Cutting Integrity (Flash) ───────────────────────────────

def phase2(manifest: dict, phase1_results: str) -> str:
    print("═══ PHASE 2: CROSS-CUTTING (Flash×5, parallel) ═══", flush=True)

    prompts = {
        "P2-Wikilinks": f"""{PRIMER}\n\n## TASK: Wikilink Integrity Audit
Check ALL wikilinks in this repo for broken references.

**Orphan wikilinks (targets not found as file stems or aliases):**
{json.dumps(manifest['orphans'][:30])}

**Total unique wikilinks used:** {len(set(manifest['wikilinks_all']))}
**Total file stems available:** {len({Path(f).stem for f in manifest['files']})}

**Sample of files with most wikilinks:**
{json.dumps({k: len(v.get('links', [])) for k, v in sorted(manifest['files'].items(), key=lambda x: -len(x[1].get('links', [])))[:15]}, indent=1)}

Report: each orphan link, where it's used, severity, fix. Table format.
End with: **Link Integrity Score: X/100**""",

        "P2-ProcessMap": f"""{PRIMER}\n\n## TASK: Process Map × Filesystem Alignment
The process map (_genesis/frameworks/alpei-dsbv-process-map.md) defines deliverable paths.
Check every path it claims against the actual directory tree.

**Process map content:**
{rf(R / '_genesis/frameworks/alpei-dsbv-process-map.md', 8000)}

**Filesystem routing rule:**
{rf(R / '.claude/rules/filesystem-routing.md', 3000)}

**Actual directory tree:**
```
{sh("find . -maxdepth 4 -type d -not -path './.git/*' -not -path './.obsidian/*' | sort")}
```

Report: each path in process map, exists? Y/N, severity. Table format.
End with: **Process Map Alignment Score: X/100**""",

        "P2-HookChain": f"""{PRIMER}\n\n## TASK: Hook Chain Verification
Verify: settings.json hook entries → hook scripts exist → target scripts exist.

**settings.json hook registrations:**
{rf(R / '.claude/settings.json', 8000)}

**Hook scripts on disk:**
```
{sh("ls -la .claude/hooks/*.sh 2>/dev/null")}
```

**Script registry claims:**
{rf(R / '.claude/rules/script-registry.md', 6000)[:4000]}

Report: each hook entry in settings.json → script exists? → script it calls exists?
End with: **Hook Chain Score: X/100**""",

        "P2-Versions": f"""{PRIMER}\n\n## TASK: Version & Status Audit
Check frontmatter consistency across ALL files.

**Version registry (source of truth):**
{rf(R / '_genesis/version-registry.md', 6000)}

**Sample frontmatter from all areas (extracted by Python — ground truth):**
{json.dumps({k: v.get('fm', {}) for k, v in list(manifest['files'].items())[:60]}, indent=1)[:6000]}

**Versioning rules:**
{rf(R / '.claude/rules/versioning.md', 3000)}

Check: invalid status values, status:validated without human, version format errors, stale dates.
Report table. End with: **Version Integrity Score: X/100**""",

        "P2-Naming": f"""{PRIMER}\n\n## TASK: Naming Convention Compliance
Check file and directory names against UNG grammar: {{SCOPE}}_{{FA}}.{{ID}}.{{NAME}}
Separators: _ = scope boundary, . = numeric level, - = word join.

**Naming rules:**
{rf(R / '.claude/rules/naming-rules.md', 2000)}

**All tracked file paths (check each):**
```
{sh("git ls-files | head -200")}
```

**Directory structure:**
```
{sh("find . -maxdepth 3 -type d -not -path './.git/*' | sort")}
```

Check: workstream dirs (N-NAME in CAPS like 1-ALIGN), subsystem dirs (N-CODE like 1-PD), file naming patterns.
Report: violations only. Table format. End with: **Naming Score: X/100**""",
    }

    results = {}
    with ThreadPoolExecutor(max_workers=5) as pool:
        futs = {pool.submit(gemini, p, "flash", lbl,
                            validate_fn=_validate_crosscut_response): lbl
                for lbl, p in prompts.items()}
        for f in as_completed(futs):
            results[futs[f]] = f.result()

    combined = "\n\n---\n\n".join(f"### {k}\n\n{v}" for k, v in sorted(results.items()))
    print("  Phase 2 complete.\n", flush=True)
    return combined

# ── PHASE 3 — PM Walkthrough + Debate + Synthesis (ProMax) ──────────────────

def phase3(manifest: dict, p1: str, p2: str,
           verify_stats: dict | None = None,
           conflicts: list | None = None,
           prior: dict | None = None) -> tuple[str, str]:
    """Run Phase 3 synthesis agents.

    verify_stats: combined claim-verification stats from Phase 1.5 + 2.5.
    conflicts: list of [CONFLICT] strings from reconcile() (Gap 4).
    prior: parsed prior audit dict from load_prior_audit() (Gap 5).
    """
    print("═══ PHASE 3: SYNTHESIS (ProMax×5, sequential) ═══", flush=True)

    findings = f"## PHASE 1 FINDINGS (per-area):\n{p1[:8000]}\n\n## PHASE 2 FINDINGS (cross-cutting):\n{p2[:6000]}"
    counts = json.dumps(manifest["counts"])
    vals = json.dumps({k: v[:200] for k, v in manifest["validations"].items()})
    verify_block = ""
    if verify_stats:
        verify_block = (
            f"\n**Claim Verification (Phase 1.5 + 2.5):**\n"
            f"P1: {verify_stats.get('p1_verified', 0)} [VERIFIED], "
            f"{verify_stats.get('p1_disputed', 0)} [DISPUTED], "
            f"{verify_stats.get('p1_hallucinated', 0)} [HALLUCINATED]\n"
            f"P2: {verify_stats.get('p2_verified', 0)} [VERIFIED], "
            f"{verify_stats.get('p2_disputed', 0)} [DISPUTED], "
            f"{verify_stats.get('p2_hallucinated', 0)} [HALLUCINATED]\n"
            f"IMPORTANT: The findings above are tagged [MACHINE]/[ANALYZED]/[SPECULATIVE]. "
            f"PRESERVE these tags in your report. Surface all [SPECULATIVE] findings "
            f"with a warning that they lack verifiable file evidence.\n"
        )

    # Reconciliation block (Gap 4)
    reconcile_block = ""
    if conflicts:
        reconcile_block = (
            f"\n**Cross-Agent Conflicts (Phase 1.R) — {len(conflicts)} contradiction(s):**\n"
            + "\n".join(f"  {c}" for c in conflicts[:10])
            + ("\n  ...(truncated)" if len(conflicts) > 10 else "")
            + "\nIMPORTANT: Where two agents made contradictory claims, treat the "
            "[MACHINE] tagged version as authoritative. Flag unresolved conflicts "
            "explicitly in your Gap Analysis.\n"
        )

    # Regression block (Gap 5)
    regression_block = ""
    if prior:
        prior_date    = prior.get("date", "unknown")
        prior_verdict = prior.get("verdict", "UNKNOWN")
        prior_scores  = prior.get("scores", {})
        prior_count   = prior.get("finding_count", 0)
        score_str = ", ".join(f"{d}={v}" for d, v in sorted(prior_scores.items())) if prior_scores else "unknown"
        regression_block = (
            f"\n**Regression Context (prior audit: {prior_date}):**\n"
            f"Prior verdict: {prior_verdict} | Prior gap-row count: {prior_count} | "
            f"Prior scores: {score_str}\n"
            "When writing §1 Executive Summary, explicitly state whether this audit "
            "represents an improvement, decline, or stable state vs prior. "
            "Flag any recurring issues (present in both audits) as highest priority.\n"
        )

    # 3a: PM Walkthrough
    pm = gemini(f"""{PRIMER}

## YOUR ROLE: You are a brand new LTC Project Manager. Day 1. Zero context.

You just cloned this repo. Walk through the onboarding experience step by step.

**README.md:**
{rf(R / 'README.md', 6000)}

**SOP:**
{rf(R / '_genesis/sops/alpei-standard-operating-procedure.md', 6000)}

**Prior audit findings (what agents found broken):**
{findings[:4000]}

**Instructions:**
1. Read README. Note every undefined term, dead link, confusing instruction.
2. Follow Quick Start steps. Note where you'd get stuck.
3. Read SOP. Try to understand the daily workflow.
4. Attempt to run `/dsbv status` mentally. What would you see?
5. Try to understand what a "subsystem" is and where your work goes.

For EVERY confusion, mark:
> CONFUSION: [what + why]
> MISSING: [what's needed]
> BLOCKER: [what stops you]

End with: **Day-1 Readiness Score: X/100** | **Time to First Productive Action: estimate**
""", "promax", "P3-PM-Walkthrough")

    # 3b: Ship Advocate
    g1 = gemini(f"""You are the SHIP ADVOCATE. Build the strongest case FOR pushing this repo to origin NOW.

Evidence: {findings[:4000]}
Counts: {counts}
Validation results: {vals}

Argue: issues are acceptable for Iteration 1/Concept stage. Template works. Framework is sound.
Risk of NOT shipping: velocity loss, staleness, 87 commits sitting unreleased.
600 words max. Structured argument with evidence.""", "promax", "P3-Advocate")

    # 3c: Ship Opponent
    g2 = gemini(f"""You are the SHIP OPPONENT. Build the strongest case AGAINST shipping.

Evidence: {findings[:4000]}
Ship Advocate's argument: {g1[:2000]}

Counter their points. Argue: remaining issues genuinely block new PMs. Template quality matters.
Identify the 3 highest-risk issues that would waste PM time if shipped.
600 words max.""", "promax", "P3-Opponent")

    # 3d: Judge
    g3 = gemini(f"""You are the IMPARTIAL JUDGE. Render verdict.

Ship Advocate: {g1[:2000]}
Ship Opponent: {g2[:2000]}

1. Which argument is stronger?
2. List specific conditions for shipping (if CONDITIONAL).
3. Verdict: SHIP / NO-SHIP / CONDITIONAL
400 words max.""", "promax", "P3-Judge")

    # 3e: Final Synthesizer
    final = gemini(f"""{PRIMER}

## YOUR ROLE: Final Synthesizer — produce the definitive audit report.

You have outputs from 21 agents across 3 phases. Produce a report a PM can act on.
{verify_block}{reconcile_block}{regression_block}
**PHASE 0 (Local — machine-verified):**
Counts: {counts}
Validation scripts: {vals}
Orphan wikilinks: {json.dumps(manifest['orphans'][:20])}
Git: {manifest['git']['ahead']} commits ahead. {manifest['git']['status'][:500]}

**PHASE 1 (Content audit — 11 areas, annotated with confidence tags):**
{p1[:8000]}

**PHASE 2 (Cross-cutting — 5 checks, annotated with confidence tags):**
{p2[:6000]}

**PHASE 3 (Walkthrough + Debate):**
PM Walkthrough: {pm[:3000]}
Debate Judge: {g3[:1500]}

## REPORT STRUCTURE (follow exactly):

```yaml
---
version: "1.0"
status: draft
last_updated: {TODAY}
auditor: gemini-multi-agent-v3.1
agents: 21
models: {json.dumps(MODELS)}
work_stream: _genesis
tags: [audit, gemini, comprehensive, release-readiness]
---
```

# Comprehensive Workspace Audit — OPS_OE.6.4.LTC-PROJECT-TEMPLATE

## 1. Executive Summary
SHIP/NO-SHIP/CONDITIONAL. S×E×Sc scores (0-100 each, justified).

## 2. Machine Verification (Phase 0)
Pre-flight results. Count accuracy. Orphan wikilinks.

## 3. Content Audit by Area (Phase 1)
One subsection per area. Area score. Key findings only (no re-listing PASSes).

## 4. Cross-Cutting Integrity (Phase 2)
Wikilinks, process map, hooks, versions, naming. Score per check.

## 5. PM Day-1 Experience (Phase 3)
What works. What breaks. Day-1 readiness score. Time to first productive action.

## 6. GAN Debate Verdict
Judge's ruling + conditions.

## 7. Gap Analysis
EVERY finding in 4-level format:
| # | What (descriptive) | Why (root cause) | Risk (predictive) | Fix (prescriptive) | Files | Effort |

## 8. Ship Readiness Checklist
[x] or [ ] per criterion: security, docs, structure, framework, versioning, hooks, multi-IDE, onboarding.

## 9. Questions You Didn't Know to Ask
5-10 unknown unknowns. Risks no prior audit caught. Architectural blind spots.

## 10. Composite Scores
| Dimension | Score | Evidence |
ALPEI completeness, DSBV enforcement, agent system, Obsidian, learning pipeline, multi-IDE, security, clone-readiness.
""", "promax", "P3-Synthesizer")

    combined = (f"### PM Walkthrough\n\n{pm}\n\n---\n\n"
                f"### Ship Advocate\n\n{g1}\n\n---\n\n"
                f"### Ship Opponent\n\n{g2}\n\n---\n\n"
                f"### Judge\n\n{g3}\n\n---\n\n"
                f"### FINAL REPORT\n\n{final}")
    print("  Phase 3 complete.\n", flush=True)
    return final, combined

# ── Regression Tracking (Gap 5) ──────────────────────────────────────────────

def load_prior_audit() -> dict | None:
    """Find and parse the most recent prior audit from inbox/.

    Searches inbox/ for *_gemini-audit.md files sorted by name descending
    (YYYY-MM-DD prefix ensures chronological order). Skips today's file.

    Extracts:
      verdict       — SHIP / NO-SHIP / CONDITIONAL
      scores        — {"S": int, "E": int, "Sc": int} if parseable
      finding_count — number of gap-analysis table rows (proxy for issue volume)
      date          — file date string (YYYY-MM-DD)
      path          — absolute path to prior file

    Returns structured dict, or None if no prior audit exists.
    """
    inbox = R / "inbox"
    if not inbox.exists():
        return None

    candidates = sorted(
        inbox.glob("*_gemini-audit.md"),
        key=lambda p: p.name,
        reverse=True,
    )
    prior_path: Path | None = None
    for c in candidates:
        if c.name.startswith(TODAY):
            continue
        prior_path = c
        break

    if prior_path is None:
        return None

    try:
        text = prior_path.read_text("utf-8", errors="replace")
    except Exception:
        return None

    result: dict = {"path": str(prior_path), "date": prior_path.name[:10]}

    # Extract verdict (first occurrence of SHIP / NO-SHIP / CONDITIONAL)
    verdict_m = re.search(r'\b(NO-SHIP|CONDITIONAL|SHIP)\b', text)
    result["verdict"] = verdict_m.group(1) if verdict_m else "UNKNOWN"

    # Extract S/E/Sc scores — patterns like "S=75", "S: 75"
    scores: dict = {}
    for dim, pat in (("S",  r'\bS[=:\s]+(\d{1,3})\b'),
                     ("E",  r'\bE[=:\s]+(\d{1,3})\b'),
                     ("Sc", r'\bSc[=:\s]+(\d{1,3})\b')):
        m = re.search(pat, text)
        if m:
            scores[dim] = int(m.group(1))
    result["scores"] = scores

    # Count gap-analysis table rows as proxy for issue volume
    gap_rows = re.findall(r'^\|\s*\d+\s*\|', text, re.MULTILINE)
    result["finding_count"] = len(gap_rows)

    # Extract area scores for avg comparison
    area_scores = re.findall(r'Area Score[:\s]+(\d{1,3})/100', text, re.IGNORECASE)
    result["area_scores"] = [int(s) for s in area_scores]

    return result


def regression_analysis(current_findings: str, prior: dict | None) -> str:
    """Compare current audit findings against the prior audit (Gap 5).

    Args:
        current_findings: p1+p2 combined findings text from the current run
        prior: parsed prior audit dict from load_prior_audit(), or None

    Returns:
        Markdown regression analysis section ready for report insertion.
    """
    if prior is None:
        return (
            "## Regression Analysis\n\n"
            "**Baseline run** — no prior audit found in `inbox/`. "
            "Future runs will compare against this audit.\n"
        )

    prior_date    = prior.get("date", "unknown")
    prior_verdict = prior.get("verdict", "UNKNOWN")
    prior_scores  = prior.get("scores", {})
    prior_count   = prior.get("finding_count", 0)
    prior_area_scores = prior.get("area_scores", [])

    # Finding pattern comparison via FAIL/WARN lines
    current_issues = {s.strip() for s in
                      re.findall(r'\[(?:FAIL|WARN)\]\s+([^\n\u2014]+)', current_findings)}
    prior_issues: set = set()
    try:
        prior_text = Path(prior["path"]).read_text("utf-8", errors="replace")
        prior_issues = {s.strip() for s in
                        re.findall(r'\[(?:FAIL|WARN)\]\s+([^\n\u2014]+)', prior_text)}
    except Exception:
        pass

    new_issues       = current_issues - prior_issues
    resolved_issues  = prior_issues   - current_issues
    recurring_issues = current_issues & prior_issues

    prior_avg = (sum(prior_area_scores) / len(prior_area_scores)) if prior_area_scores else None

    lines = [
        "## Regression Analysis\n",
        f"**Prior audit:** `{prior_date}` | Verdict: **{prior_verdict}** | "
        f"Gap rows: {prior_count}",
    ]
    if prior_avg is not None:
        lines.append(f"Prior area score avg: {prior_avg:.0f}/100 "
                     f"({len(prior_area_scores)} areas scored)")

    if prior_scores:
        score_parts = [f"{d}={v}" for d, v in sorted(prior_scores.items())]
        lines.append(f"Prior scores: {', '.join(score_parts)} (current scores in §10)")

    lines.append(
        f"\n**Issues: {len(new_issues)} new | "
        f"{len(resolved_issues)} resolved | "
        f"{len(recurring_issues)} recurring**"
    )

    if recurring_issues:
        lines.append("\n### Recurring Issues (unfixed from prior audit — highest priority)")
        for issue in sorted(recurring_issues)[:20]:
            lines.append(f"- {issue}")

    if new_issues:
        lines.append(f"\n### New Issues ({len(new_issues)} not in prior audit)")
        for issue in sorted(new_issues)[:15]:
            lines.append(f"- {issue}")

    if resolved_issues:
        lines.append(f"\n### Resolved Issues ({len(resolved_issues)} fixed since prior audit)")
        for issue in sorted(resolved_issues)[:15]:
            lines.append(f"- {issue}")

    return "\n".join(lines) + "\n"


# ── Report Assembly ──────────────────────────────────────────────────────────

def write_report(final: str, manifest: dict, elapsed: float,
                 verify_stats: dict | None = None,
                 regression: str | None = None,
                 conflicts: list | None = None):
    vs = verify_stats or {}
    p1v = vs.get("p1_verified", "n/a")
    p1d = vs.get("p1_disputed", "n/a")
    p1h = vs.get("p1_hallucinated", "n/a")
    p2v = vs.get("p2_verified", "n/a")
    p2d = vs.get("p2_disputed", "n/a")
    p2h = vs.get("p2_hallucinated", "n/a")
    n_conflicts = len(conflicts) if conflicts else 0

    regression_section = f"\n{regression}\n" if regression else ""

    footer = f"""

---
{regression_section}
## Audit Execution Metadata

| Field | Value |
|-------|-------|
| Date | {TODAY} |
| Duration | {elapsed:.0f}s |
| Models | Flash: `{MODELS['flash']}`, ProMax: `{MODELS['promax']}` |
| Agents | 21 (11 content + 5 cross-cut + 5 synthesis) |
| Phases | LOCAL → CONTENT → VERIFY → RECONCILE → CROSS-CUT → VERIFY → SYNTHESIS |
| Files audited | {manifest['counts']['tracked']} tracked |
| Scripts validated | {manifest['counts']['scripts']} |
| Repo | {R.name} |
| Commits ahead | {manifest['git']['ahead']} |
| P1 claim verification | {p1v} VERIFIED, {p1d} DISPUTED, {p1h} HALLUCINATED |
| P2 claim verification | {p2v} VERIFIED, {p2d} DISPUTED, {p2h} HALLUCINATED |
| Cross-agent conflicts | {n_conflicts} |

## Links

- [[BLUEPRINT]]
- [[CLAUDE]]
- [[AGENTS]]
- [[alpei-dsbv-process-map]]
- [[enforcement-layers]]
"""
    OUT.write_text(final + footer, encoding="utf-8")
    print(f"\n  Report written → {OUT}", flush=True)

# ── CLI ──────────────────────────────────────────────────────────────────────

def main():
    ap = argparse.ArgumentParser(description="Comprehensive multi-agent Gemini audit v3.2")
    ap.add_argument("--phase", type=int, choices=[0, 1, 2, 3], help="Run single phase")
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--list-models", action="store_true")
    args = ap.parse_args()

    if args.list_models:
        if not KEY: sys.exit("Set GEMINI_API_KEY")
        list_models(); return

    print(f"╔══════════════════════════════════════════════════════════╗")
    print(f"║  GEMINI COMPREHENSIVE AUDIT v3.2 — Every File Audited  ║")
    print(f"╠══════════════════════════════════════════════════════════╣")
    print(f"║  Flash : {MODELS['flash']:<46} ║")
    print(f"║  ProMax: {MODELS['promax']:<46} ║")
    print(f"║  Output: {str(OUT.relative_to(R)):<46} ║")
    print(f"╚══════════════════════════════════════════════════════════╝")

    # Phase 0 always runs (free)
    t0 = time.time()
    manifest = phase0()
    prior = load_prior_audit()  # Gap 5: load prior audit baseline
    if prior:
        print(f"  Prior audit found: {prior['date']} (verdict={prior['verdict']}, "
              f"{prior['finding_count']} gap rows)", flush=True)
    else:
        print("  No prior audit found — this will be the baseline run.", flush=True)

    if args.dry_run:
        n_paths = len(_extract_paths(
            " ".join(f"{k} `{k}`" for k in list(manifest["files"].keys())[:50])
        ))
        print("═══ DRY RUN ═══")
        print(f"Phase 1:   {len(AREAS)}× Flash calls  (content audit, schema-enforced)")
        print(f"Phase 1.5: claim verification — {len(manifest['files'])} manifest paths available for cross-check")
        print(f"Phase 1.R: cross-agent reconciliation — contradiction detection across {len(AREAS)} agents")
        print(f"Phase 2:   5× Flash calls  (cross-cutting, schema-enforced)")
        print(f"Phase 2.5: claim verification — same cross-check applied to Phase 2 output")
        print(f"Phase 3:   5× ProMax calls (walkthrough + debate + synthesis)")
        print(f"Total: {len(AREAS) + 10} API calls")
        print(f"Est cost: $2-5 | Est time: 5-15 min")
        print(f"Reliability: verify_claims + tag_confidence + schema retry + reconcile + regression active")
        return

    if not KEY: sys.exit("Set GEMINI_API_KEY or GOOGLE_API_KEY")

    if args.phase == 0:
        OUT.write_text(json.dumps(manifest, indent=2, default=str), encoding="utf-8")
        print(f"Manifest → {OUT}"); return

    p1_combined, p1_raw = phase1(manifest)  # unpack (combined_str, results_dict)

    # Phase 1.5: claim verification + confidence tagging
    print("═══ PHASE 1.5: CLAIM VERIFICATION + CONFIDENCE TAGGING ═══", flush=True)
    p1, p1_stats = verify_claims(p1_combined, manifest)
    p1 = tag_confidence(p1, manifest)
    print(f"  P1: {p1_stats['verified']} verified, {p1_stats['disputed']} disputed, "
          f"{p1_stats['hallucinated']} hallucinated across {len(p1_stats['paths'])} claims", flush=True)

    # Phase 1.R: cross-agent reconciliation (Gap 4)
    print("═══ PHASE 1.R: CROSS-AGENT RECONCILIATION ═══", flush=True)
    reconcile_summary, conflicts = reconcile(p1_raw)

    if args.phase == 1:
        OUT.write_text(f"# Phase 1: Content Audit (verified)\n\n{p1}\n\n---\n\n{reconcile_summary}"); return

    p2 = phase2(manifest, p1)

    # Phase 2.5: claim verification + confidence tagging
    print("═══ PHASE 2.5: CLAIM VERIFICATION + CONFIDENCE TAGGING ═══", flush=True)
    p2, p2_stats = verify_claims(p2, manifest)
    p2 = tag_confidence(p2, manifest)
    print(f"  P2: {p2_stats['verified']} verified, {p2_stats['disputed']} disputed, "
          f"{p2_stats['hallucinated']} hallucinated across {len(p2_stats['paths'])} claims", flush=True)

    if args.phase == 2:
        OUT.write_text(f"# Phases 1-2 (verified)\n\n{p1}\n\n---\n\n{p2}"); return

    verify_stats = {
        "p1_verified": p1_stats["verified"],
        "p1_disputed": p1_stats["disputed"],
        "p1_hallucinated": p1_stats["hallucinated"],
        "p2_verified": p2_stats["verified"],
        "p2_disputed": p2_stats["disputed"],
        "p2_hallucinated": p2_stats["hallucinated"],
    }

    # Gap 5: build regression analysis before synthesizer runs
    regression = regression_analysis(p1 + "\n\n" + p2, prior)

    final, _ = phase3(manifest, p1, p2,
                      verify_stats=verify_stats,
                      conflicts=conflicts,
                      prior=prior)
    elapsed = time.time() - t0
    write_report(final, manifest, elapsed,
                 verify_stats=verify_stats,
                 regression=regression,
                 conflicts=conflicts)

    print(f"\n{'='*60}")
    print(f"  AUDIT COMPLETE")
    print(f"  Duration: {elapsed:.0f}s | Agents: 21 | Files: {manifest['counts']['tracked']}")
    print(f"  P1 claims: {p1_stats['verified']}V/{p1_stats['disputed']}D/{p1_stats['hallucinated']}H  "
          f"P2 claims: {p2_stats['verified']}V/{p2_stats['disputed']}D/{p2_stats['hallucinated']}H")
    print(f"  Conflicts: {len(conflicts)} | Regression: {'vs ' + prior['date'] if prior else 'baseline'}")
    print(f"  Report: {OUT}")
    print(f"{'='*60}")

if __name__ == "__main__":
    main()
