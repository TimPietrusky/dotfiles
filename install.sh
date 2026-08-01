#!/usr/bin/env bash
# Dotfiles installer — symlinks configs into place.
# Existing real files are backed up with a .backup extension.
#
# Usage:
#   ./install.sh                  # everything except karabiner
#   ./install.sh --with-karabiner # also link karabiner (Caps Lock remap)

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; NC='\033[0m'

link() {
    local src="$1" dest="$2"
    mkdir -p "$(dirname "$dest")"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo -e "  ${YELLOW}Backing up existing $dest -> $dest.backup${NC}"
        cp "$dest" "$dest.backup"
    fi
    ln -sf "$src" "$dest"
    echo -e "  ${GREEN}linked${NC} $dest"
}

echo -e "${BLUE}Installing dotfiles from $DOTFILES_DIR${NC}\n"

echo -e "${GREEN}[zsh]${NC}"
link "$DOTFILES_DIR/zsh/.zshrc"    ~/.zshrc
link "$DOTFILES_DIR/zsh/.zprofile" ~/.zprofile
link "$DOTFILES_DIR/zsh/.p10k.zsh" ~/.p10k.zsh
if [ ! -f ~/.zshenv ]; then
    cp "$DOTFILES_DIR/zsh/.zshenv.example" ~/.zshenv
    echo -e "  ${YELLOW}created ~/.zshenv from template — add your API keys${NC}"
else
    echo -e "  ${BLUE}~/.zshenv already exists — left untouched (add keys yourself)${NC}"
fi

echo -e "${GREEN}[git]${NC}"
if [ ! -f ~/.gitconfig ]; then
    cp "$DOTFILES_DIR/git/.gitconfig.example" ~/.gitconfig
    echo -e "  ${YELLOW}created ~/.gitconfig from template — set your name + email${NC}"
else
    echo -e "  ${BLUE}~/.gitconfig already exists — left untouched${NC}"
fi

echo -e "${GREEN}[tmux]${NC}"
link "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

echo -e "${GREEN}[ghostty]${NC}"
link "$DOTFILES_DIR/config/ghostty/config" ~/.config/ghostty/config

echo -e "${GREEN}[gh]${NC}"
link "$DOTFILES_DIR/config/gh/config.yml" ~/.config/gh/config.yml
echo -e "  ${BLUE}~/.config/gh/hosts.yml is NOT linked (auth token) — run 'gh auth login'${NC}"

echo -e "${GREEN}[claude code]${NC}"
link "$DOTFILES_DIR/claude/settings.json"      ~/.claude/settings.json
link "$DOTFILES_DIR/claude/keybindings.json"   ~/.claude/keybindings.json
link "$DOTFILES_DIR/claude/CLAUDE.md"          ~/.claude/CLAUDE.md
link "$DOTFILES_DIR/claude/style-reminder.txt" ~/.claude/style-reminder.txt

echo -e "${GREEN}[codex]${NC}"
link "$DOTFILES_DIR/codex/config.toml" ~/.codex/config.toml

echo -e "${GREEN}[opencode]${NC}"
link "$DOTFILES_DIR/config/opencode/opencode.json" ~/.config/opencode/opencode.json

echo -e "${GREEN}[t3 code]${NC}"
link "$DOTFILES_DIR/t3/settings.json"        ~/.t3/userdata/settings.json
link "$DOTFILES_DIR/t3/client-settings.json" ~/.t3/userdata/client-settings.json
link "$DOTFILES_DIR/t3/keybindings.json"     ~/.t3/userdata/keybindings.json

if [ "$1" = "--with-karabiner" ]; then
    echo -e "${GREEN}[karabiner]${NC}"
    link "$DOTFILES_DIR/config/karabiner/karabiner.json" ~/.config/karabiner/karabiner.json
else
    echo -e "${BLUE}[karabiner]${NC} skipped (pass --with-karabiner to include)"
fi

echo -e "${GREEN}[tmux plugin manager]${NC}"
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo -e "  ${GREEN}TPM installed — open tmux and press 'prefix + I' to install plugins${NC}"
else
    echo -e "  ${GREEN}already installed${NC}"
fi

echo -e "\n${GREEN}Done!${NC} Next:"
echo "  ./packages/install.sh    # node, npm globals, uv, pipx, agent CLIs"
echo "  ./macos/defaults.sh      # macOS system preferences (optional)"
echo "  ./check.sh               # verify"
echo -e "\nThen read ${YELLOW}docs/NOT-IN-THIS-REPO.md${NC} — secrets and GUI steps a script cannot do."
