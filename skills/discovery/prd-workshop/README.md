# PRD Workshop & Review Agent Skill

A platform-agnostic AI agent skill for drafting and validating formal **Product Requirements Documents (PRDs)**.

---

## Capabilities

1. **PRD Generation:** Generates comprehensive, production-ready PRDs following the standardized template (`templates/template-prd.md`).
2. **PRD Validation & Critique:** Performs critical quality reviews (`references/prd-validator.md`) to catch ambiguous language, missing edge cases, architectural risks, and deliver an actionable readiness score.

---

## Quick Start Examples

- **Drafting a PRD:**
  > "Create a formal PRD for the Call for Papers submission workflow."
- **Reviewing a PRD:**
  > "Review and critique this PRD draft for any technical risks or unquantified requirements."

---

## Directory Structure

```text
.agents/skills/sessioflow-sdlc/prd-workshop/
├── SKILL.md                                          # Skill definition and instructions
├── README.md                                         # This guide
├── templates/
│   └── template-prd.md                               # Standard PRD template
└── references/
    └── prd-validator.md                              # Comprehensive review criteria and output format
```
