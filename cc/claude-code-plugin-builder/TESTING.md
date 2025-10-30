# Testing and Debugging Claude Code Plugins

Comprehensive guide to testing plugins, debugging issues, and ensuring quality before distribution.

## Testing Strategy

### Test Levels

1. **Component Testing**: Individual commands and agents
2. **Integration Testing**: Multi-agent workflows
3. **End-to-End Testing**: Complete user scenarios
4. **Performance Testing**: Token usage and execution time

## Local Development Setup

### 1. Create Local Marketplace

Create `~/.claude/marketplace.json`:

```json
{
  "plugins": {
    "my-plugin": {
      "path": "/Users/you/projects/my-plugin"
    }
  }
}
```

**Absolute paths required**: Use full paths, not `~/` or relative paths.

### 2. Install Plugin Locally

```bash
# Add to Claude Code
/plugin add local/my-plugin

# Install
/plugin install my-plugin@local

# Verify installation
/plugin list
```

### 3. Development Cycle

```bash
# 1. Edit plugin files
vim my-plugin/commands/hello.md

# 2. Reload plugin
# Option A: Restart Claude Desktop (safest)
# Option B: Uninstall and reinstall
/plugin uninstall my-plugin@local
/plugin install my-plugin@local

# 3. Test command
/hello test-argument

# 4. Iterate
```

## Testing Commands

### Unit Testing

Test individual commands in isolation:

```bash
# Test with no arguments
/hello

# Test with one argument
/hello Alice

# Test with multiple arguments
/hello Alice "Welcome message"

# Test with edge cases
/hello ""
/hello "very long name that might cause issues"
/hello 123
```

### Validation Checklist

Test each command for:

- [ ] **Correct invocation**: Command responds to `/command-name`
- [ ] **Argument handling**: `$1`, `$2`, `$ARGUMENTS` work correctly
- [ ] **Validation**: Invalid inputs show helpful errors
- [ ] **Tool permissions**: Can execute allowed tools only
- [ ] **Output format**: Response is clear and structured
- [ ] **Error messages**: Failures provide actionable guidance

### Example Test Plan

For `/review <PR_NUMBER>` command:

```markdown
**Test Cases**:

1. **Valid PR**:
   - Input: `/review 123`
   - Expected: Full review with all agents completed
   - Verify: Context file and reports created

2. **Invalid PR**:
   - Input: `/review 99999`
   - Expected: Error "PR #99999 not found"
   - Verify: Suggests checking PR number

3. **Missing argument**:
   - Input: `/review`
   - Expected: Usage message with example
   - Verify: Shows `/review <PR_NUMBER>`

4. **With Azure DevOps URLs**:
   - Input: `/review 123 https://dev.azure.com/org/project/_workitems/edit/456`
   - Expected: Review includes business validation
   - Verify: Work item data fetched and validated

5. **Large PR**:
   - Input: `/review 789` (PR with >1000 lines)
   - Expected: Adaptive strategy applied
   - Verify: Recommends splitting PR
```

## Testing Agents

### Isolated Agent Testing

Test agents independently from commands:

```bash
# Create test context file
cat > /tmp/test-context.md << 'EOF'
# Test Context
PR: #123
Files: src/auth.ts, src/api.ts
Changes: 50 additions, 10 deletions
EOF

# Invoke agent directly
# (This requires a command that invokes the agent)
/test-agent security-scanner /tmp/test-context.md
```

### Agent Test Template

Create test command in `commands/test-agent.md`:

```markdown
---
description: "Test individual agent (dev only)"
argument-hint: "<AGENT_NAME> <CONTEXT_FILE>"
---

You are a test orchestrator.

Invoke agent `$1` with context file: $2

