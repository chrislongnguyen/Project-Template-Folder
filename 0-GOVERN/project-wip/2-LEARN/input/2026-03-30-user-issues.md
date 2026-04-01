---
version: "1.0"
last_updated: 2026-03-30
source: "team discussion transcripts (2x sessions)"
participants: ["Đạt", "Khang", "Long", "Vinh"]
type: raw-input
---
# User Issues & Clarifications — 2026-03-30

## Context

Two sessions recorded: (1) user issues from Đạt and Khang, (2) discussion with Vinh on architecture and adoption. The template serves Human as Director following the ALPEI flow (Align → Learn → Plan → Execute → Improve), with Agent as Do-er (Responsible). The repo is a 7-CS system — but ALPEI zones are the primary lens users navigate.

## Session 1: User Issues (Đạt, Khang)

### Đạt — Subfolder Clarity & Agent Guessing

> "Đạt đang nói là Đạt không hiểu subfolder trong từng phase Align có quan trọng để làm không. Và cái em thấy là mấy con agent nó phải guess khá là nhiều."

> "ADR hay là diagram rồi metadata object ở trong plan á thì là mình không có một cái description cụ thể gì cho nó hết á."

> "Agent nó sẽ bỏ qua nếu mình không có instruction cho nó."

> "Em cứ execute luôn. Nhưng mà em vẫn research, em vẫn làm plan các kiểu bình thường. Nhưng một số cái đó thì em không tìm thấy hoặc là em thấy nó guess thì em không cho nó làm luôn."

Issues (sustainability — basic usability preventing adoption):
1. **Zone subfolders have no description** — both Human and Agent skip them. Agent guesses or bypasses entirely without instructions.
2. **ADR, diagram, metadata folders in PLAN have no specific guidance** — no description of what goes where.
3. **Skills in nested folders get invoked outside intended scope** — skills meant for one context bleed into others. Users place skills at project root, so nested scoping breaks.

### Khang — Release & Version Tracking

Issues (sustainability — basic usability preventing adoption):
1. **No release announcement flow** — wants to know when template updates ship and what changed.
   > "Em nghĩ em cần một cái review flow cho những cái lần deploy... ví dụ như là khi nào anh update cái framework khi nào anh release."
2. **Version tracking unclear** — which iteration, which version, how to tell what's current.
   > "Có thể nói timing luôn ví dụ version mấy, version mấy... cho nó dễ nhận biết."
3. **Deep nesting causes agent skipping** — files at deep levels or with too many files cause agents to occasionally skip content.

### Long — Clarification on Iteration Model

Long explained in response:
- **I0–I4 iteration model** — 5 iterations total. Each maps to a version: I1 = 1.x, I2 = 2.x, etc.
- **Delivery via PRs** — incremental releases within each iteration. Each PR = a delivery.
- **I1 = Sustainability** — safe to use. Not efficient or scalable yet — that comes in I2 (Efficiency) and I3 (Scalability). The S → E → Sc progression.
- **Đạt and Khang's issues are sustainability issues** — basic usability problems that prevent adoption. These belong in I1 scope.

## Session 2: Discussion with Vinh

### Vinh — ALPEI as Flow, DSBV as Internal Process

Vinh clarified the distinction between zones and process:
- **ALPEI zones are the FLOW** — the sequence Human Director follows: Align → Learn → Plan → Execute → Improve
- **DSBV is the INTERNAL PROCESS** within each zone — Design → Sequence → Build → Validate produces artifacts inside a zone
- Users navigate zones; DSBV is how artifacts are produced within zones

### Vinh — Three Types of Learning

Vinh distinguished three learning types with different lifecycles, all in the LEARN zone:
1. **Genesis frameworks** (org-level) — philosophy, principles, canonical frameworks → lives in `_genesis/`
2. **Tool/platform knowledge** (operational) — how to use specific tools and platforms
3. **Per-project exploration** (project-level) — research and discovery specific to one project → lives in `2-LEARN/`

> "Cái learn á là con người á là cái con A [Accountable] này nè sẽ work a lot. Work a lot."

### Vinh — ALIGN Serves Human-Human Alignment

> "Cái alignment nó serve cái purpose là align trên đây. Human với human."

- ALIGN in the repo is forked from human-human alignment on the WMS
- It mainly maintains human-agent alignment for that specific project
- Human-human alignment first appears on WMS, second in `_genesis/` (philosophy, framework, principles as canonical docs)

### Vinh — The Repo IS a 7-CS System

The template is a 7-CS system — but this is a property of the design, not the organizing principle. The Human thinks in ALPEI zones. Every component (EOE, EOT, EOP) enables Human (Director, Accountable) and Agent (Do-er, Responsible).

### Vinh — Adoption as Success Metric

> "Success metrics của em bây giờ á không phải product function nữa mà nó là adoption."

Vinh emphasized: the biggest risk is not design quality but user adoption. Friction kills adoption. The template must enable Human Director to leverage EOE, EOT, EOP to harness Agent effectively.

## Team Consensus — Sustainability First, Don't Front-Run Solutions

> "Em không muốn introduce cái solution ahead of time khi mà người ta chưa gặp vấn đề."

This is a sustainability principle: don't introduce solutions before users hit the problem. Let users raise issues through practice (git, version control). Slower but each addressed issue gets adopted. Friction kills adoption.

> "Nó không phải là cái framework mà là cái thói quen." — It's not about the framework, it's about the habit.

## Attachments

- Raw transcript (users): `docs/idea/LTC APEI PROJECT_ISSUES FROM USERS 30032026`
- Raw transcript (Vinh): `docs/idea/LTC APEI PROJECT_Discussion with anh Vinh 30032026`
