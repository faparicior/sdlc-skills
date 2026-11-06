---
name: reverse-engineer-domain
description: >-
  Reverse-engineer business rules and invariants from legacy or brownfield code.
  USE THIS SKILL when user mentions: reverse engineer, extract business rules,
  extract invariants, analyze legacy, software archeology, brownfield extraction,
  discover rules, find invariants in code, or extract domain logic from existing code.
  Automatically triages outputs to bounded contexts or the staging buffer docs/product/discovered/.
disable-model-invocation: true
---

# PROTOCOL: REVERSE-ENGINEER-DOMAIN (EXECUTION LEVEL 3)

<state_machine>
CURRENT_STEP          -> REQUIRED_TOOL                                      -> REQUIRED_OUTPUT                                                  -> MANDATORY_HALT
Step 1: Read Source   -> read_file / grep (legacy/brownfield code)          -> Conditional branches, exceptions, transaction boundaries         -> Continue to Step 2
Step 2: Triage        -> evaluate domain confidence                         -> Target destination (bounded-contexts/{ctx} vs discovered/RAW)    -> Continue to Step 3
Step 3: Write Rules   -> read_file(templates/business-rules.md, invariants) -> Standardized BR-* and INV-* files with file:line traceability    -> 🛑 HALT TURN (Present extracted rules)
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: You may reason freely INSIDE each step to analyze legacy code, branch conditions, and domain boundaries, but you are strictly forbidden from skipping triage or improvising output formats (`workflow structure = immutable | step reasoning = flexible`).
2. TEMPLATE LOCK: Reconstructing template headers or tables from internal memory is strictly forbidden. You MUST call `read_file` on `templates/business-rules.md` or `templates/invariants.md` before generating any file.
3. MANDATORY TRIAGE ROUTING:
   - High-confidence bounded context -> `docs/product/bounded-contexts/{context}/{business-rules,invariants}/`
   - Ambiguous/tangled legacy -> `docs/product/discovered/{business-rules,invariants}/` with `BR-RAW-XXX` / `INV-RAW-XXX` IDs and exact `file:line` pointers.
4. ESCAPE HATCH: If the situation does not fit the contract, do not silently improvise and do not force-fit: declare the deviation in one line and ask.
</execution_invariants>

<output_contract>
- TARGET_PATHS: `docs/product/bounded-contexts/{context}/{business-rules,invariants}/` OR `docs/product/discovered/{business-rules,invariants}/`
- SOURCE_TEMPLATES: `templates/business-rules.md` and `templates/invariants.md` (MUST call `read_file` before writing)
- SCHEMA_INVARIANCE: Preserve every H1/H2/H3 heading, metadata field, Gherkin scenario structure, and Traceability table verbatim, and strip all instructional meta-commentary.
- ESCAPE_HATCH: Never silently omit or invent template sections. If an upstream flow/journey link (`Traces up to`) does not exist yet in a brownfield repo, preserve the bullet and write `"None documented yet (brownfield extraction)"`.
</output_contract>

---

## 1. Core Distinction: Business Rules vs. Invariants

| Aspect | Business Rule (`BR-XXX`) | Domain Invariant (`INV-XXX`) |
| --- | --- | --- |
| **Scope** | Broad (Workflows, policies, formulas, eligibility) | Strict (Transactional consistency, state integrity) |
| **Strictness** | Allows business fallbacks or compensating actions | Absolute. Cannot be violated under any circumstance |
| **Enforcement** | Handled by UI, Workflow Handlers, or Domain Services | Protected synchronously inside the Aggregate boundary |
| **If Violated** | Business handles the exception (e.g., fee, reject) | Illegal state: transaction is immediately rolled back |

---

## 2. Autonomous Triage Engine (Where to Output)

When analyzing legacy code, determine the target location based on domain clarity:

| Scenario | Confidence | Output Destination |
| --- | --- | --- |
| **Clear Bounded Context** | High (module or domain is clearly identified) | `docs/product/bounded-contexts/{context}/business-rules/`<br>`docs/product/bounded-contexts/{context}/invariants/` |
| **Ambiguous / Tangled Legacy** | Low / Medium (Big Ball of Mud, shared spaghetti, or unknown context) | `docs/product/discovered/business-rules/`<br>`docs/product/discovered/invariants/` |

### Staging Rules for `docs/product/discovered/`
- Prefix identifiers with `RAW` (e.g., `BR-RAW-001`, `INV-RAW-001`).
- Include full source file and line number pointers (e.g., `legacy/services/OrderManager.ts:145-189`).
- Set `Candidate Bounded Context: [TBD / Suspected: ...]`.
- Add `Domain Tags` to enable subsequent clustering and context mapping.

---

## 3. Natural Language Activation

This skill is conversational and automatically infers your intent:

| Intent | Natural Language Examples | Action Executed |
| --- | --- | --- |
| **File Extraction** | "Extract business rules from `src/legacy/order.ts`", "Analyze `conference.ts` for invariants" | Scans the file, identifies rules and invariants, and writes them to the appropriate directory. |
| **Directory / Module Extraction** | "Reverse engineer the legacy billing module", "Extract domain logic from `legacy/services/`" | Iterates through files in the directory, compiling all discovered rules and invariants. |
| **Snippet Analysis** | "What business rules are in this code snippet: [code]", "Extract invariants from this logic" | Analyzes the provided code and outputs formatted rule/invariant files. |
| **Staging Review** | "Review discovered rules", "What rules are in the staging buffer?" | Inspects `docs/product/discovered/` and summarizes candidate contexts for graduation. |

---

## 4. Extraction Instructions

### Extracting Business Rules (`BR-XXX`)
1. Review the input for conditional branching (`if/else`), fee calculations, discounts, eligibility criteria, status transitions, or orchestration workflows.
2. Formulate the rule using the standard pattern:
   > **When** [Trigger / Condition], **then** [Apply this Policy / Calculation], **otherwise** [Fallback Action].
3. Fill out `templates/business-rules.md` and remove all instructional commentary.

### Extracting Invariants (`INV-XXX`)
1. Scan for transaction boundaries, capacity limits, structural uniqueness, or conditions that throw fatal domain exceptions.
2. State the invariant as an absolute truth:
   > **Invariant:** [e.g., The total registered attendees can never exceed venue capacity.]
3. Define the monitored fields and write **Gherkin scenarios** for positive (valid) and negative (violation blocked) cases.
4. Call `read_file` on `templates/invariants.md`, fill out every section verbatim, and remove all instructional commentary.

---

<self_validation_gate>
Before ending your turn, verify every item below with concrete evidence (not just a checkmark). If any item cannot be cited with real evidence from this turn, DO NOT produce your final response — return to the failed step and fix the violation first:
- [ ] **Source Code Read Evidence:** List the exact source files and `file:line` enforcement sites read via `read_file`: `<file:line list>`
- [ ] **Template Read Evidence:** Exact `templates/business-rules.md` and/or `templates/invariants.md` paths passed to `read_file`: `<paths>`
- [ ] **Triage & Output Evidence:** Exact output paths written (`bounded-contexts/{ctx}/` vs `discovered/` with `RAW` prefix) and confirmation that all 6 (`BR`) or 7 (`INV`) sections are present: `<paths>`
</self_validation_gate>
