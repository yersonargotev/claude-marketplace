# Creating Specialized Subagents

Subagents are specialized assistants that perform focused tasks. This guide covers everything you need to design effective, efficient subagents.

## Agent Basics

### File Structure

Agents are markdown files in the `agents/` directory:

```
my-plugin/
└── agents/
    ├── analyzer.md        # Code analysis agent
    ├── reviewer.md        # Code review agent
    └── fixer.md           # Automated fix agent
```

### Minimal Agent

```markdown
---
name: code-analyzer
description: "Analyzes code for quality issues"
tools: Read
model: claude-sonnet-4-5-20250929
---

You are a code quality analyzer.

Analyze the code provided and report issues.
```

## YAML Frontmatter

The frontmatter defines agent behavior:

```yaml
---
name: security-scanner                     # Agent identifier (required)
description: "When to invoke this agent"  # Clear trigger (required)
tools: Bash(gh:*), Read, Write             # Tool permissions
model: claude-sonnet-4-5-20250929          # Model to use
---
```

### Frontmatter Fields

| Field | Description | Example |
|-------|-------------|---------|
| `name` | Agent identifier (required) | `code-analyzer` |
| `description` | When to invoke (required) | `"Analyzes code for security vulnerabilities"` |
| `tools` | Tool permissions | `Bash(gh:*), Read, Write` |
| `model` | Model to use | `claude-sonnet-4-5-20250929` |

### Model Selection

**Use explicit model (recommended)**:
```yaml
model: claude-sonnet-4-5-20250929
```

**Inherit from parent** (use cautiously):
```yaml
model: inherit
```

Only use `inherit` when:
- Agent must match parent's reasoning style
- Parent uses experimental/specific model
- Cost optimization (parent uses cheaper model)

## Subagent vs Main Thread

### Key Differences

| Aspect | Main Thread | Subagent |
|--------|-------------|----------|
| **Context** | Full conversation history | Clean slate (only system prompt + args) |
| **State** | Persistent across turns | Isolated, single execution |
| **Tools** | Inherited from command | Explicitly granted in frontmatter |
| **Model** | Command default | Specified in agent frontmatter |
| **cwd** | Maintains between calls | Resets to project root |

### When to Use Subagents

**Use subagents when**:
- Task requires focused expertise
- Need tool restrictions for security
- Want parallel execution
- Require clean context (no history bleed)
- Delegating to domain specialist

**Use main thread when**:
- Task requires conversation history
- Needs high-level orchestration
- Interactive with user
- Simple, single-step tasks

## Agent Structure

### Recommended Template

```markdown
---
name: agent-name
description: "Clear description of when to invoke this agent"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are [identity statement]. Your expertise is [domain].
</role>

<specialization>
- Focus area 1
- Focus area 2
- Focus area 3
</specialization>

<input>
**Arguments**:
- `$1`: First argument description
- `$2`: Second argument description

**Expected format**: Description of input structure
</input>

<workflow>
### Step 1: [Action]
Description of first step

### Step 2: [Action]
Description of second step

### Step 3: [Action]
Description of third step
</workflow>

<output_format>
**Structure**:
```markdown
## Summary
[Concise overview]

## Findings
[Detailed findings]

## Recommendations
[Actionable items]
```
</output_format>

<error_handling>
- **If X**: Do Y
- **If Z**: Do W
- **Fallback**: Graceful degradation strategy
</error_handling>

<best_practices>
- Domain-specific guideline 1
- Domain-specific guideline 2
- Domain-specific guideline 3
</best_practices>
```

### Why This Structure?

- **`<role>`**: Establishes clear identity
- **`<specialization>`**: Defines expertise boundaries
- **`<input>`**: Documents expected arguments
- **`<workflow>`**: Provides step-by-step process
- **`<output_format>`**: Ensures consistent outputs
- **`<error_handling>`**: Handles edge cases
- **`<best_practices>`**: Domain-specific guidelines

## Working with Arguments

### Accessing Arguments

Agents receive arguments as `$1`, `$2`, etc.:

```markdown
<input>
**Arguments**:
- `$1`: File path to analyze
- `$2`: Analysis depth (optional, defaults to "medium")
</input>

<workflow>
### Step 1: Read Input
Read file at path: $1
Use analysis depth: $2 (if provided) or "medium"
</workflow>
```

**Invocation**: `Invoke security-scanner with: src/auth.ts deep`

