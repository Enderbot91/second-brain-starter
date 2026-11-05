---
description: Load full context on a project and report where it stands
argument-hint: "<project, e.g. loan closing | shop site>"
allowed-tools: Bash, Read, Grep, Glob
---

Spin up on: **$ARGUMENTS**

Load the state, then report. Do not start changing things until you have reported.

1. **Card.** Find the match in `~/Vault/04_Dashboards/Project_Cards/` (fuzzy, the card name rarely matches what {{operator}} types). Read the frontmatter: `status`, `progress`, `blocker`, `next`, `updated`.
2. **Repo.** Find the repo (`~/Repos/`, `~/Games/`). Read `HANDOFF.md` or `STATUS.md`. Run `git log --oneline -8`, `git status -s`, and check whether local is ahead of origin.
3. **Live.** If the project has a deployed URL, curl it. Confirm it actually serves what the notes claim, including whether it is Access-protected when it should be.
4. **Vault.** Grep `~/Vault/05_Projects/` for the project folder and read anything newer than the card's `updated:` date.

Report:

```
<Project>  status=<x>  progress=<n>%  card updated <date>
Live:     <url> -> <http code / what it actually serves>
Repo:     <sha> <clean|N uncommitted>  <ahead/behind origin>
Blocker:  <what is actually stopping it, or none>
Next:     <the immediate next action>
Stale:    <anything in the card contradicted by what you just verified>
```

That `Stale:` line matters. Cards drift. If the card claims a blocker that is already resolved, or claims something is live that returns a 404, say so and fix the card.
