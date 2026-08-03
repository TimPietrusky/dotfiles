# KeePassXC

Installed via `cask "keepassxc"`. `install.sh` symlinks `keepassxc.ini` into
`~/Library/Application Support/KeePassXC/keepassxc.ini`.

The only real preference in there is the password generator: **128 characters,
special characters on, no exclusions**. Everything else is defaults.

## The vault is NOT here — [HUMAN]

`keepassxc.ini` is settings only. The `.kdbx` database — the actual passwords —
is never committed and must be moved over out of band.

On the source machine it lives at:

```
~/Documents/timpietrusky/timpietrusky_keepass_database_*.kdbx
```

with stale copies also sitting in `~/Downloads` (worth cleaning up rather than
migrating). Move the current vault by hand — USB, or a channel you trust. Do not
put it anywhere near a git repo.

See `docs/NOT-IN-THIS-REPO.md`.
