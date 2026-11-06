---
name: adr-amend
description: >-
  Amend, refine, or record an architectural change to an existing ADR in docs/adr/.
  TRIGGER THIS SKILL when user mentions: amend adr, modify adr, change adr,
  update adr, create amendment, propose adr change, adr amendment,
  technical analysis for adr, impact analysis adr.
disable-model-invocation: true
---

# PROTOCOL: ADR-AMEND (EXECUTION LEVEL 3)

<state_machine>
CURRENT_STEP          -> REQUIRED_TOOL                                -> REQUIRED_OUTPUT                                      -> MANDATORY_HALT
Step 1: Locate Base   -> read_file(docs/adr/0XX-*.md)                 -> Target ADR & amendment sequence number (`0XX-01-*`)  -> Continue to Step 2
Step 2: Write Amend   -> read_file(templates/TEMPLATE-AMENDMENT.md)   -> Non-destructive amendment file in docs/adr/          -> Continue to Step 3
Step 3: Two-Way Link  -> edit_file (base ADR header)                  -> `Amends:` + `Amended By:` bidirectional links        -> Continue to Step 4
Step 4: Sync Catalog  -> edit_file (docs/adr/README.md)               -> Updated Quick Reference, categories, and count       -> 🛑 HALT TURN (Present amendment)
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: Execute all 4 steps in strict order (`workflow structure = immutable | step reasoning = flexible`).
2. NON-DESTRUCTIVE GOLDEN RULE: Never silently edit or overwrite an accepted ADR's historical body. Any modification must be a separate file (`0XX-01-*-amendment-*.md` or `0XX-02-*-analysis-*.md`), with only the `Amended By:` link added to the base ADR's header.
3. TEMPLATE LOCK: Reconstructing template headers from memory is strictly forbidden. You MUST call `read_file` on `templates/TEMPLATE-AMENDMENT.md` (or `templates/TEMPLATE-ANALYSIS.md`) before writing.
4. ESCAPE HATCH: If the situation does not fit the contract, do not silently improvise and do not force-fit: declare the deviation in one line and ask.
</execution_invariants>

<output_contract>
- TARGET_PATH: `docs/adr/0XX-01-{topic}-amendment-{type}.md` (or `0XX-02-{topic}-analysis-{subtype}.md`)
- SOURCE_TEMPLATE: `templates/TEMPLATE-AMENDMENT.md` or `templates/TEMPLATE-ANALYSIS.md` (MUST call `read_file` before writing)
- SCHEMA_INVARIANCE: Preserve every section heading and metadata field from the template verbatim.
- ESCAPE_HATCH: Never silently omit or invent template sections. If a section genuinely does not apply, preserve the heading and write `"N/A — [1-line rationale]"`, or halt and ask the user before deviating.
</output_contract>

---

## 📋 Step-by-Step Workflow

### 1. Identify Target ADR & Sequence
1. Locate the target ADR in `docs/adr/` (e.g., `docs/adr/016-dependency-injection-strategy-for-nextjs.md`).
2. Determine the file type and sequence number:
   - **Amendment**: `docs/adr/0XX-01-{topic}-amendment-{type}.md` (e.g., `016-01-controller-factory-di-amendment.md`).
   - **Technical Analysis**: `docs/adr/0XX-02-{topic}-analysis-{subtype}.md` (e.g., `002-02-use-supabase-analysis-vendor-lock-in.md`).
   - **Impact Analysis**: `docs/adr/0XX-04-{topic}-impact-analysis.md` (when a change has ripple effects on other ADRs).

### 2. Draft the Amendment or Analysis
Complete the exact sections in `templates/TEMPLATE-AMENDMENT.md` (or `templates/TEMPLATE-ANALYSIS.md`):
- **For an Amendment (`templates/TEMPLATE-AMENDMENT.md`)**:
  - **Header Metadata**: `* **Status:** Proposed Amendment` (or `Approved`), `* **Date:**`, `* **Decision Makers:**`, `* **Amends:** [ADR-0XX: Original Title](0XX-original-filename.md)`, `* **Related:**`.
  - **`## Purpose of This Amendment`**: Why this amendment is needed (new information, production experience, or requirement changes).
  - **`## Critical Updates to ADR-0XX`**: Numbered `### Update N: [Topic of Update]` subsections contrasting `* **Original ADR-0XX stated:**` with `* **Correction/New Analysis:**`.
  - **`## Revised Decision Options`**: Compare `### Option 1: Keep Original Decision As-Is` against `### Option X: [Amended/Hybrid Option Title]` (`Description`, `Pros`, `Cons`, `When to use`).
  - **`## Revised Consequences`**: Delta impact per option (`### If We Choose Option 1`, `### If We Choose Option X`).
  - **`## 🤖 AI & Agentic Ergonomics (AX)`**: `* **LLM Corpus Alignment:**`, `| Expected Agent Bias | Automated Guardrail |` table, and `* **Supervision & Guardrail Tax:**`.
  - **`## Revised Decision Outcome`**: `### Updated Recommendation` (`Option Chosen`, `Justification`, `Migration Path`).
  - **`## Updated Links`**: Supersedes/Updates, Related Documents, Reference Implementation.
- **For a Technical Analysis (`templates/TEMPLATE-ANALYSIS.md`)**:
  - Complete `## Context and Problem Statement`, `## Considered Alternatives`, `## Comparison Matrix`, `## Decision Outcome`, `## Consequences`, `## 🤖 AI & Agentic Ergonomics (AX)`, `## Recommendations`, `## Migration Path`, `## Links`, `## Discussion Questions`, and `## Decision`.

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

---

<self_validation_gate>
Before ending your turn, verify every item below with concrete evidence (not just a checkmark). If any item cannot be cited with real evidence from this turn, DO NOT produce your final response — fix the violation first:
- [ ] **Template Read Evidence:** Exact path passed to `read_file` (`templates/TEMPLATE-AMENDMENT.md` or `templates/TEMPLATE-ANALYSIS.md`): `<path>`
- [ ] **Non-Destructive Evidence:** Base ADR path (`docs/adr/0XX-*.md`) whose historical body was preserved untouched: `<path>`
- [ ] **Two-Way Links Evidence:** `Amends:` link in new file (`<path>`) + `Amended By:` link added to base ADR header (`<path>`).
- [ ] **Catalog Sync & Escape-Hatch Evidence:** `docs/adr/README.md` row added, count incremented, and any `"N/A — [rationale]"` sections explicitly noted.
</self_validation_gate>
