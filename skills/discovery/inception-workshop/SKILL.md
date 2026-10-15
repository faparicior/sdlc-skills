---
name: inception-workshop
description: >-
  Facilitate Lean Inception workshops through 8 structured steps.
  LOAD THIS SKILL when user mentions: inception workshop, lean inception,
  product vision, validate the product vision, validate vision, tradeoffs board,
  personas, empathy map, brainstorming, user journey mapping, feature sequencing,
  MVP canvas, product discovery, validate MVP, validate tradeoffs, validate personas,
  check inception step, review product vision, or validate inception.
  Executes facilitation, batch generation, tradeoff analysis, and validation modes.
disable-model-invocation: true
---

# Inception Workshop Skill

Facilitate Lean Inception workshops through 8 structured steps: Product Vision -> Tradeoffs -> Personas -> Empathy Map -> Brainstorming -> User Journey -> Features & Sequencing -> MVP Canvas.

**Critical Quality Rules:**
- **Product Name Consistency**: Use the exact product name consistently throughout all documents. Include it in titles, introductions, and key sections. After establishing context, use pronouns or "the system" naturally. Focus on clarity, not forced repetition.
- **Boundary Definitions**: MUST include at least 4 items in EACH of the 4 boundary columns (IS, IS NOT, DOES, DOES NOT) - this is non-negotiable.
- **Tradeoff Golden Rule**: Exactly ONE check (X) per priority column. If you have 7 priorities, you must have exactly 7 X marks total.
- **Template Instruction Filtering**: **STRICT RULE** - When generating output documents from templates, ALL instructional text must be removed. Instructions are for the AI agent only, not for the final document. See "Template Usage Guidelines" below for detailed filtering rules.

## Template Usage Guidelines

**CRITICAL: Template instructions must NEVER appear in output documents.**

Templates serve two purposes:
1. **Structure** - Define the document format (tables, sections, diagrams)
2. **Guidance** - Tell AI agents how to fill the template

**Only the structure should appear in output documents. Guidance must be stripped.**

### What to Remove (All Modes)

| Instruction Type | Examples | Action |
|------------------|----------|--------|
| "Instructions" sections | "Instructions:", "How to use", "Usage:" | **REMOVE ENTIRE SECTION** |
| "Format" guidelines | "Format:", "Column definitions", "Field explanations" | **REMOVE ENTIRE SECTION** |
| Validation checklists | "Verify that...", "Ensure...", "Check..." | **REMOVE** |
| Meta-commentary | "This template contains...", "Fill this field with..." | **REMOVE** |
| Technical syntax notes | "Use shields.io badges like...", "Mermaid syntax: ..." | **REMOVE** |

### What to Keep

| Content Type | Examples | Action |
|-------------|----------|--------|
| Content structure | Table headers, section titles | **KEEP** |
| Placeholders | `[Feature Name]`, `[Persona Name]` | **KEEP** (as-is or filled) |
| Actual data | Filled content, real examples | **KEEP** |
| Diagrams | Mermaid charts, tables | **KEEP** (with actual data) |
| Next steps | "Next Step: ..." | **KEEP** |
| Notes sections | "Notes & Observations" | **KEEP** (for actual notes) |

### Validation Checklist

Before finalizing any output document, verify:
- [ ] No "Instructions" sections remain
- [ ] No "How to use" guidance remains
- [ ] No column/field definition lists remain
- [ ] No validation checklists for the AI remain
- [ ] Document contains only actual content, not meta-instructions

**Failure to follow this rule results in documents that mix instructions with content, making them unusable as actual deliverables.**

---

## Natural Language Activation

This skill can be triggered using conversational phrases instead of command-line flags. The system will automatically detect your intent and activate the appropriate mode.

### Natural Language Command Patterns

| Intent | Natural Language Examples | Mode Activated |
|--------|---------------------------|----------------|
| **Start Workshop** | "Start an inception workshop", "Run a Lean Inception", "Begin product discovery" | `--mode facilitate --step 1` |
| **Specific Step** | "Let's do Step 3 personas", "Work on the empathy map", "Start user journey mapping" | `--mode facilitate --step [N]` |
| **Tradeoff Analysis** | "Generate tradeoffs", "Run the tradeoff debate", "Analyze project trade-offs" | `--mode tradeoff-generator` |
| **Batch Generation** | "Generate all inception steps", "Create the full workshop output", "Auto-generate inception docs" | `--mode batch` |
| **Validation** | "Validate the product vision", "Check if Step 2 is complete", "Review the MVP canvas" | `--mode validate` |
| **Flow Generation** | "Generate flows from the journey", "Create flow specs", "Turn the journey into flows" | `--mode generate-flows` |

