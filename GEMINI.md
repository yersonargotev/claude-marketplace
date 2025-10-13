# Project Overview

This is a **Claude Code plugin** that provides comprehensive PR review commands for FastStore/VTEX e-commerce development at Exito. The plugin is distributed via marketplace and uses an advanced multi-agent orchestration pattern with persistent context management.

The primary goal is to provide a powerful, modular, and efficient automated PR review process that:

- Adapts intelligently to PR size and complexity
- Integrates business context from Azure DevOps
- Enforces development best practices across multiple dimensions
- Optimizes token efficiency through context persistence (67% reduction)

**Main Technologies:**

- **Claude:** Powers specialized sub-agents for multi-dimensional code analysis
- **GitHub CLI (`gh`):** Extracts PR data, diffs, and metadata
- **Azure DevOps MCP Tools:** Integrates business context from User Stories
- **Context7 MCP Server:** Provides up-to-date documentation for any library/framework
- **Markdown:** Defines commands and agent logic
- **Claude Agent SDK:** Manages agent orchestration and parallel execution

**Architecture:**

The plugin implements an **advanced multi-agent orchestration pattern** with persistent context management:

1.  **Context Gathering:** Extracts PR metadata, diffs, and classifies PR size
2.  **Business Validation** (optional): Integrates with Azure DevOps to validate against User Stories
3.  **Parallel Analysis:** Six specialized agents analyze performance, architecture, code quality, security, testing, and accessibility simultaneously
4.  **Synthesis:** Combines all findings into a unified comprehensive review
5.  **Persistent Storage:** All context and reports saved to `.claude/sessions/pr_reviews/` for reusability and audit trail

Key components:

- **Commands:** `/review`, `/review-perf`, `/review-sec` for different review scopes
- **Agents:** 8 specialized sub-agents for focused analysis
- **MCP Servers:** Context7 for documentation, Azure DevOps for business alignment
- **Context Persistence:** Dramatically reduces token usage by sharing context via files instead of messages

# Building and Running

This is a Claude Code plugin distributed via marketplace. Installation and usage are straightforward:

**Prerequisites:**

- **Claude Desktop:** Installed from `https://claude.ai/download`
- **GitHub CLI:** Automatically installed via `/setup` command
- **Azure CLI:** Automatically installed via `/setup` command

**Installation:**

```bash
# Add the marketplace
/plugin marketplace add yargotev/claude-exito-plugin

# Install the plugin
/plugin install exito@yargotev-marketplace

# Setup dependencies (GitHub CLI, Azure CLI)
/setup
```

**Using the Commands:**

```bash
# Comprehensive PR review
/review <PR_NUMBER>

# With Azure DevOps context
/review <PR_NUMBER> https://dev.azure.com/grupo-exito/GCIT-Agile/_workitems/edit/12345

# Performance-focused review
/review-perf <PR_NUMBER>

# Security-focused review
/review-sec <PR_NUMBER>
```

**Optional: Setup Context7 MCP Server**

```bash
# Get your API key from https://context7.com
export CONTEXT7_API_KEY="your-api-key"

# Restart Claude Code to load the MCP server
```

# Development Conventions

- **Plugin Structure:** Commands in `commands/`, agents in `agents/`, MCP config in `.mcp.json`
- **Agent Pattern:** Each agent has YAML frontmatter with tools, model, and clear role definitions
- **Context Persistence:** Agents share context via files (`.claude/sessions/pr_reviews/`), not messages
- **Parallel Execution:** Independent agents run concurrently for maximum efficiency
- **Tool Selectivity:** Each agent only has access to tools it needs (principle of least privilege)
- **Versioning:** See `CLAUDE.md` and `README.md` for detailed versioning and architecture notes
