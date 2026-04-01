# Scope Matrix — ltc-rules-compliance

Use this table to decide which rule families are in scope.

| Artifact / Task | Rule family | Canonical source | Specialist skill |
|---|---|---|---|
| HTML/CSS/SVG/charts/slides/PDF/email | Brand identity | `rules/brand-identity.md` | `ltc-brand-identity` |
| Repo/folder/Drive/PJ Project/PJ Deliverable naming | Naming (UNG) | `rules/naming-rules.md` | `ltc-naming-rules` |
| Commits, secrets, high-risk actions, blast radius | Security | `rules/security-rules.md` | (direct rule check) |
| Skill creation / review | EOP governance | `_genesis/reference/ltc-eop-gov.md` | `skill-validator.sh` |
| DSBV phase correctness | Process gates | `_genesis/templates/DSBV_PROCESS.md` | `dsbv` |
| Session closing behavior | Process gates | `session/session-end/SKILL.md` | `session-end` |

## Rule-family decision tips

1. If no table row matches, mark as `NOT APPLICABLE` and explain.
2. If more than one row matches, check all applicable families.
3. If uncertain whether visual output is in scope, default to including brand checks.

## Links

- [[DSBV_PROCESS]]
- [[SKILL]]
- [[brand-identity]]
- [[deliverable]]
- [[dsbv]]
- [[ltc-eop-gov]]
- [[naming-rules]]
- [[project]]
- [[security]]
- [[security-rules]]
- [[task]]
