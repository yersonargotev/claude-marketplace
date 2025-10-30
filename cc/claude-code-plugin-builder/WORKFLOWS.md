# Multi-Agent Workflow Orchestration

Workflows coordinate multiple specialized agents to accomplish complex tasks. This guide covers patterns for efficient, token-optimized orchestration.

## Orchestration Basics

### Sequential vs Parallel Execution

**Sequential**: Agents run one after another
```
Agent A → Agent B → Agent C → Synthesize
```
Use when: Later agents depend on earlier results

**Parallel**: Agents run simultaneously
```
        ┌─ Agent A ─┐
Start ──┼─ Agent B ─┼── Synthesize
        └─ Agent C ─┘
```
Use when: Agents are independent

## Core Pattern: File-Based Context Sharing

### The Problem with Message Passing

```markdown
# ❌ DON'T: Pass large context between agents
Invoke Agent A with: [10,000 lines of code]
Agent A returns: [5,000 words of analysis]
Invoke Agent B with: [Agent A's output + original context]
```

**Issues**:
- Token usage explodes
- Hits context limits
- Wastes API costs
- Slow execution

### The Solution: File-Based Communication

```markdown
# ✅ DO: Use files as single source of truth
Phase 1: Create context file
  → Invoke context-gatherer
  → Creates .claude/sessions/project/context.md

Phase 2: Parallel analysis
  → Invoke agents with context file path
  → Each agent reads context, writes report
  → Agents return concise summaries only

Phase 3: Synthesize
  → Read all report files
  → Synthesize unified output
```

**Benefits**:
- 60-70% token reduction
- No context limits
- Parallel execution possible
- Audit trail preserved

## Pattern 1: Sequential Workflow

### When to Use
- Each agent builds on previous results
- Need progressive refinement
- Order matters for correctness

### Structure

```markdown
---
description: "Sequential analysis workflow"
---

You are a workflow orchestrator.

**Phase 1: Context Gathering**
Invoke `context-gatherer` agent with: $1
Wait for completion.
Context saved to: .claude/sessions/workflow/context.md

**Phase 2: Initial Analysis**
Invoke `analyzer` agent with: .claude/sessions/workflow/context.md
Wait for completion.
Analysis saved to: .claude/sessions/workflow/analysis.md

**Phase 3: Refinement**
Invoke `refiner` agent with: .claude/sessions/workflow/analysis.md
Wait for completion.
Refinement saved to: .claude/sessions/workflow/refined.md

**Phase 4: Final Review**
Read .claude/sessions/workflow/refined.md
Present final results to user
```

### Example: Code Migration Workflow

```markdown
**Phase 1: Scan Codebase**
Invoke `codebase-scanner` with: src/
Agent creates: .claude/sessions/migration/inventory.md
Returns: "Found 47 components using deprecated API"

**Phase 2: Generate Migration Plan**
Invoke `migration-planner` with: .claude/sessions/migration/inventory.md
Agent creates: .claude/sessions/migration/plan.md
Returns: "Migration plan created with 47 steps"

**Phase 3: Execute Migration**
Invoke `code-migrator` with: .claude/sessions/migration/plan.md
Agent creates: .claude/sessions/migration/results.md
Returns: "Migrated 45/47 components, 2 need manual review"

**Phase 4: Verify**
Invoke `test-runner` with: .claude/sessions/migration/results.md
Agent creates: .claude/sessions/migration/test_results.md
Returns: "All tests passed, migration successful"

**Phase 5: Report**
Read all files in .claude/sessions/migration/
Synthesize summary and present to user
```

## Pattern 2: Parallel Workflow

### When to Use
- Agents are independent
- No dependencies between tasks
- Want maximum speed
- Token budget allows concurrent execution

### Structure

```markdown
---
description: "Parallel analysis workflow"
---

You are a workflow orchestrator.

**Phase 1: Context Gathering**
Invoke `context-gatherer` agent with: $1
Wait for completion.
Context saved to: .claude/sessions/workflow/context.md

**Phase 2: Parallel Analysis**
Invoke the following agents **in parallel** using multiple Task tool calls in a single message:
- `security-scanner` with .claude/sessions/workflow/context.md
- `performance-analyzer` with .claude/sessions/workflow/context.md
- `code-quality-checker` with .claude/sessions/workflow/context.md

Each agent:
1. Reads context file
2. Performs specialized analysis
3. Writes report to .claude/sessions/workflow/[agent-name]_report.md
4. Returns concise summary (< 200 words)

Wait for all agents to complete.

**Phase 3: Synthesis**
Read all reports from .claude/sessions/workflow/
Synthesize unified report
Present to user
```

