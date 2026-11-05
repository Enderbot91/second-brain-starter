# second-brain-starter: handoff

Canonical project state lives in the vault: card `04_Dashboards/Project_Cards/AI Second Brain Training.md`, notes under `05_Projects/AxeAndBow/AI_Second_Brain_Training/`. This file is the repo-side continuity note.

## 2026-11-05: first build

What this is: the public starter kit from section 5 of the Second Brain Replication Training Plan. `vault/` is the clean skeleton with `{{operator}}` placeholders. `demo/` is a full overlay for a fictional operator (Jordan Avery, Redbud Water Supply Corporation, Caddo Falls TX) so nobody records or teaches from a real vault. `install.sh` copies the skeleton, substitutes the operator name, creates the four `~/.claude` symlinks, and with `--demo` lays the demo data on top.

Shipped this session:
- Skeleton: PARA folders, soul template + 12-question interview prompt, generic Vault Index, glossary template, Live Projects board (dataviewjs verbatim from the live vault), card template, five commands (spinup, status, handoff, todo, resume), five bin scripts (check-cards, handoff-debt, fix-claude-symlinks, session-close, sessions), three agents (chief-of-staff, domain-specialist, librarian) with soul and memory templates, AGENTS.md and GEMINI.md shims, six-line CLAUDE.template.md, Windows.md, MIT license.
- Demo: soul for Jordan, seven cards across waiting/active/paused/closed with one deliberately stale (Bramble Spring Line, updated 2026-10-01), seven handoff notes, three inbox notes, glossary with water-utility acronyms and placeholder IDs, three agents with dated memory lines, README on the identity.
- `scripts/scrub-check.sh`: word-bounded grep for real names, hosts, and addresses, plus a hard fail on any em dash. Clean at commit.
- Dry run of `install.sh --demo` under a scratch HOME: substitutions complete, symlinks correct, second run refused without `--force`, all seven cards pass the frontmatter quoting check.

Not done:
- No Obsidian render test of the demo board. Open the demo vault in Obsidian with Dataview on and confirm seven cards draw.
- No real pyyaml parse of the cards (regex check only).
- No remote. Goes under the personal GitHub account when Andrew says so. Never push from the global git identity (the repo-local email is set on purpose).
- No Windows test. `Windows.md` is written from documentation, not from a run.

Exact next commands:

```sh
cd ~/Repos/second-brain-starter
bash scripts/scrub-check.sh                       # must print clean before any push
HOME=/tmp/sbtest bash install.sh --demo --operator "Jordan Avery" --vault /tmp/sbtest/Vault
open -a Obsidian /tmp/sbtest/Vault                # render check
```

## 2026-11-05, later

- `session-close.sh` (vault and kit copies): a last commit that includes the handoff file now counts as clean, so the normal write-then-commit close-out stops tripping the Stop hook. Kit copy keeps the `VAULT` override. Commit `5aa2b20`.
- Higgsfield re-authed to the Plus plan the same afternoon, so v2 video assets are unblocked on the training side.
