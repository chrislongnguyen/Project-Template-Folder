# Security Rules Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement 3-layer defense-in-depth security rules for the LTC project template, covering all 6 items from OPS_-4215.

**Architecture:** Three independent layers — structural (.gitignore), agent EPS (CLAUDE.md/GEMINI.md + platform-specific rule files), and pre-commit hook (gitleaks). Plus one documentation file (`rules/security-rules.md`). Layers are independent and can be implemented in parallel.

**Spec:** `docs/superpowers/specs/2026-03-17-security-rules-design.md`

---

## Dependency Map

```
Task 1 (Layer 1: .gitignore)          ──┐
Task 2 (Layer 2: EPS rules)           ──┤── all independent, can run in parallel
Task 3 (Layer 3: Hook config)         ──┘
Task 4 (Documentation: rules/security-rules.md) ── depends on Tasks 1-3 being finalized
                                                   (references exact file contents)
```

**Parallel group:** Tasks 1, 2, 3 can be dispatched as parallel sub-agents.
**Sequential:** Task 4 runs after Tasks 1-3 complete (it references their exact content).

---

## Task 1: Layer 1 — Structural Convention (.gitignore)

**Files:**
- Modify: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/.gitignore`

- [ ] **Step 1: Append security entries to .gitignore**

The existing `.gitignore` already has a "Secrets" section with `.env`, `.env.local`, `.env.production`, `.env.*`. Append after that section:

```gitignore
!.env.example
secrets/
.backup/

# Security — prevent accidental credential commits
*.pem
*.key
*.p12
*.pfx
*.jks
```

The `!.env.example` negation must come immediately after the `.env.*` line to override it. The existing `.env.local` and `.env.production` lines are redundant with `.env.*` but harmless — leave them for readability.

- [ ] **Step 2: Verify .gitignore works**

Run:
```bash
cd /Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
# Create test files
mkdir -p secrets && touch secrets/test.key
touch .env.production test.pem .backup/test.txt .env.example
# Check git status — secrets/test.key, test.pem, .backup/test.txt should NOT appear
# .env.example SHOULD appear (negation working)
git status
# Clean up test files
rm -rf secrets/.  .backup/test.txt test.pem .env.example
```

Expected: `secrets/test.key`, `test.pem`, `.backup/test.txt` are gitignored. `.env.example` is NOT gitignored (negation works).

- [ ] **Step 3: Commit**

```bash
git add .gitignore
git commit -m "feat(security): add Layer 1 structural convention — gitignore entries for secrets, keys, backups"
```

---

## Task 2: Layer 2 — Agent EPS Rules

**Files:**
- Modify: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/CLAUDE.md`
- Modify: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/GEMINI.md`
- Create: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/.cursor/rules/security.md`
- Create: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/.agents/rules/security.md`

- [ ] **Step 1: Add security section to CLAUDE.md**

Insert the following BEFORE the `## Structure` line in CLAUDE.md (after the Naming section, before Structure). This keeps the flow: Brand → Naming → Security → Structure → Modular Rules.

```markdown
## Security (full spec: `rules/security-rules.md`)

### Secrets
- NEVER hardcode secrets (API keys, tokens, passwords, connection strings) in source code, prompts, or tool arguments
- All secrets MUST live in `.env` or `secrets/` (both gitignored). Reference via environment variables only
- Before completing any task, scan your output for patterns that look like secrets (API keys, tokens, passwords, PII). This check is pattern-based. If found — stop, redact, alert the user

### Execution Risk Tiers
- LOW (read files, search, lint, run tests): proceed without confirmation
- MEDIUM (edit files, git commit, install packages): proceed, user can review
- HIGH (delete files, git push, force operations, deploy, modify CI/CD, touch .env/secrets/): ALWAYS require explicit user confirmation

### Blast Radius
- Operate only within the project directory unless explicitly instructed otherwise
- For destructive or experimental operations, prefer git worktrees or branches — never on main directly
- Prefer reversible actions (git commit) over irreversible ones (file deletion of untracked files)
- When making external API calls or web requests, never include secrets, PII, or confidential data unless the endpoint is explicitly authorized

### Backup Awareness
- Before overwriting non-git-tracked files, warn the user that the original is not recoverable
- NEVER force-push without confirming the remote state and getting explicit approval
- If a file cannot be easily recreated, flag this before modifying it
```

Also update the header comment from "Keep under 50 lines" to "Keep under 80 lines".

- [ ] **Step 2: Add security section to GEMINI.md**

Insert the identical security section BEFORE the `## Structure` line in GEMINI.md. Same content, same position.

Also update the header comment from "Keep under 50 lines" to "Keep under 80 lines".

- [ ] **Step 3: Create .cursor/rules/security.md**

Reference the existing `.cursor/rules/brand-identity.md` for format conventions. Create:

```markdown
---
description: Security rules for AI agent execution
globs: **/*
---

# Security Rules

Full spec: `rules/security-rules.md`

## Secrets
- NEVER hardcode secrets in source code, prompts, or tool arguments
- All secrets in `.env` or `secrets/` only. Reference via environment variables.
- Scan output for secret patterns before completing any task. If found — stop, redact, alert user.

## Execution Risk Tiers
- LOW (read, search, lint, test): proceed
- MEDIUM (edit, commit, install): proceed, user reviews
- HIGH (delete, push, force, deploy, CI/CD, .env/secrets/): ALWAYS confirm first

## Blast Radius
- Stay within project directory unless explicitly told otherwise
- Use branches/worktrees for risky work — never main directly
- Prefer reversible actions; never include secrets in outbound API calls

## Backup Awareness
- Warn before overwriting non-git-tracked files
- Never force-push without confirming remote state
- Flag files that cannot be easily recreated
```

