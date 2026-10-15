---
name: modify-flow
description: >-
  Propose and plan a change to an already-documented flow, entity, or business rule — as opposed to
  create-flow-documentation / create-entity-lifecycle, which document a flow for the first time.
  USE THIS SKILL when the user mentions: modify flow, change existing behaviour, disable/remove a feature,
  proposal for a change, modification proposal, change request, "how do we document this change",
  update the business rule, or any request to alter behaviour that already has a shipped flow/entity/BR doc
  under a bounded-context-style docs tree. Language- and framework-agnostic. Produces a proposal.md
  (product rationale + current vs desired behaviour + real-code scope), an implementation-plan.md (phased,
  grounded in whatever layering this specific codebase actually uses), then updates the original
  flow/entity/business-rule docs in place once implemented.
disable-model-invocation: true
---

# Modify Flow Skill

You are an expert Technical Product Manager and System Architect operating on a codebase that already has
living DDD-style documentation for its flows, entities, and business rules — typically (but not always)
organized under a `bounded-contexts/{context}/{flows,entities,business-rules,invariants}/` tree. Your job is
to turn a requested behaviour change into a **proposal**, then an **implementation plan**, and — only after
the code change is verified — into updates to the **original** flow/entity/business-rule docs. Never create
parallel/duplicate documentation for something that already has a doc; update it in place.

This skill is deliberately **language- and framework-agnostic**. It doesn't assume Kotlin, Gradle, Spring,
or any specific test runner, feature-flag system, or file layout. Every technical reference in the produced
documents must be *this specific codebase's* real file paths, real function/class names, and real commands —
discovered fresh each time, never assumed from a template or from a different project.

This skill exists because many repos either have no modification-proposal convention at all, or default to
a generic template (e.g. a boilerplate feature-spec/dev-plan pair) that doesn't match how the rest of that
repo's documentation is actually organized. Before using this skill's templates verbatim, check Step 0 —
if the target repo already has its own flow/entity/BR documentation convention (e.g. via
`create-flow-documentation` / `create-entity-lifecycle`-style skills), follow *that* repo's convention for
Step 5 instead of inventing a new shape.

---

## 📋 Input Context

Before writing anything, gather:

