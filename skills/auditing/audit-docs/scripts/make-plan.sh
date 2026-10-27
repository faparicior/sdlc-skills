#!/usr/bin/env bash
# Build an audit workspace: the docs cut into small slices, each with a claim worksheet.
#
# Usage: make-plan.sh <docs-root> <audit-dir> [--max-docs N] [--max-claims N] [excluded-dir-name ...]
#   e.g. make-plan.sh etc/docs /tmp/audit-run --max-docs 3 --max-claims 100 messy-docs
#
# Defaults suit a small local model (3 docs / 100 claims per slice). Raise them for a stronger model.
# Put <audit-dir> OUTSIDE the docs tree. The plan lives on disk, so any worker (or two workers in
# parallel) can pick up the next slice, and a crash or context loss costs nothing.
# A single doc with more than --max-claims claims is split into parts (S12-1, S12-2, ...): every part
# lists the same doc to read, and covers its own range of the claims.
#
# Creates:
#   <audit-dir>/plan.md                      summary table of slices
#   <audit-dir>/slices/Sxx[-n]/{files.txt,counterparts.txt,inventory.txt,worksheet.md,STATUS}
set -u
SD="$(cd "$(dirname "$0")" && pwd)"
usage() { echo "usage: make-plan.sh <docs-root> <audit-dir> [--max-docs N] [--max-claims N] [excluded-dir-name ...]" >&2; exit 2; }
root="${1:-}"; audit="${2:-}"
[ -n "$root" ] && [ -n "$audit" ] || usage
shift 2
max_docs=3; max_claims=100; excl=()
while [ $# -gt 0 ]; do
  case "$1" in
    --max-docs) max_docs="${2:?}"; shift 2 ;;
    --max-claims) max_claims="${2:?}"; shift 2 ;;
    *) excl+=("$1"); shift ;;
  esac
done
[ -d "$root" ] || { echo "not a directory: $root" >&2; exit 2; }
root="${root%/}"
if [ -e "$audit/plan.md" ]; then echo "audit dir already has a plan: $audit (delete it or pick another)" >&2; exit 2; fi
mkdir -p "$audit/slices" || exit 2

# 1. Claim inventory, one entry per location (a line can match several kinds).
"$SD/claim-inventory.sh" "$root" ${excl[@]+"${excl[@]}"} |
  awk -F' \\| ' '
    { kind=$1; loc=$2; text=$3; for (i=4;i<=NF;i++) text=text " | " $i
      if (!(loc in seen)) { seen[loc]=1; order[++n]=loc; kinds[loc]=kind; txt[loc]=text }
      else if (index("," kinds[loc] ",", "," kind ",")==0) kinds[loc]=kinds[loc] "," kind }
    END { for (i=1;i<=n;i++) { l=order[i]; print kinds[l] " | " l " | " txt[l] } }' > "$audit/inventory.txt"

# 2. Every markdown doc, sorted so neighbours in the tree stay together.
find_args=("$root" -type f -name '*.md')
for ex in ${excl[@]+"${excl[@]}"}; do find_args+=(-not -path "*/$ex/*"); done
find "${find_args[@]}" | sort > "$audit/docs.txt"

# 3. Claims per doc.
awk -F' \\| ' '{ split($2, a, ":"); c[a[1]]++ } END { for (f in c) print f "\t" c[f] }' "$audit/inventory.txt" > "$audit/counts.tsv"

# 4. Greedy slicing: a new slice starts at a folder-group boundary or when a limit would be exceeded.
awk -F'\t' -v maxd="$max_docs" -v maxc="$max_claims" -v root="$root" '
  FNR==NR { cnt[$1]=$2; next }
  { doc=$0; rel=substr(doc, length(root)+2); n=split(rel, p, "/")
    grp = (n>=3) ? p[1] "/" p[2] : (n==2 ? p[1] : ".")
    c = (doc in cnt) ? cnt[doc] : 0
    if (slice==0 || grp!=curgrp || (nd>0 && (nd+1>maxd || nc+c>maxc))) { slice++; nd=0; nc=0; curgrp=grp }
    nd++; nc+=c; printf "S%02d\t%s\t%s\n", slice, grp, doc }' "$audit/counts.tsv" "$audit/docs.txt" > "$audit/assignment.tsv"

links_of() { # relative .md link targets of a doc, code fences ignored
  awk '/^[[:space:]]*```/{fence=!fence; next} !fence' "$1" | grep -o '\]([^)#]*\.md' | sed 's/^](//' | sort -u
}

