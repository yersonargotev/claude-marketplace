---
description: "Complete setup guide for exito-plugin (CLIs and MCP servers)"
---

# Exito Plugin Setup Guide

Welcome to the exito-plugin setup! This guide will help you configure all dependencies for comprehensive PR reviews.

**Supported Platforms**: macOS, Linux (Ubuntu/Debian), Windows

---

## Setup Overview

The plugin requires two types of configuration:

1. **Command-Line Tools (CLIs)** - GitHub CLI and Azure CLI for PR analysis
2. **MCP Servers** - Context7 and Serena for enhanced code intelligence

---

## Quick Start

### Step 1: Install and Configure CLIs

Install GitHub CLI and Azure CLI, then authenticate:

```bash
/setup-cli
```

This will:
- Install `gh` (GitHub CLI)
- Install `az` (Azure CLI)
- Configure authentication for both

**Estimated time**: 5-10 minutes

---

### Step 2: Configure MCP Servers (Optional)

Configure Context7 and Serena MCP servers for enhanced reviews:

```bash
/setup-mcp
```

This will:
- Set up Context7 API key (up-to-date library docs)
- Configure Serena project directory (IDE assistance)

**Estimated time**: 2-5 minutes

**Note**: MCP servers are optional but highly recommended for best results.

---

## What Each Command Does

### `/setup-cli` - CLI Installation & Authentication

**Installs**:
- Package manager (Homebrew/apt/winget)
- GitHub CLI (`gh`)
- Azure CLI (`az`)

**Configures**:
- GitHub authentication (for PR access)
- Azure authentication (for Azure DevOps integration)

**Required for**:
- All PR review commands (`/review`, `/review-perf`, `/review-sec`)
- Business validation against Azure DevOps User Stories

---

### `/setup-mcp` - MCP Server Configuration

**Configures**:
- **Context7**: Up-to-date documentation for libraries/frameworks
- **Serena**: IDE assistance and project-specific context

**Provides**:
- Latest API docs for React, Next.js, etc.
- Code examples and best practices
- Enhanced analysis capabilities

**Optional but recommended for**:
- Performance analysis with latest library docs
- Architecture reviews with framework-specific guidance
- Keeping recommendations current with library updates

---

## Prerequisites

- **macOS**: Admin access for installing dependencies
- **Linux**: sudo access (Ubuntu/Debian-based distributions)
- **Windows**: PowerShell 5.1+ or PowerShell 7+ with admin privileges

---

## Verification

After running both setup commands, verify everything is configured:

### Check CLIs

**macOS/Linux**:
```bash
gh auth status
az account show
```

**Windows**:
```powershell
gh auth status
az account show
```

### Check Environment Variables

**macOS/Linux**:
```bash
echo "CONTEXT7_API_KEY: ${CONTEXT7_API_KEY:+[SET]}"
echo "SERENA_PROJECT_DIR: ${SERENA_PROJECT_DIR:-[NOT SET]}"
```

**Windows**:
```powershell
Write-Host "CONTEXT7_API_KEY: $(if ($env:CONTEXT7_API_KEY) { '[SET]' } else { '[NOT SET]' })"
Write-Host "SERENA_PROJECT_DIR: $(if ($env:SERENA_PROJECT_DIR) { $env:SERENA_PROJECT_DIR } else { '[NOT SET]' })"
```

---

## Setup Complete!

Once configured, you can use all plugin commands:

### PR Review Commands

```bash
# Comprehensive review with all analysis dimensions
/review <PR_NUMBER> [AZURE_DEVOPS_URL_1] [AZURE_DEVOPS_URL_2]...

# Performance-focused review
/review-perf <PR_NUMBER>

# Security-focused review
/review-sec <PR_NUMBER>
```

### Example Usage

```bash
# Review PR #123
/review 123

# Review PR #456 with business validation
/review 456 https://dev.azure.com/grupo-exito/proyecto/_workitems/edit/789

# Performance review of PR #789
/review-perf 789

# Security review of PR #101
/review-sec 101
```

---

## Troubleshooting

### CLI Setup Issues

If `/setup-cli` encounters problems:

- **macOS**: Ensure you have admin access and internet connection
- **Linux**: Verify sudo access and run `sudo apt-get update`
- **Windows**: Run PowerShell as Administrator

See `/setup-cli` for detailed troubleshooting.

### MCP Setup Issues

If MCP servers don't load:

- Verify environment variables are set correctly
- Restart Claude Code completely
- Check API keys are valid
- Review `.mcp.json` configuration in `exito-plugin/.mcp.json`

See `/setup-mcp` for detailed troubleshooting.

---

## Manual Setup (Advanced)

If you prefer manual configuration:

### Install CLIs Manually

**macOS**:
```bash
brew install gh azure-cli
gh auth login
az login --allow-no-subscriptions
```

**Linux**:
```bash
# See /setup-cli for full installation commands
sudo apt-get install gh azure-cli
gh auth login
az login --allow-no-subscriptions
```

**Windows**:
```powershell
winget install GitHub.cli
winget install Microsoft.AzureCLI
gh auth login
az login --allow-no-subscriptions
```

### Configure MCP Servers Manually

**Set Environment Variables**:

```bash
# macOS/Linux (zsh)
echo 'export CONTEXT7_API_KEY="your-key"' >> ~/.zshrc
echo 'export SERENA_PROJECT_DIR="$PWD"' >> ~/.zshrc
source ~/.zshrc

# Windows (PowerShell)
[System.Environment]::SetEnvironmentVariable('CONTEXT7_API_KEY', 'your-key', [System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('SERENA_PROJECT_DIR', $PWD.Path, [System.EnvironmentVariableTarget]::User)
```

---

## Getting Help

### Documentation

- **CLI Setup**: Run `/setup-cli` or see [GitHub CLI Docs](https://cli.github.com/manual/)
- **MCP Setup**: Run `/setup-mcp` or see [Claude Code MCP Guide](https://docs.claude.com/claude-code/mcp)
- **Plugin Docs**: [GitHub Repository](https://github.com/yargotev/claude-exito-plugin)

### Resources

- **GitHub CLI**: https://cli.github.com/manual/
- **Azure CLI**: https://learn.microsoft.com/en-us/cli/azure/
- **Context7 API**: https://context7.com/docs
- **Claude Code**: https://docs.claude.com/claude-code

---

## Quick Reference

### Setup Commands

| Command | Purpose | Time | Required |
|---------|---------|------|----------|
| `/setup-cli` | Install and configure GitHub CLI & Azure CLI | 5-10 min | ✅ Yes |
| `/setup-mcp` | Configure MCP servers (Context7, Serena) | 2-5 min | ⭐ Recommended |

### Platform Support

| Platform | CLIs | MCP Servers |
|----------|------|-------------|
| macOS | ✅ Supported | ✅ Supported |
| Linux (Ubuntu/Debian) | ✅ Supported | ✅ Supported |
| Windows 10/11 | ✅ Supported | ✅ Supported |

### After Setup

1. **Restart Claude Code** (required for MCP servers)
2. **Verify authentication**: `gh auth status` and `az account show`
3. **Test a review**: `/review <PR_NUMBER>`

---

## Next Steps

After completing setup:

1. **Test the plugin** with a real PR: `/review <PR_NUMBER>`
2. **Explore specialized reviews**: `/review-perf` and `/review-sec`
3. **Configure Azure DevOps URLs** for business validation
4. **Join the community** and share feedback

Happy reviewing! 🚀
