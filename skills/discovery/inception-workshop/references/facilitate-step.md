# Facilitate Inception Step

This command guides you through one step of the Lean Inception workshop:
1. **Copies template** to the output location
2. **Waits for you to fill it**
3. **Validates** your completed document
4. **Proceeds** to next step when ready

## Usage

```bash
pi subagent << 'EOF'
Facilitate Step [N] of the Lean Inception workshop.

Step: [N] - [Step Name]
Template: docs/templates/inception/[template-file].md
Output: docs/inception/[output-file].md
Validator: docs/commands/inception/[validator-file].md

Instructions:
1. Read the template file
2. Create the output file with the template content
3. Tell me to fill it out
4. Wait for me to commit the completed file
5. Read my completed document
6. Validate it using the validator criteria
7. If valid, provide summary and ask if ready for next step
8. If invalid, provide specific feedback on what needs improvement
EOF
```

## Example: Step 1

```bash
pi subagent << 'EOF'
Facilitate Step 1 of the Lean Inception workshop.

Step: 1 - Product Vision & Boundaries
Template: docs/templates/inception/1-product-vision-and-boundaries.md
Output: docs/inception/1-product-vision-and-boundaries.md
Validator: docs/commands/inception/1-product-vision-boundary-validator.md

Follow the facilitation workflow:
1. Read and display the template structure
2. Create the output file with template placeholders
3. Tell me to fill it out and commit
4. Wait for my completion
5. Validate my work
6. Provide feedback or proceed to Step 2
EOF
```

## Facilitation Workflow

### Phase 1: Template Setup

```
Agent reads template → Creates output file → Tells user to fill
```

**Agent actions:**
- Read `docs/templates/inception/[N]-[name].md`
- Write to `docs/inception/[N]-[name].md` with placeholder text
- Display template structure to user
- Tell user: "Please fill this document and commit when ready"

**User actions:**
- Open `docs/inception/[N]-[name].md`
- Fill in all sections with your content
- Commit the file to git

### Phase 2: Validation

```
User signals complete → Agent reads filled doc → Validates against criteria
```

**Agent actions:**
- Read the completed `docs/inception/[N]-[name].md`
- Read validator criteria from `docs/commands/inception/[validator].md`
- Check each validation criterion
- Generate validation report

**Validation Report:**
```
## Step [N] Validation Results

### ✅ Passed Criteria
- [Criterion 1]: Met
- [Criterion 2]: Met

### ⚠️ Needs Improvement
- [Criterion 3]: Partially met - [specific feedback]

### ❌ Failed Criteria
- [Criterion 4]: Not met - [what's missing]

### Overall Score: [X]/10

### Recommendations
- [Specific action items to improve]
```

### Phase 3: Decision

**If Valid (Score ≥ 8/10):**
```
✅ Step [N] Complete!

Your document meets the requirements. Key highlights:
- [Strength 1]
- [Strength 2]

Ready to proceed to Step [N+1]? (yes/no)
```

**If Invalid (Score < 8/10):**
```
⚠️ Step [N] Needs Revision

The following areas need improvement:
- [Issue 1]: [Specific guidance]
- [Issue 2]: [Specific guidance]

Please update the document and let me know when ready for re-validation.
```

## Complete Session Example

```
User: Facilitate Step 1

Agent: 
I'll facilitate Step 1: Product Vision & Boundaries.

**Template Structure:**
```markdown
# Step 1: Product Vision & Boundaries

## Elevator Pitch
- **Problem:** [Describe the problem]
- **Solution:** [Describe your solution]
- **Target User:** [Who is this for?]
- **Benefit:** [Main benefit]
- **Competition:** [Alternative solutions]

## Is / Is Not
| Aspect | Is | Is Not |
|--------|-----|--------|
| Scope | ... | ... |

## Success Metrics
- [Metric 1]
- [Metric 2]
```

**Action:** I've created `docs/inception/1-product-vision-and-boundaries.md`

**Your Turn:** Please fill this document with your product vision and commit it. Let me know when ready for validation.

---

[User fills and commits the file]

User: Ready for validation

Agent:
I'll validate your Step 1 document now...

**Validation Results:**

✅ **Elevator Pitch:** Complete and clear
✅ **Is/Is Not Table:** Well defined boundaries
⚠️ **Success Metrics:** Could be more specific

**Score: 8/10**

**Recommendations:**
- Make metrics quantifiable (e.g., "Acquire 1000 users" vs "Get users")

**Overall: Ready to proceed to Step 2?**

User: Yes

Agent:
Great! Moving to Step 2: Tradeoffs...
```

## Batch Mode (All Steps)

For automated validation across all steps:

```bash
pi subagent << 'EOF'
Facilitate all 8 steps of Lean Inception workshop.

For each step N (1-8):
1. Template: docs/templates/inception/[N]-[name].md
2. Output: docs/inception/[N]-[name].md
3. Validator: docs/commands/inception/[N]-validator.md

Workflow:
- Copy template to output location
- Wait for user confirmation ("Step N complete")
- Validate the completed document
- If valid, proceed to next step
- If invalid, provide feedback and wait for revision

Start with Step 1.
EOF
```

## Validation Automation

The agent should check:

### For Each Step
1. **Completeness:** All template sections filled
2. **Quality:** Content is specific, not generic
3. **Consistency:** Aligns with previous steps
4. **Actionability:** Can be used for downstream decisions

### Step-Specific Checks

**Step 1 (Vision):**
- Elevator pitch has all 5 components
- Is/Is Not table is comprehensive
- Metrics are measurable

**Step 3 (Personas):**
- Primary persona clearly identified
- Pain points and goals defined
- Demographics/behavior described

**Step 6 (Journey):**
- All stages have feature mapping
- Critical path identified
- Gaps documented

**Step 8 (MVP):**
- MVP proposal is a complete "cupcake"
- Metrics align with business goals
- Success criteria defined

---

**Related:**
- [All Inception Commands](./)
- [Templates](../templates/)
- [Validators](./)
