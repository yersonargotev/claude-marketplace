# Claude Commands for Exito Store

Welcome! This repository contains a **complete Claude Code plugin** with custom commands designed to streamline and enhance the development workflow for the FastStore/VTEX e-commerce platform at Exito.

🚀 **Status**: Beta v0.9 | 🔧 **Branch**: `dev` | ⭐ **Grade**: 8.5/10 | 📅 **Updated**: Oct 18, 2025

## Installation

This project is distributed as a Claude Code plugin. Follow these steps to install it:

1.  **Add the Marketplace**:
    This command registers the repository as a source for plugins.

    ```shell
    /plugin marketplace add yargotev/claude-marketplace
    ```

2.  **Install the Plugin**:
    Install the `review` plugin from the marketplace you just added.

    ```shell
    /plugin install exito@yargotev-marketplace
    ```

After installation, restart Claude Code to enable the new commands.

## Available Commands

This plugin provides two main categories of commands:

### Code Review Commands

The `review` plugin provides a suite of commands for comprehensive PR analysis:

#### `/review` - Comprehensive PR Review

**Purpose**: Performs a holistic technical review of a Pull Request, adapting its strategy based on the PR's size and complexity. It can integrate with Azure DevOps to incorporate business context from user stories.

**Quick Start**:

```bash
# Basic usage for a PR
/review 1695

# For a PR with related User Story context from Azure DevOps
/review 1695 https://dev.azure.com/grupo-exito/GCIT-Agile/_workitems/edit/544232
```

#### `/review-perf` - Performance-Focused Review

**Purpose**: Conducts a deep-dive analysis on performance aspects of the code, focusing on potential bottlenecks, inefficient patterns, and adherence to performance best practices.

**Quick Start**:

```bash
/review-perf 1695
```

#### `/review-sec` - Security-Focused Review

**Purpose**: Scans the code for common security vulnerabilities, insecure patterns, and potential risks.

**Quick Start**:

```bash
/review-sec 1695
```

### Senior Engineer Commands

AI-powered engineering assistants that investigate, plan, implement, and validate features following a professional workflow:

#### `/build` - Full Feature Builder

**Purpose**: Your default command for building complete features and making significant changes. Follows a complete workflow: research → plan → **YOUR APPROVAL** → implement → test → review.

**When to use**: Medium to complex features, multi-file changes, when you want thorough planning.

**Quick Start**:

```bash
/build Add user authentication with JWT tokens

/build Implement caching layer for API responses

/build Add pagination to the products list endpoint
```

**Time**: 5-20 minutes | **Approval Required**: YES

#### `/think` - Deep Architectural Thinking

**Purpose**: Maximum analysis variant of `/build` for critical work. Uses ULTRATHINK mode for deep exploration at every stage.

**When to use**: Critical architectural decisions, security-sensitive features, performance optimizations, core system refactoring.

**Quick Start**:

```bash
/think Design a real-time notification system architecture

/think Optimize database queries for the dashboard (1M+ records)

/think Refactor authentication system to support OAuth2 and SAML
```

**Time**: 10-30 minutes | **Approval Required**: YES

#### `/ui` - Frontend/UI Specialist

**Purpose**: React/UI/UX specialist with focus on accessibility, responsive design, and performance.

**When to use**: Building components, UI implementation, accessibility work, responsive design.

**Quick Start**:

```bash
/ui Create an accessible date picker component

/ui Build a responsive navigation menu with mobile hamburger

/ui Implement dark mode theme switching
```

**Time**: 5-20 minutes | **Approval Required**: YES

#### `/patch` - Quick Fixes

**Purpose**: Simplified workflow for simple bugs and small changes. No approval gate - proceeds automatically.

**When to use**: Bug fixes, typos, style adjustments, config changes, dependency updates.

**Quick Start**:

```bash
/patch Fix the typo in the error message on line 45

/patch Update button color to match design system

/patch Bump lodash to latest version
```

**Time**: 1-5 minutes | **Approval Required**: NO

> 📖 **Detailed Guide**: See [`docs/senior-commands-guide.md`](docs/senior-commands-guide.md) for comprehensive usage instructions, decision trees, best practices, and examples.

---

## PR Size Handling Strategy

The `/review` command intelligently adapts to PR size:

| Size          | Lines Changed | Strategy                          | Review Time |
| ------------- | ------------- | --------------------------------- | ----------- |
| 🟢 Small      | < 200         | Complete detailed review          | 15-30 min   |
| 🟡 Medium     | 200-500       | Detailed review with focus        | 30-60 min   |
| 🟠 Large      | 500-1000      | Prioritized + sampling            | 1-2 hours   |
| 🔴 Very Large | > 1000        | Risk-based + split recommendation | 2-4 hours   |

---

## Development Workflow

### When to Use These Commands

