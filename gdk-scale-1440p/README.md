# gdk-scale-1440p

## Symptom

GTK apps and XWayland apps (Bambu Studio was where I noticed it) look **double-size** on a 2560x1440 monitor running at scale 1.

## Cause

Omarchy sets `GDK_SCALE=2` by default, its HiDPI setting. On a 1440p monitor at scale 1 that doubles everything GTK and XWayland draw.

## Fix

In `~/.config/hypr/monitors.lua`, change the GDK scale to 1:

```lua
local omarchy_gdk_scale = 1
```

which feeds:

```lua
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
```

**Apps must be fully relaunched** (or log out and back in) to pick up the new value. Already running apps keep the old scale.

## Check

```bash
grep -i gdk ~/.config/hypr/monitors.lua
systemctl --user show-environment | grep GDK_SCALE
```

If an Omarchy update ever rewrites `monitors.lua` and the problem returns, set it again.

Note: Steam looking large is usually Big Picture mode, which is intentional, not a scaling bug.