### Examples

```bash
# Natural language (system auto-detects mode)
"Start a Lean Inception workshop for SessioFlow"
→ pi skill inception-workshop --mode facilitate --step 1

"Let's work on the tradeoffs using AI debate"
→ pi skill inception-workshop --mode tradeoff-generator

"Generate all 8 inception steps automatically"
→ pi skill inception-workshop --mode batch --context "SessioFlow"

"Validate the user journey mapping"
→ pi skill inception-workshop --mode validate --step 5 --file docs/inception/5-user-journeys/

"Create flow specifications from the journey"
→ pi skill inception-workshop --mode generate-flows --from-step 6
```

### Step Recognition

The skill recognizes these step names in natural language:

| Step | Recognized Phrases |
|------|-------------------|
| 1 | "product vision", "vision & boundaries", "elevator pitch", "define the vision" |
| 2 | "tradeoffs", "trade-off board", "understanding trade-offs", "priorities" |
| 3 | "personas", "user personas", "primary persona", "define users" |
| 4 | "empathy map", "empathy blueprint", "understand the user" |
| 5 | "user journey", "journey mapping", "user flows", "customer journey" |
| 6 | "brainstorming", "feature brainstorm", "generate features", "idea generation" |
| 7 | "features & sequencing", "release planning", "roadmap", "feature sequencing" |
| 8 | "MVP canvas", "MVP definition", "minimum viable product", "MVP scope" |

---

## Command-Line Interface

### Start Interactive Facilitation

**Template -> Fill -> Validate workflow:**

```bash
pi skill inception-workshop --mode facilitate --step [N]
```

**Options:**
- `--mode facilitate` - Interactive template->fill->validate (default)
- `--mode batch` - Generate all steps automatically
- `--mode tradeoff-generator` - Use AI debate to generate tradeoffs
- `--step [N]` - Start from specific step (1-8), default: 1

### Examples

```bash
# Start from Step 1 (default)
pi skill inception-workshop --mode facilitate

# Start from Step 5 (Journey Mapping)
pi skill inception-workshop --mode facilitate --step 5

# Generate all 8 steps automatically
pi skill inception-workshop --mode batch --context "SessioFlow: Call-for-Papers platform"

# Use AI debate to generate tradeoffs (Step 2 only)
pi skill inception-workshop --mode tradeoff-generator

# Validate a completed step
pi skill inception-workshop --mode validate --step 1 --file docs/inception/1-product-vision-and-boundaries.md
```

## Workflow

### Facilitate Mode (Template -> Fill -> Validate)

**CRITICAL RULE: Template Instructions Must NOT Leak to Output**

Templates contain instructional guidelines for AI agents. When generating output documents:

**MUST REMOVE:**
- "Instructions" sections (entire section)
- "Format" guidelines and field definitions
- "How to use" instructions
- Column explanations and usage notes
- Validation checklists meant for the AI
- Meta-commentary about the template itself

**MUST KEEP:**
- Content structure (tables, sections, placeholders)
- Actual data entries (filled content)
- Diagrams and visual elements
- "Next Step" references
- Notes & Observations sections (for actual observations, not instructions)

**Implementation:**
1. Read the template file from `templates/`
2. Create the output file in `docs/inception/`
3. **Strip all instructional text** before writing output
4. Prompt the user to fill the document
5. When ready, validate against the validator criteria
6. Provide feedback and scoring
7. Proceed to next step if score ≥ 8

**Implementation:** Use read/write/edit tools to manage files, provide interactive guidance to the user.

### Tradeoff Generator Mode (AI Debate)

**Special mode for Step 2 only** - The agent simulates stakeholder debate to generate tradeoff analysis:

**Agent Implementation:**
1. Read Step 1 (Product Vision) from `docs/inception/1-product-vision-and-boundaries.md`
2. Simulate 4 stakeholder perspectives (PO, UX Advocate, Tech Lead, Agile Coach)
3. Generate individual priority perspectives based on the vision
4. Synthesize consensus tradeoff board with STRICT 1-7 ranking
5. **VERIFY**: Count X marks - must be exactly 7 (one per column). If not, fix immediately.
6. Validate against validator criteria
7. Output to `docs/inception/2-tradeoffs.md`

**Note:** The agent should generate the debate content internally, presenting each stakeholder viewpoint and then synthesizing consensus.

### Batch Mode

**CRITICAL RULE: Template Instructions Must NOT Leak to Output**

All templates contain instructional guidelines for AI agents. When generating output documents in batch mode:

**MUST REMOVE:**
- "Instructions" sections (entire section)
- "Format" guidelines and field definitions  
- "How to use" instructions
- Column explanations and usage notes
- Validation checklists meant for the AI
- Meta-commentary about the template itself

**MUST KEEP:**
- Content structure (tables, sections, placeholders)
- Actual data entries (filled content)
- Diagrams and visual elements
- "Next Step" references
- Notes & Observations sections (for actual observations, not instructions)

**Agent Implementation:**
1. Parse the context/product description - EXTRACT the exact product name
2. Sequentially generate all 8 steps using templates
3. **Strip all instructional text** before writing each output file
4. **Product Name Guidelines:**
   - Include the product name in titles and document headers
   - Use the product name in introductions and key sections
   - After establishing context, use "the system", "the platform", or pronouns naturally
   - Maintain consistency - don't switch between different names
   - Prioritize natural readability over forced repetition
5. Create output files in `docs/inception/`
6. Validate each step and report scores

```bash
# All 8 steps generated automatically
pi skill inception-workshop --mode batch --context "SessioFlow: Call-for-Papers platform"
```

## Step Mapping

| Step | Name | Template | Output | Validator | Special Mode |
|------|------|----------|--------|-----------|--------------|
| 1 | Product Vision & Boundaries | `templates/1-product-vision-and-boundaries.md` | `docs/inception/1-product-vision-and-boundaries.md` | `references/1-product-vision-boundary-validator.md` | - |
| 2 | Tradeoffs | `templates/2-tradeoffs.md` | `docs/inception/2-tradeoffs.md` | `references/2.2-tradeoff-validator.md` | ✅ **Tradeoff Generator** |
| 3 | Personas | `templates/3-personas.md` | `docs/inception/3-personas/` | `references/3-personas-validator.md` | - |
| 4 | Empathy Map | `templates/4-empathy-map.md` | `docs/inception/4-empathy-map.md` | `references/4-empathy-map-validator.md` | - |
| 5 | User Journey | `templates/5-user-journey-mapping.md` | `docs/inception/5-user-journeys/` | `references/5-user-journey-validator.md` | - |
| 6 | Brainstorming | `templates/6-brainstorming.md` | `docs/inception/6-brainstorming.md` | `references/6-brainstorming-validator.md` | - |
| 7 | Features & Sequencing | `templates/7-features-and-sequencing.md` | `docs/inception/7-features-and-sequencing.md` | `references/7-features-and-sequencing-validator.md` | - |
| 8 | MVP Canvas | `templates/8-mvp-canvas-definition.md` | `docs/inception/8-mvp-canvas.md` | `references/8-mvp-canvas-definition-validator.md` | - |

## Step Ordering by Scenario

The numbered step sequence (1–8) is the **canonical reference** — it keeps file names, cross-links, and tool output stable. Do not renumber steps. However, the **facilitation order** should adapt to whether you are discovering a new product or documenting an existing one.

### Greenfield (discovering a new product from scratch)

Run steps in sequential order — no swaps needed:

| Run order | Step # | Name | Why here |
|:---------:|:------:|------|----------|
| 1 | 1 | Product Vision & Boundaries | Anchors everything — team must agree on what the product is before any other step |
| 2 | 2 | Tradeoffs | Establishes shared priorities before discovery work begins |
| 3 | 3 | Personas | Defines who we are building for |
| 4 | 4 | Empathy Map | Deepens persona understanding before mapping experiences |
| 5 | 5 | User Journey | Map the experience first — friction points drive the feature list |
| 6 | 6 | Brainstorming | Features emerge from journey gaps, not from thin air |
| 7 | 7 | Features & Sequencing | Sequence the features discovered through the journey |
| 8 | 8 | MVP Canvas | Scope the MVP once sequencing is clear |

