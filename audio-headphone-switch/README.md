# audio-headphone-switch

Keeps the motherboard's onboard audio on **5.1 surround** for speakers, and switches it to **stereo only while headphones are plugged into the front-panel jack**. Unplug them and it goes back to 5.1.

## Why

On many onboard codecs the Headphones output port only exists in the analog stereo profile. If the card is saved on 5.1, WirePlumber keeps it there when you plug headphones in, so the headphones stay silent.

## How it works

- Runs as a systemd user service and listens to `pactl subscribe` for card events (such as a jack being plugged in).
- Headphones available: switches to `output:analog-stereo+input:analog-stereo`.
- Otherwise: switches to `output:analog-surround-51+input:analog-stereo`.
- **It never hijacks your default output.** It only moves the default sink to the new profile's sink if the default was already on the onboard card. If you picked USB headphones, HDMI or anything else, that choice is left alone.
- The service restarts automatically if it dies.

Requires `jq` and `pactl` (from `libpulse`, already present on Omarchy with PipeWire).

## Adapt it

The card name `alsa_card.pci-0000_00_1f.3` and the sink prefix `alsa_output.pci-0000_00_1f.3` contain **my PCI address, which is only an example**. Find yours with:

```bash
pactl list cards | grep -E 'Name:|Active Profile'
```

Update `CARD` and the two `pci-0000_00_1f.3` patterns in the script. Check the profile names in that same output if your card uses different ones.

## Install

```bash
install -m 755 audio-headphone-switch ~/.local/bin/
cp audio-headphone-switch.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now audio-headphone-switch
```

## Troubleshoot

```bash
systemctl --user status audio-headphone-switch
journalctl --user -u audio-headphone-switch
pactl list cards | grep 'Active Profile'
speaker-test -D pipewire -c 6 -t wav -l 1    # test all six channels
```

Speaker wiring reminder for typical 3.5 mm 5.1 jacks: green = front, black = rear, orange = center/sub.
