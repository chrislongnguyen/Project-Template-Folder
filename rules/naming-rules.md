# LTC Naming Rules (Universal Naming Grammar)

> Source of truth: OPS_OE.6.0 docs/governance/LTC-UNIVERSAL-NAMING-GRAMMAR-v1.md
> Distilled for agent use. Load when creating named items on any platform.
> Last synced: 2026-03-16

---

## 1. Canonical Key Pattern

Every LTC digital asset has a Canonical Key built from 4 segments:

```
{SCOPE}_{FA}.{ID}.{NAME}
```

**Separator grammar:**
- `_` = scope boundary (between SCOPE segments and between last SCOPE segment and FA)
- `.` = numeric hierarchy (between numbers; between last number and NAME)
- `-` = word join within NAME

**Parsing rules:**
1. Split on first `_` after SCOPE (try longest matching SCOPE from Table 3a first)
2. Next segment before `.` = FA
3. Consecutive numeric `.`-separated segments = ID
4. Everything after last number `.` = NAME

**Agent rule:** Always try the longest matching SCOPE from Table 3a first. `COE_EFF` matches before `COE`. No algorithmic derivation -- use the lookup table.

---

## 2. Where UNG Applies

| Platform | Named Items | UNG Applies? |
|---|---|---|
| Git / GitHub | Repos | Full UNG. Canonical Key as-is. Max 50 chars. |
| Local filesystem | Folders | Full UNG. Canonical Key + trailing slash. |
| ClickUp -- Project | PJ Project | Full: `[GROUP]_FA.ID. NAME` |
| ClickUp -- Deliverable | PJ Deliverable | Full: `[GROUP]_FA.ID. NAME` or `[GROUP]_FA.ID. PROJECT - DELI #. Name` |
| ClickUp -- Task and below | Increment, Blocker, Documentation, Request, etc. | No prefix. Free text. |
| Google Drive | Folders, files | Full UNG with optional decorators (classification, member, version). |

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
- Format: `[GROUP DISPLAY]_FA.ID. NAME`

**Canonical -> ClickUp:**
1. Look up SCOPE in Table 3a -> get ClickUp Display name (e.g. `INVTECH` -> `INV TECH`)
2. Wrap in brackets: `[INV TECH]`
3. Append `_FA.ID. ` (trailing dot-space before NAME)
4. NAME: replace hyphens with spaces

**ClickUp -> Canonical:**
1. Strip brackets from group -> look up in Table 3a -> get SCOPE code
2. FA code stays as-is
3. ID numbers stay as-is
4. NAME: spaces -> hyphens; strip ACTION PHASE prefix if present

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

```
^[A-Z][A-Z0-9_]*_[A-Z]{2,3}\.[0-9]+(\.[0-9]+)*\.[A-Z][A-Z0-9-]*$
```

### 7-Step Pre-Creation Checklist

Before creating ANY named item on ANY platform, the agent MUST:

1. **Compose** the Canonical Key from SCOPE + FA + ID + NAME
2. **Validate** against the regex above
3. **Verify** SCOPE exists in Table 3a (Section 4)
4. **Verify** FA exists in Table 3b (Section 5)
5. **Check** character count for Git (must be 50 chars or fewer)
6. **Render** to target platform using Section 3 rules
7. **Check** for name collisions on the target platform

If a collision is detected, disambiguate by adjusting NAME. As a last resort, append `-NN` suffix. Never create duplicates -- halt and ask the user.
