---
description: "Quality-focused refactoring - analyze existing code with fresh eyes, identify elegant improvements, craft polished solutions"
argument-hint: "Describe the code to refine or improvement goal"
allowed-tools: Task
---

# Code Refinement Master

**Welcome to the Refine Command** - Where good code becomes great code.

This isn't about adding features. This is about making existing code more:

- **Elegant** - Patterns that feel inevitable
- **Simple** - Complexity removed, not hidden
- **Clear** - Names that sing, intent that's obvious
- **Maintainable** - Easy to understand and extend

The workflow:

1. 🔍 **Analyze** - Deep understanding of current code
2. 🎨 **Philosophy** - Identify opportunities for elegance
3. 💡 **Envision** - Generate 2-4 elegant refactoring approaches
4. ⚖️ **Feasibility** - Validate improvements are achievable
5. 🎯 **Select** - You choose the refinement path
6. 🏗️ **Design** - Detailed refactoring plan
7. ⏸️ **Approve** - You review and approve
8. ✨ **Polish** - Implement refined, elegant solution
9. 🛡️ **Guard** - Quality validation
10. 📝 **Document** - Knowledge preservation

This workflow asks: **"What would be elegant here?"** and **"What can we remove?"**

---

## Code to Refine: $ARGUMENTS

---

## Phase 1: Code Analysis 🔍

**Understanding current code deeply - what it does, why it exists, where it's going...**

**Session Setup**

Generating unique session ID and creating session directory...

!SESSION_ID="refine_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/refine/$SESSION_ID"
!echo "✓ Session: $SESSION_ID"

---


<Task agent="investigator">
Session: $SESSION_ID
Directory: .claude/sessions/refine/$SESSION_ID
  $ARGUMENTS
  
  refine-analysis
</Task>

---

## Phase 2: Design Philosophy 🎨

**Looking at code with fresh eyes - identifying opportunities for elegance...**

<Task agent="design-philosopher">
Session: $SESSION_ID
Directory: .claude/sessions/refine/$SESSION_ID
  .claude/sessions/refine/$SESSION_ID/context.md
  all
</Task>

---

## Phase 3: Visionary Refactoring 💡

**Generating elegant refactoring approaches...**

<Task agent="visionary">
Session: $SESSION_ID
Directory: .claude/sessions/refine/$SESSION_ID
  .claude/sessions/refine/$SESSION_ID/context.md
  .claude/sessions/refine/$SESSION_ID/philosophy.md
</Task>

---

## Phase 4: Feasibility Validation ⚖️

**Validating that refactoring is safe and achievable...**

<Task agent="feasibility-validator">
Session: $SESSION_ID
Directory: .claude/sessions/refine/$SESSION_ID
  .claude/sessions/refine/$SESSION_ID/context.md
  .claude/sessions/refine/$SESSION_ID/alternatives.md
</Task>

---

## Phase 5: Refinement Selection 🎯

**Review the philosophy and choose your path to elegance...**

**Philosophy Analysis**: `.claude/sessions/refine/$SESSION_ID/philosophy.md`

**Refactoring Approaches**: `.claude/sessions/refine/$SESSION_ID/alternatives.md`

**Feasibility Assessment**: `.claude/sessions/refine/$SESSION_ID/feasibility.md`

**Please select your preferred refinement**:

- Type your selection (e.g., "Option B" or "B")
- Or combine approaches (e.g., "Option A + parts of Option C")
- Or request modifications
- Or ask questions about impact, risks, or trade-offs

**Consider**:
- Quick Wins (high impact, low effort)
- Strategic value (long-term maintainability)
- Risk level (chance of breaking things)
- Team familiarity (learning curve)

---

{Wait for user selection here. The conversation stops until user responds with their choice.}

---

## Phase 6: Refactoring Design 🏗️

**Creating detailed refactoring plan for: {USER_SELECTION}**

