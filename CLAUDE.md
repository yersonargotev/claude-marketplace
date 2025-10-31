# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Claude Code plugin that provides comprehensive PR review commands for FastStore/VTEX e-commerce development at Exito. The plugin is distributed via marketplace and uses an agent-based architecture to perform multi-dimensional code analysis.

## Nomenclature (Updated 2025)

The plugin uses clear, action-oriented names for all commands and agents:

### Commands (User-facing)

- **/build** - Full-cycle feature development (formerly `/inge`)
- **/think** - Deep architectural analysis with ULTRATHINK mode (formerly `/senior`)
- **/ui** - Frontend/UI specialist workflow (formerly `/frontend`)
- **/patch** - Quick fixes and simple changes (formerly `/quick-fix`)
- **/workflow** - Systematic problem-solving with multi-solution exploration and surgical implementation
- **/review** - Comprehensive PR review orchestrator
- **/review-perf** - Performance-focused PR review
- **/review-sec** - Security-focused PR review

### Agents (Internal)

**Core Workflow Agents**:
- **investigator** - Codebase research & context gathering (formerly `research-engineer`)
- **architect** - Solution design & planning (formerly `planner-engineer`)
- **builder** - Code implementation & execution (formerly `implementer-engineer`)
- **validator** - Testing & quality assurance (formerly `tester-engineer`)
- **auditor** - Final code review & approval (formerly `reviewer-engineer`)

**Workflow-Specific Agents** (used by `/workflow` command):
- **requirements-validator** - Validates context completeness before proceeding
- **solution-explorer** - Generates 2-4 alternative solutions with trade-off analysis
- **surgical-builder** - Implements with strict constraints (no comments, minimal edits)
- **documentation-writer** - Creates permanent knowledge base docs in `documentacion/`

**Rationale**: The new names eliminate redundancy ("-engineer" suffix), improve clarity (action verbs for commands), and make the system more intuitive for new users.

## Installation & Setup

To test the plugin after making changes:

1. **Install the plugin** (if not already installed):

   ```bash
   /plugin marketplace add yargotev/claude-marketplace
   /plugin install exito@exito-marketplace
   ```

2. **Setup required dependencies**:
   ```bash
   /setup
   ```
   This installs GitHub CLI (`gh`) and Azure CLI (`az`) via Homebrew if missing.

## Architecture

### Plugin Structure

The plugin uses an **advanced multi-agent orchestration pattern** with persistent context management:

```
exito-plugin/
├── .claude-plugin/              # Plugin metadata
│   └── plugin.json              # Plugin configuration
├── commands/                    # User-facing slash commands
│   ├── build.md                 # Full feature builder (ex-inge)
│   ├── think.md                 # Deep architectural thinking (ex-senior)
│   ├── ui.md                    # Frontend/UI specialist (ex-frontend)
│   ├── patch.md                 # Quick fixes (ex-quick-fix)
│   ├── review.md                # PR review orchestrator
│   ├── review-perf.md           # Performance-focused review
│   └── review-sec.md            # Security-focused review
├── agents/                      # Specialized sub-agents
│   ├── investigator.md            # Context & research (ex-research-engineer)
│   ├── architect.md               # Solution design & planning (ex-planner-engineer)
│   ├── builder.md                 # Code implementation (ex-implementer-engineer)
│   ├── validator.md               # Testing & QA (ex-tester-engineer)
│   ├── auditor.md                 # Final code review (ex-reviewer-engineer)
│   ├── 1-context-gatherer.md      # PR metadata & diff collection
│   ├── 2-business-validator.md    # Azure DevOps integration
│   ├── 3-performance-analyzer.md  # React/Next.js performance
│   ├── 4-architecture-reviewer.md # Design patterns & structure
│   ├── 5-clean-code-auditor.md    # Code quality & style
│   ├── 6-security-scanner.md      # Security vulnerabilities
│   ├── 7-testing-assessor.md      # Test coverage & quality
│   └── 8-accessibility-checker.md # WCAG compliance
└── .mcp.json                    # MCP server configuration (Context7)
```

### Architectural Improvements (2025)

The plugin now implements **Claude Code Best Practices** with **optimized token efficiency**:

**Token Optimization Results**:

- **Total Agent System Prompts**: ~3,331 words (~4,500 tokens)
- **Review Command**: ~544 words (~750 tokens)
- **Total System Prompt Budget**: ~5,250 tokens per review
- **Reduction from verbose version**: **~67% fewer tokens** while maintaining full effectiveness

