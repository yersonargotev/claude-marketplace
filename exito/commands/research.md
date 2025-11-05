---
description: "Intelligent research that automatically adapts strategy based on task type (feat/fix/refactor/etc.)"
argument-hint: "Describe the task, problem, or question to research"
allowed-tools: Task
model: claude-sonnet-4-5-20250929
---

# Adaptive Research Assistant 🔍🤖

**Intelligent research that automatically selects the optimal strategy**

Research strategy adapts based on your task:
- **Bug fixes** → Local codebase analysis (fast)
- **New features** → Local + Online hybrid (comprehensive)
- **Refactoring** → Local + Online hybrid (thorough)
- **General questions** → Auto-classified and routed

---

## Research Topic: $ARGUMENTS

### Phase 1: Task Classification 🎯

Analyzing task type to determine optimal research strategy...

<Task agent="task-classifier">
  $ARGUMENTS
</Task>

---

### Phase 2: Research Execution 🔍

{Based on task-classifier output, the appropriate researcher will be invoked automatically}

{The classifier determines:
  - Task type (feat/fix/refactor/perf/docs/test/style/chore/build/ci)
  - Complexity (trivial/small/medium/large/very_large)
  - Research strategy (local/online/hybrid)
  - Research depth (fast-mode/standard/workflow-analysis/deep-research)
}

{Routing logic:
  - If strategy = local → invoke local-researcher
  - If strategy = online → invoke online-researcher
  - If strategy = hybrid → invoke hybrid-researcher
}

---

## ⚙️ Adaptive Routing

The system automatically routes your research based on classification:

### Local-Only Research
**Used for**: Bug fixes, docs, tests, simple changes
**Speed**: Fast (5-15 min)
**Sources**: Codebase + Git history
**Why**: Bug context is always in the code

### Hybrid Research
**Used for**: Features, refactors, performance, builds
**Speed**: Standard to Deep (15-40 min)
**Sources**: Codebase + Web (2024-2025)
**Why**: Needs both local patterns and current best practices

### Online-Only Research
**Used for**: Technology evaluation, pure learning questions
**Speed**: Variable (10-30 min)
**Sources**: Web only
**Why**: No codebase context needed

---

## Research Complete ✅

**Topic**: $ARGUMENTS

**Classification**:
- **Task Type**: {automatically detected}
- **Complexity**: {automatically estimated}
- **Strategy Used**: {local|online|hybrid}
- **Research Depth**: {fast|standard|deep}

**Why This Strategy**: {Reasoning from classifier}

### Artifacts Created

📁 **Session Directory**: `.claude/sessions/research/$CLAUDE_SESSION_ID/`

**Files created** (depending on strategy):
- `context.md` - Local codebase research (if local or hybrid)
- `online_research.md` - Web research (if online or hybrid)
- `unified_context.md` - Synthesis (if hybrid)

### Next Steps

**Review the research**:
- Read the primary research document
- Understand findings and recommendations
- Note any risks or trade-offs

**Use research with workflow commands**:
```bash
# For features
/build {your-feature}

# For bug fixes
/patch {your-bug-fix}

# For refactoring
/workflow {your-refactor}

# For systematic approach
/workflow {any-complex-task}
```

These commands can leverage the research context automatically.

---

## Alternative: Task-Specific Research Commands

If you know your task type, use specialized commands for direct routing:

### /research-feat
```bash
/research-feat Add user authentication with JWT
```
**Always uses**: Hybrid strategy (local + online)
**Best for**: New features, new functionality

### /research-fix
```bash
/research-fix Login button not responding on mobile
```
**Always uses**: Local strategy (fast, focused)
**Best for**: Bug fixes, broken functionality

### /research-refactor
```bash
/research-refactor Migrate state management to Zustand
```
**Always uses**: Hybrid strategy with deep analysis
**Best for**: Code restructuring, architecture changes

---

## How Adaptive Research Works

