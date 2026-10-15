# [Short Title of Solved Problem and Solution]

* **Status:** [Proposed | Accepted | Rejected | Deprecated | Superseded]
* **Date:** [YYYY-MM-DD]
* **Decision Makers:** [Name 1, Name 2]
* **Supersedes:** [ADR-0000](link) | N/A
* **Amended By:** [ADR-0000](link) | N/A

## Context and Problem Statement

[Describe the context and problem facing the team.]

**Decision Drivers:**
*   [Driver 1, e.g., Force 1]
*   [Driver 2, e.g., Force 2]

## Considered Options

*   [Option 1]
*   [Option 2]
*   [Option 3]

## Decision Outcome

**Chosen Option:** "[Option 1]"

**Justification:**
[Why this option was chosen. e.g., It is the only option that meets the k8s requirement.]

### Consequences

*   **Positive:** [e.g., Improved modularity]
*   **Negative:** [e.g., Increased deployment complexity]
*   **Risks:** [e.g., Vendor lock-in]

### 🤖 AI & Agentic Ergonomics (AX)

* **LLM Corpus Alignment:** [High (>80%) | Medium (30-80%) | Atypical/Exotic (<30%)]

| Expected Agent Bias | Automated Guardrail |
| --- | --- |
| [e.g., Agents write CRUD logic in route handlers] | [e.g., Controller-factory convention + ts-archunit rules over `interfaces/`] |
| [e.g., Agents use primitive types instead of Value Objects] | [e.g., ts-archunit VO rules via `check:arch`] |
| [Bias with no automated countermeasure] | — (accepted manual-review risk — justify or close the gap) |

* **Supervision & Guardrail Tax:** [Low | Medium | High — human review and automated verification overhead]

## Pros and Cons of the Options

### [Option 1]

*   Good, because [argument a]
*   Good, because [argument b]
*   Bad, because [argument c]

### [Option 2]

*   Good, because [argument a]
*   Bad, because [argument b]

## Links

*   [Link type] [Link to ADR]
*   [Jira Ticket]
