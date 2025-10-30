# Event-Driven Automation with Hooks

Hooks enable event-driven automation by intercepting tool executions. This guide covers hook types, configuration, and practical use cases.

## Hook Overview

### What Are Hooks?

Hooks run automatically when specific events occur:
- **Before tool execution** (PreToolUse)
- **After tool execution** (PostToolUse)
- **On file changes** (FileChange)
- **On errors** (Error)

### Common Use Cases

- Format code before commits (PreToolUse Bash git:commit)
- Lint code before execution (PreToolUse Bash npm:*)
- Run tests after file changes (PostToolUse Write)
- Validate inputs before API calls (PreToolUse mcp__*)
- Send notifications on errors (Error)
- Log tool usage (PostToolUse *)

## Configuration

### File Location

Create `hooks.json` in plugin root:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
├── hooks.json          ← Hook configuration
├── commands/
└── agents/
```

### Basic Structure

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "matcher": "Bash(git:commit)",
      "command": "npm run format",
      "description": "Format code before git commit"
    }
  ]
}
```

### Hook Fields

| Field | Description | Example |
|-------|-------------|---------|
| `event` | When hook runs | `"PreToolUse"`, `"PostToolUse"` |
| `matcher` | What triggers hook | `"Bash(git:commit)"`, `"Write"` |
| `command` | What to execute | `"npm run lint"` |
| `script` | Alternative to command | `"./scripts/format.sh"` |
| `description` | Human-readable purpose | `"Lint before commit"` |
| `exitCodes` | Control flow behavior | `{"continue": [0], "block": [2]}` |

## Event Types

### PreToolUse

Runs **before** a tool executes.

**Use cases**:
- Validate inputs
- Format code
- Run linters
- Check permissions
- Create backups

**Example**: Format before commit
```json
{
  "event": "PreToolUse",
  "matcher": "Bash(git:commit)",
  "command": "npm run format",
  "description": "Auto-format code before commit"
}
```

### PostToolUse

Runs **after** a tool executes successfully.

**Use cases**:
- Run tests
- Update documentation
- Send notifications
- Clean up resources
- Log usage

**Example**: Run tests after file write
```json
{
  "event": "PostToolUse",
  "matcher": "Write",
  "command": "npm test",
  "description": "Run tests after code changes"
}
```

### FileChange

Runs when files change (via Write or Edit).

**Use cases**:
- Trigger builds
- Update imports
- Regenerate types
- Sync documentation

**Example**: Rebuild on TypeScript changes
```json
{
  "event": "FileChange",
  "matcher": "**/*.ts",
  "command": "npm run build:types",
  "description": "Regenerate types on TypeScript changes"
}
```

### Error

Runs when tool execution fails.

**Use cases**:
- Send error notifications
- Log failures
- Create error reports
- Rollback changes

**Example**: Notify on git failures
```json
{
  "event": "Error",
  "matcher": "Bash(git:*)",
  "command": "./scripts/notify-error.sh",
  "description": "Send notification on git errors"
}
```

## Matcher Patterns

### Tool Matchers

Match specific tools:

```json
// Match all Bash calls
{"matcher": "Bash(*)"}

// Match git commands only
{"matcher": "Bash(git:*)"}

// Match specific git command
{"matcher": "Bash(git:commit)"}

// Match Write tool
{"matcher": "Write"}

// Match Read tool
{"matcher": "Read"}

// Match MCP tools
{"matcher": "mcp__*"}

// Match specific MCP tool
{"matcher": "mcp__github__create_pr"}
```

### File Matchers

Match file patterns (glob syntax):

```json
// All TypeScript files
{"matcher": "**/*.ts"}

// Specific directory
{"matcher": "src/**/*.tsx"}

// Multiple extensions
{"matcher": "**/*.{ts,tsx}"}

// Root level only
{"matcher": "*.json"}

// Exclude pattern
{"matcher": "!**/node_modules/**"}
```

### Combining Matchers

Use arrays for multiple matchers:

```json
{
  "matcher": ["**/*.ts", "**/*.tsx"],
  "description": "Matches TypeScript and TSX files"
}
```

## Exit Codes

Control flow based on exit codes:

```json
{
  "exitCodes": {
    "continue": [0],      // Success, continue execution
    "block": [2],         // Block tool execution
    "error": [1]          // Treat as error
  }
}
```

### Exit Code Behavior

| Exit Code | Behavior | Use Case |
|-----------|----------|----------|
| `0` | Continue | Success, allow tool execution |
| `1` | Error | Hook failed, log error, continue |
| `2` | Block | Validation failed, block tool |
| Other | Error | Unexpected failure |

