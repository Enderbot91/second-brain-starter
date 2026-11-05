---
description: Write the handoff, project card, and memory for the current work
argument-hint: "[optional project name]"
allowed-tools: Bash, Read, Write, Edit, Grep, Glob
---

Close out this work burst so another machine or session can pick it up cold.

Figure out which project this is from the cwd, the repo, or `$ARGUMENTS`. Then update all three, in this order:

1. **Repo continuity file.** `HANDOFF.md` or `STATUS.md` in the repo (whichever that project already uses, do not create a second one). Append a dated section: what shipped, the current commit SHA (`git rev-parse --short HEAD`), what is deployed vs merely committed, what is mid-flight, the exact next command to run.
2. **Project card.** `~/Vault/04_Dashboards/Project_Cards/<Project>.md`. Update `status`, `progress`, `blocker`, `next`, and `updated:` to today. Card frontmatter is what the Live Projects dashboard renders, so keep `next` specific enough to act on without opening the repo. Create the card if the project has none.
3. **Memory.** If a durable fact changed (a URL went live, a service moved, a new gotcha), update the matching file in your Claude memory directory (`~/.claude/projects/<cwd-slug>/memory/`) and its line in `MEMORY.md`.

Rules:
- Verify before you write. Check `git status`, `git log`, and the live URL. Do not copy forward a claim from the last handoff without confirming it.
- Deployed and committed are different states. Say which.
- No em dashes.
- If Syncthing needs to fire for the vault to reach the other machine, say so explicitly at the end.

Finish with a three-line summary: what changed, what is blocked, what is next.
