# Create Entity Lifecycle Skill

## 📦 What This Skill Does

Generates comprehensive entity lifecycle documentation from domain requirements.

**Triggers when user mentions:**
- create entity, entity lifecycle, entity documentation
- document entity, entity state machine
- create entity spec, entity definition
- domain entity, aggregate lifecycle

---

## 🎯 Output

Creates:
1. **Entity Lifecycle Document** - Complete technical specification with state machine
2. **Business Rules (BR-XXX)** - Extracted from entity requirements
3. **Invariants (INV-XXX)** - Extracted from entity constraints

---

## 📁 File Structure

```
skills/create-entity-lifecycle/
├── SKILL.md                    # Main skill instructions
├── README.md                   # This file
├── evals/
│   └── evals.json             # Test cases
├── templates/
│   ├── entity-lifecycle.md    # Entity document template
│   ├── business-rules.md      # BR template
│   └── invariants.md          # INV template
└── guidelines/
    ├── flow-documentation-structure.md
    └── business-rules-vs-invariants.md
```

---

## 🚀 Usage

### Natural Language Triggers
- "Create entity lifecycle for Event"
- "Document the Submission entity"
- "Generate entity spec for CfpConfig"
- "Create state machine for Review entity"

### What Happens
1. Skill reads entity requirements
2. Uses bundled templates
3. Generates complete entity lifecycle document
4. Extracts business rules and invariants
5. Saves to correct location in bounded context

---

## 📋 Workflow Order

**Recommended:** Create entity lifecycle docs AFTER initial flow reveals the domain model.

```
1. Journey Mapping (Inception Step 6)
2. Flow Documentation (reveals entities)
3. Entity Lifecycle (define entities)
4. More Flows (reference existing entities)
```

---

## 📊 Total Size: ~27 KB

| Category | Files | Size |
|----------|-------|------|
| Instructions | SKILL.md | 5.9 KB |
| Templates | 3 files | 14.2 KB |
| Guidelines | 2 files | 10.1 KB |
| Tests | evals.json | 1.7 KB |
| Documentation | README.md | 1.2 KB |

---

**Ready to create entity lifecycle documentation!**