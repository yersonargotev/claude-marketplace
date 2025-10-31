# Plugin Architecture Reference

Complete reference guide for Claude Code plugin best practices, patterns, and standards.

## Agent System Prompt Structure

Every agent should follow this template for consistency and clarity:

```markdown
---
name: agent-name
description: "Clear description of when this agent should be invoked"
tools: Bash(gh:*), Read, Write  # Only tools necessary for the task
model: claude-sonnet-4-5-20250929
---

<role>
Clear identity statement. Who is this agent? What persona does it embody?
</role>

<specialization>
- Specific expertise areas
- Key focus domains
- Domain knowledge
</specialization>

<input>
Expected arguments and their format:
- $1: Path to context file
- $2: Additional parameter
</input>

<workflow>
### Step 1: Preparation
Detailed step description with sub-tasks

### Step 2: Analysis
What to analyze and how

### Step 3: Output
How to format and persist findings
</workflow>

<output_format>
Exact structure of expected output with example:

## Executive Summary
[Brief overview]

## Findings
### Issue 1: Title
- File: path:line
- Severity: Critical/High/Medium/Low
- Impact: Description
- Fix: Code example

## Score
X/10 - Rationale
</output_format>

<error_handling>
- If X happens: Do Y
- If Z is missing: Provide fallback
- For edge case: Handle gracefully
</error_handling>

<best_practices>
Domain-specific guidelines and patterns
</best_practices>
```

## Context Management Best Practices

### File-Based Communication Pattern

**Principle**: Minimize token usage by persisting context to disk and passing file paths.

**Implementation**:

```markdown
# Orchestrator (Command)
1. Invoke context-gatherer agent
2. Agent creates `.claude/sessions/domain/context_123.md`
3. Pass file path to downstream agents: `$1 = context_123.md`
4. Agents read context from file, never receive full content in prompt
```

**Benefits**:
- 60-70% reduction in token usage
- Eliminates context loss between agents
- Enables resumable workflows for large tasks
- Provides audit trail

### Context Session Structure

Organize sessions by domain:

```
.claude/sessions/
├── pr_reviews/
│   ├── pr_123_context.md
│   ├── pr_123_performance_report.md
│   ├── pr_123_security_report.md
│   └── pr_123_final_review.md
├── features/
│   ├── feature_abc_research.md
│   ├── feature_abc_plan.md
│   └── feature_abc_implementation.md
└── refactoring/
    └── refactor_xyz_analysis.md
```

### Agent Response Guidelines

**Orchestrator expects concise summaries, NOT full reports**:

✅ **GOOD** (< 200 words):
```markdown
Performance analysis complete. Found 3 critical issues:
1. Infinite useEffect loop in useCart.ts (P0)
2. Missing React.memo on expensive component (P1)
3. Large bundle due to unoptimized imports (P2)

Full report: .claude/sessions/pr_reviews/pr_123_performance_report.md
Score: 6.5/10
```

❌ **BAD** (thousands of words):
```markdown
# Performance Analysis Report

## Executive Summary
[500 words]

## Findings
[Detailed analysis of every file - 2000+ words]

## Code Examples
[Full before/after code - 1000+ words]
```

## Tool Access Patterns

### Bash Tool Restrictions

Use pattern-based restrictions to limit bash execution:

```yaml
# GitHub CLI only
tools: Bash(gh:*)

# Azure CLI only
tools: Bash(az:*)

# Specific npm commands
tools: Bash(npm:audit), Bash(npm:test), Bash(npm:run)

# Git commands only
tools: Bash(git:*)

# Multiple patterns
tools: Bash(gh:*), Bash(git:*), Bash(npm:*)
```

### When to Grant File I/O

**Read** - Agent needs to examine files:
```yaml
tools: Read, Grep, Glob  # Read-only file access
```

**Write** - Agent creates new files:
```yaml
tools: Write, Read  # Can create and read
```

**Edit** - Agent modifies existing files:
```yaml
tools: Edit, Read  # Can modify and read
```

### Tool Selection Decision Tree

