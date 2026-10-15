---
name: agents-maintainer
description: >-
  Maintain and optimize AGENTS.md files for AI coding agents.
  LOAD THIS SKILL when user mentions: agents.md, agent guidelines, 
  agent best practices, karpathy principles, think before coding, 
  agent optimization, agent instructions, coding standards for agents, 
  audit agents.md, update agent guidelines, or validate agent rules.
  Executes audit, update, validate, generate, and compare modes.
disable-model-invocation: true
---

# Agents.md Maintainer Skill

A specialized skill for maintaining, updating, and optimizing the `AGENTS.md` file to ensure it stays aligned with industry best practices and project needs.

## 🎯 Purpose

This skill helps you:
- **Review** current `AGENTS.md` against best practices
- **Update** sections with new guidelines or changes
- **Validate** that rules are clear and actionable
- **Optimize** for agent performance and understanding
- **Generate** new sections based on project evolution

## 📋 Skill Capabilities

### Audit Capability
Review the current `AGENTS.md` and identify gaps or improvements.

**When to use:**
- Periodic review of agent guidelines
- Before major project changes
- When agent performance issues arise

**Expected output:**
- Gap analysis against best practices
- Priority recommendations
- Specific improvement suggestions

### Update Capability
Update specific sections of `AGENTS.md`.

**When to use:**
- New project requirements emerge
- Industry best practices evolve
- Lessons learned from agent mistakes
- Team feedback indicates improvements needed

**Expected output:**
- Updated `AGENTS.md` with changes
- Summary of what changed
- Change justification

### Validate Capability
Check if `AGENTS.md` meets quality standards.

**When to use:**
- After making changes
- Before committing changes
- During code review

**Expected output:**
- Compliance score (0-100%)
- Missing required sections
- Formatting issues
- Clarity assessment

### Generate Capability
Create new sections or files based on needs.

**When to use:**
- Setting up new project
- Adding new agent instruction files
- Creating coding standards documentation

**Expected output:**
- New content sections
- Agent-specific instruction files (CLAUDE.md, GEMINI.md, etc.)
- Integration suggestions

### Compare Capability
Compare current `AGENTS.md` with best practices benchmarks.

**When to use:**
- Evaluating current state
- Planning improvements
- Benchmarking against industry standards

**Expected output:**
- Side-by-side comparison
- Missing practices
- Adoption recommendations

## 📊 Required Sections

A complete `AGENTS.md` should include:

| Section | Required | Purpose |
|---------|----------|---------|
| Commands | ✅ | Available scripts and tools |
| Boundaries | ✅ | Always/Ask/Never guidelines |
| Project Structure | ✅ | Directory organization |
| Code Style | ✅ | Language-specific conventions |
| Testing Guidelines | ✅ | Test organization and requirements |
| Definition of Done | ✅ | Completion criteria |
| Documentation | ✅ | Reference locations |
| Architecture Principles | ✅ | Core architectural decisions |
| Karpathy Principles | ✅ | AI agent behavioral guidelines |
| Git Workflow | ✅ | Branching and commit standards |

## 🔧 Best Practices Checklist

### Content Quality
- [ ] Rules are specific and actionable
- [ ] Examples provided for complex concepts
- [ ] No contradictory statements
- [ ] Language is clear and unambiguous
- [ ] Covers common edge cases

### Structure
- [ ] Logical organization with clear headings
- [ ] Uses tables for quick scanning
- [ ] Includes code examples
- [ ] Proper markdown formatting
- [ ] Cross-references to other docs

### Agent Optimization
- [ ] Karpathy principles included
- [ ] Think-before-coding workflow defined
- [ ] Search-first requirement explicit
- [ ] File size limits specified
- [ ] Domain knowledge embedded

### Maintenance
- [ ] Last updated date present
- [ ] Version tracking if applicable
- [ ] Change log maintained
- [ ] Regular review schedule

## 🔍 Common Issues & Fixes

### Issue: Vague Rules
**Problem:** "Write good code"
**Fix:** "Follow TypeScript strict mode, no `any` types without justification"

### Issue: Missing Context
**Problem:** No explanation why rules exist
**Fix:** Add rationale: "DDD abstraction reduces migration cost by 85%"

### Issue: Outdated Information
**Problem:** References to removed features
**Fix:** Run audit, update or remove outdated sections

### Issue: Too Long
**Problem:** Agents don't read entire file
**Fix:** 
- Use tables for quick scanning
- Add summary sections
- Keep examples concise

### Issue: Contradictions
**Problem:** Conflicting rules in different sections
**Fix:** 
- Detect contradictions
- Consolidate overlapping rules
- Add cross-references

## 📈 Metrics to Track

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Agent Error Rate | < 10% | Track agent mistakes per task |
| Rework Rate | < 15% | Count of changes after initial delivery |
| Clarification Questions | < 5 per task | Track questions asked by agent |
| Task Completion Time | Baseline | Measure time to complete tasks |
| Code Quality Score | > 90% | Linting, type checking, tests |

## 🔄 Integration with Other Skills

| Skill | Integration Point |
|-------|-------------------|
| `adr-create` / `adr-amend` / `adr-validate` | Reference ADRs in architecture sections |
| `testing-workflow` | Align testing guidelines |
| `security-review` | Incorporate security constraints |
| `code-quality` | Enforce coding standards |

## 📚 Related Resources

- [Marmelab Agent Experience Guide](https://marmelab.com/blog/2026/01/21/agent-experience.html)
- [AI-Agent-Standards Framework](https://github.com/JunMystery/AI-Agent-Standards)
- [OWASP AI Agent Security](https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html)

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-06-25 | Initial skill creation |

---

**Skill Owner**: Technical Team  
**Last Updated**: 2026-06-25