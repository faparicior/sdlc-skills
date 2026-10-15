---
name: create-entity-lifecycle
description: >-
  Generate comprehensive entity lifecycle documentation. USE THIS SKILL when user mentions:
  create entity, entity lifecycle, entity documentation, document entity, entity state machine,
  create entity spec, entity definition, domain entity, aggregate lifecycle, or any request to create
  technical documentation for a domain entity including state machine, transitions, and domain behavior.
  This skill creates complete entity specs with state diagrams, transition matrices, domain methods,
  and extracts business rules and invariants.
disable-model-invocation: true
---

# Create Entity Lifecycle Skill

You are an expert System Architect and Backend Engineer. Your job is to generate the technical details for an "Entity Lifecycle" document based on a domain noun (entity) and its high-level requirements.

Use the exact Markdown layout provided in `templates/entity-lifecycle.md`. Do not add any conversational text before or after the markdown block.

---

## 📋 Input Context

- **Entity Name:** [Domain noun/entity name]
- **Aggregate Role:** [Root Entity or Child Entity]
- **Domain Context:** [Bounded context or domain area]
- **Bounded Context:** [Identify the bounded context for this entity]
- **Related Entities:** [List related entities in the aggregate]
- **Value Objects:** [List value objects used by the entity]
- **State Machine:** [List all possible states]
- **Domain Behavior:** [List core domain methods]
- **Feature References:** `docs/product/bounded-contexts/[context]/flows/features/[journey-id]/` (feature specifications to establish bidirectional traceability in `BR-XXX` and `INV-XXX` docs)

---

## ✅ Required ADR Review After Creation

After generating the entity lifecycle document, review the project's Architecture Decision Records (ADRs) to ensure alignment with established architectural decisions.

### Compliance Checklist

- [ ] Entity is properly designated as Aggregate Root or Child Entity
- [ ] Value Objects encapsulate validation and business rules
- [ ] Domain behavior is exposed through methods (not data setters)
- [ ] State transitions are explicit and validated
- [ ] Domain events are published on state changes
- [ ] Repository interfaces are defined for data access
- [ ] Entity invariants are documented and enforced
- [ ] Entity links to relevant User Flows / Journeys
- [ ] Domain events are documented with triggers and side effects
- [ ] State definitions are clear and unambiguous
- [ ] Validation rules are comprehensive
- [ ] Every state, transition, method, event and repository row carries a Status you earned by opening the class
- [ ] `⏳ Planned` rows are phrased in the future tense, never in the present tense

---

## 🔍 Code Is Truth (Read The Class First)

Before writing a single row, open the class the document describes — plus its value objects, the
repository port in `domain/`, and `domain/events/`. This document describes **what ships**. The product
blueprint describes **what is wanted**, and only one of those two is a claim about the code.

1. **Every table row is a claim about the class.** `✅ Built` only for a state, transition, method, event
   or repository method you found in the code you read; `⚠️ Unverified` when you believe it but did not
   look; `⏳ Planned` when no code exists yet.
2. **`⏳ Planned` is written in the future tense** — "will emit `CfpClosed`", never "publishes
   `CfpClosed`". Present tense asserts the code ships.
3. **A target-product state machine documented as if it were Wave 1 is the most expensive defect this
   document can carry.** If the class implements one mutator, the matrix gets one `✅ Built` row and the
   rest are `⏳ Planned`. That is a correct document, not an incomplete one.
4. **Never invent an API in order to document one.** No `closeCfp()` in the class ⇒ it is a `⏳ Planned`
   row or absent — never a present-tense row. Same rule for repository methods, event constructors and
   value-object members.
5. **A side effect needs a live consumer.** An event whose worker is not built gets `⏳ Planned`, and the
   unbuilt worker does not appear as a bullet in the side-effect cell.
6. **Transcribe the repository port, do not improve it** — optional parameters included (`save(e, tx?)`;
   that `tx` is what makes the Transactional Outbox atomic). A phantom `findByStatus()` hides drift for
   months.
