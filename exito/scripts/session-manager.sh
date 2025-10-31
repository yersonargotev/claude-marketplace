#!/bin/bash
# Session Manager Hook for Claude Code
# Generates unique session IDs and manages session lifecycle
# Critical Fix #1: Centralized session ID generation
# Enhancement: Semantic naming with command + description + timestamp

set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

# Parse tool name to check if it's a Task tool invocation
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"')

# Sanitize description to be filesystem-safe
# Converts to lowercase, replaces spaces with hyphens, removes special chars, truncates to 30 chars
sanitize_description() {
    local desc="$1"
    # Convert to lowercase, replace spaces/underscores with hyphens
    desc=$(echo "$desc" | tr '[:upper:]' '[:lower:]' | tr ' _' '--')
    # Remove special characters except hyphens and alphanumeric
    desc=$(echo "$desc" | sed 's/[^a-z0-9-]//g')
    # Replace multiple consecutive hyphens with single hyphen
    desc=$(echo "$desc" | sed 's/--*/-/g')
    # Remove leading/trailing hyphens
    desc=$(echo "$desc" | sed 's/^-//; s/-$//')
    # Truncate to 30 characters
    desc=$(echo "$desc" | cut -c1-30)
    # Remove trailing hyphen if truncation created one
    desc=$(echo "$desc" | sed 's/-$//')
    echo "$desc"
}

# Extract agent name from Task parameters (if available)
# Task parameters may include agent name like "agent=investigator" or just "investigator"
extract_agent_name() {
    local params=$(echo "$INPUT" | jq -r '.parameters.agent // .parameters[0] // "task"' 2>/dev/null || echo "task")
    echo "$params"
}

# Extract description from Task parameters
# Looks for description or uses remaining parameters
extract_description() {
    local desc=$(echo "$INPUT" | jq -r '.parameters.description // .parameters[1] // ""' 2>/dev/null || echo "")
    if [[ -z "$desc" ]]; then
        # Try to extract from raw parameters string if JSON parsing didn't work
        desc=$(echo "$INPUT" | jq -r '.parameters | if type == "string" then . else "" end' 2>/dev/null || echo "")
    fi
    echo "$desc"
}

# Check if this is a Task tool invocation (used by /build, /think, /workflow, etc.)
if [[ "$TOOL_NAME" == "Task" ]]; then
    # Generate unique session ID with semantic naming: {agent}_{description}_{timestamp}
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

    # Extract context from Task parameters
    AGENT_NAME=$(extract_agent_name)
    RAW_DESCRIPTION=$(extract_description)

    # Sanitize description for filesystem safety
    if [[ -n "$RAW_DESCRIPTION" ]]; then
        SANITIZED_DESC=$(sanitize_description "$RAW_DESCRIPTION")
    else
        SANITIZED_DESC=""
    fi

    # Construct session ID with semantic naming
    # Format: {agent}_{description}_{timestamp}
    # Fallback: {agent}_task_{timestamp} if no description
    if [[ -n "$SANITIZED_DESC" ]]; then
        SESSION_ID="${AGENT_NAME}_${SANITIZED_DESC}_${TIMESTAMP}"
    else
        SESSION_ID="${AGENT_NAME}_task_${TIMESTAMP}"
    fi
    
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

