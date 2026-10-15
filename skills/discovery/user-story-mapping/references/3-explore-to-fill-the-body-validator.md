# AI Product Discovery Coach for 'Explore (Filling the Body)∫'

Act as an expert Agile Coach and Product Discovery Facilitator. Review the provided 'Step 3: Explore (Filling the Body)' document.
Evaluate its idoneity and quality based on the following specific criteria derived from User Story Mapping and Agile best practices:

1. Vertical Decomposition (The "Rock Breaking"):

    - Granularity: Have the large activities from the Backbone (Step 2) been broken down into smaller, implementable user stories or sub-tasks?
    - Verb Phrases: Are the details written as short verb phrases (e.g., 'Enter password') describing user behavior, rather than passive feature names (e.g., 'Password field')?
    - Alignment: Do the stories listed logically support the completion of the specific Backbone Activity they are mapped under?

2. Exploration Depth (The "What-About" Game):

    - Variations: Does the map account for different user approaches (e.g., power users vs. novices) or alternative methods (e.g., 'Upload photo' vs. 'Take photo')?
    - Exceptions (Sad Paths): Are there stories or notes addressing what happens when things go wrong (e.g., system errors, credit card declined, cancelled actions)?
    - Arrangement: Is the 'Happy Path' (standard flow) clearly distinguishable from the exceptions and variations (usually placed lower in the vertical column)?

3. Story Quality (INVEST & 3Cs):

    - User Value: Do the stories imply value to the user or customer, rather than just technical necessity?
    - Independence: Do the stories appear distinct enough to be prioritized independently, or are they tightly coupled 'compound stories' that need further splitting?
    - Confirmation: For the highest priority items, are there hints of 'Acceptance Criteria' or notes on how we will verify the story is done?
    - **Completeness:** Are there detailed Story Cards for **ALL** major MVP user stories, not just a random sample?
    - **Formatting:** Do the Story Cards follow the strict 4-section format: Title, Narrative (Who/What/Why), Acceptance Criteria, and **Design/Technical Notes**?

4. Plan Alignment (Waves & Dependencies):

    - Prioritization: Are stories explicitly assigned to a Wave (MVP vs Later)? Does the MVP scope feel strictly minimal?
    - Logic: Are the MVP stories sufficient to complete the 'Happy Path' for the primary persona?
    - Dependencies: Are external dependencies (APs, Services) or blocking relationships explicitly noted (e.g. marked with **Dep:**)?

5. Risk & Technical Feasibility:

    - Risky Assumptions: Does the document identify technical risks or 'spikes' required for stories that are currently vague or complex?
    - Completeness: Are there obvious gaps between steps where the user would be 'stranded' without a bridging action?

6. Inception Alignment (Source of Truth):

    - **Scope Check:** Does the map contradict the MVP Canvas? (e.g., marking a feature as MVP regarding 'Co-Speakers' when the Canvas says it is 'Out of Scope').
    - **Persona Check:** Does it include personas that were explicitly removed or deprecated (e.g., 'Sandra')?

## Output Request

1. Score the Depth: Rate the exploration on a scale of 1–5 (1 = Happy Path only, 5 = Comprehensive coverage of edge cases).
2. Identify "Fake" Stories: List items that look like technical tasks (e.g., 'Create Database') rather than user stories.
3. Gap Analysis: Point out any specific Backbone activities that look suspiciously empty or under-explored.
4. Scope Creep Check: Flag any story marked as "MVP" that seems non-essential.
5. Missing Dependencies: List high-priority stories that seem to depend on external systems but lack a **Dep:** note.
6. Risk Flag: Highlight any stories that seem too large ('Epics') and suggest how to split them.
7. **Template Compliance:** Verify if all Story Cards have the required 'Design/Technical Notes' section. (Pass/Fail).

--------------------------------------------------------------------------------

## Manual Quality Checklist

If performing the review manually, look for these specific "smells" in the content:

- The "Goldplating" Smell: Are there stories included that add unnecessary complexity or features not required for the immediate goal? (e.g., optimizing a search algorithm before checking if users even need search).
- The "System-Centric" Smell: Do cards say "System validates login"? They should say "User logs in." Stories must be told from the user's perspective to ensure empathy and proper flow.
- The "Vague Outcome" Smell: Are there stories like "User manages account"? This is not a closed story. It should be split into specific actions like "User changes password" or "User updates address" so the user feels a specific sense of accomplishment.
