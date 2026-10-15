# 0XX-[Original Title] Analysis: [Short Analysis Subtitle]

* **Status:** Accepted
* **Date:** [YYYY-MM-DD]
* **Decision Makers:** [List of decision makers]
* **Related:** [ADR-0XX](0XX-original-filename.md)

---

## Context and Problem Statement

Describe the specific question this analysis answers (e.g., vendor lock-in exposure, alternative evaluation, market research, cost study). State what decision(s) it informs and which ADR(s) depend on its conclusion.

---

## Considered Alternatives

### Option 1: [Current Decision - ADR-0XX]

* **Description:** [What the current decision does today]
* **Strengths:** [Key advantages]
* **Weaknesses:** [Key limitations]

### Option 2: [Alternative Under Evaluation]

* **Description:** [What the alternative would change]
* **Strengths:** [Key advantages]
* **Weaknesses:** [Key limitations]

---

## Comparison Matrix

| Criterion | Option 1 | Option 2 |
| --------- | -------- | -------- |
| [Criterion 1 - e.g., Cost] | [Assessment] | [Assessment] |
| [Criterion 2 - e.g., Migration effort] | [Assessment] | [Assessment] |
| [Criterion 3 - e.g., AI / Agentic ergonomics (AX) & LLM training corpus alignment] | [Assessment] | [Assessment] |
| [Criterion 4 - e.g., Learning curve & guardrail tax] | [Assessment] | [Assessment] |

---

## Decision Outcome

**Recommended Approach:** [State the recommendation this analysis supports]

**Justification:** [Why this recommendation follows from the comparison, tied to project constraints (MVP timeline, budget, team expertise)].

---

## Consequences

### If We Follow the Recommendation

* **Positive:**
  * ✅ [Benefit 1]
* **Negative/Risks:**
  * ❌ [Drawback 1]
  * ⚠️ [Risk 1]

---

## 🤖 AI & Agentic Ergonomics (AX)

Evaluate the friction of the pattern this analysis recommends (the validator audits this section).

* **LLM Corpus Alignment:** [High (>80%) | Medium (30-80%) | Atypical/Exotic (<30%) for the recommended pattern]

| Expected Agent Bias | Automated Guardrail |
| --- | --- |
| [e.g., Generic vendor SDK idioms that re-create the lock-in this document warns against] | [Rule that keeps the recommendation from being silently eroded: arch test, vendor-import confinement, AGENTS.md rule] |
| [Bias with no automated countermeasure] | — (accepted manual-review risk — justify or close the gap) |

* **Supervision & Guardrail Tax:** [Low | Medium | High]

---

## Recommendations

### For MVP ([timeline, budget])

* [Immediate, concrete recommendation]

### For Long-term Product

* [Post-MVP recommendation]

---

## Migration Path

[Optional — only if the analysis concludes a migration is plausible. List phases with rough effort:]

1. **Phase 1:** [Phase and effort]
2. **Phase 2:** [Phase and effort]

---

## Links

* [Reference 1 with URL]
* [Related ADR with relative link]

---

## Discussion Questions

1. [Open question for stakeholders]
2. [Open question for stakeholders]

---

## Decision

* [ ] Analysis reviewed by [role]
* [ ] Recommendation accepted / fed back into ADR-0XX (amended / no change needed)
