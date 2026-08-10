# Brewfile — install everything with: brew bundle --file=Brewfile
#
# Generated from a live machine on 2026-08-01 (macOS 26.3, Apple Silicon).
# Keep in sync with: brew leaves && brew list --cask && brew tap

# ---------------------------------------------------------------------------
# Taps
# ---------------------------------------------------------------------------
tap "hashicorp/tap"
tap "infisical/get-cli"
tap "runpod/runpodctl"
tap "steipete/tap"

# ---------------------------------------------------------------------------
# GUI apps
# ---------------------------------------------------------------------------
cask "ghostty"                   # terminal (primary)
cask "karabiner-elements"        # keyboard remapping (Caps Lock -> Esc/Ctrl)
cask "cursor"                    # editor
cask "t3-code@nightly"           # T3 Code (agent IDE) — nightly channel
cask "codex"                     # OpenAI Codex desktop
cask "docker-desktop"
cask "google-chrome"             # primary browser (3 profiles — see docs/CHROME.md)
cask "keepassxc"                 # password manager (vault file is NOT in this repo)
cask "slack"
cask "discord"
cask "signal"
cask "telegram"
cask "eqmac"                     # system-wide audio EQ
cask "granola"                   # meeting notes (login item)
cask "wispr-flow"                # voice dictation (login item)

# Android tooling (React Native / Expo work)
cask "android-commandlinetools"
cask "android-platform-tools"

# ---------------------------------------------------------------------------
# Fonts
# ---------------------------------------------------------------------------
cask "font-jetbrains-mono-nerd-font"   # Ghostty + powerlevel10k prompt
cask "font-symbols-only-nerd-font"     # icon fallback
cask "font-inter"                      # UI / design work
# Not on Homebrew — see docs/MANUAL-APPS.md: Badd Mono, Kode Mono

# ---------------------------------------------------------------------------
# Shell / terminal tooling
# ---------------------------------------------------------------------------
brew "tmux"
brew "fnm"        # node version manager (used in .zshrc)
brew "fzf"        # fuzzy finder (tmux session picker)
brew "fd"         # used by the tmux "new session from project" popup
brew "eza"        # modern ls
brew "bat"        # modern cat
brew "ripgrep"    # rg — used constantly by coding agents
brew "lazygit"    # git TUI (tmux prefix + g)

# ---------------------------------------------------------------------------
# Dev essentials
# ---------------------------------------------------------------------------
brew "git"
brew "gh"
brew "go"
brew "python@3.11"
brew "pipx"
brew "cmake"
brew "httpie"
brew "openjdk@17"    # JAVA_HOME in .zshrc — required by the Android toolchain
brew "sshpass"

# ---------------------------------------------------------------------------
# Infra / cloud
# ---------------------------------------------------------------------------
brew "hashicorp/tap/terraform"
brew "infisical/get-cli/infisical"   # secret manager — auth per machine, see docs/NOT-IN-THIS-REPO.md
brew "hcloud"                        # Hetzner Cloud CLI
brew "runpod/runpodctl/runpodctl"
brew "dolt"                          # versioned SQL db — backing store for beads

# ---------------------------------------------------------------------------
# Agent tooling
# ---------------------------------------------------------------------------
brew "beads"      # `bd` — dependency-aware issue tracker used by agents
brew "gogcli"     # Google/Gmail CLI

# ---------------------------------------------------------------------------
# Media / docs tooling
# ---------------------------------------------------------------------------
brew "ffmpeg"
brew "imagemagick"
brew "pandoc"
brew "poppler"    # pdftotext etc.
brew "potrace"    # bitmap -> vector
brew "zbar"       # barcode/QR decoding
brew "hugo"       # static site generator
brew "dfu-util"   # firmware flashing (keyboards)
