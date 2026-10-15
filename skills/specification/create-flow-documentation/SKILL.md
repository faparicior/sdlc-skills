---
name: create-flow-documentation
description: >-
  Generate comprehensive flow documentation from user journeys. USE THIS SKILL when user mentions:
  create flow, generate flow, flow specification, journey to flow, user flow documentation,
  create journey documentation, flow spec, document user journey, create flow from journey,
  flow diagram, sequence diagram flow, or any request to turn a user journey into detailed flow documentation.
  This skill creates complete flow specs with 3 Mermaid diagrams (sequence, flowchart, state),
  step-by-step walkthroughs, acceptance criteria, edge cases, and technical notes following DDD patterns.
disable-model-invocation: true
---

# Create Flow Documentation Skill

You are an expert Technical Product Manager and System Architect. Your job is to generate a detailed "User Flow" document based on a journey, explicitly mapping user actions to backend system reactions and Entity Lifecycle state changes.

Use the exact Markdown layout provided in `templates/flows.md`. Do not add any conversational text before or after the markdown block.

---

## 📋 Input Context

This skill accepts inputs from either **Lean Inception** OR **User Story Mapping**:

### Source A: Lean Inception

- **Journey Reference:** `docs/inception/5-user-journeys/*.md` (document and step number)
- **Persona:** `docs/inception/3-personas/` ([Persona Name] / [Role])
- **Goal:** [What the persona wants to accomplish]
- **Feature to Document:** `docs/inception/7-features-and-sequencing.md` (Specific feature & wave)
- **Journey Steps:** [Copy the relevant journey table from source document]

### Source B: User Story Mapping

- **Backbone Reference:** `docs/user-story-mapping/2-map-the-big-picture.md` (User Activity & Steps)
- **Story Cards:** `docs/user-story-mapping/3-explore-to-fill-the-body.md` (Title, Narrative, Acceptance Criteria, Tech Notes)
- **Release Slice:** `docs/user-story-mapping/4-slice-out-a-release-strategy.md` (Wave 1 MVP vs Wave 2)
- **Persona:** Extracted from Step 1 (`docs/user-story-mapping/1-frame-the-problem.md`) or Story Narrative

### Common Metadata

- **Active Event Status:** [e.g., Draft → CFP_OPEN]
- **Impacted Entities:** [List the entities affected]
- **Bounded Context:** [Identify the bounded context for this journey]

---

## ✅ Required ADR Review After Creation

After generating the flow document, review the project's Architecture Decision Records (ADRs) to ensure alignment with established architectural decisions.

### ADR Compliance Checklist

- [ ] Entity mutations use domain methods rather than direct property setters
- [ ] State transitions match entity lifecycle state machine
- [ ] Domain events are published on state changes
- [ ] Repository pattern is used for data access
- [ ] Input validation uses schema validation

---

## 🎨 Mermaid Diagram Requirements

The flow document MUST include **3 complete Mermaid diagrams**:

### 1. Sequence Diagram (with Error Paths)

- Must show the complete interaction flow from user to system
- **Must include colored `rect` blocks for error scenarios** (not just happy path)
- Each error path should be clearly labeled with `rgb(255, 235, 238)` (red)
- Happy path should use `rgb(232, 245, 233)` (green)
- Include notes for domain events and side effects
- Steps must align with the walkthrough table

### 2. Flowchart

- Shows decision points and branching logic
- Color-code outcomes: success (green), error/failure (red), warning (yellow)
- Must cover all major decision points from the flow

### 3. State Diagram

- Shows the primary entity/aggregate lifecycle
- Must include all relevant states and transitions
- Include notes explaining key states
- Color-code states: initial (orange), active (yellow), success (green), error (red)

---

## 🔄 Mermaid Diagram & Walkthrough Consistency

The Mermaid sequence diagram and Step-by-Step Walkthrough table MUST be aligned:

1. **Step Numbering:** Each step in the walkthrough table should correspond to a logical action in the Mermaid diagram
2. **Sequence Alignment:** The order of steps in the table must match the sequence shown in the Mermaid diagram
3. **Completeness:** Every major action in the Mermaid diagram should have a corresponding step in the walkthrough
4. **Detail Level:** The walkthrough should provide additional detail for each Mermaid interaction (User Action, System Reaction, Domain/Entity Impact)
5. **Numbering Strategy:** Use sequential numbering (1, 2, 3, ...) where each number represents a distinct action/interaction in the flow

---

## 📐 Business Rules & Invariants Extraction

During flow creation, you MUST identify all business rules and invariants that govern the steps, alternative paths, validations, or edge cases of this user flow:

1. Use the templates provided at:
   - `templates/business-rules.md`
   - `templates/invariants.md`
2. **Classify each rule by bounded context** — a rule belongs to the context that owns and enforces it, not necessarily the context where it has visible effects.
3. Extract each identified business rule to:
   - `docs/product/bounded-contexts/{owning-bounded-context}/business-rules/BR-[XXX]-[rule-name].md`
4. Extract each identified invariant to:
   - `docs/product/bounded-contexts/{owning-bounded-context}/invariants/INV-[XXX]-[invariant-name].md`
5. **Prominent Placement for PMs**: In the generated flow specification, place the extracted rules prominently in **Section 2 (`## 📜 Governing Business Rules & Domain Invariants (PM Summary)`)** right after Overview, as well as in the traceability table at the bottom.
6. **Complete the `Traceability` section of every rule/invariant you create** (`templates/business-rules.md`
   §5, `templates/invariants.md` §6) — `Traces up to` (journey, this flow, feature), `Enforced by` (one row
   per layer, naming the file and the guard, each marked ✅ Verified / ⚠️ Unverified / ⏳ Planned by what you
   actually read) and `Verified by` (test file **and** test title). Convention: `../guidelines/traceability.md`.

---

## 📑 Flow Index (`docs/product/flows/README.md`)

After creating or updating a flow, you MUST update the master flow catalog and index at:

```
docs/product/flows/README.md
```

**Rules for updating the index:**
- Add the new flow to the **Master Flow Catalog** table (including Journey, Context, BR links, INV links, Entities, Status)
- Add or update the **Master Index: Business Rules & Domain Invariants** tables
- Add a Flow Details summary section for the journey
- Update the Cross-Context Flow Diagram if new entities or contexts are involved
- Update the Last Updated date and Total Flows count

---

## 📁 Output Path

Write the result in:

```
docs/product/bounded-contexts/{bounded-context-name}/flows/journey-[XX]-[feature-name].md
```

Where:
- `{bounded-context-name}` is the kebab-case name of the bounded context (e.g., `event`, `submission`, `review`, `scheduling`)
- `[XX]` is the journey number (e.g., `01`, `02`)
- `[feature-name]` is the kebab-case feature name (e.g., `setup-event`, `submit-proposal`)

---

## 📖 Documentation Structure

This skill is **language- and framework-agnostic**. Adapt technical notes, schema definitions, and endpoint patterns to the target repository's architectural conventions (consult `AGENTS.md` or `ARCHITECTURE.md`).

The generated flow document should be a **single, comprehensive document** that includes:

1. **Overview** - User story format (As a... I want... So that...)
2. **Sequence Diagram** - Complete with error paths in colored rectangles
3. **Flowchart** - Decision points and branching logic
4. **State Diagram** - Entity lifecycle visualization
5. **Step-by-Step Walkthrough** - Aligned with sequence diagram
6. **Acceptance Criteria** - Gherkin format scenarios
7. **Edge Cases & Invariant Integrity** - Business logic failures, technical failures, validation boundaries, and concurrency/TOCTOU race mitigations
8. **Technical Notes** - API endpoints, validation schemas/contracts, database constraints, security/access policies
9. **Linked Documentation** - References to entities, value objects, ADRs

**Do NOT create separate flow map files** - all diagrams must be embedded in the main flow specification document.

---

## ⏭️ Next Step in the SDLC Workflow

Once the flow specification document (`journey-XX-[name].md`) is created and approved:
* **Invoke `/create-features` (Phase 2b)** to slice the user journey into sequentially numbered feature specifications (`features/feature-01-[name].md`, `feature-02-[name].md`) with HTTP error contracts and concurrency analysis.

---

## 📚 Bundled Resources

### Templates
| Template | Purpose |
|----------|---------|
| `templates/flows.md` | Flow document template with 3 Mermaid diagrams |
| `templates/business-rules.md` | Business rule documentation template |
| `templates/invariants.md` | Invariant documentation template |
| `templates/bounded-contexts-readme.md` | Flow index template — seed for `docs/product/bounded-contexts/README.md` |

### Guidelines
| Guideline | Purpose |
|-----------|---------|
| `../guidelines/flow-documentation-structure.md` | Flow documentation standards and best practices |
| `../guidelines/business-rules-vs-invariants.md` | When to use BR vs INV, differences and enforcement |
| `../guidelines/traceability.md` | Linking rules to flows, entities, code and tests — both ends of every edge |

## 🔗 External Documentation (Optional)

- [User Journey Mapping](../../../../docs/inception/5-user-journeys/README.md)

---

**Last Updated:** 2026-06-25  
**Version:** 2.0