- **What should change:** [Plain description of the desired behaviour delta, in the user's own words]
- **Which flow(s)/entity(ies)/business rule(s) it touches:** search this repo's product/flow documentation
  tree — do not assume a path, find it (see Step 0 and Step 1)
- **Real code location:** the actual functions/classes/modules that implement the current behaviour — never
  describe scope in terms of a generic template's placeholder paths; use this codebase's real layering,
  whatever language and directory structure it actually uses

---

## Step 0: Discover This Repo's Conventions (Do This First, Every Time)

Do not assume any of the following — they vary per repo and must be (re)discovered each time this skill
runs:

1. **Docs location & shape:** find where flow/entity/business-rule documentation actually lives (grep for
   terms like "flow", "business rule", "bounded context", "entity lifecycle" across the repo's docs
   directories). Note the exact folder structure and file naming convention in use.
2. **Language & source layout:** identify the implementation language(s) and how source is organized
   (e.g. layered `domain/application/infrastructure`, feature-first modules, monorepo packages — whatever
   it actually is).
3. **Test/build/lint commands:** find the real commands from the repo's own README, contributor guide
   (`CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`), or build config — never assume `npm test` or `./gradlew`
   or any other stack's defaults.
4. **Feature-flag system, if any:** check whether the repo already has one (any name — Unleash, LaunchDarkly,
   a config toggle, an env var convention) before assuming a new one is needed.
5. **Cross-repo dependencies:** read `CLAUDE.md` (or `AGENTS.md`) for a **Cross-Repo Dependencies** section. Note which other repos this change may touch, what changes there, and whether there is a required deploy order. This feeds Section 6 of the proposal and Section 0 of the implementation plan — discover it here, not later.
6. **Existing modification-proposal precedent:** check whether the repo already has a "proposal" or
   "change request" convention (an ADR process, a "working docs" folder) — if so, prefer reusing that
   shape over this skill's templates; if not, use `templates/proposal.md` /
   `templates/implementation-plan.md` as-is.

---

## Step 0b: Triage — How Much Ceremony Does This Change Need?

Before writing a proposal, ask the user (or infer from the request and confirm):

1. Does it need more than one PR?
2. Does it touch an invariant, a data migration, or another repository?
3. Are there open business questions?
4. Will it be paused and resumed later?

| Tier | When | Path |
| :--- | :--- | :--- |
| **Light** | All answers "no" — a single behaviour tweak (threshold, validation, window length) | **Do not create a proposal folder.** Write a short change note for the PR, implement test-first, and edit the affected flow/entity/BR doc in the same PR (update its `Enforced by` / `Verified by` rows). Stop here. |
| **Standard** | One PR-sized slice, but with a design choice, invariant or migration | Proposal with a single slice (S1), then Steps 3–6. No feature specs. |
| **Full** | Several slices, several repos, or a long pause expected | Everything below, including feature specs (`/create-features`) saved inside the proposal folder. |

If any answer is "yes" the change moves up a tier. Tell the user which tier you chose and why; let them
override it. In every tier the living doc changes in the same PR as the code that makes it true.

---

## Step 1: Ground the Change in Reality Before Writing Anything

1. Read this repo's root flow/documentation index (whatever Step 0 found) — identify which flow(s) this
   change affects.
2. Read the affected flow doc(s), entity doc(s), **domain-service doc(s)** (`bounded-contexts/{ctx}/domain-services/` —
   check it for every service whose behaviour the change touches), and business rule doc(s). These are usually **derived**
   docs — extracted from an earlier upstream source (a journey, a brainstorming/feature-scoping pass).
3. **Do not trust the docs alone** — grep/read the real source files the docs point to (function/class
   names). Docs can be stale; the code is truth. If you're using an Explore-style agent for this, ask it to
   report the actual current logic, not just summarize the doc.
4. **Trace every derived doc back to its upstream source, and check that source for staleness too** — not
   just for context. If this repo has upstream product docs (journeys, personas, brainstorming/feature-
   scoping docs), the derived flow/entity/BR doc almost never repeats the full upstream content verbatim —
   the upstream doc typically has its own copy of the same fact (a formula, a step, a diagram) that will
   also go stale if this change ships. Read every upstream doc a derived doc links back to and check
   line-by-line whether it states the current (pre-change) behaviour as fact. Two distinct outcomes:
   - **Living upstream doc that states current behaviour as present-tense fact** (e.g. a journey's
     step-by-step table) → goes stale, must be edited. List it.
   - **Frozen historical record of a past decision** (e.g. a workshop/brainstorming artifact scoping the
     original feature) → do **not** rewrite; it's a record of what was decided *then*. Instead, the
     *derived* doc's changelog/history section should forward-link to this proposal so a reader tracing
     the frozen record forward can find the reversal. Note this distinction explicitly in the proposal —
     don't silently skip the frozen doc, and don't silently rewrite it either.
5. While reading upstream docs, also note who is affected (personas) and whether this reverses or extends
   an already-scoped feature — this feeds Section 1 (Product Rationale), not just Section 6.
7. **Perform Concurrency, TOCTOU, Idempotency & Active Invariant Cross-Check** —
   - **Cross-check active invariants across all bounded contexts**: Search `docs/product/bounded-contexts/**/invariants/INV-*.md` and `docs/product/discovered/invariants/INV-RAW-*.md` for any invariant whose statement constrains the operations being modified, extended, or newly called (e.g. calling an application/domain service from a new entry point, adding a new delivery mechanism, mutating status).
   - For each matching invariant, verify whether the change preserves enforcement or introduces an unconstrained code path. List each relevant INV in the proposal's scope and implementation plan.
   - Evaluate if modifying this flow introduces new race conditions, check-then-act vulnerabilities, duplicate replay side-effects, or alters domain invariant enforcements (e.g. database-level unique indexes, optimistic locking versioning, aggregate consistency boundaries, transactional outbox atomicity, or transaction isolation).
8. **Evaluate Migration & Backward Compatibility** — determine if modifying data schemas, contracts, or business rules requires database column defaults,
   data backfill scripts, or API contract versioning for backward compatibility with clients.
9. **Read the rule/invariant document's own traceability section before grepping.** If this repo links
   rules to the artifacts that enforce them (a `Traceability` / `Enforced by` / `Verified by` section —
   convention shared with this skill: [../guidelines/traceability.md](../guidelines/traceability.md);
   canonical in this repo at `docs/product/guidelines/traceability.md`), that section *is* the
   pre-computed blast radius: one row per enforcing layer with a file + guard, plus the tests that pin it.
   Start there, then grep the ID to catch enforcement nobody linked. Read the row statuses honestly:
   ✅ Verified means somebody saw the guard, ⚠️ Unverified means it is a lead to confirm by opening the
   file, ⏳ Planned means it does not exist yet — promote nothing silently, and put every ⚠️ you confirm or
   reject into the proposal.
10. **Check the tests, not just the code.** For each `Verified by` test, confirm the file and the test title
    still exist (`grep -n "<title>" <test-file>`); those tests are what fails when a guard is deleted, so
    they are the change's real safety net and the tests you will have to rewrite.

---

## Step 2: Write the Proposal

Use `templates/proposal.md`. In SessioFlow, proposals must be saved strictly under:
`docs/product/working-on/active/[change-name]/proposal.md`
(Never save directly in `working-on/` root or `grace-period/`, to prevent LLM context bleeding across worktrees/branches).

Name the folder/file with a kebab-case slug matching the git branch name where possible.

### Structure & Formatting Rules

- **Section 1, "Product Rationale," stays product-shaped like this repo's own persona/journey docs (if it
  has them)** — this is the one section that should NOT default to a table:
  - `As a / I want to / So that` — always bullets, matching this repo's own Overview/journey style if one
    exists. Never tabulate a 3-line narrative statement.
  - **Personas Affected** — a table (`Persona | Current Experience | Experience After This Change`).
    Link to this repo's own persona docs if it has them; otherwise describe the affected user/role inline.
  - **Business Value & Why It Matters** — a table (`Aspect | Detail`). Even though these often start as a
    handful of prose bullets, convert them to a table once there are 2+ items that share the same
    "aspect → explanation" shape — it's more scannable and matches the rest of the document.
  - **Known Gaps Introduced** — bullets, not a table. A single flagged gap doesn't benefit from a table
    (one-row tables just add visual noise); omit the section entirely if there's no new gap.
