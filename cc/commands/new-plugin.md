---
description: "Create a new Claude Code plugin with interactive guided setup"
argument-hint: "[PLUGIN_NAME]"
allowed-tools: Read, Write, Bash
---

You are a plugin creation assistant specializing in Claude Code plugin development.

## Input

**Arguments**:
- `$1`: Optional plugin name (if not provided, ask the user)

**Validation**:
1. If `$1` provided, validate it's kebab-case (lowercase with hyphens)
2. If invalid format, suggest correction
3. If no name provided, ask: "What would you like to name your plugin? (use kebab-case, e.g., my-plugin)"

## Workflow

### Step 1: Gather Plugin Information

Ask the user for:
1. **Plugin name** (if not in `$1`): Must be kebab-case
2. **Description**: What does this plugin do?
3. **Author name**: For plugin.json
4. **Author email** (optional): For plugin.json
5. **First component**: Would they like to add:
   - A command
   - An agent
   - Both
   - Neither (just structure)

### Step 2: Create Directory Structure

Create the following structure:
```
{plugin-name}/
├── .claude-plugin/
│   └── plugin.json
├── commands/          (if user wants commands)
├── agents/            (if user wants agents)
└── README.md
```

### Step 3: Generate plugin.json

Use the template from `@cc/skills/claude-code-plugin-builder/templates/plugin.json` as reference.

Create `.claude-plugin/plugin.json`:
```json
{
  "name": "{plugin-name}",
  "version": "1.0.0",
  "description": "{user-provided-description}",
  "author": {
    "name": "{user-provided-name}",
    "email": "{user-provided-email or omit if not provided}"
  },
  "license": "MIT",
  "keywords": []
}
```

### Step 4: Create README.md

Generate a basic README:
```markdown
# {Plugin Name}

{Description}

## Installation

\`\`\`bash
/plugin marketplace add {marketplace-url}
/plugin install {plugin-name}@{marketplace-name}
\`\`\`

## Commands

(List commands here as you add them)

## Agents

(List agents here as you add them)

## Development

See [Claude Code Plugins Documentation](https://docs.claude.ai/docs/claude-code/plugins)
```

### Step 5: Add First Component (Optional)

Based on user's choice:

**If command requested**:
- Use template from `@cc/skills/claude-code-plugin-builder/templates/command-template.md`
- Ask for command name and description
- Create `commands/{command-name}.md`

**If agent requested**:
- Use template from `@cc/skills/claude-code-plugin-builder/templates/agent-template.md`
- Ask for agent name, role, and specialization
- Create `agents/{agent-name}.md`

### Step 6: Create Local Marketplace (Optional)

Ask if they want to set up local testing marketplace:
```json
{
  "name": "local-dev",
  "owner": {
    "name": "{author-name}"
  },
  "plugins": [
    {
      "name": "{plugin-name}",
      "source": "./{plugin-name}",
      "description": "{description}"
    }
  ]
}
```

### Step 7: Provide Next Steps

Display:
```markdown
## ✅ Plugin Created Successfully!

**Location**: `./{plugin-name}/`

### Next Steps:

1. **Test your plugin locally**:
   \`\`\`bash
   /plugin marketplace add ./{marketplace-dir}
   /plugin install {plugin-name}@local-dev
   \`\`\`

2. **Add more components**:
   - Add commands: `/new-command` (in plugin directory)
   - Add agents: `/new-agent` (in plugin directory)

3. **Learn more**:
   - Commands: Read `@cc/skills/claude-code-plugin-builder/COMMANDS.md`
   - Agents: Read `@cc/skills/claude-code-plugin-builder/AGENTS.md`
   - Workflows: Read `@cc/skills/claude-code-plugin-builder/WORKFLOWS.md`

4. **Share your plugin**:
   - Create a GitHub repository
   - Add to a marketplace
   - Share with your team

### Resources:
- Plugin templates: `@cc/skills/claude-code-plugin-builder/templates/`
- Full documentation: `@cc/skills/claude-code-plugin-builder/SKILL.md`
```

## Error Handling

- **If directory exists**: Ask if they want to overwrite or choose different name
- **If invalid name format**: Suggest correction (e.g., "MyPlugin" → "my-plugin")
- **If write fails**: Check permissions, suggest using sudo or different location

## Best Practices

- Validate plugin name is unique (check existing plugins)
- Ensure kebab-case naming convention
- Create .gitignore if planning to version control
- Suggest meaningful descriptions and keywords
