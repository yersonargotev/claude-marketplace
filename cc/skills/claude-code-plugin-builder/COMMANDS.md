# Creating Slash Commands

Slash commands are the primary interface between users and your plugin. This guide covers everything you need to build powerful, user-friendly commands.

## Command Basics

### File Structure

Commands are markdown files in the `commands/` directory:

```
my-plugin/
└── commands/
    ├── hello.md           # /hello
    ├── analyze.md         # /analyze
    └── review-pr.md       # /review-pr
```

The filename (without `.md`) becomes the command name.

### Minimal Command

```markdown
---
description: "Brief description shown in /help"
---

Your instructions to Claude go here.
```

That's it! This creates a working command.

## YAML Frontmatter

The frontmatter controls command behavior:

```yaml
---
description: "What this command does (required)"
argument-hint: "<REQUIRED> [OPTIONAL]..."  # Shows expected arguments
allowed-tools: Read, Write, Bash           # Tool restrictions
model: claude-sonnet-4-5-20250929          # Specific model
---
```

### Frontmatter Fields

| Field | Description | Example |
|-------|-------------|---------|
| `description` | Command purpose (required) | `"Analyze code for security issues"` |
| `argument-hint` | Expected arguments | `"<FILE> [OPTIONS]"` |
| `allowed-tools` | Tool restrictions | `Read, Write, Bash(gh:*)` |
| `model` | Override default model | `claude-sonnet-4-5-20250929` |

## Working with Arguments

### Accessing Arguments

Use `$ARGUMENTS` for all arguments or `$1`, `$2`, etc. for specific positions:

```markdown
---
description: "Greet user by name"
argument-hint: "<NAME> [MESSAGE]"
---

Greet the user:
- Name: $1
- Optional message: $2

If no name provided, ask the user for it.
```

**Usage**: `/greet Alice "Welcome to the team"`

### Argument Validation

```markdown
---
description: "Analyze GitHub PR"
argument-hint: "<PR_NUMBER>"
---

You are a PR analysis assistant.

**Input**: PR number in $1

**Validation**:
1. Check if $1 is provided
2. Verify it's a number
3. If invalid, explain usage: `/analyze <PR_NUMBER>`

**Process**:
1. Fetch PR with: !gh pr view $1 --json title,body,files
2. Analyze changes
3. Report findings
```

### Optional vs Required Arguments

```markdown
---
argument-hint: "<FILE_PATH> [DEPTH]"
---

Analyze file at $1 (required).
Analysis depth: $2 (optional, defaults to 'medium')

If $1 not provided: Show usage and exit
If $2 not provided: Use 'medium'
```

## Bash Commands

### Executing Commands

Prefix bash commands with `!`:

```markdown
---
description: "Show git status"
---

!git status
!git log --oneline -5
```

### Command with Arguments

```markdown
---
description: "Create branch"
argument-hint: "<BRANCH_NAME>"
---

!git checkout -b $1
!git push -u origin $1
```

### Tool Restrictions

Restrict bash to specific commands for security:

```yaml
---
allowed-tools: Bash(gh:*), Bash(npm:test)  # Only gh commands and npm test
---
```

Patterns:
- `Bash(gh:*)` - Only GitHub CLI commands
- `Bash(git:status)` - Only `git status`
- `Bash(npm:test,npm:audit)` - Only these npm commands
- `Bash(*)` - All bash (use cautiously)

## File References

### Using @ Syntax

Reference files with `@`:

```markdown
Read the configuration from @config/settings.json
Analyze the code in @src/components/Hero.tsx
```

Claude will automatically read these files.

### Dynamic File Paths

```markdown
---
argument-hint: "<FILE_PATH>"
---

Analyze the file at @$1

Provide:
- Code quality assessment
- Improvement suggestions
- Security concerns
```

**Usage**: `/analyze src/utils/auth.ts`

## Invoking Subagents

### Task Tool

Use the Task tool to invoke subagents:

```markdown
Invoke the `code-analyzer` agent with the file path: $1

Wait for the agent to complete and review its findings.
```

### Passing Arguments to Agents

Agents receive arguments as `$1`, `$2`, etc.:

```markdown
Invoke `security-scanner` agent with:
- File path: $1
- Severity threshold: $2 (or "medium" if not provided)
```

**Agent receives**:
- `$1` = file path
- `$2` = severity threshold

## Command Patterns

### 1. Simple Command (No Arguments)

