# Step 5: Features Brainstorming

## Goal
Brainstorm and identify potential features based on the personas and user journeys defined in previous steps. This is a divergent thinking exercise — quantity first, filtering second.

---

## Instructions for AI Agents

**CRITICAL:** These instructions are for the AI agent filling this template. They MUST be removed from the final output document.

### Feature Description Rules
1. **Verb-first descriptions** — Start with an action verb (Collect, Enable, Allow, Display)
2. **No technical implementation** — Describe what the user gets, not how it works internally
   - ❌ Bad: "Create Kafka event pipeline for notifications"
   - ✅ Good: "Automatically send email updates to speakers"
3. **Persona linking** — Link each feature to specific persona pains/needs by name
   - Format: `[Persona Name](path/to/persona.md)'s Pain X, Need Y`

### Assessment Column Guidelines
- **Biz Value / Tech Effort / UX Impact** — Use: **High** (bold), Medium (plain), _Low_ (italic)
- **Confidence** — Use semaphore emojis:
  - 🟢 well-understood
  - 🟡 some uncertainty (unknown scope or dependency)
  - 🔴 high risk (needs design spike before sequencing)
- **Priority** — Use: **Must-have** (bold), Should-have (plain), _Nice-to-have_ (italic)

### Quadrant Chart Rules
- **Effort grid (x-axis):** Very Low=0.08 · Low=0.20 · Medium-Low=0.35 · Medium-High=0.62 · High=0.75 · Very High=0.88
- **Value grid (y-axis):** Same scale
- **Color syntax:** Use `classDef` for chart, shields.io badges for legend
- **Overlaps:** Intentional — do not artificially space features
- **Offset:** ±0.04 only when two features share the exact same slot

### Coach's Question
Include one question that challenges the MVP scope, e.g.:
> "If you could only ship three features to validate the primary hypothesis, which would they be and why?"

---

## ![](https://img.shields.io/badge/_%20_-2ecc71) Core Features
*Essential to the primary value proposition.*

| Feature | Description | Why it matters | Related to | Biz Value | Tech Effort | UX Impact | Confidence | Priority |
| :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :---: |
| **[Feature Name]** | [Verb-first description] | [Why it matters] | [Persona Name's Pain/Need] | High/Medium/Low | High/Medium/Low | High/Medium/Low | 🟢/🟡/🔴 | **Must-have** |

---

## ![](https://img.shields.io/badge/_%20_-3498db) Supporting Features
*Enhance the system but not critical to the core value.*

| Feature | Description | Why it matters | Related to | Biz Value | Tech Effort | UX Impact | Confidence | Priority |
| :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :---: |
| **[Feature Name]** | [Verb-first description] | [Why it matters] | [Persona Name's Pain/Need] | High/Medium/Low | High/Medium/Low | High/Medium/Low | 🟢/🟡/🔴 | Should-have |

---

## ![](https://img.shields.io/badge/_%20_-e67e22) Differentiating Features
*Set the product apart from competitors.*

| Feature | Description | Why it matters | Related to | Biz Value | Tech Effort | UX Impact | Confidence | Priority |
| :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :---: |
| **[Feature Name]** | [Verb-first description] | [Why it matters] | [Persona Name's Pain/Need] | High/Medium/Low | High/Medium/Low | High/Medium/Low | 🟢/🟡/🔴 | Must-have |

---

## ![](https://img.shields.io/badge/_%20_-95a5a6) Nice-to-Have Features
*Could add value but lower priority.*

| Feature | Description | Why it matters | Related to | Biz Value | Tech Effort | UX Impact | Confidence | Priority |
| :--- | :--- | :--- | :--- | :---: | :---: | :---: | :---: | :---: |
| **[Feature Name]** | [Verb-first description] | [Why it matters] | [Persona Name's Pain/Need] | Medium/Low | High/Medium/Low | High/Medium/Low | 🟢/🟡/🔴 | _Nice-to-have_ |

---

## Feature Quadrant — Already Shipped (Core)

```mermaid
quadrantChart
    title Shipped Features — Business Value vs Technical Effort
    x-axis Low Effort --> High Effort
    y-axis Low Value --> High Value
    quadrant-1 Strategic Bets
    quadrant-2 Quick Wins
    quadrant-3 Fill-ins
    quadrant-4 Traps
    classDef core color: #2ecc71
    [Feature Name]:::core: [0.20-0.88, 0.25-0.88]
```

| Color | Category |
| :---: | :--- |
| ![](https://img.shields.io/badge/_%20_-2ecc71) | Core — shipped |

---

## Feature Quadrant — Open Decisions

```mermaid
quadrantChart
    title Open Decisions — Business Value vs Technical Effort
    x-axis Low Effort --> High Effort
    y-axis Low Value --> High Value
    quadrant-1 Strategic Bets
    quadrant-2 Quick Wins
    quadrant-3 Fill-ins
    quadrant-4 Traps
    classDef supporting color: #3498db
    classDef differentiating color: #e67e22
    classDef nicetohave color: #95a5a6
    [Feature Name]:::supporting: [0.08-0.88, 0.25-0.88]
```

| Color | Category |
| :---: | :--- |
| ![](https://img.shields.io/badge/_%20_-3498db) | Supporting |
| ![](https://img.shields.io/badge/_%20_-e67e22) | Differentiating |
| ![](https://img.shields.io/badge/_%20_-95a5a6) | Nice-to-Have |

---

## Notes & Observations

- [Observation 1]
- [Observation 2]

**Coach's question:** [One question that challenges the MVP scope]

---

**Next Step:** Map these features to user journeys and define sequencing in Step 7 — Features & Sequencing.