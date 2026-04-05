---
status: in-progress
priority: high
tags: [infra, staging, blocker]
owner: "Long Nguyen"
due_date: 2026-04-07
---
# Task: Setup Staging Environment

## Description

Provision and configure the staging server for the LTC Portfolio Dashboard. Required before Sprint 3 front-end testing can begin.

## Steps

- [x] Open IT Ops ticket for disk expansion (done 2026-04-01)
- [x] Disk expanded to 200GB (done 2026-04-02)
- [ ] Resolve Docker daemon version mismatch (staging 20.10 vs dev 24.0)
- [ ] Deploy Node.js middleware container
- [ ] Deploy React front-end build
- [ ] Smoke test: confirm Bloomberg B-PIPE WebSocket connects in staging
- [ ] Notify Frontend Dev that staging is ready

## Blocker

Docker version mismatch — IT Ops working on update. ETA: 2026-04-05 (pending IT Ops confirmation).

## Notes

If IT Ops cannot resolve by 2026-04-05, fallback: run local Docker Compose mock for UAT prep. Raises risk for UAT realism — PMs would test against mock data, not live Bloomberg.