### Argument Validation

```markdown
<workflow>
### Step 1: Validate Input
Check that $1 is provided:
- If missing: Return error "File path required as $1"
- If file doesn't exist: Return error "File not found: $1"
- If valid: Proceed to analysis
</workflow>
```

## Tool Permissions

### Restrictive (Recommended)

```yaml
tools: Read, Write
```

Grant only what's needed. This is the default.

### Bash Access

```yaml
tools: Bash(gh:*), Read, Write
```

Restrict bash to specific commands:
- `Bash(gh:*)` - Only GitHub CLI
- `Bash(git:status,git:log)` - Specific git commands
- `Bash(npm:test)` - Only npm test

### No Tools

```yaml
tools: ""
```

Agent relies only on system prompt knowledge. Use for pure reasoning tasks.

## System Prompt Engineering

### High-Signal Instructions

**❌ Vague**:
```markdown
Analyze the code and find issues.
```

**✅ Specific**:
```markdown
<workflow>
### Step 2: Scan for React Anti-Patterns
Look for:

**useEffect Infinite Loops**:
```typescript
// BAD: Causes infinite re-renders
useEffect(() => {
  setCount(count + 1);
}, [count]);

// GOOD: Uses functional update
useEffect(() => {
  setCount(prev => prev + 1);
}, []);
```

**Missing Dependency Arrays**:
```typescript
// BAD: Missing dependencies
useEffect(() => {
  fetchData(userId);
}); // Runs every render!

// GOOD: Proper dependencies
useEffect(() => {
  fetchData(userId);
}, [userId]);
```
</workflow>
```

### Concrete Examples

Include code examples for key patterns:

```markdown
<best_practices>
## Security Patterns

**XSS Prevention**:
```typescript
// ❌ DANGEROUS: Direct HTML injection
<div dangerouslySetInnerHTML={{__html: userInput}} />

// ✅ SAFE: React escapes by default
<div>{userInput}</div>

// ✅ SAFE: DOMPurify sanitization
<div dangerouslySetInnerHTML={{__html: DOMPurify.sanitize(userInput)}} />
```
</best_practices>
```

### Scoring Rubrics

When agents provide scores, include clear criteria:

```markdown
<scoring>
**Scale**: 1-10 (start at 10, deduct for issues)

**Deductions**:
- **Critical issues** (P0): -3 to -5 points
  - Infinite loops, security vulnerabilities, data loss risks
- **High severity** (P1): -1 to -2 points
  - Performance degradation, maintainability issues
- **Medium severity** (P2): -0.5 to -1 points
  - Code style, minor optimizations

**Bonuses**:
- Excellent patterns: +0.5 to +1 point
- Exceptional architecture: +1 point

**Minimum score**: 1 (never 0 or negative)
</scoring>
```

## Output Quality

### Required Elements

Every finding MUST include:

1. **Location**: `src/components/Hero.tsx:42-48`
2. **Description**: What is the issue?
3. **Impact**: Why does this matter?
4. **Fix**: Concrete code example (before/after)
5. **Priority**: Critical / High / Medium / Low

**Example**:

```markdown
### Issue: useEffect Infinite Loop

- **File**: `src/hooks/useCart.ts:23-27`
- **Severity**: Critical (P0)
- **Impact**: Component re-renders infinitely, freezing browser

**Current Code**:
```typescript
useEffect(() => {
  setCount(count + 1);
}, [count]); // Re-runs when count changes, which it does every render!
```

**Fix**:
```typescript
useEffect(() => {
  setCount(prev => prev + 1);
}, []); // Runs once on mount only
```

**Why it works**: Functional update doesn't depend on current state, breaking the cycle.
```

### Token-Efficient Output

**❌ Return full report to orchestrator**:
```markdown
Return to orchestrator:
[10,000 word detailed analysis]
```

**✅ Write to file, return summary**:
```markdown
<output_format>
**Process**:
1. Write detailed findings to: `.claude/sessions/analysis/security_report.md`
2. Return concise summary to orchestrator (< 200 words)

**Summary format**:
- Issues found: X
- Critical: Y
- High: Z
- Report location: [file path]
</output_format>
```

## Agent Patterns

### 1. Analysis Agent