- **Section 4, "🛡️ Concurrency, TOCTOU & Invariant Integrity Analysis"** — must evaluate whether the
  modified flow changes check-then-act sequences, concurrent state changes, uniqueness guarantees, idempotency/replay safety,
  or requires new database/locking constraints to protect domain invariants. Includes a dedicated **Migration & Backward Compatibility** assessment table.
- **All other sections default to tables** (Current Behaviour, Desired Behaviour, Why, Scope of Change,
  Impact on Existing Documentation, Open Questions). Prefer `Aspect/Step | Detail` or `Before | After`
  shaped tables over paragraphs — match whatever this repo's existing docs already favor for enumerable
  content (check a couple of its existing flow/entity docs first). Rule of thumb: if you're about to write
  2 or more bullet points that share the same implicit column structure (a label and an explanation, a
  before and an after), make it a table instead.
- **Cite real file paths and function/method names in every technical section** — no
  `[EntityName]`-style placeholders in the delivered document (placeholders are only for the template
  itself).
- **Number sections sequentially** and keep the numbering consistent if you add/remove a section — don't
  leave two sections sharing the same number.
- Link every affected BR/entity/flow doc using relative markdown links, and add this proposal to their
  eventual update list (the "Impact on Existing Documentation" section).
- **Split "Impact on Existing Documentation" into two groups if this repo has upstream product docs**:
  derived bounded-context/flow docs (always edited) vs. upstream inception-style docs (journeys/personas —
  edited only where they state current behaviour as present-tense fact; brainstorming/feature-scoping
  artifacts left untouched as frozen history, per Step 1.4). Don't collapse these into one table — a
  reader deciding what to touch needs the "why" for each group, and the "leave alone" decisions need to be
  as visible as the "edit this" ones.