### Critical: Parallel Execution Syntax

**Correct (truly parallel)**:
```markdown
Invoke the following agents **in parallel**:
- agent-1 with: context.md
- agent-2 with: context.md
- agent-3 with: context.md

Make all three Task tool calls in a single message.
```

**Incorrect (actually sequential)**:
```markdown
Invoke agent-1 with: context.md
Invoke agent-2 with: context.md
Invoke agent-3 with: context.md

These will run sequentially, not in parallel.
```

### Example: PR Review Workflow

From exito plugin:

```markdown
**Phase 1: Context Establishment**
Invoke `context-gatherer` with: $1
Creates: .claude/sessions/pr_reviews/pr_$1_context.md

**Phase 2: Business Validation** (conditional)
If Azure DevOps URLs provided ($2, $3...):
  Invoke `business-validator` with: $1 $2 $3...
  Appends to: .claude/sessions/pr_reviews/pr_$1_context.md

**Phase 3: Parallel Analysis**
Invoke these agents **in parallel** (one message, multiple Task calls):
- `performance-analyzer`
- `architecture-reviewer`
- `clean-code-auditor`
- `security-scanner`
- `testing-assessor`
- `accessibility-checker`

All agents receive: .claude/sessions/pr_reviews/pr_$1_context.md

Each writes to: .claude/sessions/pr_reviews/pr_$1_[agent-name]_report.md

**Phase 4: Synthesis**
Read all reports from .claude/sessions/pr_reviews/
Synthesize into: .claude/sessions/pr_reviews/pr_$1_final_review.md
Display final review to user

**Token Efficiency**:
- Context file: ~2000 tokens (created once, read 6 times)
- Agent summaries: ~200 tokens each × 6 = ~1200 tokens
- Final synthesis: ~1000 tokens
- **Total**: ~4200 tokens vs ~25,000 tokens with message passing
- **Savings**: 83%
```

## Pattern 3: Hybrid Workflow

### When to Use
- Some agents must run sequentially
- Others can run in parallel
- Complex multi-stage processes

### Structure

```markdown
**Phase 1: Sequential Setup**
Invoke `setup-agent` with: $1
→ Creates baseline

**Phase 2: Parallel Analysis**
Invoke in parallel:
- `analyzer-1` with: setup output
- `analyzer-2` with: setup output
→ Each produces analysis

**Phase 3: Sequential Refinement**
Invoke `refiner` with: all analysis outputs
→ Refines findings

**Phase 4: Parallel Validation**
Invoke in parallel:
- `validator-1` with: refined output
- `validator-2` with: refined output
→ Independent validation

**Phase 5: Sequential Synthesis**
Synthesize all findings
→ Final report
```

### Example: Security Audit Workflow

```markdown
**Phase 1: Inventory** (sequential)
Invoke `codebase-scanner` with: $1
Creates: .claude/sessions/audit/inventory.md
Returns: "Scanned 234 files, identified 12 security-critical areas"

**Phase 2: Parallel Deep Scans** (parallel)
Invoke in parallel:
- `auth-scanner` with: .claude/sessions/audit/inventory.md
- `api-scanner` with: .claude/sessions/audit/inventory.md
- `crypto-scanner` with: .claude/sessions/audit/inventory.md
- `dependency-scanner` with: .claude/sessions/audit/inventory.md

Each writes to: .claude/sessions/audit/[scanner-name]_report.md

**Phase 3: Risk Assessment** (sequential)
Invoke `risk-assessor` with: .claude/sessions/audit/
Reads all scan reports
Creates: .claude/sessions/audit/risk_assessment.md
Returns: "Identified 3 critical, 7 high, 15 medium risks"

**Phase 4: Parallel Validation** (parallel)
Invoke in parallel:
- `exploit-validator` with: .claude/sessions/audit/risk_assessment.md
- `compliance-checker` with: .claude/sessions/audit/risk_assessment.md

Each writes to: .claude/sessions/audit/[validator-name]_report.md

**Phase 5: Final Report** (sequential)
Read all files in .claude/sessions/audit/
Synthesize executive summary
Prioritize remediation steps
Present comprehensive audit report
```

## Context Management Strategies

### Session Directory Pattern