### Example: Lint Gating

```json
{
  "event": "PreToolUse",
  "matcher": "Bash(git:commit)",
  "command": "npm run lint",
  "exitCodes": {
    "continue": [0],     // Lint passed
    "block": [1, 2]      // Lint failed, block commit
  },
  "description": "Enforce linting before commit"
}
```

## Command vs Script

### Using Commands

```json
{
  "command": "npm run format"
}
```

**Pros**:
- Simple for one-liners
- Uses system PATH
- Cross-platform (if command exists)

**Cons**:
- Limited to simple commands
- Hard to pass complex arguments

### Using Scripts

```json
{
  "script": "./scripts/pre-commit-hook.sh"
}
```

**Pros**:
- Complex logic possible
- Better error handling
- Easier to maintain
- Can use shell features

**Cons**:
- Requires script file
- Platform-specific (bash vs cmd)

### Script Example

`scripts/pre-commit-hook.sh`:
```bash
#!/bin/bash

# Format code
npm run format || exit 1

# Run linter
npm run lint || exit 2

# Run tests
npm test || exit 1

echo "✓ Pre-commit checks passed"
exit 0
```

Make executable:
```bash
chmod +x scripts/pre-commit-hook.sh
```

## Practical Examples

### 1. Code Formatting

Auto-format before commits:

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "matcher": "Bash(git:commit)",
      "command": "npm run format",
      "exitCodes": {
        "continue": [0],
        "block": [1, 2]
      },
      "description": "Format code with Prettier before commit"
    }
  ]
}
```

### 2. Linting Gate

Block commits with lint errors:

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "matcher": "Bash(git:commit)",
      "script": "./scripts/lint-check.sh",
      "exitCodes": {
        "continue": [0],
        "block": [2]
      },
      "description": "Enforce linting before commit"
    }
  ]
}
```

`scripts/lint-check.sh`:
```bash
#!/bin/bash
npm run lint
if [ $? -ne 0 ]; then
  echo "❌ Lint errors found. Fix them before committing."
  exit 2  # Block commit
fi
exit 0  # Allow commit
```

### 3. Test on File Change

Run tests after code changes:

```json
{
  "hooks": [
    {
      "event": "PostToolUse",
      "matcher": "Write",
      "command": "npm test -- --related --passWithNoTests",
      "description": "Run related tests after file changes"
    }
  ]
}
```

### 4. Type Generation

Regenerate types on schema changes:

```json
{
  "hooks": [
    {
      "event": "FileChange",
      "matcher": "**/*.graphql",
      "command": "npm run generate:types",
      "description": "Regenerate TypeScript types from GraphQL schema"
    }
  ]
}
```

### 5. Build on TypeScript Changes

```json
{
  "hooks": [
    {
      "event": "FileChange",
      "matcher": ["**/*.ts", "**/*.tsx"],
      "command": "npm run build",
      "description": "Rebuild project on TypeScript changes"
    }
  ]
}
```

### 6. Documentation Sync

Update docs after command changes:

```json
{
  "hooks": [
    {
      "event": "PostToolUse",
      "matcher": "Write",
      "script": "./scripts/sync-docs.sh",
      "description": "Update README when commands change"
    }
  ]
}
```

`scripts/sync-docs.sh`:
```bash
#!/bin/bash

# Check if command files changed
if [[ $1 == *"commands/"* ]]; then
  echo "Regenerating command documentation..."
  npm run docs:generate
fi

exit 0
```

### 7. Notification on Error

Send notifications when operations fail:

```json
{
  "hooks": [
    {
      "event": "Error",
      "matcher": "Bash(npm:*)",
      "script": "./scripts/notify-error.sh",
      "description": "Send notification on npm errors"
    }
  ]
}
```

`scripts/notify-error.sh`:
```bash
#!/bin/bash

# Send notification (macOS)
osascript -e "display notification \"npm command failed\" with title \"Claude Code Error\""

# Or use a service like Slack
# curl -X POST -H 'Content-type: application/json' \
#   --data "{\"text\":\"npm command failed: $1\"}" \
#   $SLACK_WEBHOOK_URL

exit 0
```

### 8. Security Audit

