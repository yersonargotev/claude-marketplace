#!/bin/bash
# Batch script to update agent files - removes environment variable dependencies

set -e

AGENTS_DIR="exito/agents"

# Function to update agent input section
update_agent_input() {
    local file="$1"
    local agent_name=$(basename "$file" .md)
    
    echo "Updating $agent_name..."
    
    # Remove old session setup with shared-utils.sh
    sed -i.bak '/## Session Setup/,/^$/c\
## Session Extraction\
\
**Extract session metadata from input**:\
\
```bash\
# Extract primary input/path from $1\
PRIMARY_INPUT=$(echo "$1" | grep -oP "(?<=(Plan|Progress|Context|Input|Task|Session Directory): ).*" | head -1 || echo "$1")\
\
# Extract session ID\
SESSION_ID=$(echo "$1" | grep -oP "(?<=Session: ).*" | head -1 || echo "")\
\
# Extract session directory\
SESSION_DIR=$(echo "$1" | grep -oP "(?<=Directory: ).*" | head -1)\
\
# If no directory, derive from input file path or create temp\
if [ -z "$SESSION_DIR" ] && [ -f "$PRIMARY_INPUT" ]; then\
    SESSION_DIR=$(dirname "$PRIMARY_INPUT")\
elif [ -z "$SESSION_DIR" ]; then\
    SESSION_DIR=".claude/sessions/'$agent_name'_$(date +%Y%m%d_%H%M%S)"\
    mkdir -p "$SESSION_DIR"\
fi\
\
echo "✓ Session directory: $SESSION_DIR"\
```\
\
**Note**: Session metadata is explicit, not from environment variables.\
' "$file"
    
    # Replace environment variable references
    sed -i.bak 's/\$CLAUDE_SESSION_ID/$SESSION_ID/g' "$file"
    sed -i.bak 's/\${COMMAND_TYPE:-[^}]*}\/\$CLAUDE_SESSION_ID/\$SESSION_DIR/g' "$file"
    sed -i.bak 's/\.claude\/sessions\/${COMMAND_TYPE:-[^}]*}\/\$CLAUDE_SESSION_ID/\$SESSION_DIR/g' "$file"
    sed -i.bak 's/\.claude\/sessions\/{COMMAND_TYPE}\/\$CLAUDE_SESSION_ID/\$SESSION_DIR/g' "$file"
    
    echo "✓ Updated $agent_name"
}

# Update builder, validator, auditor
for agent in builder validator auditor; do
    if [ -f "$AGENTS_DIR/$agent.md" ]; then
        update_agent_input "$AGENTS_DIR/$agent.md"
    fi
done

echo "✅ Batch update complete!"
echo "Backup files created with .bak extension"

