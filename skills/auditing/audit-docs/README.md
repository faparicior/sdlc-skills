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
| Doc type | "check all business rules", "verify entity lifecycles" |
| Single doc | "is flow-02 still accurate?" |

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

---

## Guarantees

- **Read-only:** no file is ever created, modified, or deleted
- **Code-grounded:** every finding cites a real file path and line number
- **No false positives:** ambiguous findings are ⚠️ "needs manual review", not ❌

---

## Files

```
skills/audit-docs/
├── SKILL.md    # Full skill instructions
└── README.md   # This summary
```

---

**Version:** 1.0
