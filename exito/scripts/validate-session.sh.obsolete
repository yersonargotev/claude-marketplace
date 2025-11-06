#!/bin/bash
# Shared session validation for all exito agents
# Used by: builder, validator, auditor, investigator, architect, surgical-builder

# Validate session ID exists
if [ -z "$CLAUDE_SESSION_ID" ]; then
  echo "❌ ERROR: No session ID found. Session hooks may not be configured properly."
  exit 1
fi

# Set session directory (uses COMMAND_TYPE from parent command)
SESSION_DIR=".claude/sessions/${COMMAND_TYPE:-tasks}/$CLAUDE_SESSION_ID"

# Verify session directory exists (should be created by previous phases)
if [ ! -d "$SESSION_DIR" ]; then
  echo "📁 Creating session directory: $SESSION_DIR"
  mkdir -p "$SESSION_DIR" || {
    echo "❌ ERROR: Cannot create session directory. Check permissions."
    exit 1
  }
fi

# Verify write permissions
touch "$SESSION_DIR/.write_test" 2>/dev/null || {
  echo "❌ ERROR: No write permission to session directory"
  exit 1
}
rm "$SESSION_DIR/.write_test"

# Export for use by calling script
export SESSION_DIR

echo "✓ Session environment validated"
echo "  Session ID: $CLAUDE_SESSION_ID"
echo "  Directory: $SESSION_DIR"