### Brownfield (documenting or extending a live product)

Run order diverges from step numbers — Brainstorming (Step 6) runs before User Journey (Step 5):

| Run order | Step # | Name | Why here |
|:---------:|:------:|------|----------|
| 1 | 1 | Product Vision & Boundaries | Re-align the team on what the product is today |
| 2 | 3 | Personas | Identify who the product actually serves |
| 3 | **6** | **Brainstorming** | Reverse-engineer what is already built before mapping journeys |
| 4 | **5** | **User Journey** | Map how existing features connect end-to-end; expose gaps |
| 5 | 7 | Features & Sequencing | Order the next increment based on gaps found in the journey |
| 6 | 2 | Tradeoffs | Retrospective alignment — useful once scope is clear, not before |
| 7 | 4 | Empathy Map | Optional; only run if the team is misaligned on a persona |
| 8 | 8 | MVP Canvas | Document the next increment as an MVP proposal |

**Key differences from greenfield:** Tradeoffs and Empathy Map drop in priority because the product already exists. Brainstorming (Step 6) moves before User Journey (Step 5) because you need to know what is already built before you can map how it connects.

### When running incremental additions (e.g. adding a new persona to an existing product)

Steps 5 and 6 are tightly coupled — bounce between them freely. The distinction between the two scenarios above dissolves for small increments. Write the feature row in Step 5 first (it is faster), then let the journey in Step 6 validate and flesh it out.

---

## Tradeoff Generator Mode (Step 2 Special)

### What It Does

The Tradeoff Generator creates a consensus tradeoff board based on the product vision:

**Key Components:**
1. **Individual Perspectives** - Capture different stakeholder viewpoints
2. **Final Consensus Board** - STRICT 1-7 ranking (Golden Rule: one check per column)
3. **Consensus Reasoning** - Explain trade-offs and compromises made

### Process

1. **Analyze Vision** - Read Step 1 output to understand goals, users, and constraints
2. **Create Perspectives** - Define PO, UX, and Tech Lead viewpoints
3. **Build Consensus** - Create strict 1-7 ranking with compromises
4. **VERIFY GOLDEN RULE** - Count X marks: must be EXACTLY 7 (one per priority column)
5. **Validate** - Check against validator criteria
6. **Generate Output** - Create filled tradeoff template

### Output Structure

```markdown
# Step 2: Tradeoffs

## 1. Individual Perspectives

| Role | Initial Priority #1 | Reasoning |
| :--- | :---: | :--- |
| Product Owner | Cost | Vision targets free-tier infrastructure |
| UX Advocate | Usability | Core differentiator vs manual tools |
| Tech Lead | Simplicity | Essential for self-hosting |

## 2. Final Consensus Trade-off Board

| Priority Rank | 1 (Most) | 2 | 3 | 4 | 5 | 6 | 7 (Least) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Usability** | **X** | | | | | | |
| **Cost** | | **X** | | | | | |
| **Simplicity** | | | **X** | | | | |

⚠️ **GOLDEN RULE CHECK**: Count all X marks above. There must be EXACTLY 7 (one per column).

## 3. Consensus Reasoning

The team agreed on Usability as #1 because...

Key trade-offs made:
- Cost > Scalability (MVP focus from vision)
- Simplicity > Flexibility (Non-technical users)
```

### Usage

```bash
# Generate tradeoffs with AI debate simulation
pi skill inception-workshop --mode tradeoff-generator
```

**Requirements:**
- Step 1 (Product Vision) must be completed first
- Reads: `docs/inception/1-product-vision-and-boundaries.md`
- Outputs: `docs/inception/2-tradeoffs.md`

**Note:** This mode uses the agent to simulate stakeholder debate perspectives and create consensus tradeoffs directly.

## Output Structure

```
docs/inception/
├── 1-product-vision-and-boundaries.md    # Step 1 output
├── 2-tradeoffs.md                        # Step 2 output
├── 3-personas/                           # Step 3 output folder
│   ├── README.md                         # Overview & Persona validation checklist
│   ├── 01-[name].md                      # Individual persona file
│   └── 02-[name].md                      # Individual persona file
├── 4-empathy-map.md                      # Step 4 output
├── 5-user-journeys/                      # Step 5 output folder
│   ├── README.md                         # Composite View & Feature Coverage check
│   ├── journey-01-[name].md              # Individual journey file
│   └── journey-02-[name].md              # Individual journey file
├── 6-brainstorming.md                    # Step 6 output
├── 7-features-and-sequencing.md          # Step 7 output
└── 8-mvp-canvas.md                       # Step 8 output
```

