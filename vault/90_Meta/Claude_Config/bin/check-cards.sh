#!/usr/bin/env bash
# Validate every project card's YAML frontmatter. The Live Projects dashboard
# renders from this frontmatter, so a card that fails to parse can silently
# vanish from the dashboard while looking fine in the editor.
#
# Usage:  check-cards.sh          report only
#         check-cards.sh --fix    quote offending single-line values, then report
#
# The commonest break: an unquoted value containing a colon-space, e.g.
#   stage: Live 2026-08-17: sync 13 of 14 green
# YAML reads the second colon as a new mapping and the whole card fails.
set -uo pipefail
CARDS="${VAULT:-$HOME/Vault}/04_Dashboards/Project_Cards"
MODE="${1:-report}"

# Pick the first python that can import yaml rather than naming one; the system
# python3 on many Macs has no pyyaml.
PY_BIN=""
for c in "$HOME/.venvs/*/bin/python" python3 python; do
  for p in $c; do
    [ -x "$p" ] || command -v "$p" >/dev/null 2>&1 || continue
    if "$p" -c "import yaml" >/dev/null 2>&1; then PY_BIN="$p"; break 2; fi
  done
done
if [ -z "$PY_BIN" ]; then
  echo "no python with pyyaml found. Install it:  python3 -m pip install pyyaml" >&2
  exit 2
fi
"$PY_BIN" - "$CARDS" "$MODE" <<'PY'
import re, sys, glob, os
try: import yaml
except ImportError: sys.exit("pyyaml not installed: python3 -m pip install pyyaml")
cards, mode = sys.argv[1], sys.argv[2]
os.chdir(cards)
KEY = re.compile(r"^([A-Za-z_][A-Za-z0-9_-]*):(\s|$)")

def quote_fix(fm):
    out, fixed = [], []
    for ln in fm.split("\n"):
        m = KEY.match(ln)
        if m:
            try: yaml.safe_load(ln)
            except Exception:
                k, _, v = ln.partition(":")
                v = v.strip()
                cand = None
                if not v.startswith(('"', "'")):
                    # unquoted value, usually one containing ": "
                    cand = f'{k}: "{v.replace(chr(34), chr(39))}"'
                elif v.startswith('"') and v.endswith('"') and v.count('"') > 2:
                    # ALREADY quoted but with bare double quotes inside, which end the
                    # string early. This is the commonest break when a card is edited by
                    # script: writing "Tanks and Crops" inside a double-quoted next: value.
                    cand = f'{k}: "{v[1:-1].replace(chr(34), chr(39))}"'
                if cand:
                    try:
                        yaml.safe_load(cand); ln = cand; fixed.append(k)
                    except Exception: pass
        out.append(ln)
    return "\n".join(out), fixed

bad = []
for f in sorted(glob.glob("*.md")):
    s = open(f).read()
    m = re.match(r"^(---\n)(.*?)(\n---\n)", s, re.S)
    if not m: bad.append((f, "no frontmatter")); continue
    try:
        yaml.safe_load(m.group(2)); continue
    except Exception as e:
        err = str(e).splitlines()[0]
    if mode == "--fix":
        new, fixed = quote_fix(m.group(2))
        try:
            yaml.safe_load(new)
            open(f, "w").write(m.group(1) + new + m.group(3) + s[m.end():])
            print(f"  FIXED {f}  (quoted: {', '.join(fixed)})"); continue
        except Exception: pass
    bad.append((f, err))

n = len(glob.glob("*.md"))
print(f"\n{n} cards checked")
if bad:
    print(f"{len(bad)} BROKEN (these may not render on the dashboard):")
    for f, e in bad: print(f"  {f}\n      {e}")
    print("\nRe-run with --fix to auto-quote single-line values.")
    sys.exit(1)
print("all frontmatter parses clean")
PY
