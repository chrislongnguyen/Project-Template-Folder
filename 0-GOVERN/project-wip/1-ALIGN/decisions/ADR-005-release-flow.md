---
version: "1.0"
status: Decided
last_updated: 2026-03-30
owner: Long Nguyen
decision: Option A — CHANGELOG.md + git tags
---

# ADR-005: Release Announcement Flow

## Context

Khang identified that the template has no release communication mechanism (S2-Khang, R08). Team members consuming cloned templates have no way to know when the canonical template has been updated, what changed, or whether they need to take action. This creates version drift and erodes trust in the template.

## Decision Drivers

- I1 pillar focus is Sustainability — the solution must be safe and simple before being automated
- Template is a git repo — git-native mechanisms have zero additional dependencies
- Team size is 8 — announcement reach is small, manual overhead is low
- Friction-first principle (S6) — don't add infrastructure before the problem demands it

## Options

### Option A: CHANGELOG.md + Git Tags Only

Manual CHANGELOG entry per release. Git tag per version. Team members check CHANGELOG or tag diff.

| Pillar | Evaluation |
|--------|-----------|
| **Sustainability** | **Strong.** Zero dependencies. Works even if CI, WMS, or external tools are down. CHANGELOG is a markdown file — cannot break. Git tags are native. No new tool to learn or maintain. |
| **Efficiency** | **Moderate.** Requires manual CHANGELOG entry per release (2-5 min). Team must actively check for updates (pull model, not push). Acceptable at team size 8. |
| **Scalability** | **Weak at scale.** Pull-based model does not scale past ~15 consumers. No notification mechanism. But I1 does not need to solve for 15+ consumers. |

### Option B: Automated CI/CD Announcement Hook

CI pipeline triggers on tag push. Generates release notes from commit history. Posts to Slack/email/WMS.

| Pillar | Evaluation |
|--------|-----------|
| **Sustainability** | **Weak.** Adds CI dependency. CI config is a new failure surface. Auto-generated release notes from commits are often noisy and unhelpful. Requires CI infrastructure that does not exist yet. |
| **Efficiency** | **Strong.** Fully automated — zero manual effort per release. Push-based notification. |
| **Scalability** | **Strong.** Scales to any number of consumers. Notification is automatic. |

### Option C: Manual Announcement Template in `_genesis/templates/`

A release announcement template that the maintainer fills in and posts manually (to Slack, email, or WMS).

| Pillar | Evaluation |
|--------|-----------|
| **Sustainability** | **Moderate.** Template ensures consistent format. But requires a manual posting step that can be forgotten. Two artifacts to maintain (CHANGELOG + announcement). |
| **Efficiency** | **Weak.** Manual fill + manual post = double the effort of Option A with marginal benefit. |
| **Scalability** | **Moderate.** Format scales but posting does not. |

### Option D: WMS-Integrated Release Notes

Release notes created in ClickUp/Notion. Linked to iteration milestones. Team notified via WMS.

| Pillar | Evaluation |
|--------|-----------|
| **Sustainability** | **Weak.** Adds WMS dependency. WMS integration is out of scope for I1. Creates coupling between repo state and WMS state that must be kept in sync. |
| **Efficiency** | **Moderate.** WMS notification is push-based but requires maintaining release info in two places (repo + WMS). |
| **Scalability** | **Strong.** WMS notification scales. Milestone linking provides project context. |

## Decision

**Option A: CHANGELOG.md + Git Tags Only.**

### Rationale

I1 = Sustainability. Option A has the strongest sustainability profile: zero dependencies, zero new infrastructure, zero new failure surfaces. The efficiency gap (pull-based vs push-based) is acceptable at team size 8. The scalability weakness is a known I2/I3 concern — not I1.

Option B is the natural upgrade path when CI infrastructure exists and team size grows past ~15. Recording this as a future consideration, not an I1 requirement.

### Implementation

1. Every release creates a `CHANGELOG.md` entry with: version, date, summary (≤5 bullets), consumer action required (if any)
2. Every release creates a git tag: `v{MAJOR}.{MINOR}` (e.g., `v1.0`)
3. Root `VERSION` file is updated to match the tag
4. Release announcement format is documented in this ADR — no separate template needed

### Release Announcement Format

```
## v{VERSION} — {DATE}

**Summary:**
- {change 1}
- {change 2}
- ...

**Consumer action required:** {None | description of what to do}

**Details:** See CHANGELOG.md or `git diff v{prev}..v{current}`
```

## Consequences

- **Positive:** Simple, reliable, zero-dependency release flow that works from day one
- **Negative:** Team must actively check for updates (pull model). Acceptable risk at current scale.
- **Future:** When team grows past ~15 or CI exists, evaluate Option B as an upgrade

## Traces

- Source: S2-Khang (R08 — release announcement flow must exist)
- Requirement: REQ-010 (Release Announcement Flow)
- Charter: §2 In-Scope (feedback pipeline, version tracking)

---

**Classification:** INTERNAL
