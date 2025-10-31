---
name: plugin-architect
description: Design and build Claude Code plugin components including commands, sub-agents, workflows, and configurations. Use when creating new plugins, adding commands/agents to existing plugins, refactoring plugin components for token efficiency, or architecting multi-agent orchestration patterns.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Claude Code Plugin Architect

Expert guidance for building high-performance, token-efficient Claude Code plugins with proper architecture and best practices.

## When to Use This Skill

Use this skill when you need to:
- Create a new Claude Code plugin from scratch
- Add slash commands to existing plugins
- Design specialized sub-agents with proper tool restrictions
- Refactor agents for token efficiency
- Implement multi-agent orchestration patterns
- Integrate MCP servers into plugins
- Optimize plugin architecture following official best practices

## Core Principles

1. **Token Efficiency First**: Use file-based context sharing, not message passing
2. **Single Responsibility**: Each agent should have one clear, focused purpose
3. **Structured Prompts**: Use XML tags or Markdown headers for section delineation
4. **Defensive Design**: Include error handling, input validation, fallback strategies
5. **Actionable Output**: Every finding must include location, impact, and concrete fix
6. **Tool Selectivity**: Grant only essential tools with appropriate restrictions
7. **Project Context Awareness**: Align with existing patterns from CLAUDE.md

## Quick Start

### Creating a Command

Commands are markdown files in `.claude/commands/` with YAML frontmatter:

```yaml
---
description: "Brief description of what this command does"
argument-hint: "<REQUIRED_ARG> [OPTIONAL_ARG]"
---

# Command Instructions

Your command logic here. Commands orchestrate agents and manage workflow.
```

### Creating a Sub-Agent

Agents are markdown files in `.claude/agents/` with this structure:

```yaml
---
name: agent-name
description: "When to invoke this agent"
tools: Bash(gh:*), Read, Write
model: claude-sonnet-4-5-20250929
---

<role>Clear identity statement</role>

<specialization>
- Focus areas
</specialization>

<workflow>
Step-by-step process
</workflow>

<output_format>
Expected structure
</output_format>
```

### Token-Efficient Context Management

**DO**: Pass file paths between agents
```markdown
Read context from `.claude/sessions/pr_reviews/pr_123_context.md`
```

**DON'T**: Pass content in messages
```markdown
Analyze this code: [10,000 lines of diff]
```

## Tool Restrictions Pattern

Be restrictive with tool access:

```yaml
# GitHub CLI only
tools: Bash(gh:*)

# Specific npm commands
tools: Bash(npm:audit), Bash(npm:test)

# File operations only
tools: Read, Write, Grep, Glob

# No unrestricted bash
tools: Bash(*)  # ❌ NEVER DO THIS
```

## Parallel Agent Execution

For orchestrators invoking multiple independent agents:

```markdown
Invoke the following agents **in parallel** using a single message with multiple Task tool calls:
- agent-1
- agent-2
- agent-3

**Important**: All agents run concurrently for maximum efficiency.
```

## Output Quality Standards

Every finding MUST include:
1. **File path and line number**: `src/components/Hero.tsx:42-48`
2. **Clear description**: What is the issue?
3. **Impact**: Why does this matter?
4. **Before/after code example**: Specific fix
5. **Priority**: Critical / High / Medium / Low

## Detailed Resources

For comprehensive guidance, see:
- [WORKFLOW.md](WORKFLOW.md) - Complete agent/command creation workflow
- [REFERENCE.md](REFERENCE.md) - Detailed best practices and patterns
- [EXAMPLES.md](EXAMPLES.md) - Real-world plugin examples

## Quick Reference: Agent Types

**Investigator**: Research and context gathering
**Architect**: Solution design and planning
**Builder**: Code implementation with tests and commits
**Validator**: Testing and quality assurance
**Auditor**: Final code review before merge

## Common Pitfalls to Avoid

❌ **DON'T**:
- Pass large diffs between agents (use files)
- Return full analysis in responses (persist to disk, return summary)
- Create vague, overlapping agent responsibilities
- Grant unrestricted tool access
- Write prompts at wrong altitude (too specific or too vague)

✅ **DO**:
- Use file-based communication
- Return concise summaries (< 200 words)
- Create focused, specialized agents
- Restrict tools to minimum necessary
- Structure prompts with clear XML/Markdown sections

## Integration with Project Context

Always check for `CLAUDE.md` in the project root for:
- Project-specific naming conventions
- Existing agent patterns
- Required dependencies
- Domain-specific constraints

This ensures your plugin components align with project standards.
