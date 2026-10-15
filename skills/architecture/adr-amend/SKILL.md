---
name: adr-amend
description: >-
  Amend, refine, or record an architectural change to an existing ADR in docs/adr/.
  TRIGGER THIS SKILL when user mentions: amend adr, modify adr, change adr,
  update adr, create amendment, propose adr change, adr amendment,
  technical analysis for adr, impact analysis adr.
disable-model-invocation: true
---

# Amend ADR Skill

You are a Principal Software Architect. Your job is to draft, format, and catalog a non-destructive **Amendment** or **Analysis** for an existing Architecture Decision Record (ADR).

> ⚠️ **Golden Rule**: **Never silently edit or overwrite an accepted ADR's historical text.** Accepted ADRs represent the state of knowledge at the time of decision. Any modification, scope refinement, or evolution must be captured as an **Amendment** (`-01-amendment-*.md`) or **Technical Analysis** (`-02-analysis-*.md`).

Use the template located at `templates/TEMPLATE-AMENDMENT.md` (or `templates/TEMPLATE-ANALYSIS.md` for technical spikes).

---

## 📋 Step-by-Step Workflow

### 1. Identify Target ADR & Sequence
1. Locate the target ADR in `docs/adr/` (e.g., `docs/adr/016-dependency-injection-strategy-for-nextjs.md`).
2. Determine the file type and sequence number:
   - **Amendment**: `docs/adr/0XX-01-{topic}-amendment-{type}.md` (e.g., `016-01-controller-factory-di-amendment.md`).
   - **Technical Analysis**: `docs/adr/0XX-02-{topic}-analysis-{subtype}.md` (e.g., `002-02-use-supabase-analysis-vendor-lock-in.md`).
   - **Impact Analysis**: `docs/adr/0XX-04-{topic}-impact-analysis.md` (when a change has ripple effects on other ADRs).

### 2. Draft the Amendment
Complete the sections in `templates/TEMPLATE-AMENDMENT.md`:
- **Status**: `Proposed` or `Approved`.
- **Amends**: Relative link to base ADR.
- **Context & Drivers**: What new findings, requirements, or real-world friction necessitate this amendment?
- **Scope of Amendment**: Explicitly document:
  - What is modified.
  - What remains unchanged from the original decision.
- **Amended Decision**: Exact new architectural rule or pattern.
- **Consequences**: Delta impact on development, dependencies, and testing.
- **AI & Agentic Ergonomics (AX)**: Updated LLM Corpus Alignment, Guardrail Tax, and drift risks.

### 3. Establish Mandatory Two-Way Links
Both documents must reference each other to preserve navigation:
1. In the **Amendment file** header:
   ```markdown
   **Amends:** [ADR-0XX: Original Title](0XX-original-decision.md)
   ```
2. In the **Base ADR file** header:
   ```markdown
   **Amended By:** [ADR-0XX-01: Amendment Title](0XX-01-topic-amendment-type.md)
   ```

### 4. Update Catalog & Index
1. Update `docs/adr/README.md`:
   - Add a row in the Quick Reference table beneath the base ADR.
   - Note the status (e.g., `✅ Approved` for the amendment; if the base ADR is superseded, update the base status to `⚠️ Superseded`).
   - Update category listings and increment the total count in statistics.
