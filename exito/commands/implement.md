---
description: "Fast implementation workflow: research, plan, and implement without formal testing or review phases. Use for rapid prototyping or when you'll handle validation manually."
argument-hint: "Describe the feature or change to implement"
allowed-tools: Task
---

# Fast Implementation Engineer

**Welcome!** I'm your fast implementation assistant. I follow a streamlined workflow:

1. 🔍 **Research** - Understand context
2. 🧠 **Plan** - Design solution
3. ✅ **Your Approval** - Wait for go-ahead
4. 🛠️ **Implement** - Execute quickly

**Note**: This workflow skips formal testing and code review phases. Use when you need speed or will validate manually.

---

## Task: $ARGUMENTS

Let me start by understanding the context...

<Task agent="investigator">
  Analyze the codebase and gather context for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Your goals:
  1. Map relevant codebase areas
  2. Identify existing patterns and conventions
  3. Assess complexity and dependencies
  4. Find similar implementations for reference
  5. Flag potential risks or constraints

  Output your findings to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
</Task>

---

## Research Complete ✓

Now designing the solution...

<Task agent="architect">
  Design a solution plan for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Input: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md

  Your goals:
  1. Evaluate multiple approaches (at least 2-3)
  2. Choose the best solution with clear reasoning
  3. Create a step-by-step implementation plan
  4. Identify key risks
  5. Define success criteria

  Keep the plan concise and actionable - we're moving fast.

  Output your plan to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md

  Return with: ⏸️ AWAITING USER APPROVAL BEFORE IMPLEMENTATION
</Task>

---

## Plan Ready - Awaiting Your Approval ⏸️

**Please review the plan**: `.claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md`

**Quick checklist**:
- [ ] Does the approach make sense?
- [ ] Are the steps clear?
- [ ] Any concerns about risks?

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
  2. Make atomic, well-described commits
  3. Track progress in real-time
  4. Handle obvious errors gracefully

  Focus on speed - skip writing comprehensive tests.

  Output progress to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/progress.md

  Return when: All steps completed
</Task>

---

## Implementation Complete ✅

**Summary**: $ARGUMENTS

**Session artifacts** saved in: `.claude/sessions/tasks/$CLAUDE_SESSION_ID/`
- `context.md` - Research findings
- `plan.md` - Solution design
- `progress.md` - Implementation log

**Commits created**: Check git log

**⚠️ Important - Next Steps**:
- **Manual testing recommended** - This workflow skipped automated tests
- **Code review suggested** - No formal review was performed
- Test the changes in your environment
- Consider running test suite manually if applicable
- Review the code before merging to main

**When to use formal workflow instead**:
- Production-critical features → Use `/build`
- Complex refactoring → Use `/build`
- Security-sensitive code → Use `/build`
- Need test coverage → Use `/build`

---

Thank you for using fast implementation mode! 🚀
