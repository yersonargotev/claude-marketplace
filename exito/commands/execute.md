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
  Analyze the codebase and gather deep context for: $ARGUMENTS

Session directory: .claude/sessions/execute/$CLAUDE_SESSION_ID

Your goals:

1. Map all relevant codebase areas
2. Identify existing patterns and conventions
3. Assess complexity and dependencies
4. Find similar implementations for reference
5. Flag potential risks and constraints
6. Document edge cases

Output comprehensive findings to: .claude/sessions/execute/$CLAUDE_SESSION_ID/context.md
</Task>

---

## Phase 2: Requirements Validation ✅

Validating information completeness...

<Task agent="requirements-validator">
  Validate that sufficient context has been gathered for: $ARGUMENTS

Session directory: .claude/sessions/execute/$CLAUDE_SESSION_ID
  Context file: .claude/sessions/execute/$CLAUDE_SESSION_ID/context.md

Your goals:

1. Check context against completeness checklist
2. Identify any missing critical information
3. Generate validation report
4. Recommend PROCEED or REQUEST_CLARIFICATION

Output validation report to: .claude/sessions/execute/$CLAUDE_SESSION_ID/validation-report.md

Return status and any missing information needed.
</Task>

---

{If validation returns NEEDS_INFO, stop here and request clarification from user}

---

## Phase 3: Solution Exploration 🧠

Generating multiple solution alternatives...

<Task agent="solution-explorer">
  Generate 2-4 alternative solutions for: $ARGUMENTS

Session directory: .claude/sessions/execute/$CLAUDE_SESSION_ID

Inputs:

- Context: .claude/sessions/execute/$CLAUDE_SESSION_ID/context.md
- Validation: .claude/sessions/execute/$CLAUDE_SESSION_ID/validation-report.md

Your goals:

1. Generate 2-4 distinct approaches
2. Analyze pros/cons for each
3. Assess complexity and risk levels
4. Estimate implementation time
5. Recommend a preferred option (but user decides)

Output alternatives to: .claude/sessions/execute/$CLAUDE_SESSION_ID/alternatives.md

Return summary of alternatives for user review.
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
  Design detailed implementation plan for selected option: {USER_SELECTION}

Session directory: .claude/sessions/execute/$CLAUDE_SESSION_ID

Inputs:

- Context: .claude/sessions/execute/$CLAUDE_SESSION_ID/context.md
- Alternatives: .claude/sessions/execute/$CLAUDE_SESSION_ID/alternatives.md
- Selected: {USER_SELECTION}

Your goals:

1. Create step-by-step implementation plan for chosen approach
2. Break down into atomic, testable steps
3. Identify dependencies and execution order
4. Define success criteria for each step
5. Document risks and mitigation strategies

Output plan to: .claude/sessions/execute/$CLAUDE_SESSION_ID/plan.md

Return with: ⏸️ AWAITING USER APPROVAL BEFORE IMPLEMENTATION
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
  Execute the implementation plan for: $ARGUMENTS

Session directory: .claude/sessions/execute/$CLAUDE_SESSION_ID

Inputs:

- Context: .claude/sessions/execute/$CLAUDE_SESSION_ID/context.md
- Plan: .claude/sessions/execute/$CLAUDE_SESSION_ID/plan.md
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

Output progress to: .claude/sessions/execute/$CLAUDE_SESSION_ID/progress.md

Return when: All steps completed successfully
</Task>

---

## Phase 8: Documentation 📝

Creating permanent knowledge base documentation...

<Task agent="documentation-writer">
  Create comprehensive documentation for: $ARGUMENTS

Session directory: .claude/sessions/execute/$CLAUDE_SESSION_ID

Your goals:

1. Read all session artifacts (context, alternatives, plan, progress)
2. Synthesize into comprehensive documentation
3. Save to `./documentacion/{YYYYMMDD}-{brief-name}.md`
4. Include executive summary, alternatives considered, implementation details, lessons learned

Note: This workflow skipped testing and review phases. Document this limitation.

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