7. **A `✅` you did not earn by opening the file is worse than a `⚠️`** — this binds on this document's
   tables exactly as it binds on a rule's `Enforced by` table (§Extraction item 5).

---

## 🔄 Mermaid Diagram & State Definition Consistency

The Mermaid state machine diagram and the State Definitions/Transition Matrix MUST be aligned:

1. **State Completeness:** Every state shown in the Mermaid diagram must have a corresponding definition in the State Definitions section
2. **Transition Completeness:** Every transition arrow in the Mermaid diagram must be documented in the State Transition Matrix
3. **State Names:** Use consistent naming (e.g., `DRAFT`, `CFP_OPEN`, not `draft`, `active`)
4. **Trigger Alignment:** The triggering actions/events in the Mermaid diagram must match the "Event / Trigger" column in the State Transition Matrix
5. **Target State Alignment:** The target states in the Mermaid diagram must match the "Target State" column in the State Transition Matrix
6. **Domain Methods:** If domain methods are shown in the Mermaid (e.g., `Event.publishCfp()`), they must be documented in the Domain Behavior section
7. **Terminal States:** All terminal states (states with no outgoing transitions) should be clearly identified in State Definitions

---

## 📁 Output Path

Choose the output path based on the DDD classification of what you are documenting:

| Type | Path | When to use |
|------|------|-------------|
| Aggregate root / child entity | `docs/product/bounded-contexts/{context}/entities/{EntityName}.md` | Has identity, lifecycle, state machine |
| Value object | `docs/product/bounded-contexts/{context}/value-objects/{VoName}.md` | No identity, validated at construction, immutable |
| Domain service | `docs/product/bounded-contexts/{context}/domain-services/{ServiceName}.md` | Stateless logic that doesn't belong to a single entity |

Where `{bounded-context-name}` is the kebab-case name of the bounded context (e.g., `event`, `submission`, `review`, `scheduling`, or any future context)

---

## 📐 Business Rules & Invariants Extraction

During entity lifecycle creation, you MUST identify all business rules and invariants that govern the entity's state machine, transitions, domain methods, or value objects:

1. Use the templates provided at:
   - `templates/business-rules.md`
   - `templates/invariants.md`
2. Extract each identified business rule to:
   - `docs/product/bounded-contexts/{bounded-context-name}/business-rules/BR-[XXX]-[rule-name].md`
3. Extract each identified invariant to:
   - `docs/product/bounded-contexts/{bounded-context-name}/invariants/INV-[XXX]-[invariant-name].md`
4. Ensure the generated entity lifecycle document links to these extracted files under its **Invariants & Business Rules** section using relative markdown links (e.g., `../business-rules/BR-[XXX]-[rule-name].md`)
5. **Complete the `Traceability` section of every rule/invariant you create** (`templates/business-rules.md`
   §5, `templates/invariants.md` §6) — `Traces up to` (journey, flow, feature), `Enforced by` (one row per
   layer that can reject the policy, naming the file **and** the guard, each marked ✅ Verified /
   ⚠️ Unverified / ⏳ Planned according to what you read in the code) and `Verified by` (test file **and**
   test title). A rule with an empty `Enforced by` table is not finished; a ✅ you did not earn by opening
   the file is worse than ⚠️. Convention: `../guidelines/traceability.md`
6. Complete the **`Enforcement & tests`** table in the entity/value-object document you are generating, so
   each rule listed under **Invariants & Business Rules** also names its enforcing member and test file —
   that table is the reverse edge of item 5, and both must be written in the same change

---

## 📖 Documentation Structure

This skill is **language- and framework-agnostic**. File paths and class conventions should follow the target repository's established architecture (consult `AGENTS.md` or `ARCHITECTURE.md`).