```markdown
---
description: "Show project statistics"
---

You are a project analyst.

Analyze the current project:

1. !git log --oneline | wc -l (commit count)
2. !find . -name "*.ts" -o -name "*.tsx" | wc -l (TypeScript files)
3. !npm ls --depth=0 (dependencies)

Summarize findings in a table.
```

### 2. Command with Required Arguments

```markdown
---
description: "Create React component"
argument-hint: "<COMPONENT_NAME>"
---

You are a React component generator.

**Input**: Component name in $1

**Validation**:
- If $1 is empty: Show usage and exit
- If $1 contains spaces: Show error and exit

**Process**:
1. Create file: src/components/$1.tsx
2. Generate TypeScript React component with:
   - Props interface
   - Component definition
   - Export statement
3. Create test: src/components/$1.test.tsx

**Output**: Confirm files created with paths.
```

### 3. Command with Optional Arguments

```markdown
---
description: "Run tests with optional filter"
argument-hint: "[TEST_PATTERN]"
---

Run tests with optional filter:

If $1 provided:
  !npm test -- $1
Else:
  !npm test

Show results summary.
```

### 4. Multi-Stage Command

```markdown
---
description: "Code review workflow"
argument-hint: "<PR_NUMBER>"
---

You are a code review orchestrator.

**Stage 1: Fetch PR**
!gh pr view $1 --json title,body,diff > /tmp/pr_$1.json

**Stage 2: Analyze**
Invoke `code-analyzer` agent with: /tmp/pr_$1.json

**Stage 3: Review**
Invoke `security-scanner` agent with: /tmp/pr_$1.json

**Stage 4: Synthesize**
Combine findings from both agents into final review.
```

### 5. Orchestrator Command (Multi-Agent)

```markdown
---
description: "Comprehensive code audit"
argument-hint: "<DIRECTORY>"
---

You are an audit orchestrator.

**Phase 1: Context Gathering**
Invoke `context-gatherer` agent with: $1
Save context to: .claude/sessions/audit/context.md

**Phase 2: Parallel Analysis**
Invoke the following agents **in parallel**:
- `security-scanner` with .claude/sessions/audit/context.md
- `performance-analyzer` with .claude/sessions/audit/context.md
- `code-quality-checker` with .claude/sessions/audit/context.md

**Phase 3: Synthesis**
Read all reports from .claude/sessions/audit/
Synthesize into final audit report
Display to user
```

## Best Practices

### 1. Clear Descriptions

```markdown
# ❌ Bad
description: "Does stuff"

# ✅ Good
description: "Analyzes React components for performance anti-patterns"
```

### 2. Validate Inputs

```markdown
**Validation**:
1. Check $1 is provided
2. Verify file exists: @$1
3. Confirm file extension is .tsx or .jsx
4. If validation fails: Show clear error and usage
```

### 3. Show Progress

```markdown
**Phase 1: Fetching data...**
!gh pr view $1 --json files

**Phase 2: Analyzing changes...**
Invoke `analyzer` agent

**Phase 3: Generating report...**
Synthesize findings
```

### 4. Handle Errors Gracefully

```markdown
**Error Handling**:
- If PR not found: "PR #$1 not found. Check the number and try again."
- If gh CLI not authenticated: "Run `gh auth login` first."
- If analysis fails: "Analysis incomplete. Review partial results below."
```

### 5. Provide Examples

```markdown
**Usage Examples**:
- Analyze specific PR: `/review 123`
- Review with Azure DevOps: `/review 123 https://dev.azure.com/org/project/_workitems/edit/456`
- Quick analysis: `/review 123 --quick`
```

### 6. Use Structured Output

```markdown
**Output Format**:

## Analysis Summary
- **Files analyzed**: X
- **Issues found**: Y
- **Critical**: Z

## Findings
[Detailed findings here]

