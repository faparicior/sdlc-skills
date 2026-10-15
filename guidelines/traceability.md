# Traceability: Linking Rules to Flows, Entities and Code

> **This file is mirrored, byte-for-byte, into the SDLC skills pack**: it is stored centrally at
> `.agents/skills/sessioflow-sdlc/guidelines/traceability.md` (shared across `create-entity-lifecycle`,
> `create-flow-documentation`, `modify-flow` and `audit-docs` via `../guidelines/traceability.md`),
> so the skill pack carries the whole convention when it moves to another repository. Two rules keep the
> mirror honest: this file holds **no relative links outside its fenced examples** (paths are `code` spans,
> so it reads the same anywhere), and only the canonical copy — `docs/product/guidelines/traceability.md` —
> is edited; propagate with `cp`. `/audit-docs` diffs the shared copy and reports any difference as ⚠️ Stale.
> The examples below are SessioFlow-shaped (`packages/modules/**`, `docs/product/bounded-contexts/**`): map
> them onto your own layering when using the convention in another repository, and keep the edge
> vocabulary and the status legend unchanged.

A business rule or invariant is only useful if you can answer two questions in one hop:

- **Up (`⬆️`)** — why does this rule exist? Which journey, flow and feature realize it?
- **Down (`⬇️`)** — if I change this rule, what breaks? Which entities, code layers and tests enforce it?

Both directions are **relative markdown links inside the documents themselves**. No index file, no
generated artifact, no tooling: the documents are the traceability system.

## The One Rule: an Edge Exists at Both Ends

> If a link exists on one side only, the edge does not exist.

Adding `[BR-004]` to a flow document is **half a change**. The other half is adding that flow to
BR-004's `Traces up to` list, in the same commit. An agent that starts from the rule and finds
nothing there will conclude — wrongly — that the rule is unimplemented.

## Edge Vocabulary

Use these names for the edges. Synonyms fragment the graph; consistency is what makes it readable.

| Direction | Edge | Written in | Means |
| --- | --- | --- | --- |
| ⬆️ | `Traces up to` | rule doc | Journey / flow / feature that realizes the rule |
| ⬆️ | `Enforces` | entity, value-object & flow docs | Rule this artifact is responsible for upholding |
| ⬆️ | `Related rules` | rule doc | Other `BR-*` / `INV-*` it depends on or overlaps |
| ⬇️ | `Enforced by` | rule doc | Every layer where the policy actually lives |
| ⬇️ | `Verified by` | rule doc | Tests that fail when the policy changes |
| ⬇️ | `In flight` | rule doc | Active `working-on/*/proposal.md` touching it |

Rules are addressed by their ID as written in the file name — `BR-004`, `INV-002` — never by a bare
number and never by prose ("the free-tier rule"), because an ID is greppable and prose is not.

## What Each Document Type Must Carry

| Document | Must contain |
| --- | --- |
| `business-rules/BR-*.md`, `invariants/INV-*.md` | `Traces up to`, `Enforced by`, `Verified by` |
| `entities/*.md` | `🔒 Invariants & Business Rules` (`Enforces`) + `Enforcement & tests` |
| `value-objects/*.md` | `🔒 Invariants & Business Rules` (`Enforces`) |
| `flows/*.md`, `flows/features/[journey-id]/*.md` | `Enforced Business Rules`, `Enforced Invariants`, `Implementation & tests` |

An ID cited in prose does **not** count as an edge — `enforces BR-003 (checked before the free-tier
rule)` inside a sequence diagram is commentary. The edge is the link in the section above it.

## The `Enforced by` Table: One Rule Can Be Split Across Layers

Most policies are enforced more than once — contract validation, a domain guard, a database
constraint, the UI surfacing the failure. List **every** layer; a reader deciding what to edit needs
the complete picture, and "it's also checked somewhere" is not actionable.

```markdown
### Enforced by

| Layer | Where | Guard | Status |
| ----- | ----- | ----- | ------ |
| Contract (shared schema) | `packages/api-definitions/src/zod/conference.ts` | `ConferenceCreateSchema` date-order refinement | ✅ Verified |
| Domain — value object | `packages/modules/conference/src/domain/value-objects/cfp-config.ts` | `CfpConfig.create()` | ✅ Verified |
| Database | `packages/shared/database/src/schema.ts` | `conferences_slug_unique` | ⚠️ Unverified |
| UI | `apps/frontend/src/modules/conference/conference-form.tsx` | error rendering | ✅ Verified |
| Domain — aggregate | `packages/modules/conference/src/domain/conference.ts` | `Conference.publishCfp()` | ⏳ Planned |
```

Status vocabulary — the honest states, and the only reason the table stays trustworthy:

| Status | Meaning | Implies |
| --- | --- | --- |
| ✅ **Verified** | You opened the file and saw the guard | Safe to treat as current |
| ⚠️ **Unverified** | Believed to be enforced (legacy/brownfield, hearsay, or inferred from behaviour) | Goes on the audit queue; **never** treat as fact |
| ⏳ **Planned** | Documented, not built yet (later wave) | `R3`-style gap; expected, not drift |

Anything unlabeled is a rumor. An empty `Enforced by` table on a rule that a flow already exercises
is the single most dangerous row in the tree: either the code is unlinked or the policy is missing,
and nobody knows which.

