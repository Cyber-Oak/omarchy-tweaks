-- Append to the bottom of ~/.config/hypr/hyprland.lua

-- Tile Steam instead of floating it (overrides Omarchy's default float rule).
o.window("steam", { float = false, tile = true })
-- Stop Steam (Big Picture, overlay, Friends) from stealing focus from a running game.
o.window("steam", { focus_on_activate = false })

-- Ignore the Steam Controller Puck's built-in keyboard devices. Their raw
-- keypresses (e.g. Super+Return) were opening windows over games. Steam Input
-- still works; it sends input through its own virtual devices.
for _, name in ipairs({
  "valve-software-steam-controller-puck-keyboard",
  "valve-software-steam-controller-puck-keyboard-1",
  "valve-software-steam-controller-puck-keyboard-2",
  "valve-software-steam-controller-puck-keyboard-3",
}) do
  hl.device({ name = name, enabled = false })
end

-- Block the idle screensaver while a game is open. Controller input doesn't
-- reset Hyprland's idle timer, so after 5 min the screensaver terminal opened
-- and tiled next to the game (Proton games: steam_app_*, plus gamescope).
o.window("^(steam_app_.*|gamescope)$", { idle_inhibit = "always" })

-- Never let a new window knock a fullscreen game out of fullscreen. Anything
-- that opens (Steam popups, dialogs, screensaver) goes behind the game instead.
hl.config({ misc = { on_focus_under_fullscreen = 0 } })
