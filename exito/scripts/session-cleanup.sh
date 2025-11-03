#!/bin/bash
# Session Cleanup Hook for Claude Code
# Updates session state when Claude Code session ends
# Critical Fix #3: Cleanup handler for interruptions
# Enhancement: Command-specific session directories

set -euo pipefail

# Determine session directory type based on COMMAND_TYPE env var
# Falls back to "tasks" for backward compatibility
SESSION_TYPE="${COMMAND_TYPE:-tasks}"

# Get current session ID if exists
if [ -n "${CLAUDE_SESSION_ID:-}" ]; then
    SESSION_DIR=".claude/sessions/$SESSION_TYPE/$CLAUDE_SESSION_ID"
    
    if [ -d "$SESSION_DIR" ]; then
        METADATA="$SESSION_DIR/session_metadata.json"
        
        if [ -f "$METADATA" ]; then
            # Determine final status based on artifacts created
            if [ -f "$SESSION_DIR/review.md" ]; then
                STATUS="completed"
                STATUS_MSG="✅ Workflow completed successfully"
            elif [ -f "$SESSION_DIR/progress.md" ]; then
                STATUS="interrupted"
                STATUS_MSG="⚠️  Workflow interrupted during implementation"
            elif [ -f "$SESSION_DIR/plan.md" ]; then
                STATUS="interrupted"
                STATUS_MSG="⚠️  Workflow interrupted during planning phase"
            elif [ -f "$SESSION_DIR/context.md" ]; then
                STATUS="interrupted"
                STATUS_MSG="⚠️  Workflow interrupted during research phase"
            else
                STATUS="failed"
                STATUS_MSG="❌ Workflow failed or was cancelled early"
            fi
            
            # Update metadata with final status
            # Use jq if available, otherwise create new file
            if command -v jq &> /dev/null; then
                jq --arg status "$STATUS" \
                   --arg ended_at "$(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S%z)" \
                   '.status = $status | .ended_at = $ended_at' \
                   "$METADATA" > "${METADATA}.tmp" && mv "${METADATA}.tmp" "$METADATA"
            else
                # Fallback: create simple updated metadata
                cat > "${METADATA}.tmp" <<EOF
{
  "session_id": "$CLAUDE_SESSION_ID",
  "status": "$STATUS",
  "ended_at": "$(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S%z)"
}
EOF
                mv "${METADATA}.tmp" "$METADATA"
            fi
            
            # Generate session summary
            cat > "$SESSION_DIR/session_summary.md" <<EOF
# Session Summary

**Session ID**: \`$CLAUDE_SESSION_ID\`  
**Status**: $STATUS  
**Final Message**: $STATUS_MSG

## Session Artifacts

$(if [ "$(ls -1 "$SESSION_DIR" | wc -l)" -gt 0 ]; then
    echo "Artifacts created during this session:"
    echo ""
    ls -1 "$SESSION_DIR" | grep -v "^session_" | while read -r file; do
        echo "- \`$file\`"
    done
else
    echo "No artifacts were created."
fi)

## Session Timeline

$(if [ -f "$METADATA" ] && command -v jq &> /dev/null; then
    CREATED=$(jq -r '.created_at // "Unknown"' "$METADATA")
    ENDED=$(jq -r '.ended_at // "Unknown"' "$METADATA")
    echo "- **Started**: $CREATED"
    echo "- **Ended**: $ENDED"
fi)

## What Happened

$(case "$STATUS" in
    "completed")
        echo "✅ The workflow completed all phases successfully:"
        echo "1. Research phase - context gathered"
        echo "2. Planning phase - solution designed"
        echo "3. Implementation phase - code written"
        echo "4. Testing phase - validation performed"
        echo "5. Review phase - quality check completed"
        ;;
    "interrupted")
        echo "⚠️  The workflow was interrupted. To resume:"
        if [ -f "$SESSION_DIR/progress.md" ]; then
            echo "1. Review \`progress.md\` to see what was completed"
            echo "2. Continue implementation from the last checkpoint"
            echo "3. Complete remaining steps from the plan"
        elif [ -f "$SESSION_DIR/plan.md" ]; then
            echo "1. Review \`plan.md\` - the plan was created"
            echo "2. If approved, start implementation"
            echo "3. Or provide feedback to refine the plan"
        elif [ -f "$SESSION_DIR/context.md" ]; then
            echo "1. Review \`context.md\` - research was completed"
            echo "2. Continue to planning phase"
            echo "3. Or gather additional context if needed"
        fi
        ;;
    "failed")
        echo "❌ The workflow encountered issues or was cancelled early:"
        echo "1. Check logs for error messages"
        echo "2. Verify prerequisites are met"
        echo "3. Retry with a modified approach if needed"
        ;;
esac)

## Next Steps

$(case "$STATUS" in
    "completed")
        echo "- Review the implementation in \`progress.md\`"
        echo "- Check test results in \`test_report.md\`"
        echo "- Read final review in \`review.md\`"
        echo "- Merge changes if approved"
        ;;
    "interrupted")
        echo "- Resume the workflow where it left off"
        echo "- Or start a new session if needed"
        ;;
    "failed")
        echo "- Investigate the failure cause"
        echo "- Start a new session with refined requirements"
        ;;
esac)

---

**Session Directory**: \`.claude/sessions/$SESSION_TYPE/$CLAUDE_SESSION_ID/\`
EOF
            
            # Log to stderr
            echo "" >&2
            echo "═══════════════════════════════════════" >&2
            echo "$STATUS_MSG" >&2
            echo "Session: $CLAUDE_SESSION_ID" >&2
            echo "Summary: $SESSION_DIR/session_summary.md" >&2
            echo "═══════════════════════════════════════" >&2
        fi
    fi
fi

