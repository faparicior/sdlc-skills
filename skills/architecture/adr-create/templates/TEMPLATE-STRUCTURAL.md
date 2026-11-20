# [Short Title of the Structural Decision]

* **Status:** [Proposed | Accepted | Rejected | Deprecated | Superseded]
* **Date:** [YYYY-MM-DD]
* **Decision Makers:** [Name 1, Name 2]
* **Supersedes:** [ADR-0000](link) | N/A
* **Amended By:** [ADR-0000](link) | N/A

## Summary

| | |
| :--- | :--- |
| **Decision** | [One sentence: the structure, technology or convention adopted.] |
| **Why** | [The main reason it wins over the alternatives.] |
| **Scope** | [Layers, modules or repositories it governs.] |
| **Enforced by** | [Architecture tests, lint rules or reviews that keep it true.] |
| **Main trade-off** | [The biggest cost accepted.] |

## Context and Problem Statement

[Describe the context and the structural problem facing the team.]

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

### Principles and Scope

| Aspect | Definition |
| :--- | :--- |
| Applies to | [e.g., Every module under `src/`] |
| Does not apply to | [e.g., Generated code, scripts] |
| Principle | [e.g., The domain layer depends on nothing outside itself] |
| Allowed exceptions | [e.g., None, or the exception and who may approve it] |

### Enforceable Rules

These rules are the source of the architecture tests. Every rule needs a verifier. A rule with no automated verifier must say `— manual review` and justify why.

| # | Rule | Applies to | Verified by | Failure signal |
| :---: | :--- | :--- | :--- | :--- |
| R1 | [e.g., Domain classes do not import infrastructure packages] | [e.g., `domain/**`] | [e.g., ArchUnit `HexagonalArchitectureShould`] | [e.g., Build fails] |
| R2 | [e.g., Controllers return DTOs, never domain entities] | [e.g., `infrastructure/controller/**`] | [e.g., ts-archunit rule via `check:arch`] | [e.g., CI check fails] |
| R3 | [Rule with no verifier] | [Scope] | — manual review ([why it cannot be automated]) | [e.g., Pull request comment] |

### Consequences

*   **Positive:** [e.g., Improved modularity]
*   **Negative:** [e.g., Increased deployment complexity]
*   **Risks:** [See the table below]

| Risk | Impact | Mitigation |
| :--- | :--- | :--- |
| [e.g., Vendor lock-in] | [What happens if it materialises] | [Concrete action or accepted risk] |

### 🤖 AI & Agentic Ergonomics (AX)

* **LLM Corpus Alignment:** [High (>80%) | Medium (30-80%) | Atypical/Exotic (<30%)]

| Expected Agent Bias | Automated Guardrail |
| --- | --- |
| [e.g., Agents write CRUD logic in route handlers] | [e.g., Controller-factory convention + ts-archunit rules over `interfaces/`] |
| [e.g., Agents use primitive types instead of Value Objects] | [e.g., ts-archunit VO rules via `check:arch`] |
| [Bias with no automated countermeasure] | — (accepted manual-review risk — justify or close the gap) |

* **Supervision & Guardrail Tax:** [Low | Medium | High — human review and automated verification overhead]

## Pros and Cons of the Options

### Comparison at a Glance

| Criterion | [Option 1] | [Option 2] | [Option 3] |
| :--- | :--- | :--- | :--- |
| [Criterion tied to a driver] | [Value] | [Value] | [Value] |
| [Criterion tied to a driver] | [Value] | [Value] | [Value] |
| Effort to adopt | [Low, Medium or High] | [Value] | [Value] |

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