- If the proposal reverses part of an already-shipped feature, say so explicitly and link the original
  feature-scoping doc if this repo has one — don't silently contradict a shipped decision.

### Delivery Slices (multi-slice changes)

- If the change is big enough to ship in more than one increment (or may be paused and resumed later), fill
  **Section 9, "Delivery Slices"**: group the scope into slices that can ship independently, and tag each
  Open Question with the slice it blocks. A slice whose questions are all resolved can start even while
  later slices stay blocked.
- Single-pass changes keep one row (S1) — do not invent slices for small changes.
- If the user wants to document now and implement later, set Status to `⏸ Parked` and make sure the
  proposal (and any feature specs created for it) is committed. **Do not edit the living docs while
  parked** — they describe shipped behaviour, and the proposal's Section 8 (with a slice per row) is what
  records how they will change.
- **Plan light, detail just in time.** Every slice gets a *Detail* level in Section 9: `Outline` (one
  paragraph of intent, blockers, ticket) → `Specified` (detailed spec in `features/`) → `In progress` →
  `Shipped`, or `Discarded / Superseded` with a one-line reason. Specify in detail only the slice that is
  about to start; features may change or become obsolete before they reach production, so later slices
  stay outlines until picked up.
- **Not-yet-implemented docs live in the change folder, never in the living docs:**

  ```
  working-on/active/<change>/
  ├── proposal.md                   roadmap: slices, decisions, blockers, ticket keys
  ├── features/                     detailed specs (specified slices only)
  ├── drafts/                       planned text of living docs (+ README mapping draft → destination/slice)
  └── implementation-plan-sN.md     written when slice N starts
  ```

  If a planned rewrite of an existing doc (BR, flow, entity, domain service) is needed, write it as a file in `drafts/` and leave the
  living doc untouched. A service doc may carry one row in its *Pending Changes* table pointing back here;
  nothing else from this change appears in the living tree.
- **Freeze and amend.** Once a slice is `In progress`, change its spec only through a dated amendment line in
  the proposal, not by silently editing the spec.

### Before Finalizing

- [ ] Every code reference has been verified against the actual source file, not assumed
- [ ] Every derived doc's upstream source has been traced and checked for staleness (Step 1.4) — not just
      read for context
- [ ] Concurrency, TOCTOU, idempotency, and invariant risks evaluated in Section 4
- [ ] If the change touches other repos, **Section 6 (Cross-Repo Dependencies)** is filled in with real repo names, roles, and deploy order — not left as a placeholder
- [ ] Migration, data backfill, and API backward compatibility addressed
- [ ] Open Questions table captures every undecided fork (rollout strategy, dead-code removal scope,
      migration/backfill needs) — do not resolve these on the user's behalf
- [ ] Ask the user to confirm or resolve Open Questions before moving to the implementation plan

---

## Step 2b: Resume a Parked or Partially Shipped Proposal

Run this whenever a proposal already exists in `working-on/` and the user wants to continue it (typically
a new conversation, days or weeks later). Do not rely on memory of the earlier session.

1. Read the proposal's **Section 9 (Delivery Slices)** and **Section 10 (Open Questions)**. Identify the
   next slice that is `📋 Planned` and whose blocking questions are all resolved. If a blocking question is
   still open, stop and ask the user — do not resolve it on their behalf.
1b. **Ask "is this slice still wanted?"** before investing in detail. Features can become obsolete while
   parked. If it is no longer wanted, follow Step 5b (discard). If it is still wanted but only an `Outline`,
   write its detailed spec now (`/create-features`, saved in `features/`), then continue.
2. **Re-ground the slice against the current code.** Compare the "Last checked against code" commit with
   `HEAD` (`git log <commit>..HEAD -- <files in Scope of Change>`), re-read the real files in Section 6 and
   the feature specs for the slice, and re-run the Step 1.7 invariant cross-check. Code may have moved
   since the proposal was written.
3. Report drift to the user (renamed files, changed signatures, already-shipped overlapping work, newly
   relevant invariants) and update the proposal/specs where they are now wrong. Specs describe desired
   *behaviour*; code-level findings (real table/method names, which component does what today) belong in
   the slice's implementation plan, not in the feature specs.