## Recommendations
[Actionable recommendations]
```

## Tool Permissions

### Restrictive (Recommended)

```yaml
allowed-tools: Read, Write, Bash(gh:*)
```

Use restrictive permissions by default. Only grant what's needed.

### Permissive (Use Cautiously)

```yaml
allowed-tools: "*"
```

Grants all tools. Use only when necessary and understand security implications.

### No Bash (Safest)

```yaml
allowed-tools: Read, Write
```

No bash execution. Safest for pure analysis commands.

## Model Selection

### Use Default (Most Common)

```yaml
# No model field = uses default (usually Claude Sonnet 4.5)
```

### Override When Needed

```yaml
model: claude-sonnet-4-5-20250929  # Specific model
```

Use cases for override:
- Need cutting-edge features
- Require specific model capabilities
- Cost optimization (using smaller model)

## Testing Commands

### Quick Test Cycle

1. **Edit command**: Modify `commands/my-command.md`
2. **Reload**: Restart Claude Desktop or `/plugin reload`
3. **Test**: `/my-command test-args`
4. **Iterate**: Repeat until working

### Debug Output

```markdown
**Debug Info**:
- Argument 1: $1
- Argument 2: $2
- All arguments: $ARGUMENTS
- Current directory: !pwd
```

## Common Pitfalls

### ❌ Passing Large Context

```markdown
# DON'T: Pass full diff to agent
Invoke `analyzer` with this diff: [10,000 lines]
```

### ✅ Use File Paths

```markdown
# DO: Save to file, pass path
!gh pr diff $1 > /tmp/pr_diff.txt
Invoke `analyzer` with: /tmp/pr_diff.txt
```

### ❌ Vague Instructions

```markdown
# DON'T: Vague task
Analyze the code and report issues.
```

### ✅ Specific Instructions

```markdown
# DO: Clear steps
1. Read code from @$1
2. Check for React anti-patterns:
   - useEffect infinite loops
   - Missing dependency arrays
   - Expensive operations in render
3. Report findings with file:line references
```

### ❌ No Error Handling

```markdown
# DON'T: Assume success
!gh pr view $1 --json diff
Analyze the diff above.
```

### ✅ Handle Failures

```markdown
# DO: Graceful degradation
Fetch PR diff with: !gh pr view $1 --json diff

If command fails:
- Check if $1 is valid PR number
- Verify gh CLI is authenticated
- Provide clear error message with fix
```

## Advanced Patterns

### Conditional Logic

```markdown
**Logic**:
If $2 equals "quick":
  - Run fast analysis only
  - Skip optional checks
Else:
  - Run comprehensive analysis
  - Include all checks
```

### Iteration

```markdown
**Process**:
For each file in the PR:
1. Analyze file individually
2. Record findings
3. Aggregate at the end
```

### Context Preservation

```markdown
**Context Management**:
1. Create session directory: .claude/sessions/review_$1/
2. Save context: .claude/sessions/review_$1/context.md
3. Each agent writes to: .claude/sessions/review_$1/[agent-name]_report.md
4. Orchestrator reads all reports and synthesizes
```

## Real-World Example: /review Command

From the exito plugin:

```markdown
---
description: "Comprehensive PR review with specialized agents"
argument-hint: "<PR_NUMBER> [AZURE_DEVOPS_URL_1] [AZURE_DEVOPS_URL_2]..."
allowed-tools: Bash(gh:*), Read, Write
---

You are the **PR Review Orchestrator**.

**Phase 1: Context Gathering**
Invoke `context-gatherer` agent with PR number: $1
Agent creates: .claude/sessions/pr_reviews/pr_$1_context.md

**Phase 2: Business Validation** (conditional)
If Azure DevOps URLs provided ($2, $3, etc.):
  Invoke `business-validator` with: $1 $2 $3 ...

**Phase 3: Parallel Analysis**
Invoke these agents **in parallel** (one message, multiple Task calls):
- performance-analyzer
- architecture-reviewer
- clean-code-auditor
- security-scanner
- testing-assessor
- accessibility-checker

Each agent:
1. Reads .claude/sessions/pr_reviews/pr_$1_context.md
2. Performs specialized analysis
3. Writes report to .claude/sessions/pr_reviews/pr_$1_[agent-name]_report.md
4. Returns concise summary (< 200 words)

**Phase 4: Synthesis**
Read all reports from .claude/sessions/pr_reviews/
Synthesize into unified review document
Save to: .claude/sessions/pr_reviews/pr_$1_final_review.md
Display final review to user

**Error Handling**:
- PR not found: Clear error message
- gh CLI issues: Authentication instructions
- Agent failures: Continue with available reports
- No changes detected: Acknowledge gracefully
```

## Summary

- **Keep it simple**: Start with basic commands, add complexity as needed
- **Validate inputs**: Check arguments before processing
- **Handle errors**: Provide clear messages and remediation
- **Use agents**: Delegate complex tasks to specialized subagents
- **Be efficient**: Use file paths, not message passing
- **Document well**: Clear description and argument hints
- **Test thoroughly**: Validate with real-world inputs

Next: Read [AGENTS.md](AGENTS.md) to learn how to build specialized subagents.