Audit dependencies before install:

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "matcher": "Bash(npm:install)",
      "command": "npm audit --audit-level=moderate",
      "exitCodes": {
        "continue": [0],
        "block": [1]
      },
      "description": "Block npm install if vulnerabilities found"
    }
  ]
}
```

### 9. Backup Before Destructive Operations

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "matcher": "Bash(rm:*)",
      "script": "./scripts/backup.sh",
      "description": "Backup before file deletion"
    }
  ]
}
```

### 10. Log Tool Usage

Track tool usage for analytics:

```json
{
  "hooks": [
    {
      "event": "PostToolUse",
      "matcher": "*",
      "script": "./scripts/log-usage.sh",
      "description": "Log all tool usage"
    }
  ]
}
```

## Multi-Hook Configuration

### Complete Example

```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "matcher": "Bash(git:commit)",
      "command": "npm run format && npm run lint",
      "exitCodes": {
        "continue": [0],
        "block": [1, 2]
      },
      "description": "Format and lint before commit"
    },
    {
      "event": "PostToolUse",
      "matcher": "Write",
      "command": "npm test -- --related --passWithNoTests",
      "description": "Run related tests after file changes"
    },
    {
      "event": "FileChange",
      "matcher": "**/*.ts",
      "command": "npm run build:types",
      "description": "Regenerate types on TypeScript changes"
    },
    {
      "event": "Error",
      "matcher": "*",
      "script": "./scripts/notify-error.sh",
      "description": "Send notification on any error"
    }
  ]
}
```

## Security Considerations

### 1. Script Permissions

```bash
# Only owner can execute
chmod 700 scripts/hook.sh

# Verify script permissions
ls -la scripts/
```

### 2. Input Validation

In hook scripts:
```bash
#!/bin/bash

# Validate input
if [[ -z "$1" ]]; then
  echo "Error: No input provided"
  exit 1
fi

# Sanitize input
SAFE_INPUT=$(echo "$1" | sed 's/[^a-zA-Z0-9._-]//g')

# Use sanitized input
echo "Processing: $SAFE_INPUT"
```

### 3. Avoid Sensitive Data

```bash
# ❌ BAD: Expose secrets
echo "API_KEY=$API_KEY" >> logfile

# ✅ GOOD: Mask secrets
echo "API_KEY=***" >> logfile
```

### 4. Fail Safely

```bash
#!/bin/bash

# Enable strict mode
set -euo pipefail

# Fail safely on errors
command_that_might_fail || {
  echo "Command failed, but continuing..."
  exit 0  # Don't block execution
}
```

## Debugging Hooks

### Enable Verbose Logging

Add to hook script:
```bash
#!/bin/bash
set -x  # Print commands as they execute

echo "Hook started at $(date)"
echo "Arguments: $@"

# Your hook logic here

echo "Hook completed at $(date)"
```

### Test Hooks Manually

```bash
# Test pre-commit hook
./scripts/pre-commit-hook.sh

# Check exit code
echo $?  # 0 = success, 1 = error, 2 = block
```

### Log Hook Execution

```bash
#!/bin/bash

LOG_FILE=".claude/hooks.log"

echo "$(date): Hook triggered with: $@" >> "$LOG_FILE"

# Your hook logic here

echo "$(date): Hook completed with exit code $?" >> "$LOG_FILE"
```

### Disable Hooks Temporarily

Rename hooks file:
```bash
mv hooks.json hooks.json.disabled
```

## Performance Considerations

### 1. Fast Hooks

Hooks should be fast (< 2 seconds):

```bash
#!/bin/bash

# ✅ Good: Quick lint
npm run lint:quick

# ❌ Bad: Slow full test suite
npm test  # May take minutes
```

### 2. Conditional Execution

Only run when necessary:

```bash
#!/bin/bash

# Only run if TypeScript files changed
if [[ $1 == *".ts"* ]] || [[ $1 == *".tsx"* ]]; then
  npm run build:types
fi

exit 0
```

### 3. Async Hooks

For slow operations, run in background:

```bash
#!/bin/bash

# Run in background, don't block
npm run build &

# Return immediately
exit 0
```

### 4. Caching

Cache expensive operations:

```bash
#!/bin/bash

CACHE_FILE=".claude/lint-cache"
FILE_HASH=$(md5 -q $1)

# Check cache
if grep -q "$FILE_HASH" "$CACHE_FILE" 2>/dev/null; then
  echo "✓ Lint cache hit"
  exit 0
fi

# Run lint
npm run lint -- $1 || exit 2

# Update cache
echo "$FILE_HASH" >> "$CACHE_FILE"
exit 0
```

## Best Practices

### 1. Clear Descriptions

```json
{
  "description": "Format code with Prettier before commit"
  // Not: "Format code"
}
```

