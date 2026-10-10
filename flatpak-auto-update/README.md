# flatpak-auto-update

A systemd user timer that updates your **user-level** Flatpak apps once a day and then removes runtimes nothing uses anymore.

## How it works

- `flatpak-update.service` runs `flatpak update --user --noninteractive -y`, then `flatpak uninstall --user --unused --noninteractive -y`.
- `flatpak-update.timer` runs it 10 minutes after boot and daily after that, with up to 15 minutes of random delay. `Persistent=true` means a run missed while the PC was off happens at next boot.
- It only touches the `--user` installation. If you install Flatpaks system-wide, change `--user` to `--system` (which needs root, so a system unit instead of a user unit).

## Context

I set this up after installing Flatpak to get **Bambu Studio**, installed per-user from Flathub as `com.bambulab.BambuStudio`:

```bash
flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub com.bambulab.BambuStudio
```

If a freshly installed Flatpak app does not show up in the app launcher, symlink its `.desktop` file from `~/.local/share/flatpak/exports/share/applications/` into `~/.local/share/applications/`, or log out and back in.

## Install

```bash
cp flatpak-update.service flatpak-update.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now flatpak-update.timer
```

## Troubleshoot

```bash
systemctl --user list-timers flatpak-update.timer
journalctl --user -u flatpak-update
```
