# Project Overview

This project is a Claude Code plugin specifically designed for the Exito e-commerce platform, which uses the FastStore/VTEX technology stack. The plugin provides a suite of commands for comprehensive Pull Request (PR) reviews, with specialized sub-agents that analyze different aspects of the code.

## Main Purpose

The primary goal of this plugin is to automate and standardize the technical review process for PRs in the Exito FastStore/VTEX e-commerce platform. It offers multi-dimensional analysis through specialized agents that focus on different aspects such as performance, security, code quality, architecture, testing, and accessibility.

## Key Technologies

- **Claude Code**: AI assistant platform for code analysis
- **GitHub CLI (`gh`)**: Used to extract PR data, diffs, and other information from GitHub
- **Azure DevOps**: Integration for pulling business context from user stories (optional)
- **Markdown**: Used for defining commands, agents, and documentation

## Architecture

The plugin follows an advanced multi-agent orchestration pattern with persistent context management:

```
exito-plugin/
├── commands/          # User-facing slash commands
│   ├── review.md      # Main orchestrator command
│   ├── review-perf.md # Performance-focused review
│   ├── review-sec.md  # Security-focused review
│   └── setup.md       # Dependency installer
├── agents/            # Specialized sub-agents
│   ├── 1-context-gatherer.md      # PR metadata & diff collection
│   ├── 2-business-validator.md    # Azure DevOps integration
│   ├── 3-performance-analyzer.md  # React/Next.js performance
│   ├── 4-architecture-reviewer.md # Design patterns & structure
│   ├── 5-clean-code-auditor.md   # Code quality & style
│   ├── 6-security-scanner.md     # Security vulnerabilities
│   ├── 7-testing-assessor.md     # Test coverage & quality
│   └── 8-accessibility-checker.md # WCAG compliance
└── scripts/
    └── install-deps.sh            # Homebrew installer script
```

## Available Commands

1. **`/review`** - Comprehensive PR Review: Performs a holistic technical review of a Pull Request, adapting its strategy based on the PR's size and complexity. It can integrate with Azure DevOps to incorporate business context from user stories.

2. **`/review-perf`** - Performance-Focused Review: Conducts a deep-dive analysis on performance aspects of the code, focusing on potential bottlenecks, inefficient patterns, and adherence to performance best practices.

3. **`/review-sec`** - Security-Focused Review: Scans the code for common security vulnerabilities, insecure patterns, and potential risks.

# Building and Running

This is a Claude Code plugin project, not a traditional software project with build processes. The "building" involves configuring Claude Desktop to recognize the commands, and "running" means using the commands within Claude.

## Prerequisites

1. **Claude Desktop**: The environment where these commands run
   - Install from: https://claude.ai/download

2. **GitHub CLI**: Required for all commands to extract PR information
   - Install with: `brew install gh`

3. **Azure CLI** (optional): For Azure DevOps integration with the `/review` command
   - Install with: `brew install azure-cli`

## Installation & Setup

### Automatic Setup
After installing the plugin, run the setup command inside Claude:
```bash
/setup
```
This command will check for the required tools and install them using Homebrew if they are missing.

### Manual Setup
If you prefer to install dependencies manually:
```bash
brew install gh
brew install azure-cli  # Optional, for Azure DevOps integration
```

### Plugin Installation
1. Add the marketplace:
   ```bash
   /plugin marketplace add yargotev/claude-exito-plugin
   ```

2. Install the plugin:
   ```bash
   /plugin install exito@yargotev-marketplace
   ```

3. Restart Claude Desktop to enable the new commands.

## Using the Commands

### `/review` - Comprehensive PR Review
```bash
# Basic usage for a PR
/review 1695

# For a PR with related User Story context from Azure DevOps
/review 1695 https://dev.azure.com/grupo-exito/GCIT-Agile/_workitems/edit/544232
```

### `/review-perf` - Performance-Focused Review
```bash
/review-perf 1695
```

