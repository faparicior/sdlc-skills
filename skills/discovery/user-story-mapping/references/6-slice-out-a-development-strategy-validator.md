# AI Product Discovery Coach for 'Slice Out a Development Strategy'

Act as an expert Agile Delivery Lead and Product Coach familiar with Jeff Patton's 'Chess Strategy' for incremental development. Review the provided 'Step 6: Slice Out a Development Strategy' document. Evaluate its idoneity and quality based on the following criteria derived from User Story Mapping principles:

1. Risk-First Sequencing:
    - Does the strategy explicitly identify Technical, User, and Business risks associated with this release?
    - Are the highest-risk items scheduled for the Opening Game? Does the plan prioritize proving capability over completing functionality?

2. The 'Walking Skeleton' (Opening Game):
    - Does the first development phase (Opening Game) create a 'Functional Walking Skeleton'? That is, does it connect the system end-to-end (e.g., UI to Database) even if the data is hardcoded or the UI is ugly?
    - Check for Horizontal Slicing: Does the plan avoid building layer-by-layer (e.g., 'Sprint 1: Build Database', 'Sprint 2: Build API') in favor of building a thin slice through the whole stack?

3. The Chess Strategy Phases:
    - Opening Game: Is the scope limited to the essential backbone and high-risk items, skipping business rules and optional steps?
    - Mid Game: Does this phase correctly group the 'heavy lifting'—implementing validation, business logic, and secondary flows?
    - End Game: Is the final phase reserved for refinement, UI polish, performance tuning, and 'sexiness', rather than core feature development?

4. Learning & Spikes:
    - Does the plan include specific 'Spikes' (investigative timeboxes) for stories where the team lacks domain or technical knowledge?
    - Are there planned moments to pause and evaluate the product with stakeholders after the Opening and Mid games, rather than waiting for the final release?

5. Capacity Reality Check:

    - Is the 'Opening Game' small enough to fit into the first few sprints based on the team's estimated velocity?

## Output Request

1. Risk Score: Rate the strategy's focus on risk reduction (1 = Ignored/Backloaded, 5 = Risks tackled immediately).
2. Identify 'Layer Cake' Slices: Flag any items that look like horizontal architectural layers (e.g., 'Build DB schema') rather than vertical user value slices.
3. Gap Analysis: Identify if any critical 'End Game' polish (like error handling or performance) is missing from the plan."

--------------------------------------------------------------------------------

## Manual Quality Checklist

If performing the review manually, look for these specific "smells" in the content:

- The "Backend-First" Smell: If the Opening Game is entirely database or API work with no user interface, the team is delaying integration risk. A true "Walking Skeleton" must allow a user to perform a rudimentary action through the UI.

- The "Big Bang" Smell: If the Opening Game contains 80% of the stories, the team hasn't actually sliced the strategy; they have just planned to "build everything." The Opening Game should be a "steel thread"—thin and strong.

- The "Gold-Plating" Smell: Are developers adding "nice-to-have" features or complex error handling in the Opening Game? This should be deferred to the Mid or End game to ensure the core architecture proves viable first.

## The "Da Vinci" Analogy

When reviewing this document, look for the Da Vinci Strategy.

- Bad Strategy: Painting the Mona Lisa by finishing the head perfectly, then the neck perfectly, then the hands. (If you run out of time, you have a floating head).

- Good Strategy (Step 6): Sketching the whole composition (Opening Game), filling in the forms and colors (Mid Game), and finally adding the details and varnish (End Game). If you run out of time, you still have a complete, recognizable picture, even if it lacks some polish.
