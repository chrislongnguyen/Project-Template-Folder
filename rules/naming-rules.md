<!-- Zone 0 agent-facing copy. Human-readable version: _shared/security/NAMING_CONVENTION.md -->
# LTC Naming Rules (Universal Naming Grammar)

> Source of truth: OPS_OE.6.0 docs/governance/LTC-UNIVERSAL-NAMING-GRAMMAR-v1.md
> Distilled for agent use. Load when creating named items on any platform.
> Last synced: 2026-03-22

---

## 1. Canonical Key Pattern

Every LTC digital asset has a Canonical Key. The key has **two forms** depending on whether the item has a parent.

### 1a. Standard Form — 3-Part (item with parent)

This is the **default**. Most items exist within a parent context.

```
{SCOPE}_{PARENT_ID}.{PARENT_NAME}_{ITEM_ID}.{ITEM_NAME}
```

The 3 parts:
1. **SCOPE** — organizational scope (from Table 3a)
2. **PARENT** — parent's ID + name (establishes context)
3. **ITEM** — this item's ID + name (the leaf)

Example: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE_D1.FOUNDATION`
- SCOPE: `OPS`
- PARENT: `OE.6.4.LTC-PROJECT-TEMPLATE` (the project)
- ITEM: `D1.FOUNDATION` (deliverable 1)

### 1b. Short Form — 2-Part (top-level item, no parent)

Only for items that have **no parent** within the naming scope (e.g., Git repos, top-level ClickUp projects, root Drive folders).

```
{SCOPE}_{FA}.{ID}.{NAME}
```

Example: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE`
- SCOPE: `OPS`
- ITEM: `OE.6.4.LTC-PROJECT-TEMPLATE`

### Separator Grammar

- `_` = boundary separator (between SCOPE and PARENT; between PARENT and ITEM)
- `.` = numeric hierarchy (between numbers; between last number and NAME)
- `-` = word join within NAME

### Parsing Rules

**2-Part (no `_` after SCOPE+FA segment):**
1. Split on first `_` after SCOPE (try longest matching SCOPE from Table 3a first)
2. Next segment before `.` = FA
3. Consecutive numeric `.`-separated segments = ID
4. Everything after last number `.` = NAME

**3-Part (second `_` present after PARENT_NAME):**
1. First `_` after SCOPE → start of PARENT segment
2. Second `_` after PARENT_NAME → start of ITEM segment
3. Each segment follows the `{ID}.{NAME}` pattern

**Agent rule:** Always try the longest matching SCOPE from Table 3a first. `COE_EFF` matches before `COE`. No algorithmic derivation — use the lookup table.

**Agent rule:** Default to 3-part naming. Only use 2-part when the item genuinely has no parent in the naming context.

---

## 2. Where UNG Applies

| Platform | Named Items | Form | UNG Applies? |
|---|---|---|---|
| Git / GitHub | Repos | 2-part | Full UNG. Canonical Key as-is. Max 50 chars. |
| Local filesystem | Folders | 2-part | Full UNG. Canonical Key + trailing slash. |
| ClickUp — PJ Project | Top-level project | 2-part | `[GROUP]_FA.ID. NAME` |
| ClickUp — PJ Deliverable | Deliverable under project | 3-part | `[GROUP]_FA.ID. PROJECT NAME_D{n}. DELIVERABLE NAME` |
| ClickUp — Task and below | Task, Increment, Blocker, Documentation, etc. | Free text | No UNG prefix. Free text. |
| Google Drive | Folders, files | 2-part or 3-part | Full UNG with optional decorators (classification, member, version). |

**Not governed by UNG:** Learning Book page filenames inside repos (those use `BOOK-NN --` prefix convention).

---

## 3. Platform Rendering Rules

### Git / GitHub
- Format: Canonical Key as-is. ALL CAPS. No spaces, no brackets.
- Max length: **50 characters**.
- Abbreviation (if over 50 chars): shorten NAME words first (e.g. `OPERATING-SYSTEM-DESIGN` -> `OSD`), then abbreviate ORG segment. NEVER abbreviate SCOPE, FA, or ID.

