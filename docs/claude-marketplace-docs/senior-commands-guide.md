# Senior Engineer Commands - User Guide

Comprehensive guide for using the senior engineer slash commands in Claude Code.

## Overview

The senior engineer commands provide AI-powered assistance that follows a professional engineering workflow:

1. **Research** - Gather context and understand the problem
2. **Plan** - Think deeply and design solutions
3. **Implement** - Execute with precision
4. **Test** - Validate thoroughly
5. **Review** - Final quality check

All commands generate a session directory with complete artifacts of the work.

---

## Available Commands

### `/inge` - Universal Senior Engineer

**When to use**:
- Implementing new features (medium to complex)
- Making significant changes to existing code
- When you want thorough planning before implementation
- Multi-file changes with dependencies
- When you're unsure of the best approach

**Workflow**:
1. 🔍 Research the codebase
2. 🧠 Create detailed plan
3. ⏸️ **YOU APPROVE** - Review plan before proceeding
4. 🛠️ Implement the solution
5. 🧪 Test comprehensively
6. 👀 Final code review

**Example use cases**:
```
/inge Add user authentication with JWT tokens

/inge Refactor the payment processing module to support multiple providers

/inge Implement caching layer for API responses

/inge Add pagination to the products list endpoint
```

**Time estimate**: 5-20 minutes depending on complexity

**Approval required**: YES - you review the plan before implementation

---

### `/senior` - Ultra-Thinking Engineer

**When to use**:
- Critical architectural decisions
- Security-sensitive features
- Performance-critical optimizations
- Core system refactoring
- When you need maximum analysis

**Workflow**:
Same as `/inge` but with **ULTRATHINK mode** - deeper analysis at every stage

**Example use cases**:
```
/senior Design a real-time notification system architecture

/senior Optimize database queries for the dashboard (handling 1M+ records)

/senior Refactor authentication system to support OAuth2 and SAML

/senior Implement zero-downtime deployment strategy
```

**Time estimate**: 10-30 minutes - takes longer due to deep thinking

**Approval required**: YES - with comprehensive plan review

**Note**: Use this when correctness and thoroughness matter more than speed.

---

### `/frontend` - Frontend Specialist

**When to use**:
- Building React components
- UI/UX implementation
- Accessibility work
- Responsive design
- Frontend performance optimization

**Workflow**:
Same as `/inge` but with **frontend-specific focus**:
- Component architecture
- Accessibility (WCAG)
- Responsive design
- Performance (bundle size, rendering)
- Cross-browser testing

**Example use cases**:
```
/frontend Create an accessible date picker component

/frontend Build a responsive navigation menu with mobile hamburger

/frontend Optimize the product card component for performance

/frontend Implement dark mode theme switching

/frontend Add keyboard navigation to the modal dialog
```

**Time estimate**: 5-20 minutes

**Approval required**: YES - review UI/UX plan before building

**Special focus**: Accessibility, responsiveness, and user experience

---

### `/quick-fix` - Fast Fixes

**When to use**:
- Simple bug fixes
- Typo corrections
- Style adjustments
- Configuration changes
- Dependency updates
- Minor refactoring

**Workflow**:
Simplified process with **auto-approval**:
1. 🔍 Quick research
2. 🧠 Fast analysis
3. 🛠️ Implement fix
4. 🧪 Quick validation

**Example use cases**:
```
/quick-fix Fix the typo in the error message on line 45

/quick-fix Update button color to match design system

/quick-fix Remove console.log statements from ProductCard

/quick-fix Fix broken import path in utils/helpers.ts

/quick-fix Bump lodash to latest version
```

**Time estimate**: 1-5 minutes

**Approval required**: NO - proceeds automatically

**Warning**: Not suitable for:
- New features
- Architecture changes
- Security work
- Complex refactoring

---

## Decision Tree: Which Command to Use?

```
Is it a simple, low-risk fix?
├─ YES → Use /quick-fix
└─ NO → Continue...

Is it frontend/UI work?
├─ YES → Use /frontend
└─ NO → Continue...

Is it critical or highly complex?
├─ YES → Use /senior (ULTRATHINK mode)
└─ NO → Use /inge (standard workflow)
```

### Complexity Assessment