- [ ] **Step 4: Create .agents/rules/security.md**

Reference the existing `.agents/rules/brand-identity.md` for format conventions. Create:

```markdown
# Security Rules

Full spec: `rules/security-rules.md`

## Secrets
- NEVER hardcode secrets in source code, prompts, or tool arguments
- All secrets in `.env` or `secrets/` only. Reference via environment variables.
- Scan output for secret patterns before completing any task. If found — stop, redact, alert user.

## Execution Risk Tiers
- LOW (read, search, lint, test): proceed
- MEDIUM (edit, commit, install): proceed, user reviews
- HIGH (delete, push, force, deploy, CI/CD, .env/secrets/): ALWAYS confirm first

## Blast Radius
- Stay within project directory unless explicitly told otherwise
- Use branches/worktrees for risky work — never main directly
- Prefer reversible actions; never include secrets in outbound API calls

## Backup Awareness
- Warn before overwriting non-git-tracked files
- Never force-push without confirming remote state
- Flag files that cannot be easily recreated
```

(Same content as Cursor version minus the frontmatter — AntiGravity does not use path-scoping frontmatter.)

- [ ] **Step 5: Verify line counts**

Run:
```bash
wc -l /Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/CLAUDE.md
wc -l /Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/GEMINI.md
```

Expected: Both under 80 lines.

- [ ] **Step 6: Commit**

```bash
git add CLAUDE.md GEMINI.md .cursor/rules/security.md .agents/rules/security.md
git commit -m "feat(security): add Layer 2 agent EPS rules — security sections across all 4 AI tool configs"
```

---

## Task 3: Layer 3 — Pre-commit Hook Configuration

**Files:**
- Create: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/.pre-commit-config.yaml`
- Create: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/.gitleaks.toml`

- [ ] **Step 1: Create .pre-commit-config.yaml**

```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.21.2
    hooks:
      - id: gitleaks
```

- [ ] **Step 2: Create .gitleaks.toml**

```toml
title = "LTC Security — Secret Detection"

# Uses gitleaks default rules (~100+ patterns)
# Covers: AWS, GCP, GitHub, Slack, Anthropic, OpenAI,
# generic API keys, private keys, JWTs, connection strings.
# No custom rules needed — defaults are sufficient.

[allowlist]
description = "LTC template allowlist"
paths = [
    '''rules/security-rules\.md''',
    '''\.gitleaks\.toml''',
]
```

- [ ] **Step 3: Verify gitleaks config syntax**

Run:
```bash
cd /Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
# Check TOML is valid (Python has built-in tomllib since 3.11)
python3 -c "import tomllib; tomllib.load(open('.gitleaks.toml', 'rb')); print('TOML valid')"
# Check YAML is valid
python3 -c "import yaml; yaml.safe_load(open('.pre-commit-config.yaml')); print('YAML valid')"
```

Expected: Both print "valid".

- [ ] **Step 4: Commit**

```bash
git add .pre-commit-config.yaml .gitleaks.toml
git commit -m "feat(security): add Layer 3 pre-commit hook — gitleaks secret detection"
```

---

## Task 4: Documentation — rules/security-rules.md

**Depends on:** Tasks 1, 2, 3 (references their exact content)

**Files:**
- Create: `/Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/rules/security-rules.md`

- [ ] **Step 1: Write rules/security-rules.md**

This is the full reference document. Structure (from spec Section 3):

1. **Purpose & Philosophy** (~10 lines) — Security > Quality, Zero Tolerance, grounded in LT-5/LT-6/LT-8
2. **The 3-Layer Defense-in-Depth Model** (~30 lines) — Diagram, what each layer catches/misses, gap analysis
3. **The 6 Security Rules — Full Specification** (~80 lines) — Each rule with: statement, LT compensation, LTC wiki trace, compliant/non-compliant examples, enforcing layer(s)
4. **Execution Risk Tier Reference** (~20 lines) — Full LOW/MEDIUM/HIGH table with customization guidance
5. **Human Operator Guidance — Backup & Recovery** (~20 lines) — Git as backup, commit-before-modify, LTC data storage reference
6. **Setup Instructions** (~15 lines) — pre-commit install, verify, false positive handling

Total target: ~175 lines.

Content source: The spec document at `docs/superpowers/specs/2026-03-17-security-rules-design.md` contains ALL the content for this file. The task is to reorganize Sections 1-6 of the spec into the rules/ format, removing the "deliverables" and "audit criteria" sections (those are spec-only) and adding the setup instructions.

Key differences from the spec:
- The spec is a design document (explains decisions). The rules file is a reference document (explains what to do).
- Remove "Compensates for" and "Traces to" fields from each rule — move to a summary table at the end for traceability.
- Keep compliant/non-compliant examples — they are the most actionable part.
- Add the setup instructions from spec Section 6.

- [ ] **Step 2: Verify line count and structure**

Run:
```bash
wc -l /Users/longhnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE/rules/security-rules.md
```

Expected: ~175 lines (±20).

- [ ] **Step 3: Commit**

```bash
git add rules/security-rules.md
git commit -m "docs(security): add security rules reference — 3-layer defense-in-depth, 6 rules, setup guide"
```

---

## Post-Implementation

After all 4 tasks complete:

1. **Code review:** Dispatch Opus sub-agent to objectively audit all artifacts against the spec
2. **Fix any issues** found by the reviewer
3. **Final verification:** Ensure all files are committed and consistent
