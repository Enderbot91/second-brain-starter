<#
.SYNOPSIS
  Windows installer for second-brain-starter. Same job as install.sh:
  copy the vault skeleton, fill in your name, link ~/.claude into the vault.

.USAGE
  Open PowerShell (not as admin), then:
    cd $HOME\second-brain-starter
    Set-ExecutionPolicy -Scope Process Bypass
    .\install.ps1 -Operator "Your Name"
    .\install.ps1 -Operator "Jordan Avery" -Demo -Vault "$HOME\DemoVault"

  -Vault PATH   where the vault goes (default $HOME\Vault)
  -Operator     your name, as it should read in the soul file (prompted if missing)
  -Demo         overlay the fictional demo vault (Jordan Avery, Redbud Water)
  -Force        allow installing into an existing non-empty vault (files are overlaid, never deleted)
  -Hooks        also write the two hooks into $HOME\.claude\settings.json (see note at the end)

  Links: directories use junctions (no special rights needed). The one file link
  (CLAUDE.md) needs Developer Mode or admin; if that fails the installer copies
  the boot note instead and tells you, which works but will not auto-update.
#>
param(
  [string]$Vault = "$HOME\Vault",
  [string]$Operator = "",
  [switch]$Demo,
  [switch]$Force,
  [switch]$Hooks
)
$ErrorActionPreference = "Stop"
$Kit = $PSScriptRoot
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$Today = Get-Date -Format "yyyy-MM-dd"

if (-not $Operator) { $Operator = Read-Host "Your name as it should appear in the soul file" }
if (-not $Operator) { Write-Host "operator name is required"; exit 1 }

# ---- guard the target
if ((Test-Path $Vault) -and (Get-ChildItem -Force $Vault | Select-Object -First 1) -and -not $Force) {
  Write-Host "STOP: $Vault exists and is not empty. Re-run with -Force to overlay the kit onto it (nothing gets deleted)."
  exit 1
}
New-Item -ItemType Directory -Force -Path $Vault | Out-Null

# ---- copy the skeleton, then the demo overlay
Write-Host "Installing skeleton into $Vault"
Copy-Item -Path (Join-Path $Kit "vault\*") -Destination $Vault -Recurse -Force
if ($Demo) {
  Write-Host "Overlaying demo vault (fictional operator, fictional utility)"
  Copy-Item -Path (Join-Path $Kit "demo\*") -Destination $Vault -Recurse -Force
  if (Test-Path "$Vault\90_Meta\Agents\utility-ops") {
    Remove-Item -Recurse -Force "$Vault\90_Meta\Agents\domain-specialist" -ErrorAction SilentlyContinue
    Remove-Item -Force "$Vault\90_Meta\Claude_Config\agents\domain-specialist.md" -ErrorAction SilentlyContinue
  }
}

# ---- templates become live files only if nothing is there yet
if (-not (Test-Path "$Vault\90_Meta\soul.md")) { Move-Item "$Vault\90_Meta\soul.template.md" "$Vault\90_Meta\soul.md" }
if (-not (Test-Path "$Vault\90_Meta\Glossary_and_IDs.md")) { Move-Item "$Vault\90_Meta\Glossary_and_IDs.template.md" "$Vault\90_Meta\Glossary_and_IDs.md" }
Remove-Item -Force "$Vault\90_Meta\soul.template.md", "$Vault\90_Meta\Glossary_and_IDs.template.md" -ErrorAction SilentlyContinue

# ---- substitute {{operator}} {{today}} {{vault}}
Get-ChildItem -Path $Vault -Recurse -Filter *.md -File | ForEach-Object {
  $t = Get-Content -Raw -Encoding UTF8 $_.FullName
  if ($t -match "\{\{(operator|today|vault)\}\}") {
    $t = $t -replace "\{\{operator\}\}", $Operator -replace "\{\{today\}\}", $Today -replace "\{\{vault\}\}", ($Vault -replace "\\", "/")
    [IO.File]::WriteAllText($_.FullName, $t, (New-Object Text.UTF8Encoding $false))
  }
}

# ---- links into $HOME\.claude
$Claude = "$HOME\.claude"
New-Item -ItemType Directory -Force -Path $Claude | Out-Null

function Link-Dir($Target, $Link, $Label) {
  if (Test-Path $Link) {
    $item = Get-Item $Link -Force
    if ($item.LinkType -and ($item.Target -contains $Target)) { Write-Host "  OK     $Label already linked"; return }
    Move-Item $Link "$Link.pre-link.$Stamp"; Write-Host "  FIX    $Label existed, backed up to $(Split-Path -Leaf $Link).pre-link.$Stamp"
  } else { Write-Host "  NEW    $Label" }
  New-Item -ItemType Junction -Path $Link -Target $Target | Out-Null
}

Write-Host "Linking $Claude to the vault"
Link-Dir "$Vault\90_Meta\Claude_Config\agents"   "$Claude\agents"   "agents"
Link-Dir "$Vault\90_Meta\Claude_Config\commands" "$Claude\commands" "commands"
Link-Dir "$Vault\90_Meta\Claude_Config\bin"      "$Claude\bin"      "bin"

$boot = "$Vault\90_Meta\session-boot.md"
$bootLink = "$Claude\CLAUDE.md"
if (Test-Path $bootLink) { Move-Item $bootLink "$bootLink.pre-link.$Stamp" -Force }
try {
  New-Item -ItemType SymbolicLink -Path $bootLink -Target $boot | Out-Null
  Write-Host "  NEW    CLAUDE.md (symlink)"
} catch {
  Copy-Item $boot $bootLink
  Write-Host "  NOTE   Could not create a file symlink (turn on Developer Mode in Windows Settings to allow it)."
  Write-Host "         Copied the boot note instead. Re-run this installer after editing 90_Meta\session-boot.md."
}

# ---- hooks
if ($Hooks) {
  Write-Host ""
  Write-Host "NOTE: the two hooks (handoff-debt.sh, session-close.sh) are POSIX shell scripts."
  Write-Host "On Windows they run only inside WSL or Git Bash. Nothing was written to settings.json."
  Write-Host "If you use WSL, run install.sh --hooks there instead. See Windows.md."
}

Write-Host ""
Write-Host "Done. Next:"
Write-Host "  1. Open $Vault in Obsidian and enable the Dataview plugin (JavaScript queries on)."
Write-Host "  2. Open 90_Meta\soul-interview.prompt.md and write your soul file."
Write-Host "  3. Start Claude Code in the vault folder and run /status."
