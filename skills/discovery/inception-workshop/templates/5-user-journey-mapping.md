# Step 6: User Journey Mapping

## Goal
Map the brainstormed features to specific stages of the user journey, visualizing how features support the user's path from awareness to achieving their goal. This helps identify feature coverage, gaps, and dependencies.

## Instructions
1. Review the personas defined in Step 3
2. Review the features brainstormed in Step 5
3. Map each feature to one or more stages of the user journey
4. Identify which features are critical at each stage
5. Note any gaps or missing features needed to complete the journey

---

**Persona:** [Name from Step 3]  
**Main Goal:** [What is the user trying to achieve?]

> **Context note:** [Optional — any key architectural or product constraint that shapes how this journey works, e.g. event-driven vs API-driven, async vs real-time]

---

## Overview Visualization

```
[External System / Actor A]    [Your System]                      [Persona / Actor B]
        │                               │                                  │
        │─[Event / Action] ───────────→ │ Stage 1: [Stage Name]            │
        │                               │  · [Use case or process]         │
        │                               │  · [Domain event emitted]        │
        │                               │                                  │
        │─[Event / Action] ───────────→ │ Stage 2: [Stage Name]            │
        │                               │  · [Use case or process]         │
        │                               │                                  │
        │                          [cron/scheduler]                        │
        │                               │ Stage 3: [Stage Name]            │
        │                               │  · [Scheduled process]           │
        │                               │                                  │
[Actor C]                               │                                  │
        │─[Event / Action] ───────────→ │ Stage 4: [Stage Name]            │
        │                               │  · [Use case or process] ───────→│ [outcome]
        │                               │                                  │
        │─[Cancellation / End event] →  │ Stage 5: [Stage Name]            │
        │                               │  · [Cleanup process]             │
```

---

## Lifecycle Overview

| Stage | Trigger | Persona's Action | System Response |
| :--- | :--- | :--- | :--- |
| **1. [Stage Name]** | [What triggers this stage] | [What the persona does] | [What the system does] |
| **2. [Stage Name]** | [What triggers this stage] | [What the persona does] | [What the system does] |
| **3. [Stage Name]** | [What triggers this stage] | _(automatic)_ | [What the system does] |
| **4. [Stage Name]** | [What triggers this stage] | _(passive)_ | [What the system does] |
| **5. [Stage Name]** | [What triggers this stage] | [What the persona does] | [What the system does] |

---

## Stage 1: [Stage Name]

**Trigger:** [What initiates this stage — user action, event, external signal]

| Step | Event / Action | Use Case | Output |
| :--- | :--- | :--- | :--- |
| 1 | [Incoming event or action] | [Use case called] | [What is produced] |
| 2 | — | [Next use case] | [What is produced] |
| 3 | — | — | [Domain event or side effect] |

**Pain points addressed:** [Which persona pain points / needs this resolves]

**Gap:** [Missing feature or known limitation at this stage]

---

## Stage 2: [Stage Name]

**Trigger:** [What initiates this stage]

| Step | Event / Action | Use Case | Output |
| :--- | :--- | :--- | :--- |
| 1 | [Incoming event or action] | [Use case called] | [What is produced] |
| 2 | [Incoming event or action] | [Use case called] | [What is produced] |

**Pain points addressed:** [Which persona pain points / needs this resolves]

**Gap:** [Missing feature or known limitation at this stage]

---

## Stage 3: [Stage Name]

**Trigger:** [What initiates this stage — e.g. cron, manual action, external event]

| Step | What Happens |
| :--- | :--- |
| 1 | [First thing the system does] |
| 2 | [Second thing the system does] |
| 3 | [Outcome / side effect] |

**Pain points addressed:** [Which persona pain points / needs this resolves]

**Gap:** [Missing feature or known limitation at this stage]

---

## Stage 4: [Stage Name]

**Trigger:** [What initiates this stage]

| Step | Actor | Action / Event | Result |
| :--- | :--- | :--- | :--- |
| 1 | [Actor] | [Action or event] | [Result] |
| 2 | System | [Process] | [Result] |
| 3 | [Persona] | [Receives / sees] | [Outcome] |

**Pain points addressed:** [Which persona pain points / needs this resolves]

**Gap:** [Missing feature or known limitation at this stage]

---

## Critical Path

**Minimum Happy Path:**

| # | Step | Stage |
| :--- | :--- | :--- |
| 1 | [First required step] | Stage 1 |
| 2 | [Second required step] | Stage 2 |
| 3 | [Third required step] | Stage 3 |
| 4 | [Final step — value delivered] | Stage 4 |

**Related journeys:**
- [Link to related journey file]
- [Link to related journey file]

---

**Next Step:** In Step 7, we will sequence these features into the MVP Canvas to define the specific releases.
