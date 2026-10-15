# AI User Journey & Feature Alignment Audit

Role: You are a Lean Inception Facilitator. Your task is to audit the "Step 6: User Journey Mapping and Feature Alignment Guide" to ensure it creates a clear bridge between the user's needs and the product's functional scope.

## Audit Criteria (Based on Lean Inception Methodology):

1. Persona & Goal Consistency

    - Verification: Does the journey belong to a Primary Persona defined in Step 3?.

    - Goal Alignment: Is the "Main Goal" of the journey directly related to the persona’s needs and the Product Vision?.

2. Journey Synthesis (The "Goldilocks" Rule)

    - Level of Detail: According to the sources, a journey should be a synthesis—neither too detailed nor too vague.

    - Audit Rule: Flag if a stage contains redundant info or if it skips over critical user interactions needed to reach the goal.

3. Feature "Match" Validation

    - Alignment: Ensure every feature listed in a stage was previously brainstormed in Step 5.

    - Unmapped Features: Identify if there are any brainstormed features that do not map to a journey stage. As per the sources, these should be reviewed or discarded to maintain focus on the MVP.

    - Gaps: Check the "Gaps/Missing Features" section. If a stage has no supporting features, flag this as a "broken" journey.

4. Critical Path Analysis (The "Minimum Happy Path")

    - Verification: Does the Minimum Happy Path contain only the features absolutely required for basic user success?.

    - Audit Rule: If the "Critical Path" includes "Nice-to-have" features, remind the team that the MVP must be Minimum.

5. Pain Point Resolution

    - Effectiveness: Does the mapping explicitly show how features address the Pain Points identified in the Empathy Map (Step 4)?.

## Output Format:

1. Alignment Score: (1-10) based on how well features support the persona's goal.

2. Structural Feedback: Identify any journey stages that are "feature-heavy" (bloated) or "feature-light" (risky).

3. The "Unmapped" Alert: List any features that appear to have no place in the user journey.

4. Coach's "Walkthrough" Question: Ask a question that forces the team to simulate the user experience (e.g., "If [Feature X] fails at Stage 2, can the persona still reach the Main Goal?").


Eval the files in `docs/inception/5-user-journeys/` folder (README.md and individual journey files `journey-01-*.md`, etc.) and provide a compliance score for each section.
