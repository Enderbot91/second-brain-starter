# Gemini CLI shim

Gemini CLI reads `~/.gemini/GEMINI.md` (global) and `GEMINI.md` in the project root. Point both at the vault boot note so there is one copy of the rules.

```sh
mkdir -p ~/.gemini
ln -sf ~/Vault/90_Meta/session-boot.md ~/.gemini/GEMINI.md
```

Gemini does not follow the `@~/Vault/90_Meta/soul.md` import line. Add this to `~/.gemini/settings.json` so the soul loads anyway:

```json
{
  "contextFileName": ["GEMINI.md", "soul.md"]
}
```

Then symlink the soul beside it:

```sh
ln -sf ~/Vault/90_Meta/soul.md ~/.gemini/soul.md
```

Verify with `gemini` and ask "what are my top three priorities?" If it answers from the soul, the shim works. If it asks who you are, the import did not land.