Display:
- Agent output
- Execution time
- Report location (if applicable)
- Any errors
```

### Validation Checklist

Test each agent for:

- [ ] **Receives arguments**: `$1`, `$2` passed correctly
- [ ] **Reads context**: Can read context file
- [ ] **Performs analysis**: Core logic works
- [ ] **Writes report**: Report created in correct location
- [ ] **Returns summary**: Concise response (< 200 words)
- [ ] **Handles errors**: Graceful degradation on failures
- [ ] **Tool usage**: Only uses granted tools

### Example Agent Test

For `security-scanner` agent:

```markdown
**Test Cases**:

1. **No security issues**:
   - Context: Clean React code
   - Expected: Score 10/10, no findings
   - Verify: Report created with "No issues found"

2. **XSS vulnerability**:
   - Context: Code with dangerouslySetInnerHTML
   - Expected: Critical finding with fix
   - Verify: Report includes file:line and code example

3. **Missing context file**:
   - Context: Invalid file path
   - Expected: Error "Context file not found at [path]"
   - Verify: Helpful error message

4. **No React files**:
   - Context: Only Python files
   - Expected: "No React files detected. Skipping analysis."
   - Verify: Not treated as error

5. **Large codebase**:
   - Context: 100+ files
   - Expected: Analysis completes within time limit
   - Verify: Reports on high-risk patterns only
```

## Testing Workflows

### Sequential Workflow Testing

Test each phase independently, then together:

```markdown
**Phase-by-Phase Testing**:

1. **Phase 1 alone**:
   - Run context-gatherer
   - Verify context file created
   - Validate file structure

2. **Phase 2 alone**:
   - Use mock context file
   - Run analyzer
   - Verify report created

3. **Phase 3 alone**:
   - Use mock reports
   - Run synthesizer
   - Verify final output

4. **Full workflow**:
   - Run all phases
   - Verify handoffs work
   - Check token usage
```

### Parallel Workflow Testing

Verify agents run in parallel:

```markdown
**Parallel Execution Verification**:

1. Add timing logs to agents:
   ```markdown
   echo "Agent started at $(date +%s)" > /tmp/agent-start-time
   # ... agent logic ...
   echo "Agent finished at $(date +%s)" > /tmp/agent-end-time
   ```

2. Run workflow with 3 agents

3. Check timing:
   - Sequential: ~90 seconds (3 agents × 30s each)
   - Parallel: ~30 seconds (all run simultaneously)

4. Verify: Execution time ≈ longest agent, not sum
```

### Workflow Test Checklist

- [ ] **Context creation**: Baseline context file created
- [ ] **Context enrichment**: Agents append/read correctly
- [ ] **Parallel execution**: Independent agents run simultaneously
- [ ] **Report generation**: All reports created in correct location
- [ ] **Synthesis**: Final output combines all findings
- [ ] **Error handling**: Workflow continues if one agent fails
- [ ] **Token efficiency**: Usage matches expectations
- [ ] **Execution time**: Completes within acceptable time

## Testing MCP Integration

### Connection Testing

```markdown
**MCP Connection Test**:

1. Create test command:
   ```markdown
   ---
   description: "Test MCP server connection"
   ---

   Test Context7 connection:

   Use: mcp__context7__resolve-library-id
   Parameters: { libraryName: "react" }

   Expected: "/facebook/react"

   If successful: "✅ Context7 connected"
   If failed: "❌ Context7 unavailable: [error]"
   ```

2. Run test: `/test-mcp`

3. Verify:
   - Connection succeeds
   - Tool returns expected result
   - Error handling works
```

### Tool Testing

```markdown
**MCP Tool Test Cases**:

1. **Valid request**:
   - Call: mcp__context7__get-library-docs
   - Params: { libraryID: "/facebook/react", topic: "hooks", tokens: 1000 }
   - Expected: Documentation content returned

2. **Invalid library**:
   - Params: { libraryID: "/invalid/library" }
   - Expected: Error message
   - Verify: Graceful handling

3. **Authentication failure**:
   - Unset: CONTEXT7_API_KEY
   - Expected: Auth error
   - Verify: Clear error message with fix

