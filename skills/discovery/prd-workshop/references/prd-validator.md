# PRD Validator & Review Rubric

Review a submitted Product Requirements Document (PRD) for completeness, clarity, technical feasibility, and business alignment.

---

## 1. Review Criteria

| Category | Check |
| :--- | :--- |
| **Clarity & Ambiguity** | Identify vague, non-quantifiable language (e.g., "fast," "easy," "seamless," "manageable"). |
| **Completeness** | Ensure all core sections (Executive Summary, Problem, Metrics, Personas, Functional Requirements, UX/UI, Engineering Specs, NFRs) are present. |
| **Technical Feasibility** | Flag contradictory requirements, high architectural risks, or unstated complexities. |
| **Measurability** | Verify that success metrics are quantifiable, have baselines and targets, and tie directly to the Problem Statement. |
| **Edge Cases & Failure States** | Check if error states, empty states, offline modes, and timeouts are explicitly addressed. |

---

## 2. Review Output Format

```markdown
### 1. Overall Assessment
* **Readiness Score (1-10):** [Holistic score]
* **Verdict:** [Ready for Dev / Needs Minor Revisions / Needs Major Rework]

### 2. Critical Blockers (Stop Work)
* *Issues that must be resolved before engineering begins.*
* **[BLOCKER 1]:** [Description] -> **Recommended Action:** [Specific fix required]

### 3. Ambiguity & Clarity Gaps
* "Quote from PRD" -> **Why it's vague:** [Explain what needs quantification (e.g. latency target in ms)]

### 4. Missing Edge Cases & Technical Risks
* [ ] **Missing Edge Case:** [e.g., What happens if payment gateway times out?]
* [ ] **Technical Risk:** [e.g., Unaddressed data consistency under high concurrent load]

### 5. Clarifying Questions & Next Steps
* Questions to clarify with PM/Stakeholders before approval.
```
