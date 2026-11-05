# AGENTS.md shim for a second CLI

A second AI CLI (Codex, Gemini CLI, Antigravity, anything that reads `AGENTS.md`) should read the same boot note Claude Code reads. Do not copy the rules into a second file. Link to the one in the vault.

## Codex (`~/.codex/AGENTS.md`)

```sh
mkdir -p ~/.codex
ln -sf ~/Vault/90_Meta/session-boot.md ~/.codex/AGENTS.md
```

## Gemini CLI (`~/.gemini/config/AGENTS.md` or `GEMINI.md`)

See `GEMINI.md` in this folder.

## Any tool that reads a project-level `AGENTS.md`

From the repo root:

```sh
ln -sf ~/Vault/90_Meta/session-boot.md AGENTS.md
echo "AGENTS.md" >> .git/info/exclude
```

The exclude line keeps the symlink out of the repo. A committed symlink into a private vault is how private notes end up public.

## The `@` import line

Claude Code follows the `@~/Vault/90_Meta/soul.md` line in the boot note. Most other tools do not. The boot note says so in plain text right under it, so a tool that ignores the `@` still gets told to read the soul first. If your second tool never reads the soul, add a one-line instruction to its own config: "Read ~/Vault/90_Meta/soul.md before anything else."
