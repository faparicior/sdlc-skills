# Prompt Template for One Audit Slice (sub-agent)

Fill the `<...>` fields and hand this to one sub-agent per slice. Run slices in parallel; they are read-only
and independent. The main agent merges the results (see "Execution Plan" in SKILL.md).

---

You are auditing ONE SLICE of the documentation with the `audit-docs` skill. First read
`<skill dir>/SKILL.md` and `<skill dir>/references/claim-kinds.md` and follow them for this slice.

**Slice (audit every doc, end to end):**
<list of files or the folder>

**Counterpart docs (read only to compare claims, do not audit them):**
<for each capability the slice mentions as shipped or pending: the flow / rule / proposal doc that covers it>

**Code:** source under `<source root>`, migrations under `<migrations dir>`, config in `<config files>`.

**Claim inventory for this slice** (output of `scripts/claim-inventory.sh <slice folder>`; if you cannot
run it, use the manual fallback in SKILL.md). Answer EVERY line: ✅ confirmed, ⚠️ wrong (with the code
`file:line` that contradicts it), or "needs manual review":
<paste the inventory>

**Also apply** the per-type checks in SKILL.md for each doc type in the slice, the Traceability table
(grep each `Verified by` title, open each cited `file:line`, confirm each `Enforced by` symbol), and the
doc-against-doc check against the counterpart docs.

**Rules:** read-only; never sample; the code is the truth; do not cap the length of your findings.

**Return exactly:**
1. A findings table per doc: `ID | verdict | detail with file:line`.
2. A list of every WRONG claim, quoting its exact wording, so the main agent can sweep the whole tree for it.
3. The Completeness Gate lines that apply to the slice, answered honestly with counts
   (inventoried N, answered N).
4. Your limits: what you did not read or could not verify.
