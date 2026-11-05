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
1. WORKFLOW IMMUTABILITY: You may reason freely INSIDE each step, but you are strictly forbidden from skipping, merging, reordering, or replacing steps.
2. STOP GATES ARE ABSOLUTE: When a step ends with `🛑 HALT TURN`, you MUST stop your response immediately and wait for the user. Never execute the next step in the same turn.
3. TEMPLATE LOCK: Reconstructing template headers or tables from internal memory or prose descriptions is strictly forbidden. You MUST call `read_file` on the skill's `templates/*.md` file before generating any artifact.
4. NO PROACTIVE BUSINESS DECISIONS: If an open question or ambiguity exists, record it in the Open Questions / Lack of Information table, stop, and wait for the user.
</execution_invariants>
```

### C. `<output_contract>`
Binds each deliverable path to its mandatory `templates/*.md` file and structural invariance rules:

```xml
<output_contract>
- TARGET_PATH: Exact path where the artifact must be written (honouring `.sdlc/config.json` overrides).
- SOURCE_TEMPLATE: Relative path under `templates/*.md` that MUST be read via `read_file` prior to writing.
- SCHEMA_INVARIANCE: Preserve 100% of H1/H2/H3 headings, numbered section order, metadata bullets, and Markdown table column schemas verbatim. Strip all instructional meta-commentary.
</output_contract>
```

### D. `<self_validation_gate>`
Placed at the bottom of `SKILL.md` so the model must verify compliance before emitting its final response:

```xml
<self_validation_gate>
Before ending your turn, verify every applicable condition below. If any checkbox is FALSE, DO NOT produce your final answer — return to the failed step and fix it first:
- [ ] Did I execute every required step in `<state_machine>` up to the current gate without skipping or reordering?
- [ ] Did I call `read_file` on the required `templates/*.md` file during this session before writing the artifact?
- [ ] Does the written file preserve 100% of the template's H1/H2/H3 headings and table columns in exact order?
- [ ] Did I halt at the `🛑 HALT TURN` gate without leaking into the next step?
</self_validation_gate>
```
