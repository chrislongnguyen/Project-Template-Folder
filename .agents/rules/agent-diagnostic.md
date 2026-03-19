# LTC Agent Diagnostic

> For AntiGravity and other AAIF-compatible agents. Full spec: `rules/agent-diagnostic.md`

## Blame Diagnostic — Trace in This Order (sequentially)
1. **EPS** — Rules cover this case? Too verbose (consuming context)?
2. **Input** — Context complete and unambiguous? Scope explicit?
3. **EOP** — Right procedure? Steps well-scoped? Right skill triggered?
4. **Environment** — Context window sufficient? Permissions correct?
5. **Tools** — Right tools available? Returning good data? Too many loaded?
6. **Agent** — Only after 1-5: is the model genuinely underpowered?

## Derisk Checklist (before ANY delegation)
1. List what can go wrong with this task
2. Map each: `Risk → LT → Component → Configured?`
3. Unconfigured? Fix first. All covered? Delegate.

## Symptom Lookup
| Symptom | Likely Root |
|---------|-------------|
| Incorrect facts stated confidently | EPS / Tools / Input |
| Loses track mid-task | EPS (too verbose) / Environment |
| Completes wrong task | Input / EOP |
| Shallow or circular reasoning | EOP / Agent / Environment |
| Wrong tool or misinterpreted output | Tools / EOP |
| Correct output but Director rejects | Human UBS (System 1 bias) |
| Inconsistent across sessions | EPS / LT-6 |

## Force Map
- Human under pressure/fatigue → delegate to Agent
- Needs values/judgment/expertise → Human decides, Agent gathers
- Both → Agent structures data, Human makes judgment call
