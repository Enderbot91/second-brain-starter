---
description: One ranked, actionable to-do list from every project card and vault task
argument-hint: [optional area/project filter, e.g. utility | shop | personal]
allowed-tools: Bash, Read, Grep, Glob
---

Build the single active to-do list. This is /status's sibling: /status reports state, /todo outputs only actions. No narrative, no history, no "here's where things stand." Every line is something someone can physically do.

Sources, all of them:

1. Every non-closed card in `~/Vault/04_Dashboards/Project_Cards/`: mine the `blocker` and `next` fields for concrete actions. Skip watch-fors, context, and anything already done.
2. Unchecked tasks vault-wide: grep for `- [ ]` in `~/Vault` (*.md), excluding `08_Archives`, `09_Templates`, `.obsidian`, and `.trash`. Honor Obsidian Tasks due dates (`📅 YYYY-MM-DD`). `~/Vault/Master To-Do List.md` aggregates these in Obsidian, so the grep IS the master list; don't double-count it.

If an argument is given ($ARGUMENTS), filter to cards and tasks matching that area or project name and skip the cap rules below.

Rules:

- One line per action: imperative verb first, [Project] tag, then age (how long it has sat, from `updated:` or the task's date) or due date. Example: `Sign and date the loan packet [Loan Closing], past due`.
- Dedupe hard. The same action often lives in a card's blocker AND next, and sometimes on two cards (and again as a vault task). It appears once, under the highest-priority project.
- Rank inside each section by the soul-file order: money and compliance deadlines, then legal, then operations, then the side business, then health and personal.
- Flag anything that takes 5 minutes or less with ⚡ so {{operator}} can batch the quick wins.

Output, four sections:

**Hard dates.** Anything with a real calendar date in the next 14 days, soonest first, with days remaining. This section is never capped.

**{{operator}}'s list.** Needs his hands: a GUI login, a signature, a phone call, a money decision. Cap at 10 lines ranked; roll the rest into one final line: `+N more (say "full list")`. If the user says "full list", print them all.

**Claude's list.** Agent-executable right now from this laptop, no {{operator}} input needed. After the section, offer to start the top item, one sentence, no pestering.

**Waiting on others.** Blocked on a named third party (a teammate, a board member, counsel, a vendor). Format: action, who, since when. These are chase candidates: mark any sitting more than 5 business days with 🔔 chase.

Keep it terminal-plain. No em dashes, no tables, no headers beyond the four sections. If a to-do depends on a claim that something is live or deployed, do NOT re-verify here; that is /status's job.
