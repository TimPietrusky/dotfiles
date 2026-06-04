# Setup

Step-by-step guide to rebuild this setup on a fresh macOS machine.

## 0. Homebrew

If you don't have it yet:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then add it to your shell (Apple Silicon path):

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## 1. Install apps + CLI tools

```bash
brew bundle --file=Brewfile
```

This installs Ghostty, Karabiner-Elements, Cursor, Docker, Slack, the Nerd Fonts,
and the CLI tools (tmux, fnm, fzf, fd, eza, bat, lazygit, gh, etc.).

Install **Claude Code** separately — see https://claude.com/claude-code.
(Claude settings are intentionally *not* part of this repo.)

## 2. Oh My Zsh + Powerlevel10k + zsh plugins

`zsh/.zshrc` expects Oh My Zsh, the Powerlevel10k theme, and two plugins.

```bash
# Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

> The Oh My Zsh installer creates its own `~/.zshrc`. That's fine — the next
> step overwrites it with a symlink to the one in this repo (and backs up the
> original to `~/.zshrc.backup`).

## 3. Symlink the configs

```bash
./install.sh --with-karabiner   # omit the flag to skip the Caps Lock remap
```

This symlinks:

- `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh`
- `~/.tmux.conf`
- `~/.config/ghostty/config`
- `~/.config/karabiner/karabiner.json` (only with `--with-karabiner`)

…and creates `~/.zshenv` and `~/.gitconfig` from the templates if they don't
exist yet. It also installs TPM (the tmux plugin manager).

## 4. Add your secrets and git identity

```bash
$EDITOR ~/.zshenv      # paste your own RUNPOD / FAL / REPLICATE keys
$EDITOR ~/.gitconfig   # set your own name + email
```

## 5. Finish up

```bash
# Reload the shell
source ~/.zshrc

# Open tmux and install plugins: press  prefix + I  (capital i)
tmux
```

In Ghostty, the font is **JetBrainsMono Nerd Font** (installed via the Brewfile).
Powerlevel10k will offer to run `p10k configure` on first launch — you can skip
that, since `~/.p10k.zsh` is already provided.

If you enabled Karabiner, launch **Karabiner-Elements** once and grant it the
macOS Input Monitoring / Accessibility permissions it asks for.

## Notes

- tmux prefix is the default **`Ctrl+B`**. With Karabiner, hold Caps Lock as Ctrl.
- All real secrets stay in `~/.zshenv`, which is never committed.
