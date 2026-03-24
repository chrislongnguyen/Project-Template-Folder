# DATA CLASSIFICATION SYSTEM
### Derived From: Wiki — Naming System, Data Classification

---

| Level | Label | Example | Access | Storage |
|-------|-------|---------|--------|---------|
| 0 | PERSONAL | Personal documents | Owner only | Owner's discretion |
| 1 | PUBLIC | Website content | No restriction | Any |
| 2 | INTERNAL | Team OKRs, non-sensitive memos | LTC staff only | Approved tools |
| 3 | CONFIDENTIAL | Client reports, investment memos | Need-to-know + encrypted | Encrypted storage |
| 4 | RESTRICTED | Deal documents under NDA, legal cases | Management approval + encrypted | Synology NAS or Proton Drive |

## Rules
- Apply classification to EVERY output
- Only prefix RESTRICTED, CONFIDENTIAL, or EXTERNAL in file names
- Omit prefix for INTERNAL and PERSONAL
- CONFIDENTIAL and RESTRICTED data transfers must be encrypted
- Password sent via separate channel from encrypted file

---

**Classification:** INTERNAL
