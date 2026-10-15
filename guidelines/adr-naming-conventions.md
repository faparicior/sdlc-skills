# ADR Naming Convention Guide

**Version:** 1.0  
**Last Updated:** 2026-06-25

---

## Overview

This document defines the naming convention for ADR files to ensure clarity, consistency, and easy identification of document relationships.

---

## Naming Pattern

### Format

```
{adr-number}-{sequence}-{topic-description}.md
```

### Components

| Component | Format | Example |
|-----------|--------|---------|
| **ADR Number** | 3-digit number | `002` |
| **Sequence** | 2-digit number | `00`, `01`, `02`, `03` |
| **Topic** | kebab-case description | `use-supabase` |
| **Type** | optional suffix | `amendment`, `analysis`, `impact-analysis` |

---

## Sequence Numbers

| Sequence | Type | Description |
|----------|------|-------------|
| `00` | Original ADR | The primary architectural decision |
| `01` | Amendment | First amendment to the original ADR |
| `02` | Analysis | First analysis/research document |
| `03` | Analysis | Second analysis document |
| `04` | Impact Analysis | Impact assessment of related decisions |
| `05+` | Additional | Continue incrementing for more documents |

---

## Document Types

### 1. Original ADR (`00`)

**Pattern:** `{number}-00-{topic}.md`

**Example:**
```
002-00-use-supabase-for-backend-and-database.md
004-00-implement-magic-link-authentication.md
005-00-use-supabase-storage-for-files.md
```

**Purpose:** Documents the primary architectural decision with full context, alternatives, and consequences.

---

### 2. Amendment (`01`)

**Pattern:** `{number}-01-{topic}-amendment-{description}.md`

**Example:**
```
002-01-use-supabase-amendment-ddd-abstraction.md
004-01-magic-link-authentication-amendment.md
005-01-supabase-storage-amendment.md
```

**Purpose:** Proposes changes or refinements to an existing ADR. Must include:
- Link to original ADR (`Amends:` field)
- Specific updates to the original decision
- Revised consequences

---

### 3. Analysis Document (`02`, `03`, etc.)

**Pattern:** `{number}-XX-{topic}-analysis-{subtype}.md`

**Example:**
```
002-02-use-supabase-analysis-vendor-lock-in.md
002-03-use-supabase-analysis-auth-strategy.md
```

**Purpose:** Research and analysis related to the ADR topic. Can include:
- Vendor comparisons
- Alternative evaluations
- Market research
- Technical deep dives

---

### 4. Impact Analysis (`04`)

**Pattern:** `{number}-04-{topic}-impact-analysis.md`

**Example:**
```
002-04-use-supabase-impact-analysis.md
```

**Purpose:** Documents the impact of a decision on other ADRs or system components. Includes:
- Affected ADRs
- Required amendments
- Migration considerations

---

## Examples by ADR

### ADR-002: Database Strategy

```
002-00-use-supabase-for-backend-and-database.md          # Original ADR
002-01-use-supabase-amendment-ddd-abstraction.md         # Amendment (DDD layer)
002-02-use-supabase-analysis-vendor-lock-in.md           # Analysis (vendor options)
002-03-use-supabase-analysis-auth-strategy.md            # Analysis (auth strategies)
002-04-use-supabase-impact-analysis.md                   # Impact (on other ADRs)
```

### ADR-004: Authentication

```
004-00-implement-magic-link-authentication.md            # Original ADR
004-01-magic-link-authentication-amendment.md            # Amendment (DDD abstraction)
```

### ADR-005: Storage

```
005-00-use-supabase-storage-for-files.md                 # Original ADR
005-01-supabase-storage-amendment.md                     # Amendment (DDD abstraction)
```

---

## Benefits of This Convention

### 1. **Immediate Visibility**
Just by reading the filename, you can see:
- Which ADR it belongs to (`002`)
- What type of document it is (`00`=original, `01`=amendment, `02-03`=analysis, `04`=impact)
- The topic (`use-supabase`)

### 2. **Easy Grouping**
```bash
# Find all documents related to ADR-002
ls docs/adr/ | grep "^002-"

# Find all amendments
ls docs/adr/ | grep "-amendment-"

# Find all analysis documents
ls docs/adr/ | grep "-analysis-"
```

### 3. **Logical Ordering**
Files naturally sort in the correct order:
```
002-00-*  (original)
002-01-*  (amendment)
002-02-*  (analysis 1)
002-03-*  (analysis 2)
002-04-*  (impact)
```

### 4. **Scalability**
Easy to add more documents as needed:
```
002-05-use-supabase-analysis-performance.md
002-06-use-supabase-analysis-cost-optimization.md
```

---

## Implementation Guidelines

### When Creating a New ADR

1. **Determine the next ADR number** (e.g., 015)
2. **Use sequence `00`** for the original document
3. **Choose a descriptive topic** in kebab-case
4. **Format:** `015-00-{topic}.md`

**Example:**
```bash
# Create new ADR for caching strategy
touch docs/adr/015-00-implement-caching-strategy.md
```

### When Creating an Amendment

1. **Use the parent ADR number** (e.g., 015)
2. **Use next available sequence** (e.g., `01`)
3. **Add `-amendment-{description}`** suffix
4. **Format:** `015-01-{topic}-amendment-{description}.md`

**Example:**
```bash
# Create amendment for ADR-015
touch docs/adr/015-01-implement-caching-amendment-redis.md
```

### When Creating Analysis Documents

1. **Use the parent ADR number** (e.g., 015)
2. **Use next available sequence** (e.g., `02`, `03`)
3. **Add `-analysis-{subtype}`** suffix
4. **Format:** `015-02-{topic}-analysis-{subtype}.md`

**Example:**
```bash
# Create analysis document
touch docs/adr/015-02-implement-caching-analysis-comparison.md
```

---

## Integration with the ADR Skills

This naming convention is upheld by the four ADR skills — there is no `adr-manager` any more, and
skills are invoked as `/skill:<name>`, not through a `pi skill` CLI:

| Need | Invoke | Naming effect |
| :--- | :----- | :------------ |
| New ADR | `/skill:adr-create` | assigns the next `NNN-00` sequence |
| Amendment | `/skill:adr-amend` on `docs/adr/015-00-*.md` | creates `015-01-*-amendment-*.md` |
| Validate naming & compliance | `/skill:adr-validate` on `docs/adr/0XX-*.md` | checks convention compliance |
| Rebuild the index | ⚠️ **unowned after the split** — update `docs/adr/README.md` by hand | — |

---

## Quality Checklist

Before finalizing any ADR document, verify:

- [ ] **Number is correct** - Matches ADR sequence
- [ ] **Sequence is correct** - 00=original, 01+=related
- [ ] **Topic is descriptive** - Clear what the ADR is about
- [ ] **Type is clear** - Amendment/analysis/impact suffix present
- [ ] **Links are updated** - References to related documents are correct
- [ ] **README is updated** - Index reflects new file name

---

## Migration from Old Convention

If migrating from older naming:

1. **Identify parent ADR** for each document
2. **Assign sequence numbers** based on document type
3. **Rename files** to new convention
4. **Update all internal links**
5. **Update README.md index**

**Example Migration:**
```
Old: 002a-supabase-vendor-lock-in-alternatives.md
New: 002-02-use-supabase-analysis-vendor-lock-in.md

Old: 002b-auth-strategy-ddd-abstraction.md
New: 002-03-use-supabase-analysis-auth-strategy.md

Old: adr-impact-analysis-002b.md
New: 002-04-use-supabase-impact-analysis.md
```

---

**References:**
- ADR Workflow: `0-ADR-WORKFLOW.md`
- Amendment Guide: `7-generate-adr-amendment.md`
- Index Update: `6-update-adr-readme.md`

---

## Practical Examples

### Creating a New ADR
```bash
# ADR-015: Caching Strategy
touch docs/adr/015-00-implement-caching-strategy.md
```

### Creating an Amendment
```bash
# Amendment to ADR-015 with DDD abstraction
touch docs/adr/015-01-implement-caching-amendment-ddd-abstraction.md
```

### Creating an Analysis Document
```bash
# Analysis of Redis vs Memcached
touch docs/adr/015-02-implement-caching-analysis-redis-vs-memcached.md
```

### Creating an Impact Analysis
```bash
# Impact of caching on system architecture
touch docs/adr/015-04-implement-caching-impact-analysis.md
```