**Use `/review`, `/review-perf`, or `/review-sec` when**:

- ✅ PR has passed all CI/CD checks (tests, lint, build).
- ✅ PR description is complete and clear.
- ✅ User Stories are linked (if applicable for `/review`).
- ✅ The author has already self-reviewed the changes.

**Don't use them if**:

- ❌ CI/CD checks are failing.
- ❌ The PR is still in a draft state.
- ❌ There are merge conflicts.

### Recommended Workflow

1.  Author creates a PR.
2.  Automated checks run and pass ✅.
3.  Reviewer runs `/review <PR_NUMBER> [HU_URL]` for a holistic review, or a specialized command like `/review-perf` or `/review-sec`.
4.  The AI provides a comprehensive analysis.
5.  The reviewer validates the AI's findings and provides feedback on GitHub.
6.  The author addresses the feedback.
7.  Repeat as needed, then merge!

---

## Prerequisites

1.  **Claude Desktop**: The environment where these commands run.

    - Install from: https://claude.ai/download

2.  **Required Tools (GitHub CLI & Azure CLI)**: The `review` plugin requires `gh` and `az` to function. After installing the plugin, run the following command inside Claude to automatically install these tools:
    ```bash
    /setup
    ```
    This command will check for the tools and install them using Homebrew if they are missing. It will also guide you to log in if necessary. If you prefer to install them manually, you can use `brew install gh` and `brew install azure-cli`.

---

## Environment Variables

### Azure DevOps Integration

For Azure DevOps integration with the `/review` command:

```bash
export AZURE_DEVOPS_ORG_URL="https://dev.azure.com/grupo-exito"
export AZURE_DEVOPS_PAT="your-personal-access-token"
```

### Context7 MCP Server (Optional)

This plugin includes integration with **Context7**, an MCP server providing up-to-date documentation for any library or framework. To enable it:

1. Get your API key from [https://context7.com](https://context7.com)
2. Set the environment variable:

```bash
export CONTEXT7_API_KEY="your-api-key-here"
```

3. Make it persistent in your shell configuration:

**For bash/zsh (~/.bashrc or ~/.zshrc):**

```bash
echo 'export CONTEXT7_API_KEY="your-key"' >> ~/.zshrc
source ~/.zshrc
```

**For fish (~/.config/fish/config.fish):**

```fish
set -Ux CONTEXT7_API_KEY "your-key"
```

4. Restart Claude Code to load the MCP server

**What Context7 provides:**

- Up-to-date documentation for React, Next.js, FastStore, and any library
- Code examples and best practices
- Library-specific optimization patterns
- Automatic availability via MCP tools:
  - `mcp__context7__resolve-library-id` - Find library IDs
  - `mcp__context7__get-library-docs` - Fetch documentation with topic filtering

> **Security note:** Treat your Personal Access Token (PAT) and API keys as secrets. Do not commit them to source control, paste them into public chats, or include them in logs. Store secrets in a secure secrets manager (CI/CD secrets, environment vault, etc.) and rotate them periodically.

---

## 📊 Project Status & Roadmap

### Current Status: Beta (v0.9) - Active Development

**Overall Grade**: 8.5/10 | **Branch**: `dev` | **Last Updated**: October 18, 2025

The Claude Marketplace plugin system is **actively in development** with core functionality in place:

#### ✅ Completed Features

- ✅ 7 slash commands fully implemented (/build, /think, /ui, /patch, /review, /review-perf, /review-sec)
- ✅ 13 specialized agents (investigator, architect, builder, validator, auditor + 8 QA agents)
- ✅ Comprehensive documentation (1000+ lines across multiple guides)
- ✅ Session-based artifact generation system
- ✅ Approval gate workflow
- ✅ Plugin architecture with hook system
- ✅ Context7 MCP Server integration

#### � In Progress

- 🟡 Plugin validation and testing across multiple Claude versions
- 🟡 Session management refinement
- 🟡 Hook system stability improvements

#### 📋 Known Limitations

- Session ID generation needs enhancement
- Directory validation logic needs review
- Cleanup handlers require testing across edge cases

### 🔬 Strategic Assessment

A comprehensive strategic audit has identified key improvement areas. **Full documentation available:**

**Quick Links**:

- 📊 [Executive Summary](./EXECUTIVE_SUMMARY.md) - Overview of current state and recommendations
- 🔬 [Strategic Audit](./STRATEGIC_AUDIT_AND_IMPROVEMENTS.md) - Detailed 15-point improvement plan
- 🗺️ [Implementation Roadmap](./IMPLEMENTATION_ROADMAP.md) - Technical implementation guide
- ⚡ [Quick Wins](./QUICK_WINS.md) - High-impact improvements (estimated 1.5 days)

### 🎯 Development Roadmap

#### Phase 1: Stabilization (Current - 1 week)

- 🔴 **Session ID generation** - Robust UUID/timestamp system
- 🔴 **Directory validation** - Error handling and fallbacks
- 🔴 **Cleanup handlers** - Session persistence and recovery
- **Target**: 9.0/10 | **Priority**: CRITICAL

#### Phase 2: Enhancement (Week 2-3)

- 🟡 **Complexity detection** - Auto-adjust thinking budget
- 🟡 **Enhanced approval flow** - Multi-step validation
- 🟡 **Quality gates** - Pre-execution checks
- 🟡 **Performance optimization** - 2x faster quick-fix execution
- **Target**: 9.5/10 | **Priority**: HIGH

#### Phase 3: Innovation (Week 4-6)

- 🟢 **Predictive approval** - ML-based user preference learning
- 🟢 **Auto-scaling thinking** - Dynamic budget allocation
- 🟢 **Snippet library** - Context-aware code patterns
- 🟢 **Plan versioning** - A/B testing capabilities
- **Target**: Industry-leading | **Priority**: MEDIUM

### 📈 Current Metrics

| Metric                   | Status          | Target |
| ------------------------ | --------------- | ------ |
| Command availability     | ✅ 7/7 (100%)   | 7/7    |
| Agent functionality      | ✅ 13/13 (100%) | 13/13  |
| Documentation coverage   | ✅ ~95%         | 100%   |
| User success rate        | 🟡 ~60%         | 95%+   |
| New user onboarding time | 🟡 ~15 min      | <2 min |
| Workflow completion rate | 🟡 ~75%         | 95%+   |

### 🚀 How to Contribute

**For Users**: The system is ready for testing. See [senior-commands-guide.md](./docs/senior-commands-guide.md) for detailed usage patterns.

**For Contributors**:

1. Start with [Quick Wins](./QUICK_WINS.md) for immediate impact items
2. Review [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md) for technical details
3. Submit PRs to the `dev` branch
4. Request review for merge to `main`

---

## 🔄 Plugin System & Automated Hooks

### NEW: Complete Plugin Migration ✨

This repository now includes a **complete Claude Code plugin** with automated session management hooks!

**What's included:**

- ✅ **7 Slash Commands**: `/build`, `/think`, `/ui`, `/patch`, `/review`, `/review-perf`, `/review-sec`
- ✅ **13 Specialized Agents**: Investigator, architect, builder, validator, auditor + 8 quality assurance agents
- ✅ **Automated Session Management**: Hooks that automatically track workflow sessions
- ✅ **MCP Server Integration**: Context7 for up-to-date documentation

### Installation Options

#### Option 1: Standard Plugin Install (Recommended)

```bash
# Add marketplace
/plugin marketplace add yargotev/claude-marketplace

# Install plugin
/plugin install exito-plugin@yargotev-marketplace
```

#### Option 2: Local Development

```bash
# Clone and add locally
git clone https://github.com/yargotev/claude-marketplace.git
cd claude-marketplace
/plugin marketplace add .
/plugin install exito-plugin@exito-marketplace
```

### Automated Session Management

The plugin includes **automatic hooks** that:

1. **Session Creation** (`PreToolUse` hook):

   - Generates unique session IDs automatically
   - Creates session directories: `.claude/sessions/tasks/task_{timestamp}_{hash}/`
   - Tracks metadata (user, git branch, working directory)

2. **Session Cleanup** (`SessionEnd` hook):
   - Determines final status (completed/interrupted/failed)
   - Generates session summaries with next steps
   - Provides recovery guidance for interrupted workflows

**Session artifacts include:**

- `context.md` - Research phase findings
- `plan.md` - Implementation plan
- `progress.md` - Implementation progress
- `test_report.md` - Test results
- `review.md` - Code review
- `session_summary.md` - Final summary with next steps

### Plugin Documentation

For complete details on the plugin system:

- 📖 [Plugin README](./exito-plugin/README.md) - Complete plugin documentation
- 🔄 [Migration Guide](./PLUGIN_MIGRATION_GUIDE.md) - Detailed migration information
- 📊 [Migration Summary](./MIGRATION_SUMMARY.md) - Summary of changes
- 🚀 [Quick Start](./QUICK_START.md) - 3-step installation guide
- ✅ [Final Checklist](./FINAL_CHECKLIST.md) - Verification checklist

---

## Contributing

To improve or add new commands, please see the `docs/` directory for more information on the project structure and development conventions.

**For strategic improvements**, see:

- [AUDIT_INDEX.md](./AUDIT_INDEX.md) - Navigation guide for all audit documents
- [QUICK_WINS.md](./QUICK_WINS.md) - Start here for immediate improvements
- [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md) - Technical implementation guide

---

**Maintainer**: Development Team
**Last Updated**: October 18, 2025
**License**: Internal Use Only
