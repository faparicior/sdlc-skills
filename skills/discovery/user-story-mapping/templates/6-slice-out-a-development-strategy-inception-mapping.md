# Slice Out a Development Strategy - Inception Data Sources

This document provides a reference mapping to help fill out the `6-slice-out-a-development-strategy.md` template using the data generated during the Lean Inception workshop.

## ⚠️ Strategy Note

Unlike the Release Strategy (Step 4) which uses Inception "Waves" to define *what* drives value, this step uses Inception "Technical & Risk" data to define *how* to build it safely.

**Key Heuristic:** High Technical Risk (Low "Tech Comfort") + High Business Value = **Opening Game**.

| Template Section | Inception Source Document | Sections to Reference |
| :--- | :--- | :--- |
| **1. Risk Assessment** | `docs/user-story-mapping/5-slice-out-a-learning-strategy.md` (PRIMARY)<br>`docs/inception/8-mvp-canvas-definition.md` | **Unresolved Risks:** Key risks that failed the "Learning Slice" tests must be prioritized in the Opening Game.<br>**Risks & Mitigation** (Explicit risks listed) |
| **2. The Chess Strategy**<br>*(Opening / Mid / End)* | `docs/inception/7-features-and-sequencing.md`<br>`docs/inception/6-user-journeys/` | **Tech Comfort Column:** Items marked "T" (Red/Low Comfort) usually go in **Opening Game** to fail fast.<br>**MVP Wave:** This entire development strategy applies *only* to the Wave 1 feature set.<br>**Journeys:** The **Walking Skeleton** must complete a full path through the Journey. |
| **3. The Learning Plan**<br>*(Experiments/Spikes)* | `docs/inception/8-mvp-canvas-definition.md`<br>`docs/inception/7-features-and-sequencing.md` | **Hypothesis:** What are we trying to prove?<br>**Effort/Comfort:** Spikes are needed for items with "???" or low confidence estimates. |
| **4. Team Capacity Check** | `docs/inception/8-mvp-canvas-definition.md` | **Cost & Schedule:** Reference the estimated "Sprints" and "Developer Count" constraints defined here. |
