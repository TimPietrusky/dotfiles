# Agent bootstrap guide

Instructions for an AI agent provisioning this setup on a **blank macOS machine**.
Written for an agent, not a human. Follow steps in order. Each step has a
**verify** gate — do not advance until it passes. Steps marked **[HUMAN]** require
a person (GUI clicks, OS permission dialogs, secrets); stop and hand off there.

## Operating rules

- Run every command non-interactively. Never use a flag that opens an editor,
  pager, or `read` prompt. Prefer the documented `NONINTERACTIVE` / `--unattended`
  / `-y` forms below.
- All steps are idempotent. If a verify already passes, skip the step.
- **Never fabricate secrets.** Leave `~/.zshenv` as the stub and hand off to a
  human to fill in real API keys. Do not invent or guess keys.
- **Read [docs/NOT-IN-THIS-REPO.md](docs/NOT-IN-THIS-REPO.md) before you start.**
  It is the complete inventory of what this repo deliberately does *not* carry —
  credentials, auth sessions, local state, GUI-only settings — and how each one
  is restored. Without it you will finish all the steps below and still hand
  over a machine that cannot push to GitHub or run a single agent.
- Do not set git `user.name` / `user.email` to anyone but the actual operator.
  If unknown, leave the `~/.gitconfig` template and hand off.
- After each step, run its verify command and check the exit status before moving on.
- Assume Apple Silicon (`/opt/homebrew`). On Intel, Homebrew lives at
  `/usr/local`; adjust the `brew shellenv` path accordingly.

## Step 0 — Detect environment

```bash
uname -m              # arm64 (Apple Silicon) or x86_64 (Intel)
sw_vers               # macOS version
xcode-select -p 2>/dev/null || echo "no CLT"
```

If Command Line Tools are missing, install them (this opens a GUI dialog):

```bash
xcode-select --install
```

**[HUMAN]** If a CLT install dialog appears, the operator must click through it.
**Verify:** `xcode-select -p` prints a path.

## Step 1 — Homebrew

```bash
if ! command -v brew >/dev/null 2>&1; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Load brew into THIS shell (and persist for future shells)
eval "$(/opt/homebrew/bin/brew shellenv)"
grep -q 'brew shellenv' ~/.zprofile 2>/dev/null || \
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
```

**Verify:** `brew --version` succeeds.

## Step 2 — Clone this repo

```bash
DOTFILES="$HOME/dotfiles"
[ -d "$DOTFILES/.git" ] || git clone https://github.com/TimPietrusky/dotfiles.git "$DOTFILES"
cd "$DOTFILES"
```

**Verify:** `test -f "$DOTFILES/Brewfile"`.

## Step 3 — Install apps + CLI tools (includes Ghostty)

`Brewfile` declares everything, including `cask "ghostty"`. One command installs
it all and is safe to re-run:

```bash
brew bundle --file="$DOTFILES/Brewfile"
```

If you must install Ghostty on its own:

```bash
brew install --cask ghostty
```

**Verify Ghostty specifically:**

```bash
brew list --cask ghostty >/dev/null 2>&1 && test -d "/Applications/Ghostty.app" \
  && echo "ghostty OK" || echo "ghostty MISSING"
```

**Verify the rest:** `brew bundle check --file="$DOTFILES/Brewfile"` prints
"dependencies are satisfied".

> Note: `brew bundle` also installs the Nerd Fonts the prompt needs. A cask
> install only places the app/font; it does not configure it. Configuration
> happens in Step 6 (symlinks) and the **[HUMAN]** steps at the end.

## Step 4 — Oh My Zsh + theme + plugins

The Oh My Zsh installer normally switches into a new zsh and aborts the script.
Suppress that with `RUNZSH=no CHSH=no --unattended`:

```bash
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone() { [ -d "$2" ] || git clone --depth=1 "$1" "$2"; }
clone https://github.com/romkatv/powerlevel10k        "$ZSH_CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
```

**Verify:** all three directories exist under `$ZSH_CUSTOM`, and
`test -d "$HOME/.oh-my-zsh"`.

## Step 5 — Symlink configs + install TPM

`install.sh` is non-interactive: it symlinks configs (shell, tmux, Ghostty, gh,
Claude Code, Codex, opencode, T3 Code, Cursor, KeePassXC, Docker, optionally
Karabiner), backs up any existing real files to `*.backup`, seeds `~/.zshenv` and
`~/.gitconfig` from templates if absent, and clones TPM.

```bash
"$DOTFILES/install.sh" --with-karabiner   # drop the flag to skip the Caps Lock remap
```

**Verify:**

```bash
readlink ~/.zshrc; readlink ~/.tmux.conf; readlink ~/.config/ghostty/config
readlink ~/.claude/settings.json; readlink ~/.codex/config.toml
test -d ~/.tmux/plugins/tpm && echo "tpm OK"
```

Each `readlink` should point inside `$DOTFILES`.

> The app config directories (`~/.claude`, `~/.codex`, `~/.t3/userdata`,
> `~/.config/opencode`) are created by `install.sh` if the app hasn't run yet.
> Symlinking before first launch is fine — every one of these apps reads the
> file rather than replacing it.

