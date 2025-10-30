#!/bin/bash
# Session Manager Hook for Claude Code
# Generates unique session IDs and manages session lifecycle
# Critical Fix #1: Centralized session ID generation

set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

# Parse tool name to check if it's a Task tool invocation
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')

# Check if this is a Task tool invocation (used by /inge, /senior, etc.)
if [[ "$TOOL_NAME" == "Task" ]]; then
    # Generate unique session ID with timestamp and random hash
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    
    # Generate random hash (different approach for Linux vs macOS)
    if command -v md5sum &> /dev/null; then
        # Linux
        RANDOM_HASH=$(echo "$TIMESTAMP$$RANDOM" | md5sum | cut -c1-6)
    else
        # macOS
        RANDOM_HASH=$(echo "$TIMESTAMP$$RANDOM" | md5 | cut -c1-6)
    fi
    
    SESSION_ID="task_${TIMESTAMP}_${RANDOM_HASH}"
    
    # Create session directory with full path
    SESSION_DIR=".claude/sessions/tasks/$SESSION_ID"
    mkdir -p "$SESSION_DIR"
    
    # Create session metadata file
    cat > "$SESSION_DIR/session_metadata.json" <<EOF
{
  "session_id": "$SESSION_ID",
  "created_at": "$(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S%z)",
  "command": "$TOOL_NAME",
  "status": "in_progress",
  "user": "$(whoami)",
  "working_directory": "$(pwd)",
  "git_branch": "$(git branch --show-current 2>/dev/null || echo 'N/A')"
}
EOF
    
    # Export session ID as environment variable for agents
    # Note: This sets it for the current process tree
    export CLAUDE_SESSION_ID="$SESSION_ID"
    
    # Also output to stderr so it appears in logs
    echo "✓ Session initialized: $SESSION_ID" >&2
    echo "  Directory: $SESSION_DIR" >&2
    
    # Output the export command for the shell
    echo "export CLAUDE_SESSION_ID=$SESSION_ID"
fi

# Pass through the original input unchanged
echo "$INPUT"

