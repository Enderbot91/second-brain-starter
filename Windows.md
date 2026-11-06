# Windows

Everything in the kit is plain files, so the vault works anywhere Obsidian runs, and Claude Code runs natively on Windows. Two routes.

## Route 1, native PowerShell (simplest)

Use `install.ps1` instead of `install.sh`. It does the same job: copies the skeleton, fills in your name, and links `~\.claude` into the vault with directory junctions, which need no special rights.

```powershell
cd $HOME\second-brain-starter
Set-ExecutionPolicy -Scope Process Bypass
.\install.ps1 -Operator "Your Name"
```

Practice copy with the fictional utility:

```powershell
.\install.ps1 -Operator "Jordan Avery" -Demo -Vault "$HOME\DemoVault"
```

One file link (`CLAUDE.md`) needs Developer Mode (Settings, System, For developers). Without it the installer copies the boot note instead and says so; everything works, you just re-run the installer after editing the boot note.

What you give up on this route: the two hooks. They are POSIX shell scripts, so the boot-time "handoff debt" nag and the Stop-time check do not run. The slash commands and agents work fine. A PowerShell port of the two scripts is on the list; until then run `/status` by hand each morning.

## Route 2, WSL (everything works)

Install WSL (in PowerShell as admin: `wsl --install -d Ubuntu`, then reboot and open Ubuntu from the Start menu), put the vault on the Windows side so Obsidian sees it, and run the Mac/Linux installer inside WSL:

```sh
ln -s /mnt/c/Users/<you>/Vault ~/Vault
cd ~/second-brain-starter && bash install.sh --operator "Your Name" --hooks
```

Run Claude Code inside WSL too. Hooks, commands, agents, and scripts all work as on Linux.

## Sync

Syncthing runs fine on Windows. Keep the vault out of OneDrive and Google Drive desktop sync, which both fight with Obsidian over file locks.
