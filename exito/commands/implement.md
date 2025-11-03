---
description: "Fast implementation workflow: research, plan, and implement without formal testing or review phases. Use for rapid prototyping or when you'll handle validation manually."
argument-hint: "Describe the feature or change to implement"
allowed-tools: Task, Bash(*)
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

Session directory: .claude/sessions/implement/$CLAUDE_SESSION_ID

Your goals:

1. Map relevant codebase areas
2. Identify existing patterns and conventions
3. Assess complexity and dependencies
4. Find similar implementations for reference
5. Flag potential risks or constraints

Output your findings to: .claude/sessions/implement/$CLAUDE_SESSION_ID/context.md
</Task>

---

## Research Complete ✓

Now designing the solution...

<Task agent="architect">
  Design a solution plan for: $ARGUMENTS

Session directory: .claude/sessions/implement/$CLAUDE_SESSION_ID

Input: .claude/sessions/implement/$CLAUDE_SESSION_ID/context.md

**FAST MODE** - We're prioritizing speed:

1. Use "think" (not "think harder" or "ULTRATHINK") - quick analysis only
2. Skip Mermaid diagrams unless complexity is HIGH
3. Evaluate 2-3 approaches (not exhaustive)
4. Keep plan concise and actionable (target < 100 lines)
5. Choose the best solution with clear reasoning
6. Create step-by-step implementation plan
7. Identify key risks
8. Define success criteria

We're moving fast - focus on clarity and speed over depth.

Output your plan to: .claude/sessions/implement/$CLAUDE_SESSION_ID/plan.md

Return with: ⏸️ AWAITING USER APPROVAL BEFORE IMPLEMENTATION
</Task>

---

## Plan Ready - Awaiting Your Approval ⏸️

**Please review the plan**: `.claude/sessions/implement/$CLAUDE_SESSION_ID/plan.md`

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

Session directory: .claude/sessions/implement/$CLAUDE_SESSION_ID

Inputs:

- Context: .claude/sessions/implement/$CLAUDE_SESSION_ID/context.md
- Plan: .claude/sessions/implement/$CLAUDE_SESSION_ID/plan.md

Your goals:

1. Follow the plan step-by-step
2. Make atomic, well-described commits
3. Track progress in real-time
4. Handle obvious errors gracefully

Focus on speed - skip writing comprehensive tests.

Output progress to: .claude/sessions/implement/$CLAUDE_SESSION_ID/progress.md

Return when: All steps completed
</Task>

---

## Implementation Complete ✅

**Summary**: $ARGUMENTS

**Session artifacts** saved in: `.claude/sessions/implement/$CLAUDE_SESSION_ID/`

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
