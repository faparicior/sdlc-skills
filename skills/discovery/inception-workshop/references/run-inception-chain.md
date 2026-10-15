# Run Inception Workshop Chain

This document defines how to automate the Lean Inception workshop as a **subagent chain** in pi.

## Chain Structure

The inception workshop is a **sequential pipeline** where each step depends on the previous one's output:

```
Step 1 (Vision) → Step 2 (Tradeoffs) → Step 3 (Personas) → Step 4 (Empathy) 
       ↓
Step 5 (Brainstorm) → Step 6 (Journey) → Step 7 (Sequencing) → Step 8 (MVP)
```

## Automation Options

### Option 1: Interactive Facilitator (Recommended)

**Use case:** Guided workshop with human input at each step

**Command:**
```bash
pi subagent --agent inception-facilitator
```

**Agent behavior:**
1. Present Step 1 template and instructions
2. Wait for user input
3. Validate the output using the validator
4. If sufficient, move to Step 2
5. If insufficient, provide feedback and ask for revision
6. Continue through all 8 steps

**Pros:**
- Human-in-the-loop ensures quality
- Can handle ambiguity and ask clarifying questions
- Good for initial product discovery

**Cons:**
- Slower (requires user interaction at each step)
- Session may timeout for long workshops

---

### Option 2: Batch Chain Execution

**Use case:** Generate all steps automatically from initial input

**Command:**
```bash
pi subagent --chain inception-workshop
```

**Chain configuration:**
```json
{
  "chain": [
    {
      "agent": "inception-step1-vision",
      "task": "Generate product vision and boundaries for {product_context}",
      "output": "docs/inception/1-product-vision-and-boundaries.md"
    },
    {
      "agent": "inception-step2-tradeoffs",
      "task": "Analyze tradeoffs based on {previous}",
      "reads": ["docs/inception/1-product-vision-and-boundaries.md"],
      "output": "docs/inception/2-tradeoffs.md"
    },
    {
      "agent": "inception-step3-personas",
      "task": "Define primary persona based on {previous}",
      "reads": ["docs/inception/1-product-vision-and-boundaries.md"],
      "output": "docs/inception/3-personas/"
    },
    {
      "agent": "inception-step4-empathy",
      "task": "Create empathy map for the persona from {previous}",
      "reads": ["docs/inception/3-personas/"],
      "output": "docs/inception/4-empathy-map.md"
    },
    {
      "agent": "inception-step5-brainstorm",
      "task": "Brainstorm features based on {previous} and empathy map",
      "reads": ["docs/inception/4-empathy-map.md"],
      "output": "docs/inception/6-brainstorming.md"
    },
    {
      "agent": "inception-step6-journey",
      "task": "Map features to user journey stages from {previous}",
      "reads": ["docs/inception/6-brainstorming.md", "docs/inception/3-personas/"],
      "output": "docs/inception/5-user-journeys/"
    },
    {
      "agent": "inception-step7-sequencing",
      "task": "Sequence features into waves (MVP, Wave 2, etc.) from {previous}",
      "reads": ["docs/inception/5-user-journeys/"],
      "output": "docs/inception/7-features-and-sequencing.md"
    },
    {
      "agent": "inception-step8-mvp",
      "task": "Define MVP canvas based on {previous}",
      "reads": ["docs/inception/7-features-and-sequencing.md"],
      "output": "docs/inception/8-mvp-canvas.md"
    }
  ]
}
```

**Pros:**
- Fast - generates all steps in one run
- Consistent output across steps
- No session timeout issues

**Cons:**
- Less flexibility for human input
- May produce generic results without guidance

---

### Option 3: Hybrid (Step-by-Step with Validation)

**Use case:** Automated generation with human review at critical steps

**Critical review points:**
- Step 1 (Vision) - Must be validated before proceeding
- Step 3 (Personas) - Must be validated before proceeding
- Step 6 (Journey) - Must be validated before proceeding

**Command:**
```bash
# Generate steps 1-2
pi subagent --agent inception-steps-1-2

# Human reviews, then continues
pi subagent --agent inception-steps-3-4

# Human reviews, then continues
pi subagent --agent inception-steps-5-8
```

---

## Agent Definitions

### Inception Facilitator Agent

**File:** `agents/inception-facilitator/config.json`

```json
{
  "name": "inception-facilitator",
  "description": "Guides users through the 8-step Lean Inception workshop",
  "systemPrompt": "You are an expert Lean Inception Facilitator. Guide the user through 8 sequential steps...",
  "tools": ["read", "write", "subagent"],
  "maxExecutionTimeMs": 3600000
}
```

### Individual Step Agents

Each step can have its own specialized agent:

**Step 1 Agent:** `inception-step1-vision`
- Reads: `docs/templates/inception/1-product-vision-and-boundaries.md`
- Writes: `docs/inception/1-product-vision-and-boundaries.md`
- Validates against: `docs/commands/inception/1-product-vision-boundary-validator.md`

**Step 6 Agent:** `inception-step6-journey`
- Reads: `docs/templates/inception/5-user-journey-mapping.md`, previous steps
- Writes: `docs/inception/5-user-journeys/`
- Validates against: `docs/commands/inception/5-user-journey-validator.md`

---

## Implementation Example

### Interactive Mode (Facilitator)

```typescript
// This would be the agent's logic
async function facilitateInception() {
  const steps = [
    { id: 1, name: "Product Vision", template: "1-product-vision-and-boundaries.md" },
    { id: 2, name: "Tradeoffs", template: "2-tradeoffs.md" },
    // ... all 8 steps
  ];

  for (const step of steps) {
    // 1. Read template
    const template = await read(`docs/templates/inception/${step.template}`);
    
    // 2. Present to user
    const userInput = await promptUser(template);
    
    // 3. Validate
    const validator = await read(`docs/commands/inception/${step.validator}`);
    const isValid = await validate(userInput, validator);
    
    if (!isValid) {
      await provideFeedback(userInput, validator);
      continue; // Ask for revision
    }
    
    // 4. Save and proceed
    await write(`docs/inception/${step.output}`, userInput);
    console.log(`Step ${step.id} complete. Moving to next step...`);
  }
}
```

### Batch Mode (Chain)

```typescript
// Chain execution with subagent
const chain = {
  chain: [
    {
      agent: "inception-step1-vision",
      task: "Generate product vision for: {initial_context}",
      output: "docs/inception/1-product-vision-and-boundaries.md"
    },
    {
      agent: "inception-step2-tradeoffs",
      task: "Generate tradeoffs analysis based on the vision",
      reads: ["docs/inception/1-product-vision-and-boundaries.md"],
      output: "docs/inception/2-tradeoffs.md"
    }
    // ... continue for all 8 steps
  ]
};

await subagent(chain);
```

---

## Recommendations

1. **Start with Interactive Mode** for first-time users
2. **Use Batch Mode** for repeat workshops or when you have clear context
3. **Hybrid Mode** works well for teams that want automation but need human review at key decisions
4. **Always validate** using the validator files before considering a step complete
5. **Store all outputs** in `docs/inception/` for future reference and traceability

---

**Related Documentation:**
- [Inception Workshop Guide](./0-inception-workshop.md)
- [Step Templates](../templates/)
- [Validators](./)
