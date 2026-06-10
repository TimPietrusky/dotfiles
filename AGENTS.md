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

`install.sh` is non-interactive: it symlinks configs, backs up any existing real
files to `*.backup`, seeds `~/.zshenv` and `~/.gitconfig` from templates if
absent, and clones TPM.

```bash
"$DOTFILES/install.sh" --with-karabiner   # drop the flag to skip the Caps Lock remap
```

**Verify:**

```bash
readlink ~/.zshrc; readlink ~/.tmux.conf; readlink ~/.config/ghostty/config
test -d ~/.tmux/plugins/tpm && echo "tpm OK"
```

Each `readlink` should point inside `$DOTFILES`.

## Step 6 — Install tmux plugins (non-interactive)

The README tells humans to press `prefix + I`. An agent must call TPM's installer
script directly instead:

```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

**Verify:** `ls ~/.tmux/plugins/` lists `tmux-resurrect`, `tmux-continuum`,
`tmux-yank` (plus `tpm`).

## Step 7 — Secrets and git identity — **[HUMAN]**

`install.sh` created `~/.zshenv` (stub) and `~/.gitconfig` (template). The agent
must NOT fill these. Hand off:

- `~/.zshenv` — operator pastes real `RUNPOD_API_KEY`, `FAL_API_KEY`,
  `REPLICATE_API_TOKEN`.
- `~/.gitconfig` — operator sets their own `name` and `email`.

**Verify (presence only, never print values):**

```bash
grep -q 'RUNPOD_API_KEY=.\+' ~/.zshenv && echo "keys set" || echo "keys still empty — needs human"
git config --global user.email >/dev/null && echo "git identity set" || echo "git identity missing — needs human"
```

## Step 8 — Claude Code (separate install)

Not part of this repo's symlinks, but part of the workflow. Install per
https://claude.com/claude-code . No settings are provisioned from this repo by design.

**Verify:** `command -v claude` succeeds (if the operator wants it installed).

## Step 9 — Final verification

```bash
"$DOTFILES/check.sh"
zsh -ic 'echo "shell loads"' 2>/dev/null
brew list --cask ghostty >/dev/null 2>&1 && echo "ghostty installed"
echo "Done. Remaining items require a human (below)."
```

## [HUMAN] — steps an agent cannot complete

These need physical GUI / OS-permission interaction and must be left to a person:

1. **Make Ghostty your terminal** — open `/Applications/Ghostty.app` once
   (Gatekeeper may require right-click → Open the first time). Future work
   happens inside Ghostty.
2. **Karabiner-Elements permissions** — open the app; macOS will prompt for
   *Input Monitoring* and *Accessibility* under System Settings → Privacy &
   Security. The Caps Lock remap does nothing until these are granted.
3. **API keys & git identity** — Step 7 above.
4. **Powerlevel10k** — `~/.p10k.zsh` is already provided, so dismiss the
   `p10k configure` wizard if it appears on first shell launch.

## Failure handling

- A `brew` cask failing on Gatekeeper/quarantine → report it; do not bypass
  security with `sudo spctl --master-disable`.
- Network/clone failures → retry once, then report the failing URL.
- If a verify gate fails, stop and report which step + the command output rather
  than proceeding.
