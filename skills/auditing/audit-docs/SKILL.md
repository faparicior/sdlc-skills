---
name: audit-docs
description: >-
  Systematically verify that flow, entity, and business-rule documentation is still aligned with
  the real source code — and produce a drift report. USE THIS SKILL when user mentions: audit docs,
  are docs up to date, docs drift, check documentation, are flows still accurate, docs vs code,
  verify business rules in code, is the entity lifecycle correct, docs health check, documentation
  review, check if docs match, stale docs, or any request to verify whether existing documentation
  matches the implementation. Audits EVERY docs folder (rules, flows, entities, journeys, proposals and
  plans, architecture assessments, deferred decisions, API/UI reference specs), verifies every checkable
  claim sentence by sentence, and runs mechanical sweeps (links, diagrams, claim sweep). Produces a drift
  report per bounded context and folder: ✅ confirmed / ⚠️ stale / ❌ missing / ➕ undocumented —
  without modifying any file.
disable-model-invocation: true
---

# Audit Docs Skill

You are a Technical Auditor for a codebase with living DDD-style documentation — flows, entity
lifecycles, business rules, and invariants. Your job is to systematically compare what each doc
claims against what the code actually does, and produce an actionable drift report.

This skill is **read-only**. It identifies drift; it does not fix it.
Use `/modify-flow` to act on ⚠️ stale or ❌ missing findings that require a code or doc change.

This skill is **language- and framework-agnostic**. Discover paths and conventions fresh each run.

> **Coverage rule.** An audit that reads only flows, entities and rules, or that checks paths and test
> titles but not sentences, misses most real drift: wrong HTTP statuses in rule docs, "next cron" in
> journeys, "Planned" on shipped work, the same false claim surviving in a second document. So this
> skill (1) audits **every** docs folder, (2) verifies **every** checkable claim in prose, tables and
> diagrams instead of a sample, and (3) closes a finding only after a **claim sweep** shows the wrong
> wording is gone everywhere.

---

## Step 0: Discover This Repo's Conventions (Do This First, Every Time)

1. **Docs tree:** List **every** folder under the docs root that contains `.md` files
   (`find <docs root> -name '*.md'`, grouped by folder) and classify each one: bounded-context docs
   (flows, entities, rules, invariants), journeys/personas/inception, proposals/plans/feature specs
   (`working-on`), architecture and assessments, deferred decisions and reminders, reference and
   UI-spec docs, legacy/archive. **All of them are in scope by default.** A folder is skipped only when
   the user excludes it, and the report names it.
2. **Docs index:** Check if there is a top-level index (README, SDLC index, etc.). Use it to find docs
   that are unlisted, or listed but missing. **Never use it to limit the scope.**
3. **Source layout:** Identify language, DDD layers, and naming conventions used in source files.
4. **Build/test commands:** Note the real commands from CLAUDE.md, AGENTS.md, or README (for the
   Recommended Actions section).