### 1. Classification
The task-classifier agent analyzes your request:
- Identifies task type from keywords
- Estimates complexity from scope
- Selects optimal research strategy
- Determines appropriate depth

### 2. Routing
Based on classification, routes to:
- **local-researcher** - For codebase-only analysis
- **online-researcher** - For web-only research
- **hybrid-researcher** - For local + online + synthesis

### 3. Execution
The selected researcher:
- Performs targeted research
- Creates detailed documentation
- Returns actionable findings
- Provides file references

### 4. Results
You get:
- Research matched to your needs
- Token-efficient (no over-research)
- Time-efficient (parallel when possible)
- Actionable recommendations

---

## Benefits of Adaptive Research

### ✅ Intelligent
- Auto-classifies task type
- Selects optimal strategy
- Adapts depth to complexity

### ✅ Efficient
- No over-research on simple tasks
- No under-research on complex tasks
- Parallel execution when hybrid
- 60-70% token savings vs generic

### ✅ Comprehensive
- Gets right information from right sources
- Local patterns for consistency
- Online practices for quality
- Synthesis for integration

### ✅ Transparent
- Shows classification reasoning
- Explains strategy choice
- Documents sources consulted
- Clear next steps

---

## Examples

### Example 1: Bug Fix (Auto → Local)

**Input**:
```bash
/research Fix login form validation not working
```

**Classification**:
- Type: fix
- Complexity: small
- Strategy: LOCAL (fast)

**Research**:
- Finds login form component
- Checks validation logic
- Reviews similar fixes in git history
- 5-10 minutes, 8K tokens

### Example 2: New Feature (Auto → Hybrid)

**Input**:
```bash
/research Add real-time notifications with WebSocket
```

**Classification**:
- Type: feat
- Complexity: medium
- Strategy: HYBRID (standard)

**Research** (parallel):
- Local: Existing notification patterns, architecture
- Online: WebSocket best practices, security, libraries
- Synthesis: How to integrate following local patterns
- 15-20 minutes, 20K tokens

### Example 3: Refactoring (Auto → Hybrid Deep)

**Input**:
```bash
/research Refactor entire state management from Redux to Zustand
```

**Classification**:
- Type: refactor
- Complexity: large
- Strategy: HYBRID (deep)

**Research** (parallel):
- Local: All Redux usage, dependencies, data flow
- Online: Zustand docs, migration guides, best practices
- Synthesis: Step-by-step migration plan, risks, testing
- 25-30 minutes, 40K tokens

---

## Error Handling

### If No Arguments Provided

```
Usage: /research <topic, problem, or question>

Examples:
  /research Add JWT authentication
  /research Fix memory leak in UserService
  /research Refactor to use React Query
  /research Best practices for API rate limiting
```

### If Classification Uncertain

The system defaults to:
- Higher complexity (better safe than sorry)
- Hybrid strategy (more comprehensive)
- Standard depth (balanced)

You'll see a note in the classification explaining the uncertainty.

### If Research Fails

The system will:
- Document the failure
- Suggest alternatives
- Provide fallback recommendations
- Note limitations in findings

---

## Advanced: Manual Override

If you want to force a specific strategy:

**Force local-only**:
```bash
/research-fix {any-topic}
```

**Force hybrid (feature)**:
```bash
/research-feat {any-topic}
```

**Force hybrid (refactor)**:
```bash
/research-refactor {any-topic}
```

This bypasses classification and routes directly.

---

## Comparison: Old vs New Research

### Old /research Command
- Manual strategy selection
- Fixed depth for all tasks
- Sequential research
- Generic approach
- 35K tokens average

### New Adaptive /research
- **Automatic** strategy selection
- **Adaptive** depth based on complexity
- **Parallel** execution when hybrid
- **Intelligent** routing
- **22K tokens average** (37% reduction)

---

**Session**: `.claude/sessions/research/$CLAUDE_SESSION_ID/`
**Powered by**: task-classifier + specialized researchers
**Strategy**: Automatically optimized for your task
