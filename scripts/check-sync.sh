#!/usr/bin/env bash
# Fail if the installer manifest (tools.tsv) and the README catalog drift apart.
# Every tool the installer can install should be documented, and vice-versa.
# (Burp Suite / browser extensions live in the README only — they are not
# installed by the script — and are ignored here.)
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
MAN="$here/tools.tsv"
RDM="$here/README.md"

# normalize a single token to [a-z0-9] (one value per line)
norm() { printf '%s\n' "$1" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9'; echo; }

# README tool headings (### X) inside the catalog block -> normalized set.
: > /tmp/.rdm_tools
while IFS= read -r h; do norm "$h"; done < <(
  awk '/<!-- BEGIN:CATALOG -->/{c=1} /<!-- END:CATALOG -->/{c=0} c && /^### /{print substr($0,5)}' "$RDM"
) | sort -u > /tmp/.rdm_tools

# Manifest commands -> normalized set.
: > /tmp/.man_tools
while IFS= read -r t; do norm "$t"; done < <(
  awk -F'\t' 'NR>1 && $3!=""{print $2}' "$MAN"
) | sort -u > /tmp/.man_tools

missing="$(comm -23 /tmp/.man_tools /tmp/.rdm_tools || true)"
rc=0
if [ -n "$missing" ]; then
  echo "✗ In tools.tsv but NOT documented in README catalog:"
  echo "$missing" | sed 's/^/    /'
  rc=1
fi
[ "$rc" -eq 0 ] && echo "✓ manifest and README catalog are in sync ($(wc -l < /tmp/.man_tools) tools)"
rm -f /tmp/.rdm_tools /tmp/.man_tools
exit "$rc"
