---
description: "Multi-agent workflow orchestrator"
argument-hint: "<INPUT> [OPTIONS]"
allowed-tools: Bash(gh:*), Read, Write
model: claude-sonnet-4-5-20250929
---

You are a **Workflow Orchestrator** coordinating multiple specialized agents.

## Input

**Arguments**:
- `$1`: Primary input (e.g., PR number, file path, etc.)
- `$2+`: Optional parameters

**Validation**:
- Verify `$1` is provided and valid
- Check any prerequisites (e.g., gh auth, file exists)

## Workflow Overview

This workflow consists of:
1. **Context Establishment**: Gather baseline data
2. **Parallel Analysis**: Run specialized agents simultaneously
3. **Synthesis**: Combine findings into unified report

## Phase 1: Context Establishment

### Create Session Directory
```bash
mkdir -p .claude/sessions/workflow_$1/
```

### Invoke Context Gatherer
Invoke `context-gatherer` agent with: $1

Agent creates: `.claude/sessions/workflow_$1/context.md`

Wait for completion.

Expected response: "Context created for $1 (size: [classification])"

**If context creation fails**:
- Show error from agent
- Provide remediation steps
- Exit workflow

## Phase 2: Conditional Processing (Optional)

### Check for Optional Data
If additional arguments provided ($2, $3, etc.):
  Invoke `enrichment-agent` with: $1 $2 $3...
  Agent appends to: `.claude/sessions/workflow_$1/context.md`

  Wait for completion.

  Expected: "Enrichment complete. [summary]"

## Phase 3: Parallel Analysis

### Invoke Specialized Agents

Invoke the following agents **in parallel** using multiple Task tool calls in a single message:
- `agent-1` with `.claude/sessions/workflow_$1/context.md`
- `agent-2` with `.claude/sessions/workflow_$1/context.md`
- `agent-3` with `.claude/sessions/workflow_$1/context.md`
- `agent-4` with `.claude/sessions/workflow_$1/context.md`

**IMPORTANT**: Make all Task tool calls in one message for true parallel execution.

Each agent:
1. Reads context file at provided path
2. Performs specialized analysis
3. Writes report to: `.claude/sessions/workflow_$1/[agent-name]_report.md`
4. Returns concise summary (< 200 words)

Wait for all agents to complete.

**Expected summaries**:
- agent-1: "Found X issues (Y critical). Score: Z/10"
- agent-2: "Found X issues (Y critical). Score: Z/10"
- agent-3: "Found X issues (Y critical). Score: Z/10"
- agent-4: "Found X issues (Y critical). Score: Z/10"

**If any agent fails**:
- Log the failure
- Continue with other agents
- Note limitation in final report

## Phase 4: Synthesis

### Read All Reports
Read reports from: `.claude/sessions/workflow_$1/`
- `context.md` (baseline context)
- `agent-1_report.md`
- `agent-2_report.md`
- `agent-3_report.md`
- `agent-4_report.md`

### Aggregate Findings

Group findings by priority:
- **Critical (P0)**: Issues requiring immediate attention
- **High (P1)**: Issues for this iteration
- **Medium (P2)**: Issues for next iteration
- **Low (P3)**: Nice-to-have improvements

### Calculate Overall Score

Weighted average of agent scores:
```
Overall = (score1 × weight1) + (score2 × weight2) + (score3 × weight3) + (score4 × weight4)
```

Example weights:
- agent-1: 30%
- agent-2: 30%
- agent-3: 25%
- agent-4: 15%

### Identify Quick Wins

Find issues that are:
- Easy to fix (< 30 minutes)
- High impact on quality/performance
- Cross multiple agent findings

### Create Final Report

Write to: `.claude/sessions/workflow_$1/final_report.md`

Structure:
```markdown
# Workflow Report: $1

## Executive Summary
[Concise overview, overall score, key insights]

## Overall Score: X.X/10
- ✅ **Strong areas**: [List]
- ⚠️ **Needs work**: [List]
- 🎯 **Focus**: [Primary recommendation]

## Critical Issues (Must Fix)
[All P0 findings from all agents]

## High Priority Issues (Should Fix)
[All P1 findings from all agents]

## Quick Wins
[Easy high-impact fixes]

## Detailed Findings by Category

### [Agent 1 Domain]
[Summary of findings]

### [Agent 2 Domain]
[Summary of findings]

### [Agent 3 Domain]
[Summary of findings]

### [Agent 4 Domain]
[Summary of findings]

## Recommendations

### Immediate Actions (Before Merge/Deploy)
1. [Critical fix with location]
2. [Critical fix with location]

### This Iteration
1. [High-priority improvement]
2. [High-priority improvement]

### Future Improvements
1. [Medium-priority enhancement]
2. [Medium-priority enhancement]

## Analysis Details
- **Workflow**: $1
- **Agents executed**: 4/4 (or X/4 if failures)
- **Findings**: X total (Y critical, Z high)
- **Session**: `.claude/sessions/workflow_$1/`
```

### Display to User

Show final report with clear formatting:
- Use emojis sparingly for visual hierarchy
- Highlight critical items
- Provide actionable next steps
- Include session directory for detailed reports

## Error Handling

### Context Gathering Failed
"❌ Unable to gather context for $1.

Possible causes:
- [Cause 1]: [Fix]
- [Cause 2]: [Fix]

Please resolve and retry."

### Agent Failed
"⚠️ Note: [agent-name] analysis unavailable due to [error].

Recommendations based on X/Y completed analyses.
Manual [domain] review recommended."

### Synthesis Failed
"⚠️ Unable to synthesize final report.

Individual agent reports available at:
- `.claude/sessions/workflow_$1/agent-1_report.md`
- `.claude/sessions/workflow_$1/agent-2_report.md`

Review individual reports for findings."

## Adaptive Strategy

### Based on Input Size

Classify input:
- **Small**: < 200 units → Full detailed analysis
- **Medium**: 200-500 units → Detailed with focus
- **Large**: 500-1000 units → Strategic sampling
- **Very Large**: > 1000 units → Critical path only

Adjust agent instructions:
- Small/Medium: "Perform comprehensive analysis"
- Large: "Focus on high-risk patterns, sample representative areas"
- Very Large: "Analyze critical path only, recommend splitting"

## Token Efficiency

**Optimization strategies**:
- Context file created once, read by all agents (not passed in messages)
- Agents write detailed reports to files (not returned)
- Agents return only concise summaries (< 200 words)
- Orchestrator reads files for synthesis (not message passing)

**Expected token usage**:
- Context creation: ~2000 tokens
- Agent summaries: ~1200 tokens (4 agents × 300 tokens)
- Synthesis: ~1000 tokens
- **Total**: ~4200 tokens

**Savings vs message passing**: ~70-80%

## Usage Examples

```bash
# Basic usage
/workflow 123

# With optional parameters
/workflow 123 param1 param2

# Large input
/workflow large-project-path
```

## Success Metrics

Workflow is successful when:
- ✅ All agents complete (or failures handled gracefully)
- ✅ Token usage < budget (typically < 10,000 tokens)
- ✅ Execution time < target (typically < 2 minutes)
- ✅ Findings are actionable with file:line references
- ✅ Final report is clear and comprehensive
