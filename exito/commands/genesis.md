---
description: "Greenfield development from scratch - first principles thinking, pure architecture, free from legacy constraints"
argument-hint: "Describe what you want to build from scratch"
allowed-tools: Task
---

# Genesis Architect

**Welcome to the Genesis Command** - Where we build from zero with perfect foresight.

This is the rare privilege of a blank slate. No legacy code. No technical debt. No "we've always done it this way."

This is about:

- **First Principles** - Question everything, assume nothing
- **Pure Architecture** - Clean, elegant system design
- **Optimal Patterns** - Best practices, not habits
- **Future-Proof** - Built to last and evolve gracefully

The workflow:

1. 🌟 **Vision** - Understand the dream without constraints
2. ✅ **Validate** - Ensure requirements are clear
3. 🎨 **Ideate** - First principles architecture design
4. ⚖️ **Feasibility** - Validate the vision is achievable
5. 🎯 **Select** - You choose the architectural approach
6. 🏗️ **Blueprint** - Comprehensive architecture with ULTRATHINK
7. ⏸️ **Approve** - You review and approve the architecture
8. 🚀 **Build** - Greenfield implementation from foundation up
9. 🛡️ **Guard** - Quality validation
10. 📝 **Document** - System knowledge base

This workflow asks: **"If we could start fresh, what would we build?"**

---

## Vision: $ARGUMENTS

---

## Phase 1: Vision Discovery 🌟

**Understanding the dream - unburdened by legacy, unconstrained by history...**

**Session Setup**

Generating unique session ID and creating session directory...

!SESSION_ID="genesis_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/genesis/$SESSION_ID"
!echo "✓ Session: $SESSION_ID"

---


<Task agent="investigator">
Session: $SESSION_ID
Directory: .claude/sessions/genesis/$SESSION_ID
  $ARGUMENTS
  
  genesis-vision
</Task>

---

## Phase 2: Requirements Validation ✅

**Ensuring vision is clear and complete...**

<Task agent="requirements-validator">
Session: $SESSION_ID
Directory: .claude/sessions/genesis/$SESSION_ID
  .claude/sessions/genesis/$SESSION_ID/context.md
</Task>

---

{If validation returns NEEDS_INFO, stop here and request clarification from user}

---

## Phase 3: First Principles Ideation 🎨

**Designing from scratch with first principles thinking...**

<Task agent="genesis-architect">
Session: $SESSION_ID
Directory: .claude/sessions/genesis/$SESSION_ID
  .claude/sessions/genesis/$SESSION_ID/context.md
  .claude/sessions/genesis/$SESSION_ID/validation-report.md
</Task>

---

## Phase 4: Visionary Approaches 💡

**Generating multiple architectural approaches - each optimized for the problem...**

<Task agent="visionary">
Session: $SESSION_ID
Directory: .claude/sessions/genesis/$SESSION_ID
  .claude/sessions/genesis/$SESSION_ID/context.md
  .claude/sessions/genesis/$SESSION_ID/genesis-design.md
</Task>

---

## Phase 5: Feasibility Validation ⚖️

**Validating that architectures are buildable with available resources...**

<Task agent="feasibility-validator">
Session: $SESSION_ID
Directory: .claude/sessions/genesis/$SESSION_ID
  .claude/sessions/genesis/$SESSION_ID/context.md
  .claude/sessions/genesis/$SESSION_ID/alternatives.md
</Task>

---

## Phase 6: Architecture Selection 🎯

**Review the architectures and choose your foundation...**

**Genesis Design**: `.claude/sessions/genesis/$SESSION_ID/genesis-design.md`

**Architectural Approaches**: `.claude/sessions/genesis/$SESSION_ID/alternatives.md`

**Feasibility Assessment**: `.claude/sessions/genesis/$SESSION_ID/feasibility.md`

**Please select your preferred architecture**:

- Type your selection (e.g., "Option B" or "B")
- Or combine best aspects (e.g., "Option A's structure with Option C's data model")
- Or request modifications
- Or ask questions about scalability, maintainability, or trade-offs

**Consider**:
- Long-term maintainability
- Team learning curve
- Scalability potential
- Technology ecosystem
- Development velocity

---

{Wait for user selection here. The conversation stops until user responds with their choice.}

---

## Phase 7: Comprehensive Blueprint 🏗️

**Creating detailed architecture with ULTRATHINK for: {USER_SELECTION}**

This is greenfield - we'll use maximum depth thinking to design the optimal system.