```markdown
---
name: performance-analyzer
description: "Analyzes React/Next.js code for performance issues"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a React Performance Engineer specializing in identifying bottlenecks.
</role>

<specialization>
- React hooks optimization
- Next.js rendering strategies
- Bundle size analysis
- Runtime performance
</specialization>

<input>
**Arguments**:
- `$1`: Path to context file with code diffs
</input>

<workflow>
### Step 1: Read Context
Read file at path: $1
Extract React/Next.js files (.tsx, .jsx, .ts, .js)

### Step 2: Analyze Patterns
Scan for:
- useEffect without dependencies or with issues
- Missing useMemo/useCallback for expensive operations
- Improper Next.js data fetching (getServerSideProps overuse)
- Large bundle imports (lodash, moment.js without tree-shaking)

### Step 3: Generate Report
Write findings to: `.claude/sessions/analysis/performance_report.md`
Include:
- Executive summary with score (1-10)
- Detailed findings with code examples
- Prioritized recommendations

### Step 4: Return Summary
Return to orchestrator:
- Total issues: X
- Critical: Y
- Score: Z/10
- Report location
</workflow>

<output_format>
[See Token-Efficient Output section above]
</output_format>

<error_handling>
- If context file missing: "Error: Context file not found at $1. Run context-gatherer first."
- If no React files: "No React/Next.js files detected. Skipping performance analysis."
- If analysis fails: "Partial analysis completed. Review available findings."
</error_handling>

<best_practices>
[Include React performance best practices with code examples]
</best_practices>
```

### 2. Context Gathering Agent

```markdown
---
name: context-gatherer
description: "Gathers PR context and creates baseline for other agents"
tools: Bash(gh:*), Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a Context Gatherer. You create the single source of truth for PR analysis.
</role>

<workflow>
### Step 1: Fetch PR Metadata
!gh pr view $1 --json number,title,body,author,files,additions,deletions,headRefName,baseRefName

### Step 2: Classify PR Size
Based on additions + deletions:
- **Small**: < 200 lines
- **Medium**: 200-500 lines
- **Large**: 500-1000 lines
- **Very Large**: > 1000 lines

### Step 3: Fetch Diff (Adaptive)
If Small/Medium:
  !gh pr diff $1
Else (Large/Very Large):
  Focus on critical patterns:
  !gh pr diff $1 | grep -A 10 -B 2 "useEffect\|useState\|fetch\|axios"

### Step 4: Create Context File
Write to: `.claude/sessions/pr_reviews/pr_$1_context.md`
Include:
- PR metadata
- Size classification
- Changed files list
- Code diff (full or sampled)
- Analysis strategy recommendation

### Step 5: Return Summary
Confirm context file created with:
- PR number, title, author
- Size classification
- Files changed count
- Next steps
</workflow>
```

### 3. Validation Agent

```markdown
---
name: business-validator
description: "Validates PR against Azure DevOps User Stories"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a Business Analyst. You ensure code changes align with requirements.
</role>

<specialization>
- Requirements validation
- Acceptance criteria verification
- Gap analysis
- Business impact assessment
</specialization>

<input>
**Arguments**:
- `$1`: PR number
- `$2+`: Azure DevOps Work Item URLs
</input>

<workflow>
### Step 1: Read PR Context
Read context file: `.claude/sessions/pr_reviews/pr_$1_context.md`

### Step 2: Fetch User Stories
For each URL in $2, $3, $4...:
  Use MCP tool: mcp__microsoft_azu_wit_get_work_item
  Extract:
  - Title, description
  - Acceptance criteria
  - Status

### Step 3: Validate Alignment
Compare PR changes against acceptance criteria:
- Are all criteria addressed?
- Are there extra changes not in requirements?
- Does implementation match intent?

### Step 4: Update Context
Append findings to: `.claude/sessions/pr_reviews/pr_$1_context.md`
Add section: "## Business Validation"

### Step 5: Return Summary
Report:
- Work items validated: X
- Criteria met: Y/Z
- Gaps identified: W
- Alignment score: A/10
</workflow>

<error_handling>
- If Azure CLI not authenticated: "Run `az login --allow-no-subscriptions`"
- If work item not found: "Work item URL invalid or not accessible"
- If no acceptance criteria: "Work item lacks acceptance criteria. Manual validation recommended."
</error_handling>
```

### 4. Synthesis Agent

