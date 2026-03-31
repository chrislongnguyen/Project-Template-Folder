# Recall Output Format

The recall output MUST be ≤10 lines total, plain text, plain spaces for indentation.

## Standard format (OPS / Registry)

```
RECALL — {repo-name}
  Last ({date}): {1-line summary of what was accomplished}
  State: {1-line current state}
  Next: {next action}
  Issues: {active issue IDs + titles, or "none"}
```

## ILE format (append to standard — still ≤10 total)

```
  Last approved: {T{n}.P{m}} — {Page Name} [{date}]
  Next up: {OPS-NN} — {next page title}
  Branch: {branch name}
```

## No prior session

```
RECALL — {repo-name}
  No prior sessions found. Ready to work.
```

## Rules
- Plain spaces only for indentation (2 per level)
- Never use HTML entities (`&nbsp;` etc.)
- Never include standup sections (DONE, BLOCKED, DOING, IN REVIEW, PROPOSED, DISCUSSION)
- Synthesize — do not dump raw qmd/vault content
