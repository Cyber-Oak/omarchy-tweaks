# steam-controller-pairing

No code here, only a procedure.

## Symptom

The Steam Controller with its wireless **Puck** dongle stopped working in games launched from the desktop (and the Steam overlay stopped responding to it), while it still worked in Big Picture mode.

## Diagnosis

Check Steam's controller log:

```bash
grep -E 'Unable to read bond|Disconnecting zombie controller|HID IO failure' ~/.local/share/Steam/logs/controller.txt
```

These lines mean the wireless link keeps dropping because of a bad pairing bond between the controller and the Puck:

- `Unable to read bond`
- `Disconnecting zombie controller`
- `HID IO failure`

A line like `Error committing registration ... Invalid Parameter` shows up even when everything works. Ignore it.

## Fix

In Steam's controller settings, **unpair** the controller and the Puck, then **pair them again**. If it acts up later, check the log for the same lines and re-pair.

More context: [omacom/omarchy discussion #14902](https://github.com/omacom/omarchy/discussions/14902)
