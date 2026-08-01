# dotfiles

My macOS setup for terminal-based / AI-agent workflows. Point an agent at
[AGENTS.md](AGENTS.md) on a blank Mac and it rebuilds the machine: apps, shell,
terminal, editors, agent tooling, language toolchains, system preferences.

What it does **not** do is fabricate secrets. Everything that has to come from a
human or a password manager is inventoried in
**[docs/NOT-IN-THIS-REPO.md](docs/NOT-IN-THIS-REPO.md)** — read that page, it is
the difference between "installed" and "actually working".

## Quick start

```bash
git clone https://github.com/TimPietrusky/dotfiles.git ~/dotfiles
cd ~/dotfiles

brew bundle --file=Brewfile      # 1. apps, CLIs, fonts
                                 # 2. Oh My Zsh + p10k + plugins — see SETUP.md
./install.sh --with-karabiner    # 3. symlink every config
./packages/install.sh            # 4. node, npm globals, uv, pipx, agent CLIs
./macos/defaults.sh              # 5. macOS system preferences (optional)
./check.sh                       # 6. verify
```

Then open tmux and press **`prefix + I`** (capital i) to install the tmux plugins.

Full step-by-step for humans: **[SETUP.md](SETUP.md)**.
For an AI agent on a blank machine: **[AGENTS.md](AGENTS.md)**.

## What's included

### Shell & terminal
| Path | Purpose |
|------|---------|
| `zsh/.zshrc` | Oh My Zsh, Powerlevel10k, `fnm`, autosuggestions + syntax-highlighting, Android SDK / `JAVA_HOME`, opencode on `PATH` |
| `zsh/.zprofile` | Homebrew shell env |
| `zsh/.zshenv.example` | Template for API keys — copy to `~/.zshenv`, fill in yourself |
| `zsh/.p10k.zsh` | Powerlevel10k prompt |
| `tmux/.tmux.conf` | mouse, vi keys, fzf session picker, lazygit/htop popups, TPM plugins |
| `config/ghostty/config` | Ghostty (Snazzy, JetBrainsMono Nerd Font, 14pt) |
| `config/karabiner/karabiner.json` | Caps Lock → Esc (tap) / Ctrl (hold) — optional |

### Agent tooling
| Path | Purpose |
|------|---------|
| `claude/` | Claude Code: `settings.json` (opus[1m], effort high, fullscreen, style-reminder hook, daso plugin marketplace), `keybindings.json`, `CLAUDE.md`, `style-reminder.txt` — [details](claude/README.md) |
| `codex/config.toml` | Codex CLI: model, reasoning effort, service tier |
| `config/opencode/opencode.json` | opencode: Moonshot/Kimi provider |
| `t3/` | T3 Code: full keymap, provider instances, UI prefs — [details](t3/README.md) |
| `config/gh/config.yml` | `gh` CLI: `co` alias, prompt behaviour |
| `packages/skills.txt` | Which agent skills were installed (not vendored) |

### Everything else
| Path | Purpose |
|------|---------|
| `Brewfile` | Every app, CLI, and font — taps included |
| `packages/` | node version + global npm packages + pipx apps + `install.sh` |
| `macos/defaults.sh` | macOS system preferences, with the [HUMAN] GUI steps listed at the end |
| `git/.gitconfig.example` | Template — set your own name + email |
| `install.sh` | Symlinks everything (backs up existing real files) |
| `check.sh` | Verifies symlinks, commands, auth presence, fonts |
| `docs/NOT-IN-THIS-REPO.md` | **Secrets, local state, and manual steps — the gap list** |
| `docs/MANUAL-APPS.md` | Apps and fonts with no Homebrew cask |
| `docs/CHROME.md` | Chrome profiles + extension IDs |

## Secrets

Real API keys live **only** in your local `~/.zshenv`, which is never committed.
This repo ships `zsh/.zshenv.example` with empty placeholders. Better still,
pull secrets at use time from Infisical or Bitwarden — both are in the Brewfile.

Full inventory of what's excluded and how to restore each item:
**[docs/NOT-IN-THIS-REPO.md](docs/NOT-IN-THIS-REPO.md)**.

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

## T3 Code keys

| Action | Keys |
|--------|------|
| Toggle terminal | `mod+j` |
| Split terminal | `mod+d` (in terminal) |
| Toggle diff | `mod+d` (outside terminal) |
| New chat | `mod+n` / `mod+shift+o` |
| Command palette | `mod+k` |
| Model picker | `mod+shift+m` |
| Jump to thread 1–9 | `mod+1` … `mod+9` |
| Toggle sidebar / right panel | `mod+b` / `mod+alt+b` |
| Toggle preview | `mod+shift+j` |
