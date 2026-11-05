---
title: Agents Index
type: moc
created: {{today}}
tags:
  - moc
  - agents
description: The agent team. Each has a soul (role) and a memory (persistent state).
---

# Agents Index

> Start with three agents. Add a fourth only after one of these has been invoked twenty times. Every agent reads the shared [[soul]] first, then its own `<name>-soul.md` for its lane, then its `<name>-memory.md` for what it has learned.

## How this is structured

- Each agent lives in `90_Meta/Agents/<name>/`.
- `<name>-soul.md` = the agent's fixed role, scope, and success criteria. Rarely changes.
- `<name>-memory.md` = what the agent has learned and the state it tracks. Append dated, atomic facts.
- Shared context (priorities, voice, tools) is inherited from [[soul]]. Do not duplicate it into each agent.
- The runnable wrapper for each agent is `90_Meta/Claude_Config/agents/<name>.md`. It only points at these files.

## The team

| Agent | Lane | Use it when |
|-------|------|-------------|
| [[chief-of-staff-soul\|Chief of Staff]] | Orchestrator and daily driver | Daily digest, triage, routing to a specialist, "what should I do today." |
| [[domain-specialist-soul\|Domain Specialist]] | Your main job's lane | Rename this to the job (utility-ops, clinic-ops, shop-ops). Deadlines, filings, vendor and customer commitments. |
| [[librarian-soul\|Librarian]] | Vault upkeep | Triage the inbox, keep MOCs and the index current, file and archive notes. |

## Wiring

The wrapper in `Claude_Config/agents/` is what Claude Code loads (via the `~/.claude/agents` symlink). A second CLI can read the same soul and memory files directly. Keep the wrapper thin: read order, core rules, nothing else.
