---
description: "Ultra-thinking variant of /inge for maximum deep analysis on critical tasks. Uses ULTRATHINK mode for thorough exploration."
argument-hint: "Describe the critical/complex feature or architectural decision"
allowed-tools: Task
---

# Senior Engineer - Maximum Thinking Mode

**Welcome to ULTRATHINK mode!** 🧠⚡

This is the maximum-analysis variant of `/inge` - use when:
- Making critical architectural decisions
- Working on security-sensitive features
- Optimizing performance-critical paths
- Refactoring core systems
- Solving particularly complex problems

I'll take extra time to think deeply at every stage.

---

## Task: $ARGUMENTS

Starting with comprehensive research...

<Task agent="investigator">
  DEEP RESEARCH MODE - Analyze everything relevant for: $ARGUMENTS
  
  Session directory: .claude/sessions/tasks/{{timestamp}}
  
  Your goals:
  1. Map ALL relevant codebase areas (not just obvious ones)
  2. Identify patterns, anti-patterns, and conventions
  3. Deep dive into complexity and all dependencies
  4. Find multiple similar implementations for comparison
  5. Flag ALL potential risks, edge cases, and constraints
  6. Consider performance, security, and scalability implications
  
  Be thorough - this is a critical task.
  
  Output comprehensive findings to: .claude/sessions/tasks/{{timestamp}}/context.md
</Task>

---

## Deep Research Complete ✓

Now entering ULTRATHINK mode for solution design...

<Task agent="architect">
  **ULTRATHINK MODE ACTIVATED** 🧠⚡
  
  Design the optimal solution plan for: $ARGUMENTS
  
  Session directory: .claude/sessions/tasks/{{timestamp}}
  
  Input: .claude/sessions/tasks/{{timestamp}}/context.md
  
  Your goals:
  1. **ULTRATHINK** - Use maximum extended thinking budget
  2. Evaluate 5+ different approaches comprehensively
  3. Consider short-term AND long-term implications
  4. Analyze trade-offs deeply (performance, maintainability, scalability)
  5. Think through edge cases and failure modes
  6. Choose the best solution with exhaustive reasoning
  7. Create detailed step-by-step implementation plan
  8. Identify ALL risks with mitigation strategies
  9. Define comprehensive success criteria
  10. Consider migration path if breaking changes
  
  CRITICAL: This is a high-impact task. Think as hard as you can.
  Use "ultrathink" to engage maximum cognitive resources.
  
  Output detailed plan to: .claude/sessions/tasks/{{timestamp}}/plan.md
  
  Return with: ⏸️ AWAITING USER APPROVAL BEFORE IMPLEMENTATION
</Task>

---

## Comprehensive Plan Ready - Your Review Required ⏸️

**Deep plan available**: `.claude/sessions/tasks/{{timestamp}}/plan.md`

This plan has been created with maximum analysis. Please review carefully:

**Review checklist**:
- [ ] Does the chosen approach address all requirements?
- [ ] Are trade-offs clearly explained and acceptable?
- [ ] Do you understand why alternatives were rejected?
- [ ] Are risks properly identified and mitigated?
- [ ] Is the step-by-step plan clear and logical?
- [ ] Are success criteria appropriate?
- [ ] Any concerns about performance or scalability?
- [ ] Any security considerations overlooked?

**Your options**:
- ✅ **Approve**: Type "proceed" or "approved" or "looks good"
- 🔄 **Request changes**: Describe modifications needed
- 💬 **Discuss**: Ask questions or request clarification
- ❌ **Stop**: Type "stop" or "cancel"

Take your time to review - this is important work.

---

{Wait for user approval here. The conversation stops until user responds.}

---

## Implementation Starting with Precision ✓

