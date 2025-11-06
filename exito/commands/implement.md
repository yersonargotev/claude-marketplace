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

**Session Setup**

Generating unique session ID and creating session directory...

!SESSION_ID="implement_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/implement/$SESSION_ID"
!echo "✓ Session: $SESSION_ID"

---


<Task agent="investigator">
Session: $SESSION_ID
Directory: .claude/sessions/implement/$SESSION_ID
  $ARGUMENTS

  fast-mode
</Task>

---

## Research Complete ✓

Now designing the solution...

<Task agent="architect">
Session: $SESSION_ID
Directory: .claude/sessions/implement/$SESSION_ID
  .claude/sessions/implement/$SESSION_ID/context.md

  fast-planning
</Task>

---

## Plan Ready - Awaiting Your Approval ⏸️

**Please review the plan**: `.claude/sessions/implement/$SESSION_ID/plan.md`

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
Session: $SESSION_ID
Directory: .claude/sessions/implement/$SESSION_ID
  .claude/sessions/implement/$SESSION_ID/plan.md

  fast-mode
</Task>

---

## Implementation Complete ✅

**Summary**: $ARGUMENTS

**Session artifacts** saved in: `.claude/sessions/implement/$SESSION_ID/`

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
