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

For those, use `/build` or `/think` instead.

---

## Quick Fix: $ARGUMENTS

Gathering necessary context...

**Session Setup**

Generating unique session ID and creating session directory...

!SESSION_ID="patch_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/patch/$SESSION_ID"
!echo "✓ Session: $SESSION_ID"

---


<Task agent="investigator" model="haiku">
  $ARGUMENTS

  fast-mode
  .claude/sessions/patch/$SESSION_ID
</Task>

---

## Context Gathered ✓

Quick solution analysis...

<Task agent="architect" model="haiku">
  .claude/sessions/patch/$SESSION_ID/context.md

  quick-fix
</Task>

---

## Implementing the fix ✓

<Task agent="builder" model="haiku">
  .claude/sessions/patch/$SESSION_ID/plan.md

  quick-fix
</Task>

---

## Testing the fix ✓

<Task agent="validator" model="haiku">
  .claude/sessions/patch/$SESSION_ID/progress.md

  quick-validation
</Task>

---

## Quick Fix Complete ✅

**Fixed**: $ARGUMENTS

**Change summary**: Check `.claude/sessions/patch/$SESSION_ID/progress.md`

**Tests**: Check `.claude/sessions/patch/$SESSION_ID/test_report.md`

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

**Session files** (if you need them): `.claude/sessions/patch/$SESSION_ID/`

---

Fast and focused! ⚡

Need something more complex? Use `/build` or `/think` instead.

Thank you! 🚀
