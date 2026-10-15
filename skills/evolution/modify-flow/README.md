# Modify Flow Skill - Summary

## 📦 Skill Created

**Location:** `skills/modify-flow/SKILL.md`

**Purpose:** Propose, plan, implement, and document a change to a flow/entity/business rule that is
**already documented** — as opposed to a "create flow/entity documentation"-style skill, which documents
something for the first time. Language- and framework-agnostic: it discovers each target repo's own
conventions rather than assuming a stack.

---

## 🎯 What This Skill Does

When you ask to modify existing behaviour (disable a feature, change a formula, alter a rule), this skill
will:

1. **Discover this repo's own conventions first** — where its flow/entity/BR docs live, what language and
   source layout it uses, its real test/build commands, whether it has a feature-flag system, and whether
   it already has its own modification-proposal precedent worth reusing instead.
2. **Ground the change in reality** — read the affected flow/entity/BR docs, then verify against the real
   source code (docs can be stale).
3. **Write a proposal** (saved next to this repo's existing pre-implementation docs, if such a place
   exists) with:
   - Product Rationale (As a/I want to/So that, Personas Affected, Business Value, Known Gaps) — the one
     section kept prose/bullet-shaped, matching this repo's own persona/journey docs if it has them
   - Current Behaviour vs. Desired Behaviour — tables citing real functions/classes/methods
   - Scope of Change — every real file touched, plus open decisions
   - Impact on Existing Documentation — which docs get updated, and how, once shipped
   - Open Questions — decisions the user must resolve before implementation
4. **Write an implementation plan** with phases derived from the proposal's Scope of Change table,
   following whatever layering and test-authoring convention this specific repo actually uses.
5. **Guide implementation** phase by phase, validated with this repo's own real commands.
6. **Update the original docs in place** post-implementation, using whichever mechanism this repo already
   uses to author that kind of doc — never creating parallel new doc files.

---

## 🚀 How to Use This Skill

### Natural Language Triggers
- "I want to disable/change [existing behaviour]"
- "Create a modification proposal for [flow/entity/rule]"
- "How do we document this change before implementing it"
- "Modify [flow] to no longer..."

### What Happens
1. Skill discovers this repo's doc conventions, source layout, and real commands
2. Reads the affected flow/entity/BR docs and the real source code behind them
3. Generates `proposal.md` — product-framed rationale + real-code current/desired behaviour + scope
4. Once open questions are resolved, generates `implementation-plan.md`
5. Guides phased implementation against the plan
6. Updates the original living docs in place once the change ships

---

## 📁 Files Created

```
skills/modify-flow/
├── SKILL.md                        # Main skill instructions
├── README.md                       # This summary
├── templates/
│   ├── proposal.md                 # Modification proposal template
│   └── implementation-plan.md      # Phased implementation plan template
└── evals/
    └── evals.json                  # Test cases for evaluation
```

---

## ✅ Quality Checklist

The skill ensures every proposal includes:
- [ ] This repo's own conventions discovered first — no assumed stack, folder names, or sibling skills
- [ ] Product Rationale kept as bullets (As a/I want to/So that, Known Gaps); Personas Affected and
      Business Value as tables
- [ ] Current/Desired Behaviour citing real file paths and function/method names, verified against source
      code
- [ ] Scope of Change listing every real file touched, including tests
- [ ] Open Questions left unresolved for the user, not decided unilaterally
- [ ] Impact on Existing Documentation naming the exact docs to update in place (no new parallel docs)

And every implementation plan includes:
- [ ] Phases derived from the proposal's Scope of Change table, ordered inside-out per this repo's own
      real layering
- [ ] Test-authoring tasks per phase, matching this repo's own convention (test-first if it does TDD)
- [ ] A Documentation Update section mapping each doc to how this repo actually updates that kind of doc

---

**Ready to use the skill.**