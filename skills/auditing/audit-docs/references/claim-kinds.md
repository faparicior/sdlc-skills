# Claim Kinds: What To Compare Each One With

`scripts/claim-inventory.sh` lists the sentences that make a checkable claim, grouped by kind. Every line
it prints must be answered: confirmed, wrong, or "needs manual review". This table says what the truth
source is for each kind and where docs usually drift.

| Kind | Typical wording | Compare with | Usual drift |
| --- | --- | --- | --- |
| `http-status` | "returns 201 Created", "204 No Content", "409", "400 `CODE`" | The controller **and** its exception handler or advice. Read what the code returns on normal completion (e.g. `noContent()`), not what a nearby doc says | Rule and invariant docs keep the status of an earlier design (201 vs 204). Error statuses the code maps (e.g. 503 for an infrastructure failure) are never documented |
| `lifecycle` | "Status: Planned", "Draft", "pending merge/deploy", "(planned)", "not yet implemented" | The code (does the class, column, flag or config exist?), the parent proposal's Status and ship date, and the git history | A doc freezes at the moment it was written. Journeys, proposals and feature specs keep saying "planned" after shipping, and sibling docs of one change disagree |
| `timing` | "next cron", "until the next run", "nightly", a cron expression | The use case that performs the write: is it a direct write or does it wait for a task? Then the task's schedule in config | An index is written directly by the request, while docs still say "wait for the cron". Careful: the opposite also exists, so judge each hit |
| `absolute` | "permanently", "never", "always", "silently", "no events", "no email", "nothing is saved" | Trace the **whole** path, including what happens after the branch (events flushed and published after a `when`, fallbacks such as resolving a location from coordinates, recovery endpoints) | Negative claims are the most often false. "No events" is wrong when a creation event is published regardless of delivery |
| `ordering` | "AGENT guard fires first", "after the AGENT guard", "runs before the duplicate check", step 8 then step 9 | The order of the statements in the use case. Read the method top to bottom and number what happens, including early returns | The doc table lists guards in design order while the code evaluates them in another (identity check before consent, AGENT before duplicate) |
| `endpoint` | `POST /v1/...` | The route annotation in the controller | Renamed or never-existing routes (e.g. an old admin route) |
| `event` | "X is published", "triggers the email" | Where it is queued (domain), where it is published, **which consumer reacts** | A creation event confused with the assignment event that actually triggers the notification |
| `schema-name` | table, column, index, constraint, migration names | Flyway migrations (later renames win) and the repository SQL | Names inferred from class names (`xxx_contracts`) instead of the real table |
| `flag-config` | feature flags, `window-days`, caps, buffers | `application.yml`, the flag class and the use case that reads it | Values changed in config, docs keep the old number |

## How to verify well

1. **Open the code, not the neighbouring doc.** Two docs agreeing with each other proves nothing.
2. **Cite file and line** for every confirmation and every contradiction.
3. **Negative claims need the full trace.** Search for the thing the doc says does not happen.
4. **Claims inside diagrams, tables and Gherkin scenarios count.** They are the ones copied around.
5. **Same claim, many places.** When a claim is wrong, run `scripts/claim-sweep.sh` with its exact wording
   and two or three paraphrases. Judge every hit: some docs describe a different mechanism and are right.
6. **Ranges and ordering.** "Step 8 before step 9", "A runs before B": check the order in the code.
