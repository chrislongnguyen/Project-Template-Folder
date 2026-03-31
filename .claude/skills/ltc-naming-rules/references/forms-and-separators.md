# UNG Forms and Separators

Full detail: `rules/naming-rules.md` §1.

## 3-part (default — item with parent)

```
{SCOPE}_{PARENT_ID}.{PARENT_NAME}_{ITEM_ID}.{ITEM_NAME}
```

Example: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE_D1.FOUNDATION`

## 2-part (top-level only — no parent in naming scope)

```
{SCOPE}_{FA}.{ID}.{NAME}
```

Example: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE`

## Separators

| Char | Role |
|------|------|
| `_` | Boundary: after SCOPE; between PARENT and ITEM in 3-part |
| `.` | Numeric hierarchy; between last ID number and NAME |
| `-` | Word join **inside** NAME |

## Agent defaults

- Prefer **3-part** whenever the item has a parent in context.
- Resolve SCOPE using **longest match** from Table 3a first.
