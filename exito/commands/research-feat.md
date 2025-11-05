---
description: "Research for new features (local patterns + online best practices). Uses hybrid research strategy automatically."
argument-hint: "Describe the feature to research"
allowed-tools: Task
model: claude-sonnet-4-5-20250929
---

# Feature Research Assistant 🔍✨

**Optimized for**: New features requiring BOTH codebase patterns AND current best practices

**Research Strategy**: Hybrid (Local + Online in parallel)

---

## Feature Research: $ARGUMENTS

Researching feature implementation approaches...

<Task agent="hybrid-researcher">
  $ARGUMENTS
  feat
  standard
  .claude/sessions/research/$CLAUDE_SESSION_ID
</Task>

---

## Research Complete ✅

**Feature**: $ARGUMENTS
**Strategy Used**: Hybrid (Local codebase + Web research)
**Research Depth**: Standard (15-20 minutes, balanced depth)

### What Was Researched

**Local Analysis**:
- Existing similar features in codebase
- Current architecture and patterns
- Integration points and dependencies
- Testing patterns to follow

**Online Research**:
- Current best practices (2024-2025)
- Library and framework recommendations
- Security considerations
- Performance implications

**Synthesis**:
- How online best practices adapt to local architecture
- Recommended implementation approach
- Specific file modifications needed
- Risk assessment and mitigations

### Artifacts Created

📄 **Unified Context**: `.claude/sessions/research/$CLAUDE_SESSION_ID/unified_context.md`

This document contains:
- Complete research findings (local + online)
- Synthesis and recommendations
- Implementation strategy
- File references and code examples
- Security and performance checklist
- Risk mitigation strategies

### Next Steps

1. **Review the unified context** to understand the recommended approach
2. **Use with /build** command for implementation:
   ```
   /build {your-feature-description}
   ```
   The build command will use this research context automatically.

3. **Or proceed manually**:
   - Use the unified context for planning
   - Follow file references and patterns identified
   - Implement security and performance checklist
   - Add tests following examples found

---

## Why Hybrid Research for Features?

**Features need BOTH**:
- ✅ **Local patterns** - For consistency with existing code
- ✅ **Online best practices** - For current, secure, performant implementation

**Token efficient**: Parallel research saves ~50% time vs sequential

**Comprehensive**: Gets the complete picture from both sources

---

## Alternative Research Commands

If you need different research strategies:

- **General research** (auto-classifies): `/research {description}`
- **Bug fix research** (local only): `/research-fix {description}`
- **Refactoring research** (hybrid): `/research-refactor {description}`

---

**Research session**: `.claude/sessions/research/$CLAUDE_SESSION_ID/`
