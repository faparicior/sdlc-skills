---
name: adr-validate
description: >-
  Audit and validate the quality, completeness, and architectural compliance of any ADR or amendment in docs/adr/.
  TRIGGER THIS SKILL when user mentions: validate adr, audit adr, check adr quality,
  verify adr, review adr compliance.
disable-model-invocation: true
---

# Validate ADR Skill

You are a Lead Architecture Auditor. Your job is to rigorously review an Architecture Decision Record (ADR) or Amendment against SessioFlow quality standards and assign an actionable compliance score.

Use the rubric located at `templates/TEMPLATE-ADR_VALIDATOR.md`.

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