### Local Filesystem
- Format: Canonical Key + trailing `/`.
- Max length: 255 (OS limit). ALL CAPS. No spaces, no brackets.

### ClickUp

**PJ Project (2-part, top-level):**
```
[GROUP DISPLAY]_FA.ID. PROJECT NAME
```

**PJ Deliverable (3-part, child of project):**
```
[GROUP DISPLAY]_FA.ID. PROJECT NAME_D{n}. DELIVERABLE NAME
```

**Task and below:** Free text. No UNG prefix.

**Examples:**
```
PJ Project:     [OPS]_OE.6.4. LTC Project Template
PJ Deliverable: [OPS]_OE.6.4. LTC Project Template_D1. Foundation
PJ Deliverable: [OPS]_OE.6.4. LTC Project Template_D5. CLI
Task:           Core Commands
PJ Increment:   Embedder Interface + Local Backend
PJ Documentation: Storage Layer Reference
```

**Canonical -> ClickUp:**
1. Look up SCOPE in Table 3a -> get ClickUp Display name (e.g. `INVTECH` -> `INV TECH`)
2. Wrap in brackets: `[INV TECH]`
3. For 2-part (PJ Project): Append `_FA.ID. ` (dot-space before NAME). NAME: replace hyphens with spaces.
4. For 3-part (PJ Deliverable): Append `_FA.ID. PARENT NAME_ITEM_ID. ITEM NAME`. Both NAMEs: replace hyphens with spaces.

**ClickUp -> Canonical:**
1. Strip brackets from group -> look up in Table 3a -> get SCOPE code
2. FA code stays as-is
3. ID numbers stay as-is
4. All NAMEs: spaces -> hyphens
5. If `_` separates parent and item segments, preserve as 3-part canonical key

### Google Drive
- Same bracket format as ClickUp, plus optional decorators:
  - Classification prefix: `[RESTRICTED]_`, `[CONFIDENTIAL]_`, `[EXT]_`
  - Member owner: `[LONG N.]_`, `[TINA N.]_`
  - Version/status/date suffixes: `vFINAL`, `REVIEWED`, `20260303`
- `AND` in names may render as `&` on Drive (cosmetic).
- Item names may use Title Case instead of ALL CAPS.

---

## 4. Table 3a: SCOPE Codes

### Governance

| ClickUp Display | Git SCOPE | Full Name |
|---|---|---|
| `[GOV BOD]` | `GOV_BOD` | LTC Board of Directors |
| `[GOV IC]` | `GOV_IC` | LTC Investment Committee |
| `[GOV COMPLIANCE]` | `GOV_COMPLIANCE` | LTC Compliance Committee |
| `[GOV CULTURE]` | `GOV_CULTURE` | LTC Culture & People Council |

### Center of Excellence (COE)

| ClickUp Display | Git SCOPE | Full Name |
|---|---|---|
| `[COE]` | `COE` | Universal Capability Center |
| `[COE EFF]` | `COE_EFF` | Effective Excellence Area |
| `[COE DS]` | `COE_DS` | Data Science Excellence Area |
| `[COE TECH]` | `COE_TECH` | Technology Excellence Area |
| `[COE BIZ]` | `COE_BIZ` | Business Excellence Area |
| `[COE INV]` | `COE_INV` | Investment Excellence Area |
| `[COE WELLBEING]` | `COE_WELLBEING` | Wellbeing Excellence Area |
| `[COE FUN]` | `COE_FUN` | Fun & Culture Excellence Area |
| `[COE LEADERSHIP]` | `COE_LEADERSHIP` | Leadership Excellence Area |
| `[COE ALL]` | `COE_ALL` | All COE Members |
| `[COE SHARED]` | `COE_SHARED` | Shared COE Accounts |
| `[MGT COE]` | `MGT_COE` | Head of Center of Excellence |

