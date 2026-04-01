---
version: "1.2"
status: Draft
last_updated: 2026-03-31
owner: "{Human Director}"
---

# EFFECTIVENESS METRICS DASHBOARD
## KPIs Organized by the 3 Pillars
### Derived From: Wiki KPI Design Standards

---

## Key Principle
> KPIs without formulas are aspirations, not metrics.
> Each KPI must specify: Pillar, Objective, Impact, Description, Formula.

---

## SUSTAINABILITY METRICS — Does the system manage failure risks?

| KPI | Description | Formula | Target | Current | Trend |
|-----|-------------|---------|--------|---------|-------|
| Error Rate | Critical errors per deployment | `Critical Errors / Total Deployments` | <1% | — | — |
| Recovery Time | Mean time to recover from failure | `Sum(Recovery Times) / Count(Incidents)` | <30min | — | — |
| Test Coverage | % of risk areas covered by tests | `Tested Risk Areas / Total UBS Entries` | >80% | — | — |
| Documented Processes | % of procedures with SOPs | `SOPs Written / Total Procedures` | 100% | — | — |

## EFFICIENCY METRICS — Does the system minimize waste?

| KPI | Description | Formula | Target | Current | Trend |
|-----|-------------|---------|--------|---------|-------|
| Cycle Time | Average time from task start to done | `Sum(Completion Times) / Count(Tasks)` | [Target] | — | — |
| Resource Utilization | % of sprint capacity used productively | `Completed Story Points / Planned Story Points` | >85% | — | — |
| Automation Coverage | % of repetitive tasks automated | `Automated Tasks / Total Repetitive Tasks` | >70% | — | — |
| Build Time | Time from commit to deployable artifact | `Average CI/CD Pipeline Duration` | <10min | — | — |

## SCALABILITY METRICS — Does the system handle growth?

| KPI | Description | Formula | Target | Current | Trend |
|-----|-------------|---------|--------|---------|-------|
| Load Capacity | Max concurrent users at acceptable latency | `Max Users at P95 < Target Latency` | [Target] | — | — |
| Template Adoption | % of new artifacts using standard templates | `Templated Artifacts / Total New Artifacts` | >90% | — | — |
| Onboarding Time | Average time for new contributor to first commit | `Sum(Onboarding Days) / Count(New Contributors)` | <3 days | — | — |
| Modularity Score | % of code in reusable modules | `Shared Module LOC / Total LOC` | >40% | — | — |

---

**Review Cadence:** [Weekly / Bi-weekly / Monthly]
**Last Updated:** [Date]

**Classification:** INTERNAL
