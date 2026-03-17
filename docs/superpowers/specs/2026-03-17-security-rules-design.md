# Security Rules Design — OPS_OE.6.4.LTC-PROJECT-TEMPLATE

**Date:** 2026-03-17
**Task:** OPS_-4215 — LTC Security Rules (Work Review Guardrails, User Authentication, Data Access, Data Classification)
**Status:** Design approved, pending implementation

---

## 1. Purpose

Translate LTC's cybersecurity philosophy into AI-agent-enforceable rules for the project template. Every project cloned from this template inherits a working security posture from day 1.

**Grounding:**
- LTC Wiki: "Security is more important than our quality of work. Clients WILL NOT give a second chance for security failures."
- LTC Operating Principles: UBS = Convenience Bias; UDS = Zero Trust + Stewardship
- Doc-9 (Agent System Ultimate Truths): LT-5 (plausibility over truth), LT-6 (no memory), LT-8 (alignment approximate) mean agents WILL leak, drift, or destroy if uncompensated

**Scope:** AI-agent-only. Human-side policies (Yubikey, VPN, device encryption, physical document storage) already live in the ClickUp Wiki and SOP. This spec covers what AI agents can enforce during code execution.

---

## 2. Architecture: 3-Layer Defense-in-Depth

```
Layer 3: PRE-COMMIT HOOK (gitleaks)
  ├── Hard gate — blocks commits containing detected secrets
  ├── Catches: API keys, private keys, tokens, JWTs, connection strings, high-entropy strings
  └── Cannot catch: low-entropy secrets, PII, prompt leaks, classification violations

Layer 2: AGENT EPS (CLAUDE.md / GEMINI.md / .cursor/rules/ / .agents/rules/)
  ├── Always-loaded rules — agent self-enforces every session
  ├── Catches: secrets in prompts/output, PII, execution risk, blast radius, backup awareness
  └── Cannot catch: what LT-8 causes agent to miss under complex task pressure
      (LT-2/LT-4 degrade Layer 2 effectiveness under high context load)

Layer 1: STRUCTURAL CONVENTION (.gitignore + file conventions)
  ├── Passive defense — prevents accidental inclusion by path
  ├── Catches: .env, secrets/, .backup/, private keys by extension
  └── Cannot catch: secrets hardcoded in source files
```

**Why all 3 layers:** No single layer is sufficient. Layer 1 prevents accidents. Layer 2 guides the agent's judgment. Layer 3 is the hard gate that catches what Layers 1 and 2 miss. This mirrors LTC's "Brake Before Gas" principle — derisk at every level before driving output.

---

## 3. The 6 Security Rules — Full Specification

### Rule 1: Limit Blast Radius (Task Item #1)

**Statement:** For destructive or experimental operations, prefer git worktrees or branches. Never operate directly on main for risky work. Operate only within the project directory unless explicitly instructed otherwise.

**Compensates for:** LT-8 (alignment approximate — agent may execute destructive operations without considering consequences), LT-1 (hallucination — agent may misidentify which files are safe to modify)

**Traces to:** LTC Wiki Principle: Zero Trust Architecture; SOP Risk: "Loss of data from stolen or lost devices" (adapted to: loss of data from uncontrolled agent operations)

**Enforced by:** Layer 2 (agent EPS rule)

**Compliant behavior:**
- Agent creates a feature branch before making experimental changes
- Agent uses `git worktree` for isolated experimentation
- Agent stays within project directory boundaries

**Non-compliant behavior:**
- Agent force-pushes to main without confirmation
- Agent modifies files outside the project directory
- Agent runs destructive commands (rm -rf, DROP TABLE) on main branch

---

### Rule 2: Risk-Tiered User Review (Task Item #2)

**Statement:** All agent actions are classified into risk tiers. High-risk actions ALWAYS require explicit user confirmation.

**Risk Tiers:**

| Tier | Actions | Agent Behavior |
|------|---------|---------------|
| LOW | Read files, search, lint, run tests, list directories | Proceed without confirmation |
| MEDIUM | Edit files, git commit, install packages, create files | Proceed — user can review via diff |
| HIGH | Delete files, git push, force operations, deploy, modify CI/CD, touch `.env`/`secrets/`, database writes, send external messages | ALWAYS require explicit user confirmation |

**Compensates for:** LT-8 (alignment approximate), LT-3 (reasoning degrades on complex tasks — agent may not realize an action is destructive in a multi-step chain)

**Traces to:** LTC Wiki Principle: "There is absolutely no tolerance for getting things done quick at all cost"; SOP Step 1: Device Security (adapted to: execution security)

