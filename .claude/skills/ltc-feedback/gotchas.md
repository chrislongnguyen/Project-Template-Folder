# /ltc-feedback — Gotchas

Known failure patterns when executing this skill. Update this file when new issues are discovered.

---

## 1. Misclassification: idea tagged as friction (or vice versa)

**What happens:** Claude classifies any negative sentiment as "friction" even when the user is describing a solution or improvement ("it would be better if X did Y"). That's an idea, not friction.

**How to detect:** Check whether the user describes a PROBLEM they encountered (friction) or a SOLUTION they envision (idea). "This broke" = friction. "This could be better" = idea.

**Fix:** Before classifying, ask: "Is the user reporting something that went wrong, or proposing something that could be better?" If unclear, ask the user.

---

## 2. Workstream detection defaults to "workstream:agent" too often

**What happens:** When the conversation involves both workstream artifacts AND agent config, Claude defaults to "workstream:agent" because .claude/ files are more salient in recent context.

**How to detect:** Check the ACTUAL file path or topic being discussed, not just the most recent tool call.

**Fix:** Match the user's complaint against the workstream table in classification-guide.md, not your recent activity.

---

## 3. gh auth failure not handled gracefully

**What happens:** If `gh` is not authenticated to the template repo, the command fails. Claude may retry repeatedly or abandon the feedback.

**How to detect:** Before running `gh issue create`, check: `gh auth status`.

**Fix:** If auth fails, do NOT retry. Format the issue body as copyable markdown and tell the user to paste it manually.

---

## 4. Severity inflation — "blocked" assigned too readily

**What happens:** Claude assigns "blocked" severity when the user is merely "confused" or "annoyed." "Blocked" means the user literally could not proceed.

**How to detect:** Did the user explicitly say they COULD NOT continue? Did they find a workaround?

**Fix:** Default to "annoying" unless the user explicitly states they could not proceed. Reserve "blocked" for dead stops.

## 5. GitHub Project board not set up (auto-triage labels land but no board view)

**What happens:** The triage workflow adds `component:*` and `priority:*` labels correctly, but there's no Project board to visualize them. Labels exist, board doesn't.

**How to detect:** `gh project list --repo REPO` returns empty.

**Fix:** Manual one-time setup in GitHub UI:
1. Repo → Projects → New Project → "Issue Triage"
2. Add automation: "When item labeled `priority:critical` → add to board"
3. Repeat for `priority:medium` and `priority:low`
4. Group by priority label, sort by created date

---

## Links

- [[CLAUDE]]
- [[SKILL]]
- [[classification-guide]]
- [[friction]]
- [[idea]]
- [[workstream]]