## Validation Scoring

Each step is validated against criteria from the validator file:

| Score | Status | Action |
|-------|--------|--------|
| 9-10 | ✅ Excellent | Proceed to next step |
| 8-8.9 | ✅ Good | Proceed to next step |
| 6-7.9 | ⚠️ Needs Work | Provide feedback, user revises |
| < 6 | ❌ Poor | Provide detailed feedback, user revises |

## Integration with Flow Documentation

After completing Step 6 (User Journey), the skill can automatically generate flow specifications:

```bash
pi skill inception-workshop --mode generate-flows --from-step 6
```

This will:
1. Read the completed user journey
2. Extract MVP features from Step 7
3. Generate flow specifications using `docs/templates/product/flows.md`
4. Output to `docs/product/bounded-contexts/{context}/flows/`

## Configuration

### Compatibility

**Requires:**
- Standard Pi toolset (read, write, edit, bash)
- No external dependencies

### Bundled Assets

This skill includes all required templates and validators as bundled assets:

**Templates:** (in `templates/` directory)
- `templates/1-product-vision-and-boundaries.md`
- `templates/2-tradeoffs.md`
- `templates/3-personas.md`
- `templates/4-empathy-map.md`
- `templates/6-brainstorming.md`
- `templates/5-user-journey-mapping.md`
- `templates/7-features-and-sequencing.md`
- `templates/8-mvp-canvas-definition.md`

**Validators:** (in `references/` directory)
- `references/1-product-vision-boundary-validator.md`
- `references/2.2-tradeoff-validator.md`
- `references/3-personas-validator.md`
- `references/4-empathy-map-validator.md`
- `references/6-brainstorming-validator.md`
- `references/5-user-journey-validator.md`
- `references/7-features-and-sequencing-validator.md`
- `references/8-mvp-canvas-definition-validator.md`

**Tradeoff Generator:**
- `references/2.1-tradeoff-generator.md` - AI debate simulation prompt

**Additional References:**
- `references/0-inception-workshop.md` - Complete workshop guide
- `references/automate-inception.md` - Automation patterns
- `references/facilitate-step.md` - Step facilitation details
- `references/run-inception-chain.md` - Chain execution guide

### Output Directory

- `docs/inception/` - Created automatically if not exists

## Examples

### Interactive Facilitation

```
> pi skill inception-workshop --mode facilitate

Skill: Inception Workshop Facilitator

Step 1: Product Vision & Boundaries

I've created the template at:
  docs/inception/1-product-vision-and-boundaries.md

Template Structure:
```markdown
# Step 1: Product Vision & Boundaries

## Elevator Pitch
- **Problem:** [Fill this]
- **Solution:** [Fill this]
...
```

Please fill this document and commit when ready. Let me know when you want validation.

[User fills and commits]

> Ready for validation

Skill: Validating Step 1...

**Validation Results:**
✅ Elevator Pitch: Complete (5/5 components)
✅ Is/Is Not: Clear boundaries (4+ items per column)
⚠️ Metrics: Could be more specific

**Score: 8.5/10**

Step 1 is complete! Ready to proceed to Step 2: Tradeoffs? (yes/no)
```

### Tradeoff Generator (Step 2 Special)

```
> pi skill inception-workshop --mode tradeoff-generator

Skill: Tradeoff Generator (AI Debate Simulation)

Reading: docs/inception/1-product-vision-and-boundaries.md
Template: docs/templates/inception/2-tradeoffs.md
Validator: docs/commands/inception/2.2-tradeoff-validator.md

Simulating stakeholder debate...

🎭 **Product Owner:** "Based on the vision's goal of 'quick MVP launch', I prioritize Time to Market and Cost over Scalability."

🎭 **User Advocate:** "The 'Who' is 'busy event organizers' - they need Simplicity and Usability above all."

🎭 **Tech Lead:** "The 'Is/Is Not' says this is NOT a complex enterprise system, so I can accept lower Flexibility for faster delivery."

🎭 **AgileCoach:** "Remember the Golden Rule - only one check per column. Let's find consensus."

---

Generating consensus trade-off board...

✅ GOLDEN RULE VERIFIED: Exactly 7 X marks (one per column)
✅ Tradeoff analysis complete!

**Generated:** docs/inception/2-tradeoffs.md

**Key Trade-offs Made:**
- Cost > Scalability (MVP focus from vision)
- Simplicity > Flexibility (Non-technical users)
- Time to Market > Perfect Architecture (Quick launch goal)

Ready to proceed to Step 3: Personas? (yes/no)
```

