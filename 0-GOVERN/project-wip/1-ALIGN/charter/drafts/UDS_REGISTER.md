---
version: "1.1"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
---

# UDS REGISTER — Ultimate Driving System Identification
# OPS_OE.6.4.LTC-PROJECT-TEMPLATE
## Derived From: ESD §3.3 — Role-Aware UDS Analysis (R + A perspectives)
## Lens: Team 2 — User Experience & Adoption Levers

---

## Key Principle
> When replicating success, trace the chain:
> UDS → UDS.UD (what drives the driver) → UDS.UD.Principles (why it works).
> This ensures you leverage the fundamental mechanism, not just copy surface tactics.
> Every driver below is tagged to the 3-pillar framework: S (Sustainability), E (Efficiency), Sc (Scalability).

---

## Active Drivers

---

### UDS-001: Numbered Zone Folders Create Instant Visual Hierarchy

| Layer | Question | Analysis |
|-------|----------|----------|
| **2.0 UDS** | What ultimately drives success? | The 1-ALIGN, 3-PLAN, 4-EXECUTE, 5-IMPROVE naming convention creates a cognitive scaffold: numbers imply sequence, sequence implies order, order implies a starting point. A new user sees "1-ALIGN" and intuitively knows to start there |
| **2.1 UDS.UB** | What can weaken this driver? | Adding too many numbered folders (e.g., 5-LEARN, 6-OPS) dilutes the sequential signal. If the numbers don't map to a mental model the user already has, the convention backfires |
| **2.2 UDS.UD** | What makes this driver effective? | Pre-existing mental models: numbered lists = sequence = order. The convention exploits pattern recognition rather than requiring learning. "1" always comes first — this is universally understood |
| **2.3 UDS.Principles** | Why does this driver work? | Cognitive ease principle: familiar patterns require no conscious effort to interpret. The numbered folder structure is "free" learning — no training required, no documentation needed |
| **2.4 UDS.Environment** | What environment enables this driver? | GitHub file tree sorts folders alphanumerically. Numbers-first naming ensures zones appear in correct sequence in any file browser. This is environment-native |
| **2.5 UDS.Tools** | What tools enable this driver? | Any file system, any git host, any IDE — the pattern is tool-agnostic |
| **2.6 UDS.Procedure** | How to exploit this driver? | Keep zones at exactly 4 numbered folders (1-4). Never add a 5th numbered zone — this would break the APEI mental model. Use _shared/ (underscore prefix) for cross-cutting material, keeping numbers clean for the core zones |

**Leverage Strategy:** Protect the 4-number sequence as a brand asset. Every onboarding document, README, and training session starts with: "This template has 4 zones (1-ALIGN, 3-PLAN, 4-EXECUTE, 5-IMPROVE). Start at 1. Each zone feeds the next." This is the most important simplification available.
**Vulnerability:** Adding 5-LEARN or 0-GOVERNANCE breaks the clean sequence → never add numbered zones beyond 4 (cross-cutting content goes to _shared/)
**Pillar:** Sustainability (reduces cognitive failure risk), Efficiency (zero-training navigation)
**Owner:** Long Nguyen

---

### UDS-002: AI Agent Amplification — Template Quality × Agent Capability