```
.claude/sessions/
├── pr_reviews/
│   ├── pr_123_context.md           # Baseline context
│   ├── pr_123_performance_report.md
│   ├── pr_123_security_report.md
│   └── pr_123_final_review.md
├── audits/
│   ├── audit_2024_01_context.md
│   └── audit_2024_01_*.md
└── migrations/
    └── migration_v2_*.md
```

**Benefits**:
- Organized by workflow type
- Easy to find related files
- Clear audit trail
- Supports resumable workflows

### Single Source of Truth Pattern

```markdown
**Phase 1: Create SSOT**
Context-gatherer creates: context.md
This file contains ALL baseline data

**Phase 2: Enrichment**
Agents READ context.md
Agents APPEND findings to context.md OR write separate reports

**Phase 3: Synthesis**
Orchestrator reads context.md + reports
Synthesizes final output
```

**When to append vs separate files**:
- **Append**: When findings enrich baseline (e.g., business validation)
- **Separate**: When findings are large/specialized (e.g., security scan)

## Adaptive Strategies

### Scale Analysis with Input Size

```markdown
**Size Classification**:
- Small (< 200 lines): Full detailed analysis
- Medium (200-500 lines): Detailed with focus areas
- Large (500-1000 lines): Strategic sampling
- Very Large (> 1000 lines): Risk-based review

**Adaptive Execution**:
If size = Small or Medium:
  → Run all 8 analysis agents in parallel
  → Each does comprehensive analysis
Else if size = Large:
  → Run all 8 agents in parallel
  → Each focuses on high-risk patterns only
  → Sample representative files
Else (Very Large):
  → Run critical-path agents only (security, architecture)
  → Recommend splitting PR
  → Focus on integration points
```

### Example: Adaptive PR Review

```markdown
**Phase 1: Size Detection**
Invoke `context-gatherer` with: $1
Returns: "PR has 1200 lines changed (Large)"

**Phase 2: Strategy Selection**
Because PR is Large:
- Focus on critical files (API changes, auth, data handling)
- Sample UI components (10% of files)
- Full analysis of security-critical changes
- High-level architecture review

**Phase 3: Targeted Analysis**
Invoke in parallel:
- `security-scanner` (full depth)
- `architecture-reviewer` (high-level)
- `api-analyzer` (full depth)
- `ui-sampler` (10% sample)

**Phase 4: Report**
Synthesize findings
Recommend: "Consider splitting into 3 smaller PRs for better review"
```

## Error Handling in Workflows

### Graceful Degradation

```markdown
**Phase 2: Parallel Analysis**
Invoke 6 agents in parallel

**Expected**: All agents complete successfully
**Reality**: Some may fail

**Handling**:
For each agent:
  If success:
    ✓ Use report in synthesis
  If failure:
    ✓ Log error
    ✓ Continue with available reports
    ✓ Note limitation in final report

**Final Report**:
"Note: Performance analysis unavailable due to [error].
Recommendations based on 5/6 completed analyses."
```

### Retry Strategies

```markdown
**Phase 3: Critical Analysis**
Invoke `security-scanner` with: context.md

If agent fails:
  Retry once with simplified context
  If still fails:
    Log detailed error
    Proceed with other analyses
    Flag security review as incomplete

Final report includes:
"⚠️ Security analysis incomplete. Manual review recommended."
```

## Synthesis Patterns

### Aggregation Synthesis

Combine findings from multiple agents:

```markdown
**Synthesis Strategy**: Aggregate by priority

Read all reports:
- performance_report.md
- security_report.md
- quality_report.md

Group findings:
- Critical (P0): All issues requiring immediate fix
- High (P1): Issues for this iteration
- Medium (P2): Issues for next iteration
- Low (P3): Nice-to-haves

Output format:
## Executive Summary
[Overall assessment]

## Critical Issues (Must Fix)
[P0 findings from all agents]

## High Priority (Should Fix)
[P1 findings from all agents]

## Medium Priority (Consider)
[P2 findings]

## Quick Wins
[Easy high-impact fixes from any priority]
```

### Scoring Synthesis

Combine scores from multiple dimensions:

```markdown
**Synthesis Strategy**: Weighted average

Read all scores:
- Security: 8/10 (weight: 25%)
- Performance: 6/10 (weight: 20%)
- Architecture: 9/10 (weight: 20%)
- Code Quality: 7/10 (weight: 15%)
- Testing: 5/10 (weight: 10%)
- Accessibility: 8/10 (weight: 10%)

Calculate weighted score:
Overall = (8×0.25) + (6×0.20) + (9×0.20) + (7×0.15) + (5×0.10) + (8×0.10)
Overall = 2.0 + 1.2 + 1.8 + 1.05 + 0.5 + 0.8 = 7.35/10

Output:
**Overall Score**: 7.4/10
- ✅ Strong: Security, Architecture, Accessibility
- ⚠️ Needs Work: Performance, Testing
- 🎯 Focus Area: Improve test coverage (currently 5/10)
```

