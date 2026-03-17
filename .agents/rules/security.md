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
