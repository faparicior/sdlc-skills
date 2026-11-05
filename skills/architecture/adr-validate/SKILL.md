---
name: adr-validate
description: >-
  Audit and validate the quality, completeness, and architectural compliance of any ADR or amendment in docs/adr/.
  TRIGGER THIS SKILL when user mentions: validate adr, audit adr, check adr quality,
  verify adr, review adr compliance.
disable-model-invocation: true
---

# PROTOCOL: ADR-VALIDATE (EXECUTION LEVEL 3)

<state_machine>
CURRENT_STEP          -> REQUIRED_TOOL                                      -> REQUIRED_OUTPUT                                         -> MANDATORY_HALT
Step 1: Read Target   -> read_file (target ADR + docs/adr/README.md)        -> Target ADR content & index state                        -> Continue to Step 2
Step 2: Audit Rubric  -> read_file(templates/TEMPLATE-ADR_VALIDATOR.md)     -> 6-point rubric evaluation                               -> Continue to Step 3
Step 3: Score Report  -> format using TEMPLATE-ADR_VALIDATOR.md             -> Scored validation report (High / Medium / Low)          -> 🛑 HALT TURN (Present audit)
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: Execute all 3 steps and all 6 rubric checks in strict order (`workflow structure = immutable | step reasoning = flexible`).
2. TEMPLATE LOCK: You MUST call `read_file` on `templates/TEMPLATE-ADR_VALIDATOR.md` before producing the validation report and preserve its exact rubric sections and scoring structure.
</execution_invariants>

<output_contract>
- SOURCE_TEMPLATE: `templates/TEMPLATE-ADR_VALIDATOR.md` (MUST call `read_file` before producing report)
- SCHEMA_INVARIANCE: Preserve all 6 rubric check sections and overall quality score breakdown verbatim.
</output_contract>

---

## 📋 Step-by-Step Workflow

### 1. Identify Target ADR File
Locate the file in `docs/adr/` specified by the user (or prompt for the path if not provided).

### 2. Audit Against the 6-Point Quality Rubric

#### Check 1: Metadata Completeness
- [ ] Number follows 3-digit sequential standard (`0XX`).
- [ ] Status is valid (`Proposed`, `Accepted`, `Approved`, `Superseded`, `Deprecated`).
- [ ] Date is present and correctly formatted.
- [ ] Two-way links exist if this is an amendment (`Amends`) or superseded record (`Superseded By`).

#### Check 2: Context & Problem Statement
- [ ] Problem statement clearly explains the technical or business force driving the decision.
- [ ] Constraints and decision drivers (e.g., zero-cost tier, DDD boundaries) are explicitly listed.

#### Check 3: Considered Options (Minimum 2–3)
- [ ] At least 2–3 viable, real-world alternatives are analyzed.
- [ ] Each option has balanced, objective pros (✅) and cons (❌).
- [ ] No strawman alternatives designed solely to validate the chosen option.

#### Check 4: Decision Outcome & Consequences
- [ ] Clear statement of the winning decision.
- [ ] Concrete justification explaining why it was chosen over the alternatives.
- [ ] Balanced consequences: positive impacts, negative impacts/trade-offs, and risk mitigations.

#### Check 5: 🤖 AI & Agentic Ergonomics (AX) [Mandatory]
- [ ] `LLM Corpus Alignment` is classified (`High`, `Medium`, `Atypical`).
- [ ] `Guardrail Tax` is evaluated (`Low`, `Medium`, `High`).
- [ ] `Drift Risks` are documented (explaining where LLMs are prone to hallucinate or revert to generic patterns).

#### Check 6: References & Document Health
- [ ] All file links use working relative paths within `docs/adr/` or repo markdown links.
- [ ] The record is listed in `docs/adr/README.md`.

### 3. Assign Quality Score & Provide Feedback
Calculate overall quality score:
- **High (Pass)**: 6/6 checks satisfied. The ADR is complete and ready for adoption.
- **Medium (Conditional Pass)**: 4–5 checks satisfied with minor gaps (e.g., weak consequences or missing AX tag). Provide bullet points for quick fixes.
- **Low (Needs Revision)**: <4 checks satisfied (e.g., only 1 option considered, missing context, no AX section). Block adoption until remediated.

---

<self_validation_gate>
Before ending your turn, verify every item below. If any checkbox is FALSE, DO NOT produce your final response — fix the violation first:
- [ ] Target ADR file and `docs/adr/README.md` were read via `read_file`.
- [ ] **Template Read Verified:** `read_file` was called on `templates/TEMPLATE-ADR_VALIDATOR.md`.
- [ ] All 6 rubric checks evaluated and scored using the template's exact structure.
</self_validation_gate>
