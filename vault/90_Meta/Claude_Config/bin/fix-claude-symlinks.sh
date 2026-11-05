#!/usr/bin/env bash
# Point this machine's Claude Code config at the vault, so config follows you
# between every machine you work from instead of drifting.
#
# WHAT IT CHANGES (four symlinks under ~/.claude):
#   CLAUDE.md  -> ~/Vault/90_Meta/session-boot.md            global rules + soul
#   agents     -> ~/Vault/90_Meta/Claude_Config/agents       subagent definitions
#   commands   -> ~/Vault/90_Meta/Claude_Config/commands     slash commands
#   bin        -> ~/Vault/90_Meta/Claude_Config/bin          helper scripts
#
# WHAT IT DOES NOT TOUCH: settings.json, ~/.claude.json (your MCP server list
# and OAuth), credentials, history, or projects. Those stay machine-local.
#
# SAFETY
#   - Idempotent. Anything already correct is reported and skipped.
#   - Agents are MERGED, not replaced: any agent this machine has that the vault
#     does not gets copied INTO the vault first, so no local agent is lost and
#     the other machines gain it. Same-named files are never overwritten; a
#     differing local copy is parked as <name>.local-<host>-<stamp>.md for you
#     to reconcile by hand.
#   - Real files or directories in the way are backed up, never deleted.
#   - Nothing is pushed to a remote and nothing is deleted, ever.
#
# Run it on the machine you want fixed. Safe to run twice.
set -uo pipefail

VAULT="$HOME/Vault"
CFG="$VAULT/90_Meta/Claude_Config"
STAMP=$(date +%Y%m%d-%H%M%S)
HOST=$(hostname -s)
changed=0

echo "Machine: $HOST   User: $(whoami)"
echo

if [ ! -d "$VAULT/90_Meta" ]; then
  echo "STOP: no vault at $VAULT. Is Syncthing running on this machine?"
  exit 1
fi
mkdir -p "$HOME/.claude"

# ---------------------------------------------------------------- merge agents
# Do this BEFORE the symlink, while the local directory is still real.
merge_agents() {
  local live="$HOME/.claude/agents"
  [ -d "$live" ] || return 0
  [ -L "$live" ] && return 0          # already a symlink, nothing local to save
  [ -d "$CFG/agents" ] || return 0    # vault side not synced yet

  local copied=0 parked=0
  shopt -s nullglob
  for f in "$live"/*.md; do
    local base; base=$(basename "$f")
    case "$base" in *.bak*) continue ;; esac   # skip old backups
    if [ ! -e "$CFG/agents/$base" ]; then
      cp "$f" "$CFG/agents/$base"
      echo "  MERGE  $base was only on this machine, copied into the vault"
      copied=$((copied+1))
    elif ! cmp -s "$f" "$CFG/agents/$base"; then
      cp "$f" "$CFG/agents/${base%.md}.local-$HOST-$STAMP.md"
      echo "  PARK   $base differs from the vault copy, local version saved as ${base%.md}.local-$HOST-$STAMP.md"
      parked=$((parked+1))
    fi
  done
  shopt -u nullglob
  [ $((copied+parked)) -gt 0 ] && echo
  [ "$parked" -gt 0 ] && echo "  NOTE: $parked file(s) parked for you to reconcile. The vault copy is what runs." && echo
  return 0
}
merge_agents

# ------------------------------------------------------------------- link them
link_it() {
  local target="$1" link="$2" label="$3"

  if [ ! -e "$target" ]; then
    echo "  SKIP   $label: target missing ($target). Let Syncthing finish, then re-run."
    return
  fi
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
    echo "  OK     $label already linked"
    return
  fi
  if [ -L "$link" ]; then
    echo "  FIX    $label pointed at $(readlink "$link")"
    rm "$link"
  elif [ -e "$link" ]; then
    mv "$link" "$link.pre-symlink.$STAMP"
    echo "  FIX    $label was a real file/dir, backed up to $(basename "$link").pre-symlink.$STAMP"
  else
    echo "  NEW    $label did not exist"
  fi
  ln -s "$target" "$link"
  changed=$((changed+1))
}

link_it "$VAULT/90_Meta/session-boot.md" "$HOME/.claude/CLAUDE.md" "CLAUDE.md"
link_it "$CFG/agents"                    "$HOME/.claude/agents"    "agents   "
link_it "$CFG/commands"                  "$HOME/.claude/commands"  "commands "
link_it "$CFG/bin"                       "$HOME/.claude/bin"       "bin      "

echo
echo "Result:"
for p in CLAUDE.md agents commands bin; do
  if [ -L "$HOME/.claude/$p" ]; then
    printf "  %-10s -> %s\n" "$p" "$(readlink "$HOME/.claude/$p")"
  else
    printf "  %-10s NOT a symlink (see messages above)\n" "$p"
  fi
done
echo
echo "Agents visible: $(ls -1 "$HOME/.claude/agents/"*.md 2>/dev/null | grep -vc '\.local-' || echo 0)"
echo "Slash commands: $(ls -1 "$HOME/.claude/commands/"*.md 2>/dev/null | wc -l | tr -d ' ')"
echo "Changes made:   $changed"
if [ "$changed" -gt 0 ]; then
  echo
  echo "Restart Claude Code on this machine so it picks the new config up."
fi
exit 0