## Step 6 — Install tmux plugins (non-interactive)

The README tells humans to press `prefix + I`. An agent must call TPM's installer
script directly instead:

```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

**Verify:** `ls ~/.tmux/plugins/` lists `tmux-resurrect`, `tmux-continuum`,
`tmux-yank` (plus `tpm`).

## Step 7 — Language toolchains and global packages

`packages/install.sh` installs node via `fnm` (pinned in `packages/node-version`),
the global npm packages, `uv`, the pipx apps, and the agent CLIs that Homebrew
doesn't ship (`claude`, `opencode`).

```bash
"$DOTFILES/packages/install.sh"
```

**Verify:**

```bash
node -v                                    # matches packages/node-version
npm ls -g --depth=0                         # matches packages/npm-global.txt
command -v uv claude opencode
```

## Step 8 — macOS system preferences (optional)

```bash
"$DOTFILES/macos/defaults.sh"
```

This is an opinionated set (fast key repeat, Finder/Dock tweaks, screenshots to
`~/Desktop/screenshots`, no text auto-substitution), **not** a dump of the source
machine — that machine was running stock Apple defaults. Skipping it is fine.

**Verify:** `defaults read NSGlobalDomain KeyRepeat` prints `2`.

## Step 9 — Secrets, auth, and git identity — **[HUMAN]**

The agent must NOT fill any of these in. Full table with the restore command for
each: **[docs/NOT-IN-THIS-REPO.md](docs/NOT-IN-THIS-REPO.md)**. In short:

- `~/.zshenv` — operator pastes real `RUNPOD_API_KEY`, `FAL_API_KEY`,
  `REPLICATE_API_TOKEN`, `BW_SESSION`.
- `~/.gitconfig` — operator sets their own `name` and `email`.
- `~/.ssh/id_ed25519` — operator brings the key over, or generates a new one and
  registers it with GitHub. Do not generate one silently.
- Interactive logins the operator runs themselves: `gh auth login`,
  `infisical login`, `claude`, `codex`, `runpodctl config --apiKey ...`,
  plus every GUI app.

**Verify (presence only, never print values):**

```bash
grep -q 'RUNPOD_API_KEY=.\+' ~/.zshenv && echo "keys set" || echo "keys still empty — needs human"
git config --global user.email >/dev/null && echo "git identity set" || echo "git identity missing — needs human"
gh auth status >/dev/null 2>&1 && echo "gh ok" || echo "gh not logged in — needs human"
test -f ~/.ssh/id_ed25519 && echo "ssh key present" || echo "no ssh key — needs human"
```

## Step 10 — Claude Code plugins

`claude/settings.json` enables `daso-agent-ops@daso-agent-tooling`, which is
fetched from the private `DasoComputer/agent-tooling` repo. It only resolves
**after** `gh auth login` (Step 9) — so run this last.

```bash
claude   # marketplace syncs on launch
```

**Verify:** `ls ~/.claude/plugins/marketplaces` lists `daso-agent-tooling`.

## Step 11 — Final verification

```bash
"$DOTFILES/check.sh"
zsh -ic 'echo "shell loads"' 2>/dev/null
brew bundle check --file="$DOTFILES/Brewfile"
echo "Done. Remaining items require a human (below)."
```

`check.sh` distinguishes `miss` (a real failure — fix it) from `note` (waiting on
a human). Report both categories separately.

## [HUMAN] — steps an agent cannot complete

These need physical GUI / OS-permission interaction and must be left to a person.
`macos/defaults.sh` prints this list too.

1. **Make Ghostty your terminal** — open `/Applications/Ghostty.app` once
   (Gatekeeper may require right-click → Open the first time). Future work
   happens inside Ghostty.
2. **macOS Privacy & Security grants** — System Settings → Privacy & Security:
   *Input Monitoring* + *Accessibility* for **Karabiner-Elements** (the Caps Lock
   remap does nothing until both are granted), *Accessibility* for **Wispr Flow**,
   *Screen Recording* for **Granola**.
3. **Secrets, auth, git identity, SSH key** — Step 9 above.
4. **Login items** — Granola, Wispr Flow, Steam.
5. **Apps with no cask** — Affinity, DaVinci Resolve, Steam. See
   [docs/MANUAL-APPS.md](docs/MANUAL-APPS.md).
6. **Fonts with no cask** — Badd Mono, Kode Mono. Same doc.
7. **Chrome profiles** — sign in to all three, in order, so directory names match.
   See [docs/CHROME.md](docs/CHROME.md).
8. **Apple ID / iCloud, FileVault, Touch ID** (including Touch ID for `sudo`).
9. **Powerlevel10k** — `~/.p10k.zsh` is already provided, so dismiss the
   `p10k configure` wizard if it appears on first shell launch.

## Failure handling

- A `brew` cask failing on Gatekeeper/quarantine → report it; do not bypass
  security with `sudo spctl --master-disable`.
- Network/clone failures → retry once, then report the failing URL.
- If a verify gate fails, stop and report which step + the command output rather
  than proceeding.
