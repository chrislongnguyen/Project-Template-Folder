#!/usr/bin/env bash
# version: 1.0 | status: draft | last_updated: 2026-04-09
# DSBV Agent Benchmark — Orchestrator
# Runs L1 (deterministic) and optionally L2 (Opus judge), produces delta reports.
# Usage:
#   ./scripts/dsbv-benchmark.sh [--target-dir DIR] [--l2] [--json]
#   ./scripts/dsbv-benchmark.sh --delta --before DIR --after DIR [--l2]

set -euo pipefail

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET_DIR="$REPO_ROOT"
RUN_L2=0
JSON_MODE=0
DELTA_MODE=0
BEFORE_DIR=""
AFTER_DIR=""

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    --target-dir)
      TARGET_DIR="$2"; shift 2 ;;
    --l2)
      RUN_L2=1; shift ;;
    --json)
      JSON_MODE=1; shift ;;
    --delta)
      DELTA_MODE=1; shift ;;
    --before)
      BEFORE_DIR="$2"; shift 2 ;;
    --after)
      AFTER_DIR="$2"; shift 2 ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: $0 [--target-dir DIR] [--l2] [--json]" >&2
      echo "       $0 --delta --before DIR --after DIR [--l2]" >&2
      exit 1 ;;
  esac
done

L1_SCRIPT="$SCRIPT_DIR/dsbv-benchmark-l1.py"
L2_SCRIPT="$SCRIPT_DIR/dsbv-benchmark-l2-judge.py"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
TODAY="$(date +%Y-%m-%d)"

check_l1_exists() {
  if [ ! -f "$L1_SCRIPT" ]; then
    echo "ERROR: L1 script not found: $L1_SCRIPT" >&2
    exit 1
  fi
}

run_l1() {
  local dir="$1"
  python3 "$L1_SCRIPT" --target-dir "$dir" --json 2>/dev/null
}

run_l2() {
  local dir="$1"
  if [ ! -f "$L2_SCRIPT" ]; then
    echo "WARNING: L2 judge script not found ($L2_SCRIPT) — skipping L2" >&2
    echo ""
    return 0
  fi
  python3 "$L2_SCRIPT" --target-dir "$dir" --json 2>/dev/null
}

# Parse a field from L1 JSON using python3 (no jq dependency)
parse_l1_field() {
  local json="$1"
  local field="$2"
  echo "$json" | python3 -c "import sys,json; d=json.loads(sys.stdin.read()); print(d.get('$field',''))"
}

# Parse checks list from L1 JSON and compute per-dimension pass counts
parse_l1_checks() {
  local json="$1"
  python3 -c "
import sys, json
d = json.loads(sys.argv[1])
checks = d.get('checks', [])
dims = {'S': {'pass': 0, 'total': 0}, 'E': {'pass': 0, 'total': 0}, 'Sc': {'pass': 0, 'total': 0}}
for c in checks:
  cid = c.get('id', '')
  passed = c.get('passed', False)
  if cid.startswith('Sc'):
    dim = 'Sc'
  elif cid.startswith('S'):
    dim = 'S'
  elif cid.startswith('E'):
    dim = 'E'
  else:
    continue
  dims[dim]['total'] += 1
  if passed:
    dims[dim]['pass'] += 1
total_pass = d.get('total_pass', 0)
total_checks = d.get('total_checks', 0)
pct = round(total_pass / total_checks * 100, 1) if total_checks else 0.0
print('S:'+str(dims['S']['pass'])+'/'+str(dims['S']['total']))
print('E:'+str(dims['E']['pass'])+'/'+str(dims['E']['total']))
print('Sc:'+str(dims['Sc']['pass'])+'/'+str(dims['Sc']['total']))
print('TOTAL:'+str(total_pass)+'/'+str(total_checks))
print('PCT:'+str(pct))
" "$json"
}

