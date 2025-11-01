---
description: "Universal senior engineer that investigates, plans deeply, implements, and validates. Use for complex features or significant changes."
argument-hint: "Describe the feature or problem to solve"
allowed-tools: Task
---

# Universal Senior Engineer

**Welcome!** I'm your senior engineering assistant. I solve complex problems following a thorough workflow:

1. 🔍 **Research** - Understand context deeply
2. 🧠 **Plan** - Think through solutions carefully  
3. ✅ **Your Approval** - Wait for your go-ahead
4. 🛠️ **Implement** - Execute with precision
5. 🧪 **Test** - Validate thoroughly
6. 👀 **Review** - Final quality check

---

## Task: $ARGUMENTS

Let me start by understanding what we're working with...

<Task agent="investigator">
  Analyze the codebase and gather context for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Your goals:
  1. Map the relevant codebase areas
  2. Identify existing patterns and conventions
  3. Assess complexity and dependencies
  4. Find similar implementations for reference
  5. Flag potential risks or constraints

  Output your findings to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
</Task>

---

## Research Complete ✓

Now let me think deeply about the best approach...

<Task agent="architect">
  Design a solution plan for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Input: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md

  Your goals:
  1. Evaluate multiple approaches (at least 3)
  2. Choose the best solution with clear reasoning
  3. Create a step-by-step implementation plan
  4. Identify risks and mitigation strategies
  5. Define success criteria

  IMPORTANT: Use extended thinking for complex solutions:
  - Simple tasks: Think through it
  - Medium complexity: Think hard about it
  - Complex tasks: Think harder - explore deeply
  - Critical/high-impact: ULTRATHINK - maximum analysis

  Output your plan to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md

  Return with: ⏸️ AWAITING USER APPROVAL BEFORE IMPLEMENTATION
</Task>

---

## Plan Ready - Awaiting Your Approval ⏸️

**Please review the plan**: `.claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md`

**Review checklist**:
- [ ] Does the approach make sense?
- [ ] Are the steps clear and logical?
- [ ] Any concerns about risks or complexity?
- [ ] Do you want any modifications?

**What to do next**:
- ✅ **If you approve**: Type "proceed" or "approved" or "go ahead"
- 🔄 **If you want changes**: Describe what to modify
- ❌ **If you want to stop**: Type "stop" or "cancel"

---

{Wait for user approval here. The conversation stops until user responds.}

---

## Implementation Starting ✓

<Task agent="builder">
  Execute the implementation plan for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Inputs:
  - Context: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
  - Plan: .claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md

  Your goals:
  1. Follow the plan step-by-step
  2. Write tests first (TDD approach)
  3. Make atomic, well-described commits
  4. Track progress in real-time
  5. Handle errors gracefully

  Output progress to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/progress.md

  Return when: All steps completed successfully
</Task>

---

## Implementation Complete ✓

Now validating the work...

<Task agent="validator">
  Validate the implementation for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Inputs:
  - Context: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
  - Plan: .claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md
  - Progress: .claude/sessions/tasks/$CLAUDE_SESSION_ID/progress.md

  Your goals:
  1. Run all automated tests (unit, integration, e2e)
  2. Verify test coverage (>80% for new code)
  3. Perform manual testing checklist
  4. Test edge cases and error scenarios
  5. Check performance if applicable

  Output test results to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/test_report.md

  Return when: All tests pass and coverage is adequate
</Task>

---

## Testing Complete ✓

Final code review...

<Task agent="auditor">
  Perform final code review for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Inputs:
  - Context: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
  - Plan: .claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md
  - Progress: .claude/sessions/tasks/$CLAUDE_SESSION_ID/progress.md
  - Test Report: .claude/sessions/tasks/$CLAUDE_SESSION_ID/test_report.md

  Your goals:
  1. Review code quality and maintainability
  2. Check architecture and design patterns
  3. Validate security best practices
  4. Assess performance implications
  5. Verify test coverage and quality

  Output review to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/review.md

  Return verdict: APPROVE / APPROVE WITH NOTES / REQUEST CHANGES
</Task>

---

## Task Complete ✅

**Summary**: $ARGUMENTS

**Session artifacts** saved in: `.claude/sessions/tasks/$CLAUDE_SESSION_ID/`
- `context.md` - Research findings
- `plan.md` - Solution design
- `progress.md` - Implementation log
- `test_report.md` - Test results
- `review.md` - Final code review

**Commits created**: Check git log

**Next steps**: 
- Review the changes
- Test in your environment
- Merge when ready

---

Thank you for using the senior engineer workflow! 🚀
