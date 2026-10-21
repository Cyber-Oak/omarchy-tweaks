# WORKLOG — omarchy-tweaks

Shared log for Claude sessions on **infinity** (desktop) and **forge** (ThinkPad). Read before starting work; append an entry before finishing. Newest entries at the bottom.

---

## 2026-10-16 08:53 EDT — infinity

**What this project is:** Personal Omarchy (Arch + Hyprland) customizations, each in its own folder with a README: sudo-askpass-popup, openrgb-retrowave-retry, audio-headphone-switch, update-check-notify, flatpak-auto-update, tpm2-autologin, hyprland-gaming, gdk-scale-1440p, steam-controller-pairing. These are documented copies of fixes applied to infinity; the live installs are in ~/.local/bin, ~/.config/systemd/user and the Hyprland config, not symlinked from here.

**What I did:** Created this WORKLOG.md as part of the cross-machine setup. No code changes.

**Why:** Nick now works on two machines with Claude on both. The worklog protocol (in ~/.claude/CLAUDE.md, synced via the private Cyber-Oak/claude-sync repo using claudedot) makes this file the shared memory between sessions on either machine.

**Current state (as found):** Clean working tree on `main`, in sync with origin; 2 commits. Note: this clone lives at ~/omarchy-tweaks on infinity, *not* under ~/Projects like the other repos — deliberately left in place.

**Cross-machine setup today:** Syncthing pairs infinity ↔ forge for ~/Workbench only (folder id `workbench`); git repos sync through GitHub, not Syncthing. Claude config syncs via claudedot → Cyber-Oak/claude-sync. Session history sync via ccsync being set up next.

**Loose ends / next steps:** Many tweaks are hardware-specific to infinity (1440p monitor, K70/Nightsword RGB, 5.1 audio, TPM). Check which apply to forge before installing anything there.

## 2026-10-17 23:15 EDT — infinity

**What I did:** Added a systemd 262 note to tpm2-autologin/README.md. **Why:** the omarchy update to systemd 262 broke TPM auto-unlock. The new `systemd-pcrosseparator.service` extends PCR 7 in the initrd before cryptsetup, so the old PCR 7 seal stopped matching. Nick re-enrolled by hand in a real terminal (the auto-mode classifier blocked Claude from doing it, and `!` has no TTY for the sudo and LUKS prompts). The new TPM2 token is in **keyslot 2**. Old slot 1 is wiped and the passphrase is still in slot 0. I rejected masking pcrosseparator via the cmdline (option B) because it gives up the new firmware-PCR sealing.

**State / loose ends:** Not yet verified by a reboot. Next boot should go straight to the desktop. If it still prompts, check `journalctl -b | grep systemd-cryptsetup`. Full post-update check in ~/Workbench/WORKLOG.md.

## 2026-10-17 23:45 EDT — infinity

**What I did:** Fixed the Corsair MM700 mouse pad not taking the retrowave colors after tonight's update. **Cause:** the update moved openrgb from 1.0rc3 to 1.1. Version 1.1 migrated `retrowave.orp` to `~/.config/OpenRGB/profiles/retrowave.json` (the migration is fine, and the MM700 entry and its hidraw location still match). But `openrgb --profile` now applies the profile and **exits**. The MM700 goes back to its hardware effect once nothing is driving it. With 1.0rc3, the process stayed running. **Fix:** openrgb-apply-retrowave now launches with `--startminimized`, so it keeps running in the tray. It also waits for `Detection completed` instead of `Profile loading`, which 1.1 no longer logs. I installed it to ~/.local/bin and ran it. Nick confirmed the pad is lit correctly. The autostart.lua line is unchanged.

**Rejected:** `--server` with no GUI. It would probably also keep the process alive, but it opens an SDK port nobody uses. The tray is how the GUI normally runs, and Nick can open it from there.

**Loose ends:** Not yet verified on a cold boot/login.

## 2026-10-18 — infinity

**What I did:** Stopped OpenRGB from popping up a window at login. **Cause:** the window wasn't the main GUI. It was OpenRGB 1.1's "Zone Initialization" dialog (`OpenRGBZoneInitializationDialog`), which runs zone-size checks at startup and opens for unconfigured resizable zones even with `--startminimized`. **Fix:** I set `"UserInterface": {"run_zone_checks": false}` in ~/.config/OpenRGB/OpenRGB.json (backup: OpenRGB.json.bak-zonecheck). That's the GUI's "Run Zone Checks on Rescan" setting. I edited it with OpenRGB closed, then re-ran openrgb-apply-retrowave: it exited 0 (K70 and Nightsword detected), the process is still running, and no OpenRGB window is open. I documented the step in openrgb-retrowave-retry/README.md. The script and autostart are unchanged.

**Rejected:** switching to `--server` with no GUI. It would also avoid the dialog, but the reasons in the 10-17 entry still hold, and the one-setting fix is smaller.

**Loose ends:** Not yet verified on a fresh login. If the dialog comes back, check that the setting survived in OpenRGB.json. Configuring the zones in Zone Manager would be the other option.

## 2026-10-21 14:30 EDT — forge

**What I did:** Added workspace-app-icons/, which holds the `cyberoak.workspaces` Omarchy Shell bar plugin (per-window icons next to workspace numbers) and a README. **forge's copy is now canonical.** It was rebuilt on 10-21 from the 10-17 infinity worklog description; infinity's original was never in a repo, and infinity was unreachable over SSH. Nick picked this machine as the source. Scrubbing: the files had no home paths, device names or UUIDs. The id `cyberoak.workspaces` is Nick's handle and must match shell.json, so it stays. manifest.json: author changed from "Omarchy" (clone default) to "Cyber-Oak", and the description now mentions icons.

**Exception to this repo's "documented copies, not symlinked" rule:** on forge, `~/.config/omarchy/plugins/cyberoak.workspaces` is now a **symlink** into this repo, at Nick's request, so both machines run one copy. It loads fine as a symlink: `omarchy plugin list` shows it enabled. Verified on forge: icons render (screenshot), and real left clicks (via a temporary uinput mouse) on the "1" label, the Chrome icon on 2, and the "3" label each switched to that workspace.

**Next (infinity):** see ~/Workbench/WORKLOG.md for the adoption steps.
