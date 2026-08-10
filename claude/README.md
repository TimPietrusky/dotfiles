# Claude Code

`install.sh` symlinks these into `~/.claude/`:

| File | Purpose |
|------|---------|
| `settings.json` | Model (`opus[1m]`), effort `high`, fullscreen TUI, dark theme, empty commit/PR attribution, the `UserPromptSubmit` style-reminder hook, and the `daso-agent-tooling` plugin marketplace |
| `keybindings.json` | `shift+enter` inserts a newline in chat |
| `CLAUDE.md` | Global answer-style instructions |
| `style-reminder.txt` | Read by the `UserPromptSubmit` hook on every prompt |

## Install the CLI

```bash
curl -fsSL https://claude.com/install.sh | bash    # lands in ~/.local/bin/claude
```

**Verify:** `command -v claude`

## Login — [HUMAN]

`claude` uses an OAuth login stored in `~/.claude.json`. That file is **not** in
this repo (it also contains project history and machine IDs). Run `claude` once
and complete the browser login.

## Plugins / marketplaces

`settings.json` declares the marketplace, but the plugin is fetched on first run
and needs GitHub access to the private `DasoComputer/agent-tooling` repo:

```bash
gh auth status                     # must be logged in first
claude                             # marketplace syncs on launch
```

Enabled plugin: `daso-agent-ops@daso-agent-tooling` (skills: `cyber-audit`,
`effective-agent-skills`, `inbox-zero`, `setup-help`).

## Skills

Global skills live in `~/.claude/skills/` and `~/.agents/skills/`. They are
**not** vendored here — most are installable and would rot as copies. See
`packages/skills.txt` for the list that was installed on the source machine.
