# ADR 004: Session Management Strategy

**Status**: Accepted  
**Date**: November 6, 2025

## Context

File-based context sharing requires reliable session management. We need consistent directory structure, validation, and lifecycle management.

## Decision

Implement shared utility script (`exito/scripts/shared-utils.sh`) with standardized session validation for all agents.

## Implementation

**Shared Utilities**:
```bash
validate_session_environment()  # Create/validate session dir
log_agent_start()              # Track agent invocations
log_agent_complete()           # Track completion/status
log_agent_error()              # Track errors
```

**Session Structure**:
```
.claude/sessions/{command-type}/{session-id}/
  ├── context.md
  ├── plan.md
  ├── progress.md
  ├── *_report.md
  └── .agent_log
```

**Lifecycle**:
1. `PreToolUse` hook: Initialize session
2. Agent execution: Log start/complete
3. `SessionEnd` hook: Optional cleanup

## Results

- **98.9% code reduction** (500+ duplicate lines → 100 shared)
- Consistent error messages
- Agent execution observability via `.agent_log`

## Related

- [ADR-001](./001-file-based-context-sharing.md) - Why file-based approach

