# ADR 006: Fix Session Management Architecture

**Status**: Proposed  
**Date**: 2025-11-06  
**Deciders**: Engineering Team  
**Context**: Investigation of broken session management in exito plugin

---

## Context and Problem Statement

The exito plugin's session management system is completely non-functional. Commands and agents reference `$CLAUDE_SESSION_ID` and `$COMMAND_TYPE` environment variables that don't exist, causing all file operations to fail with broken paths like `.claude/sessions/build//context.md`.

### Root Cause

The system was designed under the false assumption that `PreToolUse` hooks can set environment variables for subsequent command and agent executions. This is architecturally impossible in Claude Code:

1. **Hooks run in isolated shell processes** - they cannot affect the execution environment of other tools
2. **Environment variables are process-local** - exports in one process don't propagate to sibling processes
3. **Claude Code only provides `${CLAUDE_PLUGIN_ROOT}`** - no session management environment variables exist

### Current (Broken) Flow

```
User: /build "Add feature"
  ↓
PreToolUse Hook (session-manager.sh)
  ├─ export CLAUDE_SESSION_ID="build_xyz"  ← Only affects hook process
  └─ Process exits → Export lost
  ↓
Command (build.md) executes
  ├─ References $CLAUDE_SESSION_ID  ← UNDEFINED!
  └─ Path: .claude/sessions/build//context.md  ← BROKEN!
  ↓
System fails ❌
```

---

## Decision Drivers

1. **Must work with Claude Code's architecture** - Not against it
2. **Explicit > Implicit** - Clear where session IDs come from
3. **Simplicity** - Remove unnecessary complexity
4. **Maintainability** - Easy to understand and debug
5. **Elegance** - Solution should feel inevitable

---

## Considered Options

### Option 1: Try to Fix Hook-Based Approach

**Attempt**: Use hook output to modify tool input JSON, inject session ID into command environment.

**Analysis**: 
- ❌ No documented mechanism to modify command environment via hooks
- ❌ Would require undocumented/unsupported Claude Code internals
- ❌ Fragile and likely to break with updates
- ❌ Still fighting against the platform's design

**Verdict**: REJECTED - Architectural dead end

### Option 2: Use Global State File

**Approach**: Hook writes session ID to `.claude/current-session`, commands read it.

**Analysis**:
- ❌ Race conditions with parallel executions
- ❌ Cleanup complexity
- ❌ Still uses hooks unnecessarily
- ❌ Hidden state makes debugging harder
- 🟡 Would technically work but inelegant

**Verdict**: REJECTED - Works but ugly

### Option 3: Generate Session IDs in Commands (SELECTED)

**Approach**: Commands generate their own session IDs using `!` prefix bash execution, pass explicitly to agents.

**Analysis**:
- ✅ Uses only documented Claude Code features
- ✅ No environment variable assumptions
- ✅ Self-contained and explicit
- ✅ Works perfectly with parallel execution
- ✅ Easy to understand and debug
- ✅ Removes need for hooks and shared-utils.sh
- ✅ Elegant and simple

**Verdict**: ACCEPTED - The right way

---

## Decision Outcome

**Chosen Option**: **Option 3 - Generate Session IDs in Commands**

### Implementation Strategy

#### Commands Pattern

```markdown
---
description: "Command description"
---

# Generate unique session ID
!SESSION_ID="COMMAND_NAME_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/COMMAND_NAME/$SESSION_ID"

# Pass explicitly to agents
<Task agent="investigator">
  Task: $ARGUMENTS
  Session: $SESSION_ID
  Directory: .claude/sessions/COMMAND_NAME/$SESSION_ID
</Task>

# Later agents receive same session context
<Task agent="architect">
  Input: .claude/sessions/COMMAND_NAME/$SESSION_ID/context.md
  Session: $SESSION_ID
</Task>
```

#### Agents Pattern

```markdown
<input>
- `$1`: Task description with embedded session metadata
  - May contain "Session: session_id"
  - May contain "Directory: directory_path"
- Extract session info from $1 using pattern matching
</input>

<workflow>
### Step 1: Extract Session Context
Parse $1 for session information.
If present: Use provided session directory.
If absent: Work in current directory or generate temporary session.

### Step 2: Execute Task
Use session directory for all file operations.
</workflow>
```

---

## Consequences

### Positive

- ✅ **System actually works** - No more undefined variables
- ✅ **Self-documenting** - Read command to see session management
- ✅ **Simpler architecture** - Removes 4 scripts and hook complexity
- ✅ **Better debuggability** - Session IDs visible in command execution
- ✅ **Parallel-safe** - Each command invocation gets unique ID
- ✅ **Platform-aligned** - Uses Claude Code correctly
- ✅ **Maintainable** - Fewer moving parts
- ✅ **Portable** - No assumptions about undocumented features

### Negative