# ---------------------------------------------------------------------------
# Single-target mode (no --delta)
# ---------------------------------------------------------------------------
run_single() {
  local dir="$1"
  check_l1_exists

  local l1_json
  l1_json="$(run_l1 "$dir")"

  if [ "$JSON_MODE" -eq 1 ]; then
    # Merge L1 (and optionally L2) into one JSON object
    if [ "$RUN_L2" -eq 1 ]; then
      local l2_json
      l2_json="$(run_l2 "$dir")"
      if [ -n "$l2_json" ]; then
        python3 -c "import sys,json; l1=json.loads(sys.argv[1]); l2=json.loads(sys.argv[2]); print(json.dumps({'l1':l1,'l2':l2},indent=2))" "$l1_json" "$l2_json"
      else
        python3 -c "import sys,json; print(json.dumps({'l1': json.loads(sys.argv[1]), 'l2': None}, indent=2))" "$l1_json"
      fi
    else
      python3 -c "import sys,json; print(json.dumps({'l1': json.loads(sys.argv[1])}, indent=2))" "$l1_json"
    fi
    return 0
  fi

  # Human-readable output
  echo "DSBV Agent Benchmark"
  echo "===================="
  echo "Date:   $TODAY"
  echo "Target: $dir"
  echo ""

  # L1 section
  echo "--- L1: Deterministic Contract Checks ---"
  local l1_scores
  l1_scores="$(parse_l1_checks "$l1_json")"

  local s_line e_line sc_line total_line pct_line
  s_line="$(echo "$l1_scores" | grep '^S:')"
  e_line="$(echo "$l1_scores" | grep '^E:')"
  sc_line="$(echo "$l1_scores" | grep '^Sc:')"
  total_line="$(echo "$l1_scores" | grep '^TOTAL:')"
  pct_line="$(echo "$l1_scores" | grep '^PCT:')"

  local s_val e_val sc_val total_val pct_val
  s_val="${s_line#S:}"
  e_val="${e_line#E:}"
  sc_val="${sc_line#Sc:}"
  total_val="${total_line#TOTAL:}"
  pct_val="${pct_line#PCT:}"

  printf "  %-10s %s\n" "S:"  "$s_val"
  printf "  %-10s %s\n" "E:"  "$e_val"
  printf "  %-10s %s\n" "Sc:" "$sc_val"
  printf "  %-10s %s  (%s%%)\n" "TOTAL:" "$total_val" "$pct_val"
  echo ""

  # Per-check detail
  echo "  Per-Check Results:"
  python3 -c "
import sys, json
d = json.loads(sys.argv[1])
for c in d.get('checks', []):
  status = 'PASS' if c.get('passed') else 'FAIL'
  detail = c.get('detail', '')
  print('    ' + c['id'].ljust(8) + ' ' + status.ljust(6) + '  ' + detail)
" "$l1_json"
  echo ""

  # L1 threshold verdict
  local pct_int
  pct_int="$(python3 -c "import sys; print(int(float('$pct_val')))")"
  local l1_verdict="FAIL"
  if [ "$pct_int" -ge 92 ]; then
    l1_verdict="PASS"
  elif [ "$pct_int" -ge 85 ]; then
    l1_verdict="WARN"
  fi
  echo "  L1 Verdict: $l1_verdict ($pct_val%)"
  echo ""

  # L2 section
  if [ "$RUN_L2" -eq 1 ]; then
    echo "--- L2: Opus Judge (3-run majority) ---"
    local l2_json
    l2_json="$(run_l2 "$dir")"
    if [ -z "$l2_json" ]; then
      echo "  L2 skipped (judge script not available)"
    else
      python3 -c "
import sys, json
d = json.loads(sys.argv[1])
system_mean = d.get('system_mean', 0)
agents = d.get('agents', {})
print('  System Mean: ' + str(system_mean))
for agent, data in agents.items():
  mean = data.get('mean', 'N/A')
  print('    ' + agent.ljust(20) + ' mean=' + str(mean))
fail_dims = d.get('fail_dimensions', [])
if fail_dims:
  print('  FAIL dimensions (<=2): ' + ', '.join(fail_dims))
else:
  print('  FAIL dimensions (<=2): none')
" "$l2_json"
    fi
    echo ""
  fi
}

