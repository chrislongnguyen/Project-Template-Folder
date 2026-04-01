<!-- GOVERN workstream agent-facing copy. Human-readable version: _genesis/security/SECURITY_HIERARCHY.md -->
# LTC Security Rules — AI Agent Reference

> Full reference for AI agent security behavior. Distilled rules are loaded via CLAUDE.md / GEMINI.md / .cursor/rules/ / .agents/rules/. This file provides the rationale, examples, and setup instructions.

**Version:** 1.0
**Date:** 2026-03-17
**Task:** OPS_-4215 (task reference may be truncated — verify in ClickUp)

---

## 1. Purpose & Philosophy

**Security is more important than quality of work.** Clients may forgive subpar analysis. They will not forgive a data breach. This is LTC's foundational security principle.

**Zero tolerance for speed-over-security.** Compromising security to get things done quickly is a serious violation. The "Convenience Bias" — humans (and agents) defaulting to the path of least resistance — is the primary threat this system disables.

**Why agents need security rules:** LLM agents have structural limits that create security-relevant failure modes:
- **LT-5 (Plausibility over truth):** The agent may embed a secret in code because it "looks helpful"
- **LT-6 (No persistent memory):** The agent doesn't remember what was sensitive in a prior session
- **LT-8 (Alignment approximate):** Under complex task pressure, the agent may drift from security rules

These are not bugs to be fixed. They are physics to be compensated for. The 6 rules below exist because the agent alone cannot overcome these limits.

---

## 2. The 3-Layer Defense-in-Depth Model

No single layer is sufficient. Each layer catches what the others miss.

```
Layer 3: PRE-COMMIT HOOK (gitleaks)
  ├── Hard gate — blocks commits containing detected secrets
  ├── Catches: API keys, private keys, tokens, JWTs, connection strings, high-entropy strings
  └── Cannot catch: low-entropy secrets, PII, prompt leaks, classification violations

Layer 2: AGENT EP (CLAUDE.md / GEMINI.md / .cursor/rules/ / .agents/rules/)
  ├── Always-loaded rules — agent self-enforces every session
  ├── Catches: secrets in prompts/output, PII, execution risk, blast radius, backup awareness
  └── Cannot catch: what LT-8 causes agent to miss under complex task pressure
      (LT-2/LT-4 degrade Layer 2 effectiveness under high context load)

Layer 1: STRUCTURAL CONVENTION (.gitignore + file conventions)
  ├── Passive defense — prevents accidental inclusion by path
  ├── Catches: .env, secrets/, .backup/, private keys by extension
  └── Cannot catch: secrets hardcoded in source files
```

**Layer 1** prevents accidents. **Layer 2** guides judgment. **Layer 3** is the hard gate.

### What the hook catches vs. what the agent must catch

| Threat | Hook (Layer 3) | Agent EP (Layer 2) | Why |
|--------|:-:|:-:|-----|
| API keys (AWS, GCP, Anthropic, etc.) | Y | Y | Hook detects patterns; agent should not write them |
| Private keys (.pem, .key) | Y | Y | Hook + gitignore both block |
| Connection strings with credentials | Y | Y | Hook detects embedded passwords |
| High-entropy tokens (JWT, OAuth) | Y | Y | Hook flags unusual entropy |
| Low-entropy secrets (short passwords) | - | Y | Too short for pattern detection |
| PII (names, emails, phone numbers) | - | Y | Not a key pattern |
| Secrets in prompts or console output | - | Y | Hook only runs on commits |
| Data classification violations | - | Y | Semantic, not pattern-based |
| Outbound data exfiltration via API calls | - | Y | No commit involved |

---

## 3. The 6 Security Rules

### Rule 1: Limit Blast Radius

For destructive or experimental operations, prefer git worktrees or branches. Never operate directly on main for risky work. Operate only within the project directory unless explicitly instructed otherwise.

**Compliant:**
- Create a feature branch before experimental changes
- Use `git worktree` for isolated experimentation
- Stay within project directory boundaries

**Non-compliant:**
- Force-push to main without confirmation
- Modify files outside the project directory
- Run destructive commands (rm -rf, DROP TABLE) on main branch

---

### Rule 2: Risk-Tiered User Review

All agent actions are classified into risk tiers. High-risk actions ALWAYS require explicit user confirmation.

| Tier | Actions | Agent Behavior |
|------|---------|---------------|
| **LOW** | Read files, search, lint, run tests, list directories | Proceed without confirmation |
| **MEDIUM** | Edit files, git commit, install packages, create files | Proceed — user can review via diff |
| **HIGH** | Delete files, git push, force operations, deploy, modify CI/CD, touch `.env`/`secrets/`, database writes, send external messages | ALWAYS require explicit user confirmation |

**Customization:** Projects can adjust tier assignments in their project-level CLAUDE.md. For example, a data pipeline project might elevate "database write" from HIGH to require two-person approval.

---

### Rule 3: No Secrets in Source, Prompts, or Output

NEVER hardcode secrets (API keys, tokens, passwords, connection strings) in source code, prompts, or tool arguments. All secrets MUST live in `.env` or `secrets/` (both gitignored). Reference via environment variables only.

**Compliant:**
- `os.getenv("API_KEY")` in code
- `.env.example` with placeholder values (no real secrets)
- Warning user when they paste a key into the conversation

**Non-compliant:**
- `api_key = "sk-ant-api03-..."` in source
- Including a token in a shell command argument
- Committing a `.pem` file

