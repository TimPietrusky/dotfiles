#!/usr/bin/env bash
# Verify that the expected dotfiles and core CLI tools are installed.

set -u

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
failures=0

pass() {
    printf 'ok   %s\n' "$1"
}

fail() {
    printf 'miss %s\n' "$1"
    failures=$((failures + 1))
}

note() {
    printf 'note %s\n' "$1"
}

check_link() {
    local source="$1" destination="$2"

    if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$source" ]; then
        pass "$destination -> $source"
    else
        fail "$destination should link to $source"
    fi
}

check_command() {
    local command="$1"

    if command -v "$command" >/dev/null 2>&1; then
        pass "$command"
    else
        fail "$command"
    fi
}

printf 'shell / terminal\n'
check_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
check_link "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
check_link "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
check_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
check_link "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

printf '\nagent tooling configs\n'
check_link "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
check_link "$DOTFILES_DIR/claude/keybindings.json" "$HOME/.claude/keybindings.json"
check_link "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
check_link "$DOTFILES_DIR/claude/style-reminder.txt" "$HOME/.claude/style-reminder.txt"
check_link "$DOTFILES_DIR/codex/config.toml" "$HOME/.codex/config.toml"
check_link "$DOTFILES_DIR/config/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
check_link "$DOTFILES_DIR/config/gh/config.yml" "$HOME/.config/gh/config.yml"
check_link "$DOTFILES_DIR/t3/settings.json" "$HOME/.t3/userdata/settings.json"
check_link "$DOTFILES_DIR/t3/client-settings.json" "$HOME/.t3/userdata/client-settings.json"
check_link "$DOTFILES_DIR/t3/keybindings.json" "$HOME/.t3/userdata/keybindings.json"

printf '\napp configs\n'
check_link "$DOTFILES_DIR/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
check_link "$DOTFILES_DIR/keepassxc/keepassxc.ini" "$HOME/Library/Application Support/KeePassXC/keepassxc.ini"
check_link "$DOTFILES_DIR/docker/daemon.json" "$HOME/.docker/daemon.json"

printf '\nlocal files\n'
[ -f "$HOME/.zshenv" ] && pass "$HOME/.zshenv" || fail "$HOME/.zshenv"
[ -f "$HOME/.gitconfig" ] && pass "$HOME/.gitconfig" || fail "$HOME/.gitconfig"
[ -d "$HOME/.tmux/plugins/tpm" ] && pass "tmux plugin manager" || fail "tmux plugin manager"

printf '\ncommands\n'
for command in brew git gh tmux fnm fzf fd eza bat rg lazygit node npm go python3 uv pipx; do
    check_command "$command"
done

printf '\nagent CLIs\n'
for command in claude codex opencode bd infisical terraform hcloud runpodctl dolt wrangler vercel; do
    check_command "$command"
done

printf '\nsecrets / auth (presence only — values never printed)\n'
grep -qE '^export RUNPOD_API_KEY=.+' "$HOME/.zshenv" 2>/dev/null \
    && pass "~/.zshenv has keys" || note "~/.zshenv still a stub — needs a human"
git_email="$(git config --global user.email 2>/dev/null || true)"
case "$git_email" in
    ""|"you@example.com")
        note "git identity still the template placeholder — needs a human" ;;
    *)
        pass "git identity set" ;;
esac
gh auth status >/dev/null 2>&1 \
    && pass "gh authenticated" || note "gh not logged in — run 'gh auth login'"
[ -f "$HOME/.ssh/id_ed25519" ] \
    && pass "ssh key present" || note "no ~/.ssh/id_ed25519 — needs a human"

printf '\nfonts\n'
# Ghostty's config names these explicitly; without them it silently falls back
# to the system monospace and the powerlevel10k glyphs render as boxes.
font_installed() {
    local pattern="$1"
    ls ~/Library/Fonts /Library/Fonts 2>/dev/null | grep -qi "$pattern" && return 0
    brew list --cask 2>/dev/null | grep -qi "$pattern" && return 0
    return 1
}
font_installed "jetbrains.*mono.*nerd\|font-jetbrains-mono-nerd" \
    && pass "JetBrainsMono Nerd Font" \
    || note "JetBrainsMono Nerd Font missing — Ghostty falls back, p10k glyphs break"
font_installed "symbols.*nerd\|font-symbols-only-nerd" \
    && pass "Symbols Nerd Font Mono" \
    || note "Symbols Nerd Font Mono missing — icon glyphs will render as boxes"

printf '\n'
if [ "$failures" -eq 0 ]; then
    printf 'setup looks good — see docs/NOT-IN-THIS-REPO.md for the [HUMAN] steps\n'
    exit 0
fi

printf '%s setup item(s) missing; see SETUP.md\n' "$failures"
exit 1