### Entities (aggregate roots / child entities)
1. **Definition & Context** - Description, database table / collection, primary key, implementation source path
2. **State Machine Diagram** - Mermaid state diagram showing all states and transitions
3. **State Transition Matrix** - Complete mapping of allowed state changes, every row carrying a Status
4. **State Definitions** - Detailed criteria for each state
5. **Domain Behavior** - Every public method the class exposes, each with a Status
6. **Domain Events** - Event, constructing call site, payload, and the consumer that exists today, each with a Status
7. **Invariants & Business Rules** - Links to extracted BRs and INVs, plus the `Enforcement & tests` reverse edge
8. **Repository Interface** *(aggregate roots only)* - The persistence port transcribed from `domain/`, signature included
9. **Linked User Stories & Flows** - References to flows that interact with the entity

### Value Objects
1. **Definition & Context** - Description, class/type name, implementation source path
2. **Construction & Reconstitution** - Factory methods (`create()` for validated new instances, `fromData()` for persistence reconstitution)
3. **Validation & Immutability** - What is accepted, validation constraints, error exceptions thrown
4. **Invariants & Business Rules** - Links to relevant BRs and INVs
5. **Linked Entities & Use Cases** - Which aggregates embed this VO

### Domain Services

Two parts, so a PM can stop after Part A:

**Part A — Product View** (shipped behaviour, business language, no code names)
1. **Summary** - One sentence: what it decides and why it matters
2. **Business Context** - Why it is a domain service, the business problem it solves, participating flows
3. **How It Decides** - Decision paths, governing policies (BRs and INVs), one business-language decision flow per path
4. **Pending Changes** - Changes coming from an open proposal (change, slice, proposal link, ticket, status); removed when the slice ships

**Part B — Developer View**
1. **Definition** - Type and implementation source path
2. **Collaborators** - Dependencies, what each provides, Built/Planned status
3. **Methods** - Each public method: guards, steps, side effects, return value, status
4. **Sequence Diagram** - One diagram showing all method orchestration flows (use `rect` blocks per method)
5. **Rules & Invariants Enforced** - BRs and INVs the service enforces, with the method that enforces each (a domain service may enforce business rules as well as invariants)
6. **Traceability** - `Enforced by` (file + guard + status) and `Verified by` (test file + test title)
7. **Linked Flows** - Which flows invoke which methods and at which step

---

## 📚 Bundled Resources

### Templates
| Template | Purpose |
|----------|---------|
| `templates/entity-lifecycle.md` | Entity lifecycle document template |
| `templates/value-object.md` | Value object document template |
| `templates/domain-service.md` | Domain service document template |
| `templates/business-rules.md` | Business rule documentation template |
| `templates/invariants.md` | Invariant documentation template |

### Guidelines
| Guideline | Purpose |
|-----------|---------|
| `../guidelines/flow-documentation-structure.md` | Flow documentation standards (reference) |
| `../guidelines/business-rules-vs-invariants.md` | When to use BR vs INV, differences and enforcement |
| `../guidelines/traceability.md` | Linking rules to flows, entities, code and tests — both ends of every edge |

---

## 🔗 Related Documentation

- [User Journey Mapping](../../../../docs/inception/5-user-journeys/README.md)
- [Bounded Contexts & Flows](../../../../docs/product/README.md)

---

**Last Updated:** 2026-09-16  
**Version:** 1.3  
**Changes from v1.2:**
- Added `🔍 Code Is Truth`: open the class, its value objects, the repository port and `domain/events/`
  before writing any row; every table row is an earned claim with a Status
- `Documentation Structure → Entities` now lists `Domain Behavior`, `Domain Events` and
  `Repository Interface` — the three sections whose absence let unbuilt mutators be documented in the
  present tense
- Templates `entity-lifecycle.md`, `value-object.md` and `domain-service.md` gained `Status` columns
  (`✅ Built` / `⚠️ Unverified` / `⏳ Planned`) and a status legend
**Changes from v1.1:**
- Domain service documentation structure updated: sequence diagram + one flow diagram per method
- `templates/domain-service.md` updated with separate flow diagram blocks per method and `rect`-based sequence diagram
**Changes from v1.0:**
- Output path now distinguishes entities, value-objects, and domain-services folders
- Documentation Structure split into three sections matching DDD classifications