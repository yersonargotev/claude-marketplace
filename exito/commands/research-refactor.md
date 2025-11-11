---
description: "Research for refactoring (local structure + better approaches online). Uses hybrid research strategy with deep analysis."
argument-hint: "Describe the refactoring to research"
allowed-tools: Task
model: claude-sonnet-4-5-20250929
---

# Refactoring Research Assistant 🔍♻️

**Optimized for**: Code restructuring requiring BOTH current structure AND better approaches

**Research Strategy**: Hybrid (Local + Online in parallel)
**Research Depth**: Workflow-analysis (thorough, for careful refactoring)

---

## Refactoring Research: $ARGUMENTS

Analyzing current structure and researching improvements...

<Task agent="hybrid-researcher">
  $ARGUMENTS
  refactor
  workflow-analysis
  .claude/sessions/research/$CLAUDE_SESSION_ID
</Task>

---

## Research Complete ✅

**Refactoring**: $ARGUMENTS
**Strategy Used**: Hybrid (Local structure + Online approaches)
**Research Depth**: Workflow-analysis (20-25 minutes, thorough analysis)

### What Was Researched

**Local Analysis**:
- Current code structure and organization
- All usages and dependencies
- Integration points and consumers
- Test coverage and patterns
- Breaking change risks

**Online Research**:
- Better architectural patterns
- Refactoring best practices
- Migration guides (if applicable)
- Code organization standards
- Design patterns

**Synthesis**:
- Gap analysis (current vs ideal)
- Step-by-step refactoring plan
- Migration strategy (gradual vs big-bang)
- Risk assessment and mitigations
- Test strategy for refactoring

### Artifacts Created

📄 **Unified Context**: `.claude/sessions/research/$CLAUDE_SESSION_ID/unified_context.md`

This document contains:
- Complete analysis (local + online)
- Current vs recommended structure
- Step-by-step refactoring plan
- All file dependencies mapped
- Breaking change analysis
- Test migration strategy
- Risk mitigation plan

### Next Steps

1. **Review the unified context** carefully
   - Understand current structure
   - Review recommended approach
   - Consider risks and mitigations

2. **Use with /workflow** command for systematic refactoring**:
   ```
   /workflow {refactoring-description}
   ```
   The workflow command provides:
   - Solution exploration phase
   - User approval checkpoints
   - Surgical implementation
   - Comprehensive testing

3. **Or use /build** for direct implementation:
   ```
   /build {refactoring-description}
   ```

4. **Or proceed manually**:
   - Follow step-by-step plan
   - Update tests incrementally
   - Monitor for regressions
   - Communicate breaking changes

---

## Why Hybrid Research for Refactoring?

**Refactoring needs BOTH**:
- ✅ **Local structure** - Map current implementation completely
- ✅ **Online approaches** - Learn better patterns and practices
- ✅ **Synthesis** - Adapt online patterns to local constraints

**Why deep analysis**:
- Refactoring is risky (breaking changes possible)
- Need complete dependency map
- Must maintain backwards compatibility
- Test strategy is critical

**Token efficient**: Parallel research, deep analysis where it matters

---

## Refactoring Best Practices

Based on research, here are key principles:

1. **Small steps**: Break large refactors into small, testable changes
2. **Tests first**: Ensure good test coverage before refactoring
3. **Incremental**: Prefer gradual migration over big-bang rewrite
4. **Backwards compatible**: Maintain APIs during transition when possible
5. **Communicate**: Document breaking changes clearly

---

## Alternative Research Commands

If you need different research strategies:

- **General research** (auto-classifies): `/research {description}`
- **Feature research** (hybrid): `/research-feat {description}`
- **Bug fix research** (local only): `/research-fix {description}`

---

**Research session**: `.claude/sessions/research/$CLAUDE_SESSION_ID/`
**Recommended workflow**: Use `/workflow` command for careful, systematic refactoring
