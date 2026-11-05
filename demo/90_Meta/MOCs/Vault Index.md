---
title: Vault Index
type: moc
created: 2026-11-05
tags:
  - moc
  - index
description: Agent-facing entry point for the whole vault. Start here to find anything.
---

# Vault Index

> The single entry point an agent (or Jordan) should read first.

## Read these first

- [[soul]] - who Jordan is, how to prioritize, voice and style rules. Read every session.
- [[Glossary_and_IDs]] - TCEQ and USDA acronyms, Redbud IDs. Look terms up here, do not guess.
- [[Agents Index]] - the agent team and where their souls and memory live.
- [[Live Projects]] - the board that renders every project card.

## PARA layout

| Folder | Holds | When to use |
|--------|-------|-------------|
| `00_Inbox` | New unsorted captures | `_Review_Queue` is the pile awaiting triage. |
| `04_Dashboards` | Boards and the project cards that feed them | `Project_Cards/` is the live state of every project. |
| `05_Projects` | Active work with an end state | `Redbud_Water`, `Bramble_and_Bolt`, `Personal`. |
| `06_Areas` | Ongoing responsibilities | Compliance calendar, board, finance, training. |
| `07_Resources` | Reference material | TCEQ guidance, vendor quotes, patterns. |
| `08_Archives` | Dead or superseded | Finished projects. |
| `09_Templates` | Note templates | Do not treat as content. |
| `90_Meta` | Vault-about-the-vault | This index, Glossary, Agents, the Claude config that gets symlinked. |

## Project MOCs

- [[Redbud Water MOC]] - the utility: compliance, the USDA loan, plant and distribution work.
- [[Bramble and Bolt MOC]] - the leather shop.
- [[Personal MOC]] - the marathon.

## Conventions

- Captures land in `00_Inbox`, get triaged into `05`/`06`/`07`, dead notes go to `08_Archives`. Nothing gets deleted outright.
- Each project and area has a `... MOC` note. New note, link it from the MOC.
- Style rules for anything written as Jordan live in [[soul]]. No em dashes, no "not X but Y."
- Quote any card frontmatter value with a colon. Run `check-cards.sh` when a card vanishes from the board.
