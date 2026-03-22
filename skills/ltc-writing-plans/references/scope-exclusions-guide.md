# Scope Exclusions Guide — Writing Effective HOW NOT Sections

> Use this guide when writing the **HOW NOT** section of each deliverable in an implementation plan.
> HOW NOT sections are mandatory (Fix 4, Check 7). This guide provides patterns, anti-patterns, and worked examples.

---

## Why HOW NOT Sections Matter

Agents drift. Without explicit negative constraints, an agent executing a task will:
- Take the path of least resistance (not always the right path)
- Import or reuse libraries that introduce unintended side effects
- Scope-creep into adjacent problems
- Prefer familiar patterns over the codebase-correct patterns

HOW NOT sections force the plan author to make rejection decisions explicit and give executing agents a concrete guard rail. They are the difference between "the agent built the right thing" and "the agent built something that works but breaks the system."

---

## The Anatomy of a Good HOW NOT Entry

Every entry must have two parts:

```
Do NOT [specific action or approach] — [specific consequence or reason]
```

**Bad (vague):**
> Do NOT over-engineer this

**Bad (no reason):**
> Do NOT use Redux

**Good:**
> Do NOT use Redux for state management — this component is local-only; adding Redux would require wiring a store that doesn't exist in this codebase and introduces a dependency with no upside

**Good:**
> Do NOT add error handling for network timeouts in this task — that is handled by the retry wrapper in `src/utils/retry.ts`; adding duplicate handling here creates conflicting behavior

---

## Pattern Library

### Pattern 1: "This is handled elsewhere"

Use when the excluded action is correct in general, but already handled by another component.

```
Do NOT implement [X] here — [X] is already handled by [specific file/function/layer]; adding it here creates duplicate logic that will diverge
```

Example:
> Do NOT validate the input schema in this handler — schema validation is the responsibility of `middleware/validate.ts:validateRequest()`. Adding it here bypasses the middleware and creates a second validation path that will fall out of sync.

### Pattern 2: "Wrong abstraction level"

Use when the excluded action is operating at the wrong layer.

```
Do NOT [action] at this layer — [reason this layer is not responsible]; this belongs in [correct layer]
```

Example:
> Do NOT write database queries directly in the controller — all DB access goes through the repository layer in `src/repositories/`. Writing queries in the controller couples presentation logic to data access and breaks the test isolation this codebase relies on.

### Pattern 3: "Scope boundary"

Use when the excluded action is adjacent to the deliverable but out of scope for this build.

```
Do NOT implement [adjacent feature] — it is out of scope for this deliverable; it is tracked separately as [AC-ID or ticket reference] and will be built in [D# or later phase]
```

Example:
> Do NOT add Notion sync support in this adapter — Notion integration is deferred to iteration 2 per spec §9.3. Building it now creates an untested dependency with no AC coverage in this plan.

### Pattern 4: "Copy-modify anti-pattern"

Use when there is a tempting shortcut that creates long-term problems.

```
Do NOT copy [existing file] and modify it — [reason; usually creates divergence or duplication]; instead [correct approach]
```

Example:
> Do NOT copy the OE.6.1 VANA-SPEC template and modify it — the OE.6.1 template lacks §0 Force Analysis and §6 Agent Architecture sections that are required by the OE.6.4 spec; start from the OE.6.4 template or build from spec §5.1 directly.

### Pattern 5: "Technology exclusion"

Use when a specific technology, library, or tool must not be used.

```
Do NOT use [technology] — [specific reason: performance, licensing, architectural mismatch, or existing equivalent]
```

Example:
> Do NOT use `moment.js` for date formatting — it is not installed in this codebase and is deprecated; use the native `Date.toISOString()` and the existing `src/utils/date.ts` helpers instead.

### Pattern 6: "Config-as-code anti-pattern"

Use when the excluded action would hardcode something that should be configurable.

```
Do NOT hardcode [value] — [reason]; it belongs in [config location]
```

Example:
> Do NOT hardcode the ClickUp field UUID for `task_type` — UUIDs change per workspace and are already defined in `skills/ltc-wms-adapters/clickup/field-map.md`; reference that file rather than embedding the UUID in the script.

### Pattern 7: "Premature optimization"

Use when the excluded action adds complexity the system does not yet need.

```
Do NOT [optimization] at this stage — [YAGNI reason]; add it only when [trigger condition]
```

Example:
> Do NOT add caching to this endpoint — the current load profile does not justify the added complexity, and there is no AC requiring it; add caching only when load testing (Stage 6) reveals a latency AC is failing.

---

## How Many Entries Per Deliverable

| Deliverable Complexity | Minimum Entries | Recommended Entries |
|---|---|---|
| Low (1–2 simple tasks) | 2 | 2–3 |
| Medium (3–4 tasks, mixed complexity) | 2 | 3–4 |
| High (5+ tasks or high-complexity tasks) | 3 | 4–6 |

More entries are better than fewer, but only if each entry is specific. Vague entries add noise without protection.

---

## Anti-Patterns to Avoid in HOW NOT Sections

| Anti-Pattern | Why It Fails | Fix |
|---|---|---|
| "Do NOT over-engineer" | Vague — every agent thinks their approach is appropriate | Name the specific pattern to avoid |
| "Do NOT use bad patterns" | Meaningless without specifying what "bad" means here | Name the pattern and why it is wrong in this context |
| "Do NOT skip tests" | This is already a plan-level rule; repeating it adds noise | Reserve HOW NOT for deliverable-specific exclusions |
| "Do NOT change unrelated files" | True, but generic — every HOW NOT should be deliverable-specific | Identify the specific files that are off-limits and why |
| Entry with no reason | An agent cannot evaluate the constraint without the "why" | Always append "— [reason]" |

---

## Checklist Before Committing a HOW NOT Section

- [ ] Every entry follows "Do NOT [action] — [reason]" format
- [ ] Every reason is specific (names files, functions, ACs, or architectural layers)
- [ ] No entries repeat plan-level rules (DRY, TDD, atomic commits) — those apply everywhere
- [ ] Each entry reflects a real decision made during plan design (not boilerplate)
- [ ] At least 2 entries per deliverable (per validation Check 7)
