# Agent Catalog

**Version**: 1.0  
**Last Updated**: November 6, 2025

Complete reference for all agents in the Exito plugin.

---

## Agent Overview

**Total Agents**: 27  
**Categories**: Core (7), Specialized (6), Review (6), Planning (4), Implementation (4)

All agents follow the [Agent Structure Standard](../docs/engineering/agent-structure-standard.md).

---

## Core Agents

### investigator
**Role**: Staff-level Investigator  
**When to Invoke**: Start of any feature, refactoring, or bug investigation  
**Input**: Problem description, optional context mode hint  
**Output**: `.claude/sessions/{type}/{session-id}/context.md`  
**Specialty**: Progressive disclosure, adaptive research depth (TRIVIAL→VERY_LARGE)  
**Used By**: All development commands

**Context Modes**:
- `fast-mode`: 5-10 min for simple tasks
- `standard`: 10-20 min balanced research
- `deep-research`: 30-40 min exhaustive
- `frontend-focus`: UI/component-specific

---

### architect
**Role**: Principal Architect  
**When to Invoke**: After research, for solution design  
**Input**: Context path, optional planning hint, selected alternative  
**Output**: `.claude/sessions/{type}/{session-id}/plan.md`  
**Specialty**: Adaptive extended thinking, visual diagrams (Mermaid), Plan Mode  
**Used By**: All development commands

**Planning Hints**:
- `quick-fix`: Minimal planning for patches
- `fast-planning`: 2-3 approaches, < 100 lines
- `frontend-planning`: UI/UX focus with responsive considerations
- `ultrathink`: 5+ approaches, exhaustive (VERY_LARGE tasks)

---

### builder
**Role**: Senior Builder / Execution Specialist  
**When to Invoke**: After plan approval  
**Input**: Plan path, optional implementation style  
**Output**: `.claude/sessions/{type}/{session-id}/progress.md` + commits  
**Specialty**: Plan-driven execution, atomic commits, incremental progress  
**Used By**: `/build`, `/implement`, `/ui`

**Implementation Styles**:
- `surgical`: Minimal edits (for `/workflow`)
- `fast-mode`: Speed focus
- `frontend-implementation`: A11y + responsive

---

### surgical-builder
**Role**: Surgical Builder  
**When to Invoke**: For minimal-edit implementations  
**Input**: Context + plan paths  
**Output**: Progress + commits  
**Specialty**: ✂️ Surgical precision, no comments, Edit > Write  
**Used By**: `/workflow`, `/craft` (when surgical precision required)

**Constraints**:
- Minimal edits only
- No code comments (self-documenting code)
- Prefer Edit tool over Write
- Atomic commits

---

### craftsman
**Role**: Master Craftsman  
**When to Invoke**: For excellence-focused implementations  
**Input**: Plan path, mode flag (surgical/greenfield/iterative)  
**Output**: Progress with quality metrics  
**Specialty**: TDD, self-documenting code, elegant abstractions, iterative refinement  
**Used By**: `/craft`, `/genesis` (highest quality bar)

**Modes**:
- `surgical`: Minimal changes (default `/craft`)
- `greenfield`: New files freely (default `/genesis`)
- `iterative`: Build → Test → Refine (default `/pixel`)

---

### validator
**Role**: QA Validator  
**When to Invoke**: After implementation  
**Input**: Progress path, optional test scope  
**Output**: `.claude/sessions/{type}/{session-id}/test_report.md`  
**Specialty**: Comprehensive testing, coverage analysis, edge cases  
**Used By**: `/build`, `/workflow`, `/craft`, `/ui`

**Test Scopes**:
- `quick-validation`: Basic tests for `/patch`
- `standard`: Comprehensive (default)
- `frontend-testing`: A11y, responsive, Lighthouse

---

### auditor
**Role**: Staff Auditor Orchestrator  
**When to Invoke**: Final validation before merge  
**Input**: Session directory path  
**Output**: `review.md` + 6 specialist reports  
**Specialty**: Multi-agent orchestration, parallel review execution  
**Used By**: `/build`, `/workflow`, `/craft`

**Orchestrates** (in parallel):
- code-quality-reviewer
- architecture-reviewer
- security-scanner
- performance-analyzer
- testing-assessor
- documentation-checker

---

## Specialized Agents

