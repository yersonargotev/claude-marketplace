---
description: "General-purpose excellence workflow - Think Different, question assumptions, craft solutions with obsessive attention to detail"
argument-hint: "Describe what you want to build, fix, or improve"
allowed-tools: Task
---

# Excellence Craftsman

**Welcome to the Craft Command** - Where we don't just write code, we craft solutions.

This isn't about the first solution that works. This is about:

1. 🤔 **Discover** - Deep understanding of the real problem
2. ✅ **Validate** - Ensure we have what we need
3. 💡 **Envision** - Generate 2-4 ambitious but feasible approaches
4. ⚖️ **Feasibility** - Validate ideas are achievable
5. 🎯 **Select** - You choose the best path
6. 🏗️ **Design** - Detailed architecture with extended thinking
7. ⏸️ **Approve** - You review and approve the plan
8. 🎨 **Craft** - Obsessive implementation with TDD
9. 🛡️ **Guard** - Quality validation
10. 📝 **Document** - Permanent knowledge base

This workflow embodies the "Think Different" philosophy: **push boundaries, stay pragmatic, obsess over details, craft elegant solutions**.

---

## Challenge: $ARGUMENTS

---

## Phase 1: Discovery 🤔

**Understanding the real problem, not just the stated one...**

**Session Setup**

Generating unique session ID and creating session directory...

!SESSION_ID="craft_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/craft/$SESSION_ID"
!echo "✓ Session: $SESSION_ID"

---


<Task agent="investigator">
Session: $SESSION_ID
Directory: .claude/sessions/craft/$SESSION_ID
  $ARGUMENTS
  
  craft-analysis
</Task>

---

## Phase 2: Requirements Validation ✅

**Ensuring we have sufficient information to proceed...**

<Task agent="requirements-validator">
Session: $SESSION_ID
Directory: .claude/sessions/craft/$SESSION_ID
  .claude/sessions/craft/$SESSION_ID/context.md
</Task>

---

{If validation returns NEEDS_INFO, stop here and request clarification from user}

---

## Phase 3: Visionary Exploration 💡

**Generating ambitious but feasible approaches - thinking from first principles...**

<Task agent="visionary">
Session: $SESSION_ID
Directory: .claude/sessions/craft/$SESSION_ID
  .claude/sessions/craft/$SESSION_ID/context.md
  .claude/sessions/craft/$SESSION_ID/validation-report.md
</Task>

---

## Phase 4: Feasibility Validation ⚖️

**Validating that ambitious ideas are actually achievable...**

<Task agent="feasibility-validator">
Session: $SESSION_ID
Directory: .claude/sessions/craft/$SESSION_ID
  .claude/sessions/craft/$SESSION_ID/context.md
  .claude/sessions/craft/$SESSION_ID/alternatives.md
</Task>

---

## Phase 5: Approach Selection 🎯

**Review the vision and make your choice...**

**Visionary Approaches**: `.claude/sessions/craft/$SESSION_ID/alternatives.md`

**Feasibility Assessment**: `.claude/sessions/craft/$SESSION_ID/feasibility.md`

**Please select your preferred approach**:

- Type your selection (e.g., "Option B" or "B")
- Or request modifications/clarifications
- Or ask questions about trade-offs, risks, or feasibility

---

{Wait for user selection here. The conversation stops until user responds with their choice.}

---

## Phase 6: Architectural Design 🏗️

**Creating detailed implementation plan with extended thinking for: {USER_SELECTION}**

<Task agent="architect">
Session: $SESSION_ID
Directory: .claude/sessions/craft/$SESSION_ID
  .claude/sessions/craft/$SESSION_ID/context.md
  .claude/sessions/craft/$SESSION_ID/alternatives.md
  selected-option:{USER_SELECTION}
</Task>

---

## Phase 7: Plan Approval ⏸️

**Architecture ready for review**: `.claude/sessions/craft/$SESSION_ID/plan.md`

**Review Checklist**:

- [ ] Does the architecture align with selected approach?
- [ ] Are the design decisions sound?
- [ ] Are risks identified with mitigation strategies?
- [ ] Is the implementation path clear?
- [ ] Do success criteria make sense?
- [ ] Any concerns or modifications needed?

**What to do next**:

- ✅ **Approve**: Type "proceed", "approved", "go ahead", or "looks good"
- 🔄 **Request changes**: Describe what to modify
- 💬 **Ask questions**: Request clarification on any aspect
- ❌ **Stop**: Type "stop" or "cancel"

---

{Wait for user approval here. The conversation stops until user responds.}

---

## Phase 8: Craftsmanship Implementation 🎨

**CRAFTSMANSHIP PRINCIPLES ACTIVE**:

- 🎯 Names that sing (self-documenting code)
- 🧪 Test-driven development
- 🎭 Every edge case handled with grace
- ✂️ Surgical precision (minimal edits)
- 🚫 No explanatory comments (code explains itself)
- ♻️ Iterative refinement (good → great → insanely great)

Crafting with obsessive attention to detail...

<Task agent="craftsman">
Session: $SESSION_ID
Directory: .claude/sessions/craft/$SESSION_ID
  .claude/sessions/craft/$SESSION_ID/plan.md
  
  surgical
</Task>

---

## Phase 9: Quality Guardian 🛡️

**Final quality assurance and validation...**

<Task agent="auditor">
Session: $SESSION_ID
Directory: .claude/sessions/craft/$SESSION_ID
  .claude/sessions/craft/$SESSION_ID
  
  craft-verification
</Task>

---

## Phase 10: Documentation 📝

**Creating permanent knowledge base...**

<Task agent="documentation-writer">
Session: $SESSION_ID
Directory: .claude/sessions/craft/$SESSION_ID
  .claude/sessions/craft/$SESSION_ID
</Task>

---

## Craft Complete ✨

**Challenge Solved**: $ARGUMENTS

**Philosophy Applied**:

- ✅ Questioned assumptions and thought from first principles
- ✅ Generated multiple ambitious but feasible approaches
- ✅ Validated technical feasibility before commitment
- ✅ You selected the optimal path
- ✅ Crafted with obsessive attention to detail
- ✅ Every function name sings, every abstraction feels natural
- ✅ Comprehensive tests, graceful edge case handling
- ✅ Quality validated, documentation created

**Session Artifacts**: `.claude/sessions/craft/$SESSION_ID/`

- `context.md` - Problem analysis and discovery
- `validation-report.md` - Requirements validation
- `alternatives.md` - Visionary approaches explored
- `feasibility.md` - Technical feasibility assessment
- `plan.md` - Implementation plan with architecture
- `progress.md` - Implementation log with decisions
- `quality.md` - Quality assurance report

**Documentation**: `./documentacion/{YYYYMMDD}-{name}.md`

**Commits**: Check `git log` for atomic, descriptive commits

**Next Steps**:

1. Review all session artifacts
2. Test thoroughly in your environment
3. Celebrate the craftsmanship
4. Merge when ready

---

**Note**: This wasn't about speed—it was about excellence. We thought different, pushed boundaries (while staying grounded), and crafted a solution that feels inevitable. 🎯

*"Perfection is achieved not when there is nothing left to add, but when there is nothing left to take away." — Antoine de Saint-Exupéry*

Thank you for using the Craft command! 🚀

