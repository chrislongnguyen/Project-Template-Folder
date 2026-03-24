# Causal Chain Procedure — Step-by-Step

## Step 1: Identify the Phenomenon

What is being traced? Classify it:

| Type | Example | Trace Direction |
|------|---------|-----------------|
| **(a) Effective System** | "Effective AI Orchestration Engine" | Trace both UBS (col 10) and UDS (col 4) |
| **(b) UBS (blocker)** | "Capability Gap" | Col 4 = UBS.UD (drives blocker — AGAINST Learner); Col 10 = UBS.UB (disables blocker — FOR Learner) |
| **(c) UDS (driver)** | "Hierarchical Decomposition Thinking" | Col 4 = UDS.UD (drives driver — FOR Learner); Col 10 = UDS.UB (blocks driver — AGAINST Learner) |

This classification determines the direction of tracing.

## Step 2: Determine Current Depth

Read Phase A (Approved Pages, Current state) and the last approved page.

- What level has already been approved?
- The new trace must go exactly ONE level deeper (not zero, not two)
- Example: if UBS is approved, next level = UBS.UB and UBS.UD

**Depth progression reference:**
```
Level 0: UBS / UDS                          (Topic 0, Pages 1-2)
Level 1: UBS.UB, UBS.UD / UDS.UD, UDS.UB   (Topics 1-2, Pages 1-2)
Level 2: UBS.UB.UB, UBS.UB.UD, ...          (Topics 3-5, Pages 1-2)
Level N: Continue as deep as needed
```

## Step 3: Trace One Level

For the phenomenon at level N, ask: **"What is the single most critical cause?"**

Apply the Hierarchy of Science to ensure the cause is at the correct governing layer:
- Sociology > Psychology > Biology > Chemistry > Physics > Mathematics > Logic > Philosophy
- A psychological mechanism should not be explained by sociology if the psychological layer is sufficient
- Trace to the LOWEST governing layer that fully explains the phenomenon

Produce:
1. **The cause** — one noun phrase (e.g., "Activation Barrier")
2. **The dot-notation label** — (e.g., UBS.UD)
3. **The mechanism** — how does this cause produce the effect? (maps to col 5 or col 11)
4. **The governing science layer** — (e.g., Psychology — fear of failure)

## Step 4: Validate Direction (Perspective Rule)

**If the row subject is a UBS:**
- Col 4 (UDS) = UBS.UD = what drives the blocker harder = works AGAINST Learner
- Col 10 (UBS) = UBS.UB = what disables the blocker = works FOR Learner

**If the row subject is a UDS:**
- Col 4 (UDS) = UDS.UD = what drives the driver further = works FOR Learner
- Col 10 (UBS) = UDS.UB = what blocks the driver = works AGAINST Learner

**Check:** Does the direction of the cause you identified match the column it belongs in? If UBS.UD is supposed to work AGAINST the Learner, does your cause actually make things worse? If not, re-examine.

## Step 5: Check for Shared Forces

Does this cause appear elsewhere in the causal tree under a different notation?

**Known shared forces (from UT#2):**
- **Bio-Efficient Forces** = UBS.UD.UD = UDS.UD.UB (strengthens blockers, weakens drivers)
- **Support System Belief** = UBS.UD.UB = UDS.UB.UB (weakens blockers, strengthens drivers)

If a shared force is detected, note both notations explicitly. This prevents treating UBS and UDS as independent systems.

## Step 6: Output Format

Produce the trace in a format that maps directly to Phase C table cells:

```
Row: {dot-notation label} — {cause name}
Col 4 (UDS): {what drives this cause} [{dot-notation}]
Col 5 (Mechanism): {how col 4 produces the effect}
Col 10 (UBS): {what blocks/disables this cause} [{dot-notation}]
Col 11 (Mechanism): {how col 10 produces the failure}
Science layer: {governing layer}
Shared force: {Yes/No — if yes, state both notations}
```

Present this to the Learner before proceeding to the next level.
