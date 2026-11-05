---
title: Vault Index
type: moc
created: {{today}}
tags:
  - moc
  - index
description: Agent-facing entry point for the whole vault. Start here to find anything.
---

# Vault Index

> The single entry point an agent (or you) should read first to navigate this vault.

## Read these first

- [[soul]] - who {{operator}} is, how to prioritize, voice and style rules. Read every session.
- [[Glossary_and_IDs]] - acronyms, program names, account IDs. Look terms up here, do not guess.
- [[Agents Index]] - the agent team and where their souls and memory live.
- [[Live Projects]] - the board that renders every project card. "What's live?" starts here.

## PARA layout

| Folder | Holds | When to use |
|--------|-------|-------------|
| `00_Inbox` | New unsorted captures | Anything new lands here first. `_Review_Queue` is the pile awaiting triage. |
| `04_Dashboards` | Boards and the project cards that feed them | `Project_Cards/` is the live state of every project. One card per project. |
| `05_Projects` | Active work with an end state | One folder per area, one subfolder per project, one handoff note inside. |
| `06_Areas` | Ongoing responsibilities, no end date | Health, finance, family, the standing parts of each role. |
| `07_Resources` | Reference material by topic | People, docs, snippets, anything you look up but do not act on. |
| `08_Archives` | Dead or superseded | Finished projects, duplicates. Safe to ignore. |
| `09_Templates` | Note templates | Do not treat as content. |
| `90_Meta` | Vault-about-the-vault | This index, MOCs, Glossary, Agents, the Claude config that gets symlinked. |

## Project MOCs

- [[{{Hat one}} MOC]] - the main job.
- [[{{Hat two}} MOC]] - the side business.
- [[Personal MOC]] - personal projects.

## Conventions

- Captures land in `00_Inbox`, get triaged into `05`/`06`/`07`, and dead notes go to `08_Archives`. Nothing gets deleted outright.
- Each project and area has a `... MOC` index note. When you add a note, link it from the relevant MOC so it is findable.
- Style rules for anything written as {{operator}} live in [[soul]]. Short version: no em dashes, no "not X but Y" phrasing.
- Quote any card frontmatter value that contains a colon. Run `check-cards.sh` when a card vanishes from the board.

> [!note] Dashboard structure
> `04_Dashboards/Live Projects.md` renders the notes in `04_Dashboards/Project_Cards/`. Preserve these paths and the card frontmatter.