## Brownfield and Legacy Code

Tagging legacy source with `BR-*` comments is not required and usually won't happen — you may not be
allowed to touch those files, one rule spans ten call sites, and a comment nobody verifies rots.
**Declare the edge from the document side instead**: a rule doc listing five enforcement sites is one
edit; five source comments are five edits in five places you may not own.

When you can't confirm a site by reading it, use ⚠️ **Unverified** rather than omitting it or
claiming ✅. The link is the claim; the status is your confidence in it. That combination is
auditable, while silence is not.

Code tags remain useful where they already exist (`(BR-001)` in a comment or test title) — they are
free corroboration and they make a file greppable. They are **evidence, not the record**: never the
only way an edge is expressed, because deleting a comment would silently erase a requirement.

## Working With the Links

**Creating a rule** (`/create-entity-lifecycle`): the rule is incomplete until `Traces up to`,
`Enforced by` and `Verified by` are filled. "No tests yet" is acceptable only with a ⏳ Planned row
and a matching gap in the flow document.

**Modifying a rule** (`/modify-flow`): open the rule doc **first** and read its Traceability section
— that is your blast radius. Every row is a candidate for the proposal's impact tables, and every
`Verified by` test is a test you may have to rewrite. Ship only when both ends are updated.

**Auditing** (`/audit-docs`): three mechanical checks, all of them drift you can see without running
anything:

1. **Reciprocity** — every ⬆️ link has a matching ⬇️ link, and vice versa.
2. **Existence** — every path and symbol in an `Enforced by` row still resolves; every test in
   `Verified by` still exists.
3. **Staleness** — ⚠️ Unverified rows that have sat there for a release, and ✅ Verified rows whose
   cited guard no longer exists in the file.

## Worked Example: One Edge, Both Ends

Rule side — `business-rules/BR-004-free-tier-conference-limit.md`:

```markdown
## 5. Traceability

### Traces up to

* Journey: [Journey 01 — Setup Conference](../../../../inception/5-user-journeys/journey-01-setup-conference.md)
* Flow: [Journey 01 — Setup Conference](../flows/journey-01-setup-conference.md)
* Feature: [Feature 01 — Conference Creation with CfP](../flows/features/journey-01/feature-01-conference-creation-with-cfp.md)

### Enforced by

| Layer | Where | Guard | Status |
| ----- | ----- | ----- | ------ |
| Application | `packages/modules/conference/src/application/commands/create-conference/create-conference.handler.ts` | `CreateConferenceHandler.execute()` | ✅ Verified |
| Infrastructure | `packages/modules/conference/src/infrastructure/database/conference.repository.ts` | `countActiveByOrganizerId()` | ✅ Verified |

### Verified by

* `tests/unit/modules/conference/application/commands/create-conference/create-conference.test.ts` — "runs the BR-003 slug check before the BR-004 free-tier check"
```

Entity side — `entities/conference.md`, in the `🔒 Invariants & Business Rules` section that already
exists:

```markdown
* **Business Rules:**
  * [BR-004](../business-rules/BR-004-free-tier-conference-limit.md): Free Tier Conference Creation Limit

### Enforcement & tests

| Rule | Enforcing member | Test |
| ---- | ---------------- | ---- |
| [BR-004](../business-rules/BR-004-free-tier-conference-limit.md) | `CreateConferenceHandler.execute()` + `countActiveByOrganizerId()` | `tests/unit/modules/conference/application/commands/create-conference/create-conference.test.ts` |
```

Each edge is written twice — once per side — and each side is written by whoever knows it. Nothing
else to maintain.

## Anti-Patterns

| ❌ Don't | ✅ Instead |
| --- | --- |
| Cite a rule only in prose or a diagram note | Link it in the `Enforces` / `Traces up to` list |
| List a rule in an entity but not its rule doc | Write both ends in the same commit |
| Say "enforced in the domain layer" | Name the file and the guard method |
| Mark a legacy guess ✅ Verified | Mark it ⚠️ Unverified and audit it |
| Add a new ID for a modified rule | Keep the ID, add a dated `History & Evolution` entry |
| Hand-maintain a second copy of the graph elsewhere | Keep edges in the docs; link, don't copy |
| Rename a file and fix only your own links | Fix the reciprocal links too — `grep -rn "old-name.md" docs` |

## Related

Read alongside this convention (paths relative to the repository root, deliberately not links so the
mirrors stay byte-identical):

- `docs/product/guidelines/business-rules-vs-invariants.md` — deciding whether a constraint is a `BR-*`
  or an `INV-*`
- `docs/product/guidelines/flow-documentation-structure.md` — the shape of a flow document
- Templates that emit the sections defined here: `docs/templates/product/business-rules.md`,
  `docs/templates/product/invariants.md`, `docs/templates/product/entity-lifecycle.md`,
  `docs/templates/product/flows.md` — each skill bundles its own copies under `templates/`
- Where the convention is applied: `create-entity-lifecycle` Step 5 and Step 6.3, `create-flow-documentation`
  Step 6, `modify-flow` Step 1.9–1.10 and Step 5.4, `audit-docs` Traceability check table
