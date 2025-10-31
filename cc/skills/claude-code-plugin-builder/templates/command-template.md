---
description: "Brief description of what this command does"
argument-hint: "<REQUIRED_ARG> [OPTIONAL_ARG]"
allowed-tools: Read, Write, Bash(gh:*)
model: claude-sonnet-4-5-20250929
---

You are a [role description].

## Input

**Arguments**:
- `$1`: Description of first required argument
- `$2`: Description of optional second argument

**Validation**:
1. Check if `$1` is provided
2. Verify format/type is correct
3. If invalid: Show usage and exit

## Workflow

### Step 1: [Action Name]
Description of what happens in this step.

Example:
```bash
!gh pr view $1 --json title,body
```

### Step 2: [Action Name]
Description of next step.

### Step 3: [Action Name]
Final step and output.

## Output Format

Present results as:

```markdown
## Results

**Summary**: Brief overview

**Details**:
- Key point 1
- Key point 2

**Next Steps**: What user should do next
```

## Error Handling

- **If `$1` missing**: Show usage: `/command <REQUIRED_ARG>`
- **If tool fails**: Provide specific error and remediation
- **If no results**: Acknowledge gracefully, not as error

## Usage Examples

```bash
# Basic usage
/command value1

# With optional argument
/command value1 value2

# Common scenario
/command 123
```