4. **Rate limiting**:
   - Make many rapid requests
   - Expected: Rate limit error
   - Verify: Retry logic or helpful message
```

### MCP Test Checklist

- [ ] **Configuration valid**: `.mcp.json` is valid JSON
- [ ] **Environment variables set**: Required keys configured
- [ ] **Connection succeeds**: Server reachable
- [ ] **Tools discoverable**: Listed in `/help`
- [ ] **Tool invocation works**: Correct responses
- [ ] **Authentication works**: Tokens/keys accepted
- [ ] **Error handling**: Failures handled gracefully
- [ ] **Fallback logic**: Works without MCP when appropriate

## Testing Hooks

### Hook Execution Testing

```bash
# Test pre-commit hook manually
./scripts/pre-commit-hook.sh
echo $?  # Check exit code

# Test with intentional failure
# (Add lint error, then run hook)
echo "var x = 'invalid" >> test.js
./scripts/pre-commit-hook.sh
# Should exit with code 2 (block)
```

### Hook Test Cases

```markdown
**Hook Test Scenarios**:

1. **Success case**:
   - Clean code
   - Run: git commit
   - Expected: Hook passes, commit succeeds

2. **Failure case**:
   - Add lint error
   - Run: git commit
   - Expected: Hook blocks, commit fails with clear message

3. **Partial failure**:
   - Linting passes, tests fail
   - Expected: Based on exitCodes config

4. **Hook disabled**:
   - Rename hooks.json
   - Run: git commit
   - Expected: No hook runs, commit succeeds

5. **Performance**:
   - Time: time ./scripts/pre-commit-hook.sh
   - Expected: < 2 seconds
```

### Hook Test Checklist

- [ ] **Execution**: Hook runs on correct trigger
- [ ] **Exit codes**: 0=continue, 1=error, 2=block work correctly
- [ ] **Performance**: Completes quickly (< 2 seconds)
- [ ] **Error messages**: Clear and actionable
- [ ] **Permissions**: Script is executable
- [ ] **Logging**: Errors logged appropriately

## Debugging Techniques

### 1. Enable Debug Output

Add debug logging to agents:

```markdown
**Debug Mode**:
```bash
echo "=== DEBUG INFO ===" >&2
echo "Agent: security-scanner" >&2
echo "Arguments: $@" >&2
echo "PWD: $(pwd)" >&2
echo "Context file: $1" >&2
echo "Context exists: $(test -f $1 && echo 'yes' || echo 'no')" >&2
echo "=================" >&2
```
```

### 2. Trace Tool Calls

Log all tool calls:

```markdown
**Before tool call**:
echo "Calling: gh pr view $1 --json title" >&2

**Execute**:
!gh pr view $1 --json title

**After tool call**:
echo "Exit code: $?" >&2
```

### 3. Inspect Context Files

```bash
# View context file
cat .claude/sessions/pr_reviews/pr_123_context.md

# Check file structure
tree .claude/sessions/

# Search for specific content
grep "useEffect" .claude/sessions/pr_reviews/pr_123_context.md
```

### 4. Test with Known Issues

Create test cases with known bugs:

```typescript
// test-cases/xss-vulnerability.tsx
function Component() {
  // Known XSS vulnerability
  return <div dangerouslySetInnerHTML={{__html: userInput}} />;
}
```

```bash
# Should detect this
/security-check test-cases/xss-vulnerability.tsx
```

### 5. Verify Token Usage

Track token consumption:

```markdown
**Before workflow**:
Note token count

**After workflow**:
Note token count

**Calculate usage**:
Tokens used = After - Before

**Compare to budget**:
Expected: ~5000 tokens
Actual: [measured]
Variance: [%]
```

### 6. Check File Permissions

```bash
# Verify session directory exists
ls -la .claude/sessions/

# Check file permissions
ls -la .claude/sessions/pr_reviews/

