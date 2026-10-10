# update-check-notify

A once-a-day check for pending **pacman and AUR** updates. If there are any, it shows a notification such as "Updates available (12): 10 repo, 2 AUR package update(s) available". Clicking it opens Omarchy's own updater (`omarchy-update`) in a floating terminal.

**It never installs anything itself.** It only tells you, and you decide when to update.

## Why

Omarchy's bar indicator only watches for new Omarchy releases, not ordinary system or AUR package updates.

## How it works

- The timer fires 1 minute after login and then every hour. The script exits immediately unless 24 hours have passed since the last successful check, so a missed day is caught up as soon as you log in.
- Repo updates come from `checkupdates` (from `pacman-contrib`), AUR updates from `yay -Qua`.
- If the check fails (for example no network yet), the timestamp is not written, so it retries next hour.
- The notification uses **critical** urgency because that is the only level Omarchy's notification daemon keeps on screen; others disappear after a while.
- The click action is named `default` because that is the action Omarchy's notifier triggers when you click the card.

## Install

```bash
install -m 755 update-check-notify ~/.local/bin/
cp update-check-notify.service update-check-notify.timer ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now update-check-notify.timer
```

## Test / troubleshoot

```bash
~/.local/bin/update-check-notify --force       # check right now, ignoring the 24h limit
systemctl --user list-timers update-check-notify.timer
journalctl --user -u update-check-notify
```
