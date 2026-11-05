---
title: Agents Index
type: moc
created: 2026-11-05
tags:
  - moc
  - agents
description: The agent team. Each has a soul (role) and a memory (persistent state).
---

# Agents Index

> Three agents. Every agent reads the shared [[soul]] first, then its own `<name>-soul.md` for its lane, then its `<name>-memory.md` for what it has learned.

## How this is structured

- Each agent lives in `90_Meta/Agents/<name>/`.
- `<name>-soul.md` = fixed role, scope, success criteria. Rarely changes.
- `<name>-memory.md` = what the agent has learned. Append dated, atomic facts.
- The runnable wrapper is `90_Meta/Claude_Config/agents/<name>.md`. It only points at these files.

## The team

| Agent | Lane | Use it when |
|-------|------|-------------|
| [[chief-of-staff-soul\|Chief of Staff]] | Orchestrator and daily driver | Daily digest, triage, "what should I do today." |
| [[utility-ops-soul\|Utility Ops]] | Redbud Water: TCEQ compliance, USDA loan, plant and distribution | Sampling calendar, the CCR, the loan conditions, anything Luis or Pat asks about the system. |
| [[librarian-soul\|Librarian]] | Vault upkeep | Triage the inbox, keep MOCs current, file and archive. |
