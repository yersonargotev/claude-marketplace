# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **Claude Code plugin marketplace** containing three main plugins for plugin development and advanced engineering workflows. All code is configuration-based (markdown/JSON) with bash scripts for session management.

## Plugin Structure

This repository contains three plugins that follow the standard Claude Code plugin structure:

### 1. `cc/` (plugin-builder)
Meta-plugin for building Claude Code plugins with interactive commands and comprehensive guides.

**Commands:**
- `/new-plugin [NAME]` - Create new plugin with guided setup
- `/new-command [NAME]` - Add slash command to existing plugin
- `/new-agent [NAME]` - Add specialized subagent to plugin

**Key Files:**
- `cc/skills/claude-code-plugin-builder/` - Comprehensive documentation (AGENTS.md, WORKFLOWS.md, COMMANDS.md, HOOKS.md, MCP.md, TESTING.md)
- `cc/QUICKREF.md` - Quick syntax reference (630 lines)
- `cc/skills/claude-code-plugin-builder/templates/` - Production templates

### 2. `exito/`
Senior engineer workflow plugin with multi-agent orchestration.

**Commands:**
- `/review <PR_URL>` - Multi-agent PR review (6 specialized agents in parallel)
- `/review-perf <PR_URL>` - Performance-focused PR review
- `/review-sec <PR_URL>` - Security-focused PR review
- `/workflow <TASK>` - 7-phase systematic development process with user checkpoints
- `/build <FEATURE>` - Full feature development workflow
- `/patch <ISSUE>` - Quick fixes with focused analysis
- `/implement <REQUIREMENTS>` - Implementation-focused workflow
- `/think <PROBLEM>` - Extended thinking for complex analysis
- `/ui <DESIGN>` - UI/UX implementation workflow

**Agents:** 17 specialized agents in `exito/agents/`:
- PR Review Pipeline: 1-context-gatherer → 2-business-validator → [6 parallel analyzers] → synthesis
- Workflow Pipeline: investigator → requirements-validator → solution-explorer → architect → surgical-builder
- Supporting: auditor, validator, builder, documentation-writer

**Session Management:**
- `exito/hooks/hooks.json` - PreToolUse and SessionEnd hooks
- `exito/scripts/session-manager.sh` - Session ID generation and initialization
- Session directories (command-specific):
  - `.claude/sessions/workflow/$CLAUDE_SESSION_ID/` - /workflow sessions
  - `.claude/sessions/build/$CLAUDE_SESSION_ID/` - /build sessions
  - `.claude/sessions/implement/$CLAUDE_SESSION_ID/` - /implement sessions
  - `.claude/sessions/ui/$CLAUDE_SESSION_ID/` - /ui sessions
  - `.claude/sessions/patch/$CLAUDE_SESSION_ID/` - /patch sessions
  - `.claude/sessions/think/$CLAUDE_SESSION_ID/` - /think sessions
  - `.claude/sessions/pr_reviews/` - /review sessions (PR-specific structure)

### 3. `setup/`
Installation commands for development tools.

**Commands:**
- `/azure` - Azure DevOps integration setup
- `/github` - GitHub CLI setup
- `/serena` - Serena MCP server configuration
- `/uv` - UV Python package manager installation

## Development Commands

### Testing Plugins Locally

```bash
# Add this repository as a local marketplace
/plugin marketplace add ./claude-marketplace

# Install plugins
/plugin install plugin-builder@local
/plugin install exito@local
/plugin install setup@local

# Reload after changes
/plugin disable <plugin-name>
/plugin enable <plugin-name>
```

### No Build Process
This repository contains no build step, compilation, or transpilation. All files are directly interpreted by Claude Code:
- Commands are markdown files with YAML frontmatter
- Agents are markdown files with YAML frontmatter
- Configuration is JSON
- Scripts are executable bash

## Architecture Patterns

### Plugin File Structure

Every plugin follows this structure:
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required: name, version, description
├── commands/                 # Optional: User-facing slash commands
│   └── command-name.md      # YAML frontmatter + markdown instructions
├── agents/                   # Optional: Specialized subagents
│   └── agent-name.md        # YAML frontmatter + role definition
├── skills/                   # Optional: Auto-activated agent skills
│   └── skill-name/
│       └── SKILL.md
└── hooks/                    # Optional: Event-driven automation
    └── hooks.json
```

### Command File Format

```markdown
---
description: "What this command does (shown in /help)"
argument-hint: "<REQUIRED> [OPTIONAL]"
allowed-tools: Read, Write, Bash(gh:*)
model: claude-sonnet-4-5-20250929
---

# Command Instructions

Use $1, $2 for positional arguments, $ARGUMENTS for all args.

Use !`command` for bash execution embedded in context (output becomes part of prompt).
Use Task tool for agent invocations.
```

### Agent File Format

```markdown
---
name: agent-identifier
description: "When to invoke this agent"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are [identity]. Your expertise is [domain].
</role>

<input>
- `$1`: Argument description
</input>

<workflow>
Step-by-step process...
</workflow>

<output_format>
Expected structure...
</output_format>
```

**Critical**: Agents run in isolated contexts with no conversation history. They must explicitly declare tools and model in frontmatter.

## Multi-Agent Orchestration

### File-Based Context Sharing Pattern

**❌ NEVER pass large content between agents:**
```markdown
<Task agent="analyzer">
[10,000 lines of code here]
</Task>
```

**✅ ALWAYS use files as single source of truth:**
```markdown
# Phase 1: Create context
<Task agent="context-gatherer">
  Analyze PR $1. Save to: .claude/sessions/pr_reviews/pr_123_context.md
</Task>

