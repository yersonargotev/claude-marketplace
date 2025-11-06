# Exito Plugin - Quick Reference

**Version**: 1.0  
**Last Updated**: November 6, 2025

Quick reference for all Exito commands and common workflows.

---

## Commands Overview

| Command | Duration | Use For | Approvals |
|---------|----------|---------|-----------|
| `/patch` | 5-10 min | Quick fixes (< 50 lines) | None |
| `/implement` | 15-20 min | Known approach, fast delivery | 1 |
| `/build` | 25-35 min | Standard feature development | 1 |
| `/workflow` | 40-60 min | Systematic exploration + precision | 2 |
| `/craft` | 45-70 min | Excellence, "Think Different" | 2 |
| `/genesis` | 60-90 min | Greenfield, first principles | 2 |
| `/review` | 10-20 min | PR analysis (6 dimensions) | None |
| `/ui` | 30-45 min | Frontend/React/UX focus | 1 |
| `/pixel` | 40-60 min | Pixel-perfect UI iteration | Multiple |
| `/think` | 60-90 min | Maximum analysis + ULTRATHINK | 1 |

---

## Command Syntax

### Development Commands

```bash
# Quick fix
/patch Fix button alignment in Header

# Fast implementation
/implement Add user avatar upload feature

# Standard development
/build Implement shopping cart with persistence

# Systematic workflow
/workflow Optimize database query performance

# Excellence/craftsmanship
/craft Build real-time collaboration feature

# Greenfield from scratch
/genesis Create payment microservice with event sourcing

# Maximum analysis
/think Redesign authentication system with OAuth2
```

### Frontend Commands

```bash
# Frontend development
/ui Create product comparison table

# Pixel-perfect implementation
/pixel Implement dashboard from Figma design
```

### Review Commands

```bash
# PR review
/review https://github.com/org/repo/pull/123

# PR review with business validation
/review <PR_URL> <WORK_ITEM_URL_1> <WORK_ITEM_URL_2>

# Example with Azure DevOps
/review https://github.com/org/repo/pull/123 https://dev.azure.com/org/project/_workitems/edit/456
```

### Other Commands

```bash
# Research (standalone)
/research Best practices for WebSocket optimization

# UI refinement
/refine Improve accessibility of checkout form

# Execute pre-approved plan
/execute Implement approved architecture from design doc
```

---

## Common Workflows

### Bug Fix Workflow

```bash
# Simple bug
/patch Fix typo in validation message

# Complex bug
/build Fix race condition in payment processing
```

### Feature Development Workflow

```bash
# Known requirements
/build Add email notification system

# Need to explore options
/workflow Implement caching layer (explore Redis vs Memcached)

# Highest quality
/craft Build recommendation engine
```

### UI Development Workflow

```bash
# Standard UI
/ui Create user settings page

# High-fidelity mockup
/pixel Implement marketing landing page from design
```

### Refactoring Workflow

```bash
# Systematic refactoring
/workflow Refactor authentication to use middleware pattern

# Architecture redesign
/think Migrate from monolith to microservices
```

### Review Workflow

```bash
# 1. Get PR URL
# 2. Run review
/review <PR_URL>

# 3. Address findings
/patch Fix security issues identified in review

# 4. Re-review if needed
/review <PR_URL>
```

---

## Session Artifacts

All commands create session artifacts in `.claude/sessions/{command-type}/SESSION_ID/`:

| File | Description |
|------|-------------|
| `context.md` | Problem analysis, codebase research |
| `validation-report.md` | Requirements completeness check |
| `alternatives.md` | Solution options explored |
| `plan.md` | Detailed implementation plan |
| `progress.md` | Implementation log with decisions |
| `test_report.md` | Testing results |
| `review.md` | Code review findings |
| `.agent_log` | Agent execution timeline |

**Access artifacts**: Review these files for detailed information about any workflow step.

---

## Agent Roles

Agents are automatically invoked by commands. See [AGENTS.md](./AGENTS.md) for complete catalog.

### Core Agents

| Agent | Role | Used By |
|-------|------|---------|
| `investigator` | Deep codebase research | All development commands |
| `architect` | Solution design + planning | All development commands |
| `builder` | Implementation | `/build`, `/implement` |
| `surgical-builder` | Minimal edits, no comments | `/workflow`, `/craft` |
| `craftsman` | TDD, self-documenting code | `/craft`, `/genesis` |
| `validator` | Testing + QA | `/build`, `/workflow`, `/craft` |
| `auditor` | Multi-agent code review | `/build`, `/workflow`, `/craft` |

### Specialized Agents

| Agent | Role | Used By |
|-------|------|---------|
| `context-gatherer` | PR metadata collection | `/review` |
| `solution-explorer` | Generate 2-4 alternatives | `/workflow` |
| `visionary` | First principles approaches | `/craft`, `/genesis` |
| `requirements-validator` | Check completeness | `/workflow`, `/craft` |
| `feasibility-validator` | Validate ideas are achievable | `/craft`, `/genesis` |

### Review Agents (Parallel)

Used by `/review` and `/auditor`:

- `performance-analyzer` - React/Next.js optimization
- `architecture-reviewer` - Design patterns, SOLID
- `clean-code-auditor` - KISS, DRY, code smells
- `security-scanner` - OWASP Top 10, vulnerabilities
- `testing-assessor` - Coverage, quality, gaps
- `accessibility-checker` - WCAG, a11y compliance

