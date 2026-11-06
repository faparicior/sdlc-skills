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

# PROTOCOL: CREATE-FLOW-DOCUMENTATION (EXECUTION LEVEL 3)

<state_machine>
CURRENT_STEP          -> REQUIRED_TOOL                                      -> REQUIRED_OUTPUT                                                  -> MANDATORY_HALT
Step 1: Read Inputs   -> read_file (journey/USM/code + ADRs)                -> Persona, goal, steps, bounded context                            -> Continue to Step 2
Step 2: Write Flow    -> read_file(templates/flows.md)                      -> bounded-contexts/{ctx}/flows/journey-XX-[name].md (3 diagrams)   -> Continue to Step 3
Step 3: Extract Rules -> read_file(templates/business-rules.md, invariants) -> BR-XXX & INV-XXX files with complete Traceability tables         -> Continue to Step 4
Step 4: Update Index  -> edit_file (flows/README.md)                        -> Updated Master Flow Catalog & BR/INV index                       -> 🛑 HALT TURN (Present flow & rules)
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: You may reason freely INSIDE each step to map user actions, backend reactions, and entity state transitions, but you are strictly forbidden from skipping steps, omitting any of the 3 required Mermaid diagrams, or improvising document structure (`workflow structure = immutable | step reasoning = flexible`).
2. TEMPLATE LOCK: Reconstructing template headers or tables from internal memory is strictly forbidden. You MUST call `read_file` on `templates/flows.md`, `templates/business-rules.md`, and `templates/invariants.md` before generating those files.
3. BIDIRECTIONAL TRACEABILITY: Every governing `BR-XXX` and `INV-XXX` must be extracted to its owning bounded context with both ends of the `Traceability` section completed (`../guidelines/traceability.md`).
</execution_invariants>

<output_contract>
- FLOW DOCUMENT:
  - TARGET_PATH: `docs/product/bounded-contexts/{bounded-context-name}/flows/journey-[XX]-[feature-name].md`
  - SOURCE_TEMPLATE: `templates/flows.md` (MUST call `read_file` before writing)
  - SCHEMA_INVARIANCE: Preserve all sections (`Overview`, `Governing Business Rules & Domain Invariants (PM Summary)`, `Sequence Diagram`, `Flowchart`, `State Diagram`, `Step-by-Step Walkthrough`, `Acceptance Criteria`, `Edge Cases & Invariant Integrity`, `Technical Notes`, `Linked Documentation`) verbatim.
- BUSINESS RULES & INVARIANTS:
  - TARGET_PATHS: `docs/product/bounded-contexts/{owning-bounded-context}/business-rules/BR-[XXX]-[rule-name].md` and `invariants/INV-[XXX]-[invariant-name].md`
  - SOURCE_TEMPLATES: `templates/business-rules.md` and `templates/invariants.md` (MUST call `read_file` before writing)
- ESCAPE_HATCH: Never silently omit or invent template sections or any of the 3 required Mermaid diagrams. If a technical note subsection genuinely does not apply (e.g., `HTTP Endpoint` for a cron-triggered flow), preserve the heading and write `"N/A — [1-line rationale]"`.
</output_contract>

> **Paths**: the locations shown are the pack defaults; if `.sdlc/config.json` exists (written by `/setup-sdlc`), honour its `docsRoot` / `productDocsDir` / `adrDir` overrides.

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

### Source C: Direct Request (Brownfield)

- **Journey Reference:** the user's request itself — the repo may have no inception or story-mapping docs; derive persona, goal, and steps from the description plus what the code actually does. Do not invent upstream docs that do not exist.

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

- User journey mapping docs, if the repo has them — discover the path (do not assume `docs/inception/...`).

---

<self_validation_gate>
Before ending your turn, verify every item below with concrete evidence (not just a checkmark). If any item cannot be cited with real evidence from this turn, DO NOT produce your final response — return to the failed step and fix the violation first:
- [ ] **Template Read Evidence:** Exact `templates/flows.md`, `templates/business-rules.md`, and `templates/invariants.md` paths passed to `read_file`: `<paths>`
- [ ] **Flow Output & 3-Diagram Evidence:** Exact flow doc path written and step counts matched across Sequence Diagram, Flowchart, State Diagram, and Step-by-Step Walkthrough table: `<path, N steps>`
- [ ] **BR/INV Extraction & Traceability Evidence:** List all `BR-XXX` and `INV-XXX` files created/updated in their owning bounded context with bidirectional `Traceability` (`Traces up to`, `Enforced by`, `Verified by`): `<BR/INV paths>`
- [ ] **Master Index Evidence:** Exact index file (`docs/product/flows/README.md` or equivalent) updated via `edit_file`: `<path>`
</self_validation_gate>

---

**Last Updated:** 2026-11-05  
**Version:** 2.1 (Level 3 Execution Protocol)