---

### Rule 4: Self-Check for Leaked Sensitive Information

Before completing any task, review output for patterns that look like secrets (API keys, tokens, passwords, connection strings, PII) regardless of whether you have access to the `.env` file. The self-check is pattern-based, not value-matching. If any secret, API key, password, token, PII, or confidential data appears in output, staged files, or committed code — stop, redact, and alert the user.

**Compliant:**
- Noticing a database password in output and redacting it
- Flagging: "This response contains an email address from the source data — should I redact?"

**Non-compliant:**
- Returning API keys in a code block without flagging
- Including PII from a data file in a summary

**If a secret is already committed:**
1. Do NOT rewrite git history without explicit user approval
2. Inform the user that the committed secret should be rotated immediately
3. Identify the specific commit(s) containing the leak

---

### Rule 5: Scoped Access

Operate only within the project directory unless explicitly instructed otherwise. Do not read, write, or execute files outside the project boundary. When accessing external resources (APIs, databases), confirm scope with the user first.

**Outbound network requests:** When making external API calls or web requests, never include secrets, PII, or confidential data in request parameters, headers, or bodies unless the endpoint is explicitly authorized by the user.

**Compliant:**
- Work within `/project-root/` only
- Ask before accessing `~/.ssh/config` or other system files
- Confirm database scope before running queries

**Non-compliant:**
- Reading `/etc/passwd` or `~/.env` without asking
- Modifying files in a sibling repository
- Accessing production database when development was intended

---

### Rule 6: Backup Awareness

Before overwriting non-git-tracked files, warn the user that the original is not recoverable. NEVER force-push without confirming the remote state and getting explicit approval. If a file cannot be easily recreated, flag this before modifying it.

**Compliant:**
- Warning: "This file is not tracked by git. Overwriting it is irreversible. Proceed?"
- Committing current state before major refactoring
- Checking `git status` before force operations

**Non-compliant:**
- Overwriting an untracked config file without warning
- Running `git reset --hard` without checking for uncommitted work
- Deleting files without verifying they exist in git history

---

## 4. Traceability Matrix

| Rule | LT Compensated | LTC Wiki/SOP Source | Enforcing Layer(s) |
|------|---------------|--------------------|--------------------|
| 1. Blast Radius | LT-8, LT-1 | Wiki: Zero Trust Architecture; SOP: Data loss risk | Layer 2 |
| 2. Risk-Tiered Review | LT-8, LT-3 | Wiki: Zero tolerance for speed-over-security; SOP: Device Security | Layer 2 |
| 3. No Secrets | LT-5, LT-8, LT-6 | Wiki Policy 3: No Public Sharing; SOP: Data Handling; Principle: Zero Trust | Layers 1, 2, 3 |
| 4. Self-Check | LT-5, LT-8 | SOP: Incident Reporting; Principle: Ethics Above All | Layers 2, 3 |
| 5. Scoped Access | LT-8, LT-1 | Principle: Least Privilege; SOP: Data Access | Layer 2 |
| 6. Backup Awareness | LT-6, LT-8 | SOP: Data loss risk; Wiki: Data as asset | Layer 2 |

---

## 5. Human Operator Guidance — Backup & Recovery

These items are not agent-enforceable. They are the human operator's responsibility.

- **Git is the primary backup.** If it's not committed, it doesn't exist.
- **Commit before modifying.** Anything not easily recreated should be committed before modification.
- **LTC data storage policies apply.** Google Drive and encrypted drives (per LTC SOP) cover offsite backup. Do not duplicate those policies here.
- **The `secrets/` directory requires separate backup.** It is gitignored by design. Back it up via encrypted means per LTC SOP (Cryptomator, IronKey, or Proton Drive for RESTRICTED data).
- **Incident response:** If a secret is committed and pushed, rotate the secret immediately. Do not rely on git history rewriting as a remediation — treat the secret as compromised.

---

## 6. Setup Instructions

### One-time setup (per clone)

```bash
# Install pre-commit framework
pip install pre-commit   # or: brew install pre-commit

# Install the hooks defined in .pre-commit-config.yaml
pre-commit install

# Verify everything works
pre-commit run --all-files
```

### Handling false positives

If gitleaks flags a legitimate string (e.g., a test fixture, documentation example):

1. Add the file path to the allowlist in `.gitleaks.toml`:
   ```toml
   [allowlist]
   paths = [
       '''rules/security-rules\.md''',
       '''\.gitleaks\.toml''',
       '''tests/fixtures/mock-config\.json''',  # example
   ]
   ```

2. Or add an inline comment to suppress a specific line:
   ```python
   test_token = "fake-token-for-testing"  # gitleaks:allow
   ```

3. Re-run: `pre-commit run --all-files` to verify the fix.

### Verifying the 3 layers are active

| Layer | How to verify |
|-------|--------------|
| Layer 1 (Structural) | `git status` should not show `.env`, `secrets/`, or `*.pem` files |
| Layer 2 (Agent EP) | Check that CLAUDE.md/GEMINI.md contains the `## Security` section |
| Layer 3 (Hook) | `pre-commit run --all-files` should complete without errors |

## Links

- [[CLAUDE]]
- [[DESIGN]]
- [[GEMINI]]
- [[SECURITY_HIERARCHY]]
- [[documentation]]
- [[project]]
- [[security]]
- [[task]]
- [[workstream]]
