# BR-[000]: [Short, Active Title of the Business Rule]

* **Status:** [Active | Proposed | Retired]
* **Domain Context:** [e.g., Billing Bounded Context / Notification Subdomain]
* **Business Owner:** [Product Owner / Stakeholder name]
* **Last Reviewed:** YYYY-MM-DD
* **Rule Type:** Business Rule (not an invariant - can have exceptions/fallbacks)

---

## 1. Summary
*A clear, single-sentence definition of the business policy written in plain language using the Ubiquitous Language.*

> **Rule:** When [Trigger Event happens], then [Apply this Policy/Calculation], otherwise [Fallback Action].

**Note:** Unlike an invariant, this rule can have exceptions, fallbacks, or asynchronous handling. Violation does not require transaction rollback.

## 2. Business Context & Rationale
*Why does this rule exist? What business metric, legal requirement, or operational workflow drives this policy?*

* **Objective:** [e.g., To increase customer retention during the checkout process.]
* **Source:** [e.g., Product Strategy Memo Q2 / Legal Compliance Directive Section 4.]

## 3. Detailed Rule Logic & Scenarios
*Break down the exact logic. Use tables, bullet points, or Gherkin syntax (Given/When/Then) to cover different edge cases.*

### Evaluation Logic
* **If** User Tier is `Gold` AND Basket Total > `$100` -> Apply `15% discount`.
* **If** User Tier is `Silver` OR Basket Total > `$100` -> Apply `10% discount`.
* **Else** -> Apply standard pricing.

### Asynchronous or Downstream Effects
*Does this rule trigger other business workflows or fire domain events?*
* [e.g., When a discount higher than 15% is applied, emit `HighDiscountAppliedEvent` to notify the accounting team.]

## 4. System Enforcement (How It’s Handled)
*Unlike an invariant (which sits strictly inside an Aggregate Root), a business rule can be enforced via Domain Services, Policy objects, or workflow orchestration (like n8n or Saga patterns).*

* **Enforcement Layer:** [e.g., Application/Domain Service, Dynamic Pricing Policy, or Workflow Engine]
* **Handling Violations/Exceptions:** *What happens if the rule conditions aren't met? (e.g., If a coupon is expired, do we block the checkout, or just remove the coupon and log a warning?)*
  * [e.g., If the automated discount calculation fails, fallback to standard catalog pricing and log a telemetry error; do not block the user purchase.]

## 5. Traceability

*Every edge is a relative link, and every edge has two ends: adding one here means adding the reciprocal link in that document, in the same commit. Convention: [Traceability](../guidelines/traceability.md).*

### Traces up to

Why this rule exists.

* Journey: [Journey XX — Title](../../../../inception/5-user-journeys/[journey-XX]-[name].md)
* Flow: [Flow — Journey XX](../flows/[journey-XX]-[name].md)
* Feature: [Feature XX — Title](../flows/features/[journey-id]/[feature-XX]-[name].md)

### Related rules

Rules it depends on, overlaps or contradicts.

* [INV-XXX](../invariants/INV-XXX-[name].md): [Short title]

### Enforced by

Every layer where the policy actually lives. Business rules are usually split
(contract validation + application check + domain guard + DB constraint + UI feedback); list them
all. Name the file **and** the guard. Status: ✅ Verified (you read the guard) · ⚠️ Unverified
(believed, not confirmed — legacy/brownfield) · ⏳ Planned (documented, not built).

| Layer | Where | Guard | Status |
| ----- | ----- | ----- | ------ |
| Contract (shared schema) | `packages/api-definitions/src/zod/[file].ts` | `[Schema]` refinement | ✅ Verified |
| Application | `packages/modules/[context]/src/application/commands/[name].handler.ts` | `[Handler].execute()` | ✅ Verified |
| Domain | `packages/modules/[context]/src/domain/[entity].ts` | `[Entity].[method]()` | ✅ Verified |
| Infrastructure | `packages/modules/[context]/src/infrastructure/[file].ts` | `[repository].[method]()` | ✅ Verified |
| Database | `packages/shared/database/src/schema.ts` | `[unique index / constraint name]` | ⚠️ Unverified |
| UI | `apps/frontend/src/modules/[context]/[form].tsx` | [what it does with the failure] | ✅ Verified |

### Verified by

Tests that fail when this policy changes.

* `tests/unit/modules/[context]/application/commands/[name].test.ts` — "[exact test title]"

### In flight

Active proposals touching it under `docs/product/working-on/`, else *none*.

---

## 6. History & Evolution
*Business rules change frequently based on market conditions. Track changes to this rule here.*

* **YYYY-MM-DD:** Rule created (Initial 10% discount policy).
* **2026-06-09:** Updated to include the new `Gold` tier 15% incentive.