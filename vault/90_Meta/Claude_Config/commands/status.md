---
description: Sweep every active project card for blockers, staleness, and what is on {{operator}}
allowed-tools: Bash, Read, Grep, Glob
---

Sweep all non-closed cards in `~/Vault/04_Dashboards/Project_Cards/` and give the real picture.

For each card where `status` is not `closed`, pull `project`, `area`, `status`, `progress`, `blocker`, `next`, `updated`.

Then rank using {{operator}}'s priority order from the soul file: the ranked order in the soul file (money and compliance deadlines first, then legal and regulatory, then operations, then the side business, then health and personal).

Report:

**1. On {{operator}}** (blocked on him, not on us). The single most useful section. Each line: project, the one action, how long it has been sitting.

**2. On us** (we can move it without him). Each line: project, next action.

**3. Stale** (`updated:` older than 14 days and status is active). These are probably lying.

**4. Top 3 today.** Ranked, with the reason each one ranks there.

Keep it tight. {{operator}} wants the signal and two or three actions, not the pile. No em dashes.

If a card claims something is live, spot-check the URL with curl before repeating the claim.
