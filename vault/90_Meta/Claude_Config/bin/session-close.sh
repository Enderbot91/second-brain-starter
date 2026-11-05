#!/bin/sh
# Stop hook: the end-of-session twin of handoff-debt.sh.
#
# handoff-debt.sh nags at boot about continuity that is already behind.
# This runs when Claude stops and asks the cheaper question: did this session
# touch a project without moving its card? It catches the debt before it
# becomes debt.
#
# What it checks, all read-only:
#   1. Project cards whose frontmatter fails to parse (check-cards.sh), since a
#      card edited this session is the likeliest one to have an unquoted colon.
#   2. Repos under ~/Repos and ~/Games with commits in the last 12 hours whose
#      HANDOFF.md / STATUS.md did not move in the same window.
#   3. Project folders under ~/Vault/05_Projects with notes modified in the last
#      12 hours and no card in 04_Dashboards/Project_Cards updated in the window.
#
# Output goes to stderr with exit 2 so Claude sees it and can run /handoff.
# Exit 0 (silent) when nothing is owed. Never blocks; never edits.
#
# Hook input arrives on stdin as JSON. We only read stop_hook_active so a
# session that already handled a nag does not loop on it.

STDIN=$(cat 2>/dev/null)
case "$STDIN" in *'"stop_hook_active":true'*) exit 0 ;; esac

# Headless runs (daily-brief.sh, soul-foldback.sh, any `claude -p` job) set this.
# In print mode the hook's nag would replace the job's output, since the last
# assistant message is what gets printed. Interactive sessions never set it.
[ -n "${CLAUDE_SESSION_CLOSE_SKIP:-}" ] && exit 0

VAULT="${VAULT:-$HOME/Vault}"
CARDS="$VAULT/04_Dashboards/Project_Cards"
WINDOW_MIN=720   # 12 hours
out=""

# 1. cards that no longer parse
if [ -x "$HOME/.claude/bin/check-cards.sh" ]; then
    broken=$(sh "$HOME/.claude/bin/check-cards.sh" 2>/dev/null | grep -A50 'BROKEN' | grep -E '^\s+\S+\.md$' | sed 's/^[[:space:]]*/  /')
    [ -n "$broken" ] && out="$out\nCards that will not render on Live Projects (run check-cards.sh --fix):\n$broken"
fi

# 2. repos committed this session without a continuity file update
now=$(date +%s)
for d in "$HOME"/Repos/*/ "$HOME"/Games/*/; do
    [ -d "$d/.git" ] || continue
    last_commit=$(git -C "$d" log -1 --format=%ct 2>/dev/null) || continue
    [ -n "$last_commit" ] || continue
    [ $(( now - last_commit )) -le $(( WINDOW_MIN * 60 )) ] || continue
    doc=""
    for f in HANDOFF.md STATUS.md; do [ -f "$d$f" ] && doc="$d$f" && break; done
    name=$(basename "$d")
    if [ -z "$doc" ]; then
        out="$out\n  $name: committed this session, no HANDOFF.md or STATUS.md"
        continue
    fi
    doc_mtime=$(stat -f %m "$doc" 2>/dev/null) || continue
    if [ "$doc_mtime" -lt "$last_commit" ]; then
        out="$out\n  $name: committed after $(basename "$doc") was last written"
    fi
done

# 3. project notes touched this session with no card moved in the same window
touched_cards=$(find "$CARDS" -name '*.md' -mmin -$WINDOW_MIN 2>/dev/null | wc -l | tr -d ' ')
touched_projects=$(find "$VAULT/05_Projects" -name '*.md' -mmin -$WINDOW_MIN 2>/dev/null \
    | grep -v 'sync-conflict' | awk -F/ '{print $(NF-1)}' | sort -u | head -8 | tr '\n' ',' | sed 's/,$//; s/,/, /g')
if [ -n "$touched_projects" ] && [ "$touched_cards" = "0" ]; then
    out="$out\n  vault: notes changed in [$touched_projects] but no project card moved this session"
fi

if [ -n "$out" ]; then
    printf 'Session close check (Stop hook). Before you finish, run /handoff or say why not:%b\n' "$out" >&2
    exit 2
fi
exit 0
