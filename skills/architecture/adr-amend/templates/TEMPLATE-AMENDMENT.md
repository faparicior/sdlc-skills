# 0XX-[Original Title] Amendment: [Short Amendment Description]

* **Status:** Proposed Amendment
* **Date:** [YYYY-MM-DD]
* **Decision Makers:** [List of decision makers]
* **Amends:** [ADR-0XX](0XX-original-filename.md)
* **Related:** [List related ADRs, e.g., ADR-002a, ADR-002b]

---

## Purpose of This Amendment

Describe the reason for proposing this amendment (e.g., changes in requirements, pricing adjustments, new architecture patterns, or library deprecations).

---

## Critical Updates to ADR-0XX

Detail the specific parts of the original decision that are being revised.

### Update 1: [Topic of Update]
* **Original ADR-0XX stated:** "[Quote the original text]"
* **Correction/New Analysis:** "[Explain the update, supported by current official data]"

### Update 2: [Topic of Update]
* **Original ADR-0XX stated:** "[Quote the original text]"
* **Correction/New Analysis:** "[Explain the update, supported by current official data]"

---

## Revised Decision Options

List the updated options or modified variants of original options being considered:

### Option 1: Keep Original Decision As-Is
* **Description:** Continue with the choice approved in the original ADR.
* **Assessment:** [Explain why this is no longer optimal or what limitations it presents now]

### Option X: [Amended/Hybrid Option Title]
* **Description:** [Detail the proposed change, e.g., database with repository abstraction, or a new client driver]
* **Assessment:** [Highlight pros, cons, and migration implications]

---

## Revised Consequences

List the positive and negative consequences of the amended approach compared to the original decision.

### If We Choose Option 1 (Keep Original):
* **Positive:**
  - ✅ [Benefit 1]
* **Negative:**
  - ❌ [Drawback 1]

### If We Choose Option X (Amended Option):
* **Positive:**
  - ✅ [Benefit 1]
* **Negative/Risks:**
  - ⚠️ [Risk 1]
  - ❌ [Drawback 1]

---

## 🤖 AI & Agentic Ergonomics (AX)

Re-evaluate friction against LLM training corpora for the **amended** pattern — the original ADR's AX assessment may no longer apply after this change.

* **LLM Corpus Alignment:** [High (>80%) | Medium (30-80%) | Atypical/Exotic (<30%) — for the amended pattern, not the original]

| Expected Agent Bias | Automated Guardrail |
| --- | --- |
| [New deviation the amendment introduces, or corpus default it restores] | [Arch test, linter or AGENTS.md rule added/updated by this amendment] |
| [Bias with no automated countermeasure] | — (accepted manual-review risk — justify or close the gap) |

* **Supervision & Guardrail Tax:** [Low | Medium | High — and whether it rises or falls compared to the original ADR]

---

## Revised Decision Outcome

### Updated Recommendation
* **Option Chosen:** [State the chosen amended option]
* **Justification:** [Connect the choice back to the new decision drivers and original project constraints]
* **Migration Path:** [Outline the phases to transition from the original choice to the amended one]

---

## Updated Links
* [Reference 1 with URL]
* [Reference 2 with URL]