### Narrative Synthesis

Create cohesive story from findings:

```markdown
**Synthesis Strategy**: Narrative flow

Read all reports and identify themes:
1. Common patterns (e.g., "Missing error handling in 3 areas")
2. Root causes (e.g., "Performance issues stem from over-fetching")
3. Quick wins (e.g., "Adding loading states fixes 4 issues")

Create narrative:
## Overview
This PR introduces [feature] with solid architecture but needs refinement in error handling and performance optimization.

## Key Strengths
[Positive findings with supporting evidence from agents]

## Areas for Improvement
[Issues organized by theme, not by agent]

## Recommended Action Plan
1. **Immediate** (before merge): [Critical fixes]
2. **This Sprint**: [High-priority improvements]
3. **Next Iteration**: [Long-term enhancements]
```

## Performance Optimization

### Token Budget Management

```markdown
**Budget**: 100,000 tokens per workflow

**Allocation**:
- Context creation: 5,000 tokens
- Agent execution: 60,000 tokens (6 agents × 10,000 each)
- Synthesis: 10,000 tokens
- Buffer: 25,000 tokens

**Monitoring**:
If approaching limit:
1. Reduce analysis depth
2. Sample instead of full analysis
3. Focus on critical areas only
4. Skip low-priority checks
```

### Execution Time Optimization

```markdown
**Sequential** (slow):
Agent A (30s) → Agent B (30s) → Agent C (30s) = 90s total

**Parallel** (fast):
Agent A (30s) ┐
Agent B (30s) ├─ = 30s total
Agent C (30s) ┘

**Optimization Tips**:
1. Run independent agents in parallel
2. Use smaller context files
3. Cache expensive computations
4. Skip redundant checks
```

## Testing Workflows

### End-to-End Testing

```markdown
**Test Scenario**: PR Review Workflow

1. Create test PR with known issues
2. Run: /review [test-pr-number]
3. Verify:
   ✓ Context file created
   ✓ All agents executed
   ✓ Reports written to correct location
   ✓ Findings are accurate
   ✓ Synthesis is coherent
   ✓ Token usage within budget
   ✓ Execution time acceptable
```

### Component Testing

Test each phase independently:

```markdown
**Test Phase 1**: Context Gathering
Invoke `context-gatherer` with: 123
Verify: .claude/sessions/pr_reviews/pr_123_context.md created

**Test Phase 2**: Individual Agent
Invoke `security-scanner` with: .claude/sessions/pr_reviews/pr_123_context.md
Verify: Report created with expected findings

**Test Phase 3**: Synthesis
Manually create mock reports
Run synthesis phase
Verify: Correct aggregation and formatting
```

## Best Practices

### 1. File-Based Context First

Always prefer files over message passing:

```markdown
# ✅ Good
Create context file
Pass file path to agents
Agents write reports
Synthesizer reads files

# ❌ Bad
Pass context in message
Agents return full reports
Pass reports to synthesizer
```

### 2. Concise Agent Responses

Agents return summaries, not full reports:

```markdown
# ✅ Good
Agent writes report to file
Agent returns: "Found 12 issues (3 critical). Report at: [path]"

# ❌ Bad
Agent returns: [Full 5000-word report]
```

### 3. Parallel When Possible

Default to parallel for independent agents:

```markdown
# ✅ Good
Invoke in parallel:
- agent-a
- agent-b
- agent-c

# ❌ Bad (unless necessary)
Invoke agent-a
Wait
Invoke agent-b
Wait
Invoke agent-c
```

### 4. Clear Phase Separation

Structure workflows in distinct phases:

```markdown
**Phase 1: Setup**
[Setup tasks]

**Phase 2: Analysis**
[Analysis tasks]

**Phase 3: Synthesis**
[Synthesis tasks]
```

### 5. Adaptive Strategies

Scale analysis with input size:

```markdown
If input is small: Full detailed analysis
If input is large: Strategic sampling
If input is huge: Critical path only
```

### 6. Error Handling

Plan for agent failures:

```markdown
If agent fails:
- Log error
- Continue with other agents
- Note limitation in final report
- Provide manual review guidance
```

### 7. Measurable Success

Define success metrics:

```markdown
**Success Criteria**:
- All agents complete: 100%
- Token usage: < 50,000
- Execution time: < 2 minutes
- Findings accuracy: > 90%
- User satisfaction: 8+/10
```

## Real-World Example

Complete PR review workflow from exito plugin:

```markdown
---
description: "Comprehensive PR review with specialized agents"
argument-hint: "<PR_NUMBER> [AZURE_DEVOPS_URL]..."
allowed-tools: Bash(gh:*), Read, Write
---

You are the **PR Review Orchestrator**.

**Phase 1: Context Establishment**
Invoke `context-gatherer` agent with: $1
Agent:
- Fetches PR metadata with gh CLI
- Classifies PR size (Small/Medium/Large/Very Large)
- Fetches diff (full or sampled based on size)
- Creates: .claude/sessions/pr_reviews/pr_$1_context.md

Wait for completion.
Expected: "Context created for PR #$1 (size: Medium, 342 lines)"

**Phase 2: Business Validation** (conditional)
If Azure DevOps URLs provided ($2, $3, etc.):
  Invoke `business-validator` with: $1 $2 $3...
  Agent:
  - Reads context file
  - Fetches Work Items with MCP tools
  - Validates against acceptance criteria
  - Appends to: .claude/sessions/pr_reviews/pr_$1_context.md

  Wait for completion.
  Expected: "Validated against 2 Work Items. Alignment: 8/10"

**Phase 3: Parallel Analysis**
Invoke the following agents **in parallel** (one message, multiple Task calls):
- `performance-analyzer`
- `architecture-reviewer`
- `clean-code-auditor`
- `security-scanner`
- `testing-assessor`
- `accessibility-checker`

All agents receive: .claude/sessions/pr_reviews/pr_$1_context.md

Each agent:
1. Reads context file
2. Performs specialized analysis
3. Writes report to: .claude/sessions/pr_reviews/pr_$1_[agent-name]_report.md
4. Returns summary: "Found X issues (Y critical). Score: Z/10"

Wait for all agents to complete.

**Phase 4: Synthesis**
Read all reports from: .claude/sessions/pr_reviews/
- pr_$1_context.md (baseline)
- pr_$1_performance_report.md
- pr_$1_architecture_report.md
- pr_$1_clean_code_report.md
- pr_$1_security_report.md
- pr_$1_testing_report.md
- pr_$1_accessibility_report.md

Synthesize findings:
1. Calculate weighted overall score
2. Group findings by priority (P0, P1, P2, P3)
3. Identify quick wins
4. Create action plan

Write final review to: .claude/sessions/pr_reviews/pr_$1_final_review.md

Display to user:
- Executive summary
- Overall score
- Top 5 critical issues
- Quick wins
- Detailed findings by category
- Recommended action plan

**Token Efficiency**:
- Context file: ~2000 tokens (created once)
- 6 agent executions: ~1200 tokens in summaries
- Synthesis: ~1000 tokens
- Total: ~4200 tokens (vs ~25,000 with message passing)
- Savings: 83%

**Error Handling**:
- If PR not found: "PR #$1 not found. Verify number with `gh pr list`"
- If gh CLI fails: "GitHub CLI error. Run `gh auth login` and retry"
- If agent fails: Continue with other agents, note limitation in report
- If no changes relevant: "No [X] changes detected" (not an error)

**Adaptive Strategy**:
Based on PR size (from Phase 1):
- Small (<200 lines): Full detailed analysis from all agents
- Medium (200-500): Detailed analysis with focus areas
- Large (500-1000): Strategic sampling, high-risk focus
- Very Large (>1000): Critical path only, recommend split

**Success Metrics**:
- All agents complete: ✓ 6/6
- Token usage: ✓ 4,200 / 50,000 budget
- Execution time: ✓ ~45 seconds
- Findings: ✓ Actionable with file:line + fix
```

## Summary

- **Use files** for context sharing, not messages
- **Parallel execution** for independent agents
- **Sequential execution** when order matters
- **Concise summaries** from agents (< 200 words)
- **Adaptive strategies** based on input size
- **Error handling** for graceful degradation
- **Clear phases** for structured workflows
- **Synthesis patterns** for combining findings
- **Token optimization** for cost efficiency

Next: Read [MCP.md](MCP.md) to learn how to integrate external tools and services.
