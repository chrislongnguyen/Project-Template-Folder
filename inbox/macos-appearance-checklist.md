---
title: macOS Appearance Settings Checklist
last_updated: 2026-04-10
---

# macOS System Appearance Checklist

Apply these 8 settings in ORDER. True Tone must come FIRST.

---

## Step 1 — True Tone: OFF ⚠️ DO FIRST

**Path:** System Settings → Displays → True Tone → toggle OFF
**Why first:** True Tone + Night Shift running simultaneously causes visible shimmer. Disable True Tone before enabling Night Shift.
**Verify:** True Tone toggle is grey/off. No color shift occurs when you open a white document.

---

## Step 2 — Night Shift: Sunset to Sunrise, Maximum Warmth

**Path:** System Settings → Displays → Night Shift
- Schedule: Sunset to Sunrise
- Color Temperature: drag slider to far right (Maximum Warmth, ~2500K)
**Why:** Reduces blue-channel light (450–480nm) that disrupts melatonin and strains astigmatic eyes at night.
**Verify:** Night Shift icon appears in menu bar after sunset. Screen has warm amber tint.

---

## Step 3 — Refresh Rate: 60 Hz (external displays)

**Path:** System Settings → Displays → [select external display] → Refresh Rate → 60 Hertz
**Apply to:** Samsung M7 43" TV, Samsung ViewFinity S8, Dell FHD — all external displays.
**Why:** Consistent 60Hz prevents frame-rate mismatch flicker between displays.
**Verify:** Each external display shows "60 Hz" in Refresh Rate dropdown.

---

## Step 4 — Increase Contrast: ON

**Path:** System Settings → Accessibility → Display → Increase Contrast → toggle ON
**Why:** Sharpens UI borders and text by ~10%, improving edge definition for astigmatic vision.
**Verify:** UI borders (windows, buttons, menus) appear more defined/crisp.

---

## Step 5 — Reduce Transparency: ON

**Path:** System Settings → Accessibility → Display → Reduce Transparency → toggle ON
**Why:** Removes semi-transparent UI elements (menu bar, sidebar blur) that create visual noise for astigmatic users.
**Verify:** Menu bar and sidebar appear solid, not translucent.

---

## Step 6 — Reduce Motion: ON

**Path:** System Settings → Accessibility → Display → Reduce Motion → toggle ON
**Why:** Eliminates parallax and animation effects that can trigger flicker perception.
**Verify:** Window open/close animations are simpler (fade vs. zoom).

---

## Step 7 — Cursor Size: +2 Notches

**Path:** System Settings → Accessibility → Display → Cursor Size → drag 2 notches right of default
**Why:** Larger cursor is easier to track on high-DPI displays and large 43" TV at distance.
**Verify:** Cursor is visibly larger but not comically so.

---

## Step 8 — Stillcolor: Install and Enable

**Download:** https://stillcolor.app
**Steps:**
1. Download and install Stillcolor
2. Open Stillcolor from Applications
3. Allow accessibility permissions when prompted
4. In the menu bar icon → click each display → select "No Dithering"
**Why:** macOS applies temporal dithering (rapid color cycling) that astigmatic users with dilated pupils perceive as flicker. Stillcolor suppresses this at the display driver level.
**Verify:** Stillcolor menu bar icon shows green status. Any previously-perceived dithering/shimmer is gone.

---

## Monitor-Specific OSD Settings (apply via each monitor's physical buttons)

| Monitor | Setting | Value |
|---------|---------|-------|
| Samsung M7 43" TV | OSD → Picture → Color Space | sRGB |
| Samsung M7 43" TV | OSD → Picture → Sharpness | 40 |
| Samsung ViewFinity S8 | OSD → Picture → Color Temp | Warm2 |
| Dell FHD | OSD → Color → Color Space | sRGB |

---

## Night-Work Brightness Targets

| Monitor | Brightness |
|---------|-----------|
| MacBook Air (office) | 35–45% |
| Samsung M7 TV (office) | 40% |
| Samsung ViewFinity S8 (home primary) | 40% |
| Dell FHD (home secondary) | 35% |

Keep all displays above 30% — below 30% triggers PWM backlight flicker zone.
