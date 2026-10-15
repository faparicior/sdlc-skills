# Proposal: [Change Title]

* **Status:** 📋 Draft | 🔄 In Review | ✅ Approved | ⏸ Parked | 🔄 Partially Shipped (slice N/M) | 🚀 Implemented (Grace Period) | 🧹 Ready to Purge
* **Shipped Date:** [YYYY-MM-DD or Pending]
* **Last checked against code:** [YYYY-MM-DD @ commit `abc1234` — update every time the proposal is resumed]
* **Branch:** `[git-branch-name]`
* **Bounded Context:** [Context]
* **Affects:** [BR-XXX-name.md](../../bounded-contexts/[context]/business-rules/BR-XXX-name.md), [EntityName.md](../../bounded-contexts/[context]/entities/EntityName.md), [flow-NN-name.md](../../bounded-contexts/[context]/flows/flow-NN-name.md)

---

## 1. Product Rationale

**As a:** [Persona or role driving this change]
**I want to:** [What should change, in plain product terms]
**So that:** [The business outcome this achieves]

### Personas Affected

| Persona | Current Experience | Experience After This Change |
| :--- | :--- | :--- |
| [Persona 1](../../../inception/3-personas/persona-1.md) | [What happens today] | [What happens after] |
| [Persona 2](../../../inception/3-personas/persona-2.md) | [What happens today] | [What happens after] |

### Business Value & Why It Matters

| Aspect | Detail |
| :--- | :--- |
| Relation to existing feature | [Does this reverse, extend, or replace a feature from `5-brainstorming.md`? Link it.] |
| Business driver | [Why now — commercial, legal, operational reason] |
| Trade-off accepted | [What gets worse or narrower in exchange for the benefit — be explicit] |

### Known Gaps Introduced

