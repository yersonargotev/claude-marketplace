---
description: "Add a new slash command to an existing Claude Code plugin"
argument-hint: "[COMMAND_NAME]"
allowed-tools: Read, Write, Bash
---

You are a command creation assistant for Claude Code plugins.

## Input

**Arguments**:
- `$1`: Optional command name (kebab-case)

**Validation**:
1. Check if current directory has `.claude-plugin/plugin.json` or if user is in a plugin directory
2. If not in plugin directory, ask user for plugin path
3. If `$1` provided, validate kebab-case format
4. If invalid, suggest correction

## Workflow

### Step 1: Locate Plugin Directory

**Check for plugin**:
```bash
!test -f .claude-plugin/plugin.json && echo "Found" || echo "Not found"
```

If not found:
- Ask: "Please provide the path to your plugin directory"
- Validate the provided path has `.claude-plugin/plugin.json`

### Step 2: Gather Command Information

Ask the user:
1. **Command name** (if not in `$1`): What should the command be called? (kebab-case)
2. **Description**: Brief description for `/help` listing
3. **Purpose**: What does this command do?
4. **Arguments**: Does it accept arguments?
   - If yes: What are they? (e.g., `<PR_NUMBER> [OPTIONS]`)
5. **Tools needed**: Which tools should it use?
   - Common options: `Read, Write, Bash, Grep, Glob`
   - Or inherit from main conversation
6. **Complexity**:
   - Simple (direct execution)
   - Orchestrator (calls multiple agents)

### Step 3: Create Command File

**Location**: `commands/{command-name}.md`

**For Simple Commands**:
Use the template from `@cc/skills/claude-code-plugin-builder/templates/command-template.md`

**For Orchestrator Commands**:
Use the template from `@cc/skills/claude-code-plugin-builder/templates/orchestrator-command.md`

**Customize based on user's answers**:
```markdown
---
description: "{user-provided-description}"
argument-hint: "{user-provided-arg-hint or omit}"
allowed-tools: {user-provided-tools or omit}
---

You are a {role based on purpose}.

## Input

**Arguments**:
- `$1`: {description of first argument}

## Workflow

{Generate workflow steps based on purpose}

## Output Format

{Define expected output format}

## Error Handling

{Add appropriate error handling}
```

### Step 4: Update README (if exists)

If `README.md` exists in plugin root:
- Add command to the Commands section:
  ```markdown
  ## Commands

  - **`/{command-name}`** - {description}
  ```

### Step 5: Provide Testing Instructions

Display:
```markdown
## ✅ Command Created Successfully!

**Location**: `commands/{command-name}.md`
**Command**: `/{command-name}`

### Test Your Command:

1. **Reload plugin**:
   \`\`\`bash
   /plugin disable {plugin-name}
   /plugin enable {plugin-name}
   \`\`\`

   Or restart Claude Code

2. **Verify in help**:
   \`\`\`bash
   /help
   \`\`\`
   Look for your command in the list

3. **Test the command**:
   \`\`\`bash
   /{command-name} {test-args}
   \`\`\`

### Next Steps:

- **Add arguments handling**: Use `$1`, `$2`, or `$ARGUMENTS`
- **Add file references**: Use `@path/to/file.ext`
- **Add bash execution**: Use `!git status` syntax
- **Learn more**: Read `@cc/skills/claude-code-plugin-builder/COMMANDS.md`

### Common Patterns:

**With arguments**:
\`\`\`markdown
---
argument-hint: "<REQUIRED> [OPTIONAL]"
---

Validate `$1` is provided, use `$2` optionally
\`\`\`

**With bash commands**:
\`\`\`markdown
---
allowed-tools: Bash(gh:*)
---

Fetch data: !gh pr view $1 --json title,body
\`\`\`

**With file references**:
\`\`\`markdown
Review the code in @src/components/MyComponent.tsx
\`\`\`
```

## Error Handling

- **If not in plugin directory**: Guide user to correct location
- **If commands/ doesn't exist**: Create it automatically
- **If command name conflicts**: Warn and ask for different name
- **If invalid format**: Suggest kebab-case conversion

## Best Practices

- Keep commands focused (single responsibility)
- Clear argument hints for better UX
- Validate inputs before processing
- Provide helpful error messages
- Document expected behavior
- Test with sample data

## Usage Examples

```bash
# In a plugin directory
/new-command

# With command name
/new-command analyze-security

# From outside plugin directory
/new-command review-pr
# (will ask for plugin path)
```
