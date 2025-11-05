---
description: "Research for bug fixes (local codebase analysis + git history). Uses local-only research strategy."
argument-hint: "Describe the bug or issue to fix"
allowed-tools: Task
model: claude-sonnet-4-5-20250929
---

# Bug Fix Research Assistant 🔍🐛

**Optimized for**: Bug fixes requiring codebase analysis and git history

**Research Strategy**: Local only (fast and focused)

---

## Bug Fix Research: $ARGUMENTS

Investigating bug and finding similar fixes...

<Task agent="local-researcher">
  $ARGUMENTS
  fix
  fast-mode
  .claude/sessions/research/$CLAUDE_SESSION_ID
</Task>

---

## Research Complete ✅

**Bug**: $ARGUMENTS
**Strategy Used**: Local (Codebase analysis only)
**Research Depth**: Fast-mode (5-10 minutes, focused search)

### What Was Analyzed

**Code Analysis**:
- Located relevant code and components
- Identified potential bug location
- Reviewed event handlers and logic
- Found similar past fixes in git history

**Patterns Found**:
- Existing error handling patterns
- Similar bugs previously fixed
- Test patterns for this area
- Code conventions to follow

**Context Gathered**:
- File references with line numbers
- Recent changes to affected code (git blame)
- Integration points that might be affected
- Dependencies to consider

### Artifacts Created

📄 **Local Context**: `.claude/sessions/research/$CLAUDE_SESSION_ID/context.md`

This document contains:
- Bug location and analysis
- Existing patterns to follow
- Similar fixes from git history
- File references with line numbers
- Recommended fix approach
- Test patterns to use

### Next Steps

1. **Review the local context** to understand the bug and fix approach

2. **Use with /patch** command for quick fix:
   ```
   /patch {bug-description}
   ```
   The patch command will use this research context automatically.

3. **Or proceed manually**:
   - Navigate to files identified
   - Follow fix pattern from similar issues
   - Add/update tests
   - Verify fix doesn't break integration points

---

## Why Local-Only Research for Fixes?

**Bug fixes are usually in the code**:
- ✅ **Fast** - No time wasted on unnecessary web research
- ✅ **Focused** - Targets codebase and git history
- ✅ **Efficient** - ~70% faster than hybrid research
- ✅ **Relevant** - Bug context is always local

**When you might need hybrid**:
- Large architectural bugs
- Framework/library-specific issues
- Need to understand external API behavior

For those cases, use:
```
/research {bug-description}
```
The general research command will auto-classify and route appropriately.

---

## Alternative Research Commands

If you need different research strategies:

- **General research** (auto-classifies): `/research {description}`
- **Feature research** (hybrid): `/research-feat {description}`
- **Refactoring research** (hybrid): `/research-refactor {description}`

---

**Research session**: `.claude/sessions/research/$CLAUDE_SESSION_ID/`
