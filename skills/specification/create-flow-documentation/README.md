# Create Flow Documentation Skill - Summary

## 📦 Skill Created

**Location:** `skills/create-flow-documentation/SKILL.md`

**Purpose:** Generate comprehensive flow documentation from user journey specifications

---

## 🎯 What This Skill Does

When you ask to create a flow from a journey, this skill will:

1. **Read the journey** from `docs/inception/6-user-journey-mapping.md` or other journey sources
2. **Extract requirements**: persona, goal, steps, impacted entities, bounded context
3. **Generate complete flow documentation** with:
   - 3 Mermaid diagrams (sequence, flowchart, state)
   - Step-by-step walkthrough table
   - Acceptance criteria (Gherkin format)
   - Edge cases (business, technical, validation)
   - Technical notes (API, Zod, DB constraints, RLS)
   - Business rules and invariants
   - Domain events documentation

4. **Save to correct location**: `docs/product/bounded-contexts/[context]/flows/journey-[XX]-[name].md`

---

## 📋 Test Cases Created

**Location:** `skills/create-flow-documentation/evals/evals.json`

### Test 1: Journey 2 - Submitting a Talk
- **Scenario**: Andrea submits talk proposal with co-speaker
- **Tests**: Happy path, validation errors, co-speaker invite failures, file upload issues
- **Expected**: Complete flow spec with all diagrams and edge cases

### Test 2: Journey 3 - Selection & Program Creation  
- **Scenario**: Fernando reviews, scores, and assigns schedule slots
- **Tests**: Review workflow, validation, concurrent conflicts, schedule conflicts
- **Expected**: Multi-step workflow with decision points and state transitions

### Test 3: Journey 4 - Acceptance & Logistics
- **Scenario**: Publish results and speaker confirms attendance
- **Tests**: Email delivery, authentication, travel info availability
- **Expected**: Cross-context workflow with domain events

---

## 🚀 How to Use This Skill

### Natural Language Triggers
- "Create flow for Journey 2"
- "Generate flow specification for submitting proposals"
- "Turn the user journey into a flow document"
- "Create flow documentation for the review process"

### What Happens
1. Skill reads the journey specification
2. Generates complete flow document with all required components
3. Saves to appropriate bounded context directory
4. Updates flow catalog (optional)

---

## 📊 Next Steps

### Option 1: Test the Skill (Recommended)
Run the 3 test cases to verify the skill produces quality outputs:
- Test with Journey 2 (Submission)
- Test with Journey 3 (Review)
- Test with Journey 4 (Acceptance)

### Option 2: Use Immediately
Start using the skill for new flow creation tasks

### Option 3: Customize
Modify the skill to add project-specific requirements or adjust the template

---

## 📁 Files Created

```
skills/create-flow-documentation/
├── SKILL.md              # Main skill instructions (11.8 KB)
└── evals/
    └── evals.json        # Test cases for evaluation
```

---

## ✅ Quality Checklist

The skill ensures all flow documents include:
- [ ] 3 Mermaid diagrams with proper error paths
- [ ] Sequence diagram with colored rectangles (happy + 3+ error paths)
- [ ] Walkthrough steps aligned with sequence diagram
- [ ] Gherkin acceptance criteria
- [ ] Edge cases (business, technical, validation)
- [ ] Technical notes (API, Zod, DB, RLS)
- [ ] Business rules and invariants extracted
- [ ] Domain events documented
- [ ] ADR compliance checklist

---

**Ready to test or use the skill!**