# Obsolete Scripts

The following scripts are no longer used after the session management architecture refactoring (ADR-006):

## Obsolete Files

1. **session-manager.sh.obsolete** (formerly session-manager.sh)
   - **Why obsolete**: Tried to set environment variables via PreToolUse hooks, which doesn't work
   - **Replaced by**: Inline session ID generation in commands using `!SESSION_ID="command_$(date +%Y%m%d_%H%M%S)"`
   - **Date obsoleted**: 2025-11-06

2. **shared-utils.sh.obsolete** (formerly shared-utils.sh)
   - **Why obsolete**: Validated `$CLAUDE_SESSION_ID` and `$COMMAND_TYPE` environment variables that don't exist
   - **Replaced by**: Session extraction logic in each agent from `$1` input argument
   - **Date obsoleted**: 2025-11-06

3. **validate-session.sh.obsolete** (formerly validate-session.sh)
   - **Why obsolete**: Part of the environment variable-based session management approach
   - **Replaced by**: Explicit session directory validation in agents
   - **Date obsoleted**: 2025-11-06

## Still Active Scripts

- **session-cleanup.sh**: Still used by SessionEnd hook for cleanup
- **session-analytics.sh**: Still useful for analyzing session artifacts

## Migration Summary

**OLD Architecture** (Broken):
```
Hook (PreToolUse) → Sets $CLAUDE_SESSION_ID → ❌ Doesn't propagate to commands
```

**NEW Architecture** (Working):
```
Command → Generates SESSION_ID inline → Passes explicitly to agents
```

See ADR-006 and investigation documents in `.claude/sessions/` for complete details.