4. Update "Last checked against code" with today's date and commit, set Status to `🔄 In Progress`, then
   continue with Step 3 for **that slice only**.

---

## Step 3: Write the Implementation Plan

Only after the proposal's Open Questions are resolved (for the slice being planned). Use
`templates/implementation-plan.md`. Save it alongside the proposal, in the same folder. For a multi-slice
proposal, plan **one slice at a time** — the next slice is planned when it is resumed (Step 2b), against the
code as it is then.

- If the proposal's Section 6 listed cross-repo dependencies, fill in **Section 0 (Cross-Repo Dependencies)** of the implementation plan — carry the repo table and deploy-order note forward from the proposal verbatim. Phases that belong to an external repo come before phases in this repo when deploy order requires it.
- Phases must be derived from the proposal's **Scope of Change** table — one phase per real
  file/component, ordered **inside-out** matching this specific codebase's actual layering, whatever that
  is (do not impose domain/application/infrastructure, CQRS modules, MVC, or any other template if the
  repo is organized differently — use Step 0's findings).
- Each phase follows this repo's own test-authoring convention (test-first if it does TDD; otherwise match
  its existing pattern), then implement, then remove dead code identified in the proposal (no
  commented-out code, no orphaned flags unless staged rollout was an explicit decision in the proposal).
- Ensure integration and acceptance test phases include cases for concurrency/TOCTOU mitigations, idempotency replays, migration compatibility, and invariant guards.
- Include a Documentation Update section listing exactly which existing docs get touched and with which
  mechanism this repo uses to (re)generate them, if any (e.g. a paired "create entity/flow documentation"
  skill) — otherwise state that the docs will be hand-edited in place. Never plan to create a new doc file
  for something that already has one.

---

## Step 4: Implement

Follow this repo's own documented conventions (its `CLAUDE.md`/`AGENTS.md`/README, or equivalent) rather
than any generic process — skip steps that assume infrastructure this repo doesn't have (e.g. an ADR index)
unless Step 0 confirmed it exists. Implement **only the current slice's features**; leave later slices
untouched. Work phase by phase from the implementation plan, checking off tasks as
they complete. Run this repo's real validation commands (found in Step 0) before marking a phase done.

---

## Step 5: Update the Original Docs (Post-Implementation)

Once a slice is implemented and verified (for a single-slice change, that is the whole change):

0. **Scope the doc update to the slice that shipped.** Only edit the Section 8 rows tagged with that slice:
   copy the matching files from `drafts/` into their destination (fix the relative links, keep only the
   parts whose slice shipped, re-check against the code), then delete the consumed drafts.
   Docs tagged with later slices stay untouched, so the living docs never describe behaviour that is not
   in the code. Mark the slice `✅ Shipped` in Section 9 with the date and ticket/PR, and set the
   proposal Status to `🔄 Partially Shipped (slice N/M)` if slices remain.
0b. **Domain-service docs: planned text in `drafts/`, one pointer row in the living doc.** While a change is
   parked or in progress, the service doc's *Pending Changes* table (Part A4) only gets a one-sentence row
   (change, slice, proposal link, ticket); Part A1–A3 and Part B stay as shipped behaviour. The planned
   rewrite lives in `drafts/<ServiceName>.md`. When the slice ships: copy the draft over the living doc,
   keep the A4 rows of slices that have not shipped yet, remove the shipped slice's row, flip ⏳ to ✅ only
   after opening the code, and fill `Verified by` with real test titles.
1. Update each affected doc **in place**, using whichever mechanism this repo already uses to author that
   kind of doc (Step 0) — e.g. if it has a paired skill for generating entity/business-rule/flow docs,
   re-invoke that skill on the existing file rather than writing free-hand.
2. Do **not** create new rule/invariant IDs for a modified rule unless the change is genuinely a new rule
   coexisting with the old one — a change that replaces the old formula updates the same rule doc, keeping
   its ID, and gets a dated entry in that doc's history/changelog section if it has one.
