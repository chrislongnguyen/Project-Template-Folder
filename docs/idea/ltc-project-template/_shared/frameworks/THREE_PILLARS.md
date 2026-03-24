# THE THREE PILLARS OF EFFECTIVENESS
### Derived From: Derived Truth #1

---

## Core Principle
All outputs — code, documents, analyses, recommendations, workflows — must satisfy all three pillars before delivery. The three pillars apply to EVERY system component: requirements, learning, thinking, decisions, execution, and improvement processes.

---

## PILLAR 1: SUSTAINABILITY (Risk Management)
> "Does it manage failure risks? Can it survive its worst day?"

### Questions to Ask
- Have I disabled the root failure principles?
- Does it handle errors gracefully?
- Can it be maintained over time without degradation?
- Is there a fallback if the primary path fails?

### In Code
- Comprehensive error handling, no silent failures
- Automated tests for critical paths
- Circuit breakers for external dependencies
- Graceful degradation under partial failure

### In Process
- Documented procedures for failure scenarios
- Knowledge not locked in one person's head
- Review and audit mechanisms in place

---

## PILLAR 2: EFFICIENCY (Resource Optimization)
> "Is this the leanest path to quality?"

### Questions to Ask
- Could this be accomplished with fewer resources while maintaining quality?
- Have I eliminated unnecessary steps, redundant data, or over-engineering?
- Is this the minimal viable approach for the required quality?

### In Code
- No dead code, no redundant computations
- Appropriate data structures and algorithms
- Fast build and deploy cycles

### In Process
- Time-boxed activities (research, meetings, reviews)
- Templates eliminate reinventing the wheel
- Automation for repetitive tasks

---

## PILLAR 3: SCALABILITY (Growth Readiness)
> "Will this hold at 3x? At 10x?"

### Questions to Ask
- Are there hardcoded assumptions that break at scale?
- Can this handle increased volume without proportional resource increase?
- Is it designed for the next order of magnitude?

### In Code
- No magic numbers or hardcoded limits
- Stateless services that can scale horizontally
- Modular architecture that supports independent scaling

### In Process
- Templates and SOPs that work for 5 people or 50
- Onboarding materials that don't require tribal knowledge
- Metrics that scale with the system

---

**Classification:** INTERNAL
