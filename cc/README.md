# Plugin Builder

Comprehensive Claude Code plugin development toolkit with templates, guides, and interactive commands for building custom plugins, commands, and agents.

## Features

- **🎯 Agent Skill**: Automatic plugin building assistance when Claude detects you're working on plugins
- **⚡ Interactive Commands**: Direct commands for creating plugins, commands, and agents
- **📚 Comprehensive Guides**: Detailed documentation for all plugin components
- **🎨 Production Templates**: Ready-to-use templates for all plugin components
- **✅ Best Practices**: Industry-leading patterns from Anthropic guidelines

## Installation

### From Marketplace

```bash
/plugin marketplace add yargotev/claude-marketplace
/plugin install plugin-builder@claude-marketplace
```

### Local Development

```bash
# Clone the repository
git clone https://github.com/yargotev/claude-marketplace.git

# Add local marketplace
/plugin marketplace add ./claude-marketplace

# Install the plugin
/plugin install plugin-builder@local
```

## Commands

### `/new-plugin [NAME]`
Create a new Claude Code plugin with interactive guided setup.

**Usage**:
```bash
# Interactive mode
/new-plugin

# With plugin name
/new-plugin my-awesome-plugin
```

**Features**:
- Creates complete plugin structure
- Generates plugin.json with metadata
- Optional first command/agent creation
- Sets up local testing marketplace
- Provides next steps guidance

---

### `/new-command [NAME]`
Add a new slash command to an existing plugin.

**Usage**:
```bash
# From plugin directory
cd my-plugin
/new-command

# With command name
/new-command analyze-security
```

**Features**:
- Interactive command configuration
- Template-based generation
- Argument handling setup
- Tool permission configuration
- Automatic README updates

---

### `/new-agent [NAME]`
Add a specialized subagent to an existing plugin.

**Usage**:
```bash
# From plugin directory
cd my-plugin
/new-agent

# With agent name
/new-agent security-scanner
```

**Features**:
- Interactive agent configuration
- Role and specialization setup
- Tool access restrictions
- Model selection
- Integration guidance

## Agent Skill

The plugin includes a comprehensive **Agent Skill** that activates automatically when you:

- Create or modify Claude Code plugins
- Work with custom commands
- Design specialized agents
- Build workflows
- Integrate MCP servers
- Set up hooks

**Skill Name**: `claude-code-plugin-builder`

Claude will automatically invoke this skill when relevant, providing:
- Architecture guidance
- Best practices
- Template references
- Token optimization strategies
- Error handling patterns

## Documentation

Comprehensive guides are available in the `skills/claude-code-plugin-builder/` directory:

- **[SKILL.md](skills/claude-code-plugin-builder/SKILL.md)** - Overview and quick start
- **[COMMANDS.md](skills/claude-code-plugin-builder/COMMANDS.md)** - Slash command patterns
- **[AGENTS.md](skills/claude-code-plugin-builder/AGENTS.md)** - Subagent design guide
- **[WORKFLOWS.md](skills/claude-code-plugin-builder/WORKFLOWS.md)** - Multi-agent orchestration
- **[MCP.md](skills/claude-code-plugin-builder/MCP.md)** - External tool integration
- **[HOOKS.md](skills/claude-code-plugin-builder/HOOKS.md)** - Event-driven automation
- **[TESTING.md](skills/claude-code-plugin-builder/TESTING.md)** - Debugging strategies

## Templates

Ready-to-use templates in `skills/claude-code-plugin-builder/templates/`:

| Template | Purpose |
|----------|---------|
| `plugin.json` | Plugin manifest |
| `marketplace.json` | Local marketplace config |
| `command-template.md` | Slash command scaffold |
| `agent-template.md` | Subagent scaffold |
| `orchestrator-command.md` | Multi-agent workflow |
| `mcp-config.json` | MCP server configuration |
| `hooks-template.json` | Event hooks |

## Quick Start

### Create Your First Plugin (5 Minutes)

