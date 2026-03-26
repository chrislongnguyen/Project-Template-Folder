# Agent Architecture Decision Tree

> Source: LTC Execution Pipeline Design Spec §6.1 (Fix 5)
> Use this reference when filling out the **Agent Architecture** section of each deliverable in a plan.

---

## The 2D Decision Matrix

Agent architecture is determined by two dimensions: **Task Count** (number of tasks in a deliverable) and **Task Complexity** (estimated reasoning steps per task).

### Complexity Scale

| Level | Reasoning Steps | Examples |
|---|---|---|
| **Low** | 1–5 | Config file creation, schema definition, simple CRUD |
| **Medium** | 5–10 | API integration, state management, multi-file refactor |
| **High** | 10+ | Architecture design, complex algorithm, cross-system integration |

### Decision Matrix

| | Low Complexity (1–5 steps) | Medium Complexity (5–10 steps) | High Complexity (10+ steps) |
|---|---|---|---|
| **Low Count (1–2 tasks)** | Single Agent | Sub-Agents | Agent Team |
| **Medium Count (3–4 tasks)** | Sub-Agents | Sub-Agents | Agent Team |
| **High Count (5+ tasks)** | Sub-Agents | Agent Team | Agent Team + Scoped Reviewers |

---

## Pattern Definitions

| Pattern | Structure | When to Use |
|---|---|---|
| **Single Agent** | One agent handles all tasks sequentially | Low risk, low complexity, few tasks |
| **Sub-Agents** | Lead agent delegates to specialized sub-agents | Medium on either dimension; tasks benefit from parallel execution |
| **Agent Team** | Multiple agents with coordinator + explicit handoff protocol | High on either dimension; tasks require diverse skills |
| **Agent Team + Scoped Reviewers** | Agent Team + dedicated review agents per deliverable | Both high; maximum risk requires maximum verification |

---

## Claude Code Implementation Mapping

| Pattern | Claude Code Mechanism | How It Works | Limitations |
|---|---|---|---|
| **Single Agent** | Main conversation thread | One agent executes all tasks sequentially in the primary context window. No spawning. | Context window fills over long sessions (LT-2). Use `/compress` or session breaks between tasks. |
| **Sub-Agents** | `Agent` tool (subagent dispatch) | Lead agent dispatches sub-agents via the Agent tool. Each sub-agent gets a fresh context window with a focused prompt. Lead assembles results. | Sub-agents cannot see each other's work directly. Lead must pass necessary context in the prompt. Sub-agents return a single result message. |
| **Agent Team** | `Agent` tool with `run_in_background: true` + shared `.exec/` state | Lead dispatches multiple agents in parallel via background Agent calls. Agents coordinate through `.exec/` files and `status.json` (file-based shared state). Lead polls status.json for completion. | No real-time inter-agent communication. Coordination is asynchronous via filesystem. Race conditions possible on status.json — use atomic writes. |
| **Agent Team + Scoped Reviewers** | Agent Team + dedicated review Agent calls after each deliverable | Same as Agent Team, but after each deliverable's tasks complete, a review agent is dispatched with the deliverable's .exec/ files + code output. Review agent checks ACs and produces a review report. | Review agent needs full deliverable context — ensure .exec/ files are self-contained. |

---

## Parallelism Rules

| Scenario | Parallel? | Mechanism |
|---|---|---|
| Tasks within a deliverable (no dependency) | Yes | Multiple `Agent` tool calls in a single message |
| Tasks across deliverables (no dependency) | Yes | Multiple `Agent` tool calls with `run_in_background: true` |
| Tasks with `blocked_by` dependency | No | Sequential — wait for blocking task to complete before dispatching |
| Sub-agent groups in Stage 1 brainstorming | Yes (groups), No (within group) | Dispatch all section groups as parallel Agent calls; within each group, sections are sequential |

---

## Worktree Isolation

For tasks that modify overlapping files, use `isolation: "worktree"` on the Agent tool to give each agent an isolated git worktree. The lead agent merges results after all agents complete. Use this when:
- Two tasks in the same deliverable touch the same source files
- A task's verify command might interfere with another task's state
- Risk of merge conflicts is medium or higher

---

## How to Apply

1. Count the number of tasks in the deliverable
2. Estimate the complexity of each task using the reasoning steps scale
3. Find the intersection in the decision matrix
4. State the pattern and rationale in the Agent Architecture section:

```
**Agent Architecture:** Sub-Agents — 4 medium-complexity tasks; parallel execution reduces session context load (LT-2)
```