- 🟡 **Migration effort** - 8 commands + 27 agents to update
- 🟡 **Pattern change** - Team needs to learn new approach
- 🟡 **Slight verbosity** - Session ID generation visible in each command

### Neutral

- 📝 **Documentation updates** - AGENTS.md, QUICKREF.md, ADRs need updates
- 📝 **Code removal** - Can delete session-manager.sh, shared-utils.sh, etc.

---

## Migration Plan

### Phase 1: Proof of Concept (1 command)

1. Update `exito/commands/build.md` with new pattern
2. Update 3 agents it uses (investigator, architect, builder)
3. Test thoroughly
4. Validate parallel execution

### Phase 2: Rollout (Remaining commands)

5. Update remaining 7 commands
6. Update remaining 24 agents
7. Test each command individually

### Phase 3: Cleanup

8. Remove `exito/scripts/session-manager.sh`
9. Remove `exito/scripts/shared-utils.sh`
10. Remove `exito/scripts/validate-session.sh`
11. Remove PreToolUse hook from `exito/hooks/hooks.json`
12. Keep SessionEnd hook for cleanup (it still works for cleanup)

### Phase 4: Documentation

13. Update `exito/AGENTS.md`
14. Update `exito/QUICKREF.md`
15. Update `.cursorrules`
16. Update `CLAUDE.md`
17. Add this ADR to documentation

---

## Validation

### Success Criteria

1. ✅ All commands execute without errors
2. ✅ Session directories created with correct paths
3. ✅ Agents can read/write context files
4. ✅ Parallel executions don't conflict
5. ✅ No references to undefined environment variables
6. ✅ No linter errors in updated files

### Test Cases

```bash
# Test 1: Basic execution
/build "Add feature X"
ls .claude/sessions/build/  # Should show timestamped directory

# Test 2: Parallel execution
/build "Feature A" &
/build "Feature B" &
wait
ls .claude/sessions/build/  # Should show two separate directories

# Test 3: Agent file operations
/build "Test"
cat .claude/sessions/build/build_*/context.md  # Should have content

# Test 4: End-to-end workflow
/workflow "Implement auth"
# Should complete all phases without errors
```

---

## Related Decisions

- **ADR 001**: File-Based Context Sharing (still valid, complements this)
- **ADR 002**: Adaptive Research Depth (unaffected)
- **ADR 004**: Session Management Strategy (superseded by this ADR)
- **ADR 005**: Model Selection Policy (unaffected)

---

## Technical Notes

### Why Hooks Can't Set Environment Variables

Unix process model prevents environment variable propagation between sibling processes:

```
Parent Process (Claude Code)
│
├─ Process A (Hook)
│  └─ export VAR="value"  ← Dies when process exits
│
└─ Process B (Command)
   └─ echo $VAR  ← Empty! Different process, fresh environment
```

Hooks and commands are siblings, not parent-child. Environment variables only flow downward (parent → child), never sideways (sibling → sibling).

### Why This Solution Works

Uses `!` prefix bash execution in commands, which runs in the command's own execution context:

```markdown
!SESSION_ID="build_$(date +%Y%m%d_%H%M%S)"
```

This creates a bash variable that can be referenced later in the same command using `$SESSION_ID`. The variable exists for the duration of the command execution and can be passed to agents via their Task invocation.

---

## References

- **Full Investigation**: `.claude/sessions/investigation_claude_code_session_management.md`
- **Solution Summary**: `.claude/sessions/SOLUTION_SUMMARY.md`
- **Claude Code Plugin Reference**: `docs/claude-code-docs/plugins-reference.md`
- **Claude Code Hooks Documentation**: `docs/claude-code-docs/hooks.md`
- **Slash Commands Documentation**: `docs/claude-code-docs/slash-commands.md`

---

## Appendix: Steve Jobs' Design Principles Applied

This solution embodies Jobs' philosophy of great design:

1. **Simplicity**: 
   - OLD: Hooks → Scripts → Environment Variables → Validation
   - NEW: Command generates ID → Pass to agents
   - Removed 4 scripts, 1 hook configuration, shared utilities

2. **Clarity**:
   - OLD: "Where does $CLAUDE_SESSION_ID come from?" (Hidden in hook execution)
   - NEW: First line of command shows session ID generation

3. **Integration** (Technology + Liberal Arts):
   - OLD: Fighting against Claude Code's architecture
   - NEW: Working with the platform's design

4. **Inevitability**:
   - Once you understand Claude Code's process model, this solution feels obvious
   - The right answer should feel inevitable

> "Simple can be harder than complex: You have to work hard to get your thinking clean to make it simple. But it's worth it in the end because once you get there, you can move mountains." - Steve Jobs

We worked hard to understand the system, stripped away complexity that didn't belong, and arrived at a solution so simple it feels like it couldn't be any other way. That's craftsmanship.

---

**Decision Made By**: Investigation  
**Date**: 2025-11-06  
**Status**: Awaiting approval and implementation

