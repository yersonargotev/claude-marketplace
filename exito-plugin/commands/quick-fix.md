---
description: "Fast fixes for simple bugs or small changes. Skips deep planning - just research, quick analysis, implement, and test."
argument-hint: "Describe the bug or small change needed"
allowed-tools: Task
---

# Quick Fix Engineer

**Fast, focused fixes!** ⚡

Use this for:
- Simple bug fixes
- Small style adjustments
- Minor refactoring
- Typo corrections
- Dependency updates
- Configuration tweaks

**Not suitable for**:
- New features
- Architecture changes
- Complex refactoring
- Security-critical work
- Performance optimization

For those, use `/inge` or `/senior` instead.

---

## Quick Fix: $ARGUMENTS

Gathering necessary context...

<Task agent="research-engineer">
  Quick context gathering for: $ARGUMENTS
  
  Session directory: .claude/sessions/tasks/{{timestamp}}
  
  **Fast research focus**:
  1. Locate the problem area (file + line)
  2. Understand immediate context (not entire codebase)
  3. Check for related code nearby
  4. Identify any obvious risks
  5. Find relevant tests
  
  Keep it focused - this is a quick fix.
  
  Output to: .claude/sessions/tasks/{{timestamp}}/context.md
</Task>

---

## Context Gathered ✓

Quick solution analysis...

<Task agent="planner-engineer">
  Quick fix plan for: $ARGUMENTS
  
  Session directory: .claude/sessions/tasks/{{timestamp}}
  
  Input: .claude/sessions/tasks/{{timestamp}}/context.md
  
  **Fast planning**:
  1. Identify the root cause
  2. Propose a straightforward fix
  3. List the files to change
  4. Note any risks (even for simple fixes)
  5. Define quick test to verify
  
  No need for extended thinking - keep it simple and direct.
  
  Output to: .claude/sessions/tasks/{{timestamp}}/plan.md
  
  ⚠️ **Auto-approve**: This is a quick fix, proceeding to implementation.
</Task>

---

## Implementing the fix ✓

<Task agent="implementer-engineer">
  Execute quick fix for: $ARGUMENTS
  
  Session directory: .claude/sessions/tasks/{{timestamp}}
  
  Inputs:
  - Context: .claude/sessions/tasks/{{timestamp}}/context.md
  - Plan: .claude/sessions/tasks/{{timestamp}}/plan.md
  
  **Quick implementation**:
  1. Make the targeted change
  2. Update/add test if applicable
  3. Run relevant tests
  4. Make a descriptive commit
  
  Keep it focused and simple.
  
  Output to: .claude/sessions/tasks/{{timestamp}}/progress.md
</Task>

---

## Testing the fix ✓

<Task agent="tester-engineer">
  Validate quick fix for: $ARGUMENTS
  
  Session directory: .claude/sessions/tasks/{{timestamp}}
  
  Inputs:
  - Context: .claude/sessions/tasks/{{timestamp}}/context.md
  - Plan: .claude/sessions/tasks/{{timestamp}}/plan.md
  - Progress: .claude/sessions/tasks/{{timestamp}}/progress.md
  
  **Quick validation**:
  1. Run relevant tests (not entire suite)
  2. Verify the specific bug is fixed
  3. Quick smoke test of related functionality
  4. Check for obvious regressions
  
  Fast validation for a simple fix.
  
  Output to: .claude/sessions/tasks/{{timestamp}}/test_report.md
</Task>

---

## Quick Fix Complete ✅

**Fixed**: $ARGUMENTS

**Change summary**: Check `.claude/sessions/tasks/{{timestamp}}/progress.md`

**Tests**: Check `.claude/sessions/tasks/{{timestamp}}/test_report.md`

**Commit**: Check git log

**What changed**: 
- Targeted fix applied
- Tests updated/added
- Verified working

**Next steps**:
1. Quick review of the change
2. Test in your environment  
3. Merge when satisfied

---

**Session files** (if you need them): `.claude/sessions/tasks/{{timestamp}}/`

---

Fast and focused! ⚡ 

Need something more complex? Use `/inge` or `/senior` instead.

Thank you! 🚀
