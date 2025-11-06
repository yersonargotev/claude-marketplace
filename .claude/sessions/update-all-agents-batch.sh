#!/bin/bash
# Batch script to update ALL agent files

set -e

AGENTS_DIR="exito/agents"

# Agents already updated
SKIP_AGENTS="investigator architect builder validator auditor"

echo "Updating all agents except: $SKIP_AGENTS"
echo ""

for agent_file in "$AGENTS_DIR"/*.md; do
    agent_name=$(basename "$agent_file" .md)
    
    # Skip already updated agents
    if echo "$SKIP_AGENTS" | grep -q "$agent_name"; then
        echo "↳ Skipping $agent_name (already updated)"
        continue
    fi
    
    # Skip if already updated (no env var references)
    if ! grep -q '\$CLAUDE_SESSION_ID\|\${COMMAND_TYPE' "$agent_file"; then
        echo "↳ Skipping $agent_name (no env var references)"
        continue
    fi
    
    echo "Updating $agent_name..."
    
    # Create backup
    cp "$agent_file" "$agent_file.bak2"
    
    # Replace environment variable references
    sed -i.tmp 's/\$CLAUDE_SESSION_ID/$SESSION_ID/g' "$agent_file"
    sed -i.tmp 's/\${COMMAND_TYPE:-tasks}\/\$CLAUDE_SESSION_ID/$SESSION_DIR/g' "$agent_file"
    sed -i.tmp 's/\${COMMAND_TYPE:-tasks}\/\$SESSION_ID/$SESSION_DIR/g' "$agent_file"
    sed -i.tmp 's/\${COMMAND_TYPE}\/\$SESSION_ID/$SESSION_DIR/g' "$agent_file"
    sed -i.tmp 's/\.claude\/sessions\/{COMMAND_TYPE}\/\$SESSION_ID/$SESSION_DIR/g' "$agent_file"
    
    # Remove session setup with shared-utils if present
    if grep -q 'source exito/scripts/shared-utils.sh' "$agent_file"; then
        # Remove the entire session setup section
        sed -i.tmp '/## Session Setup/,/\*\*Note\*\*.*validation\./d' "$agent_file"
        
        # Add new session extraction section after Input section
        sed -i.tmp '/## Input/a\
\
## Session Extraction\
\
**Extract session metadata from input** (if provided by command):\
\
```bash\
# Extract session info from $1\
SESSION_ID=$(echo "$1" | grep -oP "(?<=Session: ).*" | head -1 || echo "")\
SESSION_DIR=$(echo "$1" | grep -oP "(?<=Directory: ).*" | head -1)\
\
# If no directory, create temporary\
if [ -z "$SESSION_DIR" ]; then\
    SESSION_DIR=".claude/sessions/'$agent_name'_$(date +%Y%m%d_%H%M%S)"\
    mkdir -p "$SESSION_DIR"\
fi\
\
echo "✓ Session directory: $SESSION_DIR"\
```\
\
**Note**: Session metadata is explicit, not from environment variables.\
' "$agent_file"
    fi
    
    # Clean up tmp files
    rm -f "$agent_file.tmp"
    
    echo "  ✓ Updated $agent_name"
done

echo ""
echo "✅ All agents updated!"
echo "Backup files created with .bak2 extension"