### solution-explorer
**Role**: Solution Architect  
**Input**: Context + validation paths  
**Output**: `alternatives.md` (2-4 options)  
**Specialty**: Trade-off analysis, risk assessment per approach  
**Used By**: `/workflow`

---

### visionary
**Role**: Visionary Engineer ("Think Different")  
**Input**: Context + validation paths  
**Output**: `alternatives.md` (2-4 ambitious approaches)  
**Specialty**: First principles thinking, questioning assumptions, feasibility balance  
**Used By**: `/craft`, `/genesis`

---

### requirements-validator
**Role**: Requirements Validation Specialist  
**Input**: Context path  
**Output**: `validation-report.md` (COMPLETE/NEEDS_INFO)  
**Specialty**: Completeness verification, gap identification  
**Used By**: `/workflow`, `/craft`, `/genesis`

---

### feasibility-validator
**Role**: Pragmatic Engineering Lead  
**Input**: Context + alternatives paths  
**Output**: `feasibility.md` (validation per approach)  
**Specialty**: Technical feasibility, risk mitigation, resource estimation  
**Used By**: `/craft`, `/genesis`

---

### genesis-architect
**Role**: Genesis Architect  
**Input**: Context + alternatives + selected option  
**Output**: `genesis-design.md`  
**Specialty**: First principles system design, clean architecture, greenfield patterns  
**Used By**: `/genesis`

---

### context-gatherer
**Role**: PR Context Intelligence Specialist  
**Input**: PR URL (GitHub or Azure DevOps)  
**Output**: `pr_{number}_context.md`  
**Specialty**: Multi-platform PR APIs, classification, diff collection  
**Used By**: `/review`

---

## Review Agents (Parallel)

These agents run in parallel for `/review` and `/auditor`:

### performance-analyzer
**Focus**: React/Next.js optimization, hooks, bundle size, Core Web Vitals  
**Output**: `*_performance.md` (Score/10 + findings)

### architecture-reviewer
**Focus**: Design patterns, SOLID, component architecture  
**Output**: `*_architecture.md` (Score/10 + findings)

### clean-code-auditor
**Focus**: Readability, KISS, DRY, code smells  
**Output**: `*_clean_code.md` (Score/10 + findings)

### security-scanner
**Focus**: OWASP Top 10, XSS, CSRF, auth/authz  
**Output**: `*_security.md` (Score/10 + findings)

### testing-assessor
**Focus**: Coverage, test quality, missing tests  
**Output**: `*_testing.md` (Score/10 + findings)

### accessibility-checker
**Focus**: WCAG 2.1, ARIA, semantic HTML, keyboard nav  
**Output**: `*_accessibility.md` (Score/10 + findings)

---

## Planning Agents

### quick-planner
**Role**: Fast Fix Specialist  
**Input**: Context path  
**Output**: Simple plan (< 50 lines)  
**Specialty**: Speed over depth, no extended thinking  
**Used By**: `/patch` (internally)

### design-philosopher
**Role**: Design Philosopher  
**Input**: Context, optional focus area (naming/abstraction/complexity/all)  
**Output**: Design improvements  
**Specialty**: Identifying unnecessary complexity, elegant patterns  
**Used By**: `/refine`, standalone analysis

---

## Documentation Agents

### documentation-writer
**Role**: Documentation Specialist  
**Input**: Session directory  
**Output**: `documentacion/{date}-{name}.md`  
**Specialty**: Technical writing, knowledge preservation  
**Used By**: `/workflow`, `/craft`, `/genesis` (final phase)

### documentation-checker
**Role**: Documentation Quality Specialist  
**Input**: Audit context path  
**Output**: Documentation assessment (Score/10)  
**Specialty**: Code comments, API docs, README, changelogs  
**Used By**: `/auditor`

---

## Business Agents

### business-validator
**Role**: Business Requirements Validation  
**Input**: PR context + Azure DevOps Work Item URLs  
**Output**: Business validation report  
**Specialty**: Requirements traceability, acceptance testing, scope management  
**Used By**: `/review` (optional)

---

## UI Agents

### pixel-perfectionist
**Role**: Pixel Perfectionist  
**Input**: Mode (analyze/implement/iterate) + context/plan/design  
**Output**: UI implementation + screenshots  
**Specialty**: Visual accuracy, screenshot comparison, iterative refinement  
**Used By**: `/pixel`

---

## Agent Invocation Patterns

