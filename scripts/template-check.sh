#!/usr/bin/env bash
set -euo pipefail

# LTC Project Template — Staleness Checker
# Spec: docs/superpowers/specs/2026-03-19-template-distribution-design.md §6

TEMPLATE_REPO="Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE"
RAW_BASE="https://raw.githubusercontent.com/${TEMPLATE_REPO}/main"
LOCAL_VERSION_FILE=".template-version"

# --- Helpers ---

fetch_remote() {
  local url="$1"
  local curl_opts=(-sfL --connect-timeout 5 --max-time 10)
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    curl_opts+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
  fi
  curl "${curl_opts[@]}" "$url" 2>/dev/null
}

# Compare semver: returns 0 if $1 < $2, 1 otherwise
# Splits on "." and compares each numeric segment
semver_lt() {
  local IFS='.'
  local -a a=($1) b=($2)
  for i in 0 1 2; do
    local ai="${a[$i]:-0}" bi="${b[$i]:-0}"
    if (( ai < bi )); then return 0; fi
    if (( ai > bi )); then return 1; fi
  done
  return 1  # equal — not less than
}

# --- Main ---

main() {
  # Step 1: Read local version
  if [[ ! -f "$LOCAL_VERSION_FILE" ]]; then
    echo "No .template-version found."
    echo "Run: $0 --init"
    exit 2
  fi
  local local_version
  local_version=$(cat "$LOCAL_VERSION_FILE" | tr -d '[:space:]')

  # Step 2: Fetch remote version
  local remote_version
  remote_version=$(fetch_remote "${RAW_BASE}/VERSION" | tr -d '[:space:]') || true

  if [[ -z "$remote_version" ]]; then
    echo "LTC Project Template — Update Check"
    echo "  Local version:    ${local_version}"
    echo "  Template version: (offline — could not reach GitHub)"
    echo "  Status:           Unknown. Check manually or retry with network."
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
      echo ""
      echo "  Note: GITHUB_TOKEN is set but fetch failed. Check token permissions."
    else
      echo ""
      echo "  Hint: Set GITHUB_TOKEN to access private repos."
    fi
    exit 0
  fi

  # Step 3: Compare
  if semver_lt "$local_version" "$remote_version"; then
    echo "LTC Project Template — Update Check"
    echo "  Local version:    ${local_version}"
    echo "  Template version: ${remote_version}"
    echo "  Status:           ⚠ Outdated (local ${local_version} → latest ${remote_version})"

    # Step 4: Fetch and parse CHANGELOG for versions between local and remote
    local changelog
    changelog=$(fetch_remote "${RAW_BASE}/CHANGELOG.md") || true
    if [[ -n "$changelog" ]]; then
      echo ""
      echo "  Changes since ${local_version}:"
      # POSIX-compatible awk (no 3-arg match — works on macOS BSD awk)
      echo "$changelog" | awk -v local="$local_version" '
        /^## \[/ {
          # Extract version: find "[", grab until "]"
          s = $0
          i = index(s, "[")
          if (i > 0) {
            s = substr(s, i+1)
            j = index(s, "]")
            if (j > 0) ver = substr(s, 1, j-1); else ver = ""
          } else ver = ""
          if (ver != "" && ver != local) {
            # Extract date after "— "
            d = ""
            k = index($0, "— ")
            if (k > 0) d = substr($0, k+3, 10)
            in_range = 1
            printf "    [%s] %s\n", ver, d
          } else {
            in_range = 0
          }
        }
        /^### / && in_range { next }
        /^- \[T[123]:/ && in_range {
          # Extract file path between backticks
          s = $0
          i = index(s, "`")
          if (i > 0) {
            s = substr(s, i+1)
            j = index(s, "`")
            if (j > 0) printf "      %s\n", substr(s, 1, j-1)
          }
        }
      '
    fi
    echo ""
    echo "  Run: $0 --diff"
    echo "  to see file-level changes."
    exit 1
  else
    echo "LTC Project Template — Update Check"
    echo "  Local version:    ${local_version}"
    echo "  Template version: ${remote_version}"
    echo "  Status:           ✓ Up to date"
    exit 0
  fi
}

main "$@"
