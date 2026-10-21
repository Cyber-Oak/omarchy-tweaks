# workspace-app-icons

Omarchy Shell bar widget that shows an icon for every open window next to each workspace number, e.g. `1 [terminal] 2 [browser]`. It is a clone of the stock `omarchy.workspaces` widget (made with `omarchy plugin clone omarchy.workspaces`), so clicking a workspace still switches to it and the focused workspace keeps the stock glyph.

Icons come from each window's desktop entry, resolved in this order:

1. Brave/Chromium web apps (window class `brave-<host>__…`): the desktop entry whose `Exec` contains that host
2. `DesktopEntries.heuristicLookup` on the window class
3. A desktop id ending in `.<class>` (e.g. class `BambuStudio` → `com.bambulab.BambuStudio`)
4. A theme icon named after the class, then `application-x-executable`

On a vertical bar the icons stack under the number.

## Install

Symlink the plugin so `git pull` updates it (a plain copy also works):

```sh
ln -s ~/omarchy-tweaks/workspace-app-icons/cyberoak.workspaces ~/.config/omarchy/plugins/cyberoak.workspaces
```

`~/.config/omarchy/shell.json` must use this widget in place of the stock one:

```json
{ "id": "cyberoak.workspaces" }
```

Then run `omarchy restart shell`. Restart the shell after every QML edit, because the bar caches the component and hot reload does not pick up changes.

## Gotcha: `omarchy refresh shell`

`omarchy refresh shell` resets shell.json, which switches the bar back to `omarchy.workspaces`. The plugin folder is left alone. To fix it, change the id back to `cyberoak.workspaces` and run `omarchy restart shell`.

The clone does not pick up later upstream changes to the stock widget. To rebase, diff `Workspaces.qml` against `/usr/share/omarchy/shell/plugins/bar/widgets/Workspaces.qml` after an Omarchy update.
