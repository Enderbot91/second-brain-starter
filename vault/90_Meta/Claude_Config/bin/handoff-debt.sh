#!/bin/sh
# SessionStart hook: surface projects whose continuity file is behind the code.
#
# The two most common asks in any long-running AI setup are "update the handoff"
# and "I lost my session". This makes the debt visible at the start of the next
# session instead of relying on memory. Read-only, compares mtimes, no state.

VAULT="${VAULT:-$HOME/Vault}"
out=""

for d in "$HOME"/Repos/*/ "$HOME"/Games/*/; do
    [ -d "$d/.git" ] || continue
    last_commit=$(git -C "$d" log -1 --format=%ct 2>/dev/null) || continue
    [ -n "$last_commit" ] || continue

    doc=""
    for f in HANDOFF.md STATUS.md; do
        [ -f "$d$f" ] && doc="$d$f" && break
    done

    name=$(basename "$d")
    if [ -z "$doc" ]; then
        out="$out\n  $name: no HANDOFF.md or STATUS.md"
        continue
    fi

    doc_mtime=$(stat -f %m "$doc" 2>/dev/null) || continue
    # Only a full day of drift counts. Committing after writing the handoff in
    # the same session is normal, not debt.
    days=$(( (last_commit - doc_mtime) / 86400 ))
    if [ "$days" -ge 1 ]; then
        out="$out\n  $name: $(basename "$doc") is ${days}d behind the last commit"
    fi
done

# Active cards nobody has touched in two weeks.
stale=$(find "$VAULT/04_Dashboards/Project_Cards" -name '*.md' -mtime +14 2>/dev/null \
    | while read -r c; do
        grep -qE '^status: (closed|live|paused)' "$c" || printf '  %s\n' "$(basename "$c" .md)"
      done)

if [ -n "$out" ] || [ -n "$stale" ]; then
    printf 'Handoff debt (from the SessionStart hook, /handoff clears it):\n'
    [ -n "$out" ] && printf "%b\n" "$out"
    [ -n "$stale" ] && printf 'Active cards not touched in 14+ days:\n%s\n' "$stale"
fi

exit 0