1. **Create a new plugin**:
   ```bash
   /new-plugin hello-world
   ```

2. **Follow interactive prompts**:
   - Enter description
   - Add your first command
   - Set up local testing

3. **Test your plugin**:
   ```bash
   /plugin install hello-world@local-dev
   /hello
   ```

### Add Components to Existing Plugin

1. **Add a command**:
   ```bash
   cd my-plugin
   /new-command greet
   ```

2. **Add an agent**:
   ```bash
   cd my-plugin
   /new-agent analyzer
   ```

3. **Reload and test**:
   ```bash
   /plugin disable my-plugin
   /plugin enable my-plugin
   /greet Alice
   ```

## Examples

### Real-World Plugin: Exito

The `exito` plugin (mentioned in documentation) demonstrates advanced patterns:

**Commands**:
- `/review` - Multi-agent PR review orchestrator
- `/build` - Full feature development workflow
- `/patch` - Quick fixes with focused analysis

**Key Patterns**:
- Context persistence in `.claude/sessions/`
- Parallel agent execution
- Adaptive strategies (review depth scales with PR size)
- MCP integration (Azure DevOps, Context7)
- Token optimization (~67% reduction)

**Architecture**:
1. Context-gatherer creates baseline
2. Business-validator enriches with User Stories
3. Six specialized agents run in parallel
4. Orchestrator synthesizes unified review

## Best Practices

### Design Principles

1. **Token Efficiency First**
   - Use file-based context sharing (pass paths, not content)
   - Persist reports to disk
   - Return concise summaries (< 200 words)

2. **Single Responsibility**
   - One purpose per agent/command
   - Selective tool access
   - Clear domain expertise

3. **Graceful Degradation**
   - Validate inputs
   - Handle missing data
   - Clear error messages
   - Adaptive strategies

4. **Actionable Output**
   - Location (file:line)
   - Description
   - Impact
   - Concrete fix
   - Priority

### Common Patterns

**File-Based Communication**:
```markdown
# Agent reads from:
$1 = ".claude/sessions/context.md"

# Agent writes to:
".claude/sessions/agent_report.md"

# Orchestrator synthesizes:
Read all reports from file system
```

**Parallel Execution**:
```markdown
Invoke multiple agents in single message:
- Agent A (analysis)
- Agent B (review)
- Agent C (testing)

All run simultaneously for maximum speed
```

**Adaptive Strategies**:
```markdown
Classify input size → Adjust analysis depth
- Small: Full detailed review
- Large: Prioritized focus areas
```

## Troubleshooting

### Plugin Not Loading
- Check `.claude-plugin/plugin.json` exists
- Validate JSON syntax
- Restart Claude Code

### Command Not Appearing
- Verify file is in `commands/` directory
- Check filename is kebab-case with `.md` extension
- Run `/help` to see if listed
- Reload plugin: `/plugin disable` → `/plugin enable`

### Agent Not Invoked
- Check `description` field is specific
- Verify YAML frontmatter is valid
- Use `/agents` to confirm agent is listed
- Explicitly invoke: "Use the {agent-name} agent to..."

## Contributing

Contributions welcome! Areas for improvement:

- Additional templates for common patterns
- More example plugins
- Enhanced interactive commands
- Additional documentation

## Resources

- **Official Docs**: [Claude Code Plugins](https://docs.claude.ai/docs/claude-code/plugins)
- **Agent Skills**: [Agent Skills Overview](https://docs.claude.ai/docs/agents-and-tools/agent-skills)
- **MCP Protocol**: [Model Context Protocol](https://docs.claude.ai/docs/claude-code/mcp)

## License

MIT License - See [LICENSE](LICENSE) file

## Support

- **Issues**: [GitHub Issues](https://github.com/yargotev/claude-marketplace/issues)
- **Documentation**: See `skills/claude-code-plugin-builder/` directory
- **Examples**: Ask Claude to show examples from the guides

---

**Built with ❤️ for the Claude Code community**