**Enforced by:** Layer 2 (agent EPS rule). Note: Claude Code and Cursor have built-in permission modes that complement this — the EPS rule provides the LTC-specific classification.

**Compliant behavior:**
- Agent asks "This will delete 3 untracked files. Confirm?" before `rm`
- Agent asks before `git push` every time
- Agent proceeds with file edits, user reviews via diff

**Non-compliant behavior:**
- Agent deletes files without asking
- Agent auto-pushes after committing
- Agent modifies `.env` without confirmation

---

### Rule 3: No Secrets in Source, Prompts, or Output (Task Item #3)

**Statement:** NEVER hardcode secrets (API keys, tokens, passwords, connection strings) in source code, prompts, or tool arguments. All secrets MUST live in `.env` or `secrets/` (both gitignored). Reference via environment variables only.

**Compensates for:** LT-5 (plausibility over truth — embedding a key "looks helpful"), LT-8 (alignment approximate — agent may not recognize something as a secret), LT-6 (no memory — agent doesn't remember what was sensitive in a prior session)

**Traces to:** LTC Wiki Policy 3: No Public Sharing; SOP Step 3: Data Handling & Classification; LTC Operating Principle: Zero Trust

**Enforced by:** All 3 layers.
- Layer 1: `.gitignore` excludes `.env`, `secrets/`, key file extensions
- Layer 2: Agent EPS rule prohibits hardcoding and requires env var references
- Layer 3: `gitleaks` pre-commit hook detects secrets in staged files

**Compliant behavior:**
- Agent writes `os.getenv("API_KEY")` in code
- Agent creates `.env.example` with placeholder values (no real secrets)
- Agent warns when user pastes a key into the conversation

**Non-compliant behavior:**
- Agent writes `api_key = "sk-ant-api03-..."` in source
- Agent includes a token in a shell command argument
- Agent commits a `.pem` file

---

### Rule 4: Self-Check for Leaked Sensitive Information (Task Item #4)

**Statement:** Before completing any task, review output for patterns that look like secrets (API keys, tokens, passwords, connection strings, PII) regardless of whether you have access to the `.env` file. The self-check is pattern-based, not value-matching. If any secret, API key, password, token, PII (names, emails, phone numbers), or data marked CONFIDENTIAL/RESTRICTED appears in output, staged files, or committed code — stop, redact, and alert the user.

**Compensates for:** LT-5 (plausibility over truth — agent presents sensitive data as normal output), LT-8 (alignment approximate — agent may include secrets without flagging them)

**Traces to:** LTC SOP Step 5: Incident Reporting (adapted to: agent-level incident detection); LTC Operating Principle: "Ethics Above All"

**Enforced by:** Layer 2 (agent EPS rule) + Layer 3 (hook catches what agent misses in committed files)

**What agent self-check covers that the hook cannot:**

| Gap | Why hook misses it | Agent EPS compensates |
|-----|-------------------|----------------------|
| Low-entropy secrets | Doesn't look "secret" to pattern matching | "Never hardcode ANY credential, regardless of length" |
| PII in output | Not a key pattern | "Scan output for PII before returning" |
| Secrets in prompts/logs | Hook only runs on commits | "Never include secrets in tool call arguments or console output" |
| Classification violations | Semantic, not pattern-based | "Respect data classification context" |

**Compliant behavior:**
- Agent notices a database password in its own output and redacts it
- Agent flags "This response contains an email address from the source data — should I redact?"

**Non-compliant behavior:**
- Agent returns API keys in a code block without flagging
- Agent includes PII from a data file in its summary

**Post-detection incident response:**
- Do NOT attempt to rewrite git history without explicit user approval
- Inform the user that any committed secret should be rotated immediately
- Identify the specific commit(s) containing the leak

---

### Rule 5: Scoped Access (Task Item #5)

**Statement:** Operate only within the project directory unless explicitly instructed otherwise. Do not read, write, or execute files outside the project boundary. When accessing external resources (APIs, databases), confirm scope with the user first.

**Compensates for:** LT-8 (alignment approximate — agent may wander outside project), LT-1 (hallucination — agent may fabricate paths or believe files exist elsewhere)

**Traces to:** LTC Operating Principle: Principle of Least Privilege ("Users are granted the minimum levels of access necessary"); LTC SOP: Data Access controls

**Enforced by:** Layer 2 (agent EPS rule). Note: Claude Code's sandbox and permission modes provide additional enforcement at the platform level.

**Compliant behavior:**
- Agent works within `/project-root/` only
- Agent asks before accessing `~/.ssh/config` or other system files
- Agent confirms database scope before running queries

**Non-compliant behavior:**
- Agent reads `/etc/passwd` or `~/.env` without asking
- Agent modifies files in a sibling repository
- Agent accesses production database when development was intended

**Outbound network requests:** When making external API calls or web requests, never include secrets, PII, or confidential data in request parameters, headers, or bodies unless the endpoint is explicitly authorized by the user. This compensates for the exfiltration vector that Layers 1 and 3 cannot detect.

---

### Rule 6: Backup Awareness (Task Item #6)

**Statement:** Before overwriting non-git-tracked files, warn the user that the original is not recoverable. NEVER force-push without confirming the remote state and getting explicit approval. If a file cannot be easily recreated, flag this before modifying it.

**Compensates for:** LT-6 (no memory — agent doesn't know if the file has sentimental or irreplaceable value), LT-8 (alignment approximate — agent may not consider recoverability)

**Traces to:** LTC SOP Risk: "Loss of data from stolen or lost devices" (adapted to: loss of data from agent operations); LTC Wiki: data as an asset to protect

**Enforced by:** Layer 2 (agent EPS rule)

**Human Operator Guidance (not agent-enforceable):**
- Git is the primary backup. If it's not committed, it doesn't exist.
- Anything not easily recreated should be committed before modification.
- LTC's data storage policies (Google Drive, encrypted drives) cover offsite backup.
- The `secrets/` directory should be backed up separately (not in git) via encrypted means per LTC SOP.

**Compliant behavior:**
- Agent warns "This file is not tracked by git. Overwriting it is irreversible. Proceed?"
- Agent commits current state before major refactoring
- Agent checks `git status` before force operations

**Non-compliant behavior:**
- Agent overwrites an untracked config file without warning
- Agent runs `git reset --hard` without checking for uncommitted work
- Agent deletes files without verifying they exist in git history

---

## 4. Deliverables

| ClickUp Task | Type | Files | Layer |
|---|---|---|---|
| Structural Convention | Increment | `.gitignore` additions (`.env`, `.env.*`, `!.env.example`, `secrets/`, `.backup/`, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `*.jks`). These are appended to the existing `.gitignore`, not a replacement. | Layer 1 |
| Agent EPS Rules | Increment | `CLAUDE.md` security section, `GEMINI.md` security section, `.cursor/rules/security.md`, `.agents/rules/security.md` | Layer 2 |
| Pre-commit Hook | Increment | `.gitleaks.toml`, `.pre-commit-config.yaml` | Layer 3 |
| Security Rules Reference | Documentation | `rules/security-rules.md` | Full spec |

---

## 5. EPS Distillation (what goes in CLAUDE.md/GEMINI.md)

~20 lines of rule content, always-loaded. CLAUDE.md/GEMINI.md budget is 80 lines max (including all sections). Current template is ~54 lines; security adds ~20 → ~74 lines, within budget.

```
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

---

## 6. Layer 3 Configuration

### `.pre-commit-config.yaml`
```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.21.2
    hooks:
      - id: gitleaks
```

### `.gitleaks.toml`
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

### Setup (one-time per clone)
```bash
pip install pre-commit   # or: brew install pre-commit
pre-commit install
# Verify: pre-commit run --all-files
```

---

## 7. Audit Criteria

This spec should be audited against:

1. **Coverage:** Do all 6 task items have corresponding rules? (Yes — Rules 1-6 map 1:1)
2. **LT Grounding:** Does every rule trace to at least one LT from Doc-9? (Yes — LT-1, LT-3, LT-5, LT-6, LT-8 directly compensated. LT-2, LT-4, LT-7 affect security indirectly by degrading Layer 2 effectiveness under high context load — noted in architecture diagram.)
3. **Wiki Traceability:** Does every rule trace to an LTC wiki policy or principle? (Yes — see each rule's "Traces to" field)
4. **Layer Completeness:** Are all 3 layers populated? (Yes — Layer 1: .gitignore, Layer 2: EPS, Layer 3: hook)
5. **Gap Analysis:** Are the known gaps between layers documented? (Yes — Section 2 diagram + Rule 4 gap table + Rule 5 outbound network note)
6. **Token Budget:** Is the EPS distillation within budget? (~20 lines rule content; CLAUDE.md/GEMINI.md max 80 lines; current ~54 + ~20 = ~74, within budget)
7. **Consistency:** Do the rules contradict any existing CLAUDE.md content or Doc-9 principles? (No conflicts identified)
8. **Actionability:** Can an agent unambiguously determine compliant vs. non-compliant behavior for each rule? (Yes — each rule has examples. Self-check is pattern-based, not value-matching.)
