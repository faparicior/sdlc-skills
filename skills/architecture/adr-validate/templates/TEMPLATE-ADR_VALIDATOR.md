# Template: ADR Validator

**Template Version:** 1.0  
**Created:** 2026-06-06  
**Purpose:** Validate ADR quality against established criteria

---

# ADR Quality Validator

**Validator Version:** 1.0  
**Analysis Date:** [YYYY-MM-DD]  
**Validator:** [Name/Role]

---

## Overview

This validator assesses the quality of Architecture Decision Records (ADRs) against established criteria. Each ADR is evaluated on a scale of **High**, **Medium**, or **Low** quality.

**Purpose:** Ensure all ADRs meet minimum standards for clarity, completeness, and usefulness.

---

## Validation Criteria

### Criteria 1: Metadata & Formal Compliance

**What to Check:**
- [ ] Status field present and valid (Proposed/Accepted/Deprecated/Superseded)
- [ ] Date field present (YYYY-MM-DD format)
- [ ] Decision makers identified
- [ ] Supersedes/Amended By fields completed (even if N/A)
- [ ] ADR follows standard template structure

**Scoring:**
- **High:** All metadata fields complete and correct
- **Medium:** 1-2 minor metadata issues
- **Low:** Missing critical metadata or incorrect format

**Assessment:**
- [ ] High
- [ ] Medium
- [ ] Low

**Notes:**
[Document any metadata issues found]

---

### Criteria 2: Context & Problem Statement

**What to Check:**
- [ ] Context is clear and unbiased (value-neutral)
- [ ] Problem statement is specific and well-defined
- [ ] References specific pain points or constraints
- [ ] Decision drivers are explicitly stated
- [ ] Links back to inception artifacts or business requirements

**Scoring:**
- **High:** Context is crystal clear, problem well-defined, drivers explicit
- **Medium:** Context is clear but some drivers missing or vague
- **Low:** Context is unclear or problem statement is missing

**Assessment:**
- [ ] High
- [ ] Medium
- [ ] Low

**Notes:**
[Document strengths or weaknesses in context definition]

---

### Criteria 3: Options & Analysis

**What to Check:**
- [ ] At least 2-3 viable alternatives considered
- [ ] No strawman options (all options are realistic)
- [ ] Each option has pros and cons documented
- [ ] Options are compared against decision drivers
- [ ] Trade-offs are explicitly discussed

**Scoring:**
- **High:** 3+ viable options with balanced, evidence-based analysis
- **Medium:** 2-3 options with some analysis gaps
- **Low:** Only 1-2 options or strawman options presented

**Assessment:**
- [ ] High
- [ ] Medium
- [ ] Low

**Notes:**
[Document the quality of options analysis]

---

### Criteria 4: Decision Outcome

**What to Check:**
- [ ] Chosen option is clearly identified
- [ ] Justification is logical and evidence-based
- [ ] Justification references decision drivers
- [ ] Decision aligns with constraints (cost, timeline, etc.)
- [ ] Rationale is convincing and complete

**Scoring:**
- **High:** Clear choice with strong, evidence-based justification
- **Medium:** Clear choice but justification could be stronger
- **Low:** Unclear choice or weak justification

**Assessment:**
- [ ] High
- [ ] Medium
- [ ] Low

**Notes:**
[Document the strength of the decision justification]

---

### Criteria 5: Consequences Documentation

**What to Check:**
- [ ] Positive consequences explicitly listed
- [ ] Negative consequences explicitly listed
- [ ] Risks identified and documented
- [ ] Consequences are specific and actionable
- [ ] Long-term implications considered

**Scoring:**
- **High:** Comprehensive consequences (positive, negative, risks) all documented
- **Medium:** Some consequences missing or vague
- **Low:** Consequences section incomplete or missing

**Assessment:**
- [ ] High
- [ ] Medium
- [ ] Low

**Notes:**
[Document the quality of consequences documentation]

---

### Criteria 6: Traceability & References

