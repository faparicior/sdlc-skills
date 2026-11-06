# Level 3 Execution Protocol for SDLC Skills (XML + Markdown Hybrid)

> **Binding Convention Across All SDLC Skills**
> Every skill in `sdlc-skills` defines a **Level 3 Execution Protocol (Mandatory State Machine)** using top-level XML control blocks (`<state_machine>`, `<execution_invariants>`, `<output_contract>`, `<self_validation_gate>`) paired with Markdown domain instructions.

---

## 1. Why Hybrid XML Control Blocks + Markdown Body

Frontier reasoning models (GPT-6.x / Terra / Sol, Claude 4.x, Gemini 4) treat uniform Markdown (`##`) as soft, compressible domain context, whereas paired XML tags (`<state_machine>`, `<execution_invariants>`, `<output_contract>`, `<self_validation_gate>`) act as **hard syntactic permission boundaries** aligned with their RL instruction-hierarchy training:

```text
<state_machine> & <execution_invariants> = IMMUTABLE CONTROL PLANE (you do NOT control the arrows, paths, or templates)
Markdown Step Instructions               = FLEXIBLE REASONING PLANE (you control how deeply to analyze code, edge cases, and invariants inside each step)
```

---

## 2. Standard XML Blocks Required in Every Workflow/Template Skill

### A. `<state_machine>`
Maps every step in the skill to its required tool, required output artifact, and mandatory turn-halt condition:

```xml
<state_machine>
CURRENT_STEP      -> REQUIRED_TOOL            -> REQUIRED_OUTPUT         -> MANDATORY_HALT
Step 0: Discover  -> grep / find / read_file  -> Repo conventions        -> Continue to Step 0b
Step 0b: Triage   -> evaluate criteria        -> Tier decision           -> Continue to Step 1
Step 1: Ground    -> grep / read_file         -> Code & invariant truth  -> Continue to Step 2
Step 2: Propose   -> read_file (template)     -> proposal.md             -> 🛑 HALT TURN (Wait for user approval)
Step 3: Plan      -> read_file (template)     -> implementation-plan.md  -> 🛑 HALT TURN (Wait for user approval)
Step 4: Implement -> edit_file / run_command  -> Verified code & tests   -> Continue to Step 5
Step 5: LivingDoc -> edit_file / grep         -> In-place doc updates    -> Continue to Step 6
</state_machine>
```

### B. `<execution_invariants>`
Encapsulates the non-negotiable rules that reasoning models are strictly forbidden from optimizing away:

```xml
<execution_invariants>
1. WORKFLOW IMMUTABILITY: You may reason freely INSIDE each step, but you are strictly forbidden from skipping, merging, reordering, or replacing steps (`workflow structure = immutable | step reasoning = flexible`).
2. STOP GATES ARE ABSOLUTE (WITH EXPLICIT FAST-TRACK OVERRIDE): When a step ends with `🛑 HALT TURN`, you MUST stop your response immediately and wait for the user — unless the user explicitly requested unattended/batch execution or a Light-tier fast-track in their prompt.
3. TEMPLATE LOCK: Reconstructing template headers or tables from internal memory or prose descriptions is strictly forbidden. You MUST call `read_file` on the skill's `templates/*.md` file before generating any artifact.
4. NO PROACTIVE BUSINESS DECISIONS: If an open question or ambiguity exists, record it in the Open Questions / Lack of Information table, stop, and wait for the user.
5. ESCAPE HATCH: If the situation does not fit the contract, do not silently improvise and do not force-fit: declare the deviation in one line and ask.
</execution_invariants>
```

### C. `<output_contract>`
Binds each deliverable path to its mandatory `templates/*.md` file, structural invariance rules, and an explicit Escape Hatch:

```xml
<output_contract>
- TARGET_PATH: Exact path where the artifact must be written (honouring `.sdlc/config.json` overrides).
- SOURCE_TEMPLATE: Relative path under `templates/*.md` that MUST be read via `read_file` prior to writing.
- SCHEMA_INVARIANCE: Preserve 100% of H1/H2/H3 headings, numbered section order, metadata bullets, and Markdown table column schemas verbatim. Strip all instructional meta-commentary.
- ESCAPE_HATCH: Never silently omit or invent template sections. If a template section genuinely does not apply to this domain context, preserve the heading and write `"N/A — [1-line rationale]"`, or halt and ask the user before deviating.
</output_contract>
```

### D. `<self_validation_gate>` (Evidence-Based, Not Self-Report Theatre)
Placed at the bottom of `SKILL.md` so the model must verify compliance with **concrete evidence citations** (`tool call + exact file path + section/rubric count`) rather than passive boolean checkboxes before emitting its final response:

```xml
<self_validation_gate>
Before ending your turn, verify every applicable condition below with concrete evidence (not just a checkmark). If any item cannot be cited with real evidence from this turn, DO NOT produce your final answer — return to the failed step and fix it first:
- [ ] **Template Read Evidence:** Exact `templates/*.md` path passed to `read_file` in this turn: `<path>`
- [ ] **Output Path Evidence:** Exact artifact path written via `write_file`/`edit_file`: `<path>`
- [ ] **Schema & Escape-Hatch Evidence:** Confirm 100% of template headings are present verbatim, or list any section marked `"N/A — [rationale]"`: `<status>`
- [ ] **Halt Gate Evidence:** Confirm turn stops at the active `🛑 HALT TURN` gate (or cite the user's explicit batch/fast-track instruction): `<status>`
</self_validation_gate>
```
