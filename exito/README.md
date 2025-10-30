# Exito Plugin for Claude Code

Comprehensive PR review plugin for FastStore/VTEX e-commerce development at Exito.

## Features

- 🔍 **Comprehensive PR Reviews** - Multi-dimensional code analysis with specialized agents
- 🚀 **Performance Analysis** - React/Next.js optimization detection
- 🔒 **Security Scanning** - Vulnerability detection and best practices
- ♿ **Accessibility Checks** - WCAG compliance validation
- 🏗️ **Architecture Review** - Design patterns and code structure analysis
- 🧪 **Testing Assessment** - Coverage and quality evaluation
- 📊 **Business Validation** - Azure DevOps User Story alignment (optional)

## Installation

### 1. Install the Plugin

```bash
/plugin marketplace add yargotev/claude-exito-plugin
/plugin install exito@yargotev-marketplace
```

### 2. Configure Environment Variables (Optional)

The plugin uses MCP servers that require environment variables:

#### Context7 (Optional - for library documentation)

Get your API key from [https://context7.com](https://context7.com), then add to your shell config:

```bash
# For zsh (default on macOS)
echo 'export CONTEXT7_API_KEY="your-api-key-here"' >> ~/.zshrc
source ~/.zshrc

# For bash
echo 'export CONTEXT7_API_KEY="your-api-key-here"' >> ~/.bashrc
source ~/.bashrc
```

#### Serena (Optional - for IDE assistance)

Set your project directory:

```bash
# For zsh (default on macOS)
echo 'export SERENA_PROJECT_DIR="$HOME/your-project-path"' >> ~/.zshrc
source ~/.zshrc

# For bash
echo 'export SERENA_PROJECT_DIR="$HOME/your-project-path"' >> ~/.bashrc
source ~/.bashrc
```

**Alternative**: Use the `/setup` command for guided configuration:

```bash
/setup
```

### 3. Install Dependencies

The plugin requires GitHub CLI and Azure CLI (for business validation):

```bash
/setup
```

This will install:
- `gh` (GitHub CLI) - for PR data extraction
- `az` (Azure CLI) - for Azure DevOps integration (optional)

### 4. Authenticate with GitHub

```bash
gh auth login
```

### 5. Authenticate with Azure DevOps (Optional)

For business validation features:

```bash
az login --allow-no-subscriptions
export AZURE_DEVOPS_ORG_URL="https://dev.azure.com/grupo-exito"
export AZURE_DEVOPS_PAT="your-personal-access-token"
```

### 6. Restart Claude Code

**IMPORTANT**: Restart Claude Code to load the MCP servers.

## Usage

### Basic PR Review

```bash
/review <PR_NUMBER>
```

### PR Review with Business Validation

```bash
/review <PR_NUMBER> <AZURE_DEVOPS_WORK_ITEM_URL>
```

Example:
```bash
/review 123 https://dev.azure.com/grupo-exito/_workitems/edit/45678
```

### Performance-Focused Review

```bash
/review-perf <PR_NUMBER>
```

### Security-Focused Review

```bash
/review-sec <PR_NUMBER>
```

## Review Output

Reviews are saved to `.claude/sessions/pr_reviews/`:

- `pr_{number}_context.md` - PR metadata and context
- `pr_{number}_{agent}_report.md` - Individual agent reports
- `pr_{number}_final_review.md` - Comprehensive final review

## Architecture

The plugin uses an **agent-based architecture** with specialized reviewers:

1. **Context Gatherer** - Extracts PR metadata and diffs
2. **Business Validator** - Validates against User Stories (optional)
3. **Performance Analyzer** - React/Next.js optimization
4. **Architecture Reviewer** - Design patterns and structure
5. **Clean Code Auditor** - Code quality and style
6. **Security Scanner** - Vulnerability detection
7. **Testing Assessor** - Test coverage and quality
8. **Accessibility Checker** - WCAG compliance

All agents run **in parallel** for maximum efficiency, with results persisted to disk for token optimization.

## Configuration

### MCP Servers

The plugin includes pre-configured MCP servers in `.mcp.json`:

- **Context7**: Up-to-date library documentation
- **Serena**: IDE assistance and project context

To enable these servers, set the required environment variables (see Installation step 2).

### Customization

You can customize agent behavior by editing files in `exito-plugin/agents/`.

## Troubleshooting

### MCP Servers Not Loading

1. Verify environment variables are set: `echo $CONTEXT7_API_KEY`
2. Restart Claude Code
3. Check `.mcp.json` syntax is valid

### GitHub CLI Errors

```bash
# Re-authenticate
gh auth login

# Verify authentication
gh auth status
```

### Azure DevOps Connection Issues

```bash
# Re-authenticate
az login --allow-no-subscriptions

# Verify access
az account show
```

### Plugin Not Found

```bash
# Update marketplace
/plugin marketplace update

# Reinstall plugin
/plugin install exito@yargotev-marketplace
```

## Contributing

See [CLAUDE.md](../CLAUDE.md) for development guidelines and architecture details.

## License

MIT
