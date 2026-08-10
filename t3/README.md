# T3 Code

Installed via `cask "t3-code@nightly"` (Brewfile). `install.sh` symlinks these
into `~/.t3/userdata/`:

| File | Purpose |
|------|---------|
| `keybindings.json` | Full custom keymap — `mod+j` terminal toggle, `mod+d` split/diff, `mod+k` palette, `mod+1..9` thread jump, preview zoom, etc. |
| `settings.json` | Provider instances (codex + opencode drivers registered, both currently disabled) |
| `client-settings.json` | UI prefs — sidebar grouped by repository, sorted by `updated_at`, word wrap on, diff ignores whitespace, no archive confirm |

Not tracked (machine-local, regenerated on first launch):

- `~/.t3/userdata/desktop-settings.json` — window position/size
- `~/.t3/userdata/clerk-tokens.json` — auth session **(secret)**
- `~/.t3/userdata/secrets/*.bin` — signing keys **(secret)**
- `~/.t3/userdata/state.sqlite*` — thread/chat history
- `~/.t3/caches/`, `~/.t3/worktrees/`
- `~/Library/Application Support/t3code/` — Electron profile, cookies, caches

## Login — [HUMAN]

Launch T3 Code once and sign in; it writes `clerk-tokens.json` itself.