### 2. Explicit Exit Codes

```json
{
  "exitCodes": {
    "continue": [0],
    "block": [2],
    "error": [1]
  }
}
```

### 3. Idempotent Scripts

Hook scripts should be safe to run multiple times:

```bash
#!/bin/bash

# ✅ Idempotent: Safe to run multiple times
npm run format

# ❌ Not idempotent: Appends each time
echo "formatted" >> status.txt
```

### 4. User Feedback

Provide clear output:

```bash
#!/bin/bash

echo "🔍 Running linter..."
npm run lint

if [ $? -eq 0 ]; then
  echo "✅ Lint passed"
  exit 0
else
  echo "❌ Lint failed. Fix errors before committing."
  exit 2
fi
```

### 5. Document Hooks

In plugin README:

```markdown
## Hooks

This plugin includes the following hooks:

### Pre-Commit Hook
- **Trigger**: Before `git commit`
- **Action**: Formats code with Prettier and runs ESLint
- **Blocks commit**: If linting fails

### Post-Write Hook
- **Trigger**: After file write
- **Action**: Runs related tests
- **Non-blocking**: Tests run in background
```

## Troubleshooting

### Hook Not Running

**Check**:
1. Hook file exists: `hooks.json` in plugin root
2. JSON is valid: `cat hooks.json | jq`
3. Matcher is correct: `"Bash(git:commit)"` not `"git:commit"`
4. Plugin is active: `/plugin list`

### Hook Always Blocks

**Check**:
1. Exit codes are correct
2. Script has execute permissions: `chmod +x script.sh`
3. Script uses correct shebang: `#!/bin/bash`
4. Script doesn't have silent errors

### Hook Too Slow

**Solutions**:
1. Run only on changed files
2. Use caching
3. Run in background (non-blocking)
4. Reduce scope (e.g., lint staged files only)

## Complete Example: Development Workflow

`hooks.json`:
```json
{
  "hooks": [
    {
      "event": "PreToolUse",
      "matcher": "Bash(git:commit)",
      "script": "./scripts/pre-commit.sh",
      "exitCodes": {
        "continue": [0],
        "block": [2]
      },
      "description": "Quality gates before commit"
    },
    {
      "event": "PostToolUse",
      "matcher": "Write",
      "script": "./scripts/post-write.sh",
      "description": "Auto-format and test after file changes"
    },
    {
      "event": "FileChange",
      "matcher": "**/*.ts",
      "command": "npm run build:types",
      "description": "Regenerate types on TypeScript changes"
    },
    {
      "event": "Error",
      "matcher": "*",
      "script": "./scripts/on-error.sh",
      "description": "Log errors and send notifications"
    }
  ]
}
```

`scripts/pre-commit.sh`:
```bash
#!/bin/bash
set -e

echo "🔍 Running pre-commit checks..."

# Format code
echo "  📝 Formatting..."
npm run format || exit 1

# Lint code
echo "  🔎 Linting..."
npm run lint || {
  echo "❌ Lint failed. Fix errors before committing."
  exit 2
}

# Type check
echo "  🔧 Type checking..."
npm run type-check || {
  echo "❌ Type errors found. Fix before committing."
  exit 2
}

echo "✅ Pre-commit checks passed"
exit 0
```

`scripts/post-write.sh`:
```bash
#!/bin/bash

FILE=$1

echo "📝 File changed: $FILE"

# Auto-format
echo "  📝 Auto-formatting..."
npm run format -- "$FILE"

# Run related tests (non-blocking)
echo "  🧪 Running related tests..."
npm test -- --related --passWithNoTests &

exit 0
```

`scripts/on-error.sh`:
```bash
#!/bin/bash

ERROR=$1
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Log error
echo "[$TIMESTAMP] ERROR: $ERROR" >> .claude/errors.log

# Send notification (macOS)
osascript -e "display notification \"$ERROR\" with title \"Claude Code Error\""

exit 0
```

## Summary

- **Use hooks** for automated quality gates and workflows
- **PreToolUse** for validation and preparation
- **PostToolUse** for follow-up actions
- **FileChange** for file-based triggers
- **Error** for error handling and notifications
- **Exit codes** control flow (0=continue, 2=block, 1=error)
- **Scripts** for complex logic
- **Fast hooks** for better UX (< 2 seconds)
- **Document hooks** for users

Hooks enable powerful automation while maintaining control over plugin behavior.

Next: Read [TESTING.md](TESTING.md) for debugging and validation strategies.