<Task agent="architect">
Session: $SESSION_ID
Directory: .claude/sessions/refine/$SESSION_ID
  .claude/sessions/refine/$SESSION_ID/context.md
  .claude/sessions/refine/$SESSION_ID/alternatives.md
  selected-option:{USER_SELECTION}
</Task>

---

## Phase 7: Plan Approval ⏸️

**Refactoring plan ready for review**: `.claude/sessions/refine/$SESSION_ID/plan.md`

**Review Checklist**:

- [ ] Does the refactoring preserve existing functionality?
- [ ] Are edge cases maintained or improved?
- [ ] Is the rollback strategy clear?
- [ ] Are tests updated or added?
- [ ] Is the improvement worth the change?
- [ ] Any concerns about breakage or risk?

**What to do next**:

- ✅ **Approve**: Type "proceed", "approved", "go ahead", or "looks good"
- 🔄 **Request changes**: Describe what to modify
- 💬 **Ask questions**: Request clarification on any aspect
- ❌ **Stop**: Type "stop" or "cancel"

---

{Wait for user approval here. The conversation stops until user responds.}

---

## Phase 8: Polish Implementation ✨

**REFINEMENT PRINCIPLES ACTIVE**:

- 🎯 Preserve functionality (tests prove it)
- 🎨 Make elegant (remove complexity, improve clarity)
- ✂️ Surgical precision (minimal, focused changes)
- 🧪 Test-driven (tests pass throughout)
- 📛 Names that sing (self-documenting)
- 🚫 No explanatory comments (code explains itself)
- ♻️ Iterative refinement (verify at each step)

Polishing with attention to elegance and simplicity...

<Task agent="craftsman">
Session: $SESSION_ID
Directory: .claude/sessions/refine/$SESSION_ID
  .claude/sessions/refine/$SESSION_ID/plan.md
  
  surgical
</Task>

---

## Phase 9: Quality Guardian 🛡️

**Validating refinement didn't break anything and improved quality...**

<Task agent="auditor">
Session: $SESSION_ID
Directory: .claude/sessions/refine/$SESSION_ID
  .claude/sessions/refine/$SESSION_ID
  
  refine-verification
</Task>

---

## Phase 10: Documentation 📝

**Creating permanent knowledge base...**

<Task agent="documentation-writer">
Session: $SESSION_ID
Directory: .claude/sessions/refine/$SESSION_ID
  .claude/sessions/refine/$SESSION_ID
</Task>

---

## Refinement Complete 💎

**Code Refined**: $ARGUMENTS

**Philosophy Applied**:

- ✅ Analyzed existing code with fresh eyes
- ✅ Identified opportunities for elegance
- ✅ Asked "What can we remove?" and "What would be elegant?"
- ✅ Generated multiple refactoring approaches
- ✅ Validated safety and feasibility
- ✅ You selected the optimal refinement
- ✅ Polished implementation with surgical precision
- ✅ All tests passing, functionality preserved
- ✅ Code is now more elegant, simple, and maintainable

**Improvement Metrics**:

Check the quality report for:
- Lines of code removed
- Complexity reduced
- Maintainability improved
- Code quality score increase

**Session Artifacts**: `.claude/sessions/refine/$SESSION_ID/`

- `context.md` - Original code analysis
- `philosophy.md` - Design philosophy opportunities
- `alternatives.md` - Refactoring approaches explored
- `feasibility.md` - Safety and risk assessment
- `plan.md` - Refactoring plan
- `progress.md` - Implementation log
- `quality.md` - Before/after quality comparison

**Documentation**: `./documentacion/{YYYYMMDD}-{name}.md`

**Commits**: Check `git log` for atomic refactoring commits

**Next Steps**:

1. Review quality improvements
2. Run full test suite
3. Compare before/after metrics
4. Merge when confident

---

**Note**: This wasn't about adding features—it was about making existing code exceptional. We found complexity to remove, patterns to clarify, and elegance to reveal. 💎

*"Perfection is achieved not when there is nothing left to add, but when there is nothing left to take away."*

The code is now more elegant, more maintainable, and more clearly expresses its intent.

Thank you for using the Refine command! 🚀