# Verify file is readable
cat .claude/sessions/pr_reviews/pr_123_context.md
```

### 7. Test Error Paths

Force errors to test handling:

```bash
# Invalid PR number
/review 99999

# Missing argument
/review

# No gh authentication
gh auth logout
/review 123

# MCP server down
# (temporarily disable network)
/review 123
```

## Performance Testing

### Token Budget Tracking

```markdown
**Token Budget Test**:

1. Baseline measurement:
   - Run workflow
   - Record token usage

2. Optimization:
   - Implement file-based context
   - Reduce agent response length
   - Remove redundant calls

3. Measure again:
   - Record new token usage
   - Calculate savings

4. Compare:
   - Before: X tokens
   - After: Y tokens
   - Savings: (X-Y)/X %
```

### Execution Time Profiling

```markdown
**Timing Test**:

1. Add timing to each phase:
   ```markdown
   START=$(date +%s)
   # Phase 1 logic
   END=$(date +%s)
   echo "Phase 1: $((END-START))s"
   ```

2. Run workflow

3. Analyze results:
   - Phase 1: 5s (context gathering)
   - Phase 2: 30s (parallel analysis)
   - Phase 3: 10s (synthesis)
   - Total: 45s

4. Identify bottlenecks:
   - Longest phase: Phase 2
   - Optimization target: Reduce analysis time
```

### Load Testing

Test with various input sizes:

```markdown
**Load Test Cases**:

1. Small PR (< 100 lines):
   - Expected: Full analysis
   - Time: < 30s
   - Tokens: < 10,000

2. Medium PR (100-500 lines):
   - Expected: Detailed analysis
   - Time: < 60s
   - Tokens: < 20,000

3. Large PR (500-1000 lines):
   - Expected: Strategic sampling
   - Time: < 90s
   - Tokens: < 30,000

4. Very Large PR (> 1000 lines):
   - Expected: Critical path only
   - Time: < 120s
   - Tokens: < 40,000
```

## Common Issues

### Issue: Command Not Found

**Symptom**: `/my-command` returns "Command not found"

**Debug**:
```bash
# Check plugin installed
/plugin list | grep my-plugin

# Check file exists
ls my-plugin/commands/my-command.md

# Check file extension
# (must be .md, not .txt)

# Reinstall
/plugin uninstall my-plugin@local
/plugin install my-plugin@local
```

### Issue: Agent Not Executing

**Symptom**: Agent invoked but no output

**Debug**:
```markdown
# Add debug output to agent
echo "Agent started: $(date)" >&2
echo "Arguments: $@" >&2

# Check agent file exists
ls my-plugin/agents/my-agent.md

# Verify agent frontmatter
head -10 my-plugin/agents/my-agent.md

# Check tool permissions
# Agent might need Read/Write tools
```

### Issue: Tool Permission Denied

**Symptom**: "Permission denied" when agent uses tool

**Debug**:
```yaml
# Check agent frontmatter has tool
---
tools: Read, Write, Bash(gh:*)
---

# If tool missing, add it
# Reload plugin
```

### Issue: Context File Not Found

**Symptom**: "Context file not found at [path]"

**Debug**:
```bash
# Check if file exists
ls -la .claude/sessions/pr_reviews/

# Verify path is absolute
pwd
# Use full path: /Users/you/project/.claude/sessions/...

# Check directory was created
mkdir -p .claude/sessions/pr_reviews/

# Verify Write tool granted
# (needed to create files)
```

### Issue: MCP Tool Not Working

**Symptom**: "Tool mcp__context7__get-library-docs not found"

**Debug**:
```bash
# Check .mcp.json exists
ls my-plugin/.mcp.json

# Validate JSON
cat my-plugin/.mcp.json | jq

# Check environment variable
echo $CONTEXT7_API_KEY

# Restart Claude Desktop
# (required after .mcp.json changes)

# Test connection
curl -H "CONTEXT7_API_KEY: $CONTEXT7_API_KEY" \
  https://mcp.context7.com/health