This optimization achieves **dramatic cost reduction** without sacrificing analysis quality.

#### 1. **Context Persistence Pattern**

All context and reports are persisted to `.claude/sessions/pr_reviews/`:

- **Context Session**: `pr_{number}_context.md` - Single source of truth
- **Agent Reports**: `pr_{number}_{agent-name}_report.md` - Individual analysis reports
- **Final Review**: `pr_{number}_final_review.md` - Synthesized comprehensive review

**Benefits**:

- Dramatic reduction in token usage
- Eliminates context loss between agents
- Enables resumable reviews for large PRs
- Provides audit trail of analysis

#### 2. **Agent Specialization & Role Definition**

Each agent now has:

- **`<role>`**: Clear identity and responsibility
- **`<specialization>`**: Specific expertise areas
- **`<workflow>`**: Structured, step-by-step analysis process
- **`<error_handling>`**: Graceful degradation strategies
- **`<best_practices>`**: Domain-specific guidelines

#### 3. **Efficiency-First Design**

- **File-based communication**: Agents share context via file paths, not message passing
- **Selective tool access**: Each agent restricted to only necessary tools (Write, Read added where needed)
- **Adaptive depth**: Analysis detail scales inversely with PR size
- **Parallel execution**: Independent agents run concurrently for maximum speed

### How the Review Command Works

1. **User invokes**: `/review <PR_NUMBER> [AZURE_DEVOPS_URL]`

2. **Phase 1 - Context Establishment**:

   - Orchestrator invokes `context-gatherer` agent
   - Context gatherer creates `.claude/sessions/pr_reviews/pr_{number}_context.md`
   - This file becomes the **single source of truth**

3. **Phase 2 - Business Validation** (conditional):

   - If Azure DevOps URLs provided, invoke `business-validator`
   - Validator reads context file, fetches User Stories, validates alignment
   - Appends findings to context session file

4. **Phase 3 - Parallel Analysis**:

   - **All analysis agents run in parallel** (one message, multiple Task tool calls)
   - Each agent:
     1. Reads context session file via `$1` argument
     2. Performs specialized analysis
     3. Writes report to `.claude/sessions/pr_reviews/pr_{number}_{agent-name}_report.md`
     4. Returns concise summary to orchestrator (NOT full report)
   - Agents: `performance-analyzer`, `architecture-reviewer`, `clean-code-auditor`, `security-scanner`, `testing-assessor`, `accessibility-checker`

5. **Phase 4 - Synthesis**:
   - Orchestrator reads all agent reports from file system
   - Synthesizes findings into unified review document
   - Saves final review to `pr_{number}_final_review.md`
   - Displays final review to user

### Adaptive Strategy by PR Size

The context-gatherer agent classifies PRs and adapts the review strategy:

- **Small** (< 200 lines): Full detailed review of all changes
- **Medium** (200-500 lines): Detailed review with focused analysis
- **Large** (500-1000 lines): Prioritized review with strategic sampling
- **Very Large** (> 1000 lines): Risk-based review with split recommendations

For Large/Very Large PRs, the context-gatherer focuses diffs on critical patterns (hooks, state management, data fetching) rather than collecting everything.

## Key Technologies & Integrations

- **GitHub CLI (`gh`)**: All agents use `gh pr view`, `gh pr diff`, and related commands to extract PR data
- **Azure DevOps MCP Tools**: Business-validator agent uses MCP tools (`mcp_microsoft_azu_wit_get_work_item`, etc.) to fetch User Story details
- **Claude Agent SDK**: All agents are defined as markdown files with YAML frontmatter specifying tools, model, and parameters

## Common Development Tasks

### Testing Commands Locally

After modifying a command or agent:

1. Restart Claude Desktop to reload plugin changes
2. Test the command on a real PR:
   ```bash
   /review <PR_NUMBER>
   ```

### Adding a New Agent

1. Create a new file in `exito-plugin/agents/` with naming convention `<number>-<name>.md`
2. Follow the YAML frontmatter pattern:
   ```yaml
   ---
   name: agent-name
   description: "What this agent does"
   tools: Bash(gh:*)
   model: claude-sonnet-4-5-20250929
   ---
   ```
3. Update the orchestrator in [commands/review.md](exito-plugin/commands/review.md) to invoke your new agent
4. Document the agent's output format in its markdown file

### Adding a New Command

