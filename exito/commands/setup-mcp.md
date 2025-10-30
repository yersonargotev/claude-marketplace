---
description: "Configure MCP servers (Context7, Serena) for enhanced PR reviews"
---

# MCP Server Setup - Context7 & Serena

This command configures Model Context Protocol (MCP) servers for the exito-plugin.

**Supported Platforms**: macOS, Linux, Windows

## What This Command Does

Configures environment variables for MCP servers:
- **Context7**: Up-to-date library documentation
- **Serena**: IDE assistance and project context

## Prerequisites

- GitHub CLI and Azure CLI should be installed first
- Run `/setup-cli` if you haven't already

---

## MCP Server Configuration

The plugin includes MCP server configuration in `exito-plugin/.mcp.json`:

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      },
      "description": "Access up-to-date documentation and code examples"
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
      ],
      "description": "IDE assistance and project context"
    }
  }
}
```

---

## Step 1: Configure Context7 API Key (Optional)

Context7 provides up-to-date documentation for libraries and frameworks.

**Get your API key**: https://context7.com

### macOS/Linux (bash)
```bash
# For bash users
echo 'export CONTEXT7_API_KEY="your-api-key-here"' >> ~/.bashrc
source ~/.bashrc
```

### macOS/Linux (zsh)
```bash
# For zsh users (default on macOS)
echo 'export CONTEXT7_API_KEY="your-api-key-here"' >> ~/.zshrc
source ~/.zshrc
```

### Windows (PowerShell)
```powershell
# Set environment variable permanently
[System.Environment]::SetEnvironmentVariable('CONTEXT7_API_KEY', 'your-api-key-here', [System.EnvironmentVariableTarget]::User)

# Set for current session
$env:CONTEXT7_API_KEY = "your-api-key-here"

Write-Host "✓ CONTEXT7_API_KEY set successfully" -ForegroundColor Green
```

**Replace `your-api-key-here`** with your actual API key.

---

## Step 2: Configure Serena Project Directory (Optional)

Serena provides IDE assistance and requires the project directory path.

### macOS/Linux (bash)
```bash
# For bash users
echo 'export SERENA_PROJECT_DIR="$PWD"' >> ~/.bashrc
source ~/.bashrc
```

### macOS/Linux (zsh)
```bash
# For zsh users (default on macOS)
echo 'export SERENA_PROJECT_DIR="$PWD"' >> ~/.zshrc
source ~/.zshrc
```

### Windows (PowerShell)
```powershell
# Set environment variable permanently (use current directory)
[System.Environment]::SetEnvironmentVariable('SERENA_PROJECT_DIR', $PWD.Path, [System.EnvironmentVariableTarget]::User)

# Set for current session
$env:SERENA_PROJECT_DIR = $PWD.Path

Write-Host "✓ SERENA_PROJECT_DIR set to: $($PWD.Path)" -ForegroundColor Green
```

**Note**: Adjust the path as needed for your project structure.

---

## Step 3: Verify Environment Variables (All Platforms)

Let's verify environment variables are set correctly:

### macOS/Linux
```bash
echo "=== Environment Variables ==="
echo "CONTEXT7_API_KEY: ${CONTEXT7_API_KEY:+[SET]}"
echo "SERENA_PROJECT_DIR: ${SERENA_PROJECT_DIR:-[NOT SET]}"
```

### Windows (PowerShell)
```powershell
Write-Host "=== Environment Variables ===" -ForegroundColor Cyan

if ($env:CONTEXT7_API_KEY) {
  Write-Host "CONTEXT7_API_KEY: [SET]" -ForegroundColor Green
} else {
  Write-Host "CONTEXT7_API_KEY: [NOT SET]" -ForegroundColor Yellow
}

