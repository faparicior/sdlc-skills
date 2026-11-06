---
name: user-story-mapping
description: >-
  Facilitate User Story Mapping workshops through 6 structured steps or synthesize
  story maps from Lean Inception artifacts. LOAD THIS SKILL when user mentions:
  user story mapping, story map, story mapping, map the big picture, explore the body,
  slice release strategy, walking skeleton, INVEST stories, learning strategy,
  development strategy, opening game, or convert inception to user story mapping.
  Executes from-inception, standalone, and validation modes.
disable-model-invocation: true
---

# PROTOCOL: USER-STORY-MAPPING (EXECUTION LEVEL 3)

<state_machine>
CURRENT_STEP                  -> REQUIRED_TOOL                                        -> REQUIRED_OUTPUT                                         -> MANDATORY_HALT
Step 1: Frame the Problem     -> read_file(templates/1-*.md, references/1-*.md)       -> docs/user-story-mapping/1-frame-the-problem.md          -> 🛑 HALT TURN in interactive mode
Step 2: Map the Big Picture   -> read_file(templates/2-*.md, references/2-*.md)       -> docs/user-story-mapping/2-map-the-big-picture.md        -> 🛑 HALT TURN in interactive mode
Step 3: Explore the Body      -> read_file(templates/3-*.md, references/3-*.md)       -> docs/user-story-mapping/3-explore-to-fill-the-body.md   -> 🛑 HALT TURN in interactive mode
Step 4: Release Strategy      -> read_file(templates/4-*.md, references/4-*.md)       -> docs/user-story-mapping/4-slice-out-a-release-strategy.md -> 🛑 HALT TURN in interactive mode
Step 5: Learning Strategy     -> read_file(templates/5-*.md, references/5-*.md)       -> docs/user-story-mapping/5-slice-out-a-learning-strategy.md -> 🛑 HALT TURN in interactive mode
Step 6: Development Strategy  -> read_file(templates/6-*.md, references/6-*.md)       -> docs/user-story-mapping/6-slice-out-a-development-strategy.md -> 🛑 HALT TURN (Present USM output)
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: Execute the 6 structured User Story Mapping steps in strict order (`workflow structure = immutable | step reasoning = flexible`).
2. TEMPLATE LOCK: Before generating any step document in `docs/user-story-mapping/`, you MUST call `read_file` on the corresponding template in `templates/` (and `*-inception-mapping.md` when in `from-inception` mode, plus `references/*-validator.md` when validating). Never reconstruct USM templates from memory.
3. STORY CARD & FAKE-STORY BAN: Every MVP story card must follow the 4-part format (`Title`, `Narrative`, `Acceptance Criteria`, `Design/Technical Notes`). Never create standalone technical stories.
</execution_invariants>

<output_contract>
- TARGET_DIR: `docs/user-story-mapping/` (honouring `.sdlc/config.json` overrides)
- SOURCE_TEMPLATES: `templates/1-frame-the-problem.md` through `templates/6-slice-out-a-development-strategy.md` (plus `*-inception-mapping.md` in Bridge mode; MUST call `read_file` before writing)
- SCHEMA_INVARIANCE: Preserve all structural headings, tables, and 4-part story card schemas verbatim; strip all instructional meta-commentary.
- ESCAPE_HATCH: Never silently omit or invent template sections. If a section genuinely does not apply, preserve the heading and write `"N/A — [1-line rationale]"`, or halt and ask the user before deviating.
</output_contract>

This skill operates in 3 distinct modes:

1. **`from-inception`** (Bridge Mode): Reads existing `docs/inception/` artifacts and maps them into formal User Story Mapping deliverables in `docs/user-story-mapping/`.
2. **`standalone`**: Facilitates the 6 steps interactively or in batch directly from user requirements without requiring Inception docs.
3. **`validate`**: Runs quality audits on existing USM files using evaluation rubrics to check story depth, INVEST criteria, fake stories, and release slicing.

---

## Autonomous Decisions & Sensible Defaults

When requirements leave room for interpretation, proceed autonomously using the following precedence:

| Decision Domain | Default Choice | Rationale / Heuristic |
| --- | --- | --- |
| **Data Source** | `docs/inception/` if present, else prompt | If Inception docs exist, prioritize them as source of truth. |
| **Scope Authority** | `8-mvp-canvas-definition.md` | Step 8 overrides earlier inception steps if scope contradicts. |
| **Story Slicing** | Vertical slices (thin end-to-end) | Every release slice must cross the backbone and deliver value. |
| **Story Format** | Strict 4-part Story Cards | Title, Narrative, Acceptance Criteria, Design/Technical Notes. |
| **Technical Tasks** | Sub-bullets inside Story Cards | Never create standalone "technical stories" (e.g. "Create DB"). |

