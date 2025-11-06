#!/bin/bash
# Batch script to update command files - add inline session ID generation

set -e

COMMANDS_DIR="exito/commands"

update_command() {
    local file="$1"
    local command_name=$(basename "$file" .md)
    
    echo "Updating /$command_name..."
    
    # Check if already updated (contains SESSION_ID generation)
    if grep -q '!SESSION_ID=' "$file"; then
        echo "  ↳ Already updated, skipping"
        return 0
    fi
    
    # Find the first Task invocation
    local first_task_line=$(grep -n '<Task agent=' "$file" | head -1 | cut -d: -f1)
    
    if [ -z "$first_task_line" ]; then
        echo "  ↳ No Task invocations found, skipping"
        return 0
    fi
    
    # Calculate insertion point (before first Task)
    local insert_line=$((first_task_line - 2))
    
    # Create temp file with session setup
    local temp_file=$(mktemp)
    
    # Copy everything before insertion point
    head -n $insert_line "$file" > "$temp_file"
    
    # Add session setup
    cat >> "$temp_file" <<'SESSIONSETUP'

**Session Setup**

Generating unique session ID and creating session directory...

!SESSION_ID="COMMAND_NAME_$(date +%Y%m%d_%H%M%S)"
!mkdir -p ".claude/sessions/COMMAND_NAME/$SESSION_ID"
!echo "✓ Session: $SESSION_ID"

---

SESSIONSETUP
    
    # Replace COMMAND_NAME with actual command name
    sed -i.bak "s/COMMAND_NAME/${command_name}/g" "$temp_file"
    
    # Copy rest of file
    tail -n +$((insert_line + 1)) "$file" >> "$temp_file"
    
    # Replace all $CLAUDE_SESSION_ID references with $SESSION_ID
    sed -i.bak 's/\$CLAUDE_SESSION_ID/\$SESSION_ID/g' "$temp_file"
    
    # Update Task invocations to include session metadata
    # This is a simplified approach - may need manual refinement
    sed -i.bak 's/<Task agent="\([^"]*\)">/<Task agent="\1">\nSession: $SESSION_ID\nDirectory: .claude\/sessions\/'${command_name}'\/$SESSION_ID/g' "$temp_file"
    
    # Replace original file
    cp "$file" "$file.bak"
    mv "$temp_file" "$file"
    
    echo "  ✓ Updated $command_name"
}

# Get list of commands to update (excluding build.md)
commands=$(ls "$COMMANDS_DIR"/*.md | grep -v build.md)

for cmd_file in $commands; do
    update_command "$cmd_file"
done

echo ""
echo "✅ Batch command update complete!"
echo "Backup files created with .bak extension"
echo ""
echo "⚠️  IMPORTANT: Review updated commands - some Task invocations may need manual refinement"