**Simple (use `/quick-fix`)**:
- 1 file, <20 lines changed
- No architectural impact
- Clear, obvious solution
- Low risk if wrong

**Medium (use `/inge`)**:
- 1-5 files changed
- Some design decisions needed
- Multiple approaches possible
- Moderate risk

**Complex (use `/senior`)**:
- 5+ files or architectural changes
- Critical decision points
- High impact on system
- Security/performance critical
- Significant risk if wrong

---

## Understanding the Approval Gate

### What is it?

After the planning phase, the engineer stops and waits for your approval before implementing.

### Why is it important?

- **Review the approach**: Make sure the solution makes sense
- **Catch issues early**: Fix problems in planning, not code
- **Your control**: You decide when to proceed
- **Save time**: Avoid implementing the wrong solution

### What to check in the plan?

Read `.claude/sessions/{command_type}/{timestamp}/plan.md` and verify:

1. **Approach makes sense**: Does the strategy solve the problem?
2. **Steps are clear**: Can you follow the implementation plan?
3. **Risks identified**: Are potential problems considered?
4. **Scope is right**: Not too much, not too little?
5. **Alternatives considered**: Why was this approach chosen?

### How to respond?

**To approve**:
```
proceed
approved
looks good
go ahead
lgtm
```

**To request changes**:
```
Change the database approach to use transactions

Can we use the existing UserService instead of creating a new one?

Add error handling for the API timeout case
```

**To stop**:
```
stop
cancel
never mind
```

---

## Session Artifacts

Every command creates a session directory with complete documentation:

```
.claude/sessions/{command_type}/{timestamp}/
├── context.md        # Research findings
├── plan.md           # Solution design
├── progress.md       # Implementation log
├── test_report.md    # Test results
└── review.md         # Code review
```

### Why keep these?

- **Documentation**: Understand why decisions were made
- **Review**: Check the work at each stage
- **Learning**: See how complex problems were solved
- **Debugging**: If issues arise later, trace back
- **Handoff**: Share context with team members

### How long to keep?

- **Keep**: For important features or complex work
- **Delete**: After merging simple fixes

---

## Best Practices

### 1. Choose the Right Command

Don't use `/senior` for simple tasks - it takes much longer.

Don't use `/quick-fix` for complex work - it skips important planning.

### 2. Write Clear Task Descriptions

**Good**:
```
/inge Add pagination to the users list with page size of 20, 
including next/prev buttons and page number display
```

**Bad**:
```
/inge fix users
```

### 3. Review Plans Carefully

The approval gate is your safety net. Use it.

### 4. Check Session Artifacts

Read the `plan.md` before approving.

Read the `test_report.md` to understand test coverage.

Read the `review.md` for quality assessment.

### 5. Test the Changes

The commands test automatically, but you should test too:
- Run in your environment
- Try edge cases
- Check the UI manually

### 6. Iterate if Needed

If the first attempt isn't perfect, run the command again with refinements:

```
/inge Improve the user search to support fuzzy matching and filters
```

### 7. Use Quick-Fix Appropriately

It's great for speed, but has no approval gate. Use only when:
- You know exactly what needs to change
- The risk is very low
- It's genuinely simple

---

## Troubleshooting

### "The plan doesn't look right"

**Solution**: Request changes at the approval gate. Describe what to adjust.

### "The implementation isn't working"

**Solution**: Check `progress.md` to see what was done. Run the command again with more specific instructions.

### "Tests are failing"

**Solution**: Check `test_report.md` for details. The reviewer might have caught this in `review.md`.

### "It's taking too long"

**Solution**: 
- `/senior` is intentionally slow (deep thinking)
- `/inge` should be moderate
- Use `/quick-fix` for speed

### "I don't need all this planning"

**Solution**: Use `/quick-fix` for simple changes.

### "I need even more analysis"

**Solution**: Use `/senior` instead of `/inge`.

---

## Example Workflows

### Example 1: New Feature (Use `/inge`)

**Task**: Add email notifications when order status changes

```
/inge Add email notifications when order status changes. 
Send emails for: order confirmed, shipped, and delivered statuses.
```

**What happens**:
1. Research: Finds existing email service, order model, status enum
2. Plan: Proposes using event listeners on order updates → you approve
3. Implement: Adds event handlers, email templates, tests
4. Test: Verifies emails sent correctly for each status
5. Review: Checks code quality and error handling

