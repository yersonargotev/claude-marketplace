# Quick Reference

Fast lookup for common Claude Code plugin patterns and snippets.

## Plugin Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Required manifest
├── commands/                 # Slash commands (optional)
│   └── my-command.md
├── agents/                   # Subagents (optional)
│   └── my-agent.md
├── skills/                   # Agent Skills (optional)
│   └── my-skill/
│       └── SKILL.md
├── hooks/                    # Event hooks (optional)
│   └── hooks.json
├── .mcp.json                # MCP servers (optional)
└── README.md
```

## Plugin Manifest (plugin.json)

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "What this plugin does",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "homepage": "https://github.com/user/repo",
  "repository": "https://github.com/user/repo",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"]
}
```

## Command (commands/example.md)

### Minimal Command
```markdown
---
description: "What this command does"
---

Your instructions to Claude go here.
```

### Command with Arguments
```markdown
---
description: "Command with args"
argument-hint: "<REQUIRED> [OPTIONAL]"
---

Use arguments:
- $1 for first argument
- $2 for second argument
- $ARGUMENTS for all arguments
```

### Command with Tools & Model
```markdown
---
description: "Restricted command"
allowed-tools: Read, Write, Bash(git:*)
model: claude-sonnet-4-5-20250929
---

This command can only use specified tools.
```

### Command with Bash Execution
```markdown
---
description: "Fetches GitHub data"
allowed-tools: Bash(gh:*)
---

## Context

Current PR info: !`gh pr view $1 --json title,body`

## Task

Analyze the PR and report findings.
```

## Agent (agents/example.md)

### Minimal Agent
```markdown
---
name: my-agent
description: "When to invoke this agent"
tools: Read, Write
model: sonnet
---

<role>
You are a [role]. Your expertise is [domain].
</role>

<workflow>
1. Read context from $1
2. Perform analysis
3. Write report
4. Return summary
</workflow>
```

### Full Agent Template
```markdown
---
name: analyzer
description: "Analyze code for issues. Use when reviewing code quality"
tools: Read, Write, Bash(gh:*)
model: inherit
---

<role>
You are a Senior Code Analyst specializing in quality review.
</role>

<specialization>
- Code quality and maintainability
- Performance patterns
- Security vulnerabilities
</specialization>

<input>
**Arguments**:
- `$1`: Path to context file

**Expected format**: Markdown file with code diffs
</input>

<workflow>
### Step 1: Read Context
Read context file at `$1` and extract:
- Changed files
- Code diffs
- Metadata

### Step 2: Analyze Patterns
Scan for:
- Anti-patterns (with examples)
- Best practices (with examples)
- Security issues (with examples)

### Step 3: Generate Findings
For each issue:
- **Location**: `file.ts:42-48`
- **Description**: What's wrong
- **Impact**: Why it matters
- **Fix**: Code example (before/after)
- **Priority**: Critical/High/Medium/Low

### Step 4: Calculate Score
Start: 10 (perfect)
- Critical: -3 to -5
- High: -1 to -2
- Medium: -0.5 to -1
Minimum: 1

### Step 5: Write Report
Write to: `.claude/sessions/reports/analyzer_report.md`

### Step 6: Return Summary
Return < 200 words:
- Total issues: X
- Critical: Y
- Score: Z/10
</workflow>

<output_format>
## Executive Summary
[Score and overview]

## Critical Issues (P0)
[Issues that must be fixed]

## High Priority (P1)
[Issues that should be fixed]

## Recommendations
[Actionable improvements]
</output_format>

<error_handling>
- If context file missing: Report error, suggest creating it
- If no issues found: Report "No issues detected" (not an error)
- If tool fails: Provide remediation steps
</error_handling>

<best_practices>
- Be specific with file:line references
- Include concrete code examples
- Explain impact, not just symptoms
- Prioritize findings clearly
</best_practices>
```

## Agent Skill (skills/my-skill/SKILL.md)

```markdown
---
name: my-skill-name
description: What this skill does and when to use it. Include trigger keywords for discovery.
---

# Skill Title

## When to Use This Skill

Use when you need to [specific scenarios].

## Instructions

Step-by-step guidance for Claude.

## Examples

Concrete examples of using this skill.

## Supporting Files

Reference other files: [See reference](reference.md)
```

## Orchestrator Command

```markdown
---
description: "Multi-agent workflow"
argument-hint: "<INPUT>"
allowed-tools: Read, Write
---

You are an orchestrator managing specialized agents.

## Workflow

### Phase 1: Context Gathering
Use Task tool to invoke `context-gatherer` agent:
- Pass input: $1
- Agent writes: `.claude/sessions/context.md`

### Phase 2: Parallel Analysis
Invoke agents **in parallel** (single message, multiple Task calls):
- `agent-a` (reads context, writes report-a)
- `agent-b` (reads context, writes report-b)
- `agent-c` (reads context, writes report-c)

**Important**: Do NOT wait between invocations.

### Phase 3: Synthesis
Read all reports:
- `.claude/sessions/report-a.md`
- `.claude/sessions/report-b.md`
- `.claude/sessions/report-c.md`

Synthesize into final output.

## Output

Present unified results to user.
```

## MCP Configuration (.mcp.json)

```json
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "@package/mcp-server"],
      "env": {
        "API_KEY": "${API_KEY_ENV_VAR}"
      }
    },
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    }
  }
}
```

## Hooks (hooks/hooks.json)

