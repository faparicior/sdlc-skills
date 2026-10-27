#!/usr/bin/env bash
# Merge all slice worksheets into one result, and run the checks that need the WHOLE tree.
#
# Usage: merge.sh <audit-dir> <docs-root> [--force] [excluded-dir-name ...]
#
# Refuses to run while any slice is not done (use --force for a partial, clearly marked merge).
# Writes into <audit-dir>:
#   wrong-claims.md    every WRONG block, with its evidence and the sweep wording
#   review-queue.md    every REVIEW block: the rows for a human or a stronger model
#   other-findings.md  the free-form "Other findings" of every slice
#   sweep-results.md   for every sweep wording, every place it appears in the whole tree (JUDGE each hit)
#   links.txt, reciprocity.txt, mermaid.txt   whole-tree mechanical checks
#   merge-report.md    totals and pointers
set -u
SD="$(cd "$(dirname "$0")" && pwd)"
audit="${1:?usage: merge.sh <audit-dir> <docs-root> [--force] [excluded-dir-name ...]}"
root="${2:?usage: merge.sh <audit-dir> <docs-root> [--force] [excluded-dir-name ...]}"
shift 2
force=0; excl=()
for a in "$@"; do
  if [ "$a" = "--force" ]; then force=1; else excl+=("$a"); fi
done

pending=$(for d in "$audit"/slices/*/; do [ "$(cat "${d}STATUS" 2>/dev/null)" = "done" ] || basename "$d"; done)
if [ -n "$pending" ] && [ "$force" -eq 0 ]; then
  echo "slices not done: $(echo $pending)" >&2
  echo "finish them (check-worksheet.sh ... --close) or merge partially with --force" >&2
  exit 1
fi

W="$audit/wrong-claims.md"; R="$audit/review-queue.md"; O="$audit/other-findings.md"
: > "$W"; : > "$R"; : > "$O"; : > "$audit/sweeps.txt"

for d in "$audit"/slices/*/; do
  s=$(basename "$d")
  awk -v slice="$s" -v wf="$W" -v rf="$R" -v sf="$audit/sweeps.txt" '
    function finish(   v, line) {
      if (id == "") return
      v = tolower(verdict)
      line = "- [" slice "/" id "] " loc "\n  - claim: " text "\n  - evidence: " evidence
      if (v == "wrong") { print line "\n  - sweep: " sweep >> wf; if (sweep != "") print sweep >> sf }
      else if (v == "review") { print line >> rf }
    }
    /^### C[0-9]+/ { finish(); id = $2; split($0, h, " \\| "); loc = h[3]; verdict = ""; evidence = ""; sweep = ""; text = ""; next }
    /^## Other findings/ { finish(); id = ""; other = 1; next }
    other { print $0 > "/dev/null"; next }
    /^> / { text = substr($0, 3); next }
    /^verdict:/ { sub(/^verdict:[ \t]*/, ""); gsub(/[ \t]+$/, ""); verdict = $0; next }
    /^evidence:/ { sub(/^evidence:[ \t]*/, ""); evidence = $0; next }
    /^sweep:/ { sub(/^sweep:[ \t]*/, ""); gsub(/[ \t]+$/, ""); sweep = $0; next }
    END { finish() }' "${d}worksheet.md"
  awk -v slice="$s" '/^## Other findings/ { on = 1; next } on && NF { if (!hdr) { print "### " slice; hdr = 1 } print }' "${d}worksheet.md" >> "$O"
done

# Whole-tree sweep for every wrong wording.
{
  echo "# Sweep results"
  echo
  echo "Each hit is a CANDIDATE. Judge it: the same wording can be right in a doc that describes a different mechanism."
  echo
  sort -u "$audit/sweeps.txt" | while IFS= read -r phrase; do
    [ -n "$phrase" ] || continue
    echo "## \`$phrase\`"
    "$SD/claim-sweep.sh" "$phrase" "$root" ${excl[@]+"${excl[@]}"} | sed 's/^/- /' | head -60
    echo
  done
} > "$audit/sweep-results.md"

# Whole-tree mechanical checks.
"$SD/check-links.sh" "$root" ${excl[@]+"${excl[@]}"} > "$audit/links.txt" 2>&1
"$SD/check-reciprocity.sh" "$root" ${excl[@]+"${excl[@]}"} > "$audit/reciprocity.txt" 2>&1
files=$(grep -rl '```mermaid' "$root" --include='*.md' 2>/dev/null)
if [ -n "$files" ]; then
  # shellcheck disable=SC2086
  node "$SD/check-mermaid.mjs" $files > "$audit/mermaid.txt" 2>&1 || true
else
  echo "no mermaid blocks" > "$audit/mermaid.txt"
fi

nw=$(grep -c '^- \[' "$W"); nr=$(grep -c '^- \[' "$R"); ns=$(sort -u "$audit/sweeps.txt" | grep -c .)
nl=$(grep -c ' -> ' "$audit/links.txt")
{
  echo "# Merge report"
  echo
  [ -n "$pending" ] && echo "**PARTIAL MERGE** — slices not done: $(echo $pending)" && echo
  echo "| Item | Count |"
  echo "| --- | ---: |"
  echo "| WRONG claims | $nw |"
  echo "| REVIEW rows (need a human or a stronger model) | $nr |"
  echo "| Distinct wordings swept over the whole tree | $ns |"
  echo "| Broken links | $nl |"
  echo
  echo "Files: wrong-claims.md · review-queue.md · other-findings.md · sweep-results.md · links.txt · reciprocity.txt · mermaid.txt"
  echo
  echo "## Slice table"
  echo
  echo '```'
  "$SD/check-worksheet.sh" "$audit"
  echo '```'
} > "$audit/merge-report.md"

cat "$audit/merge-report.md"