---

## Template Usage Guidelines

**CRITICAL: Template instructions and guidance must NEVER appear in output documents.**

Templates provide structure for output documents, while mapping guides provide extraction rules for AI agents. When writing files to `docs/user-story-mapping/`:

- **REMOVE** all "Instructions", "How to use", checklists, and meta-commentary.
- **KEEP** all structural headers, tables, diagrams, and actual story cards.
- Ensure every major MVP story card follows the 4-part format:
  1. **Title**
  2. **Narrative** (`As a... I want... So that...`)
  3. **Acceptance Criteria** (testable conditions)
  4. **Design/Technical Notes** (API, DB, UI constraints, dependencies with `**Dep:**`)

---

## Natural Language Activation

This skill is designed to be triggered through plain, natural conversation. The AI agent automatically infers the intended workflow from your prompt:

| Intent | Natural Language Examples | Action Executed |
| --- | --- | --- |
| **Convert Inception** | "Generate user story map from inception", "Convert inception to story map", "Pasa inception a story map" | Reads `docs/inception/` and synthesizes Steps 1–6 into `docs/user-story-mapping/`. |
| **Start Workshop** | "Start a user story mapping workshop", "Let's do story mapping", "Quiero hacer un story map" | Initiates interactive facilitation starting at Step 1 (Frame the Problem). |
| **Specific Step** | "Let's map the big picture", "Explore the body of the story map", "Slice release", "Mapea el backbone" | Jumps directly to facilitate the specified step (1–6). |
| **Batch Generation** | "Generate full user story map for...", "Auto-generate USM documents" | Generates all 6 steps in a single automated pass from prompt context. |
| **Validate Output** | "Validate story map step 3", "Check if stories meet INVEST", "Audit story map" | Executes the corresponding step validator rubric to audit quality and compliance. |

---

## Supported Workflows

1. **Synthesize from Inception (Bridge):**
   - Automatically triggered when `docs/inception/` exists and the user asks to create or derive a story map.
   - Translates high-level vision, journeys, and MVP canvas into structured backbone activities and INVEST story cards.
2. **Standalone Facilitation (From Scratch):**
   - Interactive step-by-step guidance through the 6 steps when starting without prior Inception documents.
   - Can also be run in automated batch mode for rapid drafting.
3. **Quality & INVEST Validation:**
   - Evaluates documents against the 6 evaluation rubrics (`references/*-validator.md`) to catch fake technical stories, check vertical slicing, and verify acceptance criteria.

*(Note: For users running via the `pi` terminal CLI tool, the equivalent flags `--mode from-inception`, `--mode standalone`, and `--mode validate` are also supported).*

---

## The 6 Steps of User Story Mapping

| # | Step Name | Template & Mapping Source | Output Document |
| --- | --- | --- | --- |
| **1** | **Frame the Problem** | `templates/1-frame-the-problem.md`<br>`templates/1-frame-the-problem-inception-mapping.md` | `docs/user-story-mapping/1-frame-the-problem.md` |
| **2** | **Map the Big Picture** | `templates/2-map-the-big-picture.md`<br>`templates/2-map-the-big-picture-inception-mapping.md` | `docs/user-story-mapping/2-map-the-big-picture.md` |
| **3** | **Explore to Fill the Body** | `templates/3-explore-to-fill-the-body.md`<br>`templates/3-explore-to-fill-the-body-inception-mapping.md` | `docs/user-story-mapping/3-explore-to-fill-the-body.md` |
| **4** | **Slice out a Release Strategy** | `templates/4-slice-out-a-release-strategy.md`<br>`templates/4-slice-out-a-release-strategy-inception-mapping.md` | `docs/user-story-mapping/4-slice-out-a-release-strategy.md` |
| **5** | **Slice out a Learning Strategy** | `templates/5-slice-out-a-learning-strategy.md`<br>`templates/5-slice-out-a-learning-strategy-inception-mapping.md` | `docs/user-story-mapping/5-slice-out-a-learning-strategy.md` |
| **6** | **Slice out a Development Strategy** | `templates/6-slice-out-a-development-strategy.md`<br>`templates/6-slice-out-a-development-strategy-inception-mapping.md` | `docs/user-story-mapping/6-slice-out-a-development-strategy.md` |

---

## Step Execution Details

### Step 1: Frame the Problem

