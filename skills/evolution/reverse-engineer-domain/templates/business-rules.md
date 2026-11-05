# BR-[000 / RAW-000]: [Short, Active Title of the Business Rule]

<!--
Remove all HTML comments in the delivered document.
Use BR-XXX for high-confidence bounded-context rules; use BR-RAW-XXX when staging in docs/product/discovered/business-rules/.
-->

* **Status:** [Active | Proposed | Legacy-Discovered | Retired]
* **Domain Context:** [Known Bounded Context OR `Candidate: [TBD / Suspected]`]
* **Business Owner:** [Product Owner / Stakeholder name, or `TBD (Reverse-Engineered)`]
* **Source Traceability:** [File path and line numbers, e.g., `legacy/services/OrderManager.ts:145-189`]
* **Domain Tags:** [`[tag1, tag2, tag3]`]
* **Last Reviewed:** YYYY-MM-DD
* **Rule Type:** Business Rule (not an invariant - can have exceptions/fallbacks)

---

## 1. Summary
<!-- A clear, single-sentence definition of the business policy written in plain language using the Ubiquitous Language. -->

> **Rule:** When [Trigger Event happens], then [Apply this Policy/Calculation], otherwise [Fallback Action].

**Note:** Unlike an invariant, this rule can have exceptions, fallbacks, or asynchronous handling. Violation does not require transaction rollback.

## 2. Business Context & Rationale
<!-- Why does this rule exist? What business metric, legal requirement, or operational workflow drives this policy? -->

* **Objective:** [e.g., To increase customer retention during the checkout process.]
* **Source:** [e.g., Reverse-engineered from `OrderManager.ts` / Product Strategy Memo Q2.]

## 3. Detailed Rule Logic & Scenarios
<!-- Break down the exact logic found in the code using tables, bullet points, or Gherkin syntax (Given/When/Then). -->

### Evaluation Logic
* **Trigger:** [What starts or evaluates this rule?]
* **If** [Condition 1] -> [Apply Policy 1].
* **If** [Condition 2] -> [Apply Policy 2].
* **Else (Fallback):** -> [Apply fallback action].

### Asynchronous or Downstream Effects
* [e.g., When a discount higher than 15% is applied, emit `HighDiscountAppliedEvent` to notify the accounting team.]

## 4. System Enforcement (How It’s Handled)
<!-- Unlike an invariant (which sits strictly inside an Aggregate Root), a business rule can be enforced via Domain Services, Policy objects, or workflow orchestration. -->

* **Enforcement Layer:** [e.g., Application/Domain Service, Dynamic Pricing Policy, or Workflow Engine]
* **Handling Violations/Exceptions:** [Specific domain exception thrown, status transition, or fallback behavior]
* **Refactoring Note (Brownfield):** [Any coupling, code smell, or technical debt observed during extraction]

## 5. Traceability

<!-- Every edge is a relative link, and every edge has two ends: adding one here means adding the reciprocal link in that document, in the same commit. -->

### Traces up to

* Journey: [Journey XX — Title](<docs-root>/inception/5-user-journeys/[journey-XX]-[name].md) *(or `None — legacy discovered`)*
* Flow: [Flow — Journey XX](../flows/[journey-XX]-[name].md) *(or `None — legacy discovered`)*

### Related rules

* [INV-XXX](../invariants/INV-XXX-[name].md): [Short title]

### Enforced by

<!-- Every layer where the policy actually lives. Name the file AND the guard. Status: ✅ Verified (you read the guard) · ⚠️ Unverified (believed, not confirmed) · ⏳ Planned (documented, not built). -->

| Layer | Where | Guard | Status |
| ----- | ----- | ----- | ------ |
| Boundary validation (request, schema or DTO) | `<source-root>/<boundary>/[file]` | `[Schema]` refinement | ✅ Verified |
| Application | `<source-root>/<application>/[use-case]` | `[Handler].execute()` | ✅ Verified |
| Domain | `<source-root>/<domain>/[entity]` | `[Entity].[method]()` | ✅ Verified |
| Infrastructure | `<source-root>/<infrastructure>/[file]` | `[repository].[method]()` | ✅ Verified |
| Database | `<migrations>/[file]` | `[unique index / constraint name]` | ⚠️ Unverified |
| UI | `<ui-root>/[form]` | [what it does with the failure] | ✅ Verified |

### Verified by

* `<test-root>/<application>/[use-case]-test` — "[exact test title]"

### In flight

Active proposals touching it under `docs/product/working-on/`, else *none*.

---

## 6. History & Evolution

* **YYYY-MM-DD:** Rule extracted from legacy/brownfield source (`[file:line]`).
