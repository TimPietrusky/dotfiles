# Docker

Installed via `cask "docker-desktop"`. `install.sh` symlinks `daemon.json` into
`~/.docker/daemon.json` — it caps the BuildKit cache at 20 GB with GC enabled,
which is the one setting worth carrying.

Not tracked:

- `~/.docker/config.json` — points at the macOS keychain credential store
  (`credsStore: desktop`); Docker Desktop recreates it on login.
- `~/.docker/{contexts,buildx,models,sandboxes,desktop-build,mutagen}` — local state.

## Login — [HUMAN]

Launch Docker Desktop once, accept the licence prompt, sign in to Docker Hub if
you need private images.
