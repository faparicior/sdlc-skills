# Slice Out a Development Strategy

Objective: Break the Minimum Viable Solution (MVS) defined in Step 4 (and validated in Step 5) into three tactical stages of development. The goal is to learn fast, mitigate risk early, and avoid a "big bang" integration at the end.

## 1. Risk Assessment

Before sequencing the work, identify what could cause this release to fail. We prioritize building the risky parts first.

- **Technical Risks:** [e.g., "We don't know if the legacy API can handle the load."]
- **User/Value Risks:** [e.g., "We assume users will understand the new dashboard layout."]
- **Business Risks:** [e.g., "We assume legal will approve this data collection."]

## 2. The Chess Strategy (Opening, Mid, End)

Slice the MVS vertically into three phases. Do not build feature-by-feature; build across the system.

### Phase 1: The Opening Game (The Walking Skeleton)

Focus on essential features that cross the entire system. Build just enough to see the product working end-to-end. Skip business rules and optional steps.

- **Goal:** [e.g., "Connect the frontend to the backend and process a transaction successfully, even if the data is hardcoded."]
- **Key Stories:**
  - [Story Name]
  - [Story Name]
- **Validation:** Does this prove the architecture works?

### Phase 2: The Mid Game (Fleshing it Out)

Fill in the details. Add the business rules, data validation, and secondary flows. This is where you test performance and scalability.

- **Goal:** [e.g., "Make the transaction flow robust, handle errors, and apply real business logic."]
- **Key Stories:**
  - [Story Name]
  - [Story Name]
- **Validation:** Can we handle edge cases and bad data?

### Phase 3: The End Game (Polishing)

Refine the release. Make it sexy, efficient, and launch-ready. This is where you apply feedback gathered from the Opening and Mid games.

- **Goal:** [e.g., "Trustworthy UI & Measurable. Ensure the user feels safe, professional, and we can track success."]
- **Key Stories:**
  - [Story Name]
  - [Story Name]
- **Validation:** Is this delightful enough to release? **Can we measure the outcome?**

## 3. The Learning Plan (Experiments & Spikes)

Identify specific activities required to validate the risks listed in Section 1. These are not necessarily code; they can be prototypes or research.

| Assumption / Risk | Experiment / Spike | Success Metric |
| :--- | :--- | :--- |
| [e.g., Users want this specific report] | [e.g., Show paper prototype to 5 users] | [e.g., 4/5 users can explain the report's value] |
| [e.g., Database handles 1k concurrent users] | [e.g., Technical Spike: Load test script] | [e.g., Latency remains under 200ms] |

## 4. Team Capacity Check

Does the "Opening Game" fit into the first few sprints?

- **Estimated Velocity:** [e.g., 20 points per sprint]
- **Opening Game Size:** [Total Estimate]
- **Reality Check:** If the Opening Game is too big, can we slice it thinner? (e.g., Use a flat file instead of a real database for the first pass).

--------------------------------------------------------------------------------

🔍 Quality Checklist for Step 6

- [ ] **Walking Skeleton:** Does the "Opening Game" slice cut through the entire architecture (UI, Logic, Database) rather than just building one layer?
- [ ] **Risk First:** Did we schedule the highest-risk stories in the Opening Game?
- [ ] **Learning Loops:** Have we planned moments to pause and evaluate the product with stakeholders after the Opening and Mid games, rather than waiting for the final release?
