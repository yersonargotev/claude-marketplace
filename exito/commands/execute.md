---
description: "Fast implementation workflow with multiple solution exploration and surgical implementation"
argument-hint: "Describe the problem to solve"
allowed-tools: Task
---

# Fast Execution Workflow Engineer

**Welcome!** I solve problems following a streamlined 8-phase workflow:

1. 🔍 **Discover** - Deep context gathering
2. ✅ **Validate** - Ensure sufficient information
3. 🧠 **Explore** - Generate 2-4 solution alternatives
4. 🎯 **Select** - You choose the best approach
5. 📋 **Plan** - Detailed implementation roadmap
6. ⏸️ **Approve** - You review and approve plan
7. ✂️ **Execute** - Surgical implementation (minimal edits, no comments)
8. 📝 **Document** - Knowledge base creation

⚠️ **Note**: This workflow skips automated testing and code review phases for speed. You should manually test and review the implementation after completion.

This workflow emphasizes **exploration before commitment** and **precision over speed**.

---

## Problem: $ARGUMENTS

---

## Phase 1: Discovery & Analysis 🔍

Gathering comprehensive context...

<Task agent="investigator">
  $ARGUMENTS

  workflow-analysis
</Task>

---

## Phase 2: Requirements Validation ✅

Validating information completeness...

<Task agent="requirements-validator">
  .claude/sessions/execute/$CLAUDE_SESSION_ID/context.md
</Task>

---

{If validation returns NEEDS_INFO, stop here and request clarification from user}

---

## Phase 3: Solution Exploration 🧠

Generating multiple solution alternatives...

<Task agent="solution-explorer">
  .claude/sessions/execute/$CLAUDE_SESSION_ID/context.md
  .claude/sessions/execute/$CLAUDE_SESSION_ID/validation-report.md
</Task>

---

## Phase 4: Solution Selection 🎯

**Review alternatives**: `.claude/sessions/execute/$CLAUDE_SESSION_ID/alternatives.md`

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
  .claude/sessions/execute/$CLAUDE_SESSION_ID/context.md
  .claude/sessions/execute/$CLAUDE_SESSION_ID/alternatives.md
  selected-option:{USER_SELECTION}
</Task>

---

## Phase 6: Plan Approval ⏸️

**Plan ready for review**: `.claude/sessions/execute/$CLAUDE_SESSION_ID/plan.md`

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
  .claude/sessions/execute/$CLAUDE_SESSION_ID/plan.md

  surgical
</Task>

---

## Phase 8: Documentation 📝

Creating permanent knowledge base documentation...

<Task agent="documentation-writer">
  .claude/sessions/execute/$CLAUDE_SESSION_ID
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
- ✅ Documentation created

⚠️ **Important - Next Steps Required**:

This workflow skipped automated testing and code review for speed. **You should now**:

1. ✅ **Manual Testing**: Test the implementation thoroughly
2. 👀 **Code Review**: Review code quality, security, and performance
3. 🧪 **Run Tests**: Execute existing test suites if available
4. 📊 **Edge Cases**: Verify edge cases and error handling
5. 🔒 **Security**: Check for vulnerabilities (XSS, SQL injection, etc.)

**Session Artifacts**: `.claude/sessions/execute/$CLAUDE_SESSION_ID/`

- `context.md` - Problem analysis
- `validation-report.md` - Requirements validation
- `alternatives.md` - Solution options explored
- `plan.md` - Implementation plan
- `progress.md` - Implementation log

**Documentation**: `./documentacion/{YYYYMMDD}-{name}.md`

**Commits**: Check `git log` for atomic, descriptive commits

---

**Note**: This workflow prioritized exploration (multiple options) and speed (no automated validation) over comprehensive testing. Manual validation is required before merging. 🎯

Thank you for using the fast execution workflow! 🚀
