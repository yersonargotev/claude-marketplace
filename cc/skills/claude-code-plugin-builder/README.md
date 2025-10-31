# Claude Code Plugin Builder Skill

Complete Agent Skill for building production-ready Claude Code plugins with commands, subagents, workflows, MCP servers, and hooks.

## Installation

### Option 1: Local Installation

```bash
# Copy skill to Claude Code skills directory
cp -r claude-code-plugin-builder ~/.claude/skills/

# Skill will be auto-discovered by Claude Code
```

### Option 2: Use Directly

Point Claude Code to this directory when you need plugin development assistance.

## Quick Start

Ask Claude Code:

```
I need to create a Claude Code plugin that [describe what you want].
Use the claude-code-plugin-builder skill to guide me.
```

Claude will:
1. Understand your requirements
2. Design appropriate architecture
3. Generate complete plugin files
4. Provide installation and testing guidance

## What This Skill Provides

### Comprehensive Guides

- **[SKILL.md](SKILL.md)** - Main entry point with overview and quickstart
- **[COMMANDS.md](COMMANDS.md)** - Creating slash commands with arguments
- **[AGENTS.md](AGENTS.md)** - Building specialized subagents
- **[WORKFLOWS.md](WORKFLOWS.md)** - Multi-agent orchestration patterns
- **[MCP.md](MCP.md)** - External tool integration via MCP servers
- **[HOOKS.md](HOOKS.md)** - Event-driven automation
- **[TESTING.md](TESTING.md)** - Testing and debugging strategies

### Ready-to-Use Templates

Located in `templates/` directory:

- `plugin.json` - Plugin manifest configuration
- `marketplace.json` - Local marketplace setup
- `command-template.md` - Slash command template
- `agent-template.md` - Specialized subagent template
- `orchestrator-command.md` - Multi-agent workflow template
- `mcp-config.json` - MCP server configuration
- `hooks-template.json` - Hooks configuration

### Architecture Patterns

From real-world production plugins:

- **File-based context sharing** - 70% token reduction
- **Parallel agent execution** - 3x faster workflows
- **Adaptive strategies** - Scale with input size
- **Graceful degradation** - Handle failures elegantly

## Use Cases

### 1. Simple Command Plugin

Create a basic plugin with a single command:

```
Create a plugin that formats code with Prettier when I run /format.
```

### 2. Analysis Plugin

Build a plugin with specialized analysis agents:

```
Create a plugin that reviews PRs for security issues, performance problems, and code quality.
```

### 3. Workflow Plugin

Design a multi-agent orchestration workflow:

```
Create a plugin that migrates deprecated APIs to new versions across the codebase.
```

### 4. Integration Plugin

Connect to external services:

```
Create a plugin that integrates with Sentry to analyze error patterns and suggest fixes.
```

### 5. Automation Plugin

Add event-driven automation:

```
Create a plugin that auto-formats and lints code before every git commit.
```

## Example Plugins

### Hello World Plugin

Minimal working plugin:

```markdown
# File: my-plugin/.claude-plugin/plugin.json
{
  "name": "hello-plugin",
  "version": "1.0.0",
  "description": "Simple greeting plugin"
}

# File: my-plugin/commands/hello.md
---
description: "Say hello to the user"
argument-hint: "[NAME]"
---

Greet the user warmly.
If name provided in $1, greet them by name.
Otherwise, use a friendly generic greeting.
```

### PR Review Plugin

Advanced multi-agent workflow:

See the exito plugin in the claude-marketplace repository for a complete production example with:
- 8 specialized analysis agents
- Parallel execution
- MCP integration (Azure DevOps, Context7)
- Adaptive strategies
- ~83% token optimization

## Development Workflow

### 1. Create Plugin Structure

```bash
mkdir -p my-plugin/.claude-plugin
mkdir -p my-plugin/commands
mkdir -p my-plugin/agents
cp templates/plugin.json my-plugin/.claude-plugin/
```

### 2. Add Commands

```bash
cp templates/command-template.md my-plugin/commands/my-command.md
# Edit command file
```

### 3. Add Agents (Optional)

```bash
cp templates/agent-template.md my-plugin/agents/my-agent.md
# Edit agent file
```

### 4. Setup Local Marketplace

```bash
# Create marketplace config
cat > ~/.claude/marketplace.json << 'EOF'
{
  "plugins": {
    "my-plugin": {
      "path": "/absolute/path/to/my-plugin"
    }
  }
}
EOF
```

### 5. Install and Test

```bash
# In Claude Code
/plugin add local/my-plugin
/plugin install my-plugin@local

# Test your command
/my-command test-arg
```

### 6. Iterate

```bash
# Edit files
vim my-plugin/commands/my-command.md

# Reload (restart Claude Desktop or reinstall)
/plugin uninstall my-plugin@local
/plugin install my-plugin@local

# Test again
/my-command test-arg
```

## Best Practices

### Token Efficiency

- ✅ Use file-based context sharing
- ✅ Agents write reports to disk
- ✅ Return concise summaries (< 200 words)
- ❌ Don't pass large diffs in messages
- ❌ Don't return full reports to orchestrator