```
Does agent need to execute commands?
├─ YES: What type?
│  ├─ GitHub CLI → Bash(gh:*)
│  ├─ Azure CLI → Bash(az:*)
│  ├─ npm commands → Bash(npm:audit), Bash(npm:test)
│  ├─ git commands → Bash(git:*)
│  └─ Other → Specify pattern: Bash(cmd:*)
└─ NO: File operations only?
   ├─ Read files → Read, Grep, Glob
   ├─ Create files → Write, Read
   ├─ Modify files → Edit, Read
   └─ All file ops → Read, Write, Edit, Grep, Glob
```

## Scoring and Metrics

### Consistent Scoring System

**Start at 10 (perfect) and deduct points**:

```
Critical issues (P0):  -3 to -5 points
High issues (P1):      -1 to -2 points
Medium issues (P2):    -0.5 to -1 points
Low issues (P3):       -0.25 to -0.5 points

Excellent patterns:    +0.5 to +1 points
```

**Score interpretation**:
- 9-10: Excellent
- 7-8.9: Good
- 5-6.9: Fair (needs improvement)
- 3-4.9: Poor (significant issues)
- 1-2.9: Critical (major refactor needed)
- Minimum: 1 (never 0 or negative)

### Example Scoring Rationale

```markdown
## Score: 6.5/10

**Deductions**:
- Infinite useEffect loop (Critical, -3)
- Missing memoization on expensive component (High, -1.5)
- Unoptimized imports (Medium, -0.5)

**Credits**:
- Good TypeScript usage (+0.5)
- Proper error boundaries (+0.5)

**Total**: 10 - 3 - 1.5 - 0.5 + 0.5 + 0.5 = 6.5/10

**Verdict**: Fair - needs performance optimization before merge.
```

## Output Quality Standards

### Anatomy of a High-Quality Finding

Every issue report must include these 5 elements:

```markdown
### Issue: [Clear, Descriptive Title]

**File**: `src/path/to/file.tsx:42-48`
**Severity**: Critical (P0)
**Impact**: [Specific consequence - performance cost, security risk, bug]
**Root Cause**: [Why this is a problem]

**Current Code**:
```typescript
// Bad pattern
useEffect(() => {
  setCount(count + 1);
}, [count]);  // ❌ Infinite loop
```

**Fix**:
```typescript
// Correct pattern
useEffect(() => {
  setCount(prevCount => prevCount + 1);
}, []);  // ✅ Run once
```

**Testing**:
- Add test case to verify behavior
- Check console for warnings

**Priority**: P0 - Must fix before merge
```

### Priority Levels

**P0 - Critical**: Blocks release, breaks functionality, security vulnerability
**P1 - High**: Significant impact, should fix before merge
**P2 - Medium**: Improvements recommended, can merge with acknowledgment
**P3 - Low**: Nice-to-have, technical debt, future optimization

## Error Handling Patterns

### Defensive Agent Design

Every agent should handle common failure modes:

```markdown
<error_handling>
### Missing Context File
- Check if $1 file path exists
- If not: Report clear error with recovery steps
- Suggest running prerequisite agent first

### Tool Execution Failures
- GitHub CLI not authenticated: Provide `gh auth login` instructions
- Azure CLI not configured: Provide setup commands
- npm/yarn not installed: Detect and provide installation guidance

### Empty or Invalid Data
- PR has no changes: Report "No changes detected" (not an error)
- Large dataset: Implement sampling strategy
- Malformed input: Validate and provide specific error message

### Timeout or Rate Limits
- GitHub API rate limit: Cache responses, suggest waiting
- Large file processing: Break into chunks
- Network errors: Retry with exponential backoff
</error_handling>
```

### Example Error Messages

❌ **BAD**:
```
Error: Something went wrong
```

✅ **GOOD**:
```
Error: Context file not found at `.claude/sessions/pr_reviews/pr_123_context.md`

This usually means the context-gatherer agent hasn't run yet.

To fix:
1. Ensure you're running the review command correctly: `/review 123`
2. Check that GitHub CLI is authenticated: `gh auth status`
3. If problem persists, run context-gatherer manually
```

## Multi-Agent Orchestration

### Parallel Execution Pattern

**Principle**: Independent agents should run concurrently for maximum efficiency.

**Implementation**:

```markdown
### Phase 2: Parallel Analysis

Invoke the following agents **in parallel** using multiple Task tool calls in a single message:
- performance-analyzer (reads context from $1)
- architecture-reviewer (reads context from $1)
- security-scanner (reads context from $1)
- testing-assessor (reads context from $1)

**Critical**: Use ONE message with MULTIPLE Task tool invocations.

Each agent:
1. Reads context from file path $1
2. Performs specialized analysis
3. Writes report to `.claude/sessions/pr_reviews/pr_{number}_{agent}_report.md`
4. Returns concise summary (< 200 words)
```

### Sequential Execution Pattern

When agents have dependencies:

```markdown
### Phase 1: Context Establishment (Sequential)

1. Invoke context-gatherer agent
   - Wait for completion
   - Captures file path: `$context_file`

2. Invoke business-validator agent (if needed)
   - Pass: $1 = $context_file
   - Wait for completion
   - Validator appends to context file

### Phase 2: Analysis (Parallel - see above)

### Phase 3: Synthesis (Sequential)

1. Wait for all parallel agents to complete
2. Read all report files from disk
3. Synthesize into final review
```

## Adaptive Strategies

### PR Size Classification

Implement dynamic strategies based on scope:

```markdown
<workflow>
### Step 1: Classify Scope

Calculate total lines changed:
- Small: < 200 lines → Full detailed review
- Medium: 200-500 lines → Detailed with focused analysis
- Large: 500-1000 lines → Strategic sampling
- Very Large: > 1000 lines → Risk-based review

### Step 2: Adapt Analysis Depth

**Small/Medium PRs**:
- Review every changed line
- Full context for all files
- Comprehensive examples

**Large PRs**:
- Focus on critical patterns (hooks, state, data fetching)
- Sample representative files
- Prioritize high-risk areas

**Very Large PRs**:
- Risk-based analysis only
- Recommend splitting PR
- Focus on security/performance critical paths
</workflow>
```

## Plugin File Structure Standards

### Standard Plugin Layout

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata
├── commands/                 # User-facing slash commands
│   ├── primary-command.md
│   ├── secondary-command.md
│   └── setup.md
├── agents/                   # Specialized sub-agents
│   ├── investigator.md
│   ├── architect.md
│   ├── builder.md
│   ├── validator.md
│   └── auditor.md
├── skills/                   # Optional: bundled skills
│   └── skill-name/
│       └── SKILL.md
├── .mcp.json                # MCP server configuration
├── README.md                # User documentation
└── CLAUDE.md                # Instructions for Claude Code
```

### Naming Conventions

**Commands**: lowercase-with-hyphens
```
✅ review-pr.md
✅ setup-dependencies.md
❌ ReviewPR.md
❌ setup_dependencies.md
```

**Agents**: descriptive-role-name
```
✅ context-gatherer.md
✅ performance-analyzer.md
❌ agent1.md
❌ perf_agent.md
```

**Skills**: noun-or-capability
```
✅ pdf-processing/
✅ commit-helper/
❌ ProcessPDFs/
❌ commit_msgs/
```

## Command Design Patterns

### Orchestrator Command Structure

```markdown
---
description: "Brief description of command functionality"
argument-hint: "<REQUIRED> [OPTIONAL]"
---

# Command Name

## Purpose
Clear statement of what this command accomplishes.

## Prerequisites
- Tool requirements (gh, az, etc.)
- Environment setup needed
- Authentication requirements

## Arguments
- `$1` - Required argument description
- `$2` - Optional argument description

## Workflow

### Phase 1: Setup and Validation
1. Validate arguments
2. Check prerequisites
3. Create session directory

### Phase 2: Context Gathering
Invoke context-gathering agent(s) sequentially.

### Phase 3: Parallel Analysis
Invoke specialized agents in parallel.

### Phase 4: Synthesis
Combine results and present to user.

## Output
- Location of generated files
- Summary of findings
- Next steps for user

