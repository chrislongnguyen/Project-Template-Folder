---
version: "1.0"
last_updated: 2026-03-29
owner: ""
---
# LTC Data Classification
> LTC Global Rule — applies to ALL projects using this template.
> Source: Derived from LTC security policies and SOP.

---

## 5-Level Classification Scheme

Every file, document, dataset, and artifact within LTC must be classified into one of these five levels. When classification is unspecified, default to **INTERNAL**.

| Level | Label | Description | Handling Rules |
|---|---|---|---|
| **1** | **RESTRICTED** | Highest sensitivity. Credentials, API keys, private keys, financial data, legal-privileged documents. | Must live in `.env`, `secrets/`, or encrypted storage. Never committed to git. Access: named individuals only. Backup: encrypted (Cryptomator, IronKey, Proton Drive). |
| **2** | **CONFIDENTIAL** | Internal sensitive. Strategy documents, personnel data, investment theses, client-specific data. | Store in access-controlled locations (private repos, restricted Drive folders). Share only with authorized team members. Never include in agent prompts without explicit authorization. |
| **3** | **INTERNAL** | Standard business documents. Meeting notes, project artifacts, SOPs, internal communications. **This is the default classification.** | Normal internal access. May be stored in standard git repos and internal Drive folders. No special encryption required beyond standard practices. |
| **4** | **EXTERNAL** | Approved for external sharing. Published reports, marketing materials, public documentation, open-source code. | May be shared outside LTC. Must be reviewed and approved before external distribution. No confidential or restricted data embedded. |
| **5** | **PERSONAL** | Individual-owned data. Personal notes, learning journals, individual development plans. | Owned by the individual. Not subject to organizational retention policies. Should not contain RESTRICTED or CONFIDENTIAL data. |

---

## Classification Rules

1. **Default is INTERNAL.** If you do not know the classification, treat it as INTERNAL until confirmed.
2. **Classify at creation time.** Every new document or dataset should be classified when created.
3. **Highest component wins.** A document containing both INTERNAL and CONFIDENTIAL data is classified CONFIDENTIAL.
4. **Downgrade requires approval.** Moving data from a higher to lower classification requires Human Director approval.
5. **Agent behavior by level:**

| Level | Agent May |
|---|---|
| RESTRICTED | Never read, write, or reference without explicit Human Director instruction per-instance. |
| CONFIDENTIAL | Read if loaded into context. Never output to external systems. Flag if found in unexpected locations. |
| INTERNAL | Read, process, and output within project boundary. Default operating level. |
| EXTERNAL | Read, process, and output freely. May include in external-facing artifacts. |
| PERSONAL | Read only if explicitly loaded by the owner. Never share with other users. |

---

## Google Drive Naming Convention

When classification applies to Drive files, use the bracket prefix per UNG:

```
[RESTRICTED]_filename.ext
[CONFIDENTIAL]_filename.ext
[EXT]_filename.ext
```

INTERNAL and PERSONAL files do not require a classification prefix (INTERNAL is the default; PERSONAL is individually managed).

---

## Data Transfer Rules

- CONFIDENTIAL and RESTRICTED data transfers must be encrypted.
- Password sent via separate channel from encrypted file.
- RESTRICTED data storage: Synology NAS or Proton Drive only.

---

**Classification:** INTERNAL

## Links

- [[documentation]]
- [[project]]
- [[security]]
- [[standard]]