```

### Issue: Hook Not Triggering

**Symptom**: Hook doesn't run on expected event

**Debug**:
```bash
# Check hooks.json exists
ls my-plugin/hooks.json

# Validate JSON
cat my-plugin/hooks.json | jq

# Check matcher pattern
# Correct: "Bash(git:commit)"
# Wrong: "git:commit"

# Test hook script manually
./scripts/pre-commit-hook.sh
echo $?  # Should be 0, 1, or 2

# Check permissions
ls -la scripts/pre-commit-hook.sh
# Should be executable: -rwxr-xr-x
```

## Quality Checklist

Before releasing plugin:

### Functionality
- [ ] All commands work with valid inputs
- [ ] All commands handle invalid inputs gracefully
- [ ] All agents execute correctly
- [ ] Workflows complete successfully
- [ ] MCP integrations work (if applicable)
- [ ] Hooks trigger appropriately (if applicable)

### Error Handling
- [ ] Missing arguments show usage
- [ ] Invalid inputs show clear errors
- [ ] Tool failures handled gracefully
- [ ] Partial failures don't crash workflow
- [ ] Error messages include remediation

### Performance
- [ ] Token usage within budget
- [ ] Execution time acceptable
- [ ] No unnecessary tool calls
- [ ] File-based context used efficiently
- [ ] Parallel execution where appropriate

### User Experience
- [ ] Clear command descriptions
- [ ] Helpful argument hints
- [ ] Progress indicators for long operations
- [ ] Structured, readable output
- [ ] Documentation complete

### Security
- [ ] No hardcoded secrets
- [ ] Tool permissions restricted
- [ ] Input validation in place
- [ ] Scripts have correct permissions
- [ ] Sensitive data not logged

### Documentation
- [ ] README with installation instructions
- [ ] Command usage examples
- [ ] MCP setup guide (if applicable)
- [ ] Troubleshooting section
- [ ] Changelog

## Automated Testing

### Test Script Example

`scripts/test-plugin.sh`:
```bash
#!/bin/bash

set -e

echo "🧪 Testing my-plugin..."

# Test 1: Command with valid input
echo "Test 1: Valid input"
claude-code run "/my-command valid-arg" | grep -q "Expected output" || {
  echo "❌ Test 1 failed"
  exit 1
}
echo "✅ Test 1 passed"

# Test 2: Command with invalid input
echo "Test 2: Invalid input"
claude-code run "/my-command" 2>&1 | grep -q "Usage:" || {
  echo "❌ Test 2 failed"
  exit 1
}
echo "✅ Test 2 passed"

# Test 3: Agent execution
echo "Test 3: Agent execution"
# (Test agent via command that invokes it)
claude-code run "/test-agent my-agent /tmp/test-context.md" | grep -q "Agent completed" || {
  echo "❌ Test 3 failed"
  exit 1
}
echo "✅ Test 3 passed"

echo "✅ All tests passed!"
```

Run tests:
```bash
chmod +x scripts/test-plugin.sh
./scripts/test-plugin.sh
```

## Summary

- **Test incrementally**: Components → Integration → E2E
- **Use local marketplace**: Fast development cycle
- **Test edge cases**: Invalid inputs, missing args, failures
- **Profile performance**: Token usage and execution time
- **Debug systematically**: Add logging, inspect files, test manually
- **Automate testing**: Create test scripts for regression testing
- **Check quality**: Use checklist before release

Thorough testing ensures your plugin works reliably for all users.

## Next Steps

You now have complete knowledge to build Claude Code plugins:

1. **Start simple**: Use templates from `templates/` directory
2. **Test early**: Validate each component as you build
3. **Iterate quickly**: Use local marketplace for fast development
4. **Optimize**: Profile and improve token efficiency
5. **Document**: Write clear README and usage examples
6. **Share**: Distribute via marketplace

Happy plugin building!
