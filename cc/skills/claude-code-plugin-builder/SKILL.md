---
name: claude-code-plugin-builder
description: Build Claude Code plugins with commands, subagents, workflows, skills, hooks, and MCP servers. Use when creating or modifying Claude Code plugins, custom commands, specialized agents, or integrating external tools.
---

# Claude Code Plugin Builder

A comprehensive skill for building production-ready Claude Code plugins with custom commands, specialized subagents, workflow orchestration, Agent Skills, hooks, and MCP server integrations.

## When to Use This Skill

Use this skill when you need to:
- Create a new Claude Code plugin from scratch
- Add custom slash commands to existing plugins
- Design specialized subagents for task delegation
- Build multi-agent orchestration workflows
- Integrate MCP servers for external tool access
- Set up event-driven automation with hooks
- Package and distribute plugins via marketplace
- Debug or optimize existing plugin architectures

## Quick Start (5 Minutes)

### Create Your First Plugin

1. **Create plugin structure**:
```bash
mkdir -p my-plugin/.claude-plugin
mkdir -p my-plugin/commands
mkdir -p my-plugin/agents
```

2. **Create plugin manifest** (`my-plugin/.claude-plugin/plugin.json`):
```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My first Claude Code plugin",
  "author": "Your Name"
}
```

3. **Create your first command** (`my-plugin/commands/hello.md`):
```markdown
---
description: "Say hello to the user"
argument-hint: "[NAME]"
---

You are a friendly greeting assistant.

Greet the user by name if provided (use $1 for first argument), otherwise greet them warmly.

Example:
- If name provided: "Hello, Alice! Welcome to Claude Code!"
- If no name: "Hello! Welcome to Claude Code!"
```

4. **Install locally**:
```bash
# Create local marketplace
echo '{"plugins": {"my-plugin": {"path": "./my-plugin"}}}' > ~/.claude/marketplace.json

# Install the plugin
/plugin add local/my-plugin
/plugin install my-plugin@local
```

5. **Test your command**:
```bash
/hello Alice
```

Congratulations! You've created your first plugin.

## Plugin Architecture

Claude Code plugins follow a structured architecture:

```
my-plugin/
├── .claude-plugin/           # Plugin metadata
│   ├── plugin.json           # Manifest (required)
│   └── hooks.json            # Event hooks (optional)
├── .mcp.json                 # MCP server config (optional)
├── commands/                 # Slash commands (user-facing)
│   ├── simple-command.md     # Basic command
│   ├── with-args.md          # Command with arguments
│   └── orchestrator.md       # Multi-agent workflow
├── agents/                   # Specialized subagents
│   ├── analyzer.md           # Analysis agent
│   ├── builder.md            # Implementation agent
│   └── reviewer.md           # Review agent
├── skills/                   # Agent Skills (optional)
│   └── my-skill/
│       ├── SKILL.md          # Skill entry point
│       └── helpers.md        # Supporting files
└── templates/                # Reusable templates (optional)
    └── report-template.md
```

## Core Concepts

### 1. Commands
Slash commands are the user-facing interface to your plugin. They can:
- Execute simple tasks directly
- Accept arguments from users
- Orchestrate multiple subagents
- Run bash commands and interact with files

**See [COMMANDS.md](COMMANDS.md) for detailed guide.**

### 2. Subagents
Specialized agents that perform focused tasks. They:
- Run in isolated contexts with clean state
- Have restricted tool access for security
- Can use different models than the main thread
- Communicate via structured outputs

**See [AGENTS.md](AGENTS.md) for detailed guide.**

### 3. Workflows
Orchestration patterns for coordinating multiple agents:
- Sequential execution (agent A → B → C)
- Parallel execution (agents A, B, C run simultaneously)
- File-based context sharing (token efficient)
- Report synthesis and aggregation

**See [WORKFLOWS.md](WORKFLOWS.md) for detailed guide.**

### 4. MCP Servers
Integrate external tools and services:
- Access GitHub, Sentry, Linear, etc.
- Fetch up-to-date documentation (Context7)
- Query databases and APIs
- Extend plugin capabilities dynamically

**See [MCP.md](MCP.md) for detailed guide.**

### 5. Hooks
Event-driven automation for quality gates:
- Pre/post tool execution hooks
- Format code before commits
- Validate inputs before execution
- Send notifications on events

**See [HOOKS.md](HOOKS.md) for detailed guide.**