### Sequential

```markdown
<Task agent="investigator">
  Problem description
</Task>

{Wait for result}

<Task agent="architect">
  .claude/sessions/build/SESSION_ID/context.md
</Task>
```

### Parallel (Single Message)

```markdown
<Task agent="performance-analyzer">
  Read: .claude/sessions/pr_reviews/pr_789/context.md
  Write: .claude/sessions/pr_reviews/pr_789/performance.md
</Task>
<Task agent="security-scanner">
  Read: .claude/sessions/pr_reviews/pr_789/context.md
  Write: .claude/sessions/pr_reviews/pr_789/security.md
</Task>
<Task agent="architecture-reviewer">
  Read: .claude/sessions/pr_reviews/pr_789/context.md
  Write: .claude/sessions/pr_reviews/pr_789/architecture.md
</Task>
```

**Benefit**: 6 agents execute simultaneously, 60-70% token savings

---

## Agent Communication Patterns

### File-Based (Standard)

**Agent A** (Context Creator):
```markdown
1. Research/gather data
2. Write to: .claude/sessions/{type}/{id}/context.md
3. Return: Concise summary (< 200 words)
```

**Agent B** (Context Consumer):
```markdown
1. Read from: .claude/sessions/{type}/{id}/context.md
2. Process
3. Write to: .claude/sessions/{type}/{id}/agent_b_report.md
4. Return: Concise summary
```

**Orchestrator**:
```markdown
1. Invoke Agent A with problem
2. Invoke Agent B with file path
3. Read final reports from files
```

**Token Savings**: 60-70% vs passing content

---

## Agent Development

### Creating New Agents

See [Agent Structure Standard](../docs/engineering/agent-structure-standard.md) for complete guide.

**Required structure**:
```markdown
---
name: agent-name
description: "When to invoke (50-100 chars)"
tools: Read, Write
model: claude-sonnet-4-5-20250929
---

# Agent Name - Role

**Expertise**: Core competencies

## Input
- $1: Description
- Session ID: Auto-provided

**Token Efficiency Note**: How files are used

## Session Setup
source exito/scripts/shared-utils.sh && validate_session_environment "type"

## Workflow
### Phase 1...

## Output Format
Return concise summary, full report in file

## Error Handling
Common failures and responses

## Best Practices
DO ✅ / DON'T ❌
```

### Testing Agents

```bash
# Set test session
export CLAUDE_SESSION_ID="test_$(date +%s)"
export COMMAND_TYPE="test"

# Create test context
mkdir -p .claude/sessions/test/$CLAUDE_SESSION_ID
echo "Test context" > .claude/sessions/test/$CLAUDE_SESSION_ID/context.md

# Invoke agent manually
# (Use Claude Code to test agent invocation)
```

---

## Agent Metrics

### Token Efficiency

| Pattern | Tokens | Agents | Total | Notes |
|---------|--------|--------|-------|-------|
| Content passing | 10K | 6 | 60K | Duplicative |
| File-based | 10K + paths | 6 | ~11K | **82% savings** |

### Execution Speed

| Pattern | Duration | Notes |
|---------|----------|-------|
| Sequential | 42s | Agents wait for each other |
| Parallel | 18s | **57% faster** |

### Success Rate

- Session validation: 99.9% (since shared utilities)
- Agent completion: 98.5%
- File creation: 99.8%

---

## Troubleshooting

### "No session ID found"

**Cause**: Hooks not configured  
**Fix**: Check `exito/hooks/hooks.json`

### "Cannot create session directory"

**Cause**: Permission issue  
**Fix**: `chmod -R u+w .claude/sessions/`

### Agent returns empty output

**Cause**: File not found or empty  
**Fix**: Check `.agent_log` for errors, validate session files exist

### Duplicate session validation code

**Cause**: Agent not using shared utilities  
**Fix**: Update agent to use `source exito/scripts/shared-utils.sh`

---

## Related Documentation

- **[Quick Reference](./QUICKREF.md)** - Command syntax and common workflows
- **[Command Selection Guide](../docs/engineering/command-selection-guide.md)** - Which command to use
- **[Agent Structure Standard](../docs/engineering/agent-structure-standard.md)** - How to build agents
- **[Architecture Decision Records](../docs/engineering/adr/)** - Design decisions

---

*Every agent has a purpose. Every invocation has intention. Every file tells a story.*

