---
title: cmux UI Settings Template
applies_to: ~/.config/cmux/settings.json
last_updated: 2026-04-10
---

# cmux UI Settings

**Apply:** Copy the JSON block below to `~/.config/cmux/settings.json`
**Reload:** Restart cmux or use Settings panel (Cmd+,)

## Steps
1. `mkdir -p ~/.config/cmux`
2. Copy JSON below to `~/.config/cmux/settings.json`
3. Restart cmux to apply

## Config

```json
{
  "sidebarTint": "dark",
  "workspaceColors": true,
  "splitDividerColor": "#24283b"
}
```

## Notes
- `sidebarTint: "dark"` — sidebar uses dark chrome (#24283b, Night Surface)
- `splitDividerColor: "#24283b"` — pane dividers match sidebar, not full-contrast borders
- `workspaceColors: true` — enables workspace tab color coding (set colors per workspace in cmux Settings panel → Cmd+,)

## Optional: Workspace Color Coding
In cmux Settings → Workspaces, assign LTC workstream colors:
- ALIGN workspace → `#F2C75C` (Gold)
- LEARN workspace → `#B05CE8` (Purple)
- PLAN workspace → `#5ED4DB` (Teal)
- EXECUTE workspace → `#7ACC5C` (Green)
- IMPROVE workspace → `#E85D75` (Rose)
