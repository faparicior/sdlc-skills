#!/usr/bin/env bash
# List the checkable claims in the docs, grouped by kind, so none is skipped.
#
# Usage: claim-inventory.sh <docs-root> [excluded-dir-name ...]
#
# Output: "<kind> | <file>:<line> | <text>". This is a CHECKLIST, not a verdict: every line must be
# verified against the code (or against another doc) and either confirmed or reported. It is
# deliberately noisy; the point is that the audit covers every sentence of these kinds instead of
# sampling. See references/claim-kinds.md for what to compare each kind with.
#
# Kinds: http-status, lifecycle, timing, absolute, metric, contract, time-window, ordering, endpoint,
#        event, schema-name, flag-config. The 'ordering' kind only finds sentences that SAY something
#        runs before/after something else. The order of numbered steps in walkthrough tables and
#        diagrams still needs a human read against the code.
# Slicing: <docs-root> may be any sub-folder, so each sub-agent can take one folder's inventory.
#
# ── TUNE HERE ────────────────────────────────────────────────────────────────
# The patterns below are deliberately broad, but two carry per-product tuning:
#   • event  — domain events are "<Noun><PastTenseVerb>". The first 'event' line is the
#     suffix allowlist (extend it with your domain's verbs; it exists for irregulars
#     like Paid/Sent); the second line is the generic CamelCase fallback.
#   • flag-config / schema-name — if your docs cite config keys or index names in a
#     distinctive format, add a scan line for it.
# Adding a KIND (not a word) means adding both a 'scan' line here and a row in
# references/claim-kinds.md. Under-detection is the only silent failure mode, so when
# in doubt add a broader pattern: the inventory is a noisy checklist by design and
# every line is judged before it becomes a finding.
# ─────────────────────────────────────────────────────────────────────────────
set -u
root="${1:?usage: claim-inventory.sh <docs-root> [excluded-dir-name ...]}"
shift
ex_args=()
for ex in "$@"; do ex_args+=(--exclude-dir="$ex"); done

scan() { # scan <kind> <ERE> [-i]  (case-insensitive when a third argument is given)
  local flags="-rnE"
  [ "${3:-}" = "-i" ] && flags="-rniE"
  # ${ex_args[@]+...} keeps an empty array valid under 'set -u' on bash 3.2 (macOS)
  grep "$flags" --include='*.md' ${ex_args[@]+"${ex_args[@]}"} -- "$2" "$root" 2>/dev/null |
    sed -E "s|^([^:]+):([0-9]+):|$1 \| \1:\2 \| |" | cut -c1-230
}

scan http-status '(\b(200 OK|201 Created|202 Accepted|204 No Content|400 Bad Request|401 Unauthorized|403 Forbidden|404 Not Found|409 Conflict|410 Gone|500 Internal|502|503 Service Unavailable)\b|(returns?|responds?|rejected with|status) `?(200|201|202|204|400|401|403|404|409|410|500|503)\b)' -i
scan lifecycle  '(status:?\*{0,2}.*(planned|draft|proposed|pending|not started|in progress|implemented locally|partially|parked|shipped|complete|done))|not yet (implemented|built)|to be (built|implemented)|pending (merge|release|deploy)|\(planned\)|planned —' -i
scan timing     '(next cron|until the next|after the next|nightly|every [0-9]+ (min|hour|day)|`[0-9*/,-]+ [0-9*/,-]+ [0-9*/,-]+ [0-9*/,?-]+ [0-9*/,-]+ ?[0-9*/,?-]*`)' -i
scan absolute   '(\bpermanently\b|\bsilently\b|\bnever\b|\balways\b|no [a-z]* ?events?\b|no (email|delivery|record)s?\b|nothing is (sent|published|saved))' -i
scan metric     '(\bmetrics?\b|\bcounters?\b|\balerts?\b|\bdashboards?\b|\bmonitor(ing|ed)?\b|observab(le|ility))' -i
scan contract   '(\boptional\b|\bnullable\b|\bmandatory\b|may be omitted|can be omitted|defaults? to|default value|if (absent|missing|omitted|not (provided|sent))|today.s date|\bnot required\b)' -i
scan time-window '([a-z]{2,}At\b|[a-z]+_at\b|same (utc )?(calendar )?day|calendar day|within [0-9]+ (days?|hours?|months?)|last [0-9]+ (days?|months?)|since the|window)' -i
scan ordering   '(fires first|evaluated first|runs first|checked first|runs (before|after)|is (checked|run|called|evaluated|applied) (first|before|after)|happens (before|after)|(before|after) (the|any|both|each|a|an) [a-z]+ (guard|check|filter|gate|step|save|call)|about to proceed)' -i
scan endpoint   '\b(GET|POST|PUT|PATCH|DELETE) /[A-Za-z0-9/{}_.:-]+'
scan event      '\b[A-Z][A-Za-z]+(Created|Updated|Deleted|Removed|Assigned|Granted|Mandated|Skipped|Cancelled|Canceled|Purchased|Published|Delivered|Shipped|Registered|Approved|Rejected|Submitted|Accepted|Confirmed|Completed|Failed|Expired|Renewed|Suspended|Activated|Closed|Reopened|Merged|Invited|Linked|Unlinked|Scheduled|Rescheduled|Paused|Resumed|Archived|Restored|Locked|Unlocked|Paid|Refunded|Sent|Received|Imported|Exported|Migrated|Revoked|Renamed|Cloned|Escalated|Resolved|Replied|Notified|Retried|Emitted|Dispatched|Consumed|Queued|Enqueued|Committed|Synced|Transferred|Converted|Contracted|Reserved|Released|Captured|Charged|Settled|Credited|Debited)\b'
scan event      '\b[A-Z][a-z]+[A-Z][A-Za-z]*ed\b'
scan schema-name '(table|column|index|constraint|migration)[^|.]{0,50}`[a-zA-Z0-9_]+`' -i
scan flag-config '(flag|feature flag|property|setting|config(uration)?|env( var)?|cron)[^|.]{0,60}`[^`]+`' -i
