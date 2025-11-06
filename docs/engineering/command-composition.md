# Command Composition Patterns

**Version**: 1.0  
**Date**: November 6, 2025

Examples of composing commands for complex workflows.

## Multi-Stage Development

### Design → Implement → Review

```bash
# Stage 1: Systematic design exploration
/workflow Design user authentication flow with OAuth2

# Review alternatives in: .claude/sessions/workflow/SESSION_ID/alternatives.md
# Select approach and approve plan

# Stage 2: Implement chosen design
# (Artifacts from /workflow are available for reference)

# Stage 3: Review implementation
/review https://github.com/org/repo/pull/789

# Stage 4: Address review findings
/patch Fix security issues identified in review
```

### Research → Build

```bash
# Stage 1: Deep research
/research Best practices for WebSocket real-time collaboration

# Review findings, then:

# Stage 2: Implement with knowledge
/craft Build collaborative editing feature with operational transforms
```

### Prototype → Production

```bash
# Stage 1: Quick prototype
/implement Add basic product filtering

# Test with users, then:

# Stage 2: Production-quality implementation
/craft Rebuild product filtering with advanced features and testing
```

## UI Workflows

### Design → Implement → Perfect

```bash
# Stage 1: Standard UI implementation
/ui Create product comparison table

# Stage 2: Pixel-perfect refinement
/pixel Polish product comparison table from Figma design
```

### Component → Integration

```bash
# Stage 1: Build individual components
/ui Create SearchBar component
/ui Create FilterPanel component
/ui Create ProductGrid component

# Stage 2: Integrate into page
/build Integrate search components into product listing page
```

## Refactoring Workflows

### Explore → Refactor → Validate

```bash
# Stage 1: Explore refactoring options
/workflow Refactor authentication to use middleware pattern

# Review alternatives, select approach, approve plan

# Stage 2: Review quality
/review <PR_URL>

# All done automatically by /workflow!
```

### Iterative Refactoring

```bash
# Phase 1: Extract patterns
/workflow Extract common validation logic into reusable validators

# Phase 2: Extract more patterns
/workflow Extract common error handling into middleware

# Phase 3: Consolidate
/workflow Consolidate validators and error handlers into shared library
```

## Architecture Workflows

### Analysis → Design → Implement

```bash
# Stage 1: Deep analysis
/think Analyze current architecture bottlenecks

# Stage 2: Design solution
/genesis Design new microservice architecture from first principles

# Stage 3: Implement incrementally
/workflow Implement API gateway microservice
/workflow Implement auth microservice
/workflow Implement payment microservice
```

## Review Workflows

### Continuous Review

```bash
# After each feature PR
/review https://github.com/org/repo/pull/123

# Address findings
/patch Fix performance issues from review

# Re-review if significant changes
/review https://github.com/org/repo/pull/123
```

### Pre-Merge Checklist

```bash
# 1. Feature complete
/build Complete checkout flow implementation

# 2. Review
/review <PR_URL>

# 3. Address critical findings
/patch Fix security vulnerabilities identified

# 4. Final review
/review <PR_URL>

# 5. Merge when approved
```

## Cross-Command Patterns

### Session Artifact Reuse

Session artifacts from one command can inform another:

```bash
# Run /workflow
/workflow Optimize database queries

# Review artifacts
cat .claude/sessions/workflow/SESSION_ID/context.md
cat .claude/sessions/workflow/SESSION_ID/alternatives.md
cat .claude/sessions/workflow/SESSION_ID/plan.md

# Use insights for related work
/craft Implement caching layer based on workflow insights
```

### Iterative Improvement

```bash
# V1: Get it working
/implement Add email notifications

# V2: Make it good
/build Add comprehensive email template system

# V3: Make it great
/craft Rebuild email system with templating engine and queue
```

## Best Practices

### When to Chain Commands

✅ **DO Chain**:
- Research → Implementation (knowledge transfer)
- Prototype → Production (iteration)
- Build → Review → Fix (quality cycle)
- Design → Implementation → Refinement (staged delivery)

❌ **DON'T Chain**:
- Multiple builds in parallel for same area (conflicts)
- Skipping review for production code
- Using fast commands for critical code

### Session Management

Each command creates its own session:
```
.claude/sessions/workflow/abc123/
.claude/sessions/build/def456/
.claude/sessions/review/ghi789/
```

Reference prior sessions explicitly when needed.

### Timing

Allow sufficient time between commands:
- Review session artifacts before next command
- Test implementations before refinement
- Gather feedback before iteration

## Related Documentation

- [Command Selection Guide](./command-selection-guide.md) - Choose right command
- [Quick Reference](../../exito/QUICKREF.md) - Command syntax
- [Agent Catalog](../../exito/AGENTS.md) - How agents work

---

*Commands compose. Workflows emerge. Excellence evolves.*