**Time**: ~15 minutes

---

### Example 2: Critical Work (Use `/senior`)

**Task**: Refactor authentication to support multiple providers

```
/senior Refactor authentication system to support multiple OAuth providers 
(Google, GitHub, Microsoft). Maintain backward compatibility with existing users.
```

**What happens**:
1. Deep Research: Analyzes current auth flow, user model, security
2. ULTRATHINK Planning: Evaluates multiple architectures deeply → you approve
3. Careful Implementation: Step-by-step with comprehensive tests
4. Thorough Testing: Security testing, migration testing, compatibility
5. Staff-Level Review: Security audit, performance check

**Time**: ~25 minutes (worth it for critical work)

---

### Example 3: UI Component (Use `/frontend`)

**Task**: Build accessible dropdown menu

```
/frontend Create an accessible dropdown menu component with keyboard navigation.
Should support arrow keys, Enter to select, Esc to close, and work with screen readers.
```

**What happens**:
1. Frontend Research: Finds design system, checks for similar components
2. UX Planning: Considers keyboard nav, ARIA labels, mobile behavior → you approve
3. Implementation: Builds with accessibility-first approach
4. Comprehensive Testing: Tests keyboard nav, screen readers, responsiveness
5. Frontend Review: Checks accessibility, performance, UX

**Time**: ~12 minutes

---

### Example 4: Quick Bug Fix (Use `/quick-fix`)

**Task**: Fix validation error message

```
/quick-fix Fix the validation error message in LoginForm.tsx - 
should say "Email is required" instead of "Email required"
```

**What happens**:
1. Quick Research: Finds the file and error message
2. Fast Analysis: Simple text change, no risk
3. Implementation: Updates message, updates test
4. Quick Validation: Runs related tests

**Time**: ~2 minutes

---

## Advanced Tips

### Tip 1: Combine with Other Commands

You can use senior engineer commands alongside other Claude Code features:

```
# Research first
/search authentication implementation

# Then engineer
/inge Add JWT refresh token rotation
```

### Tip 2: Provide Context in Task Description

Help the research phase by mentioning relevant details:

```
/inge Add rate limiting to the API using Redis for storage. 
Currently using Express middleware. Should limit to 100 requests per 15 minutes per IP.
```

### Tip 3: Ask for Specific Approaches

If you know what you want:

```
/inge Implement user search using PostgreSQL full-text search (not Elasticsearch)
```

### Tip 4: Scope Appropriately

Break very large tasks into multiple commands:

```
# Instead of:
/inge Build entire user management system

# Do this:
/inge Add user CRUD endpoints
/inge Add user authentication
/inge Add user profile page
```

### Tip 5: Learn from Session Artifacts

Read the plans and reviews to learn good patterns:
- How problems are analyzed
- What approaches work well
- Common risks and mitigations
- Testing strategies

---

## Comparison with Regular Chat

| Aspect | Regular Chat | Senior Commands |
|--------|--------------|-----------------|
| Structure | Freeform | 5-phase workflow |
| Planning | Implicit | Explicit plan document |
| Approval | None | Required (except quick-fix) |
| Testing | Manual request | Automatic |
| Review | Manual request | Automatic |
| Documentation | None | Session artifacts |
| Best for | Simple questions | Complete implementations |

**When to use regular chat**:
- Asking questions
- Getting explanations
- Exploring options
- Quick snippets

**When to use senior commands**:
- Implementing features
- Making changes to codebase
- Need structured workflow
- Want approval control

---

## Summary

- **`/inge`** - Your default for most feature work
- **`/senior`** - When stakes are high and you need maximum analysis
- **`/frontend`** - For all React/UI work
- **`/quick-fix`** - For simple, low-risk fixes

All commands (except quick-fix) give you an **approval gate** to review plans before implementation.

All commands generate **session artifacts** documenting the entire process.

Choose based on **complexity** and **risk**, not preference.

---

**Happy engineering!** 🚀

If you have questions or issues, check the session artifacts in `.claude/sessions/{command_type}/` (where command_type is workflow, build, implement, ui, patch, or think) to understand what happened at each stage.
