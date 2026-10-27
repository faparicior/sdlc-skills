# Audit Docs Skill — Summary

## Purpose

Systematically verify that flow, entity, and business-rule documentation is still aligned with the
real source code. Produces a drift report with verdicts per doc, grouped by bounded context.

This skill does **not** fix anything — it finds and reports. Use `/modify-flow` or direct doc edits
to act on findings.

---

## When to Use

- After several sprints of feature work ("are the docs still accurate?")
- Before a release ("docs health check")
- When onboarding a new team member ("can we trust what's written?")
- After a refactor that touched domain classes or use cases
- Periodically as a quality gate for the living documentation ecosystem

---

## Scope Options

| Scope | Example |
|-------|---------|
| Full audit | "audit all docs", "docs health check" |
| Bounded context | "audit the [context] context" |
| Folder | "audit the journeys", "check the working-on docs" |
| Doc type | "check all business rules", "verify entity lifecycles" |
| Single doc | "is flow-02 still accurate?" |

A full audit covers **every** docs folder, not only the bounded contexts. The report always lists the
folders audited and the ones not audited.

---

## Verdict Levels

| Verdict | Meaning | Typical action |
|---------|---------|---------------|
| ✅ Confirmed | Doc matches code exactly | None |
| ⚠️ Stale | Doc is inaccurate (wrong value, renamed ref, missing step) | Hand-edit doc or `/modify-flow` |
| ❌ Missing | Doc references code that no longer exists | `/modify-flow` to document removal |
| ➕ Undocumented | Code behaviour with no doc | `/create-entity-lifecycle` or `/create-flow-documentation` |

---

## What Gets Checked

| Doc type | Key checks |
|----------|-----------|
| Business Rules (BR-XXX) | File cited exists, enforcement logic present, values match |
| Invariants (INV-XXX) | Same as BRs + must be in domain layer |
| Entity Lifecycle docs | States, transitions, domain events, repository interface |
| Flow docs | Entry point, step sequence, BR/INV citations, Event messaging, external calls, DB constraints, idempotency |
| Journeys, personas, inception | Status lines, behaviour claims ("waits for the next cron"), agreement with the flow docs |
| Proposals, plans, feature specs | Status vs code and vs the parent proposal, folder vs status, checklist boxes, names |
| Architecture assessments | Defaults, nullable fields and flags against code and the latest migrations |
| Deferred decisions, reminders | Embedded code and the original premise still true |
| Reference and UI-spec docs | Every enum value and field name against the code's parser; UI spec vs API reference |
| **Every doc** | Every checkable claim (HTTP status, event, table name, "never/permanently/silently"), doc-against-doc consistency, links, diagrams, and a **claim sweep** before a finding is closed |

---

## Guarantees

- **Read-only:** no file is ever created, modified, or deleted
- **Code-grounded:** every finding cites a real file path and line number
- **No false positives:** ambiguous findings are ⚠️ "needs manual review", not ❌

---

## Files

```
skills/audit-docs/
├── SKILL.md                      # Full skill instructions
├── README.md                     # This summary
├── references/
│   ├── claim-kinds.md            # What to compare each kind of claim with, and how docs usually drift
│   └── slice-prompt.md           # Prompt template for one sub-agent slice of a large audit
└── scripts/
    ├── check-links.sh            # Broken relative links, every folder (skips code fences)
    ├── check-mermaid.mjs         # Diagrams that do not parse (one-time setup in the header)
    ├── check-reciprocity.sh      # Traceability edges present at one end only
    ├── claim-inventory.sh        # Checklist of every checkable claim, by kind
    ├── claim-sweep.sh            # Every place a given wording appears
    ├── make-plan.sh              # Plan mode: cut the docs into slices with a claim worksheet each
    ├── next-slice.sh             # Plan mode: claim the next slice (safe for two workers)
    ├── check-worksheet.sh        # Plan mode: gate that refuses a slice with unanswered claims
    └── merge.sh                  # Plan mode: merge worksheets, whole-tree sweep and checks
```

---

**Version:** 1.1
