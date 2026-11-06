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
Step 2: Audit Rubric  -> read_file(templates/TEMPLATE-ADR_VALIDATOR.md)     -> 7-criteria weighted rubric evaluation                   -> Continue to Step 3
Step 3: Score Report  -> format using TEMPLATE-ADR_VALIDATOR.md             -> Scored validation report (High / Medium / Low)          -> 🛑 HALT TURN (Present audit)
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: Execute all 3 steps and all 7 rubric criteria in strict order (`workflow structure = immutable | step reasoning = flexible`).
2. TEMPLATE LOCK: You MUST call `read_file` on `templates/TEMPLATE-ADR_VALIDATOR.md` before producing the validation report and preserve its exact rubric sections and weighted scoring structure.
</execution_invariants>

<output_contract>
- SOURCE_TEMPLATE: `templates/TEMPLATE-ADR_VALIDATOR.md` (MUST call `read_file` before producing report)
- SCHEMA_INVARIANCE: Preserve all 7 validation criteria sections, the weighted Quality Score Summary table (`3.0` scale), and the Validation Summary verbatim.
- ESCAPE_HATCH: Never silently omit or invent rubric sections. If a section (such as `Batch Validation Summary` when auditing a single ADR) does not apply, preserve the heading and write `"N/A — Single ADR audit"`, or omit only sections explicitly marked `(Multiple ADRs)`.
</output_contract>

---

## 📋 Step-by-Step Workflow

### 1. Identify Target ADR File
Locate the file in `docs/adr/` specified by the user (or prompt for the path if not provided).

### 2. Audit Against the 7-Criteria Weighted Quality Rubric (`templates/TEMPLATE-ADR_VALIDATOR.md`)

#### Criteria 1: Metadata & Formal Compliance (Weight: 10%)
- [ ] Status field present and valid (`Proposed`, `Accepted`, `Approved`, `Deprecated`, `Superseded`).
- [ ] Date field present (`YYYY-MM-DD` format).
- [ ] Decision makers identified.
- [ ] `Supersedes` / `Amended By` (or `Amends`) fields completed with two-way links where applicable.
- [ ] ADR follows standard template structure and 3-digit sequential numbering (`0XX`).

#### Criteria 2: Context & Problem Statement (Weight: 20%)
- [ ] Context is clear and unbiased (value-neutral).
- [ ] Problem statement is specific and well-defined.
- [ ] References specific pain points or constraints.
- [ ] Decision drivers are explicitly stated.
- [ ] Links back to inception artifacts or business requirements.

#### Criteria 3: Options & Analysis (Weight: 20%)
- [ ] At least 2–3 viable alternatives considered.
- [ ] No strawman options (all options are realistic).
- [ ] Each option has pros and cons documented (`Good, because...` / `Bad, because...`).
- [ ] Options are compared against decision drivers and trade-offs are explicitly discussed.

#### Criteria 4: Decision Outcome (Weight: 20%)
- [ ] Chosen option is clearly identified.
- [ ] Justification is logical, evidence-based, and references decision drivers.
- [ ] Decision aligns with project constraints (cost, timeline, architecture boundaries).

#### Criteria 5: Consequences Documentation (Weight: 10%)
- [ ] Positive consequences explicitly listed.
- [ ] Negative consequences explicitly listed.
- [ ] Risks identified and documented with actionable mitigations.

#### Criteria 6: Traceability & References (Weight: 10%)
- [ ] Links to inception artifacts, related ADRs, and external documentation/benchmarks.
- [ ] Record is listed in `docs/adr/README.md` with working relative links.

#### Criteria 7: AI & Agentic Ergonomics (AX) [Mandatory] (Weight: 10%)
- [ ] `LLM Corpus Alignment` states an estimated training-corpus match (`High >80%` / `Medium 30-80%` / `Atypical/Exotic <30%`).
- [ ] `Expected Agent Bias | Automated Guardrail` table pairs each expected agent deviation with a named automated countermeasure.
- [ ] Rows marked `—` are explicitly justified as accepted manual-review risks.
- [ ] `Supervision & Guardrail Tax` (`Low`, `Medium`, `High`) is assessed.

### 3. Assign Quality Score & Provide Feedback
Score each of the 7 criteria (`High = 3`, `Medium = 2`, `Low = 1`), compute the weighted score out of `3.0` (`[X]/7` criteria at High level), and assign the rating:
- **High Quality (Accept)**: 6–7 criteria at High level, no Low ratings.
- **Medium Quality (Accept with Revisions)**: 4–5 criteria at High level, or 1–2 Medium ratings. Provide concrete action items.
- **Low Quality (Reject / Revise)**: More than 2 criteria at Medium or any Low rating (e.g., missing AX section or strawman options). Block adoption until remediated.

---

<self_validation_gate>
Before ending your turn, verify every item below with concrete evidence (not just a checkmark). If any item cannot be cited with real evidence from this turn, DO NOT produce your final response — fix the violation first:
- [ ] **Target Read Evidence:** Exact target ADR path(s) and `docs/adr/README.md` read via `read_file`: `<paths>`
- [ ] **Template Read Evidence:** Exact path passed to `read_file` (`templates/TEMPLATE-ADR_VALIDATOR.md`): `<path>`
- [ ] **Rubric Score Evidence:** All 7 weighted criteria scored (`[X]/7` at High level, weighted total `[Y]/3.0`): `<scores>`
</self_validation_gate>
