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
  $ARGUMENTS
</Task>

---

## Research Complete ✓

Now let me think deeply about the best approach...

<Task agent="architect">
  .claude/sessions/build/$CLAUDE_SESSION_ID/context.md
</Task>

---

## Plan Ready - Awaiting Your Approval ⏸️

**Please review the plan**: `.claude/sessions/build/$CLAUDE_SESSION_ID/plan.md`

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
  .claude/sessions/build/$CLAUDE_SESSION_ID/plan.md
</Task>

---

## Implementation Complete ✓

Now validating the work...

<Task agent="validator">
  .claude/sessions/build/$CLAUDE_SESSION_ID/progress.md
</Task>

---

## Testing Complete ✓

Final code review...

<Task agent="auditor">
  .claude/sessions/build/$CLAUDE_SESSION_ID
</Task>

---

## Task Complete ✅

**Summary**: $ARGUMENTS

**Session artifacts** saved in: `.claude/sessions/build/$CLAUDE_SESSION_ID/`

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