emit() { # emit <slice-name> <group> <files.txt> <counterparts.txt> <inventory part>
  local name="$1" grp="$2" files="$3" cps="$4" inv="$5" d="$audit/slices/$1"
  mkdir -p "$d"
  cp "$files" "$d/files.txt"; cp "$cps" "$d/counterparts.txt"; cp "$inv" "$d/inventory.txt"
  {
    echo "# Worksheet $name  ($grp)"
    echo
    echo "For EVERY block below, fill 'verdict:' with OK, WRONG or REVIEW."
    echo "- OK: you checked the claim against the code (or the counterpart doc) and it holds."
    echo "- WRONG: it does not hold. 'evidence:' = the code or doc file:line that contradicts it."
    echo "  'sweep:' = the exact wording to search for in the rest of the tree."
    echo "- REVIEW: you could not decide. 'evidence:' = why."
    echo "Read the whole doc(s) in files.txt (a part covers only its range of claims, but the context is the doc)."
    echo "Then add anything the claims do not cover (states, transitions, traceability, doc-against-doc)"
    echo "under '## Other findings' at the end. Run check-worksheet.sh --slice $name --close when done."
    echo
    awk -F' \\| ' '{ text=$3; for (i=4;i<=NF;i++) text=text " | " $i
                    printf "### C%03d | %s | %s\n> %s\nverdict:\nevidence:\nsweep:\n\n", NR, $1, $2, text }' "$d/inventory.txt"
    echo "## Other findings"
    echo
  } > "$d/worksheet.md"
  echo todo > "$d/STATUS"
  echo "| $name | $grp | $(wc -l < "$d/files.txt" | tr -d ' ') | $(wc -l < "$d/inventory.txt" | tr -d ' ') |" >> "$audit/plan.md"
}

{
  echo "# Audit plan"
  echo
  echo "Docs root: \`$root\`  ·  limits per slice: $max_docs docs, $max_claims claims  ·  excluded: ${excl[*]:-none}"
  echo
  echo "| Slice | Group | Docs | Claims |"
  echo "| --- | --- | ---: | ---: |"
} > "$audit/plan.md"

tmp="$audit/.tmp"; mkdir -p "$tmp"
for s in $(cut -f1 "$audit/assignment.tsv" | sort -u); do
  awk -F'\t' -v s="$s" '$1==s { print $3 }' "$audit/assignment.tsv" > "$tmp/files.txt"
  grp=$(awk -F'\t' -v s="$s" '$1==s { print $2; exit }' "$audit/assignment.tsv")
  awk -F' \\| ' 'FNR==NR { f[$0]=1; next } { split($2, a, ":"); if (a[1] in f) print }' "$tmp/files.txt" "$audit/inventory.txt" > "$tmp/inv.txt"

  : > "$tmp/cps.txt"
  while IFS= read -r doc; do
    dir=$(dirname "$doc")
    while IFS= read -r l; do
      t=$(cd "$dir" 2>/dev/null && cd "$(dirname "$l")" 2>/dev/null && [ -f "$(basename "$l")" ] && echo "$PWD/$(basename "$l")")
      [ -n "$t" ] || continue
      rel="$root/${t#"$(cd "$root" && pwd)"/}"
      grep -qxF "$rel" "$tmp/files.txt" || echo "$rel"
    done < <(links_of "$doc")
  done < "$tmp/files.txt" | sort -u > "$tmp/cps.txt"

  nclaims=$(wc -l < "$tmp/inv.txt" | tr -d ' ')
  if [ "$nclaims" -gt "$max_claims" ]; then
    rm -f "$tmp"/part.*
    split -l "$max_claims" -a 2 "$tmp/inv.txt" "$tmp/part."
    k=0
    for p in "$tmp"/part.*; do
      k=$((k + 1))
      emit "$s-$k" "$grp" "$tmp/files.txt" "$tmp/cps.txt" "$p"
    done
  else
    emit "$s" "$grp" "$tmp/files.txt" "$tmp/cps.txt" "$tmp/inv.txt"
  fi
done
rm -rf "$tmp"

n=$(ls "$audit/slices" | wc -l | tr -d ' ')
echo "slices: $n   docs: $(wc -l < "$audit/docs.txt" | tr -d ' ')   claims: $(wc -l < "$audit/inventory.txt" | tr -d ' ')   plan: $audit/plan.md"
