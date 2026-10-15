# Journey [XX]: [Feature/Flow Title]

## 🛡️ ADR Compliance Checklist
After generating the flow document, review the project's Architecture Decision Records (ADRs) to ensure alignment with established architectural decisions.

- [ ] Entity mutations use domain methods rather than direct property setters
- [ ] State transitions match entity lifecycle state machine
- [ ] Domain events are published on state changes
- [ ] Repository pattern is used for data access
- [ ] Input validation uses schema validation

## 📋 Overview
* **As a:** [User Role / Persona]
* **I want to:** [Action they want to take]
* **So that:** [The value or outcome they receive]
* **Source:** Inception Step 6 - User Journey Mapping (Journey [X])
* **Related Feature:** [Feature Name] from Wave [X] ([MVP/Phase])
* **Impacted Entities:** 
  * [Entity Name 1](../entities/entity-name-1.md) (e.g., `Order` changes from `Draft` -> `Pending`)
  * [Entity Name 2](../entities/entity-name-2.md) (e.g., `Inventory` item quantity decrements)
* **Bounded Context:** [Bounded Context Name]

---

## 🗺️ Visual Flow & Sequence
*Maps the sequence of user actions, domain behavior, and system reactions for this journey. Follows DDD patterns per ADR-009. **Must include error paths and alternative flows**, not just happy path.*

```mermaid
sequenceDiagram
    autonumber
    actor User as [Actor Role]
    participant UI as Frontend
    participant API as Application Service
    participant Domain as [Aggregate Name]
    participant DB as Repository (or Repository & Outbox)
    participant Worker as Background Worker / Event Bus (optional, per ADRs)
    participant Ext as External Service (optional)

    Note over User,Ext: Journey [XX]: [Flow Name]

    User->>UI: [Initial Action]
    UI->>API: [Request]
    API->>API: [Validation/Processing]
    API->>DB: [Query]
    DB-->>API: [Response]
    
    rect rgb(232, 245, 233)
        note right of UI: Happy Path - All Valid
        API->>Domain: [Domain Operation]
        Note over Domain: Entity state: [State]
        Domain->>Domain: [Domain Method Call]
        Note over Domain: Publishes / Records [Domain Event]
        API->>DB: Save aggregate (and Outbox events if using Outbox pattern)
        DB-->>API: Persisted
        API-->>UI: Success Response
        UI-->>User: [Success Feedback]
        
        opt Async Side Effects (if Outbox / Event Bus used per project ADRs)
            Worker->>DB: Poll pending events / Listen to Event Bus
            Worker->>Ext: [Dispatch async side-effect, e.g. email, webhook]
            Worker->>DB: Mark event processed (if Outbox)
        end
    end

    rect rgb(255, 235, 238)
        note right of UI: Error Path - [Error Type]
        [Error handling sequence]
        API-->>UI: Error Response
        UI-->>User: [Error Feedback]
    end

    Note over User,Ext: Domain Events Published
    Note right of Domain: [Event 1] → [Side Effect 1]<br/>[Event 2] → [Side Effect 2]
```

---

## 🔄 Alternative Flow (Flowchart)

*Shows decision points, branching logic, and error handling paths:*

```mermaid
flowchart TB
    Start([Start]) --> Action1[Action 1]
    Action1 --> Decision1{Decision Point?}
    
    Decision1 -->|Yes| Path1[Path 1]
    Decision1 -->|No| Path2[Path 2]
    
    Path1 --> Result1[Result 1]
    Path2 --> Result2[Result 2]
    
    Result1 --> End1([End])
    Result2 --> End2([End])
    
    style Action1 fill:#e1f5fe
    style Decision1 fill:#fff9c4
    style Result1 fill:#c8e6c9
    style Result2 fill:#ffcdd2
```

---

## 📊 Entity State Diagram

*Shows the lifecycle of the primary entity/aggregate involved in this flow:*

```mermaid
stateDiagram-v2
    [*] --> InitialState
    InitialState --> State1: Event 1
    State1 --> State2: Event 2
    State2 --> State3: Event 3
    State3 --> [*]
    
    note right of State1
        Description of what
        happens in this state
    end note
    
    style InitialState fill:#ffe0b2
    style State1 fill:#fff9c4
    style State2 fill:#e1f5fe
    style State3 fill:#c8e6c9
```

---

## 🏃‍♂️ Step-by-Step Walkthrough (Happy Path)

| Step | User Action | System Reaction | Entity Lifecycle Impact |
| :--- | :--- | :--- | :--- |
| **1** | Clicks "Place Order" | Validates fields, shows loading spinner, sends API request. | None (UI Level) |
| **2** | — | Validates stock availability, reserves items. | `InventoryItem` -> `Reserved` |
| **3** | — | Generates unique order ID, saves invoice draft. | `Order` -> `Draft` |
| **4** | Views payment modal | Redirects user to Stripe checkout overlay. | `Order` -> `PendingPayment` |

---

## ✅ Acceptance Criteria & Scenarios

### Scenario 1: Successful Execution (Happy Path)
* **Given** the user has items in their cart,
* **When** they click "Place Order",
* **Then** the system should redirect them to the payment gateway,
* **And** the `Order` state must transition to `PendingPayment`.

### Scenario 2: Alternative / Parallel Path
* **Given** ...
* **When** ...
* **Then** ...

---

## ⚠️ Edge Cases, Errors, & Boundary Conditions

### 1. Business Logic Failures

