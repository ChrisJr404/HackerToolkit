#!/usr/bin/env bash
# Regenerate the README Table of Contents from the headings inside the catalog
# block, with correct GitHub anchors (including the -1/-2 suffixes GitHub adds
# to duplicate headings). Idempotent: running twice produces no diff.
#
#   #   -> - [x](#a)        (top level)
#   ##  ->   * [x](#a)
#   ### ->     + [x](#a)
#
# Markers expected in README.md:
#   <!-- BEGIN:TOC --> ...generated... <!-- END:TOC -->
#   <!-- BEGIN:CATALOG --> ...headings sourced from here... <!-- END:CATALOG -->
set -euo pipefail
README="${1:-$(dirname "$0")/../README.md}"
tmp="$(mktemp)"

awk '
  function slug(s,   r) {
    r = tolower(s)
    gsub(/[^a-z0-9 _-]/, "", r)   # GitHub drops punctuation/emoji/&/()/./:
    gsub(/ /, "-", r)             # spaces -> hyphens (not collapsed)
    return r
  }
  # Pass 1: collect catalog headings in document order.
  FNR==NR {
    if ($0 ~ /<!-- BEGIN:CATALOG -->/) incat=1
    else if ($0 ~ /<!-- END:CATALOG -->/) incat=0
    else if (incat && $0 ~ /^#{1,3} /) heads[nh++]=$0
    next
  }
  # Pass 2: stream the file, swapping the TOC body for a freshly built one.
  {
    if ($0 ~ /<!-- BEGIN:TOC -->/) { print; build(); intoc=1; next }
    if ($0 ~ /<!-- END:TOC -->/)   { intoc=0; print; next }
    if (intoc) next
    print
  }
  function build(   i,line,indent,bullet,text,a,n) {
    delete seen
    for (i=0;i<nh;i++) {
      line=heads[i]
      if (line ~ /^### /)     { indent="    "; bullet="+"; text=substr(line,5) }
      else if (line ~ /^## /) { indent="  ";   bullet="*"; text=substr(line,4) }
      else                    { indent="";     bullet="-"; text=substr(line,3) }
      sub(/[ \t]+$/,"",text)
      a=slug(text)
      if (a in seen) { n=seen[a]++; a=a"-"n } else { seen[a]=1 }
      printf "%s%s [%s](#%s)\n", indent, bullet, text, a
    }
  }
' "$README" "$README" > "$tmp"
mv "$tmp" "$README"
echo "TOC regenerated in $README"
