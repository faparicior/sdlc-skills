# AI Product Discovery Coach for 'Slice Out a Learning Strategy'

Act as an expert Product Discovery Coach familiar with Jeff Patton's 'Plan to Learn Faster' and Lean Startup principles. Review the provided 'Step 5: Slice Out a Learning Strategy' document. Evaluate its suitability and quality based on the following criteria derived from the sources:

1. Assumption vs. Requirement:
    - Does the document clearly distinguish between facts and Risky Assumptions?
    - Does it categorize risks into Value (do they want it?), Usability (can they use it?), Feasibility (can we build it?), and Business (should we build it?) risks?,.
2. The MVPe Test (Experiment vs. Product):
    - Does the defined 'Learning Slice' describe a Minimum Viable Product experiment (MVPe)—the smallest thing required to learn—rather than the MVS (Minimum Viable Solution) defined in the previous step?.
    - Red Flag Check: Does the experiment require building the full production code? If so, flag this as 'Building to Earn' rather than 'Building to Learn' and suggest a cheaper prototype or research method,.
3. Measurable Success Signals:
    - Are the success metrics defined as observable user behaviors (e.g., 'users click the button', 'users complete the task unassisted') rather than vague feelings (e.g., 'users like it')?,.
    - Is there a clear threshold for success/failure defined before the experiment is run?.
4. **Persona Alignment:**
    - Does the experiment target the correct Persona? (e.g., Testing 'Setup Friction' with the *Organizer*, not the *Speaker*).
5. **Timeboxing:**
    - Is each experiment time-bound? Does it look like it can be completed in hours or days, not weeks?
6. **The Pivot Logic:**
    - Does the 'Go/No-Go' section explicitly allow for the possibility of failure? Does it define what happens if the data proves the solution is wrong (e.g., pivot, iterate, or kill the idea)?,.

## Output Request

1. Risk Audit: Rate the 'Riskiest Assumptions' section (1=Safe/Obvious, 5=Truly Critical/Existential Risks).
2. Experiment Efficiency: Identify if the proposed experiments are too expensive (e.g., coding vs. prototyping) and suggest a 'smaller' way to learn the same thing.
3. Metric Critique: Flag any 'Vanity Metrics' (e.g., number of page views) that do not actually validate the specific assumption."

--------------------------------------------------------------------------------

## Manual Quality Checklist

If performing the review manually, look for these specific "smells" in the document:

- The "We Know Everything" Smell: If the "Risky Assumptions" section is empty or lists trivial technical tasks (e.g., "The server stays up"), the team is skipping discovery. They must identify what human behavior they are unsure about.
- The "Big Build" Smell: If the experiment involves "Release v1.0 to the App Store," this is not a learning slice; this is a release. A learning slice should be a prototype, a fake door test, or a paper sketch shown to 10 users,.
- The "Confirmation Bias" Smell: Are the success metrics written to prove the team is right (e.g., "Get 5 users to say it's cool")? They should be written to allow the team to be wrong (e.g., "If fewer than 50% of users click 'Buy', we kill the feature").

## The "Science Lab" Analogy

Treat Step 5 like a Science Lab, not a Construction Site.

- Construction Site (Step 6): Focuses on safety, stability, and finishing on time.
- Science Lab (Step 5): Focuses on explosions, failed mixtures, and finding the truth. If your Step 5 document looks like a construction blueprint (guaranteeing success), it is wrong. It should look like a lab notebook (hypotheses and tests)
