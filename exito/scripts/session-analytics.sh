#!/bin/bash
# Session Analytics
# Analyzes session metrics for observability and optimization

analyze_session() {
  local session_id="$1"
  
  if [ -z "$session_id" ]; then
    echo "Usage: analyze_session <session_id>"
    return 1
  fi
  
  # Find session directory
  local session_dir=$(find .claude/sessions -type d -name "$session_id" 2>/dev/null | head -1)
  
  if [ -z "$session_dir" ] || [ ! -d "$session_dir" ]; then
    echo "❌ Session not found: $session_id"
    return 1
  fi
  
  echo "# Session Analytics: $session_id"
  echo ""
  echo "**Location**: $session_dir"
  echo ""
  
  ## Agents Invoked
  if [ -f "$session_dir/.agent_log" ]; then
    echo "## Agents Invoked"
    echo ""
    grep "START" "$session_dir/.agent_log" | cut -d'|' -f3 | sort | uniq -c | \
      awk '{printf "- **%s**: %d invocation(s)\n", $2, $1}'
    echo ""
    
    ## Duration
    echo "## Duration"
    echo ""
    local start=$(head -1 "$session_dir/.agent_log" | cut -d'|' -f1)
    local end=$(tail -1 "$session_dir/.agent_log" | cut -d'|' -f1)
    echo "- **Start**: $start"
    echo "- **End**: $end"
    
    # Calculate duration if dates are valid
    if command -v gdate &> /dev/null; then
      local start_epoch=$(gdate -d "$start" +%s 2>/dev/null)
      local end_epoch=$(gdate -d "$end" +%s 2>/dev/null)
      if [ -n "$start_epoch" ] && [ -n "$end_epoch" ]; then
        local duration=$((end_epoch - start_epoch))
        echo "- **Duration**: ${duration}s"
      fi
    fi
    echo ""
    
    ## Agent Status
    echo "## Agent Status"
    echo ""
    local total=$(grep -c "START" "$session_dir/.agent_log")
    local success=$(grep -c "SUCCESS" "$session_dir/.agent_log")
    local errors=$(grep -c "ERROR" "$session_dir/.agent_log")
    echo "- **Total Started**: $total"
    echo "- **Successful**: $success"
    echo "- **Errors**: $errors"
    echo ""
  else
    echo "⚠️ No agent log found"
    echo ""
  fi
  
  ## Files Created
  echo "## Session Artifacts"
  echo ""
  local file_count=$(find "$session_dir" -type f ! -name ".agent_log" ! -name ".write_test" | wc -l | tr -d ' ')
  echo "- **Total Files**: $file_count"
  echo ""
  
  if [ "$file_count" -gt 0 ]; then
    echo "**Files**:"
    find "$session_dir" -type f ! -name ".agent_log" ! -name ".write_test" | \
      while read file; do
        local size=$(wc -c < "$file" | tr -d ' ')
        local name=$(basename "$file")
        echo "- \`$name\` (${size} bytes)"
      done
    echo ""
  fi
  
  ## Code Changes (if git repo)
  if git rev-parse --git-dir > /dev/null 2>&1; then
    echo "## Code Changes"
    echo ""
    
    # Find commits with this session ID
    local commits=$(git log --oneline --grep="$session_id" 2>/dev/null)
    
    if [ -n "$commits" ]; then
      local commit_count=$(echo "$commits" | wc -l | tr -d ' ')
      echo "- **Commits**: $commit_count"
      echo ""
      echo "**Commit History**:"
      echo "\`\`\`"
      echo "$commits"
      echo "\`\`\`"
      echo ""
      
      # Get file changes
      local first_commit=$(git log --grep="$session_id" --format=%H 2>/dev/null | tail -1)
      if [ -n "$first_commit" ]; then
        echo "**Files Modified**:"
        git diff --name-only "${first_commit}^..HEAD" 2>/dev/null | \
          while read file; do
            echo "- \`$file\`"
          done
        echo ""
      fi
    else
      echo "- No commits found for this session"
      echo ""
    fi
  fi
  
  ## Token Efficiency Estimate
  echo "## Token Efficiency"
  echo ""
  local context_size=$(find "$session_dir" -name "context.md" -exec wc -c {} \; 2>/dev/null | awk '{print $1}')
  if [ -n "$context_size" ] && [ "$context_size" -gt 0 ]; then
    local agent_count=$(grep -c "START" "$session_dir/.agent_log" 2>/dev/null || echo "1")
    local content_passing_estimate=$((context_size * agent_count / 1024))
    local file_based_estimate=$((context_size / 1024 + agent_count))
    local savings=$((content_passing_estimate - file_based_estimate))
    local savings_pct=$((savings * 100 / content_passing_estimate))
    
    echo "- **Context Size**: ${context_size} bytes"
    echo "- **Agents**: $agent_count"
    echo "- **Estimated Tokens (content passing)**: ~${content_passing_estimate}K"
    echo "- **Estimated Tokens (file-based)**: ~${file_based_estimate}K"
    echo "- **Savings**: ~${savings}K tokens (**${savings_pct}%** reduction)"
  else
    echo "- Insufficient data for token estimation"
  fi
  echo ""
  
  echo "---"
  echo "**Analysis Complete**"
}

# Export function
export -f analyze_session

# If called directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
  analyze_session "$@"
fi