```json
{
  "PostToolUse": [
    {
      "matcher": "Write|Edit",
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format.sh"
        }
      ]
    }
  ],
  "UserPromptSubmit": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "echo 'Starting task...'"
        }
      ]
    }
  ]
}
```

## Marketplace (marketplace.json)

```json
{
  "name": "my-marketplace",
  "owner": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "plugins": [
    {
      "name": "plugin-name",
      "source": "./plugins/plugin-name",
      "description": "Plugin description",
      "version": "1.0.0"
    }
  ]
}
```

## Common Patterns

### Argument Handling
```markdown
# All arguments
$ARGUMENTS

# Individual arguments
$1, $2, $3

# Validation
If $1 is not provided, show usage: `/command <ARG>`
```

### File References
```markdown
Review @src/components/MyComponent.tsx
Compare @src/old.js with @src/new.js
```

### Bash Execution
```markdown
---
allowed-tools: Bash(gh:*)
---

Fetch PR: !`gh pr view 123 --json title,body`
List files: !`gh pr diff 123 --name-only`
```

### File-Based Context
```markdown
# Orchestrator creates context
Write context to: `.claude/sessions/context.md`

# Agents read context
Read context from: $1 (path passed as argument)

# Agents write reports
Write report to: `.claude/sessions/agent_report.md`

# Orchestrator reads reports
Read all reports from: `.claude/sessions/*.md`
```

### Parallel Execution
```markdown
Invoke the following agents **in parallel**:
- Use Task tool with subagent_type: "agent-a"
- Use Task tool with subagent_type: "agent-b"
- Use Task tool with subagent_type: "agent-c"

**Important**: Send all Task calls in a single message.
```

### Scoring System
```markdown
Start: 10 (perfect)

Deductions:
- Critical (P0): -3 to -5
- High (P1): -1 to -2
- Medium (P2): -0.5 to -1

Bonuses:
- Excellent patterns: +0.5 to +1

Minimum: 1 (never 0)
```

### Finding Format
```markdown
### Issue: Clear Title

- **File**: `src/file.ts:42-48`
- **Severity**: Critical (P0)
- **Impact**: Performance/Security/Functionality issue
- **Fix**:
  ```typescript
  // Before (bad)
  [problematic code]

  // After (good)
  [fixed code]
  ```
```

## Tool Restrictions

### Read-Only Agent
```yaml
tools: Read, Grep, Glob
```

### Git Operations
```yaml
tools: Bash(git:*)
```

### GitHub Operations
```yaml
tools: Bash(gh:*)
```

### Full Access
```yaml
tools: Read, Write, Edit, Bash, Grep, Glob
```

## Model Selection

```yaml
# Specific model
model: claude-sonnet-4-5-20250929

# Model alias
model: sonnet  # or opus, haiku

# Inherit from main conversation
model: inherit

# Omit to use default subagent model
# (no model field)
```

## Testing

### Install Plugin
```bash
/plugin marketplace add ./path/to/marketplace
/plugin install plugin-name@marketplace-name
```

### Reload Plugin
```bash
/plugin disable plugin-name
/plugin enable plugin-name
```

### List Commands
```bash
/help
```

### List Agents
```bash
/agents
```

### Test Command
```bash
/my-command arg1 arg2
```

### Test Agent
```bash
Use the my-agent agent to analyze this code
```

## Debugging

### View Plugin Info
```bash
/plugin
```

### Check Logs
```bash
claude --debug
```

### Validate Syntax
Check JSON with:
```bash
cat plugin.json | python -m json.tool
```

Check YAML frontmatter:
```bash
head -20 command.md
```

## Environment Variables

### Plugin Root
```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/scripts/helper.sh"
}
```

Resolves to absolute path of plugin directory.

### Custom Variables
```json
{
  "env": {
    "API_KEY": "${MY_API_KEY}",
    "DB_PATH": "${CLAUDE_PLUGIN_ROOT}/data"
  }
}
```

## Naming Conventions

### Plugin Names
```
kebab-case
my-plugin
security-scanner
```

### Command Names
```
kebab-case
analyze
review-pr
deploy-app
```

### Agent Names
```
kebab-case
code-reviewer
performance-analyzer
security-scanner
```

### Skill Names
```
kebab-case
pdf-processor
data-analyzer
code-formatter
```

## Common Mistakes

### ❌ Wrong Directory Structure
```
.claude-plugin/
├── plugin.json
├── commands/         # ❌ Commands inside .claude-plugin
└── agents/           # ❌ Agents inside .claude-plugin
```

### ✅ Correct Structure
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── commands/         # ✅ Commands at plugin root
└── agents/           # ✅ Agents at plugin root
```

### ❌ Passing Large Context
```markdown
Analyze this diff:
[10,000 lines of code]
```

### ✅ File-Based Context
```markdown
Read context from: `.claude/sessions/context.md`
```

### ❌ Sequential Invocation
```markdown
1. Invoke agent-a, wait for result
2. Then invoke agent-b, wait for result
3. Then invoke agent-c
```

### ✅ Parallel Invocation
```markdown
Invoke agents a, b, c in parallel:
[Send all Task calls in single message]
```

---

**For detailed guides, see:**
- Commands: `skills/claude-code-plugin-builder/COMMANDS.md`
- Agents: `skills/claude-code-plugin-builder/AGENTS.md`
- Workflows: `skills/claude-code-plugin-builder/WORKFLOWS.md`
