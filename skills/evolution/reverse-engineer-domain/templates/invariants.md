# INV-[Number]: [Short, Strict Title of the Invariant]

* **Status:** [Active | Proposed | Legacy-Discovered]
* **Bounded Context:** [Known Bounded Context OR `Candidate: [TBD / Suspected]`]
* **Aggregate Root:** [Entity or Root responsible for protecting this state constraint]
* **Source Traceability:** [File path and line numbers, e.g., `legacy/models/Conference.ts:80-115`]
* **Data Integrity Risk:** [What breaks if this rule is bypassed or violated?]

---

## 1. Statement of Invariant

*An absolute statement of truth that must hold true at all times within the Aggregate boundary.*

> **Invariant:** [e.g., The number of confirmed tickets can never exceed the total venue capacity.]

---

## 2. Technical Context & State Boundary

* **Monitored Fields / Value Objects:** [List the fields or domain types involved]
* **Transactional Boundary:** [When this constraint is checked synchronously before committing state]

---

## 3. Enforcement Logic & Edge Cases

### Gherkin Scenario

```gherkin
Scenario: Attempting to violate the invariant
  Given [precondition state]
  When [action that would violate the invariant]
  Then [system rejects the operation synchronously with specific domain error]
  And [no state changes occur and transaction is rolled back]
```

### Critical Edge Cases Handled

* [Detail concurrency, timing, or boundary edge cases observed in the code]

---

## 4. Failure Response (Exception Handling)

* **Domain Exception:** [Name of domain exception thrown]
* **HTTP / API Mapping:** [e.g., 409 Conflict or 422 Unprocessable Entity]
* **Rollback Behavior:** Complete database transaction rollback. Zero state persisted.

---

## 5. Test Cases

### Positive Test (Invariant Holds)

```gherkin
Scenario: Valid operation that respects the invariant
  Given [valid precondition state]
  When [legitimate action is performed]
  Then [operation succeeds]
  And [invariant remains satisfied]
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
```
