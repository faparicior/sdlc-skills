# BR-[Number]: [Short, Active Title of the Business Rule]

* **Status:** [Active | Proposed | Legacy-Discovered]
* **Bounded Context:** [Known Bounded Context OR `Candidate: [TBD / Suspected]`]
* **Source Traceability:** [File path and line numbers, e.g., `legacy/services/OrderManager.ts:145-189`]
* **Domain Tags:** [`[tag1, tag2, tag3]`]

> **Rule:** When [Trigger Condition], then [Apply this Policy / Calculation], otherwise [Fallback Action].

---

## 1. Detailed Rule Logic & Scenarios

*Break down the exact logic found in the code using clear bullet points or pseudo-logic.*

* **Trigger:** [What starts or evaluates this rule?]
* **Condition:** [What criteria must be satisfied?]
* **Enforced Policy:** [What business action, calculation, or state mutation takes place?]
* **Fallback / Else:** [What occurs when the condition is not met?]

---

## 2. System Enforcement & Implementation Details

* **Code Location:** [Class names, functions, route handlers, or database triggers]
* **Enforcement Mechanism:** [Domain Service, Application Handler, Validation Schema, or UI Guard]
* **Violation Behavior:** [Specific domain exception thrown, status transition, or error code returned]
* **Refactoring Note (Brownfield):** [Any coupling, code smell, or technical debt observed during extraction]