- [Any new gap this change creates that isn't yet solved — mirror the "Gap" callouts used in journey docs. Omit this section if none.]

---

## 2. Current Behaviour

[Describe what the system does today. Cite real file paths, class/function/method names — not placeholders. Pull from the actual flow doc / entity doc / business rule doc being changed, and verify against the source code, not just the docs (docs can be stale).]

| Step | Method / Component | Behaviour |
| :--- | :--- | :--- |
| 1 | `[RealClassOrModule.method()]` | [What it does, in the actual code] |
| 2 | `[RealClassOrModule.method()]` | [What it does, in the actual code] |

[State the business rule this enforces today, with a link to its BR/INV doc if one exists. Note whether it's gated by a feature flag — check, don't assume.]

## 3. Desired Behaviour

[Describe the target state. Use a before/after table — it's the clearest way to show a delta.]

| Aspect | Today | After This Change |
| :--- | :--- | :--- |
| [Behaviour 1] | [Current] | [Target] |
| [Behaviour 2] | [Current] | [Target] |

## 4. 🛡️ Concurrency, TOCTOU & Invariant Integrity Analysis

[Evaluate whether this modification introduces or changes race conditions, check-then-act vulnerabilities, aggregate boundaries, or invariant protections.]

| Concurrency / Invariant Scenario (TOCTOU) | Potential Risk in Modified Flow | Guard / Mitigation Strategy | Enforcement Mechanism |
| :--- | :--- | :--- | :--- |
| **Check-Then-Act Race** | [e.g. Concurrent modification of status, balance, or quota limits] | [e.g. Optimistic locking / atomic update / DB constraint] | `[Constraint/Mechanism]` $\rightarrow$ `[DomainError]` |
| **Uniqueness & Collisions** | [e.g. Concurrent duplicate creation or rename] | [e.g. Unique index / database constraint] | `UNIQUE INDEX` $\rightarrow$ `[DuplicateKeyError]` |
| **State Transition Ordering** | [e.g. Conflicting concurrent state changes on same entity] | [e.g. Aggregate version check / optimistic concurrency] | `VersionMismatchError` |
| **Idempotency & Replays** | [e.g. Duplicate webhook/event or double-submit] | [e.g. Idempotency key / deduplication / aggregate status check] | `[Deduplication]` $\rightarrow$ idempotent success |

### 4.1 Migration & Backward Compatibility Assessment

| Dimension | Risk / Impact | Mitigation / Strategy |
| :--- | :--- | :--- |
| **API Contract** | [Additive (non-breaking) / Deprecation / Breaking change] | [e.g. Optional fields with defaults / API versioning] |
| **Database Schema** | [New column / modified constraint / enum change] | [e.g. Nullable column with default value before making non-null] |
| **Existing Data Backfill** | [Do existing rows violate the new invariant or lack new data?] | [e.g. Migration backfill script / none required] |

## 5. Why

| Driver | Detail |
| :--- | :--- |
| Business decision | [The actual reason, even if informally sourced (branch name, verbal request, prior conversation)] |
| Source | [Ticket / conversation / branch name — be honest if there's no formal ticket yet] |

## 6. Scope of Change

List every real file touched, not generic module paths. Grep the codebase for the classes/methods involved before finalizing this table — this section is what the implementation plan is built from.

| File | In/Out | Change |
| :--- | :---: | :--- |
| `[real/path/to/source-file.ext]` | In | [What changes] |
| `[real/path/to/source-file.test.ext]` | In | [Which tests need rewriting and why] |
| `[real/path/to/dependency.ext]` | Out — needs decision | [Why this is undecided — e.g. shared by another flow, needs confirmation before deleting] |
| Feature flag | Out — needs decision | [Unconditional rollout vs. new flag/toggle — state whether one already exists in this codebase's feature-flag system, if it has one] |

## 7. Cross-Repo Dependencies

Fill this section only if the Scope of Change table spans more than one repository. Remove it for single-repo changes.

| # | Repo | Role in this change | Deploy first? |
| :---: | :--- | :--- | :---: |
| 1 | `[repo-name or path]` | [What changes there and why] | ✅ / — |
| 2 | this repo | [What changes here] | — |

> **Deploy order note:** describe any hard ordering constraint (e.g. "repo 1 must deploy before this repo — the new event payload references a contract that must exist in repo 1 first").

## 8. Impact on Existing Documentation

List the living docs this change will require updating **after implementation ships** — update them in place, do not create new files alongside them. Assign each row to the slice (Section 9) whose shipping makes the doc true; a doc is only edited when its slice ships. If this repo has upstream product docs (journeys, personas, brainstorming/feature-scoping) behind its derived flow/entity/BR docs, split the impact into two groups — a derived doc rarely repeats its upstream source's full content, so the upstream doc can independently go stale even after the derived doc is fixed.

### 8.1 Derived Bounded-Context / Flow Docs

The living docs are **not** edited until their slice ships. Write the planned text as a file in `drafts/` (with a `drafts/README.md` row: draft → destination → slice); in the PR that ships the slice, copy it into the destination and delete the draft.

| Doc (destination) | Draft | Slice | Change |
| :--- | :--- | :---: | :--- |
| [BR-XXX-name.md](../../bounded-contexts/[context]/business-rules/BR-XXX-name.md) | [draft](drafts/BR-XXX-name.md) | S1 | [How the rule text changes; add a dated History & Evolution entry] |
| [EntityName.md](../../bounded-contexts/[context]/entities/EntityName.md) | [draft](drafts/EntityName.md) | S1 | [Which states/transitions/notes change] |
| [flow-NN-name.md](../../bounded-contexts/[context]/flows/flow-NN-name.md) | [draft](drafts/flow-NN-name.md) | S2 | [Which diagram stages / walkthrough steps / edge cases change] |
| [ServiceName.md](../../bounded-contexts/[context]/domain-services/ServiceName.md) | [draft](drafts/ServiceName.md) (+ one A4 row in the living doc now) | S1 | [Living doc gets a Pending Changes row (A4) now; when the slice ships copy the draft, keep other slices' A4 rows, remove this one] |

### 8.2 Upstream Product Docs

Only include this subsection if this repo has upstream journey/persona/brainstorming docs. For each one linked from the derived docs above, decide which bucket it falls into — don't skip a doc just because it's "upstream":

| Doc | Stale Content | Change |
| :--- | :--- | :--- |
| [journey-name.md](../../../inception/6-user-journeys/journey-name.md) | [The specific line/step/table cell that states the old behaviour as present-tense fact] | [Edit to reflect the new behaviour] |
| [5-brainstorming.md](../../../inception/5-brainstorming.md) | [The feature description that scoped the original, now-partially-reversed behaviour] | **Do not rewrite** — frozen record of the original decision. Leave as historical record; the derived doc's History & Evolution entry (7.1) is the forward-link documenting the reversal |
| [3-personas/*.md](../../../inception/3-personas/) | [State explicitly whether any persona doc needs a change, even if the answer is "no change needed"] | [Edit, or confirm no change needed] |

## 9. Delivery Slices

The ledger for incremental delivery. Group the change into slices that can ship independently; each slice is implemented, verified and documented on its own, possibly in a different conversation or weeks later. Single-pass changes use one row (S1). Update this table whenever a slice changes state — it is the first thing read when the proposal is resumed.

Detail level: **Outline** (intent only) → **Specified** (detailed spec in `features/`) → **In progress** → **Shipped**; or **Discarded / Superseded** (keep the row with a one-line reason and date). Specify a slice in detail only when it is about to start; ask "still wanted?" when resuming.

| Slice | Features / Scope | Blocked by (Open Question #) | Detail | Status | Shipped | Ticket / PR |
| :---: | :--- | :---: | :---: | :--- | :---: | :--- |
| S1 | [e.g. F01, F02] | — | Specified | 📋 Planned / 🔄 In Progress / ✅ Shipped | [YYYY-MM-DD] | [SCMI-123 / PR link] |
| S2 | [e.g. F03, F04] | [#1] | Outline | 📋 Planned / 🗑 Discarded | — | — |

## 10. Open Questions

| # | Question | Blocks slice |
| :---: | :--- | :---: |
| 1 | [Decision still needed before implementation can start] | [S2 / none] |
| 2 | [Decision still needed before implementation can start] | [S1 / none] |

---

## 🔗 Related Documentation

- [Journey: Name](../../../inception/6-user-journeys/journey-name.md)
- [Flow NN: Name](../../bounded-contexts/[context]/flows/flow-NN-name.md)
- [BR-XXX: Name](../../bounded-contexts/[context]/business-rules/BR-XXX-name.md)