### `/review-sec` - Security-Focused Review
```bash
/review-sec 1695
```

## Environment Variables

For Azure DevOps integration with the `/review` command:
```bash
export AZURE_DEVOPS_ORG_URL="https://dev.azure.com/grupo-exito"
export AZURE_DEVOPS_PAT="your-personal-access-token"
```

> **Security note**: Treat your Personal Access Token (PAT) as a secret. Do not commit it to source control, paste it into public chats, or include it in logs. Store secrets in a secure secrets manager and rotate them periodically.

# Development Conventions

## Command Definition
Commands are defined as Markdown files in the `exito-plugin/commands/` directory with YAML frontmatter specifying:
- Description
- Argument hints
- Other metadata

## Agent Specialization
Each agent in `exito-plugin/agents/` has a specific focus area:
- **Context Gatherer**: Collects PR metadata, classifies size, and establishes review strategy
- **Business Validator**: Integrates with Azure DevOps to validate PR against user stories
- **Performance Analyzer**: Focuses on React/Next.js performance patterns
- **Architecture Reviewer**: Checks design patterns and structural concerns
- **Clean Code Auditor**: Reviews code quality, readability, and style
- **Security Scanner**: Identifies security vulnerabilities and risks
- **Testing Assessor**: Evaluates test coverage and quality
- **Accessibility Checker**: Ensures WCAG compliance

## File Organization
- **Commands**: User-facing slash commands in `exito-plugin/commands/`
- **Agents**: Specialized sub-agents in `exito-plugin/agents/`
- **Documentation**: Supporting documentation in `docs/`
- **Scripts**: Installation scripts in `exito-plugin/scripts/`

## Best Practices for Agent Design

### Context Management
- Use file-based communication between agents for efficiency
- Persist findings to disk immediately rather than returning full reports in responses
- Return concise summaries (< 200 words) from agents to the orchestrator

### System Prompt Engineering
- Structure prompts with clear XML tags or Markdown headers
- Include concrete examples of good vs bad patterns
- Provide scoring rubrics with clear criteria

### Tool Design
- Grant agents only the tools essential for their specific task
- Restrict Bash access to specific patterns when possible

### Error Handling
- Implement graceful degradation strategies
- Provide clear error messages with remediation steps
- Handle edge cases like missing files or invalid inputs

### Output Quality
Every finding should include:
1. File path and line number
2. Clear description of the issue
3. Impact explanation
4. Code example with before/after fix
5. Priority level (Critical/High/Medium/Low)

## Development Workflow

### Testing Commands Locally
1. Restart Claude Desktop to reload plugin changes
2. Test the command on a real PR:
   ```bash
   /review <PR_NUMBER>
   ```

### Adding a New Agent
1. Create a new file in `exito-plugin/agents/` with naming convention `<number>-<name>.md`
2. Follow the YAML frontmatter pattern:
   ```yaml
   ---
   name: agent-name
   description: "What this agent does"
   tools: Bash(gh:*), Read, Write
   model: claude-sonnet-4-5-20250929
   ---
   ```
3. Update the orchestrator in `exito-plugin/commands/review.md` to invoke your new agent
4. Document the agent's output format in its markdown file

### Adding a New Command
1. Create a new file in `exito-plugin/commands/` like `review-<focus>.md`
2. Add YAML frontmatter with description and argument hints
3. Define the command logic using markdown and agent invocations
4. Update `README.md` to document the new command

## Plugin Distribution

The plugin is distributed via the marketplace `yargotev/claude-exito-plugin` and installed as `exito@yargotev-marketplace`. Changes to the plugin require:

1. Committing changes to the repository
2. Users pulling the latest version via `/plugin update exito@yargotev-marketplace`

## Important Constraints

- All agents use `model: claude-sonnet-4-5-20250929`
- Agents can only use tools specified in their frontmatter `tools:` field
- The plugin assumes macOS environment (uses Homebrew for dependency installation)
- GitHub CLI must be authenticated before using any review commands