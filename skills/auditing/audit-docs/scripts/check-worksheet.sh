#!/usr/bin/env bash
# Mechanical completeness gate: is every claim in the worksheet(s) answered?
#
# Usage: check-worksheet.sh <audit-dir> [--slice Sxx] [--close]
#
# A block is answered when 'verdict:' is OK, WRONG or REVIEW. WRONG and REVIEW also need 'evidence:'.
# Without --slice it prints a table for all slices. With --close, a complete slice is marked done; an
# incomplete one is listed with its first unanswered blocks and the script exits 1.
set -u
audit="${1:?usage: check-worksheet.sh <audit-dir> [--slice Sxx] [--close]}"
shift
only=""; close=0
while [ $# -gt 0 ]; do
  case "$1" in
    --slice) only="${2:?}"; shift 2 ;;
    --close) close=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

stats() { # stats <worksheet> -> "total answered wrong review missing noevidence | first missing ids"
  awk '
    function finish(   v) {
      if (id == "") return
      total++; v = tolower(verdict)
      if (v == "ok") answered++
      else if (v == "wrong") { answered++; wrong++; if (evidence == "") noev++ }
      else if (v == "review") { answered++; review++; if (evidence == "") noev++ }
      else { missing++; if (nm < 5) { m[++nm] = id } }
    }
    /^### C[0-9]+/ { finish(); id = $2; verdict = ""; evidence = ""; next }
    /^## Other findings/ { finish(); id = ""; next }
    /^verdict:/ { sub(/^verdict:[ \t]*/, ""); gsub(/[ \t]+$/, ""); verdict = $0; next }
    /^evidence:/ { sub(/^evidence:[ \t]*/, ""); gsub(/[ \t]+$/, ""); evidence = $0; next }
    END { finish(); ids = ""; for (i = 1; i <= nm; i++) ids = ids " " m[i]
          printf "%d %d %d %d %d %d |%s\n", total, answered, wrong, review, missing, noev, ids }' "$1"
}

rc=0
printf "%-7s %-6s %7s %9s %6s %7s %8s %11s\n" slice status claims answered wrong review missing noevidence
for d in "$audit"/slices/*/; do
  s=$(basename "$d")
  [ -z "$only" ] || [ "$only" = "$s" ] || continue
  out=$(stats "${d}worksheet.md")
  nums=${out%%|*}; ids=${out#*|}
  set -- $nums
  total=$1; answered=$2; wrong=$3; review=$4; missing=$5; noev=$6
  status=$(cat "${d}STATUS" 2>/dev/null)
  complete=0
  [ "$missing" -eq 0 ] && [ "$noev" -eq 0 ] && complete=1
  if [ "$close" -eq 1 ] && [ -n "$only" ]; then
    if [ "$complete" -eq 1 ]; then echo done > "${d}STATUS"; rmdir "${d}.lock" 2>/dev/null; status=done
    else rc=1; fi
  fi
  printf "%-7s %-6s %7s %9s %6s %7s %8s %11s\n" "$s" "$status" "$total" "$answered" "$wrong" "$review" "$missing" "$noev"
  if [ "$close" -eq 1 ] && [ -n "$only" ] && [ "$complete" -eq 0 ]; then
    echo "NOT COMPLETE: unanswered blocks (first 5):$ids; WRONG/REVIEW rows without evidence: $noev" >&2
  fi
done
exit $rc