```markdown
---
name: report-synthesizer
description: "Synthesizes findings from multiple agents into unified report"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a Technical Writer. You synthesize complex findings into clear, actionable reports.
</role>

<workflow>
### Step 1: Read All Reports
Read reports from: `.claude/sessions/pr_reviews/`
- pr_$1_performance_report.md
- pr_$1_security_report.md
- pr_$1_architecture_report.md
- pr_$1_clean_code_report.md
- pr_$1_testing_report.md
- pr_$1_accessibility_report.md

### Step 2: Aggregate Findings
Group findings by:
- Critical issues (P0)
- High priority (P1)
- Medium priority (P2)
- Low priority (P3)

### Step 3: Synthesize
Create unified report with:
- Executive summary (< 200 words)
- Overall score (weighted average)
- Top 5 critical issues
- Quick wins (easy fixes with high impact)
- Long-term recommendations

### Step 4: Save Report
Write to: `.claude/sessions/pr_reviews/pr_$1_final_review.md`

### Step 5: Display to User
Show final report with clear sections and actionable items.
</workflow>
```

## Context Preservation

### File-Based Communication (Recommended)

```markdown
<workflow>
### Step 1: Read Context
Read context from file: $1
This file contains:
- PR metadata
- Code diffs
- Previous findings

### Step 2: Perform Analysis
[Your analysis logic]

### Step 3: Persist Findings
Write report to: `.claude/sessions/analysis/my_report.md`

### Step 4: Return Summary
Return concise summary (< 200 words) to orchestrator
</workflow>
```

**Benefits**:
- Dramatic token savings
- No context loss
- Enables resumable workflows
- Provides audit trail

### Message-Based Communication (Avoid)

```markdown
# ❌ DON'T: Pass large context
Analyze this code:
[10,000 lines of diff]
```

This wastes tokens and hits context limits.

## Error Handling

### Graceful Degradation

```markdown
<error_handling>
**Tool Failures**:
- If `gh` CLI fails: Check authentication, provide `gh auth login` command
- If file not readable: Skip file, note in report
- If MCP tool unavailable: Proceed with partial analysis

**Invalid Input**:
- If $1 missing: Return error with usage example
- If file doesn't exist: Return error with file check suggestion
- If format unexpected: Attempt parsing, document issues

**Partial Failures**:
- If some analysis fails: Complete available analysis
- Document what succeeded and what failed
- Provide partial results with confidence level
</error_handling>
```

### Clear Error Messages

```markdown
# ❌ Generic error
"Error: Analysis failed"

# ✅ Specific error with remediation
"Error: Unable to fetch PR #123.

Possible causes:
1. PR number incorrect (verify: gh pr list)
2. GitHub CLI not authenticated (fix: gh auth login)
3. No access to repository (check permissions)

Attempted command: gh pr view 123 --json title
Error output: [actual error]"
```

## Best Practices

### 1. Single Responsibility

Each agent should have one clear focus:

```markdown
# ✅ Good: Focused agent
name: security-scanner
description: "Scans code for security vulnerabilities"

# ❌ Bad: Too broad
name: code-analyzer
description: "Analyzes code for everything"
```

### 2. Domain Expertise

Agents should embody specific roles:

```markdown
<role>
You are a Senior Security Engineer with expertise in:
- OWASP Top 10
- React security patterns
- API security best practices
</role>
```

### 3. Actionable Output

Every finding needs a fix:

```markdown
# ❌ Vague
"Security issue detected in auth.ts"

# ✅ Actionable
"**SQL Injection Risk** in src/auth.ts:42

Current code exposes SQL injection:
```sql
query = `SELECT * FROM users WHERE id = ${userId}`
```

Fix with parameterized query:
```sql
query = `SELECT * FROM users WHERE id = ?`
db.execute(query, [userId])
```"
```

### 4. Consistent Scoring

```markdown
<scoring>
Start at 10 (perfect)
Deduct based on severity:
- Critical (P0): -3 to -5 points
- High (P1): -1 to -2 points
- Medium (P2): -0.5 to -1 points
- Low (P3): -0.25 points

Minimum: 1 point
</scoring>
```

### 5. Token Optimization

```markdown
# ❌ Return full report (wastes tokens)
Return to orchestrator:
[Full 5000-word analysis]

# ✅ Write to file, return summary
Write report to: .claude/sessions/reports/security.md
Return summary:
- Issues: 12
- Critical: 3
- Score: 7/10
- Location: [file path]
```

## Testing Agents

### Isolated Testing

Test agents independently:

```markdown
# Test security-scanner directly
Invoke `security-scanner` with: test-context.md
```

