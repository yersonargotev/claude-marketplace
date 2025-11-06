# Agent Structure Standard

**Version**: 1.0  
**Date**: November 6, 2025  
**Status**: Active

## Purpose

This document defines the standard structure for all agent files in the claude-marketplace repository. Following this standard ensures consistency, maintainability, and ease of onboarding for new contributors.

## Benefits

- **Consistency**: All agents follow the same pattern
- **Maintainability**: Easy to understand and modify any agent
- **Token Efficiency**: Shared utilities reduce duplication
- **Error Handling**: Consistent failure modes and error messages
- **Observability**: Agent execution logging for debugging

## Standard Agent Template

All agent files MUST follow this structure:

```markdown
---
name: agent-name
description: "When to invoke this agent (50-100 chars, clear and actionable)"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

# Agent Name - Role Title

You are a [role]. Your specialization is [domain].

**Expertise**: [3-5 core competencies, comma-separated or bulleted]

## Input

- `$1`: [Description of first argument]
- `$2`: [Optional description of second argument]
- Session ID: Automatically provided via `$CLAUDE_SESSION_ID` environment variable

**Token Efficiency Note**: [How this agent uses files vs content passing, e.g., "Reads context from files, writes reports to files, returns concise summaries"]

## Session Setup

Before starting any work, validate the session environment using shared utilities:

\`\`\`bash
!source exito/scripts/shared-utils.sh && validate_session_environment "${COMMAND_TYPE:-tasks}"
\`\`\`

This ensures:
- Session ID exists
- Session directory is created
- Write permissions are validated
- Consistent error messages on failure

## Workflow

### Phase 1: [Phase Name]

[Clear, actionable steps for this phase]

1. **[Step name]**: [What to do]
2. **[Step name]**: [What to do]

### Phase 2: [Phase Name]

[Continue with clear phases and steps]

### Phase N: [Final Phase]

[Complete the workflow]

## Output Format

[Exact structure of what this agent returns to the orchestrator]

**Example**:

\`\`\`markdown
## [Agent Name] Complete ✓

**[Key metric]**: [Value]

**Summary**:
- [Finding 1]
- [Finding 2]

**Report**: \`.claude/sessions/{type}/$CLAUDE_SESSION_ID/[filename].md\`
\`\`\`

**IMPORTANT**: Return only concise summaries. Full reports go in session files.

## Error Handling

[Specific failure modes this agent might encounter and how to respond]

**Common Errors**:
- **Context file missing**: [How to handle]
- **Invalid input**: [How to handle]
- **Tool failure**: [How to handle]

**Error Response Format**:
\`\`\`markdown
❌ ERROR: [Clear description]

**Cause**: [What went wrong]
**Fix**: [What user should do]
\`\`\`

## Best Practices

**DO ✅**:
- [Best practice 1]
- [Best practice 2]
- [Best practice 3]

**DON'T ❌**:
- [Anti-pattern 1]
- [Anti-pattern 2]
- [Anti-pattern 3]

---

Remember: [One sentence philosophy that encapsulates this agent's purpose]
```

## Section Definitions

### Frontmatter

**Required fields**:
- `name`: Kebab-case identifier (e.g., `context-gatherer`)
- `description`: 50-100 character description of when to invoke
- `tools`: Comma-separated list of allowed tools
- `model`: Explicit model specification (see Model Specification Standard)

### Header

- Title: `# Agent Name - Role Title`
- Role statement: "You are a [role]..."
- Expertise: 3-5 core competencies

### Input Section

- Document all expected arguments (`$1`, `$2`, etc.)
- Note session ID availability
- Include Token Efficiency Note explaining file-based patterns

### Session Setup

- MUST use shared utilities: `exito/scripts/shared-utils.sh`
- MUST call `validate_session_environment`
- Ensures consistency across all agents

### Workflow Section

- Break into logical phases
- Use numbered steps within phases
- Be specific and actionable
- Include file paths and examples

### Output Format

- Define exact return structure
- Include example output
- Emphasize concise summaries
- Specify where full reports are saved

### Error Handling

