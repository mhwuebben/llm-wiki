#!/bin/sh
# wiki-lock.sh — the vault lock of an LLM wiki (llm-wiki plugin, wiki-setup/references/locking.md).
# Lives at _meta/wiki-lock.sh in the vault; keeps its state in _meta/wiki-lock.md.
#
#   sh _meta/wiki-lock.sh take "<operation>" [minutes]    WON <token> | HELD … | UNREADABLE
#   sh _meta/wiki-lock.sh renew <token> "<progress>" [minutes]   OK | LOST
#   sh _meta/wiki-lock.sh release <token>                  RELEASED | LOST
#   sh _meta/wiki-lock.sh status                           FREE | HELD … | STALE …
#
# A lease lasts 5 minutes unless [minutes] says otherwise (at most 30). A held lease is stale,
# and may be taken over, once it is more than 60 seconds past its expiry.

self=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")
cd "$(dirname "$0")/.." || exit 2
f=_meta/wiki-lock.md
grace=60

now=$(date -u +%s)
iso() { date -u -d "@$1" +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -r "$1" +%Y-%m-%dT%H:%M:%SZ; }
field() { sed -n "s/^$1: //p" "$f" 2>/dev/null | head -n 1; }
lines() { sed -n '/^- /p' "$f" 2>/dev/null; }
mins() { m=${1:-5}; case $m in ''|*[!0-9]*) m=5;; esac; [ "$m" -gt 30 ] && m=30; [ "$m" -lt 1 ] && m=1; printf '%s\n' "$m"; }
free_form() { printf -- '---\nstatus: free\n---\nLast: %s\n' "$1" > "$f"; }
held_form() { # token operation since until progress-lines
  { printf -- '---\nstatus: held\nholder: %s\noperation: %s\nsince: %s\nexpires: %s\nexpires_at: %s\n---\n' \
      "$1" "$2" "$3" "$(iso "$4")" "$4"
    printf '%s\n' "$5" | sed '/^$/d' | tail -n 10; } > "$f"
}

[ -f "$f" ] || free_form "none — created $(iso "$now")"
st=$(field status)
if [ -z "$st" ]; then printf '%s\n' "UNREADABLE — $f is empty or half-written; read it again in a few seconds, and never write over it"; exit 3; fi
holder=$(field holder); op=$(field operation); exp=$(field expires_at); case $exp in ''|*[!0-9]*) exp=0;; esac

case $1 in
take)
  want=$(printf '%s' "${2:-write}" | tr -d '\n\r'); m=$(mins "$3")
  if [ "$st" = held ] && [ "$now" -le $((exp + grace)) ]; then
    printf '%s\n' "HELD by $holder — $op — until $(iso "$exp") — last: $(lines | tail -n 1)"; exit 1
  fi
  rnd=$(od -An -N2 -tx1 /dev/urandom | tr -d ' \n')
  tok="$(printf '%s' "$want" | cut -d' ' -f1 | tr 'A-Z' 'a-z' | tr -cd 'a-z0-9-')-$(date -u +%Y%m%dT%H%M%SZ)-$rnd"
  t=$(iso "$now")
  if [ "$st" = held ]; then
    old="$holder"
    prog=$(printf '%s\n' "$(lines | tail -n 5 | sed 's/^- /- (before) /')" "- $t taken over from $old ($op), expired $(iso "$exp")")
    printf '%s\n' "TAKING OVER a stale lease: $old — $op — expired $(iso "$exp") — last: $(lines | tail -n 1)"
  else
    prog="- $t taken"
  fi
  held_form "$tok" "$want" "$t" $((now + m * 60)) "$prog"
  sleep 5
  if [ "$(field holder)" = "$tok" ]; then printf '%s\n' "WON $tok"; else printf '%s\n' "LOST — another session took it at the same moment: $(field holder)"; exit 1; fi
  ;;
renew)
  tok=$2; m=$(mins "$4")
  if [ "$st" != held ] || [ "$holder" != "$tok" ]; then printf '%s\n' "LOST — held by ${holder:-nobody} ($st); stop writing"; exit 1; fi
  msg=$(printf '%s' "${3:-working}" | tr -d '\n\r')
  held_form "$tok" "$op" "$(field since)" $((now + m * 60)) "$(printf '%s\n' "$(lines)" "- $(iso "$now") $msg")"
  printf '%s\n' "OK until $(iso $((now + m * 60)))"
  ;;
release)
  tok=$2
  if [ "$st" != held ] || [ "$holder" != "$tok" ]; then printf '%s\n' "LOST — held by ${holder:-nobody} ($st); left as it is"; exit 1; fi
  free_form "$tok ($op), released $(iso "$now")"
  printf '%s\n' "RELEASED"
  ;;
status)
  if [ "$st" = free ]; then printf '%s\n' "FREE — $(sed -n 's/^Last: //p' "$f")"
  elif [ "$now" -gt $((exp + grace)) ]; then printf '%s\n' "STALE — $holder — $op — expired $(iso "$exp") — last: $(lines | tail -n 1)"
  else printf '%s\n' "HELD — $holder — $op — until $(iso "$exp") — last: $(lines | tail -n 1)"; fi
  ;;
*) sed -n '5,8p' "$self"; exit 2 ;;
esac
