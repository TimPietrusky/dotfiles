# dotfiles

My personal macOS setup for terminal-based / AI-agent workflows:
**zsh + Oh My Zsh + Powerlevel10k, tmux, Ghostty, Karabiner.**

Used to rebuild my global setup on a fresh machine. Bring your own API keys.

## Quick start

```bash
git clone https://github.com/TimPietrusky/dotfiles.git
cd dotfiles

# 1. Install apps + CLI tools
brew bundle --file=Brewfile

# 2. Install Oh My Zsh + Powerlevel10k + zsh plugins  (see SETUP.md)

# 3. Symlink the configs
./install.sh --with-karabiner   # drop the flag to skip the Caps Lock remap
```

Then open tmux and press **`prefix + I`** (capital i) to install the tmux plugins.

Full step-by-step instructions: **[SETUP.md](SETUP.md)** (for humans).
Provisioning with an AI agent on a blank machine: **[AGENTS.md](AGENTS.md)**.

## What's included

| Path | Purpose |
|------|---------|
| `zsh/.zshrc` | Oh My Zsh, Powerlevel10k theme, `fnm`, plugins (autosuggestions, syntax-highlighting) |
| `zsh/.zprofile` | Homebrew shell env |
| `zsh/.zshenv.example` | Template for API keys — copy to `~/.zshenv` and fill in your own |
| `zsh/.p10k.zsh` | Powerlevel10k prompt configuration |
| `git/.gitconfig.example` | Template — set your own name + email |
| `tmux/.tmux.conf` | tmux: mouse, vi keys, fzf session picker, lazygit/htop popups, TPM plugins |
| `config/ghostty/config` | Ghostty terminal (Snazzy theme, JetBrainsMono Nerd Font) |
| `config/karabiner/karabiner.json` | Caps Lock → Esc (tap) / Ctrl (hold) — optional |
| `Brewfile` | All apps + CLI tools |
| `install.sh` | Symlinks everything into place (backs up existing files) |

## Secrets

Real API keys live **only** in your local `~/.zshenv`, which is never committed.
This repo ships `zsh/.zshenv.example` with empty placeholders.

## tmux keys (prefix = `Ctrl+B`)

| Action | Keys |
|--------|------|
| Split horizontal | `prefix` then `-` |
| Split vertical | `prefix` then `\|` |
| Navigate panes | `Ctrl+h/j/k/l` |
| Zoom pane | `prefix` then `m` |
| Reload config | `prefix` then `r` |
| Session picker (fzf) | `prefix` then `s` |
| LazyGit popup | `prefix` then `g` |
| Install plugins | `prefix` then `I` |