# Phase 2: Parallel analysis (in SINGLE message)
<Task agent="performance-analyzer">
  Read context from: .claude/sessions/pr_reviews/pr_123_context.md
  Write report to: .claude/sessions/pr_reviews/pr_123_performance.md
</Task>
<Task agent="security-scanner">
  Read context from: .claude/sessions/pr_reviews/pr_123_context.md
  Write report to: .claude/sessions/pr_reviews/pr_123_security.md
</Task>

# Phase 3: Synthesize
Read all reports from .claude/sessions/pr_reviews/pr_123_*.md
```

**Benefits**: 60-70% token reduction, enables parallelism, creates audit trail.

### Session Management

- `$CLAUDE_SESSION_ID` - Available in all hooks and commands
- `$CLAUDE_PLUGIN_ROOT` - Path to plugin directory
- Session directories automatically created via PreToolUse hook
- Automatic cleanup via SessionEnd hook
- See `exito/hooks/hooks.json` and `exito/scripts/session-manager.sh`

## Key Workflows

### `/review` Command (Multi-Agent PR Review)

1. **Context Establishment** - Platform-agnostic PR normalization (GitHub CLI or Azure DevOps MCP)
2. **Business Validation** - Optional User Story alignment
3. **Parallel Analysis** - 6 agents run simultaneously:
   - 3-performance-analyzer
   - 4-architecture-reviewer
   - 5-clean-code-auditor
   - 6-security-scanner
   - 7-testing-assessor
   - 8-accessibility-checker
4. **Synthesis** - Unified report with scores and action plan

**Location**: `exito/commands/review.md`
**Pattern**: Context creation → parallel analysis → synthesis

### `/workflow` Command (7-Phase Systematic Development)

1. **Discover** - Deep context gathering (investigator agent)
2. **Validate** - Check completeness (requirements-validator)
3. **Explore** - Generate 2-4 alternatives (solution-explorer)
4. **Select** - User chooses approach (interactive pause)
5. **Plan** - Detailed implementation (architect agent with extended thinking)
6. **Approve** - User reviews plan (interactive pause)
7. **Execute** - Surgical implementation (surgical-builder agent)

**Location**: `exito/commands/workflow.md`
**Key**: Interactive pauses at Select and Approve phases for user input.

## Critical Best Practices

### From .cursorrules and .github/copilot-instructions.md:

1. **Token Efficiency**: File paths > content passing (60-70% reduction)
2. **Extended Thinking**: Use `think`, `think hard`, `think harder`, or `ULTRATHINK` for complex tasks (see `exito/agents/architect.md`)
3. **Structured Prompts**: Use XML tags (`<role>`, `<workflow>`, `<output_format>`, `<input>`)
4. **Single Responsibility**: One purpose per agent/command
5. **Graceful Degradation**: Validate inputs, handle missing data, provide fallbacks
6. **Actionable Output**: Every finding includes location, description, impact, fix example, priority
7. **Session Isolation**: Use hooks for automatic lifecycle management
8. **Platform Agnostic**: Normalize data from multiple sources (see `exito/agents/1-context-gatherer.md`)

### SOLID Principles
- Single Responsibility: Keep files focused on one purpose
- Open/Closed: Extend functionality without modifying existing files
- Liskov Substitution: Maintain consistent behavior across similar components
- Interface Segregation: Use smaller, focused hooks and components
- Dependency Inversion: Inject dependencies via context

### Common Pitfalls to AVOID

1. ❌ Don't duplicate context - Use file paths, not content, between agents
2. ❌ Don't inherit models blindly - Explicitly specify model in agent frontmatter
3. ❌ Don't forget interactive pauses - Workflow command has explicit user decision points
4. ❌ Don't skip validation - Check session environment before proceeding
5. ❌ Don't use sequential invocations for parallel work - Multiple `<Task>` calls in one message enable true parallelism

## Key Reference Documentation

When making changes, consult these files:

### Plugin Development
- `cc/skills/claude-code-plugin-builder/AGENTS.md` - Comprehensive agent design (977 lines)
- `cc/skills/claude-code-plugin-builder/WORKFLOWS.md` - Multi-agent orchestration patterns
- `cc/skills/claude-code-plugin-builder/COMMANDS.md` - Slash command patterns
- `cc/skills/claude-code-plugin-builder/HOOKS.md` - Event-driven automation
- `cc/skills/claude-code-plugin-builder/MCP.md` - External tool integration
- `cc/QUICKREF.md` - Fast syntax reference (630 lines)

### Workflow Examples
- `exito/commands/workflow.md` - Full systematic workflow pattern
- `exito/commands/review.md` - Parallel multi-agent orchestration
- `exito/agents/architect.md` - Extended thinking and session validation
- `exito/agents/1-context-gatherer.md` - Platform-agnostic data normalization

### Documentation
- `docs/claude-code-docs/` - Official Claude Code feature docs
- `docs/claude-marketplace-docs/` - Plugin-specific guides

## Editing Guidelines

### Adding New Commands
1. Create markdown file in appropriate `commands/` directory
2. Use YAML frontmatter with description and argument-hint
3. Follow command file format standard (see above)
4. Test with local plugin installation

### Adding New Agents
1. Create markdown file in appropriate `agents/` directory
2. Use YAML frontmatter with name, description, tools, and model
3. Structure with `<role>`, `<input>`, `<workflow>`, `<output_format>` tags
4. Remember: agents are isolated, specify all requirements explicitly

### Modifying Orchestration
1. Prefer file-based context sharing over content passing
2. Group parallel agent invocations in single message
3. Use session directories for intermediate artifacts
4. Document phase transitions clearly

### Adding Hooks
1. Add to `hooks/hooks.json` in plugin directory
2. Use matchers to target specific events (Task, *, etc.)
3. Ensure scripts are executable and handle errors
4. Test session lifecycle (start, middle, end)