5. **Mechanical helpers:** Run these first. They cover the whole docs tree in seconds and their output
   tells you where to look (paths are relative to this skill's folder):

   | Script | Finds |
   | --- | --- |
   | `scripts/check-links.sh <docs root> [excluded-dir ...]` | broken relative links, in every folder |
   | `node scripts/check-mermaid.mjs <files>` | diagrams that do not parse (one-time setup in the script header) |
   | `scripts/check-reciprocity.sh <docs root>` | traceability edges that exist at one end only |
   | `scripts/claim-inventory.sh <docs root>` | every checkable claim, by kind: the checklist for claim verification. Pass a sub-folder as `<docs root>` to get one slice (about 2,400 lines for a whole large tree) |
   | `scripts/claim-sweep.sh "<wording>" <docs root>` | every place a given sentence appears |

   **No scripts?** The scripts make the coverage fast and checkable; they are not what finds the drift,
   the reading is. If one cannot run (no Node, restricted shell), do the same by hand and say so in the
   report. For claims: open `scripts/claim-inventory.sh` (it is just a list of `grep` patterns, one per
   claim kind) and run those greps yourself, or, with no shell at all, **read every doc in the audited
   folders end to end** and write down each sentence of the kinds listed in
   [references/claim-kinds.md](references/claim-kinds.md). For links: `find` + `test -e` on each relative
   target. A mechanical check may be skipped only if the report says
   "Mechanical checks: <name> not run — <reason>".

---

## Scope Detection

Determine scope from the user's request. If not stated, default to **full** and announce it.

| Scope | When | What |
|-------|------|------|
| Full | "audit all docs", "docs health check", no scope given | **Every docs folder** and all doc types: bounded contexts, journeys, proposals/plans, architecture, deferred decisions, reference specs |
| Bounded context | "audit the conference context", "check submission docs" | One context, all doc types |
| Folder | "audit the journeys", "check the working-on docs" | One folder: its doc-type checks plus the cross-cutting checks |
| Doc type | "check all BRs", "verify entity lifecycles" | All contexts, one doc type |
| Single doc | "is this flow still accurate?", pointing at one file | One specific doc |

---

## Execution Plan: One Agent or Sub-Agents

This skill does not start sub-agents by itself. You decide, from the size of the scope, and you must not
trade coverage for speed. Measure first: count the docs and run `claim-inventory.sh <scope>` to count the
claims. A deep audit costs roughly 35,000 tokens and a minute per doc (observed: 4 docs ≈ 55 tool calls
and 150,000 tokens), so one agent cannot cover a large tree without sampling.

| Size of the scope | Mode |
|-------------------|------|
| Up to about 6 docs, or about 250 inventory lines (single doc, one small folder) | **One agent**, whole scope, in one pass |
| More than that, with capable agents that can run in parallel | **Sub-agents**, one per slice, in parallel |
| More than that, with a small or local model, or at most 1–2 agents at once | **Plan mode** (below): slices on disk, a worksheet per slice, scripted gates |

**Slicing.** Aim for at most about 8 docs or 300 inventory lines per slice. Split by folder; split a large
bounded context further by doc type (rules and invariants / entities and services / flows). Never merge
slices to save effort.

**Per slice** use [references/slice-prompt.md](references/slice-prompt.md): the slice's files, its inventory,
and its **counterpart docs** (the flow, rule or proposal docs for the capabilities it mentions).

**Merge (main agent, after all slices return).** This is where whole-tree problems get caught, so do not
skip it:
1. Combine the findings tables per folder and fill the Summary table.
2. For every wrong claim a slice reported, run `claim-sweep.sh` over the **whole** docs root. The same wrong
   sentence usually lives in a slice other than the one that found it.
3. Run the whole-tree checks that need no slice: links, diagrams, reciprocity.
4. Compare docs that sit in different slices (a journey in one slice, its flow in another).
5. Answer the Completeness Gate for the whole audit, with the sum of the slices' counts and every slice's
   stated limits.

**No sub-agents, a small local model, or at most 1–2 agents at once?** Use **Plan mode** below. Never shrink
the scope to fit; if you must stop part-way, report exactly which slices were not done.

### Plan mode (small models, short context, or at most two workers)

The plan and every answer live **on disk**, so nothing depends on an agent's memory, any worker can resume
after a crash or a lost context, and the completeness gate is checked by a script instead of promised by
the model. Defaults (3 docs, 100 claims per slice) suit a small model; raise them for a stronger one.
Keep the audit directory **outside** the docs tree and do not edit docs while auditing.

1. **Plan:** `scripts/make-plan.sh <docs root> <audit dir> [--max-docs 3] [--max-claims 100] [excluded-dir ...]`
   cuts the docs into slices. Each slice gets `files.txt` (docs to read), `counterparts.txt` (docs it links
   to, for comparing claims) and `worksheet.md` with one block per claim. A doc with more claims than the
   limit is split into parts (`S12-1`, `S12-2`), each covering its own range of claims.
2. **Worker loop** (one worker, or two in parallel; a lock keeps them on different slices):
   1. `scripts/next-slice.sh <audit dir>` claims the next todo slice.
   2. Read the docs in `files.txt` end to end; open the `counterparts.txt` docs to compare claims.
   3. For every worksheet block, check the claim against the code (or the counterpart doc) and write
      `verdict: OK | WRONG | REVIEW`, `evidence:` with a `file:line` (required for WRONG and REVIEW), and for
      WRONG the exact wording to search for in `sweep:`.
   4. Apply this skill's per-type checks to the slice's docs, and write what the claims do not cover
      (states, transitions, traceability, doc-against-doc) under `## Other findings`.
   5. `scripts/check-worksheet.sh <audit dir> --slice <id> --close` closes the slice only when every block
      has a valid verdict and evidence; otherwise it lists what is unanswered. Repeat until it passes.
   6. Back to step 1. Stop at "no todo slice left".
      `scripts/next-slice.sh <audit dir> --release <id>` gives back a slice from a crashed worker.
3. **Merge:** `scripts/merge.sh <audit dir> <docs root> [excluded-dir ...]` gathers `wrong-claims.md`,
   `review-queue.md`, `other-findings.md`, runs the whole-tree sweep (`sweep-results.md`), links, reciprocity
   and diagrams, and writes `merge-report.md`. It refuses to run while a slice is not done (`--force` gives a
   clearly marked partial merge).
4. **Judge:** the `REVIEW` rows and every sweep hit are for you, or a stronger model. Small models are weakest
   at negative claims, step order and doc-against-doc comparison, so those are the rows to send up. Then
   write the report in the Output Format.

---

## Audit Checks by Doc Type

### Business Rules (`BR-XXX`)

For each BR doc, verify:

| Check | What to look for |
|-------|-----------------|
| Cited file(s) exist | Open each file path the doc references — confirm the file is present |
| Enforcement present | The described logic (condition, guard, check) exists in the cited file |
| Rule values match | Any specific values (caps, thresholds, identifiers) in the doc match the code |
| No orphaned reference | No doc references a class, method, or function that no longer exists |

### Invariants (`INV-XXX`)

Same checks as BRs, plus:

| Check | What to look for |
|-------|-----------------|
| Enforcement layer | Invariants must be enforced in the **domain** layer — flag if found only in application or infrastructure |

### Entity Lifecycle Docs

| Check | What to look for |
|-------|-----------------|
| States complete | Every documented state has a corresponding constant/enum value in the domain class |
| Transitions covered | Every documented state transition has a corresponding domain method |
| No extra states | Every state in the domain class is documented (no undocumented states) |
| Domain events | Every documented event emission has a real publish/emit call in the code |
| Repository interface | The documented repository interface exists at the stated path |

### Flow Docs

| Check | What to look for |
|-------|-----------------|
| Entry point exists | The documented HTTP endpoint, message consumer, or event listener exists in the codebase |
| Step sequence | Each walkthrough step maps to a real method or service call in the traced call chain |
| BR/INV references | Every BR/INV cited in the flow exists as a doc file |
| Event messaging | Every produced/consumed event named in the flow appears in the messaging/channel config or event definitions |
| External calls | Every external service call mentioned in the flow has a real HTTP / gRPC / RPC client or adapter |
| Concurrency & DB constraints | Documented race mitigations (e.g. `UNIQUE INDEX`, `version` lock column) exist in the database schema / migrations |
| Error & status code parity | Documented HTTP/gRPC error codes in acceptance criteria match the controller / exception mapper |
| Transactional Outbox atomicity | Domain events are persisted atomically via Outbox repository / transaction boundary rather than uncommitted dispatch |
| Idempotency & replay | Message consumers / mutating endpoints implement documented idempotency keys or deduplication checks |

### Journeys, Personas and Inception Docs

| Check | What to look for |
|-------|-----------------|
| Status line | "PLANNED", "not yet implemented", "(planned)" against the code and against the flow and rule docs that say the capability shipped |
| Behaviour claims | Lines such as "Gap: Carlos waits for the next cron" or "mandates are never delivered" are claims about the system: trace them in the code like a flow step |
| Cross-doc agreement | The same capability in journeys, sequencing, MVP canvas, brainstorming and the flow doc agrees on shipped vs pending, and on who it is for (internal users vs the agency) |
| Links | Every relative link resolves (`check-links.sh`), including links to personas and comparison pages |

### Proposals, Plans and Feature Specs (`working-on`)

| Check | What to look for |
|-------|-----------------|
| Status honesty | Draft / Planned / "pending merge" / Shipped against the code, against the parent proposal's status and ship date, and against the sibling docs of the same change (spec, plan, proposal must agree) |
| Folder vs status | A change in `active/` is not shipped, a change in `grace-period/` is. Mismatch is a finding |
| Checklist boxes | Every ticked box has evidence in the code or tests; every unticked box in a "Complete" doc carries a reason |
| Names | Tables, columns, events and endpoints agree with the code |

### Architecture and Assessment Docs

| Check | What to look for |
|-------|-----------------|
| Behaviour claims | Every statement about defaults, nullable fields, optional parameters or feature flags is verified against the code **and the latest migrations** |
| Age | Note the doc date against the migrations and commits that touched what it describes |

### Deferred Decisions and Reminders

| Check | What to look for |
|-------|-----------------|
| Embedded code | Code samples or routing descriptions still match the current code |
| Premise | The reason the decision was deferred is still true ("always empty", "silently skipped", "only one caller") |

### Reference and UI-Spec Docs (field references, API contracts, form specs)

| Check | What to look for |
|-------|-----------------|
| Value by value | Every enum value, literal and field name against the code's parser or validator. A value the code rejects (a `400`) is a real conflict, not a style difference |
| Pair consistency | When two docs describe one interface (UI spec and API reference), compare them value by value, including renamed fields, merged or split fields, and values with no counterpart |
| Silent drops | A documented field the request object does not have is silently ignored: report it |

### Traceability (applies to every doc type)

Rules and invariants are only findable if their links exist at **both ends**. These checks are
mechanical — run them before judging content quality. Full convention (shared across SDLC skills):
[../guidelines/traceability.md](../guidelines/traceability.md) — the single source; product docs carry
the sections it defines but do not link to it.

| Check | How to run it | Verdict when it fails |
| --- | --- | --- |
| **Reciprocity** | For each `BR-*`/`INV-*` in a flow/entity/value-object `Enforces` list, confirm the rule doc lists that flow/entity back (in `Traces up to` / `Enforced by`); and vice versa | ⚠️ Stale — half an edge |
| **Completeness of `Enforced by`** | Every layer that can reject this policy is a row: boundary validation (request, schema or DTO), application, domain, infrastructure, database, UI. Grep the module for the rule's error class and the guard message; each hit is a missing row | ⚠️ Stale (thin) or ❌ Missing |
| **Existence** | Every path and `Symbol.method` in `Enforced by` / `Verified by` still resolves — `test -f` the path, `grep` the symbol in it | ❌ Missing (doc cites code that is gone) |
| **Test anchor** | Rule has ≥1 `Verified by` test whose title actually appears in that file (`grep -n "<title>" <file>`) | ⚠️ Stale — unverifiable rule |
| **Status honesty** | ✅ Verified rows are confirmed by opening the file; anything believed goes ⚠️ Unverified; not-yet-built goes ⏳ Planned with no test claim | ⚠️ Stale — unearned ✅ |
| **No links into the skills pack** | Product docs do not link to the convention or to any skill file — `grep -rn "\.claude/skills" <docs root>/product`. The skills directory may not be versioned with the repo, so such a link dangles for anyone without it | ⚠️ Stale — remove the link and keep the prose |
| **Untagged enforcement** | A rule has flow coverage but no enforcement row that a grep can find | ⚠️ Unverified — record the site by hand |

Report a rule with an empty `Enforced by` table **and** an active flow as the highest-risk finding in
the audit: either the code is unlinked or the policy is unimplemented, and the doc cannot tell them
apart.

---

## Cross-Cutting Checks (every doc, every folder)

The per-type tables check references. These check **sentences**, which is where most drift hides.

| Check | How to run it | Verdict when it fails |
| --- | --- | --- |
| **Claim verification (no sampling)** | Run `claim-inventory.sh`. Every line it prints is a checkable claim (HTTP status, lifecycle status, timing, absolute wording, endpoint, event, schema name, flag/config). Verify each against the code, using [references/claim-kinds.md](references/claim-kinds.md), and cite file:line. The inventory is large: split it by folder across sub-agents, never trim it | ⚠️ Stale per wrong claim |
| **Negative and absolute claims** | For "never", "permanently", "silently", "no events", "nothing is …": trace the whole path, including what runs after the branch and any fallback or recovery route | ⚠️ Stale (usually the doc is too absolute) |
| **Status lines** | For every "Status: Planned / Draft / pending merge / (planned) / not yet implemented", check the code, the parent proposal's status and ship date, and the sibling docs of the same change | ⚠️ Stale — status frozen at write time |
| **Doc-against-doc consistency** | Find the same capability described in more than one place (journeys, sequencing, MVP canvas, flows, rules, UI specs vs API references) and any single doc that contradicts itself (a rule's context vs its own time-window section). Compare value by value. **Slicing trap:** a doc that marks a capability shipped or pending (journey, sequencing, MVP canvas, brainstorming) can only be checked by opening the flow, rule or proposal doc for that capability, which is usually outside the slice. For every such claim, name the counterpart doc and read it | ⚠️ Stale — report both locations |
| **Links** | `check-links.sh` over the whole docs root. State in the report which folders were scanned | ❌ Missing for a dead target |
| **Diagrams** | `check-mermaid.mjs` over every file with a diagram. Also check each diagram agrees with its walkthrough table (step order, names) | ⚠️ Stale |
| **Claim sweep** | For each wrong claim, run `claim-sweep.sh` with its exact wording and two or three paraphrases. List every hit and judge it: some docs describe a different mechanism and are right (one index is built by a cron while another is written directly) | ⚠️ Stale for each remaining wrong hit |
| **New text is audited too** | Anything added by a fix (a table, a diagram, a note) goes through every check above before the finding is closed. A table you just wrote is not evidence | ⚠️ Stale |

A finding about a claim is **closed only when the sweep returns no wrong hit**. Fixing the place where
you spotted it is not enough.

---

## Completeness Gate (answer before you write the report)

The report is not complete, and must say so, if any line below is empty. These are the lines that earlier
audits skipped.

- [ ] Every docs folder is listed, each marked audited or "not audited — reason".
- [ ] Journeys, sequencing, MVP canvas, brainstorming, architecture assessments, deferred decisions and
      `working-on` docs were read, not only the flows, entities, rules and invariants.
- [ ] Every claim of every kind in the inventory (or its manual equivalent) has an answer: confirmed,
      wrong with file:line, or needs manual review. State the counts: inventoried N, answered N.
- [ ] Every status line (Planned, Draft, pending, "not yet implemented") was checked against the code and
      the parent proposal.
- [ ] Every "never / permanently / silently / no events / nothing is" sentence was traced through the code.
- [ ] Every HTTP status mentioned anywhere (not only in flows) was compared with the controller.
- [ ] Every sentence or step that says A happens before/after B, and every numbered walkthrough step
      order, was compared with the order in the code (the inventory's `ordering` kind finds the sentences;
      step tables and diagrams need a read).
- [ ] Every `Verified by` title was grepped in the file it cites, every cited `file:line` was opened, and
      every `Enforced by` symbol exists (the Traceability table). Say so explicitly; do not leave it implied.
- [ ] Every wrong claim has a sweep result in the Claim Sweep Results table.
- [ ] Docs describing the same behaviour or interface were compared with each other.
- [ ] Text added or changed during the audit's fixes was re-read as prose.

---

## Verdict Levels

| Verdict | Meaning |
|---------|---------|
| ✅ Confirmed | Doc matches code exactly — no action needed |
| ⚠️ Stale | Doc describes something that exists but is inaccurate (wrong value, renamed path, missing step, extra step) |
| ❌ Missing | Doc references something that does not exist in the code at all |
| ➕ Undocumented | Code has behaviour (state, transition, rule, event) with no corresponding doc entry |

When you cannot confidently verify a claim (complex logic, ambiguous mapping), mark it
⚠️ with a note "needs manual review" rather than ❌ — avoid false positives.

---

## Output Format

```
# Documentation Audit Report

**Date:** [today]
**Scope:** [full / bounded context: X / doc type: Y / single doc: Z]
**Docs root:** `[path discovered in Step 0]`
**Folders audited:** [folder — N docs, …]
**Folders NOT audited:** [folder — reason, or "none"]   ← always present; silence is not allowed
**Mechanical checks:** links [N broken, folders scanned] · diagrams [N failing of N] · reciprocity [N hits, each judged] · claims [N inventoried, N verified]

---

## Summary

| Bounded Context / Folder | ✅ Confirmed | ⚠️ Stale | ❌ Missing | ➕ Undocumented |
|--------------------------|-------------|---------|----------|----------------|
| [context-A]              | N           | N       | N        | N              |
| [inception/journeys]     | N           | N       | N        | N              |
| [working-on]             | N           | N       | N        | N              |
| **Total**                | N           | N       | N        | N              |

---

## Findings by Bounded Context

### [context-A]

#### Business Rules
| ID | Doc | Verdict | Detail |
|----|-----|---------|--------|
| BR-001 | [link](relative path) | ✅ | — |
| BR-003 | [link](relative path) | ⚠️ Stale | Cap documented as 10, code enforces 12 (`src/…/rule.ext:45`) |
| BR-007 | [link](relative path) | ❌ Missing | References `OldClass.enforce()` — class deleted |

#### Invariants
| ID | Doc | Verdict | Detail |
|----|-----|---------|--------|
| INV-001 | [link] | ✅ | — |
| INV-003 | [link] | ⚠️ Stale | Enforced in application layer, should be domain (`src/…/use-case.ext:88`) |

#### Entity Lifecycles
| Entity | Doc | Verdict | Detail |
|--------|-----|---------|--------|
| [EntityName] | [link] | ⚠️ Stale | State `REPROCESSING` exists in code (`entity-status.ext:12`) but is undocumented |
| External[Entity] | [link] | ✅ | — |

#### Flows
| Flow | Doc | Verdict | Detail |
|------|-----|---------|--------|
| flow-01 | [link] | ✅ | — |
| flow-02 | [link] | ⚠️ Stale | Step 6 references `OldService` — renamed to `NewService` in `src/…/new-service.ext` |

#### Journeys, Proposals, Architecture, Deferred Decisions, Reference Specs
(one table per folder, same columns; use the checks of the matching doc-type section)

---

## Claim Sweep Results

One row per wrong claim found. A claim is closed only when "Still wrong" is 0.

| Wrong claim | Wording searched | Hits | Still wrong | Where (file:line) |
|-------------|------------------|------|-------------|-------------------|
| Endpoint returns 201 | `201 Created` | N | N | `business-rules/BR-002-….ext:31`, `…/BR-011-….ext:56` |

---

## Recommended Actions

### High priority — ❌ Missing (doc references code that no longer exists)
1. **BR-007**: `OldClass.enforce()` was deleted. Run `/modify-flow` to document the removal and
   update BR-007 to reflect the current enforcement location or mark it retired.

### Medium priority — ⚠️ Stale (doc exists but is inaccurate)
1. **BR-003**: Update cap value from 10 → 12 in `business-rules/BR-003-[rule-name].md`.
   No code change needed — this is a doc correction.
2. **flow-02, Step 6**: Update step to reference `NewService` — no code change needed.
3. **INV-003**: Move enforcement from `use-case.ext` into the domain entity to restore invariant
   ownership. Use `/modify-flow` if a code change is required.

### Low priority — ➕ Undocumented (code has no docs)
1. **[Entity] state `REPROCESSING`**: Add this state to `entities/[Entity].md` lifecycle doc.
   Use `/create-entity-lifecycle` to regenerate the section if needed.

---

## How to Act on These Findings

| Verdict | Recommended skill |
|---------|------------------|
| ⚠️ Stale — doc-only correction | Hand-edit the doc in place |
| ⚠️ Stale — code change needed | `/modify-flow` |
| ❌ Missing | `/modify-flow` to document the removal or locate the replacement |
| ➕ Undocumented entity/state | `/create-entity-lifecycle` |
| ➕ Undocumented flow/behaviour | `/create-flow-documentation` |
| Any fixed claim | Run `scripts/claim-sweep.sh` for its wording before closing the finding |
| UI spec vs API conflict | Not a doc fix: record a deferred decision (map the values, or change the API) |
```

---

## Quality Rules

- **Never modify a file.** This skill produces a report only.
- **Code is truth.** If code and doc disagree, the doc is stale — never assume the code is wrong.
- **Always verify, never assume.** Open and read every file you report on.
- **Be specific.** Every finding must cite the exact file path and line (or range) that confirms or
  contradicts the doc.
- **No false positives.** If you cannot verify, mark ⚠️ with "needs manual review" — not ❌.
- **An edge exists at both ends.** A link found on only one side is a finding, even when the content
  it points at is perfectly accurate.
- **Complete the summary table** before listing findings — it gives the user a quick health score.
- **Audit sentences, not only references.** Paths, line numbers and test titles resolving is necessary,
  not sufficient. A rule doc whose cited file exists can still say "201 Created" when the code returns 204.
- **Never sample.** If the volume is large, split it by folder across sub-agents and give each its slice
  of the claim inventory; every line must be answered. Do not cap the length of the findings.
- **Scope is part of the report.** Name the folders audited and the folders not audited. Never write
  "no broken links" or "all docs consistent" without saying which folders were scanned.
- **Fix the claim, not the instance.** After a wrong claim is found or fixed, sweep the whole docs tree
  for its wording. A finding is closed only when the sweep shows no wrong hit left.
- **Judge sweep hits.** A hit is a candidate, not a verdict: the same wording can be correct in a doc that
  describes a different mechanism. Never bulk-replace.
- **Audit new text too.** Content added while fixing (tables, notes, diagrams) is re-checked with the same
  rigor, as prose, before the report says it is fixed.
- **Compare docs with each other.** When two docs describe the same behaviour or interface, they must
  agree; a disagreement is a finding even if one of them matches the code.
- **Delegating:** follow "Execution Plan" above. When you split the work across sub-agents, give each a folder, its claim-inventory
  lines, **the counterpart docs for the capabilities that folder mentions** (so shipped-vs-pending claims
  can be compared), and the instruction to answer every line. Tell them to report their limits honestly
  (what they did not read).

---

## Related Skills

| Skill | When to use |
|-------|-------------|
| `explore-domain` | Understand a specific part of the system (one question, not a sweep) |
| `modify-flow` | Fix stale/missing documentation or change behaviour |
| `create-flow-documentation` | Document behaviour that has no flow doc at all |
| `create-entity-lifecycle` | Document an entity that has no lifecycle doc at all |

---

**Version:** 1.1: audits every docs folder; adds claim verification, status-line, doc-against-doc,
link, diagram and claim-sweep checks, with helper scripts in `scripts/` and `references/claim-kinds.md`.