- **Objective:** Establish the strategic framing, personas, problems, desired outcomes, and boundaries.
- **`from-inception` Sources:**
  - `docs/inception/1-product-vision-and-boundaries.md` (Elevator pitch, goals, Is/Is Not)
  - `docs/inception/3-personas/` (Primary & secondary personas, pain points)
  - `docs/inception/8-mvp-canvas-definition.md` (MVP proposal, success metrics, out-of-scope boundaries)
- **Validator:** `references/1-frame-the-problem-validator.md`

### Step 2: Map the Big Picture

- **Objective:** Construct the horizontal narrative flow: User Activities (Backbone) and sequential User Steps (Walking Skeleton).
- **`from-inception` Sources:**
  - `docs/inception/5-user-journeys/*.md` (Extract steps across personas)
  - `docs/inception/7-features-and-sequencing.md` (Feature order)
- **Critical Rule:** Inception journeys often skip Setup/Config and Wrap-up/Analysis. You **must** identify and insert these flanking steps so the user narrative is continuous from start to finish.
- **Validator:** `references/2-map-the-big-picture-validator.md`

### Step 3: Explore to Fill the Body

- **Objective:** Move vertically down each backbone step, exploring variations, alternatives, exceptions (sad paths), and detailed story cards.
- **Story Card Standards:**
  - Every high-priority story must have a full card with Title, Narrative, Acceptance Criteria, and Design/Technical Notes.
  - Mark external dependencies clearly with `**Dep:**`.
  - Ban "fake" stories: technical chores (e.g., "Create database schema") must be placed inside the Design/Technical Notes of the corresponding user story card, not as independent user stories.
- **Validator:** `references/3-explore-to-fill-the-body-validator.md`

### Step 4: Slice out a Release Strategy

- **Objective:** Carve horizontal release slices across the story map.
- **Slices:**
  - **Wave 1 (MVP):** Minimal end-to-end path that provides real user value.
  - **Wave 2:** Enhancements, scale, secondary persona paths.
  - **Wave 3+:** Future iterations.
- **`from-inception` Sources:**
  - `docs/inception/7-features-and-sequencing.md`
  - `docs/inception/8-mvp-canvas-definition.md`
- **Validator:** `references/4-slice-out-a-release-strategy-validator.md`

### Step 5: Slice out a Learning Strategy

- **Objective:** Uncover riskiest assumptions and construct fast validation experiments (spikes, prototypes, landing page tests).
- **Evaluation Categories:**
  - Feasibility (technical, infrastructure cost)
  - Usability (workflows, UX)
  - Value (willingness to adopt)
  - Business viability
- **Validator:** `references/5-slice-out-a-learning-strategy-validator.md`

### Step 6: Slice out a Development Strategy

- **Objective:** Organize the delivery game plan for engineering:
  - **Opening Game:** Spikes, infrastructure setup, Walking Skeleton (thin end-to-end tracer bullet).
  - **Mid Game:** Core value loop, feature completion, exception paths.
  - **End Game:** Hardening, performance, operational launch readiness.
- **Team Capacity Check:** Ensure the Opening Game is achievable within the initial sprint.
- **Validator:** `references/6-slice-out-a-development-strategy-validator.md`

---

## Validation Mode (`--mode validate`)

When run in validation mode, the skill audits target documents and scores them across:

1. **Structural Completeness:** All required sections populated without residual template instructions.
2. **INVEST Compliance:** Stories represent user value, are independent, negotiable, and testable.
3. **Depth of Exploration:** Sad paths, error states, and alternative branches present.
4. **Scope Fidelity:** Strict adherence to boundaries defined in Step 8 (MVP Canvas) or Step 1 (Problem Frame).

---

<self_validation_gate>
Before ending your turn, verify every item below with concrete evidence (not just a checkmark). If any item cannot be cited with real evidence from this turn, DO NOT produce your final response — fix the violation first:
- [ ] **Template Read Evidence:** Exact `templates/*.md` (and `*-inception-mapping.md` / `references/*-validator.md`) path(s) passed to `read_file`: `<paths>`
- [ ] **Output & Story Card Evidence:** Exact `docs/user-story-mapping/*.md` path(s) written and number of 4-part Story Cards (`Title`, `Narrative`, `Acceptance Criteria`, `Design/Technical Notes`) generated: `<paths, N cards>`
- [ ] **No Fake Stories Evidence:** Confirm 0 standalone technical stories were created (all technical chores nested under `Design/Technical Notes`): `<0 fake stories>`
</self_validation_gate>
