# Skill Anti-Patterns

6 failure modes to avoid when creating or reviewing skills.

## 1. Mega-Skill

**Symptom:** SKILL.md body exceeds 200 lines.
**Why it fails:** Violates context budget (EOP-05). Agent accuracy degrades on mid-document content — the "lost in the middle" effect causes steps to be skipped.
**Fix:** Split into a lean SKILL.md (routing only) + references/ subdirectory for detail. The routing layer tells the agent what to do and where to find it; detail files are loaded on demand.

## 2. Ghost Skill

**Symptom:** Skill exists but never triggers when needed.
**Why it fails:** Vague description — "Manages project documentation" instead of "Use when the user asks to update the changelog after a commit." The agent cannot match user intent to a passive summary.
**Fix:** Rewrite description with specific trigger keywords and action verbs. Include the nouns and verbs a user would actually say. Test: "If the user says X, would this description match?"

## 3. Gate-Free Skill

**Symptom:** Multi-step procedure with no validation between steps. Early errors silently compound through all subsequent steps.
**Why it fails:** Violates EOP-06. The agent executes forward without pausing to verify intermediate results. A step-2 error propagates through steps 3-8 into an output that is wrong in hard-to-diagnose ways.
**Fix:** Add GATE keywords between critical steps. A GATE forces the agent to stop, check the result, and only proceed if the check passes.

## 4. Copy-Paste Skill

**Symptom:** Duplicated logic across multiple skills — the same 20 lines of boilerplate appear in 4 different SKILL.md files.
**Why it fails:** Maintenance burden multiplies. When the shared logic needs updating, you must find and update all copies. Missed copies create inconsistency.
**Fix:** Extract shared patterns into reference files in `_genesis/` or utility scripts in `scripts/`. Skills reference the shared file instead of inlining the content.

## 5. Trigger Collision

**Symptom:** Multiple skills activate on the same user request. The agent picks one arbitrarily or loads both, consuming double the context budget.
**Why it fails:** Skill descriptions overlap — both claim the same trigger territory. The agent has no way to disambiguate.
**Fix:** Make descriptions mutually exclusive. Define clear boundaries: Skill A handles X scenarios, Skill B handles Y scenarios. Run MECE check against sibling skills before committing.

## 6. God Description

**Symptom:** Description says "Use for any coding task" or "Helps with development."
**Why it fails:** Triggers too often, activating on unrelated requests. Dilutes the skill library — if everything triggers this skill, the signal-to-noise ratio drops to zero. Wastes context budget on false activations.
**Fix:** Be specific about WHEN. List concrete scenarios, action verbs, and exclusions. A good description matches 3-5 specific user intents, not all possible intents.

## Links

- [[CHANGELOG]]
- [[SKILL]]
- [[documentation]]
- [[project]]
- [[task]]