if ($env:SERENA_PROJECT_DIR) {
  Write-Host "SERENA_PROJECT_DIR: $env:SERENA_PROJECT_DIR" -ForegroundColor Green
} else {
  Write-Host "SERENA_PROJECT_DIR: [NOT SET]" -ForegroundColor Yellow
}
```

---

## Step 4: Restart Claude Code

**IMPORTANT**: You must restart Claude Code for the MCP server changes to take effect.

### All Platforms
1. Close Claude Code completely
2. Restart Claude Code
3. The plugin will now have access to all configured MCP servers

---

## What MCP Servers Provide

### Context7 MCP Server

**Available Tools**:
- `mcp__context7__resolve-library-id`: Resolves library names to Context7 IDs
  - Example: "react" → "/facebook/react"
- `mcp__context7__get-library-docs`: Fetches up-to-date documentation
  - Supports topic filtering (e.g., "hooks", "routing")
  - Configurable token limits (default 5000)

**Use Cases**:
- Get latest API documentation for React, Next.js, etc.
- Find code examples for specific patterns
- Verify best practices for libraries

**Example Usage**:
```bash
# In a PR review, the performance-analyzer agent can:
# 1. Detect usage of next/image
# 2. Fetch latest Next.js image optimization docs
# 3. Validate implementation against current best practices
```

### Serena MCP Server

**Capabilities**:
- IDE assistance and project context
- Code navigation and understanding
- Project-specific recommendations

**Configuration**:
- Requires `SERENA_PROJECT_DIR` environment variable
- Points to your project root directory

---

## Troubleshooting

### Environment Variable Issues

#### macOS/Linux
- **Variables not persisting**:
  - Check shell type: `echo $SHELL`
  - Use correct config file (~/.zshrc for zsh, ~/.bashrc for bash)
  - Manually source config: `source ~/.zshrc` or `source ~/.bashrc`
  - Restart terminal completely

#### Windows
- **Environment variables not set**:
  - Close and reopen PowerShell after setting
  - Check variable: `$env:CONTEXT7_API_KEY`
  - Use System Properties > Environment Variables GUI as fallback
  - Ensure using User scope, not System scope

### MCP Server Issues

- **MCP servers not loading**:
  - Restart Claude Code completely
  - Check environment variables are set:
    - macOS/Linux: `echo $CONTEXT7_API_KEY`
    - Windows: `Write-Host $env:CONTEXT7_API_KEY`
  - Verify `.mcp.json` configuration in `exito-plugin/.mcp.json`
  - Check Claude Code logs for errors

- **Context7 authentication fails**:
  - Verify API key is valid: https://context7.com
  - Check for typos in environment variable name
  - Ensure no extra quotes or spaces in API key

- **Serena fails to start**:
  - Verify `SERENA_PROJECT_DIR` points to valid directory
  - Check that `uvx` is available in PATH
  - Ensure Python/uv is installed for Serena dependencies

### Getting API Keys

#### Context7
1. Visit https://context7.com
2. Sign up for free account
3. Navigate to API settings
4. Generate API key
5. Copy and set as environment variable

---

## Manual MCP Configuration (Advanced)

### Adding Additional MCP Servers

To add more MCP servers (Sentry, Linear, etc.), edit `exito-plugin/.mcp.json`:

```json
{
  "mcpServers": {
    "context7": { ... },
    "serena": { ... },
    "your-new-server": {
      "type": "http",  // or "stdio"
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${YOUR_API_KEY}"
      },
      "description": "Your server description"
    }
  }
}
```

### Environment Variable Expansion

MCP configuration supports environment variable expansion using `${VAR_NAME}` syntax:

```json
{
  "headers": {
    "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
  }
}
```

This automatically substitutes the value from your environment when Claude Code starts.

---

## Verifying MCP Integration

After restarting Claude Code, verify MCP servers are working:

### Test Context7
```bash
# In Claude Code, try fetching docs for a library
# The plugin agents will automatically use Context7 when needed
```

### Check MCP Server Status
- Look for MCP server indicators in Claude Code UI
- Check if Context7 tools appear in available tools
- Verify Serena tools are accessible

---

## Setup Complete!

After configuring MCP servers and restarting Claude Code, you can use all plugin features:

- `/review <PR_NUMBER> [HU_URL_1] [HU_URL_2]...` - Comprehensive PR review
- `/review-perf <PR_NUMBER>` - Performance-focused review
- `/review-sec <PR_NUMBER>` - Security-focused review

The MCP servers will provide:
- Up-to-date library documentation (Context7)
- Project-specific context (Serena)
- Enhanced code analysis capabilities

---

## Need Help?

If you encounter issues:

1. **Check environment variables** are set correctly
2. **Restart Claude Code** completely
3. **Verify API keys** are valid
4. **Check Claude Code logs** for MCP server errors
5. **Review `.mcp.json`** configuration syntax

### Useful Resources

- **Context7 API**: https://context7.com/docs
- **Serena Documentation**: https://github.com/oraios/serena
- **Claude Code MCP Guide**: https://docs.claude.com/claude-code/mcp
- **Plugin Repository**: https://github.com/yargotev/claude-exito-plugin

---

## Quick Reference

### Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `CONTEXT7_API_KEY` | Context7 API key for docs | Optional |
| `SERENA_PROJECT_DIR` | Project directory for Serena | Optional |

### Setting Environment Variables

| Platform | Command |
|----------|---------|
| macOS/Linux (bash) | `export VAR="value"` in `~/.bashrc` |
| macOS/Linux (zsh) | `export VAR="value"` in `~/.zshrc` |
| Windows | `$env:VAR="value"` (PowerShell) |

### MCP Configuration File

Location: `exito-plugin/.mcp.json`

**After any changes**:
1. Save the file
2. Restart Claude Code
3. Verify servers load correctly
