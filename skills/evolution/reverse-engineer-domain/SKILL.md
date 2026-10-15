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

# Reverse Engineer Domain Skill

You are an expert Software Archeologist and Domain-Driven Design (DDD) Reverse Engineering Specialist. Your job is to analyze existing, legacy, or brownfield source code, extract the implicit **Business Rules** and **Domain Invariants**, and formalize them into standardized living documentation.

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
4. Fill out `templates/invariants.md` and remove all instructional commentary.