<Task agent="architect">
Session: $SESSION_ID
Directory: .claude/sessions/genesis/$SESSION_ID
  .claude/sessions/genesis/$SESSION_ID/context.md
  .claude/sessions/genesis/$SESSION_ID/alternatives.md
  selected-option:{USER_SELECTION}
</Task>

---

## Phase 8: Architecture Approval ⏸️

**Complete architecture ready for review**: `.claude/sessions/genesis/$SESSION_ID/plan.md`

**Review Checklist**:

- [ ] Does the architecture solve the core problem elegantly?
- [ ] Is the domain model clean and well-defined?
- [ ] Are layers properly separated?
- [ ] Is the technology stack optimal?
- [ ] Will this scale appropriately?
- [ ] Is the file structure intuitive?
- [ ] Are testing strategies comprehensive?
- [ ] Will this age well (5+ years)?
- [ ] Any concerns or modifications needed?

**What to do next**:

- ✅ **Approve**: Type "proceed", "approved", "go ahead", or "looks good"
- 🔄 **Request changes**: Describe what to modify
- 💬 **Ask questions**: Request clarification on any aspect
- ❌ **Stop**: Type "stop" or "cancel"

---

{Wait for user approval here. The conversation stops until user responds.}

---

## Phase 9: Greenfield Construction 🚀

**GENESIS PRINCIPLES ACTIVE**:

- 🎯 Pure domain logic (zero dependencies)
- 🏛️ Clean architecture (dependencies flow inward)
- 🎨 Elegant abstractions (patterns that feel inevitable)
- 🧪 Test-driven development (TDD from day 1)
- 📛 Self-documenting code (names explain intent)
- 🚫 No technical debt (build it right the first time)
- 🔮 Future-proof (designed for change)

Building from foundation up with craftsmanship...

<Task agent="craftsman">
Session: $SESSION_ID
Directory: .claude/sessions/genesis/$SESSION_ID
  .claude/sessions/genesis/$SESSION_ID/plan.md
  
  greenfield
</Task>

---

## Phase 10: Quality Guardian 🛡️

**Validating architecture and implementation quality...**

<Task agent="auditor">
Session: $SESSION_ID
Directory: .claude/sessions/genesis/$SESSION_ID
  .claude/sessions/genesis/$SESSION_ID
  
  genesis-verification
</Task>

---

## Phase 11: System Documentation 📝

**Creating comprehensive system knowledge base...**

<Task agent="documentation-writer">
Session: $SESSION_ID
Directory: .claude/sessions/genesis/$SESSION_ID
  .claude/sessions/genesis/$SESSION_ID
</Task>

---

## Genesis Complete 🌟

**System Built**: $ARGUMENTS

**Architecture Principles**:

- ✅ Designed from first principles (no legacy constraints)
- ✅ Pure domain model (business logic isolated)
- ✅ Clean architecture (proper separation of concerns)
- ✅ Optimal technology stack (best fit for problem)
- ✅ Comprehensive testing (TDD from start)
- ✅ Self-documenting code (elegant naming)
- ✅ Future-proof design (easy to extend)
- ✅ Zero technical debt (built right from day 1)

**System Highlights**:

- **Domain Layer**: Pure business logic, framework-agnostic
- **Application Layer**: Use cases and workflows
- **Infrastructure Layer**: Technical implementation
- **Presentation Layer**: User interfaces

**Session Artifacts**: `.claude/sessions/genesis/$SESSION_ID/`

- `context.md` - Vision and requirements
- `validation-report.md` - Requirements validation
- `genesis-design.md` - Initial first principles design
- `alternatives.md` - Architectural approaches explored
- `feasibility.md` - Technical feasibility assessment
- `plan.md` - Complete architecture blueprint
- `progress.md` - Implementation log
- `quality.md` - Quality validation report

**Documentation**: `./documentacion/{YYYYMMDD}-{name}.md`

**System Structure**:
```
src/
├── domain/          # Pure business logic
├── application/     # Use cases
├── infrastructure/  # Technical concerns
├── presentation/    # User interfaces
└── shared/          # Cross-cutting concerns
```

**Next Steps**:

1. Review complete architecture
2. Run full test suite (should be comprehensive)
3. Test all layers independently
4. Validate domain invariants
5. Deploy with confidence

---

**Note**: This wasn't built on top of legacy code—this was crafted from scratch with perfect foresight. No compromises. No shortcuts. Just elegant, maintainable, future-proof architecture. 🌟

*"In the beginner's mind there are many possibilities, in the expert's mind there are few."*

You now have a system designed from first principles, built with craftsmanship, and ready to evolve gracefully for years to come.

Thank you for using the Genesis command! 🚀

