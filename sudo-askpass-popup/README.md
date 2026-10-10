# sudo-askpass-popup

A graphical sudo prompt for Omarchy. When a script or tool runs `sudo -A`, sudo calls the program named in `SUDO_ASKPASS` to get the password. This helper opens a small floating Omarchy terminal with a masked password field (using [gum](https://github.com/charmbracelet/gum), falling back to `read -s` if gum is missing).

The password is handed back to sudo through a temporary named pipe (mode 600, in a private `mktemp -d` directory) that is deleted when the helper exits. It never touches the disk. If the window is closed without an answer, the helper gives up after 180 seconds.

This is useful because a stock Omarchy install has no polkit agent prompting for `pkexec`, so tools that cannot read a terminal (editors, AI coding agents, background scripts) otherwise have no way to ask for a password.

## Install

```bash
install -m 700 sudo-askpass-popup ~/.local/bin/
```

## Use

```bash
SUDO_ASKPASS=$HOME/.local/bin/sudo-askpass-popup sudo -A <command>
```

Or export `SUDO_ASKPASS` in your shell profile and just use `sudo -A`.

## Notes

- The message shown in the window ("Claude Code is requesting sudo access.") is just a label. Change it to whatever suits you.
- The terminal window uses the app ID `org.omarchy.terminal`, so Omarchy's floating terminal rules apply to it.
