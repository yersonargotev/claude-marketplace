---
description: "Systematic problem-solving workflow with multiple solution exploration and surgical implementation"
argument-hint: "Describe the problem to solve"
allowed-tools: Task
---

# Systematic Workflow Engineer

**Welcome!** I solve problems following a rigorous 7-phase workflow:

1. 🔍 **Discover** - Deep context gathering
2. ✅ **Validate** - Ensure sufficient information
3. 🧠 **Explore** - Generate 2-4 solution alternatives
4. 🎯 **Select** - You choose the best approach
5. 📋 **Plan** - Detailed implementation roadmap
6. ⏸️ **Approve** - You review and approve plan
7. ✂️ **Execute** - Surgical implementation (minimal edits, no comments)
8. 🧪 **Test** - Comprehensive validation
9. 👀 **Review** - Quality assurance
10. 📝 **Document** - Knowledge base creation

This workflow emphasizes **exploration before commitment** and **precision over speed**.

---

## Problem: $ARGUMENTS

---

## Phase 1: Discovery & Analysis 🔍

Gathering comprehensive context...

**Session Setup**

Generating unique session ID and creating session directory...

!SESSION_ID="workflow_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/workflow/$SESSION_ID"
!echo "✓ Session: $SESSION_ID"

---


<Task agent="investigator">
Session: $SESSION_ID
Directory: .claude/sessions/workflow/$SESSION_ID
  $ARGUMENTS

  workflow-analysis
</Task>

---

## Phase 2: Requirements Validation ✅

Validating information completeness...

<Task agent="requirements-validator">
Session: $SESSION_ID
Directory: .claude/sessions/workflow/$SESSION_ID
  .claude/sessions/workflow/$SESSION_ID/context.md
</Task>

---

{If validation returns NEEDS_INFO, stop here and request clarification from user}

---

## Phase 3: Solution Exploration 🧠

Generating multiple solution alternatives...

<Task agent="solution-explorer">
Session: $SESSION_ID
Directory: .claude/sessions/workflow/$SESSION_ID
  .claude/sessions/workflow/$SESSION_ID/context.md
  .claude/sessions/workflow/$SESSION_ID/validation-report.md
</Task>

---

## Phase 4: Solution Selection 🎯

**Review alternatives**: `.claude/sessions/workflow/$SESSION_ID/alternatives.md`

**Please select your preferred approach**:

- Type your selection (e.g., "Option B" or "B")
- Or request modifications/clarifications
- Or ask questions about trade-offs

---

{Wait for user selection here. The conversation stops until user responds with their choice.}

---

## Phase 5: Detailed Planning 📋

Creating implementation plan for: **{USER_SELECTION}**

<Task agent="architect">
Session: $SESSION_ID
Directory: .claude/sessions/workflow/$SESSION_ID
  .claude/sessions/workflow/$SESSION_ID/context.md
  .claude/sessions/workflow/$SESSION_ID/alternatives.md
  selected-option:{USER_SELECTION}
</Task>

---

## Phase 6: Plan Approval ⏸️

**Plan ready for review**: `.claude/sessions/workflow/$SESSION_ID/plan.md`

**Review Checklist**:

- [ ] Does the approach align with selected option?
- [ ] Are steps clear and logical?
- [ ] Any concerns about risks?
- [ ] Are success criteria appropriate?
- [ ] Do you want any modifications?

**What to do next**:

- ✅ **Approve**: Type "proceed", "approved", "go ahead", or "looks good"
- 🔄 **Request changes**: Describe what to modify
- 💬 **Ask questions**: Request clarification
- ❌ **Stop**: Type "stop" or "cancel"

---

{Wait for user approval here. The conversation stops until user responds.}

---

## Phase 7: Surgical Implementation ✂️

**IMPLEMENTATION CONSTRAINTS ACTIVE**:

- ✂️ Minimal edits only (surgical precision)
- 🚫 No code comments (self-documenting code required)
- 🎯 Prefer Edit over Write tool

Executing with precision...

<Task agent="surgical-builder">
Session: $SESSION_ID
Directory: .claude/sessions/workflow/$SESSION_ID
  .claude/sessions/workflow/$SESSION_ID/plan.md

  surgical
</Task>

---

## Phase 8: Testing & Validation 🧪

Running comprehensive tests...

<Task agent="validator">
Session: $SESSION_ID
Directory: .claude/sessions/workflow/$SESSION_ID
  .claude/sessions/workflow/$SESSION_ID/progress.md
</Task>

---

## Phase 9: Code Review 👀

Final quality assurance...

<Task agent="auditor">
Session: $SESSION_ID
Directory: .claude/sessions/workflow/$SESSION_ID
  .claude/sessions/workflow/$SESSION_ID

  workflow-verification
</Task>

---

## Phase 10: Documentation 📝

Creating permanent knowledge base documentation...

<Task agent="documentation-writer">
Session: $SESSION_ID
Directory: .claude/sessions/workflow/$SESSION_ID
  .claude/sessions/workflow/$SESSION_ID
</Task>

---

## Workflow Complete ✅

**Problem Solved**: $ARGUMENTS

**Workflow Summary**:

- ✅ Context gathered and validated
- ✅ Multiple alternatives explored
- ✅ Solution selected by you
- ✅ Plan approved by you
- ✅ Implementation executed with surgical precision
- ✅ Tests passed
- ✅ Code review approved
- ✅ Documentation created

**Session Artifacts**: `.claude/sessions/workflow/$SESSION_ID/`

- `context.md` - Problem analysis
- `validation-report.md` - Requirements validation
- `alternatives.md` - Solution options explored
- `plan.md` - Implementation plan
- `progress.md` - Implementation log
- `test_report.md` - Test results
- `review.md` - Code review

**Documentation**: `./documentacion/{YYYYMMDD}-{name}.md`

**Commits**: Check `git log` for atomic, descriptive commits

**Next Steps**:

1. Review all artifacts
2. Test in your environment
3. Merge when ready

---

**Note**: This workflow prioritized exploration (multiple options) and precision (surgical edits, no comments) over speed. 🎯

Thank you for using the systematic workflow! 🚀
