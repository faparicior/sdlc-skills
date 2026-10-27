#!/usr/bin/env bash
# Claim the next slice that still needs auditing. Safe for two workers in parallel (atomic lock).
#
# Usage: next-slice.sh <audit-dir>
#        next-slice.sh <audit-dir> --release <slice-id>   # give a slice back (crashed or abandoned worker)
set -u
audit="${1:?usage: next-slice.sh <audit-dir> [--release <slice-id>]}"
if [ "${2:-}" = "--release" ]; then
  s="${3:?slice id}"
  rmdir "$audit/slices/$s/.lock" 2>/dev/null
  echo todo > "$audit/slices/$s/STATUS"
  echo "released $s"
  exit 0
fi
for d in "$audit"/slices/*/; do
  [ "$(cat "${d}STATUS" 2>/dev/null)" = "todo" ] || continue
  if mkdir "${d}.lock" 2>/dev/null; then
    echo doing > "${d}STATUS"
    s=$(basename "$d")
    echo "slice:        $s"
    echo "docs to read: ${d}files.txt"
    echo "compare with: ${d}counterparts.txt   (read to compare claims, do not audit)"
    echo "fill in:      ${d}worksheet.md"
    echo "when done:    check-worksheet.sh $audit --slice $s --close"
    exit 0
  fi
done
echo "no todo slice left" >&2
exit 1