# ---------------------------------------------------------------------------
# Delta mode
# ---------------------------------------------------------------------------
run_delta() {
  check_l1_exists

  if [ -z "$BEFORE_DIR" ] || [ -z "$AFTER_DIR" ]; then
    echo "ERROR: --delta requires --before DIR and --after DIR" >&2
    exit 1
  fi

  local before_l1 after_l1
  before_l1="$(run_l1 "$BEFORE_DIR")"
  after_l1="$(run_l1 "$AFTER_DIR")"

  # Compute delta tables in Python
  python3 - "$before_l1" "$after_l1" "$BEFORE_DIR" "$AFTER_DIR" "$TODAY" <<'PYEOF'
import sys, json

before_json = sys.argv[1]
after_json  = sys.argv[2]
before_path = sys.argv[3]
after_path  = sys.argv[4]
today       = sys.argv[5]

before = json.loads(before_json)
after  = json.loads(after_json)

# ── Dimension tallies ──────────────────────────────────────────────────────
def tally(d):
  dims = {'S': {'pass': 0, 'total': 0}, 'E': {'pass': 0, 'total': 0}, 'Sc': {'pass': 0, 'total': 0}}
  for c in d.get('checks', []):
    cid = c.get('id', '')
    if cid.startswith('Sc'):
      k = 'Sc'
    elif cid.startswith('S'):
      k = 'S'
    elif cid.startswith('E'):
      k = 'E'
    else:
      continue
    dims[k]['total'] += 1
    if c.get('passed'):
      dims[k]['pass'] += 1
  total_pass  = d.get('total_pass', 0)
  total_checks = d.get('total_checks', 0)
  pct = round(total_pass / total_checks * 100, 1) if total_checks else 0.0
  return dims, total_pass, total_checks, pct

bdims, b_pass, b_total, b_pct = tally(before)
adims, a_pass, a_total, a_pct = tally(after)

# ── Header ─────────────────────────────────────────────────────────────────
print("DSBV Agent Benchmark -- L1 Delta Report")
print("========================================")
print()
print(f"Date:   {today}")
print(f"Before: {before_path}")
print(f"After:  {after_path}")
print()

# ── Summary table ──────────────────────────────────────────────────────────
def fmt_pass(p, t):
  return f"{p:>2}/{t:<2}"

header = f"{'Dimension':<10} {'Before':>10} {'After':>10} {'Delta':>8}"
sep    = "-" * len(header)
print(f"+{'-'*10}+{'-'*10}+{'-'*10}+{'-'*10}+")
print(f"| {'Dimension':<8} | {'Before':>8} | {'After':>8} | {'Delta':>8} |")
print(f"+{'-'*10}+{'-'*10}+{'-'*10}+{'-'*10}+")
for k in ('S', 'E', 'Sc'):
  b = bdims[k]; a = adims[k]
  delta = a['pass'] - b['pass']
  sign  = f"+{delta}" if delta >= 0 else str(delta)
  print(f"| {k+' ('+str(b['total'])+')':<8} | {fmt_pass(b['pass'],b['total']):>8} | {fmt_pass(a['pass'],a['total']):>8} | {sign:>8} |")
print(f"+{'-'*10}+{'-'*10}+{'-'*10}+{'-'*10}+")
total_delta = a_pass - b_pass
pct_delta   = round(a_pct - b_pct, 1)
sign_tot    = f"+{total_delta}" if total_delta >= 0 else str(total_delta)
sign_pct    = f"+{pct_delta}pp" if pct_delta >= 0 else f"{pct_delta}pp"
print(f"| {'TOTAL':<8} | {fmt_pass(b_pass,b_total):>8} | {fmt_pass(a_pass,a_total):>8} | {sign_tot:>8} |")
print(f"| {'PERCENT':<8} | {str(b_pct)+'%':>8} | {str(a_pct)+'%':>8} | {sign_pct:>8} |")
print(f"+{'-'*10}+{'-'*10}+{'-'*10}+{'-'*10}+")
print()

# ── Per-check delta ────────────────────────────────────────────────────────
before_map = {c['id']: c.get('passed', False) for c in before.get('checks', [])}
after_map  = {c['id']: c.get('passed', False) for c in after.get('checks', [])}
after_detail = {c['id']: c.get('detail','') for c in after.get('checks', [])}

all_ids = sorted(set(list(before_map.keys()) + list(after_map.keys())))

improved   = 0
regressed  = 0
unchanged  = 0

print("Per-Check Delta:")
print(f"  {'ID':<8} | {'Before':<6} | {'After':<6} | Status")
print(f"  {'-'*7}-+-{'-'*6}-+-{'-'*6}-+-------")
for cid in all_ids:
  b_pass_c = before_map.get(cid, False)
  a_pass_c = after_map.get(cid, False)
  b_s = "PASS" if b_pass_c else "FAIL"
  a_s = "PASS" if a_pass_c else "FAIL"
  if b_pass_c == a_pass_c:
    status = "UNCHANGED"
    unchanged += 1
  elif not b_pass_c and a_pass_c:
    status = "IMPROVED <-"
    improved += 1
  else:
    status = "REGRESSION !"
    regressed += 1
  print(f"  {cid:<8} | {b_s:<6} | {a_s:<6} | {status}")
print()
print(f"REGRESSIONS: {regressed}")
print(f"IMPROVEMENTS: {improved}")
print(f"UNCHANGED: {unchanged}")
print()

# ── L1 verdict ─────────────────────────────────────────────────────────────
def l1_verdict(pct, delta_pp, regressions):
  if pct >= 92 and regressions == 0:
    return "PASS"
  elif pct >= 85 and regressions <= 2:
    return "WARN"
  else:
    return "FAIL"

verdict = l1_verdict(a_pct, pct_delta, regressed)
print(f"L1 Verdict (after): {verdict}  ({a_pct}%,  regressions={regressed})")
PYEOF

  # L2 delta if requested
  if [ "$RUN_L2" -eq 1 ]; then
    echo ""
    echo "DSBV Agent Benchmark -- L2 Delta Report (Opus Judge, 3-run majority)"
    echo "===================================================================="
    echo ""

    local before_l2 after_l2
    before_l2="$(run_l2 "$BEFORE_DIR")"
    after_l2="$(run_l2 "$AFTER_DIR")"

    if [ -z "$before_l2" ] || [ -z "$after_l2" ]; then
      echo "  L2 skipped (judge script not available or returned no output)"
    else
      python3 - "$before_l2" "$after_l2" <<'PYEOF'
import sys, json

before = json.loads(sys.argv[1])
after  = json.loads(sys.argv[2])

dims = ['S1','S2','S3','S4','E1','E2','E3','E4','Sc1','Sc2','Sc3','Sc4']
agents_order = ['planner','builder','reviewer','explorer']
agent_short  = {'planner':'Pln','builder':'Bld','reviewer':'Rev','explorer':'Exp'}

def get_dim_scores(data, dim):
  """Return per-agent score for a dimension."""
  scores = []
  for ag in agents_order:
    ag_data = data.get('agents', {}).get(ag, {})
    score = ag_data.get('scores', {}).get(dim, {}).get('score', None)
    scores.append(score)
  return scores

def mean_of(scores):
  valid = [s for s in scores if s is not None]
  return round(sum(valid)/len(valid), 2) if valid else 0.0

col_w = 22
print(f"+{'-'*13}+{'-'*col_w}+{'-'*col_w}+{'-'*8}+")
print(f"| {'Dimension':<11} | {'Before (Pln Bld Rev Exp)':<{col_w-2}} | {'After (Pln Bld Rev Exp)':<{col_w-2}} | {'Delta':<6} |")
print(f"+{'-'*13}+{'-'*col_w}+{'-'*col_w}+{'-'*8}+")

b_fail = 0; a_fail = 0; regressions = 0
b_dim_means = []; a_dim_means = []

for dim in dims:
  b_scores = get_dim_scores(before, dim)
  a_scores = get_dim_scores(after, dim)
  b_str = '  '.join(str(s) if s is not None else '?' for s in b_scores)
  a_str = '  '.join(str(s) if s is not None else '?' for s in a_scores)
  b_m = mean_of(b_scores); a_m = mean_of(a_scores)
  delta = round(a_m - b_m, 2)
  sign  = f"+{delta}" if delta >= 0 else str(delta)
  print(f"| {dim:<11} | {b_str:<{col_w-2}} | {a_str:<{col_w-2}} | {sign:<6} |")
  b_dim_means.append(b_m); a_dim_means.append(a_m)
  for s in b_scores:
    if s is not None and s <= 2: b_fail += 1
  for s in a_scores:
    if s is not None and s <= 2: a_fail += 1

print(f"+{'-'*13}+{'-'*col_w}+{'-'*col_w}+{'-'*8}+")

# Agent means
b_agent_means = [mean_of([get_dim_scores(before, d)[i] for d in dims]) for i in range(4)]
a_agent_means = [mean_of([get_dim_scores(after,  d)[i] for d in dims]) for i in range(4)]
b_sys = round(sum(b_agent_means)/4, 2)
a_sys = round(sum(a_agent_means)/4, 2)
b_ag_str = '  '.join(str(m) for m in b_agent_means)
a_ag_str = '  '.join(str(m) for m in a_agent_means)
print(f"| {'Agent Mean':<11} | {b_ag_str:<{col_w-2}} | {a_ag_str:<{col_w-2}} | {'':6} |")
sys_delta = round(a_sys - b_sys, 2)
sys_sign  = f"+{sys_delta}" if sys_delta >= 0 else str(sys_delta)
print(f"| {'System Mean':<11} | {str(b_sys):^{col_w-2}} | {str(a_sys):^{col_w-2}} | {sys_sign:<6} |")
print(f"+{'-'*13}+{'-'*col_w}+{'-'*col_w}+{'-'*8}+")
print()
print(f"FAIL dimensions (score<=2): Before={b_fail}, After={a_fail}")

# L2 verdict
if a_sys >= 4.0 and sys_delta > 0.5:
  l2_v = "PASS"
elif a_sys >= 3.5 or sys_delta >= 0.5:
  l2_v = "WARN"
else:
  l2_v = "FAIL"
print(f"L2 Verdict (after): {l2_v}  (system_mean={a_sys}, delta={sys_sign})")
PYEOF
    fi
  fi

  # Combined verdict
  echo ""
  echo "========================================="
  echo "DSBV AGENT BENCHMARK -- COMBINED VERDICT"
  echo "========================================="
  echo ""

  # Re-parse to get pct values for verdict
  local b_pct a_pct
  b_pct="$(echo "$before_l1" | python3 -c "import sys,json; d=json.load(sys.stdin); t=d['total_checks']; print(round(d['total_pass']/t*100,1) if t else 0)")"
  a_pct="$(echo "$after_l1"  | python3 -c "import sys,json; d=json.load(sys.stdin); t=d['total_checks']; print(round(d['total_pass']/t*100,1) if t else 0)")"
  local delta_pp
  delta_pp="$(python3 -c "print(round($a_pct - $b_pct, 1))")"

  local q1_verdict="FAIL"
  local a_pct_int
  a_pct_int="$(python3 -c "print(int($a_pct))")"
  if [ "$a_pct_int" -ge 90 ]; then q1_verdict="PASS"; fi

  local sign_pp="+$delta_pp"
  if python3 -c "import sys; sys.exit(0 if $delta_pp < 0 else 1)" 2>/dev/null; then
    sign_pp="$delta_pp"
  fi

  echo "Q1: \"Did we build what we said we'd build?\""
  echo "  L1 enforcement: ${b_pct}% -> ${a_pct}% (${sign_pp}pp)"
  echo "  Verdict: $q1_verdict (PASS if after >= 90%)"
  echo ""

  if [ "$RUN_L2" -eq 1 ] && [ -n "${after_l2:-}" ] && [ -n "${before_l2:-}" ]; then
    local b_sys a_sys l2_delta q2_verdict
    b_sys="$(echo "$before_l2" | python3 -c "import sys,json; print(json.load(sys.stdin).get('system_mean',0))")"
    a_sys="$(echo "$after_l2"  | python3 -c "import sys,json; print(json.load(sys.stdin).get('system_mean',0))")"
    l2_delta="$(python3 -c "print(round($a_sys - $b_sys, 2))")"
    q2_verdict="FAIL"
    if python3 -c "import sys; sys.exit(0 if float('$a_sys') >= 4.0 and float('$l2_delta') > 0.5 else 1)" 2>/dev/null; then
      q2_verdict="PASS"
    fi
    local sign_l2="+$l2_delta"
    if python3 -c "import sys; sys.exit(0 if $l2_delta < 0 else 1)" 2>/dev/null; then
      sign_l2="$l2_delta"
    fi
    echo "Q2: \"Did what we built actually improve the outcome?\""
    echo "  L2 system mean: ${b_sys} -> ${a_sys} (${sign_l2})"
    echo "  Verdict: $q2_verdict (PASS if after >= 4.0 and delta > 0.5)"
    echo ""

    local combined
    if [ "$q1_verdict" = "PASS" ] && [ "$q2_verdict" = "PASS" ]; then
      combined="PASS"
    elif [ "$q1_verdict" = "FAIL" ] && [ "$q2_verdict" = "FAIL" ]; then
      combined="FAIL"
    else
      combined="PARTIAL"
    fi
    echo "Combined: $combined"
    echo "  PASS    = Q1 PASS AND Q2 PASS"
    echo "  PARTIAL = Q1 PASS XOR Q2 PASS"
    echo "  FAIL    = Q1 FAIL AND Q2 FAIL"
  else
    echo "Q2: L2 not run (omit --l2 to skip)"
    echo ""
    echo "Combined: N/A (L2 required for combined verdict)"
  fi
  echo "========================================="
}

# ---------------------------------------------------------------------------
# Dispatch
# ---------------------------------------------------------------------------
if [ "$DELTA_MODE" -eq 1 ]; then
  run_delta
else
  run_single "$TARGET_DIR"
fi
