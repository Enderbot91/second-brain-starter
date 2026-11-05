# Session Boot

> **Edit this note, not the symlinks.** This file is the global rules file for AI CLI tools, symlinked from `~/.claude/CLAUDE.md` (and `~/.gemini/config/AGENTS.md` or `~/.codex/AGENTS.md` if you use a second CLI) on every machine. It lives in the vault, so one edit here updates every tool everywhere the vault syncs.

## Read first

@~/Vault/90_Meta/soul.md

(The `@` line above auto-imports for Claude Code. Other tools: read `~/Vault/90_Meta/soul.md` first. It is the operator profile: who {{operator}} is, priorities, voice rules.)

## Where things live

- **The vault** is at `~/Vault` on every machine. It is the single source of truth for project state, handoffs, and agent instructions.
- **Live project state:** `~/Vault/04_Dashboards/Live Projects.md` renders from one card note per project in `~/Vault/04_Dashboards/Project_Cards/`. Read the card frontmatter to answer "what's still live?". A project is live until its card says `status: closed`. Age never retires a project.
- **When project state changes in any session, update its card** (status/progress/blocker/next + `updated:`). New project = new card.
- **Handoffs:** every project keeps a canonical handoff note under `~/Vault/05_Projects/<Area>/<Project>/`. End-of-session continuity goes there, never in chat scrollback.
- **Agent team:** `~/Vault/90_Meta/Agents/`. Each agent has a `<name>-soul.md` (role) and `<name>-memory.md` (state). Index at `Agents Index.md`. Every agent reads the shared soul first.
- **Vault map:** `~/Vault/90_Meta/MOCs/Vault Index.md` explains the folder structure.

## Standing rules

1. **Never send email or messages on {{operator}}'s behalf without explicit confirmation.** Draft it, show it, wait for "send it."
2. **Run multi-step tasks autonomously** and report with an after-action summary. Do not ask permission mid-flight for reversible steps.
3. No em dashes, no "not X but Y" AI-contrast phrasing, no chatbot cadence in anything written as {{operator}}.
4. Secrets never live in the vault. Keys and tokens go in `~/.config/<tool>/` or the keychain, and notes point at them by name only.
5. If a code repo links into the vault (a `docs/vault` symlink or similar), never `git add` it and never run a direct-upload deploy that could follow the link.
