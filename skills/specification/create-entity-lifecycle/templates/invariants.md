# INV-[000]: [Short, Strict Title of the Invariant]

* **Status:** [Active | Proposed | Retired]
* **Bounded Context:** [e.g., Event Management Bounded Context]
* **Aggregate Root:** [e.g., `Event` Aggregate]
* **Data Integrity Risk:** [e.g., Overbooking, Corrupt State, Financial/Inventory Discrepancy]
* **Invariant Type:** Strict constraint (must be protected inside Aggregate Root, no fallbacks)

---

## 1. Statement of Invariant
*An absolute statement of truth that must hold true at all times within the Aggregate boundary. There are no "if-else workflows" or "fallbacks" here—violating this means transaction failure.*

> **Invariant:** [e.g., The number of `ConfirmedTickets` can never exceed the `TotalCapacity` of the Event.]

**Note:** Unlike a business rule, this invariant:
- MUST be enforced synchronously inside the Aggregate Root
- CANNOT have exceptions or fallbacks
- MUST result in immediate transaction rollback if violated
- If violated, the system enters an illegal state

## 2. Technical Context & State Boundary
*Define exactly which fields, value objects, or entities inside the Aggregate Root are involved in maintaining this consistency.*

* **Monitored Fields:**
  * `Event.capacity` (Integer)
  * `Event.tickets` (Collection of Ticket entities where status == CONFIRMED)
* **Transactional Boundary:** Enforced synchronously during any command that alters ticket state or event capacity.

## 3. Enforcement Logic & Edge Cases
*Specify the exact condition under which the operation must fail using Gherkin scenarios to illustrate how the aggregate root guards this boundary.*

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
* **Edge Case 1:** [Describe critical edge case, e.g., "Capacity Reduction: What happens if an Organizer tries to lower the event capacity *below* the current number of confirmed tickets?"]
* **Edge Case 2:** [Describe concurrency challenge, e.g., "If two users attempt conflicting operations simultaneously, the aggregate locking mechanism must guarantee serial execution"]

## 4. Failure Response (Exception Handling)
*What happens when this invariant is violated? Invariants always result in a rejected transaction and a domain exception.*

* **Domain Exception:** `[SpecificDomainException]`
* **HTTP/API Mapping:** `[e.g., 409 Conflict or 422 Unprocessable Entity]`
* **Rollback Behavior:** Complete database transaction rollback. No state is persisted.

## 5. Test Cases
*Concrete test scenarios that verify the invariant is enforced at the integration test level.*

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

*Every edge is a relative link, and every edge has two ends: adding one here means adding the reciprocal link in that document, in the same commit. Convention: [Traceability](../guidelines/traceability.md).*

### Traces up to

Why this invariant exists.

* Journey: [Journey XX — Title](../../../../inception/5-user-journeys/[journey-XX]-[name].md)
* Flow: [Flow — Journey XX](../flows/[journey-XX]-[name].md)
* Feature: [Feature XX — Title](../flows/features/[journey-id]/[feature-XX]-[name].md)

### Related rules

Rules or invariants it depends on, overlaps or contradicts.

* [BR-XXX](../business-rules/BR-XXX-[name].md): [Short title]

### Enforced by

Every layer that upholds this invariant. A rule is commonly split across layers;
name the file **and** the guard, because "enforced in the domain" is not actionable. Status:
✅ Verified (you read the guard) · ⚠️ Unverified (believed, not confirmed — legacy/brownfield)
· ⏳ Planned (documented, not built).

| Layer | Where | Guard | Status |
| ----- | ----- | ----- | ------ |
| Domain — aggregate root | `packages/modules/[context]/src/domain/[entity].ts` | `[Entity].[mutator]()` | ✅ Verified |
| Domain — value object | `packages/modules/[context]/src/domain/value-objects/[vo].ts` | `[ValueObject].create()` | ✅ Verified |
| Database | `packages/shared/database/src/schema.ts` | `[unique index / constraint name]` | ⚠️ Unverified |

### Verified by

Tests that fail when this invariant stops holding.

* `tests/unit/modules/[context]/domain/[entity].test.ts` — "[exact test title]"

### In flight

Active proposals touching it under `docs/product/working-on/`, else *none*.

---

## 7. History & Evolution
*While invariants rarely change (as they define the core truth of the domain model), track any structural adjustments here.*

* **YYYY-MM-DD:** Invariant defined alongside [related feature/entity introduction].