**What to Check:**
- [ ] Links to inception artifacts (goals, constraints, personas, features)
- [ ] References to external documentation or standards
- [ ] Links to related ADRs (if applicable)
- [ ] Citations for any data or benchmarks used
- [ ] Clear connection to business requirements

**Scoring:**
- **High:** Comprehensive traceability with multiple sources
- **Medium:** Some traceability links present
- **Low:** Missing or minimal traceability

**Assessment:**
- [ ] High
- [ ] Medium
- [ ] Low

**Notes:**
[Document traceability quality]

---

### Criteria 7: AI & Agentic Ergonomics (AX)

**What to Check:**

- [ ] `LLM Corpus Alignment` states an estimated training-corpus match (High >80% / Medium 30-80% / Atypical <30%)
- [ ] A `Expected Agent Bias | Automated Guardrail` table pairs each expected agent deviation with a named automated countermeasure
- [ ] Rows marked "—" are explicitly justified as accepted manual-review risks (unjustified gaps fail this criterion)
- [ ] Guardrail tax / human oversight burden is acknowledged

**Scoring:**

- **High:** Corpus alignment quantified, every bias paired to an automated guardrail, tax assessed
- **Medium:** Some AX analysis present but pairings incomplete or tax unaddressed
- **Low:** AX section missing or descriptive only (no guardrails)

**Assessment:**

- [ ] High
- [ ] Medium
- [ ] Low

**Notes:**
[Document AX quality; list any unmitigated bias→guardrail gaps]

---

## Overall Quality Assessment

### Quality Score Summary

| Criteria | Score | Weight | Weighted Score |
|----------|-------|--------|----------------|
| Metadata & Formal Compliance | [H/M/L] | 10% | [X] |
| Context & Problem Statement | [H/M/L] | 20% | [X] |
| Options & Analysis | [H/M/L] | 20% | [X] |
| Decision Outcome | [H/M/L] | 20% | [X] |
| Consequences Documentation | [H/M/L] | 10% | [X] |
| Traceability & References | [H/M/L] | 10% | [X] |
| AI & Agentic Ergonomics (AX) | [H/M/L] | 10% | [X] |
| **Total** | - | 100% | **[X]** |

**Scoring Scale:**
- High = 3 points
- Medium = 2 points
- Low = 1 point

**Overall Quality Score:** [X]/3.0

---

### Final Quality Rating

