# SECURITY POLICY
## Following LTC's Security Hierarchy
### Derived From: Wiki — Security Setup; Data & Cybersecurity Guide

---

## Core Principle
> **THERE IS ABSOLUTELY NO TOLERANCE FOR "GETTING THINGS DONE QUICK AT ALL COST" MINDSET.**
> Security is more important than quality of work. Clients will not give us a second chance on security.

---

## Authentication Hierarchy (Most to Least Secure)
1. YubiKey physical passkey (FIDO2) — PREFERRED
2. YubiKey Authenticator (TOTP) — ACCEPTABLE
3. Proton Pass (TOTP) — ACCEPTABLE
4. Password + 2FA — MINIMUM

**PROHIBITED:**
- Platform password managers (iCloud Keychain, Chrome Passwords, Windows Hello)
- Big-tech authenticators (Google Authenticator, Apple Passwords, Microsoft Authenticator)
- Password-only without 2FA

## Data Storage Hierarchy (Most to Least Secure)
1. LTC Synology NAS — Most secure (local)
2. Proton Drive — Most private (cloud)
3. Google Shared Drives — Most convenient (cloud)

## Secrets Management
- NEVER commit secrets to version control
- Use `.env.example` as a template — never `.env` with real values
- Secrets are stored in LTC's approved password manager (Proton Pass)
- Rotate secrets on a defined schedule

## Data Classification for This Project
| Data Type | Classification | Storage | Sharing |
|-----------|---------------|---------|---------|
| Source code | INTERNAL | GitHub (private repo) | LTC team only |
| API keys/secrets | RESTRICTED | Proton Pass | Need-to-know |
| Client data | CONFIDENTIAL | Encrypted storage | Need-to-know + encrypted |
| Documentation | INTERNAL | GitHub + Google Drive | LTC team |

---

**Classification:** INTERNAL