1. Create a new file in `exito-plugin/commands/` like `review-<focus>.md`
2. Add YAML frontmatter:
   ```yaml
   ---
   description: "Brief description of command"
   argument-hint: "<ARG1> [ARG2]..."
   ---
   ```
3. Define the command logic using markdown and agent invocations
4. Update [README.md](README.md) to document the new command

### Modifying Agent Behavior

Each agent's instructions are defined in its markdown file. To change what an agent analyzes:

1. Edit the relevant agent file in `exito-plugin/agents/`
2. Update the "Focus Areas" or "Steps" sections
3. Adjust the expected output format in the "Output" section
4. Test with a sample PR to verify changes

## Environment Variables

### Azure DevOps Integration (Optional)

For Azure DevOps integration with the business-validator agent:

```bash
export AZURE_DEVOPS_ORG_URL="https://dev.azure.com/grupo-exito"
export AZURE_DEVOPS_PAT="your-personal-access-token"
```

### Context7 MCP Server (Optional)

To enable the Context7 MCP server for up-to-date library documentation:

```bash
export CONTEXT7_API_KEY="your-api-key-here"
```

Get your API key from [https://context7.com](https://context7.com).

**MCP Configuration:** The plugin includes Context7 configuration in [exito-plugin/.mcp.json](exito-plugin/.mcp.json). The MCP server loads automatically when the environment variable is set.

## Agent-Specific Notes

### Context Gatherer

- Always runs first; provides structured context to all other agents
- Uses `gh pr view --json` to fetch metadata
- Classifies PR size to determine review strategy
- For large PRs, uses targeted `gh pr diff` with grep patterns instead of full diff

### Business Validator

- Only invoked when Azure DevOps URLs are provided as arguments
- Requires Azure CLI authentication (`az login --allow-no-subscriptions`)
- Uses MCP tools to fetch Work Items and validate against acceptance criteria

### Performance Analyzer

- Focuses on React hooks (useEffect, useMemo, useCallback)
- Checks Next.js patterns (getStaticProps, next/dynamic, next/image)
- Identifies bundle size issues and runtime bottlenecks

### Security Scanner

- Looks for XSS risks (dangerouslySetInnerHTML, innerHTML)
- Scans for hardcoded secrets and sensitive data
- Reviews dependency changes in package.json

### Requirements Validator

- Runs after investigator to check context completeness
- Returns COMPLETE or NEEDS_INFO status
- If NEEDS_INFO, workflow pauses for user clarification
- Validates against checklist: scope, files, dependencies, edge cases, risks, architecture

### Solution Explorer

- Generates 2-4 distinct approaches with pros/cons
- Provides complexity and risk assessments for each option
- Estimates implementation time (Small/Medium/Large)
- Recommends preferred option but user makes final decision
- User selection required before proceeding to planning

### Surgical Builder

- **Strict constraints**: NO code comments, minimal edits only
- Prefers Edit tool over Write tool (targeted changes)
- Avoids refactoring scope creep
- Creates atomic commits with descriptive messages
- Focuses on self-documenting code patterns
- Uses descriptive names, extracted constants, and TypeScript types

### Documentation Writer

- Runs after auditor approval (Phase 10 of workflow)
- Creates markdown docs in `documentacion/` directory
- Naming convention: `{YYYYMMDD}-{brief-solution-name}.md`
- Includes: executive summary, alternatives considered, implementation details, test results, code review findings, lessons learned
- Synthesizes all session artifacts into permanent knowledge base article

### Architect (Enhanced)

- Now supports two modes: **Direct Mode** and **Selection Mode**
- **Direct Mode**: Original behavior - generates alternatives during thinking phase
- **Selection Mode**: Used by `/workflow` - receives pre-selected alternative from solution-explorer
- In Selection Mode, reads `alternatives.md` and focuses plan on chosen option
- Modified to accept `$3` argument for selected alternative (e.g., "Option B")

## Important Constraints

- All agents use `model: claude-sonnet-4-5-20250929`
- Agents can only use tools specified in their frontmatter `tools:` field
- The plugin assumes macOS environment (uses Homebrew for dependency installation)
- GitHub CLI must be authenticated before using any review commands

## Plugin Distribution

The plugin is distributed via the marketplace `yargotev/claude-marketplace` and installed as `exito@exito-marketplace`. Changes to the plugin require:

1. Committing changes to the repository
2. Users pulling the latest version via `/plugin update exito@exito-marketplace`

## MCP Server Integration

The plugin includes **Context7 MCP Server** integration for accessing up-to-date documentation and code examples.

### Configuration

MCP server configuration is stored in [exito-plugin/.mcp.json](exito-plugin/.mcp.json):

```json
{
  "mcpServers": {
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      },
      "description": "Access up-to-date documentation and code examples for any library/framework"
    }
  }
}
```

### Available Tools

Once configured and Claude Code is restarted, the following MCP tools are available to agents:

- **`mcp__context7__resolve-library-id`**: Resolves library names to Context7 IDs (e.g., "react" → "/facebook/react")
- **`mcp__context7__get-library-docs`**: Fetches up-to-date documentation for specific libraries with optional topic filtering

### Setup Instructions

1. Get API key from [https://context7.com](https://context7.com)
2. Set environment variable: `export CONTEXT7_API_KEY="your-key"`
3. Make persistent by adding to shell config (~/.zshrc, ~/.bashrc, etc.)
4. Restart Claude Code

### Adding More MCP Servers

To add additional MCP servers (Sentry, Linear, etc.), edit [exito-plugin/.mcp.json](exito-plugin/.mcp.json) and add new server configurations. Follow the same pattern with appropriate URL, authentication method (headers, oauth, etc.), and environment variable expansion.

---

## Best Practices for Agent Design (Based on Anthropic Guidelines)

This plugin implements industry-leading best practices for Claude Code agent design. Follow these principles when creating or modifying agents.

### 1. Agent Definition Structure

**Every agent MUST have**:

```markdown
---
name: agent-name
description: "Clear description of when this agent should be invoked"
tools: Bash(gh:*), Read, Write # Only tools necessary for the task
model: claude-sonnet-4-5-20250929
---

## <role>

Clear identity statement. Who is this agent?
</role>

## <specialization>

- Specific expertise areas
- Key focus domains
  </specialization>

## <input>

Expected arguments and their format
</input>

## <workflow>

Step-by-step process with sub-sections
</workflow>

## <output_format>

Exact structure of the expected output
</output_format>

## <error_handling>

How to handle edge cases and failures
</error_handling>

## <best_practices>

Domain-specific guidelines
</best_practices>
```

### 2. Context Management Principles

**Token Efficiency is Critical**:

- ✅ **DO**: Pass file paths between agents
- ❌ **DON'T**: Pass full diffs or large data in messages
- ✅ **DO**: Persist findings to disk immediately
- ❌ **DON'T**: Return full reports in agent responses
- ✅ **DO**: Return concise summaries (< 200 words)
- ❌ **DON'T**: Duplicate information across context

**Example - Efficient Communication**:

```bash
# ❌ BAD: Passing context in message
"Analyze this code: [10,000 lines of diff]"

# ✅ GOOD: Passing file path
"Read context from .claude/sessions/pr_reviews/pr_123_context.md and analyze"
```

### 3. System Prompt Engineering

**Clarity and Structure**:

- Use **XML tags** (`<role>`, `<workflow>`) or **Markdown headers** for clear sections
- Keep prompts at the "right altitude": specific enough to guide, flexible enough for judgment
- Include **concrete examples** of good vs bad patterns
- Provide **scoring rubrics** with clear criteria

**High-Signal Instructions**:

```markdown
## <workflow>

### Step 1: Read Context

Read the file at path `$1` and extract:

- Changed files (focus on .tsx, .jsx)
- Code diffs

### Step 2: Performance Analysis

Scan for anti-patterns:

- useEffect infinite loops
- Missing dependency arrays
- Expensive operations in render

[Include code examples]
```

### 4. Tool Design Principles

**Selectivity**:

- Only grant tools **essential** for the agent's task
- Restrict Bash to specific patterns: `Bash(gh:*)` not `Bash(*)`
- Add `Read, Write` only for agents that need file I/O

**Examples**:

```yaml
# Context Gatherer (needs to create context file)
tools: Bash(gh:*), Write

# Performance Analyzer (reads context, writes report)
tools: Bash(gh:*), Read, Write

# Security Scanner (reads context, writes report, may run npm audit)
tools: Bash(gh:*), Bash(npm:audit), Read, Write
```

### 5. Error Handling & Resilience

**Graceful Degradation**:

```markdown
## <error_handling>

- If context file doesn't exist: Report error, suggest running context-gatherer first
- If GitHub CLI fails: Provide clear gh auth login instructions
- If PR is too large: Focus on critical files, document limitation
- If no relevant changes: Report "No {X} changes detected" not an error
  </error_handling>
```

**Defensive Checks**:

- Validate inputs before processing
- Check file existence before reading
- Provide fallback strategies for timeouts

### 6. Output Quality Standards

**Every Finding MUST Include**:

1. **File path and line number**: `src/components/Hero.tsx:42-48`
2. **Clear description**: What is the issue?
3. **Impact**: Why does this matter? (performance cost, security risk, etc.)
4. **Code example**: Before/after with specific fix
5. **Priority**: Critical / High / Medium / Low

**Example - High-Quality Finding**:

````markdown
### Issue: Infinite useEffect Loop

- **File**: `src/hooks/useCart.ts:23-27`
- **Severity**: Critical (P0)
- **Impact**: Component re-renders infinitely, causing browser freeze
- **Fix**:

  ```typescript
  // Before (infinite loop)
  useEffect(() => {
    setCount(count + 1);
  }, [count]);

  // After (correct)
  useEffect(() => {
    setCount((prevCount) => prevCount + 1);
  }, []);
  ```
````

````

### 7. Scoring & Metrics

**Consistent Scoring System**:
- **Start at 10 (perfect)**
- **Deduct points** based on issue severity:
  - Critical: -3 to -5 points
  - High: -1 to -2 points
  - Medium: -0.5 to -1 points
- **Add points** for excellent patterns: +0.5 to +1
- **Minimum score**: 1 (never 0 or negative)

**Be Objective**:
- Define clear criteria for each score range
- Explain score in executive summary
- Include confidence level when uncertain

### 8. Parallel Execution Strategy

**Orchestrator Pattern**:
```markdown
### Phase 3: Parallel Analysis
Invoke the following agents **in parallel** using a single message with multiple Task tool calls:
- performance-analyzer
- architecture-reviewer
- clean-code-auditor
- security-scanner
- testing-assessor
- accessibility-checker

**Important**: Do NOT wait for one agent to finish before invoking the next.
````

### 9. Agent Specialization Guidelines

**Single Responsibility**:

- Each agent should have **one clear focus**
- Don't create "swiss army knife" agents that do everything
- Prefer multiple specialized agents over one general agent

**Domain Expertise**:

- Agents should embody a **specific role** (Security Engineer, Performance Expert, etc.)
- Include domain-specific knowledge (WCAG for accessibility, OWASP for security)
- Reference industry standards and best practices

### 10. Testing & Validation

**Before Deploying an Agent**:

1. Test with **small PR** (< 100 lines)
2. Test with **medium PR** (200-500 lines)
3. Test with **large PR** (> 1000 lines)
4. Test with PR that has **no relevant changes**
5. Test with **malformed inputs** (invalid PR number, missing args)

**Verify**:

- Context file is created correctly
- Report is persisted to correct location
- Summary returned to orchestrator is concise
- No token budget exceeded errors
- Findings are actionable and specific

### 11. Documentation Requirements

**Agent Documentation MUST Include**:

- **Role statement**: Who is this agent?
- **When to use**: What triggers this agent?
- **Input format**: What arguments does it expect?
- **Output location**: Where does it write results?
- **Dependencies**: What tools/services does it require?
- **Examples**: Sample inputs and outputs

### 12. Anti-Patterns to Avoid

**❌ DON'T**:

- Pass large diffs between agents (use files)
- Return full analysis in agent response (persist to disk, return summary)
- Create agents with vague, overlapping responsibilities
- Use generic error messages ("Something went wrong")
- Demand perfection (100% test coverage, AAA security everywhere)
- Over-engineer simple solutions
- Write prompts at wrong altitude (too specific or too vague)

**✅ DO**:

- Use file-based communication for context
- Return concise summaries (< 200 words)
- Create focused, specialized agents
- Provide actionable error messages with remediation steps
- Be pragmatic (balance ideal vs realistic)
- Keep it simple (KISS principle)
- Structure prompts with clear sections and examples

---

## Continuous Improvement

This plugin follows an **iterative improvement** philosophy:

1. **Measure**: Track token usage, execution time, user feedback
2. **Analyze**: Identify bottlenecks and pain points
3. **Improve**: Refactor agents to be more efficient
4. **Validate**: Test improvements with real PRs

**Key Metrics to Monitor**:

- Token consumption per review
- Time to complete review
- Accuracy of findings (false positives vs true issues)
- User satisfaction

**When to Refactor an Agent**:

- Token usage consistently exceeds budget
- Users report irrelevant findings
- Agent frequently times out
- Findings lack actionable detail
