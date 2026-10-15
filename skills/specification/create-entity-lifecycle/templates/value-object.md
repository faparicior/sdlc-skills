# Value Object: [VoName]

## 📋 Definition
* **Description:** [Brief summary of what this value object represents in the domain]
* **Type:** [Simple Value Object | Composite Value Object]
* **Immutability:** ✅ Immutable
* **Validation:** [Summary of validation constraints]

---

## 🎯 Composition

| Property | Type | Description |
|----------|------|-------------|
| `[field]` | `[Type]` | [Description] |

---

## ✅ Validation Rules

| Rule | Description |
|------|-------------|
| **[Rule Name]** | [What is validated and why] |

---

## 🎯 Behavior & Methods

| Method | Purpose | Status |
|--------|---------| ------ |
| `static create(rawValue)` | Static factory method creating validated instance (enforces invariants) | ✅ Built |
| `static fromData(rawValue)` | Static factory method reconstituting from database (bypasses time-relative validation) | ✅ Built |
| `get value` | Encapsulated getter for underlying primitive | ✅ Built |
| `equals(other)` | Structural equality comparison | ✅ Built |

> `✅ Built` only for a member you found in the class you opened; `⏳ Planned` for anything you are
> specifying rather than describing. Never leave a method row in the present tense if the code does not
> have it.

---

## ⚠️ Error Conditions

| Error | Trigger | Status |
|-------|---------| ------ |
| `[ExceptionClass]` | [When it is thrown] | ✅ Built |

---

## 🔒 Invariants

*The `Enforces` edge: every rule this value object is responsible for upholding. Both ends or it didn't
ship — each rule listed here must link back to this value object in its `Enforced by` table.
Convention: [Traceability](../guidelines/traceability.md).*

* [INV-[XXX]](../invariants/INV-[XXX]-[invariant-name].md): [Short invariant title]
* [BR-[XXX]](../business-rules/BR-[XXX]-[rule-name].md): [Short business rule title]

---

## 🔗 Referenced By

| Entity / Use Case | Usage |
|-------------------|-------|
| [EntityName](../entities/EntityName.md) | [How this VO is used] |

---

## 🔗 Related Value Objects

| Value Object | Purpose |
|--------------|---------|
| [VoName](VoName.md) | [Relationship] |
