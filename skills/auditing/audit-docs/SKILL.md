---
name: audit-docs
description: >-
  Systematically verify that flow, entity, and business-rule documentation is still aligned with
  the real source code — and produce a drift report. USE THIS SKILL when user mentions: audit docs,
  are docs up to date, docs drift, check documentation, are flows still accurate, docs vs code,
  verify business rules in code, is the entity lifecycle correct, docs health check, documentation
  review, check if docs match, stale docs, or any request to verify whether existing documentation
  matches the implementation. Produces a drift report per bounded context:
  ✅ confirmed / ⚠️ stale / ❌ missing / ➕ undocumented — without modifying any file.
disable-model-invocation: true
---

# Audit Docs Skill

You are a Technical Auditor for a codebase with living DDD-style documentation — flows, entity
lifecycles, business rules, and invariants. Your job is to systematically compare what each doc
claims against what the code actually does, and produce an actionable drift report.

This skill is **read-only**. It identifies drift; it does not fix it.
Use `/modify-flow` to act on ⚠️ stale or ❌ missing findings that require a code or doc change.

This skill is **language- and framework-agnostic**. Discover paths and conventions fresh each run.

---

## Step 0: Discover This Repo's Conventions (Do This First, Every Time)

1. **Docs tree:** Find where flow/entity/BR/invariant docs live. Build a complete inventory grouped
   by bounded context.
2. **Docs index:** Check if there is a top-level index (README, SDLC index, etc.) — use it as the
   audit checklist baseline.
3. **Source layout:** Identify language, DDD layers, and naming conventions used in source files.
4. **Build/test commands:** Note the real commands from CLAUDE.md, AGENTS.md, or README (for the
   Recommended Actions section).

---

## Scope Detection

Determine scope from the user's request. If not stated, default to **full** and announce it.

| Scope | When | What |
|-------|------|------|
| Full | "audit all docs", "docs health check", no scope given | All bounded contexts, all doc types |
| Bounded context | "audit the conference context", "check submission docs" | One context, all doc types |
| Doc type | "check all BRs", "verify entity lifecycles" | All contexts, one doc type |
| Single doc | "is this flow still accurate?", pointing at one file | One specific doc |

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

### Traceability (applies to every doc type)

Rules and invariants are only findable if their links exist at **both ends**. These checks are
mechanical — run them before judging content quality. Full convention (shared across SDLC skills):
[../guidelines/traceability.md](../guidelines/traceability.md) — canonical in this repo at
`docs/product/guidelines/traceability.md`.

| Check | How to run it | Verdict when it fails |
| --- | --- | --- |
| **Reciprocity** | For each `BR-*`/`INV-*` in a flow/entity/value-object `Enforces` list, confirm the rule doc lists that flow/entity back (in `Traces up to` / `Enforced by`); and vice versa | ⚠️ Stale — half an edge |
| **Completeness of `Enforced by`** | Every layer that can reject this policy is a row: contract/Zod, application, domain, infrastructure, database, UI. Grep the module for the rule's error class and the guard message; each hit is a missing row | ⚠️ Stale (thin) or ❌ Missing |
| **Existence** | Every path and `Symbol.method` in `Enforced by` / `Verified by` still resolves — `test -f` the path, `grep` the symbol in it | ❌ Missing (doc cites code that is gone) |
| **Test anchor** | Rule has ≥1 `Verified by` test whose title actually appears in that file (`grep -n "<title>" <file>`) | ⚠️ Stale — unverifiable rule |
| **Status honesty** | ✅ Verified rows are confirmed by opening the file; anything believed goes ⚠️ Unverified; not-yet-built goes ⏳ Planned with no test claim | ⚠️ Stale — unearned ✅ |
| **Convention mirror** | The shared SDLC mirror is byte-identical to the canonical convention — `cmp -s docs/product/guidelines/traceability.md .agents/skills/sessioflow-sdlc/guidelines/traceability.md` (the file carries no relative links outside its fenced examples, so equality is the requirement; shared across SDLC skills) | ⚠️ Stale — skill teaches outdated rules; re-sync with `cp` |
| **Untagged enforcement** | A rule has flow coverage but no enforcement row that a grep can find | ⚠️ Unverified — record the site by hand |

Report a rule with an empty `Enforced by` table **and** an active flow as the highest-risk finding in
the audit: either the code is unlinked or the policy is unimplemented, and the doc cannot tell them
apart.

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

---

## Summary

| Bounded Context | ✅ Confirmed | ⚠️ Stale | ❌ Missing | ➕ Undocumented |
|-----------------|-------------|---------|----------|----------------|
| [context-A]     | N           | N       | N        | N              |
| [context-B]     | N           | N       | N        | N              |
| **Total**       | N           | N       | N        | N              |

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

---

## Related Skills

| Skill | When to use |
|-------|-------------|
| `explore-domain` | Understand a specific part of the system (one question, not a sweep) |
| `modify-flow` | Fix stale/missing documentation or change behaviour |
| `create-flow-documentation` | Document behaviour that has no flow doc at all |
| `create-entity-lifecycle` | Document an entity that has no lifecycle doc at all |

---

**Version:** 1.0
