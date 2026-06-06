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

printf 'dotfiles\n'
check_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
check_link "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
check_link "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
check_link "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
check_link "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

printf '\nlocal files\n'
[ -f "$HOME/.zshenv" ] && pass "$HOME/.zshenv" || fail "$HOME/.zshenv"
[ -f "$HOME/.gitconfig" ] && pass "$HOME/.gitconfig" || fail "$HOME/.gitconfig"
[ -d "$HOME/.tmux/plugins/tpm" ] && pass "tmux plugin manager" || fail "tmux plugin manager"

printf '\ncommands\n'
for command in brew git gh tmux fnm fzf fd eza bat lazygit; do
    check_command "$command"
done

printf '\n'
if [ "$failures" -eq 0 ]; then
    printf 'setup looks good\n'
    exit 0
fi

printf '%s setup item(s) missing; see SETUP.md\n' "$failures"
exit 1
