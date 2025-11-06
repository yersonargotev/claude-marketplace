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

**Session Setup**

Generating unique session ID and creating session directory...

!SESSION_ID="build_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/build/$SESSION_ID"
!echo "✓ Session: $SESSION_ID"

---

Let me start by understanding what we're working with...

<Task agent="investigator">
Task: $ARGUMENTS
Session: $SESSION_ID
Directory: .claude/sessions/build/$SESSION_ID
</Task>

---

## Research Complete ✓

Now let me think deeply about the best approach...

<Task agent="architect">
Context: .claude/sessions/build/$SESSION_ID/context.md
Session: $SESSION_ID
Directory: .claude/sessions/build/$SESSION_ID
</Task>

---

## Plan Ready - Awaiting Your Approval ⏸️

**Please review the plan**: `.claude/sessions/build/$SESSION_ID/plan.md`

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
Plan: .claude/sessions/build/$SESSION_ID/plan.md
Session: $SESSION_ID
Directory: .claude/sessions/build/$SESSION_ID
</Task>

---

## Implementation Complete ✓

Now validating the work...

<Task agent="validator">
Progress: .claude/sessions/build/$SESSION_ID/progress.md
Session: $SESSION_ID
Directory: .claude/sessions/build/$SESSION_ID
</Task>

---

## Testing Complete ✓

Final code review...

<Task agent="auditor">
Session Directory: .claude/sessions/build/$SESSION_ID
Session: $SESSION_ID
</Task>

---

## Task Complete ✅

**Summary**: $ARGUMENTS

**Session artifacts** saved in: `.claude/sessions/build/$SESSION_ID/`

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
