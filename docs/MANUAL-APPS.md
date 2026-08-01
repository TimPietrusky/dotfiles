# Apps and fonts installed outside Homebrew

Everything in `Brewfile` installs unattended. These do not — either there's no
cask, the licence is per-account, or the download is huge. An agent should
install what it can and hand the rest to a human.

## Has a cask, but was installed manually on the source machine

These are now **in the Brewfile**, so a fresh machine gets them automatically.
Listed here only so the drift is documented:

`google-chrome`, `keepassxc`, `granola`, `wispr-flow`

## No cask / manual only — [HUMAN]

| App | Notes |
|-----|-------|
| **Affinity** (Photo/Designer/Publisher) | Mac App Store or Affinity account. Licence tied to the account. |
| **DaVinci Resolve** | Blackmagic account download. Pulls in *Blackmagic RAW* and *Blackmagic Proxy Generator Lite* alongside it — don't install those separately. |
| **Steam** | steampowered.com. Login item on the source machine. Also owns `~/Library/LaunchAgents/com.valvesoftware.steamclean.plist`. |
| **Disco Elysium** | Installed via Steam into `~/Applications`. |
| **Claude Code URL Handler** | Auto-created in `~/Applications` by Claude Code on first run — do not install manually. |

## Fonts not on Homebrew — [HUMAN]

Copy these from `~/Library/Fonts` on the old Mac, or re-download:

- `Badd-Mono-Regular.otf`
- `KodeMono-VariableFont_wght.ttf` — [Google Fonts: Kode Mono](https://fonts.google.com/specimen/Kode+Mono)
- `Inter-VariableFont_opsz,wght.ttf` — also available as `cask "font-inter"` (now in the Brewfile), so this one is covered

The two fonts the terminal actually depends on (**JetBrainsMono Nerd Font**,
**Symbols Nerd Font Mono**) come from the Brewfile — Ghostty renders wrong
without them.

## Launch agents on the source machine

Vendor-installed, not worth migrating; they reappear with the app:

- `com.google.GoogleUpdater.wake.plist`, `com.google.keystone.agent.plist`,
  `com.google.keystone.xpcservice.plist` — Chrome auto-updater
- `com.valvesoftware.steamclean.plist` — Steam