- List common failure modes
- Define error response format
- Provide actionable fixes

### Best Practices

- Use ✅ for DOs
- Use ❌ for DON'Ts
- Be specific, not generic

## Model Specification Standard

### Decision Matrix

| Context | Model Choice | When to Use |
|---------|--------------|-------------|
| **Default** | `claude-sonnet-4-5-20250929` | Most agents, balanced capability |
| **Fast operations** | `haiku` | Simple research, quick fixes, minimal analysis |
| **Deep thinking** | `opus` or extended sonnet | Architecture, complex planning, critical decisions |
| **Inherit from parent** | Omit `model:` field | When consistency with parent command is important |

### Rules

1. **Agents** should ALWAYS explicitly specify model (no inheritance uncertainty)
2. **Commands** should specify model ONLY when overriding default
3. **Fast commands** (`/patch`) use `haiku` for speed
4. **Deep commands** (`/think`) use extended thinking, not model changes
5. Document reasoning if using non-default model

## File-Based Context Sharing Pattern

All agents SHOULD follow this pattern for token efficiency:

1. **Read input** from session files (e.g., `context.md`, `plan.md`)
2. **Write reports** to session files (e.g., `agent-name_report.md`)
3. **Return summaries** (< 200 words) to orchestrator
4. **Pass file paths** between agents, not content

**Benefits**:
- 60-70% token reduction
- Enables parallel agent execution
- Creates audit trail
- Makes debugging easier

## Validation Checklist

Before submitting a new or refactored agent, verify:

- [ ] Frontmatter has all required fields
- [ ] Description is 50-100 characters
- [ ] Model is explicitly specified
- [ ] Session setup uses `shared-utils.sh`
- [ ] Workflow is broken into clear phases
- [ ] Output format is documented with example
- [ ] Error handling covers common failures
- [ ] Best practices section exists
- [ ] File-based context sharing is used
- [ ] Returns concise summaries (< 200 words)

## Migration Guide

### For Existing Agents

1. **Add session setup** if missing:
   ```bash
   !source exito/scripts/shared-utils.sh && validate_session_environment "${COMMAND_TYPE:-tasks}"
   ```

2. **Standardize structure**:
   - Ensure all required sections exist
   - Reorder sections to match standard
   - Add missing sections (e.g., Error Handling)

3. **Add explicit model**:
   - Check if model field exists in frontmatter
   - Add `model: claude-sonnet-4-5-20250929` (or appropriate model)

4. **Update output format**:
   - Ensure concise summaries (< 200 words)
   - Document where full reports are saved

5. **Test**:
   - Verify agent works with shared utilities
   - Check error handling
   - Validate output format

## Examples

### Good Example: Context Gatherer

```markdown
---
name: context-gatherer
description: "Gathers PR metadata, size, file changes, and CI status from GitHub or Azure DevOps"
tools: Bash(gh:*), Bash(az:*), Bash(curl:*), Write
model: claude-sonnet-4-5-20250929
---

# Context Gatherer - PR Intelligence Specialist

You are a PR Context Intelligence Specialist. You collect, classify, and structure PR information from GitHub or Azure DevOps as the foundation for downstream analysis.

**Expertise**: Multi-platform PR APIs, classification, risk assessment, context optimization

## Input

- `$1`: PR URL (GitHub or Azure DevOps)
- Session ID: Automatically provided via `$CLAUDE_SESSION_ID`

**Token Efficiency Note**: Collects PR data once, writes to file, enables parallel analysis by multiple agents reading the same context file.

## Session Setup

!source exito/scripts/shared-utils.sh && validate_session_environment "pr_reviews"

## Workflow

[... rest of agent definition ...]
```

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-11-06 | Initial standard based on architectural review |

## Related Documents

- [Architecture Decision Record: File-Based Context Sharing](../adr/001-file-based-context-sharing.md)
- [Architecture Decision Record: Model Selection Policy](../adr/005-model-selection-policy.md)
- [Shared Utilities Documentation](../../exito/scripts/README.md)
- [Agent Catalog](../../exito/AGENTS.md)

