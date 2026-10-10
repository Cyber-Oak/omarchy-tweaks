# omarchy-tweaks

Personal customizations layered on top of a stock [Omarchy](https://omarchy.org) install (Arch + Hyprland). They solve problems I hit on my own machine, so treat them as starting points: read each README and adapt paths, device names and hardware identifiers to your own setup before using anything.

> **Not official.** Nothing here is supported by Omarchy or its maintainers. Use at your own risk.

## Contents

| Folder | What it does |
| --- | --- |
| [sudo-askpass-popup](sudo-askpass-popup/) | Graphical sudo password prompt via `SUDO_ASKPASS` |
| [openrgb-retrowave-retry](openrgb-retrowave-retry/) | Apply an OpenRGB profile at login, retrying if devices are not ready yet |
| [audio-headphone-switch](audio-headphone-switch/) | Keep onboard audio on 5.1, switch to stereo only while headphones are plugged in |
| [update-check-notify](update-check-notify/) | Daily pacman + AUR update notification that opens `omarchy-update` on click |
| [flatpak-auto-update](flatpak-auto-update/) | Daily user-level Flatpak update and unused runtime cleanup |
| [tpm2-autologin](tpm2-autologin/) | TPM2 auto-unlock of the LUKS root plus SDDM autologin |
| [hyprland-gaming](hyprland-gaming/) | Hyprland rules that keep Steam and other windows from interrupting games |
| [gdk-scale-1440p](gdk-scale-1440p/) | Fix GTK/XWayland apps looking double-size on a 1440p monitor |
| [steam-controller-pairing](steam-controller-pairing/) | Fixing a Steam Controller Puck with a broken pairing |
