# `/build` Command Token Optimization - Test Validation Checklist

**Date**: 2025-11-03
**Optimization Version**: v2.0 (Token-Optimized)
**Expected Savings**: 40-50% average token reduction

---

## Pre-Test Setup

- [ ] Ensure plugin is updated with optimized build.md
- [ ] Verify all agent files have new input patterns
- [ ] Clear any existing `.claude/sessions/build/` directories
- [ ] Have baseline token measurements ready (if available)

---

## Test Suite

### Test 1: TRIVIAL Task

**Task**: "Add a primary color constant to the theme configuration"

**Expected Behavior**:
- [ ] Investigator classifies as TRIVIAL
- [ ] Context.md includes: `Task Classification: TRIVIAL`
- [ ] Context.md is concise (~500-1000 words)
- [ ] Architect uses `think` (not ULTRATHINK)
- [ ] Plan.md is appropriate for simple task
- [ ] Builder implements correctly
- [ ] Validator runs tests
- [ ] Auditor provides review

**Expected Token Usage**: ~60K-80K (vs ~150K baseline)
**Expected Savings**: ~70K (47%)

**Validation**:
- [ ] Session files created correctly
- [ ] No verbose Task invocations in logs
- [ ] Classification appears in context.md
- [ ] Quality unchanged from baseline

---

### Test 2: SMALL Task

**Task**: "Fix the login button alignment on mobile devices"

**Expected Behavior**:
- [ ] Investigator classifies as SMALL
- [ ] Context.md includes: `Task Classification: SMALL`
- [ ] Standard progressive disclosure (~1000-2000 words)
- [ ] Architect uses `think` (standard depth)
- [ ] TDD approach in builder
- [ ] Comprehensive testing

**Expected Token Usage**: ~90K-110K (vs ~180K baseline)
**Expected Savings**: ~70-90K (39-50%)

**Validation**:
- [ ] Appropriate research depth
- [ ] Correct thinking depth applied
- [ ] Tests cover the bug fix
- [ ] Quality maintained

---

### Test 3: MEDIUM Task

**Task**: "Implement a user profile page with avatar upload functionality"

**Expected Behavior**:
- [ ] Investigator classifies as MEDIUM
- [ ] Context.md includes: `Task Classification: MEDIUM`
- [ ] Detailed analysis (~2000-3000 words)
- [ ] Architect uses `think hard`
- [ ] Mermaid diagrams in plan (if 3+ components)
- [ ] Full TDD implementation
- [ ] Integration tests included

**Expected Token Usage**: ~120K-140K (vs ~200K baseline)
**Expected Savings**: ~60-80K (30-40%)

**Validation**:
- [ ] Comprehensive context
- [ ] Appropriate thinking depth
- [ ] Visual diagrams if needed
- [ ] Full test coverage

---

### Test 4: LARGE Task

**Task**: "Refactor the authentication system to use JWT tokens instead of sessions"

**Expected Behavior**:
- [ ] Investigator classifies as LARGE
- [ ] Context.md includes: `Task Classification: LARGE`
- [ ] Deep analysis focused on critical paths (~3000-4000 words)
- [ ] Architect uses `think harder`
- [ ] Risk assessment in plan
- [ ] Migration strategy documented
- [ ] Rollback plan included

**Expected Token Usage**: ~160K-190K (vs ~250K baseline)
**Expected Savings**: ~60-90K (24-36%)

**Validation**:
- [ ] Strategic context (not over-detailed)
- [ ] Deep thinking applied
- [ ] Risk mitigation planned
- [ ] Architecture diagrams present

---

### Test 5: VERY_LARGE Task

**Task**: "Migrate the entire API layer from REST to GraphQL"

**Expected Behavior**:
- [ ] Investigator classifies as VERY_LARGE
- [ ] Context.md includes: `Task Classification: VERY_LARGE`
- [ ] Strategic overview with risk-based sampling (~4000-5000 words)
- [ ] Architect uses `ULTRATHINK`
- [ ] Phased migration plan
- [ ] Comprehensive risk assessment
- [ ] Multiple Mermaid diagrams

**Expected Token Usage**: ~200K-220K (vs ~260K baseline)
**Expected Savings**: ~40-60K (15-23%)

**Validation**:
- [ ] High-level strategic context
- [ ] Maximum thinking depth
- [ ] Phased approach
- [ ] Quality matches baseline

---

## Quality Assurance Tests

### QA1: Session File Integrity

