---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: workflows
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
---

# Claude Code: Code Review

Claude Code's managed Code Review feature runs a fleet of specialized agents against GitHub pull requests and posts inline findings by severity. It is a cloud service distinct from running Claude manually in your terminal or CI.

## L1 — Knowledge

### So What? (Relevance)

Code Review gives async, automated bug-hunting on every PR without requiring team members to run Claude locally or configure GitHub Actions. For teams already on Team or Enterprise plans, it is the lowest-friction path to agentic review coverage. The tradeoff is cost ($15–25 per review) and the constraint that it only works with cloud-hosted GitHub and requires admin setup.

### What Is It?

Code Review is a managed Anthropic service that:
- Connects to GitHub via a GitHub App installed by an org admin
- Triggers on PR open, every push, or manual comment (configurable per repo)
- Runs multiple specialized agents in parallel against the diff and full codebase
- Posts findings as inline review comments on the specific lines where issues were found
- Tags each finding by severity (Important, Nit, Pre-existing)
- Does NOT approve or block PRs — findings are advisory

**Availability:** Team and Enterprise plans only. Not available for organizations with Zero Data Retention enabled.

### What Else?

**Severity levels:**

| Marker | Severity | Meaning |
|---|---|---|
| 🔴 | Important | A bug that should be fixed before merging |
| 🟡 | Nit | A minor issue, worth fixing but not blocking |
| 🟣 | Pre-existing | A bug that exists in the codebase but was not introduced by this PR |

**Review trigger modes per repository:**

| Mode | When reviews run |
|---|---|
| Once after PR creation | Runs once when a PR is opened or marked ready for review |
| After every push | Runs on every push to the PR branch; auto-resolves threads when you fix flagged issues |
| Manual | Only when someone comments `@claude review` or `@claude review once` |

**Manual trigger commands:**

| Command | What it does |
|---|---|
| `@claude review` | Starts a review AND subscribes the PR to push-triggered reviews going forward |
| `@claude review once` | Starts a single review without subscribing to future pushes |

Manual triggers work on draft PRs (explicit request signals intent regardless of draft status). They do not work on inline comments — must be top-level PR comments with the command at the start.

### How Does It Work?

1. Admin installs the Claude GitHub App (permissions: Contents read/write, Issues read/write, Pull requests read/write).
2. Admin selects repos and sets trigger mode per repo in the admin settings panel.
3. When a review triggers, multiple agents analyze the diff and surrounding codebase in parallel on Anthropic infrastructure.
4. Each agent looks for a different class of issue (logic errors, security vulnerabilities, edge cases, regressions).
5. A verification step checks candidates against actual code behavior to filter false positives.
6. Results are deduplicated, ranked by severity, and posted as inline comments.
7. If no issues are found, Claude posts a short confirmation comment on the PR.
8. A **Claude Code Review** check run is created alongside your CI checks; its Details view lists every finding in one place even if some inline comments were rejected by GitHub.

**Finding locations** (in priority order if inline comment fails):
- Inline review comments on the specific diff lines
- Annotations in the Files changed tab (separate from review comments)
- Check run Details (severity table, always available)
- "Additional findings" heading in review body (for findings on lines that moved during a concurrent push)

**Parsing findings programmatically:**

```bash
gh api repos/OWNER/REPO/check-runs/CHECK_RUN_ID \
  --jq '.output.text | split("bughunter-severity: ")[1] | split(" -->")[0] | fromjson'
# Returns: {"normal": 2, "nit": 1, "pre_existing": 0}
# "normal" = count of Important findings
```

The check run always completes neutral — it never blocks merging through branch protection. To gate on findings, parse the severity JSON from the check run output in your own CI.

## L2 — Understanding

### Why Does It Work?

Multi-agent parallelism over the full codebase (not just the diff) is what separates Code Review from simple linting. Each agent specializes in a class of issue, so the collective coverage is broader than a single-pass review. The verification step (checking candidates against actual code behavior) is why the false positive rate is lower than naive LLM review — Claude checks its own findings before posting.

The check run is the resilience layer: GitHub sometimes rejects inline comments on moved lines or rebased commits, but the check run's Details text always captures every finding regardless of GitHub's comment acceptance.

### Why Not?

- **Cost is non-trivial.** At $15–25 per review and "after every push" mode, a high-frequency PR branch can cost hundreds of dollars. Manual mode or "once after PR creation" are the right defaults for most repos.
- **Cloud-only.** For self-hosted GitHub Enterprise Server or GitLab, Code Review is not available — use GitHub Actions or GitLab CI/CD integration instead.
- **Zero Data Retention organizations cannot use it.** The service requires Anthropic infrastructure to process code.
- **Not a linter replacement.** By default it focuses on correctness bugs, not formatting or style. Adding `REVIEW.md` or `CLAUDE.md` guidance expands what it checks, but coverage is probabilistic, not exhaustive.
- **Re-run button in GitHub Checks does not work.** Use `@claude review once` or push a new commit to retrigger a failed review. The Re-run button is silently ignored.

## Sources

- https://code.claude.com/docs/en/code-review

## Links

- [[workflows/automation-and-scaling]] — self-hosted CI alternative via GitHub Actions
- [[platform/claude-code-dot-claude-directory]] — CLAUDE.md and REVIEW.md file locations
- [[platform/claude-code-cli-reference]] — `claude plugin install code-review@claude-plugins-official` for local review
