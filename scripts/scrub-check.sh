#!/usr/bin/env bash
# Grep the kit for anything that should have been scrubbed before publishing:
# the original operator's company, people, systems, addresses, and network.
# Exit 1 on any hit so it can gate a push. Word-bounded so "explains" is not "plains".
set -uo pipefail
cd "$(dirname "$0")/.."
hits=$(grep -rlI . --exclude-dir=.git --exclude=scrub-check.sh \
  | xargs perl -ne 'print "$ARGV:$.: $_" if /\b(plains|joseph|juan|sonar|zabbix|tailscale)\b|100\.|andrew@|hey\.com/i; close ARGV if eof' 2>/dev/null)
if [ -n "$hits" ]; then
  echo "SCRUB CHECK FAILED. Remove these before publishing:"
  echo "$hits"
  exit 1
fi
# Em dashes are a style rule in this kit. Report them too.
dashes=$(grep -rn "—" --exclude-dir=.git --exclude=scrub-check.sh . || true)
if [ -n "$dashes" ]; then
  echo "EM DASHES FOUND (style rule):"
  echo "$dashes"
  exit 1
fi
echo "scrub check clean"