For each test above:
- [ ] `context.md` created with classification
- [ ] `plan.md` created with appropriate detail
- [ ] `progress.md` tracks implementation
- [ ] `test_report.md` shows validation results
- [ ] `review.md` has comprehensive audit

### QA2: Agent Behavior

- [ ] Investigator respects classification guidelines
- [ ] Architect reads classification from context.md
- [ ] Architect applies correct thinking depth
- [ ] Builder follows plan precisely
- [ ] Validator comprehensive testing
- [ ] Auditor orchestrates 6 review agents

### QA3: Token Efficiency

- [ ] No verbose Task invocations in logs
- [ ] Session files used for context sharing
- [ ] No content duplication between phases
- [ ] Adaptive research scales correctly
- [ ] Adaptive thinking scales correctly

### QA4: Quality Preservation

- [ ] Output quality unchanged from baseline
- [ ] TDD approach maintained
- [ ] Test coverage >80%
- [ ] Code quality scores similar
- [ ] No functionality regressions

---

## Edge Cases & Error Handling

### Edge 1: Unclear Classification

**Task**: "Improve the application"

**Expected**:
- [ ] Investigator defaults to MEDIUM (conservative)
- [ ] Documents uncertainty in context.md
- [ ] Architect can override if needed
- [ ] Override documented in plan.md

### Edge 2: Classification Override

**Scenario**: Investigator says SMALL, but architect detects LARGE complexity

**Expected**:
- [ ] Architect documents override reasoning
- [ ] Uses appropriate thinking depth anyway
- [ ] Notes discrepancy in plan.md
- [ ] No failure or error

### Edge 3: Missing Session Files

**Scenario**: Session file accidentally deleted

**Expected**:
- [ ] Agent reports clear error
- [ ] Suggests remediation
- [ ] Doesn't proceed with bad data

---

## Performance Benchmarks

### Baseline (Old Version) - Estimated

| Task Size | Token Usage | Time |
|-----------|-------------|------|
| TRIVIAL | ~150K | 12 min |
| SMALL | ~180K | 15 min |
| MEDIUM | ~200K | 20 min |
| LARGE | ~250K | 30 min |
| VERY_LARGE | ~260K | 35 min |

### Target (Optimized) - Expected

| Task Size | Token Usage | Savings | Time |
|-----------|-------------|---------|------|
| TRIVIAL | 60-80K | 47% | 10 min |
| SMALL | 90-110K | 44% | 12 min |
| MEDIUM | 120-140K | 35% | 18 min |
| LARGE | 160-190K | 28% | 25 min |
| VERY_LARGE | 200-220K | 19% | 32 min |

### Actual Results (To Be Filled)

| Task Size | Token Usage | Savings | Time | Notes |
|-----------|-------------|---------|------|-------|
| TRIVIAL | | | | |
| SMALL | | | | |
| MEDIUM | | | | |
| LARGE | | | | |
| VERY_LARGE | | | | |

---

## Success Criteria

### Must Have (Blocking)

- [ ] All 5 test cases complete successfully
- [ ] Average token savings ≥30%
- [ ] No quality degradation
- [ ] Session files created correctly
- [ ] Agents use correct thinking depths

### Should Have (Important)

- [ ] Token savings ≥40% average
- [ ] Time savings or neutral (not slower)
- [ ] Clear classification in all contexts
- [ ] Proper override documentation
- [ ] Edge cases handled gracefully

### Nice to Have (Bonus)

- [ ] Token savings ≥50%
- [ ] Faster execution overall
- [ ] Better context quality
- [ ] Improved plan clarity
- [ ] User satisfaction improvement

---

## Issue Tracking

### Issues Found

| ID | Severity | Description | Status | Resolution |
|----|----------|-------------|--------|------------|
| | | | | |

### Observations

| Category | Observation | Action Needed |
|----------|-------------|---------------|
| | | |

---

## Sign-Off

### Tested By
- Name: ________________
- Date: ________________

### Results Summary
- Total Tests: 5 core + 3 edge cases = 8
- Tests Passed: ___ / 8
- Average Token Savings: ___%
- Quality Assessment: ☐ Maintained  ☐ Improved  ☐ Degraded

### Recommendation
☐ **APPROVE** - Deploy to production
☐ **APPROVE WITH NOTES** - Minor fixes needed
☐ **REQUEST CHANGES** - Issues must be addressed

### Notes

---

**Next Steps After Validation**:
1. If approved: Update CLAUDE.md with optimization notes
2. Create changelog entry
3. Update plugin version number
4. Announce to users
5. Monitor adoption and feedback
