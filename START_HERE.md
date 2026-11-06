# Start here

This is the kit from the video "One Brain, Many Hands." It sets up one folder of notes that every AI tool you use reads from, so you stop re-explaining yourself and nothing gets lost when a chat ends.

You do not need to be technical. You need a computer (Mac, Windows, or Linux), about an hour, and the willingness to paste a few lines into a terminal window. Every line you need is in a gray box below. Copy the whole box, paste it, press Return.

On a Mac the terminal is called Terminal (press Command-Space, type Terminal). On Windows it is PowerShell (press the Windows key, type PowerShell). On Linux you know where it is.

## 1. Install the two free apps

1. **Obsidian** is the app you read and edit notes in. Download it at obsidian.md and open it once.
2. **Claude Code** is the AI tool that reads and writes those notes. Paste the line for your computer into the terminal.

Mac or Linux:

```
curl -fsSL https://claude.ai/install.sh | bash
```

Windows (PowerShell):

```
irm https://claude.ai/install.ps1 | iex
```

Then type `claude` and press Return. It opens a browser tab to sign in with your Claude account. Sign in, come back to Terminal, type `/exit` and press Return.

## 2. Put the kit on your computer

If you were sent a zip file: double-click it (Windows: right-click, Extract All), then drag the folder it makes into your home folder (the one with your name on it, next to Desktop and Documents).

If you were given a link instead, it is this one: https://github.com/Enderbot91/second-brain-starter. Open it, click the green "Code" button, choose "Download ZIP," then do the same thing with the zip.

Either way you end up with a folder called `second-brain-starter` in your home folder.

## 3. Run the installer

Paste the line for your computer, but first replace `Your Name` with your actual name, keeping the quotes.

Mac or Linux:

```
cd ~/second-brain-starter && bash install.sh --operator "Your Name" --hooks
```

Windows (PowerShell):

```
cd $HOME\second-brain-starter; Set-ExecutionPolicy -Scope Process Bypass; .\install.ps1 -Operator "Your Name"
```

What it does, in plain words: it creates a folder called `Vault` in your home folder with the empty note structure, writes your name into the profile template, and tells Claude Code where to find the rules. Nothing on your computer is deleted. If it says something already exists, stop and read the message; it is telling you what it found.

If you want to practice on fake data first, the kit includes a made-up water utility run by a person named Jordan Avery. Install that copy with:

```
cd ~/second-brain-starter && bash install.sh --demo --vault ~/DemoVault --hooks
```

Windows:

```
cd $HOME\second-brain-starter; Set-ExecutionPolicy -Scope Process Bypass; .\install.ps1 -Demo -Vault "$HOME\DemoVault"
```

Windows note: the two automatic reminders (the "handoff debt" check at the start and end of a session) do not run on native Windows yet. Everything else does. `Windows.md` explains, and has the WSL route if you want them.

## 4. Open the vault in Obsidian

Open Obsidian, click "Open folder as vault," pick the `Vault` folder in your home folder. When it asks about plugins, go to Settings, then Community plugins, turn them on, search for **Dataview**, install it, enable it, and in its own settings turn on **Enable JavaScript Queries**. That one plugin is what draws your project board.

## 5. Write your profile

Open the note `90_Meta/soul-interview.prompt.md` in Obsidian. Copy everything in it. Paste it into any AI chat you like (Claude, ChatGPT, either works). Answer its twelve questions honestly. Paste the result into the note `90_Meta/soul.md`, replacing what is there. Read it out loud once and delete anything you would not say.

This is the most important hour of the setup. Every AI tool reads this page first.

## 6. Try it

In the terminal (Windows: `cd $HOME\Vault; claude`):

```
cd ~/Vault && claude
```

Ask: "What are my top three priorities?" It should answer from your profile. Type `/status` and press Return. With no projects yet it will say so. Add one card by copying `04_Dashboards/Project_Cards/_card.template.md` in Obsidian, renaming it after a real project, and filling in the five lines at the top. Run `/status` again. If a card ever vanishes from the board, run `~/.claude/bin/check-cards.sh --fix` in the terminal; a colon inside a value is the usual cause and that repairs it.

When you are done for the day, type `/handoff`. That is the habit the whole system depends on.

## What to do next week

The `README.md` in this folder has a seven-day checklist, one small step a day. Day 1 is what you just did.

## If something goes wrong

- "command not found: claude" (or "not recognized" on Windows) means step 1 did not finish. Close the terminal, open it again, try `claude` once more.
- Obsidian shows a blank board: Dataview is not on, or JavaScript queries are off. See step 4.
- The installer says the vault exists: you already have a `Vault` folder. Rename it or add `--force` to the installer line to lay the kit over it (nothing is deleted).
- Anything else: paste the exact message into Claude Code and ask it what went wrong. That is what it is for.