## Error Handling
- Common errors and solutions
- Recovery procedures
```

## MCP Server Integration

### Configuration Pattern

Store MCP config in plugin root as `.mcp.json`:

```json
{
  "mcpServers": {
    "server-name": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "API_KEY": "${ENV_VAR_NAME}"
      },
      "description": "What this server provides"
    }
  }
}
```

### Using MCP Tools in Agents

```yaml
---
name: agent-with-mcp
description: "Agent that uses MCP tools"
tools: Bash(gh:*), Read, Write
model: claude-sonnet-4-5-20250929
---

<workflow>
### Step 1: Use MCP Tool

Call the MCP tool using the fully qualified name:
- Tool: `mcp__server-name__tool-name`
- Example: `mcp__context7__get-library-docs`

### Step 2: Process Response
Parse the MCP response and incorporate into analysis.
</workflow>
```

## Testing and Validation

### Agent Testing Checklist

Before deploying an agent, test with:

- [ ] Small input (< 100 lines/items)
- [ ] Medium input (200-500 lines/items)
- [ ] Large input (> 1000 lines/items)
- [ ] Empty/no relevant data
- [ ] Malformed input
- [ ] Missing dependencies
- [ ] Tool failure scenarios

### Validation Criteria

**Functional**:
- ✓ Agent completes without errors
- ✓ Output file created in correct location
- ✓ Summary returned is concise (< 200 words)
- ✓ Findings are actionable and specific

**Non-Functional**:
- ✓ Token usage within budget
- ✓ Execution time reasonable (< 2 minutes for typical input)
- ✓ No false positives in findings
- ✓ Graceful handling of edge cases

### Performance Benchmarks

Target metrics for well-designed plugins:

- **Token Efficiency**: < 10,000 tokens per review/analysis
- **Execution Time**: < 5 minutes for large PRs (< 1 minute for small)
- **Accuracy**: < 10% false positive rate on findings
- **Completeness**: > 90% detection of known issues in test cases

## Anti-Patterns to Avoid

### 1. Context Duplication

❌ **BAD**: Passing full context to every agent in messages
```markdown
Invoke performance-analyzer with: [Full 10,000 line diff]
Invoke security-scanner with: [Same 10,000 line diff]
```

✅ **GOOD**: Pass file path, agents read once
```markdown
Invoke performance-analyzer with: $1 = context_file.md
Invoke security-scanner with: $1 = context_file.md
```

### 2. Vague Agent Responsibilities

❌ **BAD**: "Code analyzer" (what kind of code? what analysis?)
✅ **GOOD**: "React performance analyzer focusing on hooks and rendering"

### 3. Unrestricted Tool Access

❌ **BAD**: `tools: Bash(*)`
✅ **GOOD**: `tools: Bash(gh:*), Bash(npm:audit)`

### 4. Generic Error Messages

❌ **BAD**: "Error occurred"
✅ **GOOD**: "GitHub CLI not authenticated. Run: gh auth login"

### 5. Returning Full Reports

❌ **BAD**: Agent response includes entire 2000-word report
✅ **GOOD**: Agent returns 150-word summary, persists full report to disk

### 6. Over-Engineering

❌ **BAD**: Creating 20 hyper-specialized agents for simple task
✅ **GOOD**: 3-5 focused agents that cover all necessary analysis

### 7. Demanding Perfection

❌ **BAD**: "Must achieve 100% test coverage and zero issues"
✅ **GOOD**: "Aim for 80%+ coverage, prioritize critical paths"

## Continuous Improvement

### Metrics to Track

1. **Token Usage**: Monitor per-review consumption
2. **Execution Time**: Measure end-to-end latency
3. **Finding Accuracy**: Track false positives/negatives
4. **User Satisfaction**: Collect feedback on usefulness

### When to Refactor

Refactor an agent when:
- Token usage consistently exceeds budget (> 15,000 tokens)
- Execution time too long (> 3 minutes for typical input)
- High false positive rate (> 20%)
- Findings lack actionable detail (user confusion)
- Frequent timeout errors

### Optimization Techniques

1. **Progressive Disclosure**: Move detailed content to separate files
2. **Sampling**: For large inputs, analyze representative samples
3. **Caching**: Cache expensive operations (API calls, file parsing)
4. **Lazy Loading**: Load context only when needed
5. **Parallel Processing**: Run independent tasks concurrently
