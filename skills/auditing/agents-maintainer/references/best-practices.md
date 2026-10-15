# Agent Experience Best Practices Reference

Comprehensive reference for maintaining high-quality agent instructions.

## 📋 Marmelab Agent Experience Guide

### Domain Knowledge
- Add agent instructions (AGENTS.md, CLAUDE.md)
- Comment the code (explain what, not how)
- Use domain names in naming
- Test corner cases
- Embed documentation in code
- Use MCP servers for external knowledge

### Code SEO
- Use synonyms in comments
- Avoid duplicate file names
- Avoid abbreviations
- Use consistent structure
- Add tags and labels in comments
- Include directory descriptions (README.md in folders)

### Brevity
- Split large files into smaller modules
- Refactor large functions into reusable components
- Avoid obvious comments
- Limit error traces
- Remove dead code

### Serendipity
- Include cross-references between modules
- Tagging for categorization
- Self-documented commands
- Embedded technical documentation

### Testability
- Write tests first (TDD)
- Reproduce bugs with tests
- Write tests by hand for complex logic
- Mock external dependencies
- Provide fine-grained testing tools

### Conventions
- Use boring, well-known technologies
- Use design patterns
- Add Architecture Decision Records (ADRs)
- Include schemas and diagrams
- Consider open-sourcing

### Guardrails
- Introduce hooks (pre-commit, agent hooks)
- Plug in specialized MCP servers
- Increase CI checks
- Require PR reviews for agent code

### Usage Instructions
- Include usage examples
- Use Context7 for dependencies
- Use sensible defaults
- Avoid user interactions

### Coding Rules
- Add rule files (AGENTS.md, CLAUDE.md, .cursor/rules)
- Enforce rules with hooks
- Commit coding standards with code
- Avoid duplication (search first)

## 🏗️ AI-Agent-Standards Framework

### The 6 Core Principles

| # | Principle | Core Rule | Prevents |
|---|-----------|-----------|----------|
| 1 | **Think Before Coding** | Surface assumptions, present alternatives, ask when confused | Coding the wrong solution |
| 2 | **Simplicity First** | Minimum code, no speculative features | Over-engineering, bloat |
| 3 | **Surgical Changes** | Touch only what you must, match existing style | Scope creep, drive-by refactors |
| 4 | **Goal-Driven Execution** | Define verifiable success criteria | Ambiguous outcomes, wasted iterations |
| 5 | **DRY & Reusability** | Never duplicate UI, logic, configs, types, or any code | Hardcoded styles, duplicated types/configs, logic bugs |
| 6 | **Code Organization** | Don't put all code in one file, separate with general names | Monolithic files (>300 LOC), unorganized files |

### Quality Control

#### CI/CD Quality Gates
- SAST scanning (SonarCloud)
- 12 zero-trust security constraints
- Automated dependency checks
- Code coverage requirements

#### Code Review Checklist
- [ ] Follows Karpathy principles
- [ ] Tests included and passing
- [ ] No security vulnerabilities
- [ ] Documentation updated
- [ ] Follows coding standards
- [ ] No speculative features

#### Hallucination Detection
- Verify all code references exist
- Check all imports are valid
- Validate all API calls match documentation
- Confirm all file paths are correct

## 🔐 OWASP AI Agent Security

### Security Constraints

1. **Input Validation**: All inputs must be validated
2. **Output Sanitization**: Sanitize all outputs
3. **Authentication**: Verify authentication for all actions
4. **Authorization**: Check permissions before actions
5. **Secrets Management**: Never expose secrets or API keys
6. **Dependency Verification**: Verify all dependencies
7. **Error Handling**: Don't leak sensitive information in errors
8. **Rate Limiting**: Implement rate limits for API calls
9. **Logging**: Log security-relevant events
10. **Audit Trail**: Maintain audit trail for actions
11. **Data Protection**: Protect sensitive data
12. **Secure Communication**: Use secure protocols

### Risk Management

| Risk Level | Examples | Mitigation |
|------------|----------|------------|
| **Critical** | Secret exposure, unauthorized access | Block with hooks, require review |
| **High** | SQL injection, XSS | Validate input, use prepared statements |
| **Medium** | Information disclosure, weak auth | Implement proper error handling |
| **Low** | Minor security best practices | Document and address gradually |

## 📊 Industry Benchmarks

### Agent Experience Score

| Score | Description |
|-------|-------------|
| **90-100%** | Excellent - Agent works autonomously with minimal guidance |
| **75-89%** | Good - Agent needs occasional clarification |
| **60-74%** | Fair - Agent frequently makes mistakes |
| **Below 60%** | Poor - Agent requires constant supervision |

### Key Performance Indicators

| Metric | Excellent | Good | Fair | Poor |
|--------|-----------|------|------|------|
| **First-time Success Rate** | >80% | 60-80% | 40-60% | <40% |
| **Rework Rate** | <10% | 10-20% | 20-30% | >30% |
| **Clarification Needed** | <2/task | 2-5/task | 5-10/task | >10/task |
| **Test Coverage** | >90% | 80-90% | 70-80% | <70% |

## 🎯 Implementation Guidelines

### For New Projects
1. Start with basic AGENTS.md structure
2. Add Karpathy Principles immediately
3. Include testing guidelines
4. Document architecture decisions
5. Add security constraints

### For Existing Projects
1. Audit current AGENTS.md
2. Identify gaps against best practices
3. Prioritize improvements by impact
4. Implement changes incrementally
5. Measure agent performance improvements

### For Team Collaboration
1. Keep AGENTS.md in version control
2. Review changes in PRs
3. Update based on team feedback
4. Document lessons learned
5. Share improvements across teams

## 📚 Additional Resources

### Documentation
- [Marmelab Agent Experience](https://marmelab.com/blog/2026/01/21/agent-experience.html)
- [AI-Agent-Standards](https://github.com/JunMystery/AI-Agent-Standards)
- [OWASP AI Security](https://cheatsheetseries.owasp.org/cheatsheets/AI_Agent_Security_Cheat_Sheet.html)

### Tools
- Context7 MCP Server - Dependency documentation
- CodeQL - Security scanning
- SonarCloud - Code quality
- Pre-commit hooks - Automated checks

### Communities
- [Awesome Cursor Rules](https://github.com/PatrickJS/awesome-cursorrules)
- [Anthropic Skills](https://github.com/anthropics/skills)
- [Awesome MCP Servers](https://github.com/punkpeye/awesome-mcp-servers)

---

**Last Updated**: 2026-06-25
**Source**: Marmelab, AI-Agent-Standards, OWASP