### Batch Generation

```
> pi skill inception-workshop --mode batch --context "SessioFlow: Call-for-Papers platform for event organizers"

Skill: Inception Workshop (Batch Mode)

Generating all 8 steps...

Step 1: Product Vision... ✅
Step 2: Tradeoffs... ✅
Step 3: Personas... ✅
Step 4: Empathy Map... ✅
Step 5: Brainstorming... ✅
Step 6: User Journey... ✅
Step 7: Features & Sequencing... ✅
Step 8: MVP Canvas... ✅

All steps completed!
Files created in docs/inception/

Validation Summary:
- Step 1: 9/10
- Step 2: 8.5/10
- Step 3: 9/10
- Step 4: 8/10
- Step 5: 8.5/10
- Step 6: 9/10
- Step 7: 8.5/10
- Step 8: 9/10

Average Score: 8.7/10
```

### Generate Flows from Journey

```
> pi skill inception-workshop --mode generate-flows --from-step 6

Skill: Generating Flow Specifications

Reading: docs/inception/5-user-journeys/
Reading: docs/inception/7-features-and-sequencing.md

Generating flows for MVP features:
- Journey 01: Setup Event... ✅
- Journey 02: Submit Proposal... ✅
- Journey 03: Review Sessions... ✅
- Journey 04: Acceptance & Logistics... ✅

Files created:
- docs/product/bounded-contexts/event/flows/journey-01-setup-event.md
- docs/product/bounded-contexts/submission/flows/journey-02-submit-proposal.md
- docs/product/bounded-contexts/review/flows/journey-03-review-sessions.md
- docs/product/bounded-contexts/scheduling/flows/journey-04-acceptance-logistics.md

All flows include:
- Sequence diagram (with error paths)
- Flowchart (decision points)
- State diagram (entity lifecycle)
- Step-by-step walkthrough
- Edge cases & validation rules
```

## Related Skills

- **Flow Generator** - Create detailed flow specifications from user stories
- **Business Rule Extractor** - Identify business rules and invariants from requirements
- **DDD Model Builder** - Generate domain model from inception outputs

---

**Version:** 3.5.0  
**Last Updated:** 2026-09-08  
**Changes from v3.4:**
- Swapped Step 5 and Step 6: User Journey is now Step 5, Brainstorming is now Step 6. Templates, validators, and output folders renamed accordingly (`5-user-journey-mapping.md`, `5-user-journeys/`, `6-brainstorming.md`). Greenfield facilitation now runs in sequential step order with no swaps. Brownfield is the scenario that diverges (Step 6 before Step 5).
- Added "Step Ordering by Scenario" section documenting greenfield (sequential), brownfield (Step 6 before Step 5), and incremental additions (bounce freely).
**Changes from v3.3:**
- Step 5: no tech features rule — features must describe user-facing outcomes, not implementation mechanics (Kafka events, crons, webhooks are excluded). Borderline tech features must be reframed as user outcomes before inclusion
**Changes from v3.2:**
- Step 5 template quadrant charts now use `classDef` + `:::className` for per-dot colors and HTML `<span>` swatches in legend tables so colors match the chart exactly
- Color scheme: Core=`#2ecc71`, Supporting=`#3498db`, Differentiating=`#e67e22`, Nice-to-Have=`#95a5a6`
- Quadrant placement rule: fixed 6-point grid (0.08 / 0.20 / 0.35 / 0.62 / 0.75 / 0.88) on both axes; overlaps are intentional; offset by ±0.04 only when two features share the exact same slot
- Legend format: shields.io color-only badge (no text) — `![](https://img.shields.io/badge/_%20_-hexcolor)` — renders a plain color swatch on GitHub and VS Code preview. Use the same hex as the `classDef`
