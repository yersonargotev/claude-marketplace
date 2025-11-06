---
description: "Ultra-thinking variant of /inge for maximum deep analysis on critical tasks. Uses ULTRATHINK mode for thorough exploration."
argument-hint: "Describe the critical/complex feature or architectural decision"
allowed-tools: Task
---

# Senior Engineer - Maximum Thinking Mode

**Welcome to ULTRATHINK mode!** 🧠⚡

This is the maximum-analysis variant of `/build` - use when:

- Making critical architectural decisions
- Working on security-sensitive features
- Optimizing performance-critical paths
- Refactoring core systems
- Solving particularly complex problems

I'll take extra time to think deeply at every stage.

---

## Task: $ARGUMENTS

Starting with comprehensive research...

**Session Setup**

Generating unique session ID and creating session directory...

!SESSION_ID="think_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/think/$SESSION_ID"
!echo "✓ Session: $SESSION_ID"

---


<Task agent="investigator">
Session: $SESSION_ID
Directory: .claude/sessions/think/$SESSION_ID
  $ARGUMENTS

  deep-research
</Task>

---

## Deep Research Complete ✓

Now entering ULTRATHINK mode for solution design...

<Task agent="architect">
Session: $SESSION_ID
Directory: .claude/sessions/think/$SESSION_ID
  .claude/sessions/think/$SESSION_ID/context.md

  ultrathink
</Task>

---

## Comprehensive Plan Ready - Your Review Required ⏸️

**Deep plan available**: `.claude/sessions/think/$SESSION_ID/plan.md`

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
Session: $SESSION_ID
Directory: .claude/sessions/think/$SESSION_ID
  .claude/sessions/think/$SESSION_ID/plan.md

  maximum-care
</Task>

---

## Implementation Complete ✓

Running comprehensive validation...

<Task agent="validator">
Session: $SESSION_ID
Directory: .claude/sessions/think/$SESSION_ID
  .claude/sessions/think/$SESSION_ID/progress.md

  thorough-validation
</Task>

---

## Thorough Testing Complete ✓

Final comprehensive code review...

<Task agent="auditor">
Session: $SESSION_ID
Directory: .claude/sessions/think/$SESSION_ID
  .claude/sessions/think/$SESSION_ID

  staff-level-review
</Task>

---

## Critical Task Complete ✅

**Task**: $ARGUMENTS

**Quality assurance**: Maximum thinking and validation applied

**Complete session artifacts** in: `.claude/sessions/think/$SESSION_ID/`

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
