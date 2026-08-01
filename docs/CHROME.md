# Google Chrome

Chrome is the primary browser (`cask "google-chrome"` in the Brewfile).

**Nothing about Chrome is provisioned from this repo.** The profile directory
holds cookies, saved sessions and tokens, so it is neither committed nor copied.
Chrome syncs everything below by itself once each profile signs in — this page
just records what "restored" should look like.

## Profiles — [HUMAN]

Three profiles on the source machine. Sign in to each, in order, so the
directory names line up:

| Directory | Display name | Account |
|-----------|--------------|---------|
| `Default` | Tim | `timpietrusky@gmail.com` |
| `Profile 1` | techeurope.io | `tim@techeurope.io` |
| `Profile 2` | tim@getdaso.com | `tim@getdaso.com` |

## Extensions

Restored automatically by Chrome Sync after sign-in. If sync is off, install by
ID — `https://chrome.google.com/webstore/detail/<id>`:

| Extension | ID |
|-----------|-----|
| Bitwarden | `nngceckbapebfimnlniiiahkandclblb` |
| AdBlock | `cfhdojbkjhnklbpkdaibdccddilifddb` |
| Wappalyzer | `gppongmhjkpfnbhagpmjfkannfbllamg` |
| ColorZilla | `bhlhnicpbhignbdhedgjhgdocnmhomnp` |
| Markdown Preview Plus | `febilkbfcbhebfnokafefeacimjdckgl` |
| Scrum for Trello | `jdbcdblgjdpmfninkoogcfpnkjmndgje` |
| Google Analytics Opt-out | `fllaojicojecljbmefodhfapmkghcbnh` |
| Google Docs Offline | `ghbmnnjooekpmoecnnnilnnbdlolhkhi` |

`nmmhkkegccagdldgiimedpiccmgmieda` (Chrome Web Store Payments) is built in —
ignore it.

## Related

Bitwarden is also on the CLI (`@bitwarden/cli`, see `packages/npm-global.txt`);
the desktop vault is KeePassXC. Both need their own login — see
`docs/NOT-IN-THIS-REPO.md`.