<Task agent="builder">
  Execute the implementation plan with MAXIMUM CARE for: $ARGUMENTS
  
  Session directory: .claude/sessions/tasks/{{timestamp}}
  
  Inputs:
  - Context: .claude/sessions/tasks/{{timestamp}}/context.md
  - Plan: .claude/sessions/tasks/{{timestamp}}/plan.md
  
  Your goals:
  1. Follow the plan EXACTLY - this is critical code
  2. Write comprehensive tests FIRST (TDD)
  3. Test edge cases and error scenarios thoroughly
  4. Make atomic, descriptive commits with context
  5. Track progress meticulously
  6. Add detailed comments for complex logic
  7. Handle ALL error cases
  8. Consider performance implications
  
  This is high-impact work. Be methodical and precise.
  
  Output detailed progress to: .claude/sessions/tasks/{{timestamp}}/progress.md
  
  Return when: All steps completed and validated
</Task>

---

## Implementation Complete ✓

Running comprehensive validation...

<Task agent="validator">
  THOROUGH VALIDATION MODE for: $ARGUMENTS
  
  Session directory: .claude/sessions/tasks/{{timestamp}}
  
  Inputs:
  - Context: .claude/sessions/tasks/{{timestamp}}/context.md
  - Plan: .claude/sessions/tasks/{{timestamp}}/plan.md
  - Progress: .claude/sessions/tasks/{{timestamp}}/progress.md
  
  Your goals:
  1. Run ALL automated tests (unit, integration, e2e)
  2. Verify test coverage >85% for critical code
  3. Execute comprehensive manual testing checklist
  4. Test ALL edge cases and error scenarios
  5. Perform stress/performance testing
  6. Check security implications
  7. Verify backward compatibility
  8. Test failure modes and recovery
  
  Be thorough - this is critical functionality.
  
  Output comprehensive test results to: .claude/sessions/tasks/{{timestamp}}/test_report.md
  
  Return when: All tests pass, coverage is excellent, no concerns
</Task>

---

## Thorough Testing Complete ✓

Final comprehensive code review...

<Task agent="auditor">
  STAFF-LEVEL CODE REVIEW for: $ARGUMENTS
  
  Session directory: .claude/sessions/tasks/{{timestamp}}
  
  Inputs:
  - Context: .claude/sessions/tasks/{{timestamp}}/context.md
  - Plan: .claude/sessions/tasks/{{timestamp}}/plan.md
  - Progress: .claude/sessions/tasks/{{timestamp}}/progress.md
  - Test Report: .claude/sessions/tasks/{{timestamp}}/test_report.md
  
  Your goals:
  1. Thorough code quality review (readability, maintainability)
  2. Deep architecture assessment (patterns, structure, coupling)
  3. Comprehensive security audit
  4. Performance and scalability analysis
  5. Test coverage and quality verification
  6. Documentation completeness check
  7. Consider long-term maintenance implications
  8. Verify alignment with plan
  
  This is critical code. Apply staff-level scrutiny.
  
  Output detailed review to: .claude/sessions/tasks/{{timestamp}}/review.md
  
  Return verdict with full justification: APPROVE / APPROVE WITH NOTES / REQUEST CHANGES
</Task>

---

## Critical Task Complete ✅

**Task**: $ARGUMENTS

**Quality assurance**: Maximum thinking and validation applied

**Complete session artifacts** in: `.claude/sessions/tasks/{{timestamp}}/`
- `context.md` - Comprehensive research
- `plan.md` - Deep solution design (ULTRATHINK)
- `progress.md` - Detailed implementation log
- `test_report.md` - Thorough test results
- `review.md` - Staff-level code review

**Commits**: Check git log for atomic, well-documented commits

**Confidence level**: High - this code has been analyzed and validated thoroughly

**Next steps**: 
1. Review all artifacts carefully
2. Test in your environment
3. Consider staging deployment first
4. Monitor after deployment
5. Merge when confident

---

**Note**: This work has been done with maximum care and analysis. The extra thinking time ensures we've considered all angles. 🧠✨

Thank you for using senior engineer ULTRATHINK mode! 🚀