### Management

| ClickUp Display | Git SCOPE | Full Name |
|---|---|---|
| `[MGT]` | `MGT` | Management Function |
| `[MGT FOUNDERS]` | `MGT_FOUNDERS` | Founders |
| `[MGT LEADERS]` | `MGT_LEADERS` | Leadership Team |
| `[MGT STRATEGY]` | `MGT_STRATEGY` | Strategy |
| `[MGT FIN]` | `MGT_FIN` | Finance Management |
| `[MGT HR]` | `MGT_HR` | HR Management |
| `[MGT IT]` | `MGT_IT` | IT Management |
| `[MGT IT SUPER]` | `MGT_ITSUPER` | IT Supervisory |
| `[MGT LEGAL]` | `MGT_LEGAL` | Legal Management |
| `[MGT PR]` | `MGT_PR` | PR Management |
| `[MGT IR]` | `MGT_IR` | IR Management |
| `[MGT IMPACT]` | `MGT_IMPACT` | Impact Management |
| `[MGT INFRA]` | `MGT_INFRA` | Infrastructure Management |
| `[MGT PROCESS]` | `MGT_PROCESS` | Process Management |

### Operations

| ClickUp Display | Git SCOPE | Full Name |
|---|---|---|
| `[OPS]` | `OPS` | Internal Operations |
| `[OPS FIN]` | `OPS_FIN` | Finance Operations |
| `[OPS HR]` | `OPS_HR` | HR Operations |
| `[OPS IT]` | `OPS_IT` | IT Operations |
| `[OPS INFRA]` | `OPS_INFRA` | Infrastructure Operations |
| `[OPS PROCESS]` | `OPS_PROCESS` | Process Operations |
| `[OPERATIONS]` | `OPERATIONS` | Operations Function Group |

### Business / Investment

| ClickUp Display | Git SCOPE | Full Name |
|---|---|---|
| `[INV]` | `INV` | Public Investment Function |
| `[INV TECH]` | `INVTECH` | Investment Technology |
| `[BIZ VEN]` | `BIZVEN` | Business Ventures |
| `[BIZ DEV]` | `BIZ_DEV` | Business Development |
| `[BIZ TECH]` | `BIZ_TECH` | Business Technology |

### Growth / Fulfillment / Innovation

| ClickUp Display | Git SCOPE | Full Name |
|---|---|---|
| `[GROW]` | `GROW` | Growth Function Group |
| `[FULFILL]` | `FULFILL` | Fulfillment Function Group |
| `[INNO]` | `INNO` | Innovation Function Group |
| `[CI]` | `CI` | Customer Intimacy |
| `[CLIENT SERV]` | `CLIENT_SERV` | Client Services |

### Corporate

| ClickUp Display | Git SCOPE | Full Name |
|---|---|---|
| `[CORP DEV]` | `CORP_DEV` | Corporate Development |
| `[CORP DEV IB]` | `CORP_DEVIB` | Corporate Dev - IB |
| `[CORP DEV IR]` | `CORP_DEVIR` | Corporate Dev - IR |
| `[CORP DEV MGT]` | `CORP_DEVMGT` | Corporate Dev - Management |
| `[CORP AFFAIRS]` | `CORP_AFFAIRS` | Corporate Affairs |
| `[CORP IMPACT]` | `CORP_IMPACT` | Corporate Impact |
| `[CORP LEGAL]` | `CORP_LEGAL` | Corporate Legal |
| `[CORP PR]` | `CORP_PR` | Corporate PR |
| `[CORP IR]` | `CORP_IR` | Corporate IR |

### Company-Wide / Shared

| ClickUp Display | Git SCOPE | Full Name |
|---|---|---|
| `[LTC ALL]` | `LTC` | All LTC Members |
| `[LTC SHARED]` | `LTC_SHARED` | Shared Non-Workspace Accounts |
| `[LTC PROD]` | `LTC_PROD` | Shared Product Accounts |
| `[LTC COE]` | `LTC_COE` | LTC Center of Excellence (parent) |
| `[LTC GOV]` | `LTC_GOV` | LTC Governance (parent) |
| `[LTC LEADERS]` | `LTC_LEADERS` | LTC Leadership Group |
| `[LTC ALIGN]` | `LTC_ALIGN` | LTC Alignment (Shared Guides) |

### Stakeholders / External

| ClickUp Display | Git SCOPE | Full Name |
|---|---|---|
| `[STK CLIENT]` | `STK_CLIENT` | Client Stakeholders |
| `[STK INV CLIENTS]` | `STK_INVCLIENTS` | Investment Clients |
| `[STK CORP DEV CLIENTS]` | `STK_CORPDEVCLIENTS` | Corp Dev Clients |
| `[STK MEDIA]` | `STK_MEDIA` | Media Stakeholders |
| `[STK PARTNERS]` | `STK_PARTNERS` | Partner Stakeholders |
| `[STK SHARE]` | `STK_SHARE` | Shareholders |
| `[STK ESG]` | `STK_ESG` | ESG Stakeholders |
| `[STK GOVT]` | `STK_GOVT` | Government Stakeholders |
| `[EXT ADVISORS]` | `EXT_ADVISORS` | External Advisors |
| `[EXT BD]` | `EXT_BD` | External Board Directors |
| `[EXT OTHERS]` | `EXT_OTHERS` | External Others |
| `[EXT RECRUIT]` | `EXT_RECRUIT` | External Recruitment |

### Collapse Rules (Irregular Mappings)

```
[INV TECH]             -> INVTECH           (concatenated, no separator)
[BIZ VEN]              -> BIZVEN            (concatenated, no separator)
[COE EFF]              -> COE_EFF           (underscore -- COE is parent scope)
[COE TECH]             -> COE_TECH          (underscore -- COE is parent scope)
[MGT IT SUPER]         -> MGT_ITSUPER       (partial concatenation)
[LTC ALL]              -> LTC               (shortened -- drops qualifier)
```

No single algorithm produces all of these. ALWAYS use the lookup table.

---

## 5. Table 3b: Focus Areas (FA)

| Code | Full Name |
|---|---|
| `SA` | Strategic Alignment |
| `PD` | People Development |
| `OE` | Operational Excellence |
| `UE` | User Enablement |
| `CI` | Customer Intimacy |
| `FP` | Financial Performance |
| `CR` | Corporate Responsibility |
| `OTH` | Others |

---

## 6. Validation & Pre-Creation Checklist

### Canonical Key Regex

**2-part (top-level, no parent):**
```
^[A-Z][A-Z0-9_]*_[A-Z]{2,3}\.[0-9]+(\.[0-9]+)*\.[A-Z][A-Z0-9-]*$
```

**3-part (child item with parent):**
```
^[A-Z][A-Z0-9_]*_[A-Z]{2,3}\.[0-9]+(\.[0-9]+)*\.[A-Z][A-Z0-9-]*_[A-Z0-9]+\.[A-Z][A-Z0-9-]*$
```

### 8-Step Pre-Creation Checklist

Before creating ANY named item on ANY platform, the agent MUST:

1. **Determine form** — Does this item have a parent? 3-part (default) or 2-part (top-level only)?
2. **Compose** the Canonical Key from SCOPE + (PARENT +) ITEM
3. **Validate** against the appropriate regex above
4. **Verify** SCOPE exists in Table 3a (Section 4)
5. **Verify** FA exists in Table 3b (Section 5)
6. **Check** character count for Git (must be 50 chars or fewer — Git repos only, always 2-part)
7. **Render** to target platform using Section 3 rules
8. **Check** for name collisions on the target platform

If a collision is detected, disambiguate by adjusting NAME. As a last resort, append `-NN` suffix. Never create duplicates — halt and ask the user.
