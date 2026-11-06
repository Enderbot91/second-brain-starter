#!/usr/bin/env bash
# Install the second-brain starter kit.
#
#   bash install.sh --operator "Your Name"                 # vault at ~/Vault
#   bash install.sh --operator "Your Name" --vault ~/Brain  # elsewhere (~/Vault becomes a symlink to it)
#   bash install.sh --demo --operator "Jordan Avery"        # the fictional demo vault for teaching
#
# Flags:
#   --vault PATH     where the vault goes (default $HOME/Vault)
#   --operator NAME  replaces {{operator}} everywhere; prompted if missing
#   --demo           overlay demo/ (Jordan Avery, Redbud Water) on top of the skeleton
#   --force          allow installing into an existing non-empty vault (files are overlaid, never deleted)
#   --hooks          also write the two hooks into ~/.claude/settings.json (backup taken first)
#   --no-links       skip the four ~/.claude symlinks
#
# Safe to re-run. Nothing is deleted. Real files in the way of a symlink are backed up.
set -uo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
VAULT="$HOME/Vault"
OPERATOR=""
DEMO=0; FORCE=0; LINKS=1
TODAY=$(date +%Y-%m-%d)
STAMP=$(date +%Y%m%d-%H%M%S)

while [ $# -gt 0 ]; do
  case "$1" in
    --vault) VAULT="$2"; shift 2 ;;
    --operator) OPERATOR="$2"; shift 2 ;;
    --demo) DEMO=1; shift ;;
    --force) FORCE=1; shift ;;
    --hooks) HOOKS=1; shift ;;
    --no-links) LINKS=0; shift ;;
    -h|--help) sed -n '2,17p' "$0"; exit 0 ;;
    *) echo "unknown flag: $1"; exit 1 ;;
  esac
done
case "$VAULT" in "~"*) VAULT="$HOME${VAULT#\~}" ;; esac

if [ -z "$OPERATOR" ]; then
  if [ "$DEMO" = 1 ]; then OPERATOR="Jordan Avery"; else
    printf 'Your name as it should appear in the soul file: '; read -r OPERATOR
  fi
fi
[ -n "$OPERATOR" ] || { echo "operator name is required"; exit 1; }

# ------------------------------------------------------------- guard the target
if [ -d "$VAULT" ] && [ -n "$(ls -A "$VAULT" 2>/dev/null)" ] && [ "$FORCE" != 1 ]; then
  echo "STOP: $VAULT exists and is not empty. Re-run with --force to overlay the kit onto it (nothing gets deleted)."
  exit 1
fi
mkdir -p "$VAULT"

# ------------------------------------------------------------- copy the skeleton
echo "Installing skeleton into $VAULT"
cp -R "$KIT/vault/." "$VAULT/"

if [ "$DEMO" = 1 ]; then
  echo "Overlaying demo vault (fictional operator, fictional utility)"
  cp -R "$KIT/demo/." "$VAULT/"
  # the demo renames the domain specialist to utility-ops; drop the blank template so there is one lane
  if [ -d "$VAULT/90_Meta/Agents/utility-ops" ]; then
    rm -rf "$VAULT/90_Meta/Agents/domain-specialist" "$VAULT/90_Meta/Claude_Config/agents/domain-specialist.md"
  fi
fi

# templates become live files only if nothing is there yet
[ -f "$VAULT/90_Meta/soul.md" ] || mv "$VAULT/90_Meta/soul.template.md" "$VAULT/90_Meta/soul.md"
[ -f "$VAULT/90_Meta/Glossary_and_IDs.md" ] || mv "$VAULT/90_Meta/Glossary_and_IDs.template.md" "$VAULT/90_Meta/Glossary_and_IDs.md"
rm -f "$VAULT/90_Meta/soul.template.md" "$VAULT/90_Meta/Glossary_and_IDs.template.md"

# ------------------------------------------------------------- substitute
# {{operator}} and {{today}} are filled. Other {{...}} prompts stay for the human.
find "$VAULT" -type f -name '*.md' -print0 | while IFS= read -r -d '' f; do
  if grep -q '{{operator}}\|{{today}}\|{{vault}}' "$f"; then
    perl -pi -e "s/\{\{operator\}\}/$OPERATOR/g; s/\{\{today\}\}/$TODAY/g; s#\{\{vault\}\}#$VAULT#g" "$f"
  fi