| What If | System Handling | Domain Method | Entity Impact |
|---------|-----------------|---------------|---------------|
| Stock drops to 0 at submit | Rollback partial writes, display *"Item no longer available"*, redirect to cart | `Order.create()` throws `InsufficientStockError` | No lifecycle change; `Order` not created |
| [Edge case 2] | [System handling] | [Domain method] | [Entity impact] |

### 2. Technical Failures

| What If | System Handling | Domain Impact |
|---------|-----------------|---------------|
| Stripe webhook fails/delays | Background reconciliation cron polls Stripe every 5 minutes | `Order` safely sits in `PendingPayment` until background task pushes to `Paid` |
| [Technical issue 2] | [System handling] | [Domain impact] |

### 3. Validation Boundary Conditions

| What If | System Handling | Domain Method | Entity Impact |
|---------|-----------------|---------------|---------------|
| [Validation edge case] | [System handling] | [Domain method] | [Entity impact] |

### 4. 🛡️ Concurrency, TOCTOU & Invariant Integrity

| Concurrency Scenario (TOCTOU) | Potential Risk | Mitigation / Guard Mechanism | Error / Outcome |
|-------------------------------|----------------|------------------------------|-----------------|
| **Unique Constraint Race** (e.g. concurrent inserts with same slug/code) | Duplicate entries bypass application-level check | Database-level unique constraint/index + repository exception translation | `409 Conflict` (`[DuplicateKeyError]`) |
| **Quota / Limit Race** (e.g. concurrent creation exceeding tier limits) | User creates multiple resources simultaneously exceeding limits | Atomic transaction / locking / DB constraint | `403 Forbidden` / `422 Unprocessable` |
| **State Machine Race** (e.g. concurrent state transitions on same entity) | Double transition / duplicate events | Optimistic locking (`version` column) / conditional update (`WHERE status = '...'`) | `409 Conflict` (`[StateTransitionError]`) |
| **Dual-Write / Event Race** (e.g. DB commit succeeds but event dispatch fails) | Entity updated without downstream side effects | Transactional Outbox pattern or atomic messaging | Event safely published asynchronously |
| **Idempotency & Replays** (e.g. duplicate webhook/message delivery or double-submit) | Duplicate processing, corrupted aggregates, or duplicate charges/emails | Idempotency key / deduplication table / natural aggregate state checks | `200 OK` (idempotent result) / event acknowledged without side effects |

---

## 🛠️ Technical Notes & Validation Rules

### API Endpoint / Interface Specification

```
POST /api/v1/[endpoint]
Content-Type: application/json
Authorization: Bearer {token}

Request Body:
{
  "field1": "type (required)",
  "field2": "type (optional)"
}

Response: 201 Created
{
  "id": "identifier",
  "field1": "value",
  "status": "state"
}
```

### Input Validation Schema / Contract

```
// Schema defining input validation rules according to project conventions
{
  field1: string, min length 3, max length 100,
  field2: positive integer (optional)
}
```

### Database Constraints & Indexes

| Table / Collection | Column / Field | Constraint / Index Type | Description |
|-------------------|----------------|-------------------------|-------------|
| `[table]` | `[column]` | `[e.g., UNIQUE / NOT NULL / FK]` | [Constraint description] |

### Data Access & Security Policies

```
-- Security & access policies according to project data tier conventions
[Define access rules, ownership checks, or security constraints]
```

### Generated Fields

| Field | Value |
|-------|-------|
| `slug` | [Description] |
| `status` | [Description] |

### Enforced Business Rules

*The `Enforces` edge. Both ends or it didn't ship: listing a rule here means that rule's
`Traces up to` list must link back to this flow.
Convention: [Traceability](../guidelines/traceability.md).*

* [BR-[XXX]](../business-rules/BR-[XXX]-[rule-name].md): [Short business rule active title]

### Enforced Invariants

* [INV-[XXX]](../invariants/INV-[XXX]-[invariant-name].md): [Short invariant strict title]

### Implementation & tests

*Concrete entry points, so a reader changing a rule above can find what to edit.*

| Concern | Where |
| ------- | ----- |
| Entry point | `apps/frontend/src/app/api/v1/[endpoint]/route.ts` |
| Application | `packages/modules/[context]/src/application/commands/[name].handler.ts` |
| Domain | `packages/modules/[context]/src/domain/[entity].ts` |
| Tests (unit) | `tests/unit/modules/[context]/application/commands/[name].test.ts` |
| Tests (E2E) | `tests/e2e/[feature].spec.ts` |

### Domain Events Published

| Event | Triggered By | Side Effects |
|-------|--------------|--------------|
| `[EventName]` | `[Method call]` | [Side effect description] |

---

## 📝 Diagram & Walkthrough Consistency

This flow document follows consistency guidelines:

1. **Step Numbering:** Each step in the walkthrough table corresponds to a logical action in the sequence diagram
2. **Sequence Alignment:** The order of steps matches the sequence shown in the Mermaid diagram
3. **Completeness:** Every major action in the Mermaid diagram has a corresponding step in the walkthrough
4. **Detail Level:** The walkthrough provides additional detail for each Mermaid interaction
5. **Error Paths:** All error scenarios are shown with colored `rect` blocks in the sequence diagram

---

## 🔗 Linked Documentation

| Document | Relationship |
|----------|--------------|
| [Entity Name](../entities/entity-name.md) | Entity lifecycle and state machine |
| [Value Object](../value-objects/value-object-name.md) | Value object definition |
| [ADR-XXX](../../../../adr/XXX-xxx-xxx.md) | Relevant architecture decision |
