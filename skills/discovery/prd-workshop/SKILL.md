---
name: prd-workshop
description: >-
  Draft and validate formal Product Requirements Documents (PRDs).
  USE THIS SKILL when user mentions: prd, product requirements document,
  create prd, draft prd, write prd, validate prd, review prd, or critique prd.
  Supports PRD generation from requirements and critical quality validation.
disable-model-invocation: true
---

# PROTOCOL: PRD-WORKSHOP (EXECUTION LEVEL 3)

<state_machine>
CURRENT_STEP          -> REQUIRED_TOOL                                      -> REQUIRED_OUTPUT                                         -> MANDATORY_HALT
Workflow A (Draft)    -> read_file(templates/template-prd.md)               -> Complete PRD conforming to template-prd.md              -> 🛑 HALT TURN (Present PRD)
Workflow B (Validate) -> read_file(references/prd-validator.md)             -> 5-dimension scored critique (1-10) + blockers           -> 🛑 HALT TURN (Present critique)
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: You may reason freely INSIDE each section, but you are strictly forbidden from skipping sections or inventing a custom PRD or validation format (`workflow structure = immutable | step reasoning = flexible`).
2. TEMPLATE LOCK:
   - Workflow A (Draft PRD): You MUST call `read_file` on `templates/template-prd.md` before writing the PRD, preserve every section heading and table schema verbatim, and strip all instructional meta-commentary.
   - Workflow B (Review PRD): You MUST call `read_file` on `references/prd-validator.md` before scoring and follow its exact 5-dimension evaluation rubric.
</execution_invariants>

<output_contract>
- DRAFT PRD SOURCE_TEMPLATE: `templates/template-prd.md` (MUST call `read_file` before writing)
- REVIEW PRD SOURCE_RUBRIC: `references/prd-validator.md` (MUST call `read_file` before scoring)
- SCHEMA_INVARIANCE: Preserve all template headings and tables verbatim; strip all instructional meta-commentary.
</output_contract>

---

## 1. Supported Workflows

### Workflow A: Draft a PRD

- Generate a structured PRD using `templates/template-prd.md`.
- Ensure all sections are populated: Problem Statement, Success Metrics (with baselines), User Personas, Core Logic, Edge Cases, UX/UI, Engineering Specs, and NFRs.
- Strip all instructional commentary from the output.

### Workflow B: Review & Validate a PRD

- Critically audit a submitted PRD using `references/prd-validator.md`.
- Evaluate against 5 dimensions: Clarity, Completeness, Feasibility, Measurability, and Edge Cases.
- Deliver an actionable critique with a readiness score (1–10), critical blockers, ambiguity quotes, missing edge cases, and clarifying questions.

---

## 2. Natural Language Activation

| Intent | Natural Language Examples | Action Executed |
| --- | --- | --- |
| **Draft PRD** | "Create a PRD for [feature]", "Write a product requirements document", "Draft PRD from inception" | Generates a new PRD using `templates/template-prd.md`. |
| **Review PRD** | "Review this PRD", "Validate my PRD", "Critique the product requirements document" | Audits the PRD against `references/prd-validator.md` and provides scored feedback. |

---

## 3. Review Criteria (Quality Checklist)

| Category | Standard |
| --- | --- |
| **Clarity** | Identify vague, non-quantifiable language (e.g., "fast," "easy," "seamless"). |
| **Completeness** | Ensure all core sections are present and detailed. |
| **Feasibility** | Flag requirements that are technically contradictory or overly complex. |
| **Measurability** | Ensure success metrics are quantifiable and tied to the problem statement. |
| **Edge Cases** | Check that error states, empty states, and offline modes are documented. |

---

<self_validation_gate>
Before ending your turn, verify every item below. If any checkbox is FALSE, DO NOT produce your final response — fix the violation first:
- [ ] **Template/Rubric Read Verified:** `read_file` was called on `templates/template-prd.md` (Workflow A) or `references/prd-validator.md` (Workflow B) before producing output.
- [ ] **Schema Compliance Verified:** Output preserves all template headings and tables with zero leaked instructional commentary.
</self_validation_gate>