| Layer | Question | Analysis |
|-------|----------|----------|
| **2.0 UDS** | What ultimately drives success? | A well-structured template multiplies the productivity of AI agents exponentially. An agent given a clear template, an explicit EO, and zone-scoped context can produce a complete, high-quality Charter in minutes — work that would take a human director 2+ hours |
| **2.1 UDS.UB** | What can weaken this driver? | Template ambiguity: if template fields are vague or the EO is missing, agents produce plausible-but-wrong content at high speed — errors compound faster with agents than with humans. Template quality is the amplifier; it amplifies in both directions |
| **2.2 UDS.UD** | What makes this driver effective? | Modern LLMs excel at structured text completion. A template is essentially a structured completion task. Every template field is a constraint that guides the agent toward the right answer |
| **2.3 UDS.Principles** | Why does this driver work? | Agent performance is a function of input quality (UT#1: EI determines output ceiling). A template IS the input structure. Better template = better EI = better agent output |
| **2.4 UDS.Environment** | What environment enables this driver? | CLAUDE.md as the agent's operating context. Well-named zone folders as context signals. Clear EO in Charter as agent anchor. These collectively create an environment where agents can produce correct artifacts with minimal back-and-forth |
| **2.5 UDS.Tools** | What tools enable this driver? | Claude Code, Gemini (GEMINI.md), future agents. Pre-flight protocol in CLAUDE.md. Template files as structured completion targets |
| **2.6 UDS.Procedure** | How to exploit this driver? | Invest in template clarity as if every field will be completed by an agent with no human supervision. If the agent can get it right, the human certainly can. Make inline instructions agent-parseable (specific, not vague). This principle: design for the agent, delight the human |

**Leverage Strategy:** Every template improvement that makes field instructions more specific and examples more concrete has a multiplier effect via agents. Agents are the primary users of these templates in practice — optimizing for agent readability is the highest-leverage investment.
**Vulnerability:** Agent drift when Charter/EO is missing (UBS-004) — always fix Zone 1 before Zone 2+ agent work
**Pillar:** Efficiency (agents do the work), Scalability (agents scale infinitely)
**Owner:** Long Nguyen

---

### UDS-003: Progressive Disclosure via README-First Design

| Layer | Question | Analysis |
|-------|----------|----------|
| **2.0 UDS** | What ultimately drives success? | GitHub renders the README.md at the bottom of any directory automatically. If the README is designed as the "first and only screen" a user sees, the template can guide users through a 40+ file structure by controlling what they see first |
| **2.1 UDS.UB** | What can weaken this driver? | A README that tries to explain everything becomes a wall of text — worse than no README. The README must be ruthlessly focused: 5 steps, 3 must-read files, one clear next action |
| **2.2 UDS.UD** | What makes this driver effective? | GitHub's automatic README rendering is a platform behavior the template can rely on. Users cannot bypass the README unless they deliberately scroll past it — and the README renders before the file tree is fully scanned |
| **2.3 UDS.Principles** | Why does this driver work? | Progressive disclosure: show only what is needed at each stage. The README shows the entry point; the zone README shows the zone's artifacts; the artifact template shows the field instructions. Each level reveals the next |
| **2.4 UDS.Environment** | What environment enables this driver? | GitHub (and all git hosts) render README.md at every folder level. The template can place README.md at root AND in each zone folder — creating a nested progressive disclosure system |
| **2.5 UDS.Tools** | What tools enable this driver? | Markdown rendering on GitHub, GitLab, Gitea. Per-folder README.md files |
| **2.6 UDS.Procedure** | How to exploit this driver? | Root README: navigation map only (5 steps, zone table, 3 must-reads). Zone READMEs: what to do here (3 steps max). Template files: how to fill this specific field (one line per field). Never let any README exceed one screen of essential content |

**Leverage Strategy:** Treat every README as a user-facing product, not a developer note. Apply the same discipline to README writing as to feature writing: every sentence must earn its place. Cut anything that doesn't reduce friction or prevent a mistake.
**Vulnerability:** README becomes too long → users skip it → back to the "wall of files" problem (UBS-001)
**Pillar:** Sustainability (prevents cognitive overload), Efficiency (right information at right moment)
**Owner:** Long Nguyen

---

### UDS-004: Team Pain Awareness — Khang's Onboarding Moment

| Layer | Question | Analysis |
|-------|----------|----------|
| **2.0 UDS** | What ultimately drives success? | The APEI discussion captured a real, shared pain: every team member has experienced starting a project without structure and watching it descend into chaos. This shared experience creates genuine motivation to adopt a standard — the template is not bureaucracy, it is relief |
| **2.1 UDS.UB** | What can weaken this driver? | If the template's first-use experience is MORE painful than the current ad-hoc approach, the pain awareness driver inverts — "the old way was easier." The template must deliver visible relief in the first 15 minutes |
| **2.2 UDS.UD** | What makes this driver effective? | Khang specifically expressed "the number of options is just exploding" as a real problem. Anh Long said "we've lost chain of thought on why we made choices." These are not abstract problems — they have names and faces |
| **2.3 UDS.Principles** | Why does this driver work? | Adoption happens when the new system is visibly better than the current state within the first use. If the first 15 minutes of using the template feel like progress (not bureaucracy), users will continue |
| **2.4 UDS.Environment** | What environment enables this driver? | The team is actively building projects where structure is needed. The template arrives at the moment when the pain is real, not hypothetical |
| **2.5 UDS.Tools** | What tools enable this driver? | GETTING_STARTED.md framed as "here is how this solves the problem you already have," not "here is our framework." Root README opens with the pain, not the solution |
| **2.6 UDS.Procedure** | How to exploit this driver? | Root README first paragraph: name the pain ("Have you ever started a project and lost track of why you made a decision? Can't find where the risks were documented?"). Then: "This template solves that." Users who recognize the pain will immediately invest in the solution |

**Leverage Strategy:** The README must open with the problem, not the solution. "This template gives you a 5-zone structure" is a feature. "This template ends the 'I can't find where we documented that' conversation" is a benefit. Lead with benefit.
**Vulnerability:** Pain awareness fades if the first use is difficult — must deliver visible win in first session
**Pillar:** Sustainability (adoption = system survives), Efficiency (motivated users move faster)
**Owner:** Long Nguyen

---

### UDS-005: Validation Script as Confidence Signal

| Layer | Question | Analysis |
|-------|----------|----------|
| **2.0 UDS** | What ultimately drives success? | `template-check.sh --quiet` exiting 0 gives users a binary "you did it correctly" signal. In a complex multi-file system with many conventions, having a single pass/fail check reduces anxiety and creates a clear completion marker |
| **2.1 UDS.UB** | What can weaken this driver? | A script that fails on trivial formatting issues creates noise and erodes trust. A script that passes when content is wrong creates false confidence. Both destroy the driver |
| **2.2 UDS.UD** | What makes this driver effective? | Humans and agents are motivated by measurable progress. An exit code 0 is measurable, binary, and immediate — it is the template's equivalent of a green test suite |
| **2.3 UDS.Principles** | Why does this driver work? | Closure principle: people seek closure (completion). A passing check script provides that closure for template setup. Without it, users never know if they're "done" with setup |
| **2.4 UDS.Environment** | What environment enables this driver? | Shell scripts run on any Unix-like system. The gh CLI (already in the template) handles GitHub authentication for template-check's version comparison |
| **2.5 UDS.Tools** | What tools enable this driver? | template-check.sh (existing). Can be run manually or in CI. Exit code 0 enables CI pipeline integration |
| **2.6 UDS.Procedure** | How to exploit this driver? | Make template-check.sh the last step in the GETTING_STARTED.md flow. "When this exits green, you're ready to start Zone 1." Create a success ritual: the first green check is a team celebration moment |

**Leverage Strategy:** Position template-check.sh as the "definition of done" for template setup. Reference it in GETTING_STARTED.md, zone READMEs, and standup templates ("did you run template-check this sprint?"). It becomes the shared quality signal across all projects.
**Vulnerability:** Script must be maintained as template evolves — a passing check against a stale spec is worse than no check
**Pillar:** Sustainability (reliable quality signal), Efficiency (binary check replaces manual inspection)
**Owner:** Long Nguyen

---

### UDS-006: Framework Depth as Long-Term Competitive Advantage

| Layer | Question | Analysis |
|-------|----------|----------|
| **2.0 UDS** | What ultimately drives success? | The LTC framework (8-component system model, UBS/UDS analysis, VANA requirements, 3-pillar evaluation) is proprietary and battle-tested. Projects using this framework produce higher-quality thinking artifacts than projects using ad-hoc structure. This depth is the template's long-term moat |
| **2.1 UDS.UB** | What can weaken this driver? | Complexity that scares away new users before they experience the depth's value. If onboarding is too hard, the framework's depth never gets used — it becomes a liability, not an asset |
| **2.2 UDS.UD** | What makes this driver effective? | Anh Long designed the framework from first principles over multiple years. It maps precisely to how LTC thinks about risk, value creation, and decision-making. It is not a generic template — it is LTC's operational DNA |
| **2.3 UDS.Principles** | Why does this driver work? | Network effects at the org level: as more LTC projects use the framework, the framework's outputs become comparable, combinable, and searchable. A risk from one project becomes visible to another. Decisions are traceable. The org learns faster |
| **2.4 UDS.Environment** | What environment enables this driver? | LTC operates across 8 team members and multiple concurrent projects. A shared framework creates a common language. "What's the EO?" and "have you done the UBS scan?" become standard questions that don't require framework explanation |
| **2.5 UDS.Tools** | What tools enable this driver? | The template itself is the tool. But the driver activates only when the framework language is used consistently across projects — shared vocabulary is the mechanism |
| **2.6 UDS.Procedure** | How to exploit this driver? | Conduct one 30-minute walkthrough session for each new team member using the template's worked example. Show them: "This is a UBS entry. This is what it looks like when filled in. Now fill in one for your project." The first completed artifact unlocks the framework's value — it must happen in the first session |

**Leverage Strategy:** First artifact quality is the gateway to framework adoption. Invest in making the first UBS entry and first Charter EO excellent — these are the "aha moment" artifacts that convert skeptics. REQ-009 (worked example) directly supports this.
**Vulnerability:** Framework depth requires investment to learn — must be front-loaded with visible returns in session 1
**Pillar:** Scalability (org-wide learning), Sustainability (framework survives individual team member turnover)
**Owner:** Long Nguyen (template), Anh Vinh (culture + adoption)

---

### UDS-007: CLAUDE.md as Agent Multiplier — "One File, All Context"

| Layer | Question | Analysis |
|-------|----------|----------|
| **2.0 UDS** | What ultimately drives success? | CLAUDE.md is read at the start of every Claude Code session. A well-written CLAUDE.md means every session starts with full project context, correct rules, and clear constraints — the agent does not need to re-orient, ask clarifying questions, or make assumptions about project structure |
| **2.1 UDS.UB** | What can weaken this driver? | CLAUDE.md that tries to explain everything becomes too long (>100 lines) and the model's attention degrades on critical rules buried in the middle. Also: rules that contradict between CLAUDE.md and zone-specific files create agent confusion |
| **2.2 UDS.UD** | What makes this driver effective? | The agent reads CLAUDE.md unconditionally on every session start. This is the highest-attention read in any session — it is the only file the agent is guaranteed to process |
| **2.3 UDS.Principles** | Why does this driver work? | First-read primacy: information read first has disproportionate influence on subsequent reasoning. CLAUDE.md as the first file positions its rules as the default operating context for every interaction |
| **2.4 UDS.Environment** | What environment enables this driver? | Claude Code's automatic CLAUDE.md loading. The 100-line limit in CLAUDE.md itself is a design constraint that forces prioritization |
| **2.5 UDS.Tools** | What tools enable this driver? | Claude Code (auto-loads CLAUDE.md), Gemini (GEMINI.md), future agents (AGENTS.md pattern). Each agent gets its own governance file — same principle, different syntax |
| **2.6 UDS.Procedure** | How to exploit this driver? | Structure CLAUDE.md as: (1) project identity (5 lines), (2) structure map (10 lines), (3) rules (20 lines), (4) pre-flight protocol (5 lines). Everything else goes to .claude/rules/ and is loaded on-demand. CLAUDE.md is the index; rules/ is the reference |

**Leverage Strategy:** Treat CLAUDE.md as the highest-value file in the template. Every improvement to CLAUDE.md propagates to all agents in all consumer repos. The 100-line limit is not a constraint — it is a quality gate that forces every rule to earn its place.
**Vulnerability:** Rules buried below line 60 are read with less attention — keep critical rules in the first 30 lines
**Pillar:** Efficiency (agent orientation in 0 extra steps), Scalability (same file works for any number of agents or sessions)
**Owner:** Long Nguyen

---

**Classification:** INTERNAL
