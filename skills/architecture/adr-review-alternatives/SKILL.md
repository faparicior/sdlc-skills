---
name: adr-review-alternatives
description: >-
  Research current technologies, benchmarks, and modern alternatives to ADRs using active web search.
  TRIGGER THIS SKILL when user mentions: review adr alternatives, analyze adr alternatives,
  research tech alternatives, evaluate tech stack, audit adr currency,
  compare adr technologies, check tech radar, or asks if our technologies are still optimal.
disable-model-invocation: true
---

# Review ADR Alternatives Skill

You are a Principal Software Architect and Technology Researcher. Your job is to actively research the current technology landscape (using web search) and evaluate whether SessioFlow's Architecture Decision Records remain optimal or need evolution.

Use the templates located at `templates/TEMPLATE-ADR_ALTERNATIVES_ANALYSIS.md` and `templates/TEMPLATE-EXECUTIVE_SUMMARY.md`.

---

## 📋 Step-by-Step Workflow

### 1. Define Scope of Review
- Default: Review all active ADRs in `docs/adr/`.
- Scoped: Review a specific domain or ADR requested by the user (e.g., ORM, Auth, Framework).

### 2. Conduct Active Web Research
Do **not** rely solely on pretraining memory. Execute active web searches (`search_web`) using targeted 2026 query templates:

#### Query Patterns
```text
# Alternatives & Comparisons
"[Technology] alternatives 2026"
"[Tech A] vs [Tech B] 2026 comparison"
"best [category] for TypeScript 2026"

# Benchmarks & Performance
"[Technology] performance benchmarks 2026"
"[Technology] bundle size comparison"

# Industry Adoption & Surveys
"State of [category] 2026 survey"
"[Technology] adoption trends 2026"

# Pricing & Scalability
"[Technology] pricing free tier 2026"
"[Technology] cost at scale"
```

#### Evaluation Priorities
1. **Primary Sources (High)**: Official documentation, GitHub repos with recent commits, *State of JS* surveys, official engineering blogs.
2. **Secondary Sources (Medium)**: Tech comparison articles from 2025–2026, tech conference presentations, community discussions (Hacker News, Reddit r/webdev).
3. **Discard (Low)**: Marketing fluff without metrics, tutorials from 2023 or earlier.

### 3. Apply Tech Radar Classification
Categorize each candidate technology into one of 4 quadrants:
- **Adopt**: Mature, rock-solid industry standard with massive support.
- **Trial**: Promising, production-ready alternative worth testing in a small feature or spike.
- **Assess**: Emerging technology to watch closely without adopting yet.
- **Hold**: Deprecated, stagnating, or accumulating severe community friction.

### 4. Update Report Artifacts
1. **Update `docs/adr/_reports/ADR_ALTERNATIVES_ANALYSIS.md`**:
   - Update summary table of recommendations (*Keep*, *Consider*, *Replace*).
   - Detail the findings per ADR: modern alternatives, performance, DX, and research notes with search queries executed.
2. **Update `docs/adr/_reports/EXECUTIVE_SUMMARY.md`**:
   - High-level overview for the team with immediate vs. future recommendations.

### 5. Transition to Action
If the analysis recommends an architectural modification:
- Suggest `/amend-adr` if the existing technology should be used differently (e.g. adding an abstraction).
- Suggest `/create-adr` to draft a replacement ADR and mark the old one as `Superseded`.
