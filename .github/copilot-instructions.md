# Claude Marketplace - AI Coding Agent Guide

This repository hosts **Claude Code plugins** for both general plugin development (`cc/` - plugin-builder) and advanced engineering workflows (`exito/` - PR reviews and systematic development).

## Architecture Overview

### Three Main Components

1. **`cc/plugin-builder`** - Meta-plugin for building Claude Code plugins
   - Interactive commands: `/new-plugin`, `/new-command`, `/new-agent`
   - Comprehensive guides in `cc/skills/claude-code-plugin-builder/`
   - Production templates in `cc/skills/claude-code-plugin-builder/templates/`

2. **`exito/`** - Senior engineer workflow plugin
   - Multi-agent PR review system (`/review`, `/review-perf`, `/review-sec`)
   - Systematic development workflow (`/workflow`) with 7-phase process
   - 8 specialized subagents in `exito/agents/`
   - Session-based state management via hooks

3. **`setup/`** - Installation commands for CLI tools and MCP servers
   - `/setup-cli` - Installs GitHub CLI and Azure CLI
   - `/setup-mcp` - Configures Context7 and Serena MCP servers

### Plugin Structure (Critical Pattern)

All plugins follow this structure:
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required manifest with name, version, description
├── commands/                 # User-facing slash commands (markdown files)
│   └── command-name.md      # YAML frontmatter + instructions
├── agents/                   # Specialized subagents (markdown files)
│   └── agent-name.md        # YAML frontmatter + role definition
├── skills/                   # Optional: Agent Skills (auto-activated)
│   └── skill-name/
│       └── SKILL.md         # Skill entry point
└── hooks/                    # Optional: Event-driven automation
    └── hooks.json           # PreToolUse, SessionEnd, etc.
```

## Key Conventions

### Command File Format (commands/*.md)

```markdown
---
description: "What this command does (user sees in /help)"
argument-hint: "<REQUIRED> [OPTIONAL]"  # Optional
allowed-tools: Read, Write, Bash(gh:*)  # Optional: restricts tools
model: claude-sonnet-4-5-20250929       # Optional: overrides default
---

# Command Instructions

Use $1 for first arg, $2 for second, $ARGUMENTS for all args.

## Example with bash execution in context
Current PR: !`gh pr view $1 --json title,body`
```

**Critical**: Use `!` backticks for bash execution that gets embedded in context. Use Task tool or regular bash for side effects.

### Agent File Format (agents/*.md)

```markdown
---
name: agent-identifier
description: "When to invoke this agent"
tools: Read, Write                      # Restricted tool access
model: claude-sonnet-4-5-20250929       # Explicit model required
---

<role>
You are [identity]. Your expertise is [domain].
</role>

<input>
- `$1`: First argument description
</input>

<workflow>
Step-by-step process...
</workflow>

<output_format>
Expected structure...
</output_format>
```

**Critical Differences**:
- Agents run in **isolated contexts** (no conversation history)
- Agents have **clean state** (cwd resets to project root)
- Agents **must explicitly request tools** in frontmatter
- Orchestrators invoke with: `<Task agent="agent-name">content</Task>`

## Multi-Agent Orchestration Patterns

### File-Based Context Sharing (Primary Pattern)

**❌ NEVER DO**: Pass large content between agents
```markdown
<Task agent="analyzer">
[10,000 lines of code here]
</Task>
```

**✅ ALWAYS DO**: Use files as single source of truth
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

**Benefits**: 60-70% token reduction, enables parallelism, audit trail

### Session Management Pattern

See `exito/hooks/hooks.json` and `exito/scripts/session-manager.sh`:
- `PreToolUse` hook with `Task` matcher initializes session directory
- `SessionEnd` hook performs cleanup
- Session ID available via `$CLAUDE_SESSION_ID` environment variable
- Session directory: `.claude/sessions/tasks/$CLAUDE_SESSION_ID/`

## Critical Workflows

### `/workflow` Command (exito)

7-phase systematic development:
1. **Discover** - Deep context gathering (investigator agent)
2. **Validate** - Check information completeness (requirements-validator)
3. **Explore** - Generate 2-4 alternatives (solution-explorer)
4. **Select** - User chooses approach (interactive pause)
5. **Plan** - Detailed implementation (architect agent with extended thinking)
6. **Approve** - User reviews plan (interactive pause)
7. **Execute** - Surgical implementation (surgical-builder agent)
8. **Test** - Comprehensive validation
9. **Review** - Quality assurance
10. **Document** - Knowledge base creation

**Key Insight**: Wait for user input at Select and Approve phases. Document interactive pauses with clear prompts.

### `/review` Command (exito)

Multi-agent PR review orchestration:
1. **Context Establishment** - Platform-agnostic PR data normalization
2. **Business Validation** - Optional Azure DevOps User Story alignment
3. **Parallel Analysis** - 6 specialized agents run simultaneously:
   - performance-analyzer
   - architecture-reviewer
   - clean-code-auditor
   - security-scanner
   - testing-assessor
   - accessibility-checker
4. **Synthesis** - Unified final report with scores and action plan

**Platform Detection**: Context-gatherer auto-detects GitHub (via `gh` CLI) or Azure DevOps (via Azure MCP).

## Development Commands

### Testing Plugins Locally

```bash
# Add local marketplace
/plugin marketplace add ./claude-marketplace

# Install plugin
/plugin install plugin-builder@local
/plugin install exito@local

# Test commands
/new-plugin
/review <PR_URL>
```

### Documentation Structure

- `cc/skills/claude-code-plugin-builder/` - Complete plugin development guides
  - `COMMANDS.md` - Slash command patterns
  - `AGENTS.md` - Subagent design (977 lines - comprehensive)
  - `WORKFLOWS.md` - Multi-agent orchestration patterns
  - `HOOKS.md` - Event-driven automation
  - `MCP.md` - External tool integration
- `docs/claude-code-docs/` - Official Claude Code feature docs
- `docs/claude-marketplace-docs/` - Plugin-specific guides
- `cc/QUICKREF.md` - Fast lookup reference (630 lines)

## Best Practices from This Codebase

1. **Extended Thinking for Complex Tasks**: Architect agent uses `think`, `think hard`, `think harder`, or `ULTRATHINK` based on complexity
2. **Token Efficiency**: File paths > content passing. See WORKFLOWS.md for 60-70% reduction patterns
3. **Structured Prompts**: XML tags (`<role>`, `<workflow>`, `<output_format>`) for clarity
4. **Graceful Degradation**: Validate inputs, handle missing data, provide fallbacks
5. **Actionable Output**: Every finding includes location, description, impact, fix example, priority
6. **Session Isolation**: Use hooks for automatic session lifecycle management
7. **Platform Agnostic**: Design agents to normalize data from multiple sources (see context-gatherer)

## Common Pitfalls to Avoid

1. **Don't duplicate context** - Use file paths, not content, between agents
2. **Don't inherit models blindly** - Explicitly specify model in agent frontmatter
3. **Don't forget interactive pauses** - workflow command has explicit user decision points
4. **Don't skip validation** - Check session environment before proceeding (see architect.md lines 59-82)
5. **Don't use sequential invocations for parallel work** - Multiple `<Task>` calls in one message enable true parallelism

## Key Files to Reference

- `exito/commands/workflow.md` - Full systematic workflow pattern
- `exito/commands/review.md` - Parallel multi-agent orchestration
- `cc/skills/claude-code-plugin-builder/AGENTS.md` - Comprehensive agent design guide
- `cc/skills/claude-code-plugin-builder/WORKFLOWS.md` - Token optimization patterns
- `exito/agents/architect.md` - Extended thinking and session validation patterns
- `cc/QUICKREF.md` - Fast syntax reference
