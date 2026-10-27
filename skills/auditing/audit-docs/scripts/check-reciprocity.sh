#!/usr/bin/env bash
# Find traceability edges that exist at only one end.
#
# Usage: check-reciprocity.sh <docs-root> [excluded-dir-name ...]
#
# Rule docs are files named BR-*.md or INV-*.md anywhere under <docs-root>.
# Only the docs that CARRY traceability sections are checked: those under entities/, flows/,
# domain-services/ and value-objects/ (override with REC_DIRS="dir1 dir2 ..."). Journeys, personas,
# READMEs, deferred decisions and anything under working-on/ cite rules informally by design.
#
# Reports:
#   1. a doc links to a rule, but the rule doc never mentions that doc
#   2. a rule doc links to a doc, but that doc never mentions the rule id
# Every hit must be JUDGED, not just fixed: it is either a missing edge (add it) or a loose
# "related" mention (leave the edge out, and make the prose say it is not enforced there).
set -u
root="${1:?usage: check-reciprocity.sh <docs-root> [excluded-dir-name ...]}"
shift
dirs="${REC_DIRS:-entities flows domain-services value-objects}"
find_args=("$root" -type f -name '*.md' -not -path '*/working-on/*')
for ex in "$@"; do find_args+=(-not -path "*/$ex/*"); done

resolve() { # resolve <dir> <relative link> -> absolute path, empty if missing
  (cd "$1" 2>/dev/null && cd "$(dirname "$2")" 2>/dev/null && [ -f "$(basename "$2")" ] && echo "$PWD/$(basename "$2")")
}
is_rule() { case "$(basename "$1")" in BR-*.md | INV-*.md) return 0 ;; *) return 1 ;; esac; }
in_scope() { # carries traceability sections?
  for d in $dirs; do case "$1" in */$d/*) return 0 ;; esac; done
  return 1
}
links_in() { awk '/^[[:space:]]*```/{fence=!fence; next} !fence' "$1" | grep -o '\]([^)#]*\.md' | sed 's/^](//' | sort -u; }

echo "== doc cites rule, rule does not link back:"
while IFS= read -r f; do
  is_rule "$f" && continue
  in_scope "$f" || continue
  d=$(dirname "$f")
  while IFS= read -r l; do
    case "$(basename "$l")" in BR-*.md | INV-*.md) ;; *) continue ;; esac
    r=$(resolve "$d" "$l") || continue
    [ -n "$r" ] || continue
    grep -q "$(basename "$f")" "$r" || echo "  $(basename "$f") -> $(basename "$r")"
  done < <(links_in "$f")
done < <(find "${find_args[@]}" | sort)

echo "== rule cites doc, doc does not mention the rule id:"
while IFS= read -r r; do
  is_rule "$r" || continue
  id=$(basename "$r" | grep -o '^\(BR\|INV\)-[0-9]*')
  d=$(dirname "$r")
  while IFS= read -r l; do
    is_rule "$l" && continue
    t=$(resolve "$d" "$l") || continue
    [ -n "$t" ] || continue
    in_scope "$t" || continue
    grep -q "$id" "$t" || echo "  $id -> $(basename "$t")"
  done < <(links_in "$r")
done < <(find "${find_args[@]}" | sort)
