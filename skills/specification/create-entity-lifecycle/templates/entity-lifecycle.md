# Entity: [Entity Name (e.g., Order, Subscription)]

## 📋 Definition & Context
* **Description:** [Brief summary of what this entity represents in the system domain]
* **Database Table / Collection:** `[table_or_collection_name]`
* **Primary Key / Identifier:** `[id format, e.g., UUIDv4]`
* **Owner Team:** [e.g., Core Commerce / Billing Team]

---

## 🗺️ State Machine Diagram
*This Mermaid diagram models all valid states and transitions for this entity. It renders natively in GitHub, GitLab, and Obsidian.*

```mermaid
stateDiagram-v2
    [*] --> [Initial_State] : [Triggering Action/Event]
    [Initial_State] --> [Next_State] : [Successful Event]
    [Initial_State] --> [Terminal_State_Failed] : [Failure/Cancellation]
    
    [Next_State] --> [Final_State] : [Completion Event]
    [Final_State] --> [*]
```

---

## 🔄 State Transition Matrix
*A strict mapping of every allowed state change, the trigger behind it, and any automatic system side-effects.*

| Current State | Event / Trigger | Target State | Guards / Conditions | Side Effects / Actions | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `[e.g., DRAFT]` | User clicks "Submit" | `[PENDING]` | Cart total must be > 0 | Deduct inventory stock; lock items for 15 mins. | ✅ Built |
| `[e.g., PENDING]`| Stripe webhook success | `[PAID]` | Payment status == paid | Generate invoice; trigger confirmation email. | ✅ Built |
| `[e.g., PENDING]`| Cron timeout (15m) | `[CANCELLED]` | Time elapsed > 15 mins | Release inventory lock back to stock pool. | ⏳ Planned |

> **Status is a claim about the class, not about the product.** Open the domain class before filling this
> column: `✅ Built` only when you found the mutator or trigger in the code you read, `⚠️ Unverified` when
> you believe it but did not look, `⏳ Planned` when no code exists yet. A `⏳` row is written in the
> future tense ("will publish `X`"), never in the present tense — present tense asserts the code ships.
> A state machine that documents the whole target product as if it were Wave 1 is the single most
> expensive drift this document can carry. Convention: [Traceability](../guidelines/traceability.md).

---

## 🔍 State Definitions
*Detailed criteria for what each state means in plain English.*

* **`[STATE_NAME_1]`**: The entity has been created but is not yet finalized or validated. (e.g., `DRAFT`).
* **`[STATE_NAME_2]`**: Awaiting a critical async response or third-party confirmation. (e.g., `PENDING_PAYMENT`).
* **`[STATE_NAME_3]`**: The terminal successful state of the entity. (e.g., `COMPLETED`).
* **`[STATE_NAME_4]`**: The entity is dead/archived and can no longer transition. (e.g., `CANCELLED`).

---

## 🎯 Domain Behavior

*The public API of the class as it exists. This section exists precisely so that "the aggregate will*
*grow `closeCfp()` someday" cannot enter the document as a present-tense table row.*

| Method | Purpose | Preconditions | Effects | Status |
| ------ | ------- | ------------- | ------- | ------ |
| `[Entity].[mutator]()` | [What it does] | [Guard, e.g. status must be `DRAFT`] | [Status change; events emitted] | ✅ Built |
| `[Entity].[plannedMutator]()` | [Behaviour not built yet] | [Planned guard] | [Will emit `[DomainEvent]`] | ⏳ Planned |

---

## 📣 Domain Events

*One row per event the class actually constructs, and per worker that actually consumes it. A side*
*effect with no consumer built is a finding, not a bullet: leave it out or mark the row `⏳ Planned`.*

| Domain Event | Constructed By | Payload | Consumer / Side Effects | Status |
| ------------ | -------------- | ------- | ----------------------- | ------ |
| `[EntityCreated]` | `[Entity].[create]()` | [key fields] | [Consumer that exists today, e.g. Outbox processor] | ✅ Built |
| `[EntityClosed]` | `[Entity].[close]()` *(not built)* | [planned fields] | *(no consumer yet — do not list an unbuilt email worker)* | ⏳ Planned |

---

## 🔒 Invariants & Business Rules

*The `Enforces` edge: every rule this entity is responsible for upholding. Both ends or it didn't
ship — each rule listed here must link back to this entity in its `Enforced by` table.
Convention: [Traceability](../guidelines/traceability.md).*

* **Invariants:**
  * [INV-[XXX]](../invariants/INV-[XXX]-[invariant-name].md): [Short invariant strict title]

* **Business Rules:**
  * [BR-[XXX]](../business-rules/BR-[XXX]-[rule-name].md): [Short business rule active title]

### Enforcement & tests

Where each guard lives and what pins it.

| Rule | Enforcing member | Test |
| ---- | ---------------- | ---- |
| [INV-[XXX]](../invariants/INV-[XXX]-[invariant-name].md) | `[Entity].[mutator]()` | `tests/unit/modules/[context]/domain/[entity].test.ts` |
| [BR-[XXX]](../business-rules/BR-[XXX]-[rule-name].md) | `[Entity].[method]()` / `[ValueObject].create()` | `tests/unit/modules/[context]/domain/value-objects/[vo].test.ts` |

> Name only an enforcing member and a test file you opened. A `✅` you did not earn by reading the file
> is worse than a `⚠️`.

---

## 🛠️ Repository Interface *(aggregate roots only)*

*Transcribe the persistence port that exists in `domain/` today — signatures included, optional*
*parameters included (`save(entity, tx?)`; that `tx` is what makes the Transactional Outbox atomic). Do*
*not add the methods you wish the port had: a phantom `findByStatus()` here is how a repository drifts*
*for months without anyone noticing. Omit unbuilt methods, or label them `⏳ Planned`.*

```typescript
// Copied from <path to the real port>, never from a design sketch.
export interface [Entity]Repository {
  findById(id: [Entity]Id): Promise<[Entity] | null>;
  save(entity: [Entity], tx?: TransactionClient): Promise<void>;
}
```

---

## 🔗 Linked User Stories & Flows
*Relative links to the User Stories/Flows that interact with or trigger mutations on this entity.*

* [US-101 Example Flow](../flows/US-101-example-flow.md): Triggers transition from `None` -> `DRAFT`
* [US-202 Example Payment](../flows/US-202-example-payment.md): Triggers transition from `PENDING` -> `PAID` or `CANCELLED`
