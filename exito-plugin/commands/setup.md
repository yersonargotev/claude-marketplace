---
description: "Configure environment variables for exito-plugin MCP servers"
---

# Exito Plugin Setup

This command helps you configure the required environment variables for the plugin's MCP servers.

## Required Configuration

### 1. Context7 API Key (Optional)
Context7 provides up-to-date documentation for libraries and frameworks.

**Get your API key**: https://context7.com

### 2. Serena Project Directory (Optional)
Serena requires the project directory path for IDE assistance.

## Setup Instructions

I'll guide you through setting up the environment variables:

### Step 1: Context7 API Key

Run the following command to add the Context7 API key to your shell configuration:

```bash
# For zsh users (default on macOS)
echo 'export CONTEXT7_API_KEY="your-api-key-here"' >> ~/.zshrc

# For bash users
echo 'export CONTEXT7_API_KEY="your-api-key-here"' >> ~/.bashrc
```

**Replace `your-api-key-here`** with your actual API key from https://context7.com

### Step 2: Serena Project Directory

For Serena to work, set the project directory environment variable:

```bash
# For zsh users (default on macOS)
echo 'export SERENA_PROJECT_DIR="$PWD"' >> ~/.zshrc

# For bash users
echo 'export SERENA_PROJECT_DIR="$PWD"' >> ~/.bashrc
```

This will set the project directory to your current working directory. Adjust the path as needed.

### Step 3: Apply Changes

Reload your shell configuration:

```bash
# For zsh
source ~/.zshrc

# For bash
source ~/.bashrc
```

### Step 4: Verify Configuration

Check that the variables are set:

```bash
echo $CONTEXT7_API_KEY
echo $SERENA_PROJECT_DIR
```

### Step 5: Restart Claude Code

**IMPORTANT**: You must restart Claude Code for the MCP server changes to take effect.

## Troubleshooting

- **Variables not persisting**: Make sure you added them to the correct shell config file
- **MCP servers not loading**: Check that you restarted Claude Code after setting variables
- **Permission errors**: Ensure the project directory path is accessible

## Manual Configuration

If you prefer to configure manually, edit your `.mcp.json`:

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    },
    "serena": {
      "type": "stdio",
      "command": "uvx",
      "args": [
        "--from",
        "git+https://github.com/oraios/serena",
        "serena",
        "start-mcp-server",
        "--context",
        "ide-assistant",
        "--project",
        "${SERENA_PROJECT_DIR}"
      ]
    }
  }
}
```

## Next Steps

After configuration, you can use all plugin features:
- `/review <PR_NUMBER>` - Comprehensive PR review
- `/review-perf <PR_NUMBER>` - Performance-focused review
- `/review-sec <PR_NUMBER>` - Security-focused review
