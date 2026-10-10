# hyprland-gaming

A few Hyprland rules that stop the desktop from interrupting games. Append [hyprland-gaming.lua](hyprland-gaming.lua) to the bottom of `~/.config/hypr/hyprland.lua` (Omarchy's Lua-based config). Each rule is independent, so keep only the ones you want.

Full write-up of how these problems were tracked down: [omacom/omarchy discussion #14902](https://github.com/omacom/omarchy/discussions/14902)

## The rules

### Steam tiles instead of floating

```lua
o.window("steam", { float = false, tile = true })
```

Overrides Omarchy's default rule that floats Steam windows.

### No focus stealing from games

```lua
o.window("steam", { focus_on_activate = false })
```

Steam (Big Picture, the overlay, Friends list) can no longer pull focus away from a running game when it activates a window.

### Steam Controller Puck keyboard devices ignored

The wireless Puck dongle for the Steam Controller exposes four "keyboard" input devices. Their raw keypresses (for example Super+Return) reached Hyprland and opened a terminal on top of a game. The `hl.device` loop disables them.

Steam Input keeps working, because Steam sends controller input through its own virtual devices. Side effect: with Steam closed, the controller can no longer act as a desktop keyboard/mouse ("lizard mode"). Check your device names with `hyprctl devices`.

### Idle inhibit while a game is open

```lua
o.window("^(steam_app_.*|gamescope)$", { idle_inhibit = "always" })
```

Controller input does not reset Hyprland's idle timer, so after a few minutes Omarchy's screensaver launched and its terminal windows tiled next to the game. This blocks idle while any Proton game window (`steam_app_*`) or gamescope is open. For a native Linux game, find its window class with `hyprctl clients` and add it to the pattern.

### New windows open behind fullscreen games

```lua
hl.config({ misc = { on_focus_under_fullscreen = 0 } })
```

Anything that opens while a game is fullscreen (Steam popups, dialogs) goes behind the game instead of knocking it out of fullscreen. Games in borderless-window mode (not true fullscreen) can still get windows tiled next to them.
