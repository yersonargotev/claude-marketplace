# Plugin Development Workflow

Complete step-by-step workflows for creating commands, agents, and full plugins.

## Table of Contents

1. [Creating a Command](#creating-a-command)
2. [Creating a Sub-Agent](#creating-a-sub-agent)
3. [Creating a Full Plugin](#creating-a-full-plugin)
4. [Refactoring for Token Efficiency](#refactoring-for-token-efficiency)
5. [Testing and Validation](#testing-and-validation)

---

## Creating a Command

Commands are user-facing slash commands that orchestrate workflows.

### Step 1: Understand Requirements

**Questions to ask**:
- What problem does this command solve?
- Who is the target user?
- What arguments are needed (required vs optional)?
- Which agents will this command orchestrate?
- What should the output look like?

**Example requirements**:
```
Command: /review-pr
Purpose: Perform comprehensive PR code review
Users: Developers before merging code
Arguments: <PR_NUMBER> [AZURE_DEVOPS_URL]
Agents: context-gatherer, performance-analyzer, security-scanner, etc.
Output: Markdown report with findings and score
```

### Step 2: Check Project Context

Before creating anything, read the project's `CLAUDE.md`:

```bash
# Check for existing patterns
cat CLAUDE.md | grep -i "command\|nomenclature\|architecture"

# List existing commands
ls .claude/commands/

# List existing agents
ls .claude/agents/
```

**Ensure alignment with**:
- Naming conventions
- Existing command patterns
- Project-specific constraints
- Tool availability

### Step 3: Design Command Architecture

**Define the workflow phases**:

```markdown
Phase 1: Setup & Validation
- Validate arguments
- Check prerequisites (gh auth, az login)
- Create session directory

Phase 2: Context Gathering
- Sequential: Invoke context-gatherer
- Wait for completion, get context file path

Phase 3: Parallel Analysis (if applicable)
- Parallel: Invoke specialized agents
- All read from same context file
- Each writes own report

Phase 4: Synthesis
- Read all reports from disk
- Combine findings
- Generate final output
- Present to user
```

**Design context persistence strategy**:
```
.claude/sessions/{domain}/
├── {id}_context.md         # Single source of truth
├── {id}_agent1_report.md   # Agent outputs
├── {id}_agent2_report.md
└── {id}_final_output.md    # Synthesized result
```

### Step 4: Create Command File

Create `.claude/commands/{command-name}.md`:

```yaml
---
description: "Brief description of command (shown in /help)"
argument-hint: "<REQUIRED_ARG> [OPTIONAL_ARG]"
---

# Command Name

## Purpose
Clear statement of what this accomplishes.

## Prerequisites
List required tools, authentication, setup:
- GitHub CLI (`gh`) authenticated
- Azure CLI (`az`) configured (if needed)
- MCP servers installed (if needed)

## Arguments
- `$1` - Description of first required argument
- `$2` - Description of optional second argument

## Workflow

### Phase 1: Setup and Validation

Validate arguments and check prerequisites:

1. Validate `$1` is not empty
2. Check `gh auth status` for GitHub authentication
3. Create session directory: `.claude/sessions/domain/`

If any check fails, provide clear error and exit.

### Phase 2: Context Establishment

Invoke context-gathering agent:

Use the Task tool to invoke `context-gatherer` agent:
- Pass PR number/ID as $1
- Wait for completion
- Capture context file path

### Phase 3: Parallel Analysis

Invoke specialized agents **in parallel**:

Use a single message with multiple Task tool calls to invoke:
- agent-1 (pass context file path as $1)
- agent-2 (pass context file path as $1)
- agent-3 (pass context file path as $1)

**Important**: All agents run concurrently for efficiency.

Each agent will:
1. Read context from file
2. Perform analysis
3. Write report to `.claude/sessions/domain/{id}_{agent}_report.md`
4. Return brief summary

### Phase 4: Synthesis and Output

After all agents complete:

1. Read all report files from `.claude/sessions/domain/`
2. Synthesize findings into unified output
3. Create final report: `.claude/sessions/domain/{id}_final_report.md`
4. Display summary to user with location of detailed report

## Output

The command produces:
- Context file with all raw data
- Individual agent reports with specialized findings
- Final synthesized report
- Console summary for user

Files are saved to: `.claude/sessions/domain/`

## Error Handling

### Missing Prerequisites
If `gh auth status` fails:
```
Error: GitHub CLI not authenticated

To fix: gh auth login
```

### Invalid Arguments
If required argument missing:
```
Error: Missing required argument PR_NUMBER

Usage: /command-name <PR_NUMBER> [OPTIONAL_ARG]
```

### Agent Failures
If agent fails:
- Log error to console
- Continue with other agents
- Mark failed agent in final report
- Don't block entire workflow
```

### Step 5: Add Error Handling

Add defensive checks throughout:

```markdown
### Defensive Validation Example

Before invoking agents:
- Check context file exists: `test -f .claude/sessions/pr_reviews/pr_123_context.md`
- Validate PR number is numeric
- Verify git repository exists

If any check fails:
- Provide specific error message
- Suggest corrective action
- Exit gracefully
```

### Step 6: Test the Command

Test with various inputs:

```bash
# Happy path
/command-name valid-input

# Missing required arg
/command-name

# Invalid input
/command-name not-a-number

# Large input
/command-name very-large-pr-number
```

Verify:
- ✓ Session files created correctly
- ✓ Agents run successfully
- ✓ Reports persisted to disk
- ✓ Final output is accurate
- ✓ Error handling works

---

## Creating a Sub-Agent

Agents are specialized workers that perform focused analysis tasks.

### Step 1: Define Agent Purpose

**Single Responsibility Principle**: Each agent should have ONE clear focus.

**Good agent purposes**:
- "Analyze React performance patterns (hooks, rendering, memoization)"
- "Scan for security vulnerabilities (XSS, injection, secrets)"
- "Validate test coverage and quality"

**Bad agent purposes**:
- "Analyze code" (too vague)
- "Check everything" (not focused)
- "Code reviewer" (too broad - split into specialized agents)

### Step 2: Identify Required Tools

**Be restrictive - only grant essential tools**:

| Agent Type | Tools Needed |
|------------|--------------|
| Context gatherer | `Bash(gh:*), Write` |
| Analyzer (read-only) | `Bash(gh:*), Read` |
| Report writer | `Read, Write` |
| Code modifier | `Read, Write, Edit` |
| Multi-tool | `Bash(gh:*), Bash(npm:*), Read, Write` |

**Decision tree**:
```
Does agent need to execute commands?
├─ YES: What commands?
│  └─ Grant specific: Bash(gh:*), Bash(npm:audit)
└─ NO: File operations only?
   └─ Grant minimal: Read, Write, Grep, Glob
```

### Step 3: Design Agent Workflow

Define clear, sequential steps:

```markdown
### Step 1: Read Context
- Load context file from $1 path
- Extract relevant sections (e.g., changed files, diff)
- Identify files matching agent focus (e.g., .tsx, .jsx for React)

### Step 2: Perform Analysis
- Scan for specific patterns using grep/read
- Execute relevant tools (e.g., npm audit)
- Collect findings with file:line locations

### Step 3: Generate Report
- Format findings with severity levels
- Include code examples with before/after
- Calculate score based on rubric
- Write report to session directory

### Step 4: Return Summary
- Return concise summary (< 200 words) to orchestrator
- Include score and critical findings only
- Provide file path to full report
```

### Step 4: Design Output Format

**Every agent should produce consistent output**:

```markdown
<output_format>
## Executive Summary
[3-5 sentences: overview, score, key findings]

## Findings

### Critical Issues (P0)
#### Issue 1: [Title]
- **File**: `path/to/file.tsx:42-48`
- **Severity**: Critical (P0)
- **Impact**: [Specific consequence]
- **Current Code**:
  ```typescript
  // Bad pattern
  ```
- **Fix**:
  ```typescript
  // Good pattern
  ```

### High Priority (P1)
[Same structure]

### Medium Priority (P2)
[Same structure]

### Low Priority (P3)
[Same structure]

## Best Practices Observed
- [Positive finding 1]
- [Positive finding 2]

## Score: X/10
**Rationale**: [Scoring breakdown with deductions/credits]

## Recommendations
1. [Actionable recommendation 1]
2. [Actionable recommendation 2]
</output_format>
```

### Step 5: Create Agent File

Create `.claude/agents/{agent-name}.md`:

```yaml
---
name: agent-name
description: "Clear description of when to invoke this agent and what it analyzes"
tools: Bash(gh:*), Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a [Role Title] specializing in [domain expertise].
Your responsibility is to [clear mission statement].
</role>

<specialization>
Focus areas:
- [Specific area 1]
- [Specific area 2]
- [Specific area 3]

Domain knowledge:
- [Framework/tool 1]
- [Framework/tool 2]
</specialization>

<input>
This agent expects:
- `$1`: Path to context file (e.g., `.claude/sessions/pr_reviews/pr_123_context.md`)
- `$2`: (Optional) Additional parameter

Context file structure:
```markdown
## PR Metadata
[PR info]

## Changed Files
[File list]

## Code Diff
[Relevant diffs]
```
</input>

<workflow>
### Step 1: Read Context
1. Read the context file at path `$1`
2. Extract sections relevant to this analysis:
   - For performance: React/Next.js files
   - For security: Files handling user input, auth
   - etc.

### Step 2: Pattern Analysis
1. Scan for anti-patterns specific to domain
2. Use grep for pattern matching when applicable
3. Read full file context for complex analysis

Specific patterns to check:
- [Pattern 1: description]
- [Pattern 2: description]
- [Pattern 3: description]

### Step 3: Finding Collection
For each issue found:
1. Record exact file path and line numbers
2. Classify severity (Critical/High/Medium/Low)
3. Capture code snippet (before)
4. Provide specific fix (after)
5. Explain impact

### Step 4: Scoring
Start at 10/10 (perfect) and deduct:
- Critical issues: -3 to -5 points
- High issues: -1 to -2 points
- Medium issues: -0.5 to -1 points
- Low issues: -0.25 to -0.5 points

Add credits for excellent patterns: +0.5 to +1

Minimum score: 1/10

### Step 5: Report Generation
1. Write complete report to: `.claude/sessions/pr_reviews/pr_{number}_{agent-name}_report.md`
2. Use output format defined in <output_format>
3. Return concise summary (< 200 words) to orchestrator

Summary should include:
- Agent name
- Score
- Top 2-3 critical findings
- Path to full report
</workflow>

<output_format>
[See Step 4 above for complete format]
</output_format>

<error_handling>
### Context File Missing
- Check if file at `$1` exists
- If not: Report error and suggest running context-gatherer first

### No Relevant Changes
- If no files match agent focus (e.g., no .tsx files)
- Report: "No [domain] changes detected in this PR"
- Still create report file (empty findings)
- Return summary indicating no issues

### Tool Failures
- If GitHub CLI fails: Check auth with specific message
- If npm fails: Verify package.json exists
- For any tool error: Provide specific recovery steps

### Large Dataset
- If too many files (> 50): Sample strategically
- Focus on critical paths and high-risk areas
- Document sampling approach in report
</error_handling>

<best_practices>
Domain-specific guidelines:

[For Performance Agent]
- Check for useEffect dependency issues
- Identify missing React.memo on expensive components
- Look for bundle size issues in imports
- Verify lazy loading for large components

[For Security Agent]
- Scan for XSS risks (dangerouslySetInnerHTML)
- Check for hardcoded secrets
- Review auth/permission logic
- Validate input sanitization

[For Testing Agent]
- Calculate actual coverage (not just claimed)
- Check for test quality (not just quantity)
- Verify critical paths are tested
- Look for brittle tests (implementation details)
</best_practices>
```

### Step 6: Test the Agent

Test in isolation and in orchestration:

**Isolation test**:
```markdown
# Invoke agent directly
Task tool: agent-name
Arguments: $1 = path/to/context.md

Verify:
- Agent reads context correctly
- Findings are accurate and actionable
- Report file created at expected location
- Summary is concise (< 200 words)
```

**Orchestration test**:
```markdown
# Invoke from command
/command-name test-input

Verify:
- Agent runs in parallel with others (if applicable)
- No conflicts with other agents
- Performance is acceptable (< 2 minutes)
```

---

## Creating a Full Plugin

Full plugin creation involves coordinating multiple commands and agents.

### Step 1: Define Plugin Scope

**Core questions**:
- What domain does this plugin serve? (PR reviews, testing, deployment, etc.)
- Who are the users? (developers, QA, DevOps, etc.)
- What are the primary workflows?
- What external tools/services are required?

**Example scope definition**:
```markdown
Plugin: PR Review Assistant
Domain: Code review for React/Next.js applications
Users: Frontend developers at e-commerce company
Workflows:
1. Comprehensive PR review (performance, security, testing)
2. Performance-focused review
3. Security-focused review

External dependencies:
- GitHub CLI for PR data
- Azure DevOps API for work item validation
- Context7 MCP for up-to-date library docs
```

### Step 2: Design Plugin Structure

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json                 # Metadata
├── commands/
│   ├── primary-workflow.md         # Main command
│   ├── specialized-workflow-1.md   # Variant 1
│   ├── specialized-workflow-2.md   # Variant 2
│   └── setup.md                    # Installation/config
├── agents/
│   ├── 1-context-gatherer.md       # Phase 1: Context
│   ├── 2-specialist-a.md           # Phase 2: Analysis
│   ├── 3-specialist-b.md
│   ├── 4-specialist-c.md
│   └── 5-synthesizer.md            # Phase 3: Combine
├── skills/                         # Optional
│   └── skill-name/
│       └── SKILL.md
├── .mcp.json                       # MCP servers
├── README.md                       # User documentation
└── CLAUDE.md                       # Claude Code instructions
```

**Naming convention**:
- Number agents by execution order (1-, 2-, 3-)
- Use descriptive names (context-gatherer, performance-analyzer)
- Group related agents by prefix if needed

### Step 3: Create Plugin Metadata

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Brief description of plugin functionality",
  "author": "Your Name",
  "repository": "github.com/username/repo",
  "commands": [
    {
      "name": "primary-workflow",
      "description": "Main command description"
    },
    {
      "name": "specialized-workflow-1",
      "description": "Specialized variant 1"
    }
  ],
  "agents": [
    "context-gatherer",
    "specialist-a",
    "specialist-b",
    "specialist-c",
    "synthesizer"
  ],
  "dependencies": {
    "gh": "GitHub CLI for PR operations",
    "az": "Azure CLI for work item integration (optional)"
  }
}
```

### Step 4: Implement Core Workflow

**Start with the primary command** following the command workflow above.

**Then implement agents in order**:
1. Context gatherer (establishes foundation)
2. Specialized analysts (parallel)
3. Synthesizer (combines results)

**Test each agent individually before integration**.

### Step 5: Add MCP Server Integration

Create `.mcp.json` if external services needed:

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      },
      "description": "Up-to-date library documentation"
    }
  }
}
```

Document environment variables needed in README.md.

### Step 6: Create Setup Command

Create `.claude/commands/setup.md` for dependency installation:

```yaml
---
description: "Install and configure plugin dependencies"
---

# Setup Plugin Dependencies

This command installs required tools for the plugin.

## Dependencies

- **GitHub CLI (gh)**: Required for all PR operations
- **Azure CLI (az)**: Optional, for Azure DevOps integration

## Installation

### macOS

Install via Homebrew:
```bash
brew install gh
brew install azure-cli  # Optional
```

### Linux

[Installation instructions]

### Windows

[Installation instructions]

## Authentication

After installation, authenticate:

```bash
# GitHub
gh auth login

# Azure DevOps (if needed)
az login --allow-no-subscriptions
```

## Verification

Verify installation:
```bash
gh --version
az --version  # If installed
```

## Environment Variables

Set required environment variables:

```bash
# For Context7 MCP server (optional)
export CONTEXT7_API_KEY="your-api-key"

# For Azure DevOps (optional)
export AZURE_DEVOPS_ORG_URL="https://dev.azure.com/your-org"
```

Make persistent by adding to shell config (~/.zshrc, ~/.bashrc).

## Troubleshooting

[Common issues and solutions]
```

### Step 7: Write Documentation

Create comprehensive README.md:

```markdown
# Plugin Name

Brief description of plugin.

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

```bash
/plugin marketplace add username/marketplace-repo
/plugin install plugin-name@marketplace-name
```

## Quick Start

```bash
# Run setup
/setup

# Use primary command
/primary-workflow <argument>
```

## Commands

### /primary-workflow

Description and usage examples.

### /specialized-workflow-1

Description and usage examples.

## Configuration

Environment variables needed:
- `VAR_1`: Description
- `VAR_2`: Description (optional)

## Architecture

Brief overview of how plugin works:
- Phase 1: Context gathering
- Phase 2: Parallel analysis
- Phase 3: Synthesis

## Contributing

Guidelines for contributions.

## License

License information.
```

Create CLAUDE.md for Claude Code:

```markdown
# CLAUDE.md

Instructions for Claude Code when working with this plugin.

## Plugin Overview

[Brief description]

## Nomenclature

Commands:
- /command-1 - Description
- /command-2 - Description

Agents:
- agent-1 - Role and responsibility
- agent-2 - Role and responsibility

## Architecture

[Workflow diagram and explanation]

## Key Technologies

- Tool 1: How it's used
- Tool 2: How it's used

## Common Development Tasks

### Testing Locally
[Instructions]

### Adding New Agent
[Instructions]

### Modifying Behavior
[Instructions]
```

### Step 8: Test End-to-End

Test complete workflows:

```bash
# Install plugin locally
/plugin install ./path/to/plugin

# Run setup
/setup

# Test primary workflow
/primary-workflow test-input

# Test edge cases
/primary-workflow invalid-input
/primary-workflow very-large-input
```

Verify:
- ✓ All agents run successfully
- ✓ Reports generated correctly
- ✓ Error handling works
- ✓ Performance acceptable
- ✓ Token usage within budget

---

## Refactoring for Token Efficiency

Optimize existing agents/commands to reduce token consumption.

### Step 1: Measure Current Usage

**Identify token-heavy components**:
```markdown
# Calculate prompt sizes
wc -w .claude/agents/*.md
wc -w .claude/commands/*.md

# Identify largest prompts
find .claude -name "*.md" -exec wc -w {} \; | sort -rn | head -10
```

**Target reduction**: 60-70% token savings through refactoring.

### Step 2: Apply Progressive Disclosure

**Move detailed content to separate files**:

Before (monolithic):
```markdown
---
name: agent
tools: Read, Write
---

[3000 word prompt with all details inline]
```

After (progressive):
```markdown
---
name: agent
tools: Read, Write
---

[500 word core prompt]

For detailed guidance, see [REFERENCE.md](REFERENCE.md)
For examples, see [EXAMPLES.md](EXAMPLES.md)
```

**Claude loads additional files only when needed**.

### Step 3: Switch to File-Based Context

Before (context in messages):
```markdown
Invoke agent with: [Full diff - 10,000 lines]
```

After (context in files):
```markdown
1. Create context file: .claude/sessions/domain/context.md
2. Invoke agent with: $1 = path/to/context.md
3. Agent reads context from file
```

**Savings**: 80-90% reduction in message token usage.

### Step 4: Optimize Agent Responses

Before (full report):
```markdown
Agent returns entire 2000-word report in response
```

After (summary only):
```markdown
Agent:
1. Writes full report to disk
2. Returns 150-word summary
3. Provides file path for orchestrator
```

**Savings**: 90% reduction in response tokens.

### Step 5: Implement Adaptive Strategies

**Scale detail inversely with input size**:

```markdown
<workflow>
### Step 1: Classify Input Size

If lines < 200: Full detailed analysis
If lines 200-500: Focused analysis
If lines 500-1000: Strategic sampling
If lines > 1000: Risk-based review only

### Step 2: Adapt Detail Level

Small inputs: Complete examples for all findings
Large inputs: Summary examples, focus on critical issues
```

### Step 6: Measure Improvement

**Before refactoring**:
```
Total system prompts: 15,000 tokens
Average message context: 10,000 tokens
Total per review: 25,000 tokens
```

**After refactoring**:
```
Total system prompts: 5,000 tokens (67% reduction)
Average message context: 2,000 tokens (80% reduction)
Total per review: 7,000 tokens (72% reduction)
```

**Validate**: Quality maintained while achieving dramatic cost savings.

---

## Testing and Validation

Comprehensive testing ensures plugins work reliably.

### Unit Testing (Agent Level)

**Test each agent independently**:

```markdown
# Test context-gatherer
1. Create mock PR
2. Invoke agent
3. Verify context file created
4. Validate content structure

# Test analyzer agent
1. Create mock context file
2. Invoke agent with path
3. Verify report file created
4. Validate findings accuracy
```

### Integration Testing (Command Level)

**Test full workflows**:

```markdown
# Test primary command
1. Setup test PR
2. Run command: /primary-workflow <PR>
3. Verify all phases execute
4. Check all reports generated
5. Validate final output

# Test error scenarios
1. Run with invalid input
2. Run with missing auth
3. Run with large input
4. Verify graceful error handling
```

### Performance Testing

**Measure resource consumption**:

```markdown
# Token usage
- Record tokens per review
- Target: < 10,000 tokens
- Compare before/after refactoring

# Execution time
- Small PR: < 1 minute
- Medium PR: < 3 minutes
- Large PR: < 5 minutes

# Accuracy
- False positive rate: < 10%
- Detection rate: > 90% for known issues
```

### User Acceptance Testing

**Real-world validation**:

```markdown
# Test with actual users
1. Deploy to test environment
2. Have users run on real PRs
3. Collect feedback:
   - Were findings useful?
   - Were false positives low?
   - Was output clear?
   - Was performance acceptable?

# Iterate based on feedback
- Fix high-priority issues
- Refine unclear guidance
- Optimize slow operations
```

### Regression Testing

**Prevent regressions after changes**:

```markdown
# Maintain test suite
1. Create test cases for key scenarios
2. Run tests before each change
3. Verify no regressions
4. Update tests for new features

# Test cases
- Happy path (standard PR)
- Edge cases (empty PR, huge PR)
- Error cases (invalid input, auth failure)
- Integration (with external services)
```

### Validation Checklist

Before marking a plugin/agent as complete:

**Functional Requirements**:
- [ ] All commands execute successfully
- [ ] All agents produce expected output
- [ ] Reports saved to correct locations
- [ ] Error handling works for common failures

**Non-Functional Requirements**:
- [ ] Token usage within budget (< 10,000 per review)
- [ ] Execution time acceptable (< 5 minutes for large input)
- [ ] False positive rate low (< 10%)
- [ ] User feedback positive (> 4/5 satisfaction)

**Documentation**:
- [ ] README complete with examples
- [ ] CLAUDE.md provides clear guidance
- [ ] All commands documented
- [ ] Environment variables listed
- [ ] Troubleshooting guide included

**Quality**:
- [ ] Code follows naming conventions
- [ ] Prompts use structured sections (XML/Markdown)
- [ ] No sensitive data in code
- [ ] License information included