---

## Best Practices

### Command Selection

- **Trivial (< 50 lines)**: `/patch`
- **Small (< 200 lines)**: `/implement` or `/build`
- **Medium (200-500 lines)**: `/build` or `/workflow`
- **Large (500+ lines)**: `/workflow`, `/craft`, or `/think`
- **Greenfield**: `/genesis`
- **UI work**: `/ui` or `/pixel`
- **Review**: Always `/review`

### Quality vs Speed

| Need | Command |
|------|---------|
| **Speed** | `/patch`, `/implement` |
| **Balance** | `/build`, `/ui` |
| **Quality** | `/workflow`, `/craft` |
| **Excellence** | `/craft`, `/genesis`, `/think` |

### Approval Checkpoints

Commands with **2 approvals** (`/workflow`, `/craft`, `/genesis`):
1. **After exploration**: Review alternatives, select approach
2. **After planning**: Review detailed plan, approve to proceed

Commands with **1 approval** (`/build`, `/implement`, `/ui`, `/think`):
1. **After planning**: Review plan, approve to proceed

### Session Management

Sessions are automatically managed via hooks:

- **PreToolUse**: Initializes session directory
- **SessionEnd**: Optional cleanup (artifacts preserved)

**Session ID**: Available in `$CLAUDE_SESSION_ID` environment variable

**Manual cleanup** (if needed):
```bash
rm -rf .claude/sessions/workflow/SESSION_ID
```

---

## Troubleshooting

### Common Issues

**Issue**: "No session ID found"  
**Fix**: Session hooks not configured. Check `exito/hooks/hooks.json`

**Issue**: "Cannot create session directory"  
**Fix**: Check permissions on `.claude/sessions/` directory

**Issue**: Command takes too long  
**Fix**: Use faster command (`/patch` > `/implement` > `/build`)

**Issue**: Too many changes at once  
**Fix**: Use `/workflow` for surgical precision

**Issue**: Need to explore options  
**Fix**: Use `/workflow`, `/craft`, or `/think` (all generate alternatives)

### Session Artifacts Missing

If session artifacts are missing:

1. Check `.claude/sessions/{command-type}/` for your session ID
2. Review `.agent_log` for errors
3. Re-run command if needed

### Agent Errors

If an agent fails:

1. Check error message in command output
2. Review `.agent_log` for details
3. Validate session environment manually:
   ```bash
   source exito/scripts/shared-utils.sh
   validate_session_environment "tasks"
   ```

---

## Advanced Usage

### Custom Workflows

Chain commands for complex workflows:

```bash
# Research → Design → Implement → Review
/research Serverless architecture patterns
# (review findings)
/workflow Design serverless API gateway
# (approve plan)
/review <PR_URL>
```

### Parallel Development

Use multiple sessions simultaneously:

```bash
# Terminal 1: Feature A
/workflow Implement user authentication

# Terminal 2: Feature B  
/ui Create dashboard components

# Both run in parallel with separate session IDs
```

### Context Modes

Some agents support context modes for adaptive behavior:

- `investigator`: `fast-mode`, `standard`, `deep-research`, `frontend-focus`
- `architect`: `quick-fix`, `fast-planning`, `frontend-planning`, `ultrathink`
- `builder`: `surgical`, `fast-mode`, `quick-fix`, `frontend-implementation`

These are automatically set by commands but can be overridden.

---

## Configuration

### Hooks

Session lifecycle hooks in `exito/hooks/hooks.json`:

```json
{
  "PreToolUse": "exito/scripts/session-manager.sh start",
  "SessionEnd": "exito/scripts/session-cleanup.sh"
}
```

### Shared Utilities

All agents use `exito/scripts/shared-utils.sh` for:
- Session validation
- Agent logging
- Error handling

Functions:
- `validate_session_environment <type>`
- `log_agent_start <agent-name>`
- `log_agent_complete <agent-name> <status>`
- `log_agent_error <agent-name> <message>`

---

## Related Documentation

- **[Command Selection Guide](../docs/engineering/command-selection-guide.md)** - Detailed decision tree
- **[Agent Catalog](./AGENTS.md)** - Complete agent reference
- **[Agent Structure Standard](../docs/engineering/agent-structure-standard.md)** - How agents work
- **[Architecture Decision Records](../docs/engineering/adr/)** - Design decisions
- **[Claude Code Documentation](../docs/claude-code-docs/)** - Official docs

---

## Quick Tips

1. **Start conservative**: Use `/build`, escalate to `/workflow` if needed
2. **Review everything**: Always use `/review` before merging
3. **Session artifacts**: Review `.claude/sessions/` for detailed info
4. **Quality bar**: Match command to quality needs
5. **Iterations**: Fast commands for prototyping, thorough commands for production

---

**Need help?** 
- See [Command Selection Guide](../docs/engineering/command-selection-guide.md) for detailed guidance
- Check [AGENTS.md](./AGENTS.md) for agent details
- Review session artifacts in `.claude/sessions/`

**Feedback?** Update this document or create an issue.

---

*Built with craftsmanship. Every command feels inevitable.*