done
chmod +x "$VAULT"/90_Meta/Claude_Config/bin/*.sh 2>/dev/null

# ------------------------------------------------------------- ~/Vault alias
if [ "$VAULT" != "$HOME/Vault" ]; then
  if [ ! -e "$HOME/Vault" ]; then
    ln -s "$VAULT" "$HOME/Vault"
    echo "Linked ~/Vault -> $VAULT (the boot note and commands refer to ~/Vault)"
  else
    echo "NOTE: ~/Vault already exists and is not this vault. The boot note refers to ~/Vault; reconcile by hand."
  fi
fi

# ------------------------------------------------------------- symlinks
link_it() {
  local target="$1" link="$2" label="$3"
  if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then echo "  OK     $label already linked"; return; fi
  if [ -L "$link" ]; then echo "  FIX    $label pointed at $(readlink "$link")"; rm "$link"
  elif [ -e "$link" ]; then mv "$link" "$link.pre-symlink.$STAMP"; echo "  FIX    $label was a real file/dir, backed up to $(basename "$link").pre-symlink.$STAMP"
  else echo "  NEW    $label"; fi
  ln -s "$target" "$link"
}
if [ "$LINKS" = 1 ]; then
  echo "Linking ~/.claude to the vault"
  mkdir -p "$HOME/.claude"
  link_it "$HOME/Vault/90_Meta/session-boot.md"      "$HOME/.claude/CLAUDE.md" "CLAUDE.md"
  link_it "$HOME/Vault/90_Meta/Claude_Config/agents"   "$HOME/.claude/agents"    "agents   "
  link_it "$HOME/Vault/90_Meta/Claude_Config/commands" "$HOME/.claude/commands"  "commands "
  link_it "$HOME/Vault/90_Meta/Claude_Config/bin"      "$HOME/.claude/bin"       "bin      "
fi

# ------------------------------------------------------------- hooks (written only with --hooks)
if [ "${HOOKS:-0}" = "1" ]; then
  SETTINGS="$HOME/.claude/settings.json"
  mkdir -p "$HOME/.claude"
  [ -f "$SETTINGS" ] && cp "$SETTINGS" "$SETTINGS.bak-$STAMP"
  python3 - "$SETTINGS" <<'PY'
import json, os, sys
p = sys.argv[1]
d = json.load(open(p)) if os.path.exists(p) and os.path.getsize(p) > 0 else {}
hooks = d.setdefault("hooks", {})
want = {
  "SessionStart": {"type": "command", "command": 'sh "$HOME/.claude/bin/handoff-debt.sh"'},
  "Stop":         {"type": "command", "command": 'sh "$HOME/.claude/bin/session-close.sh"', "timeout": 30},
}
for event, hook in want.items():
    entries = hooks.setdefault(event, [])
    if not any(h.get("command") == hook["command"] for e in entries for h in e.get("hooks", [])):
        entries.append({"hooks": [hook]})
json.dump(d, open(p, "w"), indent=2); open(p, "a").write("\n")
print("  hooks written to", p)
PY
fi

# ------------------------------------------------------------- hooks (printed, never written)
cat <<MSG

Done. Vault: $VAULT   Operator: $OPERATOR

Next:
  1. Open the vault in Obsidian. Enable Dataview and its JavaScript queries so Live Projects renders.
  2. Edit 90_Meta/soul.md (or run the interview in 90_Meta/soul-interview.prompt.md first).
  3. Add these hooks to ~/.claude/settings.json so boot and stop both check continuity:
     "hooks": {
       "SessionStart": [{"hooks": [{"type": "command", "command": "sh \"\$HOME/.claude/bin/handoff-debt.sh\""}]}],
       "Stop":         [{"hooks": [{"type": "command", "command": "sh \"\$HOME/.claude/bin/session-close.sh\"", "timeout": 30}]}]
     }
  4. Restart Claude Code and run /status.
  5. Day-by-day plan: README.md in the kit.
MSG
exit 0
