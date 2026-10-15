# Explore (Filling the Body)

Objective: Break down the high-level tasks from the Backbone into specific, buildable user stories. Explore variations, alternative paths, and "sad paths" (when things go wrong) to ensure a complete understanding of the solution space.

## 1. The "What-About" Brainstorming

Before finalizing stories, play the "What-About" game for your major activities. Ask these questions to generate details.

• Variations: What about different types of users? (e.g., Power user vs. Novice)
• Exceptions: What about when things go wrong? (e.g., System is down, credit card fails)
• Alternatives: What are the other ways to achieve this goal? (e.g., Social login vs. Email login)
• Pains & Joys: What frustrates the user here? What would delight them?

## 2. The Body of the Map

Map the details vertically under each Backbone Task. Ideally, arrange them with the "Happy Path" (standard flow) at the top, and variations/exceptions below.

| Backbone Task (From Step 2) | Wave (MVP/2/3) | User Stories / Sub-Tasks (The specifics) | Notes / Dependencies / Variations |
| :--- | :---: | :--- | :--- |
| [e.g., Log In] | MVP | 1. Enter email/password<br>2. Click "Login"<br>3. Reset Password | **Dep:** Requires Auth API<br>**Var:** what if they forgot password? |
| [e.g., Search Item] | 2 | 1. Enter keyword<br>2. Filter by price<br>3. Sort by rating | **Var:** Zero results handling? |
| [e.g., Checkout] | MVP | 1. Select shipping<br>2. Enter payment<br>3. Confirm order | **Sad:** Card declines |

## 3. Story Definition Template

For high-priority items identified above, flesh out the "Card, Conversation, Confirmation" details.

### Story Card [ID]

**Title:** [Short verb phrase, e.g., "Reset Password"]

**The Narrative (Who/What/Why):**
As a [specific user persona], I want to [specific action], So that [benefit/value].

### Acceptance Criteria (Confirmation)

- [ ] Verify that [Condition A] is met.
- [ ] Verify that [Condition B] handles the error state.
- [ ] Constraint: [e.g., Must happen under 2 seconds]

### Design/Technical Notes

- **Dependencies:** [e.g., Requires Email Service API]
- **UI Sketch Reference:** [Link or description of visual]

### Splitting & Refining (The "Rock Breaking")

If a story is too big (an "Epic" or "Boulder"), break it down.

- Original Big Story: [e.g., "User manages profile"]
- Split into:
    1. [e.g., User changes avatar]
    2. [e.g., User updates address]
    3. [e.g., User changes notification settings]

### Risk Assessment (The "Opps" Factor)

Identify any high-risk assumptions or technical unknowns discovered during exploration.

- Risk 1: [e.g., We assume the API allows real-time filtering]
  - Mitigation: [e.g., Create a "Spike" (research task) to validate API]
- Risk 2: [e.g., Users might not understand the icon]
  - Mitigation: [e.g., Perform a quick usability test]

--------------------------------------------------------------------------------

🔍 Quality Checklist for Step 3

- [ ] Vertical Depth: Did we go "deep" enough to understand the complexity?
- [ ] Sad Paths: Did we account for errors and what happens when things fail?
- [ ] User Focus: Are the stories written from the user's perspective, not the system's?
- [ ] Conversation Trigger: Do the cards serve as a promise for a future conversation, rather than a full specification?
