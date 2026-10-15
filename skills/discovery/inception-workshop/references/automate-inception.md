# Automating Inception Workshop in pi

This guide shows how to automate the Lean Inception workshop using pi's subagent capabilities.

## Quick Start

### Option 1: Interactive Facilitator Mode

Best for: First-time workshops, human-guided sessions

```bash
# Start the interactive facilitator
pi subagent --agent "You are a Lean Inception Facilitator. Guide me through 8 steps. Start with Step 1: Product Vision & Boundaries. Read the template at docs/templates/inception/1-product-vision-and-boundaries.md and ask me to fill it out."
```

**How it works:**
1. Agent presents Step 1 template
2. You provide input
3. Agent validates and provides feedback
4. Moves to next step when ready
5. Continues through all 8 steps

---

### Option 2: Batch Chain Execution

Best for: Quick generation, automated workflows

```bash
# Run the complete inception chain
pi subagent --chain inception-workshop
```

**How it works:**
1. Reads chain definition from `chains/inception-workshop.json`
2. Executes all 8 steps sequentially
3. Each step reads previous outputs
4. Generates all files in `docs/inception/`

**Input required:** Provide initial context as task parameter:
```bash
pi subagent --chain inception-workshop --task "Product: SessioFlow - A Call-for-Papers platform for event organizers and speakers"
```

---

### Option 3: Individual Step Execution

Best for: Manual control, step-by-step review

```bash
# Step 1: Generate vision
pi subagent --agent "Generate product vision for SessioFlow" --output "docs/inception/1-product-vision-and-boundaries.md"

# Step 2: Generate tradeoffs (reads step 1)
pi subagent --agent "Generate tradeoffs based on the vision" --reads "docs/inception/1-product-vision-and-boundaries.md" --output "docs/inception/2-tradeoffs.md"

# Continue for each step...
```

---

## Complete Workflow Example

### Interactive Mode

```
User: /goal run inception workshop for SessioFlow

Agent: Hello! I'm your Lean Inception Facilitator. Let's start with Step 1: Product Vision & Boundaries.

[Shows template structure]

Please provide:
1. Elevator Pitch
2. Is/Is Not boundaries

User: [Provides input...]

Agent: Great! I've validated your vision. Moving to Step 2: Tradeoffs...

[Continues through all 8 steps]
```

### Batch Mode

```bash
# Create a task file with initial context
cat > /tmp/inception-task.md << 'EOF'
Product: SessioFlow
Description: Call-for-Papers platform for event organizers
Target Users: Event organizers, speakers, reviewers
Key Problem: Managing CfP processes is complex and time-consuming
EOF

# Run the chain
pi subagent --chain inception-workshop --task "$(cat /tmp/inception-task.md)"
```

**Output:**
```
docs/inception/
├── 1-product-vision-and-boundaries.md  ✅ Generated
├── 2-tradeoffs.md                      ✅ Generated
├── 3-personas/                         ✅ Generated
├── 4-empathy-map.md                      ✅ Generated
├── 6-brainstorming.md                    ✅ Generated
├── 5-user-journeys/                      ✅ Generated
├── 7-features-and-sequencing.md        ✅ Generated
└── 8-mvp-canvas.md                     ✅ Generated
```

---

## Step-by-Step Manual Execution

If you want more control, execute each step individually:

### Step 1: Product Vision

```bash
pi subagent << 'EOF'
Read the template at docs/templates/inception/1-product-vision-and-boundaries.md
Read the validator at docs/commands/inception/1-product-vision-boundary-validator.md

Generate a complete Product Vision document for: {your_product_context}

Output to: docs/inception/1-product-vision-and-boundaries.md
EOF
```

### Step 2: Tradeoffs

```bash
pi subagent << 'EOF'
Read:
- docs/inception/1-product-vision-and-boundaries.md
- docs/templates/inception/2-tradeoffs.md

Generate tradeoffs analysis based on the vision.

Output to: docs/inception/2-tradeoffs.md
EOF
```

### Step 3-8: Continue pattern...

Each step:
1. Reads previous outputs
2. Reads its template
3. Generates the output file

---

## Validation After Generation

After any mode, validate the outputs:

```bash
# Validate Step 6 (User Journey)
pi subagent << 'EOF'
Read docs/inception/5-user-journeys/
Read docs/commands/inception/5-user-journey-validator.md

Evaluate the journey against the validator criteria and provide:
1. Alignment score (1-10)
2. Structural feedback
3. Unmapped features alert
4. Coach's walkthrough question
EOF
```

---

## Connecting to Flow Documentation

Once inception is complete, use the output to generate flow documentation:

```bash
# From Journey Mapping to Flow Specs
pi subagent << 'EOF'
Read:
- docs/inception/5-user-journey.md (contains journey stages)
- docs/inception/7-features-and-sequencing.md (contains MVP features)
- docs/templates/product/flows.md (flow template)

For each journey stage that maps to MVP features:
1. Create a detailed flow specification
2. Include sequence diagram, flowchart, state diagram
3. Identify business rules and invariants
4. Output to: docs/product/bounded-contexts/{context}/flows/journey-XX-[name].md

Start with Journey 01: Setup Event (from the MVP features)
EOF
```

---

## Recommended Workflow

**For new products:**
1. Use **Interactive Mode** for Steps 1-3 (Vision, Tradeoffs, Personas)
2. Use **Batch Mode** for Steps 4-8 (can be more automated)
3. **Validate** key outputs (Steps 1, 3, 6)
4. **Generate flows** from the journey map

**For existing products:**
1. Use **Batch Mode** with existing context
2. **Review and refine** outputs manually
3. **Validate** against current system behavior
4. **Update flows** based on new insights

---

## Troubleshooting

### Chain fails at a step

```bash
# Check which step failed
pi subagent --status <run-id>

# Retry from failed step
pi subagent --agent "retry-step" --task "Retry step N with corrected context"
```

### Outputs are too generic

```bash
# Provide more specific context
pi subagent --chain inception-workshop --task "
Product: SessioFlow
Specific Problem: Event organizers struggle with manual CfP management
Target User: Conference organizers (5-500 speakers)
Key Differentiator: Automated scoring and scheduling
"
```

### Need human review between steps

Use **Hybrid Mode**:
```bash
# Generate first half
pi subagent --chain inception-workshop-steps-1-4

# Human reviews docs/inception/

# Generate second half
pi subagent --chain inception-workshop-steps-5-8
```

---

## Files Reference

| File | Purpose |
|------|---------|
| `chains/inception-workshop.json` | Chain definition |
| `docs/commands/inception/run-inception-chain.md` | Detailed automation guide |
| `docs/commands/inception/0-inception-workshop.md` | Facilitator agent prompt |
| `docs/templates/inception/*.md` | Step templates |
| `docs/commands/inception/*-validator.md` | Step validators |

---

**Last Updated:** 2026-06-13
