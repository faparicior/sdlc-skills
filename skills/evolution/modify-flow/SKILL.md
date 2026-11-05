---
name: modify-flow
description: >-
  Propose and plan a change to an already-documented flow, entity, or business rule — as opposed to
  create-flow-documentation / create-entity-lifecycle, which document a flow for the first time.
  USE THIS SKILL when the user mentions: modify flow, change existing behaviour, disable/remove a feature,
  proposal for a change, modification proposal, change request, "how do we document this change",
  update the business rule, or any request to alter behaviour that already has a shipped flow/entity/BR doc
  under a bounded-context-style docs tree. Language- and framework-agnostic. Produces a proposal.md
  (product rationale + current vs desired behaviour + real-code scope), an implementation-plan.md (phased,
  grounded in whatever layering this specific codebase actually uses), then updates the original
  flow/entity/business-rule docs in place once implemented.
disable-model-invocation: true
---

# PROTOCOL: MODIFY-FLOW (EXECUTION LEVEL 3)

<state_machine>
CURRENT_STEP          -> REQUIRED_TOOL                         -> REQUIRED_OUTPUT                            -> MANDATORY_HALT
STEP_00: Discover     -> grep / find / read_file               -> Repo conventions, commands, cross-repo map -> Continue to STEP_00B
STEP_00B: Triage      -> evaluate 4 criteria                   -> Tier decision (Light / Standard / Full)    -> Continue to STEP_01
STEP_01: Ground       -> grep / read_file                      -> Code truth, INV-* cross-check, boundaries  -> Continue to STEP_02
STEP_02: Propose      -> read_file(templates/proposal.md)      -> working-on/active/[change]/proposal.md     -> 🛑 HALT TURN (Wait for user)
STEP_02B: Resume      -> git log / read_file                   -> Re-grounded slice against HEAD             -> Continue to STEP_03
STEP_03: Plan         -> read_file(templates/*-plan.md)        -> working-on/active/[change]/*-plan*.md      -> 🛑 HALT TURN (Wait for user)
STEP_04: Implement    -> edit_file / run_command               -> Verified code + full test/arch suites      -> Continue to STEP_05
STEP_05: Living Docs  -> edit_file / grep                      -> In-place doc updates + closed trace edges  -> Continue to STEP_06
STEP_06: Grace/Purge  -> mv / rm                               -> Grace-period lifecycle transition          -> END
</state_machine>

<execution_invariants>
1. WORKFLOW IMMUTABILITY: You are free to reason deeply INSIDE each step, but you are strictly forbidden from skipping, merging, reordering, or replacing steps (`workflow structure = immutable | step reasoning = flexible`).
2. STOP GATES ARE ABSOLUTE: You are strictly forbidden from executing `STEP_03` (Plan) or `STEP_04` (Code) in the same turn as `STEP_02` (Proposal). You MUST halt your turn at every `🛑 HALT TURN` gate and wait for explicit user approval.
3. TEMPLATE LOCK: Reconstructing template headers or tables from internal memory or prose rules is strictly forbidden. You MUST call `read_file` on `templates/proposal.md` before `STEP_02`, and `read_file` on `templates/implementation-plan.md` (or `templates/parallel-change-plan.md`) before `STEP_03`.
4. NO PROACTIVE BUSINESS DECISIONS: If an open question exists, record it in Section 10 (`Open Questions`) of `proposal.md`, stop, and wait. Never resolve open questions or self-select `Light` tier without explicit user confirmation.
5. NEVER CREATE PARALLEL LIVING DOCS: Living docs under `bounded-contexts/` describe currently shipped code only. Until `STEP_04` ships, all proposals, slice specs, drafts, and plans live exclusively under `docs/product/working-on/active/[change-name]/`.
</execution_invariants>

<output_contract>
- PROPOSAL ARTIFACT (`STEP_02`):
  - TARGET_PATH: `docs/product/working-on/active/[change-name]/proposal.md` (or `.sdlc/config.json` override)
  - SOURCE_TEMPLATE: `templates/proposal.md` (MUST call `read_file` first)
  - SCHEMA_INVARIANCE: Preserve all metadata bullets and numbered sections (`## 1. Product Rationale` through `## 10. Open Questions` + `## 🔗 Related Documentation`) and exact Markdown table column schemas verbatim.
- IMPLEMENTATION PLAN ARTIFACT (`STEP_03`):
  - TARGET_PATH: `docs/product/working-on/active/[change-name]/implementation-plan.md` (or `implementation-plan-sN.md`)
  - SOURCE_TEMPLATE: `templates/implementation-plan.md` (or `templates/parallel-change-plan.md` when Section 4.1 marks a contract as `Deprecation` with staged coexistence; MUST call `read_file` first)
  - SCHEMA_INVARIANCE: Preserve `### Resolved Open Questions`, `## 0. Cross-Repo Dependencies`, `## 1. Pre-Implementation Checklist`, `## 2. Phases`, `## 3. Validation`, `## 4. Documentation Update`, `## 5. Rollout Notes`, and `## 🔗 Related Documentation` verbatim.
</output_contract>

---

## STEP_00 — Discover This Repo's Conventions

- **INPUT:** Target repository workspace and `.sdlc/config.json` (if present, honour its `docsRoot` / `productDocsDir` overrides; default is `docs/product/`).
- **ACTION:** Execute tool searches to discover (never assume):
  1. **Docs location & shape:** Find where flow/entity/business-rule documentation lives (grep for `"flow"`, `"business rule"`, `"bounded context"`, `"entity lifecycle"` across docs directories). Note exact folder structure and naming conventions.
  2. **Language & source layout:** Identify implementation language(s) and how source is organized (e.g. layered `domain/application/infrastructure`, feature-first modules, monorepo packages).
  3. **Test/build/lint commands:** Read the repo's `README.md`, `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`, or build config to find real verification commands.
  4. **Feature-flag system:** Check whether the repo already uses one (Unleash, LaunchDarkly, config toggle, env var convention).
  5. **Cross-repo dependencies:** Read `CLAUDE.md` or `AGENTS.md` for a **Cross-Repo Dependencies** section. Note which other repos this change may touch, what changes there, and any required deploy order (feeds **Section 7** of `proposal.md` and **Section 0** of `implementation-plan.md`).
- **REQUIRED OUTPUT:** Internal discovery findings used to populate subsequent steps with real paths and commands.
- **DO NOT:**
  - Do NOT guess file paths, test commands (`npm test`, `./gradlew`), or module layouts without checking the repo.
  - Do NOT skip `templates/proposal.md` in Step 2 unless the user explicitly instructs you to use a different template file.
- **PASS CONDITION:** All 5 repository dimensions above are verified from real files.

---

## STEP_00B — Triage Ceremony Tier

- **INPUT:** User request and STEP_00 findings.
- **ACTION:** Evaluate the 4 triage criteria:
  1. Does it need more than one PR?
  2. Does it touch an invariant, a data migration, or another repository?
  3. Are there open business questions?
  4. Will it be paused and resumed later?

| Tier | Trigger Condition | Mandatory Execution Path |
| :--- | :--- | :--- |
| **Light** | **All 4 answers are strictly "no"** (a single behaviour tweak such as a threshold, validation, or window length) **AND the user confirms Light tier** | Do not create a proposal folder. Run **STEP_01.10 (boundary-values check)** for any new or reused input and put the result in a short PR change note, implement test-first, and edit the affected flow/entity/BR doc in the same PR (updating its `Enforced by` / `Verified by` rows). Stop after verification. |
| **Standard** *(Default)* | One PR-sized slice, with a design choice, invariant, or migration | Execute **STEP_01 $\rightarrow$ STEP_02** (Proposal with a single slice `S1`), stop at **HARD GATE 1**, then **STEP_03 $\rightarrow$ STEP_06**. No separate feature specs. |
| **Full** | Several slices, several repos, or a long pause expected | Execute **STEP_01 $\rightarrow$ STEP_06** in full, including feature specs (`/create-features`) saved inside `docs/product/working-on/active/[change-name]/features/` for active slices. |

- **REQUIRED OUTPUT:** Explicit statement of which Tier applies and why.
- **DO NOT:**
  - Do NOT silently self-select **Light** tier to avoid writing `proposal.md`. If any criterion is "yes" or uncertain, you **MUST** use **Standard** or **Full** tier.
  - Even in **Light** tier, you **MUST NOT** skip **STEP_01.10 (boundary-values check)**.
- **PASS CONDITION:** Tier is explicitly determined; if Standard or Full, proceed immediately to `STEP_01`.

---

## STEP_01 — Ground the Change in Reality Before Writing Anything

- **INPUT:** Target change description and STEP_00 discovery results.
- **ACTION:** Perform all 10 grounding checks using file-reading and search tools:
  1. **Read root flow/documentation index:** Identify every flow this change affects.
  2. **Read affected derived docs:** Read the affected flow doc(s), entity doc(s), **domain-service doc(s)** (`bounded-contexts/{ctx}/domain-services/` — check every service whose behaviour the change touches), and business rule doc(s).
  3. **Verify against real source code (Code is Truth):** Grep and read the actual source files the docs point to. Docs can be stale; report the actual current logic in code, not just what the doc claims.
  4. **Trace every derived doc back to its upstream source for staleness:** Read every upstream doc (journeys, personas, brainstorming/feature-scoping docs) that a derived doc links back to and check line-by-line whether it states the pre-change behaviour as present-tense fact. Classify each upstream doc into one of two buckets:
     - **Bucket A — Living upstream doc stating current behaviour as present-tense fact** (e.g. a journey's step-by-step table) $\rightarrow$ goes stale; must be listed in `proposal.md` Section 8.2 for editing.
     - **Bucket B — Frozen historical record of a past decision** (e.g. a workshop/brainstorming artifact scoping the original feature) $\rightarrow$ **do NOT rewrite**; list it in `proposal.md` Section 8.2 as "Do not rewrite — frozen record", and plan a dated History & Evolution forward-link in the derived doc (Section 8.1).
  5. **Identify affected personas & feature reversals:** Note who is affected (personas) and whether this reverses or extends an already-scoped feature (feeds Section 1 and Section 8).
  6. **Perform Concurrency, TOCTOU, Idempotency & Active Invariant Cross-Check:**
     - Search `docs/product/bounded-contexts/**/invariants/INV-*.md` and `docs/product/discovered/invariants/INV-RAW-*.md` across **all** bounded contexts for any invariant constraining the operations being modified, extended, or newly called.
     - Verify whether the change preserves enforcement or introduces an unconstrained code path. List every relevant `INV-*` in the proposal's scope and implementation plan.
     - Evaluate race conditions, check-then-act vulnerabilities, duplicate replay side-effects, database unique indexes, optimistic locking versioning, aggregate consistency boundaries, transactional outbox atomicity, and transaction isolation.
  7. **Evaluate Migration & Backward Compatibility:** Determine if modifying data schemas, contracts, or business rules requires DB column defaults, data backfill scripts, or API contract versioning / staged parallel-change deprecation.
  8. **Read the rule/invariant document's own Traceability section before grepping:** Follow [../guidelines/traceability.md](../guidelines/traceability.md). Start from the rule doc's `Traceability` / `Enforced by` / `Verified by` table (the pre-computed blast radius), then grep the rule ID across the codebase to catch unlinked enforcement. Respect row statuses strictly:
     - `✅ Verified`: confirmed guard in code.
     - `⚠️ Unverified`: lead that you **must** open the file to confirm or reject in the proposal.
     - `⏳ Planned`: does not exist yet.
     - Never promote a status silently.
  9. **Verify the existing tests:** For each `Verified by` test, confirm the file and test title still exist (`grep -n "<title>" <test-file>`). These are the tests that will fail when a guard is altered and must be listed in Section 6 (Scope of Change).
  10. **Boundary-values check for every new or reused input:** For each new parameter, flag, config value, or field added, and each existing one fed from a new source:
      - List **every place it is consumed** through the full call chain (watch for hidden coupling where one value is reused for two calculations, e.g. a date used both as "has started" and as the start of a counting window).
      - Test **values on both sides of every boundary**: past / present / future, same / next period (month, year), empty / one / many, and **mixed states** in a single call (some records started, some not; some at limit, some not).
      - Ask **what a caller gains by passing an unusual value** (can it bypass a limit, permission, or uniqueness rule?).
      - Record findings in `proposal.md` Section 4 (or in the change note for Light tier). Every risky boundary value becomes a required test.
- **REQUIRED OUTPUT:** Complete evidence set of real file paths, method names, upstream docs, invariants, test titles, and boundary cases.
- **DO NOT:**
  - Do NOT trust markdown documentation without reading the underlying source code files.
  - Do NOT declare a side effect "intended" before completing check `10` (boundary-values check).
- **PASS CONDITION:** Every affected doc, source file, test file, and cross-context invariant has been read and verified.

---

## STEP_02 — Write the Proposal (`OUTPUT CONTRACT`)

- **INPUT:** Grounded findings from `STEP_00` and `STEP_01`, plus the exact contents of `templates/proposal.md`.
- **ACTION:**
  1. **MANDATORY TOOL CALL:** Read `templates/proposal.md` (located in this skill's `templates/` folder) using `read_file`.
  2. Write the proposal file to:
     `docs/product/working-on/active/[change-name]/proposal.md`
     *(Use a kebab-case `[change-name]` slug matching the git branch name where possible. Never write directly in `working-on/` root or `grace-period/`.)*
  3. If the proposal's Migration & Backward Compatibility table (`Section 4.1`) marks a contract as **Deprecation** with a staged rollout where old and new versions coexist, also read `templates/parallel-change-plan.md` and copy the two Mermaid diagram skeletons from its Appendix (`A. Before and after` and `B. Old and new surfaces coexisting`) to the top of `Section 3 (Desired Behaviour)` in `proposal.md`.

### `OUTPUT CONTRACT` for `proposal.md`
Your generated `proposal.md` **MUST** conform strictly to `templates/proposal.md`:
- **Required Header Metadata:** `* **Status:**`, `* **Shipped Date:**`, `* **Last checked against code:**` (with date + git commit SHA), `* **Branch:**`, `* **Bounded Context:**`, `* **Affects:**`.
- **Required Section Structure (Exact Order & Headings — Do Not Rename or Reorder):**
  - `## 1. Product Rationale`
    - `**As a:**` / `**I want to:**` / `**So that:**` (always 3 bullets, never a table)
    - `### Personas Affected` (table: `Persona | Current Experience | Experience After This Change`)
    - `### Business Value & Why It Matters` (table: `Aspect | Detail`)
    - `### Known Gaps Introduced` (bullets; omit this H3 subsection only if there are zero gaps)
  - `## 2. Current Behaviour` (table: `Step | Method / Component | Behaviour` citing real classes/methods + link to enforced BR/INV doc and feature-flag check)
  - `## 3. Desired Behaviour` (table: `Aspect | Today | After This Change`; preceded by the two Appendix Mermaid diagrams if Parallel Change applies)
  - `## 4. 🛡️ Concurrency, TOCTOU & Invariant Integrity Analysis` (table: `Concurrency / Invariant Scenario (TOCTOU) | Potential Risk in Modified Flow | Guard / Mitigation Strategy | Enforcement Mechanism` + boundary-value findings from `STEP_01.10`)
    - `### 4.1 Migration & Backward Compatibility Assessment` (table: `Dimension | Risk / Impact | Mitigation / Strategy`)
  - `## 5. Why` (table: `Driver | Detail`)
  - `## 6. Scope of Change` (table: `File | In/Out | Change` — every real source file, test file, undecided dependency, and feature flag)
  - `## 7. Cross-Repo Dependencies` (table: `# | Repo | Role in this change | Deploy first?` + deploy order note; remove this section only for single-repo changes)
  - `## 8. Impact on Existing Documentation`
    - `### 8.1 Derived Bounded-Context / Flow Docs` (table: `Doc (destination) | Draft | Slice | Change`)
    - `### 8.2 Upstream Product Docs` (table: `Doc | Stale Content | Change` — explicitly separating living upstream docs to edit vs. frozen historical docs left untouched)
  - `## 9. Delivery Slices` (table: `Slice | Features / Scope | Blocked by (Open Question #) | Detail | Status | Shipped | Ticket / PR`)
  - `## 10. Open Questions` (table: `# | Question | Blocks slice`)
  - `## 🔗 Related Documentation` (relative links to journeys, flows, BRs, entities)

### Multi-Slice & Draft Rules (`Section 8` & `Section 9`)
- **Single-pass changes:** Keep one row (`S1`) in Section 9.
- **Multi-slice or parked changes:** Group scope into independently shippable slices (`S1`, `S2`, ...) and tag each Open Question in Section 10 with the slice it blocks.
- **Plan light, detail just in time:** Set each slice's `Detail` column in Section 9 to `Outline` $\rightarrow$ `Specified` (detailed spec in `features/`) $\rightarrow$ `In progress` $\rightarrow$ `Shipped` (or `Discarded / Superseded`). Only specify the slice about to start.
- **Not-yet-implemented docs live in `working-on/active/<change>/drafts/`, NEVER in living docs:**
  ```text
  working-on/active/<change>/
  ├── proposal.md                   roadmap: slices, decisions, blockers, ticket keys
  ├── features/                     detailed specs (specified slices only)
  ├── drafts/                       planned text of living docs (+ README mapping draft → destination/slice)
  └── implementation-plan-sN.md     written when slice N starts (or implementation-plan.md for single-slice)
  ```
  - While parked (`⏸ Parked`) or in progress, **do not edit living docs** (except a single pointer row in a domain-service doc's Part A4 *Pending Changes* table).
  - Once a slice is `In progress`, freeze its spec and record changes only via a dated amendment line in `proposal.md`.

- **DO NOT:**
  - Do NOT leave `[EntityName]` or `[RealClassOrModule.method()]` placeholders in the delivered `proposal.md`.
  - Do NOT resolve Open Questions in Section 10 on the user's behalf.
  - Do NOT proceed to `STEP_03` (Implementation Plan) or `STEP_04` (Code) in the same turn as `STEP_02`.
- **PASS CONDITION (🛑 HARD GATE 1):**
  `proposal.md` is written to disk, passes the **Gate 1 Validation Checklist** at the bottom of this skill, and you **STOP your turn** to ask the user to review `proposal.md` and resolve Section 10 Open Questions.

---

## STEP_02B — Resume a Parked or Partially Shipped Proposal

Run this step whenever `proposal.md` already exists in `working-on/active/[change-name]/` and the user asks to continue work on it.

- **INPUT:** Existing `proposal.md` and current git `HEAD`.
- **ACTION:**
  1. Read **Section 9 (Delivery Slices)** and **Section 10 (Open Questions)**. Identify the next `📋 Planned` slice whose blocking questions are all resolved. If any blocking question is still open, **STOP** and ask the user.
  2. **Ask "is this slice still wanted?"** before investing in detail. If no longer wanted, execute `STEP_05B` (Discard). If wanted and currently at `Outline` detail in a Full-tier change, generate its detailed spec in `features/` (`/create-features`) before continuing.
  3. **Re-ground against current code:** Compare the `"Last checked against code"` commit SHA in `proposal.md` with `HEAD` (`git log <commit>..HEAD -- <files in Section 6>`), re-read the real files in Section 6, and re-run `STEP_01.6` (invariant cross-check).
  4. Report any code drift to the user and update `proposal.md` / slice specs where affected. Update `"Last checked against code"` with today's date and `HEAD` commit SHA, and set Status to `🔄 In Progress`.
- **PASS CONDITION:** Target slice is unblocked, re-grounded against `HEAD`, and ready for `STEP_03`.

---

## STEP_03 — Write the Implementation Plan (`OUTPUT CONTRACT`)

Execute **only after** the user has approved `proposal.md` and resolved all Open Questions blocking the target slice. Plan **one slice at a time**.

- **INPUT:** Approved `proposal.md` (with resolved Open Questions) and the plan template in `templates/`.
- **ACTION:**
  1. **Select & Read Template (`MANDATORY TOOL CALL`):**
     - **Standard Inside-Out Change:** Call `read_file` on `templates/implementation-plan.md`.
     - **Parallel Change Variant:** If `proposal.md` Section 4.1 marks a contract as **Deprecation** with staged coexistence (old and new versions live side-by-side while consumers migrate), call `read_file` on `templates/parallel-change-plan.md` instead.
  2. Write the plan alongside `proposal.md`:
     - Single-slice: `docs/product/working-on/active/[change-name]/implementation-plan.md`
     - Multi-slice (slice `N`): `docs/product/working-on/active/[change-name]/implementation-plan-sN.md`

### `OUTPUT CONTRACT` for `implementation-plan.md` / `parallel-change-plan.md`
- Preserve all template headings and sections in exact order:
  - Header Metadata (`Status`, `Proposal` link) + `### Resolved Open Questions` table (`# | Question | Resolution`)
  - `## 0. Cross-Repo Dependencies` (carried forward verbatim from `proposal.md` Section 7; external repo phases precede this repo's phases when deploy order requires it)
  - `## 1. Pre-Implementation Checklist`
  - `## 2. Phases`:
    - *If Standard (`templates/implementation-plan.md`):* Derive phases directly from `proposal.md` Section 6 (Scope of Change), ordered **inside-out** matching this codebase's actual layering discovered in `STEP_00`. Each phase is test-first (or matches repo test convention), implements the change, and removes dead code. Include dedicated integration/acceptance test tasks for concurrency/TOCTOU, idempotency replays, migration compatibility, and invariant guards.
    - *If Parallel Change (`templates/parallel-change-plan.md`):* Keep the Mermaid lifecycle gates diagram at the top of `## 2. Phases` and structure phases strictly as **Phase 1: Expand (baseline metrics on old surface first + dark new surface)** $\rightarrow$ **Phase 2: Migrate (consumers one at a time + deprecation signals)** $\rightarrow$ **Phase 3: Contract (remove old routes, code, flags)**.
  - `## 3. Validation` (populated with this repo's **real** unit, integration, architecture, and lint commands from `STEP_00`)
  - `## 4. Documentation Update` (table mapping every doc from `proposal.md` Section 8 for the active slice to its update mechanism)
  - `## 5. Rollout Notes` (for Parallel Change, include the mandatory `### Flags`, `### Per-consumer migration table`, `### How to confirm the rollout worked`, and `### Risks to watch` tables)
  - `## 🔗 Related Documentation`

- **DO NOT:**
  - Do NOT invent generic architecture layers (e.g. CQRS/Hexagonal) if `STEP_00` showed a different codebase structure.
  - Do NOT start modifying production or test code in the same turn that you generate the implementation plan.
- **PASS CONDITION (🛑 HARD GATE 2):**
  The implementation plan is written to disk, verified against the **Gate 2 Validation Checklist**, and presented to the user for approval before coding begins.

---

## STEP_04 — Implement the Slice

Execute **only after** user approval at **HARD GATE 2**.

- **INPUT:** Approved `implementation-plan.md` (or `implementation-plan-sN.md`).
- **ACTION:**
  1. Implement **only the current slice's scope** phase by phase, following the repo's documented conventions (`CLAUDE.md` / `AGENTS.md`).
  2. Check off (`[x]`) tasks in the implementation plan as each phase completes.
  3. After each phase, run the repo's **full unit test suite and architecture test suite** (found in `STEP_00`), not only the test file you touched — signature changes break mocks in untouched test files.
  4. Run the **full integration/acceptance test suite** and linter/typecheck before declaring implementation complete.
- **DO NOT:**
  - Do NOT implement features belonging to future slices.
  - Do NOT leave commented-out dead code or orphaned feature flags (unless in Phase 1/2 of a Parallel Change plan).
- **PASS CONDITION:** All phases for the active slice are checked off and the full unit, architecture, integration, and lint suites pass.

---

## STEP_05 — Update the Original Living Docs In-Place (Post-Implementation)

Execute once `STEP_04` is complete and verified for the active slice.

- **INPUT:** Shipped code for the slice, `proposal.md` Section 8, and `drafts/` (if used).
- **ACTION:**
  1. **Scope strictly to the shipped slice:** Only update Section 8 rows tagged with the slice that just shipped. Copy matching files from `drafts/` into their living destination, fix relative links, verify against shipped code, and delete the consumed drafts. Leave docs for unshipped slices untouched.
  2. **Domain-service docs (`Part A4 Pending Changes`):** When a slice ships, copy its draft over the living domain-service doc, retain `Part A4` rows for slices not yet shipped, remove the shipped slice's row, flip `⏳` to `✅` only after verifying the code guard, and populate `Verified by` with real test titles.
  3. **Update in place using the repo's convention:** If the repo uses paired skills (`create-entity-lifecycle`, `create-flow-documentation`), follow their exact structure on the existing file. Never create a duplicate file or new rule/invariant ID when replacing an existing rule's formula — keep the existing ID and add a dated entry in its `History & Evolution` / changelog section.
  4. **Update BOTH documentation layers from Section 8:**
     - **8.1 Derived Bounded-Context / Flow Docs** AND
     - **8.2 Living Upstream Docs** (journeys/personas that stated the old behaviour as present-tense fact).
     - Leave frozen historical brainstorming/scoping artifacts untouched.
  5. **Close every traceability edge at both ends ([../guidelines/traceability.md](../guidelines/traceability.md)):**
     - For every link added or removed (rule $\leftrightarrow$ entity, flow, feature, journey, test), write both sides in the same commit and grep the rule ID across the docs tree to verify bidirectional links.
     - Keep each rule doc's `Enforced by` table complete across layers (contract, application, domain, database, UI) with honest status (`✅ Verified` or `⚠️ Unverified`, never an unearned `✅`).
  6. Update the root flow/documentation index if any summary/status row changed.
  7. Mark the slice `✅ Shipped` in `proposal.md` Section 9 (with date and PR/ticket), update `proposal.md` Status (`🔄 Partially Shipped (slice N/M)` if slices remain), and mark Section 4 of the implementation plan complete.
- **PASS CONDITION:** All living docs for the shipped slice match the code, all bidirectional traceability links are verified via grep, and no unshipped slice behaviour leaks into living docs.

---

## STEP_05B — Discard or Supersede a Slice

Execute when a planned slice is dropped or replaced:
1. In `proposal.md` Section 9, set the slice's Status to `🗑 Discarded` (or `Superseded by S#`) with a one-line reason and date. Keep the table row as the decision record.
2. Delete its `features/` specs and `drafts/` files (and remove entries from `drafts/README.md`).
3. Remove its row from any domain-service doc's *Pending Changes* (Part A4) table.
4. Drop Open Questions in Section 10 that only blocked the discarded slice.
5. If all remaining slices are `Shipped` or `Discarded`, proceed to `STEP_06`.

---

## STEP_06 — Grace Period & Purge Lifecycle (`working-on/`)

Execute **only after** `STEP_05` is complete for the **last** slice of the proposal. (While any slice remains `📋 Planned` or `🔄 In Progress`, keep the folder in `working-on/active/`.)

1. **Move to Grace Period:** Move the change folder out of `active/` to prevent LLM context bleeding across branches/worktrees:
   ```bash
   mv docs/product/working-on/active/[change-name] docs/product/working-on/grace-period/
   ```
   Update `proposal.md` metadata:
   ```markdown
   * **Status:** 🚀 Implemented (Grace Period)
   * **Shipped Date:** YYYY-MM-DD
   ```
2. **Mark Ready to Purge:** Once verified stable in production, set `* **Status:** 🧹 Ready to Purge`.
3. **Safe Purge:** Delete `docs/product/working-on/grace-period/[change-name]` once no longer needed for hotfix reference.

---

<self_validation_gate>
Before producing your final response at ANY turn, verify every applicable item below. If any checkbox for your current gate is FALSE, DO NOT end your turn — return to the failed step and fix the violation first:

### Gate 1 Validation (End of Turn 1 — Proposal Phase)
- [ ] `STEP_00` executed: Repo conventions, real test commands, and cross-repo dependencies discovered from actual files.
- [ ] `STEP_00B` executed: Triage tier (`Light` / `Standard` / `Full`) explicitly stated and justified.
- [ ] `STEP_01` executed: Real source code read, upstream docs checked for staleness, active invariants (`INV-*`) cross-checked across all bounded contexts, existing tests verified, and boundary-values check (`STEP_01.10`) completed.
- [ ] **Template Read Verified:** `read_file` was called on `templates/proposal.md` before writing `proposal.md`.
- [ ] **Path Compliance Verified:** Proposal saved strictly at `docs/product/working-on/active/[change-name]/proposal.md` (or `.sdlc/config.json` equivalent).
- [ ] **Schema Compliance Verified:** `proposal.md` contains all numbered sections (`1` through `10` + `🔗 Related Documentation`) and exact table schemas from `templates/proposal.md` with zero `[Placeholder]` leftovers.
- [ ] **Halt Gate Respected:** No `implementation-plan.md` written and no production/test code modified before user approves `proposal.md` and resolves Section 10 Open Questions.

### Gate 2 Validation (End of Turn 2 — Implementation Plan Phase)
- [ ] **Template Read Verified:** `read_file` was called on `templates/implementation-plan.md` (or `templates/parallel-change-plan.md` for staged deprecations).
- [ ] **Schema Compliance Verified:** Plan contains `Resolved Open Questions`, `0. Cross-Repo Dependencies`, `1. Pre-Implementation Checklist`, `2. Phases`, `3. Validation` (with real repo commands), `4. Documentation Update`, and `5. Rollout Notes`.
- [ ] **Halt Gate Respected:** Plan presented to user for approval before executing `STEP_04` code changes.

### Gate 3 Validation (Post-Implementation & Living Docs Phase)
- [ ] Full unit, architecture, integration, and lint suites executed and passing.
- [ ] Living docs (both 8.1 derived and 8.2 living upstream) updated in place for the shipped slice only.
- [ ] Bidirectional traceability links (`Enforced by` / `Verified by` / `Traces up to`) verified via grep.
</self_validation_gate>

---

## 📚 Bundled Resources & Related Skills

| Resource / Guideline | Purpose |
| :--- | :--- |
| `templates/proposal.md` | **Mandatory `OUTPUT CONTRACT`** for `STEP_02` modification proposals |
| `templates/implementation-plan.md` | **Mandatory `OUTPUT CONTRACT`** for `STEP_03` standard inside-out implementation plans |
| `templates/parallel-change-plan.md` | **Mandatory `OUTPUT CONTRACT`** for `STEP_03` staged Expand $\rightarrow$ Migrate $\rightarrow$ Contract migrations |
| `../guidelines/traceability.md` | Binding traceability convention for `STEP_01.8` and `STEP_05.5` |

---

**Version:** 2.0 — Upgraded to a Level 3 Execution Protocol (explicit state machine, non-negotiable `OUTPUT CONTRACT` template locks, turn-termination gates, and mandatory self-audit checklists for reasoning models). 1.3 — added parallel change plan variant (`templates/parallel-change-plan.md`). 1.2 — added boundary-values check and full-suite run. 1.1 — generalized to be language- and framework-agnostic.