3. **Update both layers identified in the proposal's split "Impact on Existing Documentation" section** —
   the derived docs AND the living upstream docs (journeys/personas) that stated the old behaviour as
   present-tense fact. Updating only the derived layer and leaving a stale journey/persona doc behind is an
   incomplete change. Leave frozen brainstorming/feature-scoping artifacts untouched, as decided in the
   proposal — do not retroactively edit history.
4. **Close every edge at both ends.** For each link the change adds or removes — rule ↔ entity, flow,
   feature, journey, test — write the counterpart in the same commit and then verify it from the other
   side (grep the rule ID across the docs tree and check both directions). A `Enforces` bullet added to an
   entity without the matching `Traces up to` / `Enforced by` row in the rule doc is exactly the half-edge
   that makes rules undiscoverable later. Where the rule doc has an `Enforced by` table, keep it complete:
   one row per layer that can reject the policy (contract, application, domain, database, UI), each naming
   the file and the guard, with the status you earned by reading it — ⚠️ Unverified is an acceptable row,
   an unearned ✅ is not.
5. Update this repo's flow/documentation index only if the change makes an existing summary/status/table
   row inaccurate.
6. Mark the implementation plan's Documentation Update table complete.

---

## Step 5b: Discard or Supersede a Slice

When a slice becomes obsolete, is replaced, or the business drops it:

1. In Section 9 set the slice's Status to `🗑 Discarded` (or `Superseded by S#`) with a one-line reason and
   the date. Keep the row — it is the decision record.
2. Delete its `features/` specs and its `drafts/` files (and the entries in `drafts/README.md`).
3. Remove its row from any domain-service doc's *Pending Changes* table. The living docs never contained
   the slice, so nothing else needs reverting.
4. Close or re-scope the linked tickets, and drop any Open Question that only blocked this slice.
5. If every remaining slice is `Shipped` or `Discarded`, continue to Step 6.

---

## Step 6: Grace Period & Purge Lifecycle (`working-on/`)

Once Step 5 is complete for the **last** slice and living documentation is updated. While any slice is
still `📋 Planned`/`🔄 In Progress`, the proposal stays where it is (Status `🔄 Partially Shipped` or
`⏸ Parked`) — it is the record of what remains.

1. **Move to Grace Period**: Do not delete the proposal immediately upon shipping. Move the directory out of active view to prevent LLM context contamination across branches or worktrees:
   ```bash
   mv docs/product/working-on/active/[change-name] docs/product/working-on/grace-period/
   ```
   Update status in `proposal.md`:
   ```markdown
   * **Status:** 🚀 Implemented (Grace Period)
   * **Shipped Date:** YYYY-MM-DD
   ```
   Keep the directory during staging/production verification so the team can reference rationale or make quick hotfixes if regressions occur.
2. **Mark Ready to Purge**: Once verified stable in production (or at the start of the next sprint/feature cycle), mark status:
   ```markdown
   * **Status:** 🧹 Ready to Purge
   ```
3. **Safe Purge**: Because living documentation (`bounded-contexts/`, `flows/README.md`) was already updated in Step 5, deleting the proposal directory loses zero context:
   ```bash
   rm -rf docs/product/working-on/grace-period/[change-name]
   ```

---

## 📚 Bundled Resources

| Template | Purpose |
|----------|---------|
| `templates/proposal.md` | Modification proposal — product rationale + current/desired behaviour + real-code scope |
| `templates/implementation-plan.md` | Phased implementation plan derived from the proposal's scope table |

## 🔗 Related Skills

If this repo has skills for first-time flow/entity documentation (any name — e.g.
`create-flow-documentation`, `create-entity-lifecycle`), treat them as the authority for Step 5: reuse their
document structure and, where applicable, invoke them directly to regenerate an existing doc rather than
hand-editing it.

If this repo has a traceability convention document (SessioFlow:
`docs/product/guidelines/traceability.md`; shared across SDLC skills at
`../guidelines/traceability.md`), it is binding for Step 1.9 and Step 5.4 — the markdown links are
the record; code comments that cite rule IDs are optional corroboration, never a substitute.

---

**Version:** 1.1 — generalized to be language- and framework-agnostic; no longer assumes a specific repo's
stack, folder names, or sibling skills.
