# openrgb-retrowave-retry

Applies an [OpenRGB](https://openrgb.org) profile (named `retrowave` here) at login, and retries if some devices were not detected yet.

## The problem

Some USB RGB devices are not ready right after login. OpenRGB starts, does not see them, and they stay dark while everything else lights up. It is a timing race, not a permissions problem.

## How it works

1. Waits 3 seconds, then starts OpenRGB with the profile.
2. Watches OpenRGB's newest log in `~/.config/OpenRGB/logs/` until the profile finishes loading.
3. If the log mentions both expected devices, it is done.
4. Otherwise it kills OpenRGB, waits, and tries again, up to 4 attempts. On the last attempt OpenRGB is left running so the devices that were detected stay lit.
5. Each failed attempt is logged to the journal under the tag `openrgb-apply`.

## Adapt it

The device names `K70` (Corsair K70 RGB MK.2 keyboard) and `Nightsword` (Corsair Nightsword mouse) are **examples from my machine**. Replace them in the `grep` line with names of the devices that go missing on yours, as they appear in OpenRGB's log. Also change `retrowave` to the name of your saved profile.

## Install

```bash
install -m 755 openrgb-apply-retrowave ~/.local/bin/
```

Then add the line from [autostart.lua](autostart.lua) to `~/.config/hypr/autostart.lua`.

## Troubleshoot

```bash
journalctl -t openrgb-apply              # retry attempts
ls -t ~/.config/OpenRGB/logs/ | head     # newest OpenRGB log
~/.local/bin/openrgb-apply-retrowave     # run by hand
```