**Result**: 60-80% token reduction

### Single Responsibility

- ✅ One clear purpose per agent
- ✅ Focused expertise domains
- ✅ Selective tool access
- ❌ Don't create "swiss army knife" agents

### Actionable Output

Every finding must include:
1. **Location**: `file.ts:42-48`
2. **Description**: What is the issue?
3. **Impact**: Why does this matter?
4. **Fix**: Concrete code example
5. **Priority**: Critical/High/Medium/Low

### Graceful Degradation

- ✅ Validate inputs before processing
- ✅ Handle missing data with fallbacks
- ✅ Provide clear error messages
- ✅ Continue workflow if one agent fails

## Architecture Patterns

### Sequential Workflow

```
Agent A → Agent B → Agent C → Synthesize
```

Use when: Later agents depend on earlier results

### Parallel Workflow

```
        ┌─ Agent A ─┐
Start ──┼─ Agent B ─┼── Synthesize
        └─ Agent C ─┘
```

Use when: Agents are independent (3x faster)

### File-Based Context

```
Phase 1: Create context.md (single source of truth)
Phase 2: All agents read context.md
Phase 3: Each agent writes [agent]_report.md
Phase 4: Synthesizer reads all reports
```

**Result**: 70% token reduction, no context loss

## Integration Options

### MCP Servers

Integrate external services:

- **Context7**: Up-to-date library documentation
- **GitHub**: Repository and PR management
- **Azure DevOps**: Work item tracking
- **Sentry**: Error tracking
- **Linear**: Issue management
- **Custom**: Your own integrations

See [MCP.md](MCP.md) for complete guide.

### Hooks

Automate quality gates:

- **PreToolUse**: Run before tool execution (linting, validation)
- **PostToolUse**: Run after tool execution (testing, formatting)
- **FileChange**: Trigger on file changes (builds, type generation)
- **Error**: Handle errors (notifications, logging)

See [HOOKS.md](HOOKS.md) for complete guide.

## Token Optimization Results

From exito plugin production data:

| Approach | Tokens Used | Notes |
|----------|-------------|-------|
| Naive (message passing) | ~25,000 | Pass full context between agents |
| Optimized (file-based) | ~4,200 | Context file + summaries only |
| **Savings** | **83%** | No loss of quality |

## Performance Benchmarks

From real-world usage:

| PR Size | Agents | Execution Time | Token Usage |
|---------|--------|----------------|-------------|
| Small (< 100 lines) | 6 parallel | ~30s | ~5,000 |
| Medium (100-500) | 6 parallel | ~45s | ~8,000 |
| Large (500-1000) | 6 parallel | ~60s | ~15,000 |
| Very Large (> 1000) | 3 critical | ~40s | ~10,000 |

## Troubleshooting

### Command Not Found

```bash
# Check plugin installed
/plugin list | grep my-plugin

# Reinstall
/plugin uninstall my-plugin@local
/plugin install my-plugin@local
```

### Agent Not Executing

Check agent frontmatter has required tools:

```yaml
---
tools: Read, Write  # If agent reads/writes files
---
```

### MCP Tools Not Available

```bash
# Check .mcp.json exists
ls my-plugin/.mcp.json

# Check environment variable set
echo $API_KEY

# Restart Claude Desktop
```

See [TESTING.md](TESTING.md) for comprehensive debugging guide.

## Documentation

Each guide covers:

- **SKILL.md**: Overview, quickstart, architecture
- **COMMANDS.md**: Argument handling, bash commands, file references
- **AGENTS.md**: System prompts, tool permissions, output quality
- **WORKFLOWS.md**: Sequential vs parallel, context management, synthesis
- **MCP.md**: Server configuration, authentication, tool usage
- **HOOKS.md**: Event types, matchers, exit codes, scripts
- **TESTING.md**: Component testing, debugging, performance profiling

## Examples and References

### Minimal Plugin

See Quick Start section above for 5-minute plugin.

### Production Plugin

See `exito-plugin` in claude-marketplace repo for:
- Complete multi-agent architecture
- Token-optimized workflows
- MCP integrations
- Adaptive strategies
- Real-world patterns

### Template Files

See `templates/` directory for:
- Plugin manifest
- Command templates
- Agent templates
- Orchestrator patterns
- MCP configuration
- Hooks configuration

## Contributing

To improve this skill:

1. Add new patterns to guides
2. Update templates with learnings
3. Document edge cases
4. Share production examples

## Support

For issues or questions:

1. Review relevant guide (COMMANDS.md, AGENTS.md, etc.)
2. Check TESTING.md for debugging strategies
3. Examine template files for examples
4. Reference exito plugin for production patterns

## License

MIT License - Use freely for any purpose

## Version History

- **v1.0.0** (2025-01-30): Initial comprehensive skill release
  - Complete guides for all plugin aspects
  - Production-ready templates
  - Real-world optimization patterns
  - Extensive examples and references

---

**Ready to build plugins?** Start with [SKILL.md](SKILL.md) and follow the Quick Start guide!
