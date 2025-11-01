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

<Task agent="investigator">
  Analyze the codebase and gather deep context for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Your goals:
  1. Map all relevant codebase areas
  2. Identify existing patterns and conventions
  3. Assess complexity and dependencies
  4. Find similar implementations for reference
  5. Flag potential risks and constraints
  6. Document edge cases

  Output comprehensive findings to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
</Task>

---

## Phase 2: Requirements Validation ✅

Validating information completeness...

<Task agent="requirements-validator">
  Validate that sufficient context has been gathered for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID
  Context file: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md

  Your goals:
  1. Check context against completeness checklist
  2. Identify any missing critical information
  3. Generate validation report
  4. Recommend PROCEED or REQUEST_CLARIFICATION

  Output validation report to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/validation-report.md

  Return status and any missing information needed.
</Task>

---

{If validation returns NEEDS_INFO, stop here and request clarification from user}

---

## Phase 3: Solution Exploration 🧠

Generating multiple solution alternatives...

<Task agent="solution-explorer">
  Generate 2-4 alternative solutions for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Inputs:
  - Context: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
  - Validation: .claude/sessions/tasks/$CLAUDE_SESSION_ID/validation-report.md

  Your goals:
  1. Generate 2-4 distinct approaches
  2. Analyze pros/cons for each
  3. Assess complexity and risk levels
  4. Estimate implementation time
  5. Recommend a preferred option (but user decides)

  Output alternatives to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/alternatives.md

  Return summary of alternatives for user review.
</Task>

---

## Phase 4: Solution Selection 🎯

**Review alternatives**: `.claude/sessions/tasks/$CLAUDE_SESSION_ID/alternatives.md`

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
  Design detailed implementation plan for selected option: {USER_SELECTION}

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Inputs:
  - Context: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
  - Alternatives: .claude/sessions/tasks/$CLAUDE_SESSION_ID/alternatives.md
  - Selected: {USER_SELECTION}

  Your goals:
  1. Create step-by-step implementation plan for chosen approach
  2. Break down into atomic, testable steps
  3. Identify dependencies and execution order
  4. Define success criteria for each step
  5. Document risks and mitigation strategies

  Output plan to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md

  Return with: ⏸️ AWAITING USER APPROVAL BEFORE IMPLEMENTATION
</Task>

---

## Phase 6: Plan Approval ⏸️

**Plan ready for review**: `.claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md`

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
  Execute the implementation plan for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Inputs:
  - Context: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
  - Plan: .claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md
  - Selected Option: {USER_SELECTION}

  Your goals:
  1. Follow the plan step-by-step with SURGICAL PRECISION
  2. Make MINIMAL edits - change only what's necessary
  3. Write ZERO inline comments - use self-documenting code
  4. Prefer Edit tool over Write tool (targeted changes)
  5. Make atomic commits with clear messages
  6. Track progress in real-time
  7. Handle errors gracefully

  CRITICAL CONSTRAINTS:
  - ❌ NO code comments allowed
  - ✂️ SURGICAL edits only (no refactoring scope creep)
  - 🎯 Prefer modifying existing files over creating new ones

  Output progress to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/progress.md

  Return when: All steps completed successfully
</Task>

---

## Phase 8: Testing & Validation 🧪

Running comprehensive tests...

<Task agent="validator">
  Validate the implementation for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Inputs:
  - Context: .claude/sessions/tasks/$CLAUDE_SESSION_ID/context.md
  - Plan: .claude/sessions/tasks/$CLAUDE_SESSION_ID/plan.md
  - Progress: .claude/sessions/tasks/$CLAUDE_SESSION_ID/progress.md

  Your goals:
  1. Run all automated tests (unit, integration, e2e)
  2. Verify test coverage (>80% for new/modified code)
  3. Perform manual testing checklist
  4. Test edge cases and error scenarios
  5. Check performance if applicable

  Output test results to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/test_report.md

  Return when: All tests pass and coverage is adequate
</Task>

---

## Phase 9: Code Review 👀

Final quality assurance...

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
  2. Verify self-documenting code (no comments present)
  3. Check that changes were surgical (minimal scope)
  4. Validate architecture and design patterns
  5. Assess security best practices
  6. Verify test coverage and quality

  WORKFLOW-SPECIFIC CHECKS:
  - ✅ Confirm zero inline comments in code
  - ✅ Verify minimal file modifications
  - ✅ Check Edit tool usage over Write tool

  Output review to: .claude/sessions/tasks/$CLAUDE_SESSION_ID/review.md

  Return verdict: APPROVE / APPROVE WITH NOTES / REQUEST CHANGES
</Task>

---

## Phase 10: Documentation 📝

Creating permanent knowledge base documentation...

<Task agent="documentation-writer">
  Create comprehensive documentation for: $ARGUMENTS

  Session directory: .claude/sessions/tasks/$CLAUDE_SESSION_ID

  Your goals:
  1. Read all session artifacts (context, alternatives, plan, progress, tests, review)
  2. Synthesize into comprehensive documentation
  3. Save to `./documentacion/{YYYYMMDD}-{brief-name}.md`
  4. Include executive summary, alternatives considered, implementation details, lessons learned

  Output documentation to: `./documentacion/`

  Return location of created documentation file.
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

**Session Artifacts**: `.claude/sessions/tasks/$CLAUDE_SESSION_ID/`
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
