#!/bin/bash
# Shared utility functions for all agents
# Part of the architectural improvement plan for consistency and maintainability

validate_session_environment() {
  local command_type="${1:-tasks}"
  
  # Validate session ID exists
  if [ -z "$CLAUDE_SESSION_ID" ]; then
    echo "❌ ERROR: No session ID found. Session hooks may not be configured properly."
    echo "   This agent requires a valid session ID from the CLAUDE_SESSION_ID environment variable."
    return 1
  fi
  
  # Set session directory path
  local session_dir=".claude/sessions/${command_type}/$CLAUDE_SESSION_ID"
  
  # Create session directory if it doesn't exist
  if [ ! -d "$session_dir" ]; then
    echo "📁 Creating session directory: $session_dir"
    mkdir -p "$session_dir" 2>/dev/null || {
      echo "❌ ERROR: Cannot create session directory. Check permissions."
      echo "   Attempted path: $session_dir"
      return 1
    }
  fi
  
  # Verify write permissions
  touch "$session_dir/.write_test" 2>/dev/null || {
    echo "❌ ERROR: No write permission to session directory"
    echo "   Path: $session_dir"
    return 1
  }
  rm "$session_dir/.write_test"
  
  # Export for other functions to use
  export SESSION_DIR="$session_dir"
  
  # Success confirmation
  echo "✓ Session environment validated"
  echo "  Session ID: $CLAUDE_SESSION_ID"
  echo "  Directory: $session_dir"
  
  return 0
}

log_agent_start() {
  local agent_name="$1"
  local session_dir="${SESSION_DIR:-.claude/sessions/tasks/$CLAUDE_SESSION_ID}"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  # Ensure log file exists
  mkdir -p "$session_dir" 2>/dev/null
  
  # Log agent start
  echo "${timestamp} | START | ${agent_name}" >> "$session_dir/.agent_log"
}

log_agent_complete() {
  local agent_name="$1"
  local status="${2:-SUCCESS}"
  local session_dir="${SESSION_DIR:-.claude/sessions/tasks/$CLAUDE_SESSION_ID}"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  # Ensure log file exists
  mkdir -p "$session_dir" 2>/dev/null
  
  # Log agent completion
  echo "${timestamp} | ${status} | ${agent_name}" >> "$session_dir/.agent_log"
}

log_agent_error() {
  local agent_name="$1"
  local error_message="$2"
  local session_dir="${SESSION_DIR:-.claude/sessions/tasks/$CLAUDE_SESSION_ID}"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  # Ensure log file exists
  mkdir -p "$session_dir" 2>/dev/null
  
  # Log error with details
  echo "${timestamp} | ERROR | ${agent_name} | ${error_message}" >> "$session_dir/.agent_log"
}

# Export functions for use in subshells
export -f validate_session_environment
export -f log_agent_start
export -f log_agent_complete
export -f log_agent_error

