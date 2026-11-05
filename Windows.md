# Windows

This kit is Mac and Linux first. Everything in it is plain files, so the vault itself works anywhere Obsidian runs. Three things need translating on Windows.

## Symlinks

`install.sh` and `fix-claude-symlinks.sh` use `ln -s`. On Windows you have two options.

**WSL (recommended).** Run Claude Code and the scripts inside WSL. Put the vault on the Windows side (`/mnt/c/Users/<you>/Vault`) so Obsidian on Windows and the CLI in WSL see the same files, and symlink `~/Vault` in WSL to it:

```sh
ln -s /mnt/c/Users/<you>/Vault ~/Vault
bash install.sh --operator "Your Name"
```

**Native PowerShell.** Make directory junctions and a file symlink by hand. Developer Mode must be on for `New-Item -ItemType SymbolicLink` to work without admin.

```powershell
$V = "$env:USERPROFILE\Vault"
New-Item -ItemType Junction -Path "$env:USERPROFILE\.claude\agents"   -Target "$V\90_Meta\Claude_Config\agents"
New-Item -ItemType Junction -Path "$env:USERPROFILE\.claude\commands" -Target "$V\90_Meta\Claude_Config\commands"
New-Item -ItemType Junction -Path "$env:USERPROFILE\.claude\bin"      -Target "$V\90_Meta\Claude_Config\bin"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\CLAUDE.md" -Target "$V\90_Meta\session-boot.md"
```

## The shell scripts

`handoff-debt.sh`, `check-cards.sh`, and `session-close.sh` are POSIX shell and use `stat -f %m` (BSD). Under WSL change that to `stat -c %Y`. Under native PowerShell they do not run; the hooks in `settings.json` can point at a `.ps1` port instead. Nobody has written that port yet.

## No `say`

The video build in the companion repo uses the macOS `say` voice. On Windows use `edge-tts` or any TTS that writes a WAV. The vault and the agents do not depend on it.

## Sync

Syncthing runs fine on Windows. Keep the vault out of OneDrive and Google Drive desktop sync, which both fight with Obsidian over file locks.
