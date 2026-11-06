# second-brain-starter

> **New here and not technical?** Read `START_HERE.md` first. It is six numbered steps with every line to paste. This file is the reference.

One Obsidian vault as the system of record, several AI tools reading the same files. This kit is the scaffold: the folder layout, the operator profile, three agents, the project board, the slash commands, and the hooks that keep continuity honest. It is the companion to the training "One Brain, Many Hands."

Mac, Linux, and Windows. Mac and Linux use `install.sh`; Windows uses `install.ps1` (see `Windows.md`).

## Install

```sh
git clone https://github.com/Enderbot91/second-brain-starter ~/second-brain-starter
cd ~/second-brain-starter
bash install.sh --operator "Your Name"
```

That copies `vault/` to `~/Vault`, fills your name in, and symlinks `~/.claude/{CLAUDE.md,agents,commands,bin}` into the vault so every machine that syncs the vault gets the same config. Add `--hooks` to have the installer write the two hooks into `~/.claude/settings.json` (with a backup), or add them by hand from what it prints. Nothing is deleted, ever.

To teach or record from a vault with nothing real in it:

```sh
bash install.sh --demo --vault ~/DemoVault
```

That is Jordan Avery, general manager of a fictional rural water utility. See `demo/README.md`.

## What is in the box

| Path | What it is |
|---|---|
| `vault/90_Meta/soul.template.md` | The one-page operator profile every tool reads first. |
| `vault/90_Meta/soul-interview.prompt.md` | Twelve questions an AI asks you to draft the soul. Do this before anything else. |
| `vault/90_Meta/session-boot.md` | Global rules file. `~/.claude/CLAUDE.md` symlinks to it. |
| `vault/04_Dashboards/Live Projects.md` | The board. Renders one card per project. |
| `vault/04_Dashboards/Project_Cards/_card.template.md` | The card schema: status, progress, blocker, next, updated. |
| `vault/90_Meta/Agents/` | Three agents: chief of staff, domain specialist, librarian. Soul + memory each. |
| `vault/90_Meta/Claude_Config/commands/` | `/spinup` `/status` `/handoff` `/todo` `/resume` |
| `vault/90_Meta/Claude_Config/bin/` | `handoff-debt.sh` (boot hook), `check-cards.sh`, `fix-claude-symlinks.sh` |
| `shims/` | Pointing a second CLI (Codex, Gemini) at the same boot note. |
| `demo/` | The fictional overlay for recording and workshops. |
| `scripts/scrub-check.sh` | Grep gate that fails if anything from the original author's world leaks in. |

## The seven-day checklist

Do one a day. Each one is small on purpose.

- [ ] **Day 1. Vault.** Run `install.sh`. Open in Obsidian. Turn on Dataview. Move five real notes into `05_Projects` or `07_Resources`. Open `Vault Index` and fix the three MOC names.
- [ ] **Day 2. Soul.** Paste `soul-interview.prompt.md` into any AI chat and answer the twelve questions. Put the draft in `90_Meta/soul.md`. Read it out loud and strike anything you would not say.
- [ ] **Day 3. Cards.** Copy `_card.template.md` once per live project, even if `next` is "figure out next." Open `Live Projects` and watch it render. Run `check-cards.sh`.
- [ ] **Day 4. Doorway one.** Start Claude Code anywhere. Confirm the boot note loaded (ask "what are my top three priorities?"). Run `/status`. Add the two hooks. Close the session and watch the Stop hook ask about the handoff.
- [ ] **Day 5. Specialists.** Rename `domain-specialist` to your job. Fill its soul. Ask it a real question. Correct it. Watch the correction land in its memory file.
- [ ] **Day 6. Doorway two.** Pick a second tool. Follow `shims/`. Ask it the same priorities question. Then make a Claude.ai or ChatGPT project and upload `soul.md` and `Glossary_and_IDs.md` to it.
- [ ] **Day 7. The loop.** Morning: `/status`. Pick one project: `/spinup <name>`. Work. End: `/handoff`. Sync the vault to a second machine or your phone and open the board there.

## Rules the kit assumes

1. The vault is the system of record. Chats are scratch.
2. Every project has a card. A project is live until its card says closed.
3. Every session ends with a handoff, or with a reason why not.
4. Secrets never live in the vault.
5. No em dashes. It is a style rule and a tell.

## Companion

The long-form video and its build pipeline live in a sibling repo. The video's chapter 9 lists the failure modes this kit is shaped around.

MIT. Copyright 2026 Andrew Monroe.
