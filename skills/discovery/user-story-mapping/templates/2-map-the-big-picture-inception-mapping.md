# Map the Big Picture - Inception Data Sources

This document provides a reference mapping to help fill out the `2-map-the-big-picture.md` template using the data generated during the Lean Inception workshop.

## ⚠️ Precedence Rules
**Step 6 (User Journey) defines the Structure, but Step 8 (MVP Canvas) defines the Release Status.**
The Backbone should capture the *full* user journey (breadth), even parts that are not in the MVP. However, you must use Step 8 data to correctly categorize or annotate steps that are "Future / Wave 2+".

| Template Section | Inception Source Document | Sections to Reference |
| :--- | :--- | :--- |
| **1. The Narrative Context** | `docs/inception/3-personas/`<br>`docs/inception/6-user-journeys/` | **Primary Persona** (Names & Roles)<br>**Journey Goals** (The specific goal defined for each journey) |
| **2. The Backbone (Activities)** | `docs/inception/6-user-journeys/` | **Journey Titles** (These correspond to the High-Level Activities) |
| **3. The Backbone (Tasks)** | `docs/inception/6-user-journeys/`<br>`docs/inception/5-brainstorming.md`<br>`docs/inception/8-mvp-canvas-definition.md` (Check Scope) | **User Action** column in Journey tables<br>**Feature Descriptions** (Context)<br>**Explicitly Out of Scope** (Cross-reference to verify if a task is MVP or Future) |
| **4. User Role** | `docs/inception/6-user-journeys/`<br>`docs/inception/3-personas/` | **Persona** field defined in each Journey block |
| **5. Multi-User/System Intersections** | `docs/inception/6-user-journeys/`<br>`docs/inception/5-brainstorming.md` | **System Feature / Response** column<br>Transitions between different **Journeys** or **Personas** |
