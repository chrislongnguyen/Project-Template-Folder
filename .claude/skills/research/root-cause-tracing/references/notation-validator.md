# Notation Validator — Quick Reference

## Valid Patterns

```
UBS                     Ultimate Blocking System (root)
UBS.UB                  What disables the UBS (works FOR Learner)
UBS.UD                  What drives the UBS harder (works AGAINST Learner)
UBS.UB.UB               What disables the UBS disabler (works AGAINST Learner)
UBS.UB.UD               What drives the UBS disabler (works FOR Learner)
UBS.UD.UB               What disables the UBS driver (works FOR Learner)
UBS.UD.UD               What drives the UBS driver harder (works AGAINST Learner)
... (continue recursively to any depth)

UDS                     Ultimate Driving System (root)
UDS.UD                  What drives the UDS further (works FOR Learner)
UDS.UB                  What blocks the UDS (works AGAINST Learner)
UDS.UD.UD               What drives the UDS driver further (works FOR Learner)
UDS.UD.UB               What blocks the UDS driver (works AGAINST Learner)
UDS.UB.UD               What drives the UDS blocker (works AGAINST Learner)
UDS.UB.UB               What disables the UDS blocker (works FOR Learner)
... (continue recursively to any depth)
```

## Invalid Patterns (NEVER use)

```
UBS1, UBS2, UBS3        Numbered suffixes — FORBIDDEN
UDS1, UDS2              Numbered suffixes — FORBIDDEN
UB (without parent)     Must always have a parent: UBS.UB, UDS.UB, UBS.UB.UB
UD (without parent)     Must always have a parent: UBS.UD, UDS.UD, UDS.UD.UD
UBS-1, UDS_2            Hyphens or underscores as indices — FORBIDDEN
```

## Direction Truth Table

| Row Subject Type | Col 4 (UDS) | Works... | Col 10 (UBS) | Works... |
|-----------------|-------------|----------|--------------|----------|
| **Effective System** | Root UDS | FOR Learner | Root UBS | AGAINST Learner |
| **UBS (blocker)** | UBS.UD — drives blocker | AGAINST Learner | UBS.UB — disables blocker | FOR Learner |
| **UDS (driver)** | UDS.UD — drives driver | FOR Learner | UDS.UB — blocks driver | AGAINST Learner |

**Mnemonic:** UBS rows have INVERTED direction — col 4 is the bad news (drives blocker), col 10 is the good news (disables blocker). UDS rows have NORMAL direction — col 4 is good (drives driver), col 10 is bad (blocks driver).

## Shared Force Detection

When tracing to level 2+ (e.g., UBS.UD.UD), check if the cause also appears in the UDS tree (or vice versa). Known shared forces:

| Force | UBS Notation | UDS Notation | Net Effect |
|-------|-------------|-------------|------------|
| Bio-Efficient Forces | UBS.UD.UD | UDS.UD.UB | Strengthens blockers; weakens drivers |
| Support System Belief | UBS.UD.UB | UDS.UB.UB | Weakens blockers; strengthens drivers |

If you identify a new shared force not in this table, flag it to the Learner and record it via `/remember`.