### Validation Checklist

- [ ] Agent receives correct arguments
- [ ] Input validation works
- [ ] Analysis logic is sound
- [ ] Report is written to correct location
- [ ] Summary is concise (< 200 words)
- [ ] Error handling works
- [ ] Tool permissions are sufficient
- [ ] Output is actionable

## Common Pitfalls

### ❌ Too Much Responsibility

```markdown
# DON'T: One agent does everything
name: universal-analyzer
description: "Analyzes security, performance, architecture, testing, and accessibility"
```

### ✅ Focused Specialists

```markdown
# DO: Multiple specialized agents
name: security-scanner
name: performance-analyzer
name: architecture-reviewer
```

### ❌ Vague Prompts

```markdown
# DON'T: Generic instructions
You are a code reviewer. Review the code.
```

### ✅ Structured Prompts

```markdown
# DO: Clear workflow
<workflow>
### Step 1: Read Context
[Specific instructions]

### Step 2: Analyze
[Clear criteria with examples]

### Step 3: Report
[Exact format specification]
</workflow>
```

### ❌ No Error Handling

```markdown
# DON'T: Assume success
Read file: $1
Analyze content
Report findings
```

### ✅ Defensive Design

```markdown
# DO: Handle failures
Read file: $1
If file missing: Return error "File not found: $1"
If readable: Proceed with analysis
If analysis fails: Return partial results with note
```

## Real-World Example: Performance Analyzer

From exito plugin:

```markdown
---
name: performance-analyzer
description: "Analyzes React/Next.js performance patterns"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a React Performance Engineer with 10+ years optimizing production applications.
</role>

<specialization>
- React Hooks optimization (useEffect, useMemo, useCallback)
- Next.js rendering strategies (SSR, SSG, ISR)
- Bundle size reduction
- Runtime performance profiling
</specialization>

<input>
**Arguments**:
- `$1`: Path to PR context file (`.claude/sessions/pr_reviews/pr_X_context.md`)
</input>

<workflow>
### Step 1: Read Context
Read context file at path: $1
Extract React/Next.js files from diff (.tsx, .jsx, .ts, .js)

### Step 2: Scan for Anti-Patterns
Look for:

**useEffect Issues**:
- Infinite loops (state update in effect with state in deps)
- Missing dependency arrays
- Expensive operations without cleanup

**Memo/Callback**:
- Missing useMemo for expensive calculations
- Missing useCallback for child component props
- Over-memoization (premature optimization)

**Next.js Patterns**:
- Overuse of getServerSideProps (should use SSG)
- Missing next/image for images
- Missing next/dynamic for code splitting

**Bundle Size**:
- Full lodash import vs tree-shakeable
- Moment.js vs date-fns/day.js
- Large library imports in client components

### Step 3: Calculate Score
Start: 10/10
Deduct:
- Critical issues (infinite loops): -5 points
- High issues (missing optimization): -2 points
- Medium issues (minor inefficiency): -1 point
Minimum: 1/10

### Step 4: Generate Report
Write detailed report to: `.claude/sessions/pr_reviews/pr_X_performance_report.md`

Include:
- Executive summary with score
- Detailed findings (each with file:line, code example, fix)
- Quick wins (easy high-impact fixes)
- Long-term recommendations

### Step 5: Return Summary
Return to orchestrator (< 200 words):
- Total issues: X
- Critical: Y
- Score: Z/10
- Report location
</workflow>

<output_format>
[See full template in exito plugin agents/3-performance-analyzer.md]
</output_format>

<error_handling>
- If context file missing: "Run context-gatherer first"
- If no React files: "No React files detected. Skipping analysis."
- If parse error: "Partial analysis completed. Check report for details."
</error_handling>

<best_practices>
[Include React performance patterns with examples]
</best_practices>
```

## Summary

- **Structure prompts**: Use XML/Markdown sections for clarity
- **Single responsibility**: Each agent has one clear focus
- **Domain expertise**: Embody specific role with specialized knowledge
- **Token efficiency**: Write to files, return summaries
- **Actionable output**: Every finding needs location, impact, and fix
- **Error handling**: Graceful degradation with clear messages
- **Concrete examples**: Show good vs bad patterns
- **Consistent scoring**: Clear rubrics with defined criteria

Next: Read [WORKFLOWS.md](WORKFLOWS.md) to learn multi-agent orchestration patterns.
