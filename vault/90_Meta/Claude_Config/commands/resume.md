---
description: Find a lost session and pick the work back up
argument-hint: "[optional keyword, e.g. tank repaint]"
allowed-tools: Bash, Read, Grep, Glob
---

A session died (ssh drop, crash, closed laptop). Reconstruct it and keep going.

1. Run `python3 ~/.claude/bin/sessions.py 8` to list recent sessions.
2. Pick the match. If `$ARGUMENTS` is set, prefer the session whose start prompt or cwd mentions it. Otherwise take the most recent one that is not this session.
3. Read the tail of that transcript for what was actually in flight:
   `tail -c 120000 <file> | python3 -c "import sys,json; [print(json.loads(l).get('message',{}).get('role','?'), str(json.loads(l).get('message',{}).get('content'))[:400]) for l in sys.stdin if l.strip().startswith('{')]" 2>/dev/null | tail -60`
4. Check the project's real state before trusting the transcript: the repo's `HANDOFF.md` or `STATUS.md`, `git status`, `git log --oneline -5`, and the matching card in `~/Vault/04_Dashboards/Project_Cards/`.
5. Report in this shape, then continue the work without waiting for permission on reversible steps:

```
Lost session: <id> (<when>, <cwd>)
Was doing:    <one line>
Landed:       <what actually got committed / deployed / written>
In flight:    <what was mid-edit when it died>
Next:         <the immediate next action>
```

Where the transcript and the repo disagree, the repo wins. Say so when they differ.