### 6. Agent Skills
Modular, reusable capabilities:
- Self-contained expertise modules
- Discoverable by LLM from descriptions
- Can be shared across plugins
- Support multi-file organization

**See [Agent Skills documentation](https://docs.claude.ai/docs/agent-skills) for details.**

## Design Principles

### Token Efficiency First
- **Use file-based context sharing**: Pass file paths, not content
- **Persist reports to disk**: Agents write findings to `.claude/sessions/`
- **Return concise summaries**: Agents return < 200 words to orchestrators
- **Avoid message passing**: Don't duplicate large context between agents

### Single Responsibility
- **One purpose per agent**: Each agent has clear, focused role
- **Selective tool access**: Grant only necessary tools
- **Structured prompts**: Use XML tags or Markdown headers
- **Domain expertise**: Agents embody specific roles (Security Engineer, Performance Expert)

### Graceful Degradation
- **Validate inputs**: Check arguments before processing
- **Handle missing data**: Provide fallbacks for tool failures
- **Clear error messages**: Include remediation steps
- **Adaptive strategies**: Scale analysis based on input size

### Actionable Output
Every finding must include:
1. **Location**: File path and line number
2. **Description**: What is the issue?
3. **Impact**: Why does this matter?
4. **Fix**: Concrete code example (before/after)
5. **Priority**: Critical / High / Medium / Low

## Real-World Example: exito Plugin

The `exito` plugin demonstrates advanced patterns:

**Commands**:
- `/review` - Orchestrates 8 specialized agents for PR review
- `/build` - Full feature development workflow
- `/patch` - Quick fixes with focused analysis

**Key Patterns**:
- **Context persistence**: Single source of truth in `.claude/sessions/pr_reviews/`
- **Parallel execution**: All analysis agents run simultaneously
- **Adaptive strategies**: Review depth scales with PR size
- **MCP integration**: Azure DevOps for business validation, Context7 for docs
- **Token optimization**: ~67% reduction vs naive implementation

**Architecture**:
1. Context-gatherer creates baseline context file
2. Business-validator enriches with User Story data (if provided)
3. Six specialized agents run in parallel, write individual reports
4. Orchestrator synthesizes findings into unified review

## Templates

Ready-to-use templates in `templates/` directory:

- **[plugin.json](templates/plugin.json)** - Plugin manifest
- **[marketplace.json](templates/marketplace.json)** - Local marketplace config
- **[command-template.md](templates/command-template.md)** - Slash command
- **[agent-template.md](templates/agent-template.md)** - Subagent
- **[orchestrator-command.md](templates/orchestrator-command.md)** - Multi-agent workflow
- **[mcp-config.json](templates/mcp-config.json)** - MCP server configuration
- **[hooks-template.json](templates/hooks-template.json)** - Hooks configuration

## Getting Help

- **Commands**: Read [COMMANDS.md](COMMANDS.md) for slash command patterns
- **Agents**: Read [AGENTS.md](AGENTS.md) for subagent design
- **Workflows**: Read [WORKFLOWS.md](WORKFLOWS.md) for orchestration
- **MCP**: Read [MCP.md](MCP.md) for external integrations
- **Hooks**: Read [HOOKS.md](HOOKS.md) for event automation
- **Testing**: Read [TESTING.md](TESTING.md) for debugging strategies

## Best Practices Summary

1. **Start simple**: Build minimal working version first
2. **Test incrementally**: Validate each component before adding more
3. **Document clearly**: Every command and agent needs clear description
4. **Optimize tokens**: Use file-based communication, not message passing
5. **Handle errors**: Provide fallbacks and clear error messages
6. **Be specific**: Concrete examples beat vague instructions
7. **Stay focused**: One responsibility per agent
8. **Think reusable**: Design for composition and extensibility

## Next Steps

1. **Learn commands**: Read [COMMANDS.md](COMMANDS.md) to build custom slash commands
2. **Design agents**: Read [AGENTS.md](AGENTS.md) to create specialized subagents
3. **Build workflows**: Read [WORKFLOWS.md](WORKFLOWS.md) for multi-agent orchestration
4. **Integrate tools**: Read [MCP.md](MCP.md) to connect external services
5. **Add automation**: Read [HOOKS.md](HOOKS.md) for event-driven hooks
6. **Test thoroughly**: Read [TESTING.md](TESTING.md) for debugging strategies

Start with the Quick Start above, then dive into the detailed guides as needed. Happy building!