```
┌─────────────────────────────────────────────────────────────┐
│                    QUALITY RATING                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Overall Rating: [High / Medium / Low]                     │
│                                                             │
│  Score: [X]/6 criteria at High level                       │
│                                                             │
│  Recommendation: [Accept / Revise / Reject]                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Rating Guidelines:**
- **High Quality:** 5-6 criteria at High level, no Low ratings
- **Medium Quality:** 3-4 criteria at High level, or 1-2 Medium ratings
- **Low Quality:** More than 2 criteria at Medium or any Low rating

---

## Detailed Assessment

### ADR: [ADR-XXX - Decision Title]

**Status:** [Proposed / Accepted / Deprecated / Superseded]  
**Date:** [YYYY-MM-DD]

#### Strengths

1. **[Strength 1]**
   - Evidence: [Specific example from the ADR]
   - Impact: [Why this is valuable]

2. **[Strength 2]**
   - Evidence: [Specific example from the ADR]
   - Impact: [Why this is valuable]

3. **[Strength 3]**
   - Evidence: [Specific example from the ADR]
   - Impact: [Why this is valuable]

#### Areas for Improvement

1. **[Area 1]**
   - Issue: [Specific problem identified]
   - Impact: [How this affects the ADR's usefulness]
   - Suggestion: [Concrete recommendation for improvement]

2. **[Area 2]**
   - Issue: [Specific problem identified]
   - Impact: [How this affects the ADR's usefulness]
   - Suggestion: [Concrete recommendation for improvement]

3. **[Area 3]**
   - Issue: [Specific problem identified]
   - Impact: [How this affects the ADR's usefulness]
   - Suggestion: [Concrete recommendation for improvement]

---

## Recommendations

### Immediate Actions

- [ ] [Action item 1]
- [ ] [Action item 2]

### Optional Enhancements

- [ ] [Enhancement 1]
- [ ] [Enhancement 2]

### Revision Required: Yes / No

**If Yes, specify:**
- [ ] Metadata corrections needed
- [ ] Context needs clarification
- [ ] Options analysis needs expansion
- [ ] Decision justification needs strengthening
- [ ] Consequences need more detail
- [ ] Traceability needs improvement

---

## Validation Summary

### Quality Metrics

| Metric | Value |
|--------|-------|
| Total Criteria Assessed | 7 |
| High Quality Criteria | [X] |
| Medium Quality Criteria | [X] |
| Low Quality Criteria | [X] |
| Overall Score | [X]/7 |
| Quality Rating | [High/Medium/Low] |

### Decision

**Recommendation:** [Accept / Accept with Revisions / Reject]

**Rationale:**
[Summary of why this recommendation was made]

**Next Steps:**
- [ ] Approve ADR as-is
- [ ] Request revisions and re-validate
- [ ] Reject and start over

---

## Batch Validation Summary (Multiple ADRs)

If validating multiple ADRs, use this summary:

### Overall Statistics

| Quality Level | Count | Percentage |
|---------------|-------|------------|
| High | [X] | [X]% |
| Medium | [X] | [X]% |
| Low | [X] | [X]% |
| **Total** | **[X]** | **100%** |

### ADR-by-ADR Results

| ADR | Title | Quality | Recommendation | Notes |
|-----|-------|---------|----------------|-------|
| 001 | [Title] | [H/M/L] | [Action] | [Brief note] |
| 002 | [Title] | [H/M/L] | [Action] | [Brief note] |
| 003 | [Title] | [H/M/L] | [Action] | [Brief note] |

### Common Issues Found

1. **[Issue 1]** - Found in [X] ADRs
   - Pattern: [Description of the pattern]
   - Recommendation: [How to fix]

2. **[Issue 2]** - Found in [X] ADRs
   - Pattern: [Description of the pattern]
   - Recommendation: [How to fix]

### Best Practices Observed

1. **[Practice 1]** - Exemplified by ADR-[XXX]
   - Why it's good: [Explanation]

2. **[Practice 2]** - Exemplified by ADR-[XXX]
   - Why it's good: [Explanation]

---

## Validator Notes

**Validation Date:** [YYYY-MM-DD]  
**Validator Name:** [Name]  
**Validator Role:** [Role]

**General Observations:**
[Overall observations about the ADR set]

**Suggestions for Future ADRs:**
- [Tip 1 for improving future ADRs]
- [Tip 2 for improving future ADRs]
- [Tip 3 for improving future ADRs]

**Questions or Concerns:**
[Any questions or concerns that arose during validation]

---

## Sign-off

**Validator Signature:** ___________________  
**Date:** [YYYY-MM-DD]

**Review Status:**
- [ ] Pending Review
- [ ] Under Review
- [ ] Approved
- [ ] Requires Revision

**Reviewer:** [Name]  
**Review Date:** [YYYY-MM-DD]  
**Comments:** [Any additional comments]

---

## Appendix: Quality Thresholds

### What Constitutes "High" Quality

- All metadata fields complete and accurate
- Context is clear, unbiased, and comprehensive
- 3+ viable alternatives with thorough analysis
- Decision is clearly justified with evidence
- All consequences (positive, negative, risks) documented
- Strong traceability to business requirements

### What Constitutes "Medium" Quality

- Minor metadata gaps (1-2 fields)
- Context is clear but could be more specific
- 2-3 alternatives with some analysis gaps
- Decision is justified but could be stronger
- Most consequences documented
- Some traceability present

### What Constitutes "Low" Quality

- Missing critical metadata
- Context is unclear or incomplete
- Only 1-2 options or strawman options
- Decision justification is weak or missing
- Consequences section incomplete
- Little to no traceability

---

**End of Validator Template**
