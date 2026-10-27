#!/usr/bin/env bash
# Report relative markdown links whose target does not exist.
#
# Usage: check-links.sh <docs-root> [excluded-dir-name ...]
#   e.g. check-links.sh etc/docs messy-docs
#
# - Scans EVERY *.md under <docs-root> (journeys, proposals, architecture, ... not just flows/entities).
# - Ignores fenced code blocks, http(s)/mailto links and in-page anchors.
# - Prints "<file> -> <target>" per broken link; exit code 1 if any, 0 if none.
set -u
root="${1:?usage: check-links.sh <docs-root> [excluded-dir-name ...]}"
shift
find_args=("$root" -type f -name '*.md')
for ex in "$@"; do find_args+=(-not -path "*/$ex/*"); done

out=$(
  while IFS= read -r f; do
    d=$(dirname "$f")
    awk '/^[[:space:]]*```/{fence=!fence; next} !fence' "$f" |
      grep -o '\]([^)]*)' |
      sed 's/^](//; s/)$//; s/[[:space:]].*$//; s/#.*$//' |
      grep -v -e '^$' -e '^https\?:' -e '^mailto:' |
      sort -u |
      while IFS= read -r l; do
        [ -e "$d/$l" ] || echo "$f -> $l"
      done
  done < <(find "${find_args[@]}" | sort)
)

if [ -n "$out" ]; then
  echo "$out"
  echo "broken links: $(echo "$out" | wc -l | tr -d ' ')" >&2
  exit 1
fi
echo "broken links: 0" >&2
