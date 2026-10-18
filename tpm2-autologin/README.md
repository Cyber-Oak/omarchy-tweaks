# tpm2-autologin

Power button to desktop with no passwords: the LUKS-encrypted root is unlocked automatically by the motherboard's **TPM2** chip, and **SDDM autologin** logs you straight into the Omarchy session.

## The trade-off (read this first)

**This removes protection against anyone with physical access to the machine.** Whoever can press the power button gets a logged-in desktop. What remains is protection if the drive is removed and read in another computer, because the TPM will only release the key on this machine. Only use this if that trade-off suits you.

## How it works

- **LUKS2 keyslots.** Your passphrase stays in its existing keyslot and always works as a fallback. The TPM key is enrolled in an extra keyslot, bound to PCR 7 (Secure Boot state).
- **[mkinitcpio-zz-tpm-unlock.conf](mkinitcpio-zz-tpm-unlock.conf)** goes in `/etc/mkinitcpio.conf.d/zz-tpm-unlock.conf`. It replaces Omarchy's busybox `encrypt` hook with the `systemd` + `sd-encrypt` hooks, which are what support TPM unlock. The `zz-` prefix makes it load after Omarchy's own drop-ins.
- **[limine-zz-tpm-unlock.conf](limine-zz-tpm-unlock.conf)** goes in `/etc/limine-entry-tool.d/zz-tpm-unlock.conf`. It adds the `rd.luks.*` kernel options that `sd-encrypt` reads. Omarchy's original `cryptdevice=` option is kept, so if an update ever brings back the busybox initramfs, the system still boots and simply asks for the passphrase.
- **[sddm-autologin.conf](sddm-autologin.conf)** goes in `/etc/sddm.conf.d/autologin.conf`.

## Adapt it

- Replace `<your-luks-uuid>` with the UUID of your LUKS partition: `sudo cryptsetup luksUUID /dev/<your-luks-partition>` (or `lsblk -f`).
- Replace `<your-username>` with your login name.
- Compare the `HOOKS=` line with your current one (`grep -r HOOKS /etc/mkinitcpio.conf.d/`) and keep any extra hooks your system needs.

## Install

```bash
# 1. Enroll the TPM (asks for your existing LUKS passphrase)
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/<your-luks-partition>

# 2. Install the drop-ins (after editing placeholders)
sudo install -m 644 mkinitcpio-zz-tpm-unlock.conf /etc/mkinitcpio.conf.d/zz-tpm-unlock.conf
sudo install -m 644 limine-zz-tpm-unlock.conf /etc/limine-entry-tool.d/zz-tpm-unlock.conf
sudo install -m 644 sddm-autologin.conf /etc/sddm.conf.d/autologin.conf

# 3. Rebuild the initramfs and boot entries
sudo limine-mkinitcpio
```

## Re-enrolling (when the passphrase prompt comes back)

A BIOS/firmware update or toggling Secure Boot changes PCR 7, so the TPM refuses to release the key and you get the passphrase prompt again. So does the systemd 262 upgrade: its new `systemd-pcrosseparator.service` extends an "os-separator" measurement into PCR 7 in the initrd, before cryptsetup runs, and the journal shows `TPM policy does not match current system state`. Re-enrolling once while booted fixes it, because the current PCR 7 already includes the separator. Type your passphrase, then re-enroll:

```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=7 /dev/<your-luks-partition>
```

## Known downside

Booting a Limine btrfs snapshot loses Omarchy's writable overlay for snapshots, because that feature relies on the busybox `encrypt` initramfs.

## Undo

Delete the three drop-in files, run `sudo limine-mkinitcpio`, and optionally remove the TPM keyslot with `sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/<your-luks-partition>`.
