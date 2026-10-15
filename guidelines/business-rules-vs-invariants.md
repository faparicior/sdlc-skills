# Business Rules vs Invariants: A Quick Reference Guide

## Key Distinction

Understanding the difference between **Business Rules** and **Invariants** is critical for proper domain modeling and system design.

## Comparison Table

| Aspect | Business Rule | Invariant |
|--------|--------------|-----------|
| **Scope** | Broad (Workflows, policies, formulas) | Strict (Data integrity, state constraints) |
| **Strictness** | Can have exceptions or asynchronous fallbacks | Absolute. Cannot be violated under any circumstance |
| **Enforcement** | Can be handled by UI, Workflows, or Domain Services | Must be protected synchronously inside the Aggregate Root |
| **If Violated** | The business handles the exception (e.g., charge a late fee) | The system is in an illegal state (transaction must rollback) |
| **Flexibility** | Can change based on business strategy | Defines core truth of the domain model |
| **Location** | Application layer, Domain Services, Workflows | Aggregate Root methods only |

## Examples

### Business Rule Examples

**BR-004: Free Tier Conference Creation Limit**
- **Rule:** When a free tier organizer attempts to create a conference, check if they have 5 active conferences
- **Violation Handling:** Show upgrade prompt, don't block the user entirely
- **Enforcement:** Application Service (`CreateConferenceService`)
- **Fallback:** Can log telemetry error and allow purchase flow

**BR-001: CfP Dates Must Be Valid**
- **Rule:** When creating CfP, end date must be after start date
- **Violation Handling:** Display validation error to user
- **Enforcement:** Value Objects and UI validation
- **Fallback:** User can correct and resubmit

### Invariant Examples

**INV-001: Conference State Transitions Must Follow State Machine**
- **Invariant:** Conference state transitions must follow the defined state machine
- **Violation Handling:** Throw `InvalidStatusTransitionError`, rollback transaction
- **Enforcement:** Inside `Conference` Aggregate Root methods
- **Fallback:** None - operation must fail completely

**INV-002: Cfp End Date Must Be After Start Date**
- **Invariant:** The `cfpEndDate` must always be strictly greater than `cfpStartDate`
- **Violation Handling:** Throw `CfpDatesInvalidError`, rollback transaction
- **Enforcement:** Inside `CfpConfig` child entity within Conference Aggregate
- **Fallback:** None - data would be in illegal state

## Decision Guide

### Is it a Business Rule?
Ask yourself:
- ✅ Can this rule have exceptions or fallbacks?
- ✅ Can it be enforced at the UI or workflow level?
- ✅ Does it dictate a workflow or policy rather than data integrity?
- ✅ Can the business change this rule without breaking the system?

If **YES** to any of these → **Business Rule**

### Is it an Invariant?
Ask yourself:
- ✅ Must this condition ALWAYS be true, without exception?
- ✅ Would violating this put the system in an illegal/corrupt state?
- ✅ Must it be enforced inside the Aggregate Root?
- ✅ Does it define a fundamental truth about the domain?

If **YES** to any of these → **Invariant**

## Template Differences

### Business Rule Template Highlights
- **Section 4: System Enforcement** - Can mention Domain Services, Policy objects, or workflow engines
- **Handling Violations** - May include fallback actions, async workflows, or graceful degradation
- **Flexibility** - Can be changed based on business needs

### Invariant Template Highlights
- **Section 3: Enforcement Logic** - Must show Aggregate Root protection
- **Section 4: Failure Response** - Must specify domain exception and rollback behavior
- **Section 5: Test Cases** - Must include both positive and negative Gherkin scenarios
- **No Fallbacks** - Violation always means transaction failure

## Common Mistakes to Avoid

### ❌ Mistake: Treating Business Rules as Invariants
```typescript
// BAD: Business rule enforced as invariant
class CheckoutService {
  applyDiscount(cart: Cart, discount: Discount): void {
    if (discount.value > 15) {
      throw new DiscountTooHighError(); // Too strict!
    }
  }
}
```

**Fix:** Use a business rule with fallback
```typescript
// GOOD: Business rule with fallback
class CheckoutService {
  applyDiscount(cart: Cart, discount: Discount): void {
    if (discount.value > 15) {
      logWarning('High discount applied', { discount });
      // Continue with standard pricing instead
      applyStandardPricing(cart);
    }
  }
}
```

### ❌ Mistake: Treating Invariants as Business Rules
```typescript
// BAD: Invariant with fallback
class Conference {
  closeCfp(): void {
    if (this.status !== ConferenceStatus.CFP_OPEN) {
      console.warn('Invalid state for closing CfP'); // Too lenient!
      this.status = ConferenceStatus.CFP_CLOSED; // Still changes state!
    }
  }
}
```

**Fix:** Enforce strictly in Aggregate Root
```typescript
// GOOD: Invariant with no fallback
class Conference {
  closeCfp(): void {
    if (this.status !== ConferenceStatus.CFP_OPEN) {
      throw new InvalidStatusTransitionError(
        this.id, 
        ConferenceStatus.CFP_OPEN, 
        ConferenceStatus.CFP_CLOSED
      );
    }
    this.status = ConferenceStatus.CFP_CLOSED;
    this.recordDomainConference(new CfpClosed(this.id));
  }
}
```

## When in Doubt

If you're unsure whether something is a business rule or invariant:

1. **Ask the Product Owner:** "What happens if this rule is violated?"
   - If they say "Handle it gracefully" → Business Rule
   - If they say "It must never happen" → Invariant

2. **Consider the Consequences:**
   - Can the system continue operating if this is violated? → Business Rule
   - Would the data become corrupt or illegal? → Invariant

3. **Check the Enforcement Location:**
   - Can it be checked in UI or application service? → Business Rule
   - Must it be checked inside the Aggregate? → Invariant

## References

- [Business Rules Template](../../../../docs/templates/product/business-rules.md)
- [Invariants Template](../../../../docs/templates/product/invariants.md)
- [Entity Lifecycle Template](../../../../docs/templates/product/entity-lifecycle.md)
- [Traceability](traceability.md) — how to link rules to the flows, entities and code that enforce them
- Extracting rules and invariants from existing code: the `reverse-engineer-domain` skill
