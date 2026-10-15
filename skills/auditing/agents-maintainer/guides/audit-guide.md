# AGENTS.md Audit Guide

Step-by-step guide for auditing AGENTS.md files.

## 🎯 Audit Objectives

1. Identify gaps against industry best practices
2. Detect outdated or inconsistent information
3. Find areas for improvement
4. Generate actionable recommendations

## 📋 Audit Process

### Step 1: Gather Context

**Read the following files:**
- `AGENTS.md` - Main agent instructions
- `docs/ARCHITECTURE.md` - Architecture overview
- `docs/ADRS.md` or `docs/adr/README.md` - Architecture decisions
- `docs/TESTING.md` - Testing guidelines
- `docs/API-DESIGN.md` - API guidelines (if exists)

**Understand:**
- Project technology stack
- Architecture patterns used
- Team workflows and practices
- Current pain points

### Step 2: Check Required Sections

Use the validation checklist to verify all required sections exist:

```
[ ] Commands
[ ] Boundaries
[ ] Project Structure
[ ] Code Style
[ ] Testing Guidelines
[ ] Definition of Done
[ ] Documentation
[ ] Architecture Principles
[ ] Karpathy Principles
[ ] Git Workflow
```

**Scoring:**
- Each missing section: -4 points
- Total possible: 40 points

### Step 3: Evaluate Content Quality

#### Specificity (0-8 points)
- [ ] Rules are specific and actionable
- [ ] Examples show correct implementation
- [ ] Anti-patterns clearly identified

**Common issues:**
- ❌ "Write good code" → ✅ "Follow TypeScript strict mode, no `any` types"
- ❌ "Test your code" → ✅ "Write unit tests with 80% coverage minimum"

#### Completeness (0-8 points)
- [ ] All major development areas covered
- [ ] Edge cases addressed
- [ ] Error handling guidelines included
- [ ] Security considerations mentioned

#### Clarity (0-7 points)
- [ ] No ambiguous language
- [ ] Consistent terminology
- [ ] Clear distinction between required and optional

#### Organization (0-7 points)
- [ ] Logical flow between sections
- [ ] Proper use of headings and subheadings
- [ ] Tables used for comparisons
- [ ] Cross-references between sections

### Step 4: Verify Karpathy Principles

Check for all 6 principles:

| Principle | Required Elements | Score |
|-----------|-------------------|-------|
| Think Before Coding | Workflow, planning steps | 0-4 |
| Simplicity First | Minimum code, no speculation | 0-3 |
| Surgical Changes | Touch only what's needed | 0-3 |
| Goal-Driven Execution | Success criteria defined | 0-3 |
| DRY & Reusability | Search-first requirement | 0-3 |
| Code Organization | File size limits (<300 LOC) | 0-4 |

**Total: 0-20 points**

### Step 5: Security Assessment

Check for security guidelines:

- [ ] Secrets management (never commit API keys)
- [ ] Input validation requirements
- [ ] Authentication/authorization considerations
- [ ] Error handling best practices
- [ ] Dependency verification

**Score: 0-10 points**

### Step 6: Identify Issues

Categorize findings:

| Priority | Type | Examples |
|----------|------|----------|
| **Critical** | Missing security, contradictions | Secret exposure risk, conflicting rules |
| **High** | Missing Karpathy principles, vague boundaries | No think-before-coding workflow |
| **Medium** | Missing examples, outdated info | No code examples, old tech references |
| **Low** | Formatting, minor improvements | Markdown issues, could be clearer |

### Step 7: Generate Recommendations

For each issue, provide:
1. **Problem**: Clear description
2. **Impact**: Why it matters
3. **Recommendation**: Specific fix
4. **Priority**: Critical/High/Medium/Low

## 📊 Audit Report Template

```markdown
# AGENTS.md Audit Report

**Project**: [Project Name]  
**Audit Date**: [DATE]  
**Auditor**: [Name]

## Executive Summary

**Overall Score**: [X]/100  
**Rating**: [Excellent/Good/Fair/Poor]  
**Status**: [Ready/Needs Improvement/Requires Revision]

## Section Scores

| Category | Score | Max | Status |
|----------|-------|-----|--------|
| Required Sections | X/40 | 40 | [✅/⚠️/❌] |
| Content Quality | X/30 | 30 | [✅/⚠️/❌] |
| Karpathy Implementation | X/20 | 20 | [✅/⚠️/❌] |
| Security & Best Practices | X/10 | 10 | [✅/⚠️/❌] |

## Critical Issues

### [Issue 1]
- **Type**: [Security/Completeness/Clarity]
- **Description**: [Detailed description]
- **Impact**: [Why it matters]
- **Recommendation**: [Specific fix]
- **Priority**: Critical/High/Medium/Low

### [Issue 2]
...

## Strengths

- [What's done well]
- [What should be preserved]

## Recommendations

### Immediate (Critical/High)
1. [Priority 1 action]
2. [Priority 2 action]

### Short-term (Medium)
1. [Secondary improvements]

### Long-term (Low)
1. [Nice-to-have enhancements]

## Next Steps

1. [ ] Address critical issues
2. [ ] Implement high-priority recommendations
3. [ ] Schedule follow-up audit in [timeframe]
4. [ ] Update AGENTS.md based on findings
```

## 🔧 Common Findings & Fixes

### Finding: No Karpathy Principles
**Impact**: Agents may over-engineer, skip planning, create duplicate code  
**Fix**: Add Karpathy Principles section with all 6 principles and workflows

### Finding: Vague Boundaries
**Impact**: Agents make inconsistent decisions  
**Fix**: Replace with specific, actionable rules

### Finding: Missing Examples
**Impact**: Agents may misunderstand requirements  
**Fix**: Add code examples showing correct patterns

### Finding: Outdated References
**Impact**: Agents follow obsolete practices  
**Fix**: Update to match current project state

### Finding: No Search-First Requirement
**Impact**: Duplicate code creation  
**Fix**: Add explicit search-first guideline

## 📈 Metrics to Track

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Agent Error Rate | X% | Y% | (X-Y)% |
| Rework Rate | X% | Y% | (X-Y)% |
| Clarification Questions | X/task | Y/task | (X-Y)/task |
| Task Completion Time | X min | Y min | (X-Y) min |

## 🔄 Follow-up

1. **Re-validate** after implementing changes
2. **Track metrics** to measure improvement
3. **Schedule next audit** in 3-6 months
4. **Document lessons learned** for future audits

---

**Last Updated**: 2026-06-25  
**Guide Version**: 1.0.0