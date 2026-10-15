# AGENTS.md Validation Checklist

Use this checklist to validate the quality and completeness of AGENTS.md files.

## 📋 Required Sections Checklist

### Core Sections
- [ ] **Commands** - Available scripts and tools
- [ ] **Boundaries** - Always/Ask/Never guidelines
- [ ] **Project Structure** - Directory organization
- [ ] **Code Style** - Language-specific conventions
- [ ] **Testing Guidelines** - Test organization and requirements
- [ ] **Definition of Done** - Completion criteria
- [ ] **Documentation** - Reference locations
- [ ] **Architecture Principles** - Core architectural decisions
- [ ] **Karpathy Principles** - AI agent behavioral guidelines
- [ ] **Git Workflow** - Branching and commit standards

### Quality Indicators
- [ ] Clear and actionable rules
- [ ] Examples provided for complex concepts
- [ ] No contradictory statements
- [ ] Language is unambiguous
- [ ] Covers common edge cases

## 🎯 Content Quality Checklist

### Specificity
- [ ] Rules are specific (not "write good code" but "follow TypeScript strict mode")
- [ ] Examples show correct implementation
- [ ] Anti-patterns are clearly identified
- [ ] Rationale provided for important rules

### Completeness
- [ ] All major development areas covered
- [ ] Edge cases addressed
- [ ] Error handling guidelines included
- [ ] Security considerations mentioned

### Clarity
- [ ] No ambiguous language
- [ ] Consistent terminology
- [ ] Clear distinction between required and optional
- [ ] Examples are easy to understand

### Organization
- [ ] Logical flow between sections
- [ ] Proper use of headings and subheadings
- [ ] Tables used for comparisons
- [ ] Cross-references between related sections

### AI Bias & Guardrail Mitigations
- [ ] Explicitly addresses atypical architecture decisions that contradict default LLM training bias (e.g., DDD tactical rules, pure handlers, Value Objects without primitive obsession)
- [ ] Documents toolchain and dual-build idiosyncrasies (e.g., `dist/` vs `src/` resolution in monorepo, `xo` vs Prettier rules)
- [ ] Lists concrete automated checks (`npm run check:arch`, `ts-archunit`, `npm run lint`) to prevent architectural drift

## 🔍 Karpathy Principles Checklist

### Principle Coverage
- [ ] **Think Before Coding** - Workflow defined
- [ ] **Simplicity First** - Minimum code principle stated
- [ ] **Surgical Changes** - Scope control guidelines
- [ ] **Goal-Driven Execution** - Success criteria defined
- [ ] **DRY & Reusability** - Search-first requirement
- [ ] **Code Organization** - File size limits specified

### Implementation Guidance
- [ ] Think-before-coding workflow documented
- [ ] Search-first requirement explicit
- [ ] File size limits defined (<300 LOC)
- [ ] Examples of good vs bad practices

## 🛡️ Security Checklist

### Security Constraints
- [ ] Secrets management guidelines
- [ ] Input validation requirements
- [ ] Authentication/authorization considerations
- [ ] Error handling that doesn't leak information
- [ ] Dependency verification mentioned

### Risk Mitigation
- [ ] Critical risks clearly marked
- [ ] Required reviews specified
- [ ] Automated checks mentioned
- [ ] Audit trail requirements

## 📊 Scoring Rubric

### Required Sections (40 points)
| Section | Points |
|---------|--------|
| Commands | 4 |
| Boundaries | 4 |
| Project Structure | 4 |
| Code Style | 4 |
| Testing Guidelines | 4 |
| Definition of Done | 4 |
| Documentation | 4 |
| Architecture Principles | 4 |
| Karpathy Principles | 4 |
| Git Workflow | 4 |

### Content Quality (30 points)
| Criterion | Points |
|-----------|--------|
| Specificity | 8 |
| Completeness | 8 |
| Clarity | 7 |
| Organization | 7 |

### Karpathy Implementation (20 points)
| Criterion | Points |
|-----------|--------|
| All 6 principles covered | 10 |
| Implementation guidance | 10 |

### Security & Best Practices (10 points)
| Criterion | Points |
|-----------|--------|
| Security constraints | 5 |
| Best practices alignment | 5 |

### Total Score: ___ / 100

## 🎯 Score Interpretation

| Score | Rating | Action |
|-------|--------|--------|
| **90-100** | Excellent | Ready for use, minor improvements optional |
| **75-89** | Good | Minor improvements recommended |
| **60-74** | Fair | Significant improvements needed |
| **Below 60** | Poor | Major revision required |

## 🔧 Common Issues & Fixes

### Issue: Missing Karpathy Principles
**Score Impact**: -20 points  
**Fix**: Add Karpathy Principles section with all 6 principles and workflows

### Issue: Vague Boundaries
**Score Impact**: -5 to -10 points  
**Fix**: Replace vague rules with specific, actionable guidelines

### Issue: No Examples
**Score Impact**: -5 to -8 points  
**Fix**: Add code examples showing correct and incorrect patterns

### Issue: Outdated Information
**Score Impact**: -5 to -10 points  
**Fix**: Update references to match current project state

### Issue: Missing Security Guidelines
**Score Impact**: -5 points  
**Fix**: Add security constraints and best practices

## 📝 Validation Report Template

```markdown
# AGENTS.md Validation Report

**File**: AGENTS.md  
**Date**: [DATE]  
**Validator**: [NAME/TOOL]

## Summary
- **Total Score**: [X]/100
- **Rating**: [Excellent/Good/Fair/Poor]
- **Status**: [Ready/Needs Improvement/Requires Revision]

## Section Scores
| Section | Score | Max |
|---------|-------|-----|
| Required Sections | X/40 | 40 |
| Content Quality | X/30 | 30 |
| Karpathy Implementation | X/20 | 20 |
| Security & Best Practices | X/10 | 10 |

## Critical Issues
1. [Issue description]
2. [Issue description]

## Recommendations
1. [Priority improvement]
2. [Secondary improvement]

## Next Steps
- [ ] Address critical issues
- [ ] Implement recommendations
- [ ] Re-validate after changes
```

---

**Last Updated**: 2026-06-25  
**Template Version**: 1.0.0