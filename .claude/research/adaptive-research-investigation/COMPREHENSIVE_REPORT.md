# Adaptive Research System Investigation Report

**Date**: 2025-11-05
**Investigator**: Claude Code
**Topic**: Creating Research-Focused Commands and Agents with Task-Aware Intelligence

---

## Executive Summary

This report presents a comprehensive investigation into designing intelligent research systems for Claude Code plugins. The investigation reveals that **adaptive research strategies** dramatically improve efficiency by selecting appropriate research methods (local codebase analysis, online research, or hybrid) based on task type classification.

**Key Findings**:
1. The existing `/research` command provides excellent multi-source research but lacks task-aware adaptation
2. The `investigator` agent already implements adaptive research depth (fast-mode, standard, workflow-analysis)
3. A task classification system based on conventional commits provides clear routing logic
4. Research strategy should vary: fixes need local analysis, new features need both, refactors primarily local
5. Token optimization of 60-70% is achievable through file-based context sharing and adaptive strategies

**Primary Recommendation**: Implement a **Task Classifier Agent** that routes to specialized research agents based on task type, achieving optimal research depth and source selection.

---

## Table of Contents

1. [Current State Analysis](#current-state-analysis)
2. [Task Type Classification System](#task-type-classification-system)
3. [Research Strategy Patterns](#research-strategy-patterns)
4. [Architecture Design](#architecture-design)
5. [Implementation Recommendations](#implementation-recommendations)
6. [Code Examples](#code-examples)
7. [Best Practices](#best-practices)
8. [References](#references)

---

## Current State Analysis

### Existing Research Infrastructure

#### 1. `/research` Command
**Location**: `exito/commands/research.md`

**Capabilities**:
- Multi-source research (WebSearch, WebFetch, Grep, Glob, Read, Bash)
- Comprehensive reporting with structured output
- Session management (`.claude/sessions/research/`)
- Adaptive methodology notes in prompt

**Limitations**:
- Not task-aware (treats all research equally)
- No automatic strategy selection
- Manual invocation required
- Doesn't integrate with workflow commands

**Strengths**:
- Excellent report structure
- Good source citation
- Comprehensive methodology section
- Token-efficient (saves full report to file)

#### 2. `investigator` Agent
**Location**: `exito/agents/investigator.md`

**Capabilities**:
- Adaptive research depth via context modes:
  - `fast-mode`: 5-10 min, 5K-15K tokens (trivial/small)
  - `standard`: 10-20 min, 15K-30K tokens (small/medium)
  - `workflow-analysis`: 15-25 min, 25K-45K tokens (medium/large)
  - `frontend-focus`: 15-20 min, 20K-35K tokens (UI/UX specific)
  - `deep-research`: 30-40 min, 50K-80K tokens (critical/complex)
- Task classification by lines/files/keywords
- Progressive disclosure pattern
- Session validation and directory creation
- File-based context sharing

**Limitations**:
- Primarily local codebase focus (limited WebSearch use)
- Task classification is size-based, not type-based
- Doesn't distinguish between fix/feature/refactor for research strategy
- WebSearch tool listed but not actively used in workflow

**Strengths**:
- Excellent adaptive depth model
- Token-efficient output
- Clear classification criteria
- Session management built-in

#### 3. Workflow Command Integration

Different commands pass different context modes to investigator:

| Command | Context Mode | Research Depth | Use Case |
|---------|--------------|----------------|----------|
| `/patch` | `fast-mode` | Quick (5-10 min) | Simple bugs, small changes |
| `/implement` | `fast-mode` | Quick (5-10 min) | Rapid prototyping |
| `/build` | `standard` | Medium (10-20 min) | Complex features |
| `/workflow` | `workflow-analysis` | Deep (15-25 min) | Systematic problem-solving |
| `/ui` | `frontend-focus` | Medium (15-20 min) | UI/UX implementation |

**Key Insight**: Context modes enable adaptive research depth, but don't yet address **research source selection** (local vs online).

---

## Task Type Classification System

### Conventional Commit Types (Industry Standard)

Based on Conventional Commits specification and 2025 best practices:

| Type | Description | Research Needs | Primary Sources |
|------|-------------|----------------|-----------------|
| **feat** | New feature/functionality | High - needs patterns + current best practices | **Hybrid** (local patterns + online docs) |
| **fix** | Bug fix | Medium - needs error context + similar fixes | **Local** (codebase analysis, git history) |
| **refactor** | Code structure improvement | High - needs patterns + better approaches | **Hybrid** (local patterns + online best practices) |
| **perf** | Performance optimization | High - needs profiling + optimization techniques | **Hybrid** (local bottlenecks + online solutions) |
| **docs** | Documentation changes | Low - mostly local context | **Local** (existing docs, code comments) |
| **test** | Adding/updating tests | Medium - needs test patterns | **Local** (existing test patterns) |
| **style** | Formatting, cosmetic changes | Low - simple changes | **Local** (style guides, prettier config) |
| **chore** | Maintenance tasks | Low - straightforward work | **Local** (build config, dependencies) |
| **build** | Build system changes | Medium - needs tool documentation | **Hybrid** (local config + tool docs) |
| **ci** | CI/CD pipeline changes | Medium - needs platform docs | **Hybrid** (local pipelines + platform docs) |
| **revert** | Revert previous commit | Low - just undo | **Local** (git history) |

### Task Complexity Classification

Combine task type with complexity estimation:

```
Task Classification Matrix:

                 TRIVIAL    SMALL     MEDIUM    LARGE     VERY_LARGE
                 (<50 loc)  (<200)    (200-500) (500-1K)  (>1000)
┌────────────────┬──────────┬─────────┬─────────┬─────────┬────────────┐
│ feat           │ Local    │ Hybrid  │ Hybrid  │ Hybrid  │ Hybrid     │
│ fix            │ Local    │ Local   │ Local   │ Hybrid  │ Hybrid     │
│ refactor       │ Local    │ Local   │ Hybrid  │ Hybrid  │ Hybrid     │
│ perf           │ Local    │ Hybrid  │ Hybrid  │ Hybrid  │ Hybrid     │
│ docs           │ Local    │ Local   │ Local   │ Local   │ Hybrid     │
│ test           │ Local    │ Local   │ Local   │ Hybrid  │ Hybrid     │
│ style/chore    │ Local    │ Local   │ Local   │ Local   │ Local      │
│ build/ci       │ Local    │ Hybrid  │ Hybrid  │ Hybrid  │ Hybrid     │
└────────────────┴──────────┴─────────┴─────────┴─────────┴────────────┘

Legend:
  Local  = Codebase analysis only (Read, Grep, Glob, Bash(git/gh))
  Hybrid = Local + Online research (+ WebSearch, WebFetch, MCP tools)
```

### Keyword-Based Classification

**Automatic Task Type Detection** (from user input):

```yaml
feat_keywords:
  - "add feature"
  - "new functionality"
  - "implement"
  - "create new"
  - "add support for"
  - "introduce"

fix_keywords:
  - "fix bug"
  - "resolve issue"
  - "correct"
  - "repair"
  - "patch"
  - "debug"

refactor_keywords:
  - "refactor"
  - "restructure"
  - "reorganize"
  - "improve structure"
  - "clean up"
  - "optimize code"

perf_keywords:
  - "optimize"
  - "performance"
  - "speed up"
  - "reduce load time"
  - "improve efficiency"

docs_keywords:
  - "document"
  - "add comments"
  - "update readme"
  - "write docs"

test_keywords:
  - "add test"
  - "test coverage"
  - "unit test"
  - "integration test"

style_keywords:
  - "format"
  - "style"
  - "prettier"
  - "lint"
  - "cosmetic"

chore_keywords:
  - "update dependencies"
  - "maintenance"
  - "chore"
  - "housekeeping"

build_keywords:
  - "build config"
  - "webpack"
  - "vite"
  - "package.json"

ci_keywords:
  - "ci/cd"
  - "github actions"
  - "pipeline"
  - "deploy"
```

---

## Research Strategy Patterns

### Strategy 1: Local-Only Research

**When to Use**:
- Small bug fixes
- Style/formatting changes
- Simple refactors
- Documentation updates
- Test additions (following existing patterns)

**Tools**:
- `Read`: Targeted file reading
- `Grep`: Pattern searching in codebase
- `Glob`: File discovery
- `Bash(git:*)`: Git history analysis
- `Bash(gh:*)`: GitHub metadata (issues, PRs)

**Workflow Pattern**:

```markdown
### Step 1: Understand Problem Context
- Parse task description
- Identify files/modules involved
- Check git history for recent changes

### Step 2: Map Local Patterns
- Find similar implementations
- Identify coding conventions
- Review test patterns
- Check error handling approaches

### Step 3: Analyze Dependencies
- Map internal dependencies
- Identify integration points
- Check for breaking changes

### Step 4: Create Context Document
- Write to session file
- Include: patterns found, files to modify, risks
- Keep concise (500-1500 words for fast tasks)
```

**Example Tasks**:
- "Fix button color on homepage" → Local only
- "Add logging to auth service" → Local only
- "Update test for UserService" → Local only

### Strategy 2: Online-Only Research

**When to Use**:
- Technology evaluation (no existing codebase)
- Learning new patterns/frameworks
- Security vulnerability research
- Best practices investigation
- API/library documentation

**Tools**:
- `WebSearch`: Current information, best practices
- `WebFetch`: Retrieve documentation, articles
- Optional: MCP tools for specialized APIs

**Workflow Pattern**:

```markdown
### Step 1: Scope the Research Question
- Extract core topic
- Identify knowledge gaps
- Define success criteria

### Step 2: Multi-Source Research
- WebSearch for authoritative sources
- WebFetch for detailed docs
- Focus on official documentation, recent articles (2024-2025)

### Step 3: Synthesize Findings
- Compare approaches
- Note trade-offs
- Identify best practices vs anti-patterns

### Step 4: Generate Research Report
- Executive summary
- Detailed findings with sources
- Recommendations
- Save to session directory
```

**Example Tasks**:
- "Research state management options for React" → Online only
- "Best practices for JWT authentication" → Online only
- "Compare GraphQL vs REST" → Online only

### Strategy 3: Hybrid Research (Local + Online)

**When to Use**:
- New features (need local patterns + online best practices)
- Complex refactors (local code + better approaches)
- Performance optimization (local profiling + online solutions)
- Large fixes (local error context + online debugging techniques)
- Build/CI changes (local config + tool documentation)

**Tools**:
- All local tools (Read, Grep, Glob, Bash)
- All online tools (WebSearch, WebFetch)
- Optional: MCP tools

**Workflow Pattern**:

```markdown
### Phase 1: Local Context Gathering
- Analyze current implementation
- Identify patterns and conventions
- Map dependencies and integration points
- Document constraints

### Phase 2: Online Research
- Search for current best practices
- Find solutions to identified challenges
- Research new patterns/approaches
- Check for security considerations

### Phase 3: Synthesis
- Merge local constraints with online solutions
- Adapt best practices to existing patterns
- Identify gaps in current implementation
- Recommend approach that fits codebase

### Phase 4: Comprehensive Context Document
- Include local findings + online research
- Clear separation of sources
- Actionable recommendations
- Trade-offs documented
```

**Example Tasks**:
- "Add user authentication to app" → Hybrid (existing patterns + security best practices)
- "Refactor state management to use Zustand" → Hybrid (current state logic + Zustand docs)
- "Optimize React component rendering" → Hybrid (profiling data + React optimization techniques)

---

## Architecture Design

### Proposed System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      COMMAND LAYER                              │
│  /research-feat  /research-fix  /research-refactor  /research   │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                 TASK CLASSIFIER AGENT                            │
│  • Analyzes task description                                     │
│  • Detects task type (feat/fix/refactor/etc.)                   │
│  • Estimates complexity (trivial/small/medium/large)             │
│  • Selects research strategy (local/online/hybrid)               │
│  • Determines research depth (fast/standard/deep)                │
└────────────────────────┬────────────────────────────────────────┘
                         │
            ┌────────────┼────────────┐
            │            │            │
            ▼            ▼            ▼
┌───────────────┐ ┌───────────┐ ┌──────────────────┐
│ LOCAL         │ │ ONLINE    │ │ HYBRID           │
│ RESEARCHER    │ │ RESEARCHER│ │ RESEARCHER       │
│               │ │           │ │                  │
│ Tools:        │ │ Tools:    │ │ Tools:           │
│ • Read        │ │ • WebSrc  │ │ • All local      │
│ • Grep        │ │ • WebFtch │ │ • All online     │
│ • Glob        │ │ • MCP     │ │ • MCP            │
│ • Bash(git)   │ │           │ │                  │
│ • Bash(gh)    │ │           │ │                  │
└───────┬───────┘ └─────┬─────┘ └────────┬─────────┘
        │               │                │
        └───────────────┼────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────────┐
│                  SYNTHESIS AGENT                                 │
│  • Combines findings from all sources                            │
│  • Creates unified context document                              │
│  • Generates recommendations                                     │
│  • Outputs concise summary                                       │
└─────────────────────────────────────────────────────────────────┘
```

### Agent Specifications

#### 1. Task Classifier Agent

**Purpose**: Analyze task and route to appropriate research strategy

```markdown
---
name: task-classifier
description: "Analyzes task description and selects optimal research strategy"
tools: ""  # No tools needed, pure reasoning
model: claude-sonnet-4-5-20250929
---

<role>
You are a Task Classification Specialist. You analyze task descriptions and determine:
1. Task type (feat/fix/refactor/perf/docs/test/style/chore/build/ci)
2. Complexity level (trivial/small/medium/large/very_large)
3. Research strategy (local/online/hybrid)
4. Research depth (fast-mode/standard/workflow-analysis/deep-research)
</role>

<input>
- `$1`: Task description (user's request)
</input>

<workflow>
### Step 1: Task Type Detection
Analyze keywords in task description:
- Look for task type indicators (add, fix, refactor, optimize, etc.)
- Check for conventional commit keywords
- Default to "feat" if ambiguous

### Step 2: Complexity Estimation
Estimate scope based on:
- Number of components mentioned
- Scope indicators (single file, module, system-wide)
- Keywords: trivial, simple, complex, major, etc.
- Default to one level higher if uncertain

### Step 3: Research Strategy Selection
Use Task Classification Matrix:
- feat + small/medium/large → hybrid
- fix + trivial/small → local
- fix + large → hybrid
- refactor + medium/large → hybrid
- docs/test/style/chore → local
- perf/build/ci + medium/large → hybrid

### Step 4: Research Depth Selection
Map to context modes:
- trivial → fast-mode
- small → fast-mode or standard
- medium → standard
- large → workflow-analysis
- very_large → deep-research

### Step 5: Output Classification
Return structured classification with rationale
</workflow>

<output_format>
## Task Classification

**Task Type**: {feat|fix|refactor|perf|docs|test|style|chore|build|ci}
**Complexity**: {trivial|small|medium|large|very_large}
**Research Strategy**: {local|online|hybrid}
**Research Depth**: {fast-mode|standard|workflow-analysis|deep-research}

**Rationale**:
- Task Type: {why this type}
- Complexity: {estimation reasoning}
- Strategy: {why this research approach}
- Depth: {why this level of detail}

**Routing**:
- Invoke: {local-researcher|online-researcher|hybrid-researcher}
- Context Mode: {selected depth}
</output_format>
```

#### 2. Local Researcher Agent

**Purpose**: Codebase-focused research

```markdown
---
name: local-researcher
description: "Analyzes local codebase for patterns, conventions, and context"
tools: Read, Grep, Glob, Bash(git:*), Bash(gh:*)
model: claude-sonnet-4-5-20250929
---

<role>
You are a Codebase Intelligence Specialist. You analyze local codebases to discover:
- Existing patterns and conventions
- Similar implementations
- Integration points and dependencies
- Test patterns
- Code structure and organization
</role>

<specialization>
- Progressive disclosure (start broad, dive focused)
- Pattern recognition
- Dependency mapping
- Convention detection
- Git history analysis
</specialization>

<input>
- `$1`: Task description
- `$2`: Task type (feat/fix/refactor/etc.)
- `$3`: Context mode (fast-mode/standard/workflow-analysis/deep-research)
- `$4`: Session directory path
</input>

<workflow>
### Step 1: Validate Session Environment
{Use investigator agent's session validation pattern}

### Step 2: Understand Task Scope
- Parse task description
- Identify relevant modules/files
- Determine search strategy

### Step 3: Progressive Codebase Analysis
Adapt depth based on $3 context mode:

**fast-mode**:
- Quick pattern search
- 1-2 key files
- 5-10 minutes

**standard**:
- Map 3-5 relevant files
- Check similar implementations
- Review test patterns
- 10-20 minutes

**workflow-analysis**:
- Comprehensive exploration
- Map 5-10 files
- Deep pattern analysis
- Architecture understanding
- 15-25 minutes

**deep-research**:
- Strategic sampling
- Critical path focus
- Risk assessment
- Cross-module dependencies
- 30-40 minutes

### Step 4: Map Patterns & Conventions
- Architectural patterns
- Code conventions (naming, structure)
- Testing patterns
- Error handling approaches
- State management

### Step 5: Analyze Dependencies
- Tech stack
- Internal dependencies
- External dependencies
- Integration points

### Step 6: Create Context Document
Write to: `$4/context.md`

Include:
- Problem statement
- Codebase landscape
- Existing patterns
- Constraints & dependencies
- Integration points
- Risk assessment
- Recommendations
- Files to review

### Step 7: Return Summary
Concise summary (< 200 words):
- Key findings
- Patterns identified
- Risks
- Context document location
</workflow>

<output_format>
## Local Research Complete ✓

**Task**: {task description}
**Session**: {session directory}
**Task Type**: {type}
**Complexity**: {level}

**Key Findings**:
- {2-3 most important discoveries}

**Patterns Identified**:
- {1-2 relevant patterns}

**Risks**:
- {Critical risks if any}

**Context Document**: `{session_dir}/context.md` (ready for planning)

✓ Ready for next phase
</output_format>
```

#### 3. Online Researcher Agent

**Purpose**: Web-based research for best practices and documentation

```markdown
---
name: online-researcher
description: "Performs web research for best practices, documentation, and current approaches"
tools: WebSearch, WebFetch, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a Technical Research Specialist. You conduct comprehensive online research to discover:
- Current best practices (2024-2025)
- Official documentation
- Security considerations
- Performance optimization techniques
- Industry standards and patterns
</role>

<specialization>
- Multi-source intelligence gathering
- Documentation synthesis
- Best practice identification
- Trade-off analysis
- Source credibility assessment
</specialization>

<input>
- `$1`: Research topic/question
- `$2`: Task type (feat/fix/refactor/etc.)
- `$3`: Context mode (determines research depth)
- `$4`: Session directory path
</input>

<workflow>
### Step 1: Scope Research Question
- Extract core topic
- Identify specific knowledge gaps
- Define what constitutes success

### Step 2: Conduct Web Research
Adapt depth based on $3 context mode:

**fast-mode**:
- 1-2 WebSearch queries
- Focus on official docs
- Quick answers
- 5-10 minutes

**standard**:
- 2-4 WebSearch queries
- Official docs + established blogs
- Best practices review
- 10-20 minutes

**workflow-analysis**:
- 4-6 WebSearch queries
- Multiple authoritative sources
- Deep dive into alternatives
- Trade-off analysis
- 15-25 minutes

**deep-research**:
- 6-10 WebSearch queries
- Comprehensive source review
- Research papers if applicable
- Security/performance deep dive
- Expert opinions
- 30-40 minutes

### Step 3: Prioritize Authoritative Sources
- Official documentation (primary)
- Recent articles (2024-2025)
- Established technical blogs
- Research papers
- Community best practices

### Step 4: Synthesize Findings
- Key themes and patterns
- Competing approaches
- Best practices vs anti-patterns
- Security considerations
- Performance implications

### Step 5: Create Research Report
Write to: `$4/online_research.md`

Structure:
- Executive summary
- Research methodology
- Key findings (with sources)
- Analysis
- Recommendations
- References

### Step 6: Return Summary
Concise summary (< 200 words):
- Top 3 findings
- Primary recommendation
- Report location
</output_format>

<output_format>
## Online Research Complete ✓

**Topic**: {research topic}
**Session**: {session directory}
**Sources Analyzed**: {count}

**Top Findings**:
1. {Finding with source}
2. {Finding with source}
3. {Finding with source}

**Primary Recommendation**:
{Clear, actionable recommendation with rationale}

**Research Report**: `{session_dir}/online_research.md`

**Sources**:
- ✓ Official docs: {count}
- ✓ Recent articles (2024-2025): {count}
- ✓ Technical resources: {count}

✓ Ready for synthesis
</output_format>
```

#### 4. Hybrid Researcher Agent (Orchestrator)

**Purpose**: Coordinate local + online research and synthesize

```markdown
---
name: hybrid-researcher
description: "Orchestrates local and online research, then synthesizes findings"
tools: Task, Read, Write
model: claude-sonnet-4-5-20250929
---

<role>
You are a Research Orchestrator. You coordinate parallel research from multiple sources and synthesize findings into actionable context.
</role>

<input>
- `$1`: Task description
- `$2`: Task type (feat/fix/refactor/etc.)
- `$3`: Context mode (research depth)
- `$4`: Session directory path
</input>

<workflow>
### Step 1: Initiate Parallel Research
Invoke both researchers in parallel (single message, multiple Task calls):

**Local Research**:
Invoke `local-researcher` with: $1 $2 $3 $4

**Online Research**:
Invoke `online-researcher` with: $1 $2 $3 $4

Wait for both to complete.

### Step 2: Read Research Outputs
- Read: `$4/context.md` (local findings)
- Read: `$4/online_research.md` (online findings)

### Step 3: Synthesize Findings
Merge insights:
- Map local constraints to online best practices
- Identify gaps in current implementation
- Adapt recommendations to existing patterns
- Note security/performance considerations
- Document trade-offs

### Step 4: Create Unified Context
Write to: `$4/unified_context.md`

Structure:
- Task overview
- Local findings (what exists)
- Online findings (what's recommended)
- Synthesis (how to apply)
- Recommended approach
- Implementation considerations
- Risks and mitigations
- Next steps

### Step 5: Return Summary
Concise summary combining both sources
</workflow>

<output_format>
## Hybrid Research Complete ✓

**Task**: {task description}
**Session**: {session directory}
**Research Strategy**: Local + Online

**Local Findings**:
- {key local insights}

**Online Findings**:
- {key best practices}

**Synthesis**:
{How online best practices map to local constraints}

**Recommended Approach**:
{Clear path forward that balances both}

**Unified Context**: `{session_dir}/unified_context.md`

**Sources**:
- ✓ Codebase analysis: {files examined}
- ✓ Web research: {sources consulted}

✓ Ready for planning
</output_format>
```

---

## Implementation Recommendations

### Phase 1: Foundation (Week 1)

**Priority**: High
**Effort**: Medium

1. **Create Task Classifier Agent**
   - File: `exito/agents/task-classifier.md`
   - Pure reasoning agent (no tools)
   - Outputs structured classification
   - Test with various task descriptions

2. **Enhance Investigator Agent**
   - Location: `exito/agents/investigator.md`
   - Add task type parameter
   - Integrate task-based research strategy selection
   - Keep existing adaptive depth logic
   - Add WebSearch tool usage for hybrid research

3. **Testing**
   - Test classifier with 20+ diverse task descriptions
   - Verify routing logic accuracy
   - Validate output format

### Phase 2: Specialized Researchers (Week 2)

**Priority**: High
**Effort**: High

1. **Create Local Researcher Agent**
   - File: `exito/agents/local-researcher.md`
   - Fork from investigator agent
   - Optimize for codebase-only analysis
   - Remove online research logic

2. **Create Online Researcher Agent**
   - File: `exito/agents/online-researcher.md`
   - Based on existing `/research` command
   - No codebase tools
   - Focused on WebSearch + WebFetch

3. **Create Hybrid Researcher Agent**
   - File: `exito/agents/hybrid-researcher.md`
   - Orchestrates local + online in parallel
   - Synthesizes findings
   - Creates unified context

4. **Testing**
   - Test each agent independently
   - Verify file outputs
   - Check token usage
   - Validate synthesis quality

### Phase 3: Task-Specific Commands (Week 3)

**Priority**: Medium
**Effort**: Low

1. **Create Convenience Commands**
   - `/research-feat` → Routes to hybrid research
   - `/research-fix` → Routes to local research
   - `/research-refactor` → Routes to hybrid research
   - All commands can override with explicit strategy

2. **Update Existing Commands**
   - `/build` → Add task classifier invocation before investigator
   - `/workflow` → Add task classifier invocation before investigator
   - `/implement` → Add task classifier invocation before investigator
   - `/patch` → Keep fast-mode but add type detection

3. **Documentation**
   - Add to plugin README
   - Create usage examples
   - Document task type keywords

### Phase 4: Optimization (Week 4)

**Priority**: Low
**Effort**: Low

1. **Token Usage Monitoring**
   - Add token usage reporting to agents
   - Track savings from adaptive strategies
   - Optimize prompts

2. **Caching Strategy**
   - Cache common research patterns
   - Cache frequently accessed documentation
   - Implement session resume capability

3. **Performance Tuning**
   - Parallel execution optimization
   - Reduce redundant searches
   - Improve synthesis speed

### Phase 5: Advanced Features (Future)

**Priority**: Low
**Effort**: High

1. **Learning from History**
   - Analyze past research sessions
   - Build pattern library
   - Suggest similar past solutions

2. **MCP Integration**
   - Integrate specialized MCP servers
   - Add domain-specific research tools
   - Support custom research workflows

3. **Interactive Refinement**
   - Allow users to request deeper research
   - Support iterative exploration
   - Add "research more about X" capability

---

## Code Examples

### Example 1: Unified Research Command

Create a master command that uses task classifier:

```markdown
---
description: "Intelligent research that adapts to task type (feat/fix/refactor/etc.)"
argument-hint: "Describe the task or question"
allowed-tools: Task
model: claude-sonnet-4-5-20250929
---

# Adaptive Research Assistant

I'll analyze your task and select the optimal research strategy.

## Task: $ARGUMENTS

---

## Phase 1: Task Classification 🎯

Analyzing task type and requirements...

<Task agent="task-classifier">
  $ARGUMENTS
</Task>

---

## Phase 2: Research Execution 🔍

{Based on classifier output, route to appropriate researcher}

{If local-only}:
<Task agent="local-researcher">
  $ARGUMENTS
  {task-type}
  {context-mode}
  .claude/sessions/research/$CLAUDE_SESSION_ID
</Task>

{If online-only}:
<Task agent="online-researcher">
  $ARGUMENTS
  {task-type}
  {context-mode}
  .claude/sessions/research/$CLAUDE_SESSION_ID
</Task>

{If hybrid}:
<Task agent="hybrid-researcher">
  $ARGUMENTS
  {task-type}
  {context-mode}
  .claude/sessions/research/$CLAUDE_SESSION_ID
</Task>

---

## Research Complete ✅

**Task Type**: {detected-type}
**Strategy Used**: {local|online|hybrid}
**Research Depth**: {fast|standard|workflow|deep}

**Session Directory**: `.claude/sessions/research/$CLAUDE_SESSION_ID/`

**Artifacts**:
- Context document with findings
- {Online research report if applicable}
- {Unified synthesis if hybrid}

**Summary**:
{Agent return summary}

**Next Steps**:
{Recommended actions based on research}
```

### Example 2: Enhanced /build Command

```markdown
---
description: "Universal senior engineer with intelligent research"
argument-hint: "Describe the feature or problem to solve"
allowed-tools: Task
---

# Universal Senior Engineer

## Task: $ARGUMENTS

---

## Phase 0: Task Analysis 🎯

Understanding task type and requirements...

<Task agent="task-classifier">
  $ARGUMENTS
</Task>

---

## Phase 1: Research 🔍

{Route to appropriate researcher based on classifier output}

{If task-type = fix AND complexity = small}:
<Task agent="local-researcher">
  $ARGUMENTS
  fix
  fast-mode
  .claude/sessions/build/$CLAUDE_SESSION_ID
</Task>

{If task-type = feat}:
<Task agent="hybrid-researcher">
  $ARGUMENTS
  feat
  standard
  .claude/sessions/build/$CLAUDE_SESSION_ID
</Task>

{Continue with existing /build workflow...}
```

### Example 3: Task-Specific Research Commands

```markdown
# /research-feat - Feature Research
---
description: "Research for new features (local patterns + online best practices)"
argument-hint: "Describe the feature"
allowed-tools: Task
---

Researching feature implementation approaches...

<Task agent="hybrid-researcher">
  $ARGUMENTS
  feat
  standard
  .claude/sessions/research/$CLAUDE_SESSION_ID
</Task>
```

```markdown
# /research-fix - Bug Fix Research
---
description: "Research for bug fixes (local codebase analysis + git history)"
argument-hint: "Describe the bug"
allowed-tools: Task
---

Investigating bug and finding similar fixes...

<Task agent="local-researcher">
  $ARGUMENTS
  fix
  fast-mode
  .claude/sessions/research/$CLAUDE_SESSION_ID
</Task>
```

```markdown
# /research-refactor - Refactoring Research
---
description: "Research for refactoring (local structure + better approaches)"
argument-hint: "Describe the refactoring"
allowed-tools: Task
---

Analyzing current structure and researching improvements...

<Task agent="hybrid-researcher">
  $ARGUMENTS
  refactor
  workflow-analysis
  .claude/sessions/research/$CLAUDE_SESSION_ID
</Task>
```

### Example 4: Task Classifier Implementation

Complete agent definition:

```markdown
---
name: task-classifier
description: "Analyzes task description to determine type, complexity, and research strategy"
tools: ""
model: claude-sonnet-4-5-20250929
---

<role>
You are a Task Classification Specialist with expertise in software engineering task analysis.
</role>

<specialization>
- Task type identification (conventional commits)
- Complexity estimation
- Research strategy selection
- Context mode mapping
</specialization>

<input>
- `$1`: Task description (user's request)
</input>

<workflow>
### Step 1: Task Type Detection

Analyze `$1` for keywords and patterns:

**feat** (New features):
- Keywords: "add feature", "new functionality", "implement", "create new", "introduce"
- Indicators: Describes something that doesn't exist yet

**fix** (Bug fixes):
- Keywords: "fix bug", "resolve", "correct", "repair", "patch", "debug"
- Indicators: References error, issue, broken behavior

**refactor** (Code restructuring):
- Keywords: "refactor", "restructure", "reorganize", "improve structure", "clean up"
- Indicators: Changing code without changing behavior

**perf** (Performance optimization):
- Keywords: "optimize", "performance", "speed up", "reduce load time", "efficient"
- Indicators: Improving speed or resource usage

**docs** (Documentation):
- Keywords: "document", "add comments", "readme", "docs"
- Indicators: Only affecting documentation

**test** (Testing):
- Keywords: "add test", "test coverage", "unit test", "integration test"
- Indicators: Adding or modifying tests

**style** (Formatting):
- Keywords: "format", "style", "prettier", "lint", "cosmetic"
- Indicators: Visual/formatting only, no behavior change

**chore** (Maintenance):
- Keywords: "update dependencies", "maintenance", "chore", "housekeeping"
- Indicators: Routine tasks, no feature or fix

**build** (Build system):
- Keywords: "build config", "webpack", "vite", "package.json"
- Indicators: Build tool configuration

**ci** (CI/CD):
- Keywords: "ci/cd", "github actions", "pipeline", "deploy"
- Indicators: Automation pipeline changes

**Default**: If unclear, classify as "feat"

### Step 2: Complexity Estimation

Analyze scope indicators:

**TRIVIAL** (<50 lines, 1-2 files):
- Keywords: "color", "text", "constant", "simple", "quick", "minor"
- Scope: Single file, cosmetic, or config change

**SMALL** (<200 lines, <5 files):
- Keywords: "add", "fix", "update", "component", "function"
- Scope: Few files, clear pattern

**MEDIUM** (200-500 lines, 5-10 files):
- Keywords: "implement", "feature", "module", "refactor", "build"
- Scope: Multiple files, moderate complexity

**LARGE** (500-1000 lines, 10-20 files):
- Keywords: "redesign", "migrate", "overhaul", "system"
- Scope: System-wide, architectural impact

**VERY_LARGE** (>1000 lines, >20 files):
- Keywords: "rewrite", "platform", "complete", "major"
- Scope: Major overhaul, multi-system

**Rule**: When uncertain, default one level higher

### Step 3: Research Strategy Selection

Use classification matrix:

| Type | Trivial | Small | Medium | Large | Very Large |
|------|---------|-------|--------|-------|------------|
| feat | local | hybrid | hybrid | hybrid | hybrid |
| fix | local | local | local | hybrid | hybrid |
| refactor | local | local | hybrid | hybrid | hybrid |
| perf | local | hybrid | hybrid | hybrid | hybrid |
| docs | local | local | local | local | hybrid |
| test | local | local | local | hybrid | hybrid |
| style/chore | local | local | local | local | local |
| build/ci | local | hybrid | hybrid | hybrid | hybrid |

**Strategies**:
- **local**: Codebase analysis only
- **online**: Web research only (rare, mainly for tech evaluation)
- **hybrid**: Local + online research

### Step 4: Research Depth Mapping

Map complexity to context mode:

- TRIVIAL → `fast-mode`
- SMALL → `fast-mode` or `standard` (depends on task type)
- MEDIUM → `standard`
- LARGE → `workflow-analysis`
- VERY_LARGE → `deep-research`

**Special cases**:
- UI/UX tasks → `frontend-focus`
- Critical/security tasks → Upgrade one level

### Step 5: Generate Classification
</workflow>

<output_format>
## Task Classification

**Task Type**: {feat|fix|refactor|perf|docs|test|style|chore|build|ci}
**Complexity**: {trivial|small|medium|large|very_large}
**Research Strategy**: {local|online|hybrid}
**Research Depth**: {fast-mode|standard|workflow-analysis|frontend-focus|deep-research}

**Rationale**:

**Task Type Reasoning**:
{Why this type was selected, keywords found, patterns identified}

**Complexity Reasoning**:
{Estimated lines, files, scope indicators}

**Strategy Reasoning**:
{Why local/online/hybrid based on task type + complexity}

**Depth Reasoning**:
{Why this research depth is appropriate}

---

**Routing Instructions**:

**Invoke Agent**: {local-researcher|online-researcher|hybrid-researcher}

**Agent Parameters**:
- Task: `$1`
- Type: `{task-type}`
- Mode: `{context-mode}`
- Session: `.claude/sessions/{command}/$CLAUDE_SESSION_ID`

**Expected Outcome**:
{Brief description of what research should produce}
</output_format>

<error_handling>
- If task description is empty: Return error with usage example
- If classification is ambiguous: Default to higher complexity/hybrid strategy
- If multiple types detected: Choose primary type based on dominant keywords
</error_handling>

<best_practices>
1. **Err on comprehensive side**: Better to over-research than under-research
2. **Consider user intent**: "Quick fix" hints → fast-mode, "Thorough" hints → deeper
3. **Security-critical tasks**: Always upgrade research depth one level
4. **New developers**: May benefit from more online research for learning
</best_practices>
```

---

## Best Practices

### 1. Token Efficiency

**DO**:
- Use file-based context sharing (60-70% token savings)
- Write detailed findings to files
- Return concise summaries (< 200 words)
- Cache common patterns
- Use parallel execution when possible

**DON'T**:
- Pass large context between agents
- Duplicate content in messages
- Return full reports in agent responses
- Re-search for same information

### 2. Research Quality

**DO**:
- Cite all sources (URLs, file paths)
- Document reasoning and trade-offs
- Include code examples (before/after)
- Note date/version of information
- Cross-reference multiple sources

**DON'T**:
- Make assumptions without verification
- Ignore edge cases
- Skip constraint documentation
- Present single solution without alternatives

### 3. Adaptive Strategies

**DO**:
- Start with appropriate depth for task complexity
- Allow research scope expansion if needed
- Document when research is insufficient
- Recommend follow-up research if gaps exist

**DON'T**:
- Over-research trivial tasks
- Under-research critical tasks
- Use fixed research templates
- Ignore task context

### 4. User Experience

**DO**:
- Provide clear routing explanations
- Show research progress indicators
- Give actionable next steps
- Make session artifacts easy to find

**DON'T**:
- Leave users guessing about research strategy
- Hide important findings in long reports
- Forget to summarize for user
- Create confusing file structures

### 5. Error Handling

**DO**:
- Gracefully handle missing tools (WebSearch unavailable → local only)
- Provide fallbacks (online fails → local patterns)
- Document limitations clearly
- Suggest manual research if needed

**DON'T**:
- Fail silently
- Proceed with incomplete information
- Hide errors from user
- Give up without alternatives

---

## References

### Codebase Files Analyzed

1. **exito/commands/research.md** (300 lines)
   - Existing research command implementation
   - Multi-source research workflow
   - Comprehensive reporting structure

2. **exito/agents/investigator.md** (460 lines)
   - Adaptive research depth model
   - Task classification by size
   - Progressive disclosure pattern
   - Session management

3. **exito/commands/{workflow,build,implement,patch}.md**
   - Context mode usage patterns
   - Agent orchestration examples
   - User interaction patterns

4. **cc/skills/claude-code-plugin-builder/AGENTS.md** (977 lines)
   - Agent design best practices
   - Tool permissions
   - Output formats
   - Token optimization

5. **cc/skills/claude-code-plugin-builder/WORKFLOWS.md** (830 lines)
   - Multi-agent orchestration
   - Parallel execution patterns
   - File-based context sharing
   - Synthesis strategies

### Web Research Sources

1. **AI Agent Research Methodologies (2025)**
   - Paper2Agent framework
   - Multi-agent research lifecycle
   - Codebase analysis capabilities

2. **Agentic Workflow Patterns**
   - Task classification and routing
   - Adaptive planning patterns
   - Orchestration architectures
   - Hybrid workflow systems

3. **Conventional Commits Specification**
   - Official commit type definitions
   - Task type classification
   - Industry standard practices

### Key Insights from Research

1. **Token Optimization**: File-based context sharing achieves 60-70% token reduction vs message passing

2. **Adaptive Depth**: Research should scale with task complexity (fast-mode to deep-research)

3. **Task-Aware Routing**: Different task types need different research strategies (fix=local, feat=hybrid)

4. **Parallel Execution**: Independent research agents should run simultaneously for speed

5. **Synthesis Quality**: Combining local + online findings requires careful integration

---

## Appendices

### Appendix A: Task Classification Examples

| Task Description | Type | Complexity | Strategy | Depth |
|-----------------|------|------------|----------|-------|
| "Fix button color on homepage" | fix | trivial | local | fast-mode |
| "Add user authentication with JWT" | feat | medium | hybrid | standard |
| "Refactor state management to Zustand" | refactor | large | hybrid | workflow-analysis |
| "Optimize React component performance" | perf | medium | hybrid | standard |
| "Update README with API docs" | docs | small | local | fast-mode |
| "Add unit tests for UserService" | test | small | local | fast-mode |
| "Format code with Prettier" | style | trivial | local | fast-mode |
| "Update dependencies to latest" | chore | small | local | fast-mode |
| "Configure Vite build optimization" | build | medium | hybrid | standard |
| "Setup GitHub Actions CI/CD" | ci | medium | hybrid | standard |
| "Complete rewrite of auth system" | feat | very_large | hybrid | deep-research |

### Appendix B: Research Strategy Decision Tree

```
START
  │
  ├─ Is task about new tech evaluation? → YES → online-only
  │                                      → NO → Continue
  │
  ├─ What is task type?
  │   ├─ docs/style/chore → local-only
  │   ├─ fix (small/medium) → local-only
  │   ├─ test (small) → local-only
  │   └─ Other → Continue
  │
  ├─ What is complexity?
  │   ├─ trivial → local-only (unless feat/perf)
  │   ├─ small → local or hybrid (depending on type)
  │   └─ medium/large/very_large → hybrid
  │
  └─ Final Decision:
      ├─ feat (any size) → hybrid
      ├─ refactor (medium+) → hybrid
      ├─ perf (small+) → hybrid
      ├─ build/ci (small+) → hybrid
      └─ Everything else → local
```

### Appendix C: Session Directory Structure

```
.claude/sessions/
├── research/
│   └── {session-id}/
│       ├── classification.md        # Task classifier output
│       ├── context.md               # Local research findings
│       ├── online_research.md       # Online research findings
│       └── unified_context.md       # Hybrid synthesis
├── build/
│   └── {session-id}/
│       ├── classification.md
│       ├── context.md or unified_context.md
│       ├── plan.md
│       ├── progress.md
│       └── test_report.md
└── workflow/
    └── {session-id}/
        ├── classification.md
        ├── context.md or unified_context.md
        ├── alternatives.md
        ├── plan.md
        ├── progress.md
        └── final_report.md
```

### Appendix D: Tool Usage by Research Strategy

| Tool | Local | Online | Hybrid |
|------|-------|--------|--------|
| Read | ✓ | - | ✓ |
| Grep | ✓ | - | ✓ |
| Glob | ✓ | - | ✓ |
| Bash(git:*) | ✓ | - | ✓ |
| Bash(gh:*) | ✓ | - | ✓ |
| WebSearch | - | ✓ | ✓ |
| WebFetch | - | ✓ | ✓ |
| MCP tools | - | ✓ | ✓ |
| Write | ✓ | ✓ | ✓ |
| Task | - | - | ✓ |

---

## Next Steps

### Immediate Actions (This Week)

1. **Review & Validate**
   - Review this report with team
   - Validate classification matrix
   - Confirm research strategy mapping
   - Get stakeholder approval

2. **Prototype Task Classifier**
   - Create agent definition
   - Test with 20+ example tasks
   - Refine classification logic
   - Document edge cases

3. **Plan Implementation**
   - Break down into sprints
   - Assign ownership
   - Set milestones
   - Define success metrics

### Short-term (Next 2 Weeks)

1. **Implement Core Agents**
   - Task classifier
   - Local researcher
   - Online researcher
   - Hybrid researcher

2. **Integration Testing**
   - Test agent orchestration
   - Verify file outputs
   - Measure token usage
   - Validate synthesis quality

3. **Documentation**
   - User guides
   - Agent documentation
   - Command examples
   - Troubleshooting

### Medium-term (Next Month)

1. **Command Updates**
   - Enhance existing commands
   - Create convenience commands
   - Add task type detection
   - User feedback integration

2. **Optimization**
   - Token usage monitoring
   - Performance tuning
   - Caching strategy
   - Error handling improvements

3. **Training & Rollout**
   - Team training
   - Gradual rollout
   - User feedback collection
   - Iteration based on usage

---

**Report Completed**: 2025-11-05
**Next Review**: After Phase 1 implementation
**Contact**: Repository maintainers
