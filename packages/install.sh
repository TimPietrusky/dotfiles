#!/usr/bin/env bash
# Install the language toolchains and global packages that Homebrew doesn't own:
# node (via fnm), global npm packages, uv, pipx apps, and the standalone CLIs.
#
#   ./packages/install.sh
#
# Idempotent. Assumes `brew bundle` already ran (fnm + pipx come from Homebrew).

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NODE_VERSION="$(tr -d '[:space:]' < "$HERE/node-version")"

echo "==> node $NODE_VERSION via fnm"
eval "$(fnm env --use-on-cd --shell bash)"
fnm install "$NODE_VERSION" 2>/dev/null || true
fnm default "$NODE_VERSION"
fnm use "$NODE_VERSION"
node -v

echo "==> global npm packages"
grep -vE '^\s*(#|$)' "$HERE/npm-global.txt" | while read -r pkg; do
  echo "    $pkg"
  npm install -g "$pkg"
done

echo "==> uv (Astral standalone installer -> ~/.local/bin)"
command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh

echo "==> pipx apps"
grep -vE '^\s*(#|$)' "$HERE/pipx.txt" | while read -r pkg; do
  echo "    $pkg"
  pipx install "$pkg" 2>/dev/null || pipx upgrade "$pkg"
done

echo "==> Claude Code"
command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.com/install.sh | bash

echo "==> opencode"
command -v opencode >/dev/null 2>&1 || curl -fsSL https://opencode.ai/install | bash

echo "==> a2go"
command -v a2go >/dev/null 2>&1 || echo "    not installed — see https://github.com/TimPietrusky/a2go"

echo "==> Cursor extensions"
if command -v cursor >/dev/null 2>&1; then
  grep -vE '^\s*(#|$)' "$HERE/../cursor/extensions.txt" | while read -r ext; do
    echo "    $ext"
    cursor --install-extension "$ext" --force >/dev/null
  done
else
  echo "    'cursor' not on PATH — open Cursor once and run"
  echo "    'Shell Command: Install cursor command' from the palette, then re-run"
fi

echo
echo "Done. Auth for these tools is per-machine — see docs/NOT-IN-THIS-REPO.md."
