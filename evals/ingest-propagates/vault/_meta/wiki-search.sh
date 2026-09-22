#!/bin/sh
# wiki-search.sh — the searches an LLM wiki's skills run (llm-wiki plugin).
# Lives at _meta/wiki-search.sh in the vault. Run it instead of writing the greps by hand:
# it searches exactly the page set the skills define, so ingest, query and lint always agree.
#
#   sh _meta/wiki-search.sh find <name>                    where a page name resolves to
#   sh _meta/wiki-search.sh names                          every page name in the vault
#   sh _meta/wiki-search.sh search <term> [term...]        first-step search over the page set
#   sh _meta/wiki-search.sh backlinks <name> [alias...]    every page that links that page
#   sh _meta/wiki-search.sh cites [-a alias]... <name> <file>...  does each page's BODY link it?
#   sh _meta/wiki-search.sh pending [term...]              what is waiting in raw/inbox
#
# The page set is every .md in the vault except raw/, outputs/, _meta/ and dotfolders.
# Matching ignores case and takes every pattern literally, so dots and brackets need no escaping.
# Paths print from the vault root, and file arguments are read from there — not from your cwd.

cd "$(dirname "$0")/.." || exit 2
cmd=${1:-help}
[ $# -gt 0 ] && shift

# The page set. No --include/--exclude-dir: busybox grep has neither.
pages() {
  find . -name '*.md' -not -path './raw/*' -not -path './outputs/*' \
         -not -path './_meta/*' -not -path './.*/*' 2>/dev/null
}

# grep the page set with the -e patterns in "$@"; prints matching paths.
# /dev/null keeps grep off stdin when the page set is empty.
grep_pages() {
  pages | tr '\n' '\0' | xargs -0 grep -liF "$@" -- /dev/null 2>/dev/null | sort -u
}

# NAMES holds one page name per line (the page, then its aliases).
cites_one() {
  f=$1
  set --
  while IFS= read -r n; do
    [ -n "$n" ] || continue
    set -- "$@" -e "[[$n]]" -e "[[$n|" -e "[[$n\\|" -e "[[$n#" \
                -e "/$n.md)" -e "($n.md)" -e "/$n.md#" -e "($n.md#"
  done <<EOF
$NAMES
EOF
  awk 'NR == 1 { sub(/^\357\273\277/, "") }
       { sub(/\r$/, "") }
       NR == 1 && /^---[[:space:]]*$/ { fm = 1; next }
       fm { if ($0 ~ /^---[[:space:]]*$/) fm = 0; next }
       /^[[:space:]]*(```|~~~)/ { code = !code; next }
       code { next }
       { gsub(/`[^`]*`/, ""); print }' "$f" | grep -qiF "$@"
}

case $cmd in
find)
  [ $# -eq 1 ] || { echo "usage: find <name>"; exit 2; }
  n=$(printf '%s' "$1" | tr 'A-Z' 'a-z')
  found=0
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    b=${f##*/}; b=${b%.md}
    [ "$(printf '%s' "$b" | tr 'A-Z' 'a-z')" = "$n" ] || continue
    printf 'file: %s\n' "$f"; found=$((found + 1))
  done <<EOF
$(pages)
EOF
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    awk -v n="$n" '
      NR == 1 && /^---[[:space:]]*$/ { fm = 1; next }
      fm && /^---[[:space:]]*$/ { exit }
      fm {
        l = tolower($0)
        if ($0 ~ /^aliases:/) { ina = 1; if (index(l, n)) { hit = 1; exit }; next }
        if (ina && $0 ~ /^[[:space:]]*-/) { if (index(l, n)) { hit = 1; exit }; next }
        if ($0 ~ /^[A-Za-z_]+:/) ina = 0
      }
      END { if (hit) print "alias?: " FILENAME }' "$f"
  done <<EOF
$(pages)
EOF
  [ "$found" -gt 1 ] && printf 'AMBIGUOUS: %s files share this name — report it and write to neither\n' "$found"
  [ "$found" -eq 0 ] && printf 'NO PAGE: %s — any alias? line above is a substring match; check it before creating one\n' "$1"
  exit 0
  ;;
names)
  pages | sed 's#.*/##; s/\.md$//' | sort
  ;;
search)
  [ $# -ge 1 ] || { echo "usage: search <term> [term...]"; exit 2; }
  i=$#
  while [ "$i" -gt 0 ]; do t=$1; shift; set -- "$@" -e "$t"; i=$((i - 1)); done
  grep_pages "$@"
  ;;
backlinks)
  [ $# -ge 1 ] || { echo "usage: backlinks <name> [alias...]"; exit 2; }
  i=$#
  while [ "$i" -gt 0 ]; do
    n=$1; shift
    set -- "$@" -e "[[$n]]" -e "[[$n|" -e "[[$n\\|" -e "[[$n#" \
                -e "/$n.md)" -e "($n.md)" -e "/$n.md#" -e "($n.md#"
    i=$((i - 1))
  done
  grep_pages "$@"
  ;;
cites)
  NAMES=""
  while [ $# -ge 2 ] && [ "$1" = "-a" ]; do NAMES="$NAMES$2
"; shift 2; done
  [ $# -ge 2 ] || { echo "usage: cites [-a alias]... <name> <file>..."; exit 2; }
  NAMES="$1
$NAMES"
  shift
  for f in "$@"; do
    if [ ! -f "$f" ]; then printf 'MISSING: %s\n' "$f"
    elif cites_one "$f"; then printf 'cited: %s\n' "$f"
    else printf 'NOT CITED: %s\n' "$f"
    fi
  done
  ;;
pending)
  [ -d raw/inbox ] || { echo "pending: 0 — no raw/inbox"; exit 0; }
  total=0; hits=0
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    b=${f##*/}
    case $b in .*|README.md) continue ;; esac
    if [ ! -s "$f" ]; then [ $# -ge 1 ] || printf 'empty: %s\n' "$f"; continue; fi
    total=$((total + 1))
    if [ $# -ge 1 ]; then
      m=0
      for t in "$@"; do
        if printf '%s' "$b" | grep -qiF -e "$t" || grep -qiF -e "$t" "$f" 2>/dev/null; then m=1; break; fi
      done
      [ "$m" -eq 1 ] || continue
    fi
    printf '%s\n' "$f"; hits=$((hits + 1))
  done <<EOF
$(find raw/inbox -type f 2>/dev/null | sort)
EOF
  if [ $# -ge 1 ]; then printf 'pending: %s matching of %s\n' "$hits" "$total"
  else printf 'pending: %s\n' "$total"; fi
  ;;
*) sed -n '6,11p' "$0"; exit 2 ;;
esac
