#!/usr/bin/env bash
# Find every place a given sentence/wording appears in the docs tree.
#
# Usage: claim-sweep.sh "<fixed string>" <docs-root> [excluded-dir-name ...]
#   e.g. claim-sweep.sh "201 Created" etc/docs messy-docs
#        claim-sweep.sh "next cron" etc/docs
#
# Run it for EVERY false claim you find or fix. A correction that only reaches the place where the
# claim was spotted leaves the same wrong sentence alive in other docs. A finding is closed only when
# the sweep returns nothing wrong. Case-insensitive, fixed-string match, one hit per line.
set -u
phrase="${1:?usage: claim-sweep.sh \"<fixed string>\" <docs-root> [excluded-dir-name ...]}"
root="${2:?usage: claim-sweep.sh \"<fixed string>\" <docs-root> [excluded-dir-name ...]}"
shift 2
args=(-rniF --include='*.md')
for ex in "$@"; do args+=(--exclude-dir="$ex"); done
grep "${args[@]}" -- "$phrase" "$root" | cut -c1-220
