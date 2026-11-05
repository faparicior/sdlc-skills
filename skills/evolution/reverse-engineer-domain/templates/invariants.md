# INV-[000 / RAW-000]: [Short, Strict Title of the Invariant]

<!--
Remove all HTML comments in the delivered document.
Use INV-XXX for high-confidence bounded-context invariants; use INV-RAW-XXX when staging in docs/product/discovered/invariants/.
-->

* **Status:** [Active | Proposed | Legacy-Discovered | Retired]
* **Bounded Context:** [Known Bounded Context OR `Candidate: [TBD / Suspected]`]
* **Aggregate Root:** [e.g., `Event` Aggregate]
* **Source Traceability:** [File path and line numbers, e.g., `legacy/models/Conference.ts:80-115`]
* **Domain Tags:** [`[tag1, tag2, tag3]`]
* **Data Integrity Risk:** [e.g., Overbooking, Corrupt State, Financial/Inventory Discrepancy]
* **Invariant Type:** Strict constraint (must be protected inside Aggregate Root, no fallbacks)

---

## 1. Statement of Invariant
<!-- An absolute statement of truth that must hold true at all times within the Aggregate boundary. Violating this means transaction failure. -->

> **Invariant:** [e.g., The number of `ConfirmedTickets` can never exceed the `TotalCapacity` of the Event.]

**Note:** Unlike a business rule, this invariant:
- MUST be enforced synchronously inside the Aggregate Root
- CANNOT have exceptions or fallbacks
- MUST result in immediate transaction rollback if violated
- If violated, the system enters an illegal state

## 2. Technical Context & State Boundary
<!-- Define exactly which fields, value objects, or entities inside the Aggregate Root are involved in maintaining this consistency. -->

* **Monitored Fields:**
  * `[Entity.field1]` ([Type])
  * `[Entity.field2]` ([Type])
* **Transactional Boundary:** Enforced synchronously during any command that alters the monitored fields.

## 3. Enforcement Logic & Edge Cases
<!-- Specify the exact condition under which the operation must fail using Gherkin scenarios to illustrate how the aggregate root guards this boundary. -->

### Gherkin Scenarios

```gherkin
Scenario: Attempting to violate the invariant
  Given [precondition state describing the current valid state]
  When [action or command that would violate the invariant]
  Then [system rejects the operation with [SpecificDomainException]]
  And [no state changes occur]
  And [database transaction is rolled back]
```

### Critical Edge Cases Handled:
* **Edge Case 1:** [Describe critical edge case observed in the code]
* **Edge Case 2:** [Describe concurrency or race challenge]

## 4. Failure Response (Exception Handling)

* **Domain Exception:** `[SpecificDomainException]`
* **HTTP/API Mapping:** `[e.g., 409 Conflict or 422 Unprocessable Entity]`
* **Rollback Behavior:** Complete database transaction rollback. No state is persisted.

## 5. Test Cases

### Positive Test (Invariant Holds)
```gherkin
Scenario: Valid operation that respects the invariant
  Given [valid precondition state]
  When [legitimate action is performed]
  Then [operation succeeds]
  And [invariant remains satisfied]
  And [appropriate domain event is published if applicable]
```

### Negative Test (Invariant Violation Blocked)
```gherkin
Scenario: Attempted violation of the invariant
  Given [precondition state]
  When [action that would violate the invariant]
  Then [system throws [SpecificDomainException]]
  And [HTTP response is [4xx error code]]
  And [database transaction is rolled back]
  And [no state changes are persisted]
  And [user receives clear error message explaining the violation]
```

## 6. Traceability

<!-- Every edge is a relative link, and every edge has two ends: adding one here means adding the reciprocal link in that document, in the same commit. -->

### Traces up to

* Journey: [Journey XX — Title](<docs-root>/inception/5-user-journeys/[journey-XX]-[name].md) *(or `None — legacy discovered`)*
* Flow: [Flow — Journey XX](../flows/[journey-XX]-[name].md) *(or `None — legacy discovered`)*

### Related rules

* [BR-XXX](../business-rules/BR-XXX-[name].md): [Short title]

### Enforced by

<!-- Every layer that upholds this invariant. Name the file AND the guard. Status: ✅ Verified (you read the guard) · ⚠️ Unverified (believed, not confirmed) · ⏳ Planned (documented, not built). -->

| Layer | Where | Guard | Status |
| ----- | ----- | ----- | ------ |
| Domain — aggregate root | `<source-root>/<domain>/[entity]` | `[Entity].[mutator]()` | ✅ Verified |
| Domain — value object | `<source-root>/<domain>/[value-object]` | `[ValueObject].create()` | ✅ Verified |
| Database | `<migrations>/[file]` | `[unique index / constraint name]` | ⚠️ Unverified |

### Verified by

* `<test-root>/<domain>/[entity]-test` — "[exact test title]"

### In flight

Active proposals touching it under `docs/product/working-on/`, else *none*.

---

## 7. History & Evolution

* **YYYY-MM-DD:** Invariant extracted from legacy/brownfield source (`[file:line]`).
