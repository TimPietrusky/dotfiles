# Cursor

Installed via `cask "cursor"`. `install.sh` symlinks `settings.json` into
`~/Library/Application Support/Cursor/User/settings.json`.

Settings are minimal on the source machine — theme follows the system appearance
and nothing else is overridden. No custom keybindings, no snippets.

Extensions live in `extensions.txt` (two remote-dev extensions) and are installed
by `packages/install.sh`.

Not tracked: `History/`, `globalStorage/`, `workspaceStorage/` — Electron state
and per-workspace caches.

## Login — [HUMAN]

Launch Cursor once and